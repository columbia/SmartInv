1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-12-11
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-12-10
11 */
12 
13 pragma solidity 0.6.12;
14 
15 // SPDX-License-Identifier: No License
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @dev Library for managing
49  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
50  * types.
51  *
52  * Sets have the following properties:
53  *
54  * - Elements are added, removed, and checked for existence in constant time
55  * (O(1)).
56  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
57  *
58  * ```
59  * contract Example {
60  *     // Add the library methods
61  *     using EnumerableSet for EnumerableSet.AddressSet;
62  *
63  *     // Declare a set state variable
64  *     EnumerableSet.AddressSet private mySet;
65  * }
66  * ```
67  *
68  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
69  * (`UintSet`) are supported.
70  */
71 library EnumerableSet {
72     // To implement this library for multiple types with as little code
73     // repetition as possible, we write it in terms of a generic Set type with
74     // bytes32 values.
75     // The Set implementation uses private functions, and user-facing
76     // implementations (such as AddressSet) are just wrappers around the
77     // underlying Set.
78     // This means that we can only create new EnumerableSets for types that fit
79     // in bytes32.
80 
81     struct Set {
82         // Storage of set values
83         bytes32[] _values;
84 
85         // Position of the value in the `values` array, plus 1 because index 0
86         // means a value is not in the set.
87         mapping (bytes32 => uint256) _indexes;
88     }
89 
90     /**
91      * @dev Add a value to a set. O(1).
92      *
93      * Returns true if the value was added to the set, that is if it was not
94      * already present.
95      */
96     function _add(Set storage set, bytes32 value) private returns (bool) {
97         if (!_contains(set, value)) {
98             set._values.push(value);
99             // The value is stored at length-1, but we add 1 to all indexes
100             // and use 0 as a sentinel value
101             set._indexes[value] = set._values.length;
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Removes a value from a set. O(1).
110      *
111      * Returns true if the value was removed from the set, that is if it was
112      * present.
113      */
114     function _remove(Set storage set, bytes32 value) private returns (bool) {
115         // We read and store the value's index to prevent multiple reads from the same storage slot
116         uint256 valueIndex = set._indexes[value];
117 
118         if (valueIndex != 0) { // Equivalent to contains(set, value)
119             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
120             // the array, and then remove the last element (sometimes called as 'swap and pop').
121             // This modifies the order of the array, as noted in {at}.
122 
123             uint256 toDeleteIndex = valueIndex - 1;
124             uint256 lastIndex = set._values.length - 1;
125 
126             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
127             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
128 
129             bytes32 lastvalue = set._values[lastIndex];
130 
131             // Move the last value to the index where the value to delete is
132             set._values[toDeleteIndex] = lastvalue;
133             // Update the index for the moved value
134             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
135 
136             // Delete the slot where the moved value was stored
137             set._values.pop();
138 
139             // Delete the index for the deleted slot
140             delete set._indexes[value];
141 
142             return true;
143         } else {
144             return false;
145         }
146     }
147 
148     /**
149      * @dev Returns true if the value is in the set. O(1).
150      */
151     function _contains(Set storage set, bytes32 value) private view returns (bool) {
152         return set._indexes[value] != 0;
153     }
154 
155     /**
156      * @dev Returns the number of values on the set. O(1).
157      */
158     function _length(Set storage set) private view returns (uint256) {
159         return set._values.length;
160     }
161 
162    /**
163     * @dev Returns the value stored at position `index` in the set. O(1).
164     *
165     * Note that there are no guarantees on the ordering of values inside the
166     * array, and it may change when more values are added or removed.
167     *
168     * Requirements:
169     *
170     * - `index` must be strictly less than {length}.
171     */
172     function _at(Set storage set, uint256 index) private view returns (bytes32) {
173         require(set._values.length > index, "EnumerableSet: index out of bounds");
174         return set._values[index];
175     }
176 
177     // AddressSet
178 
179     struct AddressSet {
180         Set _inner;
181     }
182 
183     /**
184      * @dev Add a value to a set. O(1).
185      *
186      * Returns true if the value was added to the set, that is if it was not
187      * already present.
188      */
189     function add(AddressSet storage set, address value) internal returns (bool) {
190         return _add(set._inner, bytes32(uint256(value)));
191     }
192 
193     /**
194      * @dev Removes a value from a set. O(1).
195      *
196      * Returns true if the value was removed from the set, that is if it was
197      * present.
198      */
199     function remove(AddressSet storage set, address value) internal returns (bool) {
200         return _remove(set._inner, bytes32(uint256(value)));
201     }
202 
203     /**
204      * @dev Returns true if the value is in the set. O(1).
205      */
206     function contains(AddressSet storage set, address value) internal view returns (bool) {
207         return _contains(set._inner, bytes32(uint256(value)));
208     }
209 
210     /**
211      * @dev Returns the number of values in the set. O(1).
212      */
213     function length(AddressSet storage set) internal view returns (uint256) {
214         return _length(set._inner);
215     }
216 
217    /**
218     * @dev Returns the value stored at position `index` in the set. O(1).
219     *
220     * Note that there are no guarantees on the ordering of values inside the
221     * array, and it may change when more values are added or removed.
222     *
223     * Requirements:
224     *
225     * - `index` must be strictly less than {length}.
226     */
227     function at(AddressSet storage set, uint256 index) internal view returns (address) {
228         return address(uint256(_at(set._inner, index)));
229     }
230 
231 
232     // UintSet
233 
234     struct UintSet {
235         Set _inner;
236     }
237 
238     /**
239      * @dev Add a value to a set. O(1).
240      *
241      * Returns true if the value was added to the set, that is if it was not
242      * already present.
243      */
244     function add(UintSet storage set, uint256 value) internal returns (bool) {
245         return _add(set._inner, bytes32(value));
246     }
247 
248     /**
249      * @dev Removes a value from a set. O(1).
250      *
251      * Returns true if the value was removed from the set, that is if it was
252      * present.
253      */
254     function remove(UintSet storage set, uint256 value) internal returns (bool) {
255         return _remove(set._inner, bytes32(value));
256     }
257 
258     /**
259      * @dev Returns true if the value is in the set. O(1).
260      */
261     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
262         return _contains(set._inner, bytes32(value));
263     }
264 
265     /**
266      * @dev Returns the number of values on the set. O(1).
267      */
268     function length(UintSet storage set) internal view returns (uint256) {
269         return _length(set._inner);
270     }
271 
272    /**
273     * @dev Returns the value stored at position `index` in the set. O(1).
274     *
275     * Note that there are no guarantees on the ordering of values inside the
276     * array, and it may change when more values are added or removed.
277     *
278     * Requirements:
279     *
280     * - `index` must be strictly less than {length}.
281     */
282     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
283         return uint256(_at(set._inner, index));
284     }
285 }
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address public owner;
294 
295 
296   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298 
299   /**
300    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301    * account.
302    */
303   constructor() public {
304     owner = msg.sender;
305   }
306 
307 
308   /**
309    * @dev Throws if called by any account other than the owner.
310    */
311   modifier onlyOwner() {
312     require(msg.sender == owner);
313     _;
314   }
315 
316 
317   /**
318    * @dev Allows the current owner to transfer control of the contract to a newOwner.
319    * @param newOwner The address to transfer ownership to.
320    */
321   function transferOwnership(address newOwner) onlyOwner public {
322     require(newOwner != address(0));
323     emit OwnershipTransferred(owner, newOwner);
324     owner = newOwner;
325   }
326 }
327 
328 
329 interface Token {
330     function transferFrom(address, address, uint) external returns (bool);
331     function transfer(address, uint) external returns (bool);
332 }
333 
334 contract PRDZstakingV2 is Ownable {
335     using SafeMath for uint;
336     using EnumerableSet for EnumerableSet.AddressSet;
337     
338     event RewardsClaimed(address indexed  holder, uint amount , uint indexed  time);
339     event TokenStaked(address indexed  holder, uint amount, uint indexed  time);
340     event AllTokenStaked(uint amount, uint indexed  time);
341     event OfferStaked(uint amount, uint indexed  time);
342     
343     event AllTokenUnStaked(uint amount, uint indexed  time);
344     event AllTokenClaimed(uint amount, uint indexed  time);
345     event TokenUnstaked(address indexed  holder, uint amount, uint indexed  time);
346     event TokenBurned(uint amount, uint indexed  time);
347     event EthClaimed(address indexed  holder, uint amount, uint indexed  time);
348     
349     // PRDZ token contract address
350     address public constant tokenAddress = 0x4e085036A1b732cBe4FfB1C12ddfDd87E7C3664d;
351     address public constant burnAddress = 0x0000000000000000000000000000000000000000;
352     
353     // reward rate 80.00% per year
354     uint public constant rewardRate = 8000;
355     uint public constant scoreRate = 1000;
356     
357     uint public constant rewardInterval = 365 days;
358     uint public constant scoreInterval = 3 days;
359     
360 
361     uint public scoreEth = 1000;
362     
363       // unstaking fee 2.00 percent
364     uint public constant unstakingFeeRate = 250;
365     
366     // unstaking possible after 72 hours
367     uint public constant cliffTime = 72 hours;
368     
369     uint public totalClaimedRewards = 0;
370     uint public totalStakedToken = 0;
371     uint public totalUnstakedToken = 0;
372     uint public totalEthDeposited = 0;
373     uint public totalEthClaimed = 0;
374     uint public totalFeeCollected = 0;
375     uint public totalOfferRaise = 0;
376     
377     
378     uint public stakingOffer = 1607878800;
379     uint public stakingOfferRaise = 250;
380 
381     
382 
383     EnumerableSet.AddressSet private holders;
384     
385     mapping (address => uint) public depositedTokens;
386     mapping (address => uint) public stakingTime;
387     mapping (address => uint) public lastClaimedTime;
388     mapping (address => uint) public totalEarnedTokens;
389     mapping (address => uint) public totalScore;
390     mapping (address => uint) public totalOfferUser;
391     mapping (address => uint) public lastScoreTime;
392   
393     /* Updates Total Reward and transfer User Reward on Stake and Unstake. */
394 
395     function updateAccount(address account) private {
396         uint pendingDivs = getPendingReward(account);
397         if (pendingDivs > 0) {
398             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
399             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
400             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
401             emit RewardsClaimed(account, pendingDivs, now);
402             emit AllTokenClaimed(totalClaimedRewards, now);
403         }
404         lastClaimedTime[account] = now;
405     }
406 
407 
408     /* Updates Last Score Time for Users. */
409     
410     function updateLastScoreTime(address _holder) private  {
411            if(lastScoreTime[_holder] > 0){
412                uint timeDiff = 0 ;
413                timeDiff = now.sub(lastScoreTime[_holder]).div(2); 
414                lastScoreTime[_holder] = now.sub(timeDiff) ;
415            }else{
416               lastScoreTime[_holder] = now ;
417            }         
418        
419     }
420 
421 
422     /* Calculate realtime ETH Reward based on User Score. */
423 
424 
425    function getScoreEth(address _holder) public view returns (uint) {
426         uint timeDiff = 0 ;
427        
428         if(lastScoreTime[_holder] > 0){
429             timeDiff = now.sub(lastScoreTime[_holder]).div(2);            
430            }
431 
432         uint stakedAmount = depositedTokens[_holder];
433        
434        
435         uint score = stakedAmount
436                             .mul(scoreRate)
437                             .mul(timeDiff)
438                             .div(scoreInterval)
439                             .div(1e4);
440        
441         uint eth = score.div(scoreEth);
442         
443         return eth;
444         
445 
446     }
447 
448     /* Calculate realtime  User Score. */
449 
450 
451     function getStakingScore(address _holder) public view returns (uint) {
452            uint timeDiff = 0 ;
453            if(lastScoreTime[_holder] > 0){
454             timeDiff = now.sub(lastScoreTime[_holder]).div(2);            
455            }
456 
457             uint stakedAmount = depositedTokens[_holder];
458        
459        
460             uint score = stakedAmount
461                             .mul(scoreRate)
462                             .mul(timeDiff)
463                             .div(scoreInterval)
464                             .div(1e4);
465         return score;
466     }
467     
468     /* Calculate realtime User Staking Score. */
469 
470     
471     function getPendingReward(address _holder) public view returns (uint) {
472         if (!holders.contains(_holder)) return 0;
473         if (depositedTokens[_holder] == 0) return 0;
474 
475         uint timeDiff = now.sub(lastClaimedTime[_holder]);
476         uint stakedAmount = depositedTokens[_holder];
477         
478         uint pendingDivs = stakedAmount
479                             .mul(rewardRate)
480                             .mul(timeDiff)
481                             .div(rewardInterval)
482                             .div(1e4);
483             
484         return pendingDivs;
485     }
486     
487     
488     
489     /* Fetch realtime Number of Token Claimed. */
490 
491 
492     function getTotalClaimed() public view returns (uint) {
493         return totalClaimedRewards;
494     }
495 
496     /* Fetch realtime Number of User Staked. */
497 
498 
499     function getNumberOfHolders() public view returns (uint) {
500         return holders.length();
501     }
502 
503     /* Fetch realtime Token  User Staked. */
504 
505       function getTotalStaked() public view returns (uint) {
506         return totalStakedToken;
507     }
508 
509      /* Fetch realtime Token  User UnStaked. */
510 
511       function getTotalUnStaked() public view returns (uint) {
512         return totalUnstakedToken;
513     }
514 
515     
516     /* Fetch realtime Token Gain from UnstakeFee. */
517 
518       function getTotalFeeCollected() public view returns (uint) {
519         return totalFeeCollected;
520     }
521     
522     /* Record Staking with Offer check. */
523 
524     
525     function stake(uint amountToStake) public {
526         require(amountToStake > 0, "Cannot deposit 0 Tokens");
527         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
528         emit TokenStaked(msg.sender, amountToStake, now);
529         
530         updateAccount(msg.sender);
531         updateLastScoreTime(msg.sender);
532         totalStakedToken = totalStakedToken.add(amountToStake);
533         
534         if(stakingOffer > now){
535             uint offerRaise = amountToStake.mul(stakingOfferRaise).div(1e4);          
536             totalOfferRaise = totalOfferRaise.add(offerRaise);
537             totalOfferUser[msg.sender] = offerRaise ;
538             emit OfferStaked(totalStakedToken, now);
539 
540             amountToStake = amountToStake.add(offerRaise);
541         }
542 
543             emit AllTokenStaked(totalStakedToken, now);
544 
545 
546         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToStake);
547 
548         if (!holders.contains(msg.sender)) {
549             holders.add(msg.sender);
550             stakingTime[msg.sender] = now;
551         }
552     }
553     
554      
555     /* Record UnStaking. */
556      
557 
558 
559     function unstake(uint amountToWithdraw) public {
560 
561         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");        
562          
563         updateAccount(msg.sender);
564         
565         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
566         uint amountAfterFee = amountToWithdraw.sub(fee);
567         
568         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
569         emit TokenUnstaked(msg.sender, amountAfterFee,now);
570      
571         require(Token(tokenAddress).transfer(burnAddress, fee), "Could not burn fee.");
572         emit TokenBurned(fee,now);
573        
574         totalUnstakedToken = totalUnstakedToken.add(amountAfterFee);
575         totalFeeCollected = totalFeeCollected.add(fee);
576         emit AllTokenUnStaked(totalUnstakedToken, now);
577         
578         uint timeDiff = 0 ;
579         
580         if(lastScoreTime[msg.sender] > 0){
581             timeDiff = now.sub(lastScoreTime[msg.sender]).div(2);            
582         }
583       
584         uint score = amountAfterFee
585                             .mul(scoreRate)
586                             .mul(timeDiff)
587                             .div(scoreInterval)
588                             .div(1e4);
589             
590         
591          
592         uint eth = score.div(scoreEth);     
593         totalEthClaimed = totalEthClaimed.add(eth);
594 
595         msg.sender.transfer(eth);
596         emit EthClaimed(msg.sender ,eth,now);
597 
598         lastScoreTime[msg.sender] = now;
599 
600         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
601         
602         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
603             holders.remove(msg.sender);
604         }
605     }
606 
607 
608     /* Claim Reward. */
609 
610     
611     function claimReward() public {
612         updateAccount(msg.sender);
613     }
614 
615 
616   
617     /* Claim ETH Equivalent to Score. */
618   
619     function claimScoreEth() public {
620         uint timeDiff = 0 ;
621         
622         if(lastScoreTime[msg.sender] > 0){
623             timeDiff = now.sub(lastScoreTime[msg.sender]).div(2);            
624         }
625 
626         uint stakedAmount = depositedTokens[msg.sender];       
627        
628         uint score = stakedAmount
629                             .mul(scoreRate)
630                             .mul(timeDiff)
631                             .div(scoreInterval)
632                             .div(1e4);                    
633          
634         uint eth = score.div(scoreEth);     
635         totalEthClaimed = totalEthClaimed.add(eth);
636         msg.sender.transfer(eth);
637         emit EthClaimed(msg.sender , eth,now);
638  
639         
640         lastScoreTime[msg.sender] = now;
641     
642     }
643     
644 
645     function deposit() payable public {
646         totalEthDeposited = totalEthDeposited.add(msg.value);         
647     }
648     
649     function updateScoreEth(uint _amount) public onlyOwner {
650             scoreEth = _amount ;
651     }
652     
653 
654        function updateOffer(uint time, uint raise) public onlyOwner {
655             stakingOffer = time ;
656             stakingOfferRaise = raise ;
657     }
658  
659 }