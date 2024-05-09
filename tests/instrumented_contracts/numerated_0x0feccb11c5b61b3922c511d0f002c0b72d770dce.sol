1 // File: interfaces/DelegatorInterface.sol
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 contract DelegationStorage {
7     /**
8      * @notice Implementation address for this contract
9      */
10     address public implementation;
11 }
12 
13 abstract contract DelegatorInterface is DelegationStorage {
14     /**
15      * @notice Emitted when implementation is changed
16      */
17     event NewImplementation(
18         address oldImplementation,
19         address newImplementation
20     );
21 
22     /**
23      * @notice Called by the admin to update the implementation of the delegator
24      * @param implementation_ The address of the new implementation for delegation
25      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
26      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
27      */
28     function _setImplementation(
29         address implementation_,
30         bool allowResign,
31         bytes memory becomeImplementationData
32     ) public virtual;
33 }
34 
35 abstract contract DelegateInterface is DelegationStorage {
36     /**
37      * @notice Called by the delegator on a delegate to initialize it for duty
38      * @dev Should revert if any issues arise which make it unfit for delegation
39      * @param data The encoded bytes data for any initialization
40      */
41     function _becomeImplementation(bytes memory data) public virtual;
42 
43     /**
44      * @notice Called by the delegator on a delegate to forfeit its responsibility
45      */
46     function _resignImplementation() public virtual;
47 }
48 
49 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
50 
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 // File: @openzeppelin/contracts/math/SafeMath.sol
129 
130 
131 
132 pragma solidity >=0.6.0 <0.8.0;
133 
134 /**
135  * @dev Wrappers over Solidity's arithmetic operations with added overflow
136  * checks.
137  *
138  * Arithmetic operations in Solidity wrap on overflow. This can easily result
139  * in bugs, because programmers usually assume that an overflow raises an
140  * error, which is the standard behavior in high level programming languages.
141  * `SafeMath` restores this intuition by reverting the transaction when an
142  * operation overflows.
143  *
144  * Using this library instead of the unchecked operations eliminates an entire
145  * class of bugs, so it's recommended to use it always.
146  */
147 library SafeMath {
148     /**
149      * @dev Returns the addition of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         uint256 c = a + b;
155         if (c < a) return (false, 0);
156         return (true, c);
157     }
158 
159     /**
160      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
161      *
162      * _Available since v3.4._
163      */
164     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         if (b > a) return (false, 0);
166         return (true, a - b);
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) return (true, 0);
179         uint256 c = a * b;
180         if (c / a != b) return (false, 0);
181         return (true, c);
182     }
183 
184     /**
185      * @dev Returns the division of two unsigned integers, with a division by zero flag.
186      *
187      * _Available since v3.4._
188      */
189     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
190         if (b == 0) return (false, 0);
191         return (true, a / b);
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
196      *
197      * _Available since v3.4._
198      */
199     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         if (b == 0) return (false, 0);
201         return (true, a % b);
202     }
203 
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      *
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217         return c;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b <= a, "SafeMath: subtraction overflow");
232         return a - b;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         if (a == 0) return 0;
247         uint256 c = a * b;
248         require(c / a == b, "SafeMath: multiplication overflow");
249         return c;
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers, reverting on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(uint256 a, uint256 b) internal pure returns (uint256) {
265         require(b > 0, "SafeMath: division by zero");
266         return a / b;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * reverting when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         require(b > 0, "SafeMath: modulo by zero");
283         return a % b;
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
288      * overflow (when the result is negative).
289      *
290      * CAUTION: This function is deprecated because it requires allocating memory for the error
291      * message unnecessarily. For custom revert reasons use {trySub}.
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      *
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b <= a, errorMessage);
301         return a - b;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryDiv}.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a / b;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * reverting with custom message when dividing by zero.
327      *
328      * CAUTION: This function is deprecated because it requires allocating memory for the error
329      * message unnecessarily. For custom revert reasons use {tryMod}.
330      *
331      * Counterpart to Solidity's `%` operator. This function uses a `revert`
332      * opcode (which leaves remaining gas untouched) while Solidity uses an
333      * invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b > 0, errorMessage);
341         return a % b;
342     }
343 }
344 
345 // File: @openzeppelin/contracts/utils/Address.sol
346 
347 
348 
349 pragma solidity >=0.6.2 <0.8.0;
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      */
372     function isContract(address account) internal view returns (bool) {
373         // This method relies on extcodesize, which returns 0 for contracts in
374         // construction, since the code is only stored at the end of the
375         // constructor execution.
376 
377         uint256 size;
378         // solhint-disable-next-line no-inline-assembly
379         assembly { size := extcodesize(account) }
380         return size > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
403         (bool success, ) = recipient.call{ value: amount }("");
404         require(success, "Address: unable to send value, recipient may have reverted");
405     }
406 
407     /**
408      * @dev Performs a Solidity function call using a low level `call`. A
409      * plain`call` is an unsafe replacement for a function call: use this
410      * function instead.
411      *
412      * If `target` reverts with a revert reason, it is bubbled up by this
413      * function (like regular Solidity function calls).
414      *
415      * Returns the raw returned data. To convert to the expected return value,
416      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
417      *
418      * Requirements:
419      *
420      * - `target` must be a contract.
421      * - calling `target` with `data` must not revert.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
426       return functionCall(target, data, "Address: low-level call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
431      * `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, 0, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but also transferring `value` wei to `target`.
442      *
443      * Requirements:
444      *
445      * - the calling contract must have an ETH balance of at least `value`.
446      * - the called Solidity function must be `payable`.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
451         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
456      * with `errorMessage` as a fallback revert reason when `target` reverts.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
461         require(address(this).balance >= value, "Address: insufficient balance for call");
462         require(isContract(target), "Address: call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.call{ value: value }(data);
466         return _verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return _verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
510         require(isContract(target), "Address: delegate call to non-contract");
511 
512         // solhint-disable-next-line avoid-low-level-calls
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return _verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
518         if (success) {
519             return returndata;
520         } else {
521             // Look for revert reason and bubble it up if present
522             if (returndata.length > 0) {
523                 // The easiest way to bubble the revert reason is using memory via assembly
524 
525                 // solhint-disable-next-line no-inline-assembly
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
538 
539 
540 
541 pragma solidity >=0.6.0 <0.8.0;
542 
543 
544 
545 
546 /**
547  * @title SafeERC20
548  * @dev Wrappers around ERC20 operations that throw on failure (when the token
549  * contract returns false). Tokens that return no value (and instead revert or
550  * throw on failure) are also supported, non-reverting calls are assumed to be
551  * successful.
552  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
553  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
554  */
555 library SafeERC20 {
556     using SafeMath for uint256;
557     using Address for address;
558 
559     function safeTransfer(IERC20 token, address to, uint256 value) internal {
560         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
561     }
562 
563     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
564         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
565     }
566 
567     /**
568      * @dev Deprecated. This function has issues similar to the ones found in
569      * {IERC20-approve}, and its usage is discouraged.
570      *
571      * Whenever possible, use {safeIncreaseAllowance} and
572      * {safeDecreaseAllowance} instead.
573      */
574     function safeApprove(IERC20 token, address spender, uint256 value) internal {
575         // safeApprove should only be called when setting an initial allowance,
576         // or when resetting it to zero. To increase and decrease it, use
577         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
578         // solhint-disable-next-line max-line-length
579         require((value == 0) || (token.allowance(address(this), spender) == 0),
580             "SafeERC20: approve from non-zero to non-zero allowance"
581         );
582         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
583     }
584 
585     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
586         uint256 newAllowance = token.allowance(address(this), spender).add(value);
587         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
588     }
589 
590     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
591         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
592         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
593     }
594 
595     /**
596      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
597      * on the return value: the return value is optional (but if data is returned, it must not be false).
598      * @param token The token targeted by the call.
599      * @param data The call data (encoded using abi.encode or one of its variants).
600      */
601     function _callOptionalReturn(IERC20 token, bytes memory data) private {
602         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
603         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
604         // the target address contains contract code and also asserts for success in the low-level call.
605 
606         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
607         if (returndata.length > 0) { // Return data is optional
608             // solhint-disable-next-line max-line-length
609             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
610         }
611     }
612 }
613 
614 // File: @openzeppelin/contracts/utils/Context.sol
615 
616 
617 
618 pragma solidity >=0.6.0 <0.8.0;
619 
620 /*
621  * @dev Provides information about the current execution context, including the
622  * sender of the transaction and its data. While these are generally available
623  * via msg.sender and msg.data, they should not be accessed in such a direct
624  * manner, since when dealing with GSN meta-transactions the account sending and
625  * paying for execution may not be the actual sender (as far as an application
626  * is concerned).
627  *
628  * This contract is only required for intermediate, library-like contracts.
629  */
630 abstract contract Context {
631     function _msgSender() internal view virtual returns (address payable) {
632         return msg.sender;
633     }
634 
635     function _msgData() internal view virtual returns (bytes memory) {
636         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
637         return msg.data;
638     }
639 }
640 
641 // File: @openzeppelin/contracts/access/Ownable.sol
642 
643 
644 
645 pragma solidity >=0.6.0 <0.8.0;
646 
647 /**
648  * @dev Contract module which provides a basic access control mechanism, where
649  * there is an account (an owner) that can be granted exclusive access to
650  * specific functions.
651  *
652  * By default, the owner account will be the one that deploys the contract. This
653  * can later be changed with {transferOwnership}.
654  *
655  * This module is used through inheritance. It will make available the modifier
656  * `onlyOwner`, which can be applied to your functions to restrict their use to
657  * the owner.
658  */
659 abstract contract Ownable is Context {
660     address private _owner;
661 
662     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
663 
664     /**
665      * @dev Initializes the contract setting the deployer as the initial owner.
666      */
667     constructor () internal {
668         address msgSender = _msgSender();
669         _owner = msgSender;
670         emit OwnershipTransferred(address(0), msgSender);
671     }
672 
673     /**
674      * @dev Returns the address of the current owner.
675      */
676     function owner() public view virtual returns (address) {
677         return _owner;
678     }
679 
680     /**
681      * @dev Throws if called by any account other than the owner.
682      */
683     modifier onlyOwner() {
684         require(owner() == _msgSender(), "Ownable: caller is not the owner");
685         _;
686     }
687 
688     /**
689      * @dev Leaves the contract without owner. It will not be possible to call
690      * `onlyOwner` functions anymore. Can only be called by the current owner.
691      *
692      * NOTE: Renouncing ownership will leave the contract without an owner,
693      * thereby removing any functionality that is only available to the owner.
694      */
695     function renounceOwnership() public virtual onlyOwner {
696         emit OwnershipTransferred(_owner, address(0));
697         _owner = address(0);
698     }
699 
700     /**
701      * @dev Transfers ownership of the contract to a new account (`newOwner`).
702      * Can only be called by the current owner.
703      */
704     function transferOwnership(address newOwner) public virtual onlyOwner {
705         require(newOwner != address(0), "Ownable: new owner is the zero address");
706         emit OwnershipTransferred(_owner, newOwner);
707         _owner = newOwner;
708     }
709 }
710 
711 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
712 
713 pragma solidity >=0.5.0;
714 
715 interface IUniswapV2Pair {
716     event Approval(address indexed owner, address indexed spender, uint value);
717     event Transfer(address indexed from, address indexed to, uint value);
718 
719     function name() external pure returns (string memory);
720     function symbol() external pure returns (string memory);
721     function decimals() external pure returns (uint8);
722     function totalSupply() external view returns (uint);
723     function balanceOf(address owner) external view returns (uint);
724     function allowance(address owner, address spender) external view returns (uint);
725 
726     function approve(address spender, uint value) external returns (bool);
727     function transfer(address to, uint value) external returns (bool);
728     function transferFrom(address from, address to, uint value) external returns (bool);
729 
730     function DOMAIN_SEPARATOR() external view returns (bytes32);
731     function PERMIT_TYPEHASH() external pure returns (bytes32);
732     function nonces(address owner) external view returns (uint);
733 
734     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
735 
736     event Mint(address indexed sender, uint amount0, uint amount1);
737     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
738     event Swap(
739         address indexed sender,
740         uint amount0In,
741         uint amount1In,
742         uint amount0Out,
743         uint amount1Out,
744         address indexed to
745     );
746     event Sync(uint112 reserve0, uint112 reserve1);
747 
748     function MINIMUM_LIQUIDITY() external pure returns (uint);
749     function factory() external view returns (address);
750     function token0() external view returns (address);
751     function token1() external view returns (address);
752     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
753     function price0CumulativeLast() external view returns (uint);
754     function price1CumulativeLast() external view returns (uint);
755     function kLast() external view returns (uint);
756 
757     function mint(address to) external returns (uint liquidity);
758     function burn(address to) external returns (uint amount0, uint amount1);
759     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
760     function skim(address to) external;
761     function sync() external;
762 
763     function initialize(address, address) external;
764 }
765 
766 // File: contracts/ActivityBase.sol
767 
768 
769 pragma solidity 0.6.12;
770 
771 
772 
773 contract ActivityBase is Ownable{
774     using SafeMath for uint256;
775 
776     address public admin;
777     
778     address public marketingFund;
779     // token as the unit of measurement
780     address public WETHToken;
781     // invitee's supply 5% deposit weight to its invitor
782     uint256 public constant INVITEE_WEIGHT = 20; 
783     // invitee's supply 10% deposit weight to its invitor
784     uint256 public constant INVITOR_WEIGHT = 10;
785 
786     // The block number when SHARD mining starts.
787     uint256 public startBlock;
788 
789     // dev fund
790     uint256 public userDividendWeight;
791     uint256 public devDividendWeight;
792     address public developerDAOFund;
793 
794     // deposit limit
795     uint256 public amountFeeRateNumerator;
796     uint256 public amountfeeRateDenominator;
797 
798     // contract sender fee rate
799     uint256 public contractFeeRateNumerator;
800     uint256 public contractFeeRateDenominator;
801 
802     // Info of each user is Contract sender
803     mapping (uint256 => mapping (address => bool)) public isUserContractSender;
804     mapping (uint256 => uint256) public poolTokenAmountLimit;
805 
806     function setDividendWeight(uint256 _userDividendWeight, uint256 _devDividendWeight) public virtual{
807         checkAdmin();
808         require(
809             _userDividendWeight != 0 && _devDividendWeight != 0,
810             "invalid input"
811         );
812         userDividendWeight = _userDividendWeight;
813         devDividendWeight = _devDividendWeight;
814     }
815 
816     function setDeveloperDAOFund(address _developerDAOFund) public virtual onlyOwner {
817         developerDAOFund = _developerDAOFund;
818     }
819 
820     function setTokenAmountLimit(uint256 _pid, uint256 _tokenAmountLimit) public virtual {
821         checkAdmin();
822         poolTokenAmountLimit[_pid] = _tokenAmountLimit;
823     }
824 
825     function setTokenAmountLimitFeeRate(uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual {
826         checkAdmin();
827         require(
828             _feeRateDenominator >= _feeRateNumerator, "invalid input"
829         );
830         amountFeeRateNumerator = _feeRateNumerator;
831         amountfeeRateDenominator = _feeRateDenominator;
832     }
833 
834     function setContracSenderFeeRate(uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual {
835         checkAdmin();
836         require(
837             _feeRateDenominator >= _feeRateNumerator, "invalid input"
838         );
839         contractFeeRateNumerator = _feeRateNumerator;
840         contractFeeRateDenominator = _feeRateDenominator;
841     }
842 
843     function setStartBlock(uint256 _startBlock) public virtual onlyOwner { 
844         require(startBlock > block.number, "invalid start block");
845         startBlock = _startBlock;
846         updateAfterModifyStartBlock(_startBlock);
847     }
848 
849     function transferAdmin(address _admin) public virtual {
850         checkAdmin();
851         admin = _admin;
852     }
853 
854     function setMarketingFund(address _marketingFund) public virtual onlyOwner {
855         marketingFund = _marketingFund;
856     }
857 
858     function updateAfterModifyStartBlock(uint256 _newStartBlock) internal virtual{
859     }
860 
861     function calculateDividend(uint256 _pending, uint256 _pid, uint256 _userAmount, bool _isContractSender) internal view returns (uint256 _marketingFundDividend, uint256 _devDividend, uint256 _userDividend){
862         uint256 fee = 0;
863         if(_isContractSender && contractFeeRateDenominator > 0){
864             fee = _pending.mul(contractFeeRateNumerator).div(contractFeeRateDenominator);
865             _marketingFundDividend = _marketingFundDividend.add(fee);
866             _pending = _pending.sub(fee);
867         }
868         if(poolTokenAmountLimit[_pid] > 0 && amountfeeRateDenominator > 0 && _userAmount >= poolTokenAmountLimit[_pid]){
869             fee = _pending.mul(amountFeeRateNumerator).div(amountfeeRateDenominator);
870             _marketingFundDividend =_marketingFundDividend.add(fee);
871             _pending = _pending.sub(fee);
872         }
873         if(devDividendWeight > 0){
874             fee = _pending.mul(devDividendWeight).div(devDividendWeight.add(userDividendWeight));
875             _devDividend = _devDividend.add(fee);
876             _pending = _pending.sub(fee);
877         }
878         _userDividend = _pending;
879     }
880 
881     function judgeContractSender(uint256 _pid) internal {
882         if(msg.sender != tx.origin){
883             isUserContractSender[_pid][msg.sender] = true;
884         }
885     }
886 
887     function checkAdmin() internal view {
888         require(admin == msg.sender, "invalid authorized");
889     }
890 }
891 
892 // File: interfaces/IInvitation.sol
893 
894 pragma solidity 0.6.12;
895 
896 interface IInvitation{
897 
898     function acceptInvitation(address _invitor) external;
899 
900     function getInvitation(address _sender) external view returns(address _invitor, address[] memory _invitees, bool _isWithdrawn);
901     
902 }
903 
904 // File: contracts/MarketingMining.sol
905 
906 
907 pragma solidity 0.6.12;
908 
909 
910 
911 
912 
913 
914 
915 
916 contract MarketingMining is ActivityBase{
917     using SafeMath for uint256;
918     using SafeERC20 for IERC20;
919 
920     // Info of each user.
921     struct UserInfo {
922         uint256 amount; // How much token the user has provided.
923         uint256 originWeight; //initial weight
924         uint256 modifiedWeight; //take the invitation relationship into consideration.
925         uint256 revenue;
926         uint256 userDividend;
927         uint256 devDividend;
928         uint256 marketingFundDividend;
929         uint256 rewardDebt; // Reward debt. See explanation below.
930         bool withdrawnState;
931         bool isUsed;
932     }
933 
934     // Info of each pool.
935     struct PoolInfo {
936         uint256 tokenAmount;  // lock amount
937         IERC20 token;   // uniswapPair contract
938         uint256 allocPoint;
939         uint256 accumulativeDividend;
940         uint256 lastDividendHeight;  // last dividend block height
941         uint256 accShardPerWeight;
942         uint256 totalWeight;
943     }
944 
945     uint256 public constant BONUS_MULTIPLIER = 10;
946     // The SHARD TOKEN!
947     IERC20 public SHARD;
948     // Info of each user that stakes LP tokens.
949     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
950     // Info of each user that stakes LP tokens.
951     mapping (uint256 => mapping (address => uint256)) public userInviteeTotalAmount; // total invitee weight
952     // Info of each pool.
953     PoolInfo[] public poolInfo;
954     // Total allocation poitns. Must be the sum of all allocation poishard in all pools.
955     uint256 public totalAllocPoint = 0;
956     // SHARD tokens created per block.
957     uint256 public SHDPerBlock = 1045 * (1e16);
958 
959     //get invitation relationship
960     IInvitation public invitation;
961 
962     uint256 public bonusEndBlock;
963     uint256 public totalAvailableDividend;
964     
965     bool public isInitialized;
966     bool public isDepositAvailable;
967     bool public isRevenueWithdrawable;
968 
969     event AddPool(uint256 indexed pid, address tokenAddress);
970     event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 weight);
971     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
972 
973     function initialize(
974         IERC20 _SHARD,
975         IInvitation _invitation,
976         uint256 _bonusEndBlock,
977         uint256 _startBlock, 
978         uint256 _SHDPerBlock,
979         address _developerDAOFund,
980         address _marketingFund,
981         address _weth
982     ) public virtual onlyOwner{
983         require(!isInitialized, "contract has been initialized");
984         invitation = _invitation;
985         bonusEndBlock = _bonusEndBlock;
986         if (_startBlock < block.number) {
987             startBlock = block.number;
988         } else {
989             startBlock = _startBlock;
990         }
991         SHARD = _SHARD;
992         developerDAOFund = _developerDAOFund;
993         marketingFund = _marketingFund;
994         WETHToken = _weth;
995         if(_SHDPerBlock > 0){
996             SHDPerBlock = _SHDPerBlock;
997         }
998         userDividendWeight = 4;
999         devDividendWeight = 1;
1000 
1001         amountFeeRateNumerator = 1;
1002         amountfeeRateDenominator = 5;
1003 
1004         contractFeeRateNumerator = 1;
1005         contractFeeRateDenominator = 5;
1006         isDepositAvailable = true;
1007         isRevenueWithdrawable = false;
1008         isInitialized = true;
1009     }
1010 
1011     // Add a new pool. Can only be called by the owner.
1012     function add(uint256 _allocPoint, IERC20 _tokenAddress, bool _withUpdate) public virtual {
1013         checkAdmin();
1014         if(_withUpdate){
1015             massUpdatePools();
1016         }
1017         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1018         PoolInfo memory newpool = PoolInfo({
1019             token: _tokenAddress, 
1020             tokenAmount: 0,
1021             allocPoint: _allocPoint,
1022             lastDividendHeight: lastRewardBlock,
1023             accumulativeDividend: 0,
1024             accShardPerWeight: 0,
1025             totalWeight: 0
1026         });
1027         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1028         poolInfo.push(newpool);
1029         emit AddPool(poolInfo.length.sub(1), address(_tokenAddress));
1030     }
1031 
1032     // Update the given pool's allocation point. Can only be called by the owner.
1033     function setAllocationPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public virtual {
1034         checkAdmin();
1035         if (_withUpdate) {
1036             massUpdatePools();
1037         }
1038         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1039         poolInfo[_pid].allocPoint = _allocPoint;
1040     }
1041 
1042     function setSHDPerBlock(uint256 _SHDPerBlock, bool _withUpdate) public virtual {
1043         checkAdmin();
1044         if (_withUpdate) {
1045             massUpdatePools();
1046         }
1047         SHDPerBlock = _SHDPerBlock;
1048     }
1049 
1050     function setIsDepositAvailable(bool _isDepositAvailable) public virtual onlyOwner {
1051         isDepositAvailable = _isDepositAvailable;
1052     }
1053 
1054     function setIsRevenueWithdrawable(bool _isRevenueWithdrawable) public virtual onlyOwner {
1055         isRevenueWithdrawable = _isRevenueWithdrawable;
1056     }
1057 
1058     // update reward vairables for pools. Be careful of gas spending!
1059     function massUpdatePools() public virtual {
1060         uint256 poolCount = poolInfo.length;
1061         for(uint256 i = 0; i < poolCount; i ++){
1062             updatePoolDividend(i);
1063         }
1064     }
1065 
1066     function addAvailableDividend(uint256 _amount, bool _withUpdate) public virtual {
1067         if(_withUpdate){
1068             massUpdatePools();
1069         }
1070         SHARD.safeTransferFrom(address(msg.sender), address(this), _amount);
1071         totalAvailableDividend = totalAvailableDividend.add(_amount);
1072     }
1073 
1074     // update reward vairables for a pool
1075     function updatePoolDividend(uint256 _pid) public virtual {
1076         PoolInfo storage pool = poolInfo[_pid];
1077         if (block.number <= pool.lastDividendHeight) {
1078             return;
1079         }
1080         if (pool.tokenAmount == 0) {
1081             pool.lastDividendHeight = block.number;
1082             return;
1083         }
1084         uint256 availableDividend = totalAvailableDividend;
1085         uint256 multiplier = getMultiplier(pool.lastDividendHeight, block.number);
1086         uint256 producedToken = multiplier.mul(SHDPerBlock);
1087         producedToken = availableDividend > producedToken? producedToken: availableDividend;
1088         if(totalAllocPoint > 0){
1089             uint256 poolDevidend = producedToken.mul(pool.allocPoint).div(totalAllocPoint);
1090             if(poolDevidend > 0){
1091                 totalAvailableDividend = totalAvailableDividend.sub(poolDevidend);
1092                 pool.accumulativeDividend = pool.accumulativeDividend.add(poolDevidend);
1093                 pool.accShardPerWeight = pool.accShardPerWeight.add(poolDevidend.mul(1e12).div(pool.totalWeight));
1094             } 
1095         }
1096         pool.lastDividendHeight = block.number;
1097     }
1098 
1099     function depositETH(uint256 _pid) external payable virtual {
1100         require(address(poolInfo[_pid].token) == WETHToken, "invalid token");
1101         updateAfterDeposit(_pid, msg.value);
1102     }
1103 
1104     function withdrawETH(uint256 _pid, uint256 _amount) external virtual {
1105         require(address(poolInfo[_pid].token) == WETHToken, "invalid token");
1106         updateAfterwithdraw(_pid, _amount);
1107         if(_amount > 0){
1108             (bool success, ) = msg.sender.call{value: _amount}(new bytes(0));
1109             require(success, "Transfer: ETH_TRANSFER_FAILED");
1110         }
1111     }
1112 
1113     function updateAfterDeposit(uint256 _pid, uint256 _amount) internal{
1114         require(isDepositAvailable, "new invest is forbidden");
1115         require(_amount > 0, "invalid amount");
1116         (address invitor, , bool isWithdrawn) = invitation.getInvitation(msg.sender);
1117         require(invitor != address(0), "should be accept invitation firstly");
1118         updatePoolDividend(_pid);
1119         PoolInfo storage pool = poolInfo[_pid];
1120         UserInfo storage user = userInfo[_pid][msg.sender];
1121         UserInfo storage userInvitor = userInfo[_pid][invitor];
1122         uint256 existedAmount = user.amount;
1123         bool withdrawnState = user.withdrawnState;
1124         if(!user.isUsed){
1125             user.isUsed = true;
1126             judgeContractSender(_pid);
1127             withdrawnState = isWithdrawn;
1128         }
1129         if(!withdrawnState && userInvitor.amount > 0){
1130             updateUserRevenue(userInvitor, pool);
1131         }
1132         if(!withdrawnState){
1133             updateInvitorWeight(msg.sender, invitor, _pid, true, _amount, isWithdrawn, withdrawnState);
1134         }
1135 
1136         if(existedAmount > 0){ 
1137             updateUserRevenue(user, pool);
1138         }
1139 
1140         updateUserWeight(msg.sender, _pid, true, _amount, isWithdrawn);
1141         if(!withdrawnState && userInvitor.amount > 0){
1142             userInvitor.rewardDebt = userInvitor.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
1143         }  
1144         if(!withdrawnState){
1145             user.withdrawnState = isWithdrawn;
1146         }
1147         user.amount = existedAmount.add(_amount);
1148         user.rewardDebt = user.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
1149         pool.tokenAmount = pool.tokenAmount.add(_amount);
1150         emit Deposit(msg.sender, _pid, _amount, user.modifiedWeight);
1151     }
1152 
1153     // Deposit tokens to marketing mining for SHD allocation.
1154     function deposit(uint256 _pid, uint256 _amount) public virtual {
1155         require(address(poolInfo[_pid].token) != WETHToken, "invalid pid");
1156         IERC20(poolInfo[_pid].token).safeTransferFrom(address(msg.sender), address(this), _amount);
1157         updateAfterDeposit(_pid, _amount);
1158     }
1159 
1160     // Withdraw tokens from marketMining.
1161     function withdraw(uint256 _pid, uint256 _amount) public virtual {
1162         require(address(poolInfo[_pid].token) != WETHToken, "invalid pid");
1163         IERC20(poolInfo[_pid].token).safeTransfer(address(msg.sender), _amount);
1164         updateAfterwithdraw(_pid, _amount);
1165     }
1166 
1167     function updateAfterwithdraw(uint256 _pid, uint256 _amount) internal {
1168         (address invitor, , bool isWithdrawn) = invitation.getInvitation(msg.sender);
1169         PoolInfo storage pool = poolInfo[_pid];
1170         UserInfo storage user = userInfo[_pid][msg.sender];
1171         bool withdrawnState = user.withdrawnState;
1172         uint256 existedAmount = user.amount;
1173         require(existedAmount >= _amount, "withdraw: not good");
1174         updatePoolDividend(_pid);
1175         uint256 pending = updateUserRevenue(user, pool);
1176         UserInfo storage userInvitor = userInfo[_pid][invitor];
1177         if(!withdrawnState && userInvitor.amount > 0){
1178             updateUserRevenue(userInvitor, pool);
1179         }
1180         if(!withdrawnState){
1181             updateInvitorWeight(msg.sender, invitor, _pid, false, _amount, isWithdrawn, withdrawnState);
1182         }
1183         updateUserWeight(msg.sender, _pid, false, _amount, isWithdrawn);
1184         user.amount = existedAmount.sub(_amount);
1185         user.rewardDebt = user.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
1186         user.withdrawnState = isWithdrawn;
1187         if(!withdrawnState && userInvitor.amount > 0){
1188             userInvitor.rewardDebt = userInvitor.modifiedWeight.mul(pool.accShardPerWeight).div(1e12);
1189         }
1190         pool.tokenAmount = pool.tokenAmount.sub(_amount);
1191         user.revenue = 0;
1192         bool isContractSender = isUserContractSender[_pid][msg.sender];
1193         (uint256 marketingFundDividend, uint256 devDividend, uint256 userDividend) = calculateDividend(pending, _pid, existedAmount, isContractSender);
1194         user.userDividend = user.userDividend.add(userDividend);
1195         user.devDividend = user.devDividend.add(devDividend);
1196         if(marketingFundDividend > 0){
1197             user.marketingFundDividend = user.marketingFundDividend.add(marketingFundDividend);
1198         }
1199         if(isRevenueWithdrawable){
1200             devDividend = user.devDividend;
1201             userDividend = user.userDividend;
1202             marketingFundDividend = user.marketingFundDividend;
1203             if(devDividend > 0){
1204                 safeSHARDTransfer(developerDAOFund, devDividend);
1205             }
1206             if(userDividend > 0){
1207                 safeSHARDTransfer(msg.sender, userDividend);
1208             }
1209             if(marketingFundDividend > 0){
1210                 safeSHARDTransfer(marketingFund, marketingFundDividend);
1211             }
1212             user.devDividend = 0;
1213             user.userDividend = 0;
1214             user.marketingFundDividend = 0;
1215         }
1216         emit Withdraw(msg.sender, _pid, _amount);
1217     }
1218 
1219     // Safe SHD transfer function, just in case if rounding error causes pool to not have enough SHDs.
1220     function safeSHARDTransfer(address _to, uint256 _amount) internal {
1221         uint256 SHARDBal = SHARD.balanceOf(address(this));
1222         if (_amount > SHARDBal) {
1223             SHARD.transfer(_to, SHARDBal);
1224         } else {
1225             SHARD.transfer(_to, _amount);
1226         }
1227     }
1228 
1229     // Return reward multiplier over the given _from to _to block.
1230     function getMultiplier(uint256 _from, uint256 _to) public view virtual returns (uint256) {
1231         if (_to <= bonusEndBlock) {
1232             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1233         } else if (_from >= bonusEndBlock) {
1234             return _to.sub(_from);
1235         } else {
1236             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1237                 _to.sub(bonusEndBlock)
1238             );
1239         }
1240     }
1241 
1242     // View function to see pending SHDs on frontend.
1243     function pendingSHARD(uint256 _pid, address _user) external view virtual 
1244     returns (uint256 _pending, uint256 _potential, uint256 _blockNumber) {
1245         _blockNumber = block.number;
1246         (_pending, _potential) = calculatePendingSHARD(_pid, _user);
1247     }
1248 
1249     function pendingSHARDByPids(uint256[] memory _pids, address _user) external view virtual
1250     returns (uint256[] memory _pending, uint256[] memory _potential, uint256 _blockNumber){
1251         uint256 poolCount = _pids.length;
1252         _pending = new uint256[](poolCount);
1253         _potential = new uint256[](poolCount);
1254         _blockNumber = block.number;
1255         for(uint i = 0; i < poolCount; i ++){
1256             (_pending[i], _potential[i]) = calculatePendingSHARD(_pids[i], _user);
1257         }
1258     } 
1259 
1260     function calculatePendingSHARD(uint256 _pid, address _user) private view returns (uint256 _pending, uint256 _potential) {
1261         PoolInfo storage pool = poolInfo[_pid];
1262         UserInfo storage user = userInfo[_pid][_user];
1263         uint256 accShardPerWeight = pool.accShardPerWeight;
1264         _pending = user.modifiedWeight.mul(accShardPerWeight).div(1e12).sub(user.rewardDebt).add(user.revenue);
1265         bool isContractSender = isUserContractSender[_pid][_user];
1266         _potential = _pending;
1267         (,,_pending) = calculateDividend(_pending, _pid, user.amount, isContractSender);
1268         _pending = _pending.add(user.userDividend);
1269         uint256 lpSupply = pool.tokenAmount;
1270         if (block.number > pool.lastDividendHeight && lpSupply != 0) {
1271             uint256 multiplier = getMultiplier(pool.lastDividendHeight, block.number);
1272             uint256 totalUnupdateToken = multiplier.mul(SHDPerBlock);
1273             totalUnupdateToken = totalAvailableDividend > totalUnupdateToken? totalUnupdateToken: totalAvailableDividend;
1274             uint256 shardReward = totalUnupdateToken.mul(pool.allocPoint).div(totalAllocPoint);
1275             accShardPerWeight = accShardPerWeight.add(shardReward.mul(1e12).div(pool.totalWeight));
1276         }
1277         _potential = user.modifiedWeight.mul(accShardPerWeight).div(1e12).sub(user.rewardDebt).add(user.revenue).sub(_potential);
1278         (,,_potential) = calculateDividend(_potential, _pid, user.amount, isContractSender);
1279     }
1280 
1281     function getDepositWeight(uint256 _amount) public pure returns(uint256 weight){
1282         return _amount;
1283     }
1284 
1285     function getPoolLength() public view virtual returns(uint256){
1286         return poolInfo.length;
1287     }
1288 
1289     function getPoolInfo(uint256 _pid) public view virtual returns(uint256 _allocPoint, uint256 _accumulativeDividend, uint256 _usersTotalWeight, uint256 _tokenAmount, address _tokenAddress, uint256 _accs){
1290         PoolInfo storage pool = poolInfo[_pid];
1291         _allocPoint = pool.allocPoint;
1292         _accumulativeDividend = pool.accumulativeDividend;
1293         _usersTotalWeight = pool.totalWeight;
1294         _tokenAmount = pool.tokenAmount;
1295         _tokenAddress = address(pool.token);
1296         _accs = pool.accShardPerWeight;
1297     }
1298 
1299     function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex) public view virtual
1300     returns(uint256[] memory _allocPoint, uint256[] memory _accumulativeDividend, uint256[] memory _usersTotalWeight, uint256[] memory _tokenAmount, 
1301     address[] memory _tokenAddress, uint256[] memory _accs){
1302         uint256 poolCount = _toIndex.sub(_fromIndex).add(1);
1303         _allocPoint = new uint256[](poolCount);
1304         _accumulativeDividend = new uint256[](poolCount);
1305         _usersTotalWeight = new uint256[](poolCount);
1306         _tokenAmount = new uint256[](poolCount);
1307         _tokenAddress = new address[](poolCount);
1308         _accs = new uint256[](poolCount);
1309         uint256 startIndex = 0;
1310         for(uint i = _fromIndex; i <= _toIndex; i ++){
1311             PoolInfo storage pool = poolInfo[i];
1312             _allocPoint[startIndex] = pool.allocPoint;
1313             _accumulativeDividend[startIndex] = pool.accumulativeDividend;
1314             _usersTotalWeight[startIndex] = pool.totalWeight;
1315             _tokenAmount[startIndex] = pool.tokenAmount;
1316             _tokenAddress[startIndex] = address(pool.token);
1317             _accs[startIndex] = pool.accShardPerWeight;
1318             startIndex ++;
1319         }
1320     }
1321 
1322     function getUserInfoByPids(uint256[] memory _pids, address _user) public virtual view 
1323     returns(uint256[] memory _amount, uint256[] memory _modifiedWeight, uint256[] memory _revenue, uint256[] memory _userDividend, uint256[] memory _rewardDebt) {
1324         uint256 poolCount = _pids.length;
1325         _amount = new uint256[](poolCount);
1326         _modifiedWeight = new uint256[](poolCount);
1327         _revenue = new uint256[](poolCount);
1328         _userDividend = new uint256[](poolCount);
1329         _rewardDebt = new uint256[](poolCount);
1330         for(uint i = 0; i < poolCount; i ++){
1331             UserInfo storage user = userInfo[_pids[i]][_user];
1332             _amount[i] = user.amount;
1333             _modifiedWeight[i] = user.modifiedWeight;
1334             _revenue[i] = user.revenue;
1335             _userDividend[i] = user.userDividend;
1336             _rewardDebt[i] = user.rewardDebt;
1337         }
1338     }
1339 
1340     function updateUserRevenue(UserInfo storage _user, PoolInfo storage _pool) private returns (uint256){
1341         uint256 pending = _user.modifiedWeight.mul(_pool.accShardPerWeight).div(1e12).sub(_user.rewardDebt);
1342         _user.revenue = _user.revenue.add(pending);
1343         _pool.accumulativeDividend = _pool.accumulativeDividend.sub(pending);
1344         return _user.revenue;
1345     }
1346 
1347     function updateInvitorWeight(address _sender, address _invitor, uint256 _pid, bool _isAddAmount, uint256 _amount, bool _isWithdrawn, bool _withdrawnState) private {
1348         UserInfo storage user = userInfo[_pid][_sender];
1349         uint256 subInviteeAmount = 0;
1350         uint256 addInviteeAmount = 0;
1351         if(user.amount > 0  && !_withdrawnState){
1352             subInviteeAmount = user.originWeight;
1353         }
1354         if(!_isWithdrawn){
1355             if(_isAddAmount){
1356                 addInviteeAmount = getDepositWeight(user.amount.add(_amount));
1357             }
1358             else{ 
1359                 addInviteeAmount = getDepositWeight(user.amount.sub(_amount));
1360             }
1361         }
1362 
1363         UserInfo storage invitor = userInfo[_pid][_invitor];
1364         PoolInfo storage pool = poolInfo[_pid];
1365         uint256 inviteeAmountOfUserInvitor = userInviteeTotalAmount[_pid][_invitor];
1366         uint256 newInviteeAmountOfUserInvitor = inviteeAmountOfUserInvitor.add(addInviteeAmount).sub(subInviteeAmount);
1367         userInviteeTotalAmount[_pid][_invitor] = newInviteeAmountOfUserInvitor;
1368         if(invitor.amount > 0){
1369             invitor.modifiedWeight = invitor.modifiedWeight.add(newInviteeAmountOfUserInvitor.div(INVITEE_WEIGHT))
1370                                                                    .sub(inviteeAmountOfUserInvitor.div(INVITEE_WEIGHT));
1371             pool.totalWeight = pool.totalWeight.add(newInviteeAmountOfUserInvitor.div(INVITEE_WEIGHT))
1372                                                .sub(inviteeAmountOfUserInvitor.div(INVITEE_WEIGHT));                              
1373         }
1374     }
1375 
1376     function updateUserWeight(address _user, uint256 _pid, bool _isAddAmount, uint256 _amount, bool _isWithdrawn) private {
1377         UserInfo storage user = userInfo[_pid][_user];
1378         uint256 userOriginModifiedWeight = user.modifiedWeight;
1379         uint256 userNewModifiedWeight;
1380         if(_isAddAmount){
1381             userNewModifiedWeight = getDepositWeight(_amount.add(user.amount));
1382         }
1383         else{
1384             userNewModifiedWeight = getDepositWeight(user.amount.sub(_amount));
1385         }
1386         user.originWeight = userNewModifiedWeight;
1387         if(!_isWithdrawn){
1388             userNewModifiedWeight = userNewModifiedWeight.add(userNewModifiedWeight.div(INVITOR_WEIGHT));
1389         }
1390         uint256 inviteeAmountOfUser = userInviteeTotalAmount[_pid][msg.sender];
1391         userNewModifiedWeight = userNewModifiedWeight.add(inviteeAmountOfUser.div(INVITEE_WEIGHT));
1392         user.modifiedWeight = userNewModifiedWeight;
1393         PoolInfo storage pool = poolInfo[_pid];
1394         pool.totalWeight = pool.totalWeight.add(userNewModifiedWeight).sub(userOriginModifiedWeight);
1395     }
1396 
1397     function updateAfterModifyStartBlock(uint256 _newStartBlock) internal override{
1398         uint256 poolLenght = poolInfo.length;
1399         for(uint256 i = 0; i < poolLenght; i++){
1400             PoolInfo storage info = poolInfo[i];
1401             info.lastDividendHeight = _newStartBlock;
1402         }
1403     }
1404 }
1405 
1406 // File: contracts/MarketingMiningDelegator.sol
1407 
1408 
1409 pragma solidity 0.6.12;
1410 
1411 
1412 
1413 
1414 contract MarketingMiningDelegator is DelegatorInterface, MarketingMining {
1415     constructor(
1416         address _SHARD,
1417         address _invitation,
1418         uint256 _bonusEndBlock,
1419         uint256 _startBlock,
1420         uint256 _shardPerBlock,
1421         address _developerDAOFund,
1422         address _marketingFund,
1423         address _weth,
1424         address implementation_,
1425         bytes memory becomeImplementationData
1426     ) public {
1427         delegateTo(
1428             implementation_,
1429             abi.encodeWithSignature(
1430                 "initialize(address,address,uint256,uint256,uint256,address,address,address)",
1431                 _SHARD,
1432                 _invitation,
1433                 _bonusEndBlock,
1434                 _startBlock,
1435                 _shardPerBlock,
1436                 _developerDAOFund,
1437                 _marketingFund,
1438                 _weth
1439             )
1440         );
1441         admin = msg.sender;
1442         _setImplementation(implementation_, false, becomeImplementationData);
1443     }
1444 
1445     function _setImplementation(
1446         address implementation_,
1447         bool allowResign,
1448         bytes memory becomeImplementationData
1449     ) public override {
1450         checkAdmin();
1451         if (allowResign) {
1452             delegateToImplementation(
1453                 abi.encodeWithSignature("_resignImplementation()")
1454             );
1455         }
1456 
1457         address oldImplementation = implementation;
1458         implementation = implementation_;
1459 
1460         delegateToImplementation(
1461             abi.encodeWithSignature(
1462                 "_becomeImplementation(bytes)",
1463                 becomeImplementationData
1464             )
1465         );
1466 
1467         emit NewImplementation(oldImplementation, implementation);
1468     }
1469 
1470     function delegateTo(address callee, bytes memory data)
1471         internal
1472         returns (bytes memory)
1473     {
1474         (bool success, bytes memory returnData) = callee.delegatecall(data);
1475         assembly {
1476             if eq(success, 0) {
1477                 revert(add(returnData, 0x20), returndatasize())
1478             }
1479         }
1480         return returnData;
1481     }
1482 
1483     /**
1484      * @notice Delegates execution to the implementation contract
1485      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1486      * @param data The raw data to delegatecall
1487      * @return The returned bytes from the delegatecall
1488      */
1489     function delegateToImplementation(bytes memory data)
1490         public
1491         returns (bytes memory)
1492     {
1493         return delegateTo(implementation, data);
1494     }
1495 
1496     /**
1497      * @notice Delegates execution to an implementation contract
1498      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1499      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1500      * @param data The raw data to delegatecall
1501      * @return The returned bytes from the delegatecall
1502      */
1503     function delegateToViewImplementation(bytes memory data)
1504         public
1505         view
1506         returns (bytes memory)
1507     {
1508         (bool success, bytes memory returnData) =
1509             address(this).staticcall(
1510                 abi.encodeWithSignature("delegateToImplementation(bytes)", data)
1511             );
1512         assembly {
1513             if eq(success, 0) {
1514                 revert(add(returnData, 0x20), returndatasize())
1515             }
1516         }
1517         return abi.decode(returnData, (bytes));
1518     }
1519 
1520     /**
1521      * @notice Delegates execution to an implementation contract
1522      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1523     //  */
1524     fallback() external payable {
1525         if (msg.value > 0) return;
1526         // delegate all other functions to current implementation
1527         (bool success, ) = implementation.delegatecall(msg.data);
1528         assembly {
1529             let free_mem_ptr := mload(0x40)
1530             returndatacopy(free_mem_ptr, 0, returndatasize())
1531             switch success
1532                 case 0 {
1533                     revert(free_mem_ptr, returndatasize())
1534                 }
1535                 default {
1536                     return(free_mem_ptr, returndatasize())
1537                 }
1538         }
1539     }
1540 
1541     
1542     function add(
1543         uint256 _allocPoint,
1544         IERC20 _tokenAddress,
1545         bool _isUpdate
1546     ) public override {
1547         delegateToImplementation(
1548             abi.encodeWithSignature(
1549                 "add(uint256,address,bool)",
1550                 _allocPoint,
1551                 _tokenAddress,
1552                 _isUpdate
1553             )
1554         );
1555     }
1556 
1557     function setAllocationPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public override {
1558         delegateToImplementation(
1559             abi.encodeWithSignature(
1560                 "setAllocationPoint(uint256,uint256,bool)",
1561                 _pid,
1562                 _allocPoint,
1563                 _withUpdate
1564             )
1565         );
1566     }
1567 
1568     function setSHDPerBlock(uint256 _shardPerBlock, bool _withUpdate) public override {
1569         delegateToImplementation(
1570             abi.encodeWithSignature(
1571                 "setSHDPerBlock(uint256,bool)",
1572                 _shardPerBlock,
1573                 _withUpdate
1574             )
1575         );
1576     }
1577 
1578     function setIsDepositAvailable(bool _isDepositAvailable) public override {
1579         delegateToImplementation(
1580             abi.encodeWithSignature(
1581                 "setIsDepositAvailable(bool)",
1582                 _isDepositAvailable
1583             )
1584         );
1585     }
1586 
1587     function setIsRevenueWithdrawable(bool _isRevenueWithdrawable) public override {
1588         delegateToImplementation(
1589             abi.encodeWithSignature(
1590                 "setIsRevenueWithdrawable(bool)",
1591                 _isRevenueWithdrawable
1592             )
1593         );
1594     }
1595 
1596     function setStartBlock(
1597         uint256 _startBlock
1598     ) public override {
1599         delegateToImplementation(
1600             abi.encodeWithSignature(
1601                 "setStartBlock(uint256)",
1602                 _startBlock
1603             )
1604         );
1605     }
1606 
1607     function massUpdatePools() public override {
1608         delegateToImplementation(abi.encodeWithSignature("massUpdatePools()"));
1609     }
1610 
1611     function addAvailableDividend(uint256 _amount, bool _isUpdate) public override {
1612         delegateToImplementation(
1613             abi.encodeWithSignature("addAvailableDividend(uint256,bool)", _amount, _isUpdate)
1614         );
1615     }
1616 
1617     function updatePoolDividend(uint256 _pid) public override {
1618         delegateToImplementation(
1619             abi.encodeWithSignature("updatePoolDividend(uint256)", _pid)
1620         );
1621     }
1622 
1623     function depositETH(
1624         uint256 _pid
1625     ) external payable override {
1626         delegateToImplementation(
1627             abi.encodeWithSignature(
1628                 "depositETH(uint256)",
1629                 _pid
1630             )
1631         );
1632     }
1633 
1634     function deposit(
1635         uint256 _pid,
1636         uint256 _amount
1637     ) public override {
1638         delegateToImplementation(
1639             abi.encodeWithSignature(
1640                 "deposit(uint256,uint256)",
1641                 _pid,
1642                 _amount
1643             )
1644         );
1645     }
1646 
1647     function withdraw(uint256 _pid, uint256 _amount) public override {
1648         delegateToImplementation(
1649             abi.encodeWithSignature("withdraw(uint256,uint256)", _pid, _amount)
1650         );
1651     }
1652 
1653     function withdrawETH(uint256 _pid, uint256 _amount) external override {
1654         delegateToImplementation(
1655             abi.encodeWithSignature("withdrawETH(uint256,uint256)", _pid, _amount)
1656         );
1657     }
1658 
1659     function setDeveloperDAOFund(
1660     address _developer
1661     ) public override {
1662         delegateToImplementation(
1663             abi.encodeWithSignature(
1664                 "setDeveloperDAOFund(address)",
1665                 _developer
1666             )
1667         );
1668     }
1669 
1670     function setDividendWeight(
1671         uint256 _userDividendWeight,
1672         uint256 _devDividendWeight
1673     ) public override {
1674         delegateToImplementation(
1675             abi.encodeWithSignature(
1676                 "setDividendWeight(uint256,uint256)",
1677                 _userDividendWeight,
1678                 _devDividendWeight
1679             )
1680         );
1681     }
1682 
1683     function setTokenAmountLimit(
1684         uint256 _pid, 
1685         uint256 _tokenAmountLimit
1686     ) public override {
1687         delegateToImplementation(
1688             abi.encodeWithSignature(
1689                 "setTokenAmountLimit(uint256,uint256)",
1690                 _pid,
1691                 _tokenAmountLimit
1692             )
1693         );
1694     }
1695 
1696 
1697     function setTokenAmountLimitFeeRate(
1698         uint256 _feeRateNumerator,
1699         uint256 _feeRateDenominator
1700     ) public override {
1701         delegateToImplementation(
1702             abi.encodeWithSignature(
1703                 "setTokenAmountLimitFeeRate(uint256,uint256)",
1704                 _feeRateNumerator,
1705                 _feeRateDenominator
1706             )
1707         );
1708     }
1709 
1710     function setContracSenderFeeRate(
1711         uint256 _feeRateNumerator,
1712         uint256 _feeRateDenominator
1713     ) public override {
1714         delegateToImplementation(
1715             abi.encodeWithSignature(
1716                 "setContracSenderFeeRate(uint256,uint256)",
1717                 _feeRateNumerator,
1718                 _feeRateDenominator
1719             )
1720         );
1721     }
1722 
1723     function transferAdmin(
1724         address _admin
1725     ) public override {
1726         delegateToImplementation(
1727             abi.encodeWithSignature(
1728                 "transferAdmin(address)",
1729                 _admin
1730             )
1731         );
1732     }
1733 
1734     function setMarketingFund(
1735         address _marketingFund
1736     ) public override {
1737         delegateToImplementation(
1738             abi.encodeWithSignature(
1739                 "setMarketingFund(address)",
1740                 _marketingFund
1741             )
1742         );
1743     }
1744 
1745     function pendingSHARD(uint256 _pid, address _user)
1746         external
1747         view
1748         override
1749         returns (uint256, uint256, uint256)
1750     {
1751         bytes memory data =
1752             delegateToViewImplementation(
1753                 abi.encodeWithSignature(
1754                     "pendingSHARD(uint256,address)",
1755                     _pid,
1756                     _user
1757                 )
1758             );
1759         return abi.decode(data, (uint256, uint256, uint256));
1760     }
1761 
1762     function pendingSHARDByPids(uint256[] memory _pids, address _user)
1763         external
1764         view
1765         override
1766         returns (uint256[] memory _pending, uint256[] memory _potential, uint256 _blockNumber)
1767     {
1768         bytes memory data =
1769             delegateToViewImplementation(
1770                 abi.encodeWithSignature(
1771                     "pendingSHARDByPids(uint256[],address)",
1772                     _pids,
1773                     _user
1774                 )
1775             );
1776         return abi.decode(data, (uint256[], uint256[], uint256));
1777     }
1778 
1779     function getPoolLength() public view override returns (uint256) {
1780         bytes memory data =
1781             delegateToViewImplementation(
1782                 abi.encodeWithSignature("getPoolLength()")
1783             );
1784         return abi.decode(data, (uint256));
1785     }
1786 
1787     function getMultiplier(uint256 _from, uint256 _to) public view override returns (uint256) {
1788         bytes memory data =
1789             delegateToViewImplementation(
1790                 abi.encodeWithSignature("getMultiplier(uint256,uint256)", _from, _to)
1791             );
1792         return abi.decode(data, (uint256));
1793     }
1794 
1795     function getPoolInfo(uint256 _pid) 
1796         public 
1797         view 
1798         override
1799         returns(
1800             uint256 _allocPoint,
1801             uint256 _accumulativeDividend, 
1802             uint256 _usersTotalWeight, 
1803             uint256 _tokenAmount, 
1804             address _tokenAddress, 
1805             uint256 _accs)
1806     {
1807         bytes memory data =
1808             delegateToViewImplementation(
1809                 abi.encodeWithSignature(
1810                     "getPoolInfo(uint256)",
1811                     _pid
1812                 )
1813             );
1814             return
1815             abi.decode(
1816                 data,
1817                 (
1818                     uint256,
1819                     uint256,
1820                     uint256,
1821                     uint256,
1822                     address,
1823                     uint256
1824                 )
1825             );
1826     }
1827 
1828     function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
1829         public
1830         view
1831         override
1832         returns (
1833             uint256[] memory _allocPoint,
1834             uint256[] memory _accumulativeDividend, 
1835             uint256[] memory _usersTotalWeight, 
1836             uint256[] memory _tokenAmount, 
1837             address[] memory _tokenAddress, 
1838             uint256[] memory _accs
1839         )
1840     {
1841         bytes memory data =
1842             delegateToViewImplementation(
1843                 abi.encodeWithSignature(
1844                     "getPagePoolInfo(uint256,uint256)",
1845                     _fromIndex,
1846                     _toIndex
1847                 )
1848             );
1849         return
1850             abi.decode(
1851                 data,
1852                 (
1853                     uint256[],
1854                     uint256[],
1855                     uint256[],
1856                     uint256[],
1857                     address[],
1858                     uint256[]
1859                 )
1860             );
1861     }
1862 
1863     function getUserInfoByPids(uint256[] memory _pids,  address _user)
1864         public
1865         view
1866         override
1867         returns (
1868             uint256[] memory _amount,
1869             uint256[] memory _modifiedWeight, 
1870             uint256[] memory _revenue, 
1871             uint256[] memory _userDividend, 
1872             uint256[] memory _rewardDebt
1873         )
1874     {
1875         bytes memory data =
1876             delegateToViewImplementation(
1877                 abi.encodeWithSignature(
1878                     "getUserInfoByPids(uint256[],address)",
1879                     _pids,
1880                     _user
1881                 )
1882             );
1883         return
1884             abi.decode(
1885                 data,
1886                 (
1887                     uint256[],
1888                     uint256[],
1889                     uint256[],
1890                     uint256[],
1891                     uint256[]
1892                 )
1893             );
1894     }
1895 }