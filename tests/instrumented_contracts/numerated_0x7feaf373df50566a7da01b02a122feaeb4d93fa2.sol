1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4     function balanceOf(address who) external view returns(uint256);
5     function transfer(address to, uint256 amount) external returns(bool);
6 }
7 
8 contract AntiFrontRunning {
9     function buy(IERC20 token, uint256 minAmount) public payable {
10         require(token.call.value(msg.value)(), "Buy failed");
11 
12         uint256 balance = token.balanceOf(this);
13         require(balance >= minAmount, "Price too bad");
14         token.transfer(msg.sender, balance);
15     }
16 }