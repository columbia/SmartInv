1 /*
2 
3    TEXTMESSAGE.ETH
4    
5    A Ethereum contract to send SMS message through the blockchain.
6    This contract does require msg.value of $0.08-$0.15 USD to cover
7    the price of sending a text message to the real world.
8    
9    Documentation & web3: https://hunterlong.github.io/textmessage.eth
10    Github: https://github.com/hunterlong/textmessage.eth
11    Author: Hunter Long
12    
13 */
14 
15 pragma solidity ^0.4.11;
16 
17 contract owned {
18     address public owner;
19 
20     function owned() {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         if (msg.sender != owner) throw;
26         _;
27     }
28 
29     function transferOwnership(address newOwner) onlyOwner {
30         owner = newOwner;
31     }
32 }
33 
34 
35 contract TextMessage is owned {
36     
37     uint cost;
38     bool public enabled;
39     
40     event UpdateCost(uint newCost);
41     event UpdateEnabled(string newStatus);
42     event NewText(string number, string message);
43 
44     function TextMessage() {
45         cost = 380000000000000;
46         enabled = true;
47     }
48     
49     function changeCost(uint price) onlyOwner {
50         cost = price;
51         UpdateCost(cost);
52     }
53     
54     function pauseContract() onlyOwner {
55         enabled = false;
56         UpdateEnabled("Texting has been disabled");
57     }
58     
59     function enableContract() onlyOwner {
60         enabled = true;
61         UpdateEnabled("Texting has been enabled");
62     }
63     
64     function withdraw() onlyOwner {
65         owner.transfer(this.balance);
66     }
67     
68     function costWei() constant returns (uint) {
69       return cost;
70     }
71     
72     function sendText(string phoneNumber, string textBody) public payable {
73         if(!enabled) throw;
74         if(msg.value < cost) throw;
75         sendMsg(phoneNumber, textBody);
76     }
77     
78     function sendMsg(string num, string body) internal {
79         NewText(num,body);
80     }
81     
82 }