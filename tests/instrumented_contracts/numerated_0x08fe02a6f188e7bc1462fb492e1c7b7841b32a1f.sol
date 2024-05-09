1 pragma solidity 0.4.19;
2 
3 contract Dextera {
4 	/*
5 		Statics
6 	*/
7 
8 	// Creator account
9 	address public creator = msg.sender;
10 
11 	// Sellers account
12 	address public seller;
13 
14 	// One ticket price in wei
15 	uint256 public ticketPrice;
16 
17 	// Minimum number of tickets for successful completion
18 	uint256 public minimumTickets;
19 
20 	// Creator fee percent
21 	uint256 public creatorFeePercent;
22 
23 	// Datetime of contract end
24 	uint256 public saleEndTime;
25 
26 	/*
27 		Mutables
28 	*/
29 
30 	// Datetime of successful processing
31 	uint256 public successfulTime;
32 
33 	// Buyers
34 	struct Buyer {
35 		address ethAddress;
36 		uint256 atTicket;
37 		uint256 amountPaid;
38 	}
39 	mapping(uint256 => Buyer) public buyers;
40 
41 	// Total buyers counter
42 	uint256 public totalBuyers = 0;
43 
44 	// Total tickets counter
45 	uint256 public totalTickets = 0;
46 
47 	// Buyer index for funds return
48 	uint256 public returnLastBuyerIndex = 0;
49 
50 	// Winner, buyers mapping key (statring from 0)
51 	uint256 public winnerKey = 0;
52 
53 	// Winner ticket number (starting from 1)
54 	uint256 public winnerTicket = 0;
55 
56 	// Sale states
57 	enum States { Started, NoEntry, Failed, Succeeded }
58 	States public saleState = States.Started;
59 
60 	/*
61 		Constructor
62 	*/
63 
64 	// Saving the contract statics
65 	function Dextera(address _seller, uint256 _ticketPrice, uint256 _minimumTickets, uint256 _creatorFeePercent, uint256 _saleDays) public {
66 		// Saving the sellers address
67 		seller = _seller;
68 
69 		// Set the 1 ticket price
70 		ticketPrice = _ticketPrice;
71 
72 		// Set minimum tickets for a successful sale
73 		minimumTickets = _minimumTickets;
74 
75 		// Set the creator fee
76 		creatorFeePercent = _creatorFeePercent;
77 
78 		// Set the sale end datetime
79  		saleEndTime = now + _saleDays * 1 days;
80   }
81 
82 	/*
83 		Modifiers
84 	*/
85 
86 	// Only creator
87 	modifier onlyCreator() {
88 		require(msg.sender == creator);
89 		_;
90 	}
91 
92 	// State checker
93 	modifier inState(States _state) {
94 		require(saleState == _state);
95 		_;
96 	}
97 
98 	/*
99 		Participation
100 	*/
101 
102 	// Fallback function (simple funds transfer)
103 	function() public payable {
104 		// Buy a ticket, only if the sell is running
105 		if (saleState == States.Started) {
106 			// Is the amount enough?
107 			require(msg.value >= ticketPrice);
108 
109 			// How many tickets we can buy?
110 			uint256 _ticketsBought = 1;
111 			if (msg.value > ticketPrice) {
112 				_ticketsBought = msg.value / ticketPrice;
113 			}
114 
115 			// Do we have enough tickets for this sale?
116 			require(minimumTickets - totalTickets >= _ticketsBought);
117 
118 			// Increment the quantity of tickets sold
119 			totalTickets = totalTickets + _ticketsBought;
120 
121 			// Save the buyer
122 			buyers[totalBuyers] = Buyer(msg.sender, totalTickets, msg.value);
123 
124 			// Save the new buyers counter
125 			totalBuyers = totalBuyers + 1;
126 
127 			// We sold all the tickets?
128 			if (totalTickets >= minimumTickets) {
129 				finalSuccess();
130 			}
131 
132 		// Protection, unblock funds by the winner, only after sell was closed
133 		} else if (saleState == States.NoEntry) {
134 			// Only winner
135 			require(msg.sender == buyers[winnerKey].ethAddress);
136 
137 			// Check if there is enough balance
138 			require(this.balance > 0);
139 
140 			// Amount should be zero
141 			require(msg.value == 0);
142 
143 			// Setting the state of the sale
144 			saleState = States.Succeeded;
145 
146 			// Send fee percent amount to us
147 			uint256 _creatorFee = (this.balance * creatorFeePercent / 100);
148 			creator.send(_creatorFee);
149 
150 			// Another amount to the seller
151 			seller.send(this.balance);
152 
153 		// Not allowed to send call
154 		} else {
155 			require(false);
156 		}
157 	}
158 
159 	/*
160 		Completion
161 	*/
162 
163 	// Not enough tickets sold within timeframe, the sale failed
164 	function saleFinalize() public inState(States.Started) {
165 		// Is it the time?
166 		require(now >= saleEndTime);
167 
168 		// Set new sale state
169 		saleState = States.Failed;
170 
171 		// Return all the funds to the buyers
172 		returnToBuyers();
173 	}
174 
175 	// Complete, success
176 	function finalSuccess() private {
177 		// Set the datetime of a successful processing
178 		successfulTime = now;
179 
180 		// Set new sale state
181 		saleState = States.NoEntry;
182 
183 		// Select the winning ticket number
184 		winnerTicket = getRand(totalTickets) + 1;
185 
186 		// Get the winner address
187 		winnerKey = getWinnerKey();
188 	}
189 
190 	/*
191 		Sale protection
192 	*/
193 
194 	// Protection, return funds after the timeout if the winner did not unblocked the funds
195 	function revertFunds() public inState(States.NoEntry) {
196 		// Is it the time?
197 		require(now >= successfulTime + 30 * 1 days);
198 
199 		// Setting the state of the sale
200 		saleState = States.Failed;
201 
202 		// Return all the funds to the buyers
203 		returnToBuyers();
204 	}
205 
206 	// Continue to return funds in case the process was interrupted
207 	function returnToBuyersContinue() public inState(States.Failed) {
208 		// We didn't finished the refund yet
209 		require(returnLastBuyerIndex < totalBuyers);
210 
211 		// Start the return process
212 		returnToBuyers();
213 	}
214 
215 	/*
216 		System
217 	*/
218 
219 	// In case of emergeny, pull the lever
220 	function pullTheLever() public onlyCreator {
221 		// Destruct the contract
222 		selfdestruct(creator);
223 	}
224 
225 	// Pseudo random function, from 0 to _max (exclusive)
226 	function getRand(uint256 _max) private view returns(uint256) {
227 		return (uint256(keccak256(block.difficulty, block.coinbase, now, block.blockhash(block.number - 1))) % _max);
228 	}
229 
230 	// Get winner account
231 	function getWinnerAccount() public view returns(address) {
232 		// There should be a winner ticket selected
233 		require(winnerTicket > 0);
234 
235 		// Return the winners address
236 		return buyers[winnerKey].ethAddress;
237 	}
238 
239 	// Return all the funds to the buyers
240 	function returnToBuyers() private {
241 		// Check if there is enough balance
242 		if (this.balance > 0) {
243 			// Sending funds back (with a gas limiter check)
244 			uint256 _i = returnLastBuyerIndex;
245 
246 			while (_i < totalBuyers && msg.gas > 200000) {
247 				buyers[_i].ethAddress.send(buyers[_i].amountPaid);
248 				_i++;
249 			}
250 			returnLastBuyerIndex = _i;
251 		}
252 	}
253 
254 	// Get the winner key for a winner ticket
255 	function getWinnerKey() private view returns(uint256) {
256 		// Reset the variables
257 		uint256 _i = 0;
258 		uint256 _j = totalBuyers - 1;
259 		uint256 _n = 0;
260 
261 		// Let's search who bought this ticket
262 		do {
263 			// Buyer found in a lower limiter
264 			if (buyers[_i].atTicket >= winnerTicket) {
265 				return _i;
266 
267 			// Buyer found in a higher limiter
268 			} else if (buyers[_j].atTicket <= winnerTicket) {
269 				return _j;
270 
271 			// Only two elements left, get the biggest
272 			} else if ((_j - _i + 1) == 2) {
273 				return _j;
274 			}
275 
276 			// Split the mapping into halves
277 			_n = ((_j - _i) / 2) + _i;
278 
279 			// The ticket is in the right part
280 			if (buyers[_n].atTicket <= winnerTicket) {
281 				_i = _n;
282 
283 			// The ticket is in the left part
284 			} else {
285 				_j = _n;
286 			}
287 
288 		} while(true);
289 	}
290 }