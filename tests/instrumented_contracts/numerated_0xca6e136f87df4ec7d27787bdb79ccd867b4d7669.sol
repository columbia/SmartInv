1 pragma solidity ^0.4.23;
2 contract Ethertag {
3     address public owner;
4     address public thisContract = this;
5     uint public minValue;
6     uint public maxTextLength;
7     message[] public messages;
8     
9     struct message {
10         string text;
11         uint value;
12         rgb color;
13     }
14     
15     struct rgb {
16         uint8 red;
17         uint8 green;
18         uint8 blue;
19     }
20     
21     event newMessage(uint id, string text, uint value, uint8 red, uint8 green, uint8 blue);
22     event newSupport(uint id, uint value);
23     
24     constructor() public {
25         owner = msg.sender;
26         minValue = 10000000000000;
27         maxTextLength = 200;
28     }
29     
30     function getMessagesCount() public view returns(uint) {
31         return messages.length;
32     }
33 
34     function getMessage(uint i) public view returns(string text, uint value, uint8 red, uint8 green, uint8 blue) {
35         require(i<messages.length);
36         return (
37             messages[i].text, 
38             messages[i].value,
39             messages[i].color.red,
40             messages[i].color.green,
41             messages[i].color.blue
42             );
43     }
44   
45     function addMessage(string m, uint8 r, uint8 g, uint8 b) public payable {
46         require(msg.value >= minValue);
47         require(bytes(m).length <= maxTextLength);
48         messages.push(message(m, msg.value, rgb(r,g,b)));
49         emit newMessage(
50             messages.length-1,
51             messages[messages.length-1].text, 
52             messages[messages.length-1].value, 
53             messages[messages.length-1].color.red,
54             messages[messages.length-1].color.green,
55             messages[messages.length-1].color.blue
56             );
57     }
58     
59     function supportMessage(uint i) public payable {
60         messages[i].value += msg.value;
61         emit newSupport(i, messages[i].value);
62     }
63    
64     function changeSettings(uint newMaxTextLength, uint newMinValue) public {
65         require(msg.sender == owner);
66         maxTextLength = newMaxTextLength;
67         minValue = newMinValue;
68     }
69     
70     function withdraw() public {
71         require(msg.sender == owner);
72         msg.sender.transfer(thisContract.balance);
73     }
74 }