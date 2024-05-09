1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.1;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies in extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return _functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         return _functionCallWithValue(target, data, value, errorMessage);
274     }
275 
276     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 // solhint-disable-next-line no-inline-assembly
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 
301 /**
302  * @dev Interface of the ERC20 standard as defined in the EIP.
303  */
304 interface IERC20 {
305     /**
306      * @dev Returns the amount of tokens in existence.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns the amount of tokens owned by `account`.
312      */
313     function balanceOf(address account) external view returns (uint256);
314 
315     /**
316      * @dev Moves `amount` tokens from the caller's account to `recipient`.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transfer(address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Returns the remaining number of tokens that `spender` will be
326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
327      * zero by default.
328      *
329      * This value changes when {approve} or {transferFrom} are called.
330      */
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     /**
334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
339      * that someone may use both the old and the new allowance by unfortunate
340      * transaction ordering. One possible solution to mitigate this race
341      * condition is to first reduce the spender's allowance to 0 and set the
342      * desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address spender, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Moves `amount` tokens from `sender` to `recipient` using the
351      * allowance mechanism. `amount` is then deducted from the caller's
352      * allowance.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 /*
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with GSN meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address payable) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes memory) {
391         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
392         return msg.data;
393     }
394 }
395 
396 
397  /* @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor () {
417         address msgSender = _msgSender();
418         _owner = msgSender;
419         emit OwnershipTransferred(address(0), msgSender);
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(_owner == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 }
447 
448 contract SpazStake is Ownable {
449     using SafeMath for uint256;
450     
451     uint256 private _dailyROI = 100; // 1%
452     uint256 private _immatureUnstakeTax = 2000; //20%
453     uint256 private _referralcommission = 25; // 0.25%
454     
455     IERC20 private _spazToken;
456     uint256 private _tokenDecimals = 1e8;
457     uint256 private _stakeDuration = 100 days;
458     uint256 private _unitDuration = 1 days;
459     uint256 private _withdrawalInterval = 1 weeks;
460     uint256 private _stakingPool = _tokenDecimals.mul(5000000);
461     uint256 private _referralPool = _tokenDecimals.mul(12500);
462     uint256 private _minimumStakAmount = _tokenDecimals.mul(500);
463     uint256 private _maximumStakeAmount = _tokenDecimals.mul(100000);
464     
465     uint256 private _totalStaked;
466     uint256 private _totalStakers;
467     uint256 private _totalDividend;
468     uint256 private _refBonusPulled;
469     
470     struct Stake {
471         bool exists;
472         uint256 createdAt;
473         uint256 amount;
474         uint256 withdrawn;
475         uint256 lastWithdrewAt;
476         uint256 refBonus;
477     }
478     
479     mapping(address => Stake) stakers;
480     
481     event OnStake(address indexed staker, uint256 amount);
482     event OnUnstake(address indexed staker, uint256 amount);
483     event OnWithdraw(address indexed staker, uint256 amount);
484     
485     constructor() {
486         _spazToken = IERC20(0x810908B285f85Af668F6348cD8B26D76B3EC12e1);
487     }
488     
489     function stake(uint256 _amount, address _referrer) public {
490         require(!stakingPoolFilled(_amount), "Stake: staking pool filled");
491         require(!isStaking(_msgSender()), "Stake: Already staking");
492         require(_amount >= minimumStakeAmount(), "Stake: Not enough amount to stake");
493         require(_amount <= maximumStakeAmount(), "Stake: More than acceptable stake amount");
494         require(_spazToken.transferFrom(_msgSender(), address(this), _amount), "Stake: Token transfer failed");
495                 
496         _createStake(_msgSender(), _amount);
497         _handleReferrer(_referrer, _amount);
498     }
499     
500     function withdraw() public {
501         require(isStaking(_msgSender()), "Withdraw: sender is not a staking");
502         Stake storage targetStaker = stakers[_msgSender()];
503         uint256 lastWithdrawalTillNow = block.timestamp.sub(targetStaker.lastWithdrewAt);
504         // maximum: once per week;
505         require(targetStaker.lastWithdrewAt == 0 || lastWithdrawalTillNow > _withdrawalInterval, "Withdraw: can only withdraw once in a week");
506         uint256 roi = _stakingROI(targetStaker).sub(targetStaker.withdrawn); // sub past withdrawals
507         
508         require(roi > 0, "Withdraw: Withdrawable amount is zero");
509         uint256 total = roi.add(targetStaker.refBonus);
510         _totalDividend = _totalDividend.add(total);
511 
512         targetStaker.withdrawn = targetStaker.withdrawn.add(roi); // increase withdrawn amount
513         targetStaker.lastWithdrewAt = block.timestamp; // update last withdrawal date
514         targetStaker.refBonus = 0;
515        
516         require(_spazToken.transfer(_msgSender(), total), "Withdraw: Token transfer failed");
517         
518         emit OnWithdraw(_msgSender(), roi);
519         
520     }
521     
522     function unStake() public {
523         require(isStaking(_msgSender()), "Unstake: sender is not staking");
524         Stake memory targetStaker = stakers[_msgSender()];
525         uint256 roi = _stakingROI(targetStaker).sub(targetStaker.withdrawn); // sub past withdrawals
526         uint256 amount = targetStaker.amount;
527         
528         _totalStakers = _totalStakers.sub(1);
529         _totalStaked = _totalStaked.sub(targetStaker.amount);
530         
531         if (!isMaturedStaking(_msgSender())) {
532             uint256 tax = amount.mul(_immatureUnstakeTax).div(10000);
533             amount = amount.sub(tax); // sub tax fee for unstaking immaturely
534         }
535         uint256 total = amount.add(roi).add(targetStaker.refBonus);
536         _totalDividend = _totalDividend.add(total);
537 
538         delete stakers[_msgSender()];
539         require(_spazToken.transfer(_msgSender(), total), "Unstake: Token transfer failed");
540         emit OnUnstake(_msgSender(), total);
541     }
542     
543     function adminWithrawal(uint256 _amount) public onlyOwner {
544         require(_amount > 0, "Amount cannot be zero");
545         require(_spazToken.balanceOf(address(this)) >= _amount, "Balance is less than amount");
546         require(_spazToken.transfer(owner(), _amount), "Token transfer failed");
547         emit OnWithdraw(owner(), _amount);
548         
549     }
550 
551     function _createStake(address _staker, uint256 _amount) internal {
552         stakers[_staker] = Stake(true, block.timestamp, _amount, 0, 0, 0);
553         _totalStakers = _totalStakers.add(1);
554         _totalStaked = _totalStaked.add(_amount);
555         emit OnStake(_msgSender(), _amount);
556     }
557     
558     function _handleReferrer(address _referrer, uint256 _amount) internal {
559         if (_referrer != _msgSender() && isStaking(_referrer)) {
560             uint256 bonus = _amount.mul(_referralcommission).div(10000);
561             uint256 tempRefPulled = _refBonusPulled.add(bonus);
562             
563             if (tempRefPulled <= _referralPool) {
564                 _refBonusPulled = tempRefPulled;
565                 stakers[_referrer].refBonus += bonus;
566             }
567         }
568     }
569     
570     function _stakingROI(Stake memory _stake) internal view returns(uint256) {
571         uint256 duration = block.timestamp.sub(_stake.createdAt);
572         
573         if (duration > _stakeDuration) {
574             duration = _stakeDuration;
575         }
576         
577         uint256 unitDuration = duration.div(_unitDuration);
578         uint256 roi = unitDuration.mul(_dailyROI).mul(_stake.amount);
579         return roi.div(10000);
580     }
581     
582     function stakingROI(address _staker) public view returns(uint256) {
583         Stake memory targetStaker = stakers[_staker];
584         return _stakingROI(targetStaker);
585     }
586     
587     function isMaturedStaking(address _staker) public view returns(bool) {
588         
589         if (isStaking(_staker) && block.timestamp.sub(stakers[_staker].createdAt) > _stakeDuration) {
590             return true;
591         }
592         return false;
593     }
594     
595     function stakingPoolFilled(uint256 _amount) public view returns(bool) {
596         uint256 temporaryPool = _totalStaked.add(_amount);
597         return temporaryPool >= _stakingPool;
598     }
599     
600     function isStaking(address _staker) public view returns(bool) {
601         return stakers[_staker].exists;
602     }
603     
604     function spazToken() public view returns(IERC20) {
605         return _spazToken;
606     }
607     
608     function minimumStakeAmount() public view returns(uint256) {
609         return _minimumStakAmount;
610     }
611     
612     function maximumStakeAmount() public view returns(uint256) {
613         return _maximumStakeAmount;
614     }
615     
616     function totalStaked() external view returns(uint256) {
617         return _totalStaked;
618     }
619     
620     function totalStakers() external view returns(uint256) {
621         return _totalStakers;
622     }
623     
624     function stakingPool() external view returns(uint256) {
625         return _stakingPool;
626     }
627     
628     function referralPool() external view returns(uint256) {
629         return _referralPool;
630     }
631     
632     function referralBonus(address _staker) external view returns(uint256) {
633         return stakers[_staker].refBonus;
634     }
635     
636     function stakeCreatedAt(address _staker) external view returns(uint256) {
637         return stakers[_staker].createdAt;
638     }
639     
640     function stakingUntil(address _staker) external view returns(uint256) {
641         return stakers[_staker].createdAt.add(_stakeDuration);
642     }
643     
644     function rewardWithdrawn(address _staker) external view returns(uint256) {
645         return stakers[_staker].withdrawn;
646     }
647     
648     function lastWithdrawalDate(address _staker) external view returns(uint256) {
649         return stakers[_staker].lastWithdrewAt;
650     }
651     
652     function stakedAmount(address _staker) external view returns(uint256) {
653         return stakers[_staker].amount;
654     }
655 }