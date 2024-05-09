1 pragma solidity ^0.4.25;
2 
3 //payShopCoin total supply 21,000,000.000
4 
5 //website : https://payshopcoin.com
6 
7 
8 // ----------------------------------------------------------------------------
9 
10 // Safe maths
11 
12 // ----------------------------------------------------------------------------
13 
14 library SafeMath {
15 
16     function add(uint a, uint b) internal pure returns (uint c) {
17 
18         c = a + b;
19 
20         require(c >= a);
21 
22     }
23 
24     function sub(uint a, uint b) internal pure returns (uint c) {
25 
26         require(b <= a);
27 
28         c = a - b;
29 
30     }
31 
32     function mul(uint a, uint b) internal pure returns (uint c) {
33 
34         c = a * b;
35 
36         require(a == 0 || c / a == b);
37 
38     }
39 
40     function div(uint a, uint b) internal pure returns (uint c) {
41 
42         require(b > 0);
43 
44         c = a / b;
45 
46     }
47 
48 }
49 
50 
51 
52 library ExtendedMath {
53 
54 
55     //return the smaller of the two inputs (a or b)
56     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
57 
58         if(a > b) return b;
59 
60         return a;
61 
62     }
63 }
64 
65 // ----------------------------------------------------------------------------
66 
67 // ERC Token Standard #20 Interface
68 
69 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
70 
71 // ----------------------------------------------------------------------------
72 
73 contract ERC20Interface {
74 
75     function totalSupply() public constant returns (uint);
76 
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78 
79     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
80 
81     function transfer(address to, uint tokens) public returns (bool success);
82 
83     function approve(address spender, uint tokens) public returns (bool success);
84 
85     function transferFrom(address from, address to, uint tokens) public returns (bool success);
86 
87 
88     event Transfer(address indexed from, address indexed to, uint tokens);
89 
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 
92 }
93 
94 
95 
96 // ----------------------------------------------------------------------------
97 
98 // Contract function to receive approval and execute function in one call
99 
100 //
101 
102 // Borrowed from MiniMeToken
103 
104 // ----------------------------------------------------------------------------
105 
106 contract ApproveAndCallFallBack {
107 
108     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
109 
110 }
111 
112 
113 
114 // ----------------------------------------------------------------------------
115 
116 // Owned contract
117 
118 // ----------------------------------------------------------------------------
119 
120 contract Owned {
121 
122     address public owner;
123 
124     address public newOwner;
125 
126 
127     event OwnershipTransferred(address indexed _from, address indexed _to);
128 
129 
130     function Owned() public {
131 
132         owner = msg.sender;
133 
134     }
135 
136 
137     modifier onlyOwner {
138 
139         require(msg.sender == owner);
140 
141         _;
142 
143     }
144 
145 
146     function transferOwnership(address _newOwner) public onlyOwner {
147 
148         newOwner = _newOwner;
149 
150     }
151 
152     function acceptOwnership() public {
153 
154         require(msg.sender == newOwner);
155 
156         OwnershipTransferred(owner, newOwner);
157 
158         owner = newOwner;
159 
160         newOwner = address(0);
161 
162     }
163 
164 }
165 
166 
167 
168 // ----------------------------------------------------------------------------
169 
170 // ERC20 Token, with the addition of symbol, name and decimals and an
171 
172 // initial fixed supply
173 
174 // ----------------------------------------------------------------------------
175 
176 contract _PASCoin is ERC20Interface, Owned {
177 
178     using SafeMath for uint;
179     using ExtendedMath for uint;
180 
181 
182     string public symbol;
183 
184     string public  name;
185 
186     uint8 public decimals;
187 
188     uint public _totalSupply;
189 
190 	address public Admin;
191 
192      uint public latestDifficultyPeriodStarted;
193 
194 
195 
196     uint public epochCount;//number of 'blocks' mined
197 
198 
199     uint public _BLOCKS_PER_READJUSTMENT = 50;
200 
201 
202     //a little number
203     uint public  _MINIMUM_TARGET = 2**16;
204 
205 
206       //a big number is easier ; just find a solution that is smaller
207     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
208     uint public  _MAXIMUM_TARGET = 2**234;
209 
210 
211     uint public miningTarget;
212 
213     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
214 
215 
216 
217     uint public rewardEra;
218     uint public maxSupplyForEra;
219 
220 
221     address public lastRewardTo;
222     uint public lastRewardAmount;
223     uint public lastRewardEthBlockNumber;
224 
225     bool locked = false;
226 
227     mapping(bytes32 => bytes32) solutionForChallenge;
228 
229     uint public tokensMinted;
230 
231     mapping(address => uint) balances;
232 
233 
234     mapping(address => mapping(address => uint)) allowed;
235 
236 
237     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
238 
239     // ------------------------------------------------------------------------
240 
241     // Constructor
242 
243     // ------------------------------------------------------------------------
244 
245     function _PASCoin() public onlyOwner{
246 
247 
248 
249         symbol = "PAS";
250 
251         name = "Pay Shop Coin";
252 
253         decimals = 8;
254        
255          _totalSupply = 21000000 * 10**uint(decimals);
256 		 Admin = 0x1944EbE39319e513c4b3477CE2dbe22683B59024;
257 
258         if(locked) revert();
259         locked = true;
260 
261         tokensMinted = 0;
262 
263         rewardEra = 0;
264         maxSupplyForEra = _totalSupply.div(2);
265 
266         miningTarget = _MAXIMUM_TARGET;
267 
268         latestDifficultyPeriodStarted = block.number;
269 
270         _startNewMiningEpoch();
271 
272     }
273 
274 
275 
276 
277         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
278 
279 
280             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
281             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
282 
283             //the challenge digest must match the expected
284             if (digest != challenge_digest) revert();
285 
286             //the digest must be smaller than the target
287             if(uint256(digest) > miningTarget) revert();
288 
289 
290             //only allow one reward for each challenge
291              bytes32 solution = solutionForChallenge[challengeNumber];
292              solutionForChallenge[challengeNumber] = digest;
293              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
294 
295 
296             uint reward_amount = getMiningReward();
297 			uint balance_add = reward_amount / 2;
298 
299             balances[msg.sender] = balances[msg.sender].add(balance_add);
300 			 balances[Admin] = balances[Admin].add(balance_add);
301 
302             tokensMinted = tokensMinted.add(reward_amount);
303 
304 
305             //Cannot mint more tokens than there are
306             assert(tokensMinted <= maxSupplyForEra);
307 
308             //set readonly diagnostics data
309             lastRewardTo = msg.sender;
310             lastRewardAmount = reward_amount;
311             lastRewardEthBlockNumber = block.number;
312 
313 
314              _startNewMiningEpoch();
315 
316               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
317 
318            return true;
319 
320         }
321 
322 
323     //a new 'block' to be mined
324     function _startNewMiningEpoch() internal {
325 
326       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
327 
328       //40 is the final reward era, almost all tokens minted
329       //once the final era is reached, more tokens will not be given out because the assert function
330       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
331       {
332         rewardEra = rewardEra + 1;
333       }
334 
335       //set the next minted supply at which the era will change
336       // total supply is 21000000000000000  because of 8 decimal places
337       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
338 
339       epochCount = epochCount.add(1);
340 
341       //every so often, readjust difficulty. Dont readjust when deploying
342       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
343       {
344         _reAdjustDifficulty();
345       }
346 
347 
348       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
349       //do this last since this is a protection mechanism in the mint() function
350       challengeNumber = block.blockhash(block.number - 1);
351 
352 
353 
354 
355 
356 
357     }
358 
359 
360 
361 
362     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
363     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
364 
365     //readjust the target by 5 percent
366     function _reAdjustDifficulty() internal {
367 
368 
369         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
370         //assume 360 ethereum blocks per hour
371 
372         //we want miners to spend 1 minutes to mine each 'block', about 6 ethereum blocks = one token block
373         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
374 
375         uint targetEthBlocksPerDiffPeriod = epochsMined * 6; //should be 6 times slower than ethereum
376 
377         //if there were less eth blocks passed in time than expected
378         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
379         {
380           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
381 
382           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
383           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
384 
385           //make it harder
386           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
387         }else{
388           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
389 
390           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
391 
392           //make it easier
393           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
394         }
395 
396 
397 
398         latestDifficultyPeriodStarted = block.number;
399 
400         if(miningTarget < _MINIMUM_TARGET) //very difficult
401         {
402           miningTarget = _MINIMUM_TARGET;
403         }
404 
405         if(miningTarget > _MAXIMUM_TARGET) //very easy
406         {
407           miningTarget = _MAXIMUM_TARGET;
408         }
409     }
410 
411 
412     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
413     function getChallengeNumber() public constant returns (bytes32) {
414         return challengeNumber;
415     }
416 
417     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
418      function getMiningDifficulty() public constant returns (uint) {
419         return _MAXIMUM_TARGET.div(miningTarget);
420     }
421 
422     function getMiningTarget() public constant returns (uint) {
423        return miningTarget;
424    }
425 
426 
427 
428     //21m coins total
429     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
430     function getMiningReward() public constant returns (uint) {
431             //total block reward 0.05
432 		return (1000000) ;
433 
434     }
435 
436     //help debug mining software
437     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
438 
439         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
440 
441         return digest;
442 
443       }
444 
445         //help debug mining software
446       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
447 
448           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
449 
450           if(uint256(digest) > testTarget) revert();
451 
452           return (digest == challenge_digest);
453 
454         }
455 
456 
457 
458     // ------------------------------------------------------------------------
459 
460     // Total supply
461 
462     // ------------------------------------------------------------------------
463 
464     function totalSupply() public constant returns (uint) {
465 
466         return _totalSupply  - balances[address(0)];
467 
468     }
469 
470 
471 
472     // ------------------------------------------------------------------------
473 
474     // Get the token balance for account `tokenOwner`
475 
476     // ------------------------------------------------------------------------
477 
478     function balanceOf(address tokenOwner) public constant returns (uint balance) {
479 
480         return balances[tokenOwner];
481 
482     }
483 
484 
485 
486     // ------------------------------------------------------------------------
487 
488     // Transfer the balance from token owner's account to `to` account
489 
490     // - Owner's account must have sufficient balance to transfer
491 
492     // - 0 value transfers are allowed
493 
494     // ------------------------------------------------------------------------
495 
496     function transfer(address to, uint tokens) public returns (bool success) {
497 
498         balances[msg.sender] = balances[msg.sender].sub(tokens);
499 
500         balances[to] = balances[to].add(tokens);
501 
502         Transfer(msg.sender, to, tokens);
503 
504         return true;
505 
506     }
507 
508 
509 
510     // ------------------------------------------------------------------------
511 
512     // Token owner can approve for `spender` to transferFrom(...) `tokens`
513 
514     // from the token owner's account
515 
516     //
517 
518     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
519 
520     // recommends that there are no checks for the approval double-spend attack
521 
522     // as this should be implemented in user interfaces
523 
524     // ------------------------------------------------------------------------
525 
526     function approve(address spender, uint tokens) public returns (bool success) {
527 
528         allowed[msg.sender][spender] = tokens;
529 
530         Approval(msg.sender, spender, tokens);
531 
532         return true;
533 
534     }
535 
536 
537 
538     // ------------------------------------------------------------------------
539 
540     // Transfer `tokens` from the `from` account to the `to` account
541 
542     //
543 
544     // The calling account must already have sufficient tokens approve(...)-d
545 
546     // for spending from the `from` account and
547 
548     // - From account must have sufficient balance to transfer
549 
550     // - Spender must have sufficient allowance to transfer
551 
552     // - 0 value transfers are allowed
553 
554     // ------------------------------------------------------------------------
555 
556     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
557 
558         balances[from] = balances[from].sub(tokens);
559 
560         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
561 
562         balances[to] = balances[to].add(tokens);
563 
564         Transfer(from, to, tokens);
565 
566         return true;
567 
568     }
569 
570 
571 
572     // ------------------------------------------------------------------------
573 
574     // Returns the amount of tokens approved by the owner that can be
575 
576     // transferred to the spender's account
577 
578     // ------------------------------------------------------------------------
579 
580     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
581 
582         return allowed[tokenOwner][spender];
583 
584     }
585 
586 
587 
588     // ------------------------------------------------------------------------
589 
590     // Token owner can approve for `spender` to transferFrom(...) `tokens`
591 
592     // from the token owner's account. The `spender` contract function
593 
594     // `receiveApproval(...)` is then executed
595 
596     // ------------------------------------------------------------------------
597 
598     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
599 
600         allowed[msg.sender][spender] = tokens;
601 
602         Approval(msg.sender, spender, tokens);
603 
604         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
605 
606         return true;
607 
608     }
609 
610 
611 
612     // ------------------------------------------------------------------------
613 
614     // Don't accept ETH
615 
616     // ------------------------------------------------------------------------
617 
618     function () public payable {
619 
620         revert();
621 
622     }
623 
624 
625 
626     // ------------------------------------------------------------------------
627 
628     // Owner can transfer out any accidentally sent ERC20 tokens
629 
630     // ------------------------------------------------------------------------
631 
632     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
633 
634         return ERC20Interface(tokenAddress).transfer(owner, tokens);
635 
636     }
637 
638 }