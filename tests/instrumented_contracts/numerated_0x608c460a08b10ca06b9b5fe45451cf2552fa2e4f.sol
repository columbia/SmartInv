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
15 contract EthereumLottery {
16     uint constant GAS_LIMIT_DEPOSIT = 300000;
17     uint constant GAS_LIMIT_BUY = 450000;
18 
19     struct Lottery {
20         uint jackpot;
21         int decidingBlock;
22         uint numTickets;
23         uint numTicketsSold;
24         uint ticketPrice;
25         int winningTicket;
26         address winner;
27         uint finalizationBlock;
28         address finalizer;
29         string message;
30         mapping (uint => address) tickets;
31         int nearestKnownBlock;
32         int nearestKnownBlockHash;
33     }
34 
35     address public owner;
36     address public admin;
37     address public proposedOwner;
38 
39     int public id = -1;
40     uint public lastInitTimestamp;
41     uint public lastSaleTimestamp;
42 
43     uint public recentActivityIdx;
44     uint[1000] public recentActivity;
45 
46     mapping (int => Lottery) public lotteries;
47 
48     address public btcRelay;
49     address public escrow;
50 
51     enum Reason { TicketSaleClosed, TicketAlreadySold, InsufficientGas }
52     event PurchaseFailed(address indexed buyer, uint mark, Reason reason);
53     event PurchaseSuccessful(address indexed buyer, uint mark);
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     modifier onlyAdminOrOwner {
61         require(msg.sender == owner || msg.sender == admin);
62         _;
63     }
64 
65     modifier afterInitialization {
66         require(id >= 0);
67         _;
68     }
69 
70     function EthereumLottery(address _btcRelay,
71                              address _escrow) {
72         owner = msg.sender;
73         admin = msg.sender;
74         btcRelay = _btcRelay;
75         escrow = _escrow;
76     }
77 
78     function needsInitialization() constant returns (bool) {
79         return id == -1 || lotteries[id].finalizationBlock > 0;
80     }
81 
82     function initLottery(uint _jackpot, uint _numTickets, uint _ticketPrice)
83              onlyAdminOrOwner {
84         require(needsInitialization());
85         require(_numTickets * _ticketPrice > _jackpot);
86 
87         id += 1;
88         lotteries[id].jackpot = _jackpot;
89         lotteries[id].decidingBlock = -1;
90         lotteries[id].numTickets = _numTickets;
91         lotteries[id].ticketPrice = _ticketPrice;
92         lotteries[id].winningTicket = -1;
93 
94         lastInitTimestamp = block.timestamp;
95         lastSaleTimestamp = 0;
96     }
97 
98     function buyTickets(uint[] _tickets, uint _mark, bytes _extraData)
99              payable afterInitialization {
100         if (msg.gas < GAS_LIMIT_BUY) {
101             PurchaseFailed(msg.sender, _mark, Reason.InsufficientGas);
102             return;
103         }
104 
105         if (lotteries[id].numTicketsSold == lotteries[id].numTickets) {
106             PurchaseFailed(msg.sender, _mark, Reason.TicketSaleClosed);
107             return;
108         }
109 
110         require(_tickets.length > 0);
111         require(msg.value == _tickets.length * lotteries[id].ticketPrice);
112 
113         for (uint i = 0; i < _tickets.length; i++) {
114             uint ticket = _tickets[i];
115             require(ticket >= 0);
116             require(ticket < lotteries[id].numTickets);
117 
118             if (lotteries[id].tickets[ticket] != 0) {
119                 PurchaseFailed(msg.sender, _mark, Reason.TicketAlreadySold);
120                 return;
121             }
122         }
123 
124         for (i = 0; i < _tickets.length; i++) {
125             ticket = _tickets[i];
126             lotteries[id].tickets[ticket] = msg.sender;
127             recentActivity[recentActivityIdx] = ticket;
128 
129             recentActivityIdx += 1;
130             if (recentActivityIdx >= recentActivity.length) {
131                 recentActivityIdx = 0;
132             }
133         }
134 
135         lotteries[id].numTicketsSold += _tickets.length;
136         lastSaleTimestamp = block.timestamp;
137 
138         BTCRelay(btcRelay).storeBlockHeader(_extraData);
139 
140         PurchaseSuccessful(msg.sender, _mark);
141     }
142 
143     function needsBlockFinalization()
144              afterInitialization constant returns (bool) {
145         // Check the timestamp of the latest block known to BTCRelay
146         // and require it to be no more than 2 hours older than the
147         // timestamp of our block. This should ensure that BTCRelay
148         // is reasonably up to date.
149         uint btcTimestamp;
150         int blockHash = BTCRelay(btcRelay).getBlockchainHead();
151         (,btcTimestamp) = getBlockHeader(blockHash);
152 
153         uint delta = 0;
154         if (btcTimestamp < block.timestamp) {
155             delta = block.timestamp - btcTimestamp;
156         }
157 
158         return delta < 2 * 60 * 60 &&
159                lotteries[id].numTicketsSold == lotteries[id].numTickets &&
160                lotteries[id].decidingBlock == -1;
161     }
162 
163     function finalizeBlock()
164              afterInitialization {
165         require(needsBlockFinalization());
166 
167         // At this point we know that the timestamp of the latest block
168         // known to BTCRelay is within 2 hours of what the Ethereum network
169         // considers 'now'. If we assume this to be correct within +/- 3 hours,
170         // we can conclude that 'out there' in the real world at most 5 hours
171         // have passed. Assuming an actual block time of 9 minutes for Bitcoin,
172         // we can use the Poisson distribution to calculate, that if we wait for
173         // 54 more blocks, then the probability for all of these 54 blocks
174         // having already been mined in 5 hours is less than 0.1 %.
175         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
176         lotteries[id].decidingBlock = blockHeight + 54;
177     }
178 
179     function needsLotteryFinalization()
180              afterInitialization constant returns (bool) {
181         int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
182         return lotteries[id].decidingBlock != -1 &&
183                blockHeight >= lotteries[id].decidingBlock + 6 &&
184                lotteries[id].finalizationBlock == 0;
185     }
186 
187     function finalizeLottery(uint _steps)
188              afterInitialization {
189         require(needsLotteryFinalization());
190 
191         if (lotteries[id].nearestKnownBlock != lotteries[id].decidingBlock) {
192             walkTowardsBlock(_steps);
193         } else {
194             int winningTicket = lotteries[id].nearestKnownBlockHash %
195                                 int(lotteries[id].numTickets);
196             address winner = lotteries[id].tickets[uint(winningTicket)];
197 
198             lotteries[id].winningTicket = winningTicket;
199             lotteries[id].winner = winner;
200             lotteries[id].finalizationBlock = block.number;
201             lotteries[id].finalizer = tx.origin;
202 
203             if (winner != 0) {
204                 uint value = lotteries[id].jackpot;
205                 bool successful =
206                     winner.call.gas(GAS_LIMIT_DEPOSIT).value(value)();
207                 if (!successful) {
208                     Escrow(escrow).deposit.value(value)(winner);
209                 }
210             }
211 
212             var _ = admin.call.gas(GAS_LIMIT_DEPOSIT).value(this.balance)();
213         }
214     }
215 
216     function walkTowardsBlock(uint _steps) internal {
217         int blockHeight;
218         int blockHash;
219         if (lotteries[id].nearestKnownBlock == 0) {
220             blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
221             blockHash = BTCRelay(btcRelay).getBlockchainHead();
222         } else {
223             blockHeight = lotteries[id].nearestKnownBlock;
224             blockHash = lotteries[id].nearestKnownBlockHash;
225         }
226 
227         // Walk only a few steps to keep an upper limit on gas costs.
228         for (uint step = 0; step < _steps; step++) {
229             blockHeight -= 1;
230             (blockHash,) = getBlockHeader(blockHash);
231 
232             if (blockHeight == lotteries[id].decidingBlock) { break; }
233         }
234 
235         // Store the progress to pick up from there next time.
236         lotteries[id].nearestKnownBlock = blockHeight;
237         lotteries[id].nearestKnownBlockHash = blockHash;
238     }
239 
240     function getBlockHeader(int blockHash)
241              internal returns (int prevBlockHash, uint timestamp) {
242         // We expect free access to BTCRelay.
243         int fee = BTCRelay(btcRelay).getFeeAmount(blockHash);
244         require(fee == 0);
245 
246         // Code is based on tjade273's BTCRelayTools.
247         bytes32[5] memory blockHeader =
248             BTCRelay(btcRelay).getBlockHeader(blockHash);
249 
250         prevBlockHash = 0;
251         for (uint i = 0; i < 32; i++) {
252             uint pos = 68 + i;  // prev. block hash starts at position 68
253             byte data = blockHeader[pos / 32][pos % 32];
254             prevBlockHash = prevBlockHash | int(data) * int(0x100 ** i);
255         }
256 
257         timestamp = 0;
258         for (i = 0; i < 4; i++) {
259             pos = 132 + i;  // timestamp starts at position 132
260             data = blockHeader[pos / 32][pos % 32];
261             timestamp = timestamp | uint(data) * uint(0x100 ** i);
262         }
263 
264         return (prevBlockHash, timestamp);
265     }
266 
267     function getMessageLength(string _message) constant returns (uint) {
268         return bytes(_message).length;
269     }
270 
271     function setMessage(int _id, string _message)
272              afterInitialization {
273         require(lotteries[_id].winner != 0);
274         require(lotteries[_id].winner == msg.sender);
275         require(getMessageLength(_message) <= 500);
276         lotteries[_id].message = _message;
277     }
278 
279     function getLotteryDetailsA(int _id)
280              constant returns (int _actualId, uint _jackpot,
281                                int _decidingBlock,
282                                uint _numTickets, uint _numTicketsSold,
283                                uint _lastSaleTimestamp, uint _ticketPrice) {
284         if (_id == -1) {
285             _actualId = id;
286         } else {
287             _actualId = _id;
288         }
289         _jackpot = lotteries[_actualId].jackpot;
290         _decidingBlock = lotteries[_actualId].decidingBlock;
291         _numTickets = lotteries[_actualId].numTickets;
292         _numTicketsSold = lotteries[_actualId].numTicketsSold;
293         _lastSaleTimestamp = lastSaleTimestamp;
294         _ticketPrice = lotteries[_actualId].ticketPrice;
295     }
296 
297     function getLotteryDetailsB(int _id)
298              constant returns (int _actualId,
299                                int _winningTicket, address _winner,
300                                uint _finalizationBlock, address _finalizer,
301                                string _message,
302                                int _prevLottery, int _nextLottery,
303                                int _blockHeight) {
304         if (_id == -1) {
305             _actualId = id;
306         } else {
307             _actualId = _id;
308         }
309         _winningTicket = lotteries[_actualId].winningTicket;
310         _winner = lotteries[_actualId].winner;
311         _finalizationBlock = lotteries[_actualId].finalizationBlock;
312         _finalizer = lotteries[_actualId].finalizer;
313         _message = lotteries[_actualId].message;
314 
315         if (_actualId == 0) {
316             _prevLottery = -1;
317         } else {
318             _prevLottery = _actualId - 1;
319         }
320         if (_actualId == id) {
321             _nextLottery = -1;
322         } else {
323             _nextLottery = _actualId + 1;
324         }
325 
326         _blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
327     }
328 
329     function getTicketDetails(int _id, uint _offset, uint _n, address _addr)
330              constant returns (uint8[] details) {
331         require(_offset + _n <= lotteries[_id].numTickets);
332 
333         details = new uint8[](_n);
334         for (uint i = 0; i < _n; i++) {
335             address addr = lotteries[_id].tickets[_offset + i];
336             if (addr == _addr && _addr != 0) {
337                 details[i] = 2;
338             } else if (addr != 0) {
339                 details[i] = 1;
340             } else {
341                 details[i] = 0;
342             }
343         }
344     }
345 
346     function getTicketOwner(int _id, uint _ticket) constant returns (address) {
347         require(_id >= 0);
348         return lotteries[_id].tickets[_ticket];
349     }
350 
351     function getRecentActivity()
352              constant returns (int _id, uint _idx, uint[1000] _recentActivity) {
353         _id = id;
354         _idx = recentActivityIdx;
355         for (uint i = 0; i < recentActivity.length; i++) {
356             _recentActivity[i] = recentActivity[i];
357         }
358     }
359 
360     function setAdmin(address _admin) onlyOwner {
361         admin = _admin;
362     }
363 
364     function proposeOwner(address _owner) onlyOwner {
365         proposedOwner = _owner;
366     }
367 
368     function acceptOwnership() {
369         require(proposedOwner != 0);
370         require(msg.sender == proposedOwner);
371         owner = proposedOwner;
372     }
373 }