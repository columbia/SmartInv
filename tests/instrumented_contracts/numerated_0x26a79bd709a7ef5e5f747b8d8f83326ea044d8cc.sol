1 /**
2  * 
3  * 
4   
5 
6 $$$$$$$\   $$$$$$\  $$\   $$\ $$\   $$\  $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\  $$$$$$\  $$\           $$\           
7 $$  __$$\ $$  __$$\ $$$\  $$ |$$ | $$  |$$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\ $$ |          \__|          
8 $$ |  $$ |$$ /  $$ |$$$$\ $$ |$$ |$$  / $$ /  \__|$$ /  $$ |$$ /  \__|  $$ |  $$ /  $$ |$$ |          $$\  $$$$$$\  
9 $$$$$$$\ |$$$$$$$$ |$$ $$\$$ |$$$$$  /  \$$$$$$\  $$ |  $$ |$$ |        $$ |  $$$$$$$$ |$$ |          $$ |$$  __$$\ 
10 $$  __$$\ $$  __$$ |$$ \$$$$ |$$  $$<    \____$$\ $$ |  $$ |$$ |        $$ |  $$  __$$ |$$ |          $$ |$$ /  $$ |
11 $$ |  $$ |$$ |  $$ |$$ |\$$$ |$$ |\$$\  $$\   $$ |$$ |  $$ |$$ |  $$\   $$ |  $$ |  $$ |$$ |          $$ |$$ |  $$ |
12 $$$$$$$  |$$ |  $$ |$$ | \$$ |$$ | \$$\ \$$$$$$  | $$$$$$  |\$$$$$$  |$$$$$$\ $$ |  $$ |$$$$$$$$\ $$\ $$ |\$$$$$$  |
13 \_______/ \__|  \__|\__|  \__|\__|  \__| \______/  \______/  \______/ \______|\__|  \__|\________|\__|\__| \______/ 
14                                                                                                     
15 
16     #BANKSOCIAL features:
17     4% fee is added to the liquidity pool and locked for social consesus loans with each sell
18     3% fee auto distributed to all holders
19     
20     BankSocial is not a traditional bank.  We do not take deposits and we have no company structure that would
21     otherwise dictate how the bank is run.  The volunteers who started the token and website can go away but 
22     BankSocial will live on forever through its smart contracts and social consesus peer-to-peer lending model.
23     We are not federally insured, and we dont want to be, we are backed by the will of people and the community.
24 
25     By purchasing this token you agree that you are entering into an agreement with a self run community. 
26 
27     We want love and peace for the world, and for everyone to be a part of the new social capitalistic model.
28 
29  */
30 
31 pragma solidity ^0.6.1;
32 
33 // SPDX-License-Identifier: Unlicensed
34 
35 /**
36  * @dev Library for managing
37  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
38  * types.
39  *
40  * Sets have the following properties:
41  *
42  * - Elements are added, removed, and checked for existence in constant time
43  * (O(1)).
44  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
45  *
46  * ```
47  * contract Example {
48  *     // Add the library methods
49  *     using EnumerableSet for EnumerableSet.AddressSet;
50  *
51  *     // Declare a set state variable
52  *     EnumerableSet.AddressSet private mySet;
53  * }
54  * ```
55  *
56  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
57  * and `uint256` (`UintSet`) are supported.
58  */
59 library EnumerableSet {
60     // To implement this library for multiple types with as little code
61     // repetition as possible, we write it in terms of a generic Set type with
62     // bytes32 values.
63     // The Set implementation uses private functions, and user-facing
64     // implementations (such as AddressSet) are just wrappers around the
65     // underlying Set.
66     // This means that we can only create new EnumerableSets for types that fit
67     // in bytes32.
68 
69     struct Set {
70         // Storage of set values
71         bytes32[] _values;
72 
73         // Position of the value in the `values` array, plus 1 because index 0
74         // means a value is not in the set.
75         mapping (bytes32 => uint256) _indexes;
76     }
77 
78     /**
79      * @dev Add a value to a set. O(1).
80      *
81      * Returns true if the value was added to the set, that is if it was not
82      * already present.
83      */
84     function _add(Set storage set, bytes32 value) private returns (bool) {
85         if (!_contains(set, value)) {
86             set._values.push(value);
87             // The value is stored at length-1, but we add 1 to all indexes
88             // and use 0 as a sentinel value
89             set._indexes[value] = set._values.length;
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     /**
97      * @dev Removes a value from a set. O(1).
98      *
99      * Returns true if the value was removed from the set, that is if it was
100      * present.
101      */
102     function _remove(Set storage set, bytes32 value) private returns (bool) {
103         // We read and store the value's index to prevent multiple reads from the same storage slot
104         uint256 valueIndex = set._indexes[value];
105 
106         if (valueIndex != 0) { // Equivalent to contains(set, value)
107             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
108             // the array, and then remove the last element (sometimes called as 'swap and pop').
109             // This modifies the order of the array, as noted in {at}.
110 
111             uint256 toDeleteIndex = valueIndex - 1;
112             uint256 lastIndex = set._values.length - 1;
113 
114             if (lastIndex != toDeleteIndex) {
115                 bytes32 lastvalue = set._values[lastIndex];
116 
117                 // Move the last value to the index where the value to delete is
118                 set._values[toDeleteIndex] = lastvalue;
119                 // Update the index for the moved value
120                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
121             }
122 
123             // Delete the slot where the moved value was stored
124             set._values.pop();
125 
126             // Delete the index for the deleted slot
127             delete set._indexes[value];
128 
129             return true;
130         } else {
131             return false;
132         }
133     }
134 
135     /**
136      * @dev Returns true if the value is in the set. O(1).
137      */
138     function _contains(Set storage set, bytes32 value) private view returns (bool) {
139         return set._indexes[value] != 0;
140     }
141 
142     /**
143      * @dev Returns the number of values on the set. O(1).
144      */
145     function _length(Set storage set) private view returns (uint256) {
146         return set._values.length;
147     }
148 
149    /**
150     * @dev Returns the value stored at position `index` in the set. O(1).
151     *
152     * Note that there are no guarantees on the ordering of values inside the
153     * array, and it may change when more values are added or removed.
154     *
155     * Requirements:
156     *
157     * - `index` must be strictly less than {length}.
158     */
159     function _at(Set storage set, uint256 index) private view returns (bytes32) {
160         return set._values[index];
161     }
162 
163     // Bytes32Set
164 
165     struct Bytes32Set {
166         Set _inner;
167     }
168 
169     /**
170      * @dev Add a value to a set. O(1).
171      *
172      * Returns true if the value was added to the set, that is if it was not
173      * already present.
174      */
175     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
176         return _add(set._inner, value);
177     }
178 
179     /**
180      * @dev Removes a value from a set. O(1).
181      *
182      * Returns true if the value was removed from the set, that is if it was
183      * present.
184      */
185     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
186         return _remove(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns true if the value is in the set. O(1).
191      */
192     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
193         return _contains(set._inner, value);
194     }
195 
196     /**
197      * @dev Returns the number of values in the set. O(1).
198      */
199     function length(Bytes32Set storage set) internal view returns (uint256) {
200         return _length(set._inner);
201     }
202 
203    /**
204     * @dev Returns the value stored at position `index` in the set. O(1).
205     *
206     * Note that there are no guarantees on the ordering of values inside the
207     * array, and it may change when more values are added or removed.
208     *
209     * Requirements:
210     *
211     * - `index` must be strictly less than {length}.
212     */
213     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
214         return _at(set._inner, index);
215     }
216 
217     // AddressSet
218 
219     struct AddressSet {
220         Set _inner;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function add(AddressSet storage set, address value) internal returns (bool) {
230         return _add(set._inner, bytes32(uint256(uint160(value))));
231     }
232 
233     /**
234      * @dev Removes a value from a set. O(1).
235      *
236      * Returns true if the value was removed from the set, that is if it was
237      * present.
238      */
239     function remove(AddressSet storage set, address value) internal returns (bool) {
240         return _remove(set._inner, bytes32(uint256(uint160(value))));
241     }
242 
243     /**
244      * @dev Returns true if the value is in the set. O(1).
245      */
246     function contains(AddressSet storage set, address value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     /**
251      * @dev Returns the number of values in the set. O(1).
252      */
253     function length(AddressSet storage set) internal view returns (uint256) {
254         return _length(set._inner);
255     }
256 
257    /**
258     * @dev Returns the value stored at position `index` in the set. O(1).
259     *
260     * Note that there are no guarantees on the ordering of values inside the
261     * array, and it may change when more values are added or removed.
262     *
263     * Requirements:
264     *
265     * - `index` must be strictly less than {length}.
266     */
267     function at(AddressSet storage set, uint256 index) internal view returns (address) {
268         return address(uint160(uint256(_at(set._inner, index))));
269     }
270 
271 
272     // UintSet
273 
274     struct UintSet {
275         Set _inner;
276     }
277 
278     /**
279      * @dev Add a value to a set. O(1).
280      *
281      * Returns true if the value was added to the set, that is if it was not
282      * already present.
283      */
284     function add(UintSet storage set, uint256 value) internal returns (bool) {
285         return _add(set._inner, bytes32(value));
286     }
287 
288     /**
289      * @dev Removes a value from a set. O(1).
290      *
291      * Returns true if the value was removed from the set, that is if it was
292      * present.
293      */
294     function remove(UintSet storage set, uint256 value) internal returns (bool) {
295         return _remove(set._inner, bytes32(value));
296     }
297 
298     /**
299      * @dev Returns true if the value is in the set. O(1).
300      */
301     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
302         return _contains(set._inner, bytes32(value));
303     }
304 
305     /**
306      * @dev Returns the number of values on the set. O(1).
307      */
308     function length(UintSet storage set) internal view returns (uint256) {
309         return _length(set._inner);
310     }
311 
312    /**
313     * @dev Returns the value stored at position `index` in the set. O(1).
314     *
315     * Note that there are no guarantees on the ordering of values inside the
316     * array, and it may change when more values are added or removed.
317     *
318     * Requirements:
319     *
320     * - `index` must be strictly less than {length}.
321     */
322     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
323         return uint256(_at(set._inner, index));
324     }
325 }
326 
327 interface IERC20 {
328 
329     function totalSupply() external view returns (uint256);
330 
331     /**
332      * @dev Returns the amount of tokens owned by `account`.
333      */
334     function balanceOf(address account) external view returns (uint256);
335 
336     /**
337      * @dev Moves `amount` tokens from the caller's account to `recipient`.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transfer(address recipient, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Returns the remaining number of tokens that `spender` will be
347      * allowed to spend on behalf of `owner` through {transferFrom}. This is
348      * zero by default.
349      *
350      * This value changes when {approve} or {transferFrom} are called.
351      */
352     function allowance(address owner, address spender) external view returns (uint256);
353 
354     /**
355      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * IMPORTANT: Beware that changing an allowance with this method brings the risk
360      * that someone may use both the old and the new allowance by unfortunate
361      * transaction ordering. One possible solution to mitigate this race
362      * condition is to first reduce the spender's allowance to 0 and set the
363      * desired value afterwards:
364      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
365      *
366      * Emits an {Approval} event.
367      */
368     function approve(address spender, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Moves `amount` tokens from `sender` to `recipient` using the
372      * allowance mechanism. `amount` is then deducted from the caller's
373      * allowance.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Emitted when `value` tokens are moved from one account (`from`) to
383      * another (`to`).
384      *
385      * Note that `value` may be zero.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     /**
390      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
391      * a call to {approve}. `value` is the new allowance.
392      */
393     event Approval(address indexed owner, address indexed spender, uint256 value);
394 }
395 
396 
397 
398 /**
399  * @dev Wrappers over Solidity's arithmetic operations with added overflow
400  * checks.
401  *
402  * Arithmetic operations in Solidity wrap on overflow. This can easily result
403  * in bugs, because programmers usually assume that an overflow raises an
404  * error, which is the standard behavior in high level programming languages.
405  * `SafeMath` restores this intuition by reverting the transaction when an
406  * operation overflows.
407  *
408  * Using this library instead of the unchecked operations eliminates an entire
409  * class of bugs, so it's recommended to use it always.
410  */
411  
412 library SafeMath {
413     /**
414      * @dev Returns the addition of two unsigned integers, reverting on
415      * overflow.
416      *
417      * Counterpart to Solidity's `+` operator.
418      *
419      * Requirements:
420      *
421      * - Addition cannot overflow.
422      */
423     function add(uint256 a, uint256 b) internal pure returns (uint256) {
424         uint256 c = a + b;
425         require(c >= a, "SafeMath: addition overflow");
426 
427         return c;
428     }
429 
430     /**
431      * @dev Returns the subtraction of two unsigned integers, reverting on
432      * overflow (when the result is negative).
433      *
434      * Counterpart to Solidity's `-` operator.
435      *
436      * Requirements:
437      *
438      * - Subtraction cannot overflow.
439      */
440     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
441         return sub(a, b, "SafeMath: subtraction overflow");
442     }
443 
444     /**
445      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
446      * overflow (when the result is negative).
447      *
448      * Counterpart to Solidity's `-` operator.
449      *
450      * Requirements:
451      *
452      * - Subtraction cannot overflow.
453      */
454     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
455         require(b <= a, errorMessage);
456         uint256 c = a - b;
457 
458         return c;
459     }
460 
461     /**
462      * @dev Returns the multiplication of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `*` operator.
466      *
467      * Requirements:
468      *
469      * - Multiplication cannot overflow.
470      */
471     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
472         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
473         // benefit is lost if 'b' is also tested.
474         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
475         if (a == 0) {
476             return 0;
477         }
478 
479         uint256 c = a * b;
480         require(c / a == b, "SafeMath: multiplication overflow");
481 
482         return c;
483     }
484 
485     /**
486      * @dev Returns the integer division of two unsigned integers. Reverts on
487      * division by zero. The result is rounded towards zero.
488      *
489      * Counterpart to Solidity's `/` operator. Note: this function uses a
490      * `revert` opcode (which leaves remaining gas untouched) while Solidity
491      * uses an invalid opcode to revert (consuming all remaining gas).
492      *
493      * Requirements:
494      *
495      * - The divisor cannot be zero.
496      */
497     function div(uint256 a, uint256 b) internal pure returns (uint256) {
498         return div(a, b, "SafeMath: division by zero");
499     }
500 
501     /**
502      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
503      * division by zero. The result is rounded towards zero.
504      *
505      * Counterpart to Solidity's `/` operator. Note: this function uses a
506      * `revert` opcode (which leaves remaining gas untouched) while Solidity
507      * uses an invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
514         require(b > 0, errorMessage);
515         uint256 c = a / b;
516         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
517 
518         return c;
519     }
520 
521     /**
522      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
523      * Reverts when dividing by zero.
524      *
525      * Counterpart to Solidity's `%` operator. This function uses a `revert`
526      * opcode (which leaves remaining gas untouched) while Solidity uses an
527      * invalid opcode to revert (consuming all remaining gas).
528      *
529      * Requirements:
530      *
531      * - The divisor cannot be zero.
532      */
533     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
534         return mod(a, b, "SafeMath: modulo by zero");
535     }
536 
537     /**
538      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
539      * Reverts with custom message when dividing by zero.
540      *
541      * Counterpart to Solidity's `%` operator. This function uses a `revert`
542      * opcode (which leaves remaining gas untouched) while Solidity uses an
543      * invalid opcode to revert (consuming all remaining gas).
544      *
545      * Requirements:
546      *
547      * - The divisor cannot be zero.
548      */
549     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
550         require(b != 0, errorMessage);
551         return a % b;
552     }
553 }
554 
555 abstract contract Context {
556     function _msgSender() private view  returns (address payable) {
557         return payable(msg.sender);
558     }
559 
560     function _msgData() private view  returns (bytes memory) {
561         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
562         return msg.data;
563     }
564 }
565 
566 /**
567  * @dev Collection of functions related to the address type
568  */
569 library Address {
570     /**
571      * @dev Returns true if `account` is a contract.
572      *
573      * [IMPORTANT]
574      * ====
575      * It is unsafe to assume that an address for which this function returns
576      * false is an externally-owned account (EOA) and not a contract.
577      *
578      * Among others, `isContract` will return false for the following
579      * types of addresses:
580      *
581      *  - an externally-owned account
582      *  - a contract in construction
583      *  - an address where a contract will be created
584      *  - an address where a contract lived, but was destroyed
585      * ====
586      */
587     function isContract(address account) internal view returns (bool) {
588         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
589         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
590         // for accounts without code, i.e. `keccak256('')`
591         bytes32 codehash;
592         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
593         // solhint-disable-next-line no-inline-assembly
594         assembly { codehash := extcodehash(account) }
595         return (codehash != accountHash && codehash != 0x0);
596     }
597 
598     /**
599      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
600      * `recipient`, forwarding all available gas and reverting on errors.
601      *
602      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
603      * of certain opcodes, possibly making contracts go over the 2300 gas limit
604      * imposed by `transfer`, making them unable to receive funds via
605      * `transfer`. {sendValue} removes this limitation.
606      *
607      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
608      *
609      * IMPORTANT: because control is transferred to `recipient`, care must be
610      * taken to not create reentrancy vulnerabilities. Consider using
611      * {ReentrancyGuard} or the
612      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
613      */
614     function sendValue(address payable recipient, uint256 amount) internal {
615         require(address(this).balance >= amount, "Address: insufficient balance");
616 
617         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
618         (bool success, ) = recipient.call{ value: amount }("");
619         require(success, "Address: unable to send value, recipient may have reverted");
620     }
621 
622     /**
623      * @dev Performs a Solidity function call using a low level `call`. A
624      * plain`call` is an unsafe replacement for a function call: use this
625      * function instead.
626      *
627      * If `target` reverts with a revert reason, it is bubbled up by this
628      * function (like regular Solidity function calls).
629      *
630      * Returns the raw returned data. To convert to the expected return value,
631      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
632      *
633      * Requirements:
634      *
635      * - `target` must be a contract.
636      * - calling `target` with `data` must not revert.
637      *
638      * _Available since v3.1._
639      */
640     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
641       return functionCall(target, data, "Address: low-level call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
646      * `errorMessage` as a fallback revert reason when `target` reverts.
647      *
648      * _Available since v3.1._
649      */
650     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
651         return _functionCallWithValue(target, data, 0, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but also transferring `value` wei to `target`.
657      *
658      * Requirements:
659      *
660      * - the calling contract must have an ETH balance of at least `value`.
661      * - the called Solidity function must be `payable`.
662      *
663      * _Available since v3.1._
664      */
665     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
666         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
671      * with `errorMessage` as a fallback revert reason when `target` reverts.
672      *
673      * _Available since v3.1._
674      */
675     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
676         require(address(this).balance >= value, "Address: insufficient balance for call");
677         return _functionCallWithValue(target, data, value, errorMessage);
678     }
679 
680     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
681         require(isContract(target), "Address: call to non-contract");
682 
683         // solhint-disable-next-line avoid-low-level-calls
684         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 // solhint-disable-next-line no-inline-assembly
693                 assembly {
694                     let returndata_size := mload(returndata)
695                     revert(add(32, returndata), returndata_size)
696                 }
697             } else {
698                 revert(errorMessage);
699             }
700         }
701     }
702 }
703 
704 /**
705  * @dev Contract module which provides a basic access control mechanism, where
706  * there is an account (an owner) that can be granted exclusive access to
707  * specific functions.
708  *
709  * By default, the owner account will be the one that deploys the contract. This
710  * can later be changed with {transferOwnership}.
711  *
712  * This module is used through inheritance. It will make available the modifier
713  * `onlyOwner`, which can be applied to your functions to restrict their use to
714  * the owner.
715  */
716 contract Ownable is Context {
717     address private _owner;
718     address private _previousOwner;
719     uint256 private _lockTime;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor () internal {
727         address msgSender = msg.sender;
728         _owner = msgSender;
729         emit OwnershipTransferred(address(0), msgSender);
730     }
731 
732     /**
733      * @dev Returns the address of the current owner.
734      */
735     function owner() public view returns (address) {
736         return _owner;
737     }
738 
739     /**
740      * @dev Throws if called by any account other than the owner.
741      */
742     modifier onlyOwner() {
743         require(_owner == msg.sender, "Ownable: caller is not the owner");
744         _;
745     }
746 
747      /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * `onlyOwner` functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public virtual onlyOwner {
755         emit OwnershipTransferred(_owner, address(0));
756         _owner = address(0);
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         emit OwnershipTransferred(_owner, newOwner);
766         _owner = newOwner;
767     }
768 
769     function geUnlockTime() public view returns (uint256) {
770         return _lockTime;
771     }
772 
773     //Locks the contract for owner for the amount of time provided
774     function lock(uint256 time) public virtual onlyOwner {
775         _previousOwner = _owner;
776         _owner = address(0);
777         _lockTime = block.timestamp + time;
778         emit OwnershipTransferred(_owner, address(0));
779     }
780     
781     //Unlocks the contract for owner when _lockTime is exceeds
782     function unlock() public virtual {
783         require(_previousOwner == msg.sender, "You don't have permission to unlock");
784         require(block.timestamp > _lockTime , "Contract is locked for 7 days");
785         emit OwnershipTransferred(_owner, _previousOwner);
786         _owner = _previousOwner;
787     }
788 }
789 
790 // pragma solidity >=0.5.0;
791 
792 interface IUniswapV2Factory {
793     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
794 
795     function feeTo() external view returns (address);
796     function feeToSetter() external view returns (address);
797 
798     function getPair(address tokenA, address tokenB) external view returns (address pair);
799     function allPairs(uint) external view returns (address pair);
800     function allPairsLength() external view returns (uint);
801 
802     function createPair(address tokenA, address tokenB) external returns (address pair);
803 
804     function setFeeTo(address) external;
805     function setFeeToSetter(address) external;
806 }
807 
808 
809 // pragma solidity >=0.5.0;
810 
811 interface IUniswapV2Pair {
812     event Approval(address indexed owner, address indexed spender, uint value);
813     event Transfer(address indexed from, address indexed to, uint value);
814 
815     function name() external pure returns (string memory);
816     function symbol() external pure returns (string memory);
817     function decimals() external pure returns (uint8);
818     function totalSupply() external view returns (uint);
819     function balanceOf(address owner) external view returns (uint);
820     function allowance(address owner, address spender) external view returns (uint);
821 
822     function approve(address spender, uint value) external returns (bool);
823     function transfer(address to, uint value) external returns (bool);
824     function transferFrom(address from, address to, uint value) external returns (bool);
825 
826     function DOMAIN_SEPARATOR() external view returns (bytes32);
827     function PERMIT_TYPEHASH() external pure returns (bytes32);
828     function nonces(address owner) external view returns (uint);
829 
830     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
831 
832     event Mint(address indexed sender, uint amount0, uint amount1);
833     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
834     event Swap(
835         address indexed sender,
836         uint amount0In,
837         uint amount1In,
838         uint amount0Out,
839         uint amount1Out,
840         address indexed to
841     );
842     event Sync(uint112 reserve0, uint112 reserve1);
843 
844     function MINIMUM_LIQUIDITY() external pure returns (uint);
845     function factory() external view returns (address);
846     function token0() external view returns (address);
847     function token1() external view returns (address);
848     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
849     function price0CumulativeLast() external view returns (uint);
850     function price1CumulativeLast() external view returns (uint);
851     function kLast() external view returns (uint);
852 
853     function mint(address to) external returns (uint liquidity);
854     function burn(address to) external returns (uint amount0, uint amount1);
855     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
856     function skim(address to) external;
857     function sync() external;
858 
859     function initialize(address, address) external;
860 }
861 
862 // pragma solidity >=0.6.2;
863 
864 interface IUniswapV2Router01 {
865     function factory() external pure returns (address);
866     function WETH() external pure returns (address);
867 
868     function addLiquidity(
869         address tokenA,
870         address tokenB,
871         uint amountADesired,
872         uint amountBDesired,
873         uint amountAMin,
874         uint amountBMin,
875         address to,
876         uint deadline
877     ) external returns (uint amountA, uint amountB, uint liquidity);
878     function addLiquidityETH(
879         address token,
880         uint amountTokenDesired,
881         uint amountTokenMin,
882         uint amountETHMin,
883         address to,
884         uint deadline
885     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
886     function removeLiquidity(
887         address tokenA,
888         address tokenB,
889         uint liquidity,
890         uint amountAMin,
891         uint amountBMin,
892         address to,
893         uint deadline
894     ) external returns (uint amountA, uint amountB);
895     function removeLiquidityETH(
896         address token,
897         uint liquidity,
898         uint amountTokenMin,
899         uint amountETHMin,
900         address to,
901         uint deadline
902     ) external returns (uint amountToken, uint amountETH);
903     function removeLiquidityWithPermit(
904         address tokenA,
905         address tokenB,
906         uint liquidity,
907         uint amountAMin,
908         uint amountBMin,
909         address to,
910         uint deadline,
911         bool approveMax, uint8 v, bytes32 r, bytes32 s
912     ) external returns (uint amountA, uint amountB);
913     function removeLiquidityETHWithPermit(
914         address token,
915         uint liquidity,
916         uint amountTokenMin,
917         uint amountETHMin,
918         address to,
919         uint deadline,
920         bool approveMax, uint8 v, bytes32 r, bytes32 s
921     ) external returns (uint amountToken, uint amountETH);
922     function swapExactTokensForTokens(
923         uint amountIn,
924         uint amountOutMin,
925         address[] calldata path,
926         address to,
927         uint deadline
928     ) external returns (uint[] memory amounts);
929     function swapTokensForExactTokens(
930         uint amountOut,
931         uint amountInMax,
932         address[] calldata path,
933         address to,
934         uint deadline
935     ) external returns (uint[] memory amounts);
936     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
937         external
938         payable
939         returns (uint[] memory amounts);
940     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
941         external
942         returns (uint[] memory amounts);
943     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
944         external
945         returns (uint[] memory amounts);
946     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
947         external
948         payable
949         returns (uint[] memory amounts);
950 
951     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
952     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
953     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
954     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
955     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
956 }
957 
958 
959 
960 // pragma solidity >=0.6.2;
961 
962 interface IUniswapV2Router02 is IUniswapV2Router01 {
963     function removeLiquidityETHSupportingFeeOnTransferTokens(
964         address token,
965         uint liquidity,
966         uint amountTokenMin,
967         uint amountETHMin,
968         address to,
969         uint deadline
970     ) external returns (uint amountETH);
971     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
972         address token,
973         uint liquidity,
974         uint amountTokenMin,
975         uint amountETHMin,
976         address to,
977         uint deadline,
978         bool approveMax, uint8 v, bytes32 r, bytes32 s
979     ) external returns (uint amountETH);
980 
981     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
982         uint amountIn,
983         uint amountOutMin,
984         address[] calldata path,
985         address to,
986         uint deadline
987     ) external;
988     function swapExactETHForTokensSupportingFeeOnTransferTokens(
989         uint amountOutMin,
990         address[] calldata path,
991         address to,
992         uint deadline
993     ) external payable;
994     function swapExactTokensForETHSupportingFeeOnTransferTokens(
995         uint amountIn,
996         uint amountOutMin,
997         address[] calldata path,
998         address to,
999         uint deadline
1000     ) external;
1001 }
1002 
1003 
1004 contract BankSocial is Context, IERC20, Ownable {
1005     using EnumerableSet for EnumerableSet.AddressSet;
1006     using SafeMath for uint256;
1007     using Address for address;
1008 
1009     mapping (address => uint256) private _rOwned;
1010     mapping (address => uint256) private _tOwned;
1011     mapping (address => mapping (address => uint256)) private _allowances;
1012 
1013     mapping (address => bool) private _isExcludedFromFee;
1014 
1015     mapping (address => bool) private _isExcluded;
1016     EnumerableSet.AddressSet private _excluded;
1017    
1018     uint256 private constant MAX = ~uint256(0);
1019     uint256 constant private _tTotal = 1000000000 * 10**5 * 10**7;
1020     uint256 private _rTotal = (MAX - (MAX % _tTotal));
1021     uint256 private _tFeeTotal;
1022 
1023     string constant private _name = "BankSocial";
1024     string constant private _symbol = "BSOCIAL";
1025     uint8 constant private _decimals = 8;
1026     
1027     uint256 public _taxFee = 3;
1028     uint256 private _previousTaxFee = _taxFee;
1029     
1030     uint256 public _liquidityFee = 4;
1031     uint256 private _previousLiquidityFee = _liquidityFee;
1032 
1033     IUniswapV2Router02 public  uniswapV2Router;
1034     address public  uniswapV2Pair;
1035     
1036     bool inSwapAndLiquify;
1037     bool public swapAndLiquifyEnabled = true;
1038     
1039     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
1040     uint256 constant private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
1041     
1042     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1043     event SwapAndLiquifyEnabledUpdated(bool enabled);
1044     event SwapAndLiquify(
1045         uint256 tokensSwapped,
1046         uint256 ethReceived,
1047         uint256 tokensIntoLiquidity
1048     );
1049     
1050     modifier lockTheSwap {
1051         inSwapAndLiquify = true;
1052         _;
1053         inSwapAndLiquify = false;
1054     }
1055     
1056     constructor () public {
1057         _rOwned[msg.sender] = _rTotal;
1058         
1059         //Changed to UNISWAP Router
1060         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1061          // Create a uniswap pair for this new token
1062         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1063             .createPair(address(this), _uniswapV2Router.WETH());
1064 
1065         // set the rest of the contract variables
1066         uniswapV2Router = _uniswapV2Router;
1067         
1068         //exclude owner and this contract from fee
1069         _isExcludedFromFee[owner()] = true;
1070         _isExcludedFromFee[address(this)] = true;
1071         
1072         emit Transfer(address(0), msg.sender, _tTotal);
1073     }
1074 
1075     function name() public view returns (string memory) {
1076         return _name;
1077     }
1078 
1079     function symbol() public view returns (string memory) {
1080         return _symbol;
1081     }
1082 
1083     function decimals() public view returns (uint8) {
1084         return _decimals;
1085     }
1086 
1087     function totalSupply() public view override returns (uint256) {
1088         return _tTotal;
1089     }
1090 
1091     function balanceOf(address account) public view override returns (uint256) {
1092         if (_isExcluded[account]) return _tOwned[account];
1093         return tokenFromReflection(_rOwned[account]);
1094     }
1095 
1096     function transfer(address recipient, uint256 amount) public override returns (bool) {
1097         _transfer(msg.sender, recipient, amount);
1098         return true;
1099     }
1100 
1101     function allowance(address owner, address spender) public view override returns (uint256) {
1102         return _allowances[owner][spender];
1103     }
1104 
1105     function approve(address spender, uint256 amount) public override returns (bool) {
1106         _approve(msg.sender, spender, amount);
1107         return true;
1108     }
1109 
1110     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1111         _transfer(sender, recipient, amount);
1112         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
1113         return true;
1114     }
1115 
1116     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1117         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
1118         return true;
1119     }
1120 
1121     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1122         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1123         return true;
1124     }
1125 
1126     function isExcludedFromReward(address account) public view returns (bool) {
1127         return _isExcluded[account];
1128     }
1129 
1130     function totalFees() public view returns (uint256) {
1131         return _tFeeTotal;
1132     }
1133 
1134     function deliver(uint256 tAmount) public {
1135         address sender = msg.sender;
1136         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1137         (uint256 rAmount,,,,,) = _getValues(tAmount);
1138         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1139         _rTotal = _rTotal.sub(rAmount);
1140         _tFeeTotal = _tFeeTotal.add(tAmount);
1141     }
1142 
1143     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1144         require(tAmount <= _tTotal, "Amount must be less than supply");
1145         if (!deductTransferFee) {
1146             (uint256 rAmount,,,,,) = _getValues(tAmount);
1147             return rAmount;
1148         } else {
1149             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1150             return rTransferAmount;
1151         }
1152     }
1153 
1154     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1155         require(rAmount <= _rTotal, "Amount must be less than total reflection");
1156         uint256 currentRate =  _getRate();
1157         return rAmount.div(currentRate);
1158     }
1159 
1160     function excludeFromReward(address account) public onlyOwner() {
1161         require(!_isExcluded[account], "Account is already excluded");
1162         if(_rOwned[account] > 0) {
1163             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1164         }
1165         _isExcluded[account] = true;
1166         _excluded.add(account);
1167     }
1168 
1169     function includeInReward(address account) external onlyOwner() {
1170         require(_isExcluded[account], "Account is not excluded");
1171         for (uint256 i = 0; i < _excluded.length(); i++) {
1172             if (_excluded.contains(account)) {
1173                 _tOwned[account] = 0;
1174                 _isExcluded[account] = false;
1175                 _excluded.remove(account);
1176                 break;
1177             }
1178         }
1179     }
1180     
1181     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1182         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1183         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1184         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1185         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1186         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1187         _takeLiquidity(tLiquidity);
1188         _reflectFee(rFee, tFee);
1189         emit Transfer(sender, recipient, tTransferAmount);
1190     }
1191     
1192     function excludeFromFee(address account) public onlyOwner {
1193         _isExcludedFromFee[account] = true;
1194     }
1195     
1196     function includeInFee(address account) public onlyOwner {
1197         _isExcludedFromFee[account] = false;
1198     }
1199     
1200     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1201         _taxFee = taxFee;
1202     }
1203     
1204     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1205         _liquidityFee = liquidityFee;
1206     }
1207    
1208     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1209         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1210             10**2
1211         );
1212     }
1213 
1214     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1215         swapAndLiquifyEnabled = _enabled;
1216         emit SwapAndLiquifyEnabledUpdated(_enabled);
1217     }
1218     
1219      //to receive ETH from uniswapV2Router when swapping
1220     receive() external payable {}
1221 
1222     function _reflectFee(uint256 rFee, uint256 tFee) private {
1223         _rTotal = _rTotal.sub(rFee);
1224         _tFeeTotal = _tFeeTotal.add(tFee);
1225     }
1226 
1227     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1228         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1229         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1230         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1231     }
1232 
1233     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1234         uint256 tFee = calculateTaxFee(tAmount);
1235         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1236         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1237         return (tTransferAmount, tFee, tLiquidity);
1238     }
1239 
1240     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1241         uint256 rAmount = tAmount.mul(currentRate);
1242         uint256 rFee = tFee.mul(currentRate);
1243         uint256 rLiquidity = tLiquidity.mul(currentRate);
1244         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1245         return (rAmount, rTransferAmount, rFee);
1246     }
1247 
1248     function _getRate() private view returns(uint256) {
1249         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1250         return rSupply.div(tSupply);
1251     }
1252 
1253     function _getCurrentSupply() private view returns(uint256, uint256) {
1254         uint256 rSupply = _rTotal;
1255         uint256 tSupply = _tTotal;      
1256         for (uint256 i = 0; i < _excluded.length(); i++) {
1257             if (_rOwned[_excluded.at(i)] > rSupply || _tOwned[_excluded.at(i)] > tSupply) return (_rTotal, _tTotal);
1258             rSupply = rSupply.sub(_rOwned[_excluded.at(i)]);
1259             tSupply = tSupply.sub(_tOwned[_excluded.at(i)]);
1260         }
1261         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1262         return (rSupply, tSupply);
1263     }
1264     
1265     function _takeLiquidity(uint256 tLiquidity) private {
1266         uint256 currentRate =  _getRate();
1267         uint256 rLiquidity = tLiquidity.mul(currentRate);
1268         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1269         if(_isExcluded[address(this)])
1270             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1271     }
1272     
1273     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1274         return _amount.mul(_taxFee).div(
1275             10**2
1276         );
1277     }
1278 
1279     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1280         return _amount.mul(_liquidityFee).div(
1281             10**2
1282         );
1283     }
1284     
1285     function removeAllFee() private {
1286         if(_taxFee == 0 && _liquidityFee == 0) return;
1287         
1288         _previousTaxFee = _taxFee;
1289         _previousLiquidityFee = _liquidityFee;
1290         
1291         _taxFee = 0;
1292         _liquidityFee = 0;
1293     }
1294     
1295     function restoreAllFee() private {
1296         _taxFee = _previousTaxFee;
1297         _liquidityFee = _previousLiquidityFee;
1298     }
1299     
1300     function isExcludedFromFee(address account) public view returns(bool) {
1301         return _isExcludedFromFee[account];
1302     }
1303 
1304     function _approve(address owner, address spender, uint256 amount) private {
1305         require(owner != address(0), "ERC20: approve from the zero address");
1306         require(spender != address(0), "ERC20: approve to the zero address");
1307 
1308         _allowances[owner][spender] = amount;
1309         emit Approval(owner, spender, amount);
1310     }
1311 
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 amount
1316     ) private {
1317         require(from != address(0), "ERC20: transfer from the zero address");
1318         require(to != address(0), "ERC20: transfer to the zero address");
1319         require(amount > 0, "Transfer amount must be greater than zero");
1320         if(from != owner() && to != owner())
1321             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1322 
1323         // is the token balance of this contract address over the min number of
1324         // tokens that we need to initiate a swap + liquidity lock?
1325         // also, don't get caught in a circular liquidity event.
1326         // also, don't swap & liquify if sender is uniswap pair.
1327         uint256 contractTokenBalance = balanceOf(address(this));
1328         
1329         if(contractTokenBalance >= _maxTxAmount)
1330         {
1331             contractTokenBalance = _maxTxAmount;
1332         }
1333         
1334         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1335         if (
1336             overMinTokenBalance &&
1337             !inSwapAndLiquify &&
1338             from != uniswapV2Pair &&
1339             swapAndLiquifyEnabled
1340         ) {
1341             contractTokenBalance = numTokensSellToAddToLiquidity;
1342             //add liquidity
1343             swapAndLiquify(contractTokenBalance);
1344         }
1345         
1346         //indicates if fee should be deducted from transfer
1347         bool takeFee = true;
1348         
1349         //if any account belongs to _isExcludedFromFee account then remove the fee
1350         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1351             takeFee = false;
1352         }
1353         
1354         //transfer amount, it will take tax, burn, liquidity fee
1355         _tokenTransfer(from,to,amount,takeFee);
1356     }
1357 
1358     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1359         // split the contract balance into halves
1360         uint256 half = contractTokenBalance.div(2);
1361         uint256 otherHalf = contractTokenBalance.sub(half);
1362 
1363         // capture the contract's current ETH balance.
1364         // this is so that we can capture exactly the amount of ETH that the
1365         // swap creates, and not make the liquidity event include any ETH that
1366         // has been manually sent to the contract
1367         uint256 initialBalance = address(this).balance;
1368 
1369         // swap tokens for ETH
1370         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1371 
1372         // how much ETH did we just swap into?
1373         uint256 newBalance = address(this).balance.sub(initialBalance);
1374 
1375         // add liquidity to uniswap
1376         addLiquidity(otherHalf, newBalance);
1377         
1378         emit SwapAndLiquify(half, newBalance, otherHalf);
1379     }
1380 
1381     function swapTokensForEth(uint256 tokenAmount) private {
1382         // generate the uniswap pair path of token -> weth
1383         address[] memory path = new address[](2);
1384         path[0] = address(this);
1385         path[1] = uniswapV2Router.WETH();
1386 
1387         _approve(address(this), address(uniswapV2Router), tokenAmount);
1388 
1389         // make the swap
1390         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1391             tokenAmount,
1392             0, // accept any amount of ETH
1393             path,
1394             address(this),
1395             block.timestamp
1396         );
1397     }
1398 
1399     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1400         // approve token transfer to cover all possible scenarios
1401         _approve(address(this), address(uniswapV2Router), tokenAmount);
1402 
1403         // add the liquidity
1404         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1405             address(this),
1406             tokenAmount,
1407             0, // slippage is unavoidable
1408             0, // slippage is unavoidable
1409             owner(),
1410             block.timestamp
1411         );
1412     }
1413 
1414     //this method is responsible for taking all fee, if takeFee is true
1415     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1416         if(!takeFee)
1417             removeAllFee();
1418         
1419         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1420             _transferFromExcluded(sender, recipient, amount);
1421         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1422             _transferToExcluded(sender, recipient, amount);
1423         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1424             _transferBothExcluded(sender, recipient, amount);
1425         } else {
1426             _transferStandard(sender, recipient, amount);
1427         }
1428         
1429         if(!takeFee)
1430             restoreAllFee();
1431     }
1432 
1433     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1434         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1435         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1436         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1437         _takeLiquidity(tLiquidity);
1438         _reflectFee(rFee, tFee);
1439         emit Transfer(sender, recipient, tTransferAmount);
1440     }
1441 
1442     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1443         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1444         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1445         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1446         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1447         _takeLiquidity(tLiquidity);
1448         _reflectFee(rFee, tFee);
1449         emit Transfer(sender, recipient, tTransferAmount);
1450     }
1451 
1452     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1453         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1454         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1455         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1456         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1457         _takeLiquidity(tLiquidity);
1458         _reflectFee(rFee, tFee);
1459         emit Transfer(sender, recipient, tTransferAmount);
1460     }
1461 }