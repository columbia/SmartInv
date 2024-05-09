1 pragma solidity ^0.4.11;
2 
3 contract MyContract {
4   string word = "All men are created equal!";
5 
6   function getWord() returns (string){
7     return word;
8   }
9 
10 }