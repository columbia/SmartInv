1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockERC20.sol";
5 
6 /// @title Aave PCV Deposit
7 /// @author Fei Protocol
8 contract MockLendingPool {
9     MockERC20 public aToken;
10 
11     constructor() {
12         aToken = new MockERC20();
13     }
14 
15     function deposit(
16         address asset,
17         uint256 amount,
18         address onBehalfOf,
19         uint16 /* referralCode*/
20     ) external {
21         IERC20(asset).transferFrom(msg.sender, address(this), amount);
22         aToken.mint(onBehalfOf, amount);
23     }
24 
25     function withdraw(
26         address asset,
27         uint256 amount,
28         address to
29     ) external {
30         aToken.approveOverride(msg.sender, address(this), amount);
31         aToken.burnFrom(msg.sender, amount);
32 
33         IERC20(asset).transfer(to, amount);
34     }
35 }
