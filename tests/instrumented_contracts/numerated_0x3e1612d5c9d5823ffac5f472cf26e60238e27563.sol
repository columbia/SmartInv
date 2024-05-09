1 pragma solidity >=0.6.0 <0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // SPDX-License-Identifier: MIT
78 
79 pragma solidity >=0.6.2 <0.8.0;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      */
102     function isContract(address account) internal view returns (bool) {
103         // This method relies on extcodesize, which returns 0 for contracts in
104         // construction, since the code is only stored at the end of the
105         // constructor execution.
106 
107         uint256 size;
108         // solhint-disable-next-line no-inline-assembly
109         assembly { size := extcodesize(account) }
110         return size > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
133         (bool success, ) = recipient.call{ value: amount }("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     /**
138      * @dev Performs a Solidity function call using a low level `call`. A
139      * plain`call` is an unsafe replacement for a function call: use this
140      * function instead.
141      *
142      * If `target` reverts with a revert reason, it is bubbled up by this
143      * function (like regular Solidity function calls).
144      *
145      * Returns the raw returned data. To convert to the expected return value,
146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
147      *
148      * Requirements:
149      *
150      * - `target` must be a contract.
151      * - calling `target` with `data` must not revert.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156       return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
161      * `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but also transferring `value` wei to `target`.
172      *
173      * Requirements:
174      *
175      * - the calling contract must have an ETH balance of at least `value`.
176      * - the called Solidity function must be `payable`.
177      *
178      * _Available since v3.1._
179      */
180     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
186      * with `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
191         require(address(this).balance >= value, "Address: insufficient balance for call");
192         require(isContract(target), "Address: call to non-contract");
193 
194         // solhint-disable-next-line avoid-low-level-calls
195         (bool success, bytes memory returndata) = target.call{ value: value }(data);
196         return _verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
206         return functionStaticCall(target, data, "Address: low-level static call failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
216         require(isContract(target), "Address: static call to non-contract");
217 
218         // solhint-disable-next-line avoid-low-level-calls
219         (bool success, bytes memory returndata) = target.staticcall(data);
220         return _verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a delegate call.
226      *
227      * _Available since v3.4._
228      */
229     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
230         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
240         require(isContract(target), "Address: delegate call to non-contract");
241 
242         // solhint-disable-next-line avoid-low-level-calls
243         (bool success, bytes memory returndata) = target.delegatecall(data);
244         return _verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
248         if (success) {
249             return returndata;
250         } else {
251             // Look for revert reason and bubble it up if present
252             if (returndata.length > 0) {
253                 // The easiest way to bubble the revert reason is using memory via assembly
254 
255                 // solhint-disable-next-line no-inline-assembly
256                 assembly {
257                     let returndata_size := mload(returndata)
258                     revert(add(32, returndata), returndata_size)
259                 }
260             } else {
261                 revert(errorMessage);
262             }
263         }
264     }
265 }
266 
267 pragma solidity >=0.6.0 <0.8.0;
268 
269 
270 /**
271  * @title SafeERC20
272  * @dev Wrappers around ERC20 operations that throw on failure (when the token
273  * contract returns false). Tokens that return no value (and instead revert or
274  * throw on failure) are also supported, non-reverting calls are assumed to be
275  * successful.
276  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
277  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
278  */
279 library SafeERC20 {
280     using SafeMath for uint256;
281     using Address for address;
282 
283     function safeTransfer(IERC20 token, address to, uint256 value) internal {
284         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
285     }
286 
287     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
288         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
289     }
290 
291     /**
292      * @dev Deprecated. This function has issues similar to the ones found in
293      * {IERC20-approve}, and its usage is discouraged.
294      *
295      * Whenever possible, use {safeIncreaseAllowance} and
296      * {safeDecreaseAllowance} instead.
297      */
298     function safeApprove(IERC20 token, address spender, uint256 value) internal {
299         // safeApprove should only be called when setting an initial allowance,
300         // or when resetting it to zero. To increase and decrease it, use
301         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
302         // solhint-disable-next-line max-line-length
303         require((value == 0) || (token.allowance(address(this), spender) == 0),
304             "SafeERC20: approve from non-zero to non-zero allowance"
305         );
306         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
307     }
308 
309     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
310         uint256 newAllowance = token.allowance(address(this), spender).add(value);
311         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
312     }
313 
314     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
315         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
316         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
317     }
318 
319     /**
320      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
321      * on the return value: the return value is optional (but if data is returned, it must not be false).
322      * @param token The token targeted by the call.
323      * @param data The call data (encoded using abi.encode or one of its variants).
324      */
325     function _callOptionalReturn(IERC20 token, bytes memory data) private {
326         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
327         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
328         // the target address contains contract code and also asserts for success in the low-level call.
329 
330         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
331         if (returndata.length > 0) { // Return data is optional
332             // solhint-disable-next-line max-line-length
333             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
334         }
335     }
336 }
337 
338 
339 pragma solidity >=0.6.0 <0.8.0;
340 
341 /**
342  * @dev Library for managing
343  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
344  * types.
345  *
346  * Sets have the following properties:
347  *
348  * - Elements are added, removed, and checked for existence in constant time
349  * (O(1)).
350  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
351  *
352  * ```
353  * contract Example {
354  *     // Add the library methods
355  *     using EnumerableSet for EnumerableSet.AddressSet;
356  *
357  *     // Declare a set state variable
358  *     EnumerableSet.AddressSet private mySet;
359  * }
360  * ```
361  *
362  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
363  * and `uint256` (`UintSet`) are supported.
364  */
365 library EnumerableSet {
366     // To implement this library for multiple types with as little code
367     // repetition as possible, we write it in terms of a generic Set type with
368     // bytes32 values.
369     // The Set implementation uses private functions, and user-facing
370     // implementations (such as AddressSet) are just wrappers around the
371     // underlying Set.
372     // This means that we can only create new EnumerableSets for types that fit
373     // in bytes32.
374 
375     struct Set {
376         // Storage of set values
377         bytes32[] _values;
378 
379         // Position of the value in the `values` array, plus 1 because index 0
380         // means a value is not in the set.
381         mapping (bytes32 => uint256) _indexes;
382     }
383 
384     /**
385      * @dev Add a value to a set. O(1).
386      *
387      * Returns true if the value was added to the set, that is if it was not
388      * already present.
389      */
390     function _add(Set storage set, bytes32 value) private returns (bool) {
391         if (!_contains(set, value)) {
392             set._values.push(value);
393             // The value is stored at length-1, but we add 1 to all indexes
394             // and use 0 as a sentinel value
395             set._indexes[value] = set._values.length;
396             return true;
397         } else {
398             return false;
399         }
400     }
401 
402     /**
403      * @dev Removes a value from a set. O(1).
404      *
405      * Returns true if the value was removed from the set, that is if it was
406      * present.
407      */
408     function _remove(Set storage set, bytes32 value) private returns (bool) {
409         // We read and store the value's index to prevent multiple reads from the same storage slot
410         uint256 valueIndex = set._indexes[value];
411 
412         if (valueIndex != 0) { // Equivalent to contains(set, value)
413             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
414             // the array, and then remove the last element (sometimes called as 'swap and pop').
415             // This modifies the order of the array, as noted in {at}.
416 
417             uint256 toDeleteIndex = valueIndex - 1;
418             uint256 lastIndex = set._values.length - 1;
419 
420             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
421             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
422 
423             bytes32 lastvalue = set._values[lastIndex];
424 
425             // Move the last value to the index where the value to delete is
426             set._values[toDeleteIndex] = lastvalue;
427             // Update the index for the moved value
428             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
429 
430             // Delete the slot where the moved value was stored
431             set._values.pop();
432 
433             // Delete the index for the deleted slot
434             delete set._indexes[value];
435 
436             return true;
437         } else {
438             return false;
439         }
440     }
441 
442     /**
443      * @dev Returns true if the value is in the set. O(1).
444      */
445     function _contains(Set storage set, bytes32 value) private view returns (bool) {
446         return set._indexes[value] != 0;
447     }
448 
449     /**
450      * @dev Returns the number of values on the set. O(1).
451      */
452     function _length(Set storage set) private view returns (uint256) {
453         return set._values.length;
454     }
455 
456    /**
457     * @dev Returns the value stored at position `index` in the set. O(1).
458     *
459     * Note that there are no guarantees on the ordering of values inside the
460     * array, and it may change when more values are added or removed.
461     *
462     * Requirements:
463     *
464     * - `index` must be strictly less than {length}.
465     */
466     function _at(Set storage set, uint256 index) private view returns (bytes32) {
467         require(set._values.length > index, "EnumerableSet: index out of bounds");
468         return set._values[index];
469     }
470 
471     // Bytes32Set
472 
473     struct Bytes32Set {
474         Set _inner;
475     }
476 
477     /**
478      * @dev Add a value to a set. O(1).
479      *
480      * Returns true if the value was added to the set, that is if it was not
481      * already present.
482      */
483     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
484         return _add(set._inner, value);
485     }
486 
487     /**
488      * @dev Removes a value from a set. O(1).
489      *
490      * Returns true if the value was removed from the set, that is if it was
491      * present.
492      */
493     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
494         return _remove(set._inner, value);
495     }
496 
497     /**
498      * @dev Returns true if the value is in the set. O(1).
499      */
500     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
501         return _contains(set._inner, value);
502     }
503 
504     /**
505      * @dev Returns the number of values in the set. O(1).
506      */
507     function length(Bytes32Set storage set) internal view returns (uint256) {
508         return _length(set._inner);
509     }
510 
511    /**
512     * @dev Returns the value stored at position `index` in the set. O(1).
513     *
514     * Note that there are no guarantees on the ordering of values inside the
515     * array, and it may change when more values are added or removed.
516     *
517     * Requirements:
518     *
519     * - `index` must be strictly less than {length}.
520     */
521     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
522         return _at(set._inner, index);
523     }
524 
525     // AddressSet
526 
527     struct AddressSet {
528         Set _inner;
529     }
530 
531     /**
532      * @dev Add a value to a set. O(1).
533      *
534      * Returns true if the value was added to the set, that is if it was not
535      * already present.
536      */
537     function add(AddressSet storage set, address value) internal returns (bool) {
538         return _add(set._inner, bytes32(uint256(uint160(value))));
539     }
540 
541     /**
542      * @dev Removes a value from a set. O(1).
543      *
544      * Returns true if the value was removed from the set, that is if it was
545      * present.
546      */
547     function remove(AddressSet storage set, address value) internal returns (bool) {
548         return _remove(set._inner, bytes32(uint256(uint160(value))));
549     }
550 
551     /**
552      * @dev Returns true if the value is in the set. O(1).
553      */
554     function contains(AddressSet storage set, address value) internal view returns (bool) {
555         return _contains(set._inner, bytes32(uint256(uint160(value))));
556     }
557 
558     /**
559      * @dev Returns the number of values in the set. O(1).
560      */
561     function length(AddressSet storage set) internal view returns (uint256) {
562         return _length(set._inner);
563     }
564 
565    /**
566     * @dev Returns the value stored at position `index` in the set. O(1).
567     *
568     * Note that there are no guarantees on the ordering of values inside the
569     * array, and it may change when more values are added or removed.
570     *
571     * Requirements:
572     *
573     * - `index` must be strictly less than {length}.
574     */
575     function at(AddressSet storage set, uint256 index) internal view returns (address) {
576         return address(uint160(uint256(_at(set._inner, index))));
577     }
578 
579 
580     // UintSet
581 
582     struct UintSet {
583         Set _inner;
584     }
585 
586     /**
587      * @dev Add a value to a set. O(1).
588      *
589      * Returns true if the value was added to the set, that is if it was not
590      * already present.
591      */
592     function add(UintSet storage set, uint256 value) internal returns (bool) {
593         return _add(set._inner, bytes32(value));
594     }
595 
596     /**
597      * @dev Removes a value from a set. O(1).
598      *
599      * Returns true if the value was removed from the set, that is if it was
600      * present.
601      */
602     function remove(UintSet storage set, uint256 value) internal returns (bool) {
603         return _remove(set._inner, bytes32(value));
604     }
605 
606     /**
607      * @dev Returns true if the value is in the set. O(1).
608      */
609     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
610         return _contains(set._inner, bytes32(value));
611     }
612 
613     /**
614      * @dev Returns the number of values on the set. O(1).
615      */
616     function length(UintSet storage set) internal view returns (uint256) {
617         return _length(set._inner);
618     }
619 
620    /**
621     * @dev Returns the value stored at position `index` in the set. O(1).
622     *
623     * Note that there are no guarantees on the ordering of values inside the
624     * array, and it may change when more values are added or removed.
625     *
626     * Requirements:
627     *
628     * - `index` must be strictly less than {length}.
629     */
630     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
631         return uint256(_at(set._inner, index));
632     }
633 }
634 
635 
636 pragma solidity >=0.6.0 <0.8.0;
637 
638 /**
639  * @dev Wrappers over Solidity's arithmetic operations with added overflow
640  * checks.
641  *
642  * Arithmetic operations in Solidity wrap on overflow. This can easily result
643  * in bugs, because programmers usually assume that an overflow raises an
644  * error, which is the standard behavior in high level programming languages.
645  * `SafeMath` restores this intuition by reverting the transaction when an
646  * operation overflows.
647  *
648  * Using this library instead of the unchecked operations eliminates an entire
649  * class of bugs, so it's recommended to use it always.
650  */
651 library SafeMath {
652     /**
653      * @dev Returns the addition of two unsigned integers, with an overflow flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         uint256 c = a + b;
659         if (c < a) return (false, 0);
660         return (true, c);
661     }
662 
663     /**
664      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
665      *
666      * _Available since v3.4._
667      */
668     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
669         if (b > a) return (false, 0);
670         return (true, a - b);
671     }
672 
673     /**
674      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
675      *
676      * _Available since v3.4._
677      */
678     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
679         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
680         // benefit is lost if 'b' is also tested.
681         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
682         if (a == 0) return (true, 0);
683         uint256 c = a * b;
684         if (c / a != b) return (false, 0);
685         return (true, c);
686     }
687 
688     /**
689      * @dev Returns the division of two unsigned integers, with a division by zero flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         if (b == 0) return (false, 0);
695         return (true, a / b);
696     }
697 
698     /**
699      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
700      *
701      * _Available since v3.4._
702      */
703     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
704         if (b == 0) return (false, 0);
705         return (true, a % b);
706     }
707 
708     /**
709      * @dev Returns the addition of two unsigned integers, reverting on
710      * overflow.
711      *
712      * Counterpart to Solidity's `+` operator.
713      *
714      * Requirements:
715      *
716      * - Addition cannot overflow.
717      */
718     function add(uint256 a, uint256 b) internal pure returns (uint256) {
719         uint256 c = a + b;
720         require(c >= a, "SafeMath: addition overflow");
721         return c;
722     }
723 
724     /**
725      * @dev Returns the subtraction of two unsigned integers, reverting on
726      * overflow (when the result is negative).
727      *
728      * Counterpart to Solidity's `-` operator.
729      *
730      * Requirements:
731      *
732      * - Subtraction cannot overflow.
733      */
734     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
735         require(b <= a, "SafeMath: subtraction overflow");
736         return a - b;
737     }
738 
739     /**
740      * @dev Returns the multiplication of two unsigned integers, reverting on
741      * overflow.
742      *
743      * Counterpart to Solidity's `*` operator.
744      *
745      * Requirements:
746      *
747      * - Multiplication cannot overflow.
748      */
749     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
750         if (a == 0) return 0;
751         uint256 c = a * b;
752         require(c / a == b, "SafeMath: multiplication overflow");
753         return c;
754     }
755 
756     /**
757      * @dev Returns the integer division of two unsigned integers, reverting on
758      * division by zero. The result is rounded towards zero.
759      *
760      * Counterpart to Solidity's `/` operator. Note: this function uses a
761      * `revert` opcode (which leaves remaining gas untouched) while Solidity
762      * uses an invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function div(uint256 a, uint256 b) internal pure returns (uint256) {
769         require(b > 0, "SafeMath: division by zero");
770         return a / b;
771     }
772 
773     /**
774      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
775      * reverting when dividing by zero.
776      *
777      * Counterpart to Solidity's `%` operator. This function uses a `revert`
778      * opcode (which leaves remaining gas untouched) while Solidity uses an
779      * invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
786         require(b > 0, "SafeMath: modulo by zero");
787         return a % b;
788     }
789 
790     /**
791      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
792      * overflow (when the result is negative).
793      *
794      * CAUTION: This function is deprecated because it requires allocating memory for the error
795      * message unnecessarily. For custom revert reasons use {trySub}.
796      *
797      * Counterpart to Solidity's `-` operator.
798      *
799      * Requirements:
800      *
801      * - Subtraction cannot overflow.
802      */
803     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
804         require(b <= a, errorMessage);
805         return a - b;
806     }
807 
808     /**
809      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
810      * division by zero. The result is rounded towards zero.
811      *
812      * CAUTION: This function is deprecated because it requires allocating memory for the error
813      * message unnecessarily. For custom revert reasons use {tryDiv}.
814      *
815      * Counterpart to Solidity's `/` operator. Note: this function uses a
816      * `revert` opcode (which leaves remaining gas untouched) while Solidity
817      * uses an invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
824         require(b > 0, errorMessage);
825         return a / b;
826     }
827 
828     /**
829      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
830      * reverting with custom message when dividing by zero.
831      *
832      * CAUTION: This function is deprecated because it requires allocating memory for the error
833      * message unnecessarily. For custom revert reasons use {tryMod}.
834      *
835      * Counterpart to Solidity's `%` operator. This function uses a `revert`
836      * opcode (which leaves remaining gas untouched) while Solidity uses an
837      * invalid opcode to revert (consuming all remaining gas).
838      *
839      * Requirements:
840      *
841      * - The divisor cannot be zero.
842      */
843     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
844         require(b > 0, errorMessage);
845         return a % b;
846     }
847 }
848 
849 
850 
851 pragma solidity >=0.6.0 <0.8.0;
852 
853 /*
854  * @dev Provides information about the current execution context, including the
855  * sender of the transaction and its data. While these are generally available
856  * via msg.sender and msg.data, they should not be accessed in such a direct
857  * manner, since when dealing with GSN meta-transactions the account sending and
858  * paying for execution may not be the actual sender (as far as an application
859  * is concerned).
860  *
861  * This contract is only required for intermediate, library-like contracts.
862  */
863 abstract contract Context {
864     function _msgSender() internal view virtual returns (address payable) {
865         return msg.sender;
866     }
867 
868     function _msgData() internal view virtual returns (bytes memory) {
869         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
870         return msg.data;
871     }
872 }
873 
874 /**
875  * @dev Contract module which provides a basic access control mechanism, where
876  * there is an account (an owner) that can be granted exclusive access to
877  * specific functions.
878  *
879  * By default, the owner account will be the one that deploys the contract. This
880  * can later be changed with {transferOwnership}.
881  *
882  * This module is used through inheritance. It will make available the modifier
883  * `onlyOwner`, which can be applied to your functions to restrict their use to
884  * the owner.
885  */
886 abstract contract Ownable is Context {
887     address private _owner;
888 
889     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
890 
891     /**
892      * @dev Initializes the contract setting the deployer as the initial owner.
893      */
894     constructor () internal {
895         address msgSender = _msgSender();
896         _owner = msgSender;
897         emit OwnershipTransferred(address(0), msgSender);
898     }
899 
900     /**
901      * @dev Returns the address of the current owner.
902      */
903     function owner() public view virtual returns (address) {
904         return _owner;
905     }
906 
907     /**
908      * @dev Throws if called by any account other than the owner.
909      */
910     modifier onlyOwner() {
911         require(owner() == _msgSender(), "Ownable: caller is not the owner");
912         _;
913     }
914 
915     /**
916      * @dev Leaves the contract without owner. It will not be possible to call
917      * `onlyOwner` functions anymore. Can only be called by the current owner.
918      *
919      * NOTE: Renouncing ownership will leave the contract without an owner,
920      * thereby removing any functionality that is only available to the owner.
921      */
922     function renounceOwnership() public virtual onlyOwner {
923         emit OwnershipTransferred(_owner, address(0));
924         _owner = address(0);
925     }
926 
927     /**
928      * @dev Transfers ownership of the contract to a new account (`newOwner`).
929      * Can only be called by the current owner.
930      */
931     function transferOwnership(address newOwner) public virtual onlyOwner {
932         require(newOwner != address(0), "Ownable: new owner is the zero address");
933         emit OwnershipTransferred(_owner, newOwner);
934         _owner = newOwner;
935     }
936 }
937 pragma solidity >=0.6.0 <0.8.0;
938 
939 /**
940  * @dev Implementation of the {IERC20} interface.
941  *
942  * This implementation is agnostic to the way tokens are created. This means
943  * that a supply mechanism has to be added in a derived contract using {_mint}.
944  * For a generic mechanism see {ERC20PresetMinterPauser}.
945  *
946  * TIP: For a detailed writeup see our guide
947  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
948  * to implement supply mechanisms].
949  *
950  * We have followed general OpenZeppelin guidelines: functions revert instead
951  * of returning `false` on failure. This behavior is nonetheless conventional
952  * and does not conflict with the expectations of ERC20 applications.
953  *
954  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
955  * This allows applications to reconstruct the allowance for all accounts just
956  * by listening to said events. Other implementations of the EIP may not emit
957  * these events, as it isn't required by the specification.
958  *
959  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
960  * functions have been added to mitigate the well-known issues around setting
961  * allowances. See {IERC20-approve}.
962  */
963 contract ERC20 is Context, IERC20 {
964     using SafeMath for uint256;
965 
966     mapping (address => uint256) private _balances;
967 
968     mapping (address => mapping (address => uint256)) private _allowances;
969 
970     uint256 private _totalSupply;
971 
972     string private _name;
973     string private _symbol;
974     uint8 private _decimals;
975 
976     /**
977      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
978      * a default value of 18.
979      *
980      * To select a different value for {decimals}, use {_setupDecimals}.
981      *
982      * All three of these values are immutable: they can only be set once during
983      * construction.
984      */
985     constructor (string memory name_, string memory symbol_) public {
986         _name = name_;
987         _symbol = symbol_;
988         _decimals = 18;
989     }
990 
991     /**
992      * @dev Returns the name of the token.
993      */
994     function name() public view virtual returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev Returns the symbol of the token, usually a shorter version of the
1000      * name.
1001      */
1002     function symbol() public view virtual returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev Returns the number of decimals used to get its user representation.
1008      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1009      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1010      *
1011      * Tokens usually opt for a value of 18, imitating the relationship between
1012      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1013      * called.
1014      *
1015      * NOTE: This information is only used for _display_ purposes: it in
1016      * no way affects any of the arithmetic of the contract, including
1017      * {IERC20-balanceOf} and {IERC20-transfer}.
1018      */
1019     function decimals() public view virtual returns (uint8) {
1020         return _decimals;
1021     }
1022 
1023     /**
1024      * @dev See {IERC20-totalSupply}.
1025      */
1026     function totalSupply() public view virtual override returns (uint256) {
1027         return _totalSupply;
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-balanceOf}.
1032      */
1033     function balanceOf(address account) public view virtual override returns (uint256) {
1034         return _balances[account];
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-transfer}.
1039      *
1040      * Requirements:
1041      *
1042      * - `recipient` cannot be the zero address.
1043      * - the caller must have a balance of at least `amount`.
1044      */
1045     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1046         _transfer(_msgSender(), recipient, amount);
1047         return true;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-allowance}.
1052      */
1053     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1054         return _allowances[owner][spender];
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-approve}.
1059      *
1060      * Requirements:
1061      *
1062      * - `spender` cannot be the zero address.
1063      */
1064     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1065         _approve(_msgSender(), spender, amount);
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev See {IERC20-transferFrom}.
1071      *
1072      * Emits an {Approval} event indicating the updated allowance. This is not
1073      * required by the EIP. See the note at the beginning of {ERC20}.
1074      *
1075      * Requirements:
1076      *
1077      * - `sender` and `recipient` cannot be the zero address.
1078      * - `sender` must have a balance of at least `amount`.
1079      * - the caller must have allowance for ``sender``'s tokens of at least
1080      * `amount`.
1081      */
1082     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1083         _transfer(sender, recipient, amount);
1084         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1085         return true;
1086     }
1087 
1088     /**
1089      * @dev Atomically increases the allowance granted to `spender` by the caller.
1090      *
1091      * This is an alternative to {approve} that can be used as a mitigation for
1092      * problems described in {IERC20-approve}.
1093      *
1094      * Emits an {Approval} event indicating the updated allowance.
1095      *
1096      * Requirements:
1097      *
1098      * - `spender` cannot be the zero address.
1099      */
1100     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1101         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1102         return true;
1103     }
1104 
1105     /**
1106      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1107      *
1108      * This is an alternative to {approve} that can be used as a mitigation for
1109      * problems described in {IERC20-approve}.
1110      *
1111      * Emits an {Approval} event indicating the updated allowance.
1112      *
1113      * Requirements:
1114      *
1115      * - `spender` cannot be the zero address.
1116      * - `spender` must have allowance for the caller of at least
1117      * `subtractedValue`.
1118      */
1119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1120         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1121         return true;
1122     }
1123 
1124     /**
1125      * @dev Moves tokens `amount` from `sender` to `recipient`.
1126      *
1127      * This is internal function is equivalent to {transfer}, and can be used to
1128      * e.g. implement automatic token fees, slashing mechanisms, etc.
1129      *
1130      * Emits a {Transfer} event.
1131      *
1132      * Requirements:
1133      *
1134      * - `sender` cannot be the zero address.
1135      * - `recipient` cannot be the zero address.
1136      * - `sender` must have a balance of at least `amount`.
1137      */
1138     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1139         require(sender != address(0), "ERC20: transfer from the zero address");
1140         require(recipient != address(0), "ERC20: transfer to the zero address");
1141 
1142         _beforeTokenTransfer(sender, recipient, amount);
1143 
1144         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1145         _balances[recipient] = _balances[recipient].add(amount);
1146         emit Transfer(sender, recipient, amount);
1147     }
1148 
1149     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1150      * the total supply.
1151      *
1152      * Emits a {Transfer} event with `from` set to the zero address.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      */
1158     function _mint(address account, uint256 amount) internal virtual {
1159         require(account != address(0), "ERC20: mint to the zero address");
1160 
1161         _beforeTokenTransfer(address(0), account, amount);
1162 
1163         _totalSupply = _totalSupply.add(amount);
1164         _balances[account] = _balances[account].add(amount);
1165         emit Transfer(address(0), account, amount);
1166     }
1167 
1168     /**
1169      * @dev Destroys `amount` tokens from `account`, reducing the
1170      * total supply.
1171      *
1172      * Emits a {Transfer} event with `to` set to the zero address.
1173      *
1174      * Requirements:
1175      *
1176      * - `account` cannot be the zero address.
1177      * - `account` must have at least `amount` tokens.
1178      */
1179     function _burn(address account, uint256 amount) internal virtual {
1180         require(account != address(0), "ERC20: burn from the zero address");
1181 
1182         _beforeTokenTransfer(account, address(0), amount);
1183 
1184         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1185         _totalSupply = _totalSupply.sub(amount);
1186         emit Transfer(account, address(0), amount);
1187     }
1188 
1189     /**
1190      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1191      *
1192      * This internal function is equivalent to `approve`, and can be used to
1193      * e.g. set automatic allowances for certain subsystems, etc.
1194      *
1195      * Emits an {Approval} event.
1196      *
1197      * Requirements:
1198      *
1199      * - `owner` cannot be the zero address.
1200      * - `spender` cannot be the zero address.
1201      */
1202     function _approve(address owner, address spender, uint256 amount) internal virtual {
1203         require(owner != address(0), "ERC20: approve from the zero address");
1204         require(spender != address(0), "ERC20: approve to the zero address");
1205 
1206         _allowances[owner][spender] = amount;
1207         emit Approval(owner, spender, amount);
1208     }
1209 
1210     /**
1211      * @dev Sets {decimals} to a value other than the default one of 18.
1212      *
1213      * WARNING: This function should only be called from the constructor. Most
1214      * applications that interact with token contracts will not expect
1215      * {decimals} to ever change, and may work incorrectly if it does.
1216      */
1217     function _setupDecimals(uint8 decimals_) internal virtual {
1218         _decimals = decimals_;
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before any transfer of tokens. This includes
1223      * minting and burning.
1224      *
1225      * Calling conditions:
1226      *
1227      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1228      * will be to transferred to `to`.
1229      * - when `from` is zero, `amount` tokens will be minted for `to`.
1230      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1236 }
1237 
1238 // BitberrySwap with Governance.
1239 contract BitberrySwap is ERC20("Bitberryswap", "BBS"), Ownable {
1240     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (0x).
1241     function mint(address _to, uint256 _amount) public onlyOwner {
1242         _mint(_to, _amount);
1243     }
1244 }
1245 
1246 pragma solidity 0.6.12;
1247 /////////////////////////////////////////////////////////////////////////////////////
1248 //
1249 //  Level
1250 //
1251 /////////////////////////////////////////////////////////////////////////////////////
1252 
1253 
1254 contract BBSLevel is Ownable {
1255     using SafeMath for uint256;
1256     using SafeERC20 for IERC20;
1257 
1258     struct LevelInfo {
1259         uint256 level;
1260         uint256 amount;
1261     }
1262 
1263     BBSPoolV2 pool;
1264     IERC20 public token;
1265 
1266     LevelInfo[] public info;
1267     mapping(address => LevelInfo) public users;
1268     
1269     event LevelUp(address indexed user, uint256 amount);
1270     event LevelDown(address indexed user, uint256 amount);
1271     event EmergencyWithdraw(address indexed user, uint256 amount);
1272 
1273     constructor(BBSPoolV2 _pool, IERC20 _token) public {
1274         pool = _pool;
1275         token = _token;
1276     }
1277 
1278     function infoLength() public view returns (uint256) {
1279         return info.length;
1280     }
1281 
1282     function getLevel(address _addr) public view returns (uint256) {
1283         return users[_addr].level;
1284     }
1285 
1286     function getAmount(address _addr) public view returns (uint256) {
1287         return users[_addr].amount;
1288     }
1289 
1290     function setPoolContract(BBSPoolV2 _pool) public onlyOwner {
1291         pool = _pool;
1292     }
1293     
1294     function add(uint256 _level, uint256 _amount) public onlyOwner {
1295         info.push(LevelInfo({level: _level, amount: _amount}));
1296     }
1297 
1298     function set(uint256 id, uint256 _level, uint256 _amount) public onlyOwner {
1299         info[id].level = _level;
1300         info[id].amount = _amount;
1301     }
1302 
1303     function levelUp(uint256 _amount) public {
1304         require(_amount > 0, "levelUp: amount 0");
1305 
1306         LevelInfo storage user = users[msg.sender];
1307         user.amount = user.amount.add(_amount);
1308 
1309         uint256 length = info.length;
1310         for (uint256 i = 0; i < length; i++) {
1311             if (info[i].amount <= user.amount && user.level < info[i].level) {
1312                 user.level = info[i].level;
1313             }
1314         }
1315         token.safeTransferFrom(address(msg.sender), address(this), _amount);
1316         emit LevelUp(msg.sender, _amount);
1317     }
1318 
1319     function levelDown(uint256 _amount) public {
1320         require(_amount > 0, "levelDown: amount 0");
1321         require(users[msg.sender].amount >= _amount, "levelDown: not good");
1322         require(!pool.userMining(msg.sender, true), "levelDown: mining ture");
1323         
1324         LevelInfo storage user = users[msg.sender];
1325         user.amount = user.amount.sub(_amount);
1326         user.level = 0;
1327 
1328         uint256 length = info.length;
1329         for (uint256 i = 0; i < length; i++) {
1330             if (info[i].amount <= user.amount && user.level < info[i].level) {
1331                 user.level = info[i].level;
1332             }
1333         }
1334 
1335         token.safeTransfer(address(msg.sender), _amount);
1336         emit LevelDown(msg.sender, _amount);
1337     }
1338 
1339     function emergencyWithdraw(address _addr) public onlyOwner {
1340         LevelInfo storage user = users[_addr];
1341 
1342         token.safeTransfer(address(_addr), user.amount);
1343         emit EmergencyWithdraw(_addr, user.amount);
1344         user.level = 0;
1345         user.amount = 0;
1346     }
1347 }
1348 
1349 pragma solidity 0.6.12;
1350 
1351 /////////////////////////////////////////////////////////////////////////////////////
1352 //
1353 //  Referral
1354 //
1355 /////////////////////////////////////////////////////////////////////////////////////
1356 
1357 contract BBSReferral is Ownable {
1358     using SafeMath for uint256;
1359     using SafeERC20 for IERC20;
1360 
1361     IERC20 public token;
1362 
1363     uint256 public fee;
1364 
1365     struct User {
1366         address parent;
1367         address[] children;
1368         uint256 grade;
1369     }
1370 
1371     mapping(address => User) public users;
1372 
1373     event AddReferral(address indexed user, address _addr);
1374     event Register(address indexed user, address _addr);
1375 
1376     constructor(IERC20 _token, uint256 _fee) public {
1377         token = _token;
1378         fee = _fee;
1379     }
1380 
1381     function getParent(address _addr) public view returns (address) {
1382         return users[_addr].parent;
1383     }
1384 
1385     function getChildren(address _addr) public view returns (address[] memory) {
1386         return users[_addr].children;
1387     }
1388 
1389     function getGrade(address _addr) public view returns (uint256) {
1390         return users[_addr].grade;
1391     }
1392 
1393     function setFee(IERC20 _token, uint256 _amount) public onlyOwner {
1394         token = _token;
1395         fee = _amount;
1396     }
1397 
1398     function withdraw(uint256 _amount) public onlyOwner {
1399         require(
1400             token.balanceOf(address(this)) >= _amount,
1401             "withdraw: not good"
1402         );
1403         token.safeTransfer(address(msg.sender), _amount);
1404     }
1405 
1406     // 마스터 등록 (온리 오너계정)
1407     function addMaster(address _addr) public onlyOwner {
1408         // _addr 이 등록 되어있으면 에러
1409         require(users[_addr].grade < 1, "addMaster: used address");
1410         User storage user = users[_addr];
1411         user.grade = 1;
1412         users[_addr] = user;
1413     }
1414 
1415     // 레퍼럴 계정
1416     // 상위는 마스터, 토큰으로 구매 (fee)
1417     // _addr : master address
1418     function addReferral(address _addr) public {
1419         // _addr 이 master 계정이 아니면 에러
1420         require(users[_addr].grade == 1, "addReferral: not address");
1421 
1422         //내 address가 등록 되어있으면 에러
1423         require(users[msg.sender].grade < 1, "addReferral: used address");
1424 
1425         //레퍼럴 유저 등록
1426         User storage user = users[msg.sender];
1427         user.grade = 2;
1428         user.parent = _addr;
1429         users[msg.sender] = user;
1430 
1431         //마스터 children 추가
1432         User storage master = users[_addr];
1433         master.children.push(msg.sender);
1434 
1435         token.safeTransferFrom(address(msg.sender), address(this), fee);
1436         emit AddReferral(msg.sender, _addr);
1437     }
1438 
1439     //레퍼럴 등록
1440     // _addr = referral
1441     function register(address _addr) public {
1442         // msg.sender 와 _addr 이 같으면 에러
1443         require(msg.sender != _addr, "register: error address");
1444 
1445         //내 address가 등록 되어있으면 에러
1446         require(users[msg.sender].grade < 1, "register: used address");
1447 
1448         // _addr이 referral이 아니면 에러
1449         require(users[_addr].grade == 2, "register: not referral address");
1450 
1451         // 상위레퍼럴에 children 추가
1452         User storage parent = users[_addr];
1453         parent.children.push(msg.sender);
1454 
1455         // msg.sender로 구조체 생성
1456         User storage user = users[msg.sender];
1457         user.parent = _addr;
1458         user.grade = 3;
1459         emit Register(msg.sender, _addr);
1460     }
1461 }
1462 pragma solidity 0.6.12;
1463 
1464 interface IMigratorPool {
1465     function migrate(IERC20 token) external returns (IERC20);
1466 }
1467 
1468 
1469 contract BBSPoolV2 is Ownable {
1470     using SafeMath for uint256;
1471     using SafeERC20 for IERC20;
1472 
1473     struct UserInfo {
1474         uint256 amount;
1475         uint256 rewardDebt;
1476     }
1477 
1478     struct PoolInfo {
1479         IERC20 lpToken;
1480         uint256 allocPoint;
1481         uint256 lastRewardBlock;
1482         uint256 accTokenPerShare;
1483         uint256 level;
1484     }
1485 
1486     BitberrySwap public token;
1487     address public teamAddr;
1488     uint256 public tokenPerBlock;
1489     uint256 public BONUS_MULTIPLIER = 1;
1490     IMigratorPool public migrator;
1491     PoolInfo[] public poolInfo;
1492     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1493     uint256 public totalAllocPoint;
1494     uint256 public startBlock;
1495 
1496     uint256 public endBlock;
1497 
1498     BBSLevel public levelContract;
1499     BBSReferral public referralContract;
1500 
1501     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1502     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1503     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1504 
1505     constructor(
1506         BitberrySwap _token,
1507         address _teamAddr,
1508         uint256 _tokenPerBlock,
1509         uint256 _startBlock,
1510         uint256 _endBlock
1511     ) public {
1512         token = _token;
1513         teamAddr = _teamAddr;
1514         tokenPerBlock = _tokenPerBlock;
1515         startBlock = _startBlock;
1516         endBlock = _endBlock;
1517     }
1518 
1519     function setLevelContract(BBSLevel _levelContract) public onlyOwner {
1520         levelContract = _levelContract;
1521     }
1522 
1523     function setReferralContract(BBSReferral _referralContract) public onlyOwner {
1524         referralContract = _referralContract;
1525     }
1526 
1527     function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
1528         BONUS_MULTIPLIER = multiplierNumber;
1529     }
1530 
1531     function poolLength() external view returns (uint256) {
1532         return poolInfo.length;
1533     }
1534 
1535     function userMining(address _addr, bool _levelPool) external view returns (bool) {
1536         for (uint256 pid = 0; pid < poolInfo.length; pid++) {
1537             PoolInfo storage pool = poolInfo[pid];
1538             UserInfo storage user = userInfo[pid][_addr];
1539 
1540             if(_levelPool && pool.level > 0 && user.amount > 0)
1541                 return true;
1542             else if (!_levelPool && user.amount > 0)
1543                 return true;
1544         }
1545         return false;
1546     }
1547 
1548     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _level) public onlyOwner {
1549         if (_withUpdate) {
1550             massUpdatePools();
1551         }
1552         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1553         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1554         poolInfo.push(PoolInfo({
1555             lpToken: _lpToken,
1556             allocPoint: _allocPoint,
1557             lastRewardBlock: lastRewardBlock,
1558             accTokenPerShare: 0,
1559             level: _level
1560         }));
1561     }
1562 
1563     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1564         if (_withUpdate) {
1565             massUpdatePools();
1566         }
1567         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1568         poolInfo[_pid].allocPoint = _allocPoint;
1569     }
1570 
1571     function setMigrator(IMigratorPool _migrator) public onlyOwner {
1572         migrator = _migrator;
1573     }
1574 
1575     function migrate(uint256 _pid) public {
1576         require(address(migrator) != address(0), "migrate: no migrator");
1577         PoolInfo storage pool = poolInfo[_pid];
1578         IERC20 lpToken = pool.lpToken;
1579         uint256 bal = lpToken.balanceOf(address(this));
1580         lpToken.safeApprove(address(migrator), bal);
1581         IERC20 newLpToken = migrator.migrate(lpToken);
1582         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1583         pool.lpToken = newLpToken;
1584     }
1585 
1586     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1587         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1588     }
1589 
1590     function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
1591         PoolInfo storage pool = poolInfo[_pid];
1592         UserInfo storage user = userInfo[_pid][_user];
1593         uint256 accTokenPerShare = pool.accTokenPerShare;
1594         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1595 
1596         uint256 blockNumber = 0;
1597         if(block.number > endBlock)
1598             blockNumber = endBlock;
1599         else
1600             blockNumber = block.number;
1601         
1602         if (blockNumber > pool.lastRewardBlock && lpSupply != 0) {
1603             uint256 multiplier = getMultiplier(pool.lastRewardBlock, blockNumber);
1604             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1605             accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1606         }
1607         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1608     }
1609 
1610     function massUpdatePools() public {
1611         uint256 length = poolInfo.length;
1612         for (uint256 pid = 0; pid < length; ++pid) {
1613             updatePool(pid);
1614         }
1615     }
1616 
1617     function updatePool(uint256 _pid) public {
1618         PoolInfo storage pool = poolInfo[_pid];
1619         if (block.number <= pool.lastRewardBlock) {
1620             return;
1621         }
1622         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1623         if (lpSupply == 0) {
1624             if (block.number > endBlock)
1625                 pool.lastRewardBlock = endBlock;
1626             else
1627                 pool.lastRewardBlock = block.number;
1628             return;
1629         }
1630         if (pool.lastRewardBlock == endBlock){
1631             return;
1632         }
1633 
1634         if (block.number > endBlock){
1635             uint256 multiplier = getMultiplier(pool.lastRewardBlock, endBlock);
1636             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1637             //token.mint(teamAddr, tokenReward.div(10));
1638             //token.mint(address(this), tokenReward);
1639             pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1640             pool.lastRewardBlock = endBlock;
1641             return;
1642         }
1643 
1644         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1645         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1646         //token.mint(teamAddr, tokenReward.div(10));
1647         //token.mint(address(this), tokenReward);
1648         pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1649         pool.lastRewardBlock = block.number;
1650         
1651     }
1652 
1653     function deposit(uint256 _pid, uint256 _amount) public {
1654         PoolInfo storage pool = poolInfo[_pid];
1655         UserInfo storage user = userInfo[_pid][msg.sender];
1656 
1657         //풀 레벨 보다 사용자 레벨이 높거나 같아야 함
1658         require(levelContract.getLevel(msg.sender) >= pool.level, "deposit : user level");
1659         //레벨 풀 일 경우 사용자는 레퍼럴에 등록되어 있어야 함
1660         if(pool.level > 0)
1661             require(referralContract.getGrade(msg.sender) > 0, "deposit : user referral");
1662 
1663         //(address parent, address[] children, uint256 grade) = referralContract.users(msg.sender);
1664         //require(grade > 0, "deposit : user referral");
1665 
1666         updatePool(_pid);
1667         if (user.amount > 0) {
1668             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1669             safeTokenTransfer(msg.sender, pending, pool.level);
1670         }
1671         if(_amount > 0) { //kevin
1672             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1673             user.amount = user.amount.add(_amount);
1674         }
1675         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1676         emit Deposit(msg.sender, _pid, _amount);
1677     }
1678     
1679     function depositFor(address _beneficiary, uint256 _pid, uint256 _amount) public {
1680         PoolInfo storage pool = poolInfo[_pid];
1681         UserInfo storage user = userInfo[_pid][_beneficiary];
1682 
1683         //풀 레벨 보다 사용자 레벨이 높거나 같아야 함
1684         require(levelContract.getLevel(_beneficiary) >= pool.level, "depositFor : user level");
1685         //레벨 풀 일 경우 사용자는 레퍼럴에 등록되어 있어야 함
1686         if(pool.level > 0)
1687             require(referralContract.getGrade(_beneficiary) > 0, "depositFor : user referral");
1688 
1689         updatePool(_pid);
1690         if (user.amount > 0) {
1691             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1692             safeTokenTransfer(_beneficiary, pending, pool.level);
1693         }
1694         if(_amount > 0) { //kevin
1695             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1696             user.amount = user.amount.add(_amount);
1697         }
1698         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1699         emit Deposit(_beneficiary, _pid, _amount);
1700     }
1701 
1702     function withdraw(uint256 _pid, uint256 _amount) public {
1703         PoolInfo storage pool = poolInfo[_pid];
1704         UserInfo storage user = userInfo[_pid][msg.sender];
1705         require(user.amount >= _amount, "withdraw: not good");
1706         updatePool(_pid);
1707         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1708         safeTokenTransfer(msg.sender, pending, pool.level);
1709         user.amount = user.amount.sub(_amount);
1710         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1711         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1712         emit Withdraw(msg.sender, _pid, _amount);
1713     }
1714 
1715     function emergencyWithdraw(uint256 _pid) public {
1716         PoolInfo storage pool = poolInfo[_pid];
1717         UserInfo storage user = userInfo[_pid][msg.sender];
1718         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1719         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1720         user.amount = 0;
1721         user.rewardDebt = 0;
1722     }
1723 
1724     function safeTokenTransfer(address _to, uint256 _amount, uint256 poolLevel) internal {
1725         uint256 tokenBal = token.balanceOf(address(this));
1726 
1727         if (_amount > tokenBal) {
1728             //grade == 2(레퍼럴)일때 상위 master에게 수수료 2%
1729             if( poolLevel > 0 && referralContract.getGrade(_to) == 2 ){
1730                 address master = referralContract.getParent(_to);
1731                 uint256 masterFee = tokenBal.mul(10).div(500); //2%
1732                 token.transfer(master, masterFee);
1733                 token.transfer(_to, tokenBal.sub(masterFee));
1734             //grade == 3(일반)일때 수수료 상위 parent 8%, master 2%
1735             } else if ( poolLevel > 0 && referralContract.getGrade(_to) == 3 ){
1736                 address parent = referralContract.getParent(_to);
1737                 address master = referralContract.getParent(parent);
1738                 uint256 parentFee = tokenBal.mul(10).div(125); //8%
1739                 uint256 masterFee = tokenBal.mul(10).div(500); //2%
1740                 token.transfer(parent, parentFee);
1741                 token.transfer(master, masterFee);
1742                 token.transfer(_to, tokenBal.sub(parentFee).sub(masterFee));
1743             } else
1744                 token.transfer(_to, tokenBal);
1745 
1746         } else {
1747             //grade == 2(레퍼럴)일때 상위 master에게 수수료 2%
1748             if( poolLevel > 0 && referralContract.getGrade(_to) == 2 ){
1749                 address master = referralContract.getParent(_to);
1750                 uint256 masterFee = _amount.mul(10).div(500); //2%
1751                 token.transfer(master, masterFee);
1752                 token.transfer(_to, _amount.sub(masterFee));
1753             //grade == 3(일반)일때 수수료 상위 parent 8%, master 2%
1754             } else if ( poolLevel > 0 && referralContract.getGrade(_to) == 3 ){
1755                 address parent = referralContract.getParent(_to);
1756                 address master = referralContract.getParent(parent);
1757                 uint256 parentFee = _amount.mul(10).div(125); //8%
1758                 uint256 masterFee = _amount.mul(10).div(500); //2%
1759                 token.transfer(parent, parentFee);
1760                 token.transfer(master, masterFee);
1761                 token.transfer(_to, _amount.sub(parentFee).sub(masterFee));
1762             } else
1763                 token.transfer(_to, _amount);
1764         }
1765     }
1766 
1767     // Update team address by the previous team.
1768     function team(address _teamAddr) public {
1769         require(msg.sender == teamAddr, "dev: wut?");
1770         teamAddr = _teamAddr;
1771     }
1772 
1773     function setEndBlock(uint256 _block) public onlyOwner {
1774         require(block.number < _block, "setEndBlock: err _block");
1775         endBlock = _block;
1776     }
1777 
1778 }