1 pragma solidity 0.4.25;
2 contract Balls {
3 string messageString = "Welcome to the Project 0xbt.net";
4     
5     function getPost() public constant returns (string) {
6         return messageString;
7     }
8     
9     function setPost(string newPost) public {
10         messageString = newPost;
11     }
12     
13 }