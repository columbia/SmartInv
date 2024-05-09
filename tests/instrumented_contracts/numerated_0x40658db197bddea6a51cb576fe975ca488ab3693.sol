1 pragma solidity ^0.4.15;
2 
3 contract BTCRelay {
4     function getLastBlockHeight() public returns (int);
5     function getBlockchainHead() public returns (int);
6     function getFeeAmount(int blockHash) public returns (int);
7     function getBlockHeader(int blockHash) public returns (bytes32[5]);
8     function storeBlockHeader(bytes blockHeader) public returns (int);
9 }
10 
11 contract Escrow {
12     function deposit(address recipient) payable;
13 }
14 
15 contract AffiliateNetwork {
16     function affiliateAddresses(uint code) returns (address);
17 }
18 
19 contract EthereumLottery {
20     uint constant GAS_LIMIT_DEPOSIT = 300000;
21     uint constant GAS_LIMIT_AFFILIATE = 35000;
22 
23     struct Lottery {
24         uint jackpot;
25         int decidingBlock;
26         uint numTickets;
27         uint numTicketsSold;
28         uint ticketPrice;
29         uint affiliateCut;
30         int winningTicket;
31         address winner;
32         uint finalizationBlock;
33         address finalizer;
34         string message;
35         mapping (uint => address) tickets;
36         int nearestKnownBlock;
37         int nearestKnownBlockHash;
38     }
39 
40     address public owner;
41     address public admin;
42     address public proposedOwner;
43 
44     int public id = -1;
45     uint public lastInitTimestamp;
46     uint public lastSaleTimestamp;
47 
48     uint public recentActivityIdx;
49     uint[1000] public recentActivity;
50 
51     mapping (int => Lottery) public lotteries;
52 
53     address public btcRelay;
54     address public escrow;
55     address public affiliateNetwork;
56 
57     enum Reason { TicketSaleClosed, TicketAlreadySold }
58     event PurchaseFailed(address indexed buyer, uint mark, Reason reason);
59     event PurchaseSuccessful(address indexed buyer, uint mark);
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     modifier onlyAdminOrOwner {
67         require(msg.sender == owner || msg.sender == admin);
68         _;
69     }
70 
71     modifier afterInitialization {
72         require(id >= 0);
73         _;
74     }
75 
76     function EthereumLottery(address _btcRelay,
77                              address _escrow,
78                              address _affiliateNetwork) {
79         owner = msg.sender;
80         admin = msg.sender;
81         btcRelay = _btcRelay;
82         escrow = _escrow;
83         affiliateNetwork = _affiliateNetwork;
84     }
85 
86     function needsInitialization() constant returns (bool) {
87         return id == -1 || lotteries[id].finalizationBlock > 0;
88     }
89 
90     function initLottery(uint _jackpot, uint _numTickets, uint _ticketPrice)
91              onlyAdminOrOwner {
92         require(needsInitialization());
93         require(_numTickets * _ticketPrice > _jackpot);
94 
95         id += 1;
96         lotteries[id].jackpot = _jackpot;
97         lotteries[id].decidingBlock = -1;
98         lotteries[id].numTickets = _numTickets;
99         lotteries[id].ticketPrice = _ticketPrice;
100         lotteries[id].winningTicket = -1;
101 
102         uint affiliateCut = (_ticketPrice - (_jackpot / _numTickets)) / 2;
103         lotteries[id].affiliateCut = affiliateCut;
104 
105         lastInitTimestamp = block.timestamp;
106         lastSaleTimestamp = 0;
107     }
108 
109     function buyTickets(uint[] _tickets, uint _mark, uint _affiliate)
110              payable afterInitialization {
111         if (lotteries[id].numTicketsSold == lotteries[id].numTickets) {
112             PurchaseFailed(msg.sender, _mark, Reason.TicketSaleClosed);
113             msg.sender.transfer(msg.value);
114             return;
115         }
116 
117         require(_tickets.length > 0);
118         require(msg.value == _tickets.length * lotteries[id].ticketPrice);
119 
120         for (uint i = 0; i < _tickets.length; i++) {
121             uint ticket = _tickets[i];
122             require(ticket >= 0);
123             require(ticket < lotteries[id].numTickets);
124 
125             if (lotteries[id].tickets[ticket] != 0) {
126                 PurchaseFailed(msg.sender, _mark, Reason.TicketAlreadySold);
127                 msg.sender.transfer(msg.value);
128                 return;
129             }
130         }
131 
132         for (i = 0; i < _tickets.length; i++) {
133             ticket = _tickets[i];
134             lotteries[id].tickets[ticket] = msg.sender;
135             recentActivity[recentActivityIdx] = ticket;
136 
137             recentActivityIdx += 1;
138             if (recentActivityIdx >= recentActivity.length) {
139                 recentActivityIdx = 0;
140             }
141         }
142 
143         lotteries[id].numTicketsSold += _tickets.length;
144         lastSaleTimestamp = block.timestamp;
145 
146         address affiliateAddress =
147             AffiliateNetwork(affiliateNetwork).affiliateAddresses(_affiliate);
148         if (affiliateAddress != 0) {
149             uint cut = lotteries[id].affiliateCut * _tickets.length;
150             var _ = affiliateAddress.call.gas(GAS_LIMIT_AFFILIATE).value(cut)();
151         }
152 
153         PurchaseSuccessful(msg.sender, _mark);
154     }
155 
156     function needsBlockFinalization()
157              afterInitialization constant returns (bool) {
158         // Check the timestamp of the latest block known to BTCRelay
159         // and require it to be no more than 2 hours older than the
160         // timestamp of our block. This should ensure that BTCRelay
161         // is reasonably up to date.
162         uint btcTimestamp;
163         int blockHash = BTCRelay(btcRelay).getBlockchainHead();
164         (,btcTimestamp) = getBlockHeader(blockHash);
165 
166         uint delta = 0;
167         if (btcTimestamp < block.timestamp) {
168             delta = block.timestamp - btcTimestamp;
169         }
170 
171         return delta < 2 * 60 * 60 &&
172                lotteries[id].numTicketsSold == lotteries[id].numTickets &&
173                lotteries[id].decidingBlock == -1;
174     }
175 
176     function finalizeBlock()
177              afterInitialization {
178         require(needsBlockFinalization());
179 
180         // At this point we know that the timestamp of the latest block
181         // known to BTCRelay is within 2 hours of what the Ethereum network
182         // considers 'now'. If we assume this to be correct within +/- 3 hours,
183         // we can conclude that 'out there' in the real world at most 5 hours
184         // have passed. Assuming an actual block time of 9 minutes for Bitcoin,
185         // we can use the Poisson distribution to calculate, that if we wait for
186         // 54 more blocks, then the probability for all of these 54 blocks
187         // having already been mined in 5 hours is less than 0.1 %.
188         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
189         lotteries[id].decidingBlock = blockHeight + 54;
190     }
191 
192     function needsLotteryFinalization()
193              afterInitialization constant returns (bool) {
194         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
195         return lotteries[id].decidingBlock != -1 &&
196                blockHeight >= lotteries[id].decidingBlock + 6 &&
197                lotteries[id].finalizationBlock == 0;
198     }
199 
200     function finalizeLottery(uint _steps)
201              afterInitialization {
202         require(needsLotteryFinalization());
203 
204         if (lotteries[id].nearestKnownBlock != lotteries[id].decidingBlock) {
205             walkTowardsBlock(_steps);
206         } else {
207             int winningTicket = lotteries[id].nearestKnownBlockHash %
208                                 int(lotteries[id].numTickets);
209             address winner = lotteries[id].tickets[uint(winningTicket)];
210 
211             lotteries[id].winningTicket = winningTicket;
212             lotteries[id].winner = winner;
213             lotteries[id].finalizationBlock = block.number;
214             lotteries[id].finalizer = tx.origin;
215 
216             if (winner != 0) {
217                 uint value = lotteries[id].jackpot;
218                 bool successful =
219                     winner.call.gas(GAS_LIMIT_DEPOSIT).value(value)();
220                 if (!successful) {
221                     Escrow(escrow).deposit.value(value)(winner);
222                 }
223             }
224 
225             var _ = admin.call.gas(GAS_LIMIT_DEPOSIT).value(this.balance)();
226         }
227     }
228 
229     function walkTowardsBlock(uint _steps) internal {
230         int blockHeight;
231         int blockHash;
232         if (lotteries[id].nearestKnownBlock == 0) {
233             blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
234             blockHash = BTCRelay(btcRelay).getBlockchainHead();
235         } else {
236             blockHeight = lotteries[id].nearestKnownBlock;
237             blockHash = lotteries[id].nearestKnownBlockHash;
238         }
239 
240         // Walk only a few steps to keep an upper limit on gas costs.
241         for (uint step = 0; step < _steps; step++) {
242             blockHeight -= 1;
243             (blockHash,) = getBlockHeader(blockHash);
244 
245             if (blockHeight == lotteries[id].decidingBlock) { break; }
246         }
247 
248         // Store the progress to pick up from there next time.
249         lotteries[id].nearestKnownBlock = blockHeight;
250         lotteries[id].nearestKnownBlockHash = blockHash;
251     }
252 
253     function getBlockHeader(int blockHash)
254              internal returns (int prevBlockHash, uint timestamp) {
255         // We expect free access to BTCRelay.
256         int fee = BTCRelay(btcRelay).getFeeAmount(blockHash);
257         require(fee == 0);
258 
259         // Code is based on tjade273's BTCRelayTools.
260         bytes32[5] memory blockHeader =
261             BTCRelay(btcRelay).getBlockHeader(blockHash);
262 
263         prevBlockHash = 0;
264         for (uint i = 0; i < 32; i++) {
265             uint pos = 68 + i;  // prev. block hash starts at position 68
266             byte data = blockHeader[pos / 32][pos % 32];
267             prevBlockHash = prevBlockHash | int(data) * int(0x100 ** i);
268         }
269 
270         timestamp = 0;
271         for (i = 0; i < 4; i++) {
272             pos = 132 + i;  // timestamp starts at position 132
273             data = blockHeader[pos / 32][pos % 32];
274             timestamp = timestamp | uint(data) * uint(0x100 ** i);
275         }
276 
277         return (prevBlockHash, timestamp);
278     }
279 
280     function getMessageLength(string _message) constant returns (uint) {
281         return bytes(_message).length;
282     }
283 
284     function setMessage(int _id, string _message)
285              afterInitialization {
286         require(lotteries[_id].winner != 0);
287         require(lotteries[_id].winner == msg.sender);
288         require(getMessageLength(_message) <= 500);
289         lotteries[_id].message = _message;
290     }
291 
292     function getLotteryDetailsA(int _id)
293              constant returns (int _actualId, uint _jackpot,
294                                int _decidingBlock,
295                                uint _numTickets, uint _numTicketsSold,
296                                uint _lastSaleTimestamp, uint _ticketPrice) {
297         if (_id == -1) {
298             _actualId = id;
299         } else {
300             _actualId = _id;
301         }
302         _jackpot = lotteries[_actualId].jackpot;
303         _decidingBlock = lotteries[_actualId].decidingBlock;
304         _numTickets = lotteries[_actualId].numTickets;
305         _numTicketsSold = lotteries[_actualId].numTicketsSold;
306         _lastSaleTimestamp = lastSaleTimestamp;
307         _ticketPrice = lotteries[_actualId].ticketPrice;
308     }
309 
310     function getLotteryDetailsB(int _id)
311              constant returns (int _actualId,
312                                int _winningTicket, address _winner,
313                                uint _finalizationBlock, address _finalizer,
314                                string _message,
315                                int _prevLottery, int _nextLottery,
316                                int _blockHeight) {
317         if (_id == -1) {
318             _actualId = id;
319         } else {
320             _actualId = _id;
321         }
322         _winningTicket = lotteries[_actualId].winningTicket;
323         _winner = lotteries[_actualId].winner;
324         _finalizationBlock = lotteries[_actualId].finalizationBlock;
325         _finalizer = lotteries[_actualId].finalizer;
326         _message = lotteries[_actualId].message;
327 
328         if (_actualId == 0) {
329             _prevLottery = -1;
330         } else {
331             _prevLottery = _actualId - 1;
332         }
333         if (_actualId == id) {
334             _nextLottery = -1;
335         } else {
336             _nextLottery = _actualId + 1;
337         }
338 
339         _blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
340     }
341 
342     function getTicketDetails(int _id, uint _offset, uint _n, address _addr)
343              constant returns (uint8[] details) {
344         require(_offset + _n <= lotteries[_id].numTickets);
345 
346         details = new uint8[](_n);
347         for (uint i = 0; i < _n; i++) {
348             address addr = lotteries[_id].tickets[_offset + i];
349             if (addr == _addr && _addr != 0) {
350                 details[i] = 2;
351             } else if (addr != 0) {
352                 details[i] = 1;
353             } else {
354                 details[i] = 0;
355             }
356         }
357     }
358 
359     function getFullTicketDetails(int _id, uint _offset, uint _n)
360              constant returns (address[] details) {
361         require(_offset + _n <= lotteries[_id].numTickets);
362 
363         details = new address[](_n);
364         for (uint i = 0; i < _n; i++) {
365             details[i] = lotteries[_id].tickets[_offset + i];
366         }
367     }
368 
369     function getTicketOwner(int _id, uint _ticket) constant returns (address) {
370         require(_id >= 0);
371         return lotteries[_id].tickets[_ticket];
372     }
373 
374     function getRecentActivity()
375              constant returns (int _id, uint _idx, uint[1000] _recentActivity) {
376         _id = id;
377         _idx = recentActivityIdx;
378         for (uint i = 0; i < recentActivity.length; i++) {
379             _recentActivity[i] = recentActivity[i];
380         }
381     }
382 
383     function setAdmin(address _admin) onlyOwner {
384         admin = _admin;
385     }
386 
387     function proposeOwner(address _owner) onlyOwner {
388         proposedOwner = _owner;
389     }
390 
391     function acceptOwnership() {
392         require(proposedOwner != 0);
393         require(msg.sender == proposedOwner);
394         owner = proposedOwner;
395     }
396 }