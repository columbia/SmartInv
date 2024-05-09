1 pragma solidity ^0.4.11;
2 
3 contract ConsensysAcademy{
4     mapping(address=>bytes32) public names;
5     address[] public addresses;
6     
7     modifier onlyUnique(){
8         if(names[msg.sender] == 0){ _; }else{ throw; }
9     }
10     function register(bytes32 name) onlyUnique{
11         names[msg.sender] = name; //32 character limit (first 32 used)
12         addresses.push(msg.sender);
13     }
14     function getAddresses() returns(address[]){ return addresses; }
15 }