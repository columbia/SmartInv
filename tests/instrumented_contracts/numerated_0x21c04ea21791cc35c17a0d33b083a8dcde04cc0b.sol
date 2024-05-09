1 pragma solidity ^0.4.11;
2 
3 contract EthereumPot {
4 
5 	address public owner;
6 	address[] public addresses;
7 	
8 	address public winnerAddress;
9     uint[] public slots;
10     uint minBetSize = 0.01 ether;
11     uint public potSize = 0;
12     
13 	
14 	uint public amountWon;
15 	uint public potTime = 300;
16 	uint public endTime = now + potTime;
17 	uint public totalBet = 0;
18 
19 	bool public locked = false;
20 
21     
22     event debug(string msg);
23     event potSizeChanged(
24         uint _potSize
25     );
26 	event winnerAnnounced(
27 	    address winner,
28 	    uint amount
29 	);
30 	
31 	event timeLeft(uint left);
32 	function EthereumPot() public {
33 	    owner = msg.sender;
34 	}
35 	
36 	// function kill() public {
37 	//     if(msg.sender == owner)
38 	//         selfdestruct(owner);
39 	// }
40 	
41 	
42 	
43 	
44 	function findWinner(uint random) constant returns (address winner) {
45 	    
46 	    for(uint i = 0; i < slots.length; i++) {
47 	        
48 	       if(random <= slots[i]) {
49 	           return addresses[i];
50 	       }
51 	        
52 	    }    
53 	    
54 	}
55 	
56 	
57 	function joinPot() public payable {
58 	    
59 	    assert(now < endTime);
60 	    assert(!locked);
61 	    
62 	    uint tickets = 0;
63 	    
64 	    for(uint i = msg.value; i >= minBetSize; i-= minBetSize) {
65 	        tickets++;
66 	    }
67 	    if(tickets > 0) {
68 	        addresses.push(msg.sender);
69 	        slots.push(potSize += tickets);
70 	        totalBet+= potSize;
71 	        potSizeChanged(potSize);
72 	        timeLeft(endTime - now);
73 	    }
74 	}
75 	
76 	
77 	function getPlayers() constant public returns(address[]) {
78 		return addresses;
79 	}
80 	
81 	function getSlots() constant public returns(uint[]) {
82 		return slots;
83 	}
84 
85 	function getEndTime() constant public returns (uint) {
86 	    return endTime;
87 	}
88 	
89 	function openPot() internal {
90         potSize = 0;
91         endTime = now + potTime;
92         timeLeft(endTime - now);
93         delete slots;
94         delete addresses;
95         
96         locked = false;
97 	}
98 	
99     function rewardWinner() public payable {
100         
101         //assert time
102         
103         assert(now > endTime);
104         if(!locked) {
105             locked = true;
106             
107             if(potSize > 0) {
108             	//if only 1 person bet, wait until they've been challenged
109             	if(addresses.length == 1) {
110             	    random_number = 0;
111             	    endTime = now + potTime;
112             	    timeLeft(endTime - now);
113             	    locked = false;
114             	}
115             		
116             	else {
117             	    
118             	    uint random_number = uint(block.blockhash(block.number-1))%slots.length;
119                     winnerAddress = findWinner(random_number);
120                     amountWon = potSize * minBetSize * 98 / 100;
121                     
122                     winnerAnnounced(winnerAddress, amountWon);
123                     winnerAddress.transfer(amountWon); //2% fee
124                     owner.transfer(potSize * minBetSize * 2 / 100);
125                     openPot();
126 
127             	}
128                 
129             }
130             else {
131                 winnerAnnounced(0x0000000000000000000000000000000000000000, 0);
132                 openPot();
133             }
134             
135             
136         }
137         
138     }
139 	
140 	
141 	
142 	
143 	
144         
145 
146 }