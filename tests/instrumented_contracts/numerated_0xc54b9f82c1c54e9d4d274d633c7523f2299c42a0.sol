1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-24
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations with added overflow
15  * checks.
16  *
17  * Arithmetic operations in Solidity wrap on overflow. This can easily result
18  * in bugs, because programmers usually assume that an overflow raises an
19  * error, which is the standard behavior in high level programming languages.
20  * `SafeMath` restores this intuition by reverting the transaction when an
21  * operation overflows.
22  *
23  * Using this library instead of the unchecked operations eliminates an entire
24  * class of bugs, so it's recommended to use it always.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         uint256 c = a + b;
34         if (c < a) return (false, 0);
35         return (true, c);
36     }
37 
38     /**
39      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         if (b > a) return (false, 0);
45         return (true, a - b);
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57         if (a == 0) return (true, 0);
58         uint256 c = a * b;
59         if (c / a != b) return (false, 0);
60         return (true, c);
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         if (b == 0) return (false, 0);
70         return (true, a / b);
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         if (b == 0) return (false, 0);
80         return (true, a % b);
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b <= a, "SafeMath: subtraction overflow");
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         if (a == 0) return 0;
126         uint256 c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128         return c;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers, reverting on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         require(b > 0, "SafeMath: division by zero");
145         return a / b;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * reverting when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b > 0, "SafeMath: modulo by zero");
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {tryDiv}.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         return a / b;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 
225 
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP.
229  */
230 interface IERC20 {
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `recipient`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `sender` to `recipient` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 
302 
303 interface IStakingRewards {
304     // Views
305     function lastTimeRewardApplicable() external view returns (uint256);
306 
307     function rewardPerToken() external view returns (uint256);
308 
309     function earned(address account) external view returns (uint256);
310 
311     function getRewardForDuration() external view returns (uint256);
312 
313     function totalSupply() external view returns (uint256);
314 
315     function balanceOf(address account) external view returns (uint256);
316 
317     // Mutative
318 
319     function stake(uint256 amount) external;
320 
321     function withdraw(uint256 amount) external;
322 
323     function getReward() external;
324 
325     function exit() external;
326 }
327 
328 
329 
330 
331 
332 
333 
334 
335 
336 
337 /*
338  * @dev Provides information about the current execution context, including the
339  * sender of the transaction and its data. While these are generally available
340  * via msg.sender and msg.data, they should not be accessed in such a direct
341  * manner, since when dealing with GSN meta-transactions the account sending and
342  * paying for execution may not be the actual sender (as far as an application
343  * is concerned).
344  *
345  * This contract is only required for intermediate, library-like contracts.
346  */
347 abstract contract Context {
348     function _msgSender() internal view virtual returns (address payable) {
349         return msg.sender;
350     }
351 
352     function _msgData() internal view virtual returns (bytes memory) {
353         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
354         return msg.data;
355     }
356 }
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor () internal {
379         address msgSender = _msgSender();
380         _owner = msgSender;
381         emit OwnershipTransferred(address(0), msgSender);
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view virtual returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if called by any account other than the owner.
393      */
394     modifier onlyOwner() {
395         require(owner() == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         emit OwnershipTransferred(_owner, address(0));
408         _owner = address(0);
409     }
410 
411     /**
412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
413      * Can only be called by the current owner.
414      */
415     function transferOwnership(address newOwner) public virtual onlyOwner {
416         require(newOwner != address(0), "Ownable: new owner is the zero address");
417         emit OwnershipTransferred(_owner, newOwner);
418         _owner = newOwner;
419     }
420 }
421 
422 
423 
424 
425 
426 
427 
428 
429 /**
430  * @dev Standard math utilities missing in the Solidity language.
431  */
432 library Math {
433     /**
434      * @dev Returns the largest of two numbers.
435      */
436     function max(uint256 a, uint256 b) internal pure returns (uint256) {
437         return a >= b ? a : b;
438     }
439 
440     /**
441      * @dev Returns the smallest of two numbers.
442      */
443     function min(uint256 a, uint256 b) internal pure returns (uint256) {
444         return a < b ? a : b;
445     }
446 
447     /**
448      * @dev Returns the average of two numbers. The result is rounded towards
449      * zero.
450      */
451     function average(uint256 a, uint256 b) internal pure returns (uint256) {
452         // (a + b) / 2 can overflow, so we distribute
453         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
454     }
455 }
456 
457 
458 
459 
460 
461 
462 
463 
464 
465 
466 
467 
468 /**
469  * @dev Collection of functions related to the address type
470  */
471 library Address {
472     /**
473      * @dev Returns true if `account` is a contract.
474      *
475      * [IMPORTANT]
476      * ====
477      * It is unsafe to assume that an address for which this function returns
478      * false is an externally-owned account (EOA) and not a contract.
479      *
480      * Among others, `isContract` will return false for the following
481      * types of addresses:
482      *
483      *  - an externally-owned account
484      *  - a contract in construction
485      *  - an address where a contract will be created
486      *  - an address where a contract lived, but was destroyed
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // This method relies on extcodesize, which returns 0 for contracts in
491         // construction, since the code is only stored at the end of the
492         // constructor execution.
493 
494         uint256 size;
495         // solhint-disable-next-line no-inline-assembly
496         assembly { size := extcodesize(account) }
497         return size > 0;
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
520         (bool success, ) = recipient.call{ value: amount }("");
521         require(success, "Address: unable to send value, recipient may have reverted");
522     }
523 
524     /**
525      * @dev Performs a Solidity function call using a low level `call`. A
526      * plain`call` is an unsafe replacement for a function call: use this
527      * function instead.
528      *
529      * If `target` reverts with a revert reason, it is bubbled up by this
530      * function (like regular Solidity function calls).
531      *
532      * Returns the raw returned data. To convert to the expected return value,
533      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
534      *
535      * Requirements:
536      *
537      * - `target` must be a contract.
538      * - calling `target` with `data` must not revert.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
543       return functionCall(target, data, "Address: low-level call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
548      * `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
578         require(address(this).balance >= value, "Address: insufficient balance for call");
579         require(isContract(target), "Address: call to non-contract");
580 
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success, bytes memory returndata) = target.call{ value: value }(data);
583         return _verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return _verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return _verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
635         if (success) {
636             return returndata;
637         } else {
638             // Look for revert reason and bubble it up if present
639             if (returndata.length > 0) {
640                 // The easiest way to bubble the revert reason is using memory via assembly
641 
642                 // solhint-disable-next-line no-inline-assembly
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 
655 /**
656  * @title SafeERC20
657  * @dev Wrappers around ERC20 operations that throw on failure (when the token
658  * contract returns false). Tokens that return no value (and instead revert or
659  * throw on failure) are also supported, non-reverting calls are assumed to be
660  * successful.
661  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
662  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
663  */
664 library SafeERC20 {
665     using SafeMath for uint256;
666     using Address for address;
667 
668     function safeTransfer(IERC20 token, address to, uint256 value) internal {
669         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
670     }
671 
672     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
673         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
674     }
675 
676     /**
677      * @dev Deprecated. This function has issues similar to the ones found in
678      * {IERC20-approve}, and its usage is discouraged.
679      *
680      * Whenever possible, use {safeIncreaseAllowance} and
681      * {safeDecreaseAllowance} instead.
682      */
683     function safeApprove(IERC20 token, address spender, uint256 value) internal {
684         // safeApprove should only be called when setting an initial allowance,
685         // or when resetting it to zero. To increase and decrease it, use
686         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
687         // solhint-disable-next-line max-line-length
688         require((value == 0) || (token.allowance(address(this), spender) == 0),
689             "SafeERC20: approve from non-zero to non-zero allowance"
690         );
691         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
692     }
693 
694     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
695         uint256 newAllowance = token.allowance(address(this), spender).add(value);
696         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
697     }
698 
699     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
700         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
701         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702     }
703 
704     /**
705      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
706      * on the return value: the return value is optional (but if data is returned, it must not be false).
707      * @param token The token targeted by the call.
708      * @param data The call data (encoded using abi.encode or one of its variants).
709      */
710     function _callOptionalReturn(IERC20 token, bytes memory data) private {
711         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
712         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
713         // the target address contains contract code and also asserts for success in the low-level call.
714 
715         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
716         if (returndata.length > 0) { // Return data is optional
717             // solhint-disable-next-line max-line-length
718             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
719         }
720     }
721 }
722 
723 
724 
725 
726 
727 /**
728  * @dev Contract module that helps prevent reentrant calls to a function.
729  *
730  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
731  * available, which can be applied to functions to make sure there are no nested
732  * (reentrant) calls to them.
733  *
734  * Note that because there is a single `nonReentrant` guard, functions marked as
735  * `nonReentrant` may not call one another. This can be worked around by making
736  * those functions `private`, and then adding `external` `nonReentrant` entry
737  * points to them.
738  *
739  * TIP: If you would like to learn more about reentrancy and alternative ways
740  * to protect against it, check out our blog post
741  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
742  */
743 abstract contract ReentrancyGuard {
744     // Booleans are more expensive than uint256 or any type that takes up a full
745     // word because each write operation emits an extra SLOAD to first read the
746     // slot's contents, replace the bits taken up by the boolean, and then write
747     // back. This is the compiler's defense against contract upgrades and
748     // pointer aliasing, and it cannot be disabled.
749 
750     // The values being non-zero value makes deployment a bit more expensive,
751     // but in exchange the refund on every call to nonReentrant will be lower in
752     // amount. Since refunds are capped to a percentage of the total
753     // transaction's gas, it is best to keep them low in cases like this one, to
754     // increase the likelihood of the full refund coming into effect.
755     uint256 private constant _NOT_ENTERED = 1;
756     uint256 private constant _ENTERED = 2;
757 
758     uint256 private _status;
759 
760     constructor () internal {
761         _status = _NOT_ENTERED;
762     }
763 
764     /**
765      * @dev Prevents a contract from calling itself, directly or indirectly.
766      * Calling a `nonReentrant` function from another `nonReentrant`
767      * function is not supported. It is possible to prevent this from happening
768      * by making the `nonReentrant` function external, and make it call a
769      * `private` function that does the actual work.
770      */
771     modifier nonReentrant() {
772         // On the first call to nonReentrant, _notEntered will be true
773         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
774 
775         // Any calls to nonReentrant after this point will fail
776         _status = _ENTERED;
777 
778         _;
779 
780         // By storing the original value once again, a refund is triggered (see
781         // https://eips.ethereum.org/EIPS/eip-2200)
782         _status = _NOT_ENTERED;
783     }
784 }
785 
786 
787 // Inheritance
788 
789 
790 
791 abstract contract RewardsDistributionRecipient {
792     address public rewardsDistribution;
793 
794     function notifyRewardAmount(uint256 reward) external virtual;
795 
796     modifier onlyRewardsDistribution() {
797         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
798         _;
799     }
800 }
801 
802 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
803     using SafeMath for uint256;
804     using SafeERC20 for IERC20;
805 
806     /* ========== STATE VARIABLES ========== */
807 
808     IERC20 public rewardsToken;
809     IERC20 public stakingToken;
810     uint256 public periodFinish = 0;
811     uint256 public rewardRate = 0;
812     uint256 public rewardsDuration = 135 days;
813     uint256 public lastUpdateTime;
814     uint256 public rewardPerTokenStored;
815 
816     mapping(address => uint256) public userRewardPerTokenPaid;
817     mapping(address => uint256) public rewards;
818 
819     uint256 private _totalSupply;
820     mapping(address => uint256) private _balances;
821 
822     /* ========== CONSTRUCTOR ========== */
823 
824     constructor(
825         address _rewardsDistribution,
826         address _rewardsToken,
827         address _stakingToken
828     ) {
829         rewardsToken = IERC20(_rewardsToken);
830         stakingToken = IERC20(_stakingToken);
831         rewardsDistribution = _rewardsDistribution;
832     }
833 
834     /* ========== VIEWS ========== */
835 
836     function totalSupply() external view override returns (uint256) {
837         return _totalSupply;
838     }
839 
840     function balanceOf(address account) external view override returns (uint256) {
841         return _balances[account];
842     }
843 
844     function lastTimeRewardApplicable() public view override returns (uint256) {
845         return Math.min(block.timestamp, periodFinish);
846     }
847 
848     function rewardPerToken() public view override returns (uint256) {
849         if (_totalSupply == 0) {
850             return rewardPerTokenStored;
851         }
852         return
853             rewardPerTokenStored.add(
854                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
855             );
856     }
857 
858     function earned(address account) public view override returns (uint256) {
859         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
860     }
861 
862     function getRewardForDuration() external view override returns (uint256) {
863         return rewardRate.mul(rewardsDuration);
864     }
865 
866     /* ========== MUTATIVE FUNCTIONS ========== */
867 
868     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
869         require(amount > 0, "Cannot stake 0");
870         _totalSupply = _totalSupply.add(amount);
871         _balances[msg.sender] = _balances[msg.sender].add(amount);
872 
873         // permit
874         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
875 
876         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
877         emit Staked(msg.sender, amount);
878     }
879 
880     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
881         require(amount > 0, "Cannot stake 0");
882         _totalSupply = _totalSupply.add(amount);
883         _balances[msg.sender] = _balances[msg.sender].add(amount);
884         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
885         emit Staked(msg.sender, amount);
886     }
887 
888     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
889         require(amount > 0, "Cannot withdraw 0");
890         _totalSupply = _totalSupply.sub(amount);
891         _balances[msg.sender] = _balances[msg.sender].sub(amount);
892         stakingToken.safeTransfer(msg.sender, amount);
893         emit Withdrawn(msg.sender, amount);
894     }
895 
896     function getReward() public override nonReentrant updateReward(msg.sender) {
897         uint256 reward = rewards[msg.sender];
898         if (reward > 0) {
899             rewards[msg.sender] = 0;
900             rewardsToken.safeTransfer(msg.sender, reward);
901             emit RewardPaid(msg.sender, reward);
902         }
903     }
904 
905     function exit() external override {
906         withdraw(_balances[msg.sender]);
907         getReward();
908     }
909 
910     /* ========== RESTRICTED FUNCTIONS ========== */
911 
912     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
913         if (block.timestamp >= periodFinish) {
914             rewardRate = reward.div(rewardsDuration);
915         } else {
916             uint256 remaining = periodFinish.sub(block.timestamp);
917             uint256 leftover = remaining.mul(rewardRate);
918             rewardRate = reward.add(leftover).div(rewardsDuration);
919         }
920 
921         // Ensure the provided reward amount is not more than the balance in the contract.
922         // This keeps the reward rate in the right range, preventing overflows due to
923         // very high values of rewardRate in the earned and rewardsPerToken functions;
924         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
925         uint balance = rewardsToken.balanceOf(address(this));
926         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
927 
928         lastUpdateTime = block.timestamp;
929         periodFinish = block.timestamp.add(rewardsDuration);
930         emit RewardAdded(reward);
931     }
932 
933     /* ========== MODIFIERS ========== */
934 
935     modifier updateReward(address account) {
936         rewardPerTokenStored = rewardPerToken();
937         lastUpdateTime = lastTimeRewardApplicable();
938         if (account != address(0)) {
939             rewards[account] = earned(account);
940             userRewardPerTokenPaid[account] = rewardPerTokenStored;
941         }
942         _;
943     }
944 
945     /* ========== EVENTS ========== */
946 
947     event RewardAdded(uint256 reward);
948     event Staked(address indexed user, uint256 amount);
949     event Withdrawn(address indexed user, uint256 amount);
950     event RewardPaid(address indexed user, uint256 reward);
951 }
952 
953 interface IUniswapV2ERC20 {
954     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
955 }