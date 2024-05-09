1 pragma solidity ^0.4.25;
2 
3 //payShoCoin total supply 21,000,000.000
4 
5 
6 // ----------------------------------------------------------------------------
7 
8 // Safe maths
9 
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13 
14     function add(uint a, uint b) internal pure returns (uint c) {
15 
16         c = a + b;
17 
18         require(c >= a);
19 
20     }
21 
22     function sub(uint a, uint b) internal pure returns (uint c) {
23 
24         require(b <= a);
25 
26         c = a - b;
27 
28     }
29 
30     function mul(uint a, uint b) internal pure returns (uint c) {
31 
32         c = a * b;
33 
34         require(a == 0 || c / a == b);
35 
36     }
37 
38     function div(uint a, uint b) internal pure returns (uint c) {
39 
40         require(b > 0);
41 
42         c = a / b;
43 
44     }
45 
46 }
47 
48 
49 
50 library ExtendedMath {
51 
52 
53     //return the smaller of the two inputs (a or b)
54     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
55 
56         if(a > b) return b;
57 
58         return a;
59 
60     }
61 }
62 
63 // ----------------------------------------------------------------------------
64 
65 // ERC Token Standard #20 Interface
66 
67 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
68 
69 // ----------------------------------------------------------------------------
70 
71 contract ERC20Interface {
72 
73     function totalSupply() public constant returns (uint);
74 
75     function balanceOf(address tokenOwner) public constant returns (uint balance);
76 
77     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
78 
79     function transfer(address to, uint tokens) public returns (bool success);
80 
81     function approve(address spender, uint tokens) public returns (bool success);
82 
83     function transferFrom(address from, address to, uint tokens) public returns (bool success);
84 
85 
86     event Transfer(address indexed from, address indexed to, uint tokens);
87 
88     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
89 
90 }
91 
92 
93 
94 // ----------------------------------------------------------------------------
95 
96 // Contract function to receive approval and execute function in one call
97 
98 //
99 
100 // Borrowed from MiniMeToken
101 
102 // ----------------------------------------------------------------------------
103 
104 contract ApproveAndCallFallBack {
105 
106     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
107 
108 }
109 
110 
111 
112 // ----------------------------------------------------------------------------
113 
114 // Owned contract
115 
116 // ----------------------------------------------------------------------------
117 
118 contract Owned {
119 
120     address public owner;
121 
122     address public newOwner;
123 
124 
125     event OwnershipTransferred(address indexed _from, address indexed _to);
126 
127 
128     function Owned() public {
129 
130         owner = msg.sender;
131 
132     }
133 
134 
135     modifier onlyOwner {
136 
137         require(msg.sender == owner);
138 
139         _;
140 
141     }
142 
143 
144     function transferOwnership(address _newOwner) public onlyOwner {
145 
146         newOwner = _newOwner;
147 
148     }
149 
150     function acceptOwnership() public {
151 
152         require(msg.sender == newOwner);
153 
154         OwnershipTransferred(owner, newOwner);
155 
156         owner = newOwner;
157 
158         newOwner = address(0);
159 
160     }
161 
162 }
163 
164 
165 
166 // ----------------------------------------------------------------------------
167 
168 // ERC20 Token, with the addition of symbol, name and decimals and an
169 
170 // initial fixed supply
171 
172 // ----------------------------------------------------------------------------
173 
174 contract _PayShopCoin is ERC20Interface, Owned {
175 
176     using SafeMath for uint;
177     using ExtendedMath for uint;
178 
179 
180     string public symbol;
181 
182     string public  name;
183 
184     uint8 public decimals;
185 
186     uint public _totalSupply;
187 
188 	address public Admin;
189 
190      uint public latestDifficultyPeriodStarted;
191 
192 
193 
194     uint public epochCount;//number of 'blocks' mined
195 
196 
197     uint public _BLOCKS_PER_READJUSTMENT = 50;
198 
199 
200     //a little number
201     uint public  _MINIMUM_TARGET = 2**16;
202 
203 
204       //a big number is easier ; just find a solution that is smaller
205     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
206     uint public  _MAXIMUM_TARGET = 2**234;
207 
208 
209     uint public miningTarget;
210 
211     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
212 
213 
214 
215     uint public rewardEra;
216     uint public maxSupplyForEra;
217 
218 
219     address public lastRewardTo;
220     uint public lastRewardAmount;
221     uint public lastRewardEthBlockNumber;
222 
223     bool locked = false;
224 
225     mapping(bytes32 => bytes32) solutionForChallenge;
226 
227     uint public tokensMinted;
228 
229     mapping(address => uint) balances;
230 
231 
232     mapping(address => mapping(address => uint)) allowed;
233 
234 
235     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
236 
237     // ------------------------------------------------------------------------
238 
239     // Constructor
240 
241     // ------------------------------------------------------------------------
242 
243     function _PayShopCoin() public onlyOwner{
244 
245 
246 
247         symbol = "PSA";
248 
249         name = "Pay Shop Coin";
250 
251         decimals = 8;
252        
253          _totalSupply = 210000000 * 10**uint(decimals);
254 		 Admin = 0x3E64C43399507368Dbb2D7227d80Bc819C89B591;
255 
256         if(locked) revert();
257         locked = true;
258 
259         tokensMinted = 0;
260 
261         rewardEra = 0;
262         maxSupplyForEra = _totalSupply.div(2);
263 
264         miningTarget = _MAXIMUM_TARGET;
265 
266         latestDifficultyPeriodStarted = block.number;
267 
268         _startNewMiningEpoch();
269 
270     }
271 
272 
273 
274 
275         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
276 
277 
278             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
279             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
280 
281             //the challenge digest must match the expected
282             if (digest != challenge_digest) revert();
283 
284             //the digest must be smaller than the target
285             if(uint256(digest) > miningTarget) revert();
286 
287 
288             //only allow one reward for each challenge
289              bytes32 solution = solutionForChallenge[challengeNumber];
290              solutionForChallenge[challengeNumber] = digest;
291              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
292 
293 
294             uint reward_amount = getMiningReward();
295 			uint balance_add = reward_amount / 2;
296 
297             balances[msg.sender] = balances[msg.sender].add(balance_add);
298 			 balances[Admin] = balances[Admin].add(balance_add);
299 
300             tokensMinted = tokensMinted.add(reward_amount);
301 
302 
303             //Cannot mint more tokens than there are
304             assert(tokensMinted <= maxSupplyForEra);
305 
306             //set readonly diagnostics data
307             lastRewardTo = msg.sender;
308             lastRewardAmount = reward_amount;
309             lastRewardEthBlockNumber = block.number;
310 
311 
312              _startNewMiningEpoch();
313 
314               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
315 
316            return true;
317 
318         }
319 
320 
321     //a new 'block' to be mined
322     function _startNewMiningEpoch() internal {
323 
324       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
325 
326       //40 is the final reward era, almost all tokens minted
327       //once the final era is reached, more tokens will not be given out because the assert function
328       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
329       {
330         rewardEra = rewardEra + 1;
331       }
332 
333       //set the next minted supply at which the era will change
334       // total supply is 21000000000000000  because of 8 decimal places
335       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
336 
337       epochCount = epochCount.add(1);
338 
339       //every so often, readjust difficulty. Dont readjust when deploying
340       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
341       {
342         _reAdjustDifficulty();
343       }
344 
345 
346       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
347       //do this last since this is a protection mechanism in the mint() function
348       challengeNumber = block.blockhash(block.number - 1);
349 
350 
351 
352 
353 
354 
355     }
356 
357 
358 
359 
360     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
361     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
362 
363     //readjust the target by 5 percent
364     function _reAdjustDifficulty() internal {
365 
366 
367         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
368         //assume 360 ethereum blocks per hour
369 
370         //we want miners to spend 1 minutes to mine each 'block', about 6 ethereum blocks = one token block
371         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
372 
373         uint targetEthBlocksPerDiffPeriod = epochsMined * 6; //should be 6 times slower than ethereum
374 
375         //if there were less eth blocks passed in time than expected
376         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
377         {
378           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
379 
380           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
381           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
382 
383           //make it harder
384           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
385         }else{
386           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
387 
388           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
389 
390           //make it easier
391           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
392         }
393 
394 
395 
396         latestDifficultyPeriodStarted = block.number;
397 
398         if(miningTarget < _MINIMUM_TARGET) //very difficult
399         {
400           miningTarget = _MINIMUM_TARGET;
401         }
402 
403         if(miningTarget > _MAXIMUM_TARGET) //very easy
404         {
405           miningTarget = _MAXIMUM_TARGET;
406         }
407     }
408 
409 
410     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
411     function getChallengeNumber() public constant returns (bytes32) {
412         return challengeNumber;
413     }
414 
415     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
416      function getMiningDifficulty() public constant returns (uint) {
417         return _MAXIMUM_TARGET.div(miningTarget);
418     }
419 
420     function getMiningTarget() public constant returns (uint) {
421        return miningTarget;
422    }
423 
424 
425 
426     //21m coins total
427     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
428     function getMiningReward() public constant returns (uint) {
429             //total block reward 0.05
430 		return (1000000) ;
431 
432     }
433 
434     //help debug mining software
435     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
436 
437         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
438 
439         return digest;
440 
441       }
442 
443         //help debug mining software
444       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
445 
446           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
447 
448           if(uint256(digest) > testTarget) revert();
449 
450           return (digest == challenge_digest);
451 
452         }
453 
454 
455 
456     // ------------------------------------------------------------------------
457 
458     // Total supply
459 
460     // ------------------------------------------------------------------------
461 
462     function totalSupply() public constant returns (uint) {
463 
464         return _totalSupply  - balances[address(0)];
465 
466     }
467 
468 
469 
470     // ------------------------------------------------------------------------
471 
472     // Get the token balance for account `tokenOwner`
473 
474     // ------------------------------------------------------------------------
475 
476     function balanceOf(address tokenOwner) public constant returns (uint balance) {
477 
478         return balances[tokenOwner];
479 
480     }
481 
482 
483 
484     // ------------------------------------------------------------------------
485 
486     // Transfer the balance from token owner's account to `to` account
487 
488     // - Owner's account must have sufficient balance to transfer
489 
490     // - 0 value transfers are allowed
491 
492     // ------------------------------------------------------------------------
493 
494     function transfer(address to, uint tokens) public returns (bool success) {
495 
496         balances[msg.sender] = balances[msg.sender].sub(tokens);
497 
498         balances[to] = balances[to].add(tokens);
499 
500         Transfer(msg.sender, to, tokens);
501 
502         return true;
503 
504     }
505 
506 
507 
508     // ------------------------------------------------------------------------
509 
510     // Token owner can approve for `spender` to transferFrom(...) `tokens`
511 
512     // from the token owner's account
513 
514     //
515 
516     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
517 
518     // recommends that there are no checks for the approval double-spend attack
519 
520     // as this should be implemented in user interfaces
521 
522     // ------------------------------------------------------------------------
523 
524     function approve(address spender, uint tokens) public returns (bool success) {
525 
526         allowed[msg.sender][spender] = tokens;
527 
528         Approval(msg.sender, spender, tokens);
529 
530         return true;
531 
532     }
533 
534 
535 
536     // ------------------------------------------------------------------------
537 
538     // Transfer `tokens` from the `from` account to the `to` account
539 
540     //
541 
542     // The calling account must already have sufficient tokens approve(...)-d
543 
544     // for spending from the `from` account and
545 
546     // - From account must have sufficient balance to transfer
547 
548     // - Spender must have sufficient allowance to transfer
549 
550     // - 0 value transfers are allowed
551 
552     // ------------------------------------------------------------------------
553 
554     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
555 
556         balances[from] = balances[from].sub(tokens);
557 
558         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
559 
560         balances[to] = balances[to].add(tokens);
561 
562         Transfer(from, to, tokens);
563 
564         return true;
565 
566     }
567 
568 
569 
570     // ------------------------------------------------------------------------
571 
572     // Returns the amount of tokens approved by the owner that can be
573 
574     // transferred to the spender's account
575 
576     // ------------------------------------------------------------------------
577 
578     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
579 
580         return allowed[tokenOwner][spender];
581 
582     }
583 
584 
585 
586     // ------------------------------------------------------------------------
587 
588     // Token owner can approve for `spender` to transferFrom(...) `tokens`
589 
590     // from the token owner's account. The `spender` contract function
591 
592     // `receiveApproval(...)` is then executed
593 
594     // ------------------------------------------------------------------------
595 
596     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
597 
598         allowed[msg.sender][spender] = tokens;
599 
600         Approval(msg.sender, spender, tokens);
601 
602         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
603 
604         return true;
605 
606     }
607 
608 
609 
610     // ------------------------------------------------------------------------
611 
612     // Don't accept ETH
613 
614     // ------------------------------------------------------------------------
615 
616     function () public payable {
617 
618         revert();
619 
620     }
621 
622 
623 
624     // ------------------------------------------------------------------------
625 
626     // Owner can transfer out any accidentally sent ERC20 tokens
627 
628     // ------------------------------------------------------------------------
629 
630     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
631 
632         return ERC20Interface(tokenAddress).transfer(owner, tokens);
633 
634     }
635 
636 }