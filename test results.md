```bash
Ran 2 tests for test/Counter.t.sol:CounterTest  
[PASS] test() (gas: 102631)  
Logs:  
 first run  
 second run  
 Third run  
 For the 4th example lets now use the function addFundsFromDepositORYIELD to simulate the deposits being made or the yield increasing  
 fourth run  
 END FOR afterRoundEndTEST proof  
  
Traces:  
 [4534091] CounterTest::setUp()  
   ├─ [632219] → new ERC20Mock@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f  
   │   ├─ emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, value: 100000 [1e5])  
   │   └─ ← [Return] 2590 bytes of code  
   ├─ [325311] → new ConfigurationManager@0x2e234DAe75C793f67A35089C9d99245E1C58470b  
   │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496])  
   │   └─ ← [Return] 1506 bytes of code  
   ├─ [3428580] → new STETHVault@0xF62849F9A0B5Bf2913b396098F7c7019b51A820a  
   │   ├─ [1244] ERC20Mock::symbol() [staticcall]  
   │   │   └─ ← [Return] "ASS"  
   │   ├─ [1244] ERC20Mock::symbol() [staticcall]  
   │   │   └─ ← [Return] "ASS"  
   │   ├─ emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, value: 100000 [1e5])  
   │   ├─ [266] ERC20Mock::decimals()  
   │   │   └─ ← [Return] 18  
   │   ├─ emit RoundStarted(roundId: 0, amountAddedToStrategy: 0)  
   │   ├─ [266] ERC20Mock::decimals() [staticcall]  
   │   │   └─ ← [Return] 18  
   │   ├─ [266] ERC20Mock::decimals() [staticcall]  
   │   │   └─ ← [Return] 18  
   │   └─ ← [Return] 16061 bytes of code  
   └─ ← [Stop]    
  
 [107431] CounterTest::test()  
   ├─ [29904] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 1000)  
   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 1000)  
   │   └─ ← [Return] true  
   ├─ [25104] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], 10000 [1e4])  
   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], value: 10000 [1e4])  
   │   └─ ← [Return] true  
   ├─ [13858] STETHVault::afterRoundEndTEST()  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 89000 [8.9e4]  
   │   ├─ [3204] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 89000 [8.9e4])  
   │   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 89000 [8.9e4])  
   │   │   └─ ← [Return] true  
   │   ├─ emit normalTransfer()  
   │   └─ ← [Stop]    
   ├─ [0] console::log("first run") [staticcall]  
   │   └─ ← [Stop]    
   ├─ [3413] STETHVault::fakeWithdrawTEST(20)  
   │   └─ ← [Stop]    
   ├─ [5385] STETHVault::afterRoundEndTEST()  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 0  
   │   ├─ emit DoSTransfer()  
   │   └─ ← [Stop]    
   ├─ [0] console::log("second run") [staticcall]  
   │   └─ ← [Stop]    
   ├─ [3053] STETHVault::afterRoundEndTEST()  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 0  
   │   ├─ emit normalTransfer()  
   │   └─ ← [Stop]    
   ├─ [0] console::log("Third run") [staticcall]  
   │   └─ ← [Stop]    
   ├─ [0] console::log("For the 4th example lets now use the function addFundsFromDepositORYIELD to simulate the deposits being made or the yield increasing") [staticcall]  
   │   └─ ← [Stop]    
   ├─ [511] STETHVault::addFundsFromDepositsORYIELD()  
   │   └─ ← [Stop]    
   ├─ [613] STETHVault::fakeWithdrawTEST(301)  
   │   └─ ← [Stop]    
   ├─ [2585] STETHVault::afterRoundEndTEST()  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 0  
   │   ├─ emit DoSTransfer()  
   │   └─ ← [Stop]    
   ├─ [0] console::log("fourth run") [staticcall]  
   │   └─ ← [Stop]    
   ├─ [0] console::log("END FOR afterRoundEndTEST proof") [staticcall]  
   │   └─ ← [Stop]    
   └─ ← [Stop]    
  
[PASS] test2() (gas: 94059)  
Logs:  
 investor has no funds at all  
  
Traces:  
 [4534091] CounterTest::setUp()  
   ├─ [632219] → new ERC20Mock@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f  
   │   ├─ emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, value: 100000 [1e5])  
   │   └─ ← [Return] 2590 bytes of code  
   ├─ [325311] → new ConfigurationManager@0x2e234DAe75C793f67A35089C9d99245E1C58470b  
   │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496])  
   │   └─ ← [Return] 1506 bytes of code  
   ├─ [3428580] → new STETHVault@0xF62849F9A0B5Bf2913b396098F7c7019b51A820a  
   │   ├─ [1244] ERC20Mock::symbol() [staticcall]  
   │   │   └─ ← [Return] "ASS"  
   │   ├─ [1244] ERC20Mock::symbol() [staticcall]  
   │   │   └─ ← [Return] "ASS"  
   │   ├─ emit Transfer(from: 0x0000000000000000000000000000000000000000, to: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, value: 100000 [1e5])  
   │   ├─ [266] ERC20Mock::decimals()  
   │   │   └─ ← [Return] 18  
   │   ├─ emit RoundStarted(roundId: 0, amountAddedToStrategy: 0)  
   │   ├─ [266] ERC20Mock::decimals() [staticcall]  
   │   │   └─ ← [Return] 18  
   │   ├─ [266] ERC20Mock::decimals() [staticcall]  
   │   │   └─ ← [Return] 18  
   │   └─ ← [Return] 16061 bytes of code  
   └─ ← [Stop]    
  
 [98859] CounterTest::test2()  
   ├─ [29904] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 1000)  
   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 1000)  
   │   └─ ← [Return] true  
   ├─ [25104] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], 10000 [1e4])  
   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: CounterTest: [0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496], value: 10000 [1e4])  
   │   └─ ← [Return] true  
   ├─ [1449] STETHVault::getBalance(0x093d49D617a10F26915553255Ec3FEE532d2C12F)  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 89000 [8.9e4]  
   │   └─ ← [Return] 89000 [8.9e4]  
   ├─ [0] VM::assertEq(89000 [8.9e4], 89000 [8.9e4]) [staticcall]  
   │   └─ ← [Return]    
   ├─ [5413] STETHVault::fakeWithdrawTEST(69)  
   │   └─ ← [Stop]    
   ├─ [14201] STETHVault::afterRoundEndTEST()  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 89000 [8.9e4]  
   │   ├─ [3204] ERC20Mock::transferFrom(0x093d49D617a10F26915553255Ec3FEE532d2C12F, STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 89000 [8.9e4])  
   │   │   ├─ emit Transfer(from: 0x093d49D617a10F26915553255Ec3FEE532d2C12F, to: STETHVault: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 89000 [8.9e4])  
   │   │   └─ ← [Return] true  
   │   ├─ emit DoSTransfer()  
   │   └─ ← [Stop]    
   ├─ [1449] STETHVault::getBalance(0x093d49D617a10F26915553255Ec3FEE532d2C12F)  
   │   ├─ [585] ERC20Mock::balanceOf(0x093d49D617a10F26915553255Ec3FEE532d2C12F) [staticcall]  
   │   │   └─ ← [Return] 0  
   │   └─ ← [Return] 0  
   ├─ [0] VM::assertEq(0, 0) [staticcall]  
   │   └─ ← [Return]    
   ├─ [0] console::log("investor has no funds at all") [staticcall]  
   │   └─ ← [Stop]    
   └─ ← [Stop]    
  
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 26.62ms (4.36ms CPU time)  
  
Ran 1 test suite in 6.32s (26.62ms CPU time): 2 tests passed, 0 failed, 0 skipped (2 total tests)
```