1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.4;
5 
6 library EnumerableSet {
7     // To implement this library for multiple types with as little code
8     // repetition as possible, we write it in terms of a generic Set type with
9     // bytes32 values.
10     // The Set implementation uses private functions, and user-facing
11     // implementations (such as AddressSet) are just wrappers around the
12     // underlying Set.
13     // This means that we can only create new EnumerableSets for types that fit
14     // in bytes32.
15 
16     struct Set {
17         // Storage of set values
18         bytes32[] _values;
19 
20         // Position of the value in the `values` array, plus 1 because index 0
21         // means a value is not in the set.
22         mapping (bytes32 => uint256) _indexes;
23     }
24 
25     /**
26      * @dev Add a value to a set. O(1).
27      *
28      * Returns true if the value was added to the set, that is if it was not
29      * already present.
30      */
31     function _add(Set storage set, bytes32 value) private returns (bool) {
32         if (!_contains(set, value)) {
33             set._values.push(value);
34             // The value is stored at length-1, but we add 1 to all indexes
35             // and use 0 as a sentinel value
36             set._indexes[value] = set._values.length;
37             return true;
38         } else {
39             return false;
40         }
41     }
42 
43     /**
44      * @dev Removes a value from a set. O(1).
45      *
46      * Returns true if the value was removed from the set, that is if it was
47      * present.
48      */
49     function _remove(Set storage set, bytes32 value) private returns (bool) {
50         // We read and store the value's index to prevent multiple reads from the same storage slot
51         uint256 valueIndex = set._indexes[value];
52 
53         if (valueIndex != 0) { // Equivalent to contains(set, value)
54             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
55             // the array, and then remove the last element (sometimes called as 'swap and pop').
56             // This modifies the order of the array, as noted in {at}.
57 
58             uint256 toDeleteIndex = valueIndex - 1;
59             uint256 lastIndex = set._values.length - 1;
60 
61             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
62             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
63 
64             bytes32 lastvalue = set._values[lastIndex];
65 
66             // Move the last value to the index where the value to delete is
67             set._values[toDeleteIndex] = lastvalue;
68             // Update the index for the moved value
69             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
70 
71             // Delete the slot where the moved value was stored
72             set._values.pop();
73 
74             // Delete the index for the deleted slot
75             delete set._indexes[value];
76 
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     /**
84      * @dev Returns true if the value is in the set. O(1).
85      */
86     function _contains(Set storage set, bytes32 value) private view returns (bool) {
87         return set._indexes[value] != 0;
88     }
89 
90     /**
91      * @dev Returns the number of values on the set. O(1).
92      */
93     function _length(Set storage set) private view returns (uint256) {
94         return set._values.length;
95     }
96 
97    /**
98     * @dev Returns the value stored at position `index` in the set. O(1).
99     *
100     * Note that there are no guarantees on the ordering of values inside the
101     * array, and it may change when more values are added or removed.
102     *
103     * Requirements:
104     *
105     * - `index` must be strictly less than {length}.
106     */
107     function _at(Set storage set, uint256 index) private view returns (bytes32) {
108         require(set._values.length > index, "EnumerableSet: index out of bounds");
109         return set._values[index];
110     }
111 
112     // Bytes32Set
113 
114     struct Bytes32Set {
115         Set _inner;
116     }
117 
118     /**
119      * @dev Add a value to a set. O(1).
120      *
121      * Returns true if the value was added to the set, that is if it was not
122      * already present.
123      */
124     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
125         return _add(set._inner, value);
126     }
127 
128     /**
129      * @dev Removes a value from a set. O(1).
130      *
131      * Returns true if the value was removed from the set, that is if it was
132      * present.
133      */
134     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
135         return _remove(set._inner, value);
136     }
137 
138     /**
139      * @dev Returns true if the value is in the set. O(1).
140      */
141     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
142         return _contains(set._inner, value);
143     }
144 
145     /**
146      * @dev Returns the number of values in the set. O(1).
147      */
148     function length(Bytes32Set storage set) internal view returns (uint256) {
149         return _length(set._inner);
150     }
151 
152    /**
153     * @dev Returns the value stored at position `index` in the set. O(1).
154     *
155     * Note that there are no guarantees on the ordering of values inside the
156     * array, and it may change when more values are added or removed.
157     *
158     * Requirements:
159     *
160     * - `index` must be strictly less than {length}.
161     */
162     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
163         return _at(set._inner, index);
164     }
165 
166     // AddressSet
167 
168     struct AddressSet {
169         Set _inner;
170     }
171 
172     /**
173      * @dev Add a value to a set. O(1).
174      *
175      * Returns true if the value was added to the set, that is if it was not
176      * already present.
177      */
178     function add(AddressSet storage set, address value) internal returns (bool) {
179         return _add(set._inner, bytes32(uint256(uint160(value))));
180     }
181 
182     /**
183      * @dev Removes a value from a set. O(1).
184      *
185      * Returns true if the value was removed from the set, that is if it was
186      * present.
187      */
188     function remove(AddressSet storage set, address value) internal returns (bool) {
189         return _remove(set._inner, bytes32(uint256(uint160(value))));
190     }
191 
192     /**
193      * @dev Returns true if the value is in the set. O(1).
194      */
195     function contains(AddressSet storage set, address value) internal view returns (bool) {
196         return _contains(set._inner, bytes32(uint256(uint160(value))));
197     }
198 
199     /**
200      * @dev Returns the number of values in the set. O(1).
201      */
202     function length(AddressSet storage set) internal view returns (uint256) {
203         return _length(set._inner);
204     }
205 
206    /**
207     * @dev Returns the value stored at position `index` in the set. O(1).
208     *
209     * Note that there are no guarantees on the ordering of values inside the
210     * array, and it may change when more values are added or removed.
211     *
212     * Requirements:
213     *
214     * - `index` must be strictly less than {length}.
215     */
216     function at(AddressSet storage set, uint256 index) internal view returns (address) {
217         return address(uint160(uint256(_at(set._inner, index))));
218     }
219 
220 
221     // UintSet
222 
223     struct UintSet {
224         Set _inner;
225     }
226 
227     /**
228      * @dev Add a value to a set. O(1).
229      *
230      * Returns true if the value was added to the set, that is if it was not
231      * already present.
232      */
233     function add(UintSet storage set, uint256 value) internal returns (bool) {
234         return _add(set._inner, bytes32(value));
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the value was removed from the set, that is if it was
241      * present.
242      */
243     function remove(UintSet storage set, uint256 value) internal returns (bool) {
244         return _remove(set._inner, bytes32(value));
245     }
246 
247     /**
248      * @dev Returns true if the value is in the set. O(1).
249      */
250     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
251         return _contains(set._inner, bytes32(value));
252     }
253 
254     /**
255      * @dev Returns the number of values on the set. O(1).
256      */
257     function length(UintSet storage set) internal view returns (uint256) {
258         return _length(set._inner);
259     }
260 
261    /**
262     * @dev Returns the value stored at position `index` in the set. O(1).
263     *
264     * Note that there are no guarantees on the ordering of values inside the
265     * array, and it may change when more values are added or removed.
266     *
267     * Requirements:
268     *
269     * - `index` must be strictly less than {length}.
270     */
271     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
272         return uint256(_at(set._inner, index));
273     }
274 }
275     
276     abstract contract ReentrancyGuard {
277 
278     uint256 private constant _NOT_ENTERED = 1;
279     uint256 private constant _ENTERED = 2;
280 
281     uint256 private _status;
282 
283     constructor () {
284         _status = _NOT_ENTERED;
285     }
286 
287     modifier nonReentrant() {
288 
289         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
290 
291         _status = _ENTERED;
292 
293         _;
294 
295         _status = _NOT_ENTERED;
296     }
297 }
298 
299 
300 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
301 
302 /**
303  * @dev Interface of the ERC20 standard as defined in the EIP.
304  */
305 interface IERC20 {
306     /**
307      * @dev Returns the amount of tokens in existence.
308      */
309     function totalSupply() external view returns (uint256);
310 
311     /**
312      * @dev Returns the amount of tokens owned by `account`.
313      */
314     function balanceOf(address account) external view returns (uint256);
315 
316     /**
317      * @dev Moves `amount` tokens from the caller's account to `recipient`.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transfer(address recipient, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Returns the remaining number of tokens that `spender` will be
327      * allowed to spend on behalf of `owner` through {transferFrom}. This is
328      * zero by default.
329      *
330      * This value changes when {approve} or {transferFrom} are called.
331      */
332     function allowance(address owner, address spender) external view returns (uint256);
333 
334     /**
335      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
336      *
337      * Returns a boolean value indicating whether the operation succeeded.
338      *
339      * IMPORTANT: Beware that changing an allowance with this method brings the risk
340      * that someone may use both the old and the new allowance by unfortunate
341      * transaction ordering. One possible solution to mitigate this race
342      * condition is to first reduce the spender's allowance to 0 and set the
343      * desired value afterwards:
344      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
345      *
346      * Emits an {Approval} event.
347      */
348     function approve(address spender, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Moves `amount` tokens from `sender` to `recipient` using the
352      * allowance mechanism. `amount` is then deducted from the caller's
353      * allowance.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Emitted when `value` tokens are moved from one account (`from`) to
363      * another (`to`).
364      *
365      * Note that `value` may be zero.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 value);
368 
369     /**
370      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
371      * a call to {approve}. `value` is the new allowance.
372      */
373     event Approval(address indexed owner, address indexed spender, uint256 value);
374 }
375 
376 interface ERC20 {
377     function totalSupply() external returns (uint);
378     function balanceOf(address who) external returns (uint);
379     function transferFrom(address from, address to, uint value) external;
380     function transfer(address to, uint value) external;
381     event Transfer(address indexed from, address indexed to, uint value);
382 }
383 
384 
385 /**
386  * @dev Collection of functions related to the address type
387  */
388 library Address {
389     /**
390      * @dev Returns true if `account` is a contract.
391      *
392      * [IMPORTANT]
393      * ====
394      * It is unsafe to assume that an address for which this function returns
395      * false is an externally-owned account (EOA) and not a contract.
396      *
397      * Among others, `isContract` will return false for the following
398      * types of addresses:
399      *
400      *  - an externally-owned account
401      *  - a contract in construction
402      *  - an address where a contract will be created
403      *  - an address where a contract lived, but was destroyed
404      * ====
405      */
406     function isContract(address account) internal view returns (bool) {
407         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
408         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
409         // for accounts without code, i.e. `keccak256('')`
410         bytes32 codehash;
411         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
412         // solhint-disable-next-line no-inline-assembly
413         assembly { codehash := extcodehash(account) }
414         return (codehash != accountHash && codehash != 0x0);
415     }
416     
417     
418     /**
419      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
420      * `recipient`, forwarding all available gas and reverting on errors.
421      *
422      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
423      * of certain opcodes, possibly making contracts go over the 2300 gas limit
424      * imposed by `transfer`, making them unable to receive funds via
425      * `transfer`. {sendValue} removes this limitation.
426      *
427      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
428      *
429      * IMPORTANT: because control is transferred to `recipient`, care must be
430      * taken to not create reentrancy vulnerabilities. Consider using
431      * {ReentrancyGuard} or the
432      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
433      */
434     function sendValue(address payable recipient, uint256 amount) internal {
435         require(address(this).balance >= amount, "Address: insufficient balance");
436 
437         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
438         (bool success, ) = recipient.call{ value: amount }("");
439         require(success, "Address: unable to send value, recipient may have reverted");
440     }
441 
442     /**
443      * @dev Performs a Solidity function call using a low level `call`. A
444      * plain`call` is an unsafe replacement for a function call: use this
445      * function instead.
446      *
447      * If `target` reverts with a revert reason, it is bubbled up by this
448      * function (like regular Solidity function calls).
449      *
450      * Returns the raw returned data. To convert to the expected return value,
451      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
452      *
453      * Requirements:
454      *
455      * - `target` must be a contract.
456      * - calling `target` with `data` must not revert.
457      *
458      * _Available since v3.1._
459      */
460     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
461       return functionCall(target, data, "Address: low-level call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
466      * `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
471         return _functionCallWithValue(target, data, 0, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but also transferring `value` wei to `target`.
477      *
478      * Requirements:
479      *
480      * - the calling contract must have an ETH balance of at least `value`.
481      * - the called Solidity function must be `payable`.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
491      * with `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
496         require(address(this).balance >= value, "Address: insufficient balance for call");
497         return _functionCallWithValue(target, data, value, errorMessage);
498     }
499 
500     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
501         require(isContract(target), "Address: call to non-contract");
502 
503         // solhint-disable-next-line avoid-low-level-calls
504         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 // solhint-disable-next-line no-inline-assembly
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 library SafeMath {
525     /**
526      * @dev Returns the addition of two unsigned integers, reverting on
527      * overflow.
528      *
529      * Counterpart to Solidity's `+` operator.
530      *
531      * Requirements:
532      *
533      * - Addition cannot overflow.
534      */
535     function add(uint256 a, uint256 b) internal pure returns (uint256) {
536         uint256 c = a + b;
537         require(c >= a, "SafeMath: addition overflow");
538 
539         return c;
540     }
541 
542     /**
543      * @dev Returns the subtraction of two unsigned integers, reverting on
544      * overflow (when the result is negative).
545      *
546      * Counterpart to Solidity's `-` operator.
547      *
548      * Requirements:
549      *
550      * - Subtraction cannot overflow.
551      */
552     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
553         return sub(a, b, "SafeMath: subtraction overflow");
554     }
555 
556     /**
557      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
558      * overflow (when the result is negative).
559      *
560      * Counterpart to Solidity's `-` operator.
561      *
562      * Requirements:
563      *
564      * - Subtraction cannot overflow.
565      */
566     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
567         require(b <= a, errorMessage);
568         uint256 c = a - b;
569 
570         return c;
571     }
572 
573     /**
574      * @dev Returns the multiplication of two unsigned integers, reverting on
575      * overflow.
576      *
577      * Counterpart to Solidity's `*` operator.
578      *
579      * Requirements:
580      *
581      * - Multiplication cannot overflow.
582      */
583     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
584         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
585         // benefit is lost if 'b' is also tested.
586         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
587         if (a == 0) {
588             return 0;
589         }
590 
591         uint256 c = a * b;
592         require(c / a == b, "SafeMath: multiplication overflow");
593 
594         return c;
595     }
596 
597     /**
598      * @dev Returns the integer division of two unsigned integers. Reverts on
599      * division by zero. The result is rounded towards zero.
600      *
601      * Counterpart to Solidity's `/` operator. Note: this function uses a
602      * `revert` opcode (which leaves remaining gas untouched) while Solidity
603      * uses an invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      *
607      * - The divisor cannot be zero.
608      */
609     function div(uint256 a, uint256 b) internal pure returns (uint256) {
610         return div(a, b, "SafeMath: division by zero");
611     }
612 
613     /**
614      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
615      * division by zero. The result is rounded towards zero.
616      *
617      * Counterpart to Solidity's `/` operator. Note: this function uses a
618      * `revert` opcode (which leaves remaining gas untouched) while Solidity
619      * uses an invalid opcode to revert (consuming all remaining gas).
620      *
621      * Requirements:
622      *
623      * - The divisor cannot be zero.
624      */
625     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
626         require(b > 0, errorMessage);
627         uint256 c = a / b;
628         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
629 
630         return c;
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
635      * Reverts when dividing by zero.
636      *
637      * Counterpart to Solidity's `%` operator. This function uses a `revert`
638      * opcode (which leaves remaining gas untouched) while Solidity uses an
639      * invalid opcode to revert (consuming all remaining gas).
640      *
641      * Requirements:
642      *
643      * - The divisor cannot be zero.
644      */
645     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
646         return mod(a, b, "SafeMath: modulo by zero");
647     }
648 
649     /**
650      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
651      * Reverts with custom message when dividing by zero.
652      *
653      * Counterpart to Solidity's `%` operator. This function uses a `revert`
654      * opcode (which leaves remaining gas untouched) while Solidity uses an
655      * invalid opcode to revert (consuming all remaining gas).
656      *
657      * Requirements:
658      *
659      * - The divisor cannot be zero.
660      */
661     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
662         require(b != 0, errorMessage);
663         return a % b;
664     }
665     
666     function ceil(uint a, uint m) internal pure returns (uint r) {
667         return (a + m - 1) / m * m;
668     }
669 }
670 
671 library SafeERC20 {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     function safeTransfer(IERC20 token, address to, uint256 value) internal {
676         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
677     }
678 
679     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
680         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
681     }
682 
683     /*
684      * @dev Deprecated. This function has issues similar to the ones found in
685      * {IERC20-approve}, and its usage is discouraged.
686      *
687      * Whenever possible, use {safeIncreaseAllowance} and
688      * {safeDecreaseAllowance} instead.
689      */
690     function safeApprove(IERC20 token, address spender, uint256 value) internal {
691         // safeApprove should only be called when setting an initial allowance,
692         // or when resetting it to zero. To increase and decrease it, use
693         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
694         // solhint-disable-next-line max-line-length
695         require((value == 0) || (token.allowance(address(this), spender) == 0),
696             "SafeERC20: approve from non-zero to non-zero allowance"
697         );
698         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
699     }
700 
701     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
702         uint256 newAllowance = token.allowance(address(this), spender).add(value);
703         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
704     }
705 
706     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
707         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
709     }
710 
711     /*
712      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
713      * on the return value: the return value is optional (but if data is returned, it must not be false).
714      * @param token The token targeted by the call.
715      * @param data The call data (encoded using abi.encode or one of its variants).
716      */
717     function _callOptionalReturn(IERC20 token, bytes memory data) private {
718         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
719         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
720         // the target address contains contract code and also asserts for success in the low-level call.
721 
722         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
723         if (returndata.length > 0) { // Return data is optional
724             // solhint-disable-next-line max-line-length
725             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
726         }
727     }
728 }
729 
730 contract fUSDT is IERC20, ReentrancyGuard {
731     using Address for address;
732     using SafeMath for uint256;
733     using SafeERC20 for IERC20;
734     enum TxType { FromExcluded, ToExcluded, BothExcluded, Standard }
735 
736     mapping (address => uint256) private rUsdtBalance;
737     mapping (address => uint256) private tUsdtBalance;
738     mapping (address => mapping (address => uint256)) private _allowances;
739 
740     EnumerableSet.AddressSet excluded;
741 
742     uint256 private tUsdtSupply;
743     uint256 private rUsdtSupply;
744     uint256 private feesAccrued;
745  
746     string private _name = 'FEG Wrapped USDT'; 
747     string private _symbol = 'fUSDT';
748     uint8  private _decimals = 6;
749     
750     address private op;
751     address private op2;
752     IERC20 public lpToken;
753     
754     event  Deposit(address indexed dst, uint amount);
755     event  Withdrawal(address indexed src, uint amount);
756 
757     constructor (address _lpToken) {
758         op = address(0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C);
759         op2 = op;
760         lpToken = IERC20(_lpToken);
761         EnumerableSet.add(excluded, address(0)); // stablity - zen.
762         emit Transfer(address(0), msg.sender, 0);
763     }
764 
765     function name() public view returns (string memory) {
766         return _name;
767     }
768 
769     function symbol() public view returns (string memory) {
770         return _symbol;
771     }
772 
773     function decimals() public view returns (uint8) {
774         return _decimals;
775     }
776 
777     function totalSupply() public view override returns (uint256) {
778         return tUsdtSupply;
779     }
780 
781     function balanceOf(address account) public view override returns (uint256) {
782         if (EnumerableSet.contains(excluded, account)) return tUsdtBalance[account];
783         (uint256 r, uint256 t) = currentSupply();
784         return (rUsdtBalance[account] * t)  / r;
785     }
786 
787     function transfer(address recipient, uint256 amount) public override returns (bool) {
788         _transfer(msg.sender, recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender) public view override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount) public override returns (bool) {
797         _approve(msg.sender, spender, amount);
798         return true;
799     }
800 
801     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802         _transfer(sender, recipient, amount);
803         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
809         return true;
810     }
811 
812     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813         _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
814         return true;
815     }
816 
817     function isExcluded(address account) public view returns (bool) {
818         return EnumerableSet.contains(excluded, account);
819     }
820 
821     function totalFees() public view returns (uint256) {
822         return feesAccrued;
823     }
824     
825     function deposit(uint256 _amount) public  {
826         require(_amount > 0, "can't deposit nothing");
827         lpToken.safeTransferFrom(msg.sender, address(this), _amount);
828         (uint256 r, uint256 t) = currentSupply();
829         uint256 fee = _amount / 100; 
830         uint256 df = fee / 10;
831         uint256 net = fee != 0 ? (_amount - (fee)) : _amount;
832         tUsdtSupply += _amount;
833         if(isExcluded(msg.sender)){
834             tUsdtBalance[msg.sender] += (_amount- fee);
835         } 
836         feesAccrued += df;
837         rUsdtBalance[op] += ((df * r) / t);
838         rUsdtSupply += (((net + df) * r) / t);
839         rUsdtBalance[msg.sender] += ((net * r) / t);
840         emit Deposit(msg.sender, _amount);
841     }
842     
843     function withdraw(uint256 _amount) public  {
844         require(balanceOf(msg.sender) >= _amount && _amount <= totalSupply(), "invalid _amount");
845         (uint256 r, uint256 t) = currentSupply();
846         uint256 fee = _amount / 100;
847         uint256 wf = fee / 10;
848         uint256 net = _amount - fee;
849         if(isExcluded(msg.sender)) {
850             tUsdtBalance[msg.sender] -= _amount;
851             rUsdtBalance[msg.sender] -= ((_amount * r) / t);
852         } else {
853             rUsdtBalance[msg.sender] -= ((_amount * r) / t);
854         }
855         tUsdtSupply -= (net + wf);
856         rUsdtSupply -= (((net + wf) * r ) / t);
857         rUsdtBalance[op] += ((wf * r) / t);
858         feesAccrued += wf;
859         lpToken.safeTransfer(msg.sender, net);
860         emit Withdrawal(msg.sender, net);
861     }
862     
863     function rUsdtToEveryone(uint256 amt) public {
864         require(!isExcluded(msg.sender), "not allowed");
865         (uint256 r, uint256 t) = currentSupply();
866         rUsdtBalance[msg.sender] -= ((amt * r) / t);
867         rUsdtSupply -= ((amt * r) / t);
868         feesAccrued += amt;
869     }
870 
871     function excludeFromFees(address account) external {
872         require(msg.sender == op2, "op only");
873         require(!EnumerableSet.contains(excluded, account), "address excluded");
874         if(rUsdtBalance[account] > 0) {
875             (uint256 r, uint256 t) = currentSupply();
876             tUsdtBalance[account] = (rUsdtBalance[account] * (t)) / (r);
877         }
878         EnumerableSet.add(excluded, account);
879     }
880 
881     function includeInFees(address account) external {
882         require(msg.sender == op2, "op only");
883         require(EnumerableSet.contains(excluded, account), "address excluded");
884         tUsdtBalance[account] = 0;
885         EnumerableSet.remove(excluded, account);
886     }
887     
888     function tUsdtFromrUsdt(uint256 rUsdtAmount) external view returns (uint256) {
889         (uint256 r, uint256 t) = currentSupply();
890         return (rUsdtAmount * t) / r;
891     }
892 
893 
894     function _approve(address owner, address spender, uint256 amount) private {
895         require(owner != address(0), "ERC20: approve from the zero address");
896         require(spender != address(0), "ERC20: approve to the zero address");
897 
898         _allowances[owner][spender] = amount;
899         emit Approval(owner, spender, amount);
900     }
901 
902     function getTtype(address sender, address recipient) internal view returns (TxType t) {
903         bool isSenderExcluded = EnumerableSet.contains(excluded, sender);
904         bool isRecipientExcluded = EnumerableSet.contains(excluded, recipient);
905         if (isSenderExcluded && !isRecipientExcluded) {
906             t = TxType.FromExcluded;
907         } else if (!isSenderExcluded && isRecipientExcluded) {
908             t = TxType.ToExcluded;
909         } else if (!isSenderExcluded && !isRecipientExcluded) {
910             t = TxType.Standard;
911         } else if (isSenderExcluded && isRecipientExcluded) {
912             t = TxType.BothExcluded;
913         } else {
914             t = TxType.Standard;
915         }
916         return t;
917     }
918     function _transfer(address sender, address recipient, uint256 amt) private {
919         require(sender != address(0), "ERC20: transfer from the zero address");
920         require(recipient != address(0), "ERC20: transfer to the zero address");
921         require(amt > 0, "Transfer amt must be greater than zero");
922         (uint256 r, uint256 t) = currentSupply();
923         uint256 fee = amt / 100;
924         TxType tt = getTtype(sender, recipient);
925         if (tt == TxType.ToExcluded) {
926             rUsdtBalance[sender] -= ((amt * r) / t);
927             tUsdtBalance[recipient] += (amt - fee);
928             rUsdtBalance[recipient] += (((amt - fee) * r) / t);
929         } else if (tt == TxType.FromExcluded) {
930             tUsdtBalance[sender] -= (amt);
931             rUsdtBalance[sender] -= ((amt * r) / t);
932             rUsdtBalance[recipient] += (((amt - fee) * r) / t);
933         } else if (tt == TxType.BothExcluded) {
934             tUsdtBalance[sender] -= (amt);
935             rUsdtBalance[sender] -= ((amt * r) / t);
936             tUsdtBalance[recipient] += (amt - fee);
937             rUsdtBalance[recipient] += (((amt - fee) * r) / t);
938         } else {
939             rUsdtBalance[sender] -= ((amt * r) / t);
940             rUsdtBalance[recipient] += (((amt - fee) * r) / t);
941         }
942         rUsdtSupply  -= ((fee * r) / t);
943         feesAccrued += fee;
944         emit Transfer(sender, recipient, amt - fee);
945     }
946 
947     function currentSupply() public view returns(uint256, uint256) {
948         if(rUsdtSupply == 0 || tUsdtSupply == 0) return (1000000000, 1);
949         uint256 rSupply = rUsdtSupply;
950         uint256 tSupply = tUsdtSupply;
951         for (uint256 i = 0; i < EnumerableSet.length(excluded); i++) {
952             if (rUsdtBalance[EnumerableSet.at(excluded, i)] > rSupply || tUsdtBalance[EnumerableSet.at(excluded, i)] > tSupply) return (rUsdtSupply, tUsdtSupply);
953             rSupply -= (rUsdtBalance[EnumerableSet.at(excluded, i)]);
954             tSupply -= (tUsdtBalance[EnumerableSet.at(excluded, i)]);
955         }
956         if (rSupply < rUsdtSupply / tUsdtSupply) return (rUsdtSupply, tUsdtSupply);
957         return (rSupply, tSupply);
958     }
959     
960     function setOp(address opper, address opper2) external {
961         require(msg.sender == op, "only op can call");
962         op = opper;
963         op2 = opper2;
964     }
965 }