1 pragma solidity ^0.4.23;
2 
3 //Copyright 2018 PATRIK STAS
4 //
5 //Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
6 //
7 //The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
8 //
9 //THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
10 
11 contract EthernalMessageBook {
12 
13     event MessageEthernalized(
14         uint messageId
15     );
16 
17     struct Message {
18         string msg;
19         uint value;
20         address sourceAddr;
21         string authorName;
22         uint time;
23         uint blockNumber;
24         string metadata;
25         string link;
26         string title;
27     }
28 
29     Message[] public messages;
30 
31     address private root;
32 
33     uint public price;
34     uint public startingPrice;
35 
36     uint32 public multNumerator;
37     uint32 public multDenominator;
38 
39     uint32 public expirationSeconds;
40     uint public expirationTime;
41 
42     constructor(uint argStartPrice, uint32 argNumerator, uint32 argDenominator, uint32 argExpirationSeconds) public {
43         root = msg.sender;
44         price = argStartPrice;
45         startingPrice = argStartPrice;
46 
47         require(argNumerator > multDenominator);
48         multNumerator = argNumerator;
49         multDenominator = argDenominator;
50 
51         expirationSeconds = argExpirationSeconds;
52         expirationTime = now;
53     }
54 
55     function getMessagesCount() public view returns (uint) {
56         return messages.length;
57     }
58 
59     function getSummary() public view returns (uint32, uint32, uint, uint) {
60         return (
61             multNumerator,
62             multDenominator,
63             startingPrice,
64             messages.length
65         );
66     }
67 
68 
69     function getSecondsToExpiration() public view returns (uint) {
70         if (expirationTime > now) {
71             return expirationTime - now;
72         }
73         else return 0;
74     }
75 
76 
77     function writeMessage(string argMsg, string argTitle, string argAuthorName, string argLink, string argMeta) public payable {
78         require(block.timestamp >= expirationTime);
79         require(msg.value >= price);
80         Message memory newMessage = Message({
81             msg : argMsg,
82             value : msg.value,
83             sourceAddr : msg.sender,
84             authorName : argAuthorName,
85             time : block.timestamp,
86             blockNumber : block.number,
87             metadata : argMeta,
88             link : argLink,
89             title: argTitle
90         });
91         messages.push(newMessage);
92         address thisContract = this;
93         root.transfer(thisContract.balance);
94         emit MessageEthernalized(messages.length - 1);
95         price = (price * multNumerator) / multDenominator;
96         expirationTime = block.timestamp + expirationSeconds;
97 }
98 
99     // no fallback - reject ether sent by mistake/invalid transaction
100 }