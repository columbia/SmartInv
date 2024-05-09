1 //
2 //                                          |\,'\
3 //          ___                             | '  \
4 //     ___  \ /  ___         ,'\_           | .-. \        /|
5 //     \ /  | |,'__ \  ,'\_  |   \          | | | |      ,' |_   /|
6 //   _ | |  | |\/  \ \ |   \ | |\_|    _    | |_| |   _ '-. .-',' |_   _
7 //  // | |  | |____| | | |\_|| |__    //    |     | ,'_`. | | '-. .-',' `. ,'\_
8 //  \\_| |_,' .-, _  | | |   | |\ \  //    .| |\_/ | / \ || |   | | / |\  \|   \
9 //   `-. .-'| |/ / | | | |   | | \ \//     |  |    | | | || |   | | | |_\ || |\_|
10 //     | |  | || \_| | | |   /_\  \ /      | |`    | | | || |   | | | .---'| |
11 //     | |  | |\___,_\ /_\ _      //       | |     | \_/ || |   | | | |  /\| |
12 //     /_\  | |           //_____//       .||`  _   `._,' | |   | | \ `-' /| |
13 //          /_\           `------'        \ |  /-\ND _     `.\  | |  `._,' /_\
14 //                                         \|        |HE         `.\
15 //                                                                                                                                      
16 //        ,--.  ,--. ,-----. ,------.  ,-----.,------. ,--. ,--.,--.   ,--.    
17 //        |  '--'  |'  .-.  '|  .--. ''  .--./|  .--. '|  | |  | \  `.'  /    
18 //        |  .--.  ||  | |  ||  '--'.'|  |    |  '--'.'|  | |  |  .'    \      
19 //        |  |  |  |'  '-'  '|  |\  \ '  '--'\|  |\  \ '  '-'  ' /  .'.  \    
20 //        `--'  `--' `-----' `--' '--' `-----'`--' '--' `-----' '--'   '--'    
21 //  
22 //     The              ,--------. ,-----. ,--. ,--.,------.,--.  ,--. ,---.   
23 //      0xDiary        '--.  .--''  .-.  '|  .'   /|  .---'|  ,'.|  |'   .-'
24 //        Token           |  |   |  | |  ||  .   ' |  `--, |  |' '  |`.  `-.  
25 //                        |  |   '  '-'  '|  |\   \|  `---.|  | `   |.-'    | 
26 //                        `--'    `-----' `--' '--'`------'`--'  `--'`-----'
27 //   
28 //                  A Mineable ERC-20 / ERC-918 Token/Smart Contract
29 //                     
30 //                    
31 // ----------------------------------------------------------------------------
32 // 
33 //  0xDiary Basics:
34 //
35 //  	Symbol                     : 0xDIARY
36 //  	Name                       : The 0xDiary Token
37 //   	Total supply               : 1,000,000
38 //  	Decimals                   : 8
39 //   	First Miner Era Reward     : 4 0xDIARY
40 //  	Number of Eras             : 3
41 //  	Target Diff. Readjustment  : 250 Blocks
42 //  	Target Block Time          : 2 Minutes
43 
44 //
45 // ----------------------------------------------------------------------------
46 //
47 //   Website: https://0xhorcrux.github.io
48 //
49 // ----------------------------------------------------------------------------
50 //
51 //   ERC-20 / ERC-918 Token Fundamentals:
52 //
53 //   	- Autonomous decentralized currency
54 //
55 //   	- SoliditySHA3 proof of work algorithm
56 // 
57 //   	- Automatic difficulty adjustment
58 // 
59 //   	- Connectable with other Ethereum Smart Contracts
60 //
61 //-----------------------------------------------------------------------------
62 //
63 //   The Spellbook:
64 //    
65 //    - Use a computers processing power to destroy a piece of an 0xHorcrux.
66 //
67 //    - Download a solo miner or join a pool to participate.
68 //
69 //    - Miners are rewarded with a piece of a 0xHorcrux when they find a block.
70 //
71 //    - There is a limited supply of token pieces for each 0xHorcrux.
72 //
73 //    - Mining difficulty increases over time making them harder to acquire.
74 //
75 //    - More at https://0xhorcrux.github.io
76 //
77 //-----------------------------------------------------------------------------
78 pragma solidity ^0.4.18;
79 // ----------------------------------------------------------------------------
80 
81 // '0xDiary Token' contract
82 
83 // Mineable ERC20 Token using Proof Of Work
84 
85 // Symbol      : 0xDIARY
86 
87 // Name        : The 0xDiary Token
88 
89 // Total supply: 1,000,000 pieces
90 
91 // Decimals    : 8
92 
93 // ----------------------------------------------------------------------------
94 // Safe maths
95 // ----------------------------------------------------------------------------
96 
97 library SafeMath {
98 
99     function add(uint a, uint b) internal pure returns (uint c) {
100 
101         c = a + b;
102 
103         require(c >= a);
104 
105     }
106 
107     function sub(uint a, uint b) internal pure returns (uint c) {
108 
109         require(b <= a);
110 
111         c = a - b;
112 
113     }
114 
115     function mul(uint a, uint b) internal pure returns (uint c) {
116 
117         c = a * b;
118 
119         require(a == 0 || c / a == b);
120 
121     }
122 
123     function div(uint a, uint b) internal pure returns (uint c) {
124 
125         require(b > 0);
126 
127         c = a / b;
128 
129     }
130 
131 }
132 
133 library ExtendedMath {
134 
135     //return the smaller of the two inputs (a or b)
136     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
137 
138         if(a > b) return b;
139 
140         return a;
141 
142     }
143 }
144 
145 // ----------------------------------------------------------------------------
146 // ERC Token Standard #20 Interface
147 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
148 // ----------------------------------------------------------------------------
149 
150 contract ERC20Interface {
151 
152     function totalSupply() public constant returns (uint);
153 
154     function balanceOf(address tokenOwner) public constant returns (uint balance);
155 
156     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
157 
158     function transfer(address to, uint tokens) public returns (bool success);
159 
160     function approve(address spender, uint tokens) public returns (bool success);
161 
162     function transferFrom(address from, address to, uint tokens) public returns (bool success);
163 
164     event Transfer(address indexed from, address indexed to, uint tokens);
165 
166     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
167 
168 }
169 
170 // ----------------------------------------------------------------------------
171 // Contract function to receive approval and execute function in one call
172 // ----------------------------------------------------------------------------
173 
174 contract ApproveAndCallFallBack {
175 
176     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
177 
178 }
179 
180 // ----------------------------------------------------------------------------
181 // Owned contract
182 // ----------------------------------------------------------------------------
183 
184 contract Owned {
185 
186     address public owner;
187 
188     address public newOwner;
189 
190     event OwnershipTransferred(address indexed _from, address indexed _to);
191 
192     function Owned() public {
193 
194         owner = msg.sender;
195 
196     }
197 
198     modifier onlyOwner {
199 
200         require(msg.sender == owner);
201 
202         _;
203 
204     }
205 
206     function transferOwnership(address _newOwner) public onlyOwner {
207 
208         newOwner = _newOwner;
209 
210     }
211 
212     function acceptOwnership() public {
213 
214         require(msg.sender == newOwner);
215 
216         OwnershipTransferred(owner, newOwner);
217 
218         owner = newOwner;
219 
220         newOwner = address(0);
221 
222     }
223 
224 }
225 
226 // ----------------------------------------------------------------------------
227 // ERC20 Token, with the addition of symbol, name and decimals and an
228 // initial fixed supply
229 // ----------------------------------------------------------------------------
230 
231 contract _0xDiaryToken is ERC20Interface, Owned {
232 
233     using SafeMath for uint;
234     using ExtendedMath for uint;
235 
236     string public symbol;
237 
238     string public  name;
239 
240     uint8 public decimals;
241 
242     uint public _totalSupply;
243 
244     uint public latestDifficultyPeriodStarted;
245 
246     uint public epochCount;//number of 'blocks' mined
247 
248     uint public _BLOCKS_PER_READJUSTMENT = 250;
249 
250     //a little number
251     uint public  _MINIMUM_TARGET = 2**16;
252 
253       //a big number is easier ; just find a solution that is smaller
254     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
255     uint public  _MAXIMUM_TARGET = 2**234;
256 
257     uint public miningTarget;
258 
259     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
260 
261     uint public rewardEra;
262     uint public maxSupplyForEra;
263 
264     address public lastRewardTo;
265     uint public lastRewardAmount;
266     uint public lastRewardEthBlockNumber;
267 
268     bool locked = false;
269 
270     mapping(bytes32 => bytes32) solutionForChallenge;
271 
272     uint public tokensMinted;
273 
274     mapping(address => uint) balances;
275 
276     mapping(address => mapping(address => uint)) allowed;
277 
278     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
279 
280     // ------------------------------------------------------------------------
281     // Constructor
282     // ------------------------------------------------------------------------
283 
284     function _0xDiaryToken() public onlyOwner{
285 
286 
287         symbol = "0xDIARY";
288 
289         name = "The 0xDiary Token";
290 
291         decimals = 8;
292 
293         _totalSupply = 1000000 * 10**uint(decimals);
294 
295         if(locked) revert();
296         locked = true;
297 
298         tokensMinted = 0;
299 
300         rewardEra = 0;
301         maxSupplyForEra = _totalSupply.div(2);
302 
303         miningTarget = _MAXIMUM_TARGET;
304 
305         latestDifficultyPeriodStarted = block.number;
306 
307         _startNewMiningEpoch();
308 
309         //The owner gets nothing! You must mine this ERC20 token
310         //balances[owner] = _totalSupply;
311         //Transfer(address(0), owner, _totalSupply);
312 
313     }
314 
315         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
316 
317             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
318             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
319 
320             //the challenge digest must match the expected
321             if (digest != challenge_digest) revert();
322 
323             //the digest must be smaller than the target
324             if(uint256(digest) > miningTarget) revert();
325 
326             //only allow one reward for each challenge
327              bytes32 solution = solutionForChallenge[challengeNumber];
328              solutionForChallenge[challengeNumber] = digest;
329              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
330 
331             uint reward_amount = getMiningReward();
332 
333             balances[msg.sender] = balances[msg.sender].add(reward_amount);
334 
335             tokensMinted = tokensMinted.add(reward_amount);
336 
337             //Cannot mint more tokens than there are
338             assert(tokensMinted <= maxSupplyForEra);
339 
340             //set readonly diagnostics data
341             lastRewardTo = msg.sender;
342             lastRewardAmount = reward_amount;
343             lastRewardEthBlockNumber = block.number;
344 
345              _startNewMiningEpoch();
346 
347               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
348 
349            return true;
350 
351         }
352 
353     //a new 'block' to be mined
354     function _startNewMiningEpoch() internal {
355 
356       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
357 
358       //3 is the final reward era, almost all tokens minted
359       //once the final era is reached, more tokens will not be given out because the assert function
360       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 2)
361       {
362         rewardEra = rewardEra + 1;
363       }
364 
365       //set the next minted supply at which the era will change
366       // total supply is 10000000000000000  because of 10 decimal places
367       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
368 
369       epochCount = epochCount.add(1);
370 
371       //every so often, readjust difficulty. Dont readjust when deploying
372       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
373       {
374         _reAdjustDifficulty();
375       }
376 
377       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
378       //do this last since this is a protection mechanism in the mint() function
379       challengeNumber = block.blockhash(block.number - 1);
380 
381     }
382 
383     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
384     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
385 
386     //readjust the target by 5 percent
387     function _reAdjustDifficulty() internal {
388 
389         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
390         //assume 360 ethereum blocks per hour
391 
392         //we want miners to spend 2 minutes to mine each 'block', about 12 ethereum blocks = one 0xdiary epoch
393                       uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
394 
395        
396         uint targetEthBlocksPerDiffPeriod = epochsMined * 12; //should be 12 times slower than ethereum
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
407           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
408         }else{
409           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
410 
411           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
412 
413           //make it easier
414           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
415         }
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
430     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
431     function getChallengeNumber() public constant returns (bytes32) {
432         return challengeNumber;
433     }
434 
435     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
436      function getMiningDifficulty() public constant returns (uint) {
437         return _MAXIMUM_TARGET.div(miningTarget);
438     }
439 
440     function getMiningTarget() public constant returns (uint) {
441        return miningTarget;
442    }
443 
444     //1m pieces total
445     //reward begins at 4 and is cut in half every reward era (as tokens are mined)
446     function getMiningReward() public constant returns (uint) {
447         //once we get half way thru the coins, only get 2 per block
448 
449          //every reward era, the reward amount halves.
450 
451          return (4 * 10**uint(decimals) ).div( 2**rewardEra ) ;
452 
453     }
454 
455     //help debug mining software
456     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
457 
458         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
459 
460         return digest;
461 
462       }
463 
464         //help debug mining software
465       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
466 
467           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
468 
469           if(uint256(digest) > testTarget) revert();
470 
471           return (digest == challenge_digest);
472 
473         }
474 
475     // ------------------------------------------------------------------------
476     // Total supply
477     // ------------------------------------------------------------------------
478 
479     function totalSupply() public constant returns (uint) {
480 
481         return _totalSupply  - balances[address(0)];
482 
483     }
484 
485     // ------------------------------------------------------------------------
486     // Get the token balance for account `tokenOwner`
487     // ------------------------------------------------------------------------
488 
489     function balanceOf(address tokenOwner) public constant returns (uint balance) {
490 
491         return balances[tokenOwner];
492 
493     }
494 
495     // ------------------------------------------------------------------------
496     // Transfer the balance from token owner's account to `to` account
497     // - Owner's account must have sufficient balance to transfer
498     // - 0 value transfers are allowed
499     // ------------------------------------------------------------------------
500 
501     function transfer(address to, uint tokens) public returns (bool success) {
502 
503         balances[msg.sender] = balances[msg.sender].sub(tokens);
504 
505         balances[to] = balances[to].add(tokens);
506 
507         Transfer(msg.sender, to, tokens);
508 
509         return true;
510 
511     }
512 
513     // ------------------------------------------------------------------------
514     // Token owner can approve for `spender` to transferFrom(...) `tokens`
515     // from the token owner's account
516     //
517     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
518     // recommends that there are no checks for the approval double-spend attack
519     // as this should be implemented in user interfaces
520     // ------------------------------------------------------------------------
521 
522     function approve(address spender, uint tokens) public returns (bool success) {
523 
524         allowed[msg.sender][spender] = tokens;
525 
526         Approval(msg.sender, spender, tokens);
527 
528         return true;
529 
530     }
531 
532     // ------------------------------------------------------------------------
533     // Transfer `tokens` from the `from` account to the `to` account
534     //
535     // The calling account must already have sufficient tokens approve(...)-d
536     // for spending from the `from` account and
537     // - From account must have sufficient balance to transfer
538     // - Spender must have sufficient allowance to transfer
539     // - 0 value transfers are allowed
540     // ------------------------------------------------------------------------
541 
542     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
543 
544         balances[from] = balances[from].sub(tokens);
545 
546         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
547 
548         balances[to] = balances[to].add(tokens);
549 
550         Transfer(from, to, tokens);
551 
552         return true;
553 
554     }
555 
556     // ------------------------------------------------------------------------
557     // Returns the amount of tokens approved by the owner that can be
558     // transferred to the spender's account
559     // ------------------------------------------------------------------------
560 
561     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
562 
563         return allowed[tokenOwner][spender];
564 
565     }
566 
567     // ------------------------------------------------------------------------
568     // Token owner can approve for `spender` to transferFrom(...) `tokens`
569     // from the token owner's account. The `spender` contract function
570     // `receiveApproval(...)` is then executed
571     // ------------------------------------------------------------------------
572 
573     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
574 
575         allowed[msg.sender][spender] = tokens;
576 
577         Approval(msg.sender, spender, tokens);
578 
579         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
580 
581         return true;
582 
583     }
584 
585     // ------------------------------------------------------------------------
586     // Don't accept ETH
587     // ------------------------------------------------------------------------
588 
589     function () public payable {
590 
591         revert();
592 
593     }
594 
595     // ------------------------------------------------------------------------
596     // Owner can transfer out any accidentally sent ERC20 tokens
597     // ------------------------------------------------------------------------
598 
599     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
600 
601         return ERC20Interface(tokenAddress).transfer(owner, tokens);
602 
603     }
604 
605 }
606 
607 // ----------------------------------------------------------------------------
608 //
609 //                                          |\,'\
610 //          ___                             | '  \
611 //     ___  \ /  ___         ,'\_           | .-. \        /|
612 //     \ /  | |,'__ \  ,'\_  |   \          | | | |      ,' |_   /|
613 //   _ | |  | |\/  \ \ |   \ | |\_|    _    | |_| |   _ '-. .-',' |_   _
614 //  // | |  | |____| | | |\_|| |__    //    |     | ,'_`. | | '-. .-',' `. ,'\_
615 //  \\_| |_,' .-, _  | | |   | |\ \  //    .| |\_/ | / \ || |   | | / |\  \|   \
616 //   `-. .-'| |/ / | | | |   | | \ \//     |  |    | | | || |   | | | |_\ || |\_|
617 //     | |  | || \_| | | |   /_\  \ /      | |`    | | | || |   | | | .---'| |
618 //     | |  | |\___,_\ /_\ _      //       | |     | \_/ || |   | | | |  /\| |
619 //     /_\  | |           //_____//       .||`  _   `._,' | |   | | \ `-' /| |
620 //          /_\           `------'        \ |  /-\ND _     `.\  | |  `._,' /_\
621 //                                         \|        |HE         `.\
622 //                                                                                                                                      
623 //        ,--.  ,--. ,-----. ,------.  ,-----.,------. ,--. ,--.,--.   ,--.    
624 //        |  '--'  |'  .-.  '|  .--. ''  .--./|  .--. '|  | |  | \  `.'  /    
625 //        |  .--.  ||  | |  ||  '--'.'|  |    |  '--'.'|  | |  |  .'    \      
626 //        |  |  |  |'  '-'  '|  |\  \ '  '--'\|  |\  \ '  '-'  ' /  .'.  \    
627 //        `--'  `--' `-----' `--' '--' `-----'`--' '--' `-----' '--'   '--'    
628 //  
629 //     The              ,--------. ,-----. ,--. ,--.,------.,--.  ,--. ,---.   
630 //      0xDiary        '--.  .--''  .-.  '|  .'   /|  .---'|  ,'.|  |'   .-'
631 //        Token           |  |   |  | |  ||  .   ' |  `--, |  |' '  |`.  `-.  
632 //                        |  |   '  '-'  '|  |\   \|  `---.|  | `   |.-'    | 
633 //                        `--'    `-----' `--' '--'`------'`--'  `--'`-----'
634 //
635 //
636 //          0xDiary   0xRing   0xLocket   0xCup   0xDiadem   0xHP   0xSnake
637 //