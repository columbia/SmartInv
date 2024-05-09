1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.2;
4 
5 
6 interface IERC721 {
7     function ownerOf(uint256 tokenId) external view returns (address owner);
8     function safeTransferFrom(address from, address to, uint256 tokenId) external;
9     function transferFrom(address from, address to, uint256 tokenId) external;
10     function isApprovedForAll(address owner, address operator) external view returns (bool);
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 interface FeesContract {
25     function calcByToken(address _seller, address _token, uint256 _amount) external view returns (uint256 fee);
26     function calcByEth(address _seller, uint256 _amount) external view returns (uint256 fee);
27 }
28 
29 library EnumerableMap {
30     // To implement this library for multiple types with as little code
31     // repetition as possible, we write it in terms of a generic Map type with
32     // bytes32 keys and values.
33     // The Map implementation uses private functions, and user-facing
34     // implementations (such as Uint256ToAddressMap) are just wrappers around
35     // the underlying Map.
36     // This means that we can only create new EnumerableMaps for types that fit
37     // in bytes32.
38 
39     struct MapEntry {
40         bytes32 _key;
41         bytes32 _value;
42     }
43 
44     struct Map {
45         // Storage of map keys and values
46         MapEntry[] _entries;
47 
48         // Position of the entry defined by a key in the `entries` array, plus 1
49         // because index 0 means a key is not in the map.
50         mapping (bytes32 => uint256) _indexes;
51     }
52 
53     /**
54      * @dev Adds a key-value pair to a map, or updates the value for an existing
55      * key. O(1).
56      *
57      * Returns true if the key was added to the map, that is if it was not
58      * already present.
59      */
60     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
61         // We read and store the key's index to prevent multiple reads from the same storage slot
62         uint256 keyIndex = map._indexes[key];
63 
64         if (keyIndex == 0) { // Equivalent to !contains(map, key)
65             map._entries.push(MapEntry({ _key: key, _value: value }));
66             // The entry is stored at length-1, but we add 1 to all indexes
67             // and use 0 as a sentinel value
68             map._indexes[key] = map._entries.length;
69             return true;
70         } else {
71             map._entries[keyIndex - 1]._value = value;
72             return false;
73         }
74     }
75 
76     /**
77      * @dev Removes a key-value pair from a map. O(1).
78      *
79      * Returns true if the key was removed from the map, that is if it was present.
80      */
81     function _remove(Map storage map, bytes32 key) private returns (bool) {
82         // We read and store the key's index to prevent multiple reads from the same storage slot
83         uint256 keyIndex = map._indexes[key];
84 
85         if (keyIndex != 0) { // Equivalent to contains(map, key)
86             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
87             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
88             // This modifies the order of the array, as noted in {at}.
89 
90             uint256 toDeleteIndex = keyIndex - 1;
91             uint256 lastIndex = map._entries.length - 1;
92 
93             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
94             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
95 
96             MapEntry storage lastEntry = map._entries[lastIndex];
97 
98             // Move the last entry to the index where the entry to delete is
99             map._entries[toDeleteIndex] = lastEntry;
100             // Update the index for the moved entry
101             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
102 
103             // Delete the slot where the moved entry was stored
104             map._entries.pop();
105 
106             // Delete the index for the deleted slot
107             delete map._indexes[key];
108 
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     /**
116      * @dev Returns true if the key is in the map. O(1).
117      */
118     function _contains(Map storage map, bytes32 key) private view returns (bool) {
119         return map._indexes[key] != 0;
120     }
121 
122     /**
123      * @dev Returns the number of key-value pairs in the map. O(1).
124      */
125     function _length(Map storage map) private view returns (uint256) {
126         return map._entries.length;
127     }
128 
129    /**
130     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
131     *
132     * Note that there are no guarantees on the ordering of entries inside the
133     * array, and it may change when more entries are added or removed.
134     *
135     * Requirements:
136     *
137     * - `index` must be strictly less than {length}.
138     */
139     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
140         require(map._entries.length > index, "EnumerableMap: index out of bounds");
141 
142         MapEntry storage entry = map._entries[index];
143         return (entry._key, entry._value);
144     }
145 
146     /**
147      * @dev Tries to returns the value associated with `key`.  O(1).
148      * Does not revert if `key` is not in the map.
149      */
150     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
151         uint256 keyIndex = map._indexes[key];
152         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
153         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
154     }
155 
156     /**
157      * @dev Returns the value associated with `key`.  O(1).
158      *
159      * Requirements:
160      *
161      * - `key` must be in the map.
162      */
163     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
164         uint256 keyIndex = map._indexes[key];
165         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
166         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
167     }
168 
169     /**
170      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
171      *
172      * CAUTION: This function is deprecated because it requires allocating memory for the error
173      * message unnecessarily. For custom revert reasons use {_tryGet}.
174      */
175     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
176         uint256 keyIndex = map._indexes[key];
177         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
178         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
179     }
180 
181     // UintToB32Map
182 
183     struct UintToB32Map {
184         Map _inner;
185     }
186 
187     /**
188      * @dev Adds a key-value pair to a map, or updates the value for an existing
189      * key. O(1).
190      *
191      * Returns true if the key was added to the map, that is if it was not
192      * already present.
193      */
194     function set(UintToB32Map storage map, uint256 key, bytes32 value) internal returns (bool) {
195         return _set(map._inner, bytes32(key), value);
196     }
197 
198     /**
199      * @dev Removes a value from a set. O(1).
200      *
201      * Returns true if the key was removed from the map, that is if it was present.
202      */
203     function remove(UintToB32Map storage map, uint256 key) internal returns (bool) {
204         return _remove(map._inner, bytes32(key));
205     }
206 
207     /**
208      * @dev Returns true if the key is in the map. O(1).
209      */
210     function contains(UintToB32Map storage map, uint256 key) internal view returns (bool) {
211         return _contains(map._inner, bytes32(key));
212     }
213 
214     /**
215      * @dev Returns the number of elements in the map. O(1).
216      */
217     function length(UintToB32Map storage map) internal view returns (uint256) {
218         return _length(map._inner);
219     }
220 
221    /**
222     * @dev Returns the element stored at position `index` in the set. O(1).
223     * Note that there are no guarantees on the ordering of values inside the
224     * array, and it may change when more values are added or removed.
225     *
226     * Requirements:
227     *
228     * - `index` must be strictly less than {length}.
229     */
230     function at(UintToB32Map storage map, uint256 index) internal view returns (uint256, bytes32) {
231         (bytes32 key, bytes32 value) = _at(map._inner, index);
232         return (uint256(key), value);
233     }
234 
235     /**
236      * @dev Tries to returns the value associated with `key`.  O(1).
237      * Does not revert if `key` is not in the map.
238      *
239      * _Available since v3.4._
240      */
241     function tryGet(UintToB32Map storage map, uint256 key) internal view returns (bool, bytes32) {
242         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
243         return (success, value);
244     }
245 
246     /**
247      * @dev Returns the value associated with `key`.  O(1).
248      *
249      * Requirements:
250      *
251      * - `key` must be in the map.
252      */
253     function get(UintToB32Map storage map, uint256 key) internal view returns (bytes32) {
254         return _get(map._inner, bytes32(key));
255     }
256 
257     /**
258      * @dev Same as {get}, with a custom error message when `key` is not in the map.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryGet}.
262      */
263     function get(UintToB32Map storage map, uint256 key, string memory errorMessage) internal view returns (bytes32) {
264         return _get(map._inner, bytes32(key), errorMessage);
265     }
266 }
267 
268 library EnumerableSet {
269     // To implement this library for multiple types with as little code
270     // repetition as possible, we write it in terms of a generic Set type with
271     // bytes32 values.
272     // The Set implementation uses private functions, and user-facing
273     // implementations (such as AddressSet) are just wrappers around the
274     // underlying Set.
275     // This means that we can only create new EnumerableSets for types that fit
276     // in bytes32.
277 
278     struct Set {
279         // Storage of set values
280         bytes32[] _values;
281 
282         // Position of the value in the `values` array, plus 1 because index 0
283         // means a value is not in the set.
284         mapping (bytes32 => uint256) _indexes;
285     }
286 
287     /**
288      * @dev Add a value to a set. O(1).
289      *
290      * Returns true if the value was added to the set, that is if it was not
291      * already present.
292      */
293     function _add(Set storage set, bytes32 value) private returns (bool) {
294         if (!_contains(set, value)) {
295             set._values.push(value);
296             // The value is stored at length-1, but we add 1 to all indexes
297             // and use 0 as a sentinel value
298             set._indexes[value] = set._values.length;
299             return true;
300         } else {
301             return false;
302         }
303     }
304 
305     /**
306      * @dev Removes a value from a set. O(1).
307      *
308      * Returns true if the value was removed from the set, that is if it was
309      * present.
310      */
311     function _remove(Set storage set, bytes32 value) private returns (bool) {
312         // We read and store the value's index to prevent multiple reads from the same storage slot
313         uint256 valueIndex = set._indexes[value];
314 
315         if (valueIndex != 0) { // Equivalent to contains(set, value)
316             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
317             // the array, and then remove the last element (sometimes called as 'swap and pop').
318             // This modifies the order of the array, as noted in {at}.
319 
320             uint256 toDeleteIndex = valueIndex - 1;
321             uint256 lastIndex = set._values.length - 1;
322 
323             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
324             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
325 
326             bytes32 lastvalue = set._values[lastIndex];
327 
328             // Move the last value to the index where the value to delete is
329             set._values[toDeleteIndex] = lastvalue;
330             // Update the index for the moved value
331             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
332 
333             // Delete the slot where the moved value was stored
334             set._values.pop();
335 
336             // Delete the index for the deleted slot
337             delete set._indexes[value];
338 
339             return true;
340         } else {
341             return false;
342         }
343     }
344 
345     /**
346      * @dev Returns true if the value is in the set. O(1).
347      */
348     function _contains(Set storage set, bytes32 value) private view returns (bool) {
349         return set._indexes[value] != 0;
350     }
351 
352     /**
353      * @dev Returns the number of values on the set. O(1).
354      */
355     function _length(Set storage set) private view returns (uint256) {
356         return set._values.length;
357     }
358 
359    /**
360     * @dev Returns the value stored at position `index` in the set. O(1).
361     *
362     * Note that there are no guarantees on the ordering of values inside the
363     * array, and it may change when more values are added or removed.
364     *
365     * Requirements:
366     *
367     * - `index` must be strictly less than {length}.
368     */
369     function _at(Set storage set, uint256 index) private view returns (bytes32) {
370         require(set._values.length > index, "EnumerableSet: index out of bounds");
371         return set._values[index];
372     }
373 
374     // Bytes32Set
375 
376     struct Bytes32Set {
377         Set _inner;
378     }
379 
380     /**
381      * @dev Add a value to a set. O(1).
382      *
383      * Returns true if the value was added to the set, that is if it was not
384      * already present.
385      */
386     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
387         return _add(set._inner, value);
388     }
389 
390     /**
391      * @dev Removes a value from a set. O(1).
392      *
393      * Returns true if the value was removed from the set, that is if it was
394      * present.
395      */
396     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
397         return _remove(set._inner, value);
398     }
399 
400     /**
401      * @dev Returns true if the value is in the set. O(1).
402      */
403     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
404         return _contains(set._inner, value);
405     }
406 
407     /**
408      * @dev Returns the number of values in the set. O(1).
409      */
410     function length(Bytes32Set storage set) internal view returns (uint256) {
411         return _length(set._inner);
412     }
413 
414    /**
415     * @dev Returns the value stored at position `index` in the set. O(1).
416     *
417     * Note that there are no guarantees on the ordering of values inside the
418     * array, and it may change when more values are added or removed.
419     *
420     * Requirements:
421     *
422     * - `index` must be strictly less than {length}.
423     */
424     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
425         return _at(set._inner, index);
426     }
427 
428     // AddressSet
429 
430     struct AddressSet {
431         Set _inner;
432     }
433 
434     /**
435      * @dev Add a value to a set. O(1).
436      *
437      * Returns true if the value was added to the set, that is if it was not
438      * already present.
439      */
440     function add(AddressSet storage set, address value) internal returns (bool) {
441         return _add(set._inner, bytes32(uint256(uint160(value))));
442     }
443 
444     /**
445      * @dev Removes a value from a set. O(1).
446      *
447      * Returns true if the value was removed from the set, that is if it was
448      * present.
449      */
450     function remove(AddressSet storage set, address value) internal returns (bool) {
451         return _remove(set._inner, bytes32(uint256(uint160(value))));
452     }
453 
454     /**
455      * @dev Returns true if the value is in the set. O(1).
456      */
457     function contains(AddressSet storage set, address value) internal view returns (bool) {
458         return _contains(set._inner, bytes32(uint256(uint160(value))));
459     }
460 
461     /**
462      * @dev Returns the number of values in the set. O(1).
463      */
464     function length(AddressSet storage set) internal view returns (uint256) {
465         return _length(set._inner);
466     }
467 
468    /**
469     * @dev Returns the value stored at position `index` in the set. O(1).
470     *
471     * Note that there are no guarantees on the ordering of values inside the
472     * array, and it may change when more values are added or removed.
473     *
474     * Requirements:
475     *
476     * - `index` must be strictly less than {length}.
477     */
478     function at(AddressSet storage set, uint256 index) internal view returns (address) {
479         return address(uint160(uint256(_at(set._inner, index))));
480     }
481 
482 
483     // UintSet
484 
485     struct UintSet {
486         Set _inner;
487     }
488 
489     /**
490      * @dev Add a value to a set. O(1).
491      *
492      * Returns true if the value was added to the set, that is if it was not
493      * already present.
494      */
495     function add(UintSet storage set, uint256 value) internal returns (bool) {
496         return _add(set._inner, bytes32(value));
497     }
498 
499     /**
500      * @dev Removes a value from a set. O(1).
501      *
502      * Returns true if the value was removed from the set, that is if it was
503      * present.
504      */
505     function remove(UintSet storage set, uint256 value) internal returns (bool) {
506         return _remove(set._inner, bytes32(value));
507     }
508 
509     /**
510      * @dev Returns true if the value is in the set. O(1).
511      */
512     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
513         return _contains(set._inner, bytes32(value));
514     }
515 
516     /**
517      * @dev Returns the number of values on the set. O(1).
518      */
519     function length(UintSet storage set) internal view returns (uint256) {
520         return _length(set._inner);
521     }
522 
523    /**
524     * @dev Returns the value stored at position `index` in the set. O(1).
525     *
526     * Note that there are no guarantees on the ordering of values inside the
527     * array, and it may change when more values are added or removed.
528     *
529     * Requirements:
530     *
531     * - `index` must be strictly less than {length}.
532     */
533     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
534         return uint256(_at(set._inner, index));
535     }
536 }
537 
538 library Address {
539 
540     function isContract(address account) internal view returns (bool) {
541         // This method relies on extcodesize, which returns 0 for contracts in
542         // construction, since the code is only stored at the end of the
543         // constructor execution.
544 
545         uint256 size;
546         // solhint-disable-next-line no-inline-assembly
547         assembly { size := extcodesize(account) }
548         return size > 0;
549     }
550 
551 
552     function sendValue(address payable recipient, uint256 amount) internal {
553         require(address(this).balance >= amount, "Address: insufficient balance");
554 
555         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
556         (bool success, ) = recipient.call{ value: amount }("");
557         require(success, "Address: unable to send value, recipient may have reverted");
558     }
559 
560    
561     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
562       return functionCall(target, data, "Address: low-level call failed");
563     }
564 
565     
566     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, 0, errorMessage);
568     }
569 
570     
571     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     
576     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
577         require(address(this).balance >= value, "Address: insufficient balance for call");
578         require(isContract(target), "Address: call to non-contract");
579 
580         // solhint-disable-next-line avoid-low-level-calls
581         (bool success, bytes memory returndata) = target.call{ value: value }(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585    
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     
591     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
592         require(isContract(target), "Address: static call to non-contract");
593 
594         // solhint-disable-next-line avoid-low-level-calls
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return _verifyCallResult(success, returndata, errorMessage);
597     }
598 
599    
600     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
601         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
602     }
603 
604   
605     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
606         require(isContract(target), "Address: delegate call to non-contract");
607 
608         // solhint-disable-next-line avoid-low-level-calls
609         (bool success, bytes memory returndata) = target.delegatecall(data);
610         return _verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 // solhint-disable-next-line no-inline-assembly
622                 assembly {
623                     let returndata_size := mload(returndata)
624                     revert(add(32, returndata), returndata_size)
625                 }
626             } else {
627                 revert(errorMessage);
628             }
629         }
630     }
631 }
632 
633 library SafeERC20 {
634     using Address for address;
635 
636     function safeTransfer(IERC20 token, address to, uint256 value) internal {
637         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
638     }
639 
640     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
641         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
642     }
643 
644     /**
645      * @dev Deprecated. This function has issues similar to the ones found in
646      * {IERC20-approve}, and its usage is discouraged.
647      *
648      * Whenever possible, use {safeIncreaseAllowance} and
649      * {safeDecreaseAllowance} instead.
650      */
651     function safeApprove(IERC20 token, address spender, uint256 value) internal {
652         // safeApprove should only be called when setting an initial allowance,
653         // or when resetting it to zero. To increase and decrease it, use
654         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
655         // solhint-disable-next-line max-line-length
656         require((value == 0) || (token.allowance(address(this), spender) == 0),
657             "SafeERC20: approve from non-zero to non-zero allowance"
658         );
659         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
660     }
661 
662     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
663         uint256 newAllowance = token.allowance(address(this), spender) + value;
664         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
665     }
666 
667     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
668         unchecked {
669             uint256 oldAllowance = token.allowance(address(this), spender);
670             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
671             uint256 newAllowance = oldAllowance - value;
672             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
673         }
674     }
675 
676     /**
677      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
678      * on the return value: the return value is optional (but if data is returned, it must not be false).
679      * @param token The token targeted by the call.
680      * @param data The call data (encoded using abi.encode or one of its variants).
681      */
682     function _callOptionalReturn(IERC20 token, bytes memory data) private {
683         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
684         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
685         // the target address contains contract code and also asserts for success in the low-level call.
686 
687         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
688         if (returndata.length > 0) { // Return data is optional
689             // solhint-disable-next-line max-line-length
690             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
691         }
692     }
693 }
694 
695 library ECDSA {
696     /**
697      * @dev Returns the address that signed a hashed message (`hash`) with
698      * `signature`. This address can then be used for verification purposes.
699      *
700      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
701      * this function rejects them by requiring the `s` value to be in the lower
702      * half order, and the `v` value to be either 27 or 28.
703      *
704      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
705      * verification to be secure: it is possible to craft signatures that
706      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
707      * this is by receiving a hash of the original message (which may otherwise
708      * be too long), and then calling {toEthSignedMessageHash} on it.
709      *
710      * Documentation for signature generation:
711      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
712      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
713      */
714     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
715         // Divide the signature in r, s and v variables
716         bytes32 r;
717         bytes32 s;
718         uint8 v;
719 
720         // Check the signature length
721         // - case 65: r,s,v signature (standard)
722         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
723         if (signature.length == 65) {
724             // ecrecover takes the signature parameters, and the only way to get them
725             // currently is to use assembly.
726             // solhint-disable-next-line no-inline-assembly
727             assembly {
728                 r := mload(add(signature, 0x20))
729                 s := mload(add(signature, 0x40))
730                 v := byte(0, mload(add(signature, 0x60)))
731             }
732         } else if (signature.length == 64) {
733             // ecrecover takes the signature parameters, and the only way to get them
734             // currently is to use assembly.
735             // solhint-disable-next-line no-inline-assembly
736             assembly {
737                 let vs := mload(add(signature, 0x40))
738                 r := mload(add(signature, 0x20))
739                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
740                 v := add(shr(255, vs), 27)
741             }
742         } else {
743             revert("ECDSA: invalid signature length");
744         }
745 
746         return recover(hash, v, r, s);
747     }
748 
749     /**
750      * @dev Overload of {ECDSA-recover} that receives the `v`,
751      * `r` and `s` signature fields separately.
752      */
753     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
754         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
755         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
756         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
757         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
758         //
759         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
760         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
761         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
762         // these malleable signatures as well.
763         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
764         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
765 
766         // If the signature is valid (and not malleable), return the signer address
767         address signer = ecrecover(hash, v, r, s);
768         require(signer != address(0), "ECDSA: invalid signature");
769 
770         return signer;
771     }
772 
773     /**
774      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
775      * produces hash corresponding to the one signed with the
776      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
777      * JSON-RPC method as part of EIP-191.
778      *
779      * See {recover}.
780      */
781     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
782         // 32 is the length in bytes of hash,
783         // enforced by the type signature above
784         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
785     }
786 
787     /**
788      * @dev Returns an Ethereum Signed Typed Data, created from a
789      * `domainSeparator` and a `structHash`. This produces hash corresponding
790      * to the one signed with the
791      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
792      * JSON-RPC method as part of EIP-712.
793      *
794      * See {recover}.
795      */
796     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
797         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
798     }
799 }
800 
801 contract Market {
802     using EnumerableSet for EnumerableSet.Bytes32Set ;
803     using EnumerableMap for EnumerableMap.UintToB32Map;
804     using SafeERC20 for IERC20;
805     
806     struct Coin {
807         bool active;
808         address tokenAddress;
809         string symbol;
810         string name;
811     }
812     
813     mapping (uint256 => Coin) public tradeCoins;
814     
815     struct Trade {
816         uint256 indexedBy;
817         bool active; 
818         address nftAddress;
819         address seller;
820         address buyer;
821         uint256 assetId;
822         uint256 end;
823         uint256 stime;
824         uint256 price;
825         uint256 coinIndex;
826         
827     }
828     
829     mapping (uint8 => address) public managers;
830     mapping (bytes32 => bool) public executedTask;
831     uint16 public taskIndex;
832     
833     mapping (address => bool) public authorizedERC721;
834     mapping (uint256 => bytes32) public tradeIndex;
835     mapping (bytes32 => Trade) public trades;
836     mapping (bytes32 => bool) public tradingCheck;
837 
838     EnumerableMap.UintToB32Map private tradesMap;
839     mapping (address => EnumerableSet.Bytes32Set) private userTrades;
840     
841     uint256 nextTrade;
842     FeesContract feesContract;
843     address payable walletAddress;
844     
845     modifier isManager() {
846         require(managers[0] == msg.sender || managers[1] == msg.sender || managers[2] == msg.sender, "Not manager");
847         _;
848     }
849     
850     constructor() {
851         // include ETH as coin
852         tradeCoins[1].tokenAddress = address(0x0);
853         tradeCoins[1].symbol = "ETH";
854         tradeCoins[1].name = "Ethereum";
855         tradeCoins[1].active = true;
856         
857         // include POLC as coin
858         tradeCoins[2].tokenAddress = 0xaA8330FB2B4D5D07ABFE7A72262752a8505C6B37;
859         tradeCoins[2].symbol = "POLC";
860         tradeCoins[2].name = "Polka City Token";
861         tradeCoins[2].active = true;
862         
863         // POlka City NFT 3D
864         authorizedERC721[0xB20217bf3d89667Fa15907971866acD6CcD570C8] = true;
865         // POlka City NFT
866         authorizedERC721[0x57E9a39aE8eC404C08f88740A9e6E306f50c937f] = true;
867         
868         walletAddress = payable(0xf7A9F6001ff8b499149569C54852226d719f2D76);
869         
870         managers[0] = msg.sender;
871         managers[1] = 0xeA50CE6EBb1a5E4A8F90Bfb35A2fb3c3F0C673ec;
872         managers[2] = 0xB1A951141F1b3A16824241f687C3741459E33225;
873         
874         feesContract = FeesContract(0xc10881fa05CE734336A153c72999eE91A287cC30);
875     }
876     
877     function createTrade(address _nftAddress, uint256 _assetId, uint256 _price, uint256 _coinIndex, uint256 _end) public {
878         require(authorizedERC721[_nftAddress] == true, "Unauthorized asset");
879         require(tradeCoins[_coinIndex].active == true, "Invalid payment coin");
880         require(_end == 0 || _end > block.timestamp, "Invalid end time");
881         bytes32 atCheck = keccak256(abi.encode(_nftAddress, _assetId, msg.sender));
882         require(tradingCheck[atCheck] == false, "This asset is already listed");
883         IERC721 nftContract = IERC721(_nftAddress);
884         require(nftContract.ownerOf(_assetId) == msg.sender, "Only asset owner can sell");
885         require(nftContract.isApprovedForAll(msg.sender, address(this)), "Market needs operator approval");
886         insertTrade(_nftAddress, _assetId, _price, _coinIndex, _end, atCheck);
887     }
888     
889     function insertTrade(address _nftAddress, uint256 _assetId, uint256 _price, uint256 _coinIndex, uint256 _end, bytes32 _atCheck) private {
890         Trade memory trade = Trade(nextTrade, true, _nftAddress, msg.sender, address(0x0), _assetId, _end, block.timestamp, _price, _coinIndex);
891         bytes32 tradeHash = keccak256(abi.encode(_nftAddress, _assetId, nextTrade));
892         tradeIndex[nextTrade] = tradeHash;
893         trades[tradeHash] = trade;
894         tradesMap.set(nextTrade, tradeHash);
895         userTrades[msg.sender].add(tradeHash);
896         tradingCheck[_atCheck] == true;
897         nextTrade += 1;
898     }
899     
900     function allTradesCount() public view returns (uint256) {
901         return (nextTrade);
902     }
903 
904     function tradesCount() public view returns (uint256) {
905         return (tradesMap.length());
906     }
907     
908     function _getTrade(bytes32 _tradeId) private view returns (uint256 indexedBy, address nftToken, address seller, address buyer, uint256 assetId, uint256 end, uint256 sTime, uint256 price, uint256 coinIndex, bool active) {
909         Trade memory _trade = trades[_tradeId];
910         return (
911         _trade.indexedBy,
912         _trade.nftAddress,
913         _trade.seller,
914         _trade.buyer,
915         _trade.assetId,
916         _trade.end,
917         _trade.stime,
918         _trade.price,
919         _trade.coinIndex,
920         _trade.active
921         );
922 
923     }
924 
925     function getTrade(bytes32 _tradeId) public view returns (uint256 indexedBy, address nftToken, address seller, address buyer, uint256 assetId, uint256 end, uint256 sTime, uint256 price, uint256 coinIndex, bool active) {
926         return _getTrade(_tradeId);
927     }
928     
929     function getTradeByIndex(uint256 _index) public view returns (uint256 indexedBy, address nftToken, address seller, address buyer, uint256 assetId, uint256 end, uint256 sTime, uint256 price, uint256 coinIndex, bool active) {
930         (, bytes32 tradeId) = tradesMap.at(_index);
931         return _getTrade(tradeId);
932     }
933 
934     function parseBytes(bytes memory data) private pure returns (bytes32){
935         bytes32 parsed;
936         assembly {parsed := mload(add(data, 32))}
937         return parsed;
938     }
939     
940     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public returns (bool) {
941         bytes32 _tradeId = parseBytes(_extraData);
942         Trade memory trade = trades[_tradeId];
943         require(tradeCoins[trade.coinIndex].tokenAddress == _token, "Invalid coin");
944         require(trade.active == true, "Trade not available");
945         require(_value == trade.price, "Invalid price");
946         if (verifyTrade(_tradeId, trade.seller, trade.nftAddress, trade.assetId, trade.end)) {
947             uint256 tradeFee = feesContract.calcByToken(trade.seller, tradeCoins[trade.coinIndex].tokenAddress , _value); 
948             executeTrade(_tradeId, _from, trade.seller, trade.nftAddress, trade.assetId);
949             IERC20 erc20Token = IERC20(_token); 
950             if (tradeFee > 0) {
951                 erc20Token.safeTransferFrom(_from, walletAddress, (tradeFee));
952                 erc20Token.safeTransferFrom(_from, trade.seller, (trade.price-tradeFee));
953             } else {
954                 erc20Token.safeTransferFrom(_from, trade.seller, (trade.price));
955             }
956             transferAsset(_from, trade.seller, trade.nftAddress, trade.assetId);
957             return (true);
958         } else {
959             return (false);
960         }
961 
962     }
963     
964     function buyWithEth(bytes32 _tradeId) public payable returns (bool) {
965         Trade memory trade = trades[_tradeId];
966         require(trade.coinIndex == 1, "Invalid coin");
967         require(trade.active == true, "Trade not available");
968         require(msg.value == trade.price, "Invalid price");
969         if (verifyTrade(_tradeId, trade.seller, trade.nftAddress, trade.assetId, trade.end)) {
970             uint256 tradeFee = feesContract.calcByEth(trade.seller, msg.value);
971             executeTrade(_tradeId, msg.sender, trade.seller, trade.nftAddress, trade.assetId);
972             if (tradeFee > 0) {
973               Address.sendValue(payable(walletAddress), tradeFee);
974               Address.sendValue(payable(trade.seller),(msg.value-tradeFee));
975             } else {
976               Address.sendValue(payable(trade.seller),(msg.value));
977             }
978             transferAsset(msg.sender, trade.seller, trade.nftAddress, trade.assetId);
979             return (true);
980         } else {
981             return (false);
982         }
983 
984     }
985     
986     function executeTrade(bytes32 _tradeId, address _buyer, address _seller, address _contract, uint256 _assetId) private {
987         trades[_tradeId].buyer = _buyer;
988         trades[_tradeId].active = false;
989         trades[_tradeId].stime = block.timestamp;
990         userTrades[_seller].remove(_tradeId);
991         tradesMap.remove(trades[_tradeId].indexedBy);
992         tradingCheck[keccak256(abi.encode(_contract, _assetId, _seller))] = false;
993     }
994     
995     function transferAsset(address _buyer, address _seller, address _contract, uint256 _assetId) private {
996         IERC721 nftToken = IERC721(_contract);
997         nftToken.safeTransferFrom(_seller, _buyer, _assetId);
998     }
999     
1000     function verifyTrade(bytes32 _tradeId, address _seller, address _contract, uint256 _assetId, uint256 _endTime) private returns (bool) {
1001         IERC721 nftToken = IERC721(_contract);
1002         address assetOwner = nftToken.ownerOf(_assetId);
1003         if (assetOwner != _seller || (_endTime > 0 && _endTime < block.timestamp)) {
1004             trades[_tradeId].active = false;
1005             userTrades[_seller].remove(_tradeId);
1006             tradesMap.remove(trades[_tradeId].indexedBy);
1007             return false;
1008         } else {
1009             return true;
1010         }
1011     }
1012 
1013     function cancelTrade(bytes32 _tradeId) public returns (bool) {
1014         Trade memory trade = trades[_tradeId];
1015         require(trade.seller == msg.sender, "Only asset seller can cancel the trade");
1016         trades[_tradeId].active = false;
1017         userTrades[trade.seller].remove(_tradeId);
1018         tradesMap.remove(trade.indexedBy);
1019         tradingCheck[keccak256(abi.encode(trade.nftAddress, trade.assetId, trade.seller))] = false;
1020         return true;
1021     }
1022 
1023     function adminCancelTrade(bytes32 _tradeId, bytes memory _sig) public isManager {
1024         uint8 mId = 1;
1025         bytes32 taskHash = keccak256(abi.encode(_tradeId, taskIndex, mId));
1026         verifyApproval(taskHash, _sig);
1027         Trade memory trade = trades[_tradeId];
1028         trades[_tradeId].active = false;
1029         userTrades[trade.seller].remove(_tradeId);
1030         tradesMap.remove(trade.indexedBy);
1031         tradingCheck[keccak256(abi.encode(trade.nftAddress, trade.assetId, trade.seller))] = false;
1032     }
1033     
1034     function tradesCountOf(address _from) public view returns (uint256) {
1035         return (userTrades[_from].length());
1036     }
1037     
1038     function tradeOfByIndex(address _from, uint256 _index) public view returns (bytes32 _trade) {
1039         return (userTrades[_from].at(_index));
1040     }
1041     
1042     function addCoin(uint256 _coinIndex, address _tokenAddress, string memory _tokenSymbol, string memory _tokenName, bool _active, bytes memory _sig) public isManager {
1043         uint8 mId = 2;
1044         bytes32 taskHash = keccak256(abi.encode(_coinIndex, _tokenAddress, _tokenSymbol, _tokenName, _active, taskIndex, mId));
1045         verifyApproval(taskHash, _sig);
1046         tradeCoins[_coinIndex].tokenAddress = _tokenAddress;
1047         tradeCoins[_coinIndex].symbol = _tokenSymbol;
1048         tradeCoins[_coinIndex].name = _tokenName;
1049         tradeCoins[_coinIndex].active = _active;
1050     }
1051 
1052     function authorizeNFT(address _nftAddress, bytes memory _sig) public isManager {
1053         uint8 mId = 3;
1054         bytes32 taskHash = keccak256(abi.encode(_nftAddress, taskIndex, mId));
1055         verifyApproval(taskHash, _sig);
1056         authorizedERC721[_nftAddress] = true;
1057     }
1058     
1059     function deauthorizeNFT(address _nftAddress, bytes memory _sig) public isManager {
1060         uint8 mId = 4;
1061         bytes32 taskHash = keccak256(abi.encode(_nftAddress, taskIndex, mId));
1062         verifyApproval(taskHash, _sig);
1063         authorizedERC721[_nftAddress] = false;
1064     }
1065     
1066     function setFeesContract(address _contract, bytes memory _sig) public isManager {
1067         uint8 mId = 5;
1068         bytes32 taskHash = keccak256(abi.encode(_contract, taskIndex, mId));
1069         verifyApproval(taskHash, _sig);
1070         feesContract = FeesContract(_contract);
1071     }
1072     
1073     function setWallet(address _wallet, bytes memory _sig) public isManager  {
1074         uint8 mId = 6;
1075         bytes32 taskHash = keccak256(abi.encode(_wallet, taskIndex, mId));
1076         verifyApproval(taskHash, _sig);
1077         walletAddress = payable(_wallet);
1078     }
1079     
1080     function verifyApproval(bytes32 _taskHash, bytes memory _sig) private {
1081         require(executedTask[_taskHash] == false, "Task already executed");
1082         address mSigner = ECDSA.recover(ECDSA.toEthSignedMessageHash(_taskHash), _sig);
1083         require(mSigner == managers[0] || mSigner == managers[1] || mSigner == managers[2], "Invalid signature"  );
1084         require(mSigner != msg.sender, "Signature from different managers required");
1085         executedTask[_taskHash] = true;
1086         taskIndex += 1;
1087     }
1088     
1089     function changeManager(address _manager, uint8 _index, bytes memory _sig) public isManager {
1090         require(_index >= 0 && _index <= 2, "Invalid index");
1091         uint8 mId = 100;
1092         bytes32 taskHash = keccak256(abi.encode(_manager, taskIndex, mId));
1093         verifyApproval(taskHash, _sig);
1094         managers[_index] = _manager;
1095     }
1096     
1097 
1098 }