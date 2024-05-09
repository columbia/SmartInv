1 pragma solidity ^0.4.0;
2 contract TestContract {
3     string name;
4     function getName() public constant returns (string){
5         return name;
6     }
7     function setName(string newName) public {
8         name = newName;
9     }
10 }