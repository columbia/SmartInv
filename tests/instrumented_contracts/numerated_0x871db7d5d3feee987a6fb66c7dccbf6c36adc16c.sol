1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-06
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 
8 // ----------------------------------------------------------------------------
9 
10 // '0xLitecoin Token' contract
11 
12 // Mineable ERC20 Token using Proof Of Work
13 
14 //
15 
16 // Symbol      : 0xLTC
17 
18 // Name        : 0xLitecoin Token
19 
20 // Total supply: 84,000,000.00
21 
22 // Decimals    : 8
23 
24 //
25 
26 
27 // ----------------------------------------------------------------------------
28 
29 
30 
31 // ----------------------------------------------------------------------------
32 
33 // Safe maths
34 
35 // ----------------------------------------------------------------------------
36 
37 library SafeMath {
38 
39     function add(uint a, uint b) internal pure returns (uint c) {
40 
41         c = a + b;
42 
43         require(c >= a);
44 
45     }
46 
47     function sub(uint a, uint b) internal pure returns (uint c) {
48 
49         require(b <= a);
50 
51         c = a - b;
52 
53     }
54 
55     function mul(uint a, uint b) internal pure returns (uint c) {
56 
57         c = a * b;
58 
59         require(a == 0 || c / a == b);
60 
61     }
62 
63     function div(uint a, uint b) internal pure returns (uint c) {
64 
65         require(b > 0);
66 
67         c = a / b;
68 
69     }
70 
71 }
72 
73 
74 
75 library ExtendedMath {
76 
77 
78     //return the smaller of the two inputs (a or b)
79     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
80 
81         if(a > b) return b;
82 
83         return a;
84 
85     }
86 }
87 
88 // ----------------------------------------------------------------------------
89 
90 // ERC Token Standard #20 Interface
91 
92 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
93 
94 // ----------------------------------------------------------------------------
95 
96 contract ERC20Interface {
97 
98     function totalSupply() public constant returns (uint);
99 
100     function balanceOf(address tokenOwner) public constant returns (uint balance);
101 
102     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
103 
104     function transfer(address to, uint tokens) public returns (bool success);
105 
106     function approve(address spender, uint tokens) public returns (bool success);
107 
108     function transferFrom(address from, address to, uint tokens) public returns (bool success);
109 
110 
111     event Transfer(address indexed from, address indexed to, uint tokens);
112 
113     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
114 
115 }
116 
117 
118 
119 // ----------------------------------------------------------------------------
120 
121 // Contract function to receive approval and execute function in one call
122 
123 //
124 
125 // Borrowed from MiniMeToken
126 
127 // ----------------------------------------------------------------------------
128 
129 contract ApproveAndCallFallBack {
130 
131     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
132 
133 }
134 
135 
136 
137 // ----------------------------------------------------------------------------
138 
139 // Owned contract
140 
141 // ----------------------------------------------------------------------------
142 
143 contract Owned {
144 
145     address public owner;
146 
147     address public newOwner;
148 
149 
150     event OwnershipTransferred(address indexed _from, address indexed _to);
151 
152 
153     function Owned() public {
154 
155         owner = msg.sender;
156 
157     }
158 
159 
160     modifier onlyOwner {
161 
162         require(msg.sender == owner);
163 
164         _;
165 
166     }
167 
168 
169     function transferOwnership(address _newOwner) public onlyOwner {
170 
171         newOwner = _newOwner;
172 
173     }
174 
175     function acceptOwnership() public {
176 
177         require(msg.sender == newOwner);
178 
179         OwnershipTransferred(owner, newOwner);
180 
181         owner = newOwner;
182 
183         newOwner = address(0);
184 
185     }
186 
187 }
188 
189 
190 
191 // ----------------------------------------------------------------------------
192 
193 // ERC20 Token, with the addition of symbol, name and decimals and an
194 
195 // initial fixed supply
196 
197 // ----------------------------------------------------------------------------
198 
199 contract _0xLitecoinToken is ERC20Interface, Owned {
200 
201     using SafeMath for uint;
202     using ExtendedMath for uint;
203 
204 
205     string public symbol;
206 
207     string public  name;
208 
209     uint8 public decimals;
210 
211     uint public _totalSupply;
212 
213 
214 
215      uint public latestDifficultyPeriodStarted;
216 
217 
218 
219     uint public epochCount;//number of 'blocks' mined
220 
221 
222     uint public _BLOCKS_PER_READJUSTMENT = 1024;
223 
224 
225     //a little number
226     uint public  _MINIMUM_TARGET = 2**16;
227 
228 
229       //a big number is easier ; just find a solution that is smaller
230     //uint public  _MAXIMUM_TARGET = 2**224;  Litecoin uses 224
231     uint public  _MAXIMUM_TARGET = 2**234;
232 
233 
234     uint public miningTarget;
235 
236     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
237 
238 
239 
240     uint public rewardEra;
241     uint public maxSupplyForEra;
242 
243 
244     address public lastRewardTo;
245     uint public lastRewardAmount;
246     uint public lastRewardEthBlockNumber;
247 
248     bool locked = false;
249 
250     mapping(bytes32 => bytes32) solutionForChallenge;
251 
252     uint public tokensMinted;
253 
254     mapping(address => uint) balances;
255 
256 
257     mapping(address => mapping(address => uint)) allowed;
258 
259 
260     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
261 
262     // ------------------------------------------------------------------------
263 
264     // Constructor
265 
266     // ------------------------------------------------------------------------
267 
268     function _0xLitecoinToken() public onlyOwner{
269 
270 
271 
272         symbol = "0xLTC";
273 
274         name = "0xLitecoin Token";
275 
276         decimals = 8;
277 
278         _totalSupply = 84000000 * 10**uint(decimals);
279 
280         if(locked) revert();
281         locked = true;
282 
283         tokensMinted = 0;
284 
285         rewardEra = 0;
286         maxSupplyForEra = _totalSupply.div(2);
287 
288         miningTarget = _MAXIMUM_TARGET;
289 
290         latestDifficultyPeriodStarted = block.number;
291 
292         _startNewMiningEpoch();
293 
294 
295         //The owner gets nothing! You must mine this ERC20 token
296         //balances[owner] = _totalSupply;
297         //Transfer(address(0), owner, _totalSupply);
298 
299     }
300 
301 
302 
303 
304         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
305 
306 
307             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
308             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
309 
310             //the challenge digest must match the expected
311             if (digest != challenge_digest) revert();
312 
313             //the digest must be smaller than the target
314             if(uint256(digest) > miningTarget) revert();
315 
316 
317             //only allow one reward for each challenge
318              bytes32 solution = solutionForChallenge[challengeNumber];
319              solutionForChallenge[challengeNumber] = digest;
320              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
321 
322 
323             uint reward_amount = getMiningReward();
324 
325             balances[msg.sender] = balances[msg.sender].add(reward_amount);
326 
327             tokensMinted = tokensMinted.add(reward_amount);
328 
329 
330             //Cannot mint more tokens than there are
331             assert(tokensMinted <= maxSupplyForEra);
332 
333             //set readonly diagnostics data
334             lastRewardTo = msg.sender;
335             lastRewardAmount = reward_amount;
336             lastRewardEthBlockNumber = block.number;
337 
338 
339              _startNewMiningEpoch();
340 
341               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
342 
343            return true;
344 
345         }
346 
347 
348     //a new 'block' to be mined
349     function _startNewMiningEpoch() internal {
350 
351       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
352 
353       //40 is the final reward era, almost all tokens minted
354       //once the final era is reached, more tokens will not be given out because the assert function
355       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
356       {
357         rewardEra = rewardEra + 1;
358       }
359 
360       //set the next minted supply at which the era will change
361       // total supply is 8400000000000000  because of 8 decimal places
362       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
363 
364       epochCount = epochCount.add(1);
365 
366       //every so often, readjust difficulty. Dont readjust when deploying
367       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
368       {
369         _reAdjustDifficulty();
370       }
371 
372 
373       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
374       //do this last since this is a protection mechanism in the mint() function
375       challengeNumber = block.blockhash(block.number - 1);
376 
377 
378 
379 
380 
381 
382     }
383 
384 
385 
386 
387     //https://en.Litecoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
388     //as of 2017 the Litecoin difficulty was up to 17 zeroes, it was only 8 in the early days
389 
390     //readjust the target by 5 percent
391     function _reAdjustDifficulty() internal {
392 
393 
394         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
395         //assume 360 ethereum blocks per hour
396 
397         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xLitecoin epoch
398         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
399 
400         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
401 
402         //if there were less eth blocks passed in time than expected
403         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
404         {
405           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
406 
407           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
408           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
409 
410           //make it harder
411           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
412         }else{
413           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
414 
415           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
416 
417           //make it easier
418           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
419         }
420 
421 
422 
423         latestDifficultyPeriodStarted = block.number;
424 
425         if(miningTarget < _MINIMUM_TARGET) //very difficult
426         {
427           miningTarget = _MINIMUM_TARGET;
428         }
429 
430         if(miningTarget > _MAXIMUM_TARGET) //very easy
431         {
432           miningTarget = _MAXIMUM_TARGET;
433         }
434     }
435 
436 
437     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
438     function getChallengeNumber() public constant returns (bytes32) {
439         return challengeNumber;
440     }
441 
442     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
443      function getMiningDifficulty() public constant returns (uint) {
444         return _MAXIMUM_TARGET.div(miningTarget);
445     }
446 
447     function getMiningTarget() public constant returns (uint) {
448        return miningTarget;
449    }
450 
451 
452 
453     //84m coins total
454     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
455     function getMiningReward() public constant returns (uint) {
456         //once we get half way thru the coins, only get 25 per block
457 
458          //every reward era, the reward amount halves.
459 
460          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
461 
462     }
463 
464     //help debug mining software
465     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
466 
467         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
468 
469         return digest;
470 
471       }
472 
473         //help debug mining software
474       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
475 
476           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
477 
478           if(uint256(digest) > testTarget) revert();
479 
480           return (digest == challenge_digest);
481 
482         }
483 
484 
485 
486     // ------------------------------------------------------------------------
487 
488     // Total supply
489 
490     // ------------------------------------------------------------------------
491 
492     function totalSupply() public constant returns (uint) {
493 
494         return _totalSupply  - balances[address(0)];
495 
496     }
497 
498 
499 
500     // ------------------------------------------------------------------------
501 
502     // Get the token balance for account `tokenOwner`
503 
504     // ------------------------------------------------------------------------
505 
506     function balanceOf(address tokenOwner) public constant returns (uint balance) {
507 
508         return balances[tokenOwner];
509 
510     }
511 
512 
513 
514     // ------------------------------------------------------------------------
515 
516     // Transfer the balance from token owner's account to `to` account
517 
518     // - Owner's account must have sufficient balance to transfer
519 
520     // - 0 value transfers are allowed
521 
522     // ------------------------------------------------------------------------
523 
524     function transfer(address to, uint tokens) public returns (bool success) {
525 
526         balances[msg.sender] = balances[msg.sender].sub(tokens);
527 
528         balances[to] = balances[to].add(tokens);
529 
530         Transfer(msg.sender, to, tokens);
531 
532         return true;
533 
534     }
535 
536 
537 
538     // ------------------------------------------------------------------------
539 
540     // Token owner can approve for `spender` to transferFrom(...) `tokens`
541 
542     // from the token owner's account
543 
544     //
545 
546     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
547 
548     // recommends that there are no checks for the approval double-spend attack
549 
550     // as this should be implemented in user interfaces
551 
552     // ------------------------------------------------------------------------
553 
554     function approve(address spender, uint tokens) public returns (bool success) {
555 
556         allowed[msg.sender][spender] = tokens;
557 
558         Approval(msg.sender, spender, tokens);
559 
560         return true;
561 
562     }
563 
564 
565 
566     // ------------------------------------------------------------------------
567 
568     // Transfer `tokens` from the `from` account to the `to` account
569 
570     //
571 
572     // The calling account must already have sufficient tokens approve(...)-d
573 
574     // for spending from the `from` account and
575 
576     // - From account must have sufficient balance to transfer
577 
578     // - Spender must have sufficient allowance to transfer
579 
580     // - 0 value transfers are allowed
581 
582     // ------------------------------------------------------------------------
583 
584     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
585 
586         balances[from] = balances[from].sub(tokens);
587 
588         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
589 
590         balances[to] = balances[to].add(tokens);
591 
592         Transfer(from, to, tokens);
593 
594         return true;
595 
596     }
597 
598 
599 
600     // ------------------------------------------------------------------------
601 
602     // Returns the amount of tokens approved by the owner that can be
603 
604     // transferred to the spender's account
605 
606     // ------------------------------------------------------------------------
607 
608     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
609 
610         return allowed[tokenOwner][spender];
611 
612     }
613 
614 
615 
616     // ------------------------------------------------------------------------
617 
618     // Token owner can approve for `spender` to transferFrom(...) `tokens`
619 
620     // from the token owner's account. The `spender` contract function
621 
622     // `receiveApproval(...)` is then executed
623 
624     // ------------------------------------------------------------------------
625 
626     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
627 
628         allowed[msg.sender][spender] = tokens;
629 
630         Approval(msg.sender, spender, tokens);
631 
632         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
633 
634         return true;
635 
636     }
637 
638 
639 
640     // ------------------------------------------------------------------------
641 
642     // Don't accept ETH
643 
644     // ------------------------------------------------------------------------
645 
646     function () public payable {
647 
648         revert();
649 
650     }
651 
652 
653 
654     // ------------------------------------------------------------------------
655 
656     // Owner can transfer out any accidentally sent ERC20 tokens
657 
658     // ------------------------------------------------------------------------
659 
660     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
661 
662         return ERC20Interface(tokenAddress).transfer(owner, tokens);
663 
664     }
665 
666 }