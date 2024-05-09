1 pragma solidity 0.4.19;
2 
3 contract Admin {
4 
5     address public owner;
6     mapping(address => bool) public AdminList;
7     
8     function Test() public returns (uint256 _balance) {
9             
10         address sender = msg.sender;
11         return sender.balance;
12         
13     }
14     
15       function TestX() public {
16          
17          owner = msg.sender;
18         
19     }
20     
21 }