1 pragma solidity ^0.5.0;
2 
3 // ---------------------------------------------------------------------------
4 //  Pirate Lottery
5 //
6 // players purchase numbered tickets while a round is open; all the player's addresses are hashed together.
7 //
8 // after the round closes, the winner of the *previous* round can claim his prize, by signing a message:
9 //  message = "Pirate Lottery" + hash(previous-round-player-addresses)
10 //
11 // the signature is hashed with hash(current-round-player-addresses) to produce a number X; and the
12 // winner of the current round is selected as the holder of ticket number X modulo N, where N is the number
13 // of tickets sold in the current round. the next round is then opened.
14 //
15 // there are only 2 possible lottery states:
16 //  1) current round is open
17 //     in this state players can purchase tickets.
18 //     the previous round winner has been selected, but he cannot claim his prize yet.
19 //     the round closes when all tickets have been sold or the maximum round duration elapses
20 //
21 //  2) current round closed
22 //     in this state players cannot purchase tickets.
23 //     the winner of the previous round can claim his prize.
24 //     if the prize is not claimed within a certain time, then the prize is considered abandoned. in
25 //     that case any participant in the round can claim half the prize.
26 //     when the prize is claimed:
27 //       a) the winner of the current round is selected
28 //       b) a new round is opened
29 //       c) what was the current round becomes the previous round
30 //
31 // ---------------------------------------------------------------------------
32 
33 //import './iPlpPointsRedeemer.sol';
34 // interface for redeeming PLP Points
35 contract iPlpPointsRedeemer {
36   function reserveTokens() public view returns (uint remaining);
37   function transferFromReserve(address _to, uint _value) public;
38 }
39 
40 contract PirateLottery {
41 
42   //
43   // events
44   //
45   event WinnerEvent(uint256 round, uint256 ticket, uint256 prize);
46   event PayoutEvent(uint256 round, address payee, uint256 prize, uint256 payout);
47 
48 
49   //
50   // defines
51   //
52   uint constant MIN_TICKETS = 10;
53   uint constant MAX_TICKETS = 50000000;
54   uint constant LONG_DURATION = 5 days;
55   uint constant SHORT_DURATION = 12 hours;
56   uint constant MAX_CLAIM_DURATION = 5 days;
57   uint constant TOKEN_HOLDOVER_THRESHOLD = 20 finney;
58 
59 
60   //
61   // Round structure
62   // all data pertinent to a single round of the lottery
63   //
64   struct Round {
65     uint256 maxTickets;
66     uint256 ticketPrice;
67     uint256 ticketCount;
68     bytes32 playersHash;
69     uint256 begDate;
70     uint256 endDate;
71     uint256 winner;
72     uint256 prize;
73     bool isOpen;
74     mapping (uint256 => address) ticketOwners;
75     mapping (address => uint256) playerTicketCounts;
76     mapping (address => mapping (uint256 => uint256)) playerTickets;
77   }
78 
79   //
80   // Claim structure
81   // this struture must be signed, ala EIP 712, in order to claim the lottery prize
82   //
83   struct Claim {
84     uint256 ticket;
85     uint256 playerHash;
86   }
87   bytes32 private DOMAIN_SEPARATOR;
88   bytes32 private constant CLAIM_TYPEHASH = keccak256("Claim(string lottery,uint256 round,uint256 ticket,uint256 playerHash)");
89   bytes32 private constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
90 
91 
92   // -------------------------------------------------------------------------
93   // data storage
94   // -------------------------------------------------------------------------
95   bool    public isLocked;
96   string  public name;
97   address payable public owner;
98   bytes32 nameHash;
99   uint256 public min_ticket_price;
100   uint256 public max_ticket_price;
101   uint256 public roundCount;
102   mapping (uint256 => Round) public rounds;
103   mapping (address => uint256) public balances;
104   mapping (address => uint256) public plpPoints;
105   iPlpPointsRedeemer plpToken;
106   uint256 public tokenHoldoverBalance;
107 
108   // -------------------------------------------------------------------------
109   // modifiers
110   // -------------------------------------------------------------------------
111   modifier ownerOnly {
112     require(msg.sender == owner, "owner only");
113     _;
114   }
115   modifier unlockedOnly {
116     require(!isLocked, "unlocked only");
117     _;
118   }
119 
120 
121   //
122   //  constructor
123   //
124   constructor(address _plpToken, uint256 _chainId, string memory _name, uint256 _min_ticket_price, uint256 _max_ticket_price) public {
125     owner = msg.sender;
126     name = _name;
127     min_ticket_price = _min_ticket_price;
128     max_ticket_price = _max_ticket_price;
129     plpToken = iPlpPointsRedeemer(_plpToken);
130     Round storage _currentRound = rounds[1];
131     Round storage _previousRound = rounds[0];
132     _previousRound.maxTickets = 1;
133     //_previousRound.ticketPrice = 0;
134     _previousRound.ticketCount = 1;
135     _previousRound.playersHash = keccak256(abi.encodePacked(bytes32(0), owner));
136     _previousRound.begDate = now;
137     _previousRound.endDate = now;
138     _previousRound.winner = 1;
139     _previousRound.ticketOwners[1] = msg.sender;
140     _previousRound.playerTickets[msg.sender][0] = 1;
141     _previousRound.playerTicketCounts[msg.sender]++;
142     //_previousRound.prize = 0;
143     _currentRound.maxTickets = 2;
144     _currentRound.ticketPrice = (min_ticket_price + max_ticket_price) / 2;
145     //_currentRound.ticketCount = 0;
146     //_currentRound.playersHash = 0;
147     //_currentRound.begDate = 0;
148     //_currentRound.endDate = 0;
149     //_currentRound.winner = 0;
150     //_currentRound.prize = 0;
151     _currentRound.isOpen = true;
152     roundCount = 1;
153     //eip 712
154     DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAIN_TYPEHASH,
155                                             keccak256("Pirate Lottery"),
156                                             keccak256("1.0"),
157                                             _chainId,
158                                             address(this)));
159     nameHash = keccak256(abi.encodePacked(name));
160   }
161   //for debug only...
162   function setToken(address _plpToken) public unlockedOnly ownerOnly {
163     plpToken = iPlpPointsRedeemer(_plpToken);
164   }
165   function lock() public ownerOnly {
166     isLocked = true;
167   }
168 
169 
170   //
171   // buy a ticket for the current round
172   //
173   function buyTicket() public payable {
174     Round storage _currentRound = rounds[roundCount];
175     require(_currentRound.isOpen == true, "current round is closed");
176     require(msg.value == _currentRound.ticketPrice, "incorrect ticket price");
177     if (_currentRound.ticketCount == 0)
178       _currentRound.begDate = now;
179     _currentRound.ticketCount++;
180     _currentRound.prize += msg.value;
181     plpPoints[msg.sender]++;
182     uint256 _ticket = _currentRound.ticketCount;
183     _currentRound.ticketOwners[_ticket] = msg.sender;
184     uint256 _playerTicketCount = _currentRound.playerTicketCounts[msg.sender];
185     _currentRound.playerTickets[msg.sender][_playerTicketCount] = _ticket;
186     _currentRound.playerTicketCounts[msg.sender]++;
187     _currentRound.playersHash = keccak256(abi.encodePacked(_currentRound.playersHash, msg.sender));
188     uint256 _currentDuration = now - _currentRound.begDate;
189     if (_currentRound.ticketCount == _currentRound.maxTickets || _currentDuration > LONG_DURATION) {
190       _currentRound.playersHash = keccak256(abi.encodePacked(_currentRound.playersHash, block.coinbase));
191       _currentRound.isOpen = false;
192       _currentRound.endDate = now;
193     }
194   }
195 
196 
197   //
198   // get info for the current round
199   // if the round is closed, then we are waiting for the winner of the previous round to claim his prize
200   //
201   function getCurrentInfo(address _addr) public view returns(uint256 _round, uint256 _playerTicketCount, uint256 _ticketPrice,
202                                                              uint256 _ticketCount, uint256 _begDate, uint256 _endDate, uint256 _prize,
203                                                              bool _isOpen, uint256 _maxTickets) {
204     Round storage _currentRound = rounds[roundCount];
205     _round = roundCount;
206     _playerTicketCount = _currentRound.playerTicketCounts[_addr];
207     _ticketPrice = _currentRound.ticketPrice;
208     _ticketCount = _currentRound.ticketCount;
209     _begDate = _currentRound.begDate;
210     _endDate = _currentRound.isOpen ? (_currentRound.begDate + LONG_DURATION) : _currentRound.endDate;
211     _prize = _currentRound.prize;
212     _isOpen = _currentRound.isOpen;
213     _maxTickets = _currentRound.maxTickets;
214   }
215 
216 
217   //
218   // get the winner of the previous round
219   //
220   function getPreviousInfo(address _addr) public view returns(uint256 _round, uint256 _playerTicketCount, uint256 _ticketPrice, uint256 _ticketCount,
221                                                               uint256 _begDate, uint256 _endDate, uint256 _prize,
222                                                               uint256 _winningTicket, address _winner, uint256 _claimDeadline, bytes32 _playersHash) {
223     Round storage _currentRound = rounds[roundCount];
224     Round storage _previousRound = rounds[roundCount - 1];
225     _round = roundCount - 1;
226     _playerTicketCount = _previousRound.playerTicketCounts[_addr];
227     _ticketPrice = _previousRound.ticketPrice;
228     _ticketCount = _previousRound.ticketCount;
229     _begDate = _previousRound.begDate;
230     _endDate = _previousRound.endDate;
231     _prize = _previousRound.prize;
232     _winningTicket = _previousRound.winner;
233     _winner = _previousRound.ticketOwners[_previousRound.winner];
234     if (_currentRound.isOpen == true) {
235       _playersHash = bytes32(0);
236       _claimDeadline = 0;
237     } else {
238       _playersHash = _currentRound.playersHash;
239       _claimDeadline = _currentRound.endDate + MAX_CLAIM_DURATION;
240     }
241   }
242 
243 
244   // get array of tickets owned by address
245   //
246   // note that array will always have _maxResults entries. ignore messageID = 0
247   //
248   function getTickets(address _addr, uint256 _round, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _tickets) {
249     uint _count = 0;
250     Round storage _subjectRound = rounds[_round];
251     _tickets = new uint256[](_maxResults);
252     uint256 _playerTicketCount = _subjectRound.playerTicketCounts[_addr];
253     mapping(uint256 => uint256) storage _playerTickets = _subjectRound.playerTickets[_addr];
254     for (_idx = _startIdx; _idx < _playerTicketCount; ++_idx) {
255       _tickets[_count] = _playerTickets[_idx];
256       if (++_count >= _maxResults)
257         break;
258     }
259   }
260 
261   // get owner of passed ticket
262   //
263   function getTicketOwner(uint256 _round, uint256 _ticket) public view returns(address _owner) {
264     Round storage _subjectRound = rounds[_round];
265     _owner = _subjectRound.ticketOwners[_ticket];
266   }
267 
268 
269   //
270   // winner of previous round claims his prize here
271   // note: you can only claim your prize while the current round is closed
272   // when the winner of the previous round claims his prize, we are then able to determine
273   // the winner of the current round, and then immediately start a new round
274   //
275   function claimPrize(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket) public {
276     Round storage _currentRound = rounds[roundCount];
277     Round storage _previousRound = rounds[roundCount - 1];
278     require(_currentRound.isOpen == false, "wait until current round is closed");
279     require(_previousRound.winner == _ticket, "not the winning ticket");
280     claimPrizeForTicket(_sigV, _sigR, _sigS, _ticket, 2);
281     newRound();
282   }
283 
284 
285   //
286   // any participant of previous round claims an abandoned prize here
287   // only after MAX_CLAIM_DURATION
288   //
289   function claimAbondonedPrize(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket) public {
290     Round storage _currentRound = rounds[roundCount];
291     require(_currentRound.isOpen == false, "wait until current round is closed");
292     require(now >= _currentRound.endDate + MAX_CLAIM_DURATION, "prize is not abondoned yet");
293     claimPrizeForTicket(_sigV, _sigR, _sigS, _ticket, 50);
294     newRound();
295   }
296 
297 
298   //
299   // verifies signature against claimed ticket; sends prize to claimer
300   // computes winner of current round
301   //
302   function claimPrizeForTicket(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket, uint256 _ownerCutPct) internal {
303     Round storage _currentRound = rounds[roundCount];
304     Round storage _previousRound = rounds[roundCount - 1];
305     bytes32 _claimHash = keccak256(abi.encode(CLAIM_TYPEHASH, nameHash, roundCount - 1, _ticket, _currentRound.playersHash));
306     bytes32 _domainClaimHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, _claimHash));
307     address _recovered = ecrecover(_domainClaimHash, _sigV, _sigR, _sigS);
308     require(_previousRound.ticketOwners[_ticket] == _recovered, "claim is not valid");
309     uint256 _tokenCut = _ownerCutPct * _previousRound.prize / 100;
310     tokenHoldoverBalance += _tokenCut;
311     uint256 _payout = _previousRound.prize - _tokenCut;
312     balances[msg.sender] += _payout;
313     bytes32 _winningHash = keccak256(abi.encodePacked(_currentRound.playersHash, _sigV, _sigR, _sigS));
314     _currentRound.winner = uint256(_winningHash) % _currentRound.ticketCount + 1;
315     emit PayoutEvent(roundCount - 1, msg.sender, _previousRound.prize, _payout);
316     emit WinnerEvent(roundCount, _currentRound.winner, _currentRound.prize);
317     //
318     if (tokenHoldoverBalance > TOKEN_HOLDOVER_THRESHOLD) {
319       uint _amount = tokenHoldoverBalance;
320       tokenHoldoverBalance = 0;
321       (bool paySuccess, ) = address(plpToken).call.value(_amount)("");
322       if (!paySuccess)
323         revert();
324     }
325   }
326 
327 
328   //
329   // open a new round - adjust lottery parameters
330   // goal is that duration should be between SHORT_DURATION and LONG_DURATION
331   // first we adjust ticket price, but if price is already at the corresponding limit, then we adjust maxTickets
332   //
333   function newRound() internal {
334     ++roundCount;
335     Round storage _nextRound = rounds[roundCount];
336     Round storage _currentRound = rounds[roundCount - 1];
337     uint256 _currentDuration = _currentRound.endDate - _currentRound.begDate;
338     //
339     if (_currentDuration < SHORT_DURATION) {
340       if (_currentRound.ticketPrice < max_ticket_price && _currentRound.maxTickets > MIN_TICKETS * 10) {
341          _nextRound.ticketPrice = max_ticket_price;
342          _nextRound.maxTickets = _currentRound.maxTickets;
343        } else {
344          _nextRound.ticketPrice = _currentRound.ticketPrice;
345          _nextRound.maxTickets = 2 * _currentRound.maxTickets;
346          if (_nextRound.maxTickets > MAX_TICKETS)
347            _nextRound.maxTickets = MAX_TICKETS;
348        }
349     } else if (_currentDuration > LONG_DURATION) {
350        if (_currentRound.ticketPrice > min_ticket_price) {
351          _nextRound.ticketPrice = min_ticket_price;
352          _nextRound.maxTickets = _currentRound.maxTickets;
353        } else {
354          _nextRound.ticketPrice = min_ticket_price;
355          _nextRound.maxTickets = _currentRound.maxTickets / 2;
356          if (_nextRound.maxTickets < MIN_TICKETS)
357            _nextRound.maxTickets = MIN_TICKETS;
358        }
359     } else {
360       _nextRound.maxTickets = _currentRound.maxTickets;
361       _nextRound.ticketPrice = (min_ticket_price + max_ticket_price) / 2;
362     }
363     //_nextRound.ticketCount = 0;
364     //_nextRound.endDate = 0;
365     //_nextRound.begDate = 0;
366     _nextRound.isOpen = true;
367   }
368 
369 
370   //
371   // redeem caller's transfer-points for PLP Tokens
372   // make sure the reserve account has sufficient tokens before calling
373   //
374   function redeemPlpPoints() public {
375     uint256 noTokens = plpPoints[msg.sender];
376     plpPoints[msg.sender] = 0;
377     plpToken.transferFromReserve(msg.sender, noTokens);
378   }
379 
380 
381   //
382   // withdraw accumulated prize
383   //
384   function withdraw() public {
385     uint256 _amount = balances[msg.sender];
386     balances[msg.sender] = 0;
387     msg.sender.transfer(_amount);
388   }
389 
390 
391   //
392   // for debug
393   // only available before the contract is locked
394   //
395   function killContract() public ownerOnly unlockedOnly {
396     selfdestruct(owner);
397   }
398 }