1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // SPDX-License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 // SPDX-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: contracts/FestakingFarm.sol
465 
466 pragma solidity ^0.6.0;
467 
468 
469 
470 contract FestakingFarm {
471     using SafeMath for uint256;
472     using SafeERC20 for IERC20;
473 
474     mapping (address => uint256) private _stakes;
475 
476     string public name;
477     address  public tokenAddress;
478     address  public rewardTokenAddress;
479     uint public stakingStarts;
480     uint public stakingEnds;
481     uint public withdrawStarts;
482     uint public withdrawEnds;
483     uint256 public stakedTotal;
484     uint256 public stakingCap;
485     uint256 public totalReward;
486     uint256 public earlyWithdrawReward;
487     uint256 public rewardBalance;
488     uint256 public stakedBalance;
489 
490     IERC20 public ERC20Interface;
491     event Staked(address indexed token, address indexed staker_, uint256 requestedAmount_, uint256 stakedAmount_);
492     event PaidOut(address indexed token, address indexed rewardToken, address indexed staker_, uint256 amount_, uint256 reward_);
493 
494     /**
495      */
496     constructor (string memory name_,
497         address tokenAddress_,
498         address rewardTokenAddress_,
499         uint stakingStarts_,
500         uint stakingEnds_,
501         uint withdrawStarts_,
502         uint withdrawEnds_,
503         uint256 stakingCap_) public {
504         name = name_;
505         require(tokenAddress_ != address(0), "Festaking: 0 address");
506         tokenAddress = tokenAddress_;
507 
508         require(rewardTokenAddress_ != address(0), "Festaking: 0 reward address");
509         rewardTokenAddress = rewardTokenAddress_;
510 
511         require(stakingStarts_ > 0, "Festaking: zero staking start time");
512         if (stakingStarts_ < now) {
513             stakingStarts = now;
514         } else {
515             stakingStarts = stakingStarts_;
516         }
517 
518         require(stakingEnds_ > stakingStarts, "Festaking: staking end must be after staking starts");
519         stakingEnds = stakingEnds_;
520 
521         require(withdrawStarts_ >= stakingEnds, "Festaking: withdrawStarts must be after staking ends");
522         withdrawStarts = withdrawStarts_;
523 
524         require(withdrawEnds_ > withdrawStarts, "Festaking: withdrawEnds must be after withdraw starts");
525         withdrawEnds = withdrawEnds_;
526 
527         require(stakingCap_ > 0, "Festaking: stakingCap must be positive");
528         stakingCap = stakingCap_;
529     }
530 
531     function addReward(uint256 rewardAmount, uint256 withdrawableAmount)
532     public
533     _before(withdrawStarts)
534     returns (bool) {
535         require(rewardAmount > 0, "Festaking: reward must be positive");
536         require(withdrawableAmount >= 0, "Festaking: withdrawable amount cannot be negative");
537         require(withdrawableAmount <= rewardAmount, "Festaking: withdrawable amount must be less than or equal to the reward amount");
538         address from = msg.sender;
539         if (!_payMe(from, rewardAmount, rewardTokenAddress)) {
540             return false;
541         }
542 
543         totalReward = totalReward.add(rewardAmount);
544         rewardBalance = totalReward;
545         earlyWithdrawReward = earlyWithdrawReward.add(withdrawableAmount);
546         return true;
547     }
548 
549     function stakeOf(address account) public view returns (uint256) {
550         return _stakes[account];
551     }
552 
553     /**
554     * Requirements:
555     * - `amount` Amount to be staked
556     */
557     function stake(uint256 amount)
558     public
559     _positive(amount)
560     _realAddress(msg.sender)
561     returns (bool) {
562         address from = msg.sender;
563         return _stake(from, amount);
564     }
565 
566     function withdraw(uint256 amount)
567     public
568     _after(withdrawStarts)
569     _positive(amount)
570     _realAddress(msg.sender)
571     returns (bool) {
572         address from = msg.sender;
573         require(amount <= _stakes[from], "Festaking: not enough balance");
574         if (now < withdrawEnds) {
575             return _withdrawEarly(from, amount);
576         } else {
577             return _withdrawAfterClose(from, amount);
578         }
579     }
580 
581     function _withdrawEarly(address from, uint256 amount)
582     private
583     _realAddress(from)
584     returns (bool) {
585         // This is the formula to calculate reward:
586         // r = (earlyWithdrawReward / stakedTotal) * (now - stakingEnds) / (withdrawEnds - stakingEnds)
587         // w = (1+r) * a
588         uint256 denom = (withdrawEnds.sub(stakingEnds)).mul(stakedTotal);
589         uint256 reward = (
590         ( (now.sub(stakingEnds)).mul(earlyWithdrawReward) ).mul(amount)
591         ).div(denom);
592         rewardBalance = rewardBalance.sub(reward);
593         stakedBalance = stakedBalance.sub(amount);
594         _stakes[from] = _stakes[from].sub(amount);
595         bool principalPaid = _payDirect(from, amount, tokenAddress);
596         bool rewardPaid = _payDirect(from, reward, rewardTokenAddress);
597         require(principalPaid && rewardPaid, "Festaking: error paying");
598         emit PaidOut(tokenAddress, rewardTokenAddress, from, amount, reward);
599         return true;
600     }
601 
602     function _withdrawAfterClose(address from, uint256 amount)
603     private
604     _realAddress(from)
605     returns (bool) {
606         uint256 reward = (rewardBalance.mul(amount)).div(stakedBalance);
607         _stakes[from] = _stakes[from].sub(amount);
608         bool principalPaid = _payDirect(from, amount, tokenAddress);
609         bool rewardPaid = _payDirect(from, reward, rewardTokenAddress);
610         require(principalPaid && rewardPaid, "Festaking: error paying");
611         emit PaidOut(tokenAddress, rewardTokenAddress, from, amount, reward);
612         return true;
613     }
614 
615     function _stake(address staker, uint256 amount)
616     private
617     _after(stakingStarts)
618     _before(stakingEnds)
619     _positive(amount)
620     returns (bool) {
621         // check the remaining amount to be staked
622         uint256 remaining = amount;
623         if (remaining > (stakingCap.sub(stakedBalance))) {
624             remaining = stakingCap.sub(stakedBalance);
625         }
626         // These requires are not necessary, because it will never happen, but won't hurt to double check
627         // this is because stakedTotal and stakedBalance are only modified in this method during the staking period
628         require(remaining > 0, "Festaking: Staking cap is filled");
629         require((remaining + stakedTotal) <= stakingCap, "Festaking: this will increase staking amount pass the cap");
630         if (!_payMe(staker, remaining, tokenAddress)) {
631             return false;
632         }
633         emit Staked(tokenAddress, staker, amount, remaining);
634 
635         // Transfer is completed
636         stakedBalance = stakedBalance.add(remaining);
637         stakedTotal = stakedTotal.add(remaining);
638         _stakes[staker] = _stakes[staker].add(remaining);
639         return true;
640     }
641 
642     function _payMe(address payer, uint256 amount, address token)
643     private
644     returns (bool) {
645         return _payTo(payer, address(this), amount, token);
646     }
647 
648     function _payTo(address allower, address receiver, uint256 amount, address token)
649     private
650     returns (bool) {
651         // Request to transfer amount from the contract to receiver.
652         // contract does not own the funds, so the allower must have added allowance to the contract
653         // Allower is the original owner.
654         ERC20Interface = IERC20(token);
655         ERC20Interface.safeTransferFrom(allower, receiver, amount);
656         return true;
657     }
658 
659     function _payDirect(address to, uint256 amount, address token)
660     private
661     returns (bool) {
662         if (amount == 0) {
663             return true;
664         }
665         ERC20Interface = IERC20(token);
666         ERC20Interface.safeTransfer(to, amount);
667         return true;
668     }
669 
670     modifier _realAddress(address addr) {
671         require(addr != address(0), "Festaking: zero address");
672         _;
673     }
674 
675     modifier _positive(uint256 amount) {
676         require(amount >= 0, "Festaking: negative amount");
677         _;
678     }
679 
680     modifier _after(uint eventTime) {
681         require(now >= eventTime, "Festaking: bad timing for the request");
682         _;
683     }
684 
685     modifier _before(uint eventTime) {
686         require(now < eventTime, "Festaking: bad timing for the request");
687         _;
688     }
689 }