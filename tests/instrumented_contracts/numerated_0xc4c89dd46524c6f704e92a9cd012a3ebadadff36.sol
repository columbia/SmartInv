1 pragma solidity ^0.4.0;
2 
3 contract HelloWorld {
4     address public owner;
5     
6     modifier onlyOwner() { require(msg.sender == owner); _; }
7     
8     constructor() public {
9         owner = msg.sender;
10     }
11     
12     function salutaAndonio() public pure returns(bytes32 hw) {
13         hw = "HelloWorld";
14     }
15     
16     function killMe() public onlyOwner {
17         selfdestruct(owner);
18     }
19     
20 }