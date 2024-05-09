1 pragma solidity ^0.4.24;
2 
3 contract test{
4     uint256 public i;
5     address public owner;
6     
7     constructor() public{
8         owner = msg.sender;
9     }
10     
11     function add(uint256 a, uint256 b) public pure returns (uint256){
12         return a + b;
13     }
14     
15     function setI(uint256 m) public {
16         require(msg.sender == owner, "owner required");
17         i = m;
18     }
19 }