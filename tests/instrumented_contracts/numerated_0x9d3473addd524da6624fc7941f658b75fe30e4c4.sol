1 pragma solidity ^0.4.24;
2 
3 contract BulletinBoard {
4 
5     struct Message {
6         address sender;
7         string text;
8         uint timestamp;
9         uint payment;
10     }
11 
12     Message[] public messages;
13     address public owner;
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     function addMessage(string text) public payable {
20         require(msg.value >= 0.000001 ether * bytes(text).length);
21         messages.push(Message(msg.sender, text, block.timestamp, msg.value));
22     }
23 
24     function numMessages() public constant returns (uint) {
25         return messages.length;
26     }
27 
28     function withdraw() public {
29         require(msg.sender == owner);
30         msg.sender.transfer(address(this).balance);
31     }
32 }