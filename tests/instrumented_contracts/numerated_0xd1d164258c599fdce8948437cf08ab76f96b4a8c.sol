1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 
5 // '0xCatether Token' contract
6 
7 // Mineable ERC20 Token using Proof Of Work
8 
9 //
10 
11 // Symbol      : 0xCATE
12 
13 // Name        : 0xCatether Token
14 
15 // Total supply: No Limit
16 
17 // Decimals    : 8
18 
19 //
20 
21 
22 // ----------------------------------------------------------------------------
23 
24 
25 
26 // ----------------------------------------------------------------------------
27 
28 // Safe maths
29 
30 // ----------------------------------------------------------------------------
31 
32 library SafeMath {
33 
34     function add(uint a, uint b) internal pure returns (uint c) {
35 
36         c = a + b;
37 
38         require(c >= a);
39 
40     }
41 
42     function sub(uint a, uint b) internal pure returns (uint c) {
43 
44         require(b <= a);
45 
46         c = a - b;
47 
48     }
49 
50     function mul(uint a, uint b) internal pure returns (uint c) {
51 
52         c = a * b;
53 
54         require(a == 0 || c / a == b);
55 
56     }
57 
58     function div(uint a, uint b) internal pure returns (uint c) {
59 
60         require(b > 0);
61 
62         c = a / b;
63 
64     }
65 
66 }
67 
68 
69 
70 library ExtendedMath {
71 
72 
73     //return the smaller of the two inputs (a or b)
74     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
75 
76         if(a > b) return b;
77 
78         return a;
79 
80     }
81 }
82 
83 // ----------------------------------------------------------------------------
84 
85 // ERC Token Standard #20 Interface
86 
87 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
88 
89 // ----------------------------------------------------------------------------
90 
91 contract ERC20Interface {
92 
93     function totalSupply() public constant returns (uint);
94 
95     function balanceOf(address tokenOwner) public constant returns (uint balance);
96 
97     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
98 
99     function transfer(address to, uint tokens) public returns (bool success);
100 
101     function approve(address spender, uint tokens) public returns (bool success);
102 
103     function transferFrom(address from, address to, uint tokens) public returns (bool success);
104 
105 
106     event Transfer(address indexed from, address indexed to, uint tokens);
107 
108     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
109 
110 }
111 
112 
113 
114 // ----------------------------------------------------------------------------
115 
116 // Contract function to receive approval and execute function in one call
117 
118 //
119 
120 // Borrowed from MiniMeToken
121 
122 // ----------------------------------------------------------------------------
123 
124 contract ApproveAndCallFallBack {
125 
126     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
127 
128 }
129 
130 
131 
132 // ----------------------------------------------------------------------------
133 
134 // Owned contract
135 
136 // ----------------------------------------------------------------------------
137 
138 contract Owned {
139 
140     address public owner;
141 
142     address public newOwner;
143 
144 
145     event OwnershipTransferred(address indexed _from, address indexed _to);
146 
147 
148     constructor() public {
149 
150         owner = msg.sender;
151 
152     }
153 
154 
155     modifier onlyOwner {
156 
157         require(msg.sender == owner);
158 
159         _;
160 
161     }
162 
163 
164     function transferOwnership(address _newOwner) public onlyOwner {
165 
166         newOwner = _newOwner;
167 
168     }
169 
170     function acceptOwnership() public {
171 
172         require(msg.sender == newOwner);
173 
174         emit OwnershipTransferred(owner, newOwner);
175 
176         owner = newOwner;
177 
178         newOwner = address(0);
179 
180     }
181 
182 }
183 
184 
185 // ----------------------------------------------------------------------------
186 
187 // ERC20 Token, with the addition of symbol, name and decimals and an
188 
189 // initial fixed supply
190 
191 // ----------------------------------------------------------------------------
192 
193 contract _0xCatetherToken is ERC20Interface, Owned {
194 
195     using SafeMath for uint;
196     using ExtendedMath for uint;
197 
198 
199     string public symbol;
200 
201     string public  name;
202 
203     uint8 public decimals;
204 
205     uint public _totalSupply;
206 
207 
208 
209     uint public latestDifficultyPeriodStarted;
210 
211 
212     uint public epochCount;//number of 'blocks' mined
213 
214     //a little number
215     uint public  _MINIMUM_TARGET = 2**16;
216 
217 
218     //a big number is easier ; just find a solution that is smaller
219     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
220     uint public  _MAXIMUM_TARGET = 2**224;
221 
222 
223     uint public miningTarget;
224 
225     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
226 
227 
228     address public lastRewardTo;
229     uint public lastRewardAmount;
230     uint public lastRewardEthBlockNumber;
231 
232     // a bunch of maps to know where this is going (pun intended)
233     
234     mapping(bytes32 => bytes32) public solutionForChallenge;
235     mapping(uint => uint) public timeStampForEpoch;
236     mapping(uint => uint) public targetForEpoch;
237 
238     mapping(address => uint) balances;
239     mapping(address => address) donationsTo;
240 
241 
242     mapping(address => mapping(address => uint)) allowed;
243 
244     event Donation(address donation);
245     event DonationAddressOf(address donator, address donnationAddress);
246     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
247 
248     // ------------------------------------------------------------------------
249 
250     // Constructor
251 
252     // ------------------------------------------------------------------------
253 
254     constructor() public{
255 
256         symbol = "0xCATE";
257 
258         name = "0xCatether Token";
259 
260         decimals = 8;
261         epochCount = 0;
262         _totalSupply = 0;
263 
264         miningTarget = _MAXIMUM_TARGET;
265         challengeNumber = "GENESIS_BLOCK";
266         solutionForChallenge[challengeNumber] = "Yes, this is the Genesis block.";
267 
268         latestDifficultyPeriodStarted = block.number;
269 
270         _startNewMiningEpoch();
271 
272 
273         //The owner gets nothing! You must mine this ERC20 token
274         //balances[owner] = _totalSupply;
275         //Transfer(address(0), owner, _totalSupply);
276     }
277 
278 
279 
280 
281         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
282 
283 
284             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
285             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
286 
287             //the challenge digest must match the expected
288             if (digest != challenge_digest) revert();
289 
290             //the digest must be smaller than the target
291             if(uint256(digest) > miningTarget) revert();
292 
293 
294             //only allow one reward for each challenge
295              bytes32 solution = solutionForChallenge[challengeNumber];
296              solutionForChallenge[challengeNumber] = digest;
297              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
298 
299 
300             uint reward_amount = getMiningReward(digest);
301 
302             balances[msg.sender] = balances[msg.sender].add(reward_amount);
303 
304             _totalSupply = _totalSupply.add(reward_amount);
305 
306             //set readonly diagnostics data
307             lastRewardTo = msg.sender;
308             lastRewardAmount = reward_amount;
309             lastRewardEthBlockNumber = block.number;
310 
311              _startNewMiningEpoch();
312 
313               emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
314 
315            return true;
316 
317         }
318 
319 
320     //a new 'block' to be mined
321     function _startNewMiningEpoch() internal {
322         
323         targetForEpoch[epochCount] = miningTarget;
324         timeStampForEpoch[epochCount] = block.timestamp;
325         epochCount = epochCount.add(1);
326     
327       //Difficulty adjustment following the DigiChieldv3 implementation (Tempered-SMA)
328       // Allows more thorough protection against multi-pool hash attacks
329       // https://github.com/zawy12/difficulty-algorithms/issues/9
330         _reAdjustDifficulty();
331 
332 
333       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
334       //do this last since this is a protection mechanism in the mint() function
335       challengeNumber = blockhash(block.number - 1);
336 
337     }
338 
339 
340 
341 
342     //https://github.com/zawy12/difficulty-algorithms/issues/9
343     //readjust the target via a tempered SMA
344     function _reAdjustDifficulty() internal {
345         
346         //we want miners to spend 1 minutes to mine each 'block'
347         //for that, we need to approximate as closely as possible the current difficulty, by averaging the 28 last difficulties,
348         // compared to the average time it took to mine each block.
349         // also, since we can't really do that if we don't even have 28 mined blocks, difficulty will not move until we reach that number.
350         
351         uint timeTarget = 188; // roughly equals to Pi number. (There's also Phi somewhere below)
352         
353         if(epochCount>28) {
354             // counter, difficulty-sum, solve-time-sum, solve-time
355             uint i = 0;
356             uint sumD = 0;
357             uint sumST = 0;  // the first calculation of the timestamp difference can be negative, but it's not that bad (see below)
358             uint solvetime;
359             
360             for(i=epochCount.sub(28); i<epochCount; i++){
361                 sumD = sumD.add(targetForEpoch[i]);
362                 solvetime = timeStampForEpoch[i] - timeStampForEpoch[i-1];
363                 if (solvetime > timeTarget.mul(7)) {solvetime = timeTarget.mul(7); }
364                 //if (solvetime < timeTarget.mul(-6)) {solvetime = timeTarget.mul(-6); }    Ethereum EVM doesn't allow for a timestamp that make time go "backwards" anyway, so, we're good
365                 sumST += solvetime;                                                   //    (block.timestamp is an uint256 => negative = very very long time, thus rejected by the network)
366                 // we don't use safeAdd because in sore rare cases, it can underflow. However, the EVM structure WILL make it overflow right after, thus giving a correct SumST after a few loops
367             }
368             sumST = sumST.mul(10000).div(2523).add(1260); // 1260 seconds is a 75% weighing on what should be the actual time to mine 28 blocks.
369             miningTarget = sumD.mul(60).div(sumST); //We add it to the actual time it took with a weighted average (tempering)
370         }
371         
372         latestDifficultyPeriodStarted = block.number;
373 
374         if(miningTarget < _MINIMUM_TARGET) //very difficult
375         {
376           miningTarget = _MINIMUM_TARGET;
377         }
378 
379         if(miningTarget > _MAXIMUM_TARGET) //very easy
380         {
381           miningTarget = _MAXIMUM_TARGET;
382         }
383         targetForEpoch[epochCount] = miningTarget;
384     }
385 
386 
387     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
388     function getChallengeNumber() public constant returns (bytes32) {
389         return challengeNumber;
390     }
391 
392     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
393      function getMiningDifficulty() public constant returns (uint) {
394         return _MAXIMUM_TARGET.div(miningTarget);
395     }
396 
397     function getMiningTarget() public constant returns (uint) {
398        return miningTarget;
399    }
400 
401 
402 
403     //There's no limit to the coin supply
404     //reward follows the same emmission rate as Dogecoins'
405     function getMiningReward(bytes32 digest) public constant returns (uint) {
406         
407         if(epochCount > 600000) return (30000 * 10**uint(decimals) );
408         if(epochCount > 500000) return (46875 * 10**uint(decimals) );
409         if(epochCount > 400000) return (93750 * 10**uint(decimals) );
410         if(epochCount > 300000) return (187500 * 10**uint(decimals) );
411         if(epochCount > 200000) return (375000 * 10**uint(decimals) );
412         if(epochCount > 145000) return (500000 * 10**uint(decimals) );
413         if(epochCount > 100000) return ((uint256(keccak256(digest, blockhash(block.number - 2))) % 1500000) * 10**uint(decimals) );
414         return ( (uint256(keccak256(digest, blockhash(block.number - 2))) % 3000000) * 10**uint(decimals) );
415 
416     }
417 
418     //help debug mining software (even though challenge_digest isn't used, this function is constant and helps troubleshooting mining issues)
419     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
420 
421         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
422 
423         return digest;
424 
425       }
426 
427         //help debug mining software
428       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
429 
430           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
431 
432           if(uint256(digest) > testTarget) revert();
433 
434           return (digest == challenge_digest);
435 
436         }
437 
438 
439 
440     // ------------------------------------------------------------------------
441 
442     // Total supply
443 
444     // ------------------------------------------------------------------------
445 
446     function totalSupply() public constant returns (uint) {
447 
448         return _totalSupply  - balances[address(0)];
449 
450     }
451 
452 
453 
454     // ------------------------------------------------------------------------
455 
456     // Get the token balance for account `tokenOwner`
457 
458     // ------------------------------------------------------------------------
459 
460     function balanceOf(address tokenOwner) public constant returns (uint balance) {
461 
462         return balances[tokenOwner];
463 
464     }
465     
466     function donationTo(address tokenOwner) public constant returns (address donationAddress) {
467 
468         return donationsTo[tokenOwner];
469 
470     }
471     
472     function changeDonation(address donationAddress) public returns (bool success) {
473 
474         donationsTo[msg.sender] = donationAddress;
475         
476         emit DonationAddressOf(msg.sender , donationAddress); 
477         return true;
478     
479     }
480 
481 
482 
483     // ------------------------------------------------------------------------
484 
485     // Transfer the balance from token owner's account to `to` account
486 
487     // - Owner's account must have sufficient balance to transfer
488 
489     // - 0 value transfers are allowed
490 
491     // ------------------------------------------------------------------------
492 
493     function transfer(address to, uint tokens) public returns (bool success) {
494         
495         address donation = donationsTo[msg.sender];
496         balances[msg.sender] = balances[msg.sender].sub(tokens);
497         
498         balances[to] = balances[to].add(tokens);
499         balances[donation] = balances[donation].add(161803400);
500         
501         emit Transfer(msg.sender, to, tokens);
502         emit Donation(donation);
503         
504         return true;
505 
506     }
507     
508     function transferAndDonateTo(address to, uint tokens, address donation) public returns (bool success) {
509         
510         balances[msg.sender] = balances[msg.sender].sub(tokens);
511 
512         balances[to] = balances[to].add(tokens);
513         balances[donation] = balances[donation].add(161803400);
514 
515         emit Transfer(msg.sender, to, tokens);
516         emit Donation(donation);
517 
518         return true;
519 
520     }
521 
522 
523 
524     // ------------------------------------------------------------------------
525 
526     // Token owner can approve for `spender` to transferFrom(...) `tokens`
527 
528     // from the token owner's account
529 
530     //
531 
532     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
533 
534     // recommends that there are no checks for the approval double-spend attack
535 
536     // as this should be implemented in user interfaces
537 
538     // ------------------------------------------------------------------------
539 
540     function approve(address spender, uint tokens) public returns (bool success) {
541 
542         allowed[msg.sender][spender] = tokens;
543 
544         emit Approval(msg.sender, spender, tokens);
545 
546         return true;
547 
548     }
549 
550 
551 
552     // ------------------------------------------------------------------------
553 
554     // Transfer `tokens` from the `from` account to the `to` account
555 
556     //
557 
558     // The calling account must already have sufficient tokens approve(...)-d
559 
560     // for spending from the `from` account and
561 
562     // - From account must have sufficient balance to transfer
563 
564     // - Spender must have sufficient allowance to transfer
565 
566     // - 0 value transfers are allowed
567 
568     // ------------------------------------------------------------------------
569 
570     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
571         
572         address donation = donationsTo[from];
573         balances[from] = balances[from].sub(tokens);
574 
575         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
576 
577         balances[to] = balances[to].add(tokens);
578         balances[donation] = balances[donation].add(161803400);
579 
580         emit Transfer(from, to, tokens);
581         emit Donation(donation);
582 
583         return true;
584 
585     }
586 
587 
588 
589     // ------------------------------------------------------------------------
590 
591     // Returns the amount of tokens approved by the owner that can be
592 
593     // transferred to the spender's account
594 
595     // ------------------------------------------------------------------------
596 
597     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
598 
599         return allowed[tokenOwner][spender];
600 
601     }
602 
603 
604 
605     // ------------------------------------------------------------------------
606 
607     // Token owner can approve for `spender` to transferFrom(...) `tokens`
608 
609     // from the token owner's account. The `spender` contract function
610 
611     // `receiveApproval(...)` is then executed
612 
613     // ------------------------------------------------------------------------
614 
615     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
616 
617         allowed[msg.sender][spender] = tokens;
618 
619         emit Approval(msg.sender, spender, tokens);
620 
621         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
622 
623         return true;
624 
625     }
626 
627 
628 
629     // ------------------------------------------------------------------------
630 
631     // Don't accept ETH
632 
633     // ------------------------------------------------------------------------
634 
635     function () public payable {
636 
637         revert();
638 
639     }
640 
641 
642 
643     // ------------------------------------------------------------------------
644 
645     // Owner can transfer out any accidentally sent ERC20 tokens
646 
647     // ------------------------------------------------------------------------
648 
649     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
650 
651         return ERC20Interface(tokenAddress).transfer(owner, tokens);
652 
653     }
654 
655 }