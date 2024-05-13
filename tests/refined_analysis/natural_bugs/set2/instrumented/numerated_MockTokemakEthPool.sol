1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockERC20.sol";
5 import "./MockWeth.sol";
6 
7 contract MockTokemakEthPool is MockERC20 {
8     MockWeth public weth;
9 
10     mapping(address => uint256) public requestedWithdrawal;
11 
12     constructor(address _weth) {
13         weth = MockWeth(_weth);
14     }
15 
16     receive() external payable {}
17 
18     function underlyer() external view returns (address) {
19         return address(weth);
20     }
21 
22     function requestWithdrawal(uint256 amount) external {
23         requestedWithdrawal[msg.sender] = amount;
24     }
25 
26     function deposit(uint256 amount) external payable {
27         mint(msg.sender, amount);
28         weth.deposit{value: msg.value}();
29     }
30 
31     function withdraw(
32         uint256 requestedAmount,
33         bool /* asEth*/
34     ) external {
35         require(requestedWithdrawal[msg.sender] >= requestedAmount, "WITHDRAW_INSUFFICIENT_BALANCE");
36         require(weth.balanceOf(address(this)) >= requestedAmount, "INSUFFICIENT_POOL_BALANCE");
37         requestedWithdrawal[msg.sender] -= requestedAmount;
38         _burn(msg.sender, requestedAmount);
39         weth.withdraw(requestedAmount);
40         payable(msg.sender).transfer(requestedAmount);
41     }
42 }
