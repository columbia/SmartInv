1 /*
2  * DO NOT EDIT! DO NOT EDIT! DO NOT EDIT!
3  *
4  * This is an automatically generated file. It will be overwritten.
5  *
6  * For the original source see
7  *    '/Users/ragolta/ETH/swaldman/helloworld/src/main/solidity/helloworld.sol'
8  */
9 
10 pragma solidity ^0.4.18;
11 
12 
13 
14 
15 
16 contract HelloWorld{
17     string input = "Hello world.";
18 
19     function sayHello() view public returns (string) {
20         return input;
21     }
22 
23     function setNewGreeting(string greeting) public {
24         input = greeting;
25     }
26 }