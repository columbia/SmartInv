1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IAddressResolver
8 
9 interface IAddressResolver {
10     
11     function key2address(bytes32 key) external view returns(address);
12     function address2key(address addr) external view returns(bytes32);
13     function requireAndKey2Address(bytes32 name, string calldata reason) external view returns(address);
14 
15     function setAddress(bytes32 key, address addr) external;
16     function setMultiAddress(bytes32[] memory keys, address[] memory addrs) external;
17     
18     function setKkAddr(bytes32 k1, bytes32 k2, address addr) external;
19     function setMultiKKAddr(bytes32[] memory k1s, bytes32[] memory k2s, address[] memory addrs) external;
20 
21     function kk2addr(bytes32 k1, bytes32 k2) external view returns(address);
22     function requireKKAddrs(bytes32 k1, bytes32 k2, string calldata reason) external view returns(address);
23 }
24 
25 // Part: IBoringDAO
26 
27 interface IBoringDAO {
28     // function openTunnel(bytes32 tunnelKey) external;
29 
30     function pledge(bytes32 tunnelKey, uint _amount) external;
31     function redeem(bytes32 tunnelKey, uint _amount) external;
32 
33     function approveMint(bytes32 tunnelKey, string memory _txid, uint _amount, address account, string memory assetAddress) external;
34     function burnBToken(bytes32 _tunnelKey, uint _amount, string memory assetAddress) external;
35 
36     // function getTrustee(uint index) external view returns(address);
37     // function getTrusteeCount() external view returns(uint);
38 
39 }
40 
41 // Part: IMintProposal
42 
43 interface IMintProposal {
44     function approve(
45         bytes32 _tunnelKey,
46         string memory _txid,
47         uint256 _amount,
48         address  to,
49         address trustee,
50         uint256 trusteeCount
51     ) external returns (bool);
52 }
53 
54 // Part: IOracle
55 
56 interface IOracle {
57     
58     function setPrice(bytes32 _symbol, uint _price) external;
59     function getPrice(bytes32 _symbol) external view returns (uint);
60 }
61 
62 // Part: IPaused
63 
64 interface IPaused {
65     function paused() external view returns (bool);
66 }
67 
68 // Part: ITrusteeFeePool
69 
70 interface ITrusteeFeePool {
71     function exit(address account) external;
72     function enter(address account) external;
73     function notifyReward(uint reward) external;
74 }
75 
76 // Part: ITunnel
77 
78 interface ITunnel {
79     function pledge(address account, uint amount) external;
80     function redeem(address account, uint amount) external;
81     function issue(address account, uint amount) external;
82     function burn(address account, uint amount, string memory assetAddress) external;
83     function totalValuePledge() external view  returns(uint);
84     function canIssueAmount() external view returns(uint);
85     function oTokenKey() external view returns(bytes32);
86 }
87 
88 // Part: ITunnelV2
89 
90 interface ITunnelV2 {
91     function pledge(address account, uint amount) external;
92     function redeem(address account, uint amount) external;
93     function issue(address account, uint amount) external;
94     function burn(address account, uint amount, string memory assetAddress) external;
95     function totalValuePledge() external view  returns(uint);
96     function canIssueAmount() external view returns(uint);
97 }
98 
99 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Address
100 
101 /**
102  * @dev Collection of functions related to the address type
103  */
104 library Address {
105     /**
106      * @dev Returns true if `account` is a contract.
107      *
108      * [IMPORTANT]
109      * ====
110      * It is unsafe to assume that an address for which this function returns
111      * false is an externally-owned account (EOA) and not a contract.
112      *
113      * Among others, `isContract` will return false for the following
114      * types of addresses:
115      *
116      *  - an externally-owned account
117      *  - a contract in construction
118      *  - an address where a contract will be created
119      *  - an address where a contract lived, but was destroyed
120      * ====
121      */
122     function isContract(address account) internal view returns (bool) {
123         // This method relies on extcodesize, which returns 0 for contracts in
124         // construction, since the code is only stored at the end of the
125         // constructor execution.
126 
127         uint256 size;
128         // solhint-disable-next-line no-inline-assembly
129         assembly { size := extcodesize(account) }
130         return size > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
153         (bool success, ) = recipient.call{ value: amount }("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain`call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176       return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         // solhint-disable-next-line avoid-low-level-calls
215         (bool success, bytes memory returndata) = target.call{ value: value }(data);
216         return _verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         // solhint-disable-next-line avoid-low-level-calls
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return _verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
244         if (success) {
245             return returndata;
246         } else {
247             // Look for revert reason and bubble it up if present
248             if (returndata.length > 0) {
249                 // The easiest way to bubble the revert reason is using memory via assembly
250 
251                 // solhint-disable-next-line no-inline-assembly
252                 assembly {
253                     let returndata_size := mload(returndata)
254                     revert(add(32, returndata), returndata_size)
255                 }
256             } else {
257                 revert(errorMessage);
258             }
259         }
260     }
261 }
262 
263 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Context
264 
265 /*
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with GSN meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 abstract contract Context {
276     function _msgSender() internal view virtual returns (address payable) {
277         return msg.sender;
278     }
279 
280     function _msgData() internal view virtual returns (bytes memory) {
281         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
282         return msg.data;
283     }
284 }
285 
286 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/EnumerableSet
287 
288 /**
289  * @dev Library for managing
290  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
291  * types.
292  *
293  * Sets have the following properties:
294  *
295  * - Elements are added, removed, and checked for existence in constant time
296  * (O(1)).
297  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
298  *
299  * ```
300  * contract Example {
301  *     // Add the library methods
302  *     using EnumerableSet for EnumerableSet.AddressSet;
303  *
304  *     // Declare a set state variable
305  *     EnumerableSet.AddressSet private mySet;
306  * }
307  * ```
308  *
309  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
310  * and `uint256` (`UintSet`) are supported.
311  */
312 library EnumerableSet {
313     // To implement this library for multiple types with as little code
314     // repetition as possible, we write it in terms of a generic Set type with
315     // bytes32 values.
316     // The Set implementation uses private functions, and user-facing
317     // implementations (such as AddressSet) are just wrappers around the
318     // underlying Set.
319     // This means that we can only create new EnumerableSets for types that fit
320     // in bytes32.
321 
322     struct Set {
323         // Storage of set values
324         bytes32[] _values;
325 
326         // Position of the value in the `values` array, plus 1 because index 0
327         // means a value is not in the set.
328         mapping (bytes32 => uint256) _indexes;
329     }
330 
331     /**
332      * @dev Add a value to a set. O(1).
333      *
334      * Returns true if the value was added to the set, that is if it was not
335      * already present.
336      */
337     function _add(Set storage set, bytes32 value) private returns (bool) {
338         if (!_contains(set, value)) {
339             set._values.push(value);
340             // The value is stored at length-1, but we add 1 to all indexes
341             // and use 0 as a sentinel value
342             set._indexes[value] = set._values.length;
343             return true;
344         } else {
345             return false;
346         }
347     }
348 
349     /**
350      * @dev Removes a value from a set. O(1).
351      *
352      * Returns true if the value was removed from the set, that is if it was
353      * present.
354      */
355     function _remove(Set storage set, bytes32 value) private returns (bool) {
356         // We read and store the value's index to prevent multiple reads from the same storage slot
357         uint256 valueIndex = set._indexes[value];
358 
359         if (valueIndex != 0) { // Equivalent to contains(set, value)
360             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
361             // the array, and then remove the last element (sometimes called as 'swap and pop').
362             // This modifies the order of the array, as noted in {at}.
363 
364             uint256 toDeleteIndex = valueIndex - 1;
365             uint256 lastIndex = set._values.length - 1;
366 
367             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
368             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
369 
370             bytes32 lastvalue = set._values[lastIndex];
371 
372             // Move the last value to the index where the value to delete is
373             set._values[toDeleteIndex] = lastvalue;
374             // Update the index for the moved value
375             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
376 
377             // Delete the slot where the moved value was stored
378             set._values.pop();
379 
380             // Delete the index for the deleted slot
381             delete set._indexes[value];
382 
383             return true;
384         } else {
385             return false;
386         }
387     }
388 
389     /**
390      * @dev Returns true if the value is in the set. O(1).
391      */
392     function _contains(Set storage set, bytes32 value) private view returns (bool) {
393         return set._indexes[value] != 0;
394     }
395 
396     /**
397      * @dev Returns the number of values on the set. O(1).
398      */
399     function _length(Set storage set) private view returns (uint256) {
400         return set._values.length;
401     }
402 
403    /**
404     * @dev Returns the value stored at position `index` in the set. O(1).
405     *
406     * Note that there are no guarantees on the ordering of values inside the
407     * array, and it may change when more values are added or removed.
408     *
409     * Requirements:
410     *
411     * - `index` must be strictly less than {length}.
412     */
413     function _at(Set storage set, uint256 index) private view returns (bytes32) {
414         require(set._values.length > index, "EnumerableSet: index out of bounds");
415         return set._values[index];
416     }
417 
418     // Bytes32Set
419 
420     struct Bytes32Set {
421         Set _inner;
422     }
423 
424     /**
425      * @dev Add a value to a set. O(1).
426      *
427      * Returns true if the value was added to the set, that is if it was not
428      * already present.
429      */
430     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
431         return _add(set._inner, value);
432     }
433 
434     /**
435      * @dev Removes a value from a set. O(1).
436      *
437      * Returns true if the value was removed from the set, that is if it was
438      * present.
439      */
440     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
441         return _remove(set._inner, value);
442     }
443 
444     /**
445      * @dev Returns true if the value is in the set. O(1).
446      */
447     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
448         return _contains(set._inner, value);
449     }
450 
451     /**
452      * @dev Returns the number of values in the set. O(1).
453      */
454     function length(Bytes32Set storage set) internal view returns (uint256) {
455         return _length(set._inner);
456     }
457 
458    /**
459     * @dev Returns the value stored at position `index` in the set. O(1).
460     *
461     * Note that there are no guarantees on the ordering of values inside the
462     * array, and it may change when more values are added or removed.
463     *
464     * Requirements:
465     *
466     * - `index` must be strictly less than {length}.
467     */
468     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
469         return _at(set._inner, index);
470     }
471 
472     // AddressSet
473 
474     struct AddressSet {
475         Set _inner;
476     }
477 
478     /**
479      * @dev Add a value to a set. O(1).
480      *
481      * Returns true if the value was added to the set, that is if it was not
482      * already present.
483      */
484     function add(AddressSet storage set, address value) internal returns (bool) {
485         return _add(set._inner, bytes32(uint256(value)));
486     }
487 
488     /**
489      * @dev Removes a value from a set. O(1).
490      *
491      * Returns true if the value was removed from the set, that is if it was
492      * present.
493      */
494     function remove(AddressSet storage set, address value) internal returns (bool) {
495         return _remove(set._inner, bytes32(uint256(value)));
496     }
497 
498     /**
499      * @dev Returns true if the value is in the set. O(1).
500      */
501     function contains(AddressSet storage set, address value) internal view returns (bool) {
502         return _contains(set._inner, bytes32(uint256(value)));
503     }
504 
505     /**
506      * @dev Returns the number of values in the set. O(1).
507      */
508     function length(AddressSet storage set) internal view returns (uint256) {
509         return _length(set._inner);
510     }
511 
512    /**
513     * @dev Returns the value stored at position `index` in the set. O(1).
514     *
515     * Note that there are no guarantees on the ordering of values inside the
516     * array, and it may change when more values are added or removed.
517     *
518     * Requirements:
519     *
520     * - `index` must be strictly less than {length}.
521     */
522     function at(AddressSet storage set, uint256 index) internal view returns (address) {
523         return address(uint256(_at(set._inner, index)));
524     }
525 
526 
527     // UintSet
528 
529     struct UintSet {
530         Set _inner;
531     }
532 
533     /**
534      * @dev Add a value to a set. O(1).
535      *
536      * Returns true if the value was added to the set, that is if it was not
537      * already present.
538      */
539     function add(UintSet storage set, uint256 value) internal returns (bool) {
540         return _add(set._inner, bytes32(value));
541     }
542 
543     /**
544      * @dev Removes a value from a set. O(1).
545      *
546      * Returns true if the value was removed from the set, that is if it was
547      * present.
548      */
549     function remove(UintSet storage set, uint256 value) internal returns (bool) {
550         return _remove(set._inner, bytes32(value));
551     }
552 
553     /**
554      * @dev Returns true if the value is in the set. O(1).
555      */
556     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
557         return _contains(set._inner, bytes32(value));
558     }
559 
560     /**
561      * @dev Returns the number of values on the set. O(1).
562      */
563     function length(UintSet storage set) internal view returns (uint256) {
564         return _length(set._inner);
565     }
566 
567    /**
568     * @dev Returns the value stored at position `index` in the set. O(1).
569     *
570     * Note that there are no guarantees on the ordering of values inside the
571     * array, and it may change when more values are added or removed.
572     *
573     * Requirements:
574     *
575     * - `index` must be strictly less than {length}.
576     */
577     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
578         return uint256(_at(set._inner, index));
579     }
580 }
581 
582 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/IERC20
583 
584 /**
585  * @dev Interface of the ERC20 standard as defined in the EIP.
586  */
587 interface IERC20 {
588     /**
589      * @dev Returns the amount of tokens in existence.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns the amount of tokens owned by `account`.
595      */
596     function balanceOf(address account) external view returns (uint256);
597 
598     /**
599      * @dev Moves `amount` tokens from the caller's account to `recipient`.
600      *
601      * Returns a boolean value indicating whether the operation succeeded.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transfer(address recipient, uint256 amount) external returns (bool);
606 
607     /**
608      * @dev Returns the remaining number of tokens that `spender` will be
609      * allowed to spend on behalf of `owner` through {transferFrom}. This is
610      * zero by default.
611      *
612      * This value changes when {approve} or {transferFrom} are called.
613      */
614     function allowance(address owner, address spender) external view returns (uint256);
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * IMPORTANT: Beware that changing an allowance with this method brings the risk
622      * that someone may use both the old and the new allowance by unfortunate
623      * transaction ordering. One possible solution to mitigate this race
624      * condition is to first reduce the spender's allowance to 0 and set the
625      * desired value afterwards:
626      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address spender, uint256 amount) external returns (bool);
631 
632     /**
633      * @dev Moves `amount` tokens from `sender` to `recipient` using the
634      * allowance mechanism. `amount` is then deducted from the caller's
635      * allowance.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
642 
643     /**
644      * @dev Emitted when `value` tokens are moved from one account (`from`) to
645      * another (`to`).
646      *
647      * Note that `value` may be zero.
648      */
649     event Transfer(address indexed from, address indexed to, uint256 value);
650 
651     /**
652      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
653      * a call to {approve}. `value` is the new allowance.
654      */
655     event Approval(address indexed owner, address indexed spender, uint256 value);
656 }
657 
658 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeMath
659 
660 /**
661  * @dev Wrappers over Solidity's arithmetic operations with added overflow
662  * checks.
663  *
664  * Arithmetic operations in Solidity wrap on overflow. This can easily result
665  * in bugs, because programmers usually assume that an overflow raises an
666  * error, which is the standard behavior in high level programming languages.
667  * `SafeMath` restores this intuition by reverting the transaction when an
668  * operation overflows.
669  *
670  * Using this library instead of the unchecked operations eliminates an entire
671  * class of bugs, so it's recommended to use it always.
672  */
673 library SafeMath {
674     /**
675      * @dev Returns the addition of two unsigned integers, reverting on
676      * overflow.
677      *
678      * Counterpart to Solidity's `+` operator.
679      *
680      * Requirements:
681      *
682      * - Addition cannot overflow.
683      */
684     function add(uint256 a, uint256 b) internal pure returns (uint256) {
685         uint256 c = a + b;
686         require(c >= a, "SafeMath: addition overflow");
687 
688         return c;
689     }
690 
691     /**
692      * @dev Returns the subtraction of two unsigned integers, reverting on
693      * overflow (when the result is negative).
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702         return sub(a, b, "SafeMath: subtraction overflow");
703     }
704 
705     /**
706      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
707      * overflow (when the result is negative).
708      *
709      * Counterpart to Solidity's `-` operator.
710      *
711      * Requirements:
712      *
713      * - Subtraction cannot overflow.
714      */
715     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
716         require(b <= a, errorMessage);
717         uint256 c = a - b;
718 
719         return c;
720     }
721 
722     /**
723      * @dev Returns the multiplication of two unsigned integers, reverting on
724      * overflow.
725      *
726      * Counterpart to Solidity's `*` operator.
727      *
728      * Requirements:
729      *
730      * - Multiplication cannot overflow.
731      */
732     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
733         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
734         // benefit is lost if 'b' is also tested.
735         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
736         if (a == 0) {
737             return 0;
738         }
739 
740         uint256 c = a * b;
741         require(c / a == b, "SafeMath: multiplication overflow");
742 
743         return c;
744     }
745 
746     /**
747      * @dev Returns the integer division of two unsigned integers. Reverts on
748      * division by zero. The result is rounded towards zero.
749      *
750      * Counterpart to Solidity's `/` operator. Note: this function uses a
751      * `revert` opcode (which leaves remaining gas untouched) while Solidity
752      * uses an invalid opcode to revert (consuming all remaining gas).
753      *
754      * Requirements:
755      *
756      * - The divisor cannot be zero.
757      */
758     function div(uint256 a, uint256 b) internal pure returns (uint256) {
759         return div(a, b, "SafeMath: division by zero");
760     }
761 
762     /**
763      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
764      * division by zero. The result is rounded towards zero.
765      *
766      * Counterpart to Solidity's `/` operator. Note: this function uses a
767      * `revert` opcode (which leaves remaining gas untouched) while Solidity
768      * uses an invalid opcode to revert (consuming all remaining gas).
769      *
770      * Requirements:
771      *
772      * - The divisor cannot be zero.
773      */
774     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
775         require(b > 0, errorMessage);
776         uint256 c = a / b;
777         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
778 
779         return c;
780     }
781 
782     /**
783      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
784      * Reverts when dividing by zero.
785      *
786      * Counterpart to Solidity's `%` operator. This function uses a `revert`
787      * opcode (which leaves remaining gas untouched) while Solidity uses an
788      * invalid opcode to revert (consuming all remaining gas).
789      *
790      * Requirements:
791      *
792      * - The divisor cannot be zero.
793      */
794     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
795         return mod(a, b, "SafeMath: modulo by zero");
796     }
797 
798     /**
799      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
800      * Reverts with custom message when dividing by zero.
801      *
802      * Counterpart to Solidity's `%` operator. This function uses a `revert`
803      * opcode (which leaves remaining gas untouched) while Solidity uses an
804      * invalid opcode to revert (consuming all remaining gas).
805      *
806      * Requirements:
807      *
808      * - The divisor cannot be zero.
809      */
810     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
811         require(b != 0, errorMessage);
812         return a % b;
813     }
814 }
815 
816 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/AccessControl
817 
818 /**
819  * @dev Contract module that allows children to implement role-based access
820  * control mechanisms.
821  *
822  * Roles are referred to by their `bytes32` identifier. These should be exposed
823  * in the external API and be unique. The best way to achieve this is by
824  * using `public constant` hash digests:
825  *
826  * ```
827  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
828  * ```
829  *
830  * Roles can be used to represent a set of permissions. To restrict access to a
831  * function call, use {hasRole}:
832  *
833  * ```
834  * function foo() public {
835  *     require(hasRole(MY_ROLE, msg.sender));
836  *     ...
837  * }
838  * ```
839  *
840  * Roles can be granted and revoked dynamically via the {grantRole} and
841  * {revokeRole} functions. Each role has an associated admin role, and only
842  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
843  *
844  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
845  * that only accounts with this role will be able to grant or revoke other
846  * roles. More complex role relationships can be created by using
847  * {_setRoleAdmin}.
848  *
849  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
850  * grant and revoke this role. Extra precautions should be taken to secure
851  * accounts that have been granted it.
852  */
853 abstract contract AccessControl is Context {
854     using EnumerableSet for EnumerableSet.AddressSet;
855     using Address for address;
856 
857     struct RoleData {
858         EnumerableSet.AddressSet members;
859         bytes32 adminRole;
860     }
861 
862     mapping (bytes32 => RoleData) private _roles;
863 
864     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
865 
866     /**
867      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
868      *
869      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
870      * {RoleAdminChanged} not being emitted signaling this.
871      *
872      * _Available since v3.1._
873      */
874     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
875 
876     /**
877      * @dev Emitted when `account` is granted `role`.
878      *
879      * `sender` is the account that originated the contract call, an admin role
880      * bearer except when using {_setupRole}.
881      */
882     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
883 
884     /**
885      * @dev Emitted when `account` is revoked `role`.
886      *
887      * `sender` is the account that originated the contract call:
888      *   - if using `revokeRole`, it is the admin role bearer
889      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
890      */
891     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
892 
893     /**
894      * @dev Returns `true` if `account` has been granted `role`.
895      */
896     function hasRole(bytes32 role, address account) public view returns (bool) {
897         return _roles[role].members.contains(account);
898     }
899 
900     /**
901      * @dev Returns the number of accounts that have `role`. Can be used
902      * together with {getRoleMember} to enumerate all bearers of a role.
903      */
904     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
905         return _roles[role].members.length();
906     }
907 
908     /**
909      * @dev Returns one of the accounts that have `role`. `index` must be a
910      * value between 0 and {getRoleMemberCount}, non-inclusive.
911      *
912      * Role bearers are not sorted in any particular way, and their ordering may
913      * change at any point.
914      *
915      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
916      * you perform all queries on the same block. See the following
917      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
918      * for more information.
919      */
920     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
921         return _roles[role].members.at(index);
922     }
923 
924     /**
925      * @dev Returns the admin role that controls `role`. See {grantRole} and
926      * {revokeRole}.
927      *
928      * To change a role's admin, use {_setRoleAdmin}.
929      */
930     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
931         return _roles[role].adminRole;
932     }
933 
934     /**
935      * @dev Grants `role` to `account`.
936      *
937      * If `account` had not been already granted `role`, emits a {RoleGranted}
938      * event.
939      *
940      * Requirements:
941      *
942      * - the caller must have ``role``'s admin role.
943      */
944     function grantRole(bytes32 role, address account) public virtual {
945         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
946 
947         _grantRole(role, account);
948     }
949 
950     /**
951      * @dev Revokes `role` from `account`.
952      *
953      * If `account` had been granted `role`, emits a {RoleRevoked} event.
954      *
955      * Requirements:
956      *
957      * - the caller must have ``role``'s admin role.
958      */
959     function revokeRole(bytes32 role, address account) public virtual {
960         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
961 
962         _revokeRole(role, account);
963     }
964 
965     /**
966      * @dev Revokes `role` from the calling account.
967      *
968      * Roles are often managed via {grantRole} and {revokeRole}: this function's
969      * purpose is to provide a mechanism for accounts to lose their privileges
970      * if they are compromised (such as when a trusted device is misplaced).
971      *
972      * If the calling account had been granted `role`, emits a {RoleRevoked}
973      * event.
974      *
975      * Requirements:
976      *
977      * - the caller must be `account`.
978      */
979     function renounceRole(bytes32 role, address account) public virtual {
980         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
981 
982         _revokeRole(role, account);
983     }
984 
985     /**
986      * @dev Grants `role` to `account`.
987      *
988      * If `account` had not been already granted `role`, emits a {RoleGranted}
989      * event. Note that unlike {grantRole}, this function doesn't perform any
990      * checks on the calling account.
991      *
992      * [WARNING]
993      * ====
994      * This function should only be called from the constructor when setting
995      * up the initial roles for the system.
996      *
997      * Using this function in any other way is effectively circumventing the admin
998      * system imposed by {AccessControl}.
999      * ====
1000      */
1001     function _setupRole(bytes32 role, address account) internal virtual {
1002         _grantRole(role, account);
1003     }
1004 
1005     /**
1006      * @dev Sets `adminRole` as ``role``'s admin role.
1007      *
1008      * Emits a {RoleAdminChanged} event.
1009      */
1010     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1011         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1012         _roles[role].adminRole = adminRole;
1013     }
1014 
1015     function _grantRole(bytes32 role, address account) private {
1016         if (_roles[role].members.add(account)) {
1017             emit RoleGranted(role, account, _msgSender());
1018         }
1019     }
1020 
1021     function _revokeRole(bytes32 role, address account) private {
1022         if (_roles[role].members.remove(account)) {
1023             emit RoleRevoked(role, account, _msgSender());
1024         }
1025     }
1026 }
1027 
1028 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Ownable
1029 
1030 /**
1031  * @dev Contract module which provides a basic access control mechanism, where
1032  * there is an account (an owner) that can be granted exclusive access to
1033  * specific functions.
1034  *
1035  * By default, the owner account will be the one that deploys the contract. This
1036  * can later be changed with {transferOwnership}.
1037  *
1038  * This module is used through inheritance. It will make available the modifier
1039  * `onlyOwner`, which can be applied to your functions to restrict their use to
1040  * the owner.
1041  */
1042 abstract contract Ownable is Context {
1043     address private _owner;
1044 
1045     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1046 
1047     /**
1048      * @dev Initializes the contract setting the deployer as the initial owner.
1049      */
1050     constructor () internal {
1051         address msgSender = _msgSender();
1052         _owner = msgSender;
1053         emit OwnershipTransferred(address(0), msgSender);
1054     }
1055 
1056     /**
1057      * @dev Returns the address of the current owner.
1058      */
1059     function owner() public view returns (address) {
1060         return _owner;
1061     }
1062 
1063     /**
1064      * @dev Throws if called by any account other than the owner.
1065      */
1066     modifier onlyOwner() {
1067         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1068         _;
1069     }
1070 
1071     /**
1072      * @dev Leaves the contract without owner. It will not be possible to call
1073      * `onlyOwner` functions anymore. Can only be called by the current owner.
1074      *
1075      * NOTE: Renouncing ownership will leave the contract without an owner,
1076      * thereby removing any functionality that is only available to the owner.
1077      */
1078     function renounceOwnership() public virtual onlyOwner {
1079         emit OwnershipTransferred(_owner, address(0));
1080         _owner = address(0);
1081     }
1082 
1083     /**
1084      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1085      * Can only be called by the current owner.
1086      */
1087     function transferOwnership(address newOwner) public virtual onlyOwner {
1088         require(newOwner != address(0), "Ownable: new owner is the zero address");
1089         emit OwnershipTransferred(_owner, newOwner);
1090         _owner = newOwner;
1091     }
1092 }
1093 
1094 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Pausable
1095 
1096 /**
1097  * @dev Contract module which allows children to implement an emergency stop
1098  * mechanism that can be triggered by an authorized account.
1099  *
1100  * This module is used through inheritance. It will make available the
1101  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1102  * the functions of your contract. Note that they will not be pausable by
1103  * simply including this module, only once the modifiers are put in place.
1104  */
1105 abstract contract Pausable is Context {
1106     /**
1107      * @dev Emitted when the pause is triggered by `account`.
1108      */
1109     event Paused(address account);
1110 
1111     /**
1112      * @dev Emitted when the pause is lifted by `account`.
1113      */
1114     event Unpaused(address account);
1115 
1116     bool private _paused;
1117 
1118     /**
1119      * @dev Initializes the contract in unpaused state.
1120      */
1121     constructor () internal {
1122         _paused = false;
1123     }
1124 
1125     /**
1126      * @dev Returns true if the contract is paused, and false otherwise.
1127      */
1128     function paused() public view returns (bool) {
1129         return _paused;
1130     }
1131 
1132     /**
1133      * @dev Modifier to make a function callable only when the contract is not paused.
1134      *
1135      * Requirements:
1136      *
1137      * - The contract must not be paused.
1138      */
1139     modifier whenNotPaused() {
1140         require(!_paused, "Pausable: paused");
1141         _;
1142     }
1143 
1144     /**
1145      * @dev Modifier to make a function callable only when the contract is paused.
1146      *
1147      * Requirements:
1148      *
1149      * - The contract must be paused.
1150      */
1151     modifier whenPaused() {
1152         require(_paused, "Pausable: not paused");
1153         _;
1154     }
1155 
1156     /**
1157      * @dev Triggers stopped state.
1158      *
1159      * Requirements:
1160      *
1161      * - The contract must not be paused.
1162      */
1163     function _pause() internal virtual whenNotPaused {
1164         _paused = true;
1165         emit Paused(_msgSender());
1166     }
1167 
1168     /**
1169      * @dev Returns to normal state.
1170      *
1171      * Requirements:
1172      *
1173      * - The contract must be paused.
1174      */
1175     function _unpause() internal virtual whenPaused {
1176         _paused = false;
1177         emit Unpaused(_msgSender());
1178     }
1179 }
1180 
1181 // Part: SafeDecimalMath
1182 
1183 // https://docs.synthetix.io/contracts/SafeDecimalMath
1184 library SafeDecimalMath {
1185     using SafeMath for uint;
1186 
1187     /* Number of decimal places in the representations. */
1188     uint8 public constant decimals = 18;
1189     uint8 public constant highPrecisionDecimals = 27;
1190 
1191     /* The number representing 1.0. */
1192     uint public constant UNIT = 10**uint(decimals);
1193 
1194     /* The number representing 1.0 for higher fidelity numbers. */
1195     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
1196     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
1197 
1198     /**
1199      * @return Provides an interface to UNIT.
1200      */
1201     function unit() external pure returns (uint) {
1202         return UNIT;
1203     }
1204 
1205     /**
1206      * @return Provides an interface to PRECISE_UNIT.
1207      */
1208     function preciseUnit() external pure returns (uint) {
1209         return PRECISE_UNIT;
1210     }
1211 
1212     /**
1213      * @return The result of multiplying x and y, interpreting the operands as fixed-point
1214      * decimals.
1215      *
1216      * @dev A unit factor is divided out after the product of x and y is evaluated,
1217      * so that product must be less than 2**256. As this is an integer division,
1218      * the internal division always rounds down. This helps save on gas. Rounding
1219      * is more expensive on gas.
1220      */
1221     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
1222         /* Divide by UNIT to remove the extra factor introduced by the product. */
1223         return x.mul(y) / UNIT;
1224     }
1225 
1226     /**
1227      * @return The result of safely multiplying x and y, interpreting the operands
1228      * as fixed-point decimals of the specified precision unit.
1229      *
1230      * @dev The operands should be in the form of a the specified unit factor which will be
1231      * divided out after the product of x and y is evaluated, so that product must be
1232      * less than 2**256.
1233      *
1234      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1235      * Rounding is useful when you need to retain fidelity for small decimal numbers
1236      * (eg. small fractions or percentages).
1237      */
1238     function _multiplyDecimalRound(
1239         uint x,
1240         uint y,
1241         uint precisionUnit
1242     ) private pure returns (uint) {
1243         /* Divide by UNIT to remove the extra factor introduced by the product. */
1244         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
1245 
1246         if (quotientTimesTen % 10 >= 5) {
1247             quotientTimesTen += 10;
1248         }
1249 
1250         return quotientTimesTen / 10;
1251     }
1252 
1253     /**
1254      * @return The result of safely multiplying x and y, interpreting the operands
1255      * as fixed-point decimals of a precise unit.
1256      *
1257      * @dev The operands should be in the precise unit factor which will be
1258      * divided out after the product of x and y is evaluated, so that product must be
1259      * less than 2**256.
1260      *
1261      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1262      * Rounding is useful when you need to retain fidelity for small decimal numbers
1263      * (eg. small fractions or percentages).
1264      */
1265     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1266         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
1267     }
1268 
1269     /**
1270      * @return The result of safely multiplying x and y, interpreting the operands
1271      * as fixed-point decimals of a standard unit.
1272      *
1273      * @dev The operands should be in the standard unit factor which will be
1274      * divided out after the product of x and y is evaluated, so that product must be
1275      * less than 2**256.
1276      *
1277      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1278      * Rounding is useful when you need to retain fidelity for small decimal numbers
1279      * (eg. small fractions or percentages).
1280      */
1281     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
1282         return _multiplyDecimalRound(x, y, UNIT);
1283     }
1284 
1285     /**
1286      * @return The result of safely dividing x and y. The return value is a high
1287      * precision decimal.
1288      *
1289      * @dev y is divided after the product of x and the standard precision unit
1290      * is evaluated, so the product of x and UNIT must be less than 2**256. As
1291      * this is an integer division, the result is always rounded down.
1292      * This helps save on gas. Rounding is more expensive on gas.
1293      */
1294     function divideDecimal(uint x, uint y) internal pure returns (uint) {
1295         /* Reintroduce the UNIT factor that will be divided out by y. */
1296         return x.mul(UNIT).div(y);
1297     }
1298 
1299     /**
1300      * @return The result of safely dividing x and y. The return value is as a rounded
1301      * decimal in the precision unit specified in the parameter.
1302      *
1303      * @dev y is divided after the product of x and the specified precision unit
1304      * is evaluated, so the product of x and the specified precision unit must
1305      * be less than 2**256. The result is rounded to the nearest increment.
1306      */
1307     function _divideDecimalRound(
1308         uint x,
1309         uint y,
1310         uint precisionUnit
1311     ) private pure returns (uint) {
1312         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
1313 
1314         if (resultTimesTen % 10 >= 5) {
1315             resultTimesTen += 10;
1316         }
1317 
1318         return resultTimesTen / 10;
1319     }
1320 
1321     /**
1322      * @return The result of safely dividing x and y. The return value is as a rounded
1323      * standard precision decimal.
1324      *
1325      * @dev y is divided after the product of x and the standard precision unit
1326      * is evaluated, so the product of x and the standard precision unit must
1327      * be less than 2**256. The result is rounded to the nearest increment.
1328      */
1329     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
1330         return _divideDecimalRound(x, y, UNIT);
1331     }
1332 
1333     /**
1334      * @return The result of safely dividing x and y. The return value is as a rounded
1335      * high precision decimal.
1336      *
1337      * @dev y is divided after the product of x and the high precision unit
1338      * is evaluated, so the product of x and the high precision unit must
1339      * be less than 2**256. The result is rounded to the nearest increment.
1340      */
1341     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1342         return _divideDecimalRound(x, y, PRECISE_UNIT);
1343     }
1344 
1345     /**
1346      * @dev Convert a standard decimal representation to a high precision one.
1347      */
1348     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
1349         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
1350     }
1351 
1352     /**
1353      * @dev Convert a high precision decimal to a standard decimal representation.
1354      */
1355     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1356         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1357 
1358         if (quotientTimesTen % 10 >= 5) {
1359             quotientTimesTen += 10;
1360         }
1361 
1362         return quotientTimesTen / 10;
1363     }
1364 }
1365 
1366 // Part: ParamBook
1367 
1368 contract ParamBook is Ownable {
1369     mapping(bytes32 => uint256) public params;
1370     mapping(bytes32 => mapping(bytes32 => uint256)) public params2;
1371 
1372     function setParams(bytes32 name, uint256 value) public onlyOwner {
1373         params[name] = value;
1374     }
1375 
1376     function setMultiParams(bytes32[] memory names, uint[] memory values) public onlyOwner {
1377         require(names.length == values.length, "ParamBook::setMultiParams:param length not match");
1378         for (uint i=0; i < names.length; i++ ) {
1379             params[names[i]] = values[i];
1380         }
1381     }
1382 
1383     function setParams2(
1384         bytes32 name1,
1385         bytes32 name2,
1386         uint256 value
1387     ) public onlyOwner {
1388         params2[name1][name2] = value;
1389     }
1390 
1391     function setMultiParams2(bytes32[] memory names1, bytes32[] memory names2, uint[] memory values) public onlyOwner {
1392         require(names1.length == names2.length, "ParamBook::setMultiParams2:param length not match");
1393         require(names1.length == values.length, "ParamBook::setMultiParams2:param length not match");
1394         for(uint i=0; i < names1.length; i++) {
1395             params2[names1[i]][names2[i]] = values[i];
1396         }
1397     }
1398 }
1399 
1400 // File: BoringDAOV2.sol
1401 
1402 /**
1403 @notice The BoringDAO contract is the entrance to the entire system, 
1404 providing the functions of pledge BOR, redeem BOR, mint bBTC, and destroy bBTC
1405  */
1406 contract BoringDAOV2 is AccessControl, IBoringDAO, Pausable {
1407     using SafeDecimalMath for uint256;
1408     using SafeMath for uint256;
1409 
1410     uint256 public amountByMint;
1411 
1412     bytes32 public constant MONITOR_ROLE = "MONITOR_ROLE ";
1413     bytes32 public constant GOV_ROLE = "GOV_ROLE";
1414 
1415     bytes32 public constant BOR = "BOR";
1416     bytes32 public constant PARAM_BOOK = "ParamBook";
1417     bytes32 public constant MINT_PROPOSAL = "MintProposal";
1418     bytes32 public constant ORACLE = "Oracle";
1419     bytes32 public constant TRUSTEE_FEE_POOL = "TrusteeFeePool";
1420     bytes32 public constant OTOKEN = "oToken";
1421 
1422     bytes32 public constant TUNNEL_MINT_FEE_RATE = "mint_fee";
1423     bytes32 public constant NETWORK_FEE = "network_fee";
1424 
1425     IAddressResolver public addrReso;
1426 
1427     // tunnels
1428     ITunnelV2[] public tunnels;
1429 
1430     uint256 public mintCap;
1431 
1432     address public mine;
1433 
1434     // The user may not provide the Ethereum address or the format of the Ethereum address is wrong when mint. 
1435     // this is for a transaction
1436     mapping(string=>bool) public approveFlag;
1437 
1438     uint public reductionAmount=1000e18;
1439 
1440 
1441     constructor(IAddressResolver _addrReso, uint _mintCap, address _mine) public {
1442         // set up resolver
1443         addrReso = _addrReso;
1444         mintCap = _mintCap;
1445         mine = _mine;
1446         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1447         _setupRole(MONITOR_ROLE, msg.sender);
1448     }
1449 
1450 
1451     function tunnel(bytes32 tunnelKey) internal view returns (ITunnel) {
1452         return ITunnel(addrReso.key2address(tunnelKey));
1453     }
1454 
1455     function otoken(bytes32 _tunnelKey) internal view returns (IERC20) {
1456         return IERC20(addrReso.requireKKAddrs(_tunnelKey, OTOKEN, "oToken not exist"));
1457     }
1458 
1459     function borERC20() internal view returns (IERC20) {
1460         return IERC20(addrReso.key2address(BOR));
1461     }
1462 
1463     function paramBook() internal view returns (ParamBook) {
1464         return ParamBook(addrReso.key2address(PARAM_BOOK));
1465     }
1466 
1467     function mintProposal() internal view returns (IMintProposal) {
1468         return IMintProposal(addrReso.key2address(MINT_PROPOSAL));
1469     }
1470 
1471     function oracle() internal view returns (IOracle) {
1472         return IOracle(addrReso.key2address(ORACLE));
1473     }
1474 
1475     // trustee fee pool key
1476     function trusteeFeePool(bytes32 _tunnelKey) internal view returns (ITrusteeFeePool) {
1477         return ITrusteeFeePool(addrReso.requireKKAddrs(_tunnelKey, TRUSTEE_FEE_POOL, "BoringDAO::TrusteeFeePool is address(0)"));
1478     }
1479 
1480     // trustee fee pool key => tfpk
1481     function addTrustee(address account, bytes32 _tunnelKey) public onlyAdmin {
1482         _setupRole(_tunnelKey, account);
1483         trusteeFeePool(_tunnelKey).enter(account);
1484 
1485     }
1486 
1487     function addTrustees(address[] memory accounts, bytes32 _tunnelKey) external onlyAdmin{
1488         for (uint256 i = 0; i < accounts.length; i++) {
1489             addTrustee(accounts[i], _tunnelKey);
1490         }
1491     }
1492 
1493     function removeTrustee(address account, bytes32 _tunnelKey) public onlyAdmin {
1494         revokeRole(_tunnelKey, account);
1495         trusteeFeePool(_tunnelKey).exit(account);
1496     }
1497 
1498     function setMine(address _mine) public onlyAdmin {
1499         mine = _mine;
1500     }
1501 
1502     function setMintCap(uint256 amount) public onlyAdmin {
1503         mintCap = amount;
1504     }
1505 
1506     /**
1507     @notice tunnelKey is byte32("symbol"), eg. bytes32("BTC")
1508      */
1509     function pledge(bytes32 _tunnelKey, uint256 _amount)
1510         public
1511         override
1512         whenNotPaused
1513         whenContractExist(_tunnelKey)
1514     {
1515         require(
1516             borERC20().allowance(msg.sender, address(this)) >= _amount,
1517             "not allow enough bor"
1518         );
1519 
1520         borERC20().transferFrom(
1521             msg.sender,
1522             address(tunnel(_tunnelKey)),
1523             _amount
1524         );
1525         tunnel(_tunnelKey).pledge(msg.sender, _amount);
1526     }
1527 
1528     /**
1529     @notice redeem bor from tunnel
1530      */
1531     function redeem(bytes32 _tunnelKey, uint256 _amount)
1532         public
1533         override
1534         whenNotPaused
1535         whenContractExist(_tunnelKey)
1536     {
1537         tunnel(_tunnelKey).redeem(msg.sender, _amount);
1538     }
1539 
1540     function burnBToken(bytes32 _tunnelKey, uint256 amount, string memory assetAddress)
1541         public
1542         override
1543         whenNotPaused
1544         whenContractExist(_tunnelKey)
1545         whenTunnelNotPause(_tunnelKey)
1546     {
1547         tunnel(_tunnelKey).burn(msg.sender, amount, assetAddress);
1548     }
1549 
1550     /**
1551     @notice trustee will call the function to approve mint bToken
1552     @param _txid the transaction id of bitcoin
1553     @param _amount the amount to mint, 1BTC = 1bBTC = 1*10**18 weibBTC
1554     @param to mint to the address
1555      */
1556     function approveMint(
1557         bytes32 _tunnelKey,
1558         string memory _txid,
1559         uint256 _amount,
1560         address to,
1561         string memory assetAddress
1562     ) public override whenNotPaused whenTunnelNotPause(_tunnelKey) onlyTrustee(_tunnelKey) {
1563         if(to == address(0)) {
1564             if (approveFlag[_txid] == false) {
1565                 approveFlag[_txid] = true;
1566                 emit ETHAddressNotExist(_tunnelKey, _txid, _amount, to, msg.sender, assetAddress);
1567             }
1568             return;
1569         }
1570         
1571         uint256 trusteeCount = getRoleMemberCount(_tunnelKey);
1572         bool shouldMint = mintProposal().approve(
1573             _tunnelKey,
1574             _txid,
1575             _amount,
1576             to,
1577             msg.sender,
1578             trusteeCount
1579         );
1580         if (!shouldMint) {
1581             return;
1582         }
1583         uint256 canIssueAmount = tunnel(_tunnelKey).canIssueAmount();
1584         if (_amount.add(otoken(_tunnelKey).totalSupply()) > canIssueAmount) {
1585             emit NotEnoughPledgeValue(
1586                 _tunnelKey,
1587                 _txid,
1588                 _amount,
1589                 to,
1590                 msg.sender,
1591                 assetAddress
1592             );
1593             return;
1594         }
1595         // fee calculate in tunnel
1596         tunnel(_tunnelKey).issue(to, _amount);
1597 
1598         uint borMintAmount = calculateMintBORAmount(_tunnelKey, _amount);
1599         if(borMintAmount != 0) {
1600             amountByMint = amountByMint.add(borMintAmount);
1601             borERC20().transferFrom(mine, to, borMintAmount);
1602         }
1603         emit ApproveMintSuccess(_tunnelKey, _txid, _amount, to, assetAddress);
1604     }
1605 
1606     function calculateMintBORAmount(bytes32 _tunnelKey, uint _amount) public view returns (uint) {
1607         if (amountByMint >= mintCap || _amount == 0) {
1608             return 0;
1609         }
1610         uint256 assetPrice = oracle().getPrice(_tunnelKey);
1611         uint256 borPrice = oracle().getPrice(BOR);
1612         //LTC for 1000
1613         uint256 reductionTimes = amountByMint.div(reductionAmount);
1614         uint256 mintFeeRate = paramBook().params2(
1615             _tunnelKey,
1616             TUNNEL_MINT_FEE_RATE
1617         );
1618         // for decimal calculation, so mul 1e18
1619         uint256 reductionFactor = (4**reductionTimes).mul(1e18).div(5**reductionTimes);
1620         uint networkFee = paramBook().params2(_tunnelKey, NETWORK_FEE);
1621         uint baseAmount = _amount.multiplyDecimalRound(mintFeeRate).mul(2).add(networkFee);
1622         uint borAmount = assetPrice.multiplyDecimalRound(baseAmount).multiplyDecimalRound(reductionFactor).divideDecimalRound(borPrice);
1623         if (amountByMint.add(borAmount) >= mintCap) {
1624             borAmount = mintCap.sub(amountByMint);
1625         }
1626         return borAmount;
1627     }
1628 
1629     function pause() public onlyMonitor{
1630         _pause();
1631     }
1632 
1633     function unpause() public onlyMonitor{
1634         _unpause();
1635     }
1636 
1637     modifier onlyTrustee(bytes32 _tunnelKey) {
1638         require(hasRole(_tunnelKey, msg.sender), "Caller is not trustee");
1639         _;
1640     }
1641 
1642     modifier onlyAdmin {
1643         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "BoringDAO::caller is not admin");
1644         _;
1645     }
1646 
1647     modifier onlyMonitor {
1648         require(
1649             hasRole(MONITOR_ROLE, msg.sender),
1650             "Caller is not monitor"
1651         );
1652         _;
1653     }
1654 
1655     modifier whenContractExist(bytes32 key) {
1656         require(
1657             addrReso.key2address(key) != address(0),
1658             "Contract not exist"
1659         );
1660         _;
1661     }
1662 
1663     modifier whenTunnelNotPause(bytes32 _tunnelKey) {
1664         address tunnelAddress = addrReso.requireAndKey2Address(_tunnelKey, "tunnel not exist");
1665         require(IPaused(tunnelAddress).paused() == false, "tunnel is paused");
1666         _;
1667     }
1668 
1669     event NotEnoughPledgeValue(
1670         bytes32 indexed _tunnelKey,
1671         string indexed _txid,
1672         uint256 _amount,
1673         address to,
1674         address trustee,
1675         string assetAddress
1676     );
1677 
1678     event ApproveMintSuccess(
1679         bytes32 _tunnelKey,
1680         string _txid,
1681         uint256 _amount,
1682         address to,
1683         string assetAddress
1684     );
1685 
1686     event ETHAddressNotExist(
1687         bytes32 _tunnelKey,
1688         string _txid,
1689         uint256 _amount,
1690         address to,
1691         address trustee,
1692         string assetAddress
1693     );
1694 
1695    
1696 }
