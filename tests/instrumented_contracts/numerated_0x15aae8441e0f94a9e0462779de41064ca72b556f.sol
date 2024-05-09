1 pragma solidity 0.6.12;
2 
3 
4 library Address {
5     /**
6      * @dev Returns true if `account` is a contract.
7      *
8      * [IMPORTANT]
9      * ====
10      * It is unsafe to assume that an address for which this function returns
11      * false is an externally-owned account (EOA) and not a contract.
12      *
13      * Among others, `isContract` will return false for the following
14      * types of addresses:
15      *
16      *  - an externally-owned account
17      *  - a contract in construction
18      *  - an address where a contract will be created
19      *  - an address where a contract lived, but was destroyed
20      * ====
21      */
22     function isContract(address account) internal view returns (bool) {
23         // This method relies in extcodesize, which returns 0 for contracts in
24         // construction, since the code is only stored at the end of the
25         // constructor execution.
26 
27         uint256 size;
28         // solhint-disable-next-line no-inline-assembly
29         assembly { size := extcodesize(account) }
30         return size > 0;
31     }
32 
33     /**
34      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
35      * `recipient`, forwarding all available gas and reverting on errors.
36      *
37      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
38      * of certain opcodes, possibly making contracts go over the 2300 gas limit
39      * imposed by `transfer`, making them unable to receive funds via
40      * `transfer`. {sendValue} removes this limitation.
41      *
42      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
43      *
44      * IMPORTANT: because control is transferred to `recipient`, care must be
45      * taken to not create reentrancy vulnerabilities. Consider using
46      * {ReentrancyGuard} or the
47      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
48      */
49     function sendValue(address payable recipient, uint256 amount) internal {
50         require(address(this).balance >= amount, "Address: insufficient balance");
51 
52         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
53         (bool success, ) = recipient.call{ value: amount }("");
54         require(success, "Address: unable to send value, recipient may have reverted");
55     }
56 
57     /**
58      * @dev Performs a Solidity function call using a low level `call`. A
59      * plain`call` is an unsafe replacement for a function call: use this
60      * function instead.
61      *
62      * If `target` reverts with a revert reason, it is bubbled up by this
63      * function (like regular Solidity function calls).
64      *
65      * Returns the raw returned data. To convert to the expected return value,
66      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
67      *
68      * Requirements:
69      *
70      * - `target` must be a contract.
71      * - calling `target` with `data` must not revert.
72      *
73      * _Available since v3.1._
74      */
75     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
76       return functionCall(target, data, "Address: low-level call failed");
77     }
78 
79     /**
80      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
81      * `errorMessage` as a fallback revert reason when `target` reverts.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
86         return _functionCallWithValue(target, data, 0, errorMessage);
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
91      * but also transferring `value` wei to `target`.
92      *
93      * Requirements:
94      *
95      * - the calling contract must have an ETH balance of at least `value`.
96      * - the called Solidity function must be `payable`.
97      *
98      * _Available since v3.1._
99      */
100     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
106      * with `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
111         require(address(this).balance >= value, "Address: insufficient balance for call");
112         return _functionCallWithValue(target, data, value, errorMessage);
113     }
114 
115     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
120         if (success) {
121             return returndata;
122         } else {
123             // Look for revert reason and bubble it up if present
124             if (returndata.length > 0) {
125                 // The easiest way to bubble the revert reason is using memory via assembly
126 
127                 // solhint-disable-next-line no-inline-assembly
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address payable) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes memory) {
144         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
145         return msg.data;
146     }
147 }
148 contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor () internal {
157         address msgSender = _msgSender();
158         _owner = msgSender;
159         emit OwnershipTransferred(address(0), msgSender);
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(_owner == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     /**
178      * @dev Leaves the contract without owner. It will not be possible to call
179      * `onlyOwner` functions anymore. Can only be called by the current owner.
180      *
181      * NOTE: Renouncing ownership will leave the contract without an owner,
182      * thereby removing any functionality that is only available to the owner.
183      */
184     function renounceOwnership() public virtual onlyOwner {
185         emit OwnershipTransferred(_owner, address(0));
186         _owner = address(0);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Can only be called by the current owner.
192      */
193     function transferOwnership(address newOwner) public virtual onlyOwner {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `+` operator.
205      *
206      * Requirements:
207      *
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         require(c >= a, "SafeMath: addition overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return sub(a, b, "SafeMath: subtraction overflow");
229     }
230 
231     /**
232      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
233      * overflow (when the result is negative).
234      *
235      * Counterpart to Solidity's `-` operator.
236      *
237      * Requirements:
238      *
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b <= a, errorMessage);
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      *
256      * - Multiplication cannot overflow.
257      */
258     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
260         // benefit is lost if 'b' is also tested.
261         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
262         if (a == 0) {
263             return 0;
264         }
265 
266         uint256 c = a * b;
267         require(c / a == b, "SafeMath: multiplication overflow");
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers. Reverts on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator. Note: this function uses a
277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
278      * uses an invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         uint256 c = a / b;
303         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * Reverts when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321         return mod(a, b, "SafeMath: modulo by zero");
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts with custom message when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b != 0, errorMessage);
338         return a % b;
339     }
340 }
341 library EnumerableSet {
342     // To implement this library for multiple types with as little code
343     // repetition as possible, we write it in terms of a generic Set type with
344     // bytes32 values.
345     // The Set implementation uses private functions, and user-facing
346     // implementations (such as AddressSet) are just wrappers around the
347     // underlying Set.
348     // This means that we can only create new EnumerableSets for types that fit
349     // in bytes32.
350 
351     struct Set {
352         // Storage of set values
353         bytes32[] _values;
354 
355         // Position of the value in the `values` array, plus 1 because index 0
356         // means a value is not in the set.
357         mapping (bytes32 => uint256) _indexes;
358     }
359 
360     /**
361      * @dev Add a value to a set. O(1).
362      *
363      * Returns true if the value was added to the set, that is if it was not
364      * already present.
365      */
366     function _add(Set storage set, bytes32 value) private returns (bool) {
367         if (!_contains(set, value)) {
368             set._values.push(value);
369             // The value is stored at length-1, but we add 1 to all indexes
370             // and use 0 as a sentinel value
371             set._indexes[value] = set._values.length;
372             return true;
373         } else {
374             return false;
375         }
376     }
377 
378     /**
379      * @dev Removes a value from a set. O(1).
380      *
381      * Returns true if the value was removed from the set, that is if it was
382      * present.
383      */
384     function _remove(Set storage set, bytes32 value) private returns (bool) {
385         // We read and store the value's index to prevent multiple reads from the same storage slot
386         uint256 valueIndex = set._indexes[value];
387 
388         if (valueIndex != 0) { // Equivalent to contains(set, value)
389             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
390             // the array, and then remove the last element (sometimes called as 'swap and pop').
391             // This modifies the order of the array, as noted in {at}.
392 
393             uint256 toDeleteIndex = valueIndex - 1;
394             uint256 lastIndex = set._values.length - 1;
395 
396             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
397             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
398 
399             bytes32 lastvalue = set._values[lastIndex];
400 
401             // Move the last value to the index where the value to delete is
402             set._values[toDeleteIndex] = lastvalue;
403             // Update the index for the moved value
404             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
405 
406             // Delete the slot where the moved value was stored
407             set._values.pop();
408 
409             // Delete the index for the deleted slot
410             delete set._indexes[value];
411 
412             return true;
413         } else {
414             return false;
415         }
416     }
417 
418     /**
419      * @dev Returns true if the value is in the set. O(1).
420      */
421     function _contains(Set storage set, bytes32 value) private view returns (bool) {
422         return set._indexes[value] != 0;
423     }
424 
425     /**
426      * @dev Returns the number of values on the set. O(1).
427      */
428     function _length(Set storage set) private view returns (uint256) {
429         return set._values.length;
430     }
431 
432    /**
433     * @dev Returns the value stored at position `index` in the set. O(1).
434     *
435     * Note that there are no guarantees on the ordering of values inside the
436     * array, and it may change when more values are added or removed.
437     *
438     * Requirements:
439     *
440     * - `index` must be strictly less than {length}.
441     */
442     function _at(Set storage set, uint256 index) private view returns (bytes32) {
443         require(set._values.length > index, "EnumerableSet: index out of bounds");
444         return set._values[index];
445     }
446 
447     // AddressSet
448 
449     struct AddressSet {
450         Set _inner;
451     }
452 
453     /**
454      * @dev Add a value to a set. O(1).
455      *
456      * Returns true if the value was added to the set, that is if it was not
457      * already present.
458      */
459     function add(AddressSet storage set, address value) internal returns (bool) {
460         return _add(set._inner, bytes32(uint256(value)));
461     }
462 
463     /**
464      * @dev Removes a value from a set. O(1).
465      *
466      * Returns true if the value was removed from the set, that is if it was
467      * present.
468      */
469     function remove(AddressSet storage set, address value) internal returns (bool) {
470         return _remove(set._inner, bytes32(uint256(value)));
471     }
472 
473     /**
474      * @dev Returns true if the value is in the set. O(1).
475      */
476     function contains(AddressSet storage set, address value) internal view returns (bool) {
477         return _contains(set._inner, bytes32(uint256(value)));
478     }
479 
480     /**
481      * @dev Returns the number of values in the set. O(1).
482      */
483     function length(AddressSet storage set) internal view returns (uint256) {
484         return _length(set._inner);
485     }
486 
487    /**
488     * @dev Returns the value stored at position `index` in the set. O(1).
489     *
490     * Note that there are no guarantees on the ordering of values inside the
491     * array, and it may change when more values are added or removed.
492     *
493     * Requirements:
494     *
495     * - `index` must be strictly less than {length}.
496     */
497     function at(AddressSet storage set, uint256 index) internal view returns (address) {
498         return address(uint256(_at(set._inner, index)));
499     }
500 
501 
502     // UintSet
503 
504     struct UintSet {
505         Set _inner;
506     }
507 
508     /**
509      * @dev Add a value to a set. O(1).
510      *
511      * Returns true if the value was added to the set, that is if it was not
512      * already present.
513      */
514     function add(UintSet storage set, uint256 value) internal returns (bool) {
515         return _add(set._inner, bytes32(value));
516     }
517 
518     /**
519      * @dev Removes a value from a set. O(1).
520      *
521      * Returns true if the value was removed from the set, that is if it was
522      * present.
523      */
524     function remove(UintSet storage set, uint256 value) internal returns (bool) {
525         return _remove(set._inner, bytes32(value));
526     }
527 
528     /**
529      * @dev Returns true if the value is in the set. O(1).
530      */
531     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
532         return _contains(set._inner, bytes32(value));
533     }
534 
535     /**
536      * @dev Returns the number of values on the set. O(1).
537      */
538     function length(UintSet storage set) internal view returns (uint256) {
539         return _length(set._inner);
540     }
541 
542    /**
543     * @dev Returns the value stored at position `index` in the set. O(1).
544     *
545     * Note that there are no guarantees on the ordering of values inside the
546     * array, and it may change when more values are added or removed.
547     *
548     * Requirements:
549     *
550     * - `index` must be strictly less than {length}.
551     */
552     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
553         return uint256(_at(set._inner, index));
554     }
555 }
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
614 interface IERC20 {
615     /**
616      * @dev Returns the amount of tokens in existence.
617      */
618     function totalSupply() external view returns (uint256);
619 
620     /**
621      * @dev Returns the amount of tokens owned by `account`.
622      */
623     function balanceOf(address account) external view returns (uint256);
624 
625     /**
626      * @dev Moves `amount` tokens from the caller's account to `recipient`.
627      *
628      * Returns a boolean value indicating whether the operation succeeded.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transfer(address recipient, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Returns the remaining number of tokens that `spender` will be
636      * allowed to spend on behalf of `owner` through {transferFrom}. This is
637      * zero by default.
638      *
639      * This value changes when {approve} or {transferFrom} are called.
640      */
641     function allowance(address owner, address spender) external view returns (uint256);
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
645      *
646      * Returns a boolean value indicating whether the operation succeeded.
647      *
648      * IMPORTANT: Beware that changing an allowance with this method brings the risk
649      * that someone may use both the old and the new allowance by unfortunate
650      * transaction ordering. One possible solution to mitigate this race
651      * condition is to first reduce the spender's allowance to 0 and set the
652      * desired value afterwards:
653      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
654      *
655      * Emits an {Approval} event.
656      */
657     function approve(address spender, uint256 amount) external returns (bool);
658 
659     /**
660      * @dev Moves `amount` tokens from `sender` to `recipient` using the
661      * allowance mechanism. `amount` is then deducted from the caller's
662      * allowance.
663      *
664      * Returns a boolean value indicating whether the operation succeeded.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Emitted when `value` tokens are moved from one account (`from`) to
672      * another (`to`).
673      *
674      * Note that `value` may be zero.
675      */
676     event Transfer(address indexed from, address indexed to, uint256 value);
677 
678     /**
679      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
680      * a call to {approve}. `value` is the new allowance.
681      */
682     event Approval(address indexed owner, address indexed spender, uint256 value);
683 }
684 contract ERC20 is Context, IERC20 {
685     using SafeMath for uint256;
686     using Address for address;
687 
688     mapping (address => uint256) private _balances;
689 
690     mapping (address => mapping (address => uint256)) private _allowances;
691 
692     uint256 private _totalSupply;
693 
694     string private _name;
695     string private _symbol;
696     uint8 private _decimals;
697 
698     /**
699      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
700      * a default value of 18.
701      *
702      * To select a different value for {decimals}, use {_setupDecimals}.
703      *
704      * All three of these values are immutable: they can only be set once during
705      * construction.
706      */
707     constructor (string memory name, string memory symbol) public {
708         _name = name;
709         _symbol = symbol;
710         _decimals = 18;
711     }
712 
713     /**
714      * @dev Returns the name of the token.
715      */
716     function name() public view returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev Returns the symbol of the token, usually a shorter version of the
722      * name.
723      */
724     function symbol() public view returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev Returns the number of decimals used to get its user representation.
730      * For example, if `decimals` equals `2`, a balance of `505` tokens should
731      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
732      *
733      * Tokens usually opt for a value of 18, imitating the relationship between
734      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
735      * called.
736      *
737      * NOTE: This information is only used for _display_ purposes: it in
738      * no way affects any of the arithmetic of the contract, including
739      * {IERC20-balanceOf} and {IERC20-transfer}.
740      */
741     function decimals() public view returns (uint8) {
742         return _decimals;
743     }
744 
745     /**
746      * @dev See {IERC20-totalSupply}.
747      */
748     function totalSupply() public view override returns (uint256) {
749         return _totalSupply;
750     }
751 
752     /**
753      * @dev See {IERC20-balanceOf}.
754      */
755     function balanceOf(address account) public view override returns (uint256) {
756         return _balances[account];
757     }
758 
759     /**
760      * @dev See {IERC20-transfer}.
761      *
762      * Requirements:
763      *
764      * - `recipient` cannot be the zero address.
765      * - the caller must have a balance of at least `amount`.
766      */
767     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
768         _transfer(_msgSender(), recipient, amount);
769         return true;
770     }
771 
772     /**
773      * @dev See {IERC20-allowance}.
774      */
775     function allowance(address owner, address spender) public view virtual override returns (uint256) {
776         return _allowances[owner][spender];
777     }
778 
779     /**
780      * @dev See {IERC20-approve}.
781      *
782      * Requirements:
783      *
784      * - `spender` cannot be the zero address.
785      */
786     function approve(address spender, uint256 amount) public virtual override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     /**
792      * @dev See {IERC20-transferFrom}.
793      *
794      * Emits an {Approval} event indicating the updated allowance. This is not
795      * required by the EIP. See the note at the beginning of {ERC20};
796      *
797      * Requirements:
798      * - `sender` and `recipient` cannot be the zero address.
799      * - `sender` must have a balance of at least `amount`.
800      * - the caller must have allowance for ``sender``'s tokens of at least
801      * `amount`.
802      */
803     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
804         _transfer(sender, recipient, amount);
805         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
806         return true;
807     }
808 
809     /**
810      * @dev Atomically increases the allowance granted to `spender` by the caller.
811      *
812      * This is an alternative to {approve} that can be used as a mitigation for
813      * problems described in {IERC20-approve}.
814      *
815      * Emits an {Approval} event indicating the updated allowance.
816      *
817      * Requirements:
818      *
819      * - `spender` cannot be the zero address.
820      */
821     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
822         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
823         return true;
824     }
825 
826     /**
827      * @dev Atomically decreases the allowance granted to `spender` by the caller.
828      *
829      * This is an alternative to {approve} that can be used as a mitigation for
830      * problems described in {IERC20-approve}.
831      *
832      * Emits an {Approval} event indicating the updated allowance.
833      *
834      * Requirements:
835      *
836      * - `spender` cannot be the zero address.
837      * - `spender` must have allowance for the caller of at least
838      * `subtractedValue`.
839      */
840     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
841         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
842         return true;
843     }
844 
845     /**
846      * @dev Moves tokens `amount` from `sender` to `recipient`.
847      *
848      * This is internal function is equivalent to {transfer}, and can be used to
849      * e.g. implement automatic token fees, slashing mechanisms, etc.
850      *
851      * Emits a {Transfer} event.
852      *
853      * Requirements:
854      *
855      * - `sender` cannot be the zero address.
856      * - `recipient` cannot be the zero address.
857      * - `sender` must have a balance of at least `amount`.
858      */
859     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
860         require(sender != address(0), "ERC20: transfer from the zero address");
861         require(recipient != address(0), "ERC20: transfer to the zero address");
862 
863         _beforeTokenTransfer(sender, recipient, amount);
864 
865         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
866         _balances[recipient] = _balances[recipient].add(amount);
867         emit Transfer(sender, recipient, amount);
868     }
869 
870     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
871      * the total supply.
872      *
873      * Emits a {Transfer} event with `from` set to the zero address.
874      *
875      * Requirements
876      *
877      * - `to` cannot be the zero address.
878      */
879     function _mint(address account, uint256 amount) internal virtual {
880         require(account != address(0), "ERC20: mint to the zero address");
881 
882         _beforeTokenTransfer(address(0), account, amount);
883 
884         _totalSupply = _totalSupply.add(amount);
885         _balances[account] = _balances[account].add(amount);
886         emit Transfer(address(0), account, amount);
887     }
888 
889     /**
890      * @dev Destroys `amount` tokens from `account`, reducing the
891      * total supply.
892      *
893      * Emits a {Transfer} event with `to` set to the zero address.
894      *
895      * Requirements
896      *
897      * - `account` cannot be the zero address.
898      * - `account` must have at least `amount` tokens.
899      */
900     function _burn(address account, uint256 amount) internal virtual {
901         require(account != address(0), "ERC20: burn from the zero address");
902 
903         _beforeTokenTransfer(account, address(0), amount);
904 
905         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
906         _totalSupply = _totalSupply.sub(amount);
907         emit Transfer(account, address(0), amount);
908     }
909 
910     /**
911      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
912      *
913      * This internal function is equivalent to `approve`, and can be used to
914      * e.g. set automatic allowances for certain subsystems, etc.
915      *
916      * Emits an {Approval} event.
917      *
918      * Requirements:
919      *
920      * - `owner` cannot be the zero address.
921      * - `spender` cannot be the zero address.
922      */
923     function _approve(address owner, address spender, uint256 amount) internal virtual {
924         require(owner != address(0), "ERC20: approve from the zero address");
925         require(spender != address(0), "ERC20: approve to the zero address");
926 
927         _allowances[owner][spender] = amount;
928         emit Approval(owner, spender, amount);
929     }
930 
931     /**
932      * @dev Sets {decimals} to a value other than the default one of 18.
933      *
934      * WARNING: This function should only be called from the constructor. Most
935      * applications that interact with token contracts will not expect
936      * {decimals} to ever change, and may work incorrectly if it does.
937      */
938     function _setupDecimals(uint8 decimals_) internal {
939         _decimals = decimals_;
940     }
941 
942     /**
943      * @dev Hook that is called before any transfer of tokens. This includes
944      * minting and burning.
945      *
946      * Calling conditions:
947      *
948      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
949      * will be to transferred to `to`.
950      * - when `from` is zero, `amount` tokens will be minted for `to`.
951      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
952      * - `from` and `to` are never both zero.
953      *
954      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
955      */
956     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
957 }
958 
959 // Midas with Governance.
960 contract Midas is ERC20("Midas", "MDS"), Ownable {
961     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (GoldenTouch).
962     function mint(address _to, uint256 _amount) public onlyOwner {
963         _mint(_to, _amount);
964         _moveDelegates(address(0), _delegates[_to], _amount);
965     }
966 
967     /// @notice A record of each accounts delegate
968     mapping (address => address) internal _delegates;
969 
970     /// @notice A checkpoint for marking number of votes from a given block
971     struct Checkpoint {
972         uint32 fromBlock;
973         uint256 votes;
974     }
975 
976     /// @notice A record of votes checkpoints for each account, by index
977     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
978 
979     /// @notice The number of checkpoints for each account
980     mapping (address => uint32) public numCheckpoints;
981 
982     /// @notice The EIP-712 typehash for the contract's domain
983     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
984 
985     /// @notice The EIP-712 typehash for the delegation struct used by the contract
986     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
987 
988     /// @notice A record of states for signing / validating signatures
989     mapping (address => uint) public nonces;
990 
991       /// @notice An event thats emitted when an account changes its delegate
992     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
993 
994     /// @notice An event thats emitted when a delegate account's vote balance changes
995     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
996 
997     /**
998      * @notice Delegate votes from `msg.sender` to `delegatee`
999      * @param delegator The address to get delegatee for
1000      */
1001     function delegates(address delegator)
1002         external
1003         view
1004         returns (address)
1005     {
1006         return _delegates[delegator];
1007     }
1008 
1009    /**
1010     * @notice Delegate votes from `msg.sender` to `delegatee`
1011     * @param delegatee The address to delegate votes to
1012     */
1013     function delegate(address delegatee) external {
1014         return _delegate(msg.sender, delegatee);
1015     }
1016 
1017     /**
1018      * @notice Delegates votes from signatory to `delegatee`
1019      * @param delegatee The address to delegate votes to
1020      * @param nonce The contract state required to match the signature
1021      * @param expiry The time at which to expire the signature
1022      * @param v The recovery byte of the signature
1023      * @param r Half of the ECDSA signature pair
1024      * @param s Half of the ECDSA signature pair
1025      */
1026     function delegateBySig(
1027         address delegatee,
1028         uint nonce,
1029         uint expiry,
1030         uint8 v,
1031         bytes32 r,
1032         bytes32 s
1033     )
1034         external
1035     {
1036         bytes32 domainSeparator = keccak256(
1037             abi.encode(
1038                 DOMAIN_TYPEHASH,
1039                 keccak256(bytes(name())),
1040                 getChainId(),
1041                 address(this)
1042             )
1043         );
1044 
1045         bytes32 structHash = keccak256(
1046             abi.encode(
1047                 DELEGATION_TYPEHASH,
1048                 delegatee,
1049                 nonce,
1050                 expiry
1051             )
1052         );
1053 
1054         bytes32 digest = keccak256(
1055             abi.encodePacked(
1056                 "\x19\x01",
1057                 domainSeparator,
1058                 structHash
1059             )
1060         );
1061 
1062         address signatory = ecrecover(digest, v, r, s);
1063         require(signatory != address(0), "MIDAS::delegateBySig: invalid signature");
1064         require(nonce == nonces[signatory]++, "MIDAS::delegateBySig: invalid nonce");
1065         require(now <= expiry, "MIDAS::delegateBySig: signature expired");
1066         return _delegate(signatory, delegatee);
1067     }
1068 
1069     /**
1070      * @notice Gets the current votes balance for `account`
1071      * @param account The address to get votes balance
1072      * @return The number of current votes for `account`
1073      */
1074     function getCurrentVotes(address account)
1075         external
1076         view
1077         returns (uint256)
1078     {
1079         uint32 nCheckpoints = numCheckpoints[account];
1080         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1081     }
1082 
1083     /**
1084      * @notice Determine the prior number of votes for an account as of a block number
1085      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1086      * @param account The address of the account to check
1087      * @param blockNumber The block number to get the vote balance at
1088      * @return The number of votes the account had as of the given block
1089      */
1090     function getPriorVotes(address account, uint blockNumber)
1091         external
1092         view
1093         returns (uint256)
1094     {
1095         require(blockNumber < block.number, "MIDAS::getPriorVotes: not yet determined");
1096 
1097         uint32 nCheckpoints = numCheckpoints[account];
1098         if (nCheckpoints == 0) {
1099             return 0;
1100         }
1101 
1102         // First check most recent balance
1103         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1104             return checkpoints[account][nCheckpoints - 1].votes;
1105         }
1106 
1107         // Next check implicit zero balance
1108         if (checkpoints[account][0].fromBlock > blockNumber) {
1109             return 0;
1110         }
1111 
1112         uint32 lower = 0;
1113         uint32 upper = nCheckpoints - 1;
1114         while (upper > lower) {
1115             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1116             Checkpoint memory cp = checkpoints[account][center];
1117             if (cp.fromBlock == blockNumber) {
1118                 return cp.votes;
1119             } else if (cp.fromBlock < blockNumber) {
1120                 lower = center;
1121             } else {
1122                 upper = center - 1;
1123             }
1124         }
1125         return checkpoints[account][lower].votes;
1126     }
1127 
1128     function _delegate(address delegator, address delegatee)
1129         internal
1130     {
1131         address currentDelegate = _delegates[delegator];
1132         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MIDASs (not scaled);
1133         _delegates[delegator] = delegatee;
1134 
1135         emit DelegateChanged(delegator, currentDelegate, delegatee);
1136 
1137         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1138     }
1139 
1140     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1141         if (srcRep != dstRep && amount > 0) {
1142             if (srcRep != address(0)) {
1143                 // decrease old representative
1144                 uint32 srcRepNum = numCheckpoints[srcRep];
1145                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1146                 uint256 srcRepNew = srcRepOld.sub(amount);
1147                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1148             }
1149 
1150             if (dstRep != address(0)) {
1151                 // increase new representative
1152                 uint32 dstRepNum = numCheckpoints[dstRep];
1153                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1154                 uint256 dstRepNew = dstRepOld.add(amount);
1155                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1156             }
1157         }
1158     }
1159 
1160     function _writeCheckpoint(
1161         address delegatee,
1162         uint32 nCheckpoints,
1163         uint256 oldVotes,
1164         uint256 newVotes
1165     )
1166         internal
1167     {
1168         uint32 blockNumber = safe32(block.number, "MIDAS::_writeCheckpoint: block number exceeds 32 bits");
1169 
1170         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1171             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1172         } else {
1173             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1174             numCheckpoints[delegatee] = nCheckpoints + 1;
1175         }
1176 
1177         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1178     }
1179 
1180     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1181         require(n < 2**32, errorMessage);
1182         return uint32(n);
1183     }
1184 
1185     function getChainId() internal pure returns (uint) {
1186         uint256 chainId;
1187         assembly { chainId := chainid() }
1188         return chainId;
1189     }
1190 }
1191 
1192 
1193 interface IMigratorGoldenTouch {
1194     // Perform LP token migration from legacy UniswapV2 to MidasSwap.
1195     // Take the current LP token address and return the new LP token address.
1196     // Migrator should have full access to the caller's LP token.
1197     // Return the new LP token address.
1198     //
1199     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1200     // MidasSwap must mint EXACTLY the same amount of MidasSwap LP tokens or
1201     // else something bad will happen. Traditional UniswapV2 does not
1202     // do that so be careful!
1203     function migrate(IERC20 token) external returns (IERC20);
1204 }
1205 
1206 // GoldenTouch is the Midas. He can make Midas and he is a fair guy.
1207 //
1208 // Note that it's ownable and the owner wields tremendous power. The ownership
1209 // will be transferred to a governance smart contract once MIDAS is sufficiently
1210 // distributed and the community can show to govern itself.
1211 //
1212 // Have fun reading it. Hopefully it's bug-free. God bless.
1213 contract GoldenTouch is Ownable {
1214     using SafeMath for uint256;
1215     using SafeERC20 for IERC20;
1216 
1217     // Info of each user.
1218     struct UserInfo {
1219         uint256 amount;     // How many LP tokens the user has provided.
1220         uint256 rewardDebt; // Reward debt. See explanation below.
1221         //
1222         // We do some fancy math here. Basically, any point in time, the amount of MIDASs
1223         // entitled to a user but is pending to be distributed is:
1224         //
1225         //   pending reward = (user.amount * pool.accMidasPerShare) - user.rewardDebt
1226         //
1227         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1228         //   1. The pool's `accMidasPerShare` (and `lastRewardBlock`) gets updated.
1229         //   2. User receives the pending reward sent to his/her address.
1230         //   3. User's `amount` gets updated.
1231         //   4. User's `rewardDebt` gets updated.
1232     }
1233 
1234     // Info of each pool.
1235     struct PoolInfo {
1236         IERC20 lpToken;           // Address of LP token contract.
1237         uint256 allocPoint;       // How many allocation points assigned to this pool. MIDASs to distribute per block.
1238         uint256 lastRewardBlock;  // Last block number that MIDASs distribution occurs.
1239         uint256 accMidasPerShare; // Accumulated MIDASs per share, times 1e12. See below.
1240     }
1241 
1242     // The MIDAS TOKEN!
1243     Midas public midas;
1244     // Dev address.
1245     address public devaddr;
1246     // Block number when bonus MIDAS period ends.
1247     uint256 public bonusEndBlock;
1248     // MIDAS tokens created per block.
1249     uint256 public midasPerBlock;
1250     // Bonus muliplier for early midas makers.
1251     uint256 public constant BONUS_MULTIPLIER = 4;
1252     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1253     IMigratorGoldenTouch public migrator;
1254 
1255     // Info of each pool.
1256     PoolInfo[] public poolInfo;
1257     // Info of each user that stakes LP tokens.
1258     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1259     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1260     uint256 public totalAllocPoint = 0;
1261     // The block number when MIDAS mining starts.
1262     uint256 public startBlock;
1263 
1264     uint256 public totalBlock = 340000;
1265 
1266     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1267     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1268     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1269 
1270     constructor(
1271         Midas _midas,
1272         address _devaddr,
1273         uint256 _midasPerBlock,
1274         uint256 _startBlock,
1275         uint256 _bonusEndBlock
1276     ) public {
1277         midas = _midas;
1278         devaddr = _devaddr;
1279         midasPerBlock = _midasPerBlock;
1280         bonusEndBlock = _bonusEndBlock;
1281         startBlock = _startBlock;
1282     }
1283 
1284     function poolLength() external view returns (uint256) {
1285         return poolInfo.length;
1286     }
1287 
1288     // Add a new lp to the pool. Can only be called by the owner.
1289     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1290     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1291         if (_withUpdate) {
1292             massUpdatePools();
1293         }
1294         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1295         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1296         poolInfo.push(PoolInfo({
1297             lpToken: _lpToken,
1298             allocPoint: _allocPoint,
1299             lastRewardBlock: lastRewardBlock,
1300             accMidasPerShare: 0
1301         }));
1302     }
1303 
1304     // Update the given pool's MIDAS allocation point. Can only be called by the owner.
1305     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1306         if (_withUpdate) {
1307             massUpdatePools();
1308         }
1309         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1310         poolInfo[_pid].allocPoint = _allocPoint;
1311     }
1312 
1313     // Set the migrator contract. Can only be called by the owner.
1314     function setMigrator(IMigratorGoldenTouch _migrator) public onlyOwner {
1315         migrator = _migrator;
1316     }
1317 
1318     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1319     function migrate(uint256 _pid) public {
1320         require(address(migrator) != address(0), "migrate: no migrator");
1321         PoolInfo storage pool = poolInfo[_pid];
1322         IERC20 lpToken = pool.lpToken;
1323         uint256 bal = lpToken.balanceOf(address(this));
1324         lpToken.safeApprove(address(migrator), bal);
1325         IERC20 newLpToken = migrator.migrate(lpToken);
1326         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1327         pool.lpToken = newLpToken;
1328     }
1329 
1330     // Return reward multiplier over the given _from to _to block.
1331     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1332         if (_to <= bonusEndBlock) {
1333             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1334         } else if (_from >= bonusEndBlock) {
1335             return _to.sub(_from);
1336         } else {
1337             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1338                 _to.sub(bonusEndBlock)
1339             );
1340         }
1341     }
1342 
1343     // View function to see pending MIDASs on frontend.
1344     function pendingMidas(uint256 _pid, address _user) external view returns (uint256) {
1345         PoolInfo storage pool = poolInfo[_pid];
1346         UserInfo storage user = userInfo[_pid][_user];
1347         uint256 accMidasPerShare = pool.accMidasPerShare;
1348         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1349         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1350             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1351             uint256 midasReward = multiplier.mul(midasPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1352             accMidasPerShare = accMidasPerShare.add(midasReward.mul(1e12).div(lpSupply));
1353         }
1354         return user.amount.mul(accMidasPerShare).div(1e12).sub(user.rewardDebt);
1355     }
1356 
1357     // Update reward vairables for all pools. Be careful of gas spending!
1358     function massUpdatePools() public {
1359         uint256 length = poolInfo.length;
1360         for (uint256 pid = 0; pid < length; ++pid) {
1361             updatePool(pid);
1362         }
1363     }
1364 
1365     // Update reward variables of the given pool to be up-to-date.
1366     function updatePool(uint256 _pid) public {
1367         PoolInfo storage pool = poolInfo[_pid];
1368         if (block.number <= pool.lastRewardBlock) {
1369             return;
1370         }
1371         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1372         if (lpSupply == 0) {
1373             pool.lastRewardBlock = block.number;
1374             return;
1375         }
1376         if (pool.lastRewardBlock == (startBlock+totalBlock)){
1377             return;
1378         }
1379 
1380         if (block.number > (startBlock+totalBlock)){
1381             uint256 multiplier = getMultiplier(pool.lastRewardBlock, (startBlock+totalBlock));
1382             uint256 midasReward = multiplier.mul(midasPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1383             midas.mint(devaddr, midasReward.div(20));
1384             midas.mint(address(this), midasReward);
1385             pool.accMidasPerShare = pool.accMidasPerShare.add(midasReward.mul(1e12).div(lpSupply));
1386             pool.lastRewardBlock = (startBlock+totalBlock);
1387             return;
1388         }
1389 
1390         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1391         uint256 midasReward = multiplier.mul(midasPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1392         midas.mint(devaddr, midasReward.div(20));
1393         midas.mint(address(this), midasReward);
1394         pool.accMidasPerShare = pool.accMidasPerShare.add(midasReward.mul(1e12).div(lpSupply));
1395         pool.lastRewardBlock = block.number;
1396         
1397     }
1398 
1399     // Deposit LP tokens to GoldenTouch for MIDAS allocation.
1400     function deposit(uint256 _pid, uint256 _amount) public {
1401         PoolInfo storage pool = poolInfo[_pid];
1402         UserInfo storage user = userInfo[_pid][msg.sender];
1403         updatePool(_pid);
1404         if (user.amount > 0) {
1405             uint256 pending = user.amount.mul(pool.accMidasPerShare).div(1e12).sub(user.rewardDebt);
1406             safeMidasTransfer(msg.sender, pending);
1407         }
1408         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1409         user.amount = user.amount.add(_amount);
1410         user.rewardDebt = user.amount.mul(pool.accMidasPerShare).div(1e12);
1411         emit Deposit(msg.sender, _pid, _amount);
1412     }
1413 
1414     // Withdraw LP tokens from GoldenTouch.
1415     function withdraw(uint256 _pid, uint256 _amount) public {
1416         PoolInfo storage pool = poolInfo[_pid];
1417         UserInfo storage user = userInfo[_pid][msg.sender];
1418         require(user.amount >= _amount, "withdraw: not good");
1419         updatePool(_pid);
1420         uint256 pending = user.amount.mul(pool.accMidasPerShare).div(1e12).sub(user.rewardDebt);
1421         safeMidasTransfer(msg.sender, pending);
1422         user.amount = user.amount.sub(_amount);
1423         user.rewardDebt = user.amount.mul(pool.accMidasPerShare).div(1e12);
1424         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1425         emit Withdraw(msg.sender, _pid, _amount);
1426     }
1427 
1428     // Withdraw without caring about rewards. EMERGENCY ONLY.
1429     function emergencyWithdraw(uint256 _pid) public {
1430         PoolInfo storage pool = poolInfo[_pid];
1431         UserInfo storage user = userInfo[_pid][msg.sender];
1432         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1433         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1434         user.amount = 0;
1435         user.rewardDebt = 0;
1436     }
1437 
1438     // Safe midas transfer function, just in case if rounding error causes pool to not have enough MIDASs.
1439     function safeMidasTransfer(address _to, uint256 _amount) internal {
1440         uint256 midasBal = midas.balanceOf(address(this));
1441         if (_amount > midasBal) {
1442             midas.transfer(_to, midasBal);
1443         } else {
1444             midas.transfer(_to, _amount);
1445         }
1446     }
1447 
1448     // Update dev address by the previous dev.
1449     function dev(address _devaddr) public {
1450         require(msg.sender == devaddr, "dev: wut?");
1451         devaddr = _devaddr;
1452     }
1453 }