1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93     function start() public auth note {
94         stopped = false;
95     }
96 
97 }
98 
99 // Token standard API
100 // https://github.com/ethereum/EIPs/issues/20
101 
102 contract ERC20 {
103     function totalSupply() public view returns (uint supply);
104     function balanceOf( address who ) public view returns (uint value);
105     function allowance( address owner, address spender ) public view returns (uint _allowance);
106 
107     function transfer( address to, uint value) public returns (bool ok);
108     function transferFrom( address from, address to, uint value) public returns (bool ok);
109     function approve( address spender, uint value ) public returns (bool ok);
110 
111     event Transfer( address indexed from, address indexed to, uint value);
112     event Approval( address indexed owner, address indexed spender, uint value);
113 }
114 
115 /**
116  * Math operations with safety checks
117  */
118 library SafeMath {
119   function mul(uint a, uint b) internal returns (uint) {
120     uint c = a * b;
121     assert(a == 0 || c / a == b);
122     return c;
123   }
124 
125   function div(uint a, uint b) internal returns (uint) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     uint c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return c;
130   }
131 
132   function sub(uint a, uint b) internal returns (uint) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   function add(uint a, uint b) internal returns (uint) {
138     uint c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 
143   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
144     return a >= b ? a : b;
145   }
146 
147   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
148     return a < b ? a : b;
149   }
150 
151   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
152     return a >= b ? a : b;
153   }
154 
155   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
156     return a < b ? a : b;
157   }
158 }
159 
160 contract BetGame is DSStop {
161     using SafeMath for uint256;
162 
163     struct Bet {
164         // player
165         address player;
166         bytes32 secretHash;
167         uint256 amount;
168         uint roundId;
169 
170         // secret and reveal
171         bool isRevealed;    // flag
172         uint nonce;
173         bool guessOdd;
174         bytes32 secret;
175     }
176 
177     struct Round {
178         uint betCount;
179         uint[] betIds;
180 
181         uint startBetBlock;
182         uint startRevealBlock;
183         uint maxBetBlockCount;      // Max Block Count for wating others to join betting, will return funds if no enough bets join in.
184         uint maxRevealBlockCount;   // Should have enough minimal blocks e.g. >100
185         uint finalizedBlock;
186     }
187 
188     uint public betCount;
189     uint public roundCount;
190 
191     mapping(uint => Bet) public bets;
192     mapping(uint => Round) public rounds;
193     mapping(address => uint) public balancesForWithdraw;
194 
195     uint public poolAmount;
196     uint256 public initializeTime;
197     ERC20 public pls;
198 
199     struct TokenMessage {
200         bool init;
201         address fallbackFrom;
202         uint256 fallbackValue;
203     }
204 
205     TokenMessage public tokenMsg;
206 
207     modifier notNull(address _address) {
208         if (_address == 0)
209             throw;
210         _;
211     }
212 
213     modifier tokenPayable {
214         require(msg.sender == address(this));
215         require(tokenMsg.init);
216 
217         _;
218     }
219 
220     function BetGame(address _pls)
221     {
222         initializeTime = now;
223         roundCount = 1;
224 
225         pls = ERC20(_pls);
226     }
227 
228     function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool) {
229         if (_to == address(this))
230         {
231             if (stopped) return false;
232         }
233 
234         return true;
235     }
236 
237     function receiveToken(address from, uint256 _amount, address _token) public
238     {
239         // do nothing.
240     }
241 
242     function tokenFallback(address _from, uint256 _value, bytes _data) public
243     {
244         require(msg.sender == address(pls));
245         require(!stopped);
246         tokenMsg.init = true;
247         tokenMsg.fallbackFrom = _from;
248         tokenMsg.fallbackValue = _value;
249 
250         if(! this.call(_data)){
251             revert();
252         }
253 
254         tokenMsg.init = false;
255         tokenMsg.fallbackFrom = 0x0;
256         tokenMsg.fallbackValue = 0;
257     }
258     
259     function startRoundWithFirstBet(uint _betCount, uint _maxBetBlockCount, uint _maxRevealBlockCount, bytes32 _secretHashForFirstBet) public tokenPayable returns (uint roundId)
260     {
261         require(_betCount >= 2);
262         require(_maxBetBlockCount >= 100);
263         require(_maxRevealBlockCount >= 100);
264 
265         require(tokenMsg.fallbackValue > 0);
266 
267         uint betId = addBet(tokenMsg.fallbackFrom, _secretHashForFirstBet, tokenMsg.fallbackValue);
268 
269         roundId = addRound(_betCount, _maxBetBlockCount, _maxRevealBlockCount, betId);
270     }
271 
272     function betWithRound(uint _roundId, bytes32 _secretHashForBet) public tokenPayable
273     {
274         require(tokenMsg.fallbackValue > 0);
275         require(rounds[_roundId].finalizedBlock == 0);
276         require(rounds[_roundId].betIds.length < rounds[_roundId].betCount);
277         require(!isPlayerInRound(_roundId, tokenMsg.fallbackFrom));
278 
279         uint betId = addBet(tokenMsg.fallbackFrom, _secretHashForBet, tokenMsg.fallbackValue);
280         rounds[_roundId].betIds.push(betId);
281         bets[betId].roundId = _roundId;
282 
283         if (rounds[_roundId].betIds.length == rounds[_roundId].betCount)
284         {
285             rounds[_roundId].startRevealBlock = getBlockNumber();
286 
287             RoundRevealStarted(_roundId, rounds[_roundId].startRevealBlock);
288         }
289     }
290 
291     // anyone can try to reveal the bet
292     function revealBet(uint betId, uint _nonce, bool _guessOdd, bytes32 _secret) public returns (bool)
293     {
294         Bet bet = bets[betId];
295         Round round = rounds[bet.roundId];
296         require(round.betIds.length == round.betCount);
297         require(round.finalizedBlock == 0);
298 
299         if (bet.secretHash == keccak256(_nonce, _guessOdd, _secret) )
300         {
301             bet.isRevealed = true;
302             bet.nonce = _nonce;
303             bet.guessOdd = _guessOdd;
304             bet.secret = _secret;
305             
306             return true;
307         }
308         
309         return false;
310     }
311 
312     // anyone can try to finalize after the max block count or bets in the round are all revealed.
313     function finalizeRound(uint roundId) public
314     {
315         require(rounds[roundId].finalizedBlock == 0);
316         uint finalizedBlock = getBlockNumber();
317         
318         uint i = 0;
319         Bet bet;
320         if (rounds[roundId].betIds.length < rounds[roundId].betCount && finalizedBlock.sub(rounds[roundId].startBetBlock) > rounds[roundId].maxBetBlockCount)
321         {
322             // return funds to players if betting timeout
323             for (i=0; i<rounds[roundId].betIds.length; i++) {
324                 bet = bets[rounds[roundId].betIds[i]];
325                 balancesForWithdraw[bet.player] = balancesForWithdraw[bet.player].add(bet.amount);
326             }
327         } else if (rounds[roundId].betIds.length == rounds[roundId].betCount) {
328             bool betsRevealed = betRevealed(roundId);
329             if (!betsRevealed && finalizedBlock.sub(rounds[roundId].startRevealBlock) > rounds[roundId].maxRevealBlockCount)
330             {
331                 // return funds to players who have already revealed
332                 // but for those who didn't reveal, the funds go to pool
333                 // revealing timeout
334                 for (i = 0; i < rounds[roundId].betIds.length; i++) {
335                     if (bets[rounds[roundId].betIds[i]].isRevealed)
336                     {
337                         balancesForWithdraw[bets[rounds[roundId].betIds[i]].player] = balancesForWithdraw[bets[rounds[roundId].betIds[i]].player].add(bets[rounds[roundId].betIds[i]].amount);
338                     } else
339                     {
340                         // go to pool
341                         poolAmount = poolAmount.add(bets[rounds[roundId].betIds[i]].amount);
342                     }
343                 }
344             } else if (betsRevealed)
345             {
346                 uint dustLeft = finalizeRewardForRound(roundId);
347                 poolAmount = poolAmount.add(dustLeft);
348             } else
349             {
350                 throw;
351             }
352 
353         } else
354         {
355             throw;
356         }
357 
358         rounds[roundId].finalizedBlock = finalizedBlock;
359         RoundFinalized(roundId);
360     }
361 
362     function withdraw() public returns (bool)
363     {
364         var amount = balancesForWithdraw[msg.sender];
365         if (amount > 0) {
366             balancesForWithdraw[msg.sender] = 0;
367 
368             if (!pls.transfer(msg.sender, amount)) {
369                 // No need to call throw here, just reset the amount owing
370                 balancesForWithdraw[msg.sender] = amount;
371                 return false;
372             }
373         }
374         return true;
375     }
376 
377     function claimFromPool() public auth
378     {
379         owner.transfer(poolAmount);
380         ClaimFromPool();
381     }
382 
383     /*
384      * Constant functions
385      */
386     // For players to calculate hash of secret before start a bet.
387     function calculateSecretHash(uint _nonce, bool _guessOdd, bytes32 _secret) constant public returns (bytes32 secretHash)
388     {
389         secretHash = keccak256(_nonce, _guessOdd, _secret);
390     }
391 
392     function isPlayerInRound(uint _roundId, address _player) public constant returns (bool isIn)
393     {
394         for (uint i=0; i < rounds[_roundId].betIds.length; i++) {
395             if (bets[rounds[_roundId].betIds[i]].player == _player)
396             {
397                 isIn = true;
398                 return;
399             }
400         }
401 
402         isIn = false;
403     }
404     
405     function getBetIds(uint roundIndex) public constant returns (uint[] _betIds)
406     {
407         _betIds = new uint[](rounds[roundIndex].betIds.length);
408 
409         for (uint i=0; i < rounds[roundIndex].betIds.length; i++)
410             _betIds[i] = rounds[roundIndex].betIds[i];
411     }
412 
413     function getBetIdAtRound(uint roundIndex, uint innerIndex) constant public returns (uint) {
414         return rounds[roundIndex].betIds[innerIndex];
415     }
416 
417     function getBetSizeAtRound(uint roundIndex) constant public returns (uint) {
418         return rounds[roundIndex].betIds.length;
419     }
420 
421     function betRevealed(uint roundId) constant public returns(bool)
422     {
423         bool betsRevealed = true;
424         uint i = 0;
425         Bet bet;
426         for (i=0; i<rounds[roundId].betIds.length; i++) {
427             bet = bets[rounds[roundId].betIds[i]];
428             if (!bet.isRevealed)
429             {
430                 betsRevealed = false;
431                 break;
432             }
433         }
434         
435         return betsRevealed;
436     }
437     
438     function getJackpotResults(uint roundId) constant public returns(uint, uint, bool)
439     {
440         uint jackpotSum;
441         uint jackpotSecret;
442         uint oddSum;
443 
444         uint i = 0;
445         for (i=0; i<rounds[roundId].betIds.length; i++) {
446             jackpotSum = jackpotSum.add(bets[rounds[roundId].betIds[i]].amount);
447             jackpotSecret = jackpotSecret.add(uint(bets[rounds[roundId].betIds[i]].secret));
448             
449             if( bets[rounds[roundId].betIds[i]].guessOdd ){
450                 oddSum = oddSum.add(bets[rounds[roundId].betIds[i]].amount);
451             }
452         }
453         
454         bool isOddWin = (jackpotSecret % 2 == 1);
455 
456         // all is odd, or all is not odd
457         if (oddSum == 0 || oddSum == jackpotSum)
458         {
459             isOddWin = oddSum > 0 ? true : false;
460         }
461         
462         return (jackpotSum, oddSum, isOddWin);
463     }
464 
465     /// @notice This function is overridden by the test Mocks.
466     function getBlockNumber() internal constant returns (uint256) {
467         return block.number;
468     }
469 
470     /*
471      * Internal functions
472      */
473     /// @dev Adds a new bet to the bet mapping, if bet does not exist yet.
474     /// @param _player The player of the bet.
475     /// @param _secretHash The hash of the nonce, guessOdd, and secret for the bet, hash ＝ keccak256(_num, _guessOdd, _secret) 
476     /// @param _amount The amount of the bet.
477     /// @return Returns bet ID.
478     function addBet(address _player, bytes32 _secretHash, uint256 _amount)
479         internal
480         notNull(_player)
481         returns (uint betId)
482     {
483         betId = betCount;
484         bets[betId] = Bet({
485             player: _player,
486             secretHash: _secretHash,
487             amount: _amount,
488             roundId: 0,
489             isRevealed: false,
490             nonce:0,
491             guessOdd:false,
492             secret: ""
493         });
494         betCount += 1;
495         BetSubmission(betId);
496     }
497 
498     function addRound(uint _betCount, uint _maxBetBlockCount, uint _maxRevealBlockCount, uint _betId)
499         internal
500         returns (uint roundId)
501     {
502         roundId = roundCount;
503         rounds[roundId].betCount = _betCount;
504         rounds[roundId].maxBetBlockCount = _maxBetBlockCount;
505         rounds[roundId].maxRevealBlockCount = _maxRevealBlockCount;
506         rounds[roundId].betIds.push(_betId);
507         rounds[roundId].startBetBlock = getBlockNumber();
508         rounds[roundId].startRevealBlock = 0;
509         rounds[roundId].finalizedBlock = 0;
510 
511         bets[_betId].roundId = roundId;
512 
513         roundCount += 1;
514         RoundSubmission(roundId);
515         RoundBetStarted(roundId, rounds[roundId].startBetBlock);
516     }
517     
518     function finalizeRewardForBet(uint betId, bool isOddWin, uint jackpotSum, uint oddSum, uint evenSum, uint dustLeft) internal returns(uint)
519     {
520         uint reward = 0;
521         if (isOddWin && bets[betId].guessOdd)
522         {
523             reward = bets[betId].amount.mul(jackpotSum).div(oddSum);
524             balancesForWithdraw[bets[betId].player] = balancesForWithdraw[bets[betId].player].add(reward);
525             dustLeft = dustLeft.sub(reward);
526         } else if (!isOddWin && !bets[betId].guessOdd)
527         {
528             reward = bets[betId].amount.mul(jackpotSum).div(evenSum);
529             balancesForWithdraw[bets[betId].player] = balancesForWithdraw[bets[betId].player].add(reward);
530             dustLeft = dustLeft.sub(reward);
531         }
532         
533         return dustLeft;
534     }
535     
536     function finalizeRewardForRound(uint roundId) internal returns (uint dustLeft)
537     {
538         var (jackpotSum, oddSum, isOddWin) = getJackpotResults(roundId);
539 
540         dustLeft = jackpotSum;
541 
542         uint i = 0;
543         for (i=0; i<rounds[roundId].betIds.length; i++) {
544             dustLeft = finalizeRewardForBet(rounds[roundId].betIds[i], isOddWin, jackpotSum, oddSum, jackpotSum - oddSum, dustLeft);
545         }
546     }
547     
548     /// @notice This method can be used by the controller to extract mistakenly
549     ///  sent tokens to this contract.
550     /// @param _token The address of the token contract that you want to recover
551     ///  set to 0 in case you want to extract ether.
552     function claimTokens(address _token) public auth {
553         if (_token == 0x0) {
554             owner.transfer(this.balance);
555             return;
556         }
557         
558         ERC20 token = ERC20(_token);
559         
560         uint256 balance = token.balanceOf(this);
561         
562         token.transfer(owner, balance);
563         ClaimedTokens(_token, owner, balance);
564     }
565 
566     event BetSubmission(uint indexed _betId);
567     event RoundSubmission(uint indexed _roundId);
568     event ClaimFromPool();
569     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
570     event RoundFinalized(uint indexed _roundId);
571     event RoundBetStarted(uint indexed _roundId, uint startBetBlock);
572     event RoundRevealStarted(uint indexed _roundId, uint startRevealBlock);
573 }