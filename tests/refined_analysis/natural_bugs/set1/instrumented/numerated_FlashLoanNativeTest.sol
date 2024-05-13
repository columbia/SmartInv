1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../Interfaces.sol";
6 import "../modules/DToken.sol";
7 import "../modules/Markets.sol";
8 import "../modules/Exec.sol";
9 import "../modules/DToken.sol";
10 
11 
12 contract FlashLoanNativeTest is IDeferredLiquidityCheck {
13     struct CallbackData {
14         address eulerAddr;
15         address marketsAddr;
16         address execAddr;
17         address underlying;
18         uint amount;
19         bool payItBack;
20     }
21 
22     function testFlashLoan(CallbackData calldata data) external {
23         Exec(data.execAddr).deferLiquidityCheck(address(this), abi.encode(data));
24     }
25 
26     function onDeferredLiquidityCheck(bytes memory encodedData) external override {
27         CallbackData memory data = abi.decode(encodedData, (CallbackData));
28 
29         address dTokenAddr = Markets(data.marketsAddr).underlyingToDToken(data.underlying);
30         DToken dToken = DToken(dTokenAddr);
31 
32         dToken.borrow(0, data.amount);
33 
34         require(IERC20(data.underlying).balanceOf(address(this)) == data.amount, "didn't receive underlying");
35         require(dToken.balanceOf(address(this)) == data.amount, "didn't receive dTokens");
36 
37         if (data.payItBack) {
38             IERC20(data.underlying).approve(data.eulerAddr, type(uint).max);
39             dToken.repay(0, data.amount);
40 
41             require(IERC20(data.underlying).balanceOf(address(this)) == 0, "didn't repay underlying");
42             require(dToken.balanceOf(address(this)) == 0, "didn't burn dTokens");
43         }
44     }
45 
46     function testFlashLoan2(address underlying, address dTokenAddr, address eulerAddr, uint amount, uint repayAmount) external {
47         DToken(dTokenAddr).flashLoan(amount, abi.encode(underlying, eulerAddr, repayAmount));
48     }
49 
50     function onFlashLoan(bytes calldata data) external {
51         (address underlying, address eulerAddr, uint repayAmount) = abi.decode(data, (address, address, uint));
52         IERC20(underlying).transfer(eulerAddr, repayAmount);
53     }
54 }
