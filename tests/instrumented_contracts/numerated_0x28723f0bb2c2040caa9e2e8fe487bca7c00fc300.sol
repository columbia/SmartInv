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
188 }
189 
190 interface EIP918Interface  {
191 
192     /*
193      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
194      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
195      * a Mint event is emitted before returning a success indicator.
196      **/
197   	function mint(uint256 nonce, bytes32 challenge_digest) external returns (bool success);
198 
199 
200 	/*
201      * Returns the challenge number
202      **/
203     function getChallengeNumber() external view returns (bytes32);
204 
205     /*
206      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which
207      * typically auto adjusts during reward generation.
208      **/
209     function getMiningDifficulty() external view returns (uint);
210 
211     /*
212      * Returns the mining target
213      **/
214     function getMiningTarget() external view returns (uint);
215 
216     /*
217      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era
218      * as tokens are mined to provide scarcity
219      **/
220     function getMiningReward() external view returns (uint);
221 
222     /*
223      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address,
224      * the reward amount, the epoch count and newest challenge number.
225      **/
226     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
227 
228 }
229 
230 contract AbstractERC918 is EIP918Interface {
231 
232     // generate a new challenge number after a new reward is minted
233     bytes32 public challengeNumber;
234 
235     // the current mining difficulty
236     uint public difficulty;
237 
238     // cumulative counter of the total minted tokens
239     uint public tokensMinted;
240 
241     // track read only minting statistics
242     struct Statistics {
243         address lastRewardTo;
244         uint lastRewardAmount;
245         uint lastRewardEthBlockNumber;
246         uint lastRewardTimestamp;
247     }
248 
249     Statistics public statistics;
250 
251     /*
252      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
253      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
254      * a Mint event is emitted before returning a success indicator.
255      **/
256     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
257 
258 
259     /*
260      * Internal interface function _hash. Overide in implementation to define hashing algorithm and
261      * validation
262      **/
263     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns (bytes32 digest);
264 
265     /*
266      * Internal interface function _reward. Overide in implementation to calculate and return reward
267      * amount
268      **/
269     function _reward() internal returns (uint);
270 
271     /*
272      * Internal interface function _newEpoch. Overide in implementation to define a cutpoint for mutating
273      * mining variables in preparation for the next epoch
274      **/
275     function _newEpoch(uint256 nonce) internal returns (uint);
276 
277     /*
278      * Internal interface function _adjustDifficulty. Overide in implementation to adjust the difficulty
279      * of the mining as required
280      **/
281     function _adjustDifficulty() internal returns (uint);
282 
283 }
284 
285 contract CaelumAbstractMiner is InterfaceContracts, AbstractERC918 {
286     /**
287      * CaelumMiner contract.
288      *
289      * We need to make sure the contract is 100% compatible when using the EIP918Interface.
290      * This contract is an abstract Caelum miner contract.
291      *
292      * Function 'mint', and '_reward' are overriden in the CaelumMiner contract.
293      * Function '_reward_masternode' is added and needs to be overriden in the CaelumMiner contract.
294      */
295 
296     using SafeMath for uint;
297     using ExtendedMath for uint;
298 
299     uint256 public totalSupply = 2100000000000000;
300 
301     uint public latestDifficultyPeriodStarted;
302     uint public epochCount;
303     uint public baseMiningReward = 50;
304     uint public blocksPerReadjustment = 512;
305     uint public _MINIMUM_TARGET = 2 ** 16;
306     uint public _MAXIMUM_TARGET = 2 ** 234;
307     uint public rewardEra = 0;
308 
309     uint public maxSupplyForEra;
310     uint public MAX_REWARD_ERA = 39;
311     uint public MINING_RATE_FACTOR = 60; //mint the token 60 times less often than ether
312 
313     uint public MAX_ADJUSTMENT_PERCENT = 100;
314     uint public TARGET_DIVISOR = 2000;
315     uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);
316     mapping(bytes32 => bytes32) solutionForChallenge;
317     mapping(address => mapping(address => uint)) allowed;
318 
319     bytes32 public challengeNumber;
320     uint public difficulty;
321     uint public tokensMinted;
322 
323     Statistics public statistics;
324 
325     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
326     event RewardMasternode(address candidate, uint amount);
327 
328     constructor() public {
329         tokensMinted = 0;
330         maxSupplyForEra = totalSupply.div(2);
331         difficulty = _MAXIMUM_TARGET;
332         latestDifficultyPeriodStarted = block.number;
333         _newEpoch(0);
334     }
335 
336     function _newEpoch(uint256 nonce) internal returns(uint) {
337         if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < MAX_REWARD_ERA) {
338             rewardEra = rewardEra + 1;
339         }
340         maxSupplyForEra = totalSupply - totalSupply.div(2 ** (rewardEra + 1));
341         epochCount = epochCount.add(1);
342         challengeNumber = blockhash(block.number - 1);
343         return (epochCount);
344     }
345 
346     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
347 
348     function _hash(uint256 nonce, bytes32 challenge_digest) internal returns(bytes32 digest) {
349         digest = keccak256(challengeNumber, msg.sender, nonce);
350         if (digest != challenge_digest) revert();
351         if (uint256(digest) > difficulty) revert();
352         bytes32 solution = solutionForChallenge[challengeNumber];
353         solutionForChallenge[challengeNumber] = digest;
354         if (solution != 0x0) revert(); //prevent the same answer from awarding twice
355     }
356 
357     function _reward() internal returns(uint);
358 
359     function _reward_masternode() internal returns(uint);
360 
361     function _adjustDifficulty() internal returns(uint) {
362         //every so often, readjust difficulty. Dont readjust when deploying
363         if (epochCount % blocksPerReadjustment != 0) {
364             return difficulty;
365         }
366 
367         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
368         //assume 360 ethereum blocks per hour
369         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
370         uint epochsMined = blocksPerReadjustment;
371         uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;
372         //if there were less eth blocks passed in time than expected
373         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
374             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);
375             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);
376             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
377             //make it harder
378             difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra)); //by up to 50 %
379         } else {
380             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);
381             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000
382             //make it easier
383             difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra)); //by up to 50 %
384         }
385         latestDifficultyPeriodStarted = block.number;
386         if (difficulty < _MINIMUM_TARGET) //very difficult
387         {
388             difficulty = _MINIMUM_TARGET;
389         }
390         if (difficulty > _MAXIMUM_TARGET) //very easy
391         {
392             difficulty = _MAXIMUM_TARGET;
393         }
394     }
395 
396     function getChallengeNumber() public view returns(bytes32) {
397         return challengeNumber;
398     }
399 
400     function getMiningDifficulty() public view returns(uint) {
401         return _MAXIMUM_TARGET.div(difficulty);
402     }
403 
404     function getMiningTarget() public view returns(uint) {
405         return difficulty;
406     }
407 
408     function getMiningReward() public view returns(uint) {
409         return (baseMiningReward * 1e8).div(2 ** rewardEra);
410     }
411 
412     function getMintDigest(
413         uint256 nonce,
414         bytes32 challenge_digest,
415         bytes32 challenge_number
416     )
417     public view returns(bytes32 digesttest) {
418         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
419         return digest;
420     }
421 
422     function checkMintSolution(
423         uint256 nonce,
424         bytes32 challenge_digest,
425         bytes32 challenge_number,
426         uint testTarget
427     )
428     public view returns(bool success) {
429         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
430         if (uint256(digest) > testTarget) revert();
431         return (digest == challenge_digest);
432     }
433 }
434 
435 contract CaelumMiner is CaelumAbstractMiner {
436 
437     ICaelumToken public tokenInterface;
438     ICaelumMasternode public masternodeInterface;
439     bool public ACTIVE_STATE = false;
440     uint swapStartedBlock = now;
441     uint public gasPriceLimit = 999;
442 
443     /**
444      * @dev Allows the owner to set a gas limit on submitting solutions.
445      * courtesy of KiwiToken.
446      * See https://github.com/liberation-online/MineableToken for more details why.
447      */
448 
449     modifier checkGasPrice(uint txnGasPrice) {
450         require(txnGasPrice <= gasPriceLimit * 1000000000, "Gas above gwei limit!");
451         _;
452     }
453 
454     event GasPriceSet(uint8 _gasPrice);
455 
456     function setGasPriceLimit(uint8 _gasPrice) onlyOwner public {
457         require(_gasPrice > 0);
458         gasPriceLimit = _gasPrice;
459 
460         emit GasPriceSet(_gasPrice); //emit event
461     }
462 
463     function setTokenContract() internal {
464         tokenInterface = ICaelumToken(_contract_token());
465     }
466 
467     function setMasternodeContract() internal {
468         masternodeInterface = ICaelumMasternode(_contract_masternode());
469     }
470 
471     /**
472      * Override; For some reason, truffle testing does not recognize function.
473      */
474     function setModifierContract (address _contract) onlyOwner public {
475         require (now <= swapStartedBlock + 10 days);
476         _internalMod = InterfaceContracts(_contract);
477         setMasternodeContract();
478         setTokenContract();
479     }
480 
481     /**
482     * @dev Move the voting away from token. All votes will be made from the voting
483     */
484     function VoteModifierContract (address _contract) onlyVotingContract external {
485         //_internalMod = CaelumModifierAbstract(_contract);
486         _internalMod = InterfaceContracts(_contract);
487         setMasternodeContract();
488         setTokenContract();
489     }
490 
491     function mint(uint256 nonce, bytes32 challenge_digest) checkGasPrice(tx.gasprice) public returns(bool success) {
492         require(ACTIVE_STATE);
493 
494         _hash(nonce, challenge_digest);
495 
496         masternodeInterface._externalArrangeFlow();
497 
498         uint rewardAmount = _reward();
499         uint rewardMasternode = _reward_masternode();
500 
501         tokensMinted += rewardAmount.add(rewardMasternode);
502 
503         uint epochCounter = _newEpoch(nonce);
504 
505         _adjustDifficulty();
506 
507         statistics = Statistics(msg.sender, rewardAmount, block.number, now);
508 
509         emit Mint(msg.sender, rewardAmount, epochCounter, challengeNumber);
510 
511         return true;
512     }
513 
514     function _reward() internal returns(uint) {
515 
516         uint _pow = masternodeInterface.rewardsProofOfWork();
517 
518         tokenInterface.rewardExternal(msg.sender, 1 * 1e8);
519 
520         return _pow;
521     }
522 
523     function _reward_masternode() internal returns(uint) {
524 
525         uint _mnReward = masternodeInterface.rewardsMasternode();
526         if (masternodeInterface.masternodeIDcounter() == 0) return 0;
527 
528         address _mnCandidate = masternodeInterface.getUserFromID(masternodeInterface.masternodeCandidate()); // userByIndex[masternodeCandidate].accountOwner;
529         if (_mnCandidate == 0x0) return 0;
530 
531         tokenInterface.rewardExternal(_mnCandidate, _mnReward);
532 
533         emit RewardMasternode(_mnCandidate, _mnReward);
534 
535         return _mnReward;
536     }
537 
538     /**
539      * @dev Fetch data from the actual reward. We do this to prevent pools payout out
540      * the global reward instead of the calculated ones.
541      * By default, pools fetch the `getMiningReward()` value and will payout this amount.
542      */
543     function getMiningRewardForPool() public view returns(uint) {
544         return masternodeInterface.rewardsProofOfWork();
545     }
546 
547     function getMiningReward() public view returns(uint) {
548         return (baseMiningReward * 1e8).div(2 ** rewardEra);
549     }
550 
551     function contractProgress() public view returns
552         (
553             uint epoch,
554             uint candidate,
555             uint round,
556             uint miningepoch,
557             uint globalreward,
558             uint powreward,
559             uint masternodereward,
560             uint usercounter
561         ) {
562             return ICaelumMasternode(_contract_masternode()).contractProgress();
563 
564         }
565 
566     /**
567      * @dev Call this function prior to mining to copy all old contract values.
568      * This included minted tokens, difficulty, etc..
569      */
570 
571     function getDataFromContract(address _previous_contract) onlyOwner public {
572         require(ACTIVE_STATE == false);
573         require(_contract_token() != 0);
574         require(_contract_masternode() != 0);
575 
576         CaelumAbstractMiner prev = CaelumAbstractMiner(_previous_contract);
577         difficulty = prev.difficulty();
578         rewardEra = prev.rewardEra();
579         MINING_RATE_FACTOR = prev.MINING_RATE_FACTOR();
580         maxSupplyForEra = prev.maxSupplyForEra();
581         tokensMinted = prev.tokensMinted();
582         epochCount = prev.epochCount();
583 
584         ACTIVE_STATE = true;
585     }
586 }