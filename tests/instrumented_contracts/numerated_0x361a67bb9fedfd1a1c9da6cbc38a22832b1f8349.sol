1 pragma solidity ^0.4.11;
2 
3 contract BraggerContract {
4     address public richest;
5     string public displayString;
6     uint public highestBalance;
7     
8     address owner;
9     address[] public participants;
10     uint[] public pastValues;
11 
12     function BraggerContract() public payable {
13         owner = msg.sender;
14         highestBalance = 0;
15     }
16 
17     function becomeRichest(string newString) public payable {
18         require(msg.value > 0.002 ether);
19         require(msg.sender.balance > highestBalance);
20         require(bytes(newString).length < 500);
21         
22         highestBalance = msg.sender.balance;
23         pastValues.push(msg.sender.balance);
24         
25         richest = msg.sender;
26         participants.push(msg.sender);
27         
28         displayString = newString;
29         owner.transfer(msg.value);
30     }
31 }