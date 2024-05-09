1 pragma solidity ^0.4.18;
2 
3 contract UserName {
4 
5   mapping (address => mapping (uint => string)) public userDict;
6 
7   event OnNameChanged(uint indexed _guid, address indexed _who, string _newName);
8 
9   function changeName(uint _guid, string _newName) public {
10     userDict[msg.sender][_guid] = _newName;
11     OnNameChanged(_guid, msg.sender, _newName);
12   }
13 
14   function nameOf(uint _guid, address _who) view public returns (string) {
15     return userDict[_who][_guid];
16   }
17 }