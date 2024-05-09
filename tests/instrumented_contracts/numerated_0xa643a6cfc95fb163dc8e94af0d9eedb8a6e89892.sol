1 contract cEthereumlotteryNet {
2 	/*
3 		cEthereumlotteryNet
4 		Coded by: iFA
5 		http://c.ethereumlottery.net
6 		ver: 2.0.0
7 	*/
8 	address owner;
9 	bool private contractEnabled = true;
10 	uint public constant ticketPrice = 10 finney;
11 	uint private constant defaultJackpot = 100 ether;
12 	uint private constant feep = 23;
13 	uint private constant hit3p = 35;
14 	uint private constant hit4p = 25;
15 	uint private constant hit5p = 40;
16 	uint8 private constant maxNumber = 30;
17 	uint private constant drawCheckStep = 100;
18 	uint private constant prepareBlockDelay = 5;
19 	uint private drawDelay = 7 days;
20 	uint private feeValue;
21 
22 	struct hits_s {
23 		uint prize;
24 		uint count;
25 	}
26 	
27 	enum drawStatus_ { Wait, Prepared ,InProcess, Done }
28 	
29 	struct tickets_s {
30 		uint hits;
31 		bytes5 numbers;
32 	}
33 	
34 	struct games_s {
35 		uint startTime;
36 		uint endTime;
37 		uint jackpot;
38 		uint8[5] winningNumbers;
39 		mapping (uint => hits_s) hits;
40 		uint prizePot;
41 		drawStatus_ drawStatus;
42 		bytes32 winHash;
43 		mapping (uint => tickets_s) tickets;
44 		uint ticketsCount;
45 		uint checkedTickets;
46 		bytes32 nextHashOfSecretKey;
47 		uint prepareDrawBlock;
48 	}
49 	
50 	mapping(uint => games_s) private games;
51 	
52 	uint public CurrentGameId = 0;
53 	
54 	struct player_s {
55 		bool paid;
56 		uint[] tickets;
57 	}
58 	
59 	mapping(address => mapping(uint => player_s)) private players;
60 	uint private playersSize;
61 	
62 	string constant public Information = "http://c.ethereumlottery.net";
63 	
64 	function ContractStatus() constant returns (bool Enabled) {
65 		Enabled = contractEnabled;
66 	}
67 	function GameDetails(uint GameId) constant returns ( uint StartTime, uint EndTime, uint Jackpot, uint TicketsCount) {
68 		Jackpot = games[GameId].jackpot;
69 		TicketsCount = games[GameId].ticketsCount;
70 		StartTime = games[GameId].startTime;
71 		EndTime = games[GameId].endTime;
72 	}
73 	function DrawDetails(uint GameId) constant returns (
74 		string DrawStatus, bytes32 WinHash, uint8[5] WinningNumbers,
75 		uint Hit3Count, uint Hit4Count, uint Hit5Count,
76 		uint Hit3Prize, uint Hit4Prize, uint Hit5Prize) {
77 		DrawStatus = WritedrawStatus(games[GameId].drawStatus);
78 		if (games[GameId].drawStatus != drawStatus_.Wait) {
79 			WinningNumbers = games[GameId].winningNumbers;
80 			Hit3Count = games[GameId].hits[3].count;
81 			Hit4Count = games[GameId].hits[4].count;
82 			Hit5Count = games[GameId].hits[5].count;
83 			Hit3Prize = games[GameId].hits[3].prize;
84 			Hit4Prize = games[GameId].hits[4].prize;
85 			Hit5Prize = games[GameId].hits[5].prize;
86 			WinHash = games[GameId].winHash;
87 		} else {
88 			WinningNumbers = [0,0,0,0,0];
89 			Hit3Count = 0;
90 			Hit4Count = 0;
91 			Hit5Count = 0;
92 			Hit3Prize = 0;
93 			Hit4Prize = 0;
94 			Hit5Prize = 0;
95 			WinHash = 0;
96 		}
97 	}
98 	function CheckTickets(address Address,uint GameId,uint TicketNumber) constant returns (uint8[5] Numbers, uint Hits, bool Paid) {
99 		if (players[Address][GameId].tickets[TicketNumber] > 0) {
100 			Numbers[0] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) /256/256/256/256);
101 			Numbers[1] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) /256/256/256);
102 			Numbers[2] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) /256/256);
103 			Numbers[3] = uint8(uint40(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers) /256);
104 			Numbers[4] = uint8(games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].numbers);
105 			Numbers = sortWinningNumbers(Numbers);
106 			Hits = games[GameId].tickets[players[Address][GameId].tickets[TicketNumber]].hits;
107 			Paid = players[Address][GameId].paid;
108 		}
109 	}
110 	function CheckPrize(address Address, uint GameId) constant returns(uint Value) {
111 		if (players[Address][GameId].paid == false) {
112 		    if (contractEnabled) { 
113     			if (games[GameId].drawStatus == drawStatus_.Done) {
114     				for (uint b = 0 ; b < players[Address][GameId].tickets.length ; b++) {
115     					if (games[GameId].tickets[players[Address][GameId].tickets[b]].hits == 3){
116     						Value += games[GameId].hits[3].prize;
117     					} else if (games[GameId].tickets[players[Address][GameId].tickets[b]].hits == 4){
118     						Value += games[GameId].hits[4].prize;
119     					} else if (games[GameId].tickets[players[Address][GameId].tickets[b]].hits == 5){
120     						Value += games[GameId].hits[5].prize;
121     					}
122     				}
123     			}
124 		    } else {
125     		    if (GameId == CurrentGameId) {
126     		        Value = players[msg.sender][GameId].tickets.length * ticketPrice;
127     		    }
128 		    }
129 		}
130 	}
131 	function cEthereumlotteryNet() {
132 		owner = msg.sender;
133 		CreateNewDraw(defaultJackpot);
134 	}
135 	function GetPrize(uint GameId) external {
136 		uint Balance;
137 		uint GameBalance;
138 		if (players[msg.sender][GameId].paid == false) {
139     		if (contractEnabled) { 
140     		    if (games[GameId].drawStatus != drawStatus_.Done) { throw; }
141         		for (uint b = 0 ; b < players[msg.sender][GameId].tickets.length ; b++) {
142         			if (games[GameId].tickets[players[msg.sender][GameId].tickets[b]].hits == 3){
143         				Balance += games[GameId].hits[3].prize;
144         			} else if (games[GameId].tickets[players[msg.sender][GameId].tickets[b]].hits == 4){
145         				Balance += games[GameId].hits[4].prize;
146         			} else if (games[GameId].tickets[players[msg.sender][GameId].tickets[b]].hits == 5){
147         				Balance += games[GameId].hits[5].prize;
148         			}
149         		}
150         		players[msg.sender][GameId].paid = true;
151         		games[GameId].prizePot -= Balance;
152     		} else {
153     		    if (GameId == CurrentGameId) {
154     		        Balance = players[msg.sender][GameId].tickets.length * ticketPrice;
155     		        players[msg.sender][GameId].paid = true;
156     		    }
157     		}
158 		}
159 		if (Balance > 0) {
160 			if (msg.sender.send(Balance) == false) { throw; }
161 		} else {
162 			throw;
163 		}
164 	}
165 	function AddTicket(bytes5[] tickets) OnlyEnabled IfInTime IfDrawWait external {
166 		uint ticketsCount = tickets.length;
167 		if (ticketsCount > 70 || ticketsCount == 0) { throw; }
168 		if (msg.value < ticketsCount * ticketPrice) { throw; }
169 		if (msg.value > (ticketsCount * ticketPrice)) { if (msg.sender.send(msg.value - (ticketsCount * ticketPrice)) == false) { throw; } }
170 		for (uint a = 0 ; a < ticketsCount ; a++) {
171 			if (!CheckNumbers(ConvertNumbers(tickets[a]))) { throw; }
172 			games[CurrentGameId].tickets[games[CurrentGameId].ticketsCount].numbers = tickets[a];
173 			players[msg.sender][CurrentGameId].tickets.length += 1;
174 			players[msg.sender][CurrentGameId].tickets[players[msg.sender][CurrentGameId].tickets.length-1] = games[CurrentGameId].ticketsCount;
175 			games[CurrentGameId].ticketsCount++;
176 		}
177 	}
178 	function () {
179 		throw;
180 	}
181 	function ProcessDraw() OnlyEnabled IfDrawProcess {
182 		uint StepCount = drawCheckStep;
183 		if (games[CurrentGameId].checkedTickets < games[CurrentGameId].ticketsCount) {
184 			for (uint a = games[CurrentGameId].checkedTickets ; a < games[CurrentGameId].ticketsCount ; a++) {
185 				if (StepCount == 0) { break; }
186 				for (uint b = 0 ; b < 5 ; b++) {
187 					for (uint c = 0 ; c < 5 ; c++) {
188 						if (uint8(uint40(games[CurrentGameId].tickets[a].numbers) / (256**b)) == games[CurrentGameId].winningNumbers[c]) {
189 							games[CurrentGameId].tickets[a].hits += 1;
190 						}
191 					}
192 				}
193 				games[CurrentGameId].checkedTickets += 1;
194 				StepCount -= 1;
195 			}
196 		}
197 		if (games[CurrentGameId].checkedTickets == games[CurrentGameId].ticketsCount) {
198 			for (a = 0 ; a < games[CurrentGameId].ticketsCount ; a++) {
199 				if (games[CurrentGameId].tickets[a].hits == 3) {
200 					games[CurrentGameId].hits[3].count +=1;
201 				} else if (games[CurrentGameId].tickets[a].hits == 4) {
202 					games[CurrentGameId].hits[4].count +=1;
203 				} else if (games[CurrentGameId].tickets[a].hits == 5) {
204 					games[CurrentGameId].hits[5].count +=1;
205 				}
206 			}
207 			if (games[CurrentGameId].hits[3].count > 0) { games[CurrentGameId].hits[3].prize = games[CurrentGameId].prizePot * hit3p / 100 / games[CurrentGameId].hits[3].count; }
208 			if (games[CurrentGameId].hits[4].count > 0) { games[CurrentGameId].hits[4].prize = games[CurrentGameId].prizePot * hit4p / 100 / games[CurrentGameId].hits[4].count; }
209 			if (games[CurrentGameId].hits[5].count > 0) { games[CurrentGameId].hits[5].prize = games[CurrentGameId].jackpot / games[CurrentGameId].hits[5].count; }
210 			uint NextJackpot;
211 			if (games[CurrentGameId].hits[5].count == 0) {
212 				NextJackpot = games[CurrentGameId].prizePot * hit5p / 100 + games[CurrentGameId].jackpot;
213 			} else {
214 				NextJackpot = defaultJackpot;
215 			}
216 			games[CurrentGameId].prizePot = (games[CurrentGameId].hits[3].count*games[CurrentGameId].hits[3].prize) + (games[CurrentGameId].hits[4].count*games[CurrentGameId].hits[4].prize) + (games[CurrentGameId].hits[5].count*games[CurrentGameId].hits[5].prize);
217 			games[CurrentGameId].drawStatus = drawStatus_.Done;
218 			CreateNewDraw(NextJackpot);
219 		}
220 	}
221 	function StartDraw() external OnlyEnabled IfDrawPrepared {
222 		if (games[CurrentGameId].prepareDrawBlock > block.number) { throw; }
223 		games[CurrentGameId].drawStatus = drawStatus_.InProcess;
224 		games[CurrentGameId].winHash = makeHash();
225 		games[CurrentGameId].winningNumbers = sortWinningNumbers(GetNumbersFromHash(games[CurrentGameId].winHash));
226 		feeValue += ticketPrice * games[CurrentGameId].ticketsCount * feep / 100;
227 		games[CurrentGameId].prizePot = ticketPrice * games[CurrentGameId].ticketsCount - feeValue;
228 		ProcessDraw();
229 	}
230 	function PrepareDraw() external OnlyEnabled ReadyForDraw {
231 		if (games[CurrentGameId].ticketsCount > 0) {
232 			games[CurrentGameId].drawStatus = drawStatus_.Prepared;
233 			games[CurrentGameId].prepareDrawBlock = block.number + prepareBlockDelay;
234 		} else {
235 			if (!contractEnabled) { throw; }
236 			games[CurrentGameId].endTime = calcNextDrawTime();
237 		}
238 	}
239 	function OwnerCloseContract() external OnlyOwner OnlyEnabled {
240 		contractEnabled = false;
241 		uint contractbalance = this.balance;
242 		for (uint a=0 ; a <= CurrentGameId ; a++) {
243 			contractbalance -= games[a].prizePot;
244 		}
245 		contractbalance -= games[CurrentGameId].ticketsCount * ticketPrice;
246 		if (contractbalance == 0 ) { throw; }
247 		if (owner.send(contractbalance) == false) { throw; }
248 		feeValue = 0;
249 	}
250 	function OwnerAddFunds() external OnlyOwner {
251 		return;
252 	}
253 	function OwnerGetFee() external OnlyOwner {
254 		if (feeValue == 0) { throw; }
255 		if (owner.send(feeValue) == false) { throw; }
256 		feeValue = 0;
257 	}
258 	function CreateNewDraw(uint Jackpot) private {
259 		CurrentGameId += 1;
260 		games[CurrentGameId].startTime = now;
261 		games[CurrentGameId].endTime = calcNextDrawTime();
262 		games[CurrentGameId].jackpot = Jackpot;
263 		games[CurrentGameId].drawStatus = drawStatus_.Wait;
264 	}
265 	function ConvertNumbers(bytes5 input) private returns (uint8[5] output){
266 		output[0] = uint8(uint40(input) /256/256/256/256);
267 		output[1] = uint8(uint40(input) /256/256/256);
268 		output[2] = uint8(uint40(input) /256/256);
269 		output[3] = uint8(uint40(input) /256);
270 		output[4] = uint8(input);
271 	}
272 	function CheckNumbers(uint8[5] tickets) private returns (bool ok) {
273 		for (uint8 a = 0 ; a < 5 ; a++) {
274 			if ((tickets[a] < 1 ) || (tickets[a] > maxNumber)) { return false; }
275 			for (uint8 b = 0 ; b < 5 ; b++) { if ((tickets[a] == tickets[b]) && (a != b)) {	return false; }	}
276 		}
277 		return true;
278 	}
279 	function GetNumbersFromHash(bytes32 hash) private returns (uint8[5] tickets) {
280 		bool ok = true;
281 		uint8 num = 0;
282 		uint hashpos = 0;
283 		uint8 a;
284 		for (a = 0 ; a < 5 ; a++) {
285 			while (true) {
286 				ok = true;
287 				if (hashpos == 32) {
288 					hashpos = 0;
289 					hash = sha3(hash);
290 				}
291 				num = GetPart(hash,hashpos);
292 				num = num%maxNumber+1;
293 				hashpos += 1;
294 				for (uint8 b = 0 ; b < 5 ; b++) {
295 					if (tickets[b] == num) {
296 						ok = false;
297 						break; 
298 					}
299 				}
300 				if (ok == true) {
301 					tickets[a] = num;
302 					break;
303 				}
304 			}
305 		}
306 	}
307 	function GetPart(bytes32 a, uint i) private returns (uint8) { return uint8(byte(bytes32(uint(a) * 2 ** (8 * i)))); }
308 	function WritedrawStatus(drawStatus_ input) private returns (string drawStatus) {
309 		if (input == drawStatus_.Wait) {
310 			drawStatus = "Wait";
311 		} else if (input == drawStatus_.InProcess) {
312 			drawStatus = "In Process";
313 		} else if (input == drawStatus_.Done) {
314 			drawStatus = "Done";
315 		} else if (input == drawStatus_.Prepared) {
316 			drawStatus = "Prepared";
317 		}
318 	}
319 	function sortWinningNumbers(uint8[5] numbers) private returns(uint8[5] sortednumbers) {
320 		sortednumbers = numbers;
321 		for (uint8 i=0; i<5; i++) {
322 			for (uint8 j=i+1; j<5; j++) {
323 				if (sortednumbers[i] > sortednumbers[j]) {
324 					uint8 t = sortednumbers[i];
325 					sortednumbers[i] = sortednumbers[j];
326 					sortednumbers[j] = t;
327 				}
328 			}
329 		}
330 	}
331 	function makeHash() private returns (bytes32 hash) {
332 		for ( uint a = 0 ; a <= prepareBlockDelay ; a++ ) {
333 			hash = sha3(hash, games[CurrentGameId].prepareDrawBlock - a);
334 		}
335 		hash = sha3(hash, block.difficulty, block.coinbase, block.timestamp, tx.origin, games[CurrentGameId].ticketsCount);
336 	}
337 	function calcNextDrawTime() private returns (uint ret) {
338 		ret = 1461499200; // 2016.04.24 12:00:00
339 		while (ret < now) {
340 			ret += drawDelay;
341 		}
342 	}
343 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
344 	modifier OnlyEnabled() { if (!contractEnabled) { throw; } _	}
345 	modifier IfDrawWait() { if (games[CurrentGameId].drawStatus != drawStatus_.Wait) { throw; } _	}
346 	modifier IfDrawPrepared() { if (games[CurrentGameId].drawStatus != drawStatus_.Prepared) { throw; } _	}
347 	modifier IfDrawProcess() { if (games[CurrentGameId].drawStatus != drawStatus_.InProcess) { throw; } _	}
348 	modifier IfInTime() { if (games[CurrentGameId].endTime < now) { throw; } _ }
349 	modifier ReadyForDraw() { if (games[CurrentGameId].endTime > now || games[CurrentGameId].drawStatus != drawStatus_.Wait) { throw; } _ }
350 }