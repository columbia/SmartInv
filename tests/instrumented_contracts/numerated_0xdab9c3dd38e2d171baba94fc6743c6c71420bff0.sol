1 pragma solidity ^0.5.1;
2 
3 contract SavingTheSender {
4     address payable public theSender;
5     string public contact;
6     string public message;
7 
8     constructor() public {
9     	theSender = address(0);
10     	contact = 'support@creativecode.co.kr';
11     	message = 'This smart contract is deployed for miners who would like to return the Ethereum used in transaction fees and for developers who are working tirelessly to improve blockchain technology. We would like to show the world that smart contracts can be used in such cases.';
12     }
13     
14     event Register(address indexed _sender);
15     event Transfer(address indexed _from, uint256 _value, bytes _msg);
16     
17     modifier isCorrectSender() {
18         require(msg.sender == 0x587Ecf600d304F831201c30ea0845118dD57516e);
19         _;
20     }
21 
22     modifier isReceiver() {
23     	require(msg.sender == theSender);
24     	_;
25     }
26 
27     function registerTheSender() isCorrectSender public {
28     	theSender = msg.sender;
29     	emit Register(msg.sender);
30     }
31 
32     function appreciated() isReceiver public {
33     	theSender.transfer(address(this).balance);
34     }
35     
36     function() payable external {
37         emit Transfer(msg.sender, msg.value, msg.data);
38     }
39 }