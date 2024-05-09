1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'Yiha' contract
7 
8 // Mineable ERC20 Token using Proof Of Work
9 
10 //
11 
12 // Symbol      : YIHA
13 
14 // Name        : Yiha
15 
16 // Total supply: 250,000,000.00
17 
18 // Decimals    : 8
19 
20 //
21 
22 
23 // ----------------------------------------------------------------------------
24 
25 
26 
27 // ----------------------------------------------------------------------------
28 
29 // Safe maths
30 
31 // ----------------------------------------------------------------------------
32 
33 library SafeMath {
34 
35     function add(uint a, uint b) internal pure returns (uint c) {
36 
37         c = a + b;
38 
39         require(c >= a);
40 
41     }
42 
43     function sub(uint a, uint b) internal pure returns (uint c) {
44 
45         require(b <= a);
46 
47         c = a - b;
48 
49     }
50 
51     function mul(uint a, uint b) internal pure returns (uint c) {
52 
53         c = a * b;
54 
55         require(a == 0 || c / a == b);
56 
57     }
58 
59     function div(uint a, uint b) internal pure returns (uint c) {
60 
61         require(b > 0);
62 
63         c = a / b;
64 
65     }
66 
67 }
68 
69 
70 
71 library ExtendedMath {
72 
73 
74     //return the smaller of the two inputs (a or b)
75     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
76 
77         if(a > b) return b;
78 
79         return a;
80 
81     }
82 }
83 
84 // ----------------------------------------------------------------------------
85 
86 // ERC Token Standard #20 Interface
87 
88 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
89 
90 // ----------------------------------------------------------------------------
91 
92 contract ERC20Interface {
93 
94     function totalSupply() public constant returns (uint);
95 
96     function balanceOf(address tokenOwner) public constant returns (uint balance);
97 
98     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
99 
100     function transfer(address to, uint tokens) public returns (bool success);
101 
102     function approve(address spender, uint tokens) public returns (bool success);
103 
104     function transferFrom(address from, address to, uint tokens) public returns (bool success);
105 
106 
107     event Transfer(address indexed from, address indexed to, uint tokens);
108 
109     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
110 
111 }
112 
113 
114 
115 // ----------------------------------------------------------------------------
116 
117 // Contract function to receive approval and execute function in one call
118 
119 //
120 
121 // Borrowed from MiniMeToken
122 
123 // ----------------------------------------------------------------------------
124 
125 contract ApproveAndCallFallBack {
126 
127     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
128 
129 }
130 
131 
132 
133 // ----------------------------------------------------------------------------
134 
135 // Owned contract
136 
137 // ----------------------------------------------------------------------------
138 
139 contract Owned {
140 
141     address public owner;
142 
143     address public newOwner;
144 
145 
146     event OwnershipTransferred(address indexed _from, address indexed _to);
147 
148 
149     function Owned() public {
150 
151         owner = msg.sender;
152 
153     }
154 
155 
156     modifier onlyOwner {
157 
158         require(msg.sender == owner);
159 
160         _;
161 
162     }
163 
164 
165     function transferOwnership(address _newOwner) public onlyOwner {
166 
167         newOwner = _newOwner;
168 
169     }
170 
171     function acceptOwnership() public {
172 
173         require(msg.sender == newOwner);
174 
175         OwnershipTransferred(owner, newOwner);
176 
177         owner = newOwner;
178 
179         newOwner = address(0);
180 
181     }
182 
183 }
184 
185 
186 
187 // ----------------------------------------------------------------------------
188 
189 // ERC20 Token, with the addition of symbol, name and decimals and an
190 
191 // initial fixed supply
192 
193 // ----------------------------------------------------------------------------
194 
195 contract Yiha is ERC20Interface, Owned {
196 
197     using SafeMath for uint;
198     using ExtendedMath for uint;
199 
200 
201     string public symbol;
202 
203     string public  name;
204 
205     uint8 public decimals;
206 
207     uint public _totalSupply;
208 
209 
210 
211      uint public latestDifficultyPeriodStarted;
212 
213 
214 
215     uint public epochCount;//number of 'blocks' mined
216 
217 
218     uint public _BLOCKS_PER_READJUSTMENT = 1024;
219 
220 
221     //a little number
222     uint public  _MINIMUM_TARGET = 2**16;
223 
224 
225       //a big number is easier ; just find a solution that is smaller
226     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
227     uint public  _MAXIMUM_TARGET = 2**234;
228     uint public _START_TARGET = 2**227;
229 
230     uint public miningTarget;
231 
232     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
233 
234 
235 
236     uint public rewardEra;
237     uint public maxSupplyForEra;
238 
239 
240     address public lastRewardTo;
241     uint public lastRewardAmount;
242     uint public lastRewardEthBlockNumber;
243 
244     bool locked = false;
245 
246     mapping(bytes32 => bytes32) solutionForChallenge;
247 
248     uint public tokensMinted;
249 
250     mapping(address => uint) balances;
251 
252 
253     mapping(address => mapping(address => uint)) allowed;
254 
255 
256     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
257 
258     // ------------------------------------------------------------------------
259 
260     // Constructor
261 
262     // ------------------------------------------------------------------------
263 
264     function Yiha() public onlyOwner{
265 
266 
267 
268         symbol = "YIHA";
269 
270         name = "Yiha";
271 
272         decimals = 8;
273 
274         _totalSupply = 250000000 * 10**uint(decimals);
275 
276         if(locked) revert();
277         locked = true;
278 
279         tokensMinted = 0;
280 
281         rewardEra = 0;
282         maxSupplyForEra = _totalSupply.div(2);
283 
284         miningTarget = _START_TARGET;
285 
286         latestDifficultyPeriodStarted = block.number;
287 
288         _startNewMiningEpoch();
289 
290         balances[owner] = 50000000 * 10**uint(decimals);
291         Transfer(address(0), owner, 50000000 * 10**uint(decimals));
292 
293     }
294 
295 
296 
297 
298         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
299 
300 
301             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
302             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
303 
304             //the challenge digest must match the expected
305             if (digest != challenge_digest) revert();
306 
307             //the digest must be smaller than the target
308             if(uint256(digest) > miningTarget) revert();
309 
310 
311             //only allow one reward for each challenge
312              bytes32 solution = solutionForChallenge[challengeNumber];
313              solutionForChallenge[challengeNumber] = digest;
314              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
315 
316 
317             uint reward_amount = getMiningReward();
318 
319             balances[msg.sender] = balances[msg.sender].add(reward_amount);
320 
321             tokensMinted = tokensMinted.add(reward_amount);
322 
323 
324             //Cannot mint more tokens than there are
325             assert(tokensMinted <= maxSupplyForEra);
326 
327             //set readonly diagnostics data
328             lastRewardTo = msg.sender;
329             lastRewardAmount = reward_amount;
330             lastRewardEthBlockNumber = block.number;
331 
332 
333              _startNewMiningEpoch();
334 
335               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
336 
337            return true;
338 
339         }
340 
341 
342     //a new 'block' to be mined
343     function _startNewMiningEpoch() internal {
344 
345       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
346 
347       //40 is the final reward era, almost all tokens minted
348       //once the final era is reached, more tokens will not be given out because the assert function
349       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
350       {
351         rewardEra = rewardEra + 1;
352       }
353 
354       //set the next minted supply at which the era will change
355       // total supply is 2100000000000000  because of 8 decimal places
356       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
357 
358       epochCount = epochCount.add(1);
359 
360       //every so often, readjust difficulty. Dont readjust when deploying
361       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
362       {
363         _reAdjustDifficulty();
364       }
365 
366 
367       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
368       //do this last since this is a protection mechanism in the mint() function
369       challengeNumber = block.blockhash(block.number - 1);
370 
371 
372 
373 
374 
375 
376     }
377 
378 
379 
380 
381     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
382     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
383 
384     //readjust the target by 5 percent
385     function _reAdjustDifficulty() internal {
386 
387 
388         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
389         //assume 360 ethereum blocks per hour
390 
391         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one yiha epoch
392         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
393 
394         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
395 
396         //if there were less eth blocks passed in time than expected
397         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
398         {
399           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
400 
401           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
402           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
403 
404           //make it harder
405           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
406         }else{
407           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
408 
409           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
410 
411           //make it easier
412           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
413         }
414 
415 
416 
417         latestDifficultyPeriodStarted = block.number;
418 
419         if(miningTarget < _MINIMUM_TARGET) //very difficult
420         {
421           miningTarget = _MINIMUM_TARGET;
422         }
423 
424         if(miningTarget > _MAXIMUM_TARGET) //very easy
425         {
426           miningTarget = _MAXIMUM_TARGET;
427         }
428     }
429 
430 
431     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
432     function getChallengeNumber() public constant returns (bytes32) {
433         return challengeNumber;
434     }
435 
436     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
437      function getMiningDifficulty() public constant returns (uint) {
438         return _MAXIMUM_TARGET.div(miningTarget);
439     }
440 
441     function getMiningTarget() public constant returns (uint) {
442        return miningTarget;
443    }
444 
445 
446 
447     //21m coins total
448     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
449     function getMiningReward() public constant returns (uint) {
450         //once we get half way thru the coins, only get 25 per block
451 
452          //every reward era, the reward amount halves.
453 
454          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
455 
456     }
457 
458     //help debug mining software
459     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
460 
461         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
462 
463         return digest;
464 
465       }
466 
467         //help debug mining software
468       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
469 
470           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
471 
472           if(uint256(digest) > testTarget) revert();
473 
474           return (digest == challenge_digest);
475 
476         }
477 
478 
479 
480     // ------------------------------------------------------------------------
481 
482     // Total supply
483 
484     // ------------------------------------------------------------------------
485 
486     function totalSupply() public constant returns (uint) {
487 
488         return _totalSupply  - balances[address(0)];
489 
490     }
491 
492 
493 
494     // ------------------------------------------------------------------------
495 
496     // Get the token balance for account `tokenOwner`
497 
498     // ------------------------------------------------------------------------
499 
500     function balanceOf(address tokenOwner) public constant returns (uint balance) {
501 
502         return balances[tokenOwner];
503 
504     }
505 
506 
507 
508     // ------------------------------------------------------------------------
509 
510     // Transfer the balance from token owner's account to `to` account
511 
512     // - Owner's account must have sufficient balance to transfer
513 
514     // - 0 value transfers are allowed
515 
516     // ------------------------------------------------------------------------
517 
518     function transfer(address to, uint tokens) public returns (bool success) {
519 
520         balances[msg.sender] = balances[msg.sender].sub(tokens);
521 
522         balances[to] = balances[to].add(tokens);
523 
524         Transfer(msg.sender, to, tokens);
525 
526         return true;
527 
528     }
529 
530 
531 
532     // ------------------------------------------------------------------------
533 
534     // Token owner can approve for `spender` to transferFrom(...) `tokens`
535 
536     // from the token owner's account
537 
538     //
539 
540     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
541 
542     // recommends that there are no checks for the approval double-spend attack
543 
544     // as this should be implemented in user interfaces
545 
546     // ------------------------------------------------------------------------
547 
548     function approve(address spender, uint tokens) public returns (bool success) {
549 
550         allowed[msg.sender][spender] = tokens;
551 
552         Approval(msg.sender, spender, tokens);
553 
554         return true;
555 
556     }
557 
558 
559 
560     // ------------------------------------------------------------------------
561 
562     // Transfer `tokens` from the `from` account to the `to` account
563 
564     //
565 
566     // The calling account must already have sufficient tokens approve(...)-d
567 
568     // for spending from the `from` account and
569 
570     // - From account must have sufficient balance to transfer
571 
572     // - Spender must have sufficient allowance to transfer
573 
574     // - 0 value transfers are allowed
575 
576     // ------------------------------------------------------------------------
577 
578     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
579 
580         balances[from] = balances[from].sub(tokens);
581 
582         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
583 
584         balances[to] = balances[to].add(tokens);
585 
586         Transfer(from, to, tokens);
587 
588         return true;
589 
590     }
591 
592 
593 
594     // ------------------------------------------------------------------------
595 
596     // Returns the amount of tokens approved by the owner that can be
597 
598     // transferred to the spender's account
599 
600     // ------------------------------------------------------------------------
601 
602     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
603 
604         return allowed[tokenOwner][spender];
605 
606     }
607 
608 
609 
610     // ------------------------------------------------------------------------
611 
612     // Token owner can approve for `spender` to transferFrom(...) `tokens`
613 
614     // from the token owner's account. The `spender` contract function
615 
616     // `receiveApproval(...)` is then executed
617 
618     // ------------------------------------------------------------------------
619 
620     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
621 
622         allowed[msg.sender][spender] = tokens;
623 
624         Approval(msg.sender, spender, tokens);
625 
626         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
627 
628         return true;
629 
630     }
631 
632 
633 
634     // ------------------------------------------------------------------------
635 
636     // Don't accept ETH
637 
638     // ------------------------------------------------------------------------
639 
640     function () public payable {
641 
642         revert();
643 
644     }
645 
646 
647 
648     // ------------------------------------------------------------------------
649 
650     // Owner can transfer out any accidentally sent ERC20 tokens
651 
652     // ------------------------------------------------------------------------
653 
654     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
655 
656         return ERC20Interface(tokenAddress).transfer(owner, tokens);
657 
658     }
659 
660 }