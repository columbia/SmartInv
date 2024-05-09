1 pragma solidity ^0.5.2;
2 
3 contract Counter {
4   event Incremented(uint256 value);
5 
6   uint256 public value;
7 
8   constructor() public payable
9   {
10     value = 0;
11   }
12 
13   function increment() public payable {
14     value += 1;
15     emit Incremented(value);
16   }
17 }