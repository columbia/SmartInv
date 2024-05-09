1 pragma solidity ^0.4.23;
2 
3 contract MyTest{
4     string private name;
5    
6     function setName(string newName) public{
7         name=newName;
8     }
9     
10     function getName() public view returns(string){
11         return name;
12     }
13     
14 }