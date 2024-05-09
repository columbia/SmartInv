1 pragma solidity ^0.4.25;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6     function transferFrom(address from, address to, uint256 value) external returns (bool);
7 }
8 
9 
10 contract Disperse {
11     function disperseEther(address[] recipients, uint256[] values) external payable {
12         for (uint256 i = 0; i < recipients.length; i++)
13             recipients[i].transfer(values[i]);
14         uint256 balance = address(this).balance;
15         if (balance > 0)
16             msg.sender.transfer(balance);
17     }
18 
19     function disperseToken(IERC20 token, address[] recipients, uint256[] values) external {
20         uint256 total = 0;
21         for (uint256 i = 0; i < recipients.length; i++)
22             total += values[i];
23         require(token.transferFrom(msg.sender, address(this), total));
24         for (i = 0; i < recipients.length; i++)
25             require(token.transfer(recipients[i], values[i]));
26     }
27 
28     function disperseTokenSimple(IERC20 token, address[] recipients, uint256[] values) external {
29         for (uint256 i = 0; i < recipients.length; i++)
30             require(token.transferFrom(msg.sender, recipients[i], values[i]));
31     }
32 }