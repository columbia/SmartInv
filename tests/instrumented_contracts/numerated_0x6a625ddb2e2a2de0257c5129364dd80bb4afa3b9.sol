1 pragma solidity 0.6.12;
2 
3 library Address {
4     /**
5      * @dev Returns true if `account` is a contract.
6      *
7      * [IMPORTANT]
8      * ====
9      * It is unsafe to assume that an address for which this function returns
10      * false is an externally-owned account (EOA) and not a contract.
11      *
12      * Among others, `isContract` will return false for the following
13      * types of addresses:
14      *
15      *  - an externally-owned account
16      *  - a contract in construction
17      *  - an address where a contract will be created
18      *  - an address where a contract lived, but was destroyed
19      * ====
20      */
21     function isContract(address account) internal view returns (bool) {
22         // This method relies in extcodesize, which returns 0 for contracts in
23         // construction, since the code is only stored at the end of the
24         // constructor execution.
25 
26         uint256 size;
27         // solhint-disable-next-line no-inline-assembly
28         assembly { size := extcodesize(account) }
29         return size > 0;
30     }
31 
32     /**
33      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
34      * `recipient`, forwarding all available gas and reverting on errors.
35      *
36      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
37      * of certain opcodes, possibly making contracts go over the 2300 gas limit
38      * imposed by `transfer`, making them unable to receive funds via
39      * `transfer`. {sendValue} removes this limitation.
40      *
41      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
42      *
43      * IMPORTANT: because control is transferred to `recipient`, care must be
44      * taken to not create reentrancy vulnerabilities. Consider using
45      * {ReentrancyGuard} or the
46      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
47      */
48     function sendValue(address payable recipient, uint256 amount) internal {
49         require(address(this).balance >= amount, "Address: insufficient balance");
50 
51         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
52         (bool success, ) = recipient.call{ value: amount }("");
53         require(success, "Address: unable to send value, recipient may have reverted");
54     }
55 
56     /**
57      * @dev Performs a Solidity function call using a low level `call`. A
58      * plain`call` is an unsafe replacement for a function call: use this
59      * function instead.
60      *
61      * If `target` reverts with a revert reason, it is bubbled up by this
62      * function (like regular Solidity function calls).
63      *
64      * Returns the raw returned data. To convert to the expected return value,
65      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
66      *
67      * Requirements:
68      *
69      * - `target` must be a contract.
70      * - calling `target` with `data` must not revert.
71      *
72      * _Available since v3.1._
73      */
74     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
75       return functionCall(target, data, "Address: low-level call failed");
76     }
77 
78     /**
79      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
80      * `errorMessage` as a fallback revert reason when `target` reverts.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         return _functionCallWithValue(target, data, 0, errorMessage);
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
90      * but also transferring `value` wei to `target`.
91      *
92      * Requirements:
93      *
94      * - the calling contract must have an ETH balance of at least `value`.
95      * - the called Solidity function must be `payable`.
96      *
97      * _Available since v3.1._
98      */
99     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
105      * with `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
110         require(address(this).balance >= value, "Address: insufficient balance for call");
111         return _functionCallWithValue(target, data, value, errorMessage);
112     }
113 
114     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
119         if (success) {
120             return returndata;
121         } else {
122             // Look for revert reason and bubble it up if present
123             if (returndata.length > 0) {
124                 // The easiest way to bubble the revert reason is using memory via assembly
125 
126                 // solhint-disable-next-line no-inline-assembly
127                 assembly {
128                     let returndata_size := mload(returndata)
129                     revert(add(32, returndata), returndata_size)
130                 }
131             } else {
132                 revert(errorMessage);
133             }
134         }
135     }
136 }
137 abstract contract Context {
138     function _msgSender() internal view virtual returns (address payable) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view virtual returns (bytes memory) {
143         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
144         return msg.data;
145     }
146 }
147 contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor () internal {
156         address msgSender = _msgSender();
157         _owner = msgSender;
158         emit OwnershipTransferred(address(0), msgSender);
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(_owner == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         emit OwnershipTransferred(_owner, address(0));
185         _owner = address(0);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Can only be called by the current owner.
191      */
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 library SafeMath {
199     /**
200      * @dev Returns the addition of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `+` operator.
204      *
205      * Requirements:
206      *
207      * - Addition cannot overflow.
208      */
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         require(c >= a, "SafeMath: addition overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      *
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b <= a, errorMessage);
242         uint256 c = a - b;
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         return div(a, b, "SafeMath: division by zero");
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return mod(a, b, "SafeMath: modulo by zero");
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts with custom message when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b != 0, errorMessage);
337         return a % b;
338     }
339 }
340 library EnumerableSet {
341     // To implement this library for multiple types with as little code
342     // repetition as possible, we write it in terms of a generic Set type with
343     // bytes32 values.
344     // The Set implementation uses private functions, and user-facing
345     // implementations (such as AddressSet) are just wrappers around the
346     // underlying Set.
347     // This means that we can only create new EnumerableSets for types that fit
348     // in bytes32.
349 
350     struct Set {
351         // Storage of set values
352         bytes32[] _values;
353 
354         // Position of the value in the `values` array, plus 1 because index 0
355         // means a value is not in the set.
356         mapping (bytes32 => uint256) _indexes;
357     }
358 
359     /**
360      * @dev Add a value to a set. O(1).
361      *
362      * Returns true if the value was added to the set, that is if it was not
363      * already present.
364      */
365     function _add(Set storage set, bytes32 value) private returns (bool) {
366         if (!_contains(set, value)) {
367             set._values.push(value);
368             // The value is stored at length-1, but we add 1 to all indexes
369             // and use 0 as a sentinel value
370             set._indexes[value] = set._values.length;
371             return true;
372         } else {
373             return false;
374         }
375     }
376 
377     /**
378      * @dev Removes a value from a set. O(1).
379      *
380      * Returns true if the value was removed from the set, that is if it was
381      * present.
382      */
383     function _remove(Set storage set, bytes32 value) private returns (bool) {
384         // We read and store the value's index to prevent multiple reads from the same storage slot
385         uint256 valueIndex = set._indexes[value];
386 
387         if (valueIndex != 0) { // Equivalent to contains(set, value)
388             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
389             // the array, and then remove the last element (sometimes called as 'swap and pop').
390             // This modifies the order of the array, as noted in {at}.
391 
392             uint256 toDeleteIndex = valueIndex - 1;
393             uint256 lastIndex = set._values.length - 1;
394 
395             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
396             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
397 
398             bytes32 lastvalue = set._values[lastIndex];
399 
400             // Move the last value to the index where the value to delete is
401             set._values[toDeleteIndex] = lastvalue;
402             // Update the index for the moved value
403             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
404 
405             // Delete the slot where the moved value was stored
406             set._values.pop();
407 
408             // Delete the index for the deleted slot
409             delete set._indexes[value];
410 
411             return true;
412         } else {
413             return false;
414         }
415     }
416 
417     /**
418      * @dev Returns true if the value is in the set. O(1).
419      */
420     function _contains(Set storage set, bytes32 value) private view returns (bool) {
421         return set._indexes[value] != 0;
422     }
423 
424     /**
425      * @dev Returns the number of values on the set. O(1).
426      */
427     function _length(Set storage set) private view returns (uint256) {
428         return set._values.length;
429     }
430 
431    /**
432     * @dev Returns the value stored at position `index` in the set. O(1).
433     *
434     * Note that there are no guarantees on the ordering of values inside the
435     * array, and it may change when more values are added or removed.
436     *
437     * Requirements:
438     *
439     * - `index` must be strictly less than {length}.
440     */
441     function _at(Set storage set, uint256 index) private view returns (bytes32) {
442         require(set._values.length > index, "EnumerableSet: index out of bounds");
443         return set._values[index];
444     }
445 
446     // AddressSet
447 
448     struct AddressSet {
449         Set _inner;
450     }
451 
452     /**
453      * @dev Add a value to a set. O(1).
454      *
455      * Returns true if the value was added to the set, that is if it was not
456      * already present.
457      */
458     function add(AddressSet storage set, address value) internal returns (bool) {
459         return _add(set._inner, bytes32(uint256(value)));
460     }
461 
462     /**
463      * @dev Removes a value from a set. O(1).
464      *
465      * Returns true if the value was removed from the set, that is if it was
466      * present.
467      */
468     function remove(AddressSet storage set, address value) internal returns (bool) {
469         return _remove(set._inner, bytes32(uint256(value)));
470     }
471 
472     /**
473      * @dev Returns true if the value is in the set. O(1).
474      */
475     function contains(AddressSet storage set, address value) internal view returns (bool) {
476         return _contains(set._inner, bytes32(uint256(value)));
477     }
478 
479     /**
480      * @dev Returns the number of values in the set. O(1).
481      */
482     function length(AddressSet storage set) internal view returns (uint256) {
483         return _length(set._inner);
484     }
485 
486    /**
487     * @dev Returns the value stored at position `index` in the set. O(1).
488     *
489     * Note that there are no guarantees on the ordering of values inside the
490     * array, and it may change when more values are added or removed.
491     *
492     * Requirements:
493     *
494     * - `index` must be strictly less than {length}.
495     */
496     function at(AddressSet storage set, uint256 index) internal view returns (address) {
497         return address(uint256(_at(set._inner, index)));
498     }
499 
500 
501     // UintSet
502 
503     struct UintSet {
504         Set _inner;
505     }
506 
507     /**
508      * @dev Add a value to a set. O(1).
509      *
510      * Returns true if the value was added to the set, that is if it was not
511      * already present.
512      */
513     function add(UintSet storage set, uint256 value) internal returns (bool) {
514         return _add(set._inner, bytes32(value));
515     }
516 
517     /**
518      * @dev Removes a value from a set. O(1).
519      *
520      * Returns true if the value was removed from the set, that is if it was
521      * present.
522      */
523     function remove(UintSet storage set, uint256 value) internal returns (bool) {
524         return _remove(set._inner, bytes32(value));
525     }
526 
527     /**
528      * @dev Returns true if the value is in the set. O(1).
529      */
530     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
531         return _contains(set._inner, bytes32(value));
532     }
533 
534     /**
535      * @dev Returns the number of values on the set. O(1).
536      */
537     function length(UintSet storage set) internal view returns (uint256) {
538         return _length(set._inner);
539     }
540 
541    /**
542     * @dev Returns the value stored at position `index` in the set. O(1).
543     *
544     * Note that there are no guarantees on the ordering of values inside the
545     * array, and it may change when more values are added or removed.
546     *
547     * Requirements:
548     *
549     * - `index` must be strictly less than {length}.
550     */
551     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
552         return uint256(_at(set._inner, index));
553     }
554 }
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
613 interface IERC20 {
614     /**
615      * @dev Returns the amount of tokens in existence.
616      */
617     function totalSupply() external view returns (uint256);
618 
619     /**
620      * @dev Returns the amount of tokens owned by `account`.
621      */
622     function balanceOf(address account) external view returns (uint256);
623 
624     /**
625      * @dev Moves `amount` tokens from the caller's account to `recipient`.
626      *
627      * Returns a boolean value indicating whether the operation succeeded.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transfer(address recipient, uint256 amount) external returns (bool);
632 
633     /**
634      * @dev Returns the remaining number of tokens that `spender` will be
635      * allowed to spend on behalf of `owner` through {transferFrom}. This is
636      * zero by default.
637      *
638      * This value changes when {approve} or {transferFrom} are called.
639      */
640     function allowance(address owner, address spender) external view returns (uint256);
641 
642     /**
643      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
644      *
645      * Returns a boolean value indicating whether the operation succeeded.
646      *
647      * IMPORTANT: Beware that changing an allowance with this method brings the risk
648      * that someone may use both the old and the new allowance by unfortunate
649      * transaction ordering. One possible solution to mitigate this race
650      * condition is to first reduce the spender's allowance to 0 and set the
651      * desired value afterwards:
652      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address spender, uint256 amount) external returns (bool);
657 
658     /**
659      * @dev Moves `amount` tokens from `sender` to `recipient` using the
660      * allowance mechanism. `amount` is then deducted from the caller's
661      * allowance.
662      *
663      * Returns a boolean value indicating whether the operation succeeded.
664      *
665      * Emits a {Transfer} event.
666      */
667     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
668 
669     /**
670      * @dev Emitted when `value` tokens are moved from one account (`from`) to
671      * another (`to`).
672      *
673      * Note that `value` may be zero.
674      */
675     event Transfer(address indexed from, address indexed to, uint256 value);
676 
677     /**
678      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
679      * a call to {approve}. `value` is the new allowance.
680      */
681     event Approval(address indexed owner, address indexed spender, uint256 value);
682 }
683 contract ERC20 is Context, IERC20 {
684     using SafeMath for uint256;
685     using Address for address;
686 
687     mapping (address => uint256) private _balances;
688 
689     mapping (address => mapping (address => uint256)) private _allowances;
690 
691     uint256 private _totalSupply;
692 
693     string private _name;
694     string private _symbol;
695     uint8 private _decimals;
696 
697     /**
698      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
699      * a default value of 18.
700      *
701      * To select a different value for {decimals}, use {_setupDecimals}.
702      *
703      * All three of these values are immutable: they can only be set once during
704      * construction.
705      */
706     constructor (string memory name, string memory symbol) public {
707         _name = name;
708         _symbol = symbol;
709         _decimals = 18;
710     }
711 
712     /**
713      * @dev Returns the name of the token.
714      */
715     function name() public view returns (string memory) {
716         return _name;
717     }
718 
719     /**
720      * @dev Returns the symbol of the token, usually a shorter version of the
721      * name.
722      */
723     function symbol() public view returns (string memory) {
724         return _symbol;
725     }
726 
727     /**
728      * @dev Returns the number of decimals used to get its user representation.
729      * For example, if `decimals` equals `2`, a balance of `505` tokens should
730      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
731      *
732      * Tokens usually opt for a value of 18, imitating the relationship between
733      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
734      * called.
735      *
736      * NOTE: This information is only used for _display_ purposes: it in
737      * no way affects any of the arithmetic of the contract, including
738      * {IERC20-balanceOf} and {IERC20-transfer}.
739      */
740     function decimals() public view returns (uint8) {
741         return _decimals;
742     }
743 
744     /**
745      * @dev See {IERC20-totalSupply}.
746      */
747     function totalSupply() public view override returns (uint256) {
748         return _totalSupply;
749     }
750 
751     /**
752      * @dev See {IERC20-balanceOf}.
753      */
754     function balanceOf(address account) public view override returns (uint256) {
755         return _balances[account];
756     }
757 
758     /**
759      * @dev See {IERC20-transfer}.
760      *
761      * Requirements:
762      *
763      * - `recipient` cannot be the zero address.
764      * - the caller must have a balance of at least `amount`.
765      */
766     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
767         _transfer(_msgSender(), recipient, amount);
768         return true;
769     }
770 
771     /**
772      * @dev See {IERC20-allowance}.
773      */
774     function allowance(address owner, address spender) public view virtual override returns (uint256) {
775         return _allowances[owner][spender];
776     }
777 
778     /**
779      * @dev See {IERC20-approve}.
780      *
781      * Requirements:
782      *
783      * - `spender` cannot be the zero address.
784      */
785     function approve(address spender, uint256 amount) public virtual override returns (bool) {
786         _approve(_msgSender(), spender, amount);
787         return true;
788     }
789 
790     /**
791      * @dev See {IERC20-transferFrom}.
792      *
793      * Emits an {Approval} event indicating the updated allowance. This is not
794      * required by the EIP. See the note at the beginning of {ERC20};
795      *
796      * Requirements:
797      * - `sender` and `recipient` cannot be the zero address.
798      * - `sender` must have a balance of at least `amount`.
799      * - the caller must have allowance for ``sender``'s tokens of at least
800      * `amount`.
801      */
802     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
805         return true;
806     }
807 
808     /**
809      * @dev Atomically increases the allowance granted to `spender` by the caller.
810      *
811      * This is an alternative to {approve} that can be used as a mitigation for
812      * problems described in {IERC20-approve}.
813      *
814      * Emits an {Approval} event indicating the updated allowance.
815      *
816      * Requirements:
817      *
818      * - `spender` cannot be the zero address.
819      */
820     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
821         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
822         return true;
823     }
824 
825     /**
826      * @dev Atomically decreases the allowance granted to `spender` by the caller.
827      *
828      * This is an alternative to {approve} that can be used as a mitigation for
829      * problems described in {IERC20-approve}.
830      *
831      * Emits an {Approval} event indicating the updated allowance.
832      *
833      * Requirements:
834      *
835      * - `spender` cannot be the zero address.
836      * - `spender` must have allowance for the caller of at least
837      * `subtractedValue`.
838      */
839     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
840         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
841         return true;
842     }
843 
844     /**
845      * @dev Moves tokens `amount` from `sender` to `recipient`.
846      *
847      * This is internal function is equivalent to {transfer}, and can be used to
848      * e.g. implement automatic token fees, slashing mechanisms, etc.
849      *
850      * Emits a {Transfer} event.
851      *
852      * Requirements:
853      *
854      * - `sender` cannot be the zero address.
855      * - `recipient` cannot be the zero address.
856      * - `sender` must have a balance of at least `amount`.
857      */
858     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
859         require(sender != address(0), "ERC20: transfer from the zero address");
860         require(recipient != address(0), "ERC20: transfer to the zero address");
861 
862         _beforeTokenTransfer(sender, recipient, amount);
863 
864         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
865         _balances[recipient] = _balances[recipient].add(amount);
866         emit Transfer(sender, recipient, amount);
867     }
868 
869     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
870      * the total supply.
871      *
872      * Emits a {Transfer} event with `from` set to the zero address.
873      *
874      * Requirements
875      *
876      * - `to` cannot be the zero address.
877      */
878     function _mint(address account, uint256 amount) internal virtual {
879         require(account != address(0), "ERC20: mint to the zero address");
880 
881         _beforeTokenTransfer(address(0), account, amount);
882 
883         _totalSupply = _totalSupply.add(amount);
884         _balances[account] = _balances[account].add(amount);
885         emit Transfer(address(0), account, amount);
886     }
887 
888     /**
889      * @dev Destroys `amount` tokens from `account`, reducing the
890      * total supply.
891      *
892      * Emits a {Transfer} event with `to` set to the zero address.
893      *
894      * Requirements
895      *
896      * - `account` cannot be the zero address.
897      * - `account` must have at least `amount` tokens.
898      */
899     function _burn(address account, uint256 amount) internal virtual {
900         require(account != address(0), "ERC20: burn from the zero address");
901 
902         _beforeTokenTransfer(account, address(0), amount);
903 
904         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
905         _totalSupply = _totalSupply.sub(amount);
906         emit Transfer(account, address(0), amount);
907     }
908 
909     /**
910      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
911      *
912      * This internal function is equivalent to `approve`, and can be used to
913      * e.g. set automatic allowances for certain subsystems, etc.
914      *
915      * Emits an {Approval} event.
916      *
917      * Requirements:
918      *
919      * - `owner` cannot be the zero address.
920      * - `spender` cannot be the zero address.
921      */
922     function _approve(address owner, address spender, uint256 amount) internal virtual {
923         require(owner != address(0), "ERC20: approve from the zero address");
924         require(spender != address(0), "ERC20: approve to the zero address");
925 
926         _allowances[owner][spender] = amount;
927         emit Approval(owner, spender, amount);
928     }
929 
930     /**
931      * @dev Sets {decimals} to a value other than the default one of 18.
932      *
933      * WARNING: This function should only be called from the constructor. Most
934      * applications that interact with token contracts will not expect
935      * {decimals} to ever change, and may work incorrectly if it does.
936      */
937     function _setupDecimals(uint8 decimals_) internal {
938         _decimals = decimals_;
939     }
940 
941     /**
942      * @dev Hook that is called before any transfer of tokens. This includes
943      * minting and burning.
944      *
945      * Calling conditions:
946      *
947      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
948      * will be to transferred to `to`.
949      * - when `from` is zero, `amount` tokens will be minted for `to`.
950      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
951      * - `from` and `to` are never both zero.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
956 }
957 
958 contract IKOMP is ERC20("IKOMP", "IKOMP"), Ownable {
959     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Sommelier).
960     function mint(address _to, uint256 _amount) public onlyOwner {
961         _mint(_to, _amount);
962         _moveDelegates(address(0), _delegates[_to], _amount);
963     }
964 
965     // Copied and modified from YAM code:
966     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
967     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
968     // Which is copied and modified from COMPOUND:
969     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
970 
971     /// @notice A record of each accounts delegate
972     mapping (address => address) internal _delegates;
973 
974     /// @notice A checkpoint for marking number of votes from a given block
975     struct Checkpoint {
976         uint32 fromBlock;
977         uint256 votes;
978     }
979 
980     /// @notice A record of votes checkpoints for each account, by index
981     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
982 
983     /// @notice The number of checkpoints for each account
984     mapping (address => uint32) public numCheckpoints;
985 
986     /// @notice The EIP-712 typehash for the contract's domain
987     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
988 
989     /// @notice The EIP-712 typehash for the delegation struct used by the contract
990     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
991 
992     /// @notice A record of states for signing / validating signatures
993     mapping (address => uint) public nonces;
994 
995       /// @notice An event thats emitted when an account changes its delegate
996     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
997 
998     /// @notice An event thats emitted when a delegate account's vote balance changes
999     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1000 
1001     /**
1002      * @notice Delegate votes from `msg.sender` to `delegatee`
1003      * @param delegator The address to get delegatee for
1004      */
1005     function delegates(address delegator)
1006         external
1007         view
1008         returns (address)
1009     {
1010         return _delegates[delegator];
1011     }
1012 
1013    /**
1014     * @notice Delegate votes from `msg.sender` to `delegatee`
1015     * @param delegatee The address to delegate votes to
1016     */
1017     function delegate(address delegatee) external {
1018         return _delegate(msg.sender, delegatee);
1019     }
1020 
1021     /**
1022      * @notice Delegates votes from signatory to `delegatee`
1023      * @param delegatee The address to delegate votes to
1024      * @param nonce The contract state required to match the signature
1025      * @param expiry The time at which to expire the signature
1026      * @param v The recovery byte of the signature
1027      * @param r Half of the ECDSA signature pair
1028      * @param s Half of the ECDSA signature pair
1029      */
1030     function delegateBySig(
1031         address delegatee,
1032         uint nonce,
1033         uint expiry,
1034         uint8 v,
1035         bytes32 r,
1036         bytes32 s
1037     )
1038         external
1039     {
1040         bytes32 domainSeparator = keccak256(
1041             abi.encode(
1042                 DOMAIN_TYPEHASH,
1043                 keccak256(bytes(name())),
1044                 getChainId(),
1045                 address(this)
1046             )
1047         );
1048 
1049         bytes32 structHash = keccak256(
1050             abi.encode(
1051                 DELEGATION_TYPEHASH,
1052                 delegatee,
1053                 nonce,
1054                 expiry
1055             )
1056         );
1057 
1058         bytes32 digest = keccak256(
1059             abi.encodePacked(
1060                 "\x19\x01",
1061                 domainSeparator,
1062                 structHash
1063             )
1064         );
1065 
1066         address signatory = ecrecover(digest, v, r, s);
1067         require(signatory != address(0), "IKOMP::delegateBySig: invalid signature");
1068         require(nonce == nonces[signatory]++, "IKOMP::delegateBySig: invalid nonce");
1069         require(now <= expiry, "IKOMP::delegateBySig: signature expired");
1070         return _delegate(signatory, delegatee);
1071     }
1072 
1073     /**
1074      * @notice Gets the current votes balance for `account`
1075      * @param account The address to get votes balance
1076      * @return The number of current votes for `account`
1077      */
1078     function getCurrentVotes(address account)
1079         external
1080         view
1081         returns (uint256)
1082     {
1083         uint32 nCheckpoints = numCheckpoints[account];
1084         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1085     }
1086 
1087     /**
1088      * @notice Determine the prior number of votes for an account as of a block number
1089      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1090      * @param account The address of the account to check
1091      * @param blockNumber The block number to get the vote balance at
1092      * @return The number of votes the account had as of the given block
1093      */
1094     function getPriorVotes(address account, uint blockNumber)
1095         external
1096         view
1097         returns (uint256)
1098     {
1099         require(blockNumber < block.number, "IKOMP::getPriorVotes: not yet determined");
1100 
1101         uint32 nCheckpoints = numCheckpoints[account];
1102         if (nCheckpoints == 0) {
1103             return 0;
1104         }
1105 
1106         // First check most recent balance
1107         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1108             return checkpoints[account][nCheckpoints - 1].votes;
1109         }
1110 
1111         // Next check implicit zero balance
1112         if (checkpoints[account][0].fromBlock > blockNumber) {
1113             return 0;
1114         }
1115 
1116         uint32 lower = 0;
1117         uint32 upper = nCheckpoints - 1;
1118         while (upper > lower) {
1119             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1120             Checkpoint memory cp = checkpoints[account][center];
1121             if (cp.fromBlock == blockNumber) {
1122                 return cp.votes;
1123             } else if (cp.fromBlock < blockNumber) {
1124                 lower = center;
1125             } else {
1126                 upper = center - 1;
1127             }
1128         }
1129         return checkpoints[account][lower].votes;
1130     }
1131 
1132     function _delegate(address delegator, address delegatee)
1133         internal
1134     {
1135         address currentDelegate = _delegates[delegator];
1136         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying IKOMPs (not scaled);
1137         _delegates[delegator] = delegatee;
1138 
1139         emit DelegateChanged(delegator, currentDelegate, delegatee);
1140 
1141         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1142     }
1143 
1144     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1145         if (srcRep != dstRep && amount > 0) {
1146             if (srcRep != address(0)) {
1147                 // decrease old representative
1148                 uint32 srcRepNum = numCheckpoints[srcRep];
1149                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1150                 uint256 srcRepNew = srcRepOld.sub(amount);
1151                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1152             }
1153 
1154             if (dstRep != address(0)) {
1155                 // increase new representative
1156                 uint32 dstRepNum = numCheckpoints[dstRep];
1157                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1158                 uint256 dstRepNew = dstRepOld.add(amount);
1159                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1160             }
1161         }
1162     }
1163 
1164     function _writeCheckpoint(
1165         address delegatee,
1166         uint32 nCheckpoints,
1167         uint256 oldVotes,
1168         uint256 newVotes
1169     )
1170         internal
1171     {
1172         uint32 blockNumber = safe32(block.number, "IKOMP::_writeCheckpoint: block number exceeds 32 bits");
1173 
1174         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1175             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1176         } else {
1177             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1178             numCheckpoints[delegatee] = nCheckpoints + 1;
1179         }
1180 
1181         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1182     }
1183 
1184     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1185         require(n < 2**32, errorMessage);
1186         return uint32(n);
1187     }
1188 
1189     function getChainId() internal pure returns (uint) {
1190         uint256 chainId;
1191         assembly { chainId := chainid() }
1192         return chainId;
1193     }
1194 }