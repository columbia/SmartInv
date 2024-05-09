1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'PoWEth' contract
7 
8 // Mineable ERC20 Token using Proof Of Work
9 
10 //
11 
12 // Symbol      : POWE
13 
14 // Name        : PoWEth
15 
16 // Total supply: 100,000,000.00
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
195 contract _PoWEth is ERC20Interface, Owned {
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
228 
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
264     function _PoWEth() public onlyOwner{
265 
266 
267 
268         symbol = "POWE";
269 
270         name = "PoWEth";
271 
272         decimals = 8;
273 
274         _totalSupply = 100000000 * 10**uint(decimals);
275 
276         if(locked) revert();
277         locked = true;
278 
279         tokensMinted = 0;
280 
281         rewardEra = 0;
282         maxSupplyForEra = _totalSupply.div(2);
283 
284         miningTarget = _MAXIMUM_TARGET;
285 
286         latestDifficultyPeriodStarted = block.number;
287 
288         _startNewMiningEpoch();
289 
290 
291         //The owner gets nothing! You must mine this ERC20 token
292         //balances[owner] = _totalSupply;
293         //Transfer(address(0), owner, _totalSupply);
294 
295     }
296 
297 
298 
299 
300         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
301 
302 
303             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
304             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
305 
306             //the challenge digest must match the expected
307             if (digest != challenge_digest) revert();
308 
309             //the digest must be smaller than the target
310             if(uint256(digest) > miningTarget) revert();
311 
312 
313             //only allow one reward for each challenge
314              bytes32 solution = solutionForChallenge[challengeNumber];
315              solutionForChallenge[challengeNumber] = digest;
316              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
317 
318 
319             uint reward_amount = getMiningReward();
320 
321             balances[msg.sender] = balances[msg.sender].add(reward_amount);
322 
323             tokensMinted = tokensMinted.add(reward_amount);
324 
325 
326             //Cannot mint more tokens than there are
327             assert(tokensMinted <= maxSupplyForEra);
328 
329             //set readonly diagnostics data
330             lastRewardTo = msg.sender;
331             lastRewardAmount = reward_amount;
332             lastRewardEthBlockNumber = block.number;
333 
334 
335              _startNewMiningEpoch();
336 
337               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
338 
339            return true;
340 
341         }
342 
343 
344     //a new 'block' to be mined
345     function _startNewMiningEpoch() internal {
346 
347       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
348 
349       //40 is the final reward era, almost all tokens minted
350       //once the final era is reached, more tokens will not be given out because the assert function
351       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
352       {
353         rewardEra = rewardEra + 1;
354       }
355 
356       //set the next minted supply at which the era will change
357       // total supply is 10000000000000000  because of 8 decimal places
358       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
359 
360       epochCount = epochCount.add(1);
361 
362       //every so often, readjust difficulty. Dont readjust when deploying
363       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
364       {
365         _reAdjustDifficulty();
366       }
367 
368 
369       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
370       //do this last since this is a protection mechanism in the mint() function
371       challengeNumber = block.blockhash(block.number - 1);
372 
373 
374 
375 
376 
377 
378     }
379 
380 
381 
382 
383     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
384     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days, we keep this for legacy
385 
386     //readjust the target by 5 percent
387     function _reAdjustDifficulty() internal {
388 
389 
390         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
391         //assume 360 ethereum blocks per hour
392 
393         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one PowETH epoch
394         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
395 
396         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
397 
398         //if there were less eth blocks passed in time than expected
399         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
400         {
401           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
402 
403           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
404           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
405 
406           //make it harder
407           miningTarget = miningTarget.sub(miningTarget.div(1000).mul(excess_block_pct_extra));   //by up to 100 %
408         }else{
409           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
410 
411           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
412 
413           //make it easier
414           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
415         }
416 
417 
418 
419         latestDifficultyPeriodStarted = block.number;
420 
421         if(miningTarget < _MINIMUM_TARGET) //very difficult
422         {
423           miningTarget = _MINIMUM_TARGET;
424         }
425 
426         if(miningTarget > _MAXIMUM_TARGET) //very easy
427         {
428           miningTarget = _MAXIMUM_TARGET;
429         }
430     }
431 
432 
433     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
434     function getChallengeNumber() public constant returns (bytes32) {
435         return challengeNumber;
436     }
437 
438     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
439      function getMiningDifficulty() public constant returns (uint) {
440         return _MAXIMUM_TARGET.div(miningTarget);
441     }
442 
443     function getMiningTarget() public constant returns (uint) {
444        return miningTarget;
445    }
446 
447 
448 
449     //100m coins total
450     //reward begins at 250 and is cut in half every reward era (as tokens are mined)
451     function getMiningReward() public constant returns (uint) {
452         //once we get half way thru the coins, only get 125 per block
453 
454          //every reward era, the reward amount halves.
455 
456          return (250 * 10**uint(decimals) ).div( 2**rewardEra ) ;
457 
458     }
459 
460         //help debug mining software
461       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
462 
463           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
464 
465           if(uint256(digest) > testTarget) revert();
466 
467           return (digest == challenge_digest);
468 
469         }
470 
471 
472 
473     // ------------------------------------------------------------------------
474 
475     // Total supply
476 
477     // ------------------------------------------------------------------------
478 
479     function totalSupply() public constant returns (uint) {
480 
481         return _totalSupply  - balances[address(0)];
482 
483     }
484 
485 
486 
487     // ------------------------------------------------------------------------
488 
489     // Get the token balance for account `tokenOwner`
490 
491     // ------------------------------------------------------------------------
492 
493     function balanceOf(address tokenOwner) public constant returns (uint balance) {
494 
495         return balances[tokenOwner];
496 
497     }
498 
499 
500 
501     // ------------------------------------------------------------------------
502 
503     // Transfer the balance from token owner's account to `to` account
504 
505     // - Owner's account must have sufficient balance to transfer
506 
507     // - 0 value transfers are allowed
508 
509     // ------------------------------------------------------------------------
510 
511     function transfer(address to, uint tokens) public returns (bool success) {
512 
513         balances[msg.sender] = balances[msg.sender].sub(tokens);
514 
515         balances[to] = balances[to].add(tokens);
516 
517         Transfer(msg.sender, to, tokens);
518 
519         return true;
520 
521     }
522 
523 
524 
525     // ------------------------------------------------------------------------
526 
527     // Token owner can approve for `spender` to transferFrom(...) `tokens`
528 
529     // from the token owner's account
530 
531     //
532 
533     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
534 
535     // recommends that there are no checks for the approval double-spend attack
536 
537     // as this should be implemented in user interfaces
538 
539     // ------------------------------------------------------------------------
540 
541     function approve(address spender, uint tokens) public returns (bool success) {
542 
543         allowed[msg.sender][spender] = tokens;
544 
545         Approval(msg.sender, spender, tokens);
546 
547         return true;
548 
549     }
550 
551 
552 
553     // ------------------------------------------------------------------------
554 
555     // Transfer `tokens` from the `from` account to the `to` account
556 
557     //
558 
559     // The calling account must already have sufficient tokens approve(...)-d
560 
561     // for spending from the `from` account and
562 
563     // - From account must have sufficient balance to transfer
564 
565     // - Spender must have sufficient allowance to transfer
566 
567     // - 0 value transfers are allowed
568 
569     // ------------------------------------------------------------------------
570 
571     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
572 
573         balances[from] = balances[from].sub(tokens);
574 
575         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
576 
577         balances[to] = balances[to].add(tokens);
578 
579         Transfer(from, to, tokens);
580 
581         return true;
582 
583     }
584 
585 
586 
587     // ------------------------------------------------------------------------
588 
589     // Returns the amount of tokens approved by the owner that can be
590 
591     // transferred to the spender's account
592 
593     // ------------------------------------------------------------------------
594 
595     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
596 
597         return allowed[tokenOwner][spender];
598 
599     }
600 
601 
602 
603     // ------------------------------------------------------------------------
604 
605     // Token owner can approve for `spender` to transferFrom(...) `tokens`
606 
607     // from the token owner's account. The `spender` contract function
608 
609     // `receiveApproval(...)` is then executed
610 
611     // ------------------------------------------------------------------------
612 
613     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
614 
615         allowed[msg.sender][spender] = tokens;
616 
617         Approval(msg.sender, spender, tokens);
618 
619         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
620 
621         return true;
622 
623     }
624 
625 
626 
627     // ------------------------------------------------------------------------
628 
629     // Don't accept ETH
630 
631     // ------------------------------------------------------------------------
632 
633     function () public payable {
634 
635         revert();
636 
637     }
638 
639 
640 
641     // ------------------------------------------------------------------------
642 
643     // Owner can transfer out any accidentally sent ERC20 tokens
644 
645     // ------------------------------------------------------------------------
646 
647     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
648 
649         return ERC20Interface(tokenAddress).transfer(owner, tokens);
650 
651     }
652 
653 }