1 pragma solidity ^0.4.24;
2 
3 contract SimpleStorage {
4     
5     address public owner;
6     uint256 public storageValue;
7     
8     constructor()  public {
9         owner = msg.sender;
10     }
11     
12     function setStorage(uint256 _value) {
13         storageValue = _value;
14     }
15 }