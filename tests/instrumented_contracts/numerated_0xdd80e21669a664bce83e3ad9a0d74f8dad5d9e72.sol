1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 
217 
218 
219 /**
220  * @dev Interface of the ERC20 standard as defined in the EIP.
221  */
222 interface IERC20 {
223     /**
224      * @dev Returns the amount of tokens in existence.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     /**
229      * @dev Returns the amount of tokens owned by `account`.
230      */
231     function balanceOf(address account) external view returns (uint256);
232 
233     /**
234      * @dev Moves `amount` tokens from the caller's account to `recipient`.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transfer(address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Returns the remaining number of tokens that `spender` will be
244      * allowed to spend on behalf of `owner` through {transferFrom}. This is
245      * zero by default.
246      *
247      * This value changes when {approve} or {transferFrom} are called.
248      */
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     /**
252      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * IMPORTANT: Beware that changing an allowance with this method brings the risk
257      * that someone may use both the old and the new allowance by unfortunate
258      * transaction ordering. One possible solution to mitigate this race
259      * condition is to first reduce the spender's allowance to 0 and set the
260      * desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      *
263      * Emits an {Approval} event.
264      */
265     function approve(address spender, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Moves `amount` tokens from `sender` to `recipient` using the
269      * allowance mechanism. `amount` is then deducted from the caller's
270      * allowance.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to {approve}. `value` is the new allowance.
289      */
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291 }
292 
293 
294 
295 interface IStakingRewards {
296     // Views
297     function lastTimeRewardApplicable() external view returns (uint256);
298 
299     function rewardPerToken() external view returns (uint256);
300 
301     function earned(address account) external view returns (uint256);
302 
303     function getRewardForDuration() external view returns (uint256);
304 
305     function totalSupply() external view returns (uint256);
306 
307     function balanceOf(address account) external view returns (uint256);
308 
309     // Mutative
310 
311     function stake(uint256 amount) external;
312 
313     function withdraw(uint256 amount) external;
314 
315     function getReward() external;
316 
317     function exit() external;
318 }
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 
329 /*
330  * @dev Provides information about the current execution context, including the
331  * sender of the transaction and its data. While these are generally available
332  * via msg.sender and msg.data, they should not be accessed in such a direct
333  * manner, since when dealing with GSN meta-transactions the account sending and
334  * paying for execution may not be the actual sender (as far as an application
335  * is concerned).
336  *
337  * This contract is only required for intermediate, library-like contracts.
338  */
339 abstract contract Context {
340     function _msgSender() internal view virtual returns (address payable) {
341         return msg.sender;
342     }
343 
344     function _msgData() internal view virtual returns (bytes memory) {
345         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
346         return msg.data;
347     }
348 }
349 
350 /**
351  * @dev Contract module which provides a basic access control mechanism, where
352  * there is an account (an owner) that can be granted exclusive access to
353  * specific functions.
354  *
355  * By default, the owner account will be the one that deploys the contract. This
356  * can later be changed with {transferOwnership}.
357  *
358  * This module is used through inheritance. It will make available the modifier
359  * `onlyOwner`, which can be applied to your functions to restrict their use to
360  * the owner.
361  */
362 abstract contract Ownable is Context {
363     address private _owner;
364 
365     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     constructor () internal {
371         address msgSender = _msgSender();
372         _owner = msgSender;
373         emit OwnershipTransferred(address(0), msgSender);
374     }
375 
376     /**
377      * @dev Returns the address of the current owner.
378      */
379     function owner() public view virtual returns (address) {
380         return _owner;
381     }
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
388         _;
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public virtual onlyOwner {
399         emit OwnershipTransferred(_owner, address(0));
400         _owner = address(0);
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public virtual onlyOwner {
408         require(newOwner != address(0), "Ownable: new owner is the zero address");
409         emit OwnershipTransferred(_owner, newOwner);
410         _owner = newOwner;
411     }
412 }
413 
414 
415 
416 
417 
418 
419 
420 
421 /**
422  * @dev Standard math utilities missing in the Solidity language.
423  */
424 library Math {
425     /**
426      * @dev Returns the largest of two numbers.
427      */
428     function max(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a >= b ? a : b;
430     }
431 
432     /**
433      * @dev Returns the smallest of two numbers.
434      */
435     function min(uint256 a, uint256 b) internal pure returns (uint256) {
436         return a < b ? a : b;
437     }
438 
439     /**
440      * @dev Returns the average of two numbers. The result is rounded towards
441      * zero.
442      */
443     function average(uint256 a, uint256 b) internal pure returns (uint256) {
444         // (a + b) / 2 can overflow, so we distribute
445         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
446     }
447 }
448 
449 
450 
451 
452 
453 
454 
455 
456 
457 
458 
459 
460 /**
461  * @dev Collection of functions related to the address type
462  */
463 library Address {
464     /**
465      * @dev Returns true if `account` is a contract.
466      *
467      * [IMPORTANT]
468      * ====
469      * It is unsafe to assume that an address for which this function returns
470      * false is an externally-owned account (EOA) and not a contract.
471      *
472      * Among others, `isContract` will return false for the following
473      * types of addresses:
474      *
475      *  - an externally-owned account
476      *  - a contract in construction
477      *  - an address where a contract will be created
478      *  - an address where a contract lived, but was destroyed
479      * ====
480      */
481     function isContract(address account) internal view returns (bool) {
482         // This method relies on extcodesize, which returns 0 for contracts in
483         // construction, since the code is only stored at the end of the
484         // constructor execution.
485 
486         uint256 size;
487         // solhint-disable-next-line no-inline-assembly
488         assembly { size := extcodesize(account) }
489         return size > 0;
490     }
491 
492     /**
493      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
494      * `recipient`, forwarding all available gas and reverting on errors.
495      *
496      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
497      * of certain opcodes, possibly making contracts go over the 2300 gas limit
498      * imposed by `transfer`, making them unable to receive funds via
499      * `transfer`. {sendValue} removes this limitation.
500      *
501      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
502      *
503      * IMPORTANT: because control is transferred to `recipient`, care must be
504      * taken to not create reentrancy vulnerabilities. Consider using
505      * {ReentrancyGuard} or the
506      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
507      */
508     function sendValue(address payable recipient, uint256 amount) internal {
509         require(address(this).balance >= amount, "Address: insufficient balance");
510 
511         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
512         (bool success, ) = recipient.call{ value: amount }("");
513         require(success, "Address: unable to send value, recipient may have reverted");
514     }
515 
516     /**
517      * @dev Performs a Solidity function call using a low level `call`. A
518      * plain`call` is an unsafe replacement for a function call: use this
519      * function instead.
520      *
521      * If `target` reverts with a revert reason, it is bubbled up by this
522      * function (like regular Solidity function calls).
523      *
524      * Returns the raw returned data. To convert to the expected return value,
525      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
526      *
527      * Requirements:
528      *
529      * - `target` must be a contract.
530      * - calling `target` with `data` must not revert.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
535       return functionCall(target, data, "Address: low-level call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
540      * `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
565      * with `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
570         require(address(this).balance >= value, "Address: insufficient balance for call");
571         require(isContract(target), "Address: call to non-contract");
572 
573         // solhint-disable-next-line avoid-low-level-calls
574         (bool success, bytes memory returndata) = target.call{ value: value }(data);
575         return _verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
585         return functionStaticCall(target, data, "Address: low-level static call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         // solhint-disable-next-line avoid-low-level-calls
598         (bool success, bytes memory returndata) = target.staticcall(data);
599         return _verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
609         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
619         require(isContract(target), "Address: delegate call to non-contract");
620 
621         // solhint-disable-next-line avoid-low-level-calls
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return _verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
627         if (success) {
628             return returndata;
629         } else {
630             // Look for revert reason and bubble it up if present
631             if (returndata.length > 0) {
632                 // The easiest way to bubble the revert reason is using memory via assembly
633 
634                 // solhint-disable-next-line no-inline-assembly
635                 assembly {
636                     let returndata_size := mload(returndata)
637                     revert(add(32, returndata), returndata_size)
638                 }
639             } else {
640                 revert(errorMessage);
641             }
642         }
643     }
644 }
645 
646 
647 /**
648  * @title SafeERC20
649  * @dev Wrappers around ERC20 operations that throw on failure (when the token
650  * contract returns false). Tokens that return no value (and instead revert or
651  * throw on failure) are also supported, non-reverting calls are assumed to be
652  * successful.
653  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
654  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
655  */
656 library SafeERC20 {
657     using SafeMath for uint256;
658     using Address for address;
659 
660     function safeTransfer(IERC20 token, address to, uint256 value) internal {
661         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
662     }
663 
664     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
665         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
666     }
667 
668     /**
669      * @dev Deprecated. This function has issues similar to the ones found in
670      * {IERC20-approve}, and its usage is discouraged.
671      *
672      * Whenever possible, use {safeIncreaseAllowance} and
673      * {safeDecreaseAllowance} instead.
674      */
675     function safeApprove(IERC20 token, address spender, uint256 value) internal {
676         // safeApprove should only be called when setting an initial allowance,
677         // or when resetting it to zero. To increase and decrease it, use
678         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
679         // solhint-disable-next-line max-line-length
680         require((value == 0) || (token.allowance(address(this), spender) == 0),
681             "SafeERC20: approve from non-zero to non-zero allowance"
682         );
683         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
684     }
685 
686     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
687         uint256 newAllowance = token.allowance(address(this), spender).add(value);
688         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
689     }
690 
691     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
692         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
693         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
694     }
695 
696     /**
697      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
698      * on the return value: the return value is optional (but if data is returned, it must not be false).
699      * @param token The token targeted by the call.
700      * @param data The call data (encoded using abi.encode or one of its variants).
701      */
702     function _callOptionalReturn(IERC20 token, bytes memory data) private {
703         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
704         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
705         // the target address contains contract code and also asserts for success in the low-level call.
706 
707         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
708         if (returndata.length > 0) { // Return data is optional
709             // solhint-disable-next-line max-line-length
710             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
711         }
712     }
713 }
714 
715 
716 
717 
718 
719 /**
720  * @dev Contract module that helps prevent reentrant calls to a function.
721  *
722  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
723  * available, which can be applied to functions to make sure there are no nested
724  * (reentrant) calls to them.
725  *
726  * Note that because there is a single `nonReentrant` guard, functions marked as
727  * `nonReentrant` may not call one another. This can be worked around by making
728  * those functions `private`, and then adding `external` `nonReentrant` entry
729  * points to them.
730  *
731  * TIP: If you would like to learn more about reentrancy and alternative ways
732  * to protect against it, check out our blog post
733  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
734  */
735 abstract contract ReentrancyGuard {
736     // Booleans are more expensive than uint256 or any type that takes up a full
737     // word because each write operation emits an extra SLOAD to first read the
738     // slot's contents, replace the bits taken up by the boolean, and then write
739     // back. This is the compiler's defense against contract upgrades and
740     // pointer aliasing, and it cannot be disabled.
741 
742     // The values being non-zero value makes deployment a bit more expensive,
743     // but in exchange the refund on every call to nonReentrant will be lower in
744     // amount. Since refunds are capped to a percentage of the total
745     // transaction's gas, it is best to keep them low in cases like this one, to
746     // increase the likelihood of the full refund coming into effect.
747     uint256 private constant _NOT_ENTERED = 1;
748     uint256 private constant _ENTERED = 2;
749 
750     uint256 private _status;
751 
752     constructor () internal {
753         _status = _NOT_ENTERED;
754     }
755 
756     /**
757      * @dev Prevents a contract from calling itself, directly or indirectly.
758      * Calling a `nonReentrant` function from another `nonReentrant`
759      * function is not supported. It is possible to prevent this from happening
760      * by making the `nonReentrant` function external, and make it call a
761      * `private` function that does the actual work.
762      */
763     modifier nonReentrant() {
764         // On the first call to nonReentrant, _notEntered will be true
765         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
766 
767         // Any calls to nonReentrant after this point will fail
768         _status = _ENTERED;
769 
770         _;
771 
772         // By storing the original value once again, a refund is triggered (see
773         // https://eips.ethereum.org/EIPS/eip-2200)
774         _status = _NOT_ENTERED;
775     }
776 }
777 
778 
779 // Inheritance
780 
781 
782 
783 abstract contract RewardsDistributionRecipient {
784     address public rewardsDistribution;
785 
786     function notifyRewardAmount(uint256 reward) external virtual;
787 
788     modifier onlyRewardsDistribution() {
789         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
790         _;
791     }
792 }
793 
794 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
795     using SafeMath for uint256;
796     using SafeERC20 for IERC20;
797 
798     /* ========== STATE VARIABLES ========== */
799 
800     IERC20 public rewardsToken;
801     IERC20 public stakingToken;
802     uint256 public periodFinish = 0;
803     uint256 public rewardRate = 0;
804     uint256 public rewardsDuration = 90 days;
805     uint256 public lastUpdateTime;
806     uint256 public rewardPerTokenStored;
807 
808     mapping(address => uint256) public userRewardPerTokenPaid;
809     mapping(address => uint256) public rewards;
810 
811     uint256 private _totalSupply;
812     mapping(address => uint256) private _balances;
813 
814     /* ========== CONSTRUCTOR ========== */
815 
816     constructor(
817         address _rewardsDistribution,
818         address _rewardsToken,
819         address _stakingToken
820     ) {
821         rewardsToken = IERC20(_rewardsToken);
822         stakingToken = IERC20(_stakingToken);
823         rewardsDistribution = _rewardsDistribution;
824     }
825 
826     /* ========== VIEWS ========== */
827 
828     function totalSupply() external view override returns (uint256) {
829         return _totalSupply;
830     }
831 
832     function balanceOf(address account) external view override returns (uint256) {
833         return _balances[account];
834     }
835 
836     function lastTimeRewardApplicable() public view override returns (uint256) {
837         return Math.min(block.timestamp, periodFinish);
838     }
839 
840     function rewardPerToken() public view override returns (uint256) {
841         if (_totalSupply == 0) {
842             return rewardPerTokenStored;
843         }
844         return
845             rewardPerTokenStored.add(
846                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
847             );
848     }
849 
850     function earned(address account) public view override returns (uint256) {
851         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
852     }
853 
854     function getRewardForDuration() external view override returns (uint256) {
855         return rewardRate.mul(rewardsDuration);
856     }
857 
858     /* ========== MUTATIVE FUNCTIONS ========== */
859 
860     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
861         require(amount > 0, "Cannot stake 0");
862         _totalSupply = _totalSupply.add(amount);
863         _balances[msg.sender] = _balances[msg.sender].add(amount);
864 
865         // permit
866         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
867 
868         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
869         emit Staked(msg.sender, amount);
870     }
871 
872     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
873         require(amount > 0, "Cannot stake 0");
874         _totalSupply = _totalSupply.add(amount);
875         _balances[msg.sender] = _balances[msg.sender].add(amount);
876         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
877         emit Staked(msg.sender, amount);
878     }
879 
880     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
881         require(amount > 0, "Cannot withdraw 0");
882         _totalSupply = _totalSupply.sub(amount);
883         _balances[msg.sender] = _balances[msg.sender].sub(amount);
884         stakingToken.safeTransfer(msg.sender, amount);
885         emit Withdrawn(msg.sender, amount);
886     }
887 
888     function getReward() public override nonReentrant updateReward(msg.sender) {
889         uint256 reward = rewards[msg.sender];
890         if (reward > 0) {
891             rewards[msg.sender] = 0;
892             rewardsToken.safeTransfer(msg.sender, reward);
893             emit RewardPaid(msg.sender, reward);
894         }
895     }
896 
897     function exit() external override {
898         withdraw(_balances[msg.sender]);
899         getReward();
900     }
901 
902     /* ========== RESTRICTED FUNCTIONS ========== */
903 
904     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
905         if (block.timestamp >= periodFinish) {
906             rewardRate = reward.div(rewardsDuration);
907         } else {
908             uint256 remaining = periodFinish.sub(block.timestamp);
909             uint256 leftover = remaining.mul(rewardRate);
910             rewardRate = reward.add(leftover).div(rewardsDuration);
911         }
912 
913         // Ensure the provided reward amount is not more than the balance in the contract.
914         // This keeps the reward rate in the right range, preventing overflows due to
915         // very high values of rewardRate in the earned and rewardsPerToken functions;
916         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
917         uint balance = rewardsToken.balanceOf(address(this));
918         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
919 
920         lastUpdateTime = block.timestamp;
921         periodFinish = block.timestamp.add(rewardsDuration);
922         emit RewardAdded(reward);
923     }
924 
925     /* ========== MODIFIERS ========== */
926 
927     modifier updateReward(address account) {
928         rewardPerTokenStored = rewardPerToken();
929         lastUpdateTime = lastTimeRewardApplicable();
930         if (account != address(0)) {
931             rewards[account] = earned(account);
932             userRewardPerTokenPaid[account] = rewardPerTokenStored;
933         }
934         _;
935     }
936 
937     /* ========== EVENTS ========== */
938 
939     event RewardAdded(uint256 reward);
940     event Staked(address indexed user, uint256 amount);
941     event Withdrawn(address indexed user, uint256 amount);
942     event RewardPaid(address indexed user, uint256 reward);
943 }
944 
945 interface IUniswapV2ERC20 {
946     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
947 }