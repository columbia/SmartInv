1 pragma solidity ^0.4.13;
2 
3 contract CryptoPeopleName {
4     address owner;
5     mapping(address => string) private nameOfAddress;
6   
7     function CryptoPeopleName() public{
8         owner = msg.sender;
9     }
10     
11     function setName(string name) public {
12         nameOfAddress[msg.sender] = name;
13     }
14     
15     function getNameOfAddress(address _address) public view returns(string _name){
16         return nameOfAddress[_address];
17     }
18     
19 }