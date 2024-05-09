1 pragma solidity ^0.4.21;
2 
3 contract Hellina{
4     address owner;
5     function Hellina(){
6         owner=msg.sender;
7     }
8     
9     function Buy() payable{
10         
11     }
12     
13     function Withdraw(){
14         owner.transfer(address(this).balance);
15     }
16 }