1 pragma solidity ^0.4.25;
2 
3 contract Hello {
4     string greeting;
5 
6      constructor() public {
7         greeting = "hello";
8      }
9 
10      function getGreeting() public view returns (string) {
11         return greeting;
12      }
13 
14      function setGreeting(string _greeting) public {
15         greeting = _greeting;
16      }
17 }