1 pragma solidity >=0.6.0 <0.8.0;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with GSN meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address payable) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes memory) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 
101 /**
102  * @dev Contract module which provides a basic access control mechanism, where
103  * there is an account (an owner) that can be granted exclusive access to
104  * specific functions.
105  *
106  * By default, the owner account will be the one that deploys the contract. This
107  * can later be changed with {transferOwnership}.
108  *
109  * This module is used through inheritance. It will make available the modifier
110  * `onlyOwner`, which can be applied to your functions to restrict their use to
111  * the owner.
112  */
113 abstract contract Ownable is Context {
114     address private _owner;
115 
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118     /**
119      * @dev Initializes the contract setting the deployer as the initial owner.
120      */
121     constructor () internal {
122         address msgSender = _msgSender();
123         _owner = msgSender;
124         emit OwnershipTransferred(address(0), msgSender);
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         emit OwnershipTransferred(_owner, address(0));
151         _owner = address(0);
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180     /**
181      * @dev Returns the addition of two unsigned integers, with an overflow flag.
182      *
183      * _Available since v3.4._
184      */
185     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
186         uint256 c = a + b;
187         if (c < a) return (false, 0);
188         return (true, c);
189     }
190 
191     /**
192      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
193      *
194      * _Available since v3.4._
195      */
196     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197         if (b > a) return (false, 0);
198         return (true, a - b);
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
203      *
204      * _Available since v3.4._
205      */
206     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
208         // benefit is lost if 'b' is also tested.
209         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
210         if (a == 0) return (true, 0);
211         uint256 c = a * b;
212         if (c / a != b) return (false, 0);
213         return (true, c);
214     }
215 
216     /**
217      * @dev Returns the division of two unsigned integers, with a division by zero flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         if (b == 0) return (false, 0);
223         return (true, a / b);
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
228      *
229      * _Available since v3.4._
230      */
231     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         if (b == 0) return (false, 0);
233         return (true, a % b);
234     }
235 
236     /**
237      * @dev Returns the addition of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `+` operator.
241      *
242      * Requirements:
243      *
244      * - Addition cannot overflow.
245      */
246     function add(uint256 a, uint256 b) internal pure returns (uint256) {
247         uint256 c = a + b;
248         require(c >= a, "SafeMath: addition overflow");
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b <= a, "SafeMath: subtraction overflow");
264         return a - b;
265     }
266 
267     /**
268      * @dev Returns the multiplication of two unsigned integers, reverting on
269      * overflow.
270      *
271      * Counterpart to Solidity's `*` operator.
272      *
273      * Requirements:
274      *
275      * - Multiplication cannot overflow.
276      */
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         if (a == 0) return 0;
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         require(b > 0, "SafeMath: division by zero");
298         return a / b;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * reverting when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(b > 0, "SafeMath: modulo by zero");
315         return a % b;
316     }
317 
318     /**
319      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
320      * overflow (when the result is negative).
321      *
322      * CAUTION: This function is deprecated because it requires allocating memory for the error
323      * message unnecessarily. For custom revert reasons use {trySub}.
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b <= a, errorMessage);
333         return a - b;
334     }
335 
336     /**
337      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
338      * division by zero. The result is rounded towards zero.
339      *
340      * CAUTION: This function is deprecated because it requires allocating memory for the error
341      * message unnecessarily. For custom revert reasons use {tryDiv}.
342      *
343      * Counterpart to Solidity's `/` operator. Note: this function uses a
344      * `revert` opcode (which leaves remaining gas untouched) while Solidity
345      * uses an invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b > 0, errorMessage);
353         return a / b;
354     }
355 
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * reverting with custom message when dividing by zero.
359      *
360      * CAUTION: This function is deprecated because it requires allocating memory for the error
361      * message unnecessarily. For custom revert reasons use {tryMod}.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b > 0, errorMessage);
373         return a % b;
374     }
375 }
376 
377 
378 contract TimeUtil {
379     uint256 private constant blockPerSecNumerator = 1;
380     uint256 private constant blockPerSecDenominator = 13;
381     using SafeMath for uint256;
382 
383     function blocksFromCurrent(uint256 targetTime) public view returns (uint256) {
384         return toBlocks(targetTime.sub(block.timestamp));
385     }
386 
387     function blocksFromBegin(uint256 targetTime) public view returns (uint256) {
388         return blocksFromCurrent(targetTime).add(block.number);
389     }
390 
391     function toBlocks(uint256 diffTime) public pure returns (uint256) {
392         return diffTime.mul(blockPerSecNumerator).div(blockPerSecDenominator);
393     }
394 }
395 
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         uint256 size;
424         // solhint-disable-next-line no-inline-assembly
425         assembly { size := extcodesize(account) }
426         return size > 0;
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, "Address: insufficient balance");
447 
448         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
449         (bool success, ) = recipient.call{ value: amount }("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain`call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472       return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but also transferring `value` wei to `target`.
488      *
489      * Requirements:
490      *
491      * - the calling contract must have an ETH balance of at least `value`.
492      * - the called Solidity function must be `payable`.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
502      * with `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         // solhint-disable-next-line avoid-low-level-calls
511         (bool success, bytes memory returndata) = target.call{ value: value }(data);
512         return _verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
522         return functionStaticCall(target, data, "Address: low-level static call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
532         require(isContract(target), "Address: static call to non-contract");
533 
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.staticcall(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
546         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
556         require(isContract(target), "Address: delegate call to non-contract");
557 
558         // solhint-disable-next-line avoid-low-level-calls
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return _verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 // solhint-disable-next-line no-inline-assembly
572                 assembly {
573                     let returndata_size := mload(returndata)
574                     revert(add(32, returndata), returndata_size)
575                 }
576             } else {
577                 revert(errorMessage);
578             }
579         }
580     }
581 }
582 
583 
584 /**
585  * @title SafeERC20
586  * @dev Wrappers around ERC20 operations that throw on failure (when the token
587  * contract returns false). Tokens that return no value (and instead revert or
588  * throw on failure) are also supported, non-reverting calls are assumed to be
589  * successful.
590  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
591  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
592  */
593 library SafeERC20 {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     function safeTransfer(IERC20 token, address to, uint256 value) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
599     }
600 
601     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
603     }
604 
605     /**
606      * @dev Deprecated. This function has issues similar to the ones found in
607      * {IERC20-approve}, and its usage is discouraged.
608      *
609      * Whenever possible, use {safeIncreaseAllowance} and
610      * {safeDecreaseAllowance} instead.
611      */
612     function safeApprove(IERC20 token, address spender, uint256 value) internal {
613         // safeApprove should only be called when setting an initial allowance,
614         // or when resetting it to zero. To increase and decrease it, use
615         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
616         // solhint-disable-next-line max-line-length
617         require((value == 0) || (token.allowance(address(this), spender) == 0),
618             "SafeERC20: approve from non-zero to non-zero allowance"
619         );
620         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
621     }
622 
623     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
624         uint256 newAllowance = token.allowance(address(this), spender).add(value);
625         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
626     }
627 
628     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
629         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
630         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
631     }
632 
633     /**
634      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
635      * on the return value: the return value is optional (but if data is returned, it must not be false).
636      * @param token The token targeted by the call.
637      * @param data The call data (encoded using abi.encode or one of its variants).
638      */
639     function _callOptionalReturn(IERC20 token, bytes memory data) private {
640         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
641         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
642         // the target address contains contract code and also asserts for success in the low-level call.
643 
644         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
645         if (returndata.length > 0) { // Return data is optional
646             // solhint-disable-next-line max-line-length
647             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
648         }
649     }
650 }
651 
652 
653 /**
654  * @dev Library for managing
655  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
656  * types.
657  *
658  * Sets have the following properties:
659  *
660  * - Elements are added, removed, and checked for existence in constant time
661  * (O(1)).
662  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
663  *
664  * ```
665  * contract Example {
666  *     // Add the library methods
667  *     using EnumerableSet for EnumerableSet.AddressSet;
668  *
669  *     // Declare a set state variable
670  *     EnumerableSet.AddressSet private mySet;
671  * }
672  * ```
673  *
674  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
675  * and `uint256` (`UintSet`) are supported.
676  */
677 library EnumerableSet {
678     // To implement this library for multiple types with as little code
679     // repetition as possible, we write it in terms of a generic Set type with
680     // bytes32 values.
681     // The Set implementation uses private functions, and user-facing
682     // implementations (such as AddressSet) are just wrappers around the
683     // underlying Set.
684     // This means that we can only create new EnumerableSets for types that fit
685     // in bytes32.
686 
687     struct Set {
688         // Storage of set values
689         bytes32[] _values;
690 
691         // Position of the value in the `values` array, plus 1 because index 0
692         // means a value is not in the set.
693         mapping (bytes32 => uint256) _indexes;
694     }
695 
696     /**
697      * @dev Add a value to a set. O(1).
698      *
699      * Returns true if the value was added to the set, that is if it was not
700      * already present.
701      */
702     function _add(Set storage set, bytes32 value) private returns (bool) {
703         if (!_contains(set, value)) {
704             set._values.push(value);
705             // The value is stored at length-1, but we add 1 to all indexes
706             // and use 0 as a sentinel value
707             set._indexes[value] = set._values.length;
708             return true;
709         } else {
710             return false;
711         }
712     }
713 
714     /**
715      * @dev Removes a value from a set. O(1).
716      *
717      * Returns true if the value was removed from the set, that is if it was
718      * present.
719      */
720     function _remove(Set storage set, bytes32 value) private returns (bool) {
721         // We read and store the value's index to prevent multiple reads from the same storage slot
722         uint256 valueIndex = set._indexes[value];
723 
724         if (valueIndex != 0) { // Equivalent to contains(set, value)
725             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
726             // the array, and then remove the last element (sometimes called as 'swap and pop').
727             // This modifies the order of the array, as noted in {at}.
728 
729             uint256 toDeleteIndex = valueIndex - 1;
730             uint256 lastIndex = set._values.length - 1;
731 
732             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
733             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
734 
735             bytes32 lastvalue = set._values[lastIndex];
736 
737             // Move the last value to the index where the value to delete is
738             set._values[toDeleteIndex] = lastvalue;
739             // Update the index for the moved value
740             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
741 
742             // Delete the slot where the moved value was stored
743             set._values.pop();
744 
745             // Delete the index for the deleted slot
746             delete set._indexes[value];
747 
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754     /**
755      * @dev Returns true if the value is in the set. O(1).
756      */
757     function _contains(Set storage set, bytes32 value) private view returns (bool) {
758         return set._indexes[value] != 0;
759     }
760 
761     /**
762      * @dev Returns the number of values on the set. O(1).
763      */
764     function _length(Set storage set) private view returns (uint256) {
765         return set._values.length;
766     }
767 
768    /**
769     * @dev Returns the value stored at position `index` in the set. O(1).
770     *
771     * Note that there are no guarantees on the ordering of values inside the
772     * array, and it may change when more values are added or removed.
773     *
774     * Requirements:
775     *
776     * - `index` must be strictly less than {length}.
777     */
778     function _at(Set storage set, uint256 index) private view returns (bytes32) {
779         require(set._values.length > index, "EnumerableSet: index out of bounds");
780         return set._values[index];
781     }
782 
783     // Bytes32Set
784 
785     struct Bytes32Set {
786         Set _inner;
787     }
788 
789     /**
790      * @dev Add a value to a set. O(1).
791      *
792      * Returns true if the value was added to the set, that is if it was not
793      * already present.
794      */
795     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
796         return _add(set._inner, value);
797     }
798 
799     /**
800      * @dev Removes a value from a set. O(1).
801      *
802      * Returns true if the value was removed from the set, that is if it was
803      * present.
804      */
805     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
806         return _remove(set._inner, value);
807     }
808 
809     /**
810      * @dev Returns true if the value is in the set. O(1).
811      */
812     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
813         return _contains(set._inner, value);
814     }
815 
816     /**
817      * @dev Returns the number of values in the set. O(1).
818      */
819     function length(Bytes32Set storage set) internal view returns (uint256) {
820         return _length(set._inner);
821     }
822 
823    /**
824     * @dev Returns the value stored at position `index` in the set. O(1).
825     *
826     * Note that there are no guarantees on the ordering of values inside the
827     * array, and it may change when more values are added or removed.
828     *
829     * Requirements:
830     *
831     * - `index` must be strictly less than {length}.
832     */
833     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
834         return _at(set._inner, index);
835     }
836 
837     // AddressSet
838 
839     struct AddressSet {
840         Set _inner;
841     }
842 
843     /**
844      * @dev Add a value to a set. O(1).
845      *
846      * Returns true if the value was added to the set, that is if it was not
847      * already present.
848      */
849     function add(AddressSet storage set, address value) internal returns (bool) {
850         return _add(set._inner, bytes32(uint256(uint160(value))));
851     }
852 
853     /**
854      * @dev Removes a value from a set. O(1).
855      *
856      * Returns true if the value was removed from the set, that is if it was
857      * present.
858      */
859     function remove(AddressSet storage set, address value) internal returns (bool) {
860         return _remove(set._inner, bytes32(uint256(uint160(value))));
861     }
862 
863     /**
864      * @dev Returns true if the value is in the set. O(1).
865      */
866     function contains(AddressSet storage set, address value) internal view returns (bool) {
867         return _contains(set._inner, bytes32(uint256(uint160(value))));
868     }
869 
870     /**
871      * @dev Returns the number of values in the set. O(1).
872      */
873     function length(AddressSet storage set) internal view returns (uint256) {
874         return _length(set._inner);
875     }
876 
877    /**
878     * @dev Returns the value stored at position `index` in the set. O(1).
879     *
880     * Note that there are no guarantees on the ordering of values inside the
881     * array, and it may change when more values are added or removed.
882     *
883     * Requirements:
884     *
885     * - `index` must be strictly less than {length}.
886     */
887     function at(AddressSet storage set, uint256 index) internal view returns (address) {
888         return address(uint160(uint256(_at(set._inner, index))));
889     }
890 
891 
892     // UintSet
893 
894     struct UintSet {
895         Set _inner;
896     }
897 
898     /**
899      * @dev Add a value to a set. O(1).
900      *
901      * Returns true if the value was added to the set, that is if it was not
902      * already present.
903      */
904     function add(UintSet storage set, uint256 value) internal returns (bool) {
905         return _add(set._inner, bytes32(value));
906     }
907 
908     /**
909      * @dev Removes a value from a set. O(1).
910      *
911      * Returns true if the value was removed from the set, that is if it was
912      * present.
913      */
914     function remove(UintSet storage set, uint256 value) internal returns (bool) {
915         return _remove(set._inner, bytes32(value));
916     }
917 
918     /**
919      * @dev Returns true if the value is in the set. O(1).
920      */
921     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
922         return _contains(set._inner, bytes32(value));
923     }
924 
925     /**
926      * @dev Returns the number of values on the set. O(1).
927      */
928     function length(UintSet storage set) internal view returns (uint256) {
929         return _length(set._inner);
930     }
931 
932    /**
933     * @dev Returns the value stored at position `index` in the set. O(1).
934     *
935     * Note that there are no guarantees on the ordering of values inside the
936     * array, and it may change when more values are added or removed.
937     *
938     * Requirements:
939     *
940     * - `index` must be strictly less than {length}.
941     */
942     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
943         return uint256(_at(set._inner, index));
944     }
945 }
946 
947 
948 /**
949  * @dev Contract module that helps prevent reentrant calls to a function.
950  *
951  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
952  * available, which can be applied to functions to make sure there are no nested
953  * (reentrant) calls to them.
954  *
955  * Note that because there is a single `nonReentrant` guard, functions marked as
956  * `nonReentrant` may not call one another. This can be worked around by making
957  * those functions `private`, and then adding `external` `nonReentrant` entry
958  * points to them.
959  *
960  * TIP: If you would like to learn more about reentrancy and alternative ways
961  * to protect against it, check out our blog post
962  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
963  */
964 abstract contract ReentrancyGuard {
965     // Booleans are more expensive than uint256 or any type that takes up a full
966     // word because each write operation emits an extra SLOAD to first read the
967     // slot's contents, replace the bits taken up by the boolean, and then write
968     // back. This is the compiler's defense against contract upgrades and
969     // pointer aliasing, and it cannot be disabled.
970 
971     // The values being non-zero value makes deployment a bit more expensive,
972     // but in exchange the refund on every call to nonReentrant will be lower in
973     // amount. Since refunds are capped to a percentage of the total
974     // transaction's gas, it is best to keep them low in cases like this one, to
975     // increase the likelihood of the full refund coming into effect.
976     uint256 private constant _NOT_ENTERED = 1;
977     uint256 private constant _ENTERED = 2;
978 
979     uint256 private _status;
980 
981     constructor () internal {
982         _status = _NOT_ENTERED;
983     }
984 
985     /**
986      * @dev Prevents a contract from calling itself, directly or indirectly.
987      * Calling a `nonReentrant` function from another `nonReentrant`
988      * function is not supported. It is possible to prevent this from happening
989      * by making the `nonReentrant` function external, and make it call a
990      * `private` function that does the actual work.
991      */
992     modifier nonReentrant() {
993         // On the first call to nonReentrant, _notEntered will be true
994         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
995 
996         // Any calls to nonReentrant after this point will fail
997         _status = _ENTERED;
998 
999         _;
1000 
1001         // By storing the original value once again, a refund is triggered (see
1002         // https://eips.ethereum.org/EIPS/eip-2200)
1003         _status = _NOT_ENTERED;
1004     }
1005 }
1006 
1007 
1008 abstract contract AdminAccessControl is Context {
1009     using EnumerableSet for EnumerableSet.AddressSet;
1010     EnumerableSet.AddressSet private _adminSet;
1011 
1012     constructor() internal {
1013         _adminSet.add(_msgSender());
1014     }
1015 
1016     function getAdministrators() public view returns (address[] memory addresses) {
1017         addresses = new address[](_adminSet.length());
1018         for (uint256 index = 0; index < addresses.length; ++index) addresses[index] = _adminSet.at(index);
1019     }
1020 
1021     function addAdministrator(address account) public onlyAdmin {
1022         require(_adminSet.add(account), "AccessControl: account already an administrator.");
1023     }
1024 
1025     function clearAdministrator(address account) public onlyAdmin {
1026         require(_adminSet.length() > 1, "AccessControl: cannot remove last administrator.");
1027         require(_adminSet.remove(account), "AccessControl: account not an administrator.");
1028     }
1029 
1030     modifier onlyAdmin() {
1031         require(_adminSet.contains(_msgSender()), "AccessControl: require administrator account");
1032         _;
1033     }
1034 }
1035 
1036 
1037 contract StakingBase is ReentrancyGuard, AdminAccessControl {
1038     using SafeMath for uint256;
1039     using SafeERC20 for IERC20;
1040 
1041     struct UserInfo {
1042         uint256 amount; // deposited amount
1043         uint256 rewardDebt; // reward debt for pending calculation
1044         uint256 exChanged; // total claimed token
1045     }
1046 
1047     // Info of each pool.
1048     struct PoolInfo {
1049         address tokenAddress; // address of sataking token
1050         uint256 poolPledged; // total pledged token per pool
1051         uint256 allocPoint; // How many allocation points assigned to this pool.
1052         uint256 lastRewardBlock; // Last block number that token distribution occurs.
1053         uint256 accTokenPerShare; // Accumulated token per share, times 1e12.
1054     }
1055 
1056     struct PeriodeReleases {
1057         uint256 blockOffset; // number of block from mining begin
1058         uint256 tokenPerBlock; // number of tokens release per block 
1059     }
1060 
1061     // How many allocation points assigned in total.
1062     uint256 public totalAllocPoint;
1063 
1064     // periodes
1065     PeriodeReleases[] public periodes;
1066 
1067     // Tokens that will be released
1068     uint256 public miningTotal;
1069 
1070     // the beginning block of mining
1071     uint256 public miningBeginBlock;
1072  
1073 
1074     // yao token
1075     IERC20 private _yao;
1076 
1077     bool public isEmergency;
1078 
1079     // abstraction pools, which might be an ERC1155 pool, an ERC20 pool, even a CFX pool
1080     // depens on inherition
1081     PoolInfo[] public poolInfo;
1082 
1083     // Info of each user that stakes LP tokens.
1084     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1085 
1086     event Withdraw(address indexed user, uint256 indexed pId, uint256 amount);
1087     event EmergencyWithdraw(address indexed user, uint256 indexed pId, uint256 amount);
1088 
1089     constructor(IERC20 yao_) public {
1090         _yao = yao_;
1091         isEmergency = false;
1092     }
1093 
1094     function setEmergency(bool isEmergency_) public onlyAdmin {
1095         isEmergency = isEmergency_;
1096     }
1097 
1098     
1099     /**
1100      * @dev add new pool, with alloc point
1101      * any inherited contract should call this function to create the pool
1102      */
1103     function _add(uint256 _allocPoint, address tokenAddress) internal onlyAdmin returns (uint256) {
1104         _updateAllPools();
1105         uint256 pid = poolInfo.length;
1106         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1107         poolInfo.push(PoolInfo({tokenAddress: tokenAddress, poolPledged: 0, allocPoint: _allocPoint, lastRewardBlock: miningBeginBlock, accTokenPerShare: 0}));
1108         return pid;
1109     }
1110 
1111     /**
1112      * @dev modify an pool's alloc point.
1113      * in order to minimize inaccuracy, it should call before the pool opens or as soon as a periode is advanced
1114      */
1115     function setAllocPoint(uint256 pId, uint256 _allocPoint) public virtual onlyAdmin {
1116         _updateAllPools();
1117         PoolInfo storage pool = poolInfo[pId];
1118         totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(_allocPoint);
1119         pool.allocPoint = _allocPoint;
1120     }
1121 
1122     /**
1123      * @dev get the balance of owner's periode token
1124      */
1125     function pendingToken(uint256 pId, address _user) external view returns (uint256) {
1126         PoolInfo memory pool = poolInfo[pId];
1127         UserInfo memory user = userInfo[pId][_user];
1128         uint256 accTokenPerShare = pool.accTokenPerShare;
1129         if (block.number > pool.lastRewardBlock && pool.poolPledged > 0) {
1130             uint256 yaoReward = getPoolReward(pool.lastRewardBlock, pool.allocPoint);
1131             accTokenPerShare = accTokenPerShare.add(yaoReward.mul(1e12).div(pool.poolPledged));
1132         }
1133         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1134     }
1135 
1136     /**
1137      * @dev refresh all pool infomation, should be called before modification is maked for any pools
1138      */
1139     function _updateAllPools() internal virtual {
1140         for (uint256 idxPool = 0; idxPool < poolInfo.length; ++idxPool) _updatePool(poolInfo[idxPool]);
1141     }
1142 
1143     /**
1144      * @dev Update reward variables of the given pool to be up-to-date.
1145      */
1146 
1147     function _updatePool(PoolInfo storage pool) internal virtual {
1148         // if the mining is not started there is no needs to update
1149         if (block.number <= pool.lastRewardBlock) {
1150             return;
1151         }
1152         // if there is nothing in this pool
1153         if (pool.poolPledged == 0) {
1154             pool.lastRewardBlock = block.number;
1155             return;
1156         }
1157         // get reward
1158         uint256 yaoReward = getPoolReward(pool.lastRewardBlock, pool.allocPoint);
1159         // calcult accumulate token per share
1160         pool.accTokenPerShare = pool.accTokenPerShare.add(yaoReward.mul(1e12).div(pool.poolPledged));
1161         // update pool last reward block
1162         pool.lastRewardBlock = block.number;  
1163     }
1164 
1165     /**
1166      * @dev deposit token into pool
1167      * any inherited contract should call this function to make a deposit
1168      */
1169     function _deposit(uint256 pId, uint256 _amount) internal nonReentrant returns (uint256) {
1170         PoolInfo storage pool = poolInfo[pId];
1171         UserInfo storage user = userInfo[pId][_msgSender()];
1172         _withdrawPool(pId, user);
1173         user.amount = user.amount.add(_amount);
1174         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1175         pool.poolPledged = pool.poolPledged.add(_amount);
1176         return user.amount;
1177     }
1178 
1179     /**
1180      * @dev withdraw staking token from pool
1181      * any inherited contract should call this function to make a withdraw
1182      */
1183     function _withdraw(uint256 pId, uint256 _amount) internal nonReentrant returns (uint256) {
1184         PoolInfo storage pool = poolInfo[pId];
1185         UserInfo storage user = userInfo[pId][_msgSender()];
1186         require(user.amount >= _amount, "StakingBase: _withdraw needs amount > user.amount");
1187         _withdrawPool(pId, user);
1188         user.amount = user.amount.sub(_amount);
1189         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1190         pool.poolPledged = pool.poolPledged.sub(_amount);
1191         return user.amount;
1192     }
1193 
1194     /**
1195      * @dev withdraw without tokens, emergency only
1196      * any inherited contract should call this function to make a emergencyWithdraw
1197      */
1198     function _emergencyWithdraw(uint256 pId) internal nonReentrant onEmergency returns (uint256) {
1199         PoolInfo storage pool = poolInfo[pId];
1200         UserInfo storage user = userInfo[pId][_msgSender()];
1201         if (user.amount > 0) {
1202             user.amount = 0;
1203             user.rewardDebt = 0;
1204             pool.poolPledged = pool.poolPledged.sub(user.amount);
1205         }
1206     }
1207 
1208     /**
1209      * @dev withdraw periode token from pool(in this case is Yao)
1210      */
1211     function withdrawPool(uint256 pId) public nonReentrant {
1212         _withdrawPool(pId, userInfo[pId][_msgSender()]);
1213     }
1214 
1215     /**
1216      * @dev withdraw periode token from every pool(in this case is Yao)
1217      */
1218     function withdrawPoolAll() public nonReentrant {
1219         for (uint256 index = 0; index < poolInfo.length; ++index) {
1220             UserInfo storage user = userInfo[index][_msgSender()];
1221             if (user.amount > 0) _withdrawPool(index, user);
1222         }
1223     }
1224 
1225     /**
1226      * @dev implemtation of withdraw pending tokens
1227      */
1228     function _withdrawPool(uint256 pId, UserInfo storage user) private {
1229         PoolInfo storage pool = poolInfo[pId];
1230         // update pool for new accTokenPerShare
1231         _updatePool(pool);
1232         // calculate pending tokens
1233         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1234         // if has pending token, then send
1235         if (pending > 0) {
1236             safeTransferYAO(_msgSender(), pending);
1237             user.exChanged = user.exChanged.add(pending);
1238             emit Withdraw(_msgSender(), pId, pending);
1239         }
1240         // update user reward debut
1241         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1242     }
1243  
1244 
1245     // Safe Yao transfer function, just in case if rounding error causes pool to not have enough tokens.
1246     function safeTransferYAO(address to, uint256 amount) internal {
1247         if (amount > 0) {
1248             uint256 acgBal = _yao.balanceOf(address(this));
1249             if (amount > acgBal) {
1250                 _yao.transfer(to, acgBal);
1251             } else {
1252                 _yao.transfer(to, amount);
1253             }
1254         }
1255     }
1256 
1257     /**
1258      * @dev get pool reward
1259      */
1260     function getPoolReward(uint256 _poolLastRewardBlock, uint256 _poolAllocPoint) internal view returns (uint256) {
1261         return getPoolReward(_poolLastRewardBlock, _poolAllocPoint, block.number);
1262     }
1263 
1264     /**
1265      * @dev get pool reward
1266      */
1267     function getPoolReward(
1268         uint256 _poolLastRewardBlock,
1269         uint256 _poolAllocPoint,
1270         uint256 _blockNumber
1271     ) internal view returns (uint256) {
1272         if (_blockNumber < miningBeginBlock) return 0;
1273 
1274         // get offset of current block from beginning
1275         uint256 currentOffset = _blockNumber.sub(miningBeginBlock);
1276         // get offset of last reward block from beginning
1277         uint256 lasRewardBlockOffset = _poolLastRewardBlock.sub(miningBeginBlock);
1278         uint256 poolRewards = 0;
1279         // from last periode to first periode
1280         for (uint256 idx = periodes.length - 1; ; --idx) {
1281             // if last reward is later that current periode,
1282             // so we sure that lasRewardBlockOffset to currentOffset is in the same periode,
1283             // accumulate rewards then stop iterate.
1284             // if not, that lasRewardBlockOffset and currentOffset is in the different periode,
1285             // accumulate rewards and move currentOffset to the beginning of current periode, contiune to iterate
1286             PeriodeReleases memory onePeriode = periodes[idx];
1287             if (lasRewardBlockOffset >= onePeriode.blockOffset) {
1288                 poolRewards = poolRewards.add(onePeriode.tokenPerBlock * currentOffset.sub(lasRewardBlockOffset));
1289                 break;
1290             } else if (currentOffset > onePeriode.blockOffset) {
1291                 poolRewards = poolRewards.add(onePeriode.tokenPerBlock * (currentOffset.sub(onePeriode.blockOffset)));
1292                 currentOffset = onePeriode.blockOffset;
1293             }
1294         }
1295         // apply allocation percentage to pool reward
1296         return poolRewards.mul(_poolAllocPoint).div(totalAllocPoint);
1297     }
1298 
1299     function getBlockInfo() public view returns (uint256, uint256) {
1300         return (block.timestamp, block.number);
1301     }
1302 
1303     function estimateRewards(
1304         uint256 pId,
1305         uint256 amount,
1306         uint256 blockOffset
1307     ) public view returns (uint256 rewards) {
1308         PoolInfo memory pool = poolInfo[pId];
1309         uint256 yaoReward = getPoolReward(block.number, pool.allocPoint, block.number.add(blockOffset));
1310         return yaoReward.mul(amount).div(pool.poolPledged.add(amount));
1311     }
1312 
1313     function totalReleased() public view returns (uint256) {
1314         if (block.number < miningBeginBlock) return 0;
1315         // get offset of current block from beginning
1316         uint256 currentOffset = block.number.sub(miningBeginBlock);
1317         uint256 sum = 0;
1318         for (uint256 idx = periodes.length - 1; ; --idx) {
1319             PeriodeReleases memory onePeriode = periodes[idx];
1320             if (currentOffset > onePeriode.blockOffset) {
1321                 sum = sum.add(onePeriode.tokenPerBlock * (currentOffset.sub(onePeriode.blockOffset)));
1322                 currentOffset = onePeriode.blockOffset;
1323                 if (idx == 0) break;
1324             }
1325         }
1326         return sum;
1327     }
1328 
1329     modifier onEmergency() {
1330         require(isEmergency, "StakingBase: not in emergency");
1331         _;
1332     }
1333 }
1334 
1335 
1336 /**
1337  * @dev Interface of the ERC165 standard, as defined in the
1338  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1339  *
1340  * Implementers can declare support of contract interfaces, which can then be
1341  * queried by others ({ERC165Checker}).
1342  *
1343  * For an implementation, see {ERC165}.
1344  */
1345 interface IERC165 {
1346     /**
1347      * @dev Returns true if this contract implements the interface defined by
1348      * `interfaceId`. See the corresponding
1349      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1350      * to learn more about how these ids are created.
1351      *
1352      * This function call must use less than 30 000 gas.
1353      */
1354     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1355 }
1356 
1357 
1358 /**
1359  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1360  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1361  *
1362  * _Available since v3.1._
1363  */
1364 interface IERC1155 is IERC165 {
1365     /**
1366      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1367      */
1368     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1369 
1370     /**
1371      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1372      * transfers.
1373      */
1374     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1375 
1376     /**
1377      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1378      * `approved`.
1379      */
1380     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1381 
1382     /**
1383      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1384      *
1385      * If an {URI} event was emitted for `id`, the standard
1386      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1387      * returned by {IERC1155MetadataURI-uri}.
1388      */
1389     event URI(string value, uint256 indexed id);
1390 
1391     /**
1392      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1393      *
1394      * Requirements:
1395      *
1396      * - `account` cannot be the zero address.
1397      */
1398     function balanceOf(address account, uint256 id) external view returns (uint256);
1399 
1400     /**
1401      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1402      *
1403      * Requirements:
1404      *
1405      * - `accounts` and `ids` must have the same length.
1406      */
1407     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1408 
1409     /**
1410      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1411      *
1412      * Emits an {ApprovalForAll} event.
1413      *
1414      * Requirements:
1415      *
1416      * - `operator` cannot be the caller.
1417      */
1418     function setApprovalForAll(address operator, bool approved) external;
1419 
1420     /**
1421      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1422      *
1423      * See {setApprovalForAll}.
1424      */
1425     function isApprovedForAll(address account, address operator) external view returns (bool);
1426 
1427     /**
1428      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1429      *
1430      * Emits a {TransferSingle} event.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1436      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1437      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1438      * acceptance magic value.
1439      */
1440     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1441 
1442     /**
1443      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1444      *
1445      * Emits a {TransferBatch} event.
1446      *
1447      * Requirements:
1448      *
1449      * - `ids` and `amounts` must have the same length.
1450      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1451      * acceptance magic value.
1452      */
1453     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1454 }
1455 
1456 
1457 /**
1458  * _Available since v3.1._
1459  */
1460 interface IERC1155Receiver is IERC165 {
1461 
1462     /**
1463         @dev Handles the receipt of a single ERC1155 token type. This function is
1464         called at the end of a `safeTransferFrom` after the balance has been updated.
1465         To accept the transfer, this must return
1466         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1467         (i.e. 0xf23a6e61, or its own function selector).
1468         @param operator The address which initiated the transfer (i.e. msg.sender)
1469         @param from The address which previously owned the token
1470         @param id The ID of the token being transferred
1471         @param value The amount of tokens being transferred
1472         @param data Additional data with no specified format
1473         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1474     */
1475     function onERC1155Received(
1476         address operator,
1477         address from,
1478         uint256 id,
1479         uint256 value,
1480         bytes calldata data
1481     )
1482         external
1483         returns(bytes4);
1484 
1485     /**
1486         @dev Handles the receipt of a multiple ERC1155 token types. This function
1487         is called at the end of a `safeBatchTransferFrom` after the balances have
1488         been updated. To accept the transfer(s), this must return
1489         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1490         (i.e. 0xbc197c81, or its own function selector).
1491         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1492         @param from The address which previously owned the token
1493         @param ids An array containing ids of each token being transferred (order and length must match values array)
1494         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1495         @param data Additional data with no specified format
1496         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1497     */
1498     function onERC1155BatchReceived(
1499         address operator,
1500         address from,
1501         uint256[] calldata ids,
1502         uint256[] calldata values,
1503         bytes calldata data
1504     )
1505         external
1506         returns(bytes4);
1507 }
1508 
1509 
1510 /**
1511  * @dev Implementation of the {IERC165} interface.
1512  *
1513  * Contracts may inherit from this and call {_registerInterface} to declare
1514  * their support of an interface.
1515  */
1516 abstract contract ERC165 is IERC165 {
1517     /*
1518      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1519      */
1520     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1521 
1522     /**
1523      * @dev Mapping of interface ids to whether or not it's supported.
1524      */
1525     mapping(bytes4 => bool) private _supportedInterfaces;
1526 
1527     constructor () internal {
1528         // Derived contracts need only register support for their own interfaces,
1529         // we register support for ERC165 itself here
1530         _registerInterface(_INTERFACE_ID_ERC165);
1531     }
1532 
1533     /**
1534      * @dev See {IERC165-supportsInterface}.
1535      *
1536      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1537      */
1538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1539         return _supportedInterfaces[interfaceId];
1540     }
1541 
1542     /**
1543      * @dev Registers the contract as an implementer of the interface defined by
1544      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1545      * registering its interface id is not required.
1546      *
1547      * See {IERC165-supportsInterface}.
1548      *
1549      * Requirements:
1550      *
1551      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1552      */
1553     function _registerInterface(bytes4 interfaceId) internal virtual {
1554         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1555         _supportedInterfaces[interfaceId] = true;
1556     }
1557 }
1558 
1559 
1560 /**
1561  * @dev _Available since v3.1._
1562  */
1563 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1564     constructor() internal {
1565         _registerInterface(
1566             ERC1155Receiver(address(0)).onERC1155Received.selector ^
1567             ERC1155Receiver(address(0)).onERC1155BatchReceived.selector
1568         );
1569     }
1570 }
1571 
1572 
1573 /**
1574  * @dev Library for managing an enumerable variant of Solidity's
1575  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1576  * type.
1577  *
1578  * Maps have the following properties:
1579  *
1580  * - Entries are added, removed, and checked for existence in constant time
1581  * (O(1)).
1582  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1583  *
1584  * ```
1585  * contract Example {
1586  *     // Add the library methods
1587  *     using EnumerableMap for EnumerableMap.UintToUintMap;
1588  *
1589  *     // Declare a set state variable
1590  *     EnumerableMap.UintToUintMap private myMap;
1591  * }
1592  * ```
1593  *
1594  * As of v3.0.0, only maps of type `uint256 -> uint256` (`UintToUintMap`) are
1595  * supported.
1596  */
1597 library EnumerableMap {
1598     // To implement this library for multiple types with as little code
1599     // repetition as possible, we write it in terms of a generic Map type with
1600     // bytes32 keys and values.
1601     // The Map implementation uses private functions, and user-facing
1602     // implementations (such as Uint256Touint256Map) are just wrappers around
1603     // the underlying Map.
1604     // This means that we can only create new EnumerableMaps for types that fit
1605     // in bytes32.
1606 
1607     struct MapEntry {
1608         bytes32 _key;
1609         bytes32 _value;
1610     }
1611 
1612     struct Map {
1613         // Storage of map keys and values
1614         MapEntry[] _entries;
1615         // Position of the entry defined by a key in the `entries` array, plus 1
1616         // because index 0 means a key is not in the map.
1617         mapping(bytes32 => uint256) _indexes;
1618     }
1619 
1620     /**
1621      * @dev Adds a key-value pair to a map, or updates the value for an existing
1622      * key. O(1).
1623      *
1624      * Returns true if the key was added to the map, that is if it was not
1625      * already present.
1626      */
1627     function _set(
1628         Map storage map,
1629         bytes32 key,
1630         bytes32 value
1631     ) private returns (bool) {
1632         // We read and store the key's index to prevent multiple reads from the same storage slot
1633         uint256 keyIndex = map._indexes[key];
1634 
1635         if (keyIndex == 0) {
1636             // Equivalent to !contains(map, key)
1637             map._entries.push(MapEntry({_key: key, _value: value}));
1638             // The entry is stored at length-1, but we add 1 to all indexes
1639             // and use 0 as a sentinel value
1640             map._indexes[key] = map._entries.length;
1641             return true;
1642         } else {
1643             map._entries[keyIndex - 1]._value = value;
1644             return false;
1645         }
1646     }
1647 
1648     /**
1649      * @dev Removes a key-value pair from a map. O(1).
1650      *
1651      * Returns true if the key was removed from the map, that is if it was present.
1652      */
1653     function _remove(Map storage map, bytes32 key) private returns (bool) {
1654         // We read and store the key's index to prevent multiple reads from the same storage slot
1655         uint256 keyIndex = map._indexes[key];
1656 
1657         if (keyIndex != 0) {
1658             // Equivalent to contains(map, key)
1659             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1660             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1661             // This modifies the order of the array, as noted in {at}.
1662 
1663             uint256 toDeleteIndex = keyIndex - 1;
1664             uint256 lastIndex = map._entries.length - 1;
1665 
1666             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1667             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1668 
1669             MapEntry storage lastEntry = map._entries[lastIndex];
1670 
1671             // Move the last entry to the index where the entry to delete is
1672             map._entries[toDeleteIndex] = lastEntry;
1673             // Update the index for the moved entry
1674             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1675 
1676             // Delete the slot where the moved entry was stored
1677             map._entries.pop();
1678 
1679             // Delete the index for the deleted slot
1680             delete map._indexes[key];
1681 
1682             return true;
1683         } else {
1684             return false;
1685         }
1686     }
1687 
1688     /**
1689      * @dev Returns true if the key is in the map. O(1).
1690      */
1691     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1692         return map._indexes[key] != 0;
1693     }
1694 
1695     /**
1696      * @dev Returns the number of key-value pairs in the map. O(1).
1697      */
1698     function _length(Map storage map) private view returns (uint256) {
1699         return map._entries.length;
1700     }
1701 
1702     /**
1703      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1704      *
1705      * Note that there are no guarantees on the ordering of entries inside the
1706      * array, and it may change when more entries are added or removed.
1707      *
1708      * Requirements:
1709      *
1710      * - `index` must be strictly less than {length}.
1711      */
1712     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1713         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1714 
1715         MapEntry storage entry = map._entries[index];
1716         return (entry._key, entry._value);
1717     }
1718 
1719     /**
1720      * @dev Tries to returns the value associated with `key`.  O(1).
1721      * Does not revert if `key` is not in the map.
1722      */
1723     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1724         uint256 keyIndex = map._indexes[key];
1725         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1726         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1727     }
1728 
1729     /**
1730      * @dev Returns the value associated with `key`.  O(1).
1731      *
1732      * Requirements:
1733      *
1734      * - `key` must be in the map.
1735      */
1736     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1737         uint256 keyIndex = map._indexes[key];
1738         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1739         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1740     }
1741 
1742     /**
1743      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1744      *
1745      * CAUTION: This function is deprecated because it requires allocating memory for the error
1746      * message unnecessarily. For custom revert reasons use {_tryGet}.
1747      */
1748     function _get(
1749         Map storage map,
1750         bytes32 key,
1751         string memory errorMessage
1752     ) private view returns (bytes32) {
1753         uint256 keyIndex = map._indexes[key];
1754         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1755         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1756     }
1757 
1758     // UintToUintMap
1759 
1760     struct UintToUintMap {
1761         Map _inner;
1762     }
1763 
1764     /**
1765      * @dev Adds a key-value pair to a map, or updates the value for an existing
1766      * key. O(1).
1767      *
1768      * Returns true if the key was added to the map, that is if it was not
1769      * already present.
1770      */
1771     function set(
1772         UintToUintMap storage map,
1773         uint256 key,
1774         uint256 value
1775     ) internal returns (bool) {
1776         return _set(map._inner, bytes32(key), bytes32(value));
1777     }
1778 
1779     /**
1780      * @dev Removes a value from a set. O(1).
1781      *
1782      * Returns true if the key was removed from the map, that is if it was present.
1783      */
1784     function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
1785         return _remove(map._inner, bytes32(key));
1786     }
1787 
1788     /**
1789      * @dev Returns true if the key is in the map. O(1).
1790      */
1791     function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
1792         return _contains(map._inner, bytes32(key));
1793     }
1794 
1795     /**
1796      * @dev Returns the number of elements in the map. O(1).
1797      */
1798     function length(UintToUintMap storage map) internal view returns (uint256) {
1799         return _length(map._inner);
1800     }
1801 
1802     /**
1803      * @dev Returns the element stored at position `index` in the set. O(1).
1804      * Note that there are no guarantees on the ordering of values inside the
1805      * array, and it may change when more values are added or removed.
1806      *
1807      * Requirements:
1808      *
1809      * - `index` must be strictly less than {length}.
1810      */
1811     function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
1812         (bytes32 key, bytes32 value) = _at(map._inner, index);
1813         return (uint256(key), uint256(value));
1814     }
1815 
1816     /**
1817      * @dev Tries to returns the value associated with `key`.  O(1).
1818      * Does not revert if `key` is not in the map.
1819      *
1820      * _Available since v3.4._
1821      */
1822     function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
1823         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1824         return (success, uint256(value));
1825     }
1826 
1827     /**
1828      * @dev Returns the value associated with `key`.  O(1).
1829      *
1830      * Requirements:
1831      *
1832      * - `key` must be in the map.
1833      */
1834     function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
1835         return uint256(_get(map._inner, bytes32(key)));
1836     }
1837 
1838     /**
1839      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1840      *
1841      * CAUTION: This function is deprecated because it requires allocating memory for the error
1842      * message unnecessarily. For custom revert reasons use {tryGet}.
1843      */
1844     function get(
1845         UintToUintMap storage map,
1846         uint256 key,
1847         string memory errorMessage
1848     ) internal view returns (uint256) {
1849         return uint256(_get(map._inner, bytes32(key), errorMessage));
1850     }
1851 }
1852 
1853 
1854 contract StakingERC1155Receiver is ERC1155Receiver {
1855     event OnERC1155Received(address operator, address from, uint256 id, uint256 value, bytes data);
1856     event OnERC1155BatchReceived(address operator, address from, uint256[] ids, uint256[] values, bytes data);
1857 
1858     /**
1859         @dev Handles the receipt of a single ERC1155 token type. This function is
1860         called at the end of a `safeTransferFrom` after the balance has been updated.
1861         To accept the transfer, this must return
1862         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1863         (i.e. 0xf23a6e61, or its own function selector).
1864         @param operator The address which initiated the transfer (i.e. msg.sender)
1865         @param from The address which previously owned the token
1866         @param id The ID of the token being transferred
1867         @param value The amount of tokens being transferred
1868         @param data Additional data with no specified format
1869         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1870     */
1871     function onERC1155Received(
1872         address operator,
1873         address from,
1874         uint256 id,
1875         uint256 value,
1876         bytes calldata data
1877     ) public virtual override returns (bytes4) {
1878         //return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
1879         emit OnERC1155Received(operator, from, id, value, data);
1880         return this.onERC1155Received.selector;
1881     }
1882 
1883     /**
1884         @dev Handles the receipt of a multiple ERC1155 token types. This function
1885         is called at the end of a `safeBatchTransferFrom` after the balances have
1886         been updated. To accept the transfer(s), this must return
1887         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1888         (i.e. 0xbc197c81, or its own function selector).
1889         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1890         @param from The address which previously owned the token
1891         @param ids An array containing ids of each token being transferred (order and length must match values array)
1892         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1893         @param data Additional data with no specified format
1894         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1895     */
1896     function onERC1155BatchReceived(
1897         address operator,
1898         address from,
1899         uint256[] calldata ids,
1900         uint256[] calldata values,
1901         bytes calldata data
1902     ) public virtual override returns (bytes4) {
1903         //return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
1904         emit OnERC1155BatchReceived(operator, from, ids, values, data);
1905         return this.onERC1155BatchReceived.selector;
1906     }
1907 }
1908 
1909 
1910 abstract contract StakingERC1155 is StakingBase, StakingERC1155Receiver {
1911     using SafeMath for uint256;
1912     using EnumerableMap for EnumerableMap.UintToUintMap;
1913     using EnumerableSet for EnumerableSet.UintSet;
1914 
1915     uint256 constant ERC1155StakingMax = 5;
1916 
1917     mapping(uint256 => mapping(address => EnumerableMap.UintToUintMap)) private _erc1155Pools;
1918     EnumerableSet.UintSet private _erc1155PoolIdSet;
1919 
1920     event DepositERC1155(address indexed user, uint256 indexed pid, uint256[] erc1155Id, uint256[] amount);
1921     event WithdrawERC1155(address indexed user, uint256 indexed pid, uint256[] erc1155Id, uint256[] amount);
1922 
1923     constructor() internal {}
1924 
1925     /**
1926      * @dev add a erc1155 pool
1927      */
1928     function addERC1155Pool(uint256 _allocPoint, address _1155TokenAddr) public onlyAdmin {
1929         uint256 pId = _add(_allocPoint, _1155TokenAddr);
1930         _erc1155PoolIdSet.add(pId);
1931     }
1932 
1933     /**
1934      * @dev deposit erc1155 token to pool
1935      */
1936     function depositERC1155(
1937         uint256 pId,
1938         uint256[] calldata erc1155Ids,
1939         uint256[] calldata amounts
1940     ) public validAsERC1155PId(pId) {
1941         require(erc1155Ids.length == amounts.length, "StakingERC1155: _ids and amounts length mismatch");
1942         uint256 amountSum = 0;
1943         EnumerableMap.UintToUintMap storage erc1155Entities = _erc1155Pools[pId][_msgSender()];
1944 
1945         for (uint256 index = 0; index < erc1155Ids.length; ++index) {
1946             (, uint256 count) = erc1155Entities.tryGet(erc1155Ids[index]);
1947             erc1155Entities.set(erc1155Ids[index], count.add(amounts[index]));
1948             amountSum = amountSum.add(amounts[index]);
1949         }
1950 
1951         require(_deposit(pId, amountSum) <= ERC1155StakingMax, "StakingERC1155: NFT staking count exceed its maximun");
1952         IERC1155 tokenProdiver = IERC1155(poolInfo[pId].tokenAddress); // get token provider by id
1953         tokenProdiver.safeBatchTransferFrom(_msgSender(), address(this), erc1155Ids, amounts, "");
1954         emit DepositERC1155(_msgSender(), pId, erc1155Ids, amounts);
1955     }
1956 
1957     /**
1958      * @dev withdraw erc1155 token from pool
1959      */
1960     function withdrawERC1155(
1961         uint256 pId,
1962         uint256[] calldata erc1155Ids,
1963         uint256[] calldata amounts
1964     ) public validAsERC1155PId(pId) {
1965         require(erc1155Ids.length == amounts.length, "StakingERC1155: _ids and amounts length mismatch");
1966         uint256 amountSum = 0;
1967         EnumerableMap.UintToUintMap storage erc1155Entities = _erc1155Pools[pId][_msgSender()];
1968 
1969         for (uint256 index = 0; index < erc1155Ids.length; ++index) {
1970             uint256 id = erc1155Ids[index];
1971             uint256 amount = amounts[index];
1972 
1973             uint256 count = erc1155Entities.get(id);
1974             uint256 rest = count.sub(amount);
1975             if (rest > 0) erc1155Entities.set(id, rest);
1976             else erc1155Entities.remove(id);
1977             amountSum = amountSum.add(amount);
1978         }
1979 
1980         _withdraw(pId, amountSum);
1981         IERC1155 tokenProdiver = IERC1155(poolInfo[pId].tokenAddress); // get token provider by id
1982         tokenProdiver.safeBatchTransferFrom(address(this), _msgSender(), erc1155Ids, amounts, "");
1983         emit WithdrawERC1155(_msgSender(), pId, erc1155Ids, amounts);
1984     }
1985 
1986     /**
1987      * @dev withdraw all staked erc1155 tokens in emergency, without tansfer pending tokens
1988      */
1989     function emergencyWithdrawERC1155(uint256 pId) public onEmergency validAsERC1155PId(pId) {
1990         (uint256[] memory erc1155Ids, uint256[] memory amounts) = pledgedERC1155(pId, _msgSender());
1991         _emergencyWithdraw(pId);
1992         IERC1155 tokenProdiver = IERC1155(poolInfo[pId].tokenAddress); // get token provider by id
1993         tokenProdiver.safeBatchTransferFrom(address(this), _msgSender(), erc1155Ids, amounts, "");
1994     }
1995 
1996     /**
1997      * @dev get user pledgedERC1155 tokens for all pools
1998      */
1999     function pledgedERC1155(uint256 pId, address user) public view validAsERC1155PId(pId) returns (uint256[] memory erc1155Ids, uint256[] memory amounts) {
2000         EnumerableMap.UintToUintMap storage erc1155Entities = _erc1155Pools[pId][user];
2001         uint256 count = erc1155Entities.length();
2002         erc1155Ids = new uint256[](count);
2003         amounts = new uint256[](count);
2004         for (uint256 index = 0; index < count; ++index) (erc1155Ids[index], amounts[index]) = erc1155Entities.at(index);
2005     }
2006 
2007     /**
2008      * @dev get all ERC1155 token pool ids
2009      */
2010     function listERC1155PoolIds() public view returns (uint256[] memory poolIds) {
2011         poolIds = new uint256[](_erc1155PoolIdSet.length());
2012         for (uint256 index = 0; index < poolIds.length; ++index) poolIds[index] = _erc1155PoolIdSet.at(index);
2013     }
2014 
2015     /**
2016      * @dev valid a pool id is belonged to erc 20 pool
2017      */
2018     modifier validAsERC1155PId(uint256 pId) {
2019         require(_erc1155PoolIdSet.contains(pId), "StakingERC1155: pool id not belong to defi ERC1155");
2020         _;
2021     }
2022 }
2023 
2024 
2025 /**
2026  * @dev Required interface of an ERC721 compliant contract.
2027  */
2028 interface IERC721 is IERC165 {
2029     /**
2030      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2031      */
2032     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2033 
2034     /**
2035      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2036      */
2037     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2038 
2039     /**
2040      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2041      */
2042     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2043 
2044     /**
2045      * @dev Returns the number of tokens in ``owner``'s account.
2046      */
2047     function balanceOf(address owner) external view returns (uint256 balance);
2048 
2049     /**
2050      * @dev Returns the owner of the `tokenId` token.
2051      *
2052      * Requirements:
2053      *
2054      * - `tokenId` must exist.
2055      */
2056     function ownerOf(uint256 tokenId) external view returns (address owner);
2057 
2058     /**
2059      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2060      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2061      *
2062      * Requirements:
2063      *
2064      * - `from` cannot be the zero address.
2065      * - `to` cannot be the zero address.
2066      * - `tokenId` token must exist and be owned by `from`.
2067      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2069      *
2070      * Emits a {Transfer} event.
2071      */
2072     function safeTransferFrom(address from, address to, uint256 tokenId) external;
2073 
2074     /**
2075      * @dev Transfers `tokenId` token from `from` to `to`.
2076      *
2077      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2078      *
2079      * Requirements:
2080      *
2081      * - `from` cannot be the zero address.
2082      * - `to` cannot be the zero address.
2083      * - `tokenId` token must be owned by `from`.
2084      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2085      *
2086      * Emits a {Transfer} event.
2087      */
2088     function transferFrom(address from, address to, uint256 tokenId) external;
2089 
2090     /**
2091      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2092      * The approval is cleared when the token is transferred.
2093      *
2094      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2095      *
2096      * Requirements:
2097      *
2098      * - The caller must own the token or be an approved operator.
2099      * - `tokenId` must exist.
2100      *
2101      * Emits an {Approval} event.
2102      */
2103     function approve(address to, uint256 tokenId) external;
2104 
2105     /**
2106      * @dev Returns the account approved for `tokenId` token.
2107      *
2108      * Requirements:
2109      *
2110      * - `tokenId` must exist.
2111      */
2112     function getApproved(uint256 tokenId) external view returns (address operator);
2113 
2114     /**
2115      * @dev Approve or remove `operator` as an operator for the caller.
2116      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2117      *
2118      * Requirements:
2119      *
2120      * - The `operator` cannot be the caller.
2121      *
2122      * Emits an {ApprovalForAll} event.
2123      */
2124     function setApprovalForAll(address operator, bool _approved) external;
2125 
2126     /**
2127      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2128      *
2129      * See {setApprovalForAll}
2130      */
2131     function isApprovedForAll(address owner, address operator) external view returns (bool);
2132 
2133     /**
2134       * @dev Safely transfers `tokenId` token from `from` to `to`.
2135       *
2136       * Requirements:
2137       *
2138       * - `from` cannot be the zero address.
2139       * - `to` cannot be the zero address.
2140       * - `tokenId` token must exist and be owned by `from`.
2141       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2142       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2143       *
2144       * Emits a {Transfer} event.
2145       */
2146     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
2147 }
2148 
2149 
2150 /**
2151  * @title ERC721 token receiver interface
2152  * @dev Interface for any contract that wants to support safeTransfers
2153  * from ERC721 asset contracts.
2154  */
2155 interface IERC721Receiver {
2156     /**
2157      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2158      * by `operator` from `from`, this function is called.
2159      *
2160      * It must return its Solidity selector to confirm the token transfer.
2161      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2162      *
2163      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2164      */
2165     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
2166 }
2167 
2168 
2169 /**
2170  * @dev Implementation of the {IERC721Receiver} interface.
2171  *
2172  * Accepts all token transfers.
2173  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
2174  */
2175 contract StakingERC721Receiver is ERC165, IERC721Receiver {
2176     
2177     constructor() internal {
2178         _registerInterface(StakingERC721Receiver(address(0)).onERC721Received.selector);
2179     }
2180 
2181     /**
2182      * @dev See {IERC721Receiver-onERC721Received}.
2183      *
2184      * Always returns `IERC721Receiver.onERC721Received.selector`.
2185      */
2186     function onERC721Received(
2187         address,
2188         address,
2189         uint256,
2190         bytes memory
2191     ) public virtual override returns (bytes4) {
2192         return this.onERC721Received.selector;
2193     }
2194 }
2195 
2196 
2197 abstract contract StakingERC721 is StakingBase, StakingERC721Receiver {
2198     using SafeMath for uint256;
2199     using EnumerableSet for EnumerableSet.UintSet;
2200 
2201     uint256 constant ERC721StakingMax = 5;
2202 
2203     mapping(uint256 => mapping(address => EnumerableSet.UintSet)) private erc721Pools;
2204     EnumerableSet.UintSet private erc721PoolIdSet;
2205 
2206     event DepositERC721(address indexed user, uint256 indexed pid, uint256 indexed erc721Id);
2207     event WithdrawERC721(address indexed user, uint256 indexed pid, uint256 indexed erc721Id);
2208 
2209     constructor() internal {}
2210 
2211     // Add a new erc721 token to the pool. Can only be called by the owner.
2212     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2213     function addERC721Pool(uint256 _allocPoint, address _721TokenAddr) public onlyAdmin {
2214         uint256 pId = _add(_allocPoint, _721TokenAddr);
2215         erc721PoolIdSet.add(pId);
2216     }
2217 
2218     // Deposit ERC721s to MasterChef for XIAONAN allocation.
2219     function depositERC721(uint256 pId, uint256 erc721Id) public validAsERC721PId(pId) {
2220         EnumerableSet.UintSet storage erc721Entities = erc721Pools[pId][_msgSender()];
2221         require(erc721Entities.add(erc721Id), "StakingERC721: erc721 token already deposited");
2222         require(_deposit(pId, 1) <= ERC721StakingMax, "StakingERC721: NFT staking count exceed its maximun");
2223         IERC721 tokenProdiver = IERC721(poolInfo[pId].tokenAddress);
2224         tokenProdiver.safeTransferFrom(_msgSender(), address(this), erc721Id);
2225         emit DepositERC721(_msgSender(), pId, erc721Id);
2226     }
2227 
2228     // Withdraw ERC721s from MasterChef.
2229     function withdrawERC721(uint256 pId, uint256 erc721Id) public validAsERC721PId(pId) {
2230         EnumerableSet.UintSet storage erc721Entities = erc721Pools[pId][_msgSender()];
2231         require(erc721Entities.remove(erc721Id), "StakingERC721: erc721 token not existe");
2232         _withdraw(pId, 1);
2233         IERC721 tokenProdiver = IERC721(poolInfo[pId].tokenAddress);
2234         tokenProdiver.safeTransferFrom(address(this), _msgSender(), erc721Id);
2235         emit WithdrawERC721(_msgSender(), pId, erc721Id);
2236     }
2237  
2238     /**
2239      * @dev withdraw all staked erc1155 tokens in emergency, without tansfer pending tokens
2240      */
2241     function emergencyWithdrawERC721(uint256 pId) public onEmergency validAsERC721PId(pId) {
2242         uint256[] memory erc721Ids = pledgedERC721(pId, _msgSender());
2243         _emergencyWithdraw(pId);
2244         IERC721 tokenProdiver = IERC721(poolInfo[pId].tokenAddress); // get token provider by id
2245         for (uint256 index = 0; index < erc721Ids.length; ++index)
2246             tokenProdiver.safeTransferFrom(address(this), _msgSender(), erc721Ids[index]);
2247     }
2248 
2249     function pledgedERC721(uint256 pId, address _user) public view validAsERC721PId(pId) returns (uint256[] memory erc721Ids) {
2250         EnumerableSet.UintSet storage erc721Entities = erc721Pools[pId][_user];
2251         uint256 count = erc721Entities.length();
2252         erc721Ids = new uint256[](count);
2253         for (uint256 index = 0; index < count; ++index) erc721Ids[index] = erc721Entities.at(index);
2254     }
2255 
2256     function listERC721PoolIds() public view returns (uint256[] memory poolIds) {
2257         poolIds = new uint256[](erc721PoolIdSet.length());
2258         for (uint256 index = 0; index < poolIds.length; ++index) poolIds[index] = erc721PoolIdSet.at(index);
2259     }
2260 
2261     modifier validAsERC721PId(uint256 pId) {
2262         require(erc721PoolIdSet.contains(pId), "StakingERC721: pool id not belong to defi ERC721");
2263         _;
2264     }
2265 }
2266 
2267 
2268 contract StakingYao is Ownable, StakingBase, StakingERC1155, StakingERC721, TimeUtil {
2269     constructor(IERC20 yao_) public StakingBase(yao_) {
2270         prodInit();
2271     } 
2272 
2273     function prodInit() private {
2274         miningBeginBlock = 12527500; //2021/05/29 13:54:19
2275         periodes.push(PeriodeReleases({blockOffset: toBlocks(0 days), tokenPerBlock: calculeTokenPerBlock(60000 ether, 14 days)}));
2276         periodes.push(PeriodeReleases({blockOffset: toBlocks(14 days), tokenPerBlock: calculeTokenPerBlock(25000 ether, 90 days)}));
2277         periodes.push(PeriodeReleases({blockOffset: toBlocks(104 days), tokenPerBlock: calculeTokenPerBlock(10000 ether, 90 days)}));
2278         periodes.push(PeriodeReleases({blockOffset: toBlocks(194 days), tokenPerBlock: calculeTokenPerBlock(3750 ether, 90 days)}));
2279         periodes.push(PeriodeReleases({blockOffset: toBlocks(284 days), tokenPerBlock: calculeTokenPerBlock(1250 ether, 90 days)}));
2280         periodes.push(PeriodeReleases({blockOffset: toBlocks(374 days), tokenPerBlock: 0}));
2281 
2282         updateMiningTotal();
2283     }
2284 
2285     function updateMiningTotal() private {
2286         uint256 sum = 0;
2287         for (uint256 index = 1; index < periodes.length; ++index) {
2288             sum += (periodes[index].blockOffset - periodes[index - 1].blockOffset) * periodes[index - 1].tokenPerBlock;
2289         }
2290         miningTotal = sum;
2291     }
2292 
2293     function calculeTokenPerBlock(uint256 amount, uint256 time) private pure returns (uint256) {
2294         return amount / toBlocks(time);
2295     }
2296 }