1 pragma solidity ^0.4.13;
2 
3 contract NameTracker {
4   address creator;
5   string public name;
6 
7   function NameTracker(string initialName) {
8     creator = msg.sender;
9     name = initialName;
10   }
11   
12   function update(string newName) {
13     if (msg.sender == creator) {
14       name = newName;
15     }
16   }
17 
18   function getBlockNumber() constant returns (uint)
19   {
20     return block.number;
21   }
22 
23   function kill() {
24     if (msg.sender == creator) suicide(creator);
25   }
26 }