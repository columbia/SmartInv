1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, reverts on overflow.
7      */
8     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24      */
25     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
26         require(_b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
37         require(_b <= _a);
38         uint256 c = _a - _b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two numbers, reverts on overflow.
45      */
46     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 library ExtendedMath {
64     function limitLessThan(uint a, uint b) internal pure returns(uint c) {
65         if (a > b) return b;
66         return a;
67     }
68 }
69 
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipRenounced(address indexed previousOwner);
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to relinquish control of the contract.
99    * @dev Renouncing to ownership will leave the contract without an owner.
100    * It will not be possible to call the functions with the `onlyOwner`
101    * modifier anymore.
102    */
103   function renounceOwnership() public onlyOwner {
104     emit OwnershipRenounced(owner);
105     owner = address(0);
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114   }
115 
116   /**
117    * @dev Transfers control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function _transferOwnership(address _newOwner) internal {
121     require(_newOwner != address(0));
122     emit OwnershipTransferred(owner, _newOwner);
123     owner = _newOwner;
124   }
125 }
126 
127 contract InterfaceContracts is Ownable {
128     InterfaceContracts public _internalMod;
129     
130     function setModifierContract (address _t) onlyOwner public {
131         _internalMod = InterfaceContracts(_t);
132     }
133 
134     modifier onlyMiningContract() {
135       require(msg.sender == _internalMod._contract_miner(), "Wrong sender");
136           _;
137       }
138 
139     modifier onlyTokenContract() {
140       require(msg.sender == _internalMod._contract_token(), "Wrong sender");
141       _;
142     }
143     
144     modifier onlyMasternodeContract() {
145       require(msg.sender == _internalMod._contract_masternode(), "Wrong sender");
146       _;
147     }
148     
149     modifier onlyVotingOrOwner() {
150       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
151       _;
152     }
153     
154     modifier onlyVotingContract() {
155       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
156       _;
157     }
158       
159     function _contract_voting () public view returns (address) {
160         return _internalMod._contract_voting();
161     }
162     
163     function _contract_masternode () public view returns (address) {
164         return _internalMod._contract_masternode();
165     }
166     
167     function _contract_token () public view returns (address) {
168         return _internalMod._contract_token();
169     }
170     
171     function _contract_miner () public view returns (address) {
172         return _internalMod._contract_miner();
173     }
174 }
175 
176 interface ICaelumMasternode {
177     function _externalArrangeFlow() external;
178     function rewardsProofOfWork() external returns (uint) ;
179     function rewardsMasternode() external returns (uint) ;
180     function masternodeIDcounter() external returns (uint) ;
181     function masternodeCandidate() external returns (uint) ;
182     function getUserFromID(uint) external view returns  (address) ;
183     function contractProgress() external view returns (uint, uint, uint, uint, uint, uint, uint, uint);
184 }
185 
186 interface ICaelumToken {
187     function rewardExternal(address, uint) external;
188     function balanceOf(address) external view returns (uint);
189 }
190 
191 interface EIP918Interface  {
192 
193     /*
194      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
195      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
196      * a Mint event is emitted before returning a success indicator.
197      **/
198   	function mint(uint256 nonce, bytes32 challenge_digest) external returns (bool success);
199 
200 
201 	/*
202      * Returns the challenge number
203      **/
204     function getChallengeNumber() external view returns (bytes32);
205 
206     /*
207      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which
208      * typically auto adjusts during reward generation.
209      **/
210     function getMiningDifficulty() external view returns (uint);
211 
212     /*
213      * Returns the mining target
214      **/
215     function getMiningTarget() external view returns (uint);
216 
217     /*
218      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era
219      * as tokens are mined to provide scarcity
220      **/
221     function getMiningReward() external view returns (uint);
222 
223     /*
224      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address,
225      * the reward amount, the epoch count and newest challenge number.
226      **/
227     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
228 
229 }
230 
231 contract AbstractERC918 is EIP918Interface {
232 
233     // generate a new challenge number after a new reward is minted
234     bytes32 public challengeNumber;
235 
236     // the current mining difficulty
237     uint public difficulty;
238 
239     // cumulative counter of the total minted tokens
240     uint public tokensMinted;
241 
242     // track read only minting statistics
243     struct Statistics {
244         address lastRewardTo;
245         uint lastRewardAmount;
246         uint lastRewardEthBlockNumber;
247         uint lastRewardTimestamp;
248     }
249 
250     Statistics public statistics;
251 
252     /*
253      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
254      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
255      * a Mint event is emitted before returning a success indicator.
256      **/
257     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
258 
259 
260     /*
261      * Internal interface function _hash. Overide in implementation to define hashing algorithm and
262      * validation
263      **/
264     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns (bytes32 digest);
265 
266     /*
267      * Internal interface function _reward. Overide in implementation to calculate and return reward
268      * amount
269      **/
270     function _reward() internal returns (uint);
271 
272     /*
273      * Internal interface function _newEpoch. Overide in implementation to define a cutpoint for mutating
274      * mining variables in preparation for the next epoch
275      **/
276     function _newEpoch(uint256 nonce) internal returns (uint);
277 
278     /*
279      * Internal interface function _adjustDifficulty. Overide in implementation to adjust the difficulty
280      * of the mining as required
281      **/
282     function _adjustDifficulty() internal returns (uint);
283 
284 }
285 
286 contract CaelumAbstractMiner is InterfaceContracts, AbstractERC918 {
287     /**
288      * CaelumMiner contract.
289      *
290      * We need to make sure the contract is 100% compatible when using the EIP918Interface.
291      * This contract is an abstract Caelum miner contract.
292      *
293      * Function 'mint', and '_reward' are overriden in the CaelumMiner contract.
294      * Function '_reward_masternode' is added and needs to be overriden in the CaelumMiner contract.
295      */
296 
297     using SafeMath for uint;
298     using ExtendedMath for uint;
299 
300     uint256 public totalSupply = 2100000000000000;
301 
302     uint public latestDifficultyPeriodStarted;
303     uint public epochCount;
304     uint public baseMiningReward = 50;
305     uint public blocksPerReadjustment = 512;
306     uint public _MINIMUM_TARGET = 2 ** 16;
307     uint public _MAXIMUM_TARGET = 2 ** 234;
308     uint public rewardEra = 0;
309 
310     uint public maxSupplyForEra;
311     uint public MAX_REWARD_ERA = 39;
312     uint public MINING_RATE_FACTOR = 60; //mint the token 60 times less often than ether
313 
314     uint public MAX_ADJUSTMENT_PERCENT = 100;
315     uint public TARGET_DIVISOR = 2000;
316     uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);
317     mapping(bytes32 => bytes32) solutionForChallenge;
318     mapping(address => mapping(address => uint)) allowed;
319 
320     bytes32 public challengeNumber;
321     uint public difficulty;
322     uint public tokensMinted;
323 
324     Statistics public statistics;
325 
326     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
327     event RewardMasternode(address candidate, uint amount);
328 
329     constructor() public {
330         tokensMinted = 0;
331         maxSupplyForEra = totalSupply.div(2);
332         difficulty = _MAXIMUM_TARGET;
333         latestDifficultyPeriodStarted = block.number;
334         _newEpoch(0);
335     }
336 
337     function _newEpoch(uint256 nonce) internal returns(uint) {
338         if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < MAX_REWARD_ERA) {
339             rewardEra = rewardEra + 1;
340         }
341         maxSupplyForEra = totalSupply - totalSupply.div(2 ** (rewardEra + 1));
342         epochCount = epochCount.add(1);
343         challengeNumber = blockhash(block.number - 1);
344         return (epochCount);
345     }
346 
347     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
348 
349     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns(bytes32 digest) {
350         digest = keccak256(challengeNumber, msg.sender, nonce);
351         if (digest != challenge_digest) revert();
352         if (uint256(digest) > difficulty) revert();
353         bytes32 solution = solutionForChallenge[challengeNumber];
354         solutionForChallenge[challengeNumber] = digest;
355         if (solution != 0x0) revert(); //prevent the same answer from awarding twice
356     }
357 
358     function _reward() internal returns(uint);
359 
360     function _reward_masternode() internal returns(uint);
361 
362     function _adjustDifficulty() internal returns(uint) {
363         //every so often, readjust difficulty. Dont readjust when deploying
364         if (epochCount % blocksPerReadjustment != 0) {
365             return difficulty;
366         }
367 
368         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
369         //assume 360 ethereum blocks per hour
370         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
371         uint epochsMined = blocksPerReadjustment;
372         uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;
373         //if there were less eth blocks passed in time than expected
374         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
375             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);
376             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);
377             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
378             //make it harder
379             difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra)); //by up to 50 %
380         } else {
381             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);
382             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000
383             //make it easier
384             difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra)); //by up to 50 %
385         }
386         latestDifficultyPeriodStarted = block.number;
387         if (difficulty < _MINIMUM_TARGET) //very difficult
388         {
389             difficulty = _MINIMUM_TARGET;
390         }
391         if (difficulty > _MAXIMUM_TARGET) //very easy
392         {
393             difficulty = _MAXIMUM_TARGET;
394         }
395     }
396 
397     function getChallengeNumber() public view returns(bytes32) {
398         return challengeNumber;
399     }
400 
401     function getMiningDifficulty() public view returns(uint) {
402         return _MAXIMUM_TARGET.div(difficulty);
403     }
404 
405     function getMiningTarget() public view returns(uint) {
406         return difficulty;
407     }
408 
409     function getMiningReward() public view returns(uint) {
410         return (baseMiningReward * 1e8).div(2 ** rewardEra);
411     }
412 
413     function getMintDigest(
414         uint256 nonce,
415         bytes32 challenge_digest,
416         bytes32 challenge_number
417     )
418     public view returns(bytes32 digesttest) {
419         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
420         return digest;
421     }
422 
423     function checkMintSolution(
424         uint256 nonce,
425         bytes32 challenge_digest,
426         bytes32 challenge_number,
427         uint testTarget
428     )
429     public view returns(bool success) {
430         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
431         if (uint256(digest) > testTarget) revert();
432         return (digest == challenge_digest);
433     }
434 }
435 
436 contract CaelumMiner is CaelumAbstractMiner {
437 
438     ICaelumToken public tokenInterface;
439     ICaelumMasternode public masternodeInterface;
440     bool public ACTIVE_STATE = false;
441     uint swapStartedBlock = now;
442     uint public gasPriceLimit = 999;
443 
444     /**
445      * @dev Allows the owner to set a gas limit on submitting solutions.
446      * courtesy of KiwiToken.
447      * See https://github.com/liberation-online/MineableToken for more details why.
448      */
449 
450     modifier checkGasPrice(uint txnGasPrice) {
451         require(txnGasPrice <= gasPriceLimit * 1000000000, "Gas above gwei limit!");
452         _;
453     }
454 
455     event GasPriceSet(uint8 _gasPrice);
456 
457     function setGasPriceLimit(uint8 _gasPrice) onlyOwner public {
458         require(_gasPrice > 0);
459         gasPriceLimit = _gasPrice;
460 
461         emit GasPriceSet(_gasPrice); //emit event
462     }
463 
464     function setTokenContract() internal {
465         tokenInterface = ICaelumToken(_contract_token());
466     }
467 
468     function setMasternodeContract() internal {
469         masternodeInterface = ICaelumMasternode(_contract_masternode());
470     }
471 
472     /**
473      * Override; For some reason, truffle testing does not recognize function.
474      */
475     function setModifierContract (address _contract) onlyOwner public {
476         require (now <= swapStartedBlock + 10 days);
477         _internalMod = InterfaceContracts(_contract);
478         setMasternodeContract();
479         setTokenContract();
480     }
481 
482     /**
483     * @dev Move the voting away from token. All votes will be made from the voting
484     */
485     function VoteModifierContract (address _contract) onlyVotingContract external {
486         //_internalMod = CaelumModifierAbstract(_contract);
487         _internalMod = InterfaceContracts(_contract);
488         setMasternodeContract();
489         setTokenContract();
490     }
491 
492     function mint(uint256 nonce, bytes32 challenge_digest) checkGasPrice(tx.gasprice) public returns(bool success) {
493         require(ACTIVE_STATE);
494 
495         _hash(nonce, challenge_digest);
496 
497         masternodeInterface._externalArrangeFlow();
498 
499         uint rewardAmount = _reward();
500         uint rewardMasternode = _reward_masternode();
501 
502         tokensMinted += rewardAmount.add(rewardMasternode);
503 
504         uint epochCounter = _newEpoch(nonce);
505 
506         _adjustDifficulty();
507 
508         statistics = Statistics(msg.sender, rewardAmount, block.number, now);
509 
510         emit Mint(msg.sender, rewardAmount, epochCounter, challengeNumber);
511 
512         return true;
513     }
514 
515     function _reward() internal returns(uint) {
516 
517         uint _pow = masternodeInterface.rewardsProofOfWork();
518 
519         tokenInterface.rewardExternal(msg.sender, 1 * 1e8);
520 
521         return _pow;
522     }
523 
524     function _reward_masternode() internal returns(uint) {
525 
526         uint _mnReward = masternodeInterface.rewardsMasternode();
527         if (masternodeInterface.masternodeIDcounter() == 0) return 0;
528 
529         address _mnCandidate = masternodeInterface.getUserFromID(masternodeInterface.masternodeCandidate()); // userByIndex[masternodeCandidate].accountOwner;
530         if (_mnCandidate == 0x0) return 0;
531 
532         tokenInterface.rewardExternal(_mnCandidate, _mnReward);
533 
534         emit RewardMasternode(_mnCandidate, _mnReward);
535 
536         return _mnReward;
537     }
538 
539     /**
540      * @dev Fetch data from the actual reward. We do this to prevent pools payout out
541      * the global reward instead of the calculated ones.
542      * By default, pools fetch the `getMiningReward()` value and will payout this amount.
543      */
544     function getMiningRewardForPool() public view returns(uint) {
545         return masternodeInterface.rewardsProofOfWork();
546     }
547 
548     function getMiningReward() public view returns(uint) {
549         return (baseMiningReward * 1e8).div(2 ** rewardEra);
550     }
551 
552     function contractProgress() public view returns
553         (
554             uint epoch,
555             uint candidate,
556             uint round,
557             uint miningepoch,
558             uint globalreward,
559             uint powreward,
560             uint masternodereward,
561             uint usercounter
562         ) {
563             return ICaelumMasternode(_contract_masternode()).contractProgress();
564 
565         }
566 
567     /**
568      * @dev Call this function prior to mining to copy all old contract values.
569      * This included minted tokens, difficulty, etc..
570      */
571 
572     function getDataFromContract(address _previous_contract) onlyOwner public {
573         require(ACTIVE_STATE == false);
574         require(_contract_token() != 0);
575         require(_contract_masternode() != 0);
576 
577         CaelumAbstractMiner prev = CaelumAbstractMiner(_previous_contract);
578         difficulty = prev.difficulty();
579         rewardEra = prev.rewardEra();
580         MINING_RATE_FACTOR = prev.MINING_RATE_FACTOR();
581         maxSupplyForEra = prev.maxSupplyForEra();
582         tokensMinted = prev.tokensMinted();
583         epochCount = prev.epochCount();
584 
585         ACTIVE_STATE = true;
586     }
587     
588     function balanceOf(address _owner) public view returns(uint256) {
589         return tokenInterface.balanceOf(_owner);
590     }
591 }