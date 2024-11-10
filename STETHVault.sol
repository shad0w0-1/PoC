// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.17;

import { IERC4626 } from "./lib/IERC4626.sol";
import { ERC4626 } from "./lib/ERC4626.sol";
import { IERC20Metadata } from "./lib/IERC20Metadata.sol";
import { SafeERC20 } from "./lib/SafeERC20.sol";
import { Math } from "./lib/Math.sol";
import { BaseVault } from "./BaseVault.sol";
import { IConfigurationManager } from "./lib/IConfigurationManager.sol";
import { IVault } from "./lib/IVault.sol";

/**
 * @title STETHVault
 * @notice A Vault that use variable weekly yields to buy strangles
 * @author Pods Finance
 */
contract STETHVault is BaseVault {
    using SafeERC20 for IERC20Metadata;
    using Math for uint256;
    /**
     * @dev INVESTOR_RATIO is the proportion that the weekly yield will be split
     * The precision of this number is set by the variable DENOMINATOR. 5000 is equivalent to 50%
     */
    uint256 public constant INVESTOR_RATIO = 5000;
    address public immutable investor; // investor is a multisig wallet
    uint8 public immutable sharePriceDecimals;
    uint256 public lastRoundAssets;
    Fractional public lastSharePrice;

    event StartRoundData(uint256 indexed roundId, uint256 lastRoundAssets, uint256 sharePrice);
    event EndRoundData(
        uint256 indexed roundId,
        uint256 roundAccruedInterest,
        uint256 investmentYield,
        uint256 idleAssets
    );
    event SharePrice(uint256 indexed roundId, uint256 startSharePrice, uint256 endSharePrice);

    error STETHVault__PermitNotAvailable();

    constructor(
        IConfigurationManager _configuration,
        IERC20Metadata _asset,
        address _investor
    )
        BaseVault(
            _configuration,
            _asset,
            string(abi.encodePacked(_asset.symbol(), " Volatility Vault")),
            string(abi.encodePacked(_asset.symbol(), "vv"))
        )
    {
        investor = _investor;
        sharePriceDecimals = _asset.decimals();
    }

    /**
     * @inheritdoc IVault
     */
    function assetsOf(address owner) external view virtual returns (uint256) {
        uint256 shares = balanceOf(owner);
        return convertToAssets(shares) + idleAssetsOf(owner);
    }

    /**
     * @notice Return the stETH price per share
     * @dev Each share is considered to be 10^(assets.decimals())
     * The share price represents the amount of stETH needed to mint one vault share. When the number of vault
     * shares that has been minted thus far is zero, the share price should simply be the ratio of the
     * underlying asset's decimals to the vault's decimals.
     */
    function sharePrice() external view returns (uint256) {
        return convertToAssets(10**sharePriceDecimals);
    }

    /**
     * @inheritdoc IVault
     */
    function depositWithPermit(
        uint256 assets,
        address receiver,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256) {
        revert STETHVault__PermitNotAvailable();
    }

    /**
     * @inheritdoc IVault
     */
    function mintWithPermit(
        uint256 shares,
        address receiver,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256) {
        revert STETHVault__PermitNotAvailable();
    }

    /**
     * @inheritdoc BaseVault
     */
    function _afterRoundStart() internal override {
        uint256 supply = totalSupply(); // totalSupply of ERC20 token

        lastRoundAssets = totalAssets(); // totalAssets of asset - idletokens
        lastSharePrice = Fractional({ // struct
            numerator: supply == 0 ? MIN_INITIAL_ASSETS : lastRoundAssets,
            denominator: supply == 0 ? 10**sharePriceDecimals : supply
        });

        uint256 currentSharePrice = lastSharePrice.denominator == 0
            ? convertToAssets(10**sharePriceDecimals)
            : lastSharePrice.numerator.mulDiv(10**sharePriceDecimals, lastSharePrice.denominator, Math.Rounding.Down);
        emit StartRoundData(vaultState.currentRoundId, lastRoundAssets, currentSharePrice);
    }

    /**
     * @inheritdoc BaseVault
     */
    function _afterRoundEnd() internal override {
        uint256 roundAccruedInterest = 0;
        uint256 investmentYield = IERC20Metadata(asset()).balanceOf(investor);
        uint256 supply = totalSupply(); // totalSupply of ERC20
        // @audit-MED if I withdraw just to bring the totalAssets < lastRoundAssets it will trigger DoS
        if (supply != 0) {
            if (totalAssets() >= lastRoundAssets) {
                roundAccruedInterest = totalAssets() - lastRoundAssets;
                uint256 investmentAmount = (roundAccruedInterest * INVESTOR_RATIO) / DENOMINATOR;

                // Pulls the yields from investor
                if (investmentYield > 0) {
                    IERC20Metadata(asset()).safeTransferFrom(investor, address(this), investmentYield);
                }

                if (investmentAmount > 0) {
                    IERC20Metadata(asset()).safeTransfer(investor, investmentAmount);
                }
            } else {
                // Pulls the yields from investor
                if (investmentYield > 0) {
                    IERC20Metadata(asset()).safeTransferFrom(investor, address(this), investmentYield);
                }
            }
        }
        // End Share price needs to be calculated after the transfers between investor and vault
        uint256 endSharePrice = convertToAssets(10**sharePriceDecimals);

        uint256 startSharePrice = lastSharePrice.denominator == 0
            ? convertToAssets(10**sharePriceDecimals)
            : lastSharePrice.numerator.mulDiv(10**sharePriceDecimals, lastSharePrice.denominator, Math.Rounding.Down);

        emit EndRoundData(vaultState.currentRoundId, roundAccruedInterest, investmentYield, totalIdleAssets());
        emit SharePrice(vaultState.currentRoundId, startSharePrice, endSharePrice);
    }

    /**
     * @inheritdoc BaseVault
     */
     /*
       1. function deposit is being called in BaseVault
       2. function deposit is being called in ERC4626
       3. function _deposit in STETHVault is called
     */
    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal virtual override {
        assets = _stETHTransferFrom(caller, address(this), assets);
        _addToDepositQueue(receiver, assets);

        shares = previewDeposit(assets);
        _spendCap(shares); // Increases spend capacity
        emit Deposit(caller, receiver, assets, shares);
    }

    /**
     * @inheritdoc BaseVault
     */
    function _withdrawWithFees(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal virtual override returns (uint256 receiverAssets, uint256 receiverShares) {
        if (caller != owner) {
            _spendAllowance(owner, caller, shares);
        }

        _burn(owner, shares);
        _restoreCap(shares); // subtracts shares from available capacity

        lastRoundAssets -= shares.mulDiv(lastSharePrice.numerator, lastSharePrice.denominator, Math.Rounding.Down); // LRA -= shares * 

        uint256 fee = _getFee(assets); // if assets is 1000 then it will return 1
        receiverAssets = assets - fee;
        receiverShares = shares;

        emit Withdraw(caller, receiver, owner, receiverAssets, shares);
        receiverAssets = _stETHTransferFrom(address(this), receiver, receiverAssets);

        if (fee > 0) {
            emit FeeCollected(fee);
            _stETHTransferFrom(address(this), controller(), fee);
        }
    }

    /**
     * @dev Moves `amount` of stETH from `from` to `to` using the
     * allowance mechanism.
     *
     * Note that due to division rounding, not always is not possible to move
     * the entire amount, hence transfer is attempted, returning the
     * `effectiveAmount` transferred.
     *
     * For more information refer to: https://docs.lido.fi/guides/steth-integration-guide#1-wei-corner-case
     */
    function _stETHTransferFrom(
        address from,
        address to,
        uint256 amount
    ) internal returns (uint256) {
        uint256 balanceBefore = IERC20Metadata(asset()).balanceOf(to);
        if (from == address(this)) {
            IERC20Metadata(asset()).safeTransfer(to, amount);
        } else {
            IERC20Metadata(asset()).safeTransferFrom(from, to, amount);
        }
        return IERC20Metadata(asset()).balanceOf(to) - balanceBefore;
    }
    /// ---------------------------------------------------------------------------------------------------
    //test block 
    // note that all functions/variables marked with func/TEST at the end are supposed to represents
    // the ones who dont totalAssetsTEST = totalAssets
    uint256 totalAssetsTEST = 1000; // initialize variable to 1k 
    uint256 totalSupplyTEST = 1000;  // initialize variable to 1k 
    uint256 lastRoundAssetsTEST = 1000;  // initialize variable to 1k 
    event normalTransfer(); // This will be used to check which code block the excution went to (if/else)
    event DoSTransfer();   // This will be used to check which code block the excution went to (if/else)
    function afterRoundEndTEST() external {
        uint256 roundAccruedInterest = 0;
        uint256 investmentYield = IERC20Metadata(asset()).balanceOf(investor);
        uint256 supply = totalSupplyTEST; // totalSupply was changed to totalSupplyTEST for testing
        // @audit-MED if I withdraw just to bring the totalAssets < lastRoundAssets it will trigger DoS
        if (supply != 0) {
            if (functotalAssetsTEST() >= lastRoundAssetsTEST) { // totalAssets was changed to functotalAssetsTEST 
                roundAccruedInterest = functotalAssetsTEST() - lastRoundAssetsTEST; 
                // totalAssets() was changed to functotalAssetsTEST() 
                uint256 investmentAmount = (roundAccruedInterest * INVESTOR_RATIO) / DENOMINATOR;

                // Pulls the yields from investor
                if (investmentYield > 0) {
                    IERC20Metadata(asset()).safeTransferFrom(investor, address(this), investmentYield);
                }

                if (investmentAmount > 0) {
                    IERC20Metadata(asset()).safeTransfer(investor, investmentAmount);
                }
                lastRoundAssetsTEST = totalAssetsTEST;
                emit normalTransfer(); // added to see which direction the code will take durinmg execution 
            } else {
                // Pulls the yields from investor
                if (investmentYield > 0) {
                    IERC20Metadata(asset()).safeTransferFrom(investor, address(this), investmentYield);
                }
                lastRoundAssetsTEST = totalAssetsTEST;
                emit DoSTransfer();  // added to see which direction the code will take durinmg execution
            }
        }
    }
    function functotalAssetsTEST() public returns (uint256)
    { // returns the totalAssetsTEST variable which is basically totalAssets
      return totalAssetsTEST;
    }
    
    function fakeWithdrawTEST(uint256 amount) public
    { // A subtraction operation to mimic a withdraw
      totalAssetsTEST -= amount;
        
    }
    function addFundsFromDepositsORYIELD() public
    { // an operation that adds funds and mimics a user adding funds or yield
      totalAssetsTEST += 300;
    }
    function getBalance(address to) public returns(uint256)
    { // simple getter function that returns the balance
      return IERC20Metadata(asset()).balanceOf(to);
    }








    // ----------------------------------------------------------------------------------------------------
}
