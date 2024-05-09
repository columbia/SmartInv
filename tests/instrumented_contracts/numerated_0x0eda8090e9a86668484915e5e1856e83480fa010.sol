1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /*
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with GSN meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address payable) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes memory) {
104         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
105         return msg.data;
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor () internal {
135         address msgSender = _msgSender();
136         _owner = msgSender;
137         emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 
179 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
180 
181 pragma solidity >=0.6.0 <0.8.0;
182 
183 /**
184  * @dev Contract module that helps prevent reentrant calls to a function.
185  *
186  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
187  * available, which can be applied to functions to make sure there are no nested
188  * (reentrant) calls to them.
189  *
190  * Note that because there is a single `nonReentrant` guard, functions marked as
191  * `nonReentrant` may not call one another. This can be worked around by making
192  * those functions `private`, and then adding `external` `nonReentrant` entry
193  * points to them.
194  *
195  * TIP: If you would like to learn more about reentrancy and alternative ways
196  * to protect against it, check out our blog post
197  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
198  */
199 abstract contract ReentrancyGuard {
200     // Booleans are more expensive than uint256 or any type that takes up a full
201     // word because each write operation emits an extra SLOAD to first read the
202     // slot's contents, replace the bits taken up by the boolean, and then write
203     // back. This is the compiler's defense against contract upgrades and
204     // pointer aliasing, and it cannot be disabled.
205 
206     // The values being non-zero value makes deployment a bit more expensive,
207     // but in exchange the refund on every call to nonReentrant will be lower in
208     // amount. Since refunds are capped to a percentage of the total
209     // transaction's gas, it is best to keep them low in cases like this one, to
210     // increase the likelihood of the full refund coming into effect.
211     uint256 private constant _NOT_ENTERED = 1;
212     uint256 private constant _ENTERED = 2;
213 
214     uint256 private _status;
215 
216     constructor () internal {
217         _status = _NOT_ENTERED;
218     }
219 
220     /**
221      * @dev Prevents a contract from calling itself, directly or indirectly.
222      * Calling a `nonReentrant` function from another `nonReentrant`
223      * function is not supported. It is possible to prevent this from happening
224      * by making the `nonReentrant` function external, and make it call a
225      * `private` function that does the actual work.
226      */
227     modifier nonReentrant() {
228         // On the first call to nonReentrant, _notEntered will be true
229         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
230 
231         // Any calls to nonReentrant after this point will fail
232         _status = _ENTERED;
233 
234         _;
235 
236         // By storing the original value once again, a refund is triggered (see
237         // https://eips.ethereum.org/EIPS/eip-2200)
238         _status = _NOT_ENTERED;
239     }
240 }
241 
242 
243 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
244 
245 pragma solidity >=0.6.0 <0.8.0;
246 
247 /**
248  * @dev Wrappers over Solidity's arithmetic operations with added overflow
249  * checks.
250  *
251  * Arithmetic operations in Solidity wrap on overflow. This can easily result
252  * in bugs, because programmers usually assume that an overflow raises an
253  * error, which is the standard behavior in high level programming languages.
254  * `SafeMath` restores this intuition by reverting the transaction when an
255  * operation overflows.
256  *
257  * Using this library instead of the unchecked operations eliminates an entire
258  * class of bugs, so it's recommended to use it always.
259  */
260 library SafeMath {
261     /**
262      * @dev Returns the addition of two unsigned integers, with an overflow flag.
263      *
264      * _Available since v3.4._
265      */
266     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         uint256 c = a + b;
268         if (c < a) return (false, 0);
269         return (true, c);
270     }
271 
272     /**
273      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
274      *
275      * _Available since v3.4._
276      */
277     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         if (b > a) return (false, 0);
279         return (true, a - b);
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
284      *
285      * _Available since v3.4._
286      */
287     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
289         // benefit is lost if 'b' is also tested.
290         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
291         if (a == 0) return (true, 0);
292         uint256 c = a * b;
293         if (c / a != b) return (false, 0);
294         return (true, c);
295     }
296 
297     /**
298      * @dev Returns the division of two unsigned integers, with a division by zero flag.
299      *
300      * _Available since v3.4._
301      */
302     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         if (b == 0) return (false, 0);
304         return (true, a / b);
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
309      *
310      * _Available since v3.4._
311      */
312     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         if (b == 0) return (false, 0);
314         return (true, a % b);
315     }
316 
317     /**
318      * @dev Returns the addition of two unsigned integers, reverting on
319      * overflow.
320      *
321      * Counterpart to Solidity's `+` operator.
322      *
323      * Requirements:
324      *
325      * - Addition cannot overflow.
326      */
327     function add(uint256 a, uint256 b) internal pure returns (uint256) {
328         uint256 c = a + b;
329         require(c >= a, "SafeMath: addition overflow");
330         return c;
331     }
332 
333     /**
334      * @dev Returns the subtraction of two unsigned integers, reverting on
335      * overflow (when the result is negative).
336      *
337      * Counterpart to Solidity's `-` operator.
338      *
339      * Requirements:
340      *
341      * - Subtraction cannot overflow.
342      */
343     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
344         require(b <= a, "SafeMath: subtraction overflow");
345         return a - b;
346     }
347 
348     /**
349      * @dev Returns the multiplication of two unsigned integers, reverting on
350      * overflow.
351      *
352      * Counterpart to Solidity's `*` operator.
353      *
354      * Requirements:
355      *
356      * - Multiplication cannot overflow.
357      */
358     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
359         if (a == 0) return 0;
360         uint256 c = a * b;
361         require(c / a == b, "SafeMath: multiplication overflow");
362         return c;
363     }
364 
365     /**
366      * @dev Returns the integer division of two unsigned integers, reverting on
367      * division by zero. The result is rounded towards zero.
368      *
369      * Counterpart to Solidity's `/` operator. Note: this function uses a
370      * `revert` opcode (which leaves remaining gas untouched) while Solidity
371      * uses an invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function div(uint256 a, uint256 b) internal pure returns (uint256) {
378         require(b > 0, "SafeMath: division by zero");
379         return a / b;
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * reverting when dividing by zero.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
395         require(b > 0, "SafeMath: modulo by zero");
396         return a % b;
397     }
398 
399     /**
400      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
401      * overflow (when the result is negative).
402      *
403      * CAUTION: This function is deprecated because it requires allocating memory for the error
404      * message unnecessarily. For custom revert reasons use {trySub}.
405      *
406      * Counterpart to Solidity's `-` operator.
407      *
408      * Requirements:
409      *
410      * - Subtraction cannot overflow.
411      */
412     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
413         require(b <= a, errorMessage);
414         return a - b;
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
419      * division by zero. The result is rounded towards zero.
420      *
421      * CAUTION: This function is deprecated because it requires allocating memory for the error
422      * message unnecessarily. For custom revert reasons use {tryDiv}.
423      *
424      * Counterpart to Solidity's `/` operator. Note: this function uses a
425      * `revert` opcode (which leaves remaining gas untouched) while Solidity
426      * uses an invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
433         require(b > 0, errorMessage);
434         return a / b;
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
439      * reverting with custom message when dividing by zero.
440      *
441      * CAUTION: This function is deprecated because it requires allocating memory for the error
442      * message unnecessarily. For custom revert reasons use {tryMod}.
443      *
444      * Counterpart to Solidity's `%` operator. This function uses a `revert`
445      * opcode (which leaves remaining gas untouched) while Solidity uses an
446      * invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
453         require(b > 0, errorMessage);
454         return a % b;
455     }
456 }
457 
458 
459 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
460 
461 pragma solidity >=0.6.2 <0.8.0;
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      */
484     function isContract(address account) internal view returns (bool) {
485         // This method relies on extcodesize, which returns 0 for contracts in
486         // construction, since the code is only stored at the end of the
487         // constructor execution.
488 
489         uint256 size;
490         // solhint-disable-next-line no-inline-assembly
491         assembly { size := extcodesize(account) }
492         return size > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
515         (bool success, ) = recipient.call{ value: amount }("");
516         require(success, "Address: unable to send value, recipient may have reverted");
517     }
518 
519     /**
520      * @dev Performs a Solidity function call using a low level `call`. A
521      * plain`call` is an unsafe replacement for a function call: use this
522      * function instead.
523      *
524      * If `target` reverts with a revert reason, it is bubbled up by this
525      * function (like regular Solidity function calls).
526      *
527      * Returns the raw returned data. To convert to the expected return value,
528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
529      *
530      * Requirements:
531      *
532      * - `target` must be a contract.
533      * - calling `target` with `data` must not revert.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
538       return functionCall(target, data, "Address: low-level call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
543      * `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, 0, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but also transferring `value` wei to `target`.
554      *
555      * Requirements:
556      *
557      * - the calling contract must have an ETH balance of at least `value`.
558      * - the called Solidity function must be `payable`.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
568      * with `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         // solhint-disable-next-line avoid-low-level-calls
577         (bool success, bytes memory returndata) = target.call{ value: value }(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
598         require(isContract(target), "Address: static call to non-contract");
599 
600         // solhint-disable-next-line avoid-low-level-calls
601         (bool success, bytes memory returndata) = target.staticcall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
612         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         // solhint-disable-next-line avoid-low-level-calls
625         (bool success, bytes memory returndata) = target.delegatecall(data);
626         return _verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
630         if (success) {
631             return returndata;
632         } else {
633             // Look for revert reason and bubble it up if present
634             if (returndata.length > 0) {
635                 // The easiest way to bubble the revert reason is using memory via assembly
636 
637                 // solhint-disable-next-line no-inline-assembly
638                 assembly {
639                     let returndata_size := mload(returndata)
640                     revert(add(32, returndata), returndata_size)
641                 }
642             } else {
643                 revert(errorMessage);
644             }
645         }
646     }
647 }
648 
649 
650 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
651 
652 pragma solidity >=0.6.0 <0.8.0;
653 
654 
655 
656 /**
657  * @title SafeERC20
658  * @dev Wrappers around ERC20 operations that throw on failure (when the token
659  * contract returns false). Tokens that return no value (and instead revert or
660  * throw on failure) are also supported, non-reverting calls are assumed to be
661  * successful.
662  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
663  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
664  */
665 library SafeERC20 {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     function safeTransfer(IERC20 token, address to, uint256 value) internal {
670         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
671     }
672 
673     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
674         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
675     }
676 
677     /**
678      * @dev Deprecated. This function has issues similar to the ones found in
679      * {IERC20-approve}, and its usage is discouraged.
680      *
681      * Whenever possible, use {safeIncreaseAllowance} and
682      * {safeDecreaseAllowance} instead.
683      */
684     function safeApprove(IERC20 token, address spender, uint256 value) internal {
685         // safeApprove should only be called when setting an initial allowance,
686         // or when resetting it to zero. To increase and decrease it, use
687         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
688         // solhint-disable-next-line max-line-length
689         require((value == 0) || (token.allowance(address(this), spender) == 0),
690             "SafeERC20: approve from non-zero to non-zero allowance"
691         );
692         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
693     }
694 
695     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
696         uint256 newAllowance = token.allowance(address(this), spender).add(value);
697         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
698     }
699 
700     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
701         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
702         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
703     }
704 
705     /**
706      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
707      * on the return value: the return value is optional (but if data is returned, it must not be false).
708      * @param token The token targeted by the call.
709      * @param data The call data (encoded using abi.encode or one of its variants).
710      */
711     function _callOptionalReturn(IERC20 token, bytes memory data) private {
712         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
713         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
714         // the target address contains contract code and also asserts for success in the low-level call.
715 
716         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
717         if (returndata.length > 0) { // Return data is optional
718             // solhint-disable-next-line max-line-length
719             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
720         }
721     }
722 }
723 
724 
725 // File contracts/libraries/FixedPointMath.sol
726 
727 pragma solidity ^0.6.12;
728 
729 library FixedPointMath {
730   uint256 public constant DECIMALS = 18;
731   uint256 public constant SCALAR = 10**DECIMALS;
732 
733   struct uq192x64 {
734     uint256 x;
735   }
736 
737   function fromU256(uint256 value) internal pure returns (uq192x64 memory) {
738     uint256 x;
739     require(value == 0 || (x = value * SCALAR) / SCALAR == value);
740     return uq192x64(x);
741   }
742 
743   function maximumValue() internal pure returns (uq192x64 memory) {
744     return uq192x64(uint256(-1));
745   }
746 
747   function add(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
748     uint256 x;
749     require((x = self.x + value.x) >= self.x);
750     return uq192x64(x);
751   }
752 
753   function add(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
754     return add(self, fromU256(value));
755   }
756 
757   function sub(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
758     uint256 x;
759     require((x = self.x - value.x) <= self.x);
760     return uq192x64(x);
761   }
762 
763   function sub(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
764     return sub(self, fromU256(value));
765   }
766 
767   function mul(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
768     uint256 x;
769     require(value == 0 || (x = self.x * value) / value == self.x);
770     return uq192x64(x);
771   }
772 
773   function div(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
774     require(value != 0);
775     return uq192x64(self.x / value);
776   }
777 
778   function cmp(uq192x64 memory self, uq192x64 memory value) internal pure returns (int256) {
779     if (self.x < value.x) {
780       return -1;
781     }
782 
783     if (self.x > value.x) {
784       return 1;
785     }
786 
787     return 0;
788   }
789 
790   function decode(uq192x64 memory self) internal pure returns (uint256) {
791     return self.x / SCALAR;
792   }
793 }
794 
795 
796 // File contracts/interfaces/IDetailedERC20.sol
797 
798 pragma solidity ^0.6.12;
799 
800 interface IDetailedERC20 is IERC20 {
801   function name() external returns (string memory);
802   function symbol() external returns (string memory);
803   function decimals() external returns (uint8);
804 }
805 
806 
807 // File contracts/interfaces/IMintableERC20.sol
808 
809 pragma solidity ^0.6.12;
810 
811 interface IMintableERC20 is IDetailedERC20{
812   function mint(address _recipient, uint256 _amount) external;
813   function burnFrom(address account, uint256 amount) external;
814   function lowerHasMinted(uint256 amount)external;
815 }
816 
817 
818 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
819 
820 pragma solidity >=0.6.0 <0.8.0;
821 
822 /**
823  * @dev Standard math utilities missing in the Solidity language.
824  */
825 library Math {
826     /**
827      * @dev Returns the largest of two numbers.
828      */
829     function max(uint256 a, uint256 b) internal pure returns (uint256) {
830         return a >= b ? a : b;
831     }
832 
833     /**
834      * @dev Returns the smallest of two numbers.
835      */
836     function min(uint256 a, uint256 b) internal pure returns (uint256) {
837         return a < b ? a : b;
838     }
839 
840     /**
841      * @dev Returns the average of two numbers. The result is rounded towards
842      * zero.
843      */
844     function average(uint256 a, uint256 b) internal pure returns (uint256) {
845         // (a + b) / 2 can overflow, so we distribute
846         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
847     }
848 }
849 
850 
851 // File hardhat/console.sol@v2.1.1
852 
853 pragma solidity >= 0.4.22 <0.9.0;
854 
855 library console {
856 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
857 
858 	function _sendLogPayload(bytes memory payload) private view {
859 		uint256 payloadLength = payload.length;
860 		address consoleAddress = CONSOLE_ADDRESS;
861 		assembly {
862 			let payloadStart := add(payload, 32)
863 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
864 		}
865 	}
866 
867 	function log() internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log()"));
869 	}
870 
871 	function logInt(int p0) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
873 	}
874 
875 	function logUint(uint p0) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
877 	}
878 
879 	function logString(string memory p0) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
881 	}
882 
883 	function logBool(bool p0) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
885 	}
886 
887 	function logAddress(address p0) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
889 	}
890 
891 	function logBytes(bytes memory p0) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
893 	}
894 
895 	function logBytes1(bytes1 p0) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
897 	}
898 
899 	function logBytes2(bytes2 p0) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
901 	}
902 
903 	function logBytes3(bytes3 p0) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
905 	}
906 
907 	function logBytes4(bytes4 p0) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
909 	}
910 
911 	function logBytes5(bytes5 p0) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
913 	}
914 
915 	function logBytes6(bytes6 p0) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
917 	}
918 
919 	function logBytes7(bytes7 p0) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
921 	}
922 
923 	function logBytes8(bytes8 p0) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
925 	}
926 
927 	function logBytes9(bytes9 p0) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
929 	}
930 
931 	function logBytes10(bytes10 p0) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
933 	}
934 
935 	function logBytes11(bytes11 p0) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
937 	}
938 
939 	function logBytes12(bytes12 p0) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
941 	}
942 
943 	function logBytes13(bytes13 p0) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
945 	}
946 
947 	function logBytes14(bytes14 p0) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
949 	}
950 
951 	function logBytes15(bytes15 p0) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
953 	}
954 
955 	function logBytes16(bytes16 p0) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
957 	}
958 
959 	function logBytes17(bytes17 p0) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
961 	}
962 
963 	function logBytes18(bytes18 p0) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
965 	}
966 
967 	function logBytes19(bytes19 p0) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
969 	}
970 
971 	function logBytes20(bytes20 p0) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
973 	}
974 
975 	function logBytes21(bytes21 p0) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
977 	}
978 
979 	function logBytes22(bytes22 p0) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
981 	}
982 
983 	function logBytes23(bytes23 p0) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
985 	}
986 
987 	function logBytes24(bytes24 p0) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
989 	}
990 
991 	function logBytes25(bytes25 p0) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
993 	}
994 
995 	function logBytes26(bytes26 p0) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
997 	}
998 
999 	function logBytes27(bytes27 p0) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1001 	}
1002 
1003 	function logBytes28(bytes28 p0) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1005 	}
1006 
1007 	function logBytes29(bytes29 p0) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1009 	}
1010 
1011 	function logBytes30(bytes30 p0) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1013 	}
1014 
1015 	function logBytes31(bytes31 p0) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1017 	}
1018 
1019 	function logBytes32(bytes32 p0) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1021 	}
1022 
1023 	function log(uint p0) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1025 	}
1026 
1027 	function log(string memory p0) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1029 	}
1030 
1031 	function log(bool p0) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1033 	}
1034 
1035 	function log(address p0) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1037 	}
1038 
1039 	function log(uint p0, uint p1) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1041 	}
1042 
1043 	function log(uint p0, string memory p1) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1045 	}
1046 
1047 	function log(uint p0, bool p1) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1049 	}
1050 
1051 	function log(uint p0, address p1) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1053 	}
1054 
1055 	function log(string memory p0, uint p1) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1057 	}
1058 
1059 	function log(string memory p0, string memory p1) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1061 	}
1062 
1063 	function log(string memory p0, bool p1) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1065 	}
1066 
1067 	function log(string memory p0, address p1) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1069 	}
1070 
1071 	function log(bool p0, uint p1) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1073 	}
1074 
1075 	function log(bool p0, string memory p1) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1077 	}
1078 
1079 	function log(bool p0, bool p1) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1081 	}
1082 
1083 	function log(bool p0, address p1) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1085 	}
1086 
1087 	function log(address p0, uint p1) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1089 	}
1090 
1091 	function log(address p0, string memory p1) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1093 	}
1094 
1095 	function log(address p0, bool p1) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1097 	}
1098 
1099 	function log(address p0, address p1) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1101 	}
1102 
1103 	function log(uint p0, uint p1, uint p2) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1105 	}
1106 
1107 	function log(uint p0, uint p1, string memory p2) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1109 	}
1110 
1111 	function log(uint p0, uint p1, bool p2) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1113 	}
1114 
1115 	function log(uint p0, uint p1, address p2) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1117 	}
1118 
1119 	function log(uint p0, string memory p1, uint p2) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1121 	}
1122 
1123 	function log(uint p0, string memory p1, string memory p2) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1125 	}
1126 
1127 	function log(uint p0, string memory p1, bool p2) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1129 	}
1130 
1131 	function log(uint p0, string memory p1, address p2) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1133 	}
1134 
1135 	function log(uint p0, bool p1, uint p2) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1137 	}
1138 
1139 	function log(uint p0, bool p1, string memory p2) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1141 	}
1142 
1143 	function log(uint p0, bool p1, bool p2) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1145 	}
1146 
1147 	function log(uint p0, bool p1, address p2) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1149 	}
1150 
1151 	function log(uint p0, address p1, uint p2) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1153 	}
1154 
1155 	function log(uint p0, address p1, string memory p2) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1157 	}
1158 
1159 	function log(uint p0, address p1, bool p2) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1161 	}
1162 
1163 	function log(uint p0, address p1, address p2) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1165 	}
1166 
1167 	function log(string memory p0, uint p1, uint p2) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1169 	}
1170 
1171 	function log(string memory p0, uint p1, string memory p2) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1173 	}
1174 
1175 	function log(string memory p0, uint p1, bool p2) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1177 	}
1178 
1179 	function log(string memory p0, uint p1, address p2) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1181 	}
1182 
1183 	function log(string memory p0, string memory p1, uint p2) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1185 	}
1186 
1187 	function log(string memory p0, string memory p1, string memory p2) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1189 	}
1190 
1191 	function log(string memory p0, string memory p1, bool p2) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1193 	}
1194 
1195 	function log(string memory p0, string memory p1, address p2) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1197 	}
1198 
1199 	function log(string memory p0, bool p1, uint p2) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1201 	}
1202 
1203 	function log(string memory p0, bool p1, string memory p2) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1205 	}
1206 
1207 	function log(string memory p0, bool p1, bool p2) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1209 	}
1210 
1211 	function log(string memory p0, bool p1, address p2) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1213 	}
1214 
1215 	function log(string memory p0, address p1, uint p2) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1217 	}
1218 
1219 	function log(string memory p0, address p1, string memory p2) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1221 	}
1222 
1223 	function log(string memory p0, address p1, bool p2) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1225 	}
1226 
1227 	function log(string memory p0, address p1, address p2) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1229 	}
1230 
1231 	function log(bool p0, uint p1, uint p2) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1233 	}
1234 
1235 	function log(bool p0, uint p1, string memory p2) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1237 	}
1238 
1239 	function log(bool p0, uint p1, bool p2) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1241 	}
1242 
1243 	function log(bool p0, uint p1, address p2) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1245 	}
1246 
1247 	function log(bool p0, string memory p1, uint p2) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1249 	}
1250 
1251 	function log(bool p0, string memory p1, string memory p2) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1253 	}
1254 
1255 	function log(bool p0, string memory p1, bool p2) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1257 	}
1258 
1259 	function log(bool p0, string memory p1, address p2) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1261 	}
1262 
1263 	function log(bool p0, bool p1, uint p2) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1265 	}
1266 
1267 	function log(bool p0, bool p1, string memory p2) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1269 	}
1270 
1271 	function log(bool p0, bool p1, bool p2) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1273 	}
1274 
1275 	function log(bool p0, bool p1, address p2) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1277 	}
1278 
1279 	function log(bool p0, address p1, uint p2) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1281 	}
1282 
1283 	function log(bool p0, address p1, string memory p2) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1285 	}
1286 
1287 	function log(bool p0, address p1, bool p2) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1289 	}
1290 
1291 	function log(bool p0, address p1, address p2) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1293 	}
1294 
1295 	function log(address p0, uint p1, uint p2) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1297 	}
1298 
1299 	function log(address p0, uint p1, string memory p2) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1301 	}
1302 
1303 	function log(address p0, uint p1, bool p2) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1305 	}
1306 
1307 	function log(address p0, uint p1, address p2) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1309 	}
1310 
1311 	function log(address p0, string memory p1, uint p2) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1313 	}
1314 
1315 	function log(address p0, string memory p1, string memory p2) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1317 	}
1318 
1319 	function log(address p0, string memory p1, bool p2) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1321 	}
1322 
1323 	function log(address p0, string memory p1, address p2) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1325 	}
1326 
1327 	function log(address p0, bool p1, uint p2) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1329 	}
1330 
1331 	function log(address p0, bool p1, string memory p2) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1333 	}
1334 
1335 	function log(address p0, bool p1, bool p2) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1337 	}
1338 
1339 	function log(address p0, bool p1, address p2) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1341 	}
1342 
1343 	function log(address p0, address p1, uint p2) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1345 	}
1346 
1347 	function log(address p0, address p1, string memory p2) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1349 	}
1350 
1351 	function log(address p0, address p1, bool p2) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1353 	}
1354 
1355 	function log(address p0, address p1, address p2) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1357 	}
1358 
1359 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(uint p0, uint p1, address p2, address p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(uint p0, bool p1, address p2, address p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1557 	}
1558 
1559 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1561 	}
1562 
1563 	function log(uint p0, address p1, uint p2, address p3) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1565 	}
1566 
1567 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1569 	}
1570 
1571 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1573 	}
1574 
1575 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1577 	}
1578 
1579 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1581 	}
1582 
1583 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1585 	}
1586 
1587 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1589 	}
1590 
1591 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1593 	}
1594 
1595 	function log(uint p0, address p1, bool p2, address p3) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1597 	}
1598 
1599 	function log(uint p0, address p1, address p2, uint p3) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1601 	}
1602 
1603 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1605 	}
1606 
1607 	function log(uint p0, address p1, address p2, bool p3) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1609 	}
1610 
1611 	function log(uint p0, address p1, address p2, address p3) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1613 	}
1614 
1615 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1617 	}
1618 
1619 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1621 	}
1622 
1623 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1625 	}
1626 
1627 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1629 	}
1630 
1631 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1633 	}
1634 
1635 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1637 	}
1638 
1639 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1641 	}
1642 
1643 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1645 	}
1646 
1647 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1649 	}
1650 
1651 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1653 	}
1654 
1655 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1657 	}
1658 
1659 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1661 	}
1662 
1663 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1665 	}
1666 
1667 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1669 	}
1670 
1671 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1673 	}
1674 
1675 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1677 	}
1678 
1679 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1681 	}
1682 
1683 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1685 	}
1686 
1687 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1689 	}
1690 
1691 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1693 	}
1694 
1695 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1697 	}
1698 
1699 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1701 	}
1702 
1703 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1705 	}
1706 
1707 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1709 	}
1710 
1711 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1713 	}
1714 
1715 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1717 	}
1718 
1719 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1721 	}
1722 
1723 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1725 	}
1726 
1727 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1729 	}
1730 
1731 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1733 	}
1734 
1735 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1737 	}
1738 
1739 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1741 	}
1742 
1743 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1745 	}
1746 
1747 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1749 	}
1750 
1751 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1753 	}
1754 
1755 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1757 	}
1758 
1759 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1761 	}
1762 
1763 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1765 	}
1766 
1767 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1769 	}
1770 
1771 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1773 	}
1774 
1775 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1777 	}
1778 
1779 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1781 	}
1782 
1783 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1785 	}
1786 
1787 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1789 	}
1790 
1791 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1793 	}
1794 
1795 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1797 	}
1798 
1799 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1801 	}
1802 
1803 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1805 	}
1806 
1807 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1809 	}
1810 
1811 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1813 	}
1814 
1815 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(string memory p0, address p1, address p2, address p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(bool p0, uint p1, address p2, address p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(bool p0, bool p1, address p2, address p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(bool p0, address p1, uint p2, address p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(bool p0, address p1, bool p2, address p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(bool p0, address p1, address p2, uint p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(bool p0, address p1, address p2, bool p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(bool p0, address p1, address p2, address p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(address p0, uint p1, uint p2, address p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(address p0, uint p1, bool p2, address p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(address p0, uint p1, address p2, uint p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(address p0, uint p1, address p2, bool p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(address p0, uint p1, address p2, address p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(address p0, string memory p1, address p2, address p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(address p0, bool p1, uint p2, address p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(address p0, bool p1, bool p2, address p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(address p0, bool p1, address p2, uint p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(address p0, bool p1, address p2, bool p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(address p0, bool p1, address p2, address p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(address p0, address p1, uint p2, uint p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(address p0, address p1, uint p2, bool p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2329 	}
2330 
2331 	function log(address p0, address p1, uint p2, address p3) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2333 	}
2334 
2335 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2337 	}
2338 
2339 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2341 	}
2342 
2343 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2345 	}
2346 
2347 	function log(address p0, address p1, string memory p2, address p3) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2349 	}
2350 
2351 	function log(address p0, address p1, bool p2, uint p3) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2353 	}
2354 
2355 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2357 	}
2358 
2359 	function log(address p0, address p1, bool p2, bool p3) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2361 	}
2362 
2363 	function log(address p0, address p1, bool p2, address p3) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2365 	}
2366 
2367 	function log(address p0, address p1, address p2, uint p3) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2369 	}
2370 
2371 	function log(address p0, address p1, address p2, string memory p3) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2373 	}
2374 
2375 	function log(address p0, address p1, address p2, bool p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2377 	}
2378 
2379 	function log(address p0, address p1, address p2, address p3) internal view {
2380 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2381 	}
2382 
2383 }
2384 
2385 
2386 // File contracts/libraries/pools/Pool.sol
2387 
2388 pragma solidity ^0.6.12;
2389 pragma experimental ABIEncoderV2;
2390 
2391 
2392 
2393 
2394 
2395 /// @title Pool
2396 ///
2397 /// @dev A library which provides the Pool data struct and associated functions.
2398 library Pool {
2399   using FixedPointMath for FixedPointMath.uq192x64;
2400   using Pool for Pool.Data;
2401   using Pool for Pool.List;
2402   using SafeMath for uint256;
2403 
2404   struct Context {
2405     uint256 rewardRate;
2406     uint256 totalRewardWeight;
2407   }
2408 
2409   struct Data {
2410     IERC20 token;
2411     uint256 totalDeposited;
2412     uint256 rewardWeight;
2413     FixedPointMath.uq192x64 accumulatedRewardWeight;
2414     uint256 lastUpdatedBlock;
2415   }
2416 
2417   struct List {
2418     Data[] elements;
2419   }
2420 
2421   /// @dev Updates the pool.
2422   ///
2423   /// @param _ctx the pool context.
2424   function update(Data storage _data, Context storage _ctx) internal {
2425     _data.accumulatedRewardWeight = _data.getUpdatedAccumulatedRewardWeight(_ctx);
2426     _data.lastUpdatedBlock = block.number;
2427   }
2428 
2429   /// @dev Gets the rate at which the pool will distribute rewards to stakers.
2430   ///
2431   /// @param _ctx the pool context.
2432   ///
2433   /// @return the reward rate of the pool in tokens per block.
2434   function getRewardRate(Data storage _data, Context storage _ctx)
2435     internal view
2436     returns (uint256)
2437   {
2438     // console.log("get reward rate");
2439     // console.log(uint(_data.rewardWeight));
2440     // console.log(uint(_ctx.totalRewardWeight));
2441     // console.log(uint(_ctx.rewardRate));
2442     return _ctx.rewardRate.mul(_data.rewardWeight).div(_ctx.totalRewardWeight);
2443   }
2444 
2445   /// @dev Gets the accumulated reward weight of a pool.
2446   ///
2447   /// @param _ctx the pool context.
2448   ///
2449   /// @return the accumulated reward weight.
2450   function getUpdatedAccumulatedRewardWeight(Data storage _data, Context storage _ctx)
2451     internal view
2452     returns (FixedPointMath.uq192x64 memory)
2453   {
2454     if (_data.totalDeposited == 0) {
2455       return _data.accumulatedRewardWeight;
2456     }
2457 
2458     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
2459     if (_elapsedTime == 0) {
2460       return _data.accumulatedRewardWeight;
2461     }
2462 
2463     uint256 _rewardRate = _data.getRewardRate(_ctx);
2464     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
2465 
2466     if (_distributeAmount == 0) {
2467       return _data.accumulatedRewardWeight;
2468     }
2469 
2470     FixedPointMath.uq192x64 memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalDeposited);
2471     return _data.accumulatedRewardWeight.add(_rewardWeight);
2472   }
2473 
2474   /// @dev Adds an element to the list.
2475   ///
2476   /// @param _element the element to add.
2477   function push(List storage _self, Data memory _element) internal {
2478     _self.elements.push(_element);
2479   }
2480 
2481   /// @dev Gets an element from the list.
2482   ///
2483   /// @param _index the index in the list.
2484   ///
2485   /// @return the element at the specified index.
2486   function get(List storage _self, uint256 _index) internal view returns (Data storage) {
2487     return _self.elements[_index];
2488   }
2489 
2490   /// @dev Gets the last element in the list.
2491   ///
2492   /// This function will revert if there are no elements in the list.
2493   ///ck
2494   /// @return the last element in the list.
2495   function last(List storage _self) internal view returns (Data storage) {
2496     return _self.elements[_self.lastIndex()];
2497   }
2498 
2499   /// @dev Gets the index of the last element in the list.
2500   ///
2501   /// This function will revert if there are no elements in the list.
2502   ///
2503   /// @return the index of the last element.
2504   function lastIndex(List storage _self) internal view returns (uint256) {
2505     uint256 _length = _self.length();
2506     return _length.sub(1, "Pool.List: list is empty");
2507   }
2508 
2509   /// @dev Gets the number of elements in the list.
2510   ///
2511   /// @return the number of elements.
2512   function length(List storage _self) internal view returns (uint256) {
2513     return _self.elements.length;
2514   }
2515 }
2516 
2517 
2518 // File contracts/libraries/pools/Stake.sol
2519 
2520 pragma solidity ^0.6.12;
2521 
2522 
2523 
2524 
2525 /// @title Stake
2526 ///
2527 /// @dev A library which provides the Stake data struct and associated functions.
2528 library Stake {
2529   using FixedPointMath for FixedPointMath.uq192x64;
2530   using Pool for Pool.Data;
2531   using SafeMath for uint256;
2532   using Stake for Stake.Data;
2533 
2534   struct Data {
2535     uint256 totalDeposited;
2536     uint256 totalUnclaimed;
2537     FixedPointMath.uq192x64 lastAccumulatedWeight;
2538   }
2539 
2540   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
2541     _self.totalUnclaimed = _self.getUpdatedTotalUnclaimed(_pool, _ctx);
2542     _self.lastAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
2543   }
2544 
2545   function getUpdatedTotalUnclaimed(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
2546     internal view
2547     returns (uint256)
2548   {
2549     FixedPointMath.uq192x64 memory _currentAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
2550     FixedPointMath.uq192x64 memory _lastAccumulatedWeight = _self.lastAccumulatedWeight;
2551 
2552     if (_currentAccumulatedWeight.cmp(_lastAccumulatedWeight) == 0) {
2553       return _self.totalUnclaimed;
2554     }
2555 
2556     uint256 _distributedAmount = _currentAccumulatedWeight
2557       .sub(_lastAccumulatedWeight)
2558       .mul(_self.totalDeposited)
2559       .decode();
2560 
2561     return _self.totalUnclaimed.add(_distributedAmount);
2562   }
2563 }
2564 
2565 
2566 // File contracts/StakingPools.sol
2567 
2568 pragma solidity ^0.6.12;
2569 
2570 //import "hardhat/console.sol";
2571 
2572 
2573 
2574 
2575 
2576 
2577 
2578 
2579 // __      __  _____    _________   _____ __________._______  ___
2580 // /  \    /  \/  _  \  /   _____/  /  _  \\______   \   \   \/  /  /\
2581 // \   \/\/   /  /_\  \ \_____  \  /  /_\  \|    |  _/   |\     /   \/
2582 // \        /    |    \/        \/    |    \    |   \   |/     \   /\
2583 //  \__/\  /\____|__  /_______  /\____|__  /______  /___/___/\  \  \/
2584 //       \/         \/        \/         \/       \/          \_/
2585 //      _______..___________.     ___       __  ___  __  .__   __.   _______    .______     ______     ______    __           _______.
2586 //     /       ||           |    /   \     |  |/  / |  | |  \ |  |  /  _____|   |   _  \   /  __  \   /  __  \  |  |         /       |
2587 //    |   (----``---|  |----`   /  ^  \    |  '  /  |  | |   \|  | |  |  __     |  |_)  | |  |  |  | |  |  |  | |  |        |   (----`
2588 //     \   \        |  |       /  /_\  \   |    <   |  | |  . `  | |  | |_ |    |   ___/  |  |  |  | |  |  |  | |  |         \   \
2589 // .----)   |       |  |      /  _____  \  |  .  \  |  | |  |\   | |  |__| |    |  |      |  `--'  | |  `--'  | |  `----..----)   |
2590 // |_______/        |__|     /__/     \__\ |__|\__\ |__| |__| \__|  \______|    | _|       \______/   \______/  |_______||_______/
2591 ///
2592 /// @dev A contract which allows users to stake to farm tokens.
2593 ///
2594 /// This contract was inspired by Chef Nomi's 'MasterChef' contract which can be found in this
2595 /// repository: https://github.com/sushiswap/sushiswap.
2596 contract StakingPools is ReentrancyGuard {
2597   using FixedPointMath for FixedPointMath.uq192x64;
2598   using Pool for Pool.Data;
2599   using Pool for Pool.List;
2600   using SafeERC20 for IERC20;
2601   using SafeMath for uint256;
2602   using Stake for Stake.Data;
2603 
2604   event PendingGovernanceUpdated(
2605     address pendingGovernance
2606   );
2607 
2608   event GovernanceUpdated(
2609     address governance
2610   );
2611 
2612   event RewardRateUpdated(
2613     uint256 rewardRate
2614   );
2615 
2616   event PoolRewardWeightUpdated(
2617     uint256 indexed poolId,
2618     uint256 rewardWeight
2619   );
2620 
2621   event PoolCreated(
2622     uint256 indexed poolId,
2623     IERC20 indexed token
2624   );
2625 
2626   event TokensDeposited(
2627     address indexed user,
2628     uint256 indexed poolId,
2629     uint256 amount
2630   );
2631 
2632   event TokensWithdrawn(
2633     address indexed user,
2634     uint256 indexed poolId,
2635     uint256 amount
2636   );
2637 
2638   event TokensClaimed(
2639     address indexed user,
2640     uint256 indexed poolId,
2641     uint256 amount
2642   );
2643 
2644   /// @dev The token which will be minted as a reward for staking.
2645   IMintableERC20 public reward;
2646 
2647   /// @dev The address of the account which currently has administrative capabilities over this contract.
2648   address public governance;
2649 
2650   address public pendingGovernance;
2651 
2652   /// @dev Tokens are mapped to their pool identifier plus one. Tokens that do not have an associated pool
2653   /// will return an identifier of zero.
2654   mapping(IERC20 => uint256) public tokenPoolIds;
2655 
2656   /// @dev The context shared between the pools.
2657   Pool.Context private _ctx;
2658 
2659   /// @dev A list of all of the pools.
2660   Pool.List private _pools;
2661 
2662   /// @dev A mapping of all of the user stakes mapped first by pool and then by address.
2663   mapping(address => mapping(uint256 => Stake.Data)) private _stakes;
2664 
2665   constructor(
2666     IMintableERC20 _reward,
2667     address _governance
2668   ) public {
2669     require(_governance != address(0), "StakingPools: governance address cannot be 0x0");
2670 
2671     reward = _reward;
2672     governance = _governance;
2673   }
2674 
2675   /// @dev A modifier which reverts when the caller is not the governance.
2676   modifier onlyGovernance() {
2677     require(msg.sender == governance, "StakingPools: only governance");
2678     _;
2679   }
2680 
2681   /// @dev Sets the governance.
2682   ///
2683   /// This function can only called by the current governance.
2684   ///
2685   /// @param _pendingGovernance the new pending governance.
2686   function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
2687     require(_pendingGovernance != address(0), "StakingPools: pending governance address cannot be 0x0");
2688     pendingGovernance = _pendingGovernance;
2689 
2690     emit PendingGovernanceUpdated(_pendingGovernance);
2691   }
2692 
2693   function acceptGovernance() external {
2694     require(msg.sender == pendingGovernance, "StakingPools: only pending governance");
2695 
2696     address _pendingGovernance = pendingGovernance;
2697     governance = _pendingGovernance;
2698 
2699     emit GovernanceUpdated(_pendingGovernance);
2700   }
2701 
2702   /// @dev Sets the distribution reward rate.
2703   ///
2704   /// This will update all of the pools.
2705   ///
2706   /// @param _rewardRate The number of tokens to distribute per second.
2707   function setRewardRate(uint256 _rewardRate) external onlyGovernance {
2708     _updatePools();
2709 
2710     _ctx.rewardRate = _rewardRate;
2711 
2712     emit RewardRateUpdated(_rewardRate);
2713   }
2714 
2715   /// @dev Creates a new pool.
2716   ///
2717   /// The created pool will need to have its reward weight initialized before it begins generating rewards.
2718   ///
2719   /// @param _token The token the pool will accept for staking.
2720   ///
2721   /// @return the identifier for the newly created pool.
2722   function createPool(IERC20 _token) external onlyGovernance returns (uint256) {
2723     require(tokenPoolIds[_token] == 0, "StakingPools: token already has a pool");
2724 
2725     uint256 _poolId = _pools.length();
2726 
2727     _pools.push(Pool.Data({
2728       token: _token,
2729       totalDeposited: 0,
2730       rewardWeight: 0,
2731       accumulatedRewardWeight: FixedPointMath.uq192x64(0),
2732       lastUpdatedBlock: block.number
2733     }));
2734 
2735     tokenPoolIds[_token] = _poolId + 1;
2736 
2737     emit PoolCreated(_poolId, _token);
2738 
2739     return _poolId;
2740   }
2741 
2742   /// @dev Sets the reward weights of all of the pools.
2743   ///
2744   /// @param _rewardWeights The reward weights of all of the pools.
2745   function setRewardWeights(uint256[] calldata _rewardWeights) external onlyGovernance {
2746     require(_rewardWeights.length == _pools.length(), "StakingPools: weights length mismatch");
2747 
2748     _updatePools();
2749 
2750     uint256 _totalRewardWeight = _ctx.totalRewardWeight;
2751     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
2752       Pool.Data storage _pool = _pools.get(_poolId);
2753 
2754       uint256 _currentRewardWeight = _pool.rewardWeight;
2755       if (_currentRewardWeight == _rewardWeights[_poolId]) {
2756         continue;
2757       }
2758 
2759       // FIXME
2760       _totalRewardWeight = _totalRewardWeight.sub(_currentRewardWeight).add(_rewardWeights[_poolId]);
2761       _pool.rewardWeight = _rewardWeights[_poolId];
2762 
2763       emit PoolRewardWeightUpdated(_poolId, _rewardWeights[_poolId]);
2764     }
2765 
2766     _ctx.totalRewardWeight = _totalRewardWeight;
2767   }
2768 
2769   /// @dev Stakes tokens into a pool.
2770   ///
2771   /// @param _poolId        the pool to deposit tokens into.
2772   /// @param _depositAmount the amount of tokens to deposit.
2773   function deposit(uint256 _poolId, uint256 _depositAmount) external nonReentrant {
2774     Pool.Data storage _pool = _pools.get(_poolId);
2775     _pool.update(_ctx);
2776 
2777     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2778     _stake.update(_pool, _ctx);
2779 
2780     _deposit(_poolId, _depositAmount);
2781   }
2782 
2783   /// @dev Withdraws staked tokens from a pool.
2784   ///
2785   /// @param _poolId          The pool to withdraw staked tokens from.
2786   /// @param _withdrawAmount  The number of tokens to withdraw.
2787   function withdraw(uint256 _poolId, uint256 _withdrawAmount) external nonReentrant {
2788     Pool.Data storage _pool = _pools.get(_poolId);
2789     _pool.update(_ctx);
2790 
2791     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2792     _stake.update(_pool, _ctx);
2793 
2794     _claim(_poolId);
2795     _withdraw(_poolId, _withdrawAmount);
2796   }
2797 
2798   /// @dev Claims all rewarded tokens from a pool.
2799   ///
2800   /// @param _poolId The pool to claim rewards from.
2801   ///
2802   /// @notice use this function to claim the tokens from a corresponding pool by ID.
2803   function claim(uint256 _poolId) external nonReentrant {
2804     Pool.Data storage _pool = _pools.get(_poolId);
2805     _pool.update(_ctx);
2806 
2807     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2808     _stake.update(_pool, _ctx);
2809 
2810     _claim(_poolId);
2811   }
2812 
2813   /// @dev Claims all rewards from a pool and then withdraws all staked tokens.
2814   ///
2815   /// @param _poolId the pool to exit from.
2816   function exit(uint256 _poolId) external nonReentrant {
2817     Pool.Data storage _pool = _pools.get(_poolId);
2818     _pool.update(_ctx);
2819 
2820     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2821     _stake.update(_pool, _ctx);
2822 
2823     _claim(_poolId);
2824     _withdraw(_poolId, _stake.totalDeposited);
2825   }
2826 
2827   /// @dev Gets the rate at which tokens are minted to stakers for all pools.
2828   ///
2829   /// @return the reward rate.
2830   function rewardRate() external view returns (uint256) {
2831     return _ctx.rewardRate;
2832   }
2833 
2834   /// @dev Gets the total reward weight between all the pools.
2835   ///
2836   /// @return the total reward weight.
2837   function totalRewardWeight() external view returns (uint256) {
2838     return _ctx.totalRewardWeight;
2839   }
2840 
2841   /// @dev Gets the number of pools that exist.
2842   ///
2843   /// @return the pool count.
2844   function poolCount() external view returns (uint256) {
2845     return _pools.length();
2846   }
2847 
2848   /// @dev Gets the token a pool accepts.
2849   ///
2850   /// @param _poolId the identifier of the pool.
2851   ///
2852   /// @return the token.
2853   function getPoolToken(uint256 _poolId) external view returns (IERC20) {
2854     Pool.Data storage _pool = _pools.get(_poolId);
2855     return _pool.token;
2856   }
2857 
2858   /// @dev Gets the total amount of funds staked in a pool.
2859   ///
2860   /// @param _poolId the identifier of the pool.
2861   ///
2862   /// @return the total amount of staked or deposited tokens.
2863   function getPoolTotalDeposited(uint256 _poolId) external view returns (uint256) {
2864     Pool.Data storage _pool = _pools.get(_poolId);
2865     return _pool.totalDeposited;
2866   }
2867 
2868   /// @dev Gets the reward weight of a pool which determines how much of the total rewards it receives per block.
2869   ///
2870   /// @param _poolId the identifier of the pool.
2871   ///
2872   /// @return the pool reward weight.
2873   function getPoolRewardWeight(uint256 _poolId) external view returns (uint256) {
2874     Pool.Data storage _pool = _pools.get(_poolId);
2875     return _pool.rewardWeight;
2876   }
2877 
2878   /// @dev Gets the amount of tokens per block being distributed to stakers for a pool.
2879   ///
2880   /// @param _poolId the identifier of the pool.
2881   ///
2882   /// @return the pool reward rate.
2883   function getPoolRewardRate(uint256 _poolId) external view returns (uint256) {
2884     Pool.Data storage _pool = _pools.get(_poolId);
2885     return _pool.getRewardRate(_ctx);
2886   }
2887 
2888   /// @dev Gets the number of tokens a user has staked into a pool.
2889   ///
2890   /// @param _account The account to query.
2891   /// @param _poolId  the identifier of the pool.
2892   ///
2893   /// @return the amount of deposited tokens.
2894   function getStakeTotalDeposited(address _account, uint256 _poolId) external view returns (uint256) {
2895     Stake.Data storage _stake = _stakes[_account][_poolId];
2896     return _stake.totalDeposited;
2897   }
2898 
2899   /// @dev Gets the number of unclaimed reward tokens a user can claim from a pool.
2900   ///
2901   /// @param _account The account to get the unclaimed balance of.
2902   /// @param _poolId  The pool to check for unclaimed rewards.
2903   ///
2904   /// @return the amount of unclaimed reward tokens a user has in a pool.
2905   function getStakeTotalUnclaimed(address _account, uint256 _poolId) external view returns (uint256) {
2906     Stake.Data storage _stake = _stakes[_account][_poolId];
2907     return _stake.getUpdatedTotalUnclaimed(_pools.get(_poolId), _ctx);
2908   }
2909 
2910   /// @dev Updates all of the pools.
2911   function _updatePools() internal {
2912     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
2913       Pool.Data storage _pool = _pools.get(_poolId);
2914       _pool.update(_ctx);
2915     }
2916   }
2917 
2918   /// @dev Stakes tokens into a pool.
2919   ///
2920   /// The pool and stake MUST be updated before calling this function.
2921   ///
2922   /// @param _poolId        the pool to deposit tokens into.
2923   /// @param _depositAmount the amount of tokens to deposit.
2924   function _deposit(uint256 _poolId, uint256 _depositAmount) internal {
2925     Pool.Data storage _pool = _pools.get(_poolId);
2926     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2927 
2928     _pool.totalDeposited = _pool.totalDeposited.add(_depositAmount);
2929     _stake.totalDeposited = _stake.totalDeposited.add(_depositAmount);
2930 
2931     _pool.token.safeTransferFrom(msg.sender, address(this), _depositAmount);
2932 
2933     emit TokensDeposited(msg.sender, _poolId, _depositAmount);
2934   }
2935 
2936   /// @dev Withdraws staked tokens from a pool.
2937   ///
2938   /// The pool and stake MUST be updated before calling this function.
2939   ///
2940   /// @param _poolId          The pool to withdraw staked tokens from.
2941   /// @param _withdrawAmount  The number of tokens to withdraw.
2942   function _withdraw(uint256 _poolId, uint256 _withdrawAmount) internal {
2943     Pool.Data storage _pool = _pools.get(_poolId);
2944     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2945 
2946     _pool.totalDeposited = _pool.totalDeposited.sub(_withdrawAmount);
2947     _stake.totalDeposited = _stake.totalDeposited.sub(_withdrawAmount);
2948 
2949     _pool.token.safeTransfer(msg.sender, _withdrawAmount);
2950 
2951     emit TokensWithdrawn(msg.sender, _poolId, _withdrawAmount);
2952   }
2953 
2954   /// @dev Claims all rewarded tokens from a pool.
2955   ///
2956   /// The pool and stake MUST be updated before calling this function.
2957   ///
2958   /// @param _poolId The pool to claim rewards from.
2959   ///
2960   /// @notice use this function to claim the tokens from a corresponding pool by ID.
2961   function _claim(uint256 _poolId) internal {
2962     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
2963 
2964     uint256 _claimAmount = _stake.totalUnclaimed;
2965     _stake.totalUnclaimed = 0;
2966 
2967     reward.mint(msg.sender, _claimAmount);
2968 
2969     emit TokensClaimed(msg.sender, _poolId, _claimAmount);
2970   }
2971 }