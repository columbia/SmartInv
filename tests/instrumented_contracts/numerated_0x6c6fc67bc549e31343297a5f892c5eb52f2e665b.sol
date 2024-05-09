1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract EmailRegistry {
6     mapping (address => string) public emails;
7     address [] public registeredAddresses;
8     function registerEmail(string email) public{
9         require(bytes(email).length>0);
10         //if previously unregistered, add to list
11         if(bytes(emails[msg.sender]).length==0){
12             registeredAddresses.push(msg.sender);
13         }
14         emails[msg.sender]=email;    
15     }
16     function numRegistered() public constant returns(uint count) {
17         return registeredAddresses.length;
18     }
19 }