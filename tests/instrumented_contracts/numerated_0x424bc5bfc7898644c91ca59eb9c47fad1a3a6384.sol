1 pragma solidity 0.4.21;
2 
3 contract Greeter {
4     string public greeting;
5     
6     function Greeter(string _greeting) public {
7         setGreeting(_greeting);
8     }
9     
10     function setGreeting(string _greeting) public {
11         greeting = _greeting;
12     }
13     
14 }