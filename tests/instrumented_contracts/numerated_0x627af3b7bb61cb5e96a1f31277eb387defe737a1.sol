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
52 
53 pragma solidity >=0.6.0 <0.8.0;
54 
55 /**
56  * @dev Interface of the ERC20 standard as defined in the EIP.
57  */
58 interface IERC20 {
59     /**
60      * @dev Returns the amount of tokens in existence.
61      */
62     function totalSupply() external view returns (uint256);
63 
64     /**
65      * @dev Returns the amount of tokens owned by `account`.
66      */
67     function balanceOf(address account) external view returns (uint256);
68 
69     /**
70      * @dev Moves `amount` tokens from the caller's account to `recipient`.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transfer(address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     /**
88      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * IMPORTANT: Beware that changing an allowance with this method brings the risk
93      * that someone may use both the old and the new allowance by unfortunate
94      * transaction ordering. One possible solution to mitigate this race
95      * condition is to first reduce the spender's allowance to 0 and set the
96      * desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      *
99      * Emits an {Approval} event.
100      */
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Moves `amount` tokens from `sender` to `recipient` using the
105      * allowance mechanism. `amount` is then deducted from the caller's
106      * allowance.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 // File: @openzeppelin/contracts/math/SafeMath.sol
130 
131 
132 
133 pragma solidity >=0.6.0 <0.8.0;
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         uint256 c = a + b;
156         if (c < a) return (false, 0);
157         return (true, c);
158     }
159 
160     /**
161      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
162      *
163      * _Available since v3.4._
164      */
165     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b > a) return (false, 0);
167         return (true, a - b);
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) return (true, 0);
180         uint256 c = a * b;
181         if (c / a != b) return (false, 0);
182         return (true, c);
183     }
184 
185     /**
186      * @dev Returns the division of two unsigned integers, with a division by zero flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         if (b == 0) return (false, 0);
192         return (true, a / b);
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         if (b == 0) return (false, 0);
202         return (true, a % b);
203     }
204 
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      *
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b <= a, "SafeMath: subtraction overflow");
233         return a - b;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      *
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         if (a == 0) return 0;
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250         return c;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: division by zero");
267         return a / b;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b > 0, "SafeMath: modulo by zero");
284         return a % b;
285     }
286 
287     /**
288      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
289      * overflow (when the result is negative).
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {trySub}.
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b <= a, errorMessage);
302         return a - b;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
307      * division by zero. The result is rounded towards zero.
308      *
309      * CAUTION: This function is deprecated because it requires allocating memory for the error
310      * message unnecessarily. For custom revert reasons use {tryDiv}.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
321         require(b > 0, errorMessage);
322         return a / b;
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * reverting with custom message when dividing by zero.
328      *
329      * CAUTION: This function is deprecated because it requires allocating memory for the error
330      * message unnecessarily. For custom revert reasons use {tryMod}.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b > 0, errorMessage);
342         return a % b;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/utils/Address.sol
347 
348 
349 
350 pragma solidity >=0.6.2 <0.8.0;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // This method relies on extcodesize, which returns 0 for contracts in
375         // construction, since the code is only stored at the end of the
376         // constructor execution.
377 
378         uint256 size;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { size := extcodesize(account) }
381         return size > 0;
382     }
383 
384     /**
385      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
386      * `recipient`, forwarding all available gas and reverting on errors.
387      *
388      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
389      * of certain opcodes, possibly making contracts go over the 2300 gas limit
390      * imposed by `transfer`, making them unable to receive funds via
391      * `transfer`. {sendValue} removes this limitation.
392      *
393      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
394      *
395      * IMPORTANT: because control is transferred to `recipient`, care must be
396      * taken to not create reentrancy vulnerabilities. Consider using
397      * {ReentrancyGuard} or the
398      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
399      */
400     function sendValue(address payable recipient, uint256 amount) internal {
401         require(address(this).balance >= amount, "Address: insufficient balance");
402 
403         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
404         (bool success, ) = recipient.call{ value: amount }("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain`call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
427       return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
437         return functionCallWithValue(target, data, 0, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but also transferring `value` wei to `target`.
443      *
444      * Requirements:
445      *
446      * - the calling contract must have an ETH balance of at least `value`.
447      * - the called Solidity function must be `payable`.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         // solhint-disable-next-line avoid-low-level-calls
466         (bool success, bytes memory returndata) = target.call{ value: value }(data);
467         return _verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
477         return functionStaticCall(target, data, "Address: low-level static call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         // solhint-disable-next-line avoid-low-level-calls
490         (bool success, bytes memory returndata) = target.staticcall(data);
491         return _verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
501         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
506      * but performing a delegate call.
507      *
508      * _Available since v3.4._
509      */
510     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         // solhint-disable-next-line avoid-low-level-calls
514         (bool success, bytes memory returndata) = target.delegatecall(data);
515         return _verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
519         if (success) {
520             return returndata;
521         } else {
522             // Look for revert reason and bubble it up if present
523             if (returndata.length > 0) {
524                 // The easiest way to bubble the revert reason is using memory via assembly
525 
526                 // solhint-disable-next-line no-inline-assembly
527                 assembly {
528                     let returndata_size := mload(returndata)
529                     revert(add(32, returndata), returndata_size)
530                 }
531             } else {
532                 revert(errorMessage);
533             }
534         }
535     }
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
539 
540 
541 
542 pragma solidity >=0.6.0 <0.8.0;
543 
544 
545 
546 
547 /**
548  * @title SafeERC20
549  * @dev Wrappers around ERC20 operations that throw on failure (when the token
550  * contract returns false). Tokens that return no value (and instead revert or
551  * throw on failure) are also supported, non-reverting calls are assumed to be
552  * successful.
553  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
554  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
555  */
556 library SafeERC20 {
557     using SafeMath for uint256;
558     using Address for address;
559 
560     function safeTransfer(IERC20 token, address to, uint256 value) internal {
561         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
562     }
563 
564     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
565         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
566     }
567 
568     /**
569      * @dev Deprecated. This function has issues similar to the ones found in
570      * {IERC20-approve}, and its usage is discouraged.
571      *
572      * Whenever possible, use {safeIncreaseAllowance} and
573      * {safeDecreaseAllowance} instead.
574      */
575     function safeApprove(IERC20 token, address spender, uint256 value) internal {
576         // safeApprove should only be called when setting an initial allowance,
577         // or when resetting it to zero. To increase and decrease it, use
578         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
579         // solhint-disable-next-line max-line-length
580         require((value == 0) || (token.allowance(address(this), spender) == 0),
581             "SafeERC20: approve from non-zero to non-zero allowance"
582         );
583         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
584     }
585 
586     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
587         uint256 newAllowance = token.allowance(address(this), spender).add(value);
588         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
589     }
590 
591     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
592         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
593         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
594     }
595 
596     /**
597      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
598      * on the return value: the return value is optional (but if data is returned, it must not be false).
599      * @param token The token targeted by the call.
600      * @param data The call data (encoded using abi.encode or one of its variants).
601      */
602     function _callOptionalReturn(IERC20 token, bytes memory data) private {
603         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
604         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
605         // the target address contains contract code and also asserts for success in the low-level call.
606 
607         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
608         if (returndata.length > 0) { // Return data is optional
609             // solhint-disable-next-line max-line-length
610             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
611         }
612     }
613 }
614 
615 // File: @openzeppelin/contracts/utils/Context.sol
616 
617 
618 
619 pragma solidity >=0.6.0 <0.8.0;
620 
621 /*
622  * @dev Provides information about the current execution context, including the
623  * sender of the transaction and its data. While these are generally available
624  * via msg.sender and msg.data, they should not be accessed in such a direct
625  * manner, since when dealing with GSN meta-transactions the account sending and
626  * paying for execution may not be the actual sender (as far as an application
627  * is concerned).
628  *
629  * This contract is only required for intermediate, library-like contracts.
630  */
631 abstract contract Context {
632     function _msgSender() internal view virtual returns (address payable) {
633         return msg.sender;
634     }
635 
636     function _msgData() internal view virtual returns (bytes memory) {
637         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
638         return msg.data;
639     }
640 }
641 
642 // File: @openzeppelin/contracts/access/Ownable.sol
643 
644 
645 
646 pragma solidity >=0.6.0 <0.8.0;
647 
648 /**
649  * @dev Contract module which provides a basic access control mechanism, where
650  * there is an account (an owner) that can be granted exclusive access to
651  * specific functions.
652  *
653  * By default, the owner account will be the one that deploys the contract. This
654  * can later be changed with {transferOwnership}.
655  *
656  * This module is used through inheritance. It will make available the modifier
657  * `onlyOwner`, which can be applied to your functions to restrict their use to
658  * the owner.
659  */
660 abstract contract Ownable is Context {
661     address private _owner;
662 
663     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
664 
665     /**
666      * @dev Initializes the contract setting the deployer as the initial owner.
667      */
668     constructor () internal {
669         address msgSender = _msgSender();
670         _owner = msgSender;
671         emit OwnershipTransferred(address(0), msgSender);
672     }
673 
674     /**
675      * @dev Returns the address of the current owner.
676      */
677     function owner() public view virtual returns (address) {
678         return _owner;
679     }
680 
681     /**
682      * @dev Throws if called by any account other than the owner.
683      */
684     modifier onlyOwner() {
685         require(owner() == _msgSender(), "Ownable: caller is not the owner");
686         _;
687     }
688 
689     /**
690      * @dev Leaves the contract without owner. It will not be possible to call
691      * `onlyOwner` functions anymore. Can only be called by the current owner.
692      *
693      * NOTE: Renouncing ownership will leave the contract without an owner,
694      * thereby removing any functionality that is only available to the owner.
695      */
696     function renounceOwnership() public virtual onlyOwner {
697         emit OwnershipTransferred(_owner, address(0));
698         _owner = address(0);
699     }
700 
701     /**
702      * @dev Transfers ownership of the contract to a new account (`newOwner`).
703      * Can only be called by the current owner.
704      */
705     function transferOwnership(address newOwner) public virtual onlyOwner {
706         require(newOwner != address(0), "Ownable: new owner is the zero address");
707         emit OwnershipTransferred(_owner, newOwner);
708         _owner = newOwner;
709     }
710 }
711 
712 // File: @uniswap/lib/contracts/libraries/FullMath.sol
713 
714 pragma solidity >=0.4.0;
715 
716 // taken from https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
717 // license is CC-BY-4.0
718 library FullMath {
719     function fullMul(uint256 x, uint256 y) internal pure returns (uint256 l, uint256 h) {
720         uint256 mm = mulmod(x, y, uint256(-1));
721         l = x * y;
722         h = mm - l;
723         if (mm < l) h -= 1;
724     }
725 
726     function fullDiv(
727         uint256 l,
728         uint256 h,
729         uint256 d
730     ) private pure returns (uint256) {
731         uint256 pow2 = d & -d;
732         d /= pow2;
733         l /= pow2;
734         l += h * ((-pow2) / pow2 + 1);
735         uint256 r = 1;
736         r *= 2 - d * r;
737         r *= 2 - d * r;
738         r *= 2 - d * r;
739         r *= 2 - d * r;
740         r *= 2 - d * r;
741         r *= 2 - d * r;
742         r *= 2 - d * r;
743         r *= 2 - d * r;
744         return l * r;
745     }
746 
747     function mulDiv(
748         uint256 x,
749         uint256 y,
750         uint256 d
751     ) internal pure returns (uint256) {
752         (uint256 l, uint256 h) = fullMul(x, y);
753 
754         uint256 mm = mulmod(x, y, d);
755         if (mm > l) h -= 1;
756         l -= mm;
757 
758         if (h == 0) return l / d;
759 
760         require(h < d, 'FullMath: FULLDIV_OVERFLOW');
761         return fullDiv(l, h, d);
762     }
763 }
764 
765 // File: @uniswap/lib/contracts/libraries/Babylonian.sol
766 
767 
768 pragma solidity >=0.4.0;
769 
770 // computes square roots using the babylonian method
771 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
772 library Babylonian {
773     // credit for this implementation goes to
774     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
775     function sqrt(uint256 x) internal pure returns (uint256) {
776         if (x == 0) return 0;
777         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
778         // however that code costs significantly more gas
779         uint256 xx = x;
780         uint256 r = 1;
781         if (xx >= 0x100000000000000000000000000000000) {
782             xx >>= 128;
783             r <<= 64;
784         }
785         if (xx >= 0x10000000000000000) {
786             xx >>= 64;
787             r <<= 32;
788         }
789         if (xx >= 0x100000000) {
790             xx >>= 32;
791             r <<= 16;
792         }
793         if (xx >= 0x10000) {
794             xx >>= 16;
795             r <<= 8;
796         }
797         if (xx >= 0x100) {
798             xx >>= 8;
799             r <<= 4;
800         }
801         if (xx >= 0x10) {
802             xx >>= 4;
803             r <<= 2;
804         }
805         if (xx >= 0x8) {
806             r <<= 1;
807         }
808         r = (r + x / r) >> 1;
809         r = (r + x / r) >> 1;
810         r = (r + x / r) >> 1;
811         r = (r + x / r) >> 1;
812         r = (r + x / r) >> 1;
813         r = (r + x / r) >> 1;
814         r = (r + x / r) >> 1; // Seven iterations should be enough
815         uint256 r1 = x / r;
816         return (r < r1 ? r : r1);
817     }
818 }
819 
820 // File: @uniswap/lib/contracts/libraries/BitMath.sol
821 
822 pragma solidity >=0.5.0;
823 
824 library BitMath {
825     // returns the 0 indexed position of the most significant bit of the input x
826     // s.t. x >= 2**msb and x < 2**(msb+1)
827     function mostSignificantBit(uint256 x) internal pure returns (uint8 r) {
828         require(x > 0, 'BitMath::mostSignificantBit: zero');
829 
830         if (x >= 0x100000000000000000000000000000000) {
831             x >>= 128;
832             r += 128;
833         }
834         if (x >= 0x10000000000000000) {
835             x >>= 64;
836             r += 64;
837         }
838         if (x >= 0x100000000) {
839             x >>= 32;
840             r += 32;
841         }
842         if (x >= 0x10000) {
843             x >>= 16;
844             r += 16;
845         }
846         if (x >= 0x100) {
847             x >>= 8;
848             r += 8;
849         }
850         if (x >= 0x10) {
851             x >>= 4;
852             r += 4;
853         }
854         if (x >= 0x4) {
855             x >>= 2;
856             r += 2;
857         }
858         if (x >= 0x2) r += 1;
859     }
860 
861     // returns the 0 indexed position of the least significant bit of the input x
862     // s.t. (x & 2**lsb) != 0 and (x & (2**(lsb) - 1)) == 0)
863     // i.e. the bit at the index is set and the mask of all lower bits is 0
864     function leastSignificantBit(uint256 x) internal pure returns (uint8 r) {
865         require(x > 0, 'BitMath::leastSignificantBit: zero');
866 
867         r = 255;
868         if (x & uint128(-1) > 0) {
869             r -= 128;
870         } else {
871             x >>= 128;
872         }
873         if (x & uint64(-1) > 0) {
874             r -= 64;
875         } else {
876             x >>= 64;
877         }
878         if (x & uint32(-1) > 0) {
879             r -= 32;
880         } else {
881             x >>= 32;
882         }
883         if (x & uint16(-1) > 0) {
884             r -= 16;
885         } else {
886             x >>= 16;
887         }
888         if (x & uint8(-1) > 0) {
889             r -= 8;
890         } else {
891             x >>= 8;
892         }
893         if (x & 0xf > 0) {
894             r -= 4;
895         } else {
896             x >>= 4;
897         }
898         if (x & 0x3 > 0) {
899             r -= 2;
900         } else {
901             x >>= 2;
902         }
903         if (x & 0x1 > 0) r -= 1;
904     }
905 }
906 
907 // File: @uniswap/lib/contracts/libraries/FixedPoint.sol
908 
909 pragma solidity >=0.4.0;
910 
911 
912 
913 
914 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
915 library FixedPoint {
916     // range: [0, 2**112 - 1]
917     // resolution: 1 / 2**112
918     struct uq112x112 {
919         uint224 _x;
920     }
921 
922     // range: [0, 2**144 - 1]
923     // resolution: 1 / 2**112
924     struct uq144x112 {
925         uint256 _x;
926     }
927 
928     uint8 public constant RESOLUTION = 112;
929     uint256 public constant Q112 = 0x10000000000000000000000000000; // 2**112
930     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000; // 2**224
931     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
932 
933     // encode a uint112 as a UQ112x112
934     function encode(uint112 x) internal pure returns (uq112x112 memory) {
935         return uq112x112(uint224(x) << RESOLUTION);
936     }
937 
938     // encodes a uint144 as a UQ144x112
939     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
940         return uq144x112(uint256(x) << RESOLUTION);
941     }
942 
943     // decode a UQ112x112 into a uint112 by truncating after the radix point
944     function decode(uq112x112 memory self) internal pure returns (uint112) {
945         return uint112(self._x >> RESOLUTION);
946     }
947 
948     // decode a UQ144x112 into a uint144 by truncating after the radix point
949     function decode144(uq144x112 memory self) internal pure returns (uint144) {
950         return uint144(self._x >> RESOLUTION);
951     }
952 
953     // multiply a UQ112x112 by a uint, returning a UQ144x112
954     // reverts on overflow
955     function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
956         uint256 z = 0;
957         require(y == 0 || (z = self._x * y) / y == self._x, 'FixedPoint::mul: overflow');
958         return uq144x112(z);
959     }
960 
961     // multiply a UQ112x112 by an int and decode, returning an int
962     // reverts on overflow
963     function muli(uq112x112 memory self, int256 y) internal pure returns (int256) {
964         uint256 z = FullMath.mulDiv(self._x, uint256(y < 0 ? -y : y), Q112);
965         require(z < 2**255, 'FixedPoint::muli: overflow');
966         return y < 0 ? -int256(z) : int256(z);
967     }
968 
969     // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
970     // lossy
971     function muluq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
972         if (self._x == 0 || other._x == 0) {
973             return uq112x112(0);
974         }
975         uint112 upper_self = uint112(self._x >> RESOLUTION); // * 2^0
976         uint112 lower_self = uint112(self._x & LOWER_MASK); // * 2^-112
977         uint112 upper_other = uint112(other._x >> RESOLUTION); // * 2^0
978         uint112 lower_other = uint112(other._x & LOWER_MASK); // * 2^-112
979 
980         // partial products
981         uint224 upper = uint224(upper_self) * upper_other; // * 2^0
982         uint224 lower = uint224(lower_self) * lower_other; // * 2^-224
983         uint224 uppers_lowero = uint224(upper_self) * lower_other; // * 2^-112
984         uint224 uppero_lowers = uint224(upper_other) * lower_self; // * 2^-112
985 
986         // so the bit shift does not overflow
987         require(upper <= uint112(-1), 'FixedPoint::muluq: upper overflow');
988 
989         // this cannot exceed 256 bits, all values are 224 bits
990         uint256 sum = uint256(upper << RESOLUTION) + uppers_lowero + uppero_lowers + (lower >> RESOLUTION);
991 
992         // so the cast does not overflow
993         require(sum <= uint224(-1), 'FixedPoint::muluq: sum overflow');
994 
995         return uq112x112(uint224(sum));
996     }
997 
998     // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
999     function divuq(uq112x112 memory self, uq112x112 memory other) internal pure returns (uq112x112 memory) {
1000         require(other._x > 0, 'FixedPoint::divuq: division by zero');
1001         if (self._x == other._x) {
1002             return uq112x112(uint224(Q112));
1003         }
1004         if (self._x <= uint144(-1)) {
1005             uint256 value = (uint256(self._x) << RESOLUTION) / other._x;
1006             require(value <= uint224(-1), 'FixedPoint::divuq: overflow');
1007             return uq112x112(uint224(value));
1008         }
1009 
1010         uint256 result = FullMath.mulDiv(Q112, self._x, other._x);
1011         require(result <= uint224(-1), 'FixedPoint::divuq: overflow');
1012         return uq112x112(uint224(result));
1013     }
1014 
1015     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
1016     // can be lossy
1017     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
1018         require(denominator > 0, 'FixedPoint::fraction: division by zero');
1019         if (numerator == 0) return FixedPoint.uq112x112(0);
1020 
1021         if (numerator <= uint144(-1)) {
1022             uint256 result = (numerator << RESOLUTION) / denominator;
1023             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
1024             return uq112x112(uint224(result));
1025         } else {
1026             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
1027             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
1028             return uq112x112(uint224(result));
1029         }
1030     }
1031 
1032     // take the reciprocal of a UQ112x112
1033     // reverts on overflow
1034     // lossy
1035     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1036         require(self._x != 0, 'FixedPoint::reciprocal: reciprocal of zero');
1037         require(self._x != 1, 'FixedPoint::reciprocal: overflow');
1038         return uq112x112(uint224(Q224 / self._x));
1039     }
1040 
1041     // square root of a UQ112x112
1042     // lossy between 0/1 and 40 bits
1043     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1044         if (self._x <= uint144(-1)) {
1045             return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << 112)));
1046         }
1047 
1048         uint8 safeShiftBits = 255 - BitMath.mostSignificantBit(self._x);
1049         safeShiftBits -= safeShiftBits % 2;
1050         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x) << safeShiftBits) << ((112 - safeShiftBits) / 2)));
1051     }
1052 }
1053 
1054 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1055 
1056 pragma solidity >=0.5.0;
1057 
1058 interface IUniswapV2Pair {
1059     event Approval(address indexed owner, address indexed spender, uint value);
1060     event Transfer(address indexed from, address indexed to, uint value);
1061 
1062     function name() external pure returns (string memory);
1063     function symbol() external pure returns (string memory);
1064     function decimals() external pure returns (uint8);
1065     function totalSupply() external view returns (uint);
1066     function balanceOf(address owner) external view returns (uint);
1067     function allowance(address owner, address spender) external view returns (uint);
1068 
1069     function approve(address spender, uint value) external returns (bool);
1070     function transfer(address to, uint value) external returns (bool);
1071     function transferFrom(address from, address to, uint value) external returns (bool);
1072 
1073     function DOMAIN_SEPARATOR() external view returns (bytes32);
1074     function PERMIT_TYPEHASH() external pure returns (bytes32);
1075     function nonces(address owner) external view returns (uint);
1076 
1077     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1078 
1079     event Mint(address indexed sender, uint amount0, uint amount1);
1080     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1081     event Swap(
1082         address indexed sender,
1083         uint amount0In,
1084         uint amount1In,
1085         uint amount0Out,
1086         uint amount1Out,
1087         address indexed to
1088     );
1089     event Sync(uint112 reserve0, uint112 reserve1);
1090 
1091     function MINIMUM_LIQUIDITY() external pure returns (uint);
1092     function factory() external view returns (address);
1093     function token0() external view returns (address);
1094     function token1() external view returns (address);
1095     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1096     function price0CumulativeLast() external view returns (uint);
1097     function price1CumulativeLast() external view returns (uint);
1098     function kLast() external view returns (uint);
1099 
1100     function mint(address to) external returns (uint liquidity);
1101     function burn(address to) external returns (uint amount0, uint amount1);
1102     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1103     function skim(address to) external;
1104     function sync() external;
1105 
1106     function initialize(address, address) external;
1107 }
1108 
1109 // File: @uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol
1110 
1111 pragma solidity >=0.5.0;
1112 
1113 
1114 
1115 // library with helper methods for oracles that are concerned with computing average prices
1116 library UniswapV2OracleLibrary {
1117     using FixedPoint for *;
1118 
1119     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1120     function currentBlockTimestamp() internal view returns (uint32) {
1121         return uint32(block.timestamp % 2 ** 32);
1122     }
1123 
1124     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1125     function currentCumulativePrices(
1126         address pair
1127     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
1128         blockTimestamp = currentBlockTimestamp();
1129         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1130         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1131 
1132         // if time has elapsed since the last update on the pair, mock the accumulated price values
1133         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
1134         if (blockTimestampLast != blockTimestamp) {
1135             // subtraction overflow is desired
1136             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1137             // addition overflow is desired
1138             // counterfactual
1139             price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1140             // counterfactual
1141             price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
1142         }
1143     }
1144 }
1145 
1146 // File: interfaces/IInvitation.sol
1147 
1148 pragma solidity 0.6.12;
1149 
1150 interface IInvitation{
1151 
1152     function acceptInvitation(address _invitor) external;
1153 
1154     function getInvitation(address _sender) external view returns(address _invitor, address[] memory _invitees, bool _isWithdrawn);
1155     
1156 }
1157 
1158 // File: contracts/ActivityBase.sol
1159 
1160 
1161 pragma solidity 0.6.12;
1162 
1163 
1164 
1165 contract ActivityBase is Ownable{
1166     using SafeMath for uint256;
1167 
1168     address public admin;
1169     
1170     address public marketingFund;
1171     // token as the unit of measurement
1172     address public WETHToken;
1173     // invitee's supply 5% deposit weight to its invitor
1174     uint256 public constant INVITEE_WEIGHT = 20; 
1175     // invitee's supply 10% deposit weight to its invitor
1176     uint256 public constant INVITOR_WEIGHT = 10;
1177 
1178     // The block number when SHARD mining starts.
1179     uint256 public startBlock;
1180 
1181     // dev fund
1182     uint256 public userDividendWeight;
1183     uint256 public devDividendWeight;
1184     address public developerDAOFund;
1185 
1186     // deposit limit
1187     uint256 public amountFeeRateNumerator;
1188     uint256 public amountfeeRateDenominator;
1189 
1190     // contract sender fee rate
1191     uint256 public contractFeeRateNumerator;
1192     uint256 public contractFeeRateDenominator;
1193 
1194     // Info of each user is Contract sender
1195     mapping (uint256 => mapping (address => bool)) public isUserContractSender;
1196     mapping (uint256 => uint256) public poolTokenAmountLimit;
1197 
1198     function setDividendWeight(uint256 _userDividendWeight, uint256 _devDividendWeight) public virtual{
1199         checkAdmin();
1200         require(
1201             _userDividendWeight != 0 && _devDividendWeight != 0,
1202             "invalid input"
1203         );
1204         userDividendWeight = _userDividendWeight;
1205         devDividendWeight = _devDividendWeight;
1206     }
1207 
1208     function setDeveloperDAOFund(address _developerDAOFund) public virtual onlyOwner {
1209         developerDAOFund = _developerDAOFund;
1210     }
1211 
1212     function setTokenAmountLimit(uint256 _pid, uint256 _tokenAmountLimit) public virtual {
1213         checkAdmin();
1214         poolTokenAmountLimit[_pid] = _tokenAmountLimit;
1215     }
1216 
1217     function setTokenAmountLimitFeeRate(uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual {
1218         checkAdmin();
1219         require(
1220             _feeRateDenominator >= _feeRateNumerator, "invalid input"
1221         );
1222         amountFeeRateNumerator = _feeRateNumerator;
1223         amountfeeRateDenominator = _feeRateDenominator;
1224     }
1225 
1226     function setContracSenderFeeRate(uint256 _feeRateNumerator, uint256 _feeRateDenominator) public virtual {
1227         checkAdmin();
1228         require(
1229             _feeRateDenominator >= _feeRateNumerator, "invalid input"
1230         );
1231         contractFeeRateNumerator = _feeRateNumerator;
1232         contractFeeRateDenominator = _feeRateDenominator;
1233     }
1234 
1235     function setStartBlock(uint256 _startBlock) public virtual onlyOwner { 
1236         require(startBlock > block.number, "invalid start block");
1237         startBlock = _startBlock;
1238         updateAfterModifyStartBlock(_startBlock);
1239     }
1240 
1241     function transferAdmin(address _admin) public virtual {
1242         checkAdmin();
1243         admin = _admin;
1244     }
1245 
1246     function setMarketingFund(address _marketingFund) public virtual onlyOwner {
1247         marketingFund = _marketingFund;
1248     }
1249 
1250     function updateAfterModifyStartBlock(uint256 _newStartBlock) internal virtual{
1251     }
1252 
1253     function calculateDividend(uint256 _pending, uint256 _pid, uint256 _userAmount, bool _isContractSender) internal view returns (uint256 _marketingFundDividend, uint256 _devDividend, uint256 _userDividend){
1254         uint256 fee = 0;
1255         if(_isContractSender && contractFeeRateDenominator > 0){
1256             fee = _pending.mul(contractFeeRateNumerator).div(contractFeeRateDenominator);
1257             _marketingFundDividend = _marketingFundDividend.add(fee);
1258             _pending = _pending.sub(fee);
1259         }
1260         if(poolTokenAmountLimit[_pid] > 0 && amountfeeRateDenominator > 0 && _userAmount >= poolTokenAmountLimit[_pid]){
1261             fee = _pending.mul(amountFeeRateNumerator).div(amountfeeRateDenominator);
1262             _marketingFundDividend =_marketingFundDividend.add(fee);
1263             _pending = _pending.sub(fee);
1264         }
1265         if(devDividendWeight > 0){
1266             fee = _pending.mul(devDividendWeight).div(devDividendWeight.add(userDividendWeight));
1267             _devDividend = _devDividend.add(fee);
1268             _pending = _pending.sub(fee);
1269         }
1270         _userDividend = _pending;
1271     }
1272 
1273     function judgeContractSender(uint256 _pid) internal {
1274         if(msg.sender != tx.origin){
1275             isUserContractSender[_pid][msg.sender] = true;
1276         }
1277     }
1278 
1279     function checkAdmin() internal view {
1280         require(admin == msg.sender, "invalid authorized");
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/GSN/Context.sol
1285 
1286 
1287 
1288 pragma solidity >=0.6.0 <0.8.0;
1289 
1290 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1291 
1292 
1293 
1294 pragma solidity >=0.6.0 <0.8.0;
1295 
1296 
1297 
1298 
1299 /**
1300  * @dev Implementation of the {IERC20} interface.
1301  *
1302  * This implementation is agnostic to the way tokens are created. This means
1303  * that a supply mechanism has to be added in a derived contract using {_mint}.
1304  * For a generic mechanism see {ERC20PresetMinterPauser}.
1305  *
1306  * TIP: For a detailed writeup see our guide
1307  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1308  * to implement supply mechanisms].
1309  *
1310  * We have followed general OpenZeppelin guidelines: functions revert instead
1311  * of returning `false` on failure. This behavior is nonetheless conventional
1312  * and does not conflict with the expectations of ERC20 applications.
1313  *
1314  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1315  * This allows applications to reconstruct the allowance for all accounts just
1316  * by listening to said events. Other implementations of the EIP may not emit
1317  * these events, as it isn't required by the specification.
1318  *
1319  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1320  * functions have been added to mitigate the well-known issues around setting
1321  * allowances. See {IERC20-approve}.
1322  */
1323 contract ERC20 is Context, IERC20 {
1324     using SafeMath for uint256;
1325 
1326     mapping (address => uint256) private _balances;
1327 
1328     mapping (address => mapping (address => uint256)) private _allowances;
1329 
1330     uint256 private _totalSupply;
1331 
1332     string private _name;
1333     string private _symbol;
1334     uint8 private _decimals;
1335 
1336     /**
1337      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1338      * a default value of 18.
1339      *
1340      * To select a different value for {decimals}, use {_setupDecimals}.
1341      *
1342      * All three of these values are immutable: they can only be set once during
1343      * construction.
1344      */
1345     constructor (string memory name_, string memory symbol_) public {
1346         _name = name_;
1347         _symbol = symbol_;
1348         _decimals = 18;
1349     }
1350 
1351     /**
1352      * @dev Returns the name of the token.
1353      */
1354     function name() public view virtual returns (string memory) {
1355         return _name;
1356     }
1357 
1358     /**
1359      * @dev Returns the symbol of the token, usually a shorter version of the
1360      * name.
1361      */
1362     function symbol() public view virtual returns (string memory) {
1363         return _symbol;
1364     }
1365 
1366     /**
1367      * @dev Returns the number of decimals used to get its user representation.
1368      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1369      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1370      *
1371      * Tokens usually opt for a value of 18, imitating the relationship between
1372      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1373      * called.
1374      *
1375      * NOTE: This information is only used for _display_ purposes: it in
1376      * no way affects any of the arithmetic of the contract, including
1377      * {IERC20-balanceOf} and {IERC20-transfer}.
1378      */
1379     function decimals() public view virtual returns (uint8) {
1380         return _decimals;
1381     }
1382 
1383     /**
1384      * @dev See {IERC20-totalSupply}.
1385      */
1386     function totalSupply() public view virtual override returns (uint256) {
1387         return _totalSupply;
1388     }
1389 
1390     /**
1391      * @dev See {IERC20-balanceOf}.
1392      */
1393     function balanceOf(address account) public view virtual override returns (uint256) {
1394         return _balances[account];
1395     }
1396 
1397     /**
1398      * @dev See {IERC20-transfer}.
1399      *
1400      * Requirements:
1401      *
1402      * - `recipient` cannot be the zero address.
1403      * - the caller must have a balance of at least `amount`.
1404      */
1405     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1406         _transfer(_msgSender(), recipient, amount);
1407         return true;
1408     }
1409 
1410     /**
1411      * @dev See {IERC20-allowance}.
1412      */
1413     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1414         return _allowances[owner][spender];
1415     }
1416 
1417     /**
1418      * @dev See {IERC20-approve}.
1419      *
1420      * Requirements:
1421      *
1422      * - `spender` cannot be the zero address.
1423      */
1424     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1425         _approve(_msgSender(), spender, amount);
1426         return true;
1427     }
1428 
1429     /**
1430      * @dev See {IERC20-transferFrom}.
1431      *
1432      * Emits an {Approval} event indicating the updated allowance. This is not
1433      * required by the EIP. See the note at the beginning of {ERC20}.
1434      *
1435      * Requirements:
1436      *
1437      * - `sender` and `recipient` cannot be the zero address.
1438      * - `sender` must have a balance of at least `amount`.
1439      * - the caller must have allowance for ``sender``'s tokens of at least
1440      * `amount`.
1441      */
1442     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1443         _transfer(sender, recipient, amount);
1444         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1445         return true;
1446     }
1447 
1448     /**
1449      * @dev Atomically increases the allowance granted to `spender` by the caller.
1450      *
1451      * This is an alternative to {approve} that can be used as a mitigation for
1452      * problems described in {IERC20-approve}.
1453      *
1454      * Emits an {Approval} event indicating the updated allowance.
1455      *
1456      * Requirements:
1457      *
1458      * - `spender` cannot be the zero address.
1459      */
1460     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1462         return true;
1463     }
1464 
1465     /**
1466      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1467      *
1468      * This is an alternative to {approve} that can be used as a mitigation for
1469      * problems described in {IERC20-approve}.
1470      *
1471      * Emits an {Approval} event indicating the updated allowance.
1472      *
1473      * Requirements:
1474      *
1475      * - `spender` cannot be the zero address.
1476      * - `spender` must have allowance for the caller of at least
1477      * `subtractedValue`.
1478      */
1479     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1481         return true;
1482     }
1483 
1484     /**
1485      * @dev Moves tokens `amount` from `sender` to `recipient`.
1486      *
1487      * This is internal function is equivalent to {transfer}, and can be used to
1488      * e.g. implement automatic token fees, slashing mechanisms, etc.
1489      *
1490      * Emits a {Transfer} event.
1491      *
1492      * Requirements:
1493      *
1494      * - `sender` cannot be the zero address.
1495      * - `recipient` cannot be the zero address.
1496      * - `sender` must have a balance of at least `amount`.
1497      */
1498     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1499         require(sender != address(0), "ERC20: transfer from the zero address");
1500         require(recipient != address(0), "ERC20: transfer to the zero address");
1501 
1502         _beforeTokenTransfer(sender, recipient, amount);
1503 
1504         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1505         _balances[recipient] = _balances[recipient].add(amount);
1506         emit Transfer(sender, recipient, amount);
1507     }
1508 
1509     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1510      * the total supply.
1511      *
1512      * Emits a {Transfer} event with `from` set to the zero address.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      */
1518     function _mint(address account, uint256 amount) internal virtual {
1519         require(account != address(0), "ERC20: mint to the zero address");
1520 
1521         _beforeTokenTransfer(address(0), account, amount);
1522 
1523         _totalSupply = _totalSupply.add(amount);
1524         _balances[account] = _balances[account].add(amount);
1525         emit Transfer(address(0), account, amount);
1526     }
1527 
1528     /**
1529      * @dev Destroys `amount` tokens from `account`, reducing the
1530      * total supply.
1531      *
1532      * Emits a {Transfer} event with `to` set to the zero address.
1533      *
1534      * Requirements:
1535      *
1536      * - `account` cannot be the zero address.
1537      * - `account` must have at least `amount` tokens.
1538      */
1539     function _burn(address account, uint256 amount) internal virtual {
1540         require(account != address(0), "ERC20: burn from the zero address");
1541 
1542         _beforeTokenTransfer(account, address(0), amount);
1543 
1544         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1545         _totalSupply = _totalSupply.sub(amount);
1546         emit Transfer(account, address(0), amount);
1547     }
1548 
1549     /**
1550      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1551      *
1552      * This internal function is equivalent to `approve`, and can be used to
1553      * e.g. set automatic allowances for certain subsystems, etc.
1554      *
1555      * Emits an {Approval} event.
1556      *
1557      * Requirements:
1558      *
1559      * - `owner` cannot be the zero address.
1560      * - `spender` cannot be the zero address.
1561      */
1562     function _approve(address owner, address spender, uint256 amount) internal virtual {
1563         require(owner != address(0), "ERC20: approve from the zero address");
1564         require(spender != address(0), "ERC20: approve to the zero address");
1565 
1566         _allowances[owner][spender] = amount;
1567         emit Approval(owner, spender, amount);
1568     }
1569 
1570     /**
1571      * @dev Sets {decimals} to a value other than the default one of 18.
1572      *
1573      * WARNING: This function should only be called from the constructor. Most
1574      * applications that interact with token contracts will not expect
1575      * {decimals} to ever change, and may work incorrectly if it does.
1576      */
1577     function _setupDecimals(uint8 decimals_) internal virtual {
1578         _decimals = decimals_;
1579     }
1580 
1581     /**
1582      * @dev Hook that is called before any transfer of tokens. This includes
1583      * minting and burning.
1584      *
1585      * Calling conditions:
1586      *
1587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1588      * will be to transferred to `to`.
1589      * - when `from` is zero, `amount` tokens will be minted for `to`.
1590      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1591      * - `from` and `to` are never both zero.
1592      *
1593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1594      */
1595     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1596 }
1597 
1598 // File: contracts/SHDToken.sol
1599 
1600 
1601 pragma solidity 0.6.12;
1602 
1603 
1604 
1605 
1606 
1607 
1608 // SHDToken with Governance.
1609 contract SHDToken is ERC20("ShardingDAO", "SHD"), Ownable {
1610     // cross chain
1611     mapping(address => bool) public minters;
1612 
1613     struct Checkpoint {
1614         uint256 fromBlock;
1615         uint256 votes;
1616     }
1617     /// @notice A record of votes checkpoints for each account, by index
1618     mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;
1619 
1620     /// @notice The number of checkpoints for each account
1621     mapping(address => uint256) public numCheckpoints;
1622     event VotesBalanceChanged(
1623         address indexed user,
1624         uint256 previousBalance,
1625         uint256 newBalance
1626     );
1627 
1628     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1629     function mint(address _to, uint256 _amount) public {
1630         require(minters[msg.sender] == true, "SHD : You are not the miner");
1631         _mint(_to, _amount);
1632     }
1633 
1634     function burn(uint256 _amount) public {
1635         _burn(msg.sender, _amount);
1636     }
1637 
1638     function addMiner(address _miner) external onlyOwner {
1639         minters[_miner] = true;
1640     }
1641 
1642     function removeMiner(address _miner) external onlyOwner {
1643         minters[_miner] = false;
1644     }
1645 
1646     function getPriorVotes(address account, uint256 blockNumber)
1647         public
1648         view
1649         returns (uint256)
1650     {
1651         require(
1652             blockNumber < block.number,
1653             "getPriorVotes: not yet determined"
1654         );
1655 
1656         uint256 nCheckpoints = numCheckpoints[account];
1657         if (nCheckpoints == 0) {
1658             return 0;
1659         }
1660 
1661         // First check most recent balance
1662         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1663             return checkpoints[account][nCheckpoints - 1].votes;
1664         }
1665 
1666         // Next check implicit zero balance
1667         if (checkpoints[account][0].fromBlock > blockNumber) {
1668             return 0;
1669         }
1670 
1671         uint256 lower = 0;
1672         uint256 upper = nCheckpoints - 1;
1673         while (upper > lower) {
1674             uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1675             Checkpoint memory cp = checkpoints[account][center];
1676             if (cp.fromBlock == blockNumber) {
1677                 return cp.votes;
1678             } else if (cp.fromBlock < blockNumber) {
1679                 lower = center;
1680             } else {
1681                 upper = center - 1;
1682             }
1683         }
1684         return checkpoints[account][lower].votes;
1685     }
1686 
1687     function _voteTransfer(
1688         address from,
1689         address to,
1690         uint256 amount
1691     ) internal {
1692         if (from != to && amount > 0) {
1693             if (from != address(0)) {
1694                 uint256 fromNum = numCheckpoints[from];
1695                 uint256 fromOld =
1696                     fromNum > 0 ? checkpoints[from][fromNum - 1].votes : 0;
1697                 uint256 fromNew = fromOld.sub(amount);
1698                 _writeCheckpoint(from, fromNum, fromOld, fromNew);
1699             }
1700 
1701             if (to != address(0)) {
1702                 uint256 toNum = numCheckpoints[to];
1703                 uint256 toOld =
1704                     toNum > 0 ? checkpoints[to][toNum - 1].votes : 0;
1705                 uint256 toNew = toOld.add(amount);
1706                 _writeCheckpoint(to, toNum, toOld, toNew);
1707             }
1708         }
1709     }
1710 
1711     function _writeCheckpoint(
1712         address user,
1713         uint256 nCheckpoints,
1714         uint256 oldVotes,
1715         uint256 newVotes
1716     ) internal {
1717         uint256 blockNumber = block.number;
1718         if (
1719             nCheckpoints > 0 &&
1720             checkpoints[user][nCheckpoints - 1].fromBlock == blockNumber
1721         ) {
1722             checkpoints[user][nCheckpoints - 1].votes = newVotes;
1723         } else {
1724             checkpoints[user][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1725             numCheckpoints[user] = nCheckpoints + 1;
1726         }
1727 
1728         emit VotesBalanceChanged(user, oldVotes, newVotes);
1729     }
1730 
1731     function _beforeTokenTransfer(
1732         address from,
1733         address to,
1734         uint256 amount
1735     ) internal override {
1736         _voteTransfer(from, to, amount);
1737     }
1738 }
1739 
1740 // File: contracts/ShardingDAOMining.sol
1741 
1742 
1743 pragma solidity 0.6.12;
1744 
1745 
1746 
1747 
1748 
1749 
1750 
1751 
1752 
1753 
1754 
1755 contract ShardingDAOMining is IInvitation, ActivityBase {
1756     using SafeMath for uint256;
1757     using SafeERC20 for IERC20; 
1758     using FixedPoint for *;
1759 
1760     // Info of each user.
1761     struct UserInfo {
1762         uint256 amount; // How much LP token the user has provided.
1763         uint256 originWeight; //initial weight
1764         uint256 inviteeWeight; // invitees' weight
1765         uint256 endBlock;
1766         bool isCalculateInvitation;
1767     }
1768 
1769     // Info of each pool.
1770     struct PoolInfo {
1771         uint256 nftPoolId;
1772         address lpTokenSwap; // uniswapPair contract address
1773         uint256 accumulativeDividend;
1774         uint256 usersTotalWeight; // user's sum weight
1775         uint256 lpTokenAmount; // lock amount
1776         uint256 oracleWeight; // eth value
1777         uint256 lastDividendHeight; // last dividend block height
1778         TokenPairInfo tokenToEthPairInfo;
1779         bool isFirstTokenShard;
1780     }
1781 
1782     struct TokenPairInfo{
1783         IUniswapV2Pair tokenToEthSwap; 
1784         FixedPoint.uq112x112 price; 
1785         bool isFirstTokenEth;
1786         uint256 priceCumulativeLast;
1787         uint32  blockTimestampLast;
1788         uint256 lastPriceUpdateHeight;
1789     }
1790 
1791     struct InvitationInfo {
1792         address invitor;
1793         address[] invitees;
1794         bool isUsed;
1795         bool isWithdrawn;
1796         mapping(address => uint256) inviteeIndexMap;
1797     }
1798 
1799     // black list
1800     struct EvilPoolInfo {
1801         uint256 pid;
1802         string description;
1803     }
1804 
1805     // The SHD TOKEN!
1806     SHDToken public SHD;
1807     // Info of each pool.
1808     uint256[] public rankPoolIndex;
1809     // indicates whether the pool is in the rank
1810     mapping(uint256 => uint256) public rankPoolIndexMap;
1811     // relationship info about invitation
1812     mapping(address => InvitationInfo) public usersRelationshipInfo;
1813     // Info of each user that stakes LP tokens.
1814     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1815     // Info of each pool.
1816     PoolInfo[] private poolInfo;
1817     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1818     uint256 public maxRankNumber = 10;
1819     // Last block number that SHARDs distribution occurs.
1820     uint256 public lastRewardBlock;
1821     // produced blocks per day
1822     uint256 public constant produceBlocksPerDay = 6496;
1823     // produced blocks per month
1824     uint256 public constant produceBlocksPerMonth = produceBlocksPerDay * 30;
1825     // SHD tokens created per block.
1826     uint256 public SHDPerBlock = 104994 * (1e13);
1827     // after each term, mine half SHD token
1828     uint256 public constant MINT_DECREASE_TERM = 9500000;
1829     // used to caculate user deposit weight
1830     uint256[] private depositTimeWeight;
1831     // max lock time in stage two
1832     uint256 private constant MAX_MONTH = 36;
1833     // add pool automatically in nft shard
1834     address public nftShard;
1835     // oracle token price update term
1836     uint256 public updateTokenPriceTerm = 120;
1837     // to mint token cross chain
1838     uint256 public shardMintWeight = 1;
1839     uint256 public reserveMintWeight = 0;
1840     uint256 public reserveToMint;
1841     // black list
1842     EvilPoolInfo[] public blackList;
1843     mapping(uint256 => uint256) public blackListMap;
1844     // undividend shard
1845     uint256 public unDividendShard;
1846     // 20% shard => SHD - ETH pool
1847     uint256 public shardPoolDividendWeight = 2;
1848     // 80% shard => SHD - ETH pool
1849     uint256 public otherPoolDividendWeight = 8;
1850 
1851     event Deposit(
1852         address indexed user,
1853         uint256 indexed pid,
1854         uint256 amount,
1855         uint256 weight
1856     );
1857     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1858     event Replace(
1859         address indexed user,
1860         uint256 indexed rankIndex,
1861         uint256 newPid
1862     );
1863 
1864     event AddToBlacklist(
1865         uint256 indexed pid
1866     );
1867 
1868     event RemoveFromBlacklist(
1869         uint256 indexed pid
1870     );
1871     event AddPool(uint256 indexed pid, uint256 nftId, address tokenAddress);
1872 
1873     function initialize(
1874         SHDToken _SHD,
1875         address _wethToken,
1876         address _developerDAOFund,
1877         address _marketingFund,
1878         uint256 _maxRankNumber,
1879         uint256 _startBlock
1880     ) public virtual onlyOwner{
1881         require(WETHToken == address(0), "already initialized");
1882         SHD = _SHD;
1883         maxRankNumber = _maxRankNumber;
1884         if (_startBlock < block.number) {
1885             startBlock = block.number;
1886         } else {
1887             startBlock = _startBlock;
1888         }
1889         lastRewardBlock = startBlock.sub(1);
1890         WETHToken = _wethToken;
1891         initializeTimeWeight();
1892         developerDAOFund = _developerDAOFund;
1893         marketingFund = _marketingFund;
1894         InvitationInfo storage initialInvitor =
1895             usersRelationshipInfo[address(this)];
1896 
1897         userDividendWeight = 8;
1898         devDividendWeight = 2;
1899 
1900         amountFeeRateNumerator = 0;
1901         amountfeeRateDenominator = 0;
1902 
1903         contractFeeRateNumerator = 1;
1904         contractFeeRateDenominator = 5;
1905         initialInvitor.isUsed = true;
1906     }
1907 
1908     function initializeTimeWeight() private {
1909         depositTimeWeight = [
1910             1238,
1911             1383,
1912             1495,
1913             1587,
1914             1665,
1915             1732,
1916             1790,
1917             1842,
1918             1888,
1919             1929,
1920             1966,
1921             2000,
1922             2031,
1923             2059,
1924             2085,
1925             2108,
1926             2131,
1927             2152,
1928             2171,
1929             2189,
1930             2206,
1931             2221,
1932             2236,
1933             2250,
1934             2263,
1935             2276,
1936             2287,
1937             2298,
1938             2309,
1939             2319,
1940             2328,
1941             2337,
1942             2346,
1943             2355,
1944             2363,
1945             2370
1946         ];
1947     }
1948 
1949     function setNftShard(address _nftShard) public virtual {
1950         checkAdmin();
1951         nftShard = _nftShard;
1952     }
1953 
1954     // Add a new lp to the pool. Can only be called by the nft shard contract.
1955     // if _lpTokenSwap contains tokenA instead of eth, then _tokenToEthSwap should consist of token A and eth
1956     function add(
1957         uint256 _nftPoolId,
1958         IUniswapV2Pair _lpTokenSwap,
1959         IUniswapV2Pair _tokenToEthSwap
1960     ) public virtual {
1961         require(msg.sender == nftShard || msg.sender == admin, "invalid sender");
1962         TokenPairInfo memory tokenToEthInfo;
1963         uint256 lastDividendHeight = 0;
1964         if(poolInfo.length == 0){
1965             _nftPoolId = 0;
1966             lastDividendHeight = lastRewardBlock;
1967         }
1968         bool isFirstTokenShard;
1969         if (address(_tokenToEthSwap) != address(0)) {
1970             (address token0, address token1, uint256 targetTokenPosition) =
1971                 getTargetTokenInSwap(_tokenToEthSwap, WETHToken);
1972             address wantToken;
1973             bool isFirstTokenEthToken;
1974             if (targetTokenPosition == 0) {
1975                 isFirstTokenEthToken = true;
1976                 wantToken = token1;
1977             } else {
1978                 isFirstTokenEthToken = false;
1979                 wantToken = token0;
1980             }
1981             (, , targetTokenPosition) = getTargetTokenInSwap(
1982                 _lpTokenSwap,
1983                 wantToken
1984             );
1985             if (targetTokenPosition == 0) {
1986                 isFirstTokenShard = false;
1987             } else {
1988                 isFirstTokenShard = true;
1989             }
1990             tokenToEthInfo = generateOrcaleInfo(
1991                 _tokenToEthSwap,
1992                 isFirstTokenEthToken
1993             );
1994         } else {
1995             (, , uint256 targetTokenPosition) =
1996                 getTargetTokenInSwap(_lpTokenSwap, WETHToken);
1997             if (targetTokenPosition == 0) {
1998                 isFirstTokenShard = false;
1999             } else {
2000                 isFirstTokenShard = true;
2001             }
2002             tokenToEthInfo = generateOrcaleInfo(
2003                 _lpTokenSwap,
2004                 !isFirstTokenShard
2005             );
2006         }
2007         poolInfo.push(
2008             PoolInfo({
2009                 nftPoolId: _nftPoolId,
2010                 lpTokenSwap: address(_lpTokenSwap),
2011                 lpTokenAmount: 0,
2012                 usersTotalWeight: 0,
2013                 accumulativeDividend: 0,
2014                 oracleWeight: 0,
2015                 lastDividendHeight: lastDividendHeight,
2016                 tokenToEthPairInfo: tokenToEthInfo,
2017                 isFirstTokenShard: isFirstTokenShard
2018             })
2019         );
2020         emit AddPool(poolInfo.length.sub(1), _nftPoolId, address(_lpTokenSwap));
2021     }
2022 
2023     function setPriceUpdateTerm(uint256 _term) public virtual onlyOwner{
2024         updateTokenPriceTerm = _term;
2025     }
2026 
2027     function kickEvilPoolByPid(uint256 _pid, string calldata description)
2028         public
2029         virtual
2030         onlyOwner
2031     {
2032         bool isDescriptionLeagal = verifyDescription(description);
2033         require(isDescriptionLeagal, "invalid description, just ASCII code is allowed");
2034         require(_pid > 0, "invalid pid");
2035         uint256 poolRankIndex = rankPoolIndexMap[_pid];
2036         if (poolRankIndex > 0) {
2037             massUpdatePools();
2038             uint256 _rankIndex = poolRankIndex.sub(1);
2039             uint256 currentRankLastIndex = rankPoolIndex.length.sub(1);
2040             uint256 lastPidInRank = rankPoolIndex[currentRankLastIndex];
2041             rankPoolIndex[_rankIndex] = lastPidInRank;
2042             rankPoolIndexMap[lastPidInRank] = poolRankIndex;
2043             delete rankPoolIndexMap[_pid];
2044             rankPoolIndex.pop();
2045         }
2046         addInBlackList(_pid, description);
2047         dealEvilPoolDiviend(_pid);
2048         emit AddToBlacklist(_pid);
2049     }
2050 
2051     function addInBlackList(uint256 _pid, string calldata description) private {
2052         if (blackListMap[_pid] > 0) {
2053             return;
2054         }
2055         blackList.push(EvilPoolInfo({pid: _pid, description: description}));
2056         blackListMap[_pid] = blackList.length;
2057     }
2058 
2059     function resetEvilPool(uint256 _pid) public virtual onlyOwner {
2060         uint256 poolPosition = blackListMap[_pid];
2061         if (poolPosition == 0) {
2062             return;
2063         }
2064         uint256 poolIndex = poolPosition.sub(1);
2065         uint256 lastIndex = blackList.length.sub(1);
2066         EvilPoolInfo storage lastEvilInBlackList = blackList[lastIndex];
2067         uint256 lastPidInBlackList = lastEvilInBlackList.pid;
2068         blackListMap[lastPidInBlackList] = poolPosition;
2069         blackList[poolIndex] = blackList[lastIndex];
2070         delete blackListMap[_pid];
2071         blackList.pop();
2072         emit RemoveFromBlacklist(_pid);
2073     }
2074 
2075     function dealEvilPoolDiviend(uint256 _pid) private {
2076         PoolInfo storage pool = poolInfo[_pid];
2077         uint256 undistributeDividend = pool.accumulativeDividend;
2078         if (undistributeDividend == 0) {
2079             return;
2080         }
2081         uint256 currentRankCount = rankPoolIndex.length;
2082         if (currentRankCount > 0) {
2083             uint256 averageDividend =
2084                 undistributeDividend.div(currentRankCount);
2085             for (uint256 i = 0; i < currentRankCount; i++) {
2086                 PoolInfo storage poolInRank = poolInfo[rankPoolIndex[i]];
2087                 if (i < currentRankCount - 1) {
2088                     poolInRank.accumulativeDividend = poolInRank
2089                         .accumulativeDividend
2090                         .add(averageDividend);
2091                     undistributeDividend = undistributeDividend.sub(
2092                         averageDividend
2093                     );
2094                 } else {
2095                     poolInRank.accumulativeDividend = poolInRank
2096                         .accumulativeDividend
2097                         .add(undistributeDividend);
2098                 }
2099             }
2100         } else {
2101             unDividendShard = unDividendShard.add(undistributeDividend);
2102         }
2103         pool.accumulativeDividend = 0;
2104     }
2105 
2106     function setMintCoefficient(
2107         uint256 _shardMintWeight,
2108         uint256 _reserveMintWeight
2109     ) public virtual {
2110         checkAdmin();
2111         require(
2112             _shardMintWeight != 0 && _reserveMintWeight != 0,
2113             "invalid input"
2114         );
2115         massUpdatePools();
2116         shardMintWeight = _shardMintWeight;
2117         reserveMintWeight = _reserveMintWeight;
2118     }
2119 
2120     function setShardPoolDividendWeight(
2121         uint256 _shardPoolWeight,
2122         uint256 _otherPoolWeight
2123     ) public virtual {
2124         checkAdmin();
2125         require(
2126             _shardPoolWeight != 0 && _otherPoolWeight != 0,
2127             "invalid input"
2128         );
2129         massUpdatePools();
2130         shardPoolDividendWeight = _shardPoolWeight;
2131         otherPoolDividendWeight = _otherPoolWeight;
2132     }
2133 
2134     function setSHDPerBlock(uint256 _SHDPerBlock, bool _withUpdate) public virtual {
2135         checkAdmin();
2136         if (_withUpdate) {
2137             massUpdatePools();
2138         }
2139         SHDPerBlock = _SHDPerBlock;
2140     }
2141 
2142     function massUpdatePools() public virtual {
2143         uint256 poolCountInRank = rankPoolIndex.length;
2144         uint256 farmMintShard = mintSHARD(address(this), block.number);
2145         updateSHARDPoolAccumulativeDividend(block.number);
2146         if(poolCountInRank == 0){
2147             farmMintShard = farmMintShard.mul(otherPoolDividendWeight)
2148                                      .div(shardPoolDividendWeight.add(otherPoolDividendWeight));
2149             if(farmMintShard > 0){
2150                 unDividendShard = unDividendShard.add(farmMintShard);
2151             }
2152         }
2153         for (uint256 i = 0; i < poolCountInRank; i++) {
2154             updatePoolAccumulativeDividend(
2155                 rankPoolIndex[i],
2156                 poolCountInRank,
2157                 block.number
2158             );
2159         }
2160     }
2161 
2162     // update reward vairables for a pool
2163     function updatePoolDividend(uint256 _pid) public virtual {
2164         if(_pid == 0){
2165             updateSHARDPoolAccumulativeDividend(block.number);
2166             return;
2167         }
2168         if (rankPoolIndexMap[_pid] == 0) {
2169             return;
2170         }
2171         updatePoolAccumulativeDividend(
2172             _pid,
2173             rankPoolIndex.length,
2174             block.number
2175         );
2176     }
2177 
2178     function mintSHARD(address _address, uint256 _toBlock) private returns (uint256){
2179         uint256 recentlyRewardBlock = lastRewardBlock;
2180         if (recentlyRewardBlock >= _toBlock) {
2181             return 0;
2182         }
2183         uint256 totalReward =
2184             getRewardToken(recentlyRewardBlock.add(1), _toBlock);
2185         uint256 farmMint =
2186             totalReward.mul(shardMintWeight).div(
2187                 reserveMintWeight.add(shardMintWeight)
2188             );
2189         uint256 reserve = totalReward.sub(farmMint);
2190         if (totalReward > 0) {
2191             SHD.mint(_address, farmMint);
2192             if (reserve > 0) {
2193                 reserveToMint = reserveToMint.add(reserve);
2194             }
2195             lastRewardBlock = _toBlock;
2196         }
2197         return farmMint;
2198     }
2199 
2200     function updatePoolAccumulativeDividend(
2201         uint256 _pid,
2202         uint256 _validRankPoolCount,
2203         uint256 _toBlock
2204     ) private {
2205         PoolInfo storage pool = poolInfo[_pid];
2206         if (pool.lastDividendHeight >= _toBlock) return;
2207         uint256 poolReward =
2208             getModifiedRewardToken(pool.lastDividendHeight.add(1), _toBlock)
2209                                     .mul(otherPoolDividendWeight)
2210                                     .div(shardPoolDividendWeight.add(otherPoolDividendWeight));
2211 
2212         uint256 otherPoolReward = poolReward.div(_validRankPoolCount);                            
2213         pool.lastDividendHeight = _toBlock;
2214         uint256 existedDividend = pool.accumulativeDividend;
2215         pool.accumulativeDividend = existedDividend.add(otherPoolReward);
2216     }
2217 
2218     function updateSHARDPoolAccumulativeDividend (uint256 _toBlock) private{
2219         PoolInfo storage pool = poolInfo[0];
2220         if (pool.lastDividendHeight >= _toBlock) return;
2221         uint256 poolReward =
2222             getModifiedRewardToken(pool.lastDividendHeight.add(1), _toBlock);
2223 
2224         uint256 shardPoolDividend = poolReward.mul(shardPoolDividendWeight)
2225                                                .div(shardPoolDividendWeight.add(otherPoolDividendWeight));                              
2226         pool.lastDividendHeight = _toBlock;
2227         uint256 existedDividend = pool.accumulativeDividend;
2228         pool.accumulativeDividend = existedDividend.add(shardPoolDividend);
2229     }
2230 
2231     // deposit LP tokens to MasterChef for SHD allocation.
2232     // ignore lockTime in stage one
2233     function deposit(
2234         uint256 _pid,
2235         uint256 _amount,
2236         uint256 _lockTime
2237     ) public virtual {
2238         require(_amount > 0, "invalid deposit amount");
2239         InvitationInfo storage senderInfo = usersRelationshipInfo[msg.sender];
2240         require(senderInfo.isUsed, "must accept an invitation firstly");
2241         require(_lockTime > 0 && _lockTime <= 36, "invalid lock time"); // less than 36 months
2242         PoolInfo storage pool = poolInfo[_pid];
2243         uint256 lpTokenAmount = pool.lpTokenAmount.add(_amount);
2244         UserInfo storage user = userInfo[_pid][msg.sender];
2245         uint256 newOriginWeight = user.originWeight;
2246         uint256 existedAmount = user.amount;
2247         uint256 endBlock = user.endBlock;
2248         uint256 newEndBlock =
2249             block.number.add(produceBlocksPerMonth.mul(_lockTime));
2250         if (existedAmount > 0) {
2251             if (block.number >= endBlock) {
2252                 newOriginWeight = getDepositWeight(
2253                     _amount.add(existedAmount),
2254                     _lockTime
2255                 );
2256             } else {
2257                 newOriginWeight = newOriginWeight.add(getDepositWeight(_amount, _lockTime));
2258                 newOriginWeight = newOriginWeight.add(
2259                     getDepositWeight(
2260                         existedAmount,
2261                         newEndBlock.sub(endBlock).div(produceBlocksPerMonth)
2262                     )
2263                 );
2264             }
2265         } else {
2266             judgeContractSender(_pid);
2267             newOriginWeight = getDepositWeight(_amount, _lockTime);
2268         }
2269         modifyWeightByInvitation(
2270             _pid,
2271             msg.sender,
2272             user.originWeight,
2273             newOriginWeight,
2274             user.inviteeWeight,
2275             existedAmount
2276         );   
2277         updateUserInfo(
2278             user,
2279             existedAmount.add(_amount),
2280             newOriginWeight,
2281             newEndBlock
2282         );
2283         IERC20(pool.lpTokenSwap).safeTransferFrom(
2284             address(msg.sender),
2285             address(this),
2286             _amount
2287         );
2288         pool.oracleWeight =  getOracleWeight(pool, lpTokenAmount);
2289         pool.lpTokenAmount = lpTokenAmount;
2290         if (
2291             rankPoolIndexMap[_pid] == 0 &&
2292             rankPoolIndex.length < maxRankNumber &&
2293             blackListMap[_pid] == 0
2294         ) {
2295             addToRank(pool, _pid);
2296         }
2297         emit Deposit(msg.sender, _pid, _amount, newOriginWeight);
2298     }
2299 
2300     // Withdraw LP tokens from MasterChef.
2301     function withdraw(uint256 _pid) public virtual {
2302         UserInfo storage user = userInfo[_pid][msg.sender];
2303         uint256 amount = user.amount;
2304         require(amount > 0, "user is not existed");
2305         require(user.endBlock < block.number, "token is still locked");
2306         mintSHARD(address(this), block.number);
2307         updatePoolDividend(_pid);
2308         uint256 originWeight = user.originWeight;
2309         PoolInfo storage pool = poolInfo[_pid];
2310         uint256 usersTotalWeight = pool.usersTotalWeight;
2311         uint256 userWeight = user.inviteeWeight.add(originWeight);
2312         if(user.isCalculateInvitation){
2313             userWeight = userWeight.add(originWeight.div(INVITOR_WEIGHT));
2314         }
2315         if (pool.accumulativeDividend > 0) {
2316             uint256 pending = pool.accumulativeDividend.mul(userWeight).div(usersTotalWeight);
2317             pool.accumulativeDividend = pool.accumulativeDividend.sub(pending);
2318             uint256 treasruyDividend;
2319             uint256 devDividend;
2320             (treasruyDividend, devDividend, pending) = calculateDividend(pending, _pid, amount, isUserContractSender[_pid][msg.sender]);
2321             if(treasruyDividend > 0){
2322                 safeSHARDTransfer(marketingFund, treasruyDividend);
2323             }
2324             if(devDividend > 0){
2325                 safeSHARDTransfer(developerDAOFund, devDividend);
2326             }
2327             if(pending > 0){
2328                 safeSHARDTransfer(msg.sender, pending);
2329             }
2330         }
2331         pool.usersTotalWeight = usersTotalWeight.sub(userWeight);
2332         user.amount = 0;
2333         user.originWeight = 0;
2334         user.endBlock = 0;
2335         IERC20(pool.lpTokenSwap).safeTransfer(address(msg.sender), amount);
2336         pool.lpTokenAmount = pool.lpTokenAmount.sub(amount);
2337         if (pool.lpTokenAmount == 0) pool.oracleWeight = 0;
2338         else {
2339             pool.oracleWeight = getOracleWeight(pool, pool.lpTokenAmount);
2340         }
2341         resetInvitationRelationship(_pid, msg.sender, originWeight);
2342         emit Withdraw(msg.sender, _pid, amount);
2343     }
2344 
2345     function addToRank(
2346         PoolInfo storage _pool,
2347         uint256 _pid
2348     ) private {
2349         if(_pid == 0){
2350             return;
2351         }
2352         massUpdatePools();
2353         _pool.lastDividendHeight = block.number;
2354         rankPoolIndex.push(_pid);
2355         rankPoolIndexMap[_pid] = rankPoolIndex.length;
2356         if(unDividendShard > 0){
2357             _pool.accumulativeDividend = _pool.accumulativeDividend.add(unDividendShard);
2358             unDividendShard = 0;
2359         }
2360         emit Replace(msg.sender, rankPoolIndex.length.sub(1), _pid);
2361         return;
2362     }
2363 
2364     //_poolIndexInRank is the index in rank
2365     //_pid is the index in poolInfo
2366     function tryToReplacePoolInRank(uint256 _poolIndexInRank, uint256 _pid)
2367         public
2368         virtual
2369     {
2370         if(_pid == 0){
2371             return;
2372         }
2373         PoolInfo storage pool = poolInfo[_pid];
2374         require(pool.lpTokenAmount > 0, "there is not any lp token depsoited");
2375         require(blackListMap[_pid] == 0, "pool is in the black list");
2376         if (rankPoolIndexMap[_pid] > 0) {
2377             return;
2378         }
2379         uint256 currentPoolCountInRank = rankPoolIndex.length;
2380         require(currentPoolCountInRank == maxRankNumber, "invalid operation");
2381         uint256 targetPid = rankPoolIndex[_poolIndexInRank];
2382         PoolInfo storage targetPool = poolInfo[targetPid];
2383         uint256 targetPoolOracleWeight = getOracleWeight(targetPool, targetPool.lpTokenAmount);
2384         uint256 challengerOracleWeight = getOracleWeight(pool, pool.lpTokenAmount);
2385         if (challengerOracleWeight <= targetPoolOracleWeight) {
2386             return;
2387         }
2388         updatePoolDividend(targetPid);
2389         rankPoolIndex[_poolIndexInRank] = _pid;
2390         delete rankPoolIndexMap[targetPid];
2391         rankPoolIndexMap[_pid] = _poolIndexInRank.add(1);
2392         pool.lastDividendHeight = block.number;
2393         emit Replace(msg.sender, _poolIndexInRank, _pid);
2394     }
2395 
2396     function acceptInvitation(address _invitor) public virtual override {
2397         require(_invitor != msg.sender, "invitee should not be invitor");
2398         buildInvitation(_invitor, msg.sender);
2399     }
2400 
2401     function buildInvitation(address _invitor, address _invitee) private {
2402         InvitationInfo storage invitee = usersRelationshipInfo[_invitee];
2403         require(!invitee.isUsed, "has accepted invitation");
2404         invitee.isUsed = true;
2405         InvitationInfo storage invitor = usersRelationshipInfo[_invitor];
2406         require(invitor.isUsed, "invitor has not acceptted invitation");
2407         invitee.invitor = _invitor;
2408         invitor.invitees.push(_invitee);
2409         invitor.inviteeIndexMap[_invitee] = invitor.invitees.length.sub(1);
2410     }
2411 
2412     function setMaxRankNumber(uint256 _count) public virtual {
2413         checkAdmin();
2414         require(_count > 0, "invalid count");
2415         if (maxRankNumber == _count) return;
2416         massUpdatePools();
2417         maxRankNumber = _count;
2418         uint256 currentPoolCountInRank = rankPoolIndex.length;
2419         if (_count >= currentPoolCountInRank) {
2420             return;
2421         }
2422         uint256 sparePoolCount = currentPoolCountInRank.sub(_count);
2423         uint256 lastPoolIndex = currentPoolCountInRank.sub(1);
2424         while (sparePoolCount > 0) {
2425             delete rankPoolIndexMap[rankPoolIndex[lastPoolIndex]];
2426             rankPoolIndex.pop();
2427             lastPoolIndex--;
2428             sparePoolCount--;
2429         }
2430     }
2431 
2432     function getModifiedRewardToken(uint256 _fromBlock, uint256 _toBlock)
2433         private
2434         view
2435         returns (uint256)
2436     {
2437         return
2438             getRewardToken(_fromBlock, _toBlock).mul(shardMintWeight).div(
2439                 reserveMintWeight.add(shardMintWeight)
2440             );
2441     }
2442 
2443     // View function to see pending SHARDs on frontend.
2444     function pendingSHARD(uint256 _pid, address _user)
2445         external
2446         view
2447         virtual
2448         returns (uint256 _pending, uint256 _potential, uint256 _blockNumber)
2449     {
2450         _blockNumber = block.number;
2451         (_pending, _potential) = calculatePendingSHARD(_pid, _user);
2452         
2453     }
2454 
2455     function pendingSHARDByPids(uint256[] memory _pids, address _user)
2456         external
2457         view
2458         virtual
2459         returns (uint256[] memory _pending, uint256[] memory _potential, uint256 _blockNumber)
2460     {
2461          uint256 poolCount = _pids.length;
2462         _pending = new uint256[](poolCount);
2463         _potential = new uint256[](poolCount);
2464         _blockNumber = block.number;
2465         for(uint i = 0; i < poolCount; i ++){
2466             (_pending[i], _potential[i]) = calculatePendingSHARD(_pids[i], _user);
2467         }
2468     }
2469 
2470     function calculatePendingSHARD(uint256 _pid, address _user) private view returns (uint256 _pending, uint256 _potential){
2471         PoolInfo storage pool = poolInfo[_pid];
2472         UserInfo storage user = userInfo[_pid][_user];
2473         if (user.amount == 0) {
2474             return (0, 0);
2475         }
2476         uint256 userModifiedWeight = getUserModifiedWeight(_pid, _user);
2477         _pending = pool.accumulativeDividend.mul(userModifiedWeight);
2478         _pending = _pending.div(pool.usersTotalWeight);
2479         bool isContractSender = isUserContractSender[_pid][_user];
2480         (,,_pending) = calculateDividend(_pending, _pid, user.amount, isContractSender);
2481         if (pool.lastDividendHeight >= block.number) {
2482             return (_pending, 0);
2483         }
2484         if (_pid != 0 && (rankPoolIndex.length == 0 || rankPoolIndexMap[_pid] == 0)) {
2485             return (_pending, 0);
2486         }
2487         uint256 poolReward = getModifiedRewardToken(pool.lastDividendHeight.add(1), block.number);
2488         uint256 numerator;
2489         uint256 denominator = otherPoolDividendWeight.add(shardPoolDividendWeight);
2490         if(_pid == 0){
2491             numerator = shardPoolDividendWeight;
2492         }
2493         else{
2494             numerator = otherPoolDividendWeight;
2495         }
2496         poolReward = poolReward       
2497             .mul(numerator)
2498             .div(denominator);
2499         if(_pid != 0){
2500             poolReward = poolReward.div(rankPoolIndex.length);
2501         }                          
2502         _potential = poolReward
2503             .mul(userModifiedWeight)
2504             .div(pool.usersTotalWeight);
2505         (,,_potential) = calculateDividend(_potential, _pid, user.amount, isContractSender);
2506     }
2507 
2508     //calculate the weight and end block when users deposit
2509     function getDepositWeight(uint256 _lockAmount, uint256 _lockTime)
2510         private
2511         view
2512         returns (uint256)
2513     {
2514         if (_lockTime == 0) return 0;
2515         if (_lockTime.div(MAX_MONTH) > 1) _lockTime = MAX_MONTH;
2516         return depositTimeWeight[_lockTime.sub(1)].sub(500).mul(_lockAmount);
2517     }
2518 
2519     function getPoolLength() public view virtual returns (uint256) {
2520         return poolInfo.length;
2521     }
2522 
2523     function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
2524         public
2525         view
2526         virtual
2527         returns (
2528             uint256[] memory _nftPoolId,
2529             uint256[] memory _accumulativeDividend,
2530             uint256[] memory _usersTotalWeight,
2531             uint256[] memory _lpTokenAmount,
2532             uint256[] memory _oracleWeight,
2533             address[] memory _swapAddress
2534         )
2535     {
2536         uint256 poolCount = _toIndex.sub(_fromIndex).add(1);
2537         _nftPoolId = new uint256[](poolCount);
2538         _accumulativeDividend = new uint256[](poolCount);
2539         _usersTotalWeight = new uint256[](poolCount);
2540         _lpTokenAmount = new uint256[](poolCount);
2541         _oracleWeight = new uint256[](poolCount);
2542         _swapAddress = new address[](poolCount);
2543         uint256 startIndex = 0;
2544         for (uint256 i = _fromIndex; i <= _toIndex; i++) {
2545             PoolInfo storage pool = poolInfo[i];
2546             _nftPoolId[startIndex] = pool.nftPoolId;
2547             _accumulativeDividend[startIndex] = pool.accumulativeDividend;
2548             _usersTotalWeight[startIndex] = pool.usersTotalWeight;
2549             _lpTokenAmount[startIndex] = pool.lpTokenAmount;
2550             _oracleWeight[startIndex] = pool.oracleWeight;
2551             _swapAddress[startIndex] = pool.lpTokenSwap;
2552             startIndex++;
2553         }
2554     }
2555 
2556     function getInstantPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
2557     public
2558     virtual
2559     returns (
2560         uint256[] memory _nftPoolId,
2561         uint256[] memory _accumulativeDividend,
2562         uint256[] memory _usersTotalWeight,
2563         uint256[] memory _lpTokenAmount,
2564         uint256[] memory _oracleWeight,
2565         address[] memory _swapAddress
2566     )
2567     {
2568         uint256 poolCount = _toIndex.sub(_fromIndex).add(1);
2569         _nftPoolId = new uint256[](poolCount);
2570         _accumulativeDividend = new uint256[](poolCount);
2571         _usersTotalWeight = new uint256[](poolCount);
2572         _lpTokenAmount = new uint256[](poolCount);
2573         _oracleWeight = new uint256[](poolCount);
2574         _swapAddress = new address[](poolCount);
2575         uint256 startIndex = 0;
2576         for (uint256 i = _fromIndex; i <= _toIndex; i++) {
2577             PoolInfo storage pool = poolInfo[i];
2578             _nftPoolId[startIndex] = pool.nftPoolId;
2579             _accumulativeDividend[startIndex] = pool.accumulativeDividend;
2580             _usersTotalWeight[startIndex] = pool.usersTotalWeight;
2581             _lpTokenAmount[startIndex] = pool.lpTokenAmount;
2582             _oracleWeight[startIndex] = getOracleWeight(pool, _lpTokenAmount[startIndex]);
2583             _swapAddress[startIndex] = pool.lpTokenSwap;
2584             startIndex++;
2585         }
2586     }
2587 
2588     function getRankList() public view virtual returns (uint256[] memory) {
2589         uint256[] memory rankIdList = rankPoolIndex;
2590         return rankIdList;
2591     }
2592 
2593     function getBlackList()
2594         public
2595         view
2596         virtual
2597         returns (EvilPoolInfo[] memory _blackList)
2598     {
2599         _blackList = blackList;
2600     }
2601 
2602     function getInvitation(address _sender)
2603         public
2604         view
2605         virtual
2606         override
2607         returns (
2608             address _invitor,
2609             address[] memory _invitees,
2610             bool _isWithdrawn
2611         )
2612     {
2613         InvitationInfo storage invitation = usersRelationshipInfo[_sender];
2614         _invitees = invitation.invitees;
2615         _invitor = invitation.invitor;
2616         _isWithdrawn = invitation.isWithdrawn;
2617     }
2618 
2619     function getUserInfo(uint256 _pid, address _user)
2620         public
2621         view
2622         virtual
2623         returns (
2624             uint256 _amount,
2625             uint256 _originWeight,
2626             uint256 _modifiedWeight,
2627             uint256 _endBlock
2628         )
2629     {
2630         UserInfo storage user = userInfo[_pid][_user];
2631         _amount = user.amount;
2632         _originWeight = user.originWeight;
2633         _modifiedWeight = getUserModifiedWeight(_pid, _user);
2634         _endBlock = user.endBlock;
2635     }
2636 
2637     function getUserInfoByPids(uint256[] memory _pids, address _user)
2638         public
2639         view
2640         virtual
2641         returns (
2642             uint256[] memory _amount,
2643             uint256[] memory _originWeight,
2644             uint256[] memory _modifiedWeight,
2645             uint256[] memory _endBlock
2646         )
2647     {
2648         uint256 poolCount = _pids.length;
2649         _amount = new uint256[](poolCount);
2650         _originWeight = new uint256[](poolCount);
2651         _modifiedWeight = new uint256[](poolCount);
2652         _endBlock = new uint256[](poolCount);
2653         for(uint i = 0; i < poolCount; i ++){
2654             (_amount[i], _originWeight[i], _modifiedWeight[i], _endBlock[i]) = getUserInfo(_pids[i], _user);
2655         }
2656     }
2657 
2658     function getOracleInfo(uint256 _pid)
2659         public
2660         view
2661         virtual
2662         returns (
2663             address _swapToEthAddress,
2664             uint256 _priceCumulativeLast,
2665             uint256 _blockTimestampLast,
2666             uint256 _price,
2667             uint256 _lastPriceUpdateHeight
2668         )
2669     {
2670         PoolInfo storage pool = poolInfo[_pid];
2671         _swapToEthAddress = address(pool.tokenToEthPairInfo.tokenToEthSwap);
2672         _priceCumulativeLast = pool.tokenToEthPairInfo.priceCumulativeLast;
2673         _blockTimestampLast = pool.tokenToEthPairInfo.blockTimestampLast;
2674         _price = pool.tokenToEthPairInfo.price._x;
2675         _lastPriceUpdateHeight = pool.tokenToEthPairInfo.lastPriceUpdateHeight;
2676     }
2677 
2678     // Safe SHD transfer function, just in case if rounding error causes pool to not have enough SHARDs.
2679     function safeSHARDTransfer(address _to, uint256 _amount) internal {
2680         uint256 SHARDBal = SHD.balanceOf(address(this));
2681         if (_amount > SHARDBal) {
2682             SHD.transfer(_to, SHARDBal);
2683         } else {
2684             SHD.transfer(_to, _amount);
2685         }
2686     }
2687 
2688     function updateUserInfo(
2689         UserInfo storage _user,
2690         uint256 _amount,
2691         uint256 _originWeight,
2692         uint256 _endBlock
2693     ) private {
2694         _user.amount = _amount;
2695         _user.originWeight = _originWeight;
2696         _user.endBlock = _endBlock;
2697     }
2698 
2699     function getOracleWeight(
2700         PoolInfo storage _pool,
2701         uint256 _amount
2702     ) private returns (uint256 _oracleWeight) {
2703         _oracleWeight = calculateOracleWeight(_pool, _amount);
2704         _pool.oracleWeight = _oracleWeight;
2705     }
2706 
2707     function calculateOracleWeight(PoolInfo storage _pool, uint256 _amount)
2708         private
2709         returns (uint256 _oracleWeight)
2710     {
2711         uint256 lpTokenTotalSupply =
2712             IUniswapV2Pair(_pool.lpTokenSwap).totalSupply();
2713         (uint112 shardReserve, uint112 wantTokenReserve, ) =
2714             IUniswapV2Pair(_pool.lpTokenSwap).getReserves();
2715         if (_amount == 0) {
2716             _amount = _pool.lpTokenAmount;
2717             if (_amount == 0) {
2718                 return 0;
2719             }
2720         }
2721         if (!_pool.isFirstTokenShard) {
2722             uint112 wantToken = wantTokenReserve;
2723             wantTokenReserve = shardReserve;
2724             shardReserve = wantToken;
2725         }
2726         FixedPoint.uq112x112 memory price =
2727             updateTokenOracle(_pool.tokenToEthPairInfo);
2728         if (
2729             address(_pool.tokenToEthPairInfo.tokenToEthSwap) ==
2730             _pool.lpTokenSwap
2731         ) {
2732             _oracleWeight = uint256(price.mul(shardReserve).decode144())
2733                 .mul(2)
2734                 .mul(_amount)
2735                 .div(lpTokenTotalSupply);
2736         } else {
2737             _oracleWeight = uint256(price.mul(wantTokenReserve).decode144())
2738                 .mul(2)
2739                 .mul(_amount)
2740                 .div(lpTokenTotalSupply);
2741         }
2742     }
2743 
2744     function resetInvitationRelationship(
2745         uint256 _pid,
2746         address _user,
2747         uint256 _originWeight
2748     ) private {
2749         InvitationInfo storage senderRelationshipInfo =
2750             usersRelationshipInfo[_user];
2751         if (!senderRelationshipInfo.isWithdrawn){
2752             senderRelationshipInfo.isWithdrawn = true;
2753             InvitationInfo storage invitorRelationshipInfo =
2754             usersRelationshipInfo[senderRelationshipInfo.invitor];
2755             uint256 targetIndex = invitorRelationshipInfo.inviteeIndexMap[_user];
2756             uint256 inviteesCount = invitorRelationshipInfo.invitees.length;
2757             address lastInvitee =
2758             invitorRelationshipInfo.invitees[inviteesCount.sub(1)];
2759             invitorRelationshipInfo.inviteeIndexMap[lastInvitee] = targetIndex;
2760             invitorRelationshipInfo.invitees[targetIndex] = lastInvitee;
2761             delete invitorRelationshipInfo.inviteeIndexMap[_user];
2762             invitorRelationshipInfo.invitees.pop();
2763         }
2764         
2765         UserInfo storage invitorInfo =
2766             userInfo[_pid][senderRelationshipInfo.invitor];
2767         UserInfo storage user =
2768             userInfo[_pid][_user];
2769         if(!user.isCalculateInvitation){
2770             return;
2771         }
2772         user.isCalculateInvitation = false;
2773         uint256 inviteeToSubWeight = _originWeight.div(INVITEE_WEIGHT);
2774         invitorInfo.inviteeWeight = invitorInfo.inviteeWeight.sub(inviteeToSubWeight);
2775         if (invitorInfo.amount == 0){
2776             return;
2777         }
2778         PoolInfo storage pool = poolInfo[_pid];
2779         pool.usersTotalWeight = pool.usersTotalWeight.sub(inviteeToSubWeight);
2780     }
2781 
2782     function modifyWeightByInvitation(
2783         uint256 _pid,
2784         address _user,
2785         uint256 _oldOriginWeight,
2786         uint256 _newOriginWeight,
2787         uint256 _inviteeWeight,
2788         uint256 _existedAmount
2789     ) private{
2790         PoolInfo storage pool = poolInfo[_pid];
2791         InvitationInfo storage senderInfo = usersRelationshipInfo[_user];
2792         uint256 poolTotalWeight = pool.usersTotalWeight;
2793         poolTotalWeight = poolTotalWeight.sub(_oldOriginWeight).add(_newOriginWeight);
2794         if(_existedAmount == 0){
2795             poolTotalWeight = poolTotalWeight.add(_inviteeWeight);
2796         }     
2797         UserInfo storage user = userInfo[_pid][_user];
2798         if (!senderInfo.isWithdrawn || (_existedAmount > 0 && user.isCalculateInvitation)) {
2799             UserInfo storage invitorInfo = userInfo[_pid][senderInfo.invitor];
2800             user.isCalculateInvitation = true;
2801             uint256 addInviteeWeight =
2802                     _newOriginWeight.div(INVITEE_WEIGHT).sub(
2803                         _oldOriginWeight.div(INVITEE_WEIGHT)
2804                     );
2805             invitorInfo.inviteeWeight = invitorInfo.inviteeWeight.add(
2806                 addInviteeWeight
2807             );
2808             uint256 addInvitorWeight = 
2809                     _newOriginWeight.div(INVITOR_WEIGHT).sub(
2810                         _oldOriginWeight.div(INVITOR_WEIGHT)
2811                     );
2812             
2813             poolTotalWeight = poolTotalWeight.add(addInvitorWeight);
2814             if (invitorInfo.amount > 0) {
2815                 poolTotalWeight = poolTotalWeight.add(addInviteeWeight);
2816             } 
2817         }
2818         pool.usersTotalWeight = poolTotalWeight;
2819     }
2820 
2821     function verifyDescription(string memory description)
2822         internal
2823         pure
2824         returns (bool success)
2825     {
2826         bytes memory nameBytes = bytes(description);
2827         uint256 nameLength = nameBytes.length;
2828         require(nameLength > 0, "INVALID INPUT");
2829         success = true;
2830         bool n7;
2831         for (uint256 i = 0; i <= nameLength - 1; i++) {
2832             n7 = (nameBytes[i] & 0x80) == 0x80 ? true : false;
2833             if (n7) {
2834                 success = false;
2835                 break;
2836             }
2837         }
2838     }
2839 
2840     function getUserModifiedWeight(uint256 _pid, address _user) private view returns (uint256){
2841         UserInfo storage user =  userInfo[_pid][_user];
2842         uint256 originWeight = user.originWeight;
2843         uint256 modifiedWeight = originWeight.add(user.inviteeWeight);
2844         if(user.isCalculateInvitation){
2845             modifiedWeight = modifiedWeight.add(originWeight.div(INVITOR_WEIGHT));
2846         }
2847         return modifiedWeight;
2848     }
2849 
2850         // get how much token will be mined from _toBlock to _toBlock.
2851     function getRewardToken(uint256 _fromBlock, uint256 _toBlock) public view virtual returns (uint256){
2852         return calculateRewardToken(MINT_DECREASE_TERM, SHDPerBlock, startBlock, _fromBlock, _toBlock);
2853     }
2854 
2855     function calculateRewardToken(uint _term, uint256 _initialBlock, uint256 _startBlock, uint256 _fromBlock, uint256 _toBlock) private pure returns (uint256){
2856         if(_fromBlock > _toBlock || _startBlock > _toBlock)
2857             return 0;
2858         if(_startBlock > _fromBlock)
2859             _fromBlock = _startBlock;
2860         uint256 totalReward = 0;
2861         uint256 blockPeriod = _fromBlock.sub(_startBlock).add(1);
2862         uint256 yearPeriod = blockPeriod.div(_term);  // produce 5760 blocks per day, 2102400 blocks per year.
2863         for (uint256 i = 0; i < yearPeriod; i++){
2864             _initialBlock = _initialBlock.div(2);
2865         }
2866         uint256 termStartIndex = yearPeriod.add(1).mul(_term).add(_startBlock);
2867         uint256 beforeCalculateIndex = _fromBlock.sub(1);
2868         while(_toBlock >= termStartIndex && _initialBlock > 0){
2869             totalReward = totalReward.add(termStartIndex.sub(beforeCalculateIndex).mul(_initialBlock));
2870             beforeCalculateIndex = termStartIndex.add(1);
2871             _initialBlock = _initialBlock.div(2);
2872             termStartIndex = termStartIndex.add(_term);
2873         }
2874         if(_toBlock > beforeCalculateIndex){
2875             totalReward = totalReward.add(_toBlock.sub(beforeCalculateIndex).mul(_initialBlock));
2876         }
2877         return totalReward;
2878     }
2879 
2880     function getTargetTokenInSwap(IUniswapV2Pair _lpTokenSwap, address _targetToken) internal view returns (address, address, uint256){
2881         address token0 = _lpTokenSwap.token0();
2882         address token1 = _lpTokenSwap.token1();
2883         if(token0 == _targetToken){
2884             return(token0, token1, 0);
2885         }
2886         if(token1 == _targetToken){
2887             return(token0, token1, 1);
2888         }
2889         require(false, "invalid uniswap");
2890     }
2891 
2892     function generateOrcaleInfo(IUniswapV2Pair _pairSwap, bool _isFirstTokenEth) internal view returns(TokenPairInfo memory){
2893         uint256 priceTokenCumulativeLast = _isFirstTokenEth? _pairSwap.price1CumulativeLast(): _pairSwap.price0CumulativeLast();
2894         uint112 reserve0;
2895         uint112 reserve1;
2896         uint32 tokenBlockTimestampLast;
2897         (reserve0, reserve1, tokenBlockTimestampLast) = _pairSwap.getReserves();
2898         require(reserve0 != 0 && reserve1 != 0, 'ExampleOracleSimple: NO_RESERVES'); // ensure that there's liquidity in the pair
2899         TokenPairInfo memory tokenBInfo = TokenPairInfo({
2900             tokenToEthSwap: _pairSwap,
2901             isFirstTokenEth: _isFirstTokenEth,
2902             priceCumulativeLast: priceTokenCumulativeLast,
2903             blockTimestampLast: tokenBlockTimestampLast,
2904             price: FixedPoint.uq112x112(0),
2905             lastPriceUpdateHeight: block.number
2906         });
2907         return tokenBInfo;
2908     }
2909 
2910     function updateTokenOracle(TokenPairInfo storage _pairInfo) internal returns (FixedPoint.uq112x112 memory _price) {
2911         FixedPoint.uq112x112 memory cachedPrice = _pairInfo.price;
2912         if(cachedPrice._x > 0 && block.number.sub(_pairInfo.lastPriceUpdateHeight) <= updateTokenPriceTerm){
2913             return cachedPrice;
2914         }
2915         (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
2916             UniswapV2OracleLibrary.currentCumulativePrices(address(_pairInfo.tokenToEthSwap));
2917         uint32 timeElapsed = blockTimestamp - _pairInfo.blockTimestampLast; // overflow is desired
2918         // overflow is desired, casting never truncates
2919         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
2920         if(_pairInfo.isFirstTokenEth){
2921             _price = FixedPoint.uq112x112(uint224(price1Cumulative.sub(_pairInfo.priceCumulativeLast).div(timeElapsed)));
2922             _pairInfo.priceCumulativeLast = price1Cumulative;
2923         }     
2924         else{
2925             _price = FixedPoint.uq112x112(uint224(price0Cumulative.sub(_pairInfo.priceCumulativeLast).div(timeElapsed)));
2926             _pairInfo.priceCumulativeLast = price0Cumulative;
2927         }
2928         _pairInfo.price = _price;
2929         _pairInfo.lastPriceUpdateHeight = block.number;
2930         _pairInfo.blockTimestampLast = blockTimestamp;
2931     }
2932 
2933     function updateAfterModifyStartBlock(uint256 _newStartBlock) internal override{
2934         lastRewardBlock = _newStartBlock.sub(1);
2935         if(poolInfo.length > 0){
2936             PoolInfo storage shdPool = poolInfo[0];
2937             shdPool.lastDividendHeight = lastRewardBlock;
2938         }
2939     }
2940 }
2941 
2942 // File: contracts/ShardingDAOMiningDelegator.sol
2943 
2944 
2945 pragma solidity 0.6.12;
2946 
2947 
2948 
2949 contract ShardingDAOMiningDelegator is DelegatorInterface, ShardingDAOMining {
2950     constructor(
2951         SHDToken _SHD,
2952         address _wethToken,
2953         address _developerDAOFund,
2954         address _marketingFund,
2955         uint256 _maxRankNumber,
2956         uint256 _startBlock,
2957         address implementation_,
2958         bytes memory becomeImplementationData
2959     ) public {
2960         delegateTo(
2961             implementation_,
2962             abi.encodeWithSignature(
2963                 "initialize(address,address,address,address,uint256,uint256)",
2964                 _SHD,
2965                 _wethToken,
2966                 _developerDAOFund,
2967                 _marketingFund,
2968                 _maxRankNumber,
2969                 _startBlock
2970             )
2971         );
2972         admin = msg.sender;
2973         _setImplementation(implementation_, false, becomeImplementationData);
2974     }
2975 
2976     function _setImplementation(
2977         address implementation_,
2978         bool allowResign,
2979         bytes memory becomeImplementationData
2980     ) public override {
2981         checkAdmin();
2982         if (allowResign) {
2983             delegateToImplementation(
2984                 abi.encodeWithSignature("_resignImplementation()")
2985             );
2986         }
2987 
2988         address oldImplementation = implementation;
2989         implementation = implementation_;
2990 
2991         delegateToImplementation(
2992             abi.encodeWithSignature(
2993                 "_becomeImplementation(bytes)",
2994                 becomeImplementationData
2995             )
2996         );
2997 
2998         emit NewImplementation(oldImplementation, implementation);
2999     }
3000 
3001     function delegateTo(address callee, bytes memory data)
3002         internal
3003         returns (bytes memory)
3004     {
3005         (bool success, bytes memory returnData) = callee.delegatecall(data);
3006         assembly {
3007             if eq(success, 0) {
3008                 revert(add(returnData, 0x20), returndatasize())
3009             }
3010         }
3011         return returnData;
3012     }
3013 
3014     /**
3015      * @notice Delegates execution to the implementation contract
3016      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
3017      * @param data The raw data to delegatecall
3018      * @return The returned bytes from the delegatecall
3019      */
3020     function delegateToImplementation(bytes memory data)
3021         public
3022         returns (bytes memory)
3023     {
3024         return delegateTo(implementation, data);
3025     }
3026 
3027     /**
3028      * @notice Delegates execution to an implementation contract
3029      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
3030      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
3031      * @param data The raw data to delegatecall
3032      * @return The returned bytes from the delegatecall
3033      */
3034     function delegateToViewImplementation(bytes memory data)
3035         public
3036         view
3037         returns (bytes memory)
3038     {
3039         (bool success, bytes memory returnData) =
3040             address(this).staticcall(
3041                 abi.encodeWithSignature("delegateToImplementation(bytes)", data)
3042             );
3043         assembly {
3044             if eq(success, 0) {
3045                 revert(add(returnData, 0x20), returndatasize())
3046             }
3047         }
3048         return abi.decode(returnData, (bytes));
3049     }
3050 
3051     /**
3052      * @notice Delegates execution to an implementation contract
3053      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
3054     //  */
3055     fallback() external payable {
3056         if (msg.value > 0) return;
3057         // delegate all other functions to current implementation
3058         (bool success, ) = implementation.delegatecall(msg.data);
3059         assembly {
3060             let free_mem_ptr := mload(0x40)
3061             returndatacopy(free_mem_ptr, 0, returndatasize())
3062             switch success
3063                 case 0 {
3064                     revert(free_mem_ptr, returndatasize())
3065                 }
3066                 default {
3067                     return(free_mem_ptr, returndatasize())
3068                 }
3069         }
3070     }
3071 
3072     function setNftShard(address _nftShard) public override {
3073         delegateToImplementation(
3074             abi.encodeWithSignature("setNftShard(address)", _nftShard)
3075         );
3076     }
3077 
3078     function add(
3079         uint256 _nftPoolId,
3080         IUniswapV2Pair _lpTokenSwap,
3081         IUniswapV2Pair _tokenToEthSwap
3082     ) public override {
3083         delegateToImplementation(
3084             abi.encodeWithSignature(
3085                 "add(uint256,address,address)",
3086                 _nftPoolId,
3087                 _lpTokenSwap,
3088                 _tokenToEthSwap
3089             )
3090         );
3091     }
3092 
3093     function setPriceUpdateTerm(uint256 _term) 
3094         public 
3095         override
3096     {
3097         delegateToImplementation(
3098             abi.encodeWithSignature(
3099                 "setPriceUpdateTerm(uint256)",
3100                 _term
3101             )
3102         );
3103     }
3104 
3105     function kickEvilPoolByPid(uint256 _pid, string calldata description)
3106         public
3107         override
3108     {
3109         delegateToImplementation(
3110             abi.encodeWithSignature(
3111                 "kickEvilPoolByPid(uint256,string)",
3112                 _pid,
3113                 description
3114             )
3115         );
3116     }
3117 
3118     function resetEvilPool(uint256 _pid)
3119         public
3120         override
3121     {
3122         delegateToImplementation(
3123             abi.encodeWithSignature(
3124                 "resetEvilPool(uint256)",
3125                 _pid
3126             )
3127         );
3128     }
3129 
3130     function setMintCoefficient(
3131         uint256 _nftMintWeight,
3132         uint256 _reserveMintWeight
3133     ) public override {
3134         delegateToImplementation(
3135             abi.encodeWithSignature(
3136                 "setMintCoefficient(uint256,uint256)",
3137                 _nftMintWeight,
3138                 _reserveMintWeight
3139             )
3140         );
3141     }
3142 
3143     function setShardPoolDividendWeight(
3144         uint256 _shardPoolWeight,
3145         uint256 _otherPoolWeight
3146     ) public override {
3147         delegateToImplementation(
3148             abi.encodeWithSignature(
3149                 "setShardPoolDividendWeight(uint256,uint256)",
3150                 _shardPoolWeight,
3151                 _otherPoolWeight
3152             )
3153         );
3154     }
3155 
3156     function setStartBlock(
3157         uint256 _startBlock
3158     ) public override {
3159         delegateToImplementation(
3160             abi.encodeWithSignature(
3161                 "setStartBlock(uint256)",
3162                 _startBlock
3163             )
3164         );
3165     }
3166 
3167     function setSHDPerBlock(uint256 _shardPerBlock, bool _withUpdate) public override {
3168         delegateToImplementation(
3169             abi.encodeWithSignature(
3170                 "setSHDPerBlock(uint256,bool)",
3171                 _shardPerBlock,
3172                 _withUpdate
3173             )
3174         );
3175     }
3176 
3177     function massUpdatePools() public override {
3178         delegateToImplementation(abi.encodeWithSignature("massUpdatePools()"));
3179     }
3180 
3181     function updatePoolDividend(uint256 _pid) public override {
3182         delegateToImplementation(
3183             abi.encodeWithSignature("updatePoolDividend(uint256)", _pid)
3184         );
3185     }
3186 
3187     function deposit(
3188         uint256 _pid,
3189         uint256 _amount,
3190         uint256 _lockTime
3191     ) public override {
3192         delegateToImplementation(
3193             abi.encodeWithSignature(
3194                 "deposit(uint256,uint256,uint256)",
3195                 _pid,
3196                 _amount,
3197                 _lockTime
3198             )
3199         );
3200     }
3201 
3202     function withdraw(uint256 _pid) public override {
3203         delegateToImplementation(
3204             abi.encodeWithSignature("withdraw(uint256)", _pid)
3205         );
3206     }
3207 
3208     function tryToReplacePoolInRank(uint256 _poolIndexInRank, uint256 _pid)
3209         public
3210         override
3211     {
3212         delegateToImplementation(
3213             abi.encodeWithSignature(
3214                 "tryToReplacePoolInRank(uint256,uint256)",
3215                 _poolIndexInRank,
3216                 _pid
3217             )
3218         );
3219     }
3220 
3221     function acceptInvitation(address _invitor) public override {
3222         delegateToImplementation(
3223             abi.encodeWithSignature("acceptInvitation(address)", _invitor)
3224         );
3225     }
3226 
3227     function setMaxRankNumber(uint256 _count) public override {
3228         delegateToImplementation(
3229             abi.encodeWithSignature("setMaxRankNumber(uint256)", _count)
3230         );
3231     }
3232 
3233     function setDeveloperDAOFund(
3234     address _developer
3235     ) public override {
3236         delegateToImplementation(
3237             abi.encodeWithSignature(
3238                 "setDeveloperDAOFund(address)",
3239                 _developer
3240             )
3241         );
3242     }
3243 
3244     function setDividendWeight(
3245         uint256 _userDividendWeight,
3246         uint256 _devDividendWeight
3247     ) public override {
3248         delegateToImplementation(
3249             abi.encodeWithSignature(
3250                 "setDividendWeight(uint256,uint256)",
3251                 _userDividendWeight,
3252                 _devDividendWeight
3253             )
3254         );
3255     }
3256 
3257     function setTokenAmountLimit(
3258         uint256 _pid, 
3259         uint256 _tokenAmountLimit
3260     ) public override {
3261         delegateToImplementation(
3262             abi.encodeWithSignature(
3263                 "setTokenAmountLimit(uint256,uint256)",
3264                 _pid,
3265                 _tokenAmountLimit
3266             )
3267         );
3268     }
3269 
3270     function setTokenAmountLimitFeeRate(
3271         uint256 _feeRateNumerator,
3272         uint256 _feeRateDenominator
3273     ) public override {
3274         delegateToImplementation(
3275             abi.encodeWithSignature(
3276                 "setTokenAmountLimitFeeRate(uint256,uint256)",
3277                 _feeRateNumerator,
3278                 _feeRateDenominator
3279             )
3280         );
3281     }
3282 
3283     function setContracSenderFeeRate(
3284         uint256 _feeRateNumerator,
3285         uint256 _feeRateDenominator
3286     ) public override {
3287         delegateToImplementation(
3288             abi.encodeWithSignature(
3289                 "setContracSenderFeeRate(uint256,uint256)",
3290                 _feeRateNumerator,
3291                 _feeRateDenominator
3292             )
3293         );
3294     }
3295 
3296     function transferAdmin(
3297         address _admin
3298     ) public override {
3299         delegateToImplementation(
3300             abi.encodeWithSignature(
3301                 "transferAdmin(address)",
3302                 _admin
3303             )
3304         );
3305     }
3306 
3307     function setMarketingFund(
3308         address _marketingFund
3309     ) public override {
3310         delegateToImplementation(
3311             abi.encodeWithSignature(
3312                 "setMarketingFund(address)",
3313                 _marketingFund
3314             )
3315         );
3316     }
3317 
3318     function pendingSHARD(uint256 _pid, address _user)
3319         external
3320         view
3321         override
3322         returns (uint256, uint256, uint256)
3323     {
3324         bytes memory data =
3325             delegateToViewImplementation(
3326                 abi.encodeWithSignature(
3327                     "pendingSHARD(uint256,address)",
3328                     _pid,
3329                     _user
3330                 )
3331             );
3332         return abi.decode(data, (uint256, uint256, uint256));
3333     }
3334 
3335     function pendingSHARDByPids(uint256[] memory _pids, address _user)
3336         external
3337         view
3338         override
3339         returns (uint256[] memory _pending, uint256[] memory _potential, uint256 _blockNumber)
3340     {
3341         bytes memory data =
3342             delegateToViewImplementation(
3343                 abi.encodeWithSignature(
3344                     "pendingSHARDByPids(uint256[],address)",
3345                     _pids,
3346                     _user
3347                 )
3348             );
3349         return abi.decode(data, (uint256[], uint256[], uint256));
3350     }
3351 
3352     function getPoolLength() public view override returns (uint256) {
3353         bytes memory data =
3354             delegateToViewImplementation(
3355                 abi.encodeWithSignature("getPoolLength()")
3356             );
3357         return abi.decode(data, (uint256));
3358     }
3359 
3360     function getPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
3361         public
3362         view
3363         override
3364         returns (
3365             uint256[] memory _nftPoolId,
3366             uint256[] memory _accumulativeDividend,
3367             uint256[] memory _usersTotalWeight,
3368             uint256[] memory _lpTokenAmount,
3369             uint256[] memory _oracleWeight,
3370             address[] memory _swapAddress
3371         )
3372     {
3373         bytes memory data =
3374             delegateToViewImplementation(
3375                 abi.encodeWithSignature(
3376                     "getPagePoolInfo(uint256,uint256)",
3377                     _fromIndex,
3378                     _toIndex
3379                 )
3380             );
3381         return
3382             abi.decode(
3383                 data,
3384                 (
3385                     uint256[],
3386                     uint256[],
3387                     uint256[],
3388                     uint256[],
3389                     uint256[],
3390                     address[]
3391                 )
3392             );
3393     }
3394 
3395     function getInstantPagePoolInfo(uint256 _fromIndex, uint256 _toIndex)
3396     public
3397     override
3398     returns (
3399         uint256[] memory _nftPoolId,
3400         uint256[] memory _accumulativeDividend,
3401         uint256[] memory _usersTotalWeight,
3402         uint256[] memory _lpTokenAmount,
3403         uint256[] memory _oracleWeight,
3404         address[] memory _swapAddress
3405     )
3406     {
3407         bytes memory data =
3408             delegateToImplementation(
3409                 abi.encodeWithSignature(
3410                     "getInstantPagePoolInfo(uint256,uint256)",
3411                     _fromIndex,
3412                     _toIndex
3413                 )
3414             );
3415         return
3416             abi.decode(
3417                 data,
3418                 (
3419                     uint256[],
3420                     uint256[],
3421                     uint256[],
3422                     uint256[],
3423                     uint256[],
3424                     address[]
3425                 )
3426             );
3427     }
3428 
3429     function getRankList() public view override returns (uint256[] memory) {
3430         bytes memory data =
3431             delegateToViewImplementation(
3432                 abi.encodeWithSignature("getRankList()")
3433             );
3434         return abi.decode(data, (uint256[]));
3435     }
3436 
3437     function getBlackList()
3438         public
3439         view
3440         override
3441         returns (EvilPoolInfo[] memory _blackList)
3442     {
3443         bytes memory data =
3444             delegateToViewImplementation(
3445                 abi.encodeWithSignature("getBlackList()")
3446             );
3447         return abi.decode(data, (EvilPoolInfo[]));
3448     }
3449 
3450     function getInvitation(address _sender)
3451         public
3452         view
3453         override
3454         returns (
3455             address _invitor,
3456             address[] memory _invitees,
3457             bool _isWithdrawn
3458         )
3459     {
3460         bytes memory data =
3461             delegateToViewImplementation(
3462                 abi.encodeWithSignature("getInvitation(address)", _sender)
3463             );
3464         return abi.decode(data, (address, address[], bool));
3465     }
3466 
3467     function getUserInfo(uint256 _pid, address _sender)
3468         public
3469         view
3470         override
3471         returns (
3472             uint256 _amount,
3473             uint256 _originWeight,
3474             uint256 _modifiedWeight,
3475             uint256 _endBlock
3476         )
3477     {
3478         bytes memory data =
3479             delegateToViewImplementation(
3480                 abi.encodeWithSignature(
3481                     "getUserInfo(uint256,address)",
3482                     _pid,
3483                     _sender
3484                 )
3485             );
3486         return abi.decode(data, (uint256, uint256, uint256, uint256));
3487     }
3488 
3489     function getUserInfoByPids(uint256[] memory _pids, address _sender)
3490         public
3491         view
3492         override
3493         returns (
3494             uint256[] memory _amount,
3495             uint256[] memory _originWeight,
3496             uint256[] memory _modifiedWeight,
3497             uint256[] memory _endBlock
3498         )
3499     {
3500         bytes memory data =
3501             delegateToViewImplementation(
3502                 abi.encodeWithSignature(
3503                     "getUserInfoByPids(uint256[],address)",
3504                     _pids,
3505                     _sender
3506                 )
3507             );
3508         return abi.decode(data, (uint256[], uint256[], uint256[], uint256[]));
3509     }
3510 
3511     function getOracleInfo(uint256 _pid)
3512         public
3513         view
3514         override
3515         returns (
3516             address _swapToEthAddress,
3517             uint256 _priceCumulativeLast,
3518             uint256 _blockTimestampLast,
3519             uint256 _price,
3520             uint256 _lastPriceUpdateHeight
3521         )
3522     {
3523         bytes memory data =
3524             delegateToViewImplementation(
3525                 abi.encodeWithSignature("getOracleInfo(uint256)", _pid)
3526             );
3527         return abi.decode(data, (address, uint256, uint256, uint256, uint256));
3528     }
3529 
3530     function getRewardToken(uint256 _fromBlock, uint256 _toBlock)
3531         public
3532         view
3533         override
3534         returns (
3535             uint256
3536         )
3537     {
3538         bytes memory data =
3539             delegateToViewImplementation(
3540                 abi.encodeWithSignature("getRewardToken(uint256,uint256)", _fromBlock, _toBlock)
3541             );
3542         return abi.decode(data, (uint256));
3543     }
3544 }