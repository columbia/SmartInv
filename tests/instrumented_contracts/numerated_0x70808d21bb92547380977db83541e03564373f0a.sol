1 pragma solidity ^0.4.24;
2 
3 contract Test {
4     event testLog(address indexed account, uint amount);
5     
6     constructor() public {
7         emit testLog(msg.sender, block.number);
8     }
9     
10     function execute(uint number) public returns (bool) {
11         emit testLog(msg.sender, number);
12         return true;
13     }
14 }