1 pragma solidity ^0.7.6;
2 
3 
4 
5 
6 library SafeMathUpgradeable {
7     /**
8      * @dev Returns the addition of two unsigned integers, reverting on
9      * overflow.
10      *
11      * Counterpart to Solidity's `+` operator.
12      *
13      * Requirements:
14      *
15      * - Addition cannot overflow.
16      */
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, reverting on
26      * overflow (when the result is negative).
27      *
28      * Counterpart to Solidity's `-` operator.
29      *
30      * Requirements:
31      *
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the multiplication of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `*` operator.
60      *
61      * Requirements:
62      *
63      * - Multiplication cannot overflow.
64      */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the integer division of two unsigned integers. Reverts on
81      * division by zero. The result is rounded towards zero.
82      *
83      * Counterpart to Solidity's `/` operator. Note: this function uses a
84      * `revert` opcode (which leaves remaining gas untouched) while Solidity
85      * uses an invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      *
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b > 0, errorMessage);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
117      * Reverts when dividing by zero.
118      *
119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
120      * opcode (which leaves remaining gas untouched) while Solidity uses an
121      * invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         return mod(a, b, "SafeMath: modulo by zero");
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts with custom message when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b != 0, errorMessage);
145         return a % b;
146     }
147 }
148 
149 
150 
151 
152 library EnumerableSetUpgradeable {
153     // To implement this library for multiple types with as little code
154     // repetition as possible, we write it in terms of a generic Set type with
155     // bytes32 values.
156     // The Set implementation uses private functions, and user-facing
157     // implementations (such as AddressSet) are just wrappers around the
158     // underlying Set.
159     // This means that we can only create new EnumerableSets for types that fit
160     // in bytes32.
161 
162     struct Set {
163         // Storage of set values
164         bytes32[] _values;
165 
166         // Position of the value in the `values` array, plus 1 because index 0
167         // means a value is not in the set.
168         mapping (bytes32 => uint256) _indexes;
169     }
170 
171     /**
172      * @dev Add a value to a set. O(1).
173      *
174      * Returns true if the value was added to the set, that is if it was not
175      * already present.
176      */
177     function _add(Set storage set, bytes32 value) private returns (bool) {
178         if (!_contains(set, value)) {
179             set._values.push(value);
180             // The value is stored at length-1, but we add 1 to all indexes
181             // and use 0 as a sentinel value
182             set._indexes[value] = set._values.length;
183             return true;
184         } else {
185             return false;
186         }
187     }
188 
189     /**
190      * @dev Removes a value from a set. O(1).
191      *
192      * Returns true if the value was removed from the set, that is if it was
193      * present.
194      */
195     function _remove(Set storage set, bytes32 value) private returns (bool) {
196         // We read and store the value's index to prevent multiple reads from the same storage slot
197         uint256 valueIndex = set._indexes[value];
198 
199         if (valueIndex != 0) { // Equivalent to contains(set, value)
200             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
201             // the array, and then remove the last element (sometimes called as 'swap and pop').
202             // This modifies the order of the array, as noted in {at}.
203 
204             uint256 toDeleteIndex = valueIndex - 1;
205             uint256 lastIndex = set._values.length - 1;
206 
207             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
208             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
209 
210             bytes32 lastvalue = set._values[lastIndex];
211 
212             // Move the last value to the index where the value to delete is
213             set._values[toDeleteIndex] = lastvalue;
214             // Update the index for the moved value
215             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
216 
217             // Delete the slot where the moved value was stored
218             set._values.pop();
219 
220             // Delete the index for the deleted slot
221             delete set._indexes[value];
222 
223             return true;
224         } else {
225             return false;
226         }
227     }
228 
229     /**
230      * @dev Returns true if the value is in the set. O(1).
231      */
232     function _contains(Set storage set, bytes32 value) private view returns (bool) {
233         return set._indexes[value] != 0;
234     }
235 
236     /**
237      * @dev Returns the number of values on the set. O(1).
238      */
239     function _length(Set storage set) private view returns (uint256) {
240         return set._values.length;
241     }
242 
243     /**
244      * @dev Returns the value stored at position `index` in the set. O(1).
245      *
246      * Note that there are no guarantees on the ordering of values inside the
247      * array, and it may change when more values are added or removed.
248      *
249      * Requirements:
250      *
251      * - `index` must be strictly less than {length}.
252      */
253     function _at(Set storage set, uint256 index) private view returns (bytes32) {
254         require(set._values.length > index, "EnumerableSet: index out of bounds");
255         return set._values[index];
256     }
257 
258     // Bytes32Set
259 
260     struct Bytes32Set {
261         Set _inner;
262     }
263 
264     /**
265      * @dev Add a value to a set. O(1).
266      *
267      * Returns true if the value was added to the set, that is if it was not
268      * already present.
269      */
270     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
271         return _add(set._inner, value);
272     }
273 
274     /**
275      * @dev Removes a value from a set. O(1).
276      *
277      * Returns true if the value was removed from the set, that is if it was
278      * present.
279      */
280     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
281         return _remove(set._inner, value);
282     }
283 
284     /**
285      * @dev Returns true if the value is in the set. O(1).
286      */
287     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
288         return _contains(set._inner, value);
289     }
290 
291     /**
292      * @dev Returns the number of values in the set. O(1).
293      */
294     function length(Bytes32Set storage set) internal view returns (uint256) {
295         return _length(set._inner);
296     }
297 
298     /**
299      * @dev Returns the value stored at position `index` in the set. O(1).
300      *
301      * Note that there are no guarantees on the ordering of values inside the
302      * array, and it may change when more values are added or removed.
303      *
304      * Requirements:
305      *
306      * - `index` must be strictly less than {length}.
307      */
308     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
309         return _at(set._inner, index);
310     }
311 
312     // AddressSet
313 
314     struct AddressSet {
315         Set _inner;
316     }
317 
318     /**
319      * @dev Add a value to a set. O(1).
320      *
321      * Returns true if the value was added to the set, that is if it was not
322      * already present.
323      */
324     function add(AddressSet storage set, address value) internal returns (bool) {
325         return _add(set._inner, bytes32(uint256(value)));
326     }
327 
328     /**
329      * @dev Removes a value from a set. O(1).
330      *
331      * Returns true if the value was removed from the set, that is if it was
332      * present.
333      */
334     function remove(AddressSet storage set, address value) internal returns (bool) {
335         return _remove(set._inner, bytes32(uint256(value)));
336     }
337 
338     /**
339      * @dev Returns true if the value is in the set. O(1).
340      */
341     function contains(AddressSet storage set, address value) internal view returns (bool) {
342         return _contains(set._inner, bytes32(uint256(value)));
343     }
344 
345     /**
346      * @dev Returns the number of values in the set. O(1).
347      */
348     function length(AddressSet storage set) internal view returns (uint256) {
349         return _length(set._inner);
350     }
351 
352     /**
353      * @dev Returns the value stored at position `index` in the set. O(1).
354      *
355      * Note that there are no guarantees on the ordering of values inside the
356      * array, and it may change when more values are added or removed.
357      *
358      * Requirements:
359      *
360      * - `index` must be strictly less than {length}.
361      */
362     function at(AddressSet storage set, uint256 index) internal view returns (address) {
363         return address(uint256(_at(set._inner, index)));
364     }
365 
366 
367     // UintSet
368 
369     struct UintSet {
370         Set _inner;
371     }
372 
373     /**
374      * @dev Add a value to a set. O(1).
375      *
376      * Returns true if the value was added to the set, that is if it was not
377      * already present.
378      */
379     function add(UintSet storage set, uint256 value) internal returns (bool) {
380         return _add(set._inner, bytes32(value));
381     }
382 
383     /**
384      * @dev Removes a value from a set. O(1).
385      *
386      * Returns true if the value was removed from the set, that is if it was
387      * present.
388      */
389     function remove(UintSet storage set, uint256 value) internal returns (bool) {
390         return _remove(set._inner, bytes32(value));
391     }
392 
393     /**
394      * @dev Returns true if the value is in the set. O(1).
395      */
396     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
397         return _contains(set._inner, bytes32(value));
398     }
399 
400     /**
401      * @dev Returns the number of values on the set. O(1).
402      */
403     function length(UintSet storage set) internal view returns (uint256) {
404         return _length(set._inner);
405     }
406 
407     /**
408      * @dev Returns the value stored at position `index` in the set. O(1).
409      *
410      * Note that there are no guarantees on the ordering of values inside the
411      * array, and it may change when more values are added or removed.
412      *
413      * Requirements:
414      *
415      * - `index` must be strictly less than {length}.
416      */
417     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
418         return uint256(_at(set._inner, index));
419     }
420 }
421 
422 
423 
424 
425 library AddressUpgradeable {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize, which returns 0 for contracts in
445         // construction, since the code is only stored at the end of the
446         // constructor execution.
447 
448         uint256 size;
449         // solhint-disable-next-line no-inline-assembly
450         assembly { size := extcodesize(account) }
451         return size > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
474         (bool success, ) = recipient.call{ value: amount }("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain`call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         // solhint-disable-next-line avoid-low-level-calls
536         (bool success, bytes memory returndata) = target.call{ value: value }(data);
537         return _verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = target.staticcall(data);
561         return _verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
565         if (success) {
566             return returndata;
567         } else {
568             // Look for revert reason and bubble it up if present
569             if (returndata.length > 0) {
570                 // The easiest way to bubble the revert reason is using memory via assembly
571 
572                 // solhint-disable-next-line no-inline-assembly
573                 assembly {
574                     let returndata_size := mload(returndata)
575                     revert(add(32, returndata), returndata_size)
576                 }
577             } else {
578                 revert(errorMessage);
579             }
580         }
581     }
582 }
583 
584 
585 
586 
587 abstract contract Initializable {
588 
589     /**
590      * @dev Indicates that the contract has been initialized.
591      */
592     bool private _initialized;
593 
594     /**
595      * @dev Indicates that the contract is in the process of being initialized.
596      */
597     bool private _initializing;
598 
599     /**
600      * @dev Modifier to protect an initializer function from being invoked twice.
601      */
602     modifier initializer() {
603         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
604 
605         bool isTopLevelCall = !_initializing;
606         if (isTopLevelCall) {
607             _initializing = true;
608             _initialized = true;
609         }
610 
611         _;
612 
613         if (isTopLevelCall) {
614             _initializing = false;
615         }
616     }
617 
618     /// @dev Returns true if and only if the function is running in the constructor
619     function _isConstructor() private view returns (bool) {
620         // extcodesize checks the size of the code stored in an address, and
621         // address returns the current address. Since the code is still not
622         // deployed when running a constructor, any checks on its code size will
623         // yield zero, making it an effective way to detect if a contract is
624         // under construction or not.
625         address self = address(this);
626         uint256 cs;
627         // solhint-disable-next-line no-inline-assembly
628         assembly { cs := extcodesize(self) }
629         return cs == 0;
630     }
631 }
632 
633 
634 abstract contract ContextUpgradeable is Initializable {
635     function __Context_init() internal initializer {
636         __Context_init_unchained();
637     }
638 
639     function __Context_init_unchained() internal initializer {
640     }
641     function _msgSender() internal view virtual returns (address payable) {
642         return msg.sender;
643     }
644 
645     function _msgData() internal view virtual returns (bytes memory) {
646         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
647         return msg.data;
648     }
649     uint256[50] private __gap;
650 }
651 
652 
653 
654 interface IERC20Upgradeable {
655     /**
656      * @dev Returns the amount of tokens in existence.
657      */
658     function totalSupply() external view returns (uint256);
659 
660     /**
661      * @dev Returns the amount of tokens owned by `account`.
662      */
663     function balanceOf(address account) external view returns (uint256);
664 
665     /**
666      * @dev Moves `amount` tokens from the caller's account to `recipient`.
667      *
668      * Returns a boolean value indicating whether the operation succeeded.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transfer(address recipient, uint256 amount) external returns (bool);
673 
674     /**
675      * @dev Returns the remaining number of tokens that `spender` will be
676      * allowed to spend on behalf of `owner` through {transferFrom}. This is
677      * zero by default.
678      *
679      * This value changes when {approve} or {transferFrom} are called.
680      */
681     function allowance(address owner, address spender) external view returns (uint256);
682 
683     /**
684      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
685      *
686      * Returns a boolean value indicating whether the operation succeeded.
687      *
688      * IMPORTANT: Beware that changing an allowance with this method brings the risk
689      * that someone may use both the old and the new allowance by unfortunate
690      * transaction ordering. One possible solution to mitigate this race
691      * condition is to first reduce the spender's allowance to 0 and set the
692      * desired value afterwards:
693      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address spender, uint256 amount) external returns (bool);
698 
699     /**
700      * @dev Moves `amount` tokens from `sender` to `recipient` using the
701      * allowance mechanism. `amount` is then deducted from the caller's
702      * allowance.
703      *
704      * Returns a boolean value indicating whether the operation succeeded.
705      *
706      * Emits a {Transfer} event.
707      */
708     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
709 
710     /**
711      * @dev Emitted when `value` tokens are moved from one account (`from`) to
712      * another (`to`).
713      *
714      * Note that `value` may be zero.
715      */
716     event Transfer(address indexed from, address indexed to, uint256 value);
717 
718     /**
719      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
720      * a call to {approve}. `value` is the new allowance.
721      */
722     event Approval(address indexed owner, address indexed spender, uint256 value);
723 }
724 
725 
726 
727 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
728     /**
729      * @dev Emitted when the pause is triggered by `account`.
730      */
731     event Paused(address account);
732 
733     /**
734      * @dev Emitted when the pause is lifted by `account`.
735      */
736     event Unpaused(address account);
737 
738     bool private _paused;
739 
740     /**
741      * @dev Initializes the contract in unpaused state.
742      */
743     function __Pausable_init() internal initializer {
744         __Context_init_unchained();
745         __Pausable_init_unchained();
746     }
747 
748     function __Pausable_init_unchained() internal initializer {
749         _paused = false;
750     }
751 
752     /**
753      * @dev Returns true if the contract is paused, and false otherwise.
754      */
755     function paused() public view returns (bool) {
756         return _paused;
757     }
758 
759     /**
760      * @dev Modifier to make a function callable only when the contract is not paused.
761      *
762      * Requirements:
763      *
764      * - The contract must not be paused.
765      */
766     modifier whenNotPaused() {
767         require(!_paused, "Pausable: paused");
768         _;
769     }
770 
771     /**
772      * @dev Modifier to make a function callable only when the contract is paused.
773      *
774      * Requirements:
775      *
776      * - The contract must be paused.
777      */
778     modifier whenPaused() {
779         require(_paused, "Pausable: not paused");
780         _;
781     }
782 
783     /**
784      * @dev Triggers stopped state.
785      *
786      * Requirements:
787      *
788      * - The contract must not be paused.
789      */
790     function _pause() internal virtual whenNotPaused {
791         _paused = true;
792         emit Paused(_msgSender());
793     }
794 
795     /**
796      * @dev Returns to normal state.
797      *
798      * Requirements:
799      *
800      * - The contract must be paused.
801      */
802     function _unpause() internal virtual whenPaused {
803         _paused = false;
804         emit Unpaused(_msgSender());
805     }
806     uint256[49] private __gap;
807 }
808 
809 
810 
811 
812 
813 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable {
814     using SafeMathUpgradeable for uint256;
815 
816     mapping (address => uint256) private _balances;
817 
818     mapping (address => mapping (address => uint256)) private _allowances;
819 
820     uint256 private _totalSupply;
821 
822     string private _name;
823     string private _symbol;
824     uint8 private _decimals;
825 
826     /**
827      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
828      * a default value of 18.
829      *
830      * To select a different value for {decimals}, use {_setupDecimals}.
831      *
832      * All three of these values are immutable: they can only be set once during
833      * construction.
834      */
835     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
836         __Context_init_unchained();
837         __ERC20_init_unchained(name_, symbol_);
838     }
839 
840     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
841         _name = name_;
842         _symbol = symbol_;
843         _decimals = 18;
844     }
845 
846     /**
847      * @dev Returns the name of the token.
848      */
849     function name() public view returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev Returns the symbol of the token, usually a shorter version of the
855      * name.
856      */
857     function symbol() public view returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev Returns the number of decimals used to get its user representation.
863      * For example, if `decimals` equals `2`, a balance of `505` tokens should
864      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
865      *
866      * Tokens usually opt for a value of 18, imitating the relationship between
867      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
868      * called.
869      *
870      * NOTE: This information is only used for _display_ purposes: it in
871      * no way affects any of the arithmetic of the contract, including
872      * {IERC20-balanceOf} and {IERC20-transfer}.
873      */
874     function decimals() public view returns (uint8) {
875         return _decimals;
876     }
877 
878     /**
879      * @dev See {IERC20-totalSupply}.
880      */
881     function totalSupply() public view override returns (uint256) {
882         return _totalSupply;
883     }
884 
885     /**
886      * @dev See {IERC20-balanceOf}.
887      */
888     function balanceOf(address account) public view override returns (uint256) {
889         return _balances[account];
890     }
891 
892     /**
893      * @dev See {IERC20-transfer}.
894      *
895      * Requirements:
896      *
897      * - `recipient` cannot be the zero address.
898      * - the caller must have a balance of at least `amount`.
899      */
900     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
901         _transfer(_msgSender(), recipient, amount);
902         return true;
903     }
904 
905     /**
906      * @dev See {IERC20-allowance}.
907      */
908     function allowance(address owner, address spender) public view virtual override returns (uint256) {
909         return _allowances[owner][spender];
910     }
911 
912     /**
913      * @dev See {IERC20-approve}.
914      *
915      * Requirements:
916      *
917      * - `spender` cannot be the zero address.
918      */
919     function approve(address spender, uint256 amount) public virtual override returns (bool) {
920         _approve(_msgSender(), spender, amount);
921         return true;
922     }
923 
924     /**
925      * @dev See {IERC20-transferFrom}.
926      *
927      * Emits an {Approval} event indicating the updated allowance. This is not
928      * required by the EIP. See the note at the beginning of {ERC20}.
929      *
930      * Requirements:
931      *
932      * - `sender` and `recipient` cannot be the zero address.
933      * - `sender` must have a balance of at least `amount`.
934      * - the caller must have allowance for ``sender``'s tokens of at least
935      * `amount`.
936      */
937     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
938         _transfer(sender, recipient, amount);
939         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
940         return true;
941     }
942 
943     /**
944      * @dev Atomically increases the allowance granted to `spender` by the caller.
945      *
946      * This is an alternative to {approve} that can be used as a mitigation for
947      * problems described in {IERC20-approve}.
948      *
949      * Emits an {Approval} event indicating the updated allowance.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      */
955     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
956         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
957         return true;
958     }
959 
960     /**
961      * @dev Atomically decreases the allowance granted to `spender` by the caller.
962      *
963      * This is an alternative to {approve} that can be used as a mitigation for
964      * problems described in {IERC20-approve}.
965      *
966      * Emits an {Approval} event indicating the updated allowance.
967      *
968      * Requirements:
969      *
970      * - `spender` cannot be the zero address.
971      * - `spender` must have allowance for the caller of at least
972      * `subtractedValue`.
973      */
974     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
976         return true;
977     }
978 
979     /**
980      * @dev Moves tokens `amount` from `sender` to `recipient`.
981      *
982      * This is internal function is equivalent to {transfer}, and can be used to
983      * e.g. implement automatic token fees, slashing mechanisms, etc.
984      *
985      * Emits a {Transfer} event.
986      *
987      * Requirements:
988      *
989      * - `sender` cannot be the zero address.
990      * - `recipient` cannot be the zero address.
991      * - `sender` must have a balance of at least `amount`.
992      */
993     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
994         require(sender != address(0), "ERC20: transfer from the zero address");
995         require(recipient != address(0), "ERC20: transfer to the zero address");
996 
997         _beforeTokenTransfer(sender, recipient, amount);
998 
999         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1000         _balances[recipient] = _balances[recipient].add(amount);
1001         emit Transfer(sender, recipient, amount);
1002     }
1003 
1004     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1005      * the total supply.
1006      *
1007      * Emits a {Transfer} event with `from` set to the zero address.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      */
1013     function _mint(address account, uint256 amount) internal virtual {
1014         require(account != address(0), "ERC20: mint to the zero address");
1015 
1016         _beforeTokenTransfer(address(0), account, amount);
1017 
1018         _totalSupply = _totalSupply.add(amount);
1019         _balances[account] = _balances[account].add(amount);
1020         emit Transfer(address(0), account, amount);
1021     }
1022 
1023     /**
1024      * @dev Destroys `amount` tokens from `account`, reducing the
1025      * total supply.
1026      *
1027      * Emits a {Transfer} event with `to` set to the zero address.
1028      *
1029      * Requirements:
1030      *
1031      * - `account` cannot be the zero address.
1032      * - `account` must have at least `amount` tokens.
1033      */
1034     function _burn(address account, uint256 amount) internal virtual {
1035         require(account != address(0), "ERC20: burn from the zero address");
1036 
1037         _beforeTokenTransfer(account, address(0), amount);
1038 
1039         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1040         _totalSupply = _totalSupply.sub(amount);
1041         emit Transfer(account, address(0), amount);
1042     }
1043 
1044     /**
1045      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1046      *
1047      * This internal function is equivalent to `approve`, and can be used to
1048      * e.g. set automatic allowances for certain subsystems, etc.
1049      *
1050      * Emits an {Approval} event.
1051      *
1052      * Requirements:
1053      *
1054      * - `owner` cannot be the zero address.
1055      * - `spender` cannot be the zero address.
1056      */
1057     function _approve(address owner, address spender, uint256 amount) internal virtual {
1058         require(owner != address(0), "ERC20: approve from the zero address");
1059         require(spender != address(0), "ERC20: approve to the zero address");
1060 
1061         _allowances[owner][spender] = amount;
1062         emit Approval(owner, spender, amount);
1063     }
1064 
1065     /**
1066      * @dev Sets {decimals} to a value other than the default one of 18.
1067      *
1068      * WARNING: This function should only be called from the constructor. Most
1069      * applications that interact with token contracts will not expect
1070      * {decimals} to ever change, and may work incorrectly if it does.
1071      */
1072     function _setupDecimals(uint8 decimals_) internal {
1073         _decimals = decimals_;
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any transfer of tokens. This includes
1078      * minting and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1083      * will be to transferred to `to`.
1084      * - when `from` is zero, `amount` tokens will be minted for `to`.
1085      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1086      * - `from` and `to` are never both zero.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1091     uint256[44] private __gap;
1092 }
1093 
1094 
1095 
1096 
1097 abstract contract ERC20PausableUpgradeable is Initializable, ERC20Upgradeable, PausableUpgradeable {
1098     function __ERC20Pausable_init() internal initializer {
1099         __Context_init_unchained();
1100         __Pausable_init_unchained();
1101         __ERC20Pausable_init_unchained();
1102     }
1103 
1104     function __ERC20Pausable_init_unchained() internal initializer {
1105     }
1106     /**
1107      * @dev See {ERC20-_beforeTokenTransfer}.
1108      *
1109      * Requirements:
1110      *
1111      * - the contract must not be paused.
1112      */
1113     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1114         super._beforeTokenTransfer(from, to, amount);
1115 
1116         require(!paused(), "ERC20Pausable: token transfer while paused");
1117     }
1118     uint256[50] private __gap;
1119 }
1120 
1121 
1122 
1123 
1124 
1125 abstract contract ERC20BurnableUpgradeable is Initializable, ContextUpgradeable, ERC20Upgradeable {
1126     function __ERC20Burnable_init() internal initializer {
1127         __Context_init_unchained();
1128         __ERC20Burnable_init_unchained();
1129     }
1130 
1131     function __ERC20Burnable_init_unchained() internal initializer {
1132     }
1133     using SafeMathUpgradeable for uint256;
1134 
1135     /**
1136      * @dev Destroys `amount` tokens from the caller.
1137      *
1138      * See {ERC20-_burn}.
1139      */
1140     function burn(uint256 amount) public virtual {
1141         _burn(_msgSender(), amount);
1142     }
1143 
1144     /**
1145      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1146      * allowance.
1147      *
1148      * See {ERC20-_burn} and {ERC20-allowance}.
1149      *
1150      * Requirements:
1151      *
1152      * - the caller must have allowance for ``accounts``'s tokens of at least
1153      * `amount`.
1154      */
1155     function burnFrom(address account, uint256 amount) public virtual {
1156         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1157 
1158         _approve(account, _msgSender(), decreasedAllowance);
1159         _burn(account, amount);
1160     }
1161     uint256[50] private __gap;
1162 }
1163 
1164 
1165 
1166 
1167 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable {
1168     function __AccessControl_init() internal initializer {
1169         __Context_init_unchained();
1170         __AccessControl_init_unchained();
1171     }
1172 
1173     function __AccessControl_init_unchained() internal initializer {
1174     }
1175     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
1176     using AddressUpgradeable for address;
1177 
1178     struct RoleData {
1179         EnumerableSetUpgradeable.AddressSet members;
1180         bytes32 adminRole;
1181     }
1182 
1183     mapping (bytes32 => RoleData) private _roles;
1184 
1185     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1186 
1187     /**
1188      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1189      *
1190      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1191      * {RoleAdminChanged} not being emitted signaling this.
1192      *
1193      * _Available since v3.1._
1194      */
1195     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1196 
1197     /**
1198      * @dev Emitted when `account` is granted `role`.
1199      *
1200      * `sender` is the account that originated the contract call, an admin role
1201      * bearer except when using {_setupRole}.
1202      */
1203     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1204 
1205     /**
1206      * @dev Emitted when `account` is revoked `role`.
1207      *
1208      * `sender` is the account that originated the contract call:
1209      *   - if using `revokeRole`, it is the admin role bearer
1210      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1211      */
1212     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1213 
1214     /**
1215      * @dev Returns `true` if `account` has been granted `role`.
1216      */
1217     function hasRole(bytes32 role, address account) public view returns (bool) {
1218         return _roles[role].members.contains(account);
1219     }
1220 
1221     /**
1222      * @dev Returns the number of accounts that have `role`. Can be used
1223      * together with {getRoleMember} to enumerate all bearers of a role.
1224      */
1225     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1226         return _roles[role].members.length();
1227     }
1228 
1229     /**
1230      * @dev Returns one of the accounts that have `role`. `index` must be a
1231      * value between 0 and {getRoleMemberCount}, non-inclusive.
1232      *
1233      * Role bearers are not sorted in any particular way, and their ordering may
1234      * change at any point.
1235      *
1236      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1237      * you perform all queries on the same block. See the following
1238      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1239      * for more information.
1240      */
1241     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1242         return _roles[role].members.at(index);
1243     }
1244 
1245     /**
1246      * @dev Returns the admin role that controls `role`. See {grantRole} and
1247      * {revokeRole}.
1248      *
1249      * To change a role's admin, use {_setRoleAdmin}.
1250      */
1251     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1252         return _roles[role].adminRole;
1253     }
1254 
1255     /**
1256      * @dev Grants `role` to `account`.
1257      *
1258      * If `account` had not been already granted `role`, emits a {RoleGranted}
1259      * event.
1260      *
1261      * Requirements:
1262      *
1263      * - the caller must have ``role``'s admin role.
1264      */
1265     function grantRole(bytes32 role, address account) public virtual {
1266         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1267 
1268         _grantRole(role, account);
1269     }
1270 
1271     /**
1272      * @dev Revokes `role` from `account`.
1273      *
1274      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1275      *
1276      * Requirements:
1277      *
1278      * - the caller must have ``role``'s admin role.
1279      */
1280     function revokeRole(bytes32 role, address account) public virtual {
1281         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1282 
1283         _revokeRole(role, account);
1284     }
1285 
1286     /**
1287      * @dev Revokes `role` from the calling account.
1288      *
1289      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1290      * purpose is to provide a mechanism for accounts to lose their privileges
1291      * if they are compromised (such as when a trusted device is misplaced).
1292      *
1293      * If the calling account had been granted `role`, emits a {RoleRevoked}
1294      * event.
1295      *
1296      * Requirements:
1297      *
1298      * - the caller must be `account`.
1299      */
1300     function renounceRole(bytes32 role, address account) public virtual {
1301         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1302 
1303         _revokeRole(role, account);
1304     }
1305 
1306     /**
1307      * @dev Grants `role` to `account`.
1308      *
1309      * If `account` had not been already granted `role`, emits a {RoleGranted}
1310      * event. Note that unlike {grantRole}, this function doesn't perform any
1311      * checks on the calling account.
1312      *
1313      * [WARNING]
1314      * ====
1315      * This function should only be called from the constructor when setting
1316      * up the initial roles for the system.
1317      *
1318      * Using this function in any other way is effectively circumventing the admin
1319      * system imposed by {AccessControl}.
1320      * ====
1321      */
1322     function _setupRole(bytes32 role, address account) internal virtual {
1323         _grantRole(role, account);
1324     }
1325 
1326     /**
1327      * @dev Sets `adminRole` as ``role``'s admin role.
1328      *
1329      * Emits a {RoleAdminChanged} event.
1330      */
1331     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1332         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1333         _roles[role].adminRole = adminRole;
1334     }
1335 
1336     function _grantRole(bytes32 role, address account) private {
1337         if (_roles[role].members.add(account)) {
1338             emit RoleGranted(role, account, _msgSender());
1339         }
1340     }
1341 
1342     function _revokeRole(bytes32 role, address account) private {
1343         if (_roles[role].members.remove(account)) {
1344             emit RoleRevoked(role, account, _msgSender());
1345         }
1346     }
1347     uint256[49] private __gap;
1348 }
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 
1364 /**
1365  * @dev Collection of functions related to the address type
1366  */
1367 library Address {
1368     /**
1369      * @dev Returns true if `account` is a contract.
1370      *
1371      * [IMPORTANT]
1372      * ====
1373      * It is unsafe to assume that an address for which this function returns
1374      * false is an externally-owned account (EOA) and not a contract.
1375      *
1376      * Among others, `isContract` will return false for the following
1377      * types of addresses:
1378      *
1379      *  - an externally-owned account
1380      *  - a contract in construction
1381      *  - an address where a contract will be created
1382      *  - an address where a contract lived, but was destroyed
1383      * ====
1384      */
1385     function isContract(address account) internal view returns (bool) {
1386         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1387         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1388         // for accounts without code, i.e. `keccak256('')`
1389         bytes32 codehash;
1390         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1391         // solhint-disable-next-line no-inline-assembly
1392         assembly { codehash := extcodehash(account) }
1393         return (codehash != accountHash && codehash != 0x0);
1394     }
1395 
1396     /**
1397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1398      * `recipient`, forwarding all available gas and reverting on errors.
1399      *
1400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1402      * imposed by `transfer`, making them unable to receive funds via
1403      * `transfer`. {sendValue} removes this limitation.
1404      *
1405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1406      *
1407      * IMPORTANT: because control is transferred to `recipient`, care must be
1408      * taken to not create reentrancy vulnerabilities. Consider using
1409      * {ReentrancyGuard} or the
1410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1411      */
1412     function sendValue(address payable recipient, uint256 amount) internal {
1413         require(address(this).balance >= amount, "Address: insufficient balance");
1414 
1415         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1416         (bool success, ) = recipient.call{ value: amount }("");
1417         require(success, "Address: unable to send value, recipient may have reverted");
1418     }
1419 }
1420 
1421 
1422 
1423 /**
1424  * @title Proxy
1425  * @dev Implements delegation of calls to other contracts, with proper
1426  * forwarding of return values and bubbling of failures.
1427  * It defines a fallback function that delegates all calls to the address
1428  * returned by the abstract _implementation() internal function.
1429  */
1430 abstract contract Proxy {
1431 /**
1432  * @dev Fallback function.
1433  * Implemented entirely in `_fallback`.
1434  */
1435 fallback () payable external {
1436 _fallback();
1437 }
1438 
1439 /**
1440  * @return The Address of the implementation.
1441  */
1442 function _implementation() internal virtual view returns (address);
1443 
1444 /**
1445  * @dev Delegates execution to an implementation contract.
1446  * This is a low level function that doesn't return to its internal call site.
1447  * It will return to the external caller whatever the implementation returns.
1448  * @param implementation Address to delegate.
1449  */
1450 function _delegate(address implementation) internal {
1451 assembly {
1452 // Copy msg.data. We take full control of memory in this inline assembly
1453 // block because it will not return to Solidity code. We overwrite the
1454 // Solidity scratch pad at memory position 0.
1455 calldatacopy(0, 0, calldatasize())
1456 
1457 // Call the implementation.
1458 // out and outsize are 0 because we don't know the size yet.
1459 let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
1460 
1461 // Copy the returned data.
1462 returndatacopy(0, 0, returndatasize())
1463 
1464 switch result
1465 // delegatecall returns 0 on error.
1466 case 0 { revert(0, returndatasize()) }
1467 default { return(0, returndatasize()) }
1468 }
1469 }
1470 
1471 /**
1472  * @dev Function that is run as the first thing in the fallback function.
1473  * Can be redefined in derived contracts to add functionality.
1474  * Redefinitions must call super._willFallback().
1475  */
1476 function _willFallback() internal virtual {
1477 }
1478 
1479 /**
1480  * @dev fallback implementation.
1481  * Extracted to enable manual triggering.
1482  */
1483 function _fallback() internal {
1484 _willFallback();
1485 _delegate(_implementation());
1486 }
1487 }
1488 
1489 
1490 
1491 /**
1492  * @title BaseUpgradeabilityProxy
1493  * @dev This contract implements a proxy that allows to change the
1494  * implementation address to which it will delegate.
1495  * Such a change is called an implementation upgrade.
1496  */
1497 contract BaseUpgradeabilityProxy is Proxy {
1498 /**
1499  * @dev Emitted when the implementation is upgraded.
1500  * @param implementation Address of the new implementation.
1501  */
1502 event Upgraded(address indexed implementation);
1503 
1504 /**
1505  * @dev Storage slot with the address of the current implementation.
1506  * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
1507  * validated in the constructor.
1508  */
1509 bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1510 
1511 /**
1512  * @dev Returns the current implementation.
1513  * @return impl Address of the current implementation
1514  */
1515 function _implementation() internal override view returns (address impl) {
1516 bytes32 slot = IMPLEMENTATION_SLOT;
1517 assembly {
1518 impl := sload(slot)
1519 }
1520 }
1521 
1522 /**
1523  * @dev Upgrades the proxy to a new implementation.
1524  * @param newImplementation Address of the new implementation.
1525  */
1526 function _upgradeTo(address newImplementation) internal {
1527 _setImplementation(newImplementation);
1528 emit Upgraded(newImplementation);
1529 }
1530 
1531 /**
1532  * @dev Sets the implementation address of the proxy.
1533  * @param newImplementation Address of the new implementation.
1534  */
1535 function _setImplementation(address newImplementation) internal {
1536 require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
1537 
1538 bytes32 slot = IMPLEMENTATION_SLOT;
1539 
1540 assembly {
1541 sstore(slot, newImplementation)
1542 }
1543 }
1544 }
1545 
1546 
1547 
1548 
1549 
1550 
1551 /**
1552  * @title UpgradeabilityProxy
1553  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
1554  * implementation and init data.
1555  */
1556 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
1557 /**
1558  * @dev Contract constructor.
1559  * @param _logic Address of the initial implementation.
1560  * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1561  * It should include the signature and the parameters of the function to be called, as described in
1562  * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1563  * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1564  */
1565 constructor(address _logic, bytes memory _data) public payable {
1566 assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
1567 _setImplementation(_logic);
1568 if(_data.length > 0) {
1569 (bool success,) = _logic.delegatecall(_data);
1570 require(success);
1571 }
1572 }
1573 }
1574 
1575 
1576 
1577 
1578 /**
1579  * @title BaseAdminUpgradeabilityProxy
1580  * @dev This contract combines an upgradeability proxy with an authorization
1581  * mechanism for administrative tasks.
1582  * All external functions in this contract must be guarded by the
1583  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
1584  * feature proposal that would enable this to be done automatically.
1585  */
1586 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
1587 /**
1588  * @dev Emitted when the administration has been transferred.
1589  * @param previousAdmin Address of the previous admin.
1590  * @param newAdmin Address of the new admin.
1591  */
1592 event AdminChanged(address previousAdmin, address newAdmin);
1593 
1594 /**
1595  * @dev Storage slot with the admin of the contract.
1596  * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
1597  * validated in the constructor.
1598  */
1599 
1600 bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1601 
1602 /**
1603  * @dev Modifier to check whether the `msg.sender` is the admin.
1604  * If it is, it will run the function. Otherwise, it will delegate the call
1605  * to the implementation.
1606  */
1607 modifier ifAdmin() {
1608 if (msg.sender == _admin()) {
1609 _;
1610 } else {
1611 _fallback();
1612 }
1613 }
1614 
1615 /**
1616  * @return The address of the proxy admin.
1617  */
1618 function admin() external ifAdmin returns (address) {
1619 return _admin();
1620 }
1621 
1622 /**
1623  * @return The address of the implementation.
1624  */
1625 function implementation() external ifAdmin returns (address) {
1626 return _implementation();
1627 }
1628 
1629 /**
1630  * @dev Changes the admin of the proxy.
1631  * Only the current admin can call this function.
1632  * @param newAdmin Address to transfer proxy administration to.
1633  */
1634 function changeAdmin(address newAdmin) external ifAdmin {
1635 require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
1636 emit AdminChanged(_admin(), newAdmin);
1637 _setAdmin(newAdmin);
1638 }
1639 
1640 /**
1641  * @dev Upgrade the backing implementation of the proxy.
1642  * Only the admin can call this function.
1643  * @param newImplementation Address of the new implementation.
1644  */
1645 function upgradeTo(address newImplementation) external ifAdmin {
1646 _upgradeTo(newImplementation);
1647 }
1648 
1649 /**
1650  * @dev Upgrade the backing implementation of the proxy and call a function
1651  * on the new implementation.
1652  * This is useful to initialize the proxied contract.
1653  * @param newImplementation Address of the new implementation.
1654  * @param data Data to send as msg.data in the low level call.
1655  * It should include the signature and the parameters of the function to be called, as described in
1656  * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1657  */
1658 function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
1659 _upgradeTo(newImplementation);
1660 (bool success,) = newImplementation.delegatecall(data);
1661 require(success);
1662 }
1663 
1664 /**
1665  * @return adm The admin slot.
1666  */
1667 function _admin() internal view returns (address adm) {
1668 bytes32 slot = ADMIN_SLOT;
1669 assembly {
1670 adm := sload(slot)
1671 }
1672 }
1673 
1674 /**
1675  * @dev Sets the address of the proxy admin.
1676  * @param newAdmin Address of the new proxy admin.
1677  */
1678 function _setAdmin(address newAdmin) internal {
1679 bytes32 slot = ADMIN_SLOT;
1680 
1681 assembly {
1682 sstore(slot, newAdmin)
1683 }
1684 }
1685 
1686 /**
1687  * @dev Only fall back when the sender is not the admin.
1688  */
1689 function _willFallback() internal override virtual {
1690 require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
1691 super._willFallback();
1692 }
1693 }
1694 
1695 
1696 
1697 
1698 
1699 /**
1700  * @title InitializableUpgradeabilityProxy
1701  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
1702  * implementation and init data.
1703  */
1704 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
1705 /**
1706 * @dev Contract initializer.
1707 * @param _logic Address of the initial implementation.
1708 * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1709 * It should include the signature and the parameters of the function to be called, as described in
1710 * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1711 * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1712 */
1713 function initialize(address _logic, bytes memory _data) public payable {
1714 require(_implementation() == address(0));
1715 assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
1716 _setImplementation(_logic);
1717 if (_data.length > 0) {
1718 (bool success, ) = _logic.delegatecall(_data);
1719 require(success);
1720 }
1721 }
1722 }
1723 
1724 
1725 
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 contract PUNDIXTokenProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
1734 /**
1735 * Contract initializer.
1736 * @param _logic address of the initial implementation.
1737 * @param _admin Address of the proxy administrator.
1738 * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1739 * It should include the signature and the parameters of the function to be called, as described in
1740 * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1741 * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1742 */
1743 function initialize(address _logic, address _admin, bytes memory _data) public payable {
1744 require(_implementation() == address(0));
1745 InitializableUpgradeabilityProxy.initialize(_logic, _data);
1746 assert(ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
1747 _setAdmin(_admin);
1748 }
1749 
1750 /**
1751 * @dev Only fall back when the sender is not the admin.
1752 */
1753 function _willFallback() internal override(BaseAdminUpgradeabilityProxy, Proxy) {
1754 BaseAdminUpgradeabilityProxy._willFallback();
1755 }
1756 
1757 }
1758 
1759 
1760 
1761 
1762 
1763 
1764 library ECDSAUpgradeable {
1765 /**
1766  * @dev Returns the address that signed a hashed message (`hash`) with
1767  * `signature`. This address can then be used for verification purposes.
1768  *
1769  * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1770  * this function rejects them by requiring the `s` value to be in the lower
1771  * half order, and the `v` value to be either 27 or 28.
1772  *
1773  * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1774  * verification to be secure: it is possible to craft signatures that
1775  * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1776  * this is by receiving a hash of the original message (which may otherwise
1777  * be too long), and then calling {toEthSignedMessageHash} on it.
1778  */
1779 function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1780 // Check the signature length
1781 if (signature.length != 65) {
1782 revert("ECDSA: invalid signature length");
1783 }
1784 
1785 // Divide the signature in r, s and v variables
1786 bytes32 r;
1787 bytes32 s;
1788 uint8 v;
1789 
1790 // ecrecover takes the signature parameters, and the only way to get them
1791 // currently is to use assembly.
1792 // solhint-disable-next-line no-inline-assembly
1793 assembly {
1794 r := mload(add(signature, 0x20))
1795 s := mload(add(signature, 0x40))
1796 v := byte(0, mload(add(signature, 0x60)))
1797 }
1798 
1799 return recover(hash, v, r, s);
1800 }
1801 
1802 /**
1803  * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
1804  * `r` and `s` signature fields separately.
1805  */
1806 function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1807 // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1808 // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1809 // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1810 // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1811 //
1812 // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1813 // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1814 // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1815 // these malleable signatures as well.
1816 require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
1817 require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1818 
1819 // If the signature is valid (and not malleable), return the signer address
1820 address signer = ecrecover(hash, v, r, s);
1821 require(signer != address(0), "ECDSA: invalid signature");
1822 
1823 return signer;
1824 }
1825 
1826 /**
1827  * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1828  * replicates the behavior of the
1829  * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1830  * JSON-RPC method.
1831  *
1832  * See {recover}.
1833  */
1834 function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1835 // 32 is the length in bytes of hash,
1836 // enforced by the type signature above
1837 return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1838 }
1839 }
1840 
1841 
1842 
1843 library CountersUpgradeable {
1844 using SafeMathUpgradeable for uint256;
1845 
1846 struct Counter {
1847 // This variable should never be directly accessed by users of the library: interactions must be restricted to
1848 // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1849 // this feature: see https://github.com/ethereum/solidity/issues/4637
1850 uint256 _value; // default: 0
1851 }
1852 
1853 function current(Counter storage counter) internal view returns (uint256) {
1854 return counter._value;
1855 }
1856 
1857 function increment(Counter storage counter) internal {
1858 // The {SafeMath} overflow check can be skipped here, see the comment at the top
1859 counter._value += 1;
1860 }
1861 
1862 function decrement(Counter storage counter) internal {
1863 counter._value = counter._value.sub(1);
1864 }
1865 }
1866 
1867 
1868 
1869 abstract contract EIP712Upgradeable is Initializable {
1870 /* solhint-disable var-name-mixedcase */
1871 bytes32 private _HASHED_NAME;
1872 bytes32 private _HASHED_VERSION;
1873 bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1874 /* solhint-enable var-name-mixedcase */
1875 
1876 /**
1877  * @dev Initializes the domain separator and parameter caches.
1878  *
1879  * The meaning of `name` and `version` is specified in
1880  * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1881  *
1882  * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1883  * - `version`: the current major version of the signing domain.
1884  *
1885  * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1886  * contract upgrade].
1887  */
1888 function __EIP712_init(string memory name, string memory version) internal initializer {
1889 __EIP712_init_unchained(name, version);
1890 }
1891 
1892 function __EIP712_init_unchained(string memory name, string memory version) internal initializer {
1893 bytes32 hashedName = keccak256(bytes(name));
1894 bytes32 hashedVersion = keccak256(bytes(version));
1895 _HASHED_NAME = hashedName;
1896 _HASHED_VERSION = hashedVersion;
1897 }
1898 
1899 /**
1900  * @dev Returns the domain separator for the current chain.
1901  */
1902 function _domainSeparatorV4() internal view returns (bytes32) {
1903 return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
1904 }
1905 
1906 function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1907 return keccak256(
1908 abi.encode(
1909 typeHash,
1910 name,
1911 version,
1912 _getChainId(),
1913 address(this)
1914 )
1915 );
1916 }
1917 
1918 /**
1919  * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1920  * function returns the hash of the fully encoded EIP712 message for this domain.
1921  *
1922  * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1923  *
1924  * ```solidity
1925  * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1926  *     keccak256("Mail(address to,string contents)"),
1927  *     mailTo,
1928  *     keccak256(bytes(mailContents))
1929  * )));
1930  * address signer = ECDSA.recover(digest, signature);
1931  * ```
1932  */
1933 function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1934 return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
1935 }
1936 
1937 function _getChainId() private view returns (uint256 chainId) {
1938 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1939 // solhint-disable-next-line no-inline-assembly
1940 assembly {
1941 chainId := chainid()
1942 }
1943 }
1944 
1945 /**
1946  * @dev The hash of the name parameter for the EIP712 domain.
1947  *
1948  * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1949  * are a concern.
1950  */
1951 function _EIP712NameHash() internal virtual view returns (bytes32) {
1952 return _HASHED_NAME;
1953 }
1954 
1955 /**
1956  * @dev The hash of the version parameter for the EIP712 domain.
1957  *
1958  * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1959  * are a concern.
1960  */
1961 function _EIP712VersionHash() internal virtual view returns (bytes32) {
1962 return _HASHED_VERSION;
1963 }
1964 uint256[50] private __gap;
1965 }
1966 
1967 
1968 
1969 interface IERC20PermitUpgradeable {
1970 /**
1971  * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
1972  * given `owner`'s signed approval.
1973  *
1974  * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1975  * ordering also apply here.
1976  *
1977  * Emits an {Approval} event.
1978  *
1979  * Requirements:
1980  *
1981  * - `spender` cannot be the zero address.
1982  * - `deadline` must be a timestamp in the future.
1983  * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1984  * over the EIP712-formatted function arguments.
1985  * - the signature must use ``owner``'s current nonce (see {nonces}).
1986  *
1987  * For more information on the signature format, see the
1988  * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1989  * section].
1990  */
1991 function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
1992 
1993 /**
1994  * @dev Returns the current nonce for `owner`. This value must be
1995  * included whenever a signature is generated for {permit}.
1996  *
1997  * Every successful call to {permit} increases ``owner``'s nonce by one. This
1998  * prevents a signature from being used multiple times.
1999  */
2000 function nonces(address owner) external view returns (uint256);
2001 
2002 /**
2003  * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
2004  */
2005 // solhint-disable-next-line func-name-mixedcase
2006 function DOMAIN_SEPARATOR() external view returns (bytes32);
2007 }
2008 
2009 
2010 
2011 abstract contract ERC20PermitUpgradeable is Initializable, ERC20Upgradeable, IERC20PermitUpgradeable, EIP712Upgradeable {
2012 using CountersUpgradeable for CountersUpgradeable.Counter;
2013 
2014 mapping (address => CountersUpgradeable.Counter) private _nonces;
2015 
2016 // solhint-disable-next-line var-name-mixedcase
2017 bytes32 private _PERMIT_TYPEHASH;
2018 
2019 /**
2020  * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
2021  *
2022  * It's a good idea to use the same `name` that is defined as the ERC20 token name.
2023  */
2024 function __ERC20Permit_init(string memory name) internal initializer {
2025 __Context_init_unchained();
2026 __EIP712_init_unchained(name, "1");
2027 __ERC20Permit_init_unchained(name);
2028 }
2029 
2030 function __ERC20Permit_init_unchained(string memory name) internal initializer {
2031 _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
2032 }
2033 
2034 /**
2035  * @dev See {IERC20Permit-permit}.
2036  */
2037 function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
2038 // solhint-disable-next-line not-rely-on-time
2039 require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
2040 
2041 bytes32 structHash = keccak256(
2042 abi.encode(
2043 _PERMIT_TYPEHASH,
2044 owner,
2045 spender,
2046 value,
2047 _nonces[owner].current(),
2048 deadline
2049 )
2050 );
2051 
2052 bytes32 hash = _hashTypedDataV4(structHash);
2053 
2054 address signer = ECDSAUpgradeable.recover(hash, v, r, s);
2055 require(signer == owner, "ERC20Permit: invalid signature");
2056 
2057 _nonces[owner].increment();
2058 _approve(owner, spender, value);
2059 }
2060 
2061 /**
2062  * @dev See {IERC20Permit-nonces}.
2063  */
2064 function nonces(address owner) public view override returns (uint256) {
2065 return _nonces[owner].current();
2066 }
2067 
2068 /**
2069  * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
2070  */
2071 // solhint-disable-next-line func-name-mixedcase
2072 function DOMAIN_SEPARATOR() external view override returns (bytes32) {
2073 return _domainSeparatorV4();
2074 }
2075 uint256[49] private __gap;
2076 }
2077 
2078 
2079 
2080 
2081 
2082 
2083 
2084 
2085 
2086 contract TokenRecipient {
2087 
2088     function tokenFallback(address _sender, uint256 _value, bytes memory _extraData) public virtual returns (bool) {}
2089 
2090 }
2091 
2092 
2093 
2094 
2095 contract PUNDIXToken is Initializable, ContextUpgradeable, AccessControlUpgradeable, ERC20BurnableUpgradeable, ERC20PausableUpgradeable, ERC20PermitUpgradeable {
2096 
2097 
2098     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2099 
2100 
2101 
2102     function initialize(address to) public virtual initializer {
2103         __Context_init_unchained();
2104         __AccessControl_init_unchained();
2105         __ERC20_init_unchained("Pundi X Token", "PUNDIX");
2106         __ERC20Burnable_init_unchained();
2107         __Pausable_init_unchained();
2108         __ERC20Pausable_init_unchained();
2109         __ERC20Permit_init("PUNDIX");
2110 
2111         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2112         _setupRole(ADMIN_ROLE, _msgSender());
2113 
2114         _mint(to, 258498693019069996455928086);
2115     }
2116 
2117 
2118 
2119 
2120     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20PausableUpgradeable) {
2121         super._beforeTokenTransfer(from, to, amount);
2122     }
2123 
2124 
2125 
2126     function pause() public virtual {
2127         require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role to pause");
2128         _pause();
2129     }
2130 
2131     function unpause() public virtual {
2132         require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role to unpause");
2133         _unpause();
2134     }
2135 
2136 
2137 
2138 
2139     function transferERCToken(address tokenContractAddress, address to, uint256 amount) public {
2140         require(hasRole(ADMIN_ROLE, _msgSender()), "must have admin role to transfer other ERC20");
2141         require(IERC20Upgradeable(tokenContractAddress).transfer(to, amount));
2142     }
2143 
2144 
2145     function transferAndCall(address recipient, uint256 amount, bytes memory data) public {
2146         require(recipient != address(0), "transfer to the zero address");
2147         require(amount <= balanceOf(recipient), "insufficient balance");
2148         transfer(recipient, amount);
2149         require(TokenRecipient(recipient).tokenFallback(msg.sender, amount, data));
2150     }
2151 }