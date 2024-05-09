1 // SPDX-License-Identifier: NONE
2 
3 
4 pragma solidity 0.8.6;
5 
6 
7 // File: @openzeppelin/contracts/math/SafeMath.sol
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
221 
222 
223 
224 pragma solidity 0.8.6;
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP.
228  */
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 // File: @openzeppelin/contracts/utils/Address.sol
301 
302 
303 
304 pragma solidity 0.8.6;
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize, which returns 0 for contracts in
329         // construction, since the code is only stored at the end of the
330         // constructor execution.
331 
332         uint256 size;
333         // solhint-disable-next-line no-inline-assembly
334         assembly { size := extcodesize(account) }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
358         (bool success, ) = recipient.call{ value: amount }("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain`call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381       return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         // solhint-disable-next-line avoid-low-level-calls
420         (bool success, bytes memory returndata) = target.call{ value: value }(data);
421         return _verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
431         return functionStaticCall(target, data, "Address: low-level static call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
441         require(isContract(target), "Address: static call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return _verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
465         require(isContract(target), "Address: delegate call to non-contract");
466 
467         // solhint-disable-next-line avoid-low-level-calls
468         (bool success, bytes memory returndata) = target.delegatecall(data);
469         return _verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479 
480                 // solhint-disable-next-line no-inline-assembly
481                 assembly {
482                     let returndata_size := mload(returndata)
483                     revert(add(32, returndata), returndata_size)
484                 }
485             } else {
486                 revert(errorMessage);
487             }
488         }
489     }
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
493 
494 
495 
496 pragma solidity 0.8.6;
497 
498 
499 
500 
501 /**
502  * @title SafeERC20
503  * @dev Wrappers around ERC20 operations that throw on failure (when the token
504  * contract returns false). Tokens that return no value (and instead revert or
505  * throw on failure) are also supported, non-reverting calls are assumed to be
506  * successful.
507  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
508  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
509  */
510 library SafeERC20 {
511     using SafeMath for uint256;
512     using Address for address;
513 
514     function safeTransfer(IERC20 token, address to, uint256 value) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
519         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
520     }
521 
522     /**
523      * @dev Deprecated. This function has issues similar to the ones found in
524      * {IERC20-approve}, and its usage is discouraged.
525      *
526      * Whenever possible, use {safeIncreaseAllowance} and
527      * {safeDecreaseAllowance} instead.
528      */
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function _callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
559         // the target address contains contract code and also asserts for success in the low-level call.
560 
561         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
562         if (returndata.length > 0) { // Return data is optional
563             // solhint-disable-next-line max-line-length
564             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
565         }
566     }
567 }
568 
569 // File: @openzeppelin/contracts/utils/Context.sol
570 
571 
572 
573 pragma solidity 0.8.6;
574 
575 /*
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with GSN meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address payable) {
587         return payable(msg.sender);
588     }
589 
590     function _msgData() internal view virtual returns (bytes memory) {
591         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
592         return msg.data;
593     }
594 }
595 
596 // File: @openzeppelin/contracts/access/Ownable.sol
597 
598 
599 
600 pragma solidity 0.8.6;
601 
602 /**
603  * @dev Contract module which provides a basic access control mechanism, where
604  * there is an account (an owner) that can be granted exclusive access to
605  * specific functions.
606  *
607  * By default, the owner account will be the one that deploys the contract. This
608  * can later be changed with {transferOwnership}.
609  *
610  * This module is used through inheritance. It will make available the modifier
611  * `onlyOwner`, which can be applied to your functions to restrict their use to
612  * the owner.
613  */
614 abstract contract Ownable is Context {
615     address private _owner;
616 
617     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
618 
619     /**
620      * @dev Initializes the contract setting the deployer as the initial owner.
621      */
622     constructor () {
623         address msgSender = _msgSender();
624         _owner = msgSender;
625         emit OwnershipTransferred(address(0), msgSender);
626     }
627 
628     /**
629      * @dev Returns the address of the current owner.
630      */
631     function owner() public view virtual returns (address) {
632         return _owner;
633     }
634 
635     /**
636      * @dev Throws if called by any account other than the owner.
637      */
638     modifier onlyOwner() {
639         require(owner() == _msgSender(), "Ownable: caller is not the owner");
640         _;
641     }
642 
643     /**
644      * @dev Leaves the contract without owner. It will not be possible to call
645      * `onlyOwner` functions anymore. Can only be called by the current owner.
646      *
647      * NOTE: Renouncing ownership will leave the contract without an owner,
648      * thereby removing any functionality that is only available to the owner.
649      */
650     function renounceOwnership() public virtual onlyOwner {
651         emit OwnershipTransferred(_owner, address(0));
652         _owner = address(0);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      * Can only be called by the current owner.
658      */
659     function transferOwnership(address newOwner) public virtual onlyOwner {
660         require(newOwner != address(0), "Ownable: new owner is the zero address");
661         emit OwnershipTransferred(_owner, newOwner);
662         _owner = newOwner;
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
667 
668 
669 pragma solidity 0.8.6;
670 
671 
672 /**
673  * @dev Contract module that helps prevent reentrant calls to a function.
674  *
675  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
676  * available, which can be applied to functions to make sure there are no nested
677  * (reentrant) calls to them.
678  *
679  * Note that because there is a single `nonReentrant` guard, functions marked as
680  * `nonReentrant` may not call one another. This can be worked around by making
681  * those functions `private`, and then adding `external` `nonReentrant` entry
682  * points to them.
683  *
684  * TIP: If you would like to learn more about reentrancy and alternative ways
685  * to protect against it, check out our blog post
686  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
687  */
688 abstract contract ReentrancyGuard {
689     // Booleans are more expensive than uint256 or any type that takes up a full
690     // word because each write operation emits an extra SLOAD to first read the
691     // slot's contents, replace the bits taken up by the boolean, and then write
692     // back. This is the compiler's defense against contract upgrades and
693     // pointer aliasing, and it cannot be disabled.
694 
695     // The values being non-zero value makes deployment a bit more expensive,
696     // but in exchange the refund on every call to nonReentrant will be lower in
697     // amount. Since refunds are capped to a percentage of the total
698     // transaction's gas, it is best to keep them low in cases like this one, to
699     // increase the likelihood of the full refund coming into effect.
700     uint256 private constant _NOT_ENTERED = 1;
701     uint256 private constant _ENTERED = 2;
702 
703     uint256 private _status;
704 
705     constructor () {
706         _status = _NOT_ENTERED;
707     }
708 
709     /**
710      * @dev Prevents a contract from calling itself, directly or indirectly.
711      * Calling a `nonReentrant` function from another `nonReentrant`
712      * function is not supported. It is possible to prevent this from happening
713      * by making the `nonReentrant` function external, and make it call a
714      * `private` function that does the actual work.
715      */
716     modifier nonReentrant() {
717         // On the first call to nonReentrant, _notEntered will be true
718         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
719 
720         // Any calls to nonReentrant after this point will fail
721         _status = _ENTERED;
722 
723         _;
724 
725         // By storing the original value once again, a refund is triggered (see
726         // https://eips.ethereum.org/EIPS/eip-2200)
727         _status = _NOT_ENTERED;
728     }
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
732 
733 
734 
735 
736 
737 pragma solidity 0.8.6;
738 
739 
740 // File: contracts/ShiryoinuChef.sol
741 
742 contract ShiryoinuChef is Ownable, ReentrancyGuard {
743     using SafeMath for uint256;
744     using SafeERC20 for IERC20;
745 
746     IERC20 public rewardToken;
747 
748     IERC20 public stakedToken;
749 
750     IERC20 public stakedLP;
751     uint256 public quantumStakedTokens = 20000000000000000000000; // number of staked tokens needed to earn the reward, 20 trillion x 9 decimals
752     uint256 public quantumLPTokens = 20000000000000000000; // number of LP tokens needed to earn the reward (20) x 18 dec
753     uint256 public rewardForTokenPerDuration = 1;
754     uint256 public rewardForLPPerDuration = 2;
755 
756    // uint256 rewardDuration = 7 days;
757     uint256 public rewardDuration = 10 minutes;
758     uint256 public totalClaimed;
759 
760     bool public farming = true;
761 
762     struct userPosition {
763         uint256 totalClaimed;
764         uint256 amountToken;
765         uint256 amountTokenReceived;
766         uint256 amountLP;  // quantized
767         uint256 amountLPReceived; // amount received due to transfer tax
768         uint256 lastRewardTimestamp;
769     }
770     mapping (address =>userPosition) public addressToUserPosition;
771 
772     constructor(){
773         rewardToken = IERC20(0x773D6E3e85Ed29D2C40C42f7cbc8aD3d4dDBeef0);
774         stakedToken = IERC20(0x1E2F15302B90EddE696593607b6bD444B64e8F02);
775         stakedLP = IERC20(0xe6e1F4F9b0303Ca3878A110061C0Ec9b84fddD03);
776     }
777     
778     function _checkAndClaimPacks(address _user) internal {
779        uint256 claimable = claimablePacks(_user);
780        if (claimable>0){
781            addressToUserPosition[_user].lastRewardTimestamp = block.timestamp;
782            addressToUserPosition[_user].totalClaimed = claimable;
783            totalClaimed = totalClaimed + claimable;
784            rewardToken.safeTransfer(_user, claimable);
785        }
786     }
787 
788     // user functions
789     function deposit(IERC20 _target, uint256 _amount) public nonReentrant{
790         require(_target == stakedToken || _target == stakedLP , "Uknown token.");
791         
792         _checkAndClaimPacks(msg.sender);
793         
794         if (_target == stakedToken){
795              uint256 current = addressToUserPosition[msg.sender].amountToken;
796              require(current + _amount >= quantumStakedTokens , "Not enough tokens staked.");
797              uint256 tokenBalanceBefore = stakedToken.balanceOf(address(this));
798              stakedToken.safeTransferFrom(msg.sender,address(this), _amount);
799              uint256 tokenReceived = stakedToken.balanceOf(address(this)).sub(tokenBalanceBefore);
800              addressToUserPosition[msg.sender].amountTokenReceived = addressToUserPosition[msg.sender].amountTokenReceived + tokenReceived;
801              addressToUserPosition[msg.sender].amountToken=current + _amount;
802              addressToUserPosition[msg.sender].lastRewardTimestamp = block.timestamp;
803         }
804         if (_target == stakedLP){
805              uint256 current = addressToUserPosition[msg.sender].amountLP;
806              require(current + _amount >= quantumLPTokens , "Not enough LP staked.");
807              uint256 lpBalanceBefore = stakedLP.balanceOf(address(this));
808              stakedLP.safeTransferFrom(msg.sender,address(this), _amount);
809              uint256 lpReceived = stakedLP.balanceOf(address(this)).sub(lpBalanceBefore);
810              addressToUserPosition[msg.sender].amountLPReceived = addressToUserPosition[msg.sender].amountLPReceived + lpReceived;
811              addressToUserPosition[msg.sender].amountLP=current + _amount;
812              addressToUserPosition[msg.sender].lastRewardTimestamp = block.timestamp;
813         }
814 
815     }
816 
817     function withdraw(IERC20 _target) public nonReentrant{
818        
819          _checkAndClaimPacks(msg.sender);
820        
821          if (_target == stakedToken && addressToUserPosition[msg.sender].amountToken>0){
822              uint256 current = addressToUserPosition[msg.sender].amountTokenReceived;
823              addressToUserPosition[msg.sender].amountToken=0;
824              addressToUserPosition[msg.sender].amountTokenReceived=0;
825              stakedToken.safeTransfer(msg.sender, current);
826         }
827         if (_target == stakedLP && addressToUserPosition[msg.sender].amountLP>0){
828              uint256 current = addressToUserPosition[msg.sender].amountLPReceived;
829              addressToUserPosition[msg.sender].amountLP=0;
830              addressToUserPosition[msg.sender].amountLPReceived=0;
831              stakedLP.safeTransfer(msg.sender, current);
832         }
833          addressToUserPosition[msg.sender].lastRewardTimestamp = block.timestamp;
834     }
835 
836     function nextRewardTime(address _user) public view returns (uint256){
837          uint256 elapsedTime = block.timestamp - addressToUserPosition[_user].lastRewardTimestamp;
838          uint256 next = addressToUserPosition[_user].lastRewardTimestamp + rewardDuration;
839          if (elapsedTime >= rewardDuration){
840              uint256 durationUnits = elapsedTime.div(rewardDuration).add(1);
841              next = addressToUserPosition[_user].lastRewardTimestamp.add(durationUnits.mul(rewardDuration));
842          }
843          return next;
844     }
845 
846     function claimablePacks(address _user) public view returns (uint256){
847         uint256 claimable = 0;
848         uint256 elapsedTime = block.timestamp - addressToUserPosition[_user].lastRewardTimestamp;
849         if (elapsedTime >= rewardDuration && farming==true){
850             uint256 durationUnits = elapsedTime.div(rewardDuration);
851             uint256 multipleOfTokenQuantums = 0;
852             if(addressToUserPosition[_user].amountToken>0) {multipleOfTokenQuantums = addressToUserPosition[_user].amountToken.div(quantumStakedTokens);}
853             uint256 multipleOfLPQuantums = 0;
854             if(addressToUserPosition[_user].amountLP>0) {multipleOfLPQuantums = addressToUserPosition[_user].amountLP.div(quantumLPTokens);}
855             claimable = durationUnits.mul(rewardForTokenPerDuration.mul(multipleOfTokenQuantums) + rewardForLPPerDuration.mul(multipleOfLPQuantums));
856         }
857         return claimable;
858     }
859 
860     function claim() public {
861         _checkAndClaimPacks(msg.sender);
862     }
863 
864     // admin functions
865     function setStakedToken(IERC20 _target ) public onlyOwner{
866         require (address(_target)!=address(0x0), "Null address not allowed");
867         stakedToken = _target;
868     }
869     function setStakedLPT(IERC20 _target) public onlyOwner{
870         require (address(_target)!=address(0x0) , "Null address not allowed");
871         stakedLP = _target;
872     }
873     // sets the reward amount for the target token
874     function setReward(IERC20 _target, uint256 _amount) public onlyOwner{
875         require(_target == stakedToken || _target == stakedLP , "Uknown token.");
876 
877         if (_target == stakedToken){
878             rewardForTokenPerDuration = _amount;
879         }
880         if (_target == stakedLP){
881             rewardForLPPerDuration = _amount;
882         }
883     }
884     
885     function setRewardDuration(uint256 _durationSeconds) public onlyOwner{
886         rewardDuration = _durationSeconds;
887     }
888     
889     function setQuantumLPTokens(uint256 _amount) public onlyOwner{
890         quantumLPTokens = _amount;
891     }
892     
893     function setQuantumStakedTokens(uint256 _amount) public onlyOwner{
894         quantumStakedTokens = _amount;
895     }
896     
897     function withdrawRewardToken(uint256 _amount) public onlyOwner{
898         rewardToken.safeTransfer(msg.sender, _amount);
899     }
900     
901     function setFarming(bool _farming) public onlyOwner{
902         farming = _farming;
903     }
904 
905 }