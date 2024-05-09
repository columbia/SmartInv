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
217 interface IERC20 {
218     /**
219      * @dev Returns the amount of tokens in existence.
220      */
221     function totalSupply() external view returns (uint256);
222 
223     /**
224      * @dev Returns the token decimals.
225      */
226     function decimals() external view returns (uint8);
227 
228     /**
229      * @dev Returns the token symbol.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the token name.
235      */
236     function name() external view returns (string memory);
237 
238     /**
239      * @dev Returns the ERC token owner.
240      */
241     function getOwner() external view returns (address);
242 
243     /**
244      * @dev Returns the amount of tokens owned by `account`.
245      */
246     function balanceOf(address account) external view returns (uint256);
247 
248     /**
249      * @dev Moves `amount` tokens from the caller's account to `recipient`.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transfer(address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Returns the remaining number of tokens that `spender` will be
259      * allowed to spend on behalf of `owner` through {transferFrom}. This is
260      * zero by default.
261      *
262      * This value changes when {approve} or {transferFrom} are called.
263      */
264     function allowance(address _owner, address spender) external view returns (uint256);
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * IMPORTANT: Beware that changing an allowance with this method brings the risk
272      * that someone may use both the old and the new allowance by unfortunate
273      * transaction ordering. One possible solution to mitigate this race
274      * condition is to first reduce the spender's allowance to 0 and set the
275      * desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      *
278      * Emits an {Approval} event.
279      */
280     function approve(address spender, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Moves `amount` tokens from `sender` to `recipient` using the
284      * allowance mechanism. `amount` is then deducted from the caller's
285      * allowance.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) external returns (bool);
296 
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 library Address {
313     /**
314      * @dev Returns true if `account` is a contract.
315      *
316      * [IMPORTANT]
317      * ====
318      * It is unsafe to assume that an address for which this function returns
319      * false is an externally-owned account (EOA) and not a contract.
320      *
321      * Among others, `isContract` will return false for the following
322      * types of addresses:
323      *
324      *  - an externally-owned account
325      *  - a contract in construction
326      *  - an address where a contract will be created
327      *  - an address where a contract lived, but was destroyed
328      * ====
329      */
330     function isContract(address account) internal view returns (bool) {
331         // This method relies on extcodesize, which returns 0 for contracts in
332         // construction, since the code is only stored at the end of the
333         // constructor execution.
334 
335         uint256 size;
336         // solhint-disable-next-line no-inline-assembly
337         assembly { size := extcodesize(account) }
338         return size > 0;
339     }
340 
341     /**
342      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
343      * `recipient`, forwarding all available gas and reverting on errors.
344      *
345      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
346      * of certain opcodes, possibly making contracts go over the 2300 gas limit
347      * imposed by `transfer`, making them unable to receive funds via
348      * `transfer`. {sendValue} removes this limitation.
349      *
350      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
351      *
352      * IMPORTANT: because control is transferred to `recipient`, care must be
353      * taken to not create reentrancy vulnerabilities. Consider using
354      * {ReentrancyGuard} or the
355      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
356      */
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
361         (bool success, ) = recipient.call{ value: amount }("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain`call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384       return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         // solhint-disable-next-line avoid-low-level-calls
423         (bool success, bytes memory returndata) = target.call{ value: value }(data);
424         return _verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.staticcall(data);
448         return _verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
468         require(isContract(target), "Address: delegate call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 // solhint-disable-next-line no-inline-assembly
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(
509         IERC20 token,
510         address to,
511         uint256 value
512     ) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(
517         IERC20 token,
518         address from,
519         address to,
520         uint256 value
521     ) internal {
522         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
523     }
524 
525     /**
526      * @dev Deprecated. This function has issues similar to the ones found in
527      * {IERC20-approve}, and its usage is discouraged.
528      *
529      * Whenever possible, use {safeIncreaseAllowance} and
530      * {safeDecreaseAllowance} instead.
531      */
532     function safeApprove(
533         IERC20 token,
534         address spender,
535         uint256 value
536     ) internal {
537         // safeApprove should only be called when setting an initial allowance,
538         // or when resetting it to zero. To increase and decrease it, use
539         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
540         // solhint-disable-next-line max-line-length
541         require(
542             (value == 0) || (token.allowance(address(this), spender) == 0),
543             "SafeERC20: approve from non-zero to non-zero allowance"
544         );
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
546     }
547 
548     function safeIncreaseAllowance(
549         IERC20 token,
550         address spender,
551         uint256 value
552     ) internal {
553         uint256 newAllowance = token.allowance(address(this), spender).add(value);
554         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
555     }
556 
557     function safeDecreaseAllowance(
558         IERC20 token,
559         address spender,
560         uint256 value
561     ) internal {
562         uint256 newAllowance = token.allowance(address(this), spender).sub(
563             value,
564             "SafeERC20: decreased allowance below zero"
565         );
566         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
567     }
568 
569     /**
570      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
571      * on the return value: the return value is optional (but if data is returned, it must not be false).
572      * @param token The token targeted by the call.
573      * @param data The call data (encoded using abi.encode or one of its variants).
574      */
575     function _callOptionalReturn(IERC20 token, bytes memory data) private {
576         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
577         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
578         // the target address contains contract code and also asserts for success in the low-level call.
579 
580         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
581         if (returndata.length > 0) {
582             // Return data is optional
583             // solhint-disable-next-line max-line-length
584             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
585         }
586     }
587 }
588 
589 interface ITokenReferral {
590     /**
591      * @dev Record referral.
592      */
593     function recordReferral(address user, address referrer) external;
594 
595     /**
596      * @dev Record referral commission.
597      */
598     function recordReferralCommission(address referrer, uint256 commission) external;
599 
600     /**
601      * @dev Get the referrer address that referred the user.
602      */
603     function getReferrer(address user) external view returns (address);
604 }
605 
606 /*
607  * @dev Provides information about the current execution context, including the
608  * sender of the transaction and its data. While these are generally available
609  * via msg.sender and msg.data, they should not be accessed in such a direct
610  * manner, since when dealing with GSN meta-transactions the account sending and
611  * paying for execution may not be the actual sender (as far as an application
612  * is concerned).
613  *
614  * This contract is only required for intermediate, library-like contracts.
615  */
616 abstract contract Context {
617     function _msgSender() internal view virtual returns (address payable) {
618         return msg.sender;
619     }
620 
621     function _msgData() internal view virtual returns (bytes memory) {
622         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
623         return msg.data;
624     }
625 }
626 
627 /**
628  * @dev Contract module which provides a basic access control mechanism, where
629  * there is an account (an owner) that can be granted exclusive access to
630  * specific functions.
631  *
632  * By default, the owner account will be the one that deploys the contract. This
633  * can later be changed with {transferOwnership}.
634  *
635  * This module is used through inheritance. It will make available the modifier
636  * `onlyOwner`, which can be applied to your functions to restrict their use to
637  * the owner.
638  */
639 abstract contract Ownable is Context {
640     address private _owner;
641 
642     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
643 
644     /**
645      * @dev Initializes the contract setting the deployer as the initial owner.
646      */
647     constructor () internal {
648         address msgSender = _msgSender();
649         _owner = msgSender;
650         emit OwnershipTransferred(address(0), msgSender);
651     }
652 
653     /**
654      * @dev Returns the address of the current owner.
655      */
656     function owner() public view virtual returns (address) {
657         return _owner;
658     }
659 
660     /**
661      * @dev Throws if called by any account other than the owner.
662      */
663     modifier onlyOwner() {
664         require(owner() == _msgSender(), "Ownable: caller is not the owner");
665         _;
666     }
667 
668     /**
669      * @dev Leaves the contract without owner. It will not be possible to call
670      * `onlyOwner` functions anymore. Can only be called by the current owner.
671      *
672      * NOTE: Renouncing ownership will leave the contract without an owner,
673      * thereby removing any functionality that is only available to the owner.
674      */
675     function renounceOwnership() public virtual onlyOwner {
676         emit OwnershipTransferred(_owner, address(0));
677         _owner = address(0);
678     }
679 
680     /**
681      * @dev Transfers ownership of the contract to a new account (`newOwner`).
682      * Can only be called by the current owner.
683      */
684     function transferOwnership(address newOwner) public virtual onlyOwner {
685         require(newOwner != address(0), "Ownable: new owner is the zero address");
686         emit OwnershipTransferred(_owner, newOwner);
687         _owner = newOwner;
688     }
689 }
690 
691 /**
692  * @dev Contract module that helps prevent reentrant calls to a function.
693  *
694  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
695  * available, which can be applied to functions to make sure there are no nested
696  * (reentrant) calls to them.
697  *
698  * Note that because there is a single `nonReentrant` guard, functions marked as
699  * `nonReentrant` may not call one another. This can be worked around by making
700  * those functions `private`, and then adding `external` `nonReentrant` entry
701  * points to them.
702  *
703  * TIP: If you would like to learn more about reentrancy and alternative ways
704  * to protect against it, check out our blog post
705  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
706  */
707 abstract contract ReentrancyGuard {
708     // Booleans are more expensive than uint256 or any type that takes up a full
709     // word because each write operation emits an extra SLOAD to first read the
710     // slot's contents, replace the bits taken up by the boolean, and then write
711     // back. This is the compiler's defense against contract upgrades and
712     // pointer aliasing, and it cannot be disabled.
713 
714     // The values being non-zero value makes deployment a bit more expensive,
715     // but in exchange the refund on every call to nonReentrant will be lower in
716     // amount. Since refunds are capped to a percentage of the total
717     // transaction's gas, it is best to keep them low in cases like this one, to
718     // increase the likelihood of the full refund coming into effect.
719     uint256 private constant _NOT_ENTERED = 1;
720     uint256 private constant _ENTERED = 2;
721 
722     uint256 private _status;
723 
724     constructor () internal {
725         _status = _NOT_ENTERED;
726     }
727 
728     /**
729      * @dev Prevents a contract from calling itself, directly or indirectly.
730      * Calling a `nonReentrant` function from another `nonReentrant`
731      * function is not supported. It is possible to prevent this from happening
732      * by making the `nonReentrant` function external, and make it call a
733      * `private` function that does the actual work.
734      */
735     modifier nonReentrant() {
736         // On the first call to nonReentrant, _notEntered will be true
737         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
738 
739         // Any calls to nonReentrant after this point will fail
740         _status = _ENTERED;
741 
742         _;
743 
744         // By storing the original value once again, a refund is triggered (see
745         // https://eips.ethereum.org/EIPS/eip-2200)
746         _status = _NOT_ENTERED;
747     }
748 }
749 
750 contract ArchieIunStakingAndFarming is Ownable, ReentrancyGuard {
751     using SafeMath for uint256;
752     using SafeERC20 for IERC20;
753 
754     // Info of each user.
755     struct UserInfo {
756         uint256 amount;         // How many LP tokens the user has provided.
757         uint256 rewardDebt;     // Reward debt. See explanation below.
758         uint256 rewardLockedUp;  // Reward locked up.
759         uint256 nextHarvestUntil; // When can the user harvest again.
760         uint256 lastDepositTime; // when user deposited
761 
762         //
763         // We do some fancy math here. Basically, any point in time, the amount of Archieneko
764         // entitled to a user but is pending to be distributed is:
765         //
766         //   pending reward = (user.amount * pool.accTokenPerShare) - user.rewardDebt
767         //
768         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
769         //   1. The pool's `accTokenPerShare` (and `lastRewardBlock`) gets updated.
770         //   2. User receives the pending reward sent to his/her address.
771         //   3. User's `amount` gets updated.
772         //   4. User's `rewardDebt` gets updated.
773     }
774 
775     // Info of each pool.
776     struct PoolInfo {
777         IERC20 lpToken;             // Address of LP token contract.
778         uint256 allocPoint;         // How many allocation points assigned to this pool. Archieneko to distribute per block.
779         uint256 lastRewardBlock;    // Last block number that Archieneko distribution occurs.
780         uint256 accTokenPerShare;   // Accumulated Archieneko per share, times 1e12. See below.
781         uint16 depositFeeBP;
782         uint16 emergencyWithdrawFeeBP;        // Deposit fee in basis points
783         uint256 harvestInterval;    // Harvest interval in seconds
784         uint256 withdrawLockPeriod; // lock period for this pool
785         uint256 balance;            // pool token balance, allow multiple pools with same token
786     }
787 
788     // The ArchieInu TOKEN!
789     IERC20 public token;
790     // Dev address.
791     address public devAddress;
792     // Deposit Fee address
793     address public feeAddress;
794     // Archieneko tokens created per block.
795     uint256 public tokenPerBlock;
796     // Bonus muliplier for early token makers.
797     uint256 public constant BONUS_MULTIPLIER = 1;
798 
799     // Info of each pool.
800     PoolInfo[] public poolInfo;
801     // Info of each user that stakes LP tokens.
802     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
803     // Total allocation points. Must be the sum of all allocation points in all pools.
804     uint256 public totalAllocPoint = 0;
805     // The block number when Archieneko mining starts.
806     uint256 public startBlock;
807     uint256 public endBlock;
808     // Total locked up rewards
809     uint256 public totalLockedUpRewards;
810 
811     // Token referral contract address.
812     ITokenReferral public tokenReferral;
813     // Referral commission rate in basis points.
814     uint16 public referralCommissionRate = 100;
815     // Max referral commission rate: 10%.
816     uint16 public constant MAXIMUM_REFERRAL_COMMISSION_RATE = 1000;
817 
818     uint256 public treasure;
819     uint256 public allocated;
820     uint256 public blocks;
821 
822     event Mint(address to,  uint256 amount);
823     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
824     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
825     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
826     event EmissionRateUpdated(address indexed caller, uint256 previousAmount, uint256 newAmount);
827     event ReferralCommissionPaid(address indexed user, address indexed referrer, uint256 commissionAmount);
828     event RewardLockedUp(address indexed user, uint256 indexed pid, uint256 amountLockedUp);
829 
830     constructor(
831         IERC20 _token,
832         uint256 _startBlock,
833         uint256 _tokenPerBlock
834     ) public {
835         token = _token;
836         startBlock = _startBlock;
837         tokenPerBlock = _tokenPerBlock;
838         token.balanceOf( address(this) );
839         devAddress = msg.sender;
840         feeAddress = msg.sender;
841     }
842 
843     function poolLength() external view returns (uint256) {
844         return poolInfo.length;
845     }
846 
847     // Add a new lp to the pool. Can only be called by the owner.
848     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
849     function add(uint256 _allocPoint, IERC20 _lpToken, uint16 _depositFeeBP, uint16 _emergencyWithdrawFeeBP, uint256 _harvestInterval, bool _withUpdate,
850         uint256 _withdrawLockPeriod ) external onlyOwner {
851         require(_depositFeeBP <= 2000, "add: invalid deposit fee basis points");
852         require(_emergencyWithdrawFeeBP <= 2000,"invaild emergencywithdraw fee basis points");
853         require(_withdrawLockPeriod <= 90 days, "withdraw lock must be less than 90 days");
854         require(_harvestInterval <= 90 days, "add: invalid harvest interval");
855         if (_withUpdate) {
856             massUpdatePools();
857         }
858         _lpToken.balanceOf(address(this)); // prevent adding invalid token.
859         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
860         totalAllocPoint = totalAllocPoint.add(_allocPoint);
861         poolInfo.push(PoolInfo({
862             lpToken: _lpToken,
863             allocPoint: _allocPoint,
864             lastRewardBlock: lastRewardBlock,
865             accTokenPerShare: 0,
866             balance: 0,
867             depositFeeBP: _depositFeeBP,
868             emergencyWithdrawFeeBP: _emergencyWithdrawFeeBP,
869             harvestInterval: _harvestInterval,
870             withdrawLockPeriod: _withdrawLockPeriod
871         }));
872     }
873 
874     // Update the given pool's Archieneko allocation point and deposit fee. Can only be called by the owner.
875     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, uint16 _emergencyWithdrawFeeBP, uint256 _harvestInterval, bool _withUpdate,
876         uint256 _withdrawLockPeriod ) external onlyOwner {
877         require(_depositFeeBP <= 2000, "set: invalid deposit fee basis points");
878         require(_emergencyWithdrawFeeBP <= 2000,"invaild emergencywithdraw fee basis points");
879         require(_withdrawLockPeriod <= 90 days, "withdraw lock must be less than 90 days");
880         require(_harvestInterval <= 90 days, "set: invalid harvest interval");
881         if (_withUpdate) {
882             massUpdatePools();
883         }
884         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
885         poolInfo[_pid].allocPoint = _allocPoint;
886         poolInfo[_pid].depositFeeBP = _depositFeeBP;
887         poolInfo[_pid].emergencyWithdrawFeeBP = _emergencyWithdrawFeeBP;
888         poolInfo[_pid].harvestInterval = _harvestInterval;
889         poolInfo[_pid].withdrawLockPeriod = _withdrawLockPeriod;
890     }
891 
892     // Return reward multiplier over the given _from to _to block.
893     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
894         if( treasure == 0 ){
895             // if contract has no balance, stop emission.
896             return 0;
897         }
898         return _to.sub(_from).mul(BONUS_MULTIPLIER);
899     }
900 
901     // View function to see pending Archieneko on frontend.
902     function pendingToken(uint256 _pid, address _user) public view returns (uint256) {
903         PoolInfo storage pool = poolInfo[_pid];
904         UserInfo storage user = userInfo[_pid][_user];
905         uint256 accTokenPerShare = pool.accTokenPerShare;
906         uint256 lpSupply = pool.balance;
907         uint256 myBlock = (block.number <= endBlock ) ? block.number : endBlock;
908         if (myBlock > pool.lastRewardBlock && lpSupply != 0 ) {
909             uint256 multiplier = getMultiplier(pool.lastRewardBlock, myBlock);
910             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
911             accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
912         }
913         uint256 pending = user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
914         return pending.add(user.rewardLockedUp);
915     }
916 
917     // View function to see if user can harvest Archieneko.
918     function canHarvest(uint256 _pid, address _user) public view returns (bool) {
919         UserInfo storage user = userInfo[_pid][_user];
920         return block.timestamp >= user.nextHarvestUntil;
921     }
922 
923     // Update reward variables for all pools. Be careful of gas spending!
924     function massUpdatePools() public {
925         uint256 length = poolInfo.length;
926         for (uint256 pid = 0; pid < length; ++pid) {
927             updatePool(pid);
928         }
929     }
930 
931     // Update reward variables of the given pool to be up-to-date.
932     function updatePool(uint256 _pid) public {
933         PoolInfo storage pool = poolInfo[_pid];
934         uint256 myBlock = (block.number <= endBlock ) ? block.number : endBlock;
935         if (myBlock <= pool.lastRewardBlock) {
936             return;
937         }
938         uint256 lpSupply = pool.balance;
939         if (lpSupply == 0 || pool.allocPoint == 0) {
940             pool.lastRewardBlock = myBlock;
941             return;
942         }
943         uint256 multiplier = getMultiplier(pool.lastRewardBlock, myBlock);
944         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
945         mint(address(this), tokenReward);
946         pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
947         pool.lastRewardBlock = myBlock;
948     }
949 
950     // Deposit LP tokens to MasterChef for Archieneko allocation.
951     function deposit(uint256 _pid, uint256 _amount, address _referrer) external nonReentrant {
952         PoolInfo storage pool = poolInfo[_pid];
953         UserInfo storage user = userInfo[_pid][msg.sender];
954         updatePool(_pid);
955         if (_amount > 0 && address(tokenReferral) != address(0) && _referrer != address(0) && _referrer != msg.sender) {
956             tokenReferral.recordReferral(msg.sender, _referrer);
957         }
958         payOrLockupPendingToken(_pid);
959         if (_amount > 0) {
960 
961             uint256 oldBalance = pool.lpToken.balanceOf(address(this));
962             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
963             uint256 newBalance = pool.lpToken.balanceOf(address(this));
964             _amount = newBalance.sub(oldBalance);
965 
966             pool.balance = pool.balance.add(_amount);
967 
968             if (pool.depositFeeBP > 0) {
969                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
970                 pool.lpToken.safeTransfer(feeAddress, depositFee);
971                 user.amount = user.amount.add(_amount).sub(depositFee);
972             } else {
973                 user.amount = user.amount.add(_amount);
974             }
975             user.lastDepositTime = block.timestamp;
976         }
977         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
978         emit Deposit(msg.sender, _pid, _amount);
979     }
980 
981     // Withdraw LP tokens from MasterChef.
982     function withdraw(uint256 _pid, uint256 _amount) external nonReentrant {
983         PoolInfo storage pool = poolInfo[_pid];
984         UserInfo storage user = userInfo[_pid][msg.sender];
985         require(user.amount >= _amount, "withdraw: not good");
986         updatePool(_pid);
987         payOrLockupPendingToken(_pid);
988         if (_amount > 0) {
989             // check withdraw is locked:
990             if( pool.withdrawLockPeriod > 0){
991                 bool isLocked = block.timestamp < user.lastDepositTime + pool.withdrawLockPeriod;
992                 require( isLocked == false, "withdraw still locked" );
993             }
994             user.amount = user.amount.sub(_amount);
995             pool.balance = pool.balance.sub(_amount);
996             pool.lpToken.safeTransfer(address(msg.sender), _amount);
997         }
998         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
999         emit Withdraw(msg.sender, _pid, _amount);
1000     }
1001 
1002     // Withdraw without caring about rewards. EMERGENCY ONLY.
1003     function emergencyWithdaw(uint256 _pid) external nonReentrant {
1004         PoolInfo storage pool = poolInfo[_pid];
1005         UserInfo storage user = userInfo[_pid][msg.sender];
1006         uint256 amount = user.amount;
1007         pool.balance = pool.balance.sub(amount);
1008         user.amount = 0;
1009         user.rewardDebt = 0;
1010         user.rewardLockedUp = 0;
1011         user.nextHarvestUntil = 0;
1012         uint256 withdrawAmount;
1013         if (pool.emergencyWithdrawFeeBP > 0) {
1014                 uint256 withdrawFee = amount.mul(pool.emergencyWithdrawFeeBP).div(10000);
1015                 pool.lpToken.safeTransfer(feeAddress, withdrawFee);
1016                 withdrawAmount = amount.sub(withdrawFee);
1017                 
1018             } else {
1019                 withdrawAmount = amount;
1020             }
1021         pool.lpToken.safeTransfer(address(msg.sender), withdrawAmount);
1022         emit EmergencyWithdraw(msg.sender, _pid, withdrawAmount);
1023     }
1024 
1025     // Pay or lockup pending Archieneko.
1026     function payOrLockupPendingToken(uint256 _pid) internal {
1027         PoolInfo storage pool = poolInfo[_pid];
1028         UserInfo storage user = userInfo[_pid][msg.sender];
1029 
1030         if (user.nextHarvestUntil == 0) {
1031             user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
1032         }
1033 
1034         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1035         if (canHarvest(_pid, msg.sender)) {
1036             if (pending > 0 || user.rewardLockedUp > 0) {
1037                 uint256 totalRewards = pending.add(user.rewardLockedUp);
1038 
1039                 // reset lockup
1040                 totalLockedUpRewards = totalLockedUpRewards.sub(user.rewardLockedUp);
1041                 user.rewardLockedUp = 0;
1042                 user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
1043 
1044                 // send rewards
1045                 safeTokenTransfer(msg.sender, totalRewards);
1046                 payReferralCommission(msg.sender, totalRewards);
1047             }
1048         } else if (pending > 0) {
1049             user.rewardLockedUp = user.rewardLockedUp.add(pending);
1050             totalLockedUpRewards = totalLockedUpRewards.add(pending);
1051             emit RewardLockedUp(msg.sender, _pid, pending);
1052         }
1053     }
1054 
1055     // Update dev address by the previous dev.
1056     function setDevAddress(address _devAddress) external {
1057         require(msg.sender == devAddress, "setDevAddress: FORBIDDEN");
1058         require(_devAddress != address(0), "setDevAddress: ZERO");
1059         devAddress = _devAddress;
1060     }
1061 
1062     function setFeeAddress(address _feeAddress) external {
1063         require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
1064         require(_feeAddress != address(0), "setFeeAddress: ZERO");
1065         feeAddress = _feeAddress;
1066     }
1067 
1068     // Update the token referral contract address by the owner
1069     function setTokenReferral(ITokenReferral _tokenReferral) external onlyOwner {
1070         tokenReferral = _tokenReferral;
1071     }
1072 
1073     // Update referral commission rate by the owner
1074     function setReferralCommissionRate(uint16 _referralCommissionRate) external onlyOwner {
1075         require(_referralCommissionRate <= MAXIMUM_REFERRAL_COMMISSION_RATE, "setReferralCommissionRate: invalid referral commission rate basis points");
1076         referralCommissionRate = _referralCommissionRate;
1077     }
1078 
1079     // Pay referral commission to the referrer who referred this user.
1080     function payReferralCommission(address _user, uint256 _pending) internal {
1081         if (address(tokenReferral) != address(0) && referralCommissionRate > 0) {
1082             address referrer = tokenReferral.getReferrer(_user);
1083             uint256 commissionAmount = _pending.mul(referralCommissionRate).div(10000);
1084 
1085             if (referrer != address(0) && commissionAmount > 0) {
1086                 mint(referrer, commissionAmount);
1087                 tokenReferral.recordReferralCommission(referrer, commissionAmount);
1088                 emit ReferralCommissionPaid(_user, referrer, commissionAmount);
1089             }
1090         }
1091     }
1092 
1093     function addBalance(uint256 _amount, uint256 _endBlock) external onlyOwner {
1094         require( _amount > 0 , "err _amount=0");
1095         require( _endBlock > block.number , "err start<=block");
1096 
1097         // Note: finding by auditors.
1098         uint256 oldBalance = token.balanceOf(address(this));
1099         token.safeTransferFrom(msg.sender, address(this), _amount);
1100         uint256 newBalance = token.balanceOf(address(this));
1101         _amount = newBalance.sub(oldBalance);
1102 
1103         endBlock = _endBlock;
1104         treasure = treasure.add(_amount);
1105         blocks = _endBlock - block.number;
1106         tokenPerBlock = treasure.div(blocks);
1107         startBlock = block.number;
1108     }
1109     function mint(address to,  uint256 amount ) internal {
1110         if( amount > treasure ){
1111             // treasure is 0, stop emission.
1112             tokenPerBlock = 0;
1113             amount = treasure; // last ming
1114         }
1115         treasure = treasure.sub(amount);
1116         allocated = allocated.add(amount);
1117         emit Mint(to, amount);
1118     }
1119     // Safe token transfer function, just in case if rounding error causes pool to not have enough Archieneko.
1120     function safeTokenTransfer(address _to, uint256 _amount) internal {
1121         uint256 tokenBal = token.balanceOf(address(this));
1122         if (_amount > tokenBal) {
1123             token.transfer(_to, tokenBal);
1124         } else {
1125             token.transfer(_to, _amount);
1126         }
1127     }
1128 
1129     function getBlock() public view returns (uint256) {
1130         return block.number;
1131     }
1132 
1133     function recoverTreasure( IERC20 recoverToken, uint256 amount) external onlyOwner{
1134         uint256 length = poolInfo.length;
1135         for (uint256 pid = 1; pid < length; ++pid) {
1136             require(recoverToken != poolInfo[pid].lpToken,"can't transfer lp");
1137         }
1138         require(block.number > endBlock, "can recover only farming end.");
1139         // allow treasure recover unused/lost funds
1140         recoverToken.transfer(devAddress, amount);
1141     }
1142 
1143 }