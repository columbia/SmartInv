1 //SPDX-License-Identifier: MIT 
2 pragma solidity 0.6.11; 
3 pragma experimental ABIEncoderV2;
4 
5 // ====================================================================
6 //     ________                   _______                           
7 //    / ____/ /__  ____  ____ _  / ____(_)___  ____ _____  ________ 
8 //   / __/ / / _ \/ __ \/ __ `/ / /_  / / __ \/ __ `/ __ \/ ___/ _ \
9 //  / /___/ /  __/ / / / /_/ / / __/ / / / / / /_/ / / / / /__/  __/
10 // /_____/_/\___/_/ /_/\__,_(_)_/   /_/_/ /_/\__,_/_/ /_/\___/\___/                                                                                                                     
11 //                                                                        
12 // ====================================================================
13 // ====================== Elena Protocol (USE) ========================
14 // ====================================================================
15 
16 // Dapp    :  https://elena.finance
17 // Twitter :  https://twitter.com/ElenaProtocol
18 // Telegram:  https://t.me/ElenaFinance
19 // ====================================================================
20 
21 
22 // File: contracts\@openzeppelin\contracts\GSN\Context.sol
23 // License: MIT
24 
25 /*
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with GSN meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address payable) {
37         return msg.sender;
38     }
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 // File: contracts\@openzeppelin\contracts\access\Ownable.sol
46 // License: MIT
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 contract Ownable is Context {
62     address private _owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor () internal {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view returns (address) {
76         return _owner;
77     }
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 // File: contracts\@openzeppelin\contracts\math\SafeMath.sol
108 // License: MIT
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137         return c;
138     }
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165         return c;
166     }
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186         return c;
187     }
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219         return c;
220     }
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 // File: contracts\@openzeppelin\contracts\token\ERC20\IERC20.sol
255 // License: MIT
256 
257 /**
258  * @dev Interface of the ERC20 standard as defined in the EIP.
259  */
260 interface IERC20 {
261     /**
262      * @dev Returns the amount of tokens in existence.
263      */
264     function totalSupply() external view returns (uint256);
265     /**
266      * @dev Returns the amount of tokens owned by `account`.
267      */
268     function balanceOf(address account) external view returns (uint256);
269     /**
270      * @dev Moves `amount` tokens from the caller's account to `recipient`.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transfer(address recipient, uint256 amount) external returns (bool);
277     /**
278      * @dev Returns the remaining number of tokens that `spender` will be
279      * allowed to spend on behalf of `owner` through {transferFrom}. This is
280      * zero by default.
281      *
282      * This value changes when {approve} or {transferFrom} are called.
283      */
284     function allowance(address owner, address spender) external view returns (uint256);
285     /**
286      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * IMPORTANT: Beware that changing an allowance with this method brings the risk
291      * that someone may use both the old and the new allowance by unfortunate
292      * transaction ordering. One possible solution to mitigate this race
293      * condition is to first reduce the spender's allowance to 0 and set the
294      * desired value afterwards:
295      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address spender, uint256 amount) external returns (bool);
300     /**
301      * @dev Moves `amount` tokens from `sender` to `recipient` using the
302      * allowance mechanism. `amount` is then deducted from the caller's
303      * allowance.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317     /**
318      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
319      * a call to {approve}. `value` is the new allowance.
320      */
321     event Approval(address indexed owner, address indexed spender, uint256 value);
322 }
323 
324 // File: contracts\@openzeppelin\contracts\utils\Address.sol
325 // License: MIT
326 
327 /**
328  * @dev Collection of functions related to the address type
329  */
330 library Address {
331     /**
332      * @dev Returns true if `account` is a contract.
333      *
334      * [IMPORTANT]
335      * ====
336      * It is unsafe to assume that an address for which this function returns
337      * false is an externally-owned account (EOA) and not a contract.
338      *
339      * Among others, `isContract` will return false for the following
340      * types of addresses:
341      *
342      *  - an externally-owned account
343      *  - a contract in construction
344      *  - an address where a contract will be created
345      *  - an address where a contract lived, but was destroyed
346      * ====
347      */
348     function isContract(address account) internal view returns (bool) {
349         // This method relies in extcodesize, which returns 0 for contracts in
350         // construction, since the code is only stored at the end of the
351         // constructor execution.
352         uint256 size;
353         // solhint-disable-next-line no-inline-assembly
354         assembly { size := extcodesize(account) }
355         return size > 0;
356     }
357     /**
358      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
359      * `recipient`, forwarding all available gas and reverting on errors.
360      *
361      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
362      * of certain opcodes, possibly making contracts go over the 2300 gas limit
363      * imposed by `transfer`, making them unable to receive funds via
364      * `transfer`. {sendValue} removes this limitation.
365      *
366      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
367      *
368      * IMPORTANT: because control is transferred to `recipient`, care must be
369      * taken to not create reentrancy vulnerabilities. Consider using
370      * {ReentrancyGuard} or the
371      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
372      */
373     function sendValue(address payable recipient, uint256 amount) internal {
374         require(address(this).balance >= amount, "Address: insufficient balance");
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain`call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
407         return _functionCallWithValue(target, data, 0, errorMessage);
408     }
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         return _functionCallWithValue(target, data, value, errorMessage);
432     }
433     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
434         require(isContract(target), "Address: call to non-contract");
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443                 // solhint-disable-next-line no-inline-assembly
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 // File: contracts\@openzeppelin\contracts\token\ERC20\SafeERC20.sol
456 // License: MIT
457 
458 
459 
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473     function safeTransfer(IERC20 token, address to, uint256 value) internal {
474         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
475     }
476     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
477         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
478     }
479     /**
480      * @dev Deprecated. This function has issues similar to the ones found in
481      * {IERC20-approve}, and its usage is discouraged.
482      *
483      * Whenever possible, use {safeIncreaseAllowance} and
484      * {safeDecreaseAllowance} instead.
485      */
486     function safeApprove(IERC20 token, address spender, uint256 value) internal {
487         // safeApprove should only be called when setting an initial allowance,
488         // or when resetting it to zero. To increase and decrease it, use
489         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
490         // solhint-disable-next-line max-line-length
491         require((value == 0) || (token.allowance(address(this), spender) == 0),
492             "SafeERC20: approve from non-zero to non-zero allowance"
493         );
494         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
495     }
496     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
497         uint256 newAllowance = token.allowance(address(this), spender).add(value);
498         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
499     }
500     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
501         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
502         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
503     }
504     /**
505      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
506      * on the return value: the return value is optional (but if data is returned, it must not be false).
507      * @param token The token targeted by the call.
508      * @param data The call data (encoded using abi.encode or one of its variants).
509      */
510     function _callOptionalReturn(IERC20 token, bytes memory data) private {
511         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
512         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
513         // the target address contains contract code and also asserts for success in the low-level call.
514         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
515         if (returndata.length > 0) { // Return data is optional
516             // solhint-disable-next-line max-line-length
517             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
518         }
519     }
520 }
521 
522 // File: contracts\@openzeppelin\contracts\utils\EnumerableSet.sol
523 // License: MIT
524 
525 /**
526  * @dev Library for managing
527  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
528  * types.
529  *
530  * Sets have the following properties:
531  *
532  * - Elements are added, removed, and checked for existence in constant time
533  * (O(1)).
534  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
535  *
536  * ```
537  * contract Example {
538  *     // Add the library methods
539  *     using EnumerableSet for EnumerableSet.AddressSet;
540  *
541  *     // Declare a set state variable
542  *     EnumerableSet.AddressSet private mySet;
543  * }
544  * ```
545  *
546  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
547  * (`UintSet`) are supported.
548  */
549 library EnumerableSet {
550     // To implement this library for multiple types with as little code
551     // repetition as possible, we write it in terms of a generic Set type with
552     // bytes32 values.
553     // The Set implementation uses private functions, and user-facing
554     // implementations (such as AddressSet) are just wrappers around the
555     // underlying Set.
556     // This means that we can only create new EnumerableSets for types that fit
557     // in bytes32.
558     struct Set {
559         // Storage of set values
560         bytes32[] _values;
561         // Position of the value in the `values` array, plus 1 because index 0
562         // means a value is not in the set.
563         mapping (bytes32 => uint256) _indexes;
564     }
565     /**
566      * @dev Add a value to a set. O(1).
567      *
568      * Returns true if the value was added to the set, that is if it was not
569      * already present.
570      */
571     function _add(Set storage set, bytes32 value) private returns (bool) {
572         if (!_contains(set, value)) {
573             set._values.push(value);
574             // The value is stored at length-1, but we add 1 to all indexes
575             // and use 0 as a sentinel value
576             set._indexes[value] = set._values.length;
577             return true;
578         } else {
579             return false;
580         }
581     }
582     /**
583      * @dev Removes a value from a set. O(1).
584      *
585      * Returns true if the value was removed from the set, that is if it was
586      * present.
587      */
588     function _remove(Set storage set, bytes32 value) private returns (bool) {
589         // We read and store the value's index to prevent multiple reads from the same storage slot
590         uint256 valueIndex = set._indexes[value];
591         if (valueIndex != 0) { // Equivalent to contains(set, value)
592             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
593             // the array, and then remove the last element (sometimes called as 'swap and pop').
594             // This modifies the order of the array, as noted in {at}.
595             uint256 toDeleteIndex = valueIndex - 1;
596             uint256 lastIndex = set._values.length - 1;
597             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
598             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
599             bytes32 lastvalue = set._values[lastIndex];
600             // Move the last value to the index where the value to delete is
601             set._values[toDeleteIndex] = lastvalue;
602             // Update the index for the moved value
603             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
604             // Delete the slot where the moved value was stored
605             set._values.pop();
606             // Delete the index for the deleted slot
607             delete set._indexes[value];
608             return true;
609         } else {
610             return false;
611         }
612     }
613     /**
614      * @dev Returns true if the value is in the set. O(1).
615      */
616     function _contains(Set storage set, bytes32 value) private view returns (bool) {
617         return set._indexes[value] != 0;
618     }
619     /**
620      * @dev Returns the number of values on the set. O(1).
621      */
622     function _length(Set storage set) private view returns (uint256) {
623         return set._values.length;
624     }
625    /**
626     * @dev Returns the value stored at position `index` in the set. O(1).
627     *
628     * Note that there are no guarantees on the ordering of values inside the
629     * array, and it may change when more values are added or removed.
630     *
631     * Requirements:
632     *
633     * - `index` must be strictly less than {length}.
634     */
635     function _at(Set storage set, uint256 index) private view returns (bytes32) {
636         require(set._values.length > index, "EnumerableSet: index out of bounds");
637         return set._values[index];
638     }
639     // AddressSet
640     struct AddressSet {
641         Set _inner;
642     }
643     /**
644      * @dev Add a value to a set. O(1).
645      *
646      * Returns true if the value was added to the set, that is if it was not
647      * already present.
648      */
649     function add(AddressSet storage set, address value) internal returns (bool) {
650         return _add(set._inner, bytes32(uint256(value)));
651     }
652     /**
653      * @dev Removes a value from a set. O(1).
654      *
655      * Returns true if the value was removed from the set, that is if it was
656      * present.
657      */
658     function remove(AddressSet storage set, address value) internal returns (bool) {
659         return _remove(set._inner, bytes32(uint256(value)));
660     }
661     /**
662      * @dev Returns true if the value is in the set. O(1).
663      */
664     function contains(AddressSet storage set, address value) internal view returns (bool) {
665         return _contains(set._inner, bytes32(uint256(value)));
666     }
667     /**
668      * @dev Returns the number of values in the set. O(1).
669      */
670     function length(AddressSet storage set) internal view returns (uint256) {
671         return _length(set._inner);
672     }
673    /**
674     * @dev Returns the value stored at position `index` in the set. O(1).
675     *
676     * Note that there are no guarantees on the ordering of values inside the
677     * array, and it may change when more values are added or removed.
678     *
679     * Requirements:
680     *
681     * - `index` must be strictly less than {length}.
682     */
683     function at(AddressSet storage set, uint256 index) internal view returns (address) {
684         return address(uint256(_at(set._inner, index)));
685     }
686     // UintSet
687     struct UintSet {
688         Set _inner;
689     }
690     /**
691      * @dev Add a value to a set. O(1).
692      *
693      * Returns true if the value was added to the set, that is if it was not
694      * already present.
695      */
696     function add(UintSet storage set, uint256 value) internal returns (bool) {
697         return _add(set._inner, bytes32(value));
698     }
699     /**
700      * @dev Removes a value from a set. O(1).
701      *
702      * Returns true if the value was removed from the set, that is if it was
703      * present.
704      */
705     function remove(UintSet storage set, uint256 value) internal returns (bool) {
706         return _remove(set._inner, bytes32(value));
707     }
708     /**
709      * @dev Returns true if the value is in the set. O(1).
710      */
711     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
712         return _contains(set._inner, bytes32(value));
713     }
714     /**
715      * @dev Returns the number of values on the set. O(1).
716      */
717     function length(UintSet storage set) internal view returns (uint256) {
718         return _length(set._inner);
719     }
720    /**
721     * @dev Returns the value stored at position `index` in the set. O(1).
722     *
723     * Note that there are no guarantees on the ordering of values inside the
724     * array, and it may change when more values are added or removed.
725     *
726     * Requirements:
727     *
728     * - `index` must be strictly less than {length}.
729     */
730     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
731         return uint256(_at(set._inner, index));
732     }
733 }
734 
735 // File: contracts\@openzeppelin\contracts\access\AccessControl.sol
736 // License: MIT
737 
738 
739 
740 
741 /**
742  * @dev Contract module that allows children to implement role-based access
743  * control mechanisms.
744  *
745  * Roles are referred to by their `bytes32` identifier. These should be exposed
746  * in the external API and be unique. The best way to achieve this is by
747  * using `public constant` hash digests:
748  *
749  * ```
750  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
751  * ```
752  *
753  * Roles can be used to represent a set of permissions. To restrict access to a
754  * function call, use {hasRole}:
755  *
756  * ```
757  * function foo() public {
758  *     require(hasRole(MY_ROLE, msg.sender));
759  *     ...
760  * }
761  * ```
762  *
763  * Roles can be granted and revoked dynamically via the {grantRole} and
764  * {revokeRole} functions. Each role has an associated admin role, and only
765  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
766  *
767  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
768  * that only accounts with this role will be able to grant or revoke other
769  * roles. More complex role relationships can be created by using
770  * {_setRoleAdmin}.
771  *
772  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
773  * grant and revoke this role. Extra precautions should be taken to secure
774  * accounts that have been granted it.
775  */
776 abstract contract AccessControl is Context {
777     using EnumerableSet for EnumerableSet.AddressSet;
778     using Address for address;
779     struct RoleData {
780         EnumerableSet.AddressSet members;
781         bytes32 adminRole;
782     }
783     mapping (bytes32 => RoleData) private _roles;
784     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
785     /**
786      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
787      *
788      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
789      * {RoleAdminChanged} not being emitted signaling this.
790      *
791      * _Available since v3.1._
792      */
793     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
794     /**
795      * @dev Emitted when `account` is granted `role`.
796      *
797      * `sender` is the account that originated the contract call, an admin role
798      * bearer except when using {_setupRole}.
799      */
800     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
801     /**
802      * @dev Emitted when `account` is revoked `role`.
803      *
804      * `sender` is the account that originated the contract call:
805      *   - if using `revokeRole`, it is the admin role bearer
806      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
807      */
808     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
809     /**
810      * @dev Returns `true` if `account` has been granted `role`.
811      */
812     function hasRole(bytes32 role, address account) public view returns (bool) {
813         return _roles[role].members.contains(account);
814     }
815     /**
816      * @dev Returns the number of accounts that have `role`. Can be used
817      * together with {getRoleMember} to enumerate all bearers of a role.
818      */
819     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
820         return _roles[role].members.length();
821     }
822     /**
823      * @dev Returns one of the accounts that have `role`. `index` must be a
824      * value between 0 and {getRoleMemberCount}, non-inclusive.
825      *
826      * Role bearers are not sorted in any particular way, and their ordering may
827      * change at any point.
828      *
829      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
830      * you perform all queries on the same block. See the following
831      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
832      * for more information.
833      */
834     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
835         return _roles[role].members.at(index);
836     }
837     /**
838      * @dev Returns the admin role that controls `role`. See {grantRole} and
839      * {revokeRole}.
840      *
841      * To change a role's admin, use {_setRoleAdmin}.
842      */
843     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
844         return _roles[role].adminRole;
845     }
846     /**
847      * @dev Grants `role` to `account`.
848      *
849      * If `account` had not been already granted `role`, emits a {RoleGranted}
850      * event.
851      *
852      * Requirements:
853      *
854      * - the caller must have ``role``'s admin role.
855      */
856     function grantRole(bytes32 role, address account) public virtual {
857         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
858         _grantRole(role, account);
859     }
860     /**
861      * @dev Revokes `role` from `account`.
862      *
863      * If `account` had been granted `role`, emits a {RoleRevoked} event.
864      *
865      * Requirements:
866      *
867      * - the caller must have ``role``'s admin role.
868      */
869     function revokeRole(bytes32 role, address account) public virtual {
870         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
871         _revokeRole(role, account);
872     }
873     /**
874      * @dev Revokes `role` from the calling account.
875      *
876      * Roles are often managed via {grantRole} and {revokeRole}: this function's
877      * purpose is to provide a mechanism for accounts to lose their privileges
878      * if they are compromised (such as when a trusted device is misplaced).
879      *
880      * If the calling account had been granted `role`, emits a {RoleRevoked}
881      * event.
882      *
883      * Requirements:
884      *
885      * - the caller must be `account`.
886      */
887     function renounceRole(bytes32 role, address account) public virtual {
888         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
889         _revokeRole(role, account);
890     }
891     /**
892      * @dev Grants `role` to `account`.
893      *
894      * If `account` had not been already granted `role`, emits a {RoleGranted}
895      * event. Note that unlike {grantRole}, this function doesn't perform any
896      * checks on the calling account.
897      *
898      * [WARNING]
899      * ====
900      * This function should only be called from the constructor when setting
901      * up the initial roles for the system.
902      *
903      * Using this function in any other way is effectively circumventing the admin
904      * system imposed by {AccessControl}.
905      * ====
906      */
907     function _setupRole(bytes32 role, address account) internal virtual {
908         _grantRole(role, account);
909     }
910     /**
911      * @dev Sets `adminRole` as ``role``'s admin role.
912      *
913      * Emits a {RoleAdminChanged} event.
914      */
915     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
916         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
917         _roles[role].adminRole = adminRole;
918     }
919     function _grantRole(bytes32 role, address account) private {
920         if (_roles[role].members.add(account)) {
921             emit RoleGranted(role, account, _msgSender());
922         }
923     }
924     function _revokeRole(bytes32 role, address account) private {
925         if (_roles[role].members.remove(account)) {
926             emit RoleRevoked(role, account, _msgSender());
927         }
928     }
929 }
930 
931 // File: contracts\Share\IShareToken.sol
932 // License: MIT
933 
934 
935 
936 interface IShareToken is IERC20 {  
937     function pool_mint(address m_address, uint256 m_amount) external; 
938     function pool_burn_from(address b_address, uint256 b_amount) external; 
939     function burn(uint256 amount) external;
940 }
941 
942 // File: contracts\Oracle\IUniswapPairOracle.sol
943 // License: MIT
944 
945 // Fixed window oracle that recomputes the average price for the entire period once every period
946 // Note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
947 interface IUniswapPairOracle { 
948     function getPairToken(address token) external view returns(address);
949     function containsToken(address token) external view returns(bool);
950     function getSwapTokenReserve(address token) external view returns(uint256);
951     function update() external returns(bool);
952     // Note this will always return 0 before update has been called successfully for the first time.
953     function consult(address token, uint amountIn) external view returns (uint amountOut);
954 }
955 
956 // File: contracts\USE\IUSEStablecoin.sol
957 // License: MIT
958 
959 
960 interface IUSEStablecoin {
961     function totalSupply() external view returns (uint256);
962     function balanceOf(address account) external view returns (uint256);
963     function transfer(address recipient, uint256 amount) external returns (bool);
964     function allowance(address owner, address spender) external view returns (uint256);
965     function approve(address spender, uint256 amount) external returns (bool);
966     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
967     function owner_address() external returns (address);
968     function creator_address() external returns (address);
969     function timelock_address() external returns (address); 
970     function genesis_supply() external returns (uint256); 
971     function refresh_cooldown() external returns (uint256);
972     function price_target() external returns (uint256);
973     function price_band() external returns (uint256);
974     function DEFAULT_ADMIN_ADDRESS() external returns (address);
975     function COLLATERAL_RATIO_PAUSER() external returns (bytes32);
976     function collateral_ratio_paused() external returns (bool);
977     function last_call_time() external returns (uint256);
978     function USEDAIOracle() external returns (IUniswapPairOracle);
979     function USESharesOracle() external returns (IUniswapPairOracle); 
980     /* ========== VIEWS ========== */
981     function use_pools(address a) external view returns (bool);
982     function global_collateral_ratio() external view returns (uint256);
983     function use_price() external view returns (uint256);
984     function share_price()  external view returns (uint256);
985     function share_price_in_use()  external view returns (uint256); 
986     function globalCollateralValue() external view returns (uint256);
987     /* ========== PUBLIC FUNCTIONS ========== */
988     function refreshCollateralRatio() external;
989     function swapCollateralAmount() external view returns(uint256);
990     function pool_mint(address m_address, uint256 m_amount) external;
991     function pool_burn_from(address b_address, uint256 b_amount) external;
992     function burn(uint256 amount) external;
993 }
994 
995 // File: contracts\USE\Pools\IUSEPool.sol
996 // License: MIT
997 
998 interface IUSEPool { 
999     function collatDollarBalance() external view returns (uint256); 
1000 }
1001 
1002 // File: contracts\Uniswap\Interfaces\IUniswapV2Pair.sol
1003 // License: MIT
1004 
1005 interface IUniswapV2Pair {
1006     event Approval(address indexed owner, address indexed spender, uint value);
1007     event Transfer(address indexed from, address indexed to, uint value);
1008     function name() external pure returns (string memory);
1009     function symbol() external pure returns (string memory);
1010     function decimals() external pure returns (uint8);
1011     function totalSupply() external view returns (uint);
1012     function balanceOf(address owner) external view returns (uint);
1013     function allowance(address owner, address spender) external view returns (uint);
1014     function approve(address spender, uint value) external returns (bool);
1015     function transfer(address to, uint value) external returns (bool);
1016     function transferFrom(address from, address to, uint value) external returns (bool);
1017     function DOMAIN_SEPARATOR() external view returns (bytes32);
1018     function PERMIT_TYPEHASH() external pure returns (bytes32);
1019     function nonces(address owner) external view returns (uint);
1020     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1021     event Mint(address indexed sender, uint amount0, uint amount1);
1022     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1023     event Swap(
1024         address indexed sender,
1025         uint amount0In,
1026         uint amount1In,
1027         uint amount0Out,
1028         uint amount1Out,
1029         address indexed to
1030     );
1031     event Sync(uint112 reserve0, uint112 reserve1);
1032     function MINIMUM_LIQUIDITY() external pure returns (uint);
1033     function factory() external view returns (address);
1034     function token0() external view returns (address);
1035     function token1() external view returns (address);
1036     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1037     function price0CumulativeLast() external view returns (uint);
1038     function price1CumulativeLast() external view returns (uint);
1039     function kLast() external view returns (uint);
1040     function mint(address to) external returns (uint liquidity);
1041     function burn(address to) external returns (uint amount0, uint amount1);
1042     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1043     function skim(address to) external;
1044     function sync() external;
1045     function initialize(address, address) external;
1046 }
1047 
1048 // File: contracts\Uniswap\Interfaces\IUniswapV2Factory.sol
1049 // License: MIT
1050 
1051 interface IUniswapV2Factory {
1052     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1053     function feeTo() external view returns (address);
1054     function feeToSetter() external view returns (address);
1055     function getPair(address tokenA, address tokenB) external view returns (address pair);
1056     function allPairs(uint) external view returns (address pair);
1057     function allPairsLength() external view returns (uint);
1058     function createPair(address tokenA, address tokenB) external returns (address pair);
1059     function setFeeTo(address) external;
1060     function setFeeToSetter(address) external;
1061 }
1062 
1063 // File: contracts\Uniswap\Interfaces\IUniswapV2Router01.sol
1064 // License: MIT
1065 
1066 interface IUniswapV2Router01 {
1067     function factory() external pure returns (address);
1068     function WETH() external pure returns (address);
1069     function addLiquidity(
1070         address tokenA,
1071         address tokenB,
1072         uint amountADesired,
1073         uint amountBDesired,
1074         uint amountAMin,
1075         uint amountBMin,
1076         address to,
1077         uint deadline
1078     ) external returns (uint amountA, uint amountB, uint liquidity);
1079     function addLiquidityETH(
1080         address token,
1081         uint amountTokenDesired,
1082         uint amountTokenMin,
1083         uint amountETHMin,
1084         address to,
1085         uint deadline
1086     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1087     function removeLiquidity(
1088         address tokenA,
1089         address tokenB,
1090         uint liquidity,
1091         uint amountAMin,
1092         uint amountBMin,
1093         address to,
1094         uint deadline
1095     ) external returns (uint amountA, uint amountB);
1096     function removeLiquidityETH(
1097         address token,
1098         uint liquidity,
1099         uint amountTokenMin,
1100         uint amountETHMin,
1101         address to,
1102         uint deadline
1103     ) external returns (uint amountToken, uint amountETH);
1104     function removeLiquidityWithPermit(
1105         address tokenA,
1106         address tokenB,
1107         uint liquidity,
1108         uint amountAMin,
1109         uint amountBMin,
1110         address to,
1111         uint deadline,
1112         bool approveMax, uint8 v, bytes32 r, bytes32 s
1113     ) external returns (uint amountA, uint amountB);
1114     function removeLiquidityETHWithPermit(
1115         address token,
1116         uint liquidity,
1117         uint amountTokenMin,
1118         uint amountETHMin,
1119         address to,
1120         uint deadline,
1121         bool approveMax, uint8 v, bytes32 r, bytes32 s
1122     ) external returns (uint amountToken, uint amountETH);
1123     function swapExactTokensForTokens(
1124         uint amountIn,
1125         uint amountOutMin,
1126         address[] calldata path,
1127         address to,
1128         uint deadline
1129     ) external returns (uint[] memory amounts);
1130     function swapTokensForExactTokens(
1131         uint amountOut,
1132         uint amountInMax,
1133         address[] calldata path,
1134         address to,
1135         uint deadline
1136     ) external returns (uint[] memory amounts);
1137     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1138         external
1139         payable
1140         returns (uint[] memory amounts);
1141     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1142         external
1143         returns (uint[] memory amounts);
1144     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1145         external
1146         returns (uint[] memory amounts);
1147     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1148         external
1149         payable
1150         returns (uint[] memory amounts);
1151     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1152     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1153     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1154     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1155     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1156 }
1157 
1158 // File: contracts\Comptroller\ProtocolValue.sol
1159 //License: MIT
1160 
1161 
1162 abstract contract ProtocolValue  { 
1163     using SafeMath for uint256;
1164     using SafeERC20 for IERC20;
1165     uint256 public constant PERCENT = 1e6;  
1166     struct PCVInfo{
1167         //remove 
1168         uint256 targetTokenRemoved;
1169         uint256 otherTokenRemoved;
1170         uint256 liquidityRemoved;
1171         //swap
1172         uint256 otherTokenIn;
1173         uint256 targetTokenOut;
1174         //add
1175         uint256 targetTokenAdded;
1176         uint256 otherTokenAdded;
1177         uint256 liquidityAdded; 
1178         //remain
1179         uint256 targetTokenRemain;       
1180     }
1181     event PCVResult(address targetToken,address otherToken,uint256 lpp,uint256 cp,PCVInfo pcv);
1182     function _getPair(address router,address token0,address token1) internal view returns(address){
1183         address _factory =  IUniswapV2Router01(router).factory();
1184         return IUniswapV2Factory(_factory).getPair(token0,token1);
1185     }
1186     function _checkOrApproveRouter(address _router,address _token,uint256 _amount) internal{
1187         if(IERC20(_token).allowance(address(this),_router) < _amount){
1188             IERC20(_token).safeApprove(_router,0);
1189             IERC20(_token).safeApprove(_router,uint256(-1));
1190         }        
1191     }
1192     function _swapToken(address router,address tokenIn,address tokenOut,uint256 amountIn) internal returns (uint256){
1193         address[] memory path = new address[](2);
1194         path[0] = tokenIn;
1195         path[1] = tokenOut; 
1196         uint256 exptime = block.timestamp+60;
1197         _checkOrApproveRouter(router,tokenIn,amountIn); 
1198         return IUniswapV2Router01(router).swapExactTokensForTokens(amountIn,0,path,address(this),exptime)[1];
1199     }
1200     function _addLiquidity(
1201         address router,
1202         address tokenA,
1203         address tokenB,
1204         uint amountADesired,
1205         uint amountBDesired,
1206         uint amountAMin,
1207         uint amountBMin
1208     ) internal returns (uint amountA, uint amountB, uint liquidity){
1209          uint256 exptime = block.timestamp+60;
1210         _checkOrApproveRouter(router,tokenA,amountADesired);
1211         _checkOrApproveRouter(router,tokenB,amountBDesired);
1212         return IUniswapV2Router01(router).addLiquidity(tokenA,tokenB,amountADesired,amountBDesired,amountAMin,amountBMin,address(this), exptime);
1213     }
1214     function _removeLiquidity(
1215         address router,
1216         address pair,
1217         address tokenA,
1218         address tokenB,
1219         uint256 lpp 
1220     ) internal returns (uint amountA, uint amountB,uint256 liquidity){
1221         uint256 exptime = block.timestamp+60;
1222         liquidity = IERC20(pair).balanceOf(address(this)).mul(lpp).div(PERCENT);
1223         _checkOrApproveRouter(router,pair,liquidity);
1224         (amountA, amountB) = IUniswapV2Router01(router).removeLiquidity(tokenA,tokenB,liquidity,0,0,address(this),exptime);
1225     }
1226     function getOtherToken(address _pair,address _targetToken) public view returns(address){
1227         address token0 = IUniswapV2Pair(_pair).token0();
1228         address token1 = IUniswapV2Pair(_pair).token1(); 
1229         require(token0 == _targetToken || token1 == _targetToken,"!_targetToken");
1230         return _targetToken == token0 ? token1 : token0;
1231     } 
1232     function _protocolValue(address _router,address _pair,address _targetToken,uint256 _lpp,uint256 _cp) internal returns(uint256){
1233         //only guard _targetToken 
1234         address otherToken = getOtherToken(_pair,_targetToken); 
1235         PCVInfo memory pcv =  PCVInfo(0,0,0,0,0,0,0,0,0);
1236         //removeLiquidity 
1237         (pcv.targetTokenRemoved,pcv.otherTokenRemoved,pcv.liquidityRemoved) = _removeLiquidity(_router,_pair,_targetToken,otherToken,_lpp);
1238         //swap _targetToken
1239         pcv.otherTokenIn = pcv.otherTokenRemoved.mul(_cp).div(PERCENT);
1240         pcv.targetTokenOut = _swapToken(_router,otherToken,_targetToken,pcv.otherTokenIn);
1241         //addLiquidity
1242         uint256 otherTokenRemain  = (pcv.otherTokenRemoved).sub((pcv.otherTokenIn));
1243         uint256 targetTokenAmount = (pcv.targetTokenRemoved).add(pcv.targetTokenOut);        
1244         (pcv.targetTokenAdded, pcv.otherTokenAdded, pcv.liquidityAdded) = _addLiquidity(_router,
1245                                                                                         _targetToken,otherToken,
1246                                                                                         targetTokenAmount,otherTokenRemain,
1247                                                                                         0,otherTokenRemain);
1248         pcv.targetTokenRemain = targetTokenAmount.sub(pcv.targetTokenAdded);
1249         emit PCVResult(_targetToken,otherToken,_lpp,_cp,pcv);
1250         return pcv.targetTokenRemain;  
1251     }
1252 }
1253 
1254 // File: contracts\Comptroller\USEMasterChefPool.sol
1255 // License: MIT
1256 
1257 // MasterChef is the master of rewardToken. He can make rewardToken and he is a fair guy.
1258 //
1259 // Note that it's ownable and the owner wields tremendous power. The ownership
1260 // will be transferred to a governance smart contract once rewardToken is sufficiently
1261 // distributed and the community can show to govern itself.
1262 //
1263 // Have fun reading it. Hopefully it's bug-free. God bless.
1264 contract USEMasterChefPool is IUSEPool,AccessControl,ProtocolValue {
1265     using SafeMath for uint256;
1266     using SafeERC20 for IERC20;
1267     // Info of each user.
1268     struct UserInfo {
1269         uint256 amount; // How many LP tokens the user has provided.
1270         uint256 rewardDebt; // Reward debt. See explanation below.
1271         //
1272         // We do some fancy math here. Basically, any point in time, the amount of rewardTokens
1273         // entitled to a user but is pending to be distributed is:
1274         //
1275         //   pending reward = (user.amount * pool.accrewardTokenPerShare) - user.rewardDebt
1276         //
1277         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1278         //   1. The pool's `accrewardTokenPerShare` (and `lastRewardBlock`) gets updated.
1279         //   2. User receives the pending reward sent to his/her address.
1280         //   3. User's `amount` gets updated.
1281         //   4. User's `rewardDebt` gets updated.
1282     }
1283     // Info of each pool.
1284     struct PoolInfo {
1285         IERC20 lpToken; // Address of LP token contract.
1286         uint256 allocPoint; // How many allocation points assigned to this pool. rewardTokens to distribute per block.
1287         uint256 lastRewardBlock; // Last block number that rewardTokens distribution occurs.
1288         uint256 accrewardTokenPerShare; // Accumulated rewardTokens per share, times 1e12. See below.
1289     }
1290     uint256 public constant PRECISION = 1e6;
1291     bytes32 public constant COMMUNITY_MASTER = keccak256("COMMUNITY_MASTER");
1292     bytes32 public constant COMMUNITY_MASTER_PCV = keccak256("COMMUNITY_MASTER_PCV");
1293     // The rewardToken TOKEN!
1294     IShareToken public rewardToken;
1295     address public swapRouter;
1296     // Dev address.
1297     address public communityaddr;
1298     uint256 public communityRateAmount; 
1299     // rewardToken tokens created per block.
1300     uint256 public rewardTokenPerBlock; 
1301     // Info of each pool.
1302     PoolInfo[] public poolInfo;
1303     // Info of each user that stakes LP tokens.
1304     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1305     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1306     uint256 public totalAllocPoint = 0;
1307     // The block number when rewardToken mining starts.
1308     uint256 public startBlock;
1309     uint256 public miningEndBlock;
1310     event Deposit(address indexed user, uint256 indexed pid, uint256 amount,uint256 rewardToken);
1311     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount,uint256 rewardToken);
1312     event EmergencyWithdraw(
1313         address indexed user,
1314         uint256 indexed pid,
1315         uint256 amount
1316     );
1317     constructor(
1318         address _rewardToken,
1319         address _communityaddr,
1320         address _swapRouter,
1321         uint256 _rewardTokenPerBlock,
1322         uint256 _startBlock,
1323         uint256 _miningEndBlock
1324     ) public {
1325         rewardToken =IShareToken(_rewardToken);
1326         communityaddr = _communityaddr;
1327         swapRouter = _swapRouter;
1328         rewardTokenPerBlock = _rewardTokenPerBlock; 
1329         startBlock = _startBlock;
1330         miningEndBlock = _miningEndBlock;
1331         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1332         grantRole(COMMUNITY_MASTER, _communityaddr);
1333         grantRole(COMMUNITY_MASTER_PCV, _communityaddr);        
1334     }
1335     modifier onlyAdmin(){
1336          require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
1337          _;
1338     }
1339     modifier onlyPCVMaster(){
1340          require(hasRole(COMMUNITY_MASTER_PCV, msg.sender));
1341          _;
1342     }
1343     function collatDollarBalance() external view override returns (uint256){
1344          return 0;
1345      }
1346     function poolLength() external view returns (uint256) {
1347         return poolInfo.length;
1348     }
1349     // Add a new lp to the pool. Can only be called by the owner.
1350     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1351     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyAdmin {
1352         if (_withUpdate) {
1353             massUpdatePools();
1354         }
1355         uint256 lastRewardBlock =  block.number > startBlock ? block.number : startBlock;
1356         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1357         poolInfo.push(
1358             PoolInfo({
1359                 lpToken: _lpToken,
1360                 allocPoint: _allocPoint,
1361                 lastRewardBlock: lastRewardBlock,
1362                 accrewardTokenPerShare: 0
1363             })
1364         );
1365     }
1366     // Update the given pool's rewardToken allocation point. Can only be called by the owner.
1367     function set(uint256 _pid,uint256 _allocPoint, bool _withUpdate) public onlyAdmin {
1368         if (_withUpdate) {
1369             massUpdatePools();
1370         }
1371         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1372             _allocPoint
1373         );
1374         poolInfo[_pid].allocPoint = _allocPoint;
1375     }
1376     // Return reward multiplier over the given _from to _to block.
1377     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256){
1378         return _to.sub(_from);
1379     }
1380     // View function to see pending rewardTokens on frontend.
1381     function pendingrewardToken(uint256 _pid, address _user)external view returns (uint256){
1382         PoolInfo storage pool = poolInfo[_pid];
1383         UserInfo storage user = userInfo[_pid][_user];
1384         uint256 accrewardTokenPerShare = pool.accrewardTokenPerShare;
1385         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1386         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1387             uint256 multiplier =
1388                 getMultiplier(pool.lastRewardBlock, block.number);
1389             uint256 rewardTokenReward =
1390                 multiplier.mul(rewardTokenPerBlock).mul(pool.allocPoint).div(
1391                     totalAllocPoint
1392                 );
1393             accrewardTokenPerShare = accrewardTokenPerShare.add(
1394                 rewardTokenReward.mul(1e12).div(lpSupply)
1395             );
1396         }
1397         return user.amount.mul(accrewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1398     }
1399     // Update reward vairables for all pools. Be careful of gas spending!
1400     function massUpdatePools() public {
1401         uint256 length = poolInfo.length;
1402         for (uint256 pid = 0; pid < length; ++pid) {
1403             updatePool(pid);
1404         }
1405     }
1406     // Update reward variables of the given pool to be up-to-date.
1407     function updatePool(uint256 _pid) public {
1408         PoolInfo storage pool = poolInfo[_pid];
1409         if (block.number <= pool.lastRewardBlock) {
1410             return;
1411         }
1412         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1413         if (lpSupply == 0) {
1414             pool.lastRewardBlock = block.number;
1415             return;
1416         }
1417         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1418         uint256 rewardTokenReward = multiplier.mul(rewardTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1419         communityRateAmount = communityRateAmount.add(rewardTokenReward.div(5));
1420         rewardToken.pool_mint(address(this), rewardTokenReward);
1421         pool.accrewardTokenPerShare = pool.accrewardTokenPerShare.add(
1422             rewardTokenReward.mul(1e12).div(lpSupply)
1423         );
1424         pool.lastRewardBlock = block.number;
1425     }
1426     // Deposit LP tokens to MasterChef for rewardToken allocation.
1427     function deposit(uint256 _pid, uint256 _amount) public {
1428         uint256 pending = 0;
1429         require(block.number > startBlock,"!!!start");
1430         PoolInfo storage pool = poolInfo[_pid];
1431         UserInfo storage user = userInfo[_pid][msg.sender];
1432         updatePool(_pid);
1433         if (user.amount > 0) {
1434             pending = user.amount.mul(pool.accrewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1435             safeRewardTokenTransfer(msg.sender, pending);
1436         }
1437         //save gas for claimReward
1438         if(_amount > 0){
1439             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1440             user.amount = user.amount.add(_amount);
1441         }
1442         user.rewardDebt = user.amount.mul(pool.accrewardTokenPerShare).div(1e12);
1443         emit Deposit(msg.sender, _pid, _amount,pending);
1444     }
1445     // Withdraw LP tokens from MasterChef.
1446     function withdraw(uint256 _pid, uint256 _amount) public {
1447         PoolInfo storage pool = poolInfo[_pid];
1448         UserInfo storage user = userInfo[_pid][msg.sender];
1449         require(user.amount >= _amount, "withdraw: not good");
1450         updatePool(_pid);
1451         uint256 pending = user.amount.mul(pool.accrewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1452         safeRewardTokenTransfer(msg.sender, pending);
1453         user.amount = user.amount.sub(_amount);
1454         user.rewardDebt = user.amount.mul(pool.accrewardTokenPerShare).div(1e12);
1455         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1456         emit Withdraw(msg.sender, _pid, _amount,pending);
1457     }
1458     function claimReward(uint256 _pid) public {
1459         deposit(_pid,0);
1460     }
1461     function protocolValueForUSE(address _pair,address _use,uint256 _lpp,uint256 _cp) public onlyPCVMaster{
1462         require(block.number >= miningEndBlock,"pcv: only start after mining");
1463         uint256 _useRemain =  _protocolValue(swapRouter,_pair,_use,_lpp,_cp);
1464         IUSEStablecoin(_use).burn(_useRemain); 
1465     }
1466     // Withdraw without caring about rewards. EMERGENCY ONLY.
1467     function emergencyWithdraw(uint256 _pid) public {
1468         PoolInfo storage pool = poolInfo[_pid];
1469         UserInfo storage user = userInfo[_pid][msg.sender];
1470         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1471         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1472         user.amount = 0;
1473         user.rewardDebt = 0;
1474     }
1475     // Safe rewardToken transfer function, just in case if rounding error causes pool to not have enough rewardTokens.
1476     function safeRewardTokenTransfer(address _to, uint256 _amount) internal {
1477         uint256 rewardTokenBal = rewardToken.balanceOf(address(this));
1478         if (_amount > rewardTokenBal) {
1479             rewardToken.transfer(_to, rewardTokenBal);
1480         } else {
1481             rewardToken.transfer(_to, _amount);
1482         }
1483     }
1484     function communityRate(uint256 _rate) public{
1485         require(communityRateAmount > 0,"No community rate");
1486         require(hasRole(COMMUNITY_MASTER, msg.sender),"!role");
1487         uint256 _community_amount = communityRateAmount.mul(_rate).div(PRECISION);
1488         communityRateAmount = communityRateAmount.sub(_community_amount);
1489         rewardToken.pool_mint(msg.sender,_community_amount);   
1490     }
1491     function rewardTokenRate(uint256 _rewardTokenPerBlock) public onlyAdmin{ 
1492          rewardTokenPerBlock = _rewardTokenPerBlock;
1493     }
1494     function updateStartBlock(uint256 _startBlock,uint256 _miningEndBlock) public onlyAdmin{ 
1495          startBlock = _startBlock;
1496          miningEndBlock = _miningEndBlock;
1497     }
1498 }