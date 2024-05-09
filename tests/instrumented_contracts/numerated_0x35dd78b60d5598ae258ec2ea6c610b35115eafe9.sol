1 pragma solidity ^0.4.24;
2 
3 /**
4  * The PlutoCommyLotto contract is a communist bidding/lottery system. It shares 80% of the prize with everyone who didn't win. The winner gets 20%.
5  */
6 contract PlutoCommyLotto {
7 
8 	address public maintenanceFunds; //holds capital for reinvestment in case there's no activity for too long.
9 
10 	uint public currentCicle = 0;
11 	uint public numBlocksForceEnd = 5760;//5760;
12 	uint public jackpotPossibilities = 5000000;//5000000;
13 	uint public winnerPct = 20; //20%
14 	uint public commyPct = 80; //80%
15 	uint public lastJackpotResult; //for easy auditing.
16 
17 	uint private costIncrementNormal = 5; //0.5%
18 	uint private idealReserve = 60 finney;
19 	uint private minTicketCost = 1 finney / 10;
20 	uint private baseTicketProportion = 30;
21 	uint private maintenanceTickets = 50;
22 	
23 	struct Cicle {
24 		mapping (address => uint) ticketsByHash;
25 		address lastPlayer;
26 		uint number; 
27 		uint initialBlock;
28 		uint numTickets;
29 		uint currentTicketCost;
30 		uint lastJackpotChance;
31 		uint winnerPot; 
32 		uint commyPot; 
33 		uint commyReward;
34 		uint lastBetBlock;
35 		bool isActive;
36 	}
37 
38 	mapping (uint => Cicle) public cicles;
39 
40 	//////////###########//////////
41 	modifier onlyInitOnce() { 
42 		require(currentCicle == 0); 
43 		_; 
44 	}
45 	modifier onlyLastPlayer(uint cicleNumber) { 
46 		require(msg.sender == cicles[cicleNumber].lastPlayer); 
47 		_; 
48 	}
49 	modifier onlyIfNoActivity(uint cicleNumber) { 
50 		require(block.number - cicles[cicleNumber].lastBetBlock > numBlocksForceEnd);
51 		_; 
52 	}
53 	modifier onlyActiveCicle(uint cicleNumber) { 
54 		require(cicles[cicleNumber].isActive == true);
55 		_; 
56 	}
57 	modifier onlyInactiveCicle(uint cicleNumber) { 
58 		require(cicles[cicleNumber].isActive == false);
59 		_; 
60 	}
61 	modifier onlyWithTickets(uint cicleNumber) { 
62 		require(cicles[cicleNumber].ticketsByHash[msg.sender] > 0);
63 		_; 
64 	}
65 	modifier onlyValidCicle(uint cicleNumber) { 
66 		require(cicleNumber <= currentCicle);
67 		_; 
68 	}
69 	//////////###########//////////
70 
71 	function init() public payable onlyInitOnce() {
72 		maintenanceFunds = msg.sender;
73 		createNewCicle();
74 		
75 		idealReserve = msg.value;
76 
77 		uint winnerVal = msg.value * winnerPct / 100;
78 		cicles[currentCicle].winnerPot += winnerVal;
79 		cicles[currentCicle].commyPot += msg.value - winnerVal;
80 		cicles[currentCicle].currentTicketCost = ((cicles[currentCicle].winnerPot + cicles[currentCicle].commyPot) / baseTicketProportion);
81 		
82 		setCommyReward(currentCicle);
83 	}
84 
85 	event NewCicle(uint indexed cicleNumber, uint firstBlock);
86 	function createNewCicle() private {
87 		currentCicle += 1;
88 		cicles[currentCicle] = Cicle({ number:currentCicle,
89 									initialBlock:block.number,
90 									numTickets:maintenanceTickets,
91 									lastPlayer:maintenanceFunds,
92 									lastJackpotChance:0,
93 									lastBetBlock:block.number,
94 									winnerPot:0,
95 									commyPot:0,
96 									commyReward:0,
97 									currentTicketCost:0,
98 									isActive:false });
99 
100 		cicles[currentCicle].ticketsByHash[maintenanceFunds] = maintenanceTickets;
101 
102 		if(currentCicle != 1) {
103 			cicles[currentCicle-1].ticketsByHash[maintenanceFunds] = 0;
104 			if (cicles[currentCicle-1].commyReward * maintenanceTickets > idealReserve) {
105 				cicles[currentCicle].winnerPot = idealReserve * winnerPct / 100;
106 				cicles[currentCicle].commyPot = idealReserve * commyPct / 100;
107 				maintenanceFunds.transfer(cicles[currentCicle-1].commyReward * maintenanceTickets - idealReserve);
108 			} else {
109 				if(cicles[currentCicle-1].numTickets == maintenanceTickets) {
110 					cicles[currentCicle].winnerPot = cicles[currentCicle-1].winnerPot;
111 					cicles[currentCicle].commyPot = cicles[currentCicle-1].commyPot;
112 				} else {
113 					cicles[currentCicle].winnerPot = (cicles[currentCicle-1].commyReward * maintenanceTickets) * winnerPct / 100;
114 					cicles[currentCicle].commyPot = (cicles[currentCicle-1].commyReward * maintenanceTickets) * commyPct / 100;
115 				}
116 			}
117 
118 			setCommyReward(currentCicle);
119 			cicles[currentCicle].currentTicketCost = (cicles[currentCicle].winnerPot + cicles[currentCicle].commyPot) / baseTicketProportion;
120 			if(cicles[currentCicle].currentTicketCost < minTicketCost) {
121 				cicles[currentCicle].currentTicketCost = minTicketCost;
122 			}
123 		}
124 				
125 		cicles[currentCicle].isActive = true;
126 		emit NewCicle(currentCicle, block.number);
127 	}
128 
129 	function setCommyReward(uint cicleNumber) private {
130 		cicles[cicleNumber].commyReward = cicles[cicleNumber].commyPot / (cicles[cicleNumber].numTickets-1);
131 	}
132 
133 	event NewBet(uint indexed cicleNumber, address indexed player, uint instantPrize, uint jackpotChance, uint jackpotResult, bool indexed hasHitJackpot);
134 	function bet() public payable {
135 		require (msg.value >= cicles[currentCicle].currentTicketCost);
136 
137 		cicles[currentCicle].lastBetBlock = block.number;
138 		cicles[currentCicle].ticketsByHash[msg.sender] += 1;
139 
140 		uint commyVal = cicles[currentCicle].currentTicketCost * commyPct / 100;
141 		cicles[currentCicle].winnerPot += msg.value - commyVal;
142 		cicles[currentCicle].commyPot += commyVal;
143 		cicles[currentCicle].numTickets += 1;
144 		cicles[currentCicle].currentTicketCost += cicles[currentCicle].currentTicketCost * costIncrementNormal / 1000;
145 		cicles[currentCicle].lastJackpotChance = block.number - cicles[currentCicle].initialBlock;
146 		cicles[currentCicle].lastPlayer = msg.sender;
147 		setCommyReward(currentCicle);
148 
149 		if(getJackpotResult(currentCicle) == true)
150 		{
151 			emit NewBet(currentCicle, cicles[currentCicle].lastPlayer, cicles[currentCicle].winnerPot, cicles[currentCicle].lastJackpotChance, lastJackpotResult, true);
152 			endCicle(currentCicle, true);
153 		} else {
154 			emit NewBet(currentCicle, msg.sender, 0, cicles[currentCicle].lastJackpotChance, lastJackpotResult, false);
155 		}
156 	}
157 
158 	function getJackpotResult(uint cicleNumber) private returns (bool isWinner) {
159 		lastJackpotResult = uint(blockhash(block.number-1)) % jackpotPossibilities;
160 
161 		if(lastJackpotResult < cicles[cicleNumber].lastJackpotChance) {
162 			isWinner = true;
163 		}
164 	}
165 
166 	event CicleEnded(uint indexed cicleNumber, address winner, uint winnerPrize, uint commyReward, uint lastBlock, bool jackpotVictory);
167 	function endCicle(uint cicleNumber, bool jackpotVictory) private {
168 		cicles[cicleNumber].isActive = false;
169 		emit CicleEnded(cicleNumber, cicles[cicleNumber].lastPlayer, cicles[cicleNumber].winnerPot, cicles[cicleNumber].commyReward, block.number, jackpotVictory);
170 		createNewCicle();
171 	}
172 
173 	function finishByInactivity(uint cicleNumber) public onlyIfNoActivity(cicleNumber) onlyActiveCicle(cicleNumber){
174 		endCicle(cicleNumber, false);
175 	}
176 
177 	function withdraw(uint cicleNumber) public onlyValidCicle(cicleNumber) onlyInactiveCicle(cicleNumber) onlyWithTickets(cicleNumber) {
178 		uint numTickets = cicles[cicleNumber].ticketsByHash[msg.sender];			
179 		cicles[cicleNumber].ticketsByHash[msg.sender] = 0;
180 
181 		if(msg.sender != cicles[cicleNumber].lastPlayer){
182 			msg.sender.transfer(cicles[cicleNumber].commyReward * numTickets);
183 		} else {
184 			if(numTickets == 1){
185 				msg.sender.transfer(cicles[cicleNumber].winnerPot);
186 			} else {
187 				msg.sender.transfer(cicles[cicleNumber].winnerPot + (cicles[cicleNumber].commyReward * (numTickets - 1)));
188 			}
189 		}
190 	}
191 
192 	function claimPrizeByInactivity(uint cicleNumber) public onlyValidCicle(cicleNumber) onlyActiveCicle(cicleNumber) onlyIfNoActivity(cicleNumber) onlyLastPlayer(cicleNumber) {
193 		endCicle(cicleNumber, false);
194 		withdraw(cicleNumber);
195 	}
196 
197 	//////
198 	//Getters for dapp:
199 	function getCicle(uint cicleNumber) public view returns (address lastPlayer,
200 														uint number,
201 														uint initialBlock,
202 														uint numTickets,
203 														uint currentTicketCost,
204 														uint lastJackpotChance,
205 														uint winnerPot,
206 														uint commyPot,
207 														uint commyReward,
208 														uint lastBetBlock,
209 														bool isActive){
210 		Cicle memory myCurrentCicle = cicles[cicleNumber];
211 
212 		return (myCurrentCicle.lastPlayer,
213 				myCurrentCicle.number,
214 				myCurrentCicle.initialBlock,
215 				myCurrentCicle.numTickets,
216 				myCurrentCicle.currentTicketCost,
217 				myCurrentCicle.lastJackpotChance,
218 				myCurrentCicle.winnerPot,
219 				myCurrentCicle.commyPot,
220 				myCurrentCicle.commyReward,
221 				myCurrentCicle.lastBetBlock,
222 				myCurrentCicle.isActive);
223 	}
224 
225 	function getMyTickets(address myAddress, uint cicleNumber) public view returns (uint myTickets) {
226 		return cicles[cicleNumber].ticketsByHash[myAddress];
227 	}
228 }