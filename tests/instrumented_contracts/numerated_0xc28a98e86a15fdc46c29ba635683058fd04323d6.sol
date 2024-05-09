1 pragma solidity ^0.4.2;
2 contract owned {
3     address public owner;
4 
5     function owned() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) revert();
11         _;
12     }
13 
14     function transferOwnership(address newOwner) public onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 
20 
21 
22 contract WorldLotteryFast is owned{
23     uint public countTickets = 4;
24     uint public JackPot = 10000000000000000;
25     address[100] public tickets;
26     uint public ticketPrice = 10000000000000000;                         
27     uint public toJackPotfromEveryTicket = 1000000000000000;
28     uint public lastWinNumber;
29     uint public ticketCounter;
30     bool public playFast=true;
31  
32 	
33     /* This generates a public event on the blockchain that will notify clients */
34 	event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     function clearTickets() public {
37         for (uint i = 0 ; i < countTickets ; i++ )
38             tickets[i] = 0;
39     }
40 
41     
42 	function PlayNow() public returns (bool success)  {     
43         lastWinNumber = uint(block.blockhash(block.number-1))%countTickets + 1;                                  // take random number
44       		
45 		if (tickets[lastWinNumber] !=0 ){  
46 			msg.sender.transfer(JackPot);
47 			Transfer(this,msg.sender,JackPot);												//send Jack Pot to the winner
48 			JackPot = 0;                                                                	                                                                // and clear JackPot
49         }  
50         clearTickets();
51         
52         return true;
53     }
54     
55     
56 	function getJackPot() public returns (uint jPot)  {     
57         return JackPot;
58     }
59 	
60  
61     function setLotteryParameters(uint newCountTickets, uint newTicketPrice, uint newToJackPotfromEveryTicket, uint newJackPot, bool newPlayFast) public onlyOwner {
62         countTickets=newCountTickets;
63         ticketPrice = newTicketPrice;
64         toJackPotfromEveryTicket = newToJackPotfromEveryTicket;
65         JackPot=newJackPot;
66         playFast=newPlayFast;
67     }
68   
69     
70 }
71 
72 contract PlayLottery is WorldLotteryFast{
73 
74 
75 function adopt(uint ticketId) public payable returns (uint) {
76 		
77 		require(msg.value>=ticketPrice);
78 
79 		require(ticketId >= 0 && ticketId <= countTickets);
80 		
81 		if ( tickets[ticketId] != 0x0000000000000000000000000000000000000000 ) return 0;                        		    // Check if ticket already buyed
82         JackPot += toJackPotfromEveryTicket;                                			    								            // send tokens to JackPot
83         tickets[ticketId] = msg.sender;                                    	    											           // write senders address to ticketlist
84        
85         Transfer(msg.sender,this,ticketPrice);
86         
87 		if (playFast)                                                           											                          //if fast play
88 		    PlayNow();
89 		else{
90 		    ticketCounter++;                                                    											                 //if need to buy all tickets
91 		    if (ticketCounter==countTickets)
92 		        PlayNow();
93 		}
94 		
95        
96 		return ticketId;
97 }
98 
99 
100 // Retrieving the adopters
101 function getAdopters() public view returns (address[100]) {
102   return tickets;
103 }
104 
105 function withdraw() public onlyOwner {
106         owner.transfer(this.balance);
107 }
108 
109 
110 function killMe() public onlyOwner {
111         selfdestruct(owner);
112 }
113 
114 function getLastWinNumber() public returns (uint){
115         return lastWinNumber;
116 }
117 
118 function getTicket(uint newTicketId) public returns (address){
119         return  tickets[newTicketId];
120 }
121 
122 }