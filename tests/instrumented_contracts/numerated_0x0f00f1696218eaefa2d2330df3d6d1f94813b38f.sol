1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 
5 // 'SEDO PoW Token' contract
6 
7 // Mineable ERC20 / ERC918 Token using Proof Of Work
8 
9 // Supported Merge Mining with 0xbitcoin and other compatible tokens
10 
11 // Based on technologies of 0xBitcoin (0xbitcoin.org)
12 
13 // Many thanks to the Mikers help (http://mike.rs) for pool help
14 
15 // ********************************************************
16 
17 // S.E.D.O. web site: http://sedocoin.org
18 // S.E.D.O. pool address: http://pool.sedocoin.org
19 
20 // ********************************************************
21 
22 // Symbol      : SEDO
23 
24 // Name        : SEDO PoW Token
25 
26 // Total supply: 50,000,000.00
27 // Premine     : 1,000,000
28 
29 // Decimals    : 8
30 
31 // Rewards     : 25 (initial)
32 
33 
34 // ********************************************************
35 
36 // Safe maths
37 
38 // ----------------------------------------------------------------------------
39 
40 library SafeMath {
41 
42     function add(uint a, uint b) internal pure returns (uint c) {
43 
44         c = a + b;
45 
46         require(c >= a);
47 
48     }
49 
50     function sub(uint a, uint b) internal pure returns (uint c) {
51 
52         require(b <= a);
53 
54         c = a - b;
55 
56     }
57 
58     function mul(uint a, uint b) internal pure returns (uint c) {
59 
60         c = a * b;
61 
62         require(a == 0 || c / a == b);
63 
64     }
65 
66     function div(uint a, uint b) internal pure returns (uint c) {
67 
68         require(b > 0);
69 
70         c = a / b;
71 
72     }
73 
74 }
75 
76 
77 
78 library ExtendedMath {
79 
80 
81     //return the smaller of the two inputs (a or b)
82     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
83 
84         if(a > b) return b;
85 
86         return a;
87 
88     }
89 }
90 
91 // ----------------------------------------------------------------------------
92 
93 // ERC Token Standard #20 Interface
94 
95 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
96 
97 // ----------------------------------------------------------------------------
98 
99 contract ERC20Interface {
100 
101     function totalSupply() public constant returns (uint);
102 
103     function balanceOf(address tokenOwner) public constant returns (uint balance);
104 
105     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
106 
107     function transfer(address to, uint tokens) public returns (bool success);
108 
109     function approve(address spender, uint tokens) public returns (bool success);
110 
111     function transferFrom(address from, address to, uint tokens) public returns (bool success);
112 
113 
114     event Transfer(address indexed from, address indexed to, uint tokens);
115 
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117 
118 }
119 
120 
121 
122 // ----------------------------------------------------------------------------
123 
124 // Contract function to receive approval and execute function in one call
125 
126 //
127 
128 // Borrowed from MiniMeToken
129 
130 // ----------------------------------------------------------------------------
131 
132 contract ApproveAndCallFallBack {
133 
134     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
135 
136 }
137 
138 
139 
140 // ----------------------------------------------------------------------------
141 
142 // Owned contract
143 
144 // ----------------------------------------------------------------------------
145 
146 contract Owned {
147 
148     address public owner;
149 
150     address public newOwner;
151 
152 
153     event OwnershipTransferred(address indexed _from, address indexed _to);
154 
155 
156     function Owned() public {
157 
158         owner = msg.sender;
159 
160     }
161 
162 
163     modifier onlyOwner {
164 
165         require(msg.sender == owner);
166 
167         _;
168 
169     }
170 
171 
172     function transferOwnership(address _newOwner) public onlyOwner {
173 
174         newOwner = _newOwner;
175 
176     }
177 
178     function acceptOwnership() public {
179 
180         require(msg.sender == newOwner);
181 
182         OwnershipTransferred(owner, newOwner);
183 
184         owner = newOwner;
185 
186         newOwner = address(0);
187 
188     }
189 
190 }
191 
192 
193 // ----------------------------------------------------------------------------
194 
195 // EIP-918 Interface
196 
197 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-918.md
198 
199 // ----------------------------------------------------------------------------
200 
201 
202 contract ERC918Interface {
203   function totalSupply() public constant returns (uint);
204   function getMiningDifficulty() public constant returns (uint);
205   function getMiningTarget() public constant returns (uint);
206   function getMiningReward() public constant returns (uint);
207   function balanceOf(address tokenOwner) public constant returns (uint balance);
208 
209   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
210 
211   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
212   address public lastRewardTo;
213   uint public lastRewardAmount;
214   uint public lastRewardEthBlockNumber;
215   bytes32 public challengeNumber;
216 
217 }
218 
219 
220 // ----------------------------------------------------------------------------
221 
222 // ERC20 Token, with the addition of symbol, name and decimals and an
223 
224 // initial fixed supply
225 
226 // ----------------------------------------------------------------------------
227 
228 
229 contract SedoPoWToken is ERC20Interface, Owned {
230 
231     using SafeMath for uint;
232     using ExtendedMath for uint;
233 
234 
235     string public symbol;
236 
237     string public  name;
238 
239     uint8 public decimals;
240 
241     uint public _totalSupply;
242 
243 
244     uint public latestDifficultyPeriodStarted;
245 
246     uint public epochCount;//number of 'blocks' mined
247 
248     uint public _BLOCKS_PER_READJUSTMENT = 1024;
249 
250     //a little number
251     uint public  _MINIMUM_TARGET = 2**16;
252 
253     uint public  _MAXIMUM_TARGET = 2**234;
254 
255     uint public miningTarget;
256 
257     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
258 
259     uint public rewardEra;
260     uint public maxSupplyForEra;
261 
262     address public lastRewardTo;
263     uint public lastRewardAmount;
264     uint public lastRewardEthBlockNumber;
265 
266     bool locked = false;
267 
268     mapping(bytes32 => bytes32) solutionForChallenge;
269 
270     uint public tokensMinted; 
271     address public parentAddress; //address of 0xbtc
272     uint public miningReward; //initial reward
273 
274     mapping(address => uint) balances;
275     
276     mapping(address => uint) merge_mint_ious;
277     mapping(address => uint) merge_mint_payout_threshold;
278 
279     mapping(address => mapping(address => uint)) allowed;
280 
281     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
282 
283     // ------------------------------------------------------------------------
284 
285     // Constructor
286 
287     // ------------------------------------------------------------------------
288 
289     function SedoPoWToken() public onlyOwner{
290 
291         symbol = "SEDO";
292 
293         name = "SEDO PoW Token";
294 
295         decimals = 8; 
296 
297         _totalSupply = 50000000 * 10**uint(decimals);
298 
299         if(locked) revert();
300         locked = true;
301 
302         tokensMinted = 1000000 * 10**uint(decimals);
303         
304         miningReward = 25; //initial Mining reward for 1st half of totalSupply (50 000 000 / 2)
305  
306         rewardEra = 0;
307         maxSupplyForEra = _totalSupply.div(2);
308 
309         miningTarget = 2**220; //initial mining target
310 
311         latestDifficultyPeriodStarted = block.number;
312 
313         _startNewMiningEpoch();
314 
315         parentAddress = 0x9D2Cc383E677292ed87f63586086CfF62a009010; //address of parent coin 0xBTC - need to be changed to actual in the mainnet !
316        //0xB6eD7644C69416d67B522e20bC294A9a9B405B31 - production
317 
318         balances[owner] = balances[owner].add(tokensMinted);
319         Transfer(address(this), owner, tokensMinted); 
320 
321 
322     }
323     
324     
325     // ------------------------------------------------------------------------
326 
327     // Parent contract changing (it can be useful if parent will make a swap or in some other cases)
328 
329     // ------------------------------------------------------------------------
330     
331 
332     function ParentCoinAddress(address parent) public onlyOwner{
333         parentAddress = parent;
334     }
335 
336 
337     // ------------------------------------------------------------------------
338 
339     // Main mint function
340 
341     // ------------------------------------------------------------------------
342 
343     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
344 
345 
346             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
347             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
348 
349             //the challenge digest must match the expected
350             if (digest != challenge_digest) revert();
351 
352             //the digest must be smaller than the target
353             if(uint256(digest) > miningTarget) revert();
354 
355 
356             //only allow one reward for each challenge
357             bytes32 solution = solutionForChallenge[challengeNumber];
358             solutionForChallenge[challengeNumber] = digest;
359             if(solution != 0x0) revert();  //prevent the same answer from awarding twice
360 
361 
362             uint reward_amount = getMiningReward();
363 
364             balances[msg.sender] = balances[msg.sender].add(reward_amount);
365 
366             tokensMinted = tokensMinted.add(reward_amount);
367 
368 
369             //Cannot mint more tokens than there are
370             assert(tokensMinted <= maxSupplyForEra);
371 
372             //set readonly diagnostics data
373             lastRewardTo = msg.sender;
374             lastRewardAmount = reward_amount;
375             lastRewardEthBlockNumber = block.number;
376             
377             _startNewMiningEpoch();
378 
379             Mint(msg.sender, reward_amount, epochCount, challengeNumber );
380               
381             emit Transfer(address(this), msg.sender, reward_amount); //we need add it to show token transfers in the etherscan
382 
383            return true;
384 
385     }
386 
387     
388     // ------------------------------------------------------------------------
389 
390     // merge mint function
391 
392     // ------------------------------------------------------------------------
393 
394     function merge() public returns (bool success) {
395 
396             // Function for the Merge mining (0xbitcoin as a parent coin)
397             // original idea by 0xbitcoin developers
398             // the idea is that the miner uses https://github.com/0xbitcoin/mint-helper/blob/master/contracts/MintHelper.sol 
399             // to call mint() and then mergeMint() in the same transaction
400             // hard code a reference to the "Parent" ERC918 Contract ( in this case 0xBitcoin)
401             // Verify that the Parent contract was minted in this block, by the same person calling this contract
402             // then followthrough with the resulting mint logic
403             // don't call revert, but return true or false based on success
404             // this method shouldn't revert because it will be calleed in the same transaction as a "Parent" mint attempt
405             //ensure that mergeMint() can only be called once per Parent::mint()
406             //do this by ensuring that the "new" challenge number from Parent::challenge post mint can be called once
407             //and that this block time is the same as this mint, and the caller is msg.sender
408             //only allow one reward for each challenge
409             // do this by calculating what the new challenge will be in _startNewMiningEpoch, and verify that it is not that value
410             // this checks happen in the local contract, not in the parent
411 
412             bytes32 future_challengeNumber = block.blockhash(block.number - 1);
413 
414             if(challengeNumber == future_challengeNumber){
415                 return false; // ( this is likely the second time that mergeMint() has been called in a transaction, so return false (don't revert))
416             }
417 
418             if(ERC918Interface(parentAddress).lastRewardTo() != msg.sender){
419                 return false; // a different address called mint last so return false ( don't revert)
420             }
421             
422 
423             if(ERC918Interface(parentAddress).lastRewardEthBlockNumber() != block.number){
424                 return false; // parent::mint() was called in a different block number so return false ( don't revert)
425             }
426 
427             //we have verified that _startNewMiningEpoch has not been run more than once this block by verifying that
428             // the challenge is not the challenge that will be set by _startNewMiningEpoch
429             //we have verified that this is the same block as a call to Parent::mint() and that the sender
430             // is the sender that has called mint
431             
432             //SEDO will have the same challenge numbers as 0xBitcoin, this means that mining for one is literally the same process as mining for the other
433             // we want to make sure that one can't use a combination of merge and mint to get two blocks of SEDO for each valid nonce, since the same solution 
434             //    applies to each coin
435             // for this reason, we update the solutionForChallenge hashmap with the value of parent::challengeNumber when a solution is merge minted.
436             // when a miner finds a valid solution, if they call this::mint(), without the next few lines of code they can then subsequently use the mint helper and in one transaction
437             //   call parent::mint() this::merge(). the following code will ensure that this::merge() does not give a block reward, because the challenge number will already be set in the 
438             //   solutionForChallenge map
439             //only allow one reward for each challenge based on parent::challengeNumber
440             
441             bytes32 parentChallengeNumber = ERC918Interface(parentAddress).challengeNumber();
442             bytes32 solution = solutionForChallenge[parentChallengeNumber];
443             if(solution != 0x0) return false;  //prevent the same answer from awarding twice
444 
445             //now that we've checked that the next challenge wasn't reused, apply the current SEDO challenge 
446             //this will prevent the 'previous' challenge from being reused
447             
448             bytes32 digest = 'merge';
449             solutionForChallenge[challengeNumber] = digest;
450 
451             //so now we may safely run the relevant logic to give an award to the sender, and update the contract
452 
453             uint reward_amount = getMiningReward();
454 
455             balances[msg.sender] = balances[msg.sender].add(reward_amount);
456 
457             tokensMinted = tokensMinted.add(reward_amount);
458 
459 
460             //Cannot mint more tokens than there are
461             assert(tokensMinted <= maxSupplyForEra);
462 
463             //set readonly diagnostics data
464             lastRewardTo = msg.sender;
465             lastRewardAmount = reward_amount;
466             lastRewardEthBlockNumber = block.number;
467 
468 
469             _startNewMiningEpoch();
470 
471             Mint(msg.sender, reward_amount, epochCount, 0 ); // use 0 to indicate a merge mine
472 
473             return true;
474 
475     }
476 
477 
478     //a new 'block' to be mined
479     
480     function _startNewMiningEpoch() internal {
481 
482       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
483 
484       //40 is the final reward era, almost all tokens minted
485       //once the final era is reached, more tokens will not be given out because the assert function
486       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
487       {
488         rewardEra = rewardEra + 1;
489       }
490 
491       //set the next minted supply at which the era will change
492       // total supply is 5000000000000000  because of 8 decimal places
493       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
494 
495       epochCount = epochCount.add(1);
496 
497       //every so often, readjust difficulty. Dont readjust when deploying
498       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
499       {
500         _reAdjustDifficulty();
501       }
502 
503 
504       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
505       //do this last since this is a protection mechanism in the mint() function
506       challengeNumber = block.blockhash(block.number - 1);
507 
508     }
509 
510 
511     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
512     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
513 
514     //readjust the target by 5 percent
515     
516     function _reAdjustDifficulty() internal {
517 
518 
519         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
520 
521         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
522 
523         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
524 
525         //if there were less eth blocks passed in time than expected
526         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
527         {
528             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
529 
530             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
531             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
532 
533             //make it harder
534             miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
535         }else{
536             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
537 
538             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
539 
540             //make it easier
541             miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
542         }
543 
544 
545         latestDifficultyPeriodStarted = block.number;
546 
547         if(miningTarget < _MINIMUM_TARGET) //very difficult
548         {
549           miningTarget = _MINIMUM_TARGET;
550         }
551 
552         if(miningTarget > _MAXIMUM_TARGET) //very easy
553         {
554           miningTarget = _MAXIMUM_TARGET;
555         }
556     }
557 
558 
559     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
560     function getChallengeNumber() public constant returns (bytes32) {
561         return challengeNumber;
562     }
563 
564     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
565      function getMiningDifficulty() public constant returns (uint) {
566         return _MAXIMUM_TARGET.div(miningTarget);
567     }
568 
569     function getMiningTarget() public constant returns (uint) {
570        return miningTarget;
571    }
572 
573 
574     //50m coins total
575     //reward begins at miningReward and is cut in half every reward era (as tokens are mined)
576     function getMiningReward() public constant returns (uint) {
577         //once we get half way thru the coins, only get 25 per block
578 
579          //every reward era, the reward amount halves.
580 
581          return (miningReward * 10**uint(decimals) ).div( 2**rewardEra ) ;
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
592     }
593 
594         //help debug mining software
595     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
596 
597           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
598 
599           if(uint256(digest) > testTarget) revert();
600 
601           return (digest == challenge_digest);
602 
603     }
604 
605 
606     // ------------------------------------------------------------------------
607 
608     // Total supply
609 
610     // ------------------------------------------------------------------------
611 
612     function totalSupply() public constant returns (uint) {
613 
614         return _totalSupply  - balances[address(0)];
615 
616     }
617 
618 
619     // ------------------------------------------------------------------------
620 
621     // Get the token balance for account `tokenOwner`
622 
623     // ------------------------------------------------------------------------
624 
625     function balanceOf(address tokenOwner) public constant returns (uint balance) {
626 
627         return balances[tokenOwner];
628 
629     }
630 
631 
632     // ------------------------------------------------------------------------
633 
634     // Transfer the balance from token owner's account to `to` account
635 
636     // - Owner's account must have sufficient balance to transfer
637 
638     // - 0 value transfers are allowed
639 
640     // ------------------------------------------------------------------------
641 
642     function transfer(address to, uint tokens) public returns (bool success) {
643 
644         balances[msg.sender] = balances[msg.sender].sub(tokens);
645 
646         balances[to] = balances[to].add(tokens);
647 
648         Transfer(msg.sender, to, tokens);
649 
650         return true;
651 
652     }
653 
654 
655     // ------------------------------------------------------------------------
656 
657     // Token owner can approve for `spender` to transferFrom(...) `tokens`
658 
659     // from the token owner's account
660 
661     //
662 
663     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
664 
665     // recommends that there are no checks for the approval double-spend attack
666 
667     // as this should be implemented in user interfaces
668 
669     // ------------------------------------------------------------------------
670 
671     function approve(address spender, uint tokens) public returns (bool success) {
672 
673         allowed[msg.sender][spender] = tokens;
674 
675         Approval(msg.sender, spender, tokens);
676 
677         return true;
678 
679     }
680 
681 
682     // ------------------------------------------------------------------------
683 
684     // Transfer `tokens` from the `from` account to the `to` account
685 
686     //
687 
688     // The calling account must already have sufficient tokens approve(...)-d
689 
690     // for spending from the `from` account and
691 
692     // - From account must have sufficient balance to transfer
693 
694     // - Spender must have sufficient allowance to transfer
695 
696     // - 0 value transfers are allowed
697 
698     // ------------------------------------------------------------------------
699 
700     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
701 
702         balances[from] = balances[from].sub(tokens);
703 
704         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
705 
706         balances[to] = balances[to].add(tokens);
707 
708         Transfer(from, to, tokens);
709 
710         return true;
711 
712     }
713 
714 
715 
716     // ------------------------------------------------------------------------
717 
718     // Returns the amount of tokens approved by the owner that can be
719 
720     // transferred to the spender's account
721 
722     // ------------------------------------------------------------------------
723 
724     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
725 
726         return allowed[tokenOwner][spender];
727 
728     }
729 
730 
731     // ------------------------------------------------------------------------
732 
733     // Token owner can approve for `spender` to transferFrom(...) `tokens`
734 
735     // from the token owner's account. The `spender` contract function
736 
737     // `receiveApproval(...)` is then executed
738 
739     // ------------------------------------------------------------------------
740 
741     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
742 
743         allowed[msg.sender][spender] = tokens;
744 
745         Approval(msg.sender, spender, tokens);
746 
747         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
748 
749         return true;
750 
751     }
752 
753     // ------------------------------------------------------------------------
754 
755     // Don't accept ETH
756 
757     // ------------------------------------------------------------------------
758 
759     function () public payable {
760 
761         revert();
762 
763     }
764 
765 
766     // ------------------------------------------------------------------------
767 
768     // Owner can transfer out any accidentally sent ERC20 tokens
769 
770     // ------------------------------------------------------------------------
771 
772     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
773 
774         return ERC20Interface(tokenAddress).transfer(owner, tokens);
775 
776     }
777 
778 }