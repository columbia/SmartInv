1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ReentrancyGuard {
30 
31   /**
32    * @dev We use a single lock for the whole contract. 
33    */
34   bool private rentrancy_lock = false;
35 
36   /**
37    * @dev Prevents a contract from calling itself, directly or indirectly.
38    * @notice If you mark a function `nonReentrant`, you should also
39    * mark it `external`. Calling one nonReentrant function from
40    * another is not supported. Instead, you can implement a
41    * `private` function doing the actual work, and a `external`
42    * wrapper marked as `nonReentrant`.
43    */
44   modifier nonReentrant() {
45     require(!rentrancy_lock);
46     rentrancy_lock = true;
47     _;
48     rentrancy_lock = false;
49   }
50 
51 }
52 
53 
54 contract ERC20Basic {
55   uint256 public totalSupply;
56   function balanceOf(address who) constant returns (uint256);
57   function transfer(address to, uint256 value);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender) constant returns (uint256);
64   function transferFrom(address from, address to, uint256 value);
65   function approve(address spender, uint256 value);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) {
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of. 
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // if (_value > _allowance) throw;
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     if (_value != 0) require(allowed[msg.sender][_spender] == 0);
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 contract Transmutable {
150   function transmute(address to, uint256 value) returns (bool, uint256);
151   event Transmuted(address indexed who, address baseContract, address transmutedContract, uint256 sourceQuantity, uint256 destQuantity);
152 }
153 
154 // Contracts that can be transmuted to should implement this
155 contract TransmutableInterface {
156   function transmuted(uint256 _value) returns (bool, uint256);
157 }
158 
159 
160 
161 contract ERC20Mineable is StandardToken, ReentrancyGuard  {
162 
163    uint256 public constant divisible_units = 10000000;
164    uint256 public constant decimals = 8;
165 
166    uint256 public constant initial_reward = 100;
167 
168    /** totalSupply in StandardToken refers to currently available supply
169    * maximumSupply refers to the cap on mining.
170    * When mining is finished totalSupply == maximumSupply
171    */
172    uint256 public maximumSupply;
173 
174    // Current mining difficulty in Wei
175    uint256 public currentDifficultyWei;
176 
177    // Minimum difficulty
178    uint256 public minimumDifficultyThresholdWei;
179 
180    /** Block creation rate as number of Ethereum blocks per mining cycle
181    * 10 minutes at 12 seconds a block would be an internal block
182    * generated every 50 Ethereum blocks
183    */
184    uint256 public blockCreationRate;
185 
186    /* difficultyAdjustmentPeriod should be every two weeks, or
187    * 2016 internal blocks.
188    */
189    uint256 public difficultyAdjustmentPeriod;
190 
191    /* When was the last time we did a difficulty adjustment.
192    * In case mining ceases for indeterminate duration
193    */
194    uint256 public lastDifficultyAdjustmentEthereumBlock;
195 
196    // Scale multiplier limit for difficulty adjustment
197    uint256 public constant difficultyScaleMultiplierLimit = 4;
198 
199    // Total blocks mined helps us calculate the current reward
200    uint256 public totalBlocksMined;
201 
202    // Reward adjustment period in Bitcoineum native blocks
203 
204    uint256 public rewardAdjustmentPeriod; 
205 
206    // Total amount of Wei put into mining during current period
207    uint256 public totalWeiCommitted;
208    // Total amount of Wei expected for this mining period
209    uint256 public totalWeiExpected;
210 
211    // Where to burn Ether
212    address public burnAddress;
213 
214    /** Each block is created on a mining attempt if
215    * it does not already exist.
216    * this keeps track of the target difficulty at the time of creation
217    */
218 
219    struct InternalBlock {
220       uint256 targetDifficultyWei;
221       uint256 blockNumber;
222       uint256 totalMiningWei;
223       uint256 totalMiningAttempts;
224       uint256 currentAttemptOffset;
225       bool payed;
226       address payee;
227       bool isCreated;
228    }
229 
230    /** Mining attempts are given a projected offset to minimize
231    * keyspace overlap to increase fairness by reducing the redemption
232    * race condition
233    * This does not remove the possibility that two or more miners will
234    * be competing for the same award, especially if subsequent increases in
235    * wei from a single miner increase overlap
236    */
237    struct MiningAttempt {
238       uint256 projectedOffset;
239       uint256 value;
240       bool isCreated;
241    }
242 
243    // Each guess gets assigned to a block
244    mapping (uint256 => InternalBlock) public blockData;
245    mapping (uint256 => mapping (address => MiningAttempt)) public miningAttempts;
246 
247    // Utility related
248 
249    function resolve_block_hash(uint256 _blockNum) public constant returns (bytes32) {
250        return block.blockhash(_blockNum);
251    }
252 
253    function current_external_block() public constant returns (uint256) {
254        return block.number;
255    }
256 
257    function external_to_internal_block_number(uint256 _externalBlockNum) public constant returns (uint256) {
258       // blockCreationRate is > 0
259       return _externalBlockNum / blockCreationRate;
260    }
261 
262    // For the test harness verification
263    function get_internal_block_number() public constant returns (uint256) {
264      return external_to_internal_block_number(current_external_block());
265    }
266 
267    // Initial state related
268    /** Dapps need to grab the initial state of the contract
269    * in order to properly initialize mining or tracking
270    * this is a single atomic function for getting state
271    * rather than scattering it across multiple public calls
272    * also returns the current blocks parameters
273    * or default params if it hasn't been created yet
274    * This is only called externally
275    */
276 
277    function getContractState() external constant
278      returns (uint256,  // currentDifficultyWei
279               uint256,  // minimumDifficultyThresholdWei
280               uint256,  // blockNumber
281               uint256,  // blockCreationRate
282               uint256,  // difficultyAdjustmentPeriod
283               uint256,  // rewardAdjustmentPeriod
284               uint256,  // lastDifficultyAdustmentEthereumBlock
285               uint256,  // totalBlocksMined
286               uint256,  // totalWeiCommitted
287               uint256,  // totalWeiExpected
288               uint256,  // b.targetDifficultyWei
289               uint256,  // b.totalMiningWei
290               uint256  // b.currentAttemptOffset
291               ) {
292     InternalBlock memory b;
293     uint256 _blockNumber = external_to_internal_block_number(current_external_block());
294     if (!blockData[_blockNumber].isCreated) {
295         b = InternalBlock(
296                        {targetDifficultyWei: currentDifficultyWei,
297                        blockNumber: _blockNumber,
298                        totalMiningWei: 0,
299                        totalMiningAttempts: 0,
300                        currentAttemptOffset: 0,
301                        payed: false,
302                        payee: 0,
303                        isCreated: true
304                        });
305     } else {
306          b = blockData[_blockNumber];
307     }
308     return (currentDifficultyWei,
309             minimumDifficultyThresholdWei,
310             _blockNumber,
311             blockCreationRate,
312             difficultyAdjustmentPeriod,
313             rewardAdjustmentPeriod,
314             lastDifficultyAdjustmentEthereumBlock,
315             totalBlocksMined,
316             totalWeiCommitted,
317             totalWeiExpected,
318             b.targetDifficultyWei,
319             b.totalMiningWei,
320             b.currentAttemptOffset);
321    }
322 
323    function getBlockData(uint256 _blockNum) public constant returns (uint256, uint256, uint256, uint256, uint256, bool, address, bool) {
324     InternalBlock memory iBlock = blockData[_blockNum];
325     return (iBlock.targetDifficultyWei,
326     iBlock.blockNumber,
327     iBlock.totalMiningWei,
328     iBlock.totalMiningAttempts,
329     iBlock.currentAttemptOffset,
330     iBlock.payed,
331     iBlock.payee,
332     iBlock.isCreated);
333    }
334 
335    function getMiningAttempt(uint256 _blockNum, address _who) public constant returns (uint256, uint256, bool) {
336      if (miningAttempts[_blockNum][_who].isCreated) {
337         return (miningAttempts[_blockNum][_who].projectedOffset,
338         miningAttempts[_blockNum][_who].value,
339         miningAttempts[_blockNum][_who].isCreated);
340      } else {
341         return (0, 0, false);
342      }
343    }
344 
345    // Mining Related
346 
347    modifier blockCreated(uint256 _blockNum) {
348      require(blockData[_blockNum].isCreated);
349      _;
350    }
351 
352    modifier blockRedeemed(uint256 _blockNum) {
353      require(_blockNum != current_external_block());
354      /* Should capture if the blockdata is payed
355      *  or if it does not exist in the blockData mapping
356      */
357      require(blockData[_blockNum].isCreated);
358      require(!blockData[_blockNum].payed);
359      _;
360    }
361 
362    modifier initBlock(uint256 _blockNum) {
363      require(_blockNum != current_external_block());
364 
365      if (!blockData[_blockNum].isCreated) {
366        // This is a new block, adjust difficulty
367        adjust_difficulty();
368 
369        // Create new block for tracking
370        blockData[_blockNum] = InternalBlock(
371                                      {targetDifficultyWei: currentDifficultyWei,
372                                       blockNumber: _blockNum,
373                                       totalMiningWei: 0,
374                                       totalMiningAttempts: 0,
375                                       currentAttemptOffset: 0,
376                                       payed: false,
377                                       payee: 0,
378                                       isCreated: true
379                                       });
380      }
381      _;
382    }
383 
384    modifier isValidAttempt() {
385      /* If the Ether for this mining attempt is less than minimum
386      * 0.0000001 % of total difficulty
387      */
388      uint256 minimum_wei = currentDifficultyWei / divisible_units; 
389      require (msg.value >= minimum_wei);
390 
391      /* Let's bound the value to guard against potential overflow
392      * i.e max int, or an underflow bug
393      * This is a single attempt
394      */
395      require(msg.value <= (1000000 ether));
396      _;
397    }
398 
399    modifier alreadyMined(uint256 blockNumber, address sender) {
400      require(blockNumber != current_external_block()); 
401     /* We are only going to allow one mining attempt per block per account
402     *  This prevents stuffing and make it easier for us to track boundaries
403     */
404     
405     // This user already made a mining attempt for this block
406     require(!checkMiningAttempt(blockNumber, sender));
407     _;
408    }
409 
410    function checkMiningActive() public constant returns (bool) {
411       return (totalSupply < maximumSupply);
412    }
413 
414    modifier isMiningActive() {
415       require(checkMiningActive());
416       _;
417    }
418 
419    function burn(uint256 value) internal {
420       /* We don't really care if the burn fails for some
421       *  weird reason.
422       */
423       bool ret = burnAddress.send(value);
424       /* If we cannot burn this ether, than the contract might
425       *  be under some kind of stack attack.
426       *  Even though it shouldn't matter, let's err on the side of
427       *  caution and throw in case there is some invalid state.
428       */
429       require (ret);
430    }
431 
432    event MiningAttemptEvent(
433        address indexed _from,
434        uint256 _value,
435        uint256 indexed _blockNumber,
436        uint256 _totalMinedWei,
437        uint256 _targetDifficultyWei
438    );
439 
440    event LogEvent(
441        string _info
442    );
443 
444    /**
445    * @dev Add a mining attempt for the current internal block
446    * Initialize an empty block if not created
447    * Invalidate this mining attempt if the block has been paid out
448    */
449 
450    function mine() external payable 
451                            nonReentrant
452                            isValidAttempt
453                            isMiningActive
454                            initBlock(external_to_internal_block_number(current_external_block()))
455                            blockRedeemed(external_to_internal_block_number(current_external_block()))
456                            alreadyMined(external_to_internal_block_number(current_external_block()), msg.sender) returns (bool) {
457       /* Let's immediately adjust the difficulty
458       *  In case an abnormal period of time has elapsed
459       *  nobody has been mining etc.
460       *  Will let us recover the network even if the
461       * difficulty spikes to some absurd amount
462       * this should only happen on the first attempt on a block
463       */
464       uint256 internalBlockNum = external_to_internal_block_number(current_external_block());
465       miningAttempts[internalBlockNum][msg.sender] =
466                      MiningAttempt({projectedOffset: blockData[internalBlockNum].currentAttemptOffset,
467                                     value: msg.value,
468                                     isCreated: true});
469 
470       // Increment the mining attempts for this block
471       blockData[internalBlockNum].totalMiningAttempts += 1;
472       blockData[internalBlockNum].totalMiningWei += msg.value;
473       totalWeiCommitted += msg.value;
474 
475       /* We are trying to stack mining attempts into their relative
476       *  positions in the key space.
477       */
478       blockData[internalBlockNum].currentAttemptOffset += msg.value;
479       MiningAttemptEvent(msg.sender,
480                          msg.value,
481                          internalBlockNum,
482                          blockData[internalBlockNum].totalMiningWei,
483                          blockData[internalBlockNum].targetDifficultyWei
484                          );
485       // All mining attempt Ether is burned
486       burn(msg.value);
487       return true;
488    }
489 
490    // Redemption Related
491 
492    modifier userMineAttempted(uint256 _blockNum, address _user) {
493       require(checkMiningAttempt(_blockNum, _user));
494       _;
495    }
496    
497    modifier isBlockMature(uint256 _blockNumber) {
498       require(_blockNumber != current_external_block());
499       require(checkBlockMature(_blockNumber, current_external_block()));
500       require(checkRedemptionWindow(_blockNumber, current_external_block()));
501       _;
502    }
503 
504    // Just in case this block falls outside of the available
505    // block range, possibly because of a change in network params
506    modifier isBlockReadable(uint256 _blockNumber) {
507       InternalBlock memory iBlock = blockData[_blockNumber];
508       uint256 targetBlockNum = targetBlockNumber(_blockNumber);
509       require(resolve_block_hash(targetBlockNum) != 0);
510       _;
511    }
512 
513    function calculate_difficulty_attempt(uint256 targetDifficultyWei,
514                                          uint256 totalMiningWei,
515                                          uint256 value) public constant returns (uint256) {
516       // The total amount of Wei sent for this mining attempt exceeds the difficulty level
517       // So the calculation of percentage keyspace should be done on the total wei.
518       uint256 selectedDifficultyWei = 0;
519       if (totalMiningWei > targetDifficultyWei) {
520          selectedDifficultyWei = totalMiningWei;
521       } else {
522          selectedDifficultyWei = targetDifficultyWei; 
523       }
524 
525       /* normalize the value against the entire key space
526        * Multiply it out because we do not have floating point
527        * 10000000 is .0000001 % increments
528       */
529 
530       uint256 intermediate = ((value * divisible_units) / selectedDifficultyWei);
531       uint256 max_int = 0;
532       // Underflow to maxint
533       max_int = max_int - 1;
534 
535       if (intermediate >= divisible_units) {
536          return max_int;
537       } else {
538          return intermediate * (max_int / divisible_units);
539       }
540    }
541 
542    function calculate_range_attempt(uint256 difficulty, uint256 offset) public constant returns (uint256, uint256) {
543        /* Both the difficulty and offset should be normalized
544        * against the difficulty scale.
545        * If they are not we might have an integer overflow
546        */
547        require(offset + difficulty >= offset);
548        return (offset, offset+difficulty);
549    }
550 
551    // Total allocated reward is proportional to burn contribution to limit incentive for
552    // hash grinding attacks
553    function calculate_proportional_reward(uint256 _baseReward, uint256 _userContributionWei, uint256 _totalCommittedWei) public constant returns (uint256) {
554    require(_userContributionWei <= _totalCommittedWei);
555    require(_userContributionWei > 0);
556    require(_totalCommittedWei > 0);
557       uint256 intermediate = ((_userContributionWei * divisible_units) / _totalCommittedWei);
558 
559       if (intermediate >= divisible_units) {
560          return _baseReward;
561       } else {
562          return intermediate * (_baseReward / divisible_units);
563       }
564    }
565 
566    function calculate_base_mining_reward(uint256 _totalBlocksMined) public constant returns (uint256) {
567       /* Block rewards starts at initial_reward
568       *  Every 10 minutes
569       *  Block reward decreases by 50% every 210000 blocks
570       */
571       uint256 mined_block_period = 0;
572       if (_totalBlocksMined < 210000) {
573            mined_block_period = 210000;
574       } else {
575            mined_block_period = _totalBlocksMined;
576       }
577 
578       // Again we have to do this iteratively because of floating
579       // point limitations in solidity.
580       uint256 total_reward = initial_reward * (10 ** decimals); 
581       uint256 i = 1;
582       uint256 rewardperiods = mined_block_period / 210000;
583       if (mined_block_period % 210000 > 0) {
584          rewardperiods += 1;
585       }
586       for (i=1; i < rewardperiods; i++) {
587           total_reward = total_reward / 2;
588       }
589       return total_reward;
590    }
591 
592    // Break out the expected wei calculation
593    // for easy external testing
594    function calculate_next_expected_wei(uint256 _totalWeiCommitted,
595                                         uint256 _totalWeiExpected,
596                                         uint256 _minimumDifficultyThresholdWei,
597                                         uint256 _difficultyScaleMultiplierLimit) public constant
598                                         returns (uint256) {
599           
600           /* The adjustment window has been fulfilled
601           *  The new difficulty should be bounded by the total wei actually spent
602           * capped at difficultyScaleMultiplierLimit times
603           */
604           uint256 lowerBound = _totalWeiExpected / _difficultyScaleMultiplierLimit;
605           uint256 upperBound = _totalWeiExpected * _difficultyScaleMultiplierLimit;
606 
607           if (_totalWeiCommitted < lowerBound) {
608               _totalWeiExpected = lowerBound;
609           } else if (_totalWeiCommitted > upperBound) {
610               _totalWeiExpected = upperBound;
611           } else {
612               _totalWeiExpected = _totalWeiCommitted;
613           }
614 
615           /* If difficulty drops too low lets set it to our minimum.
616           *  This may halt coin creation, but obviously does not affect
617           *  token transactions.
618           */
619           if (_totalWeiExpected < _minimumDifficultyThresholdWei) {
620               _totalWeiExpected = _minimumDifficultyThresholdWei;
621           }
622 
623           return _totalWeiExpected;
624     }
625 
626    function adjust_difficulty() internal {
627       /* Total blocks mined might not be increasing if the 
628       *  difficulty is too high. So we should instead base the adjustment
629       * on the progression of the Ethereum network.
630       * So that the difficulty can increase/deflate regardless of sparse
631       * mining attempts
632       */
633 
634       if ((current_external_block() - lastDifficultyAdjustmentEthereumBlock) > (difficultyAdjustmentPeriod * blockCreationRate)) {
635 
636           // Get the new total wei expected via static function
637           totalWeiExpected = calculate_next_expected_wei(totalWeiCommitted, totalWeiExpected, minimumDifficultyThresholdWei * difficultyAdjustmentPeriod, difficultyScaleMultiplierLimit);
638 
639           currentDifficultyWei = totalWeiExpected / difficultyAdjustmentPeriod;
640 
641           // Regardless of difficulty adjustment, let us zero totalWeiCommited
642           totalWeiCommitted = 0;
643 
644           // Lets reset the difficulty adjustment block target
645           lastDifficultyAdjustmentEthereumBlock = current_external_block();
646 
647       }
648    }
649 
650    event BlockClaimedEvent(
651        address indexed _from,
652        address indexed _forCreditTo,
653        uint256 _reward,
654        uint256 indexed _blockNumber
655    );
656 
657    modifier onlyWinner(uint256 _blockNumber) {
658       require(checkWinning(_blockNumber));
659       _;
660    }
661 
662 
663    // Helper function to avoid stack issues
664    function calculate_reward(uint256 _totalBlocksMined, address _sender, uint256 _blockNumber) public constant returns (uint256) {
665       return calculate_proportional_reward(calculate_base_mining_reward(_totalBlocksMined), miningAttempts[_blockNumber][_sender].value, blockData[_blockNumber].totalMiningWei); 
666    }
667 
668    /** 
669    * @dev Claim the mining reward for a given block
670    * @param _blockNumber The internal block that the user is trying to claim
671    * @param forCreditTo When the miner account is different from the account
672    * where we want to deliver the redeemed Bitcoineum. I.e Hard wallet.
673    */
674    function claim(uint256 _blockNumber, address forCreditTo)
675                   nonReentrant
676                   blockRedeemed(_blockNumber)
677                   isBlockMature(_blockNumber)
678                   isBlockReadable(_blockNumber)
679                   userMineAttempted(_blockNumber, msg.sender)
680                   onlyWinner(_blockNumber)
681                   external returns (bool) {
682       /* If attempt is valid, invalidate redemption
683       *  Difficulty is adjusted here
684       *  and on bidding, in case bidding stalls out for some
685       *  unusual period of time.
686       *  Do everything, then adjust supply and balance
687       */
688       blockData[_blockNumber].payed = true;
689       blockData[_blockNumber].payee = msg.sender;
690       totalBlocksMined = totalBlocksMined + 1;
691 
692       uint256 proportional_reward = calculate_reward(totalBlocksMined, msg.sender, _blockNumber);
693       balances[forCreditTo] = balances[forCreditTo].add(proportional_reward);
694       totalSupply += proportional_reward;
695       BlockClaimedEvent(msg.sender, forCreditTo,
696                         proportional_reward,
697                         _blockNumber);
698       // Mining rewards should show up as ERC20 transfer events
699       // So that ERC20 scanners will see token creation.
700       Transfer(this, forCreditTo, proportional_reward);
701       return true;
702    }
703 
704    /** 
705    * @dev Claim the mining reward for a given block
706    * @param _blockNum The internal block that the user is trying to claim
707    */
708    function isBlockRedeemed(uint256 _blockNum) constant public returns (bool) {
709      if (!blockData[_blockNum].isCreated) {
710          return false;
711      } else {
712          return blockData[_blockNum].payed;
713      }
714    }
715 
716    /** 
717    * @dev Get the target block in the winning equation 
718    * @param _blockNum is the internal block number to get the target block for
719    */
720    function targetBlockNumber(uint256 _blockNum) constant public returns (uint256) {
721       return ((_blockNum + 1) * blockCreationRate);
722    }
723 
724    /** 
725    * @dev Check whether a given block is mature 
726    * @param _blockNum is the internal block number to check 
727    */
728    function checkBlockMature(uint256 _blockNum, uint256 _externalblock) constant public returns (bool) {
729      return (_externalblock >= targetBlockNumber(_blockNum));
730    }
731 
732    /**
733    * @dev Check the redemption window for a given block
734    * @param _blockNum is the internal block number to check
735    */
736 
737    function checkRedemptionWindow(uint256 _blockNum, uint256 _externalblock) constant public returns (bool) {
738        uint256 _targetblock = targetBlockNumber(_blockNum);
739        return _externalblock >= _targetblock && _externalblock < (_targetblock + 256);
740    }
741 
742    /** 
743    * @dev Check whether a mining attempt was made by sender for this block
744    * @param _blockNum is the internal block number to check
745    */
746    function checkMiningAttempt(uint256 _blockNum, address _sender) constant public returns (bool) {
747        return miningAttempts[_blockNum][_sender].isCreated;
748    }
749 
750    /** 
751    * @dev Did the user win a specific block and can claim it?
752    * @param _blockNum is the internal block number to check
753    */
754    function checkWinning(uint256 _blockNum) constant public returns (bool) {
755      if (checkMiningAttempt(_blockNum, msg.sender) && checkBlockMature(_blockNum, current_external_block())) {
756 
757       InternalBlock memory iBlock = blockData[_blockNum];
758       uint256 targetBlockNum = targetBlockNumber(iBlock.blockNumber);
759       MiningAttempt memory attempt = miningAttempts[_blockNum][msg.sender];
760 
761       uint256 difficultyAttempt = calculate_difficulty_attempt(iBlock.targetDifficultyWei, iBlock.totalMiningWei, attempt.value);
762       uint256 beginRange;
763       uint256 endRange;
764       uint256 targetBlockHashInt;
765 
766       (beginRange, endRange) = calculate_range_attempt(difficultyAttempt,
767           calculate_difficulty_attempt(iBlock.targetDifficultyWei, iBlock.totalMiningWei, attempt.projectedOffset)); 
768       targetBlockHashInt = uint256(keccak256(resolve_block_hash(targetBlockNum)));
769    
770       // This is the winning condition
771       if ((beginRange < targetBlockHashInt) && (endRange >= targetBlockHashInt))
772       {
773         return true;
774       }
775      
776      }
777 
778      return false;
779      
780    }
781 
782 }
783 
784 
785 
786 contract Bitcoineum is ERC20Mineable, Transmutable {
787 
788  string public constant name = "Bitcoineum";
789  string public constant symbol = "BTE";
790  uint256 public constant decimals = 8;
791  uint256 public constant INITIAL_SUPPLY = 0;
792 
793  // 21 Million coins at 8 decimal places
794  uint256 public constant MAX_SUPPLY = 21000000 * (10**8);
795  
796  function Bitcoineum() {
797 
798     totalSupply = INITIAL_SUPPLY;
799     maximumSupply = MAX_SUPPLY;
800 
801     // 0.0001 Ether per block
802     // Difficulty is so low because it doesn't include
803     // gas prices for execution
804     currentDifficultyWei = 100 szabo;
805     minimumDifficultyThresholdWei = 100 szabo;
806     
807     // Ethereum blocks to internal blocks
808     // Roughly 10 minute windows
809     blockCreationRate = 50;
810 
811     // Adjust difficulty x claimed internal blocks
812     difficultyAdjustmentPeriod = 2016;
813 
814     // Reward adjustment
815 
816     rewardAdjustmentPeriod = 210000;
817 
818     // This is the effective block counter, since block windows are discontinuous
819     totalBlocksMined = 0;
820 
821     totalWeiExpected = difficultyAdjustmentPeriod * currentDifficultyWei;
822 
823     // Balance of this address can be used to determine total burned value
824     // not including fees spent.
825     burnAddress = 0xdeaDDeADDEaDdeaDdEAddEADDEAdDeadDEADDEaD;
826 
827     lastDifficultyAdjustmentEthereumBlock = block.number; 
828  }
829 
830 
831    /**
832    * @dev Bitcoineum can extend proof of burn into convertable units
833    * that have token specific properties
834    * @param to is the address of the contract that Bitcoineum is converting into
835    * @param value is the quantity of Bitcoineum to attempt to convert
836    */
837 
838   function transmute(address to, uint256 value) nonReentrant returns (bool, uint256) {
839     require(value > 0);
840     require(balances[msg.sender] >= value);
841     require(totalSupply >= value);
842     balances[msg.sender] = balances[msg.sender].sub(value);
843     totalSupply = totalSupply.sub(value);
844     TransmutableInterface target = TransmutableInterface(to);
845     bool _result = false;
846     uint256 _total = 0;
847     (_result, _total) = target.transmuted(value);
848     require (_result);
849     Transmuted(msg.sender, this, to, value, _total);
850     return (_result, _total);
851   }
852 
853  }