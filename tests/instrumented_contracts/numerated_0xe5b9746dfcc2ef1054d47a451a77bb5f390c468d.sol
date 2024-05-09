1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 
7 //    /$$$$$$            /$$$$$$$  /$$   /$$                         /$$            /$$$$$$               /$$    /$$      
8 //   /$$$_  $$          | $$__  $$|__/  | $$                        |__/           /$$__  $$            /$$$$$$ | $$      
9 //  | $$$$\ $$ /$$   /$$| $$  \ $$ /$$ /$$$$$$    /$$$$$$$  /$$$$$$  /$$ /$$$$$$$ | $$  \__/  /$$$$$$  /$$__  $$| $$$$$$$ 
10 //  | $$ $$ $$|  $$ /$$/| $$$$$$$ | $$|_  $$_/   /$$_____/ /$$__  $$| $$| $$__  $$| $$       |____  $$| $$  \__/| $$__  $$
11 //  | $$\ $$$$ \  $$$$/ | $$__  $$| $$  | $$    | $$      | $$  \ $$| $$| $$  \ $$| $$        /$$$$$$$|  $$$$$$ | $$  \ $$
12 //  | $$ \ $$$  >$$  $$ | $$  \ $$| $$  | $$ /$$| $$      | $$  | $$| $$| $$  | $$| $$    $$ /$$__  $$ \____  $$| $$  | $$
13 //  |  $$$$$$/ /$$/\  $$| $$$$$$$/| $$  |  $$$$/|  $$$$$$$|  $$$$$$/| $$| $$  | $$|  $$$$$$/|  $$$$$$$ /$$  \ $$| $$  | $$
14 //   \______/ |__/  \__/|_______/ |__/   \___/   \_______/ \______/ |__/|__/  |__/ \______/  \_______/|  $$$$$$/|__/  |__/
15 //                                                                                                     \_  $$_/           
16 //                                                                                                       \__/             
17 // -----------------------------------------------------------------------------                                                                                                                      
18 
19 
20 // '0xBitcoinCash' contract
21 
22 // Mineable ERC20 Token using Proof Of Work
23 
24 // Website: https://0xbitcoincash.io
25 
26 //
27 
28 // Symbol      : 0xBCH
29 
30 // Name        : 0xBitcoinCash
31 
32 // Total supply: 21,000,000.00
33 
34 // Decimals    : 8
35 
36 //
37 
38 
39 // ----------------------------------------------------------------------------
40 
41 
42 
43 // ----------------------------------------------------------------------------
44 
45 // Safe maths
46 
47 // ----------------------------------------------------------------------------
48 
49 library SafeMath {
50 
51     function add(uint a, uint b) internal pure returns (uint c) {
52 
53         c = a + b;
54 
55         require(c >= a);
56 
57     }
58 
59     function sub(uint a, uint b) internal pure returns (uint c) {
60 
61         require(b <= a);
62 
63         c = a - b;
64 
65     }
66 
67     function mul(uint a, uint b) internal pure returns (uint c) {
68 
69         c = a * b;
70 
71         require(a == 0 || c / a == b);
72 
73     }
74 
75     function div(uint a, uint b) internal pure returns (uint c) {
76 
77         require(b > 0);
78 
79         c = a / b;
80 
81     }
82 
83 }
84 
85 
86 
87 library ExtendedMath {
88 
89 
90     //return the smaller of the two inputs (a or b)
91     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
92 
93         if(a > b) return b;
94 
95         return a;
96 
97     }
98 }
99 
100 // ----------------------------------------------------------------------------
101 
102 // ERC Token Standard #20 Interface
103 
104 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
105 
106 // ----------------------------------------------------------------------------
107 
108 contract ERC20Interface {
109 
110     function totalSupply() public constant returns (uint);
111 
112     function balanceOf(address tokenOwner) public constant returns (uint balance);
113 
114     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
115 
116     function transfer(address to, uint tokens) public returns (bool success);
117 
118     function approve(address spender, uint tokens) public returns (bool success);
119 
120     function transferFrom(address from, address to, uint tokens) public returns (bool success);
121 
122 
123     event Transfer(address indexed from, address indexed to, uint tokens);
124 
125     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
126 
127 }
128 
129 
130 
131 // ----------------------------------------------------------------------------
132 
133 // Contract function to receive approval and execute function in one call
134 
135 //
136 
137 // Borrowed from MiniMeToken
138 
139 // ----------------------------------------------------------------------------
140 
141 contract ApproveAndCallFallBack {
142 
143     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
144 
145 }
146 
147 
148 
149 // ----------------------------------------------------------------------------
150 
151 // Owned contract
152 
153 // ----------------------------------------------------------------------------
154 
155 contract Owned {
156 
157     address public owner;
158 
159     address public newOwner;
160 
161 
162     event OwnershipTransferred(address indexed _from, address indexed _to);
163 
164 
165     function Owned() public {
166 
167         owner = msg.sender;
168 
169     }
170 
171 
172     modifier onlyOwner {
173 
174         require(msg.sender == owner);
175 
176         _;
177 
178     }
179 
180 
181     function transferOwnership(address _newOwner) public onlyOwner {
182 
183         newOwner = _newOwner;
184 
185     }
186 
187     function acceptOwnership() public {
188 
189         require(msg.sender == newOwner);
190 
191         OwnershipTransferred(owner, newOwner);
192 
193         owner = newOwner;
194 
195         newOwner = address(0);
196 
197     }
198 
199 }
200 
201 
202 
203 // ----------------------------------------------------------------------------
204 
205 // ERC20 Token, with the addition of symbol, name and decimals and an
206 
207 // initial fixed supply
208 
209 // ----------------------------------------------------------------------------
210 
211 contract _0xBitcoinCash is ERC20Interface, Owned {
212 
213     using SafeMath for uint;
214     using ExtendedMath for uint;
215 
216 
217     string public symbol;
218 
219     string public  name;
220 
221     uint8 public decimals;
222 
223     uint public _totalSupply;
224 
225 
226 
227      uint public latestDifficultyPeriodStarted;
228 
229 
230 
231     uint public epochCount;//number of 'blocks' mined
232 
233 
234     uint public _BLOCKS_PER_READJUSTMENT = 1024;
235 
236 
237     //a little number
238     uint public  _MINIMUM_TARGET = 2**16;
239 
240 
241       //a big number is easier ; just find a solution that is smaller
242     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
243     uint public  _MAXIMUM_TARGET = 2**234;
244 
245 
246     uint public miningTarget;
247 
248     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
249 
250 
251 
252     uint public rewardEra;
253     uint public maxSupplyForEra;
254 
255 
256     address public lastRewardTo;
257     uint public lastRewardAmount;
258     uint public lastRewardEthBlockNumber;
259 
260     bool locked = false;
261 
262     mapping(bytes32 => bytes32) solutionForChallenge;
263 
264     uint public tokensMinted;
265 
266     mapping(address => uint) balances;
267 
268 
269     mapping(address => mapping(address => uint)) allowed;
270 
271 
272     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
273 
274     // ------------------------------------------------------------------------
275 
276     // Constructor
277 
278     // ------------------------------------------------------------------------
279 
280     function _0xBitcoinCash() public onlyOwner{
281 
282 
283 
284         symbol = "0xBCH";
285 
286         name = "0xBitcoinCash";
287 
288         decimals = 8;
289 
290         _totalSupply = 21000000 * 10**uint(decimals);
291 
292         if(locked) revert();
293         locked = true;
294 
295         tokensMinted = 0;
296 
297         rewardEra = 0;
298         maxSupplyForEra = _totalSupply.div(2);
299 
300         miningTarget = _MAXIMUM_TARGET;
301 
302         latestDifficultyPeriodStarted = block.number;
303 
304         _startNewMiningEpoch();
305 
306 
307         //The owner gets nothing! You must mine this ERC20 token
308         //balances[owner] = _totalSupply;
309         //Transfer(address(0), owner, _totalSupply);
310 
311     }
312 
313 
314 
315 
316         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
317 
318 
319             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
320             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
321 
322             //the challenge digest must match the expected
323             if (digest != challenge_digest) revert();
324 
325             //the digest must be smaller than the target
326             if(uint256(digest) > miningTarget) revert();
327 
328 
329             //only allow one reward for each challenge
330              bytes32 solution = solutionForChallenge[challengeNumber];
331              solutionForChallenge[challengeNumber] = digest;
332              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
333 
334 
335             uint reward_amount = getMiningReward();
336 
337             balances[msg.sender] = balances[msg.sender].add(reward_amount);
338 
339             tokensMinted = tokensMinted.add(reward_amount);
340 
341 
342             //Cannot mint more tokens than there are
343             assert(tokensMinted <= maxSupplyForEra);
344 
345             //set readonly diagnostics data
346             lastRewardTo = msg.sender;
347             lastRewardAmount = reward_amount;
348             lastRewardEthBlockNumber = block.number;
349 
350 
351              _startNewMiningEpoch();
352 
353               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
354 
355            return true;
356 
357         }
358 
359 
360     //a new 'block' to be mined
361     function _startNewMiningEpoch() internal {
362 
363       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
364 
365       //40 is the final reward era, almost all tokens minted
366       //once the final era is reached, more tokens will not be given out because the assert function
367       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
368       {
369         rewardEra = rewardEra + 1;
370       }
371 
372       //set the next minted supply at which the era will change
373       // total supply is 2100000000000000  because of 8 decimal places
374       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
375 
376       epochCount = epochCount.add(1);
377 
378       //every so often, readjust difficulty. Dont readjust when deploying
379       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
380       {
381         _reAdjustDifficulty();
382       }
383 
384 
385       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
386       //do this last since this is a protection mechanism in the mint() function
387       challengeNumber = block.blockhash(block.number - 1);
388 
389 
390 
391 
392 
393 
394     }
395 
396 
397 
398 
399     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
400     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
401 
402     //readjust the target by 5 percent
403     function _reAdjustDifficulty() internal {
404 
405 
406         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
407         //assume 360 ethereum blocks per hour
408 
409         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoinCash epoch
410         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
411 
412         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
413 
414         //if there were less eth blocks passed in time than expected
415         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
416         {
417           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
418 
419           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
420           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
421 
422           //make it harder
423           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
424         }else{
425           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
426 
427           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
428 
429           //make it easier
430           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
431         }
432 
433 
434 
435         latestDifficultyPeriodStarted = block.number;
436 
437         if(miningTarget < _MINIMUM_TARGET) //very difficult
438         {
439           miningTarget = _MINIMUM_TARGET;
440         }
441 
442         if(miningTarget > _MAXIMUM_TARGET) //very easy
443         {
444           miningTarget = _MAXIMUM_TARGET;
445         }
446     }
447 
448 
449     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
450     function getChallengeNumber() public constant returns (bytes32) {
451         return challengeNumber;
452     }
453 
454     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
455      function getMiningDifficulty() public constant returns (uint) {
456         return _MAXIMUM_TARGET.div(miningTarget);
457     }
458 
459     function getMiningTarget() public constant returns (uint) {
460        return miningTarget;
461    }
462 
463 
464 
465     //21m coins total
466     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
467     function getMiningReward() public constant returns (uint) {
468         //once we get half way thru the coins, only get 25 per block
469 
470          //every reward era, the reward amount halves.
471 
472          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
473 
474     }
475 
476     //help debug mining software
477     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
478 
479         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
480 
481         return digest;
482 
483       }
484 
485         //help debug mining software
486       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
487 
488           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
489 
490           if(uint256(digest) > testTarget) revert();
491 
492           return (digest == challenge_digest);
493 
494         }
495 
496 
497 
498     // ------------------------------------------------------------------------
499 
500     // Total supply
501 
502     // ------------------------------------------------------------------------
503 
504     function totalSupply() public constant returns (uint) {
505 
506         return _totalSupply  - balances[address(0)];
507 
508     }
509 
510 
511 
512     // ------------------------------------------------------------------------
513 
514     // Get the token balance for account `tokenOwner`
515 
516     // ------------------------------------------------------------------------
517 
518     function balanceOf(address tokenOwner) public constant returns (uint balance) {
519 
520         return balances[tokenOwner];
521 
522     }
523 
524 
525 
526     // ------------------------------------------------------------------------
527 
528     // Transfer the balance from token owner's account to `to` account
529 
530     // - Owner's account must have sufficient balance to transfer
531 
532     // - 0 value transfers are allowed
533 
534     // ------------------------------------------------------------------------
535 
536     function transfer(address to, uint tokens) public returns (bool success) {
537 
538         balances[msg.sender] = balances[msg.sender].sub(tokens);
539 
540         balances[to] = balances[to].add(tokens);
541 
542         Transfer(msg.sender, to, tokens);
543 
544         return true;
545 
546     }
547 
548 
549 
550     // ------------------------------------------------------------------------
551 
552     // Token owner can approve for `spender` to transferFrom(...) `tokens`
553 
554     // from the token owner's account
555 
556     //
557 
558     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
559 
560     // recommends that there are no checks for the approval double-spend attack
561 
562     // as this should be implemented in user interfaces
563 
564     // ------------------------------------------------------------------------
565 
566     function approve(address spender, uint tokens) public returns (bool success) {
567 
568         allowed[msg.sender][spender] = tokens;
569 
570         Approval(msg.sender, spender, tokens);
571 
572         return true;
573 
574     }
575 
576 
577 
578     // ------------------------------------------------------------------------
579 
580     // Transfer `tokens` from the `from` account to the `to` account
581 
582     //
583 
584     // The calling account must already have sufficient tokens approve(...)-d
585 
586     // for spending from the `from` account and
587 
588     // - From account must have sufficient balance to transfer
589 
590     // - Spender must have sufficient allowance to transfer
591 
592     // - 0 value transfers are allowed
593 
594     // ------------------------------------------------------------------------
595 
596     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
597 
598         balances[from] = balances[from].sub(tokens);
599 
600         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
601 
602         balances[to] = balances[to].add(tokens);
603 
604         Transfer(from, to, tokens);
605 
606         return true;
607 
608     }
609 
610 
611 
612     // ------------------------------------------------------------------------
613 
614     // Returns the amount of tokens approved by the owner that can be
615 
616     // transferred to the spender's account
617 
618     // ------------------------------------------------------------------------
619 
620     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
621 
622         return allowed[tokenOwner][spender];
623 
624     }
625 
626 
627 
628     // ------------------------------------------------------------------------
629 
630     // Token owner can approve for `spender` to transferFrom(...) `tokens`
631 
632     // from the token owner's account. The `spender` contract function
633 
634     // `receiveApproval(...)` is then executed
635 
636     // ------------------------------------------------------------------------
637 
638     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
639 
640         allowed[msg.sender][spender] = tokens;
641 
642         Approval(msg.sender, spender, tokens);
643 
644         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
645 
646         return true;
647 
648     }
649 
650 
651 
652     // ------------------------------------------------------------------------
653 
654     // Don't accept ETH
655 
656     // ------------------------------------------------------------------------
657 
658     function () public payable {
659 
660         revert();
661 
662     }
663 
664 
665 
666     // ------------------------------------------------------------------------
667 
668     // Owner can transfer out any accidentally sent ERC20 tokens
669 
670     // ------------------------------------------------------------------------
671 
672     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
673 
674         return ERC20Interface(tokenAddress).transfer(owner, tokens);
675 
676     }
677 
678 }