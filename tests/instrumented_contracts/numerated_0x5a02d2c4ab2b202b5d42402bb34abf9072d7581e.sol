1 pragma solidity ^0.4.19;
2 contract ChessMoney {
3  
4     //CONSTANT
5     uint256 private maxTickets;
6     uint256 public ticketPrice; 
7      
8     //LOTTO REGISTER
9     uint256 public lottoIndex;
10     uint256 lastTicketTime;
11     
12     //LOTTO VARIABLES
13 	uint8 _direction;
14     uint256 numtickets;
15     uint256 totalBounty;
16     
17     address worldOwner;   
18      
19     event NewTicket(address indexed fromAddress, bool success);
20     event LottoComplete(address indexed fromAddress, uint indexed lottoIndex, uint256 reward);
21     
22     /// Create a new Lotto
23     function ChessMoney() public 
24     {
25         worldOwner = msg.sender; 
26         
27         ticketPrice = 0.00064 * 10**18;
28         maxTickets = 320;
29         
30 		_direction = 0;
31         lottoIndex = 1;
32         lastTicketTime = 0;
33         
34         numtickets = 0;
35         totalBounty = 0;
36     }
37 
38     
39     function getBalance() public view returns (uint256 balance)
40     {
41         balance = 0;
42         
43         if(worldOwner == msg.sender) balance = this.balance;
44         
45         return balance;
46     }
47     
48     
49 	function withdraw() public 
50     {
51         require(worldOwner == msg.sender);  
52         
53 		//reset values
54         lottoIndex += 1;
55         numtickets = 0;
56         totalBounty = 0;
57 		
58 		worldOwner.transfer(this.balance); 
59     }
60     
61     
62     function getLastTicketTime() public view returns (uint256 time)
63     {
64         time = lastTicketTime; 
65         return time;
66     }
67     
68 	
69     function AddTicket() public payable 
70     {
71         require(msg.value == ticketPrice); 
72         require(numtickets < maxTickets);
73         
74 		//update bif
75 		lastTicketTime = now;
76         numtickets += 1;
77         totalBounty += ticketPrice;
78         bool success = numtickets == maxTickets;
79 		
80         NewTicket(msg.sender, success);
81         
82 		//check if winner
83         if(success) 
84         {
85             PayWinner(msg.sender);
86         } 
87     }
88     
89     
90     function PayWinner( address winner ) private 
91     { 
92         require(numtickets == maxTickets);
93         
94 		//calc reward
95         uint ownerTax = totalBounty / 10;
96         uint winnerPrice = totalBounty - ownerTax;
97         
98         LottoComplete(msg.sender, lottoIndex, winnerPrice);
99          
100 		//reset values
101         lottoIndex += 1;
102         numtickets = 0;
103         totalBounty = 0;
104 		
105 		//change max tickets to give unpredictability
106 		if(_direction == 0 && maxTickets < 10) maxTickets += 1;
107 		if(_direction == 1 && maxTickets > 20) maxTickets -= 1;
108 		if(_direction == 0 && maxTickets < 30) maxTickets += 1;
109 		if(_direction == 1 && maxTickets > 40) maxTickets -= 1;
110 		if(_direction == 0 && maxTickets < 50) maxTickets += 1;
111 		if(_direction == 1 && maxTickets > 60) maxTickets -= 1;
112 		if(_direction == 0 && maxTickets < 70) maxTickets += 1;
113 		if(_direction == 1 && maxTickets > 80) maxTickets -= 1;
114 		if(_direction == 0 && maxTickets < 90) maxTickets += 1;
115 		if(_direction == 1 && maxTickets > 100) maxTickets -= 1;
116 		if(_direction == 0 && maxTickets < 110) maxTickets += 1;
117 		if(_direction == 1 && maxTickets > 120) maxTickets -= 1;
118 		if(_direction == 0 && maxTickets < 130) maxTickets += 1;
119 		if(_direction == 1 && maxTickets > 140) maxTickets -= 1;
120 		if(_direction == 0 && maxTickets < 150) maxTickets += 1;
121 		if(_direction == 1 && maxTickets > 160) maxTickets -= 1;
122 		if(_direction == 0 && maxTickets < 170) maxTickets += 1;
123 		if(_direction == 1 && maxTickets > 180) maxTickets -= 1;
124 		if(_direction == 0 && maxTickets < 190) maxTickets += 1;
125 		if(_direction == 1 && maxTickets > 200) maxTickets -= 1;
126 		if(_direction == 0 && maxTickets < 210) maxTickets += 1;
127 		if(_direction == 1 && maxTickets > 220) maxTickets -= 1;
128 		if(_direction == 0 && maxTickets < 230) maxTickets += 1;
129 		if(_direction == 1 && maxTickets > 240) maxTickets -= 1;
130 		if(_direction == 0 && maxTickets < 250) maxTickets += 1;
131 		if(_direction == 1 && maxTickets > 260) maxTickets -= 1;
132 		if(_direction == 0 && maxTickets < 270) maxTickets += 1;
133 		if(_direction == 1 && maxTickets > 280) maxTickets -= 1;
134 		if(_direction == 0 && maxTickets < 290) maxTickets += 1;
135 		if(_direction == 1 && maxTickets > 300) maxTickets -= 1;
136 		if(_direction == 0 && maxTickets < 310) maxTickets += 1;
137 		if(_direction == 1 && maxTickets > 320) maxTickets -= 1;
138 		if(_direction == 0 && maxTickets == 10) _direction = 1;
139 		if(_direction == 1 && maxTickets == 20) _direction = 0;
140 		if(_direction == 0 && maxTickets == 30) _direction = 1;
141 		if(_direction == 1 && maxTickets == 40) _direction = 0;
142 		if(_direction == 0 && maxTickets == 50) _direction = 1;
143 		if(_direction == 1 && maxTickets == 60) _direction = 0;
144 		if(_direction == 0 && maxTickets == 70) _direction = 1;
145 		if(_direction == 1 && maxTickets == 80) _direction = 0;
146  		if(_direction == 0 && maxTickets == 90) _direction = 1;
147 		if(_direction == 1 && maxTickets == 100) _direction = 0;
148 		if(_direction == 0 && maxTickets == 110) _direction = 1;
149 		if(_direction == 1 && maxTickets == 120) _direction = 0;
150 		if(_direction == 0 && maxTickets == 130) _direction = 1;
151 		if(_direction == 1 && maxTickets == 140) _direction = 0;
152 		if(_direction == 0 && maxTickets == 150) _direction = 1;
153 		if(_direction == 1 && maxTickets == 160) _direction = 0;
154 		if(_direction == 0 && maxTickets == 170) _direction = 1;
155 		if(_direction == 1 && maxTickets == 180) _direction = 0;
156 		if(_direction == 0 && maxTickets == 190) _direction = 1;
157 		if(_direction == 1 && maxTickets == 200) _direction = 0;
158 		if(_direction == 0 && maxTickets == 210) _direction = 1;
159 		if(_direction == 1 && maxTickets == 220) _direction = 0;
160 		if(_direction == 0 && maxTickets == 230) _direction = 1;
161 		if(_direction == 1 && maxTickets == 240) _direction = 0;
162  		if(_direction == 0 && maxTickets == 250) _direction = 1;
163 		if(_direction == 1 && maxTickets == 260) _direction = 0;
164 		if(_direction == 0 && maxTickets == 270) _direction = 1;
165 		if(_direction == 1 && maxTickets == 280) _direction = 0;
166 		if(_direction == 0 && maxTickets == 290) _direction = 1;
167 		if(_direction == 1 && maxTickets == 300) _direction = 0;
168 		if(_direction == 0 && maxTickets == 310) _direction = 1;
169 		if(_direction == 1 && maxTickets == 320) _direction = 0;
170 	      
171 
172         
173 		//give real money
174         worldOwner.transfer(ownerTax);
175         winner.transfer(winnerPrice); 
176     }
177 }