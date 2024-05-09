1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // '0xLitecoin Token' contract
7 
8 // Mineable ERC20 Token using Proof Of Work
9 
10 
11 
12 /*
13 
14 the idea is that the miner uses proxyMergeMint in https://github.com/snissn/0xlitecoin-token/blob/master/contracts/MintHelper.sol#L189 
15 to call parent::mint() and then this::merge() in the same transaction
16 
17 */
18 
19 //
20 
21 // Symbol      : 0xLTC
22 
23 // Name        : 0xLitecoin Token
24 
25 // Total supply: 4*21,000,000.00
26 
27 // Decimals    : 8
28 
29 //
30 
31 
32 // ----------------------------------------------------------------------------
33 
34 
35 
36 // ----------------------------------------------------------------------------
37 
38 // Safe maths
39 
40 // ----------------------------------------------------------------------------
41 
42 library SafeMath {
43 
44     function add(uint a, uint b) internal pure returns (uint c) {
45 
46         c = a + b;
47 
48         require(c >= a);
49 
50     }
51 
52     function sub(uint a, uint b) internal pure returns (uint c) {
53 
54         require(b <= a);
55 
56         c = a - b;
57 
58     }
59 
60     function mul(uint a, uint b) internal pure returns (uint c) {
61 
62         c = a * b;
63 
64         require(a == 0 || c / a == b);
65 
66     }
67 
68     function div(uint a, uint b) internal pure returns (uint c) {
69 
70         require(b > 0);
71 
72         c = a / b;
73 
74     }
75 
76 }
77 
78 
79 
80 library ExtendedMath {
81 
82 
83     //return the smaller of the two inputs (a or b)
84     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
85 
86         if(a > b) return b;
87 
88         return a;
89 
90     }
91 }
92 
93 // ----------------------------------------------------------------------------
94 
95 // ERC Token Standard #20 Interface
96 
97 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
98 
99 // ----------------------------------------------------------------------------
100 
101 contract ERC20Interface {
102 
103     function totalSupply() public constant returns (uint);
104 
105     function balanceOf(address tokenOwner) public constant returns (uint balance);
106 
107     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
108 
109     function transfer(address to, uint tokens) public returns (bool success);
110 
111     function approve(address spender, uint tokens) public returns (bool success);
112 
113     function transferFrom(address from, address to, uint tokens) public returns (bool success);
114 
115 
116     event Transfer(address indexed from, address indexed to, uint tokens);
117 
118     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
119 
120 
121 }
122 
123 
124 contract ERC918Interface {
125   function totalSupply() public constant returns (uint);
126   function getMiningDifficulty() public constant returns (uint);
127   function getMiningTarget() public constant returns (uint);
128   function getMiningReward() public constant returns (uint);
129   function balanceOf(address tokenOwner) public constant returns (uint balance);
130 
131   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
132 
133   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
134   address public lastRewardTo;
135   uint public lastRewardAmount;
136   uint public lastRewardEthBlockNumber;
137   bytes32 public challengeNumber;
138 
139 
140 
141 }
142 
143 
144 // ----------------------------------------------------------------------------
145 
146 // Contract function to receive approval and execute function in one call
147 
148 //
149 
150 // Borrowed from MiniMeToken
151 
152 // ----------------------------------------------------------------------------
153 
154 contract ApproveAndCallFallBack {
155 
156     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
157 
158 }
159 
160 
161 
162 // ----------------------------------------------------------------------------
163 
164 // Owned contract
165 
166 // ----------------------------------------------------------------------------
167 
168 contract Owned {
169 
170     address public owner;
171 
172     address public newOwner;
173 
174 
175     event OwnershipTransferred(address indexed _from, address indexed _to);
176 
177 
178     function Owned() public {
179 
180         owner = msg.sender;
181 
182     }
183 
184 
185     modifier onlyOwner {
186 
187         require(msg.sender == owner);
188 
189         _;
190 
191     }
192 
193 
194     function transferOwnership(address _newOwner) public onlyOwner {
195 
196         newOwner = _newOwner;
197 
198     }
199 
200     function acceptOwnership() public {
201 
202         require(msg.sender == newOwner);
203 
204         OwnershipTransferred(owner, newOwner);
205 
206         owner = newOwner;
207 
208         newOwner = address(0);
209 
210     }
211 
212 }
213 
214 
215 
216 // ----------------------------------------------------------------------------
217 
218 // ERC20 Token, with the addition of symbol, name and decimals and an
219 
220 // initial fixed supply
221 
222 // ----------------------------------------------------------------------------
223 
224 contract _0xLitecoinToken is ERC20Interface, Owned {
225 
226     using SafeMath for uint;
227     using ExtendedMath for uint;
228 
229 
230     string public symbol;
231 
232     string public  name;
233 
234     uint8 public decimals;
235 
236     uint public _totalSupply;
237 
238     address parentAddress;
239 
240 
241      uint public latestDifficultyPeriodStarted;
242 
243 
244 
245     uint public epochCount;//number of 'blocks' mined
246 
247 
248     // the goal is for 0xLitecoin to be mined with 0xBTC
249 
250     uint public _BLOCKS_PER_READJUSTMENT = 1024;
251 
252 
253     //a little number
254     uint public  _MINIMUM_TARGET = 2**16; // TODO increase this before deploying
255 
256 
257       //a big number is easier ; just find a solution that is smaller
258     //uint public  _MAXIMUM_TARGET = 2**224;  Litecoin uses 224
259     uint public  _MAXIMUM_TARGET = 2**234;
260 
261 
262     uint public miningTarget;
263 
264     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
265 
266 
267 
268     uint public rewardEra;
269     uint public maxSupplyForEra;
270 
271 
272     address public lastRewardTo;
273     uint public lastRewardAmount;
274     uint public lastRewardEthBlockNumber;
275 
276     bool locked = false;
277 
278     mapping(bytes32 => bytes32) solutionForChallenge;
279 
280     uint public tokensMinted;
281 
282     mapping(address => uint) balances;
283 
284 
285     mapping(address => mapping(address => uint)) allowed;
286 
287 
288     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
289 
290     // ------------------------------------------------------------------------
291 
292     // Constructor
293 
294     // ------------------------------------------------------------------------
295 
296     function _0xLitecoinToken() public onlyOwner{
297 
298 
299 
300         symbol = "0xLTC";
301 
302         name = "0xLitecoin Token";
303 
304         decimals = 8;
305 
306         _totalSupply = 4*21000000 * 10**uint(decimals);
307 
308         if(locked) revert();
309         locked = true;
310 
311         tokensMinted = 0;
312 
313         rewardEra = 0;
314         maxSupplyForEra = _totalSupply.div(2);
315 
316         miningTarget = 27938697607979437428382017032425071986904332731688489302005732; // from 0xBitcoin as of block 5902249
317 
318         latestDifficultyPeriodStarted = block.number;
319 
320         _startNewMiningEpoch();
321 
322         parentAddress = 0xb6ed7644c69416d67b522e20bc294a9a9b405b31;
323 
324 
325 
326         //The owner gets nothing! You must mine this ERC20 token
327         //balances[owner] = _totalSupply;
328         //Transfer(address(0), owner, _totalSupply);
329 
330     }
331 
332 
333 
334 
335         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
336 
337 
338             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
339             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
340 
341             //the challenge digest must match the expected
342             if (digest != challenge_digest) revert();
343 
344             //the digest must be smaller than the target
345             if(uint256(digest) > miningTarget) revert();
346 
347 
348             //only allow one reward for each challenge
349              bytes32 solution = solutionForChallenge[challengeNumber];
350              solutionForChallenge[challengeNumber] = digest;
351              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
352 
353 
354             uint reward_amount = getMiningReward();
355 
356             balances[msg.sender] = balances[msg.sender].add(reward_amount);
357 
358             tokensMinted = tokensMinted.add(reward_amount);
359 
360 
361             //Cannot mint more tokens than there are
362             assert(tokensMinted <= maxSupplyForEra);
363 
364             //set readonly diagnostics data
365             lastRewardTo = msg.sender;
366             lastRewardAmount = reward_amount;
367             lastRewardEthBlockNumber = block.number;
368 
369 
370              _startNewMiningEpoch();
371 
372               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
373 
374            return true;
375 
376         }
377 
378 
379 
380 
381         function merge() public returns (bool success) {
382 
383             // the idea is that the miner uses https://github.com/0xbitcoin/mint-helper/blob/master/contracts/MintHelper.sol 
384             // to call mint() and then mergeMint() in the same transaction
385 
386 
387 
388             // hard code a reference to the "Parent" ERC918 Contract ( in this case 0xBitcoin)
389             // Verify that the Parent contract was minted in this block, by the same person calling this contract
390             // then followthrough with the resulting mint logic
391             // don't call revert, but return true or false based on success
392             // this method shouldn't revert because it will be calleed in the same transaction as a "Parent" mint attempt
393 
394             //ensure that mergeMint() can only be called once per Parent::mint()
395             //do this by ensuring that the "new" challenge number from Parent::challenge post mint can be called once
396             //and that this block time is the same as this mint, and the caller is msg.sender
397 
398 
399             //only allow one reward for each challenge
400             // do this by calculating what the new challenge will be in _startNewMiningEpoch, and verify that it is not that value
401             // this checks happen in the local contract, not in the parent
402 
403             bytes32 future_challengeNumber = block.blockhash(block.number - 1);
404             if(challengeNumber == future_challengeNumber){
405                 return false; // ( this is likely the second time that mergeMint() has been called in a transaction, so return false (don't revert))
406             }
407 
408             //verify Parent::lastRewardTo == msg.sender;
409             if(ERC918Interface(parentAddress).lastRewardTo() != msg.sender){
410                 return false; // a different address called mint last so return false ( don't revert)
411             }
412             
413             //verify Parent::lastRewardEthBlockNumber == block.number;
414 
415             if(ERC918Interface(parentAddress).lastRewardEthBlockNumber() != block.number){
416                 return false; // parent::mint() was called in a different block number so return false ( don't revert)
417             }
418 
419             //we have verified that _startNewMiningEpoch has not been run more than once this block by verifying that
420             // the challenge is not the challenge that will be set by _startNewMiningEpoch
421             //we have verified that this is the same block as a call to Parent::mint() and that the sender
422             // is the sender that has called mint
423 
424 
425 
426              //0xLTC will have the same challenge numbers as 0xBitcoin, this means that mining for one is literally the same process as mining for the other
427              // we want to make sure that one can't use a combination of merge and mint to get two blocks of 0xLTC for each valid nonce, since the same solution 
428              //    applies to each coin
429              // for this reason, we update the solutionForChallenge hashmap with the value of parent::challengeNumber when a solution is merge minted.
430              // when a miner finds a valid solution, if they call this::mint(), without the next few lines of code they can then subsequently use the mint helper and in one transaction
431              //   call parent::mint() this::merge(). the following code will ensure that this::merge() does not give a block reward, because the challenge number will already be set in the 
432              //   solutionForChallenge map
433              //only allow one reward for each challenge based on parent::challengeNumber
434              bytes32 parentChallengeNumber = ERC918Interface(parentAddress).challengeNumber();
435              bytes32 solution = solutionForChallenge[parentChallengeNumber];
436              if(solution != 0x0) return false;  //prevent the same answer from awarding twice
437              bytes32 digest = 'merge';
438              solutionForChallenge[parentChallengeNumber] = digest;
439 
440 
441             //so now we may safely run the relevant logic to give an award to the sender, and update the contract
442 
443             uint reward_amount = getMiningReward();
444 
445             balances[msg.sender] = balances[msg.sender].add(reward_amount);
446 
447             tokensMinted = tokensMinted.add(reward_amount);
448 
449 
450             //Cannot mint more tokens than there are
451             assert(tokensMinted <= maxSupplyForEra);
452 
453             //set readonly diagnostics data
454             lastRewardTo = msg.sender;
455             lastRewardAmount = reward_amount;
456             lastRewardEthBlockNumber = block.number;
457 
458 
459              _startNewMiningEpoch();
460 
461               Mint(msg.sender, reward_amount, epochCount, 0 ); // use 0 to indicate a merge mine
462 
463            return true;
464 
465         }
466 
467 
468 
469     //a new 'block' to be mined
470     function _startNewMiningEpoch() internal {
471 
472       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
473 
474       //40 is the final reward era, almost all tokens minted
475       //once the final era is reached, more tokens will not be given out because the assert function
476       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
477       {
478         rewardEra = rewardEra + 1;
479       }
480 
481       //set the next minted supply at which the era will change
482       // total supply is 4*2100000000000000  because of 8 decimal places
483       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
484 
485       epochCount = epochCount.add(1);
486 
487       //every so often, readjust difficulty. Dont readjust when deploying
488       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
489       {
490         _reAdjustDifficulty();
491       }
492 
493 
494       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
495       //do this last since this is a protection mechanism in the mint() function
496       challengeNumber = block.blockhash(block.number - 1);
497 
498 
499 
500 
501 
502 
503     }
504 
505 
506 
507 
508     //https://en.Litecoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
509     //as of 2017 the Litecoin difficulty was up to 17 zeroes, it was only 8 in the early days
510 
511     //readjust the target by 5 percent
512     function _reAdjustDifficulty() internal {
513 
514 
515         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
516         //assume 360 ethereum blocks per hour
517 
518         //we want miners to spend 15 minutes to mine each 'block', about 60 ethereum blocks = one 0xLitecoin epoch = one 0xBitcoin
519         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
520 
521         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
522 
523         //if there were less eth blocks passed in time than expected
524         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
525         {
526           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
527 
528           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
529           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
530 
531           //make it harder
532           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
533         }else{
534           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
535 
536           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
537 
538           //make it easier
539           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
540         }
541 
542 
543 
544         latestDifficultyPeriodStarted = block.number;
545 
546         if(miningTarget < _MINIMUM_TARGET) //very difficult
547         {
548           miningTarget = _MINIMUM_TARGET;
549         }
550 
551         if(miningTarget > _MAXIMUM_TARGET) //very easy
552         {
553           miningTarget = _MAXIMUM_TARGET;
554         }
555     }
556 
557 
558     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
559     function getChallengeNumber() public constant returns (bytes32) {
560         return challengeNumber;
561     }
562 
563     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
564      function getMiningDifficulty() public constant returns (uint) {
565         return _MAXIMUM_TARGET.div(miningTarget);
566     }
567 
568     function getMiningTarget() public constant returns (uint) {
569        return miningTarget;
570    }
571 
572 
573 
574     //4*21m coins total
575     //reward begins at 4*25 and is cut in half every reward era (as tokens are mined)
576     function getMiningReward() public constant returns (uint) {
577         //once we get half way thru the coins, only get 25 per block
578 
579          //every reward era, the reward amount halves.
580 
581          return (4*50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
582 
583     }
584 
585     //help debug mining software
586     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
587 
588         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
589 
590         return digest;
591 
592       }
593 
594         //help debug mining software
595       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
596 
597           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
598 
599           if(uint256(digest) > testTarget) revert();
600 
601           return (digest == challenge_digest);
602 
603         }
604 
605 
606 
607     // ------------------------------------------------------------------------
608 
609     // Total supply
610 
611     // ------------------------------------------------------------------------
612 
613     function totalSupply() public constant returns (uint) {
614 
615         return _totalSupply  - balances[address(0)];
616 
617     }
618 
619 
620 
621     // ------------------------------------------------------------------------
622 
623     // Get the token balance for account `tokenOwner`
624 
625     // ------------------------------------------------------------------------
626 
627     function balanceOf(address tokenOwner) public constant returns (uint balance) {
628 
629         return balances[tokenOwner];
630 
631     }
632 
633 
634 
635     // ------------------------------------------------------------------------
636 
637     // Transfer the balance from token owner's account to `to` account
638 
639     // - Owner's account must have sufficient balance to transfer
640 
641     // - 0 value transfers are allowed
642 
643     // ------------------------------------------------------------------------
644 
645     function transfer(address to, uint tokens) public returns (bool success) {
646 
647         balances[msg.sender] = balances[msg.sender].sub(tokens);
648 
649         balances[to] = balances[to].add(tokens);
650 
651         Transfer(msg.sender, to, tokens);
652 
653         return true;
654 
655     }
656 
657 
658 
659     // ------------------------------------------------------------------------
660 
661     // Token owner can approve for `spender` to transferFrom(...) `tokens`
662 
663     // from the token owner's account
664 
665     //
666 
667     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
668 
669     // recommends that there are no checks for the approval double-spend attack
670 
671     // as this should be implemented in user interfaces
672 
673     // ------------------------------------------------------------------------
674 
675     function approve(address spender, uint tokens) public returns (bool success) {
676 
677         allowed[msg.sender][spender] = tokens;
678 
679         Approval(msg.sender, spender, tokens);
680 
681         return true;
682 
683     }
684 
685 
686 
687     // ------------------------------------------------------------------------
688 
689     // Transfer `tokens` from the `from` account to the `to` account
690 
691     //
692 
693     // The calling account must already have sufficient tokens approve(...)-d
694 
695     // for spending from the `from` account and
696 
697     // - From account must have sufficient balance to transfer
698 
699     // - Spender must have sufficient allowance to transfer
700 
701     // - 0 value transfers are allowed
702 
703     // ------------------------------------------------------------------------
704 
705     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
706 
707         balances[from] = balances[from].sub(tokens);
708 
709         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
710 
711         balances[to] = balances[to].add(tokens);
712 
713         Transfer(from, to, tokens);
714 
715         return true;
716 
717     }
718 
719 
720 
721     // ------------------------------------------------------------------------
722 
723     // Returns the amount of tokens approved by the owner that can be
724 
725     // transferred to the spender's account
726 
727     // ------------------------------------------------------------------------
728 
729     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
730 
731         return allowed[tokenOwner][spender];
732 
733     }
734 
735 
736 
737     // ------------------------------------------------------------------------
738 
739     // Token owner can approve for `spender` to transferFrom(...) `tokens`
740 
741     // from the token owner's account. The `spender` contract function
742 
743     // `receiveApproval(...)` is then executed
744 
745     // ------------------------------------------------------------------------
746 
747     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
748 
749         allowed[msg.sender][spender] = tokens;
750 
751         Approval(msg.sender, spender, tokens);
752 
753         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
754 
755         return true;
756 
757     }
758 
759 
760 
761     // ------------------------------------------------------------------------
762 
763     // Don't accept ETH
764 
765     // ------------------------------------------------------------------------
766 
767     function () public payable {
768 
769         revert();
770 
771     }
772 
773 
774 
775     // ------------------------------------------------------------------------
776 
777     // Owner can transfer out any accidentally sent ERC20 tokens
778 
779     // ------------------------------------------------------------------------
780 
781     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
782 
783         return ERC20Interface(tokenAddress).transfer(owner, tokens);
784 
785     }
786 
787 }