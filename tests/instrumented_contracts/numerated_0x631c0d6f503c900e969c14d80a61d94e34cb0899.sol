1 pragma solidity ^0.4.18;
2 
3 contract PutYourFuckingTextOnTheFuckingBlockchain {
4     uint public mostSent = 0;
5     string public currentText = "Put your own text here for money!";
6     address public owner = msg.sender;
7     uint private maxLength = 50;
8     
9     function setText(string newText) public payable returns (bool) {
10         if (msg.value > mostSent && bytes(newText).length < maxLength) {
11             currentText = newText;
12             mostSent = msg.value;
13             return true;
14         } else {
15             msg.sender.transfer(msg.value);
16             return false;
17         }
18     }
19 
20     function withdrawEther() external {
21         require(msg.sender == owner);
22         owner.transfer(this.balance);
23     }
24 
25     function () public payable{
26         setText("Default text!");
27     }
28 }