1 // SPDX-License-Identifier: UNLICENSED
2 // produced by the Solididy File Flattener (c) David Appleton 2018 - 2020 and beyond
3 // contact : calistralabs@gmail.com
4 // source  : https://github.com/DaveAppleton/SolidityFlattery
5 // released under Apache 2.0 licence
6 // input  /Users/daveappleton/Documents/akombalabs/ec_traits/contracts/ethercards.sol
7 // flattened :  Monday, 01-Mar-21 20:16:06 UTC
8 pragma solidity ^0.7.3;
9 interface IERC721Receiver {
10     /**
11      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
12      * by `operator` from `from`, this function is called.
13      *
14      * It must return its Solidity selector to confirm the token transfer.
15      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
16      *
17      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
18      */
19     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
20 }
21 
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         // solhint-disable-next-line no-inline-assembly
245         assembly { size := extcodesize(account) }
246         return size > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
269         (bool success, ) = recipient.call{ value: amount }("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain`call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292       return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         // solhint-disable-next-line avoid-low-level-calls
331         (bool success, bytes memory returndata) = target.call{ value: value }(data);
332         return _verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
352         require(isContract(target), "Address: static call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return _verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return _verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 library EnumerableMap {
404     // To implement this library for multiple types with as little code
405     // repetition as possible, we write it in terms of a generic Map type with
406     // bytes32 keys and values.
407     // The Map implementation uses private functions, and user-facing
408     // implementations (such as Uint256ToAddressMap) are just wrappers around
409     // the underlying Map.
410     // This means that we can only create new EnumerableMaps for types that fit
411     // in bytes32.
412 
413     struct MapEntry {
414         bytes32 _key;
415         bytes32 _value;
416     }
417 
418     struct Map {
419         // Storage of map keys and values
420         MapEntry[] _entries;
421 
422         // Position of the entry defined by a key in the `entries` array, plus 1
423         // because index 0 means a key is not in the map.
424         mapping (bytes32 => uint256) _indexes;
425     }
426 
427     /**
428      * @dev Adds a key-value pair to a map, or updates the value for an existing
429      * key. O(1).
430      *
431      * Returns true if the key was added to the map, that is if it was not
432      * already present.
433      */
434     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
435         // We read and store the key's index to prevent multiple reads from the same storage slot
436         uint256 keyIndex = map._indexes[key];
437 
438         if (keyIndex == 0) { // Equivalent to !contains(map, key)
439             map._entries.push(MapEntry({ _key: key, _value: value }));
440             // The entry is stored at length-1, but we add 1 to all indexes
441             // and use 0 as a sentinel value
442             map._indexes[key] = map._entries.length;
443             return true;
444         } else {
445             map._entries[keyIndex - 1]._value = value;
446             return false;
447         }
448     }
449 
450     /**
451      * @dev Removes a key-value pair from a map. O(1).
452      *
453      * Returns true if the key was removed from the map, that is if it was present.
454      */
455     function _remove(Map storage map, bytes32 key) private returns (bool) {
456         // We read and store the key's index to prevent multiple reads from the same storage slot
457         uint256 keyIndex = map._indexes[key];
458 
459         if (keyIndex != 0) { // Equivalent to contains(map, key)
460             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
461             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
462             // This modifies the order of the array, as noted in {at}.
463 
464             uint256 toDeleteIndex = keyIndex - 1;
465             uint256 lastIndex = map._entries.length - 1;
466 
467             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
468             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
469 
470             MapEntry storage lastEntry = map._entries[lastIndex];
471 
472             // Move the last entry to the index where the entry to delete is
473             map._entries[toDeleteIndex] = lastEntry;
474             // Update the index for the moved entry
475             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
476 
477             // Delete the slot where the moved entry was stored
478             map._entries.pop();
479 
480             // Delete the index for the deleted slot
481             delete map._indexes[key];
482 
483             return true;
484         } else {
485             return false;
486         }
487     }
488 
489     /**
490      * @dev Returns true if the key is in the map. O(1).
491      */
492     function _contains(Map storage map, bytes32 key) private view returns (bool) {
493         return map._indexes[key] != 0;
494     }
495 
496     /**
497      * @dev Returns the number of key-value pairs in the map. O(1).
498      */
499     function _length(Map storage map) private view returns (uint256) {
500         return map._entries.length;
501     }
502 
503    /**
504     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
505     *
506     * Note that there are no guarantees on the ordering of entries inside the
507     * array, and it may change when more entries are added or removed.
508     *
509     * Requirements:
510     *
511     * - `index` must be strictly less than {length}.
512     */
513     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
514         require(map._entries.length > index, "EnumerableMap: index out of bounds");
515 
516         MapEntry storage entry = map._entries[index];
517         return (entry._key, entry._value);
518     }
519 
520     /**
521      * @dev Tries to returns the value associated with `key`.  O(1).
522      * Does not revert if `key` is not in the map.
523      */
524     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
525         uint256 keyIndex = map._indexes[key];
526         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
527         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
528     }
529 
530     /**
531      * @dev Returns the value associated with `key`.  O(1).
532      *
533      * Requirements:
534      *
535      * - `key` must be in the map.
536      */
537     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
538         uint256 keyIndex = map._indexes[key];
539         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
540         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
541     }
542 
543     /**
544      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
545      *
546      * CAUTION: This function is deprecated because it requires allocating memory for the error
547      * message unnecessarily. For custom revert reasons use {_tryGet}.
548      */
549     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
550         uint256 keyIndex = map._indexes[key];
551         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
552         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
553     }
554 
555     // UintToAddressMap
556 
557     struct UintToAddressMap {
558         Map _inner;
559     }
560 
561     /**
562      * @dev Adds a key-value pair to a map, or updates the value for an existing
563      * key. O(1).
564      *
565      * Returns true if the key was added to the map, that is if it was not
566      * already present.
567      */
568     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
569         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
570     }
571 
572     /**
573      * @dev Removes a value from a set. O(1).
574      *
575      * Returns true if the key was removed from the map, that is if it was present.
576      */
577     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
578         return _remove(map._inner, bytes32(key));
579     }
580 
581     /**
582      * @dev Returns true if the key is in the map. O(1).
583      */
584     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
585         return _contains(map._inner, bytes32(key));
586     }
587 
588     /**
589      * @dev Returns the number of elements in the map. O(1).
590      */
591     function length(UintToAddressMap storage map) internal view returns (uint256) {
592         return _length(map._inner);
593     }
594 
595    /**
596     * @dev Returns the element stored at position `index` in the set. O(1).
597     * Note that there are no guarantees on the ordering of values inside the
598     * array, and it may change when more values are added or removed.
599     *
600     * Requirements:
601     *
602     * - `index` must be strictly less than {length}.
603     */
604     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
605         (bytes32 key, bytes32 value) = _at(map._inner, index);
606         return (uint256(key), address(uint160(uint256(value))));
607     }
608 
609     /**
610      * @dev Tries to returns the value associated with `key`.  O(1).
611      * Does not revert if `key` is not in the map.
612      *
613      * _Available since v3.4._
614      */
615     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
616         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
617         return (success, address(uint160(uint256(value))));
618     }
619 
620     /**
621      * @dev Returns the value associated with `key`.  O(1).
622      *
623      * Requirements:
624      *
625      * - `key` must be in the map.
626      */
627     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
628         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
629     }
630 
631     /**
632      * @dev Same as {get}, with a custom error message when `key` is not in the map.
633      *
634      * CAUTION: This function is deprecated because it requires allocating memory for the error
635      * message unnecessarily. For custom revert reasons use {tryGet}.
636      */
637     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
638         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
639     }
640 }
641 
642 interface IERC165 {
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30 000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) external view returns (bool);
652 }
653 
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address payable) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes memory) {
660         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
661         return msg.data;
662     }
663 }
664 
665 library Strings {
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` representation.
668      */
669     function toString(uint256 value) internal pure returns (string memory) {
670         // Inspired by OraclizeAPI's implementation - MIT licence
671         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
672 
673         if (value == 0) {
674             return "0";
675         }
676         uint256 temp = value;
677         uint256 digits;
678         while (temp != 0) {
679             digits++;
680             temp /= 10;
681         }
682         bytes memory buffer = new bytes(digits);
683         uint256 index = digits - 1;
684         temp = value;
685         while (temp != 0) {
686             buffer[index--] = bytes1(uint8(48 + temp % 10));
687             temp /= 10;
688         }
689         return string(buffer);
690     }
691 }
692 
693 library Math {
694     /**
695      * @dev Returns the largest of two numbers.
696      */
697     function max(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a >= b ? a : b;
699     }
700 
701     /**
702      * @dev Returns the smallest of two numbers.
703      */
704     function min(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a < b ? a : b;
706     }
707 
708     /**
709      * @dev Returns the average of two numbers. The result is rounded towards
710      * zero.
711      */
712     function average(uint256 a, uint256 b) internal pure returns (uint256) {
713         // (a + b) / 2 can overflow, so we distribute
714         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
715     }
716 }
717 
718 abstract contract IRNG {
719 
720     function requestRandomNumber() external virtual returns (bytes32 requestId) ;
721 
722     function isRequestComplete(bytes32 requestId) external virtual view returns (bool isCompleted) ; 
723 
724     function randomNumber(bytes32 requestId) external view virtual returns (uint256 randomNum) ;
725 }
726 library EnumerableSet {
727     // To implement this library for multiple types with as little code
728     // repetition as possible, we write it in terms of a generic Set type with
729     // bytes32 values.
730     // The Set implementation uses private functions, and user-facing
731     // implementations (such as AddressSet) are just wrappers around the
732     // underlying Set.
733     // This means that we can only create new EnumerableSets for types that fit
734     // in bytes32.
735 
736     struct Set {
737         // Storage of set values
738         bytes32[] _values;
739 
740         // Position of the value in the `values` array, plus 1 because index 0
741         // means a value is not in the set.
742         mapping (bytes32 => uint256) _indexes;
743     }
744 
745     /**
746      * @dev Add a value to a set. O(1).
747      *
748      * Returns true if the value was added to the set, that is if it was not
749      * already present.
750      */
751     function _add(Set storage set, bytes32 value) private returns (bool) {
752         if (!_contains(set, value)) {
753             set._values.push(value);
754             // The value is stored at length-1, but we add 1 to all indexes
755             // and use 0 as a sentinel value
756             set._indexes[value] = set._values.length;
757             return true;
758         } else {
759             return false;
760         }
761     }
762 
763     /**
764      * @dev Removes a value from a set. O(1).
765      *
766      * Returns true if the value was removed from the set, that is if it was
767      * present.
768      */
769     function _remove(Set storage set, bytes32 value) private returns (bool) {
770         // We read and store the value's index to prevent multiple reads from the same storage slot
771         uint256 valueIndex = set._indexes[value];
772 
773         if (valueIndex != 0) { // Equivalent to contains(set, value)
774             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
775             // the array, and then remove the last element (sometimes called as 'swap and pop').
776             // This modifies the order of the array, as noted in {at}.
777 
778             uint256 toDeleteIndex = valueIndex - 1;
779             uint256 lastIndex = set._values.length - 1;
780 
781             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
782             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
783 
784             bytes32 lastvalue = set._values[lastIndex];
785 
786             // Move the last value to the index where the value to delete is
787             set._values[toDeleteIndex] = lastvalue;
788             // Update the index for the moved value
789             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
790 
791             // Delete the slot where the moved value was stored
792             set._values.pop();
793 
794             // Delete the index for the deleted slot
795             delete set._indexes[value];
796 
797             return true;
798         } else {
799             return false;
800         }
801     }
802 
803     /**
804      * @dev Returns true if the value is in the set. O(1).
805      */
806     function _contains(Set storage set, bytes32 value) private view returns (bool) {
807         return set._indexes[value] != 0;
808     }
809 
810     /**
811      * @dev Returns the number of values on the set. O(1).
812      */
813     function _length(Set storage set) private view returns (uint256) {
814         return set._values.length;
815     }
816 
817    /**
818     * @dev Returns the value stored at position `index` in the set. O(1).
819     *
820     * Note that there are no guarantees on the ordering of values inside the
821     * array, and it may change when more values are added or removed.
822     *
823     * Requirements:
824     *
825     * - `index` must be strictly less than {length}.
826     */
827     function _at(Set storage set, uint256 index) private view returns (bytes32) {
828         require(set._values.length > index, "EnumerableSet: index out of bounds");
829         return set._values[index];
830     }
831 
832     // Bytes32Set
833 
834     struct Bytes32Set {
835         Set _inner;
836     }
837 
838     /**
839      * @dev Add a value to a set. O(1).
840      *
841      * Returns true if the value was added to the set, that is if it was not
842      * already present.
843      */
844     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
845         return _add(set._inner, value);
846     }
847 
848     /**
849      * @dev Removes a value from a set. O(1).
850      *
851      * Returns true if the value was removed from the set, that is if it was
852      * present.
853      */
854     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
855         return _remove(set._inner, value);
856     }
857 
858     /**
859      * @dev Returns true if the value is in the set. O(1).
860      */
861     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
862         return _contains(set._inner, value);
863     }
864 
865     /**
866      * @dev Returns the number of values in the set. O(1).
867      */
868     function length(Bytes32Set storage set) internal view returns (uint256) {
869         return _length(set._inner);
870     }
871 
872    /**
873     * @dev Returns the value stored at position `index` in the set. O(1).
874     *
875     * Note that there are no guarantees on the ordering of values inside the
876     * array, and it may change when more values are added or removed.
877     *
878     * Requirements:
879     *
880     * - `index` must be strictly less than {length}.
881     */
882     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
883         return _at(set._inner, index);
884     }
885 
886     // AddressSet
887 
888     struct AddressSet {
889         Set _inner;
890     }
891 
892     /**
893      * @dev Add a value to a set. O(1).
894      *
895      * Returns true if the value was added to the set, that is if it was not
896      * already present.
897      */
898     function add(AddressSet storage set, address value) internal returns (bool) {
899         return _add(set._inner, bytes32(uint256(uint160(value))));
900     }
901 
902     /**
903      * @dev Removes a value from a set. O(1).
904      *
905      * Returns true if the value was removed from the set, that is if it was
906      * present.
907      */
908     function remove(AddressSet storage set, address value) internal returns (bool) {
909         return _remove(set._inner, bytes32(uint256(uint160(value))));
910     }
911 
912     /**
913      * @dev Returns true if the value is in the set. O(1).
914      */
915     function contains(AddressSet storage set, address value) internal view returns (bool) {
916         return _contains(set._inner, bytes32(uint256(uint160(value))));
917     }
918 
919     /**
920      * @dev Returns the number of values in the set. O(1).
921      */
922     function length(AddressSet storage set) internal view returns (uint256) {
923         return _length(set._inner);
924     }
925 
926    /**
927     * @dev Returns the value stored at position `index` in the set. O(1).
928     *
929     * Note that there are no guarantees on the ordering of values inside the
930     * array, and it may change when more values are added or removed.
931     *
932     * Requirements:
933     *
934     * - `index` must be strictly less than {length}.
935     */
936     function at(AddressSet storage set, uint256 index) internal view returns (address) {
937         return address(uint160(uint256(_at(set._inner, index))));
938     }
939 
940 
941     // UintSet
942 
943     struct UintSet {
944         Set _inner;
945     }
946 
947     /**
948      * @dev Add a value to a set. O(1).
949      *
950      * Returns true if the value was added to the set, that is if it was not
951      * already present.
952      */
953     function add(UintSet storage set, uint256 value) internal returns (bool) {
954         return _add(set._inner, bytes32(value));
955     }
956 
957     /**
958      * @dev Removes a value from a set. O(1).
959      *
960      * Returns true if the value was removed from the set, that is if it was
961      * present.
962      */
963     function remove(UintSet storage set, uint256 value) internal returns (bool) {
964         return _remove(set._inner, bytes32(value));
965     }
966 
967     /**
968      * @dev Returns true if the value is in the set. O(1).
969      */
970     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
971         return _contains(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns the number of values on the set. O(1).
976      */
977     function length(UintSet storage set) internal view returns (uint256) {
978         return _length(set._inner);
979     }
980 
981    /**
982     * @dev Returns the value stored at position `index` in the set. O(1).
983     *
984     * Note that there are no guarantees on the ordering of values inside the
985     * array, and it may change when more values are added or removed.
986     *
987     * Requirements:
988     *
989     * - `index` must be strictly less than {length}.
990     */
991     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
992         return uint256(_at(set._inner, index));
993     }
994 }
995 
996 interface IERC721 is IERC165 {
997     /**
998      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
999      */
1000     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1001 
1002     /**
1003      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1004      */
1005     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1006 
1007     /**
1008      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1009      */
1010     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1011 
1012     /**
1013      * @dev Returns the number of tokens in ``owner``'s account.
1014      */
1015     function balanceOf(address owner) external view returns (uint256 balance);
1016 
1017     /**
1018      * @dev Returns the owner of the `tokenId` token.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function ownerOf(uint256 tokenId) external view returns (address owner);
1025 
1026     /**
1027      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1028      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1029      *
1030      * Requirements:
1031      *
1032      * - `from` cannot be the zero address.
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must exist and be owned by `from`.
1035      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1036      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1041 
1042     /**
1043      * @dev Transfers `tokenId` token from `from` to `to`.
1044      *
1045      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function transferFrom(address from, address to, uint256 tokenId) external;
1057 
1058     /**
1059      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1060      * The approval is cleared when the token is transferred.
1061      *
1062      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1063      *
1064      * Requirements:
1065      *
1066      * - The caller must own the token or be an approved operator.
1067      * - `tokenId` must exist.
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function approve(address to, uint256 tokenId) external;
1072 
1073     /**
1074      * @dev Returns the account approved for `tokenId` token.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function getApproved(uint256 tokenId) external view returns (address operator);
1081 
1082     /**
1083      * @dev Approve or remove `operator` as an operator for the caller.
1084      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1085      *
1086      * Requirements:
1087      *
1088      * - The `operator` cannot be the caller.
1089      *
1090      * Emits an {ApprovalForAll} event.
1091      */
1092     function setApprovalForAll(address operator, bool _approved) external;
1093 
1094     /**
1095      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1096      *
1097      * See {setApprovalForAll}
1098      */
1099     function isApprovedForAll(address owner, address operator) external view returns (bool);
1100 
1101     /**
1102       * @dev Safely transfers `tokenId` token from `from` to `to`.
1103       *
1104       * Requirements:
1105       *
1106       * - `from` cannot be the zero address.
1107       * - `to` cannot be the zero address.
1108       * - `tokenId` token must exist and be owned by `from`.
1109       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1110       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1111       *
1112       * Emits a {Transfer} event.
1113       */
1114     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1115 }
1116 
1117 abstract contract ERC165 is IERC165 {
1118     /*
1119      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1120      */
1121     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1122 
1123     /**
1124      * @dev Mapping of interface ids to whether or not it's supported.
1125      */
1126     mapping(bytes4 => bool) private _supportedInterfaces;
1127 
1128     constructor () internal {
1129         // Derived contracts need only register support for their own interfaces,
1130         // we register support for ERC165 itself here
1131         _registerInterface(_INTERFACE_ID_ERC165);
1132     }
1133 
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      *
1137      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1138      */
1139     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1140         return _supportedInterfaces[interfaceId];
1141     }
1142 
1143     /**
1144      * @dev Registers the contract as an implementer of the interface defined by
1145      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1146      * registering its interface id is not required.
1147      *
1148      * See {IERC165-supportsInterface}.
1149      *
1150      * Requirements:
1151      *
1152      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1153      */
1154     function _registerInterface(bytes4 interfaceId) internal virtual {
1155         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1156         _supportedInterfaces[interfaceId] = true;
1157     }
1158 }
1159 
1160 abstract contract Pausable is Context {
1161     /**
1162      * @dev Emitted when the pause is triggered by `account`.
1163      */
1164     event Paused(address account);
1165 
1166     /**
1167      * @dev Emitted when the pause is lifted by `account`.
1168      */
1169     event Unpaused(address account);
1170 
1171     bool private _paused;
1172 
1173     /**
1174      * @dev Initializes the contract in unpaused state.
1175      */
1176     constructor () internal {
1177         _paused = false;
1178     }
1179 
1180     /**
1181      * @dev Returns true if the contract is paused, and false otherwise.
1182      */
1183     function paused() public view virtual returns (bool) {
1184         return _paused;
1185     }
1186 
1187     /**
1188      * @dev Modifier to make a function callable only when the contract is not paused.
1189      *
1190      * Requirements:
1191      *
1192      * - The contract must not be paused.
1193      */
1194     modifier whenNotPaused() {
1195         require(!paused(), "Pausable: paused");
1196         _;
1197     }
1198 
1199     /**
1200      * @dev Modifier to make a function callable only when the contract is paused.
1201      *
1202      * Requirements:
1203      *
1204      * - The contract must be paused.
1205      */
1206     modifier whenPaused() {
1207         require(paused(), "Pausable: not paused");
1208         _;
1209     }
1210 
1211     /**
1212      * @dev Triggers stopped state.
1213      *
1214      * Requirements:
1215      *
1216      * - The contract must not be paused.
1217      */
1218     function _pause() internal virtual whenNotPaused {
1219         _paused = true;
1220         emit Paused(_msgSender());
1221     }
1222 
1223     /**
1224      * @dev Returns to normal state.
1225      *
1226      * Requirements:
1227      *
1228      * - The contract must be paused.
1229      */
1230     function _unpause() internal virtual whenPaused {
1231         _paused = false;
1232         emit Unpaused(_msgSender());
1233     }
1234 }
1235 
1236 interface IERC721Enumerable is IERC721 {
1237 
1238     /**
1239      * @dev Returns the total amount of tokens stored by the contract.
1240      */
1241     function totalSupply() external view returns (uint256);
1242 
1243     /**
1244      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1245      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1246      */
1247     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1248 
1249     /**
1250      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1251      * Use along with {totalSupply} to enumerate all tokens.
1252      */
1253     function tokenByIndex(uint256 index) external view returns (uint256);
1254 }
1255 
1256 abstract contract Ownable is Context {
1257     address private _owner;
1258 
1259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1260 
1261     /**
1262      * @dev Initializes the contract setting the deployer as the initial owner.
1263      */
1264     constructor () internal {
1265         address msgSender = _msgSender();
1266         _owner = msgSender;
1267         emit OwnershipTransferred(address(0), msgSender);
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         emit OwnershipTransferred(_owner, address(0));
1294         _owner = address(0);
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Can only be called by the current owner.
1300      */
1301     function transferOwnership(address newOwner) public virtual onlyOwner {
1302         require(newOwner != address(0), "Ownable: new owner is the zero address");
1303         emit OwnershipTransferred(_owner, newOwner);
1304         _owner = newOwner;
1305     }
1306 }
1307 
1308 interface IERC721Metadata is IERC721 {
1309 
1310     /**
1311      * @dev Returns the token collection name.
1312      */
1313     function name() external view returns (string memory);
1314 
1315     /**
1316      * @dev Returns the token collection symbol.
1317      */
1318     function symbol() external view returns (string memory);
1319 
1320     /**
1321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1322      */
1323     function tokenURI(uint256 tokenId) external view returns (string memory);
1324 }
1325 
1326 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1327     using SafeMath for uint256;
1328     using Address for address;
1329     using EnumerableSet for EnumerableSet.UintSet;
1330     using EnumerableMap for EnumerableMap.UintToAddressMap;
1331     using Strings for uint256;
1332 
1333     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1334     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1335     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1336 
1337     // Mapping from holder address to their (enumerable) set of owned tokens
1338     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1339 
1340     // Enumerable mapping from token ids to their owners
1341     EnumerableMap.UintToAddressMap private _tokenOwners;
1342 
1343     // Mapping from token ID to approved address
1344     mapping (uint256 => address) private _tokenApprovals;
1345 
1346     // Mapping from owner to operator approvals
1347     mapping (address => mapping (address => bool)) private _operatorApprovals;
1348 
1349     // Token name
1350     string private _name;
1351 
1352     // Token symbol
1353     string private _symbol;
1354 
1355     // Optional mapping for token URIs
1356     mapping (uint256 => string) private _tokenURIs;
1357 
1358     // Base URI
1359     string private _baseURI;
1360 
1361     /*
1362      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1363      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1364      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1365      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1366      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1367      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1368      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1369      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1370      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1371      *
1372      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1373      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1374      */
1375     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1376 
1377     /*
1378      *     bytes4(keccak256('name()')) == 0x06fdde03
1379      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1380      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1381      *
1382      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1383      */
1384     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1385 
1386     /*
1387      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1388      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1389      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1390      *
1391      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1392      */
1393     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1394 
1395     /**
1396      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1397      */
1398     constructor (string memory name_, string memory symbol_) public {
1399         _name = name_;
1400         _symbol = symbol_;
1401 
1402         // register the supported interfaces to conform to ERC721 via ERC165
1403         _registerInterface(_INTERFACE_ID_ERC721);
1404         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1405         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-balanceOf}.
1410      */
1411     function balanceOf(address owner) public view virtual override returns (uint256) {
1412         require(owner != address(0), "ERC721: balance query for the zero address");
1413         return _holderTokens[owner].length();
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-ownerOf}.
1418      */
1419     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1420         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Metadata-name}.
1425      */
1426     function name() public view virtual override returns (string memory) {
1427         return _name;
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Metadata-symbol}.
1432      */
1433     function symbol() public view virtual override returns (string memory) {
1434         return _symbol;
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Metadata-tokenURI}.
1439      */
1440     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1441         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1442 
1443         string memory _tokenURI = _tokenURIs[tokenId];
1444         string memory base = baseURI();
1445 
1446         // If there is no base URI, return the token URI.
1447         if (bytes(base).length == 0) {
1448             return _tokenURI;
1449         }
1450         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1451         if (bytes(_tokenURI).length > 0) {
1452             return string(abi.encodePacked(base, _tokenURI));
1453         }
1454         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1455         return string(abi.encodePacked(base, uint256(tokenId).toString()));
1456     }
1457 
1458     /**
1459     * @dev Returns the base URI set via {_setBaseURI}. This will be
1460     * automatically added as a prefix in {tokenURI} to each token's URI, or
1461     * to the token ID if no specific URI is set for that token ID.
1462     */
1463     function baseURI() public view virtual returns (string memory) {
1464         return _baseURI;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1469      */
1470     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1471         return _holderTokens[owner].at(index);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-totalSupply}.
1476      */
1477     function totalSupply() public view virtual override returns (uint256) {
1478         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1479         return _tokenOwners.length();
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Enumerable-tokenByIndex}.
1484      */
1485     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1486         (uint256 tokenId, ) = _tokenOwners.at(index);
1487         return tokenId;
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-approve}.
1492      */
1493     function approve(address to, uint256 tokenId) public virtual override {
1494         address owner = ERC721.ownerOf(tokenId);
1495         require(to != owner, "ERC721: approval to current owner");
1496 
1497         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1498             "ERC721: approve caller is not owner nor approved for all"
1499         );
1500 
1501         _approve(to, tokenId);
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-getApproved}.
1506      */
1507     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1508         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1509 
1510         return _tokenApprovals[tokenId];
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-setApprovalForAll}.
1515      */
1516     function setApprovalForAll(address operator, bool approved) public virtual override {
1517         require(operator != _msgSender(), "ERC721: approve to caller");
1518 
1519         _operatorApprovals[_msgSender()][operator] = approved;
1520         emit ApprovalForAll(_msgSender(), operator, approved);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-isApprovedForAll}.
1525      */
1526     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1527         return _operatorApprovals[owner][operator];
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-transferFrom}.
1532      */
1533     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1534         //solhint-disable-next-line max-line-length
1535         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1536 
1537         _transfer(from, to, tokenId);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-safeTransferFrom}.
1542      */
1543     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1544         safeTransferFrom(from, to, tokenId, "");
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-safeTransferFrom}.
1549      */
1550     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1551         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1552         _safeTransfer(from, to, tokenId, _data);
1553     }
1554 
1555     /**
1556      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1557      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1558      *
1559      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1560      *
1561      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1562      * implement alternative mechanisms to perform token transfer, such as signature-based.
1563      *
1564      * Requirements:
1565      *
1566      * - `from` cannot be the zero address.
1567      * - `to` cannot be the zero address.
1568      * - `tokenId` token must exist and be owned by `from`.
1569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1574         _transfer(from, to, tokenId);
1575         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1576     }
1577 
1578     /**
1579      * @dev Returns whether `tokenId` exists.
1580      *
1581      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1582      *
1583      * Tokens start existing when they are minted (`_mint`),
1584      * and stop existing when they are burned (`_burn`).
1585      */
1586     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1587         return _tokenOwners.contains(tokenId);
1588     }
1589 
1590     /**
1591      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1592      *
1593      * Requirements:
1594      *
1595      * - `tokenId` must exist.
1596      */
1597     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1598         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1599         address owner = ERC721.ownerOf(tokenId);
1600         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1601     }
1602 
1603     /**
1604      * @dev Safely mints `tokenId` and transfers it to `to`.
1605      *
1606      * Requirements:
1607      d*
1608      * - `tokenId` must not exist.
1609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function _safeMint(address to, uint256 tokenId) internal virtual {
1614         _safeMint(to, tokenId, "");
1615     }
1616 
1617     /**
1618      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1619      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1620      */
1621     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1622         _mint(to, tokenId);
1623         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1624     }
1625 
1626     /**
1627      * @dev Mints `tokenId` and transfers it to `to`.
1628      *
1629      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must not exist.
1634      * - `to` cannot be the zero address.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function _mint(address to, uint256 tokenId) internal virtual {
1639         require(to != address(0), "ERC721: mint to the zero address");
1640         require(!_exists(tokenId), "ERC721: token already minted");
1641 
1642         _beforeTokenTransfer(address(0), to, tokenId);
1643 
1644         _holderTokens[to].add(tokenId);
1645 
1646         _tokenOwners.set(tokenId, to);
1647 
1648         emit Transfer(address(0), to, tokenId);
1649     }
1650 
1651     /**
1652      * @dev Destroys `tokenId`.
1653      * The approval is cleared when the token is burned.
1654      *
1655      * Requirements:
1656      *
1657      * - `tokenId` must exist.
1658      *
1659      * Emits a {Transfer} event.
1660      */
1661     function _burn(uint256 tokenId) internal virtual {
1662         address owner = ERC721.ownerOf(tokenId); // internal owner
1663 
1664         _beforeTokenTransfer(owner, address(0), tokenId);
1665 
1666         // Clear approvals
1667         _approve(address(0), tokenId);
1668 
1669         // Clear metadata (if any)
1670         if (bytes(_tokenURIs[tokenId]).length != 0) {
1671             delete _tokenURIs[tokenId];
1672         }
1673 
1674         _holderTokens[owner].remove(tokenId);
1675 
1676         _tokenOwners.remove(tokenId);
1677 
1678         emit Transfer(owner, address(0), tokenId);
1679     }
1680 
1681     /**
1682      * @dev Transfers `tokenId` from `from` to `to`.
1683      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1684      *
1685      * Requirements:
1686      *
1687      * - `to` cannot be the zero address.
1688      * - `tokenId` token must be owned by `from`.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1693         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1694         require(to != address(0), "ERC721: transfer to the zero address");
1695 
1696         _beforeTokenTransfer(from, to, tokenId);
1697 
1698         // Clear approvals from the previous owner
1699         _approve(address(0), tokenId);
1700 
1701         _holderTokens[from].remove(tokenId);
1702         _holderTokens[to].add(tokenId);
1703 
1704         _tokenOwners.set(tokenId, to);
1705 
1706         emit Transfer(from, to, tokenId);
1707     }
1708 
1709     /**
1710      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1711      *
1712      * Requirements:
1713      *
1714      * - `tokenId` must exist.
1715      */
1716     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1717         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1718         _tokenURIs[tokenId] = _tokenURI;
1719     }
1720 
1721     /**
1722      * @dev Internal function to set the base URI for all token IDs. It is
1723      * automatically added as a prefix to the value returned in {tokenURI},
1724      * or to the token ID if {tokenURI} is empty.
1725      */
1726     function _setBaseURI(string memory baseURI_) internal virtual {
1727         _baseURI = baseURI_;
1728     }
1729 
1730     /**
1731      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1732      * The call is not executed if the target address is not a contract.
1733      *
1734      * @param from address representing the previous owner of the given token ID
1735      * @param to target address that will receive the tokens
1736      * @param tokenId uint256 ID of the token to be transferred
1737      * @param _data bytes optional data to send along with the call
1738      * @return bool whether the call correctly returned the expected magic value
1739      */
1740     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1741         private returns (bool)
1742     {
1743         if (!to.isContract()) {
1744             return true;
1745         }
1746         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1747             IERC721Receiver(to).onERC721Received.selector,
1748             _msgSender(),
1749             from,
1750             tokenId,
1751             _data
1752         ), "ERC721: transfer to non ERC721Receiver implementer");
1753         bytes4 retval = abi.decode(returndata, (bytes4));
1754         return (retval == _ERC721_RECEIVED);
1755     }
1756 
1757     function _approve(address to, uint256 tokenId) private {
1758         _tokenApprovals[tokenId] = to;
1759         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1760     }
1761 
1762     /**
1763      * @dev Hook that is called before any token transfer. This includes minting
1764      * and burning.
1765      *
1766      * Calling conditions:
1767      *
1768      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1769      * transferred to `to`.
1770      * - When `from` is zero, `tokenId` will be minted for `to`.
1771      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1772      * - `from` cannot be the zero address.
1773      * - `to` cannot be the zero address.
1774      *
1775      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1776      */
1777     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1778 }
1779 
1780 abstract contract xERC20 {
1781     function transfer(address,uint256) public virtual returns (bool);
1782     function balanceOf(address) public view virtual returns (uint256);
1783 }
1784 
1785 contract ethercards is ERC721 , Ownable, Pausable{
1786     using Strings for uint256;
1787     using SafeMath for uint256;
1788 
1789     IRNG rng;
1790 
1791     enum CardType { OG, Alpha, Random, Common, Founder,  Unresolved } 
1792 
1793     uint256   constant oStart = 10;
1794     uint256   constant aStart = 100;
1795     uint256   constant cStart = 1000;
1796     uint256   constant oMax = 99;
1797     uint256   constant aMax = 999;
1798     uint256   constant cMax = 9999;
1799 
1800     uint256   constant tr_ass_order_length = 14;
1801     uint256   constant tr_ass_order_mask   = 0x3ff;
1802 
1803     uint256   extra_trait_offset ;
1804 
1805 
1806 
1807     // sale conditions
1808     uint256   immutable sale_start;
1809     uint256   immutable sale_end;
1810 
1811     
1812     bool      curve_set;
1813 
1814 
1815     // sold AND resolved
1816     uint256   public oSold;
1817     uint256   public aSold;
1818     uint256   public cSold;
1819     // pending resolution
1820     uint256   public oPending;
1821     uint256   public aPending;
1822     uint256   public cPending;
1823     
1824     uint256   public nextTokenId = 10;
1825     // Random Stuff
1826     mapping (uint256 => bytes32) public randomRequests;
1827     uint256                      public lastRandomRequested;
1828     uint256                      public lastRandomProcessed;
1829     uint256                      public randomOneOfEight;
1830 
1831     // pricing stuff
1832     uint256[]                   og_stop;
1833     uint256[]                   og_price;
1834     uint256[]                   alpha_stop;
1835     uint256[]                   alpha_price;
1836     uint256[]                   common_stop;
1837     uint256[]                   common_price;
1838     uint256                     og_pointer;
1839     uint256                     alpha_pointer;
1840     uint256                     common_pointer;
1841 
1842     address payable             wallet;
1843 
1844 
1845     // traits stuff
1846     bytes32[50] public           traitHashes;
1847     mapping (uint256 => uint256)  traitAssignmentOrder;
1848     // Validation
1849     uint256                     startPos;
1850     bytes32                     tokenIdHash;
1851 
1852 
1853     //mapping(uint256 => uint256) serialToTokenId;
1854     //mapping(uint256 => uint256) tokenIdToSerial;
1855     mapping(uint256 => uint256) cardTraits;
1856     
1857 
1858     bytes32      public fullTokenIDHash;
1859     bytes32[50]  public allTokenIDHashes;
1860 
1861 
1862     
1863     bool    presale_closed;
1864     bool    founders_done;
1865     address oracle;
1866     address controller;
1867 
1868     event OG_Ordered(address buyer, uint256 price_paid, uint256 tokenID);
1869     event ALPHA_Ordered(address buyer, uint256 price_paid, uint256 tokenID);
1870     event COMMON_Ordered(address buyer, uint256 price_paid, uint256 tokenID);
1871 
1872     event Resolution(uint256 tokenId,uint256 chance);
1873 
1874     event PresaleClosed();
1875     event OracleSet( address oracle);
1876     event ControllerSet( address oracle);
1877     event SaleSet(uint256 start, uint256 end);
1878     event RandomSet(address random);
1879     event HashesSet();
1880     
1881     event WheresWallet(address wallet);
1882     event Upgrade(uint256 tokenID, uint256 position);
1883 
1884     event UpgradeToOG(uint256 tokenId,uint256 pos);
1885     event UpgradeToAlpha(uint256 tokenId,uint256 pos);
1886 
1887     event TraitsClaimed(uint tokenID,uint traits);
1888     event TraitsAlreadyClaimed(uint tokenID);
1889  
1890     
1891     modifier onlyOracle() {
1892         require(msg.sender == oracle,"Not Authorised");
1893         _;
1894     }
1895 
1896     modifier onlyAllowed() {
1897         require(
1898             msg.sender == owner() ||
1899             msg.sender == controller,"Not Authorised");
1900         _;
1901     }
1902 
1903     // SECTIONS IN CAPS TO RETAIN SANITY
1904 
1905     // CONSTRUCTOR
1906     // traitHashes : hashes of 50 x 200 elements
1907 
1908     constructor(
1909         IRNG _rng, 
1910         uint256 _start, uint256 _end,
1911         address payable _wallet, address _oracle
1912         ) ERC721("Ether Cards Founder","ECF") {
1913 
1914         
1915         rng = _rng;
1916         sale_start = _start;
1917         sale_end = _end;
1918         wallet = _wallet;
1919         oracle = _oracle;
1920 // need events
1921         emit OracleSet(_oracle);
1922         emit SaleSet(_start,_end);
1923         emit RandomSet(address(_rng));
1924         emit WheresWallet(_wallet);
1925     }
1926 
1927     function setTraitHashes(bytes32[50] memory _traitHashes) external onlyOwner {
1928         traitHashes = _traitHashes;
1929         emit HashesSet();
1930     }
1931 
1932     function setCurve(
1933         uint256[] memory _og_stop, uint256[] memory _og_price,
1934         uint256[] memory _alpha_stop, uint256[] memory _alpha_price,
1935         uint256[] memory _random_stop, uint256[] memory _random_price) external onlyOwner {
1936         og_stop = _og_stop;
1937         og_price = _og_price;
1938         alpha_stop = _alpha_stop;
1939         alpha_price = _alpha_price;
1940         common_stop = _random_stop;
1941         common_price = _random_price;
1942         curve_set = true;
1943         _setBaseURI("temp.ether.cards/metadata");
1944     }
1945 
1946 
1947     // ENTRY POINT TO SALE CONTRACT
1948     // 0 = OG
1949     // 1 = ALPHA
1950     // 2 = RANDOM
1951 
1952     event Refund(address buyer, uint sent, uint purchased, uint refund);
1953 
1954     function buyCard(uint card_type) external payable sale_active whenNotPaused {
1955         buyCardInternal(card_type);
1956     }
1957 
1958 
1959     function buyCardInternal(uint card_type) internal {
1960         require(curve_set,"price curve not set");
1961         uint balance = msg.value;
1962         uint price;
1963         require(card_type < 3, "Invalid card type");
1964         for (uint j = 0; j < 100; j++) {
1965             if (card_type == 0) {
1966                 price = OG_price();
1967             }  else if (card_type == 1) {
1968                 price =  ALPHA_price();
1969             } else {
1970                 price = COMMON_price();
1971             }
1972             if (balance < price) {
1973                 if (j == 0) require(false,"Not enough sent");
1974                 payable(wallet).transfer(msg.value.sub(balance));
1975                 payable(msg.sender).transfer(balance);
1976                 emit Refund(msg.sender,msg.value, j,balance);
1977                 return;
1978             }
1979             assignCard(msg.sender,card_type);
1980             balance = balance.sub(price);
1981         }
1982         payable(wallet).transfer(msg.value.sub(balance));
1983         payable(msg.sender).transfer(balance);
1984         emit Refund(msg.sender,msg.value, 100,balance);
1985 }
1986 
1987     // PRESALE FUNCTIONS
1988     // 0 - OG
1989     // 1 - ALPHA
1990     // 2 - COMMON
1991 
1992     function allocateManyCards(address[] memory buyers, uint256 card_type) external onlyOwner {
1993         require(curve_set,"price curve not set");
1994          require(founders_done, "mint founders first");
1995         require(card_type < 3 , "Invalid Card Type");
1996         require(!presale_closed,"Presale is over");
1997         for (uint j = 0; j < buyers.length; j++) {
1998             assignCard(buyers[j],card_type);
1999         }
2000     }
2001     
2002     function allocateCard(address buyer, uint256 card_type) external onlyOwner {
2003         require(curve_set,"price curve not set");
2004          require(founders_done, "mint founders first");
2005         require(card_type < 3, "Invalid Card Type");
2006         require((!presale_closed) || sale_is_over() ,"Presale is over");
2007         assignCard(buyer,card_type);
2008     }
2009 
2010     function closePresalePartOne() external onlyOwner {
2011         if (randomOneOfEight % 16 > 7) {
2012             request_random();
2013         }
2014         if (randomOneOfEight % 16 > 0) {
2015             request_random();
2016         }
2017     }
2018 
2019     function closePresalePartTwo() external onlyOwner {
2020         processRand();
2021         presale_closed = true;
2022         emit PresaleClosed();
2023     }
2024 
2025 
2026     // FOUNDERS CARDS
2027 
2028     function mintFounders(address[10] memory founders) external onlyOwner {
2029         require(!founders_done, "Founders already minted");
2030         for (uint j = 0; j < 10; j++) {
2031             _mint(founders[j],j);
2032             traitAssignmentOrder[j] = 1;
2033         }
2034         founders_done = true;
2035     }
2036 
2037     // Extra Traits
2038 
2039     function setExtraTraits(uint256 tokenId, uint256 bitNumber) external onlyAllowed {
2040         require((bitNumber >= extra_trait_offset) && (bitNumber < 256), "illegal bit number");
2041         cardTraits[tokenId] |=   (1 << bitNumber);
2042     }
2043 
2044     function setExtraTraitOffset(uint256 _offset) external onlyOwner {
2045         require(extra_trait_offset == 0, "Extra Trait offset already set");
2046         extra_trait_offset = _offset;
2047     }
2048 
2049     // ORACLE ACTIVATION
2050 
2051     function numberPending() public view returns (uint256) {
2052         return oPending + cPending  +aPending;
2053     }
2054 
2055     function needProcessing() public view returns (bool) {
2056         uint count = 15;
2057         
2058         return (oPending + cPending  +aPending > count || nextTokenId > cMax) && randomAvailable();
2059     }
2060 
2061     event ProcessRandom();
2062     function processRandom() external onlyOracle {
2063         processRand();
2064     }
2065 
2066     function processRand() internal {
2067         emit ProcessRandom();
2068         uint random = nextRandom();
2069     
2070         uint count = 16;
2071         uint mask = 0xffff;
2072         uint shift = 16;
2073         
2074         uint pending = oPending + cPending +aPending;
2075         for (uint i = 0; i < count; i++) {
2076             if (pending-- == 0) {
2077                 return;
2078             }
2079             resolve(random & mask);
2080             random = random >> shift;
2081         }
2082     }
2083 
2084     function setOracle(address _oracle) external onlyOwner {
2085         oracle = _oracle;
2086         emit OracleSet(_oracle);
2087     }
2088 
2089    function setController(address _controller) external onlyOwner {
2090         controller = _controller;
2091         emit ControllerSet(_controller);
2092     }
2093 
2094     // WEB3 SALE SUPPORT
2095 
2096 
2097     function OG_remaining() public view returns (uint256) {
2098         return oMax - (oStart + oSold + oPending)+1;
2099     }
2100 
2101     function ALPHA_remaining() public view returns (uint256) {
2102         return aMax - (aStart + aSold + aPending)+1;
2103     }
2104 
2105     function COMMON_remaining() public view returns (uint256) {
2106         return cMax - (cStart + cSold + cPending)+1;
2107     }
2108 
2109     function OG_price() public view returns (uint256) {
2110         require(OG_remaining() > 0,"OG Cards sold out"); 
2111         return og_price[og_pointer];
2112     }
2113 
2114     function ALPHA_price() public view returns (uint256) {
2115         require(ALPHA_remaining() > 0,"Alpha Cards sold out"); 
2116         return alpha_price[alpha_pointer];        
2117     }
2118 
2119     function COMMON_price() public view returns (uint256) {
2120         require(COMMON_remaining() > 0,"Random Cards sold out"); 
2121         return common_price[common_pointer];
2122     }
2123 
2124     modifier sale_active() {
2125         require(block.timestamp >= sale_start,"Sale not started");
2126         require(block.timestamp <= sale_end,"Sale ended");
2127         require(nextTokenId <= cMax, "Sorry. Sold out");
2128         _;
2129     }
2130 
2131 
2132     function request_random_if_needed() internal {
2133 
2134         if (randomOneOfEight++ % 16 == 15) {
2135             request_random();
2136         }
2137 
2138     }
2139 
2140  
2141     function assignCard(address buyer, uint256 card_type) internal {
2142         require(curve_set,"price curve not set");
2143         
2144         uint common_remaining = COMMON_remaining();
2145         uint alpha_remaining = ALPHA_remaining();
2146         request_random_if_needed();
2147         if (card_type == 2) {
2148             require(common_remaining > 0, "Sorry no random tickets available");
2149             uint cSum = cStart+cSold+cPending;
2150             _mint(buyer,cSum);
2151             cPending++;
2152             common_pointer = bump(cSold , cPending , common_stop,common_pointer);
2153             emit COMMON_Ordered(msg.sender, msg.value,cSum);
2154             return;
2155         } else if (card_type == 1)  {
2156             require (alpha_remaining > 0,"Sorry - no Alpha tickets available");
2157             uint aSum =aStart+aSold+aPending;
2158             _mint(buyer,aSum);
2159             emit ALPHA_Ordered(msg.sender, msg.value,aSum);
2160             aPending++;
2161             alpha_pointer = bump(aSold , aPending , alpha_stop,alpha_pointer);
2162             return;
2163         }
2164         require (OG_remaining() > 0, "Sorry, no OG cards available");
2165         uint oSum = oStart + oSold+oPending;
2166         _mint(buyer,oSum);
2167         emit OG_Ordered(msg.sender, msg.value,oSum);
2168         oPending++;
2169         og_pointer = bump(oSold,oPending,og_stop,og_pointer);
2170         return;
2171     }
2172  
2173    function resolve(uint256 random) internal {
2174         //bool upgrade;
2175         uint256 card_pos;
2176         //uint256 draw_pos;  // let's not get them confused
2177         uint256 r = random;
2178         if (cPending > 0) {
2179             card_pos = cStart + cSold++;
2180             cPending--;
2181         } else if (aPending > 0) {
2182             card_pos = aStart + aSold++;
2183             aPending--;
2184         } else if (oPending > 0) {
2185             card_pos = oStart+oSold++;
2186             oPending--;
2187         }   else {
2188             return; // NOTHING TO DO
2189         }
2190         uint256 chance = (r & tr_ass_order_mask)+1;       
2191         traitAssignmentOrder[card_pos] = chance;
2192         emit Resolution(card_pos,chance);
2193     }
2194 
2195     function bump(uint sold, uint pending, uint[] memory stop, uint pointer) internal pure returns (uint256) {
2196         if (pointer == stop.length - 1) return pointer; 
2197         if (sold + pending > stop[pointer]) {
2198             return pointer + 1;
2199         }
2200         return pointer;
2201     }
2202     
2203     function mintTheRest(uint card_type, address target) external onlyOwner {
2204         require(sale_is_over(), "not until it's over");
2205         require(card_type < 3,"invalid card type");
2206         uint remaining;
2207         uint toMint = 50;
2208         if (card_type == 0) remaining = OG_remaining();
2209         else if (card_type == 1) remaining = ALPHA_remaining();
2210         else if (card_type == 2) {
2211             remaining = COMMON_remaining();
2212             toMint = 30;
2213         }
2214         remaining = Math.min(remaining,toMint);
2215         for (uint j = 0; j < remaining; j++) {
2216             assignCard(target,card_type);
2217         }
2218     }
2219 
2220 
2221   
2222     function setSimpleHash200(uint pos,bytes32 hashX) external onlyAllowed {        
2223         allTokenIDHashes[pos] = hashX;
2224     }
2225 
2226     function hash10k(uint256[10000] memory data) public pure returns (bytes32) {
2227         return keccak256(abi.encodePacked(data));
2228     }
2229 
2230     function hash200(uint256[200] memory data) public pure returns (bytes32) {
2231         return keccak256(abi.encodePacked(data));
2232     }
2233 
2234     // ensures that the hashes are all correct
2235     function checkSimpleHash200( uint[10000] calldata input) public view returns (bool) {
2236         uint256[200] memory data;
2237         for (uint pos = 0; pos < 50; pos++){  
2238             for (uint j = 0; j < 200; j++) {
2239                 data[j] = input[j+pos*200];
2240             }
2241             bytes32 h32 = hash200(data);
2242             if(allTokenIDHashes[pos]!= h32) {
2243                 return (false);
2244             }
2245         }
2246         return (true);
2247     }
2248 
2249     function getTokenIDPosition(uint tokenID, uint[10000] calldata tokenIdArray) external pure returns (uint blockOf200, uint position) {
2250         for (uint j = 0; j < 100000; j++) {
2251             if (tokenID == tokenIdArray[j]) 
2252                 return (j/200,j%200);
2253         }
2254         require(false,"Not Found");
2255     }
2256 
2257     function verifyTokenAt(uint256 position, uint[10000] calldata tokenIdArray) public view returns (bool) {
2258         require (position < 10000,"invalid position") ;
2259         if (position < 11) return true; // founder or first OG
2260         if (position == 100) return true; // First Alpha
2261         if (position == 1000) return true; // First Common
2262         uint tokenId = tokenIdArray[position];
2263         uint prevToken = tokenIdArray[position-1];
2264         require(_exists(tokenId),"Token does not exist");
2265         require(_exists(prevToken),"Prev Token does not exist");
2266         require(cardType(tokenId) == cardType(prevToken),"different types of card");
2267         if (traitAssignmentOrder[tokenId] > traitAssignmentOrder[prevToken]) return true;
2268         if (traitAssignmentOrder[tokenId] < traitAssignmentOrder[prevToken]) return false;
2269         return (tokenId > prevToken );
2270     }
2271 
2272     function revealTokenAt(uint256 hashBlock, uint256 hashBlockPos,uint256[200] memory _tokenIds, uint256[200] memory _traits) external {
2273         require(hash200(_tokenIds)==allTokenIDHashes[hashBlock],"IDs in wrong order");
2274         require(hash200(_traits)==traitHashes[hashBlock],"Traits in wrong order");
2275  
2276         uint tokenID = _tokenIds[hashBlockPos];
2277         require(ownerOf(tokenID) == msg.sender,"Not your token");
2278         if (cardTraits[tokenID] == 0) {
2279             cardTraits[tokenID] = _traits[hashBlockPos];
2280             emit TraitsClaimed(tokenID,_traits[hashBlockPos]);
2281         } else {
2282             emit TraitsAlreadyClaimed(tokenID);
2283         }       
2284     }
2285 
2286     event TraitSet(uint pos,uint256 tokenId, uint256 traits);
2287 
2288     function randomAvailable() public view returns (bool) {
2289         return (lastRandomRequested > lastRandomProcessed) && rng.isRequestComplete(randomRequests[lastRandomProcessed]);
2290     }
2291 
2292     function nextRandom() internal returns (uint256) {
2293         require(randomAvailable(),"Nothing to process");
2294         return rng.randomNumber(randomRequests[lastRandomProcessed++]);
2295     }
2296 
2297     function request_random() internal {
2298         randomRequests[lastRandomRequested++] = rng.requestRandomNumber();
2299     }
2300 
2301     function request_another_random() external onlyOwner {
2302         request_random();
2303     }
2304 
2305     // View Function to get graphic properties
2306 
2307     function isCardResolved(uint256 tokenId) public view returns (bool) {
2308         return traitAssignmentOrder[tokenId] > 0;
2309     }
2310 
2311 
2312     function fullTrait(uint256 tokenId) external view returns (uint256) {
2313         return cardTraits[tokenId];
2314     }
2315 
2316     function cardType(uint256 serial) public view returns(CardType) {
2317         if (!isCardResolved(serial)) return CardType.Unresolved;
2318         if (serial < oStart) return CardType.Founder;
2319         if (serial < aStart) return CardType.OG;
2320         if (serial < cStart) return CardType.Alpha;
2321         return CardType.Common;
2322     }
2323 
2324      function traitAssignment(uint256 tokenId) external view returns (uint256) {
2325         return traitAssignmentOrder[tokenId];
2326     }
2327 
2328   
2329     function OG_next() external view returns (uint256 left, uint256 nextPrice) {
2330         return CARD_next(og_stop, og_price, oSold,oPending,og_pointer);
2331     }
2332 
2333     function ALPHA_next() external view returns (uint256 left, uint256 nextPrice) {
2334             return CARD_next(alpha_stop, alpha_price, aSold,aPending,alpha_pointer);
2335     }
2336     function RANDOM_next() external view returns (uint256 left, uint256 nextPrice) {
2337             return CARD_next(common_stop, common_price, cSold,cPending,common_pointer);
2338     }
2339 
2340     function CARD_next(uint256[] storage stop, uint256[] memory price, uint256 sold, uint256 pending, uint256 pointer) internal view returns (uint256 left, uint256 nextPrice) {
2341         left = stop[pointer] - (sold + pending);
2342         if (pointer < stop.length - 1)
2343             nextPrice = price[pointer+1];
2344         else
2345             nextPrice = price[pointer];
2346     }
2347 
2348         function drain(xERC20 token) external onlyOwner {
2349         if (address(token) == 0x0000000000000000000000000000000000000000) {
2350             payable(owner()).transfer(address(this).balance);
2351         } else {
2352             token.transfer(owner(),token.balanceOf(address(this)));
2353         }
2354     }
2355 
2356     bool _FuzeBlown;
2357     // after finalization the images will be assigned to match the trait data
2358     // but due to onboarding more artists we will have a late assignment.
2359     // when it is proven OK we burn
2360 
2361     // should be of the format ipfs://<hash>/path
2362     function setDataFolder(string memory _baseURI) external onlyAllowed {
2363         require(!_FuzeBlown,"This data can no longer be changed");
2364         _setBaseURI(_baseURI);
2365     }
2366 
2367     function burnDataFolder() external onlyAllowed {
2368         _FuzeBlown = true;
2369     }
2370 
2371     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2372         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2373         CardType ct = cardType(tokenId);
2374         if (ct == CardType.Unresolved) {
2375             return "https://temp.ether.cards/metadata/Unresolved";
2376         }
2377         // reformat to directory structure as below
2378         string memory folder = (tokenId % 100).toString(); 
2379         string memory file = tokenId.toString();
2380         string memory slash = "/";
2381         return string(abi.encodePacked(baseURI(),folder,slash,file,".json"));
2382     }
2383 
2384     /// 1 ... 10000
2385     /// 1 - 100 / 1 - 100
2386 
2387     function is_sale_on() external view returns (bool) {
2388         if (sale_is_over()) return false;
2389         if (block.timestamp < sale_start) return false;
2390         if (nextTokenId > cMax) return false;
2391         return true;
2392     }
2393 
2394     function TokenExists(uint tokenId) external view returns (bool) {
2395         return _exists(tokenId);
2396     }
2397     
2398     uint launch_date = 1616072400;
2399 
2400     function sale_is_over() public view returns (bool) {
2401         return (block.timestamp > sale_end);
2402     }
2403     
2404     function how_long_more() public view returns (uint Days, uint Hours, uint Minutes, uint Seconds) {
2405         require(block.timestamp < launch_date,"Missed It");
2406         uint gap = launch_date - block.timestamp;
2407         Days = gap / (24 * 60 * 60);
2408         gap = gap %  (24 * 60 * 60);
2409         Hours = gap / (60 * 60);
2410         gap = gap % (60 * 60);
2411         Minutes = gap / 60;
2412         Seconds = gap % 60;
2413         return (Days,Hours,Minutes,Seconds);
2414     }
2415 
2416     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2417         super._beforeTokenTransfer(from, to, tokenId);
2418 
2419         require(!paused(), "ERC721Pausable: token transfer while paused");
2420     }
2421 
2422     function pause() external onlyAllowed {
2423         _pause();
2424     }
2425 
2426     function unpause() external onlyAllowed {
2427         _unpause();
2428     }
2429 
2430 }