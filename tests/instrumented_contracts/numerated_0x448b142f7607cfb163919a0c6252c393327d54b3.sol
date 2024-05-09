1 pragma solidity ^0.4.13;
2  
3 contract HelloWorld {
4     
5     string wellcomeString = "Hello, world!";
6     
7     function getData() constant returns (string) {
8         return wellcomeString;
9     }
10     
11     function setData(string newData) {
12         wellcomeString = newData;
13     }
14     
15 }