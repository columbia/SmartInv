1 pragma solidity ^0.4.19;
2 contract LottoCount {
3  
4     //CONSTANT
5     uint256 private maxTickets;
6     uint256 public ticketPrice; 
7      
8     //LOTO REGISTER
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
23     function LottoCount() public 
24     {
25         worldOwner = msg.sender; 
26         
27         ticketPrice = 0.0101 * 10**18;
28         maxTickets = 10;
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
95         uint ownerTax = 6 * totalBounty / 100;
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
106 		if(_direction == 0 && maxTickets < 20) maxTickets += 1;
107 		if(_direction == 1 && maxTickets > 10) maxTickets -= 1;
108 		
109 		if(_direction == 0 && maxTickets == 20) _direction = 1;
110 		if(_direction == 1 && maxTickets == 10) _direction = 0;
111          
112 		//give real money
113         worldOwner.transfer(ownerTax);
114         winner.transfer(winnerPrice); 
115     }
116 }