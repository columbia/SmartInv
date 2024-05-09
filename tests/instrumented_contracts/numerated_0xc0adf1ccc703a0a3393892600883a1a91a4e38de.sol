1 pragma solidity ^0.4.13;
2 
3 contract BTCRelay {
4     function getLastBlockHeight() returns (int);
5     function getBlockchainHead() returns (int);
6     function getFeeAmount(int blockHash) returns (int);
7     function getBlockHeader(int blockHash) returns (bytes32[3]);
8 }
9 
10 contract PoissonData {
11     function lookup(int blocks) constant returns (uint);
12 }
13 
14 contract Escrow {
15     function deposit(address recipient) payable;
16 }
17 
18 contract EthereumLottery {
19     uint constant INACTIVITY_TIMEOUT = 2 weeks;
20     uint constant GAS_LIMIT = 300000;
21 
22     struct Lottery {
23         uint jackpot;
24         int decidingBlock;
25         uint numTickets;
26         uint numTicketsSold;
27         uint ticketPrice;
28         uint cutoffTimestamp;
29         int winningTicket;
30         address winner;
31         uint finalizationBlock;
32         address finalizer;
33         string message;
34         mapping (uint => address) tickets;
35         int nearestKnownBlock;
36         int nearestKnownBlockHash;
37     }
38 
39     address public owner;
40     address public admin;
41     address public proposedOwner;
42 
43     int public id = -1;
44     uint public lastInitTimestamp;
45     uint public lastSaleTimestamp;
46 
47     uint public recentActivityIdx;
48     uint[1000] public recentActivity;
49 
50     mapping (int => Lottery) public lotteries;
51 
52     address public btcRelay;
53     address public poissonData;
54     address public escrow;
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     modifier onlyAdminOrOwner {
62         require(msg.sender == owner || msg.sender == admin);
63         _;
64     }
65 
66     modifier afterInitialization {
67         require(id >= 0);
68         _;
69     }
70 
71     function EthereumLottery(address _btcRelay,
72                              address _poissonData,
73                              address _escrow) {
74         owner = msg.sender;
75         admin = msg.sender;
76         btcRelay = _btcRelay;
77         poissonData = _poissonData;
78         escrow = _escrow;
79     }
80 
81     function needsInitialization() constant returns (bool) {
82         return id == -1 || lotteries[id].finalizationBlock > 0;
83     }
84 
85     function initLottery(uint _jackpot, uint _numTickets,
86                          uint _ticketPrice, int _durationInBlocks)
87              payable onlyAdminOrOwner {
88         require(needsInitialization());
89         require(msg.value > 0);
90         require(msg.value == _jackpot);
91         require(_numTickets * _ticketPrice > _jackpot);
92 
93         // Look up precomputed timespan in seconds where the
94         // probability for n or more blocks occuring within
95         // that timespan is just 1 %. This is based on
96         // assuming an actual block time of 9 minutes. We
97         // can use this data to figure out for how long it
98         // is safe to keep selling tickets.
99         uint ticketSaleDuration =
100             PoissonData(poissonData).lookup(_durationInBlocks - 1);
101         require(ticketSaleDuration > 0);
102 
103         id += 1;
104         lotteries[id].jackpot = _jackpot;
105         lotteries[id].decidingBlock =
106             BTCRelay(btcRelay).getLastBlockHeight() + _durationInBlocks;
107         lotteries[id].numTickets = _numTickets;
108         lotteries[id].ticketPrice = _ticketPrice;
109         lotteries[id].cutoffTimestamp = now + ticketSaleDuration;
110         lotteries[id].winningTicket = -1;
111 
112         lastInitTimestamp = now;
113     }
114 
115     function buyTickets(uint[] _tickets)
116              payable afterInitialization {
117         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
118         require(blockHeight + 1 < lotteries[id].decidingBlock);
119         require(now < lotteries[id].cutoffTimestamp);
120 
121         require(_tickets.length > 0);
122         require(msg.value == _tickets.length * lotteries[id].ticketPrice);
123 
124         for (uint i = 0; i < _tickets.length; i++) {
125             uint ticket = _tickets[i];
126             require(ticket >= 0);
127             require(ticket < lotteries[id].numTickets);
128             require(lotteries[id].tickets[ticket] == 0);
129 
130             lotteries[id].tickets[ticket] = msg.sender;
131             recentActivity[recentActivityIdx] = ticket;
132 
133             recentActivityIdx += 1;
134             if (recentActivityIdx >= recentActivity.length) {
135                 recentActivityIdx = 0;
136             }
137         }
138         lotteries[id].numTicketsSold += _tickets.length;
139         lastSaleTimestamp = now;
140 
141         // Maybe shorten ticket sale timespan if we are running ahead.
142         int remainingDurationInBlocks =
143             lotteries[id].decidingBlock - blockHeight;
144         uint ticketSaleDuration =
145             PoissonData(poissonData).lookup(remainingDurationInBlocks - 1);
146         if (now + ticketSaleDuration < lotteries[id].cutoffTimestamp) {
147             lotteries[id].cutoffTimestamp = now + ticketSaleDuration;
148         }
149     }
150 
151     function needsFinalization()
152              afterInitialization constant returns (bool) {
153         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
154         return blockHeight >= lotteries[id].decidingBlock + 6 &&
155                lotteries[id].finalizationBlock == 0;
156     }
157 
158     function finalizeLottery(uint _steps)
159              afterInitialization {
160         require(needsFinalization());
161 
162         if (lotteries[id].nearestKnownBlock != lotteries[id].decidingBlock) {
163             walkTowardsBlock(_steps);
164         } else {
165             int winningTicket = lotteries[id].nearestKnownBlockHash %
166                                 int(lotteries[id].numTickets);
167             address winner = lotteries[id].tickets[uint(winningTicket)];
168 
169             lotteries[id].winningTicket = winningTicket;
170             lotteries[id].winner = winner;
171             lotteries[id].finalizationBlock = block.number;
172             lotteries[id].finalizer = tx.origin;
173 
174             if (winner != 0) {
175                 uint value = lotteries[id].jackpot;
176                 bool successful = winner.call.gas(GAS_LIMIT).value(value)();
177                 if (!successful) {
178                     Escrow(escrow).deposit.value(value)(winner);
179                 }
180             }
181 
182             var _ = admin.call.gas(GAS_LIMIT).value(this.balance)();
183         }
184     }
185 
186     function walkTowardsBlock(uint _steps) internal {
187         int blockHeight;
188         int blockHash;
189         if (lotteries[id].nearestKnownBlock == 0) {
190             blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
191             blockHash = BTCRelay(btcRelay).getBlockchainHead();
192         } else {
193             blockHeight = lotteries[id].nearestKnownBlock;
194             blockHash = lotteries[id].nearestKnownBlockHash;
195         }
196 
197         // Walk only a few steps to keep an upper limit on gas costs.
198         for (uint step = 0; step < _steps; step++) {
199             // We expect free access to BTCRelay.
200             int fee = BTCRelay(btcRelay).getFeeAmount(blockHash);
201             require(fee == 0);
202 
203             bytes32 blockHeader =
204                 BTCRelay(btcRelay).getBlockHeader(blockHash)[2];
205             bytes32 temp;
206 
207             assembly {
208                 let x := mload(0x40)
209                 mstore(x, blockHeader)
210                 temp := mload(add(x, 0x04))
211             }
212 
213             blockHeight -= 1;
214             blockHash = 0;
215             for (uint i = 0; i < 32; i++) {
216                 blockHash = blockHash | int(temp[uint(i)]) * int(256 ** i);
217             }
218 
219             if (blockHeight == lotteries[id].decidingBlock) { break; }
220         }
221 
222         // Store the progress to pick up from there next time.
223         lotteries[id].nearestKnownBlock = blockHeight;
224         lotteries[id].nearestKnownBlockHash = blockHash;
225     }
226 
227     function getMessageLength(string _message) constant returns (uint) {
228         return bytes(_message).length;
229     }
230 
231     function setMessage(int _id, string _message)
232              afterInitialization {
233         require(lotteries[_id].winner != 0);
234         require(lotteries[_id].winner == msg.sender);
235         require(getMessageLength(_message) <= 500);
236         lotteries[_id].message = _message;
237     }
238 
239     function getLotteryDetailsA(int _id)
240              constant returns (int _actualId, uint _jackpot,
241                                int _decidingBlock,
242                                uint _numTickets, uint _numTicketsSold,
243                                uint _lastSaleTimestamp, uint _ticketPrice,
244                                uint _cutoffTimestamp) {
245         if (_id == -1) {
246             _actualId = id;
247         } else {
248             _actualId = _id;
249         }
250         _jackpot = lotteries[_actualId].jackpot;
251         _decidingBlock = lotteries[_actualId].decidingBlock;
252         _numTickets = lotteries[_actualId].numTickets;
253         _numTicketsSold = lotteries[_actualId].numTicketsSold;
254         _lastSaleTimestamp = lastSaleTimestamp;
255         _ticketPrice = lotteries[_actualId].ticketPrice;
256         _cutoffTimestamp = lotteries[_actualId].cutoffTimestamp;
257     }
258 
259     function getLotteryDetailsB(int _id)
260              constant returns (int _actualId,
261                                int _winningTicket, address _winner,
262                                uint _finalizationBlock, address _finalizer,
263                                string _message,
264                                int _prevLottery, int _nextLottery,
265                                int _blockHeight) {
266         if (_id == -1) {
267             _actualId = id;
268         } else {
269             _actualId = _id;
270         }
271         _winningTicket = lotteries[_actualId].winningTicket;
272         _winner = lotteries[_actualId].winner;
273         _finalizationBlock = lotteries[_actualId].finalizationBlock;
274         _finalizer = lotteries[_actualId].finalizer;
275         _message = lotteries[_actualId].message;
276 
277         if (_actualId == 0) {
278             _prevLottery = -1;
279         } else {
280             _prevLottery = _actualId - 1;
281         }
282         if (_actualId == id) {
283             _nextLottery = -1;
284         } else {
285             _nextLottery = _actualId + 1;
286         }
287 
288         _blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
289     }
290 
291     function getTicketDetails(int _id, uint _offset, uint _n, address _addr)
292              constant returns (uint8[] details) {
293         require(_offset + _n <= lotteries[_id].numTickets);
294 
295         details = new uint8[](_n);
296         for (uint i = 0; i < _n; i++) {
297             address addr = lotteries[_id].tickets[_offset + i];
298             if (addr == _addr && _addr != 0) {
299                 details[i] = 2;
300             } else if (addr != 0) {
301                 details[i] = 1;
302             } else {
303                 details[i] = 0;
304             }
305         }
306     }
307 
308 
309     function getTicketOwner(int _id, uint _ticket) constant returns (address) {
310         require(_id >= 0);
311         return lotteries[_id].tickets[_ticket];
312     }
313 
314     function getRecentActivity()
315              constant returns (int _id, uint _idx, uint[1000] _recentActivity) {
316         _id = id;
317         _idx = recentActivityIdx;
318         for (uint i = 0; i < recentActivity.length; i++) {
319             _recentActivity[i] = recentActivity[i];
320         }
321     }
322 
323     function setAdmin(address _admin) onlyOwner {
324         admin = _admin;
325     }
326 
327     function proposeOwner(address _owner) onlyOwner {
328         proposedOwner = _owner;
329     }
330 
331     function acceptOwnership() {
332         require(proposedOwner != 0);
333         require(msg.sender == proposedOwner);
334         owner = proposedOwner;
335     }
336 
337     function destruct() onlyOwner {
338         require(now - lastInitTimestamp > INACTIVITY_TIMEOUT);
339         selfdestruct(owner);
340     }
341 }