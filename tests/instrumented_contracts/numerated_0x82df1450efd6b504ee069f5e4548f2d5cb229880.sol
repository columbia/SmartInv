1 // SPDX-License-Identifier: BSD-3-Clause
2 pragma solidity 0.6.11;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @dev Collection of functions related to the address type
36  */
37 library Address {
38     /**
39      * @dev Returns true if `account` is a contract.
40      *
41      * [IMPORTANT]
42      * ====
43      * It is unsafe to assume that an address for which this function returns
44      * false is an externally-owned account (EOA) and not a contract.
45      *
46      * Among others, `isContract` will return false for the following
47      * types of addresses:
48      *
49      *  - an externally-owned account
50      *  - a contract in construction
51      *  - an address where a contract will be created
52      *  - an address where a contract lived, but was destroyed
53      * ====
54      */
55     function isContract(address account) internal view returns (bool) {
56         // This method relies on extcodesize, which returns 0 for contracts in
57         // construction, since the code is only stored at the end of the
58         // constructor execution.
59 
60         uint256 size;
61         // solhint-disable-next-line no-inline-assembly
62         assembly { size := extcodesize(account) }
63         return size > 0;
64     }
65 
66     /**
67      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
68      * `recipient`, forwarding all available gas and reverting on errors.
69      *
70      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
71      * of certain opcodes, possibly making contracts go over the 2300 gas limit
72      * imposed by `transfer`, making them unable to receive funds via
73      * `transfer`. {sendValue} removes this limitation.
74      *
75      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
76      *
77      * IMPORTANT: because control is transferred to `recipient`, care must be
78      * taken to not create reentrancy vulnerabilities. Consider using
79      * {ReentrancyGuard} or the
80      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
81      */
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
86         (bool success, ) = recipient.call{ value: amount }("");
87         require(success, "Address: unable to send value, recipient may have reverted");
88     }
89 
90     /**
91      * @dev Performs a Solidity function call using a low level `call`. A
92      * plain`call` is an unsafe replacement for a function call: use this
93      * function instead.
94      *
95      * If `target` reverts with a revert reason, it is bubbled up by this
96      * function (like regular Solidity function calls).
97      *
98      * Returns the raw returned data. To convert to the expected return value,
99      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
100      *
101      * Requirements:
102      *
103      * - `target` must be a contract.
104      * - calling `target` with `data` must not revert.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109       return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
114      * `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but also transferring `value` wei to `target`.
125      *
126      * Requirements:
127      *
128      * - the calling contract must have an ETH balance of at least `value`.
129      * - the called Solidity function must be `payable`.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         require(isContract(target), "Address: call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.call{ value: value }(data);
149         return _verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
169         require(isContract(target), "Address: static call to non-contract");
170 
171         // solhint-disable-next-line avoid-low-level-calls
172         (bool success, bytes memory returndata) = target.staticcall(data);
173         return _verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.3._
181      */
182     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a delegate call.
189      *
190      * _Available since v3.3._
191      */
192     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return _verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             // Look for revert reason and bubble it up if present
205             if (returndata.length > 0) {
206                 // The easiest way to bubble the revert reason is using memory via assembly
207 
208                 // solhint-disable-next-line no-inline-assembly
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 /**
221  * @dev Library for managing
222  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
223  * types.
224  *
225  * Sets have the following properties:
226  *
227  * - Elements are added, removed, and checked for existence in constant time
228  * (O(1)).
229  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
230  *
231  * ```
232  * contract Example {
233  *     // Add the library methods
234  *     using EnumerableSet for EnumerableSet.AddressSet;
235  *
236  *     // Declare a set state variable
237  *     EnumerableSet.AddressSet private mySet;
238  * }
239  * ```
240  *
241  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
242  * (`UintSet`) are supported.
243  */
244 library EnumerableSet {
245     // To implement this library for multiple types with as little code
246     // repetition as possible, we write it in terms of a generic Set type with
247     // bytes32 values.
248     // The Set implementation uses private functions, and user-facing
249     // implementations (such as AddressSet) are just wrappers around the
250     // underlying Set.
251     // This means that we can only create new EnumerableSets for types that fit
252     // in bytes32.
253 
254     struct Set {
255         // Storage of set values
256         bytes32[] _values;
257 
258         // Position of the value in the `values` array, plus 1 because index 0
259         // means a value is not in the set.
260         mapping (bytes32 => uint256) _indexes;
261     }
262 
263     /**
264      * @dev Add a value to a set. O(1).
265      *
266      * Returns true if the value was added to the set, that is if it was not
267      * already present.
268      */
269     function _add(Set storage set, bytes32 value) private returns (bool) {
270         if (!_contains(set, value)) {
271             set._values.push(value);
272             // The value is stored at length-1, but we add 1 to all indexes
273             // and use 0 as a sentinel value
274             set._indexes[value] = set._values.length;
275             return true;
276         } else {
277             return false;
278         }
279     }
280 
281     /**
282      * @dev Removes a value from a set. O(1).
283      *
284      * Returns true if the value was removed from the set, that is if it was
285      * present.
286      */
287     function _remove(Set storage set, bytes32 value) private returns (bool) {
288         // We read and store the value's index to prevent multiple reads from the same storage slot
289         uint256 valueIndex = set._indexes[value];
290 
291         if (valueIndex != 0) { // Equivalent to contains(set, value)
292             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
293             // the array, and then remove the last element (sometimes called as 'swap and pop').
294             // This modifies the order of the array, as noted in {at}.
295 
296             uint256 toDeleteIndex = valueIndex - 1;
297             uint256 lastIndex = set._values.length - 1;
298 
299             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
300             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
301 
302             bytes32 lastvalue = set._values[lastIndex];
303 
304             // Move the last value to the index where the value to delete is
305             set._values[toDeleteIndex] = lastvalue;
306             // Update the index for the moved value
307             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
308 
309             // Delete the slot where the moved value was stored
310             set._values.pop();
311 
312             // Delete the index for the deleted slot
313             delete set._indexes[value];
314 
315             return true;
316         } else {
317             return false;
318         }
319     }
320 
321     /**
322      * @dev Returns true if the value is in the set. O(1).
323      */
324     function _contains(Set storage set, bytes32 value) private view returns (bool) {
325         return set._indexes[value] != 0;
326     }
327 
328     /**
329      * @dev Returns the number of values on the set. O(1).
330      */
331     function _length(Set storage set) private view returns (uint256) {
332         return set._values.length;
333     }
334 
335    /**
336     * @dev Returns the value stored at position `index` in the set. O(1).
337     *
338     * Note that there are no guarantees on the ordering of values inside the
339     * array, and it may change when more values are added or removed.
340     *
341     * Requirements:
342     *
343     * - `index` must be strictly less than {length}.
344     */
345     function _at(Set storage set, uint256 index) private view returns (bytes32) {
346         require(set._values.length > index, "EnumerableSet: index out of bounds");
347         return set._values[index];
348     }
349 
350     // AddressSet
351 
352     struct AddressSet {
353         Set _inner;
354     }
355 
356     /**
357      * @dev Add a value to a set. O(1).
358      *
359      * Returns true if the value was added to the set, that is if it was not
360      * already present.
361      */
362     function add(AddressSet storage set, address value) internal returns (bool) {
363         return _add(set._inner, bytes32(uint256(value)));
364     }
365 
366     /**
367      * @dev Removes a value from a set. O(1).
368      *
369      * Returns true if the value was removed from the set, that is if it was
370      * present.
371      */
372     function remove(AddressSet storage set, address value) internal returns (bool) {
373         return _remove(set._inner, bytes32(uint256(value)));
374     }
375 
376     /**
377      * @dev Returns true if the value is in the set. O(1).
378      */
379     function contains(AddressSet storage set, address value) internal view returns (bool) {
380         return _contains(set._inner, bytes32(uint256(value)));
381     }
382 
383     /**
384      * @dev Returns the number of values in the set. O(1).
385      */
386     function length(AddressSet storage set) internal view returns (uint256) {
387         return _length(set._inner);
388     }
389 
390    /**
391     * @dev Returns the value stored at position `index` in the set. O(1).
392     *
393     * Note that there are no guarantees on the ordering of values inside the
394     * array, and it may change when more values are added or removed.
395     *
396     * Requirements:
397     *
398     * - `index` must be strictly less than {length}.
399     */
400     function at(AddressSet storage set, uint256 index) internal view returns (address) {
401         return address(uint256(_at(set._inner, index)));
402     }
403 
404 
405     // UintSet
406 
407     struct UintSet {
408         Set _inner;
409     }
410 
411     /**
412      * @dev Add a value to a set. O(1).
413      *
414      * Returns true if the value was added to the set, that is if it was not
415      * already present.
416      */
417     function add(UintSet storage set, uint256 value) internal returns (bool) {
418         return _add(set._inner, bytes32(value));
419     }
420 
421     /**
422      * @dev Removes a value from a set. O(1).
423      *
424      * Returns true if the value was removed from the set, that is if it was
425      * present.
426      */
427     function remove(UintSet storage set, uint256 value) internal returns (bool) {
428         return _remove(set._inner, bytes32(value));
429     }
430 
431     /**
432      * @dev Returns true if the value is in the set. O(1).
433      */
434     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
435         return _contains(set._inner, bytes32(value));
436     }
437 
438     /**
439      * @dev Returns the number of values on the set. O(1).
440      */
441     function length(UintSet storage set) internal view returns (uint256) {
442         return _length(set._inner);
443     }
444 
445    /**
446     * @dev Returns the value stored at position `index` in the set. O(1).
447     *
448     * Note that there are no guarantees on the ordering of values inside the
449     * array, and it may change when more values are added or removed.
450     *
451     * Requirements:
452     *
453     * - `index` must be strictly less than {length}.
454     */
455     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
456         return uint256(_at(set._inner, index));
457     }
458 }
459 
460 /**
461  * @title Ownable
462  * @dev The Ownable contract has an owner address, and provides basic authorization control
463  * functions, this simplifies the implementation of "user permissions".
464  */
465 contract Ownable {
466   address public owner;
467 
468 
469   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470 
471 
472   /**
473    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
474    * account.
475    */
476   constructor() public {
477     owner = msg.sender;
478   }
479 
480 
481   /**
482    * @dev Throws if called by any account other than the owner.
483    */
484   modifier onlyOwner() {
485     require(msg.sender == owner);
486     _;
487   }
488 
489 
490   /**
491    * @dev Allows the current owner to transfer control of the contract to a newOwner.
492    * @param newOwner The address to transfer ownership to.
493    */
494   function transferOwnership(address newOwner) onlyOwner public {
495     require(newOwner != address(0));
496     emit OwnershipTransferred(owner, newOwner);
497     owner = newOwner;
498   }
499 }
500 
501 interface Token {
502     function transferFrom(address, address, uint) external returns (bool);
503     function transfer(address, uint) external returns (bool);
504 }
505 
506 interface LegacyToken {
507     function transfer(address, uint) external;
508 }
509 
510 contract ConstantReturnStaking is Ownable {
511     using Address for address;
512     using SafeMath for uint;
513     using EnumerableSet for EnumerableSet.AddressSet;
514     
515     event RewardsTransferred(address indexed holder, uint amount);
516     event ReferralFeeTransferred(address indexed referrer, uint amount);
517     event Reinvest(address indexed holder, uint amount);
518     
519     // ============================= CONTRACT VARIABLES ==============================
520     
521     // stake token contract address
522     address public constant TRUSTED_TOKEN_ADDRESS = 0x961C8c0B1aaD0c0b10a51FeF6a867E3091BCef17;
523     
524     // earnings reward rate
525     uint public constant REWARD_RATE_X_100 = 3500;
526     uint public constant REWARD_INTERVAL = 365 days;
527     
528     // staking fee
529     uint public constant STAKING_FEE_RATE_X_100 = 0;
530     
531     // unstaking fee 
532     uint public constant UNSTAKING_FEE_RATE_X_100 = 25;
533     
534     // this % of earned rewards go to referrer
535     uint public constant REFERRAL_FEE_RATE_X_100 = 500;
536     
537     // unstaking possible after 72 hours
538     uint public constant LOCKUP_TIME = 120 days;
539     
540     uint public constant ADMIN_CAN_CLAIM_AFTER = 395 days;
541     
542     // ========================= END CONTRACT VARIABLES ==============================
543     
544     uint public totalClaimedRewards = 0;
545     uint public totalClaimedReferralFee = 0;
546     
547     uint public immutable contractStartTime;
548     
549     // Contracts are not allowed to deposit, claim or withdraw
550     modifier noContractsAllowed() {
551         require(!(address(msg.sender).isContract()) && tx.origin == msg.sender, "No Contracts Allowed!");
552         _;
553     }
554     
555     EnumerableSet.AddressSet private holders;
556     
557     mapping (address => uint) public depositedTokens;
558     mapping (address => uint) public stakingTime;
559     mapping (address => uint) public lastClaimedTime;
560     mapping (address => uint) public totalEarnedTokens;
561     
562     mapping (address => uint) public rewardsPendingClaim;
563     
564     mapping (address => address) public referrals;
565     mapping (address => uint) public totalReferralFeeEarned;
566     
567     mapping (address => EnumerableSet.AddressSet) private activeReferredAddressesOfUser;
568     mapping (address => EnumerableSet.AddressSet) private totalReferredAddressesOfUser;
569     
570     constructor() public {
571         contractStartTime = now;
572     }
573     
574     function updateAccount(address account) private {
575         uint pendingDivs = getPendingDivs(account);
576         if (pendingDivs > 0) {
577             uint referralFee = pendingDivs.mul(REFERRAL_FEE_RATE_X_100).div(100e2);
578             uint pendingDivsAfterFee = pendingDivs.sub(referralFee);
579             
580             bool success = transferReferralFeeIfPossible(referrals[account], referralFee);
581             
582             uint amount = pendingDivs;
583             if (success) {
584                 amount = pendingDivsAfterFee;
585             }
586             
587             
588             rewardsPendingClaim[account] = rewardsPendingClaim[account].add(amount);
589             totalEarnedTokens[account] = totalEarnedTokens[account].add(amount);
590             
591             totalClaimedRewards = totalClaimedRewards.add(amount);
592             
593         }
594         lastClaimedTime[account] = now;
595     }
596     
597     function transferReferralFeeIfPossible(address account, uint amount) private returns (bool) {
598         if (account != address(0) && amount > 0) {
599             totalReferralFeeEarned[account] = totalReferralFeeEarned[account].add(amount);
600             require(Token(TRUSTED_TOKEN_ADDRESS).transfer(account, amount), "Could not transfer referral fee!");
601             totalClaimedReferralFee = totalClaimedReferralFee.add(amount);
602             emit ReferralFeeTransferred(account, amount);
603             return true;
604         }
605         return false;
606     }
607     
608     function getPendingDivs(address _holder) public view returns (uint) {
609         if (!holders.contains(_holder)) return 0;
610         if (depositedTokens[_holder] == 0) return 0;
611         
612         uint timeDiff;
613         uint stakingEndTime = contractStartTime.add(REWARD_INTERVAL);
614         uint _now = now;
615         if (_now > stakingEndTime) {
616             _now = stakingEndTime;
617         }
618         
619         if (lastClaimedTime[_holder] >= _now) {
620             timeDiff = 0;
621         } else {
622             timeDiff = _now.sub(lastClaimedTime[_holder]);
623         }
624 
625         uint stakedAmount = depositedTokens[_holder];
626         
627         uint pendingDivs = stakedAmount
628                             .mul(REWARD_RATE_X_100)
629                             .mul(timeDiff)
630                             .div(REWARD_INTERVAL)
631                             .div(1e4);
632             
633         return pendingDivs;
634     }
635     
636     function getTotalPendingDivs(address _holder) external view returns (uint) {
637         uint pending = getPendingDivs(_holder);
638         uint awaitingClaim = rewardsPendingClaim[_holder];
639         return pending.add(awaitingClaim);
640     }
641     
642     function getNumberOfHolders() external view returns (uint) {
643         return holders.length();
644     }
645     
646     function getNumberOfReferredStakers(address referrer) external view returns (uint _activeStakers, uint _totalStakers) {
647         _activeStakers = activeReferredAddressesOfUser[referrer].length();
648         _totalStakers = totalReferredAddressesOfUser[referrer].length();
649     }
650     
651     function getReferredStaker(address account, uint i) external view returns (address _staker, uint _totalEarned) {
652         _staker = totalReferredAddressesOfUser[account].at(i);
653         _totalEarned = totalEarnedTokens[_staker];
654     }
655     function getActiveReferredStaker(address account, uint i) external view returns (address _staker, uint _totalEarned) {
656         _staker = activeReferredAddressesOfUser[account].at(i);
657         _totalEarned = totalEarnedTokens[_staker];
658     }
659     
660     
661     function stake(uint amountToStake, address referrer) external noContractsAllowed {
662         require(amountToStake > 0, "Cannot deposit 0 Tokens");
663         require(Token(TRUSTED_TOKEN_ADDRESS).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
664         
665         updateAccount(msg.sender);
666         
667         uint fee = amountToStake.mul(STAKING_FEE_RATE_X_100).div(1e4);
668         uint amountAfterFee = amountToStake.sub(fee);
669         require(Token(TRUSTED_TOKEN_ADDRESS).transfer(owner, fee), "Could not transfer deposit fee.");
670         
671         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
672         
673         holders.add(msg.sender);
674         
675         if (referrals[msg.sender] == address(0)) {
676             referrals[msg.sender] = referrer;
677         }
678         
679         totalReferredAddressesOfUser[referrals[msg.sender]].add(msg.sender);
680         activeReferredAddressesOfUser[referrals[msg.sender]].add(msg.sender);
681         
682         stakingTime[msg.sender] = now;
683     }
684     
685     function unstake(uint amountToWithdraw) external noContractsAllowed {
686         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
687         
688         require(now.sub(stakingTime[msg.sender]) > LOCKUP_TIME, "You recently staked, please wait before withdrawing.");
689         
690         updateAccount(msg.sender);
691         
692         uint fee = amountToWithdraw.mul(UNSTAKING_FEE_RATE_X_100).div(1e4);
693         uint amountAfterFee = amountToWithdraw.sub(fee);
694         
695         require(Token(TRUSTED_TOKEN_ADDRESS).transfer(owner, fee), "Could not transfer withdraw fee.");
696         require(Token(TRUSTED_TOKEN_ADDRESS).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
697         
698         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
699         
700         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
701             holders.remove(msg.sender);
702             activeReferredAddressesOfUser[referrals[msg.sender]].remove(msg.sender);
703         }
704     }
705     
706     // emergency unstake without caring about pending earnings
707     // pending earnings will be lost / set to 0 if used emergency unstake
708     function emergencyUnstake(uint amountToWithdraw) external noContractsAllowed {
709         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
710         
711         require(now.sub(stakingTime[msg.sender]) > LOCKUP_TIME, "You recently staked, please wait before withdrawing.");
712         
713         // set pending earnings to 0 here
714         lastClaimedTime[msg.sender] = now;
715         
716         uint fee = amountToWithdraw.mul(UNSTAKING_FEE_RATE_X_100).div(1e4);
717         uint amountAfterFee = amountToWithdraw.sub(fee);
718         
719         require(Token(TRUSTED_TOKEN_ADDRESS).transfer(owner, fee), "Could not transfer withdraw fee.");
720         require(Token(TRUSTED_TOKEN_ADDRESS).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
721         
722         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
723         
724         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
725             holders.remove(msg.sender);
726         }
727     }
728     
729     function claim() external noContractsAllowed {
730         updateAccount(msg.sender);
731         uint amount = rewardsPendingClaim[msg.sender];
732         if (amount > 0) {
733             rewardsPendingClaim[msg.sender] = 0;
734             require(Token(TRUSTED_TOKEN_ADDRESS).transfer(msg.sender, amount), "Could not transfer earned tokens.");  
735             emit RewardsTransferred(msg.sender, amount);
736         }
737     }
738     
739     function reInvest() external noContractsAllowed {
740         updateAccount(msg.sender);
741         uint amount = rewardsPendingClaim[msg.sender];
742         if (amount > 0) {
743             rewardsPendingClaim[msg.sender] = 0;
744             
745             // re-invest here
746             depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amount);
747             
748             stakingTime[msg.sender] = now;
749             emit Reinvest(msg.sender, amount);
750         }
751     }
752     
753     function getStakersList(uint startIndex, uint endIndex) 
754         public 
755         view 
756         returns (address[] memory stakers, 
757             uint[] memory stakingTimestamps, 
758             uint[] memory lastClaimedTimeStamps,
759             uint[] memory stakedTokens) {
760         require (startIndex < endIndex);
761         
762         uint length = endIndex.sub(startIndex);
763         address[] memory _stakers = new address[](length);
764         uint[] memory _stakingTimestamps = new uint[](length);
765         uint[] memory _lastClaimedTimeStamps = new uint[](length);
766         uint[] memory _stakedTokens = new uint[](length);
767         
768         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
769             address staker = holders.at(i);
770             uint listIndex = i.sub(startIndex);
771             _stakers[listIndex] = staker;
772             _stakingTimestamps[listIndex] = stakingTime[staker];
773             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
774             _stakedTokens[listIndex] = depositedTokens[staker];
775         }
776         
777         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
778     }
779     
780     
781     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
782     // Admin cannot transfer out reward tokens from this smart contract
783     function transferAnyERC20Token(address tokenAddress, address recipient, uint amount) external onlyOwner {
784         require (tokenAddress != TRUSTED_TOKEN_ADDRESS || now > contractStartTime.add(ADMIN_CAN_CLAIM_AFTER), "Cannot Transfer Out main tokens!");
785         require (Token(tokenAddress).transfer(recipient, amount), "Transfer failed!");
786     }
787     
788     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
789     // Admin cannot transfer out reward tokens from this smart contract
790     function transferAnyLegacyERC20Token(address tokenAddress, address recipient, uint amount) external onlyOwner {
791         require (tokenAddress != TRUSTED_TOKEN_ADDRESS || now > contractStartTime.add(ADMIN_CAN_CLAIM_AFTER), "Cannot Transfer Out main tokens!");
792         LegacyToken(tokenAddress).transfer(recipient, amount);
793     }
794 }