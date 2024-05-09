1 pragma solidity ^0.4.9;
2 
3 contract Originstamp {
4 
5     address public owner;
6 
7     event Submitted(bytes32 indexed pHash);
8 
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function Originstamp() public {
15 	owner = msg.sender;
16     }
17 
18     function submitHash(bytes32 pHash) public onlyOwner() {
19         Submitted(pHash);
20     }
21 }