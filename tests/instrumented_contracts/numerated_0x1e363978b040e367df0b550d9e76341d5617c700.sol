1 pragma solidity ^0.4.24;
2 
3 contract PhraseFlow {
4     string[] public flow;
5     uint public count;
6 
7     function addPhrase(string _newPhrase) public {
8         flow.push(_newPhrase);
9         count = count + 1;
10     }
11 
12     constructor() public {
13         count = 0;
14     }
15 }