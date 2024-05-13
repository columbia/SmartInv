1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/Manager.sol';
10 import '../interfaces/managers/IStrategyManager.sol';
11 
12 contract StrategyMock is IStrategyManager, Manager {
13   IERC20 public override want;
14   uint256 public depositCalled;
15   uint256 public withdrawCalled;
16   uint256 public withdrawAllCalled;
17   bool public fail;
18 
19   constructor(IERC20 _token) {
20     want = _token;
21   }
22 
23   function setFail() external {
24     fail = true;
25   }
26 
27   function withdrawAll() external override returns (uint256 b) {
28     b = balanceOf();
29     if (b != 0) want.transfer(msg.sender, b);
30     withdrawAllCalled++;
31     require(!fail, 'FAIL');
32   }
33 
34   function withdraw(uint256 _amount) external override {
35     want.transfer(msg.sender, _amount);
36     withdrawCalled++;
37   }
38 
39   function deposit() external override {
40     depositCalled++;
41   }
42 
43   function balanceOf() public view override returns (uint256) {
44     return want.balanceOf(address(this));
45   }
46 }
