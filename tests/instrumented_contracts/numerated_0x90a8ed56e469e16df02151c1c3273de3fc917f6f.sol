1 contract aEthereumlotteryNet {
2 	/*
3 		aEthereumlotteryNet
4 		Coded by: iFA
5 		http://a.ethereumlottery.net
6 		ver: 1.0.1
7 	*/
8 	address private owner;
9 	uint private collectedFee;
10 	bool public contractEnabled = true;
11 	uint public ticketPrice = 1 finney; // 0.01 ether
12 	uint private feeP = 5; // 5 %
13 	uint private drawDelay = 7 days;
14 	uint private drawAtLeastTicketCount = 10000;
15 	uint private drawAtLeastPlayerCount = 10;
16 	uint private placeMultiple  =  10000;
17 	uint private place1P    	= 600063; // 60.0063 %
18 	uint private place2P    	= 240025; // 24.0025 %
19 	uint private place3P    	=  96010; //  9.6010 %
20 	uint private place4P    	=  38404; //  3.8404 %
21 	uint private place5P    	=  15362; //  1.5362 %
22 	uint private place6P    	=   6145; //  0.6145 %
23 	uint private place7P    	=   2458; //  0.2458 %
24 	uint private place8P    	=    983; //  0.0983 %
25 	uint private place9P    	=    393; //  0.0393 %
26 	uint private place10P       =    157; //  0.0157 %
27 	
28 	uint private constant prepareBlockDelay = 5;
29 	
30 	enum drawStatus_ { Wait, Prepared ,Done }
31 	
32 	struct players_s {
33 		address addr;
34 		uint ticketCount;
35 	}
36 	struct game_s {
37 		players_s[] players;
38 		uint startDate;
39 		uint endDate;
40 		uint totalTickets;
41 		uint prepareDrawBlock;
42 		drawStatus_ drawStatus;
43 	}
44 	game_s private game;
45 	
46 	mapping (address => uint) public balances;
47 	
48 	string constant public Information = "http://a.ethereumlottery.net";
49 	
50 	function Details() constant returns(uint start, uint end, uint tickets, uint players) {
51 		start = game.startDate;
52 		end = game.endDate;
53 		tickets = game.totalTickets;
54 		players = game.players.length;
55 	}
56 	function Prizes() constant returns(bool estimated, uint place1, uint place2, uint place3, 
57 	uint place4, uint place5, uint place6, uint place7, uint place8, uint place9, uint place10) {
58 		uint pot;
59 		if (game.totalTickets < drawAtLeastTicketCount) {
60 			estimated = true;
61 			pot = drawAtLeastTicketCount*ticketPrice*(100-feeP)/100;
62 		} else {
63 			estimated = false;
64 			pot = game.totalTickets*ticketPrice*(100-feeP)/100;
65 		}
66 		place1 = pot*place1P/placeMultiple/100;
67 		place2 = pot*place2P/placeMultiple/100;
68 		place3 = pot*place3P/placeMultiple/100;
69 		place4 = pot*place4P/placeMultiple/100;
70 		place5 = pot*place5P/placeMultiple/100;
71 		place6 = pot*place6P/placeMultiple/100;
72 		place7 = pot*place7P/placeMultiple/100;
73 		place8 = pot*place8P/placeMultiple/100;
74 		place9 = pot*place9P/placeMultiple/100;
75 		place10 = pot*place10P/placeMultiple/100;
76 	}
77 	function aEthereumlotteryNet() {
78 		owner = msg.sender;
79 		createNewDraw();
80 	}
81 	function () {
82 		BuyTickets();
83 	}
84 	function BuyTickets() OnlyInTime OnlyWhileWait onValidContract {
85 		if (msg.value < ticketPrice) { throw; }
86 		uint ticketsCount = msg.value / ticketPrice;
87 		if (game.totalTickets+ticketsCount >= 255**4) { throw; }
88 		if (msg.value > (ticketsCount * ticketPrice)) { if (msg.sender.send(msg.value - (ticketsCount * ticketPrice)) == false) { throw; } }
89 		game.totalTickets += ticketsCount;
90 		uint a;
91 		uint playersid = game.players.length;
92 		for ( a = 0 ; a < playersid ; a++ ) {
93 			if (game.players[a].addr == msg.sender) {
94 				game.players[a].ticketCount += ticketsCount;
95 				return;
96 			}
97 		}
98 		game.players.length += 1;
99 		game.players[playersid].addr = msg.sender;
100 		game.players[playersid].ticketCount = ticketsCount;
101 	}
102 	function PrepareDraw() external ReadyForPrepare onValidContract {
103 	    reFund();
104 		if (game.players.length < drawAtLeastPlayerCount && game.totalTickets < drawAtLeastTicketCount) {
105 			game.endDate = calcNextDrawTime();
106 		} else {
107 			game.prepareDrawBlock = block.number + prepareBlockDelay;
108 			game.drawStatus = drawStatus_.Prepared;
109 		}
110 	}
111 	event announceWinner(address addr,uint prize);
112 	function Draw() external OnlyWhilePrepared ReadyForDraw onValidContract {
113 	    reFund();
114 		bytes32 WinHash = makeHash();
115 		uint a;
116 		uint b;
117 		uint c;
118 		uint d;
119 		uint e;
120 		uint num;
121 		address[10] memory winners;
122 		bool next;
123 		for ( a = 0 ; a < 10 ; a++ ) {
124 			while (true) {
125 				next = true;
126 				if (b == 8) {
127 					WinHash = sha3(WinHash);
128 					b = 0;
129 				}
130 				num = getNum(WinHash,b) % game.totalTickets;
131 				d = 0;
132 				for ( c = 0 ; c < game.players.length ; c++ ) {
133 					d += game.players[c].ticketCount;
134 					if (d >= num) {
135 						for ( e = 0 ; e < 10 ; e++ ){
136 							if (game.players[c].addr == winners[e]) {
137 								next = false;
138 								break;
139 							}
140 						}
141 						if (next == true) {
142 							winners[a] = game.players[c].addr;
143 							break;
144 						}
145 					}
146 				}
147 				b++;
148 				if (next == true) { break; }
149 			}
150 		}
151 		uint fee = game.totalTickets * ticketPrice * feeP / 100;
152 		uint pot = game.totalTickets * ticketPrice - fee;
153 		collectedFee += fee;
154 		balances[winners[0]] += pot * place1P / placeMultiple / 100;
155 		balances[winners[1]] += pot * place2P / placeMultiple / 100;
156 		balances[winners[2]] += pot * place3P / placeMultiple / 100;
157 		balances[winners[3]] += pot * place4P / placeMultiple / 100;
158 		balances[winners[4]] += pot * place5P / placeMultiple / 100;
159 		balances[winners[5]] += pot * place6P / placeMultiple / 100;
160 		balances[winners[6]] += pot * place7P / placeMultiple / 100;
161 		balances[winners[7]] += pot * place8P / placeMultiple / 100;
162 		balances[winners[8]] += pot * place9P / placeMultiple / 100;
163 		balances[winners[9]] += pot * place10P / placeMultiple / 100;
164 		announceWinner(winners[0],balances[winners[0]]);
165 		announceWinner(winners[1],balances[winners[1]]);
166 		announceWinner(winners[2],balances[winners[2]]);
167 		announceWinner(winners[3],balances[winners[3]]);
168 		announceWinner(winners[4],balances[winners[4]]);
169 		announceWinner(winners[5],balances[winners[5]]);
170 		announceWinner(winners[6],balances[winners[6]]);
171 		announceWinner(winners[7],balances[winners[7]]);
172 		announceWinner(winners[8],balances[winners[8]]);
173 		announceWinner(winners[9],balances[winners[9]]);
174 		if (contractEnabled == true) {
175 			createNewDraw();
176 		} else {
177 			game.drawStatus = drawStatus_.Done;
178 		}
179 	}
180 	function GetPrize() external {
181 	    reFund();
182 	    if (contractEnabled) { 
183             if (balances[msg.sender] == 0) { throw; }
184         	if (msg.sender.send(balances[msg.sender]) == false) { throw; }
185         	balances[msg.sender] = 0;
186 	    } else {
187             for ( uint a = 0 ; a < game.players.length ; a++ ) {
188     			if (game.players[a].addr == msg.sender) {
189     			    if (game.players[a].ticketCount > 0) {
190     			        if ( ! msg.sender.send(game.players[a].ticketCount * ticketPrice)) { throw; }
191     			        game.totalTickets -= game.players[a].ticketCount;
192     			        delete game.players[a];
193     			    } else {
194     			        throw;
195     			    }
196     			}
197     		}
198 	    }
199 	}
200 	function OwnerGetFee() external OnlyOwner {
201 	    reFund();
202 		if (owner.send(collectedFee) == false) { throw; }
203 		collectedFee = 0;
204 	}
205 	function OwnerCloseContract() external OnlyOwner {
206 	    reFund();
207 	    if (!contractEnabled) { throw; }
208 		contractEnabled = false;
209 	}
210 	function createNewDraw() private {
211 		game.startDate = now;
212 		game.endDate = calcNextDrawTime();
213 		game.players.length = 0;
214 		game.totalTickets = 0;
215 		game.prepareDrawBlock = 0;
216 		game.drawStatus = drawStatus_.Wait;
217 	}
218 	function calcNextDrawTime() private returns (uint ret) {
219 		ret = 1461499200; // 2016.04.24 12:00:00
220 		while (ret < now) {
221 			ret += drawDelay;
222 		}
223 	}
224 	function makeHash() private returns (bytes32 hash) {
225 		for ( uint a = 0 ; a <= prepareBlockDelay ; a++ ) {
226 			hash = sha3(hash, block.blockhash(game.prepareDrawBlock - prepareBlockDelay + a));
227 		}
228 		hash = sha3(hash, game.players.length, game.totalTickets);
229 	}
230 	function reFund() private { if (msg.value > 0) { if (msg.sender.send(msg.value) == false) { throw; } } }
231 	function getNum(bytes32 a, uint i) private returns (uint) { return uint32(bytes4(bytes32(uint(a) * 2 ** (8 * (i*4))))); }
232 	modifier onValidContract() { if (!contractEnabled) { throw; } _ }
233 	modifier OnlyInTime() { if (game.endDate < now) { throw; } _ }
234 	modifier OnlyWhileWait() { if (game.drawStatus != drawStatus_.Wait) { throw; } _ }
235 	modifier OnlyWhilePrepared() { if (game.drawStatus != drawStatus_.Prepared) { throw; } _ }
236 	modifier ReadyForPrepare() { if (game.endDate > now || game.drawStatus != drawStatus_.Wait) { throw; } _ }
237 	modifier ReadyForDraw() { if (game.prepareDrawBlock > block.number) { throw; } _ }
238 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
239 }