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
40 
41 contract PirateLottery {
42 
43   //
44   // events
45   //
46   event WinnerEvent(uint256 round, uint256 ticket, uint256 prize);
47   event PayoutEvent(uint256 round, address payee, uint256 prize, uint256 payout);
48 
49 
50   //
51   // defines
52   //
53   uint constant MIN_TICKETS = 10;
54   uint constant MAX_TICKETS = 50000000;
55   uint constant LONG_DURATION = 5 days;
56   uint constant SHORT_DURATION = 12 hours;
57   uint constant MAX_CLAIM_DURATION = 5 days;
58   uint constant TOKEN_HOLDOVER_THRESHOLD = 20 finney;
59 
60 
61   //
62   // Round structure
63   // all data pertinent to a single round of the lottery
64   //
65   struct Round {
66     uint256 maxTickets;
67     uint256 ticketPrice;
68     uint256 ticketCount;
69     bytes32 playersHash;
70     uint256 begDate;
71     uint256 endDate;
72     uint256 winner;
73     uint256 prize;
74     bool isOpen;
75     mapping (uint256 => address) ticketOwners;
76     mapping (address => uint256) playerTicketCounts;
77     mapping (address => mapping (uint256 => uint256)) playerTickets;
78   }
79 
80   //
81   // Claim structure
82   // this struture must be signed, ala EIP 712, in order to claim the lottery prize
83   //
84   struct Claim {
85     uint256 ticket;
86     uint256 playerHash;
87   }
88   bytes32 private DOMAIN_SEPARATOR;
89   bytes32 private constant CLAIM_TYPEHASH = keccak256("Claim(string lottery,uint256 round,uint256 ticket,uint256 playerHash)");
90   bytes32 private constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
91 
92 
93   // -------------------------------------------------------------------------
94   // data storage
95   // -------------------------------------------------------------------------
96   bool    public isLocked;
97   string  public name;
98   address payable public owner;
99   bytes32 nameHash;
100   uint256 public min_ticket_price;
101   uint256 public max_ticket_price;
102   uint256 public roundCount;
103   mapping (uint256 => Round) public rounds;
104   mapping (address => uint256) public balances;
105   mapping (address => uint256) public plpPoints;
106   iPlpPointsRedeemer plpToken;
107   uint256 public tokenHoldoverBalance;
108 
109   // -------------------------------------------------------------------------
110   // modifiers
111   // -------------------------------------------------------------------------
112   modifier ownerOnly {
113     require(msg.sender == owner, "owner only");
114     _;
115   }
116   modifier unlockedOnly {
117     require(!isLocked, "unlocked only");
118     _;
119   }
120 
121 
122   //
123   //  constructor
124   //
125   constructor(address _plpToken, uint256 _chainId, string memory _name, uint256 _min_ticket_price, uint256 _max_ticket_price) public {
126     owner = msg.sender;
127     name = _name;
128     min_ticket_price = _min_ticket_price;
129     max_ticket_price = _max_ticket_price;
130     plpToken = iPlpPointsRedeemer(_plpToken);
131     Round storage _currentRound = rounds[1];
132     Round storage _previousRound = rounds[0];
133     _previousRound.maxTickets = 1;
134     //_previousRound.ticketPrice = 0;
135     _previousRound.ticketCount = 1;
136     _previousRound.playersHash = keccak256(abi.encodePacked(bytes32(0), owner));
137     _previousRound.begDate = now;
138     _previousRound.endDate = now;
139     _previousRound.winner = 1;
140     _previousRound.ticketOwners[1] = msg.sender;
141     _previousRound.playerTickets[msg.sender][0] = 1;
142     _previousRound.playerTicketCounts[msg.sender]++;
143     //_previousRound.prize = 0;
144     _currentRound.maxTickets = 2;
145     _currentRound.ticketPrice = (min_ticket_price + max_ticket_price) / 2;
146     //_currentRound.ticketCount = 0;
147     //_currentRound.playersHash = 0;
148     //_currentRound.begDate = 0;
149     //_currentRound.endDate = 0;
150     //_currentRound.winner = 0;
151     //_currentRound.prize = 0;
152     _currentRound.isOpen = true;
153     roundCount = 1;
154     //eip 712
155     DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAIN_TYPEHASH,
156                                             keccak256("Pirate Lottery"),
157                                             keccak256("1.0"),
158                                             _chainId,
159                                             address(this)));
160     nameHash = keccak256(abi.encodePacked(name));
161   }
162   //for debug only...
163   function setToken(address _plpToken) public unlockedOnly ownerOnly {
164     plpToken = iPlpPointsRedeemer(_plpToken);
165   }
166   function lock() public ownerOnly {
167     isLocked = true;
168   }
169 
170 
171   //
172   // buy a ticket for the current round
173   //
174   function buyTicket() public payable {
175     Round storage _currentRound = rounds[roundCount];
176     require(_currentRound.isOpen == true, "current round is closed");
177     require(msg.value == _currentRound.ticketPrice, "incorrect ticket price");
178     if (_currentRound.ticketCount == 0)
179       _currentRound.begDate = now;
180     _currentRound.ticketCount++;
181     _currentRound.prize += msg.value;
182     plpPoints[msg.sender]++;
183     uint256 _ticket = _currentRound.ticketCount;
184     _currentRound.ticketOwners[_ticket] = msg.sender;
185     uint256 _playerTicketCount = _currentRound.playerTicketCounts[msg.sender];
186     _currentRound.playerTickets[msg.sender][_playerTicketCount] = _ticket;
187     _currentRound.playerTicketCounts[msg.sender]++;
188     _currentRound.playersHash = keccak256(abi.encodePacked(_currentRound.playersHash, msg.sender));
189     uint256 _currentDuration = now - _currentRound.begDate;
190     if (_currentRound.ticketCount == _currentRound.maxTickets || _currentDuration > LONG_DURATION) {
191       _currentRound.playersHash = keccak256(abi.encodePacked(_currentRound.playersHash, block.coinbase));
192       _currentRound.isOpen = false;
193       _currentRound.endDate = now;
194     }
195   }
196 
197 
198   //
199   // get info for the current round
200   // if the round is closed, then we are waiting for the winner of the previous round to claim his prize
201   //
202   function getCurrentInfo(address _addr) public view returns(uint256 _round, uint256 _playerTicketCount, uint256 _ticketPrice,
203                                                              uint256 _ticketCount, uint256 _begDate, uint256 _endDate, uint256 _prize,
204                                                              bool _isOpen, uint256 _maxTickets) {
205     Round storage _currentRound = rounds[roundCount];
206     _round = roundCount;
207     _playerTicketCount = _currentRound.playerTicketCounts[_addr];
208     _ticketPrice = _currentRound.ticketPrice;
209     _ticketCount = _currentRound.ticketCount;
210     _begDate = _currentRound.begDate;
211     _endDate = _currentRound.isOpen ? (_currentRound.begDate + LONG_DURATION) : _currentRound.endDate;
212     _prize = _currentRound.prize;
213     _isOpen = _currentRound.isOpen;
214     _maxTickets = _currentRound.maxTickets;
215   }
216 
217 
218   //
219   // get the winner of the previous round
220   //
221   function getPreviousInfo(address _addr) public view returns(uint256 _round, uint256 _playerTicketCount, uint256 _ticketPrice, uint256 _ticketCount,
222                                                               uint256 _begDate, uint256 _endDate, uint256 _prize,
223                                                               uint256 _winningTicket, address _winner, uint256 _claimDeadline, bytes32 _playersHash) {
224     Round storage _currentRound = rounds[roundCount];
225     Round storage _previousRound = rounds[roundCount - 1];
226     _round = roundCount - 1;
227     _playerTicketCount = _previousRound.playerTicketCounts[_addr];
228     _ticketPrice = _previousRound.ticketPrice;
229     _ticketCount = _previousRound.ticketCount;
230     _begDate = _previousRound.begDate;
231     _endDate = _previousRound.endDate;
232     _prize = _previousRound.prize;
233     _winningTicket = _previousRound.winner;
234     _winner = _previousRound.ticketOwners[_previousRound.winner];
235     if (_currentRound.isOpen == true) {
236       _playersHash = bytes32(0);
237       _claimDeadline = 0;
238     } else {
239       _playersHash = _currentRound.playersHash;
240       _claimDeadline = _currentRound.endDate + MAX_CLAIM_DURATION;
241     }
242   }
243 
244 
245   // get array of tickets owned by address
246   //
247   // note that array will always have _maxResults entries. ignore messageID = 0
248   //
249   function getTickets(address _addr, uint256 _round, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _tickets) {
250     uint _count = 0;
251     Round storage _subjectRound = rounds[_round];
252     _tickets = new uint256[](_maxResults);
253     uint256 _playerTicketCount = _subjectRound.playerTicketCounts[_addr];
254     mapping(uint256 => uint256) storage _playerTickets = _subjectRound.playerTickets[_addr];
255     for (_idx = _startIdx; _idx < _playerTicketCount; ++_idx) {
256       _tickets[_count] = _playerTickets[_idx];
257       if (++_count >= _maxResults)
258         break;
259     }
260   }
261 
262   // get owner of passed ticket
263   //
264   function getTicketOwner(uint256 _round, uint256 _ticket) public view returns(address _owner) {
265     Round storage _subjectRound = rounds[_round];
266     _owner = _subjectRound.ticketOwners[_ticket];
267   }
268 
269 
270   //
271   // winner of previous round claims his prize here
272   // note: you can only claim your prize while the current round is closed
273   // when the winner of the previous round claims his prize, we are then able to determine
274   // the winner of the current round, and then immediately start a new round
275   //
276   function claimPrize(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket) public {
277     Round storage _currentRound = rounds[roundCount];
278     Round storage _previousRound = rounds[roundCount - 1];
279     require(_currentRound.isOpen == false, "wait until current round is closed");
280     require(_previousRound.winner == _ticket, "not the winning ticket");
281     claimPrizeForTicket(_sigV, _sigR, _sigS, _ticket, 2);
282     newRound();
283   }
284 
285 
286   //
287   // any participant of previous round claims an abandoned prize here
288   // only after MAX_CLAIM_DURATION
289   //
290   function claimAbondonedPrize(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket) public {
291     Round storage _currentRound = rounds[roundCount];
292     require(_currentRound.isOpen == false, "wait until current round is closed");
293     require(now >= _currentRound.endDate + MAX_CLAIM_DURATION, "prize is not abondoned yet");
294     claimPrizeForTicket(_sigV, _sigR, _sigS, _ticket, 50);
295     newRound();
296   }
297 
298 
299   //
300   // verifies signature against claimed ticket; sends prize to claimer
301   // computes winner of current round
302   //
303   function claimPrizeForTicket(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, uint256 _ticket, uint256 _ownerCutPct) internal {
304     Round storage _currentRound = rounds[roundCount];
305     Round storage _previousRound = rounds[roundCount - 1];
306     bytes32 _claimHash = keccak256(abi.encode(CLAIM_TYPEHASH, nameHash, roundCount - 1, _ticket, _currentRound.playersHash));
307     bytes32 _domainClaimHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, _claimHash));
308     address _recovered = ecrecover(_domainClaimHash, _sigV, _sigR, _sigS);
309     require(_previousRound.ticketOwners[_ticket] == _recovered, "claim is not valid");
310     uint256 _tokenCut = _ownerCutPct * _previousRound.prize / 100;
311     tokenHoldoverBalance += _tokenCut;
312     uint256 _payout = _previousRound.prize - _tokenCut;
313     balances[msg.sender] += _payout;
314     bytes32 _winningHash = keccak256(abi.encodePacked(_currentRound.playersHash, _sigV, _sigR, _sigS));
315     _currentRound.winner = uint256(_winningHash) % _currentRound.ticketCount + 1;
316     emit PayoutEvent(roundCount - 1, msg.sender, _previousRound.prize, _payout);
317     emit WinnerEvent(roundCount, _currentRound.winner, _currentRound.prize);
318     //
319     if (tokenHoldoverBalance > TOKEN_HOLDOVER_THRESHOLD) {
320       uint _amount = tokenHoldoverBalance;
321       tokenHoldoverBalance = 0;
322       (bool paySuccess, ) = address(plpToken).call.value(_amount)("");
323       if (!paySuccess)
324         revert();
325     }
326   }
327 
328 
329   //
330   // open a new round - adjust lottery parameters
331   // goal is that duration should be between SHORT_DURATION and LONG_DURATION
332   // first we adjust ticket price, but if price is already at the corresponding limit, then we adjust maxTickets
333   //
334   function newRound() internal {
335     ++roundCount;
336     Round storage _nextRound = rounds[roundCount];
337     Round storage _currentRound = rounds[roundCount - 1];
338     uint256 _currentDuration = _currentRound.endDate - _currentRound.begDate;
339     //
340     if (_currentDuration < SHORT_DURATION) {
341       if (_currentRound.ticketPrice < max_ticket_price && _currentRound.maxTickets > MIN_TICKETS * 10) {
342          _nextRound.ticketPrice = max_ticket_price;
343          _nextRound.maxTickets = _currentRound.maxTickets;
344        } else {
345          _nextRound.ticketPrice = _currentRound.ticketPrice;
346          _nextRound.maxTickets = 2 * _currentRound.maxTickets;
347          if (_nextRound.maxTickets > MAX_TICKETS)
348            _nextRound.maxTickets = MAX_TICKETS;
349        }
350     } else if (_currentDuration > LONG_DURATION) {
351        if (_currentRound.ticketPrice > min_ticket_price) {
352          _nextRound.ticketPrice = min_ticket_price;
353          _nextRound.maxTickets = _currentRound.maxTickets;
354        } else {
355          _nextRound.ticketPrice = min_ticket_price;
356          _nextRound.maxTickets = _currentRound.maxTickets / 2;
357          if (_nextRound.maxTickets < MIN_TICKETS)
358            _nextRound.maxTickets = MIN_TICKETS;
359        }
360     } else {
361       _nextRound.maxTickets = _currentRound.maxTickets;
362       _nextRound.ticketPrice = (min_ticket_price + max_ticket_price) / 2;
363     }
364     //_nextRound.ticketCount = 0;
365     //_nextRound.endDate = 0;
366     //_nextRound.begDate = 0;
367     _nextRound.isOpen = true;
368   }
369 
370 
371   //
372   // redeem caller's transfer-points for PLP Tokens
373   // make sure the reserve account has sufficient tokens before calling
374   //
375   function redeemPlpPoints() public {
376     uint256 noTokens = plpPoints[msg.sender];
377     plpPoints[msg.sender] = 0;
378     plpToken.transferFromReserve(msg.sender, noTokens);
379   }
380 
381 
382   //
383   // withdraw accumulated prize
384   //
385   function withdraw() public {
386     uint256 _amount = balances[msg.sender];
387     balances[msg.sender] = 0;
388     msg.sender.transfer(_amount);
389   }
390 
391 
392   //
393   // for debug
394   // only available before the contract is locked
395   //
396   function killContract() public ownerOnly unlockedOnly {
397     selfdestruct(owner);
398   }
399 }