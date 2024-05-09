1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // THIS IS NOT A CONTRACT USED FOR ANYTHING
7 
8 // THIS IS JUST A TEST CONTRACT
9 
10 //
11 
12 //
13 
14 
15 // ----------------------------------------------------------------------------
16 
17 
18 
19 // ----------------------------------------------------------------------------
20 
21 // Safe maths
22 
23 // ----------------------------------------------------------------------------
24 
25 library SafeMath {
26 
27     function add(uint a, uint b) internal pure returns (uint c) {
28 
29         c = a + b;
30 
31         require(c >= a);
32 
33     }
34 
35     function sub(uint a, uint b) internal pure returns (uint c) {
36 
37         require(b <= a);
38 
39         c = a - b;
40 
41     }
42 
43     function mul(uint a, uint b) internal pure returns (uint c) {
44 
45         c = a * b;
46 
47         require(a == 0 || c / a == b);
48 
49     }
50 
51     function div(uint a, uint b) internal pure returns (uint c) {
52 
53         require(b > 0);
54 
55         c = a / b;
56 
57     }
58 
59 }
60 
61 
62 
63 library ExtendedMath {
64 
65 
66     //return the smaller of the two inputs (a or b)
67     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
68 
69         if(a > b) return b;
70 
71         return a;
72 
73     }
74 }
75 
76 // ----------------------------------------------------------------------------
77 
78 // ERC Token Standard #20 Interface
79 
80 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
81 
82 // ----------------------------------------------------------------------------
83 
84 contract ERC20Interface {
85 
86     function totalSupply() public constant returns (uint);
87 
88     function balanceOf(address tokenOwner) public constant returns (uint balance);
89 
90     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
91 
92     function transfer(address to, uint tokens) public returns (bool success);
93 
94     function approve(address spender, uint tokens) public returns (bool success);
95 
96     function transferFrom(address from, address to, uint tokens) public returns (bool success);
97 
98 
99     event Transfer(address indexed from, address indexed to, uint tokens);
100 
101     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
102 
103 }
104 
105 
106 
107 // ----------------------------------------------------------------------------
108 
109 // Contract function to receive approval and execute function in one call
110 
111 //
112 
113 // Borrowed from MiniMeToken
114 
115 // ----------------------------------------------------------------------------
116 
117 contract ApproveAndCallFallBack {
118 
119     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
120 
121 }
122 
123 
124 
125 // ----------------------------------------------------------------------------
126 
127 // Owned contract
128 
129 // ----------------------------------------------------------------------------
130 
131 contract Owned {
132 
133     address public owner;
134 
135     address public newOwner;
136 
137 
138     event OwnershipTransferred(address indexed _from, address indexed _to);
139 
140 
141     function Owned() public {
142 
143         owner = msg.sender;
144 
145     }
146 
147 
148     modifier onlyOwner {
149 
150         require(msg.sender == owner);
151 
152         _;
153 
154     }
155 
156 
157     function transferOwnership(address _newOwner) public onlyOwner {
158 
159         newOwner = _newOwner;
160 
161     }
162 
163     function acceptOwnership() public {
164 
165         require(msg.sender == newOwner);
166 
167         OwnershipTransferred(owner, newOwner);
168 
169         owner = newOwner;
170 
171         newOwner = address(0);
172 
173     }
174 
175 }
176 
177 
178 
179 // ----------------------------------------------------------------------------
180 
181 // ERC20 Token, with the addition of symbol, name and decimals and an
182 
183 // initial fixed supply
184 
185 // ----------------------------------------------------------------------------
186 
187 contract _0xTestToken is ERC20Interface, Owned {
188 
189     using SafeMath for uint;
190     using ExtendedMath for uint;
191 
192 
193     string public symbol;
194 
195     string public  name;
196 
197     uint8 public decimals;
198 
199     uint public _totalSupply;
200 
201 
202 
203      uint public latestDifficultyPeriodStarted;
204 
205 
206 
207     uint public epochCount;//number of 'blocks' mined
208 
209 
210     uint public _BLOCKS_PER_READJUSTMENT = 1024;
211 
212 
213     //a little number
214     uint public  _MINIMUM_TARGET = 2**16;
215 
216 
217       //a big number is easier ; just find a solution that is smaller
218     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
219     uint public  _MAXIMUM_TARGET = 2**234;
220 
221 
222     uint public miningTarget;
223 
224     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
225 
226 
227 
228     uint public rewardEra;
229     uint public maxSupplyForEra;
230 
231 
232     address public lastRewardTo;
233     uint public lastRewardAmount;
234     uint public lastRewardEthBlockNumber;
235 
236     bool locked = false;
237 
238     mapping(bytes32 => bytes32) solutionForChallenge;
239 
240     uint public tokensMinted;
241 
242     mapping(address => uint) balances;
243 
244 
245     mapping(address => mapping(address => uint)) allowed;
246 
247 
248     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
249 
250     // ------------------------------------------------------------------------
251 
252     // Constructor
253 
254     // ------------------------------------------------------------------------
255 
256     function _0xTestToken() public onlyOwner{
257 
258 
259 
260         symbol = "0xTEST";
261 
262         name = "0xTEST Token";
263 
264         decimals = 8;
265 
266         _totalSupply = 21000000 * 10**uint(decimals);
267 
268         if(locked) revert();
269         locked = true;
270 
271         tokensMinted = 0;
272 
273         rewardEra = 0;
274         maxSupplyForEra = _totalSupply.div(2);
275 
276         miningTarget = _MAXIMUM_TARGET;
277 
278         latestDifficultyPeriodStarted = block.number;
279 
280         _startNewMiningEpoch();
281 
282 
283         //The owner gets nothing! You must mine this ERC20 token
284         //balances[owner] = _totalSupply;
285         //Transfer(address(0), owner, _totalSupply);
286 
287     }
288 
289 
290 
291 
292         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
293 
294 
295             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
296             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
297 
298             //the challenge digest must match the expected
299             if (digest != challenge_digest) revert();
300 
301             //the digest must be smaller than the target
302             if(uint256(digest) > miningTarget) revert();
303 
304 
305             //only allow one reward for each challenge
306              bytes32 solution = solutionForChallenge[challengeNumber];
307              solutionForChallenge[challengeNumber] = digest;
308              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
309 
310 
311             uint reward_amount = getMiningReward();
312 
313             balances[msg.sender] = balances[msg.sender].add(reward_amount);
314 
315             tokensMinted = tokensMinted.add(reward_amount);
316 
317 
318             //Cannot mint more tokens than there are
319             assert(tokensMinted <= maxSupplyForEra);
320 
321             //set readonly diagnostics data
322             lastRewardTo = msg.sender;
323             lastRewardAmount = reward_amount;
324             lastRewardEthBlockNumber = block.number;
325 
326 
327              _startNewMiningEpoch();
328 
329               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
330 
331            return true;
332 
333         }
334 
335 
336     //a new 'block' to be mined
337     function _startNewMiningEpoch() internal {
338 
339       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
340 
341       //40 is the final reward era, almost all tokens minted
342       //once the final era is reached, more tokens will not be given out because the assert function
343       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
344       {
345         rewardEra = rewardEra + 1;
346       }
347 
348       //set the next minted supply at which the era will change
349       // total supply is 2100000000000000  because of 8 decimal places
350       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
351 
352       epochCount = epochCount.add(1);
353 
354       //every so often, readjust difficulty. Dont readjust when deploying
355       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
356       {
357         _reAdjustDifficulty();
358       }
359 
360 
361       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
362       //do this last since this is a protection mechanism in the mint() function
363       challengeNumber = block.blockhash(block.number - 1);
364 
365 
366 
367 
368 
369 
370     }
371 
372 
373 
374 
375     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
376     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
377 
378     //readjust the target by 5 percent
379     function _reAdjustDifficulty() internal {
380 
381 
382         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
383         //assume 360 ethereum blocks per hour
384 
385         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xTest epoch
386         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
387 
388         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
389 
390         //if there were less eth blocks passed in time than expected
391         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
392         {
393           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
394 
395           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
396           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
397 
398           //make it harder
399           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
400         }else{
401           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
402 
403           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
404 
405           //make it easier
406           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
407         }
408 
409 
410 
411         latestDifficultyPeriodStarted = block.number;
412 
413         if(miningTarget < _MINIMUM_TARGET) //very difficult
414         {
415           miningTarget = _MINIMUM_TARGET;
416         }
417 
418         if(miningTarget > _MAXIMUM_TARGET) //very easy
419         {
420           miningTarget = _MAXIMUM_TARGET;
421         }
422     }
423 
424 
425     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
426     function getChallengeNumber() public constant returns (bytes32) {
427         return challengeNumber;
428     }
429 
430     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
431      function getMiningDifficulty() public constant returns (uint) {
432         return _MAXIMUM_TARGET.div(miningTarget);
433     }
434 
435     function getMiningTarget() public constant returns (uint) {
436        return miningTarget;
437    }
438 
439 
440 
441     //21m coins total
442     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
443     function getMiningReward() public constant returns (uint) {
444         //once we get half way thru the coins, only get 25 per block
445 
446          //every reward era, the reward amount halves.
447 
448          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
449 
450     }
451 
452     //help debug mining software
453     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
454 
455         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
456 
457         return digest;
458 
459       }
460 
461         //help debug mining software
462       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
463 
464           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
465 
466           if(uint256(digest) > testTarget) revert();
467 
468           return (digest == challenge_digest);
469 
470         }
471 
472 
473 
474     // ------------------------------------------------------------------------
475 
476     // Total supply
477 
478     // ------------------------------------------------------------------------
479 
480     function totalSupply() public constant returns (uint) {
481 
482         return _totalSupply  - balances[address(0)];
483 
484     }
485 
486 
487 
488     // ------------------------------------------------------------------------
489 
490     // Get the token balance for account `tokenOwner`
491 
492     // ------------------------------------------------------------------------
493 
494     function balanceOf(address tokenOwner) public constant returns (uint balance) {
495 
496         return balances[tokenOwner];
497 
498     }
499 
500 
501 
502     // ------------------------------------------------------------------------
503 
504     // Transfer the balance from token owner's account to `to` account
505 
506     // - Owner's account must have sufficient balance to transfer
507 
508     // - 0 value transfers are allowed
509 
510     // ------------------------------------------------------------------------
511 
512     function transfer(address to, uint tokens) public returns (bool success) {
513 
514         balances[msg.sender] = balances[msg.sender].sub(tokens);
515 
516         balances[to] = balances[to].add(tokens);
517 
518         Transfer(msg.sender, to, tokens);
519 
520         return true;
521 
522     }
523 
524 
525 
526     // ------------------------------------------------------------------------
527 
528     // Token owner can approve for `spender` to transferFrom(...) `tokens`
529 
530     // from the token owner's account
531 
532     //
533 
534     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
535 
536     // recommends that there are no checks for the approval double-spend attack
537 
538     // as this should be implemented in user interfaces
539 
540     // ------------------------------------------------------------------------
541 
542     function approve(address spender, uint tokens) public returns (bool success) {
543 
544         allowed[msg.sender][spender] = tokens;
545 
546         Approval(msg.sender, spender, tokens);
547 
548         return true;
549 
550     }
551 
552 
553 
554     // ------------------------------------------------------------------------
555 
556     // Transfer `tokens` from the `from` account to the `to` account
557 
558     //
559 
560     // The calling account must already have sufficient tokens approve(...)-d
561 
562     // for spending from the `from` account and
563 
564     // - From account must have sufficient balance to transfer
565 
566     // - Spender must have sufficient allowance to transfer
567 
568     // - 0 value transfers are allowed
569 
570     // ------------------------------------------------------------------------
571 
572     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
573 
574         balances[from] = balances[from].sub(tokens);
575 
576         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
577 
578         balances[to] = balances[to].add(tokens);
579 
580         Transfer(from, to, tokens);
581 
582         return true;
583 
584     }
585 
586 
587 
588     // ------------------------------------------------------------------------
589 
590     // Returns the amount of tokens approved by the owner that can be
591 
592     // transferred to the spender's account
593 
594     // ------------------------------------------------------------------------
595 
596     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
597 
598         return allowed[tokenOwner][spender];
599 
600     }
601 
602 
603 
604     // ------------------------------------------------------------------------
605 
606     // Token owner can approve for `spender` to transferFrom(...) `tokens`
607 
608     // from the token owner's account. The `spender` contract function
609 
610     // `receiveApproval(...)` is then executed
611 
612     // ------------------------------------------------------------------------
613 
614     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
615 
616         allowed[msg.sender][spender] = tokens;
617 
618         Approval(msg.sender, spender, tokens);
619 
620         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
621 
622         return true;
623 
624     }
625 
626 
627 
628     // ------------------------------------------------------------------------
629 
630     // Don't accept ETH
631 
632     // ------------------------------------------------------------------------
633 
634     function () public payable {
635 
636         revert();
637 
638     }
639 
640 
641 
642     // ------------------------------------------------------------------------
643 
644     // Owner can transfer out any accidentally sent ERC20 tokens
645 
646     // ------------------------------------------------------------------------
647 
648     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
649 
650         return ERC20Interface(tokenAddress).transfer(owner, tokens);
651 
652     }
653 
654 }