1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockERC20.sol";
5 
6 contract MockTokemakERC20Pool is MockERC20 {
7     MockERC20 public token;
8 
9     mapping(address => uint256) public requestedWithdrawal;
10 
11     constructor(address _token) {
12         token = MockERC20(_token);
13     }
14 
15     function underlyer() external view returns (address) {
16         return address(token);
17     }
18 
19     function requestWithdrawal(uint256 amount) external {
20         requestedWithdrawal[msg.sender] = amount;
21     }
22 
23     function deposit(uint256 amount) external {
24         mint(msg.sender, amount);
25         token.transferFrom(msg.sender, address(this), amount);
26     }
27 
28     function withdraw(uint256 requestedAmount) external {
29         require(requestedWithdrawal[msg.sender] >= requestedAmount, "WITHDRAW_INSUFFICIENT_BALANCE");
30         require(token.balanceOf(address(this)) >= requestedAmount, "INSUFFICIENT_POOL_BALANCE");
31         requestedWithdrawal[msg.sender] -= requestedAmount;
32         _burn(msg.sender, requestedAmount);
33         token.transfer(msg.sender, requestedAmount);
34     }
35 }
