1 pragma solidity ^0.4.11;
2 
3 contract WhiteList {
4     
5     mapping (address => bool)   public  whiteList;
6     
7     address  public  owner;
8     
9     function WhiteList() public {
10         owner = msg.sender;
11         whiteList[owner] = true;
12     }
13     
14     function addToWhiteList(address [] _addresses) public {
15         require(msg.sender == owner);
16         
17         for (uint i = 0; i < _addresses.length; i++) {
18             whiteList[_addresses[i]] = true;
19         }
20     }
21     
22     function removeFromWhiteList(address [] _addresses) public {
23         require (msg.sender == owner);
24         for (uint i = 0; i < _addresses.length; i++) {
25             whiteList[_addresses[i]] = false;
26         }
27     }
28 }