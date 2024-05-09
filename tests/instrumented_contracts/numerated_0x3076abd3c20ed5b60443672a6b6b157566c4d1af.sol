1 pragma solidity ^0.5.2;
2 
3 contract splitPayKleee02 {
4     /* Constructor */
5 
6     address payable private constant payrollArtist1 = 0x4257D02E2854C9c86d6975FCd14a1aF4FA65a652;
7     address payable private constant payrollArtist2 = 0x2ea533314069dC9B4dF29E72bD1dFB64cC68456d;
8 
9     event PaymentReceived(address from, uint256 amount);
10 
11     function () external payable {
12 
13         payrollArtist1.transfer(msg.value/2);
14         payrollArtist2.transfer(msg.value/2);
15 
16         emit PaymentReceived(msg.sender, msg.value);
17 
18     }
19 }