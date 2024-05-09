1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC900/ERC900.sol
4 
5 /**
6  * @title ERC900 Simple Staking Interface
7  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
8  */
9 contract ERC900 {
10   event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
11   event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
12 
13   function stake(uint256 amount, bytes data) public;
14   function stakeFor(address user, uint256 amount, bytes data) public;
15   function unstake(uint256 amount, bytes data) public;
16   function totalStakedFor(address addr) public view returns (uint256);
17   function totalStaked() public view returns (uint256);
18   function token() public view returns (address);
19   function supportsHistory() public pure returns (bool);
20 
21   // NOTE: Not implementing the optional functions
22   // function lastStakedFor(address addr) public view returns (uint256);
23   // function totalStakedForAt(address addr, uint256 blockNumber) public view returns (uint256);
24   // function totalStakedAt(uint256 blockNumber) public view returns (uint256);
25 }
26 
27 // File: contracts/CodexStakeContractInterface.sol
28 
29 contract CodexStakeContractInterface is ERC900 {
30 
31   function stakeForDuration(
32     address user,
33     uint256 amount,
34     uint256 lockInDuration,
35     bytes data)
36     public;
37 
38   function spendCredits(
39     address user,
40     uint256 amount)
41     public;
42 
43   function creditBalanceOf(
44     address user)
45     public
46     view
47     returns (uint256);
48 }
49 
50 // File: contracts/library/Ownable.sol
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    * @notice Renouncing to ownership will leave the contract without an owner.
87    * It will not be possible to call the functions with the `onlyOwner`
88    * modifier anymore.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 // File: contracts/ERC20/ERC20Basic.sol
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   function totalSupply() public view returns (uint256);
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 // File: contracts/ERC20/ERC20.sol
129 
130 /**
131  * @title ERC20 interface
132  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 // File: contracts/library/SafeMath.sol
142 
143 /**
144  * @title SafeMath
145  * @dev Math operations with safety checks that throw on error
146  */
147 library SafeMath {
148 
149   /**
150   * @dev Multiplies two numbers, throws on overflow.
151   */
152   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
153     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
154     // benefit is lost if 'b' is also tested.
155     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
156     if (a == 0) {
157       return 0;
158     }
159 
160     c = a * b;
161     assert(c / a == b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     // uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return a / b;
173   }
174 
175   /**
176   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179     assert(b <= a);
180     return a - b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
187     c = a + b;
188     assert(c >= a);
189     return c;
190   }
191 }
192 
193 // File: contracts/ERC900/ERC900BasicStakeContract.sol
194 
195 /* solium-disable security/no-block-members */
196 pragma solidity 0.4.24;
197 
198 
199 
200 
201 
202 /**
203  * @title ERC900 Simple Staking Interface basic implementation
204  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
205  */
206 contract ERC900BasicStakeContract is ERC900 {
207   // @TODO: deploy this separately so we don't have to deploy it multiple times for each contract
208   using SafeMath for uint256;
209 
210   // Token used for staking
211   ERC20 stakingToken;
212 
213   // The default duration of stake lock-in (in seconds)
214   uint256 public defaultLockInDuration;
215 
216   // To save on gas, rather than create a separate mapping for totalStakedFor & personalStakes,
217   //  both data structures are stored in a single mapping for a given addresses.
218   //
219   // It's possible to have a non-existing personalStakes, but have tokens in totalStakedFor
220   //  if other users are staking on behalf of a given address.
221   mapping (address => StakeContract) public stakeHolders;
222 
223   // Struct for personal stakes (i.e., stakes made by this address)
224   // unlockedTimestamp - when the stake unlocks (in seconds since Unix epoch)
225   // actualAmount - the amount of tokens in the stake
226   // stakedFor - the address the stake was staked for
227   struct Stake {
228     uint256 unlockedTimestamp;
229     uint256 actualAmount;
230     address stakedFor;
231   }
232 
233   // Struct for all stake metadata at a particular address
234   // totalStakedFor - the number of tokens staked for this address
235   // personalStakeIndex - the index in the personalStakes array.
236   // personalStakes - append only array of stakes made by this address
237   // exists - whether or not there are stakes that involve this address
238   struct StakeContract {
239     uint256 totalStakedFor;
240 
241     uint256 personalStakeIndex;
242 
243     Stake[] personalStakes;
244 
245     bool exists;
246   }
247 
248   /**
249    * @dev Modifier that checks that this contract can transfer tokens from the
250    *  balance in the stakingToken contract for the given address.
251    * @dev This modifier also transfers the tokens.
252    * @param _address address to transfer tokens from
253    * @param _amount uint256 the number of tokens
254    */
255   modifier canStake(address _address, uint256 _amount) {
256     require(
257       stakingToken.transferFrom(_address, this, _amount),
258       "Stake required");
259 
260     _;
261   }
262 
263   /**
264    * @dev Constructor function
265    * @param _stakingToken ERC20 The address of the token contract used for staking
266    */
267   constructor(ERC20 _stakingToken) public {
268     stakingToken = _stakingToken;
269   }
270 
271   /**
272    * @dev Returns the timestamps for when active personal stakes for an address will unlock
273    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
274    * @param _address address that created the stakes
275    * @return uint256[] array of timestamps
276    */
277   function getPersonalStakeUnlockedTimestamps(address _address) external view returns (uint256[]) {
278     uint256[] memory timestamps;
279     (timestamps,,) = getPersonalStakes(_address);
280 
281     return timestamps;
282   }
283 
284   /**
285    * @dev Returns the stake actualAmount for active personal stakes for an address
286    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
287    * @param _address address that created the stakes
288    * @return uint256[] array of actualAmounts
289    */
290   function getPersonalStakeActualAmounts(address _address) external view returns (uint256[]) {
291     uint256[] memory actualAmounts;
292     (,actualAmounts,) = getPersonalStakes(_address);
293 
294     return actualAmounts;
295   }
296 
297   /**
298    * @dev Returns the addresses that each personal stake was created for by an address
299    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
300    * @param _address address that created the stakes
301    * @return address[] array of amounts
302    */
303   function getPersonalStakeForAddresses(address _address) external view returns (address[]) {
304     address[] memory stakedFor;
305     (,,stakedFor) = getPersonalStakes(_address);
306 
307     return stakedFor;
308   }
309 
310   /**
311    * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the user
312    * @notice MUST trigger Staked event
313    * @param _amount uint256 the amount of tokens to stake
314    * @param _data bytes optional data to include in the Stake event
315    */
316   function stake(uint256 _amount, bytes _data) public {
317     createStake(
318       msg.sender,
319       _amount,
320       defaultLockInDuration,
321       _data);
322   }
323 
324   /**
325    * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the caller
326    * @notice MUST trigger Staked event
327    * @param _user address the address the tokens are staked for
328    * @param _amount uint256 the amount of tokens to stake
329    * @param _data bytes optional data to include in the Stake event
330    */
331   function stakeFor(address _user, uint256 _amount, bytes _data) public {
332     createStake(
333       _user,
334       _amount,
335       defaultLockInDuration,
336       _data);
337   }
338 
339   /**
340    * @notice Unstakes a certain amount of tokens, this SHOULD return the given amount of tokens to the user, if unstaking is currently not possible the function MUST revert
341    * @notice MUST trigger Unstaked event
342    * @dev Unstaking tokens is an atomic operation—either all of the tokens in a stake, or none of the tokens.
343    * @dev Users can only unstake a single stake at a time, it is must be their oldest active stake. Upon releasing that stake, the tokens will be
344    *  transferred back to their account, and their personalStakeIndex will increment to the next active stake.
345    * @param _amount uint256 the amount of tokens to unstake
346    * @param _data bytes optional data to include in the Unstake event
347    */
348   function unstake(uint256 _amount, bytes _data) public {
349     withdrawStake(
350       _amount,
351       _data);
352   }
353 
354   /**
355    * @notice Returns the current total of tokens staked for an address
356    * @param _address address The address to query
357    * @return uint256 The number of tokens staked for the given address
358    */
359   function totalStakedFor(address _address) public view returns (uint256) {
360     return stakeHolders[_address].totalStakedFor;
361   }
362 
363   /**
364    * @notice Returns the current total of tokens staked
365    * @return uint256 The number of tokens staked in the contract
366    */
367   function totalStaked() public view returns (uint256) {
368     return stakingToken.balanceOf(this);
369   }
370 
371   /**
372    * @notice Address of the token being used by the staking interface
373    * @return address The address of the ERC20 token used for staking
374    */
375   function token() public view returns (address) {
376     return stakingToken;
377   }
378 
379   /**
380    * @notice MUST return true if the optional history functions are implemented, otherwise false
381    * @dev Since we don't implement the optional interface, this always returns false
382    * @return bool Whether or not the optional history functions are implemented
383    */
384   function supportsHistory() public pure returns (bool) {
385     return false;
386   }
387 
388   /**
389    * @dev Helper function to get specific properties of all of the personal stakes created by an address
390    * @param _address address The address to query
391    * @return (uint256[], uint256[], address[])
392    *  timestamps array, actualAmounts array, stakedFor array
393    */
394   function getPersonalStakes(
395     address _address
396   )
397     view
398     public
399     returns(uint256[], uint256[], address[])
400   {
401     StakeContract storage stakeContract = stakeHolders[_address];
402 
403     uint256 arraySize = stakeContract.personalStakes.length - stakeContract.personalStakeIndex;
404     uint256[] memory unlockedTimestamps = new uint256[](arraySize);
405     uint256[] memory actualAmounts = new uint256[](arraySize);
406     address[] memory stakedFor = new address[](arraySize);
407 
408     for (uint256 i = stakeContract.personalStakeIndex; i < stakeContract.personalStakes.length; i++) {
409       uint256 index = i - stakeContract.personalStakeIndex;
410       unlockedTimestamps[index] = stakeContract.personalStakes[i].unlockedTimestamp;
411       actualAmounts[index] = stakeContract.personalStakes[i].actualAmount;
412       stakedFor[index] = stakeContract.personalStakes[i].stakedFor;
413     }
414 
415     return (
416       unlockedTimestamps,
417       actualAmounts,
418       stakedFor
419     );
420   }
421 
422   /**
423    * @dev Helper function to create stakes for a given address
424    * @param _address address The address the stake is being created for
425    * @param _amount uint256 The number of tokens being staked
426    * @param _lockInDuration uint256 The duration to lock the tokens for
427    * @param _data bytes optional data to include in the Stake event
428    */
429   function createStake(
430     address _address,
431     uint256 _amount,
432     uint256 _lockInDuration,
433     bytes _data
434   )
435     internal
436     canStake(msg.sender, _amount)
437   {
438     if (!stakeHolders[msg.sender].exists) {
439       stakeHolders[msg.sender].exists = true;
440     }
441 
442     stakeHolders[_address].totalStakedFor = stakeHolders[_address].totalStakedFor.add(_amount);
443     stakeHolders[msg.sender].personalStakes.push(
444       Stake(
445         block.timestamp.add(_lockInDuration),
446         _amount,
447         _address)
448       );
449 
450     emit Staked(
451       _address,
452       _amount,
453       totalStakedFor(_address),
454       _data);
455   }
456 
457   /**
458    * @dev Helper function to withdraw stakes for the msg.sender
459    * @param _amount uint256 The amount to withdraw. MUST match the stake amount for the
460    *  stake at personalStakeIndex.
461    * @param _data bytes optional data to include in the Unstake event
462    */
463   function withdrawStake(
464     uint256 _amount,
465     bytes _data
466   )
467     internal
468   {
469     Stake storage personalStake = stakeHolders[msg.sender].personalStakes[stakeHolders[msg.sender].personalStakeIndex];
470 
471     // Check that the current stake has unlocked & matches the unstake amount
472     require(
473       personalStake.unlockedTimestamp <= block.timestamp,
474       "The current stake hasn't unlocked yet");
475 
476     require(
477       personalStake.actualAmount == _amount,
478       "The unstake amount does not match the current stake");
479 
480     // Transfer the staked tokens from this contract back to the sender
481     // Notice that we are using transfer instead of transferFrom here, so
482     //  no approval is needed beforehand.
483     require(
484       stakingToken.transfer(msg.sender, _amount),
485       "Unable to withdraw stake");
486 
487     stakeHolders[personalStake.stakedFor].totalStakedFor = stakeHolders[personalStake.stakedFor]
488       .totalStakedFor.sub(personalStake.actualAmount);
489 
490     personalStake.actualAmount = 0;
491     stakeHolders[msg.sender].personalStakeIndex++;
492 
493     emit Unstaked(
494       personalStake.stakedFor,
495       _amount,
496       totalStakedFor(personalStake.stakedFor),
497       _data);
498   }
499 }
500 
501 // File: contracts/ERC900/ERC900CreditsStakeContract.sol
502 
503 /**
504  * @title ERC900 Credits-based staking implementation
505  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
506  *
507  * Notice that credits aren't lost when tokens are unstaked--only when credits are spent.
508  * This means that after the initial lock in duration expires, a user can re-stake those tokens
509  *  for more credits.
510  * Another important note: spendCredits can only be called by the contract's owner. This
511  *  is meant to be another smart contract. For example, the smart contract can offer call
512  *  spendCredits to reduce a user's credit balance in place of spending real tokens.
513  */
514 contract ERC900CreditsStakeContract is ERC900BasicStakeContract, Ownable {
515 
516   // NOTE: Credits do not have decimal places
517   // Users cannot own fractional credits
518   mapping (address => uint256) public creditBalances;
519 
520   /**
521    * @dev Returns the balance of credits at a user's address.
522    * @param _user address The address to check.
523    * @return uint256 The credit balance.
524    */
525   function creditBalanceOf(
526     address _user
527   )
528     public
529     view
530     returns (uint256)
531   {
532     return creditBalances[_user];
533   }
534 
535   /**
536    * @dev Spends credits for a user. Only callable by the owner. Reverts if the
537    *  user doesn't have enough credits.
538    * @param _user address The address that owns the credits being spent.
539    * @param _amount uint256 The number of credits to spend.
540    */
541   function spendCredits(
542     address _user,
543     uint256 _amount
544   )
545     public
546     onlyOwner
547   {
548     require(
549       creditBalances[_user] >= _amount,
550       "Insufficient balance");
551 
552     creditBalances[_user] = creditBalances[_user].sub(_amount);
553   }
554 
555   /**
556    * @dev Stakes tokens for the caller and rewards them with credits. Reverts
557    *  if less than 1 token is being staked.
558    * @param _amount uint256 The number of tokens to stake
559    * @param _data bytes optional data to include in the Stake event
560    */
561   function stake(
562     uint256 _amount,
563     bytes _data
564   )
565     public
566   {
567     super.stake(
568       _amount,
569       _data);
570 
571     updateCreditBalance(
572       msg.sender,
573       _amount,
574       defaultLockInDuration);
575   }
576 
577   /**
578    * Stakes tokens from the caller for a particular user, and rewards that user with credits.
579    * Reverts if less than 1 token is being staked.
580    * @param _user address The address the tokens are staked for
581    * @param _amount uint256 The number of tokens to stake
582    * @param _data bytes optional data to include in the Stake event
583    */
584   function stakeFor(
585     address _user,
586     uint256 _amount,
587     bytes _data
588   )
589     public
590   {
591     super.stakeFor(
592       _user,
593       _amount,
594       _data);
595 
596     updateCreditBalance(
597       _user,
598       _amount,
599       defaultLockInDuration);
600   }
601 
602   /**
603    * @dev Stakes tokens from the caller for a given user & duration, and rewards that user with credits.
604    * Reverts if less than 1 token is being staked, or if the duration specified is less than the default.
605    * @param _user address The address the tokens are staked for
606    * @param _amount uint256 The number of tokens to stake
607    * @param _lockInDuration uint256 The duration (in seconds) that the stake should be locked for
608    * @param _data bytes optional data to be included in the Stake event
609    */
610   function stakeForDuration(
611     address _user,
612     uint256 _amount,
613     uint256 _lockInDuration,
614     bytes _data
615   )
616     public
617   {
618     require(
619       _lockInDuration >= defaultLockInDuration,
620       "Insufficient stake duration");
621 
622     super.createStake(
623       _user,
624       _amount,
625       _lockInDuration,
626       _data);
627 
628     updateCreditBalance(
629       _user,
630       _amount,
631       _lockInDuration);
632   }
633 
634   /**
635    * @dev Internal function to update the credit balance of a user when staking tokens.
636    *  Users are rewarded with more tokens the longer they stake for.
637    * @param _user address The address to award credits to
638    * @param _amount uint256 The number of tokens being staked
639    * @param _lockInDuration uint256 The duration (in seconds) that the stake should be locked for
640    */
641   function updateCreditBalance(
642     address _user,
643     uint256 _amount,
644     uint256 _lockInDuration
645   )
646     internal
647   {
648     uint256 divisor = 1 ether;
649 
650     require(
651       _amount >= divisor,
652       "Insufficient amount");
653 
654     // NOTE: Truncation is intentional here
655     // If a user stakes for less than the minimum duration, they are awarded with 0 credits
656     // If they stake 2x the minimum duration, they are awarded with 2x credits
657     // etc.
658     uint256 rewardMultiplier = _lockInDuration / defaultLockInDuration;
659 
660     uint256 creditsAwarded = _amount.mul(rewardMultiplier).div(divisor);
661     creditBalances[_user] = creditBalances[_user].add(creditsAwarded);
662   }
663 }
664 
665 // File: contracts/CodexStakeContract.sol
666 
667 /**
668  * @title CodexStakeContract
669  */
670 contract CodexStakeContract is CodexStakeContractInterface, ERC900CreditsStakeContract {
671 
672   /**
673    * @dev Constructor function
674    * @param _stakingToken ERC20 The address of the token used for staking
675    * @param _defaultLockInDuration uint256 The duration (in seconds) that stakes are required to be locked for
676    */
677   constructor(
678     ERC20 _stakingToken,
679     uint256 _defaultLockInDuration
680   )
681     public
682     ERC900BasicStakeContract(_stakingToken)
683   {
684     defaultLockInDuration = _defaultLockInDuration;
685   }
686 
687   /**
688    * @dev Sets the lockInDuration for stakes. Only callable by the owner
689    * @param _defaultLockInDuration uint256 The duration (in seconds) that stakes are required to be locked for
690    */
691   function setDefaultLockInDuration(
692     uint256 _defaultLockInDuration
693   )
694     external
695     onlyOwner
696   {
697     defaultLockInDuration = _defaultLockInDuration;
698   }
699 }