1 pragma solidity 0.4.22;
2 
3 // EthGraffiti.com
4 
5 // A stupid internet experiment
6 // Will probably give you cancer
7 
8 contract EthGraffiti {
9     
10     address owner;
11     uint public constant MESSAGE_PRICE = 69 wei;
12     mapping (uint => string) public messages;
13     uint public messageNumber;
14     
15     constructor () public {
16         owner = msg.sender;
17     }
18     
19     function sendMessage(string message) public payable {
20         require (msg.value == MESSAGE_PRICE);
21         messages[messageNumber] = message;
22         messageNumber++;
23     }
24     
25     function withdraw() public {
26         require (msg.sender == owner);
27         msg.sender.transfer(address(this).balance);
28     }
29 }