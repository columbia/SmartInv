1 pragma solidity ^0.4.19;
2  
3  
4  
5  
6  
7 contract Lottery7 {
8     
9     address owner;
10     address profit = 0xB7BB510B0746bdeE208dB6fB781bF5Be39d15A15;
11     uint public tickets;
12     uint public round;
13     string public status;
14     uint public lastWiningTicketNumber;
15     address public lastWinner;
16     address ticket1;
17     address ticket2;
18     address ticket3;
19     address ticket4;
20     address ticket5;
21     uint constant price = 0.1 ether; 
22     uint seed;
23     bool entry = false;
24      
25     function Lottery7() public { 
26         owner = msg.sender;
27         tickets = 5;
28         round = 1;
29         status = "Running";
30         entry = false;
31         seed = 777;
32     }
33      
34      
35     function changeStatus(string w) public {
36         if (msg.sender == owner) {
37             status = w;
38         }
39         else {
40             revert();
41         }
42     }
43     
44     function changeSeed(uint32 n) public {
45         if (msg.sender == owner) {
46             seed = uint(n);
47             seed = uint(block.blockhash(block.number-seed))%2000 + 1; 
48         }
49         else {
50             revert();
51         }
52     }
53      
54     function () public payable { 
55         buyTickets();
56     }
57      
58     function buyTickets() public payable {
59         if (entry == true) { 
60             revert();
61         }
62         entry = true;
63         
64         if (msg.value != (price)) {
65             entry = false;
66             if (keccak256(status) == keccak256("Shutdown")) { 
67                 selfdestruct(owner);
68             }
69             revert(); 
70         }
71         else {
72             if (tickets == 5) {
73                 tickets -= 1;
74                 ticket1 = msg.sender;
75             }
76             else if(tickets == 4) {
77                 tickets -= 1;
78                 ticket2 = msg.sender;
79                 profit.transfer(price * 1/2); 
80             }
81             else if(tickets == 3) {
82                 tickets -= 1;
83                 ticket3 = msg.sender;
84             }
85             else if(tickets == 2) {
86                 tickets -= 1;
87                 ticket4 = msg.sender;
88             }
89             else if(tickets == 1) {
90                 ticket5 = msg.sender;
91                 
92                 tickets = 5; 
93                 round += 1; 
94                 seed = uint(block.blockhash(block.number-seed))%2000 + 1; 
95                 uint random_number = uint(block.blockhash(block.number-seed))%5 + 1; 
96                 lastWiningTicketNumber = random_number; 
97     
98                 uint pay = (price * 9/2); 
99                 
100                 if (random_number == 1) {
101                     ticket1.transfer(pay);
102                     lastWinner = ticket1; 
103                 }
104                 else if(random_number == 2) {
105                     ticket2.transfer(pay);
106                     lastWinner = ticket2; 
107                 }
108                 else if(random_number == 3) {
109                     ticket3.transfer(pay);
110                     lastWinner = ticket3; 
111                 }
112                 else if(random_number == 4) {
113                     ticket4.transfer(pay);
114                     lastWinner = ticket4; 
115                 }
116                 else if(random_number == 5) {
117                     ticket5.transfer(pay);
118                     lastWinner = ticket5; 
119                 }
120             }
121         }
122 
123         entry = false;
124     }
125      
126      
127 }