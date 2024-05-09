1 // SPDX-License-Identifier: UNLICENSED
2 
3 // ørß1t$
4 // generative art nft project by berk aka princesscamel
5 // @berkozdemir - berkozdemir.com
6 // forked from RedemptionNFT.art by @memoryc0llector - 0x399AA4e3A65282eEe090EB58aedD787431C4aF2D
7 
8 // In 2019, I was heavily influenced by Alexai Shulgin's "Form Art", and one of my first generative visual works using p5.js was making orbiting html radio buttons on browser. 
9 // The live sketch can be viewed at my website "https://berkozdemir.com/", and SuperRare (as radiOrbit #1 and #2). 
10 // "ørß1t$” is the updated version, rewritten for on-chain generative art purposes; which displays a unique combination of varying object shapes, color palettes & distribution, orbit directions & speeds for every mint.
11 // You can click on canvas and move in x-axis to change the overall spinning speed.
12 
13 //                                .`           :/`                                 
14 //                               `hy.          os-                                 
15 //                                ``                        -.                     
16 //                   `--                                   -ys                     
17 //                   `::                                    ``                     
18 //                                                                           
19 //                             oh/                                     `           
20 //                             `/`                                   -yh           
21 //          -:.                                                      `:/           
22 //          `-`                      ..    `/-                                     
23 //                                   yd:   .hs`   ..                               
24 //                             +o.   .-     `     ::`                              
25 //                             /y.                      .                          
26 //                         ``             `            -:.        `:/       :+.    
27 //    `oo                 ./:         `/::ho.-```                 .++       .-     
28 //    -oy`                 ``       -:-o+.o:.--os``       `.:                      
29 //                       `        /y/-`        .-/+`      -so                      
30 //                     `ym-      .o+-            `oy/                              
31 //                      .-`      oo-              :s:                              
32 //                              -Nd`              `--      .ss`                    
33 //                      //`      +s-              :+/       ``               .yy`  
34 //    sy.               +/.      /oo.            `./`                         ``   
35 //    /:.                         .y+-.        ./..`      -o+                      
36 //                        .:.      `.+:oh::+.ys/o:        `+-                      
37 //              `dy.      /s:        ` :s-+o.//`                                   
38 //               o:`       `                           ys.                         
39 //                            .dy`                     ::`                .+:`     
40 //        ..`                  +:   `..     `    `/-                      .y+      
41 //        ++-                       .o/    od:   `..                               
42 //        `                          ``    .:.                                     
43 //                                                                             
44 //                                                  `:`            ``              
45 //                ```                               /s:            yh-             
46 //                /ds                                              --`             
47 //                `:`                                                              
48 //                                                      `.                         
49 //                            `.                        sy.                        
50 //                            ``           +y.           `                         
51 //                                         /s.                                     
52                                                                                 
53 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
54 
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP.
60  */
61 interface IERC20 {
62     /**
63      * @dev Returns the amount of tokens in existence.
64      */
65     function totalSupply() external view returns (uint256);
66 
67     /**
68      * @dev Returns the amount of tokens owned by `account`.
69      */
70     function balanceOf(address account) external view returns (uint256);
71 
72     /**
73      * @dev Moves `amount` tokens from the caller's account to `recipient`.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Returns the remaining number of tokens that `spender` will be
83      * allowed to spend on behalf of `owner` through {transferFrom}. This is
84      * zero by default.
85      *
86      * This value changes when {approve} or {transferFrom} are called.
87      */
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     /**
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * IMPORTANT: Beware that changing an allowance with this method brings the risk
96      * that someone may use both the old and the new allowance by unfortunate
97      * transaction ordering. One possible solution to mitigate this race
98      * condition is to first reduce the spender's allowance to 0 and set the
99      * desired value afterwards:
100      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101      *
102      * Emits an {Approval} event.
103      */
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Moves `amount` tokens from `sender` to `recipient` using the
108      * allowance mechanism. `amount` is then deducted from the caller's
109      * allowance.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) external returns (bool);
120 
121     /**
122      * @dev Emitted when `value` tokens are moved from one account (`from`) to
123      * another (`to`).
124      *
125      * Note that `value` may be zero.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     /**
130      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
131      * a call to {approve}. `value` is the new allowance.
132      */
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 
136 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev String operations.
144  */
145 library Strings {
146     bytes16 private constant alphabet = "0123456789abcdef";
147 
148     /**
149      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
150      */
151     function toString(uint256 value) internal pure returns (string memory) {
152         // Inspired by OraclizeAPI's implementation - MIT licence
153         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
154 
155         if (value == 0) {
156             return "0";
157         }
158         uint256 temp = value;
159         uint256 digits;
160         while (temp != 0) {
161             digits++;
162             temp /= 10;
163         }
164         bytes memory buffer = new bytes(digits);
165         while (value != 0) {
166             digits -= 1;
167             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
168             value /= 10;
169         }
170         return string(buffer);
171     }
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
175      */
176     function toHexString(uint256 value) internal pure returns (string memory) {
177         if (value == 0) {
178             return "0x00";
179         }
180         uint256 temp = value;
181         uint256 length = 0;
182         while (temp != 0) {
183             length++;
184             temp >>= 8;
185         }
186         return toHexString(value, length);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
191      */
192     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
193         bytes memory buffer = new bytes(2 * length + 2);
194         buffer[0] = "0";
195         buffer[1] = "x";
196         for (uint256 i = 2 * length + 1; i > 1; --i) {
197             buffer[i] = alphabet[value & 0xf];
198             value >>= 4;
199         }
200         require(value == 0, "Strings: hex length insufficient");
201         return string(buffer);
202     }
203 
204 }
205 
206 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
207 
208 
209 
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev Library for managing an enumerable variant of Solidity's
215  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
216  * type.
217  *
218  * Maps have the following properties:
219  *
220  * - Entries are added, removed, and checked for existence in constant time
221  * (O(1)).
222  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
223  *
224  * ```
225  * contract Example {
226  *     // Add the library methods
227  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
228  *
229  *     // Declare a set state variable
230  *     EnumerableMap.UintToAddressMap private myMap;
231  * }
232  * ```
233  *
234  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
235  * supported.
236  */
237 library EnumerableMap {
238     // To implement this library for multiple types with as little code
239     // repetition as possible, we write it in terms of a generic Map type with
240     // bytes32 keys and values.
241     // The Map implementation uses private functions, and user-facing
242     // implementations (such as Uint256ToAddressMap) are just wrappers around
243     // the underlying Map.
244     // This means that we can only create new EnumerableMaps for types that fit
245     // in bytes32.
246 
247     struct MapEntry {
248         bytes32 _key;
249         bytes32 _value;
250     }
251 
252     struct Map {
253         // Storage of map keys and values
254         MapEntry[] _entries;
255 
256         // Position of the entry defined by a key in the `entries` array, plus 1
257         // because index 0 means a key is not in the map.
258         mapping (bytes32 => uint256) _indexes;
259     }
260 
261     /**
262      * @dev Adds a key-value pair to a map, or updates the value for an existing
263      * key. O(1).
264      *
265      * Returns true if the key was added to the map, that is if it was not
266      * already present.
267      */
268     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
269         // We read and store the key's index to prevent multiple reads from the same storage slot
270         uint256 keyIndex = map._indexes[key];
271 
272         if (keyIndex == 0) { // Equivalent to !contains(map, key)
273             map._entries.push(MapEntry({ _key: key, _value: value }));
274             // The entry is stored at length-1, but we add 1 to all indexes
275             // and use 0 as a sentinel value
276             map._indexes[key] = map._entries.length;
277             return true;
278         } else {
279             map._entries[keyIndex - 1]._value = value;
280             return false;
281         }
282     }
283 
284     /**
285      * @dev Removes a key-value pair from a map. O(1).
286      *
287      * Returns true if the key was removed from the map, that is if it was present.
288      */
289     function _remove(Map storage map, bytes32 key) private returns (bool) {
290         // We read and store the key's index to prevent multiple reads from the same storage slot
291         uint256 keyIndex = map._indexes[key];
292 
293         if (keyIndex != 0) { // Equivalent to contains(map, key)
294             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
295             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
296             // This modifies the order of the array, as noted in {at}.
297 
298             uint256 toDeleteIndex = keyIndex - 1;
299             uint256 lastIndex = map._entries.length - 1;
300 
301             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
302             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
303 
304             MapEntry storage lastEntry = map._entries[lastIndex];
305 
306             // Move the last entry to the index where the entry to delete is
307             map._entries[toDeleteIndex] = lastEntry;
308             // Update the index for the moved entry
309             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
310 
311             // Delete the slot where the moved entry was stored
312             map._entries.pop();
313 
314             // Delete the index for the deleted slot
315             delete map._indexes[key];
316 
317             return true;
318         } else {
319             return false;
320         }
321     }
322 
323     /**
324      * @dev Returns true if the key is in the map. O(1).
325      */
326     function _contains(Map storage map, bytes32 key) private view returns (bool) {
327         return map._indexes[key] != 0;
328     }
329 
330     /**
331      * @dev Returns the number of key-value pairs in the map. O(1).
332      */
333     function _length(Map storage map) private view returns (uint256) {
334         return map._entries.length;
335     }
336 
337    /**
338     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
339     *
340     * Note that there are no guarantees on the ordering of entries inside the
341     * array, and it may change when more entries are added or removed.
342     *
343     * Requirements:
344     *
345     * - `index` must be strictly less than {length}.
346     */
347     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
348         require(map._entries.length > index, "EnumerableMap: index out of bounds");
349 
350         MapEntry storage entry = map._entries[index];
351         return (entry._key, entry._value);
352     }
353 
354     /**
355      * @dev Tries to returns the value associated with `key`.  O(1).
356      * Does not revert if `key` is not in the map.
357      */
358     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
359         uint256 keyIndex = map._indexes[key];
360         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
361         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
362     }
363 
364     /**
365      * @dev Returns the value associated with `key`.  O(1).
366      *
367      * Requirements:
368      *
369      * - `key` must be in the map.
370      */
371     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
372         uint256 keyIndex = map._indexes[key];
373         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
374         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
375     }
376 
377     /**
378      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {_tryGet}.
382      */
383     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
384         uint256 keyIndex = map._indexes[key];
385         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
386         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
387     }
388 
389     // UintToAddressMap
390 
391     struct UintToAddressMap {
392         Map _inner;
393     }
394 
395     /**
396      * @dev Adds a key-value pair to a map, or updates the value for an existing
397      * key. O(1).
398      *
399      * Returns true if the key was added to the map, that is if it was not
400      * already present.
401      */
402     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
403         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
404     }
405 
406     /**
407      * @dev Removes a value from a set. O(1).
408      *
409      * Returns true if the key was removed from the map, that is if it was present.
410      */
411     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
412         return _remove(map._inner, bytes32(key));
413     }
414 
415     /**
416      * @dev Returns true if the key is in the map. O(1).
417      */
418     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
419         return _contains(map._inner, bytes32(key));
420     }
421 
422     /**
423      * @dev Returns the number of elements in the map. O(1).
424      */
425     function length(UintToAddressMap storage map) internal view returns (uint256) {
426         return _length(map._inner);
427     }
428 
429    /**
430     * @dev Returns the element stored at position `index` in the set. O(1).
431     * Note that there are no guarantees on the ordering of values inside the
432     * array, and it may change when more values are added or removed.
433     *
434     * Requirements:
435     *
436     * - `index` must be strictly less than {length}.
437     */
438     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
439         (bytes32 key, bytes32 value) = _at(map._inner, index);
440         return (uint256(key), address(uint160(uint256(value))));
441     }
442 
443     /**
444      * @dev Tries to returns the value associated with `key`.  O(1).
445      * Does not revert if `key` is not in the map.
446      *
447      * _Available since v3.4._
448      */
449     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
450         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
451         return (success, address(uint160(uint256(value))));
452     }
453 
454     /**
455      * @dev Returns the value associated with `key`.  O(1).
456      *
457      * Requirements:
458      *
459      * - `key` must be in the map.
460      */
461     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
462         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
463     }
464 
465     /**
466      * @dev Same as {get}, with a custom error message when `key` is not in the map.
467      *
468      * CAUTION: This function is deprecated because it requires allocating memory for the error
469      * message unnecessarily. For custom revert reasons use {tryGet}.
470      */
471     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
472         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
473     }
474 }
475 
476 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
477 
478 
479 
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Library for managing
485  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
486  * types.
487  *
488  * Sets have the following properties:
489  *
490  * - Elements are added, removed, and checked for existence in constant time
491  * (O(1)).
492  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
493  *
494  * ```
495  * contract Example {
496  *     // Add the library methods
497  *     using EnumerableSet for EnumerableSet.AddressSet;
498  *
499  *     // Declare a set state variable
500  *     EnumerableSet.AddressSet private mySet;
501  * }
502  * ```
503  *
504  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
505  * and `uint256` (`UintSet`) are supported.
506  */
507 library EnumerableSet {
508     // To implement this library for multiple types with as little code
509     // repetition as possible, we write it in terms of a generic Set type with
510     // bytes32 values.
511     // The Set implementation uses private functions, and user-facing
512     // implementations (such as AddressSet) are just wrappers around the
513     // underlying Set.
514     // This means that we can only create new EnumerableSets for types that fit
515     // in bytes32.
516 
517     struct Set {
518         // Storage of set values
519         bytes32[] _values;
520 
521         // Position of the value in the `values` array, plus 1 because index 0
522         // means a value is not in the set.
523         mapping (bytes32 => uint256) _indexes;
524     }
525 
526     /**
527      * @dev Add a value to a set. O(1).
528      *
529      * Returns true if the value was added to the set, that is if it was not
530      * already present.
531      */
532     function _add(Set storage set, bytes32 value) private returns (bool) {
533         if (!_contains(set, value)) {
534             set._values.push(value);
535             // The value is stored at length-1, but we add 1 to all indexes
536             // and use 0 as a sentinel value
537             set._indexes[value] = set._values.length;
538             return true;
539         } else {
540             return false;
541         }
542     }
543 
544     /**
545      * @dev Removes a value from a set. O(1).
546      *
547      * Returns true if the value was removed from the set, that is if it was
548      * present.
549      */
550     function _remove(Set storage set, bytes32 value) private returns (bool) {
551         // We read and store the value's index to prevent multiple reads from the same storage slot
552         uint256 valueIndex = set._indexes[value];
553 
554         if (valueIndex != 0) { // Equivalent to contains(set, value)
555             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
556             // the array, and then remove the last element (sometimes called as 'swap and pop').
557             // This modifies the order of the array, as noted in {at}.
558 
559             uint256 toDeleteIndex = valueIndex - 1;
560             uint256 lastIndex = set._values.length - 1;
561 
562             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
563             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
564 
565             bytes32 lastvalue = set._values[lastIndex];
566 
567             // Move the last value to the index where the value to delete is
568             set._values[toDeleteIndex] = lastvalue;
569             // Update the index for the moved value
570             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
571 
572             // Delete the slot where the moved value was stored
573             set._values.pop();
574 
575             // Delete the index for the deleted slot
576             delete set._indexes[value];
577 
578             return true;
579         } else {
580             return false;
581         }
582     }
583 
584     /**
585      * @dev Returns true if the value is in the set. O(1).
586      */
587     function _contains(Set storage set, bytes32 value) private view returns (bool) {
588         return set._indexes[value] != 0;
589     }
590 
591     /**
592      * @dev Returns the number of values on the set. O(1).
593      */
594     function _length(Set storage set) private view returns (uint256) {
595         return set._values.length;
596     }
597 
598    /**
599     * @dev Returns the value stored at position `index` in the set. O(1).
600     *
601     * Note that there are no guarantees on the ordering of values inside the
602     * array, and it may change when more values are added or removed.
603     *
604     * Requirements:
605     *
606     * - `index` must be strictly less than {length}.
607     */
608     function _at(Set storage set, uint256 index) private view returns (bytes32) {
609         require(set._values.length > index, "EnumerableSet: index out of bounds");
610         return set._values[index];
611     }
612 
613     // Bytes32Set
614 
615     struct Bytes32Set {
616         Set _inner;
617     }
618 
619     /**
620      * @dev Add a value to a set. O(1).
621      *
622      * Returns true if the value was added to the set, that is if it was not
623      * already present.
624      */
625     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
626         return _add(set._inner, value);
627     }
628 
629     /**
630      * @dev Removes a value from a set. O(1).
631      *
632      * Returns true if the value was removed from the set, that is if it was
633      * present.
634      */
635     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
636         return _remove(set._inner, value);
637     }
638 
639     /**
640      * @dev Returns true if the value is in the set. O(1).
641      */
642     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
643         return _contains(set._inner, value);
644     }
645 
646     /**
647      * @dev Returns the number of values in the set. O(1).
648      */
649     function length(Bytes32Set storage set) internal view returns (uint256) {
650         return _length(set._inner);
651     }
652 
653    /**
654     * @dev Returns the value stored at position `index` in the set. O(1).
655     *
656     * Note that there are no guarantees on the ordering of values inside the
657     * array, and it may change when more values are added or removed.
658     *
659     * Requirements:
660     *
661     * - `index` must be strictly less than {length}.
662     */
663     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
664         return _at(set._inner, index);
665     }
666 
667     // AddressSet
668 
669     struct AddressSet {
670         Set _inner;
671     }
672 
673     /**
674      * @dev Add a value to a set. O(1).
675      *
676      * Returns true if the value was added to the set, that is if it was not
677      * already present.
678      */
679     function add(AddressSet storage set, address value) internal returns (bool) {
680         return _add(set._inner, bytes32(uint256(uint160(value))));
681     }
682 
683     /**
684      * @dev Removes a value from a set. O(1).
685      *
686      * Returns true if the value was removed from the set, that is if it was
687      * present.
688      */
689     function remove(AddressSet storage set, address value) internal returns (bool) {
690         return _remove(set._inner, bytes32(uint256(uint160(value))));
691     }
692 
693     /**
694      * @dev Returns true if the value is in the set. O(1).
695      */
696     function contains(AddressSet storage set, address value) internal view returns (bool) {
697         return _contains(set._inner, bytes32(uint256(uint160(value))));
698     }
699 
700     /**
701      * @dev Returns the number of values in the set. O(1).
702      */
703     function length(AddressSet storage set) internal view returns (uint256) {
704         return _length(set._inner);
705     }
706 
707    /**
708     * @dev Returns the value stored at position `index` in the set. O(1).
709     *
710     * Note that there are no guarantees on the ordering of values inside the
711     * array, and it may change when more values are added or removed.
712     *
713     * Requirements:
714     *
715     * - `index` must be strictly less than {length}.
716     */
717     function at(AddressSet storage set, uint256 index) internal view returns (address) {
718         return address(uint160(uint256(_at(set._inner, index))));
719     }
720 
721 
722     // UintSet
723 
724     struct UintSet {
725         Set _inner;
726     }
727 
728     /**
729      * @dev Add a value to a set. O(1).
730      *
731      * Returns true if the value was added to the set, that is if it was not
732      * already present.
733      */
734     function add(UintSet storage set, uint256 value) internal returns (bool) {
735         return _add(set._inner, bytes32(value));
736     }
737 
738     /**
739      * @dev Removes a value from a set. O(1).
740      *
741      * Returns true if the value was removed from the set, that is if it was
742      * present.
743      */
744     function remove(UintSet storage set, uint256 value) internal returns (bool) {
745         return _remove(set._inner, bytes32(value));
746     }
747 
748     /**
749      * @dev Returns true if the value is in the set. O(1).
750      */
751     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
752         return _contains(set._inner, bytes32(value));
753     }
754 
755     /**
756      * @dev Returns the number of values on the set. O(1).
757      */
758     function length(UintSet storage set) internal view returns (uint256) {
759         return _length(set._inner);
760     }
761 
762    /**
763     * @dev Returns the value stored at position `index` in the set. O(1).
764     *
765     * Note that there are no guarantees on the ordering of values inside the
766     * array, and it may change when more values are added or removed.
767     *
768     * Requirements:
769     *
770     * - `index` must be strictly less than {length}.
771     */
772     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
773         return uint256(_at(set._inner, index));
774     }
775 }
776 
777 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
778 
779 
780 
781 
782 pragma solidity ^0.8.0;
783 
784 /**
785  * @dev Collection of functions related to the address type
786  */
787 library Address {
788     /**
789      * @dev Returns true if `account` is a contract.
790      *
791      * [IMPORTANT]
792      * ====
793      * It is unsafe to assume that an address for which this function returns
794      * false is an externally-owned account (EOA) and not a contract.
795      *
796      * Among others, `isContract` will return false for the following
797      * types of addresses:
798      *
799      *  - an externally-owned account
800      *  - a contract in construction
801      *  - an address where a contract will be created
802      *  - an address where a contract lived, but was destroyed
803      * ====
804      */
805     function isContract(address account) internal view returns (bool) {
806         // This method relies on extcodesize, which returns 0 for contracts in
807         // construction, since the code is only stored at the end of the
808         // constructor execution.
809 
810         uint256 size;
811         // solhint-disable-next-line no-inline-assembly
812         assembly { size := extcodesize(account) }
813         return size > 0;
814     }
815 
816     /**
817      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
818      * `recipient`, forwarding all available gas and reverting on errors.
819      *
820      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
821      * of certain opcodes, possibly making contracts go over the 2300 gas limit
822      * imposed by `transfer`, making them unable to receive funds via
823      * `transfer`. {sendValue} removes this limitation.
824      *
825      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
826      *
827      * IMPORTANT: because control is transferred to `recipient`, care must be
828      * taken to not create reentrancy vulnerabilities. Consider using
829      * {ReentrancyGuard} or the
830      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
831      */
832     function sendValue(address payable recipient, uint256 amount) internal {
833         require(address(this).balance >= amount, "Address: insufficient balance");
834 
835         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
836         (bool success, ) = recipient.call{ value: amount }("");
837         require(success, "Address: unable to send value, recipient may have reverted");
838     }
839 
840     /**
841      * @dev Performs a Solidity function call using a low level `call`. A
842      * plain`call` is an unsafe replacement for a function call: use this
843      * function instead.
844      *
845      * If `target` reverts with a revert reason, it is bubbled up by this
846      * function (like regular Solidity function calls).
847      *
848      * Returns the raw returned data. To convert to the expected return value,
849      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
850      *
851      * Requirements:
852      *
853      * - `target` must be a contract.
854      * - calling `target` with `data` must not revert.
855      *
856      * _Available since v3.1._
857      */
858     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
859       return functionCall(target, data, "Address: low-level call failed");
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
864      * `errorMessage` as a fallback revert reason when `target` reverts.
865      *
866      * _Available since v3.1._
867      */
868     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
869         return functionCallWithValue(target, data, 0, errorMessage);
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
874      * but also transferring `value` wei to `target`.
875      *
876      * Requirements:
877      *
878      * - the calling contract must have an ETH balance of at least `value`.
879      * - the called Solidity function must be `payable`.
880      *
881      * _Available since v3.1._
882      */
883     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
884         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
885     }
886 
887     /**
888      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
889      * with `errorMessage` as a fallback revert reason when `target` reverts.
890      *
891      * _Available since v3.1._
892      */
893     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
894         require(address(this).balance >= value, "Address: insufficient balance for call");
895         require(isContract(target), "Address: call to non-contract");
896 
897         // solhint-disable-next-line avoid-low-level-calls
898         (bool success, bytes memory returndata) = target.call{ value: value }(data);
899         return _verifyCallResult(success, returndata, errorMessage);
900     }
901 
902     /**
903      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
904      * but performing a static call.
905      *
906      * _Available since v3.3._
907      */
908     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
909         return functionStaticCall(target, data, "Address: low-level static call failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
914      * but performing a static call.
915      *
916      * _Available since v3.3._
917      */
918     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
919         require(isContract(target), "Address: static call to non-contract");
920 
921         // solhint-disable-next-line avoid-low-level-calls
922         (bool success, bytes memory returndata) = target.staticcall(data);
923         return _verifyCallResult(success, returndata, errorMessage);
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
928      * but performing a delegate call.
929      *
930      * _Available since v3.4._
931      */
932     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
933         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
934     }
935 
936     /**
937      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
938      * but performing a delegate call.
939      *
940      * _Available since v3.4._
941      */
942     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
943         require(isContract(target), "Address: delegate call to non-contract");
944 
945         // solhint-disable-next-line avoid-low-level-calls
946         (bool success, bytes memory returndata) = target.delegatecall(data);
947         return _verifyCallResult(success, returndata, errorMessage);
948     }
949 
950     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
951         if (success) {
952             return returndata;
953         } else {
954             // Look for revert reason and bubble it up if present
955             if (returndata.length > 0) {
956                 // The easiest way to bubble the revert reason is using memory via assembly
957 
958                 // solhint-disable-next-line no-inline-assembly
959                 assembly {
960                     let returndata_size := mload(returndata)
961                     revert(add(32, returndata), returndata_size)
962                 }
963             } else {
964                 revert(errorMessage);
965             }
966         }
967     }
968 }
969 
970 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
971 
972 
973 pragma solidity ^0.8.0;
974 
975 /**
976  * @dev Interface of the ERC165 standard, as defined in the
977  * https://eips.ethereum.org/EIPS/eip-165[EIP].
978  *
979  * Implementers can declare support of contract interfaces, which can then be
980  * queried by others ({ERC165Checker}).
981  *
982  * For an implementation, see {ERC165}.
983  */
984 interface IERC165 {
985     /**
986      * @dev Returns true if this contract implements the interface defined by
987      * `interfaceId`. See the corresponding
988      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
989      * to learn more about how these ids are created.
990      *
991      * This function call must use less than 30 000 gas.
992      */
993     function supportsInterface(bytes4 interfaceId) external view returns (bool);
994 }
995 
996 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @dev Implementation of the {IERC165} interface.
1004  *
1005  * Contracts may inherit from this and call {_registerInterface} to declare
1006  * their support of an interface.
1007  */
1008 abstract contract ERC165 is IERC165 {
1009     /**
1010      * @dev Mapping of interface ids to whether or not it's supported.
1011      */
1012     mapping(bytes4 => bool) private _supportedInterfaces;
1013 
1014     constructor () {
1015         // Derived contracts need only register support for their own interfaces,
1016         // we register support for ERC165 itself here
1017         _registerInterface(type(IERC165).interfaceId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      *
1023      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1026         return _supportedInterfaces[interfaceId];
1027     }
1028 
1029     /**
1030      * @dev Registers the contract as an implementer of the interface defined by
1031      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1032      * registering its interface id is not required.
1033      *
1034      * See {IERC165-supportsInterface}.
1035      *
1036      * Requirements:
1037      *
1038      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1039      */
1040     function _registerInterface(bytes4 interfaceId) internal virtual {
1041         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1042         _supportedInterfaces[interfaceId] = true;
1043     }
1044 }
1045 
1046 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
1047 
1048 
1049 
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 
1054 /**
1055  * @dev Required interface of an ERC721 compliant contract.
1056  */
1057 interface IERC721 is IERC165 {
1058     /**
1059      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1060      */
1061     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1062 
1063     /**
1064      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1065      */
1066     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1067 
1068     /**
1069      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1070      */
1071     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1072 
1073     /**
1074      * @dev Returns the number of tokens in ``owner``'s account.
1075      */
1076     function balanceOf(address owner) external view returns (uint256 balance);
1077 
1078     /**
1079      * @dev Returns the owner of the `tokenId` token.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      */
1085     function ownerOf(uint256 tokenId) external view returns (address owner);
1086 
1087     /**
1088      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1089      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1090      *
1091      * Requirements:
1092      *
1093      * - `from` cannot be the zero address.
1094      * - `to` cannot be the zero address.
1095      * - `tokenId` token must exist and be owned by `from`.
1096      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1097      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1102 
1103     /**
1104      * @dev Transfers `tokenId` token from `from` to `to`.
1105      *
1106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function transferFrom(address from, address to, uint256 tokenId) external;
1118 
1119     /**
1120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1121      * The approval is cleared when the token is transferred.
1122      *
1123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1124      *
1125      * Requirements:
1126      *
1127      * - The caller must own the token or be an approved operator.
1128      * - `tokenId` must exist.
1129      *
1130      * Emits an {Approval} event.
1131      */
1132     function approve(address to, uint256 tokenId) external;
1133 
1134     /**
1135      * @dev Returns the account approved for `tokenId` token.
1136      *
1137      * Requirements:
1138      *
1139      * - `tokenId` must exist.
1140      */
1141     function getApproved(uint256 tokenId) external view returns (address operator);
1142 
1143     /**
1144      * @dev Approve or remove `operator` as an operator for the caller.
1145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1146      *
1147      * Requirements:
1148      *
1149      * - The `operator` cannot be the caller.
1150      *
1151      * Emits an {ApprovalForAll} event.
1152      */
1153     function setApprovalForAll(address operator, bool _approved) external;
1154 
1155     /**
1156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1157      *
1158      * See {setApprovalForAll}
1159      */
1160     function isApprovedForAll(address owner, address operator) external view returns (bool);
1161 
1162     /**
1163       * @dev Safely transfers `tokenId` token from `from` to `to`.
1164       *
1165       * Requirements:
1166       *
1167       * - `from` cannot be the zero address.
1168       * - `to` cannot be the zero address.
1169       * - `tokenId` token must exist and be owned by `from`.
1170       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1171       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172       *
1173       * Emits a {Transfer} event.
1174       */
1175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1176 }
1177 
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 /**
1182  * @title ERC721 token receiver interface
1183  * @dev Interface for any contract that wants to support safeTransfers
1184  * from ERC721 asset contracts.
1185  */
1186 interface IERC721Receiver {
1187     /**
1188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1189      * by `operator` from `from`, this function is called.
1190      *
1191      * It must return its Solidity selector to confirm the token transfer.
1192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1193      *
1194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1195      */
1196     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1197 }
1198 
1199 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1200 
1201 
1202 
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 /**
1208  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1209  * @dev See https://eips.ethereum.org/EIPS/eip-721
1210  */
1211 interface IERC721Enumerable is IERC721 {
1212 
1213     /**
1214      * @dev Returns the total amount of tokens stored by the contract.
1215      */
1216     function totalSupply() external view returns (uint256);
1217 
1218     /**
1219      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1220      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1221      */
1222     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1223 
1224     /**
1225      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1226      * Use along with {totalSupply} to enumerate all tokens.
1227      */
1228     function tokenByIndex(uint256 index) external view returns (uint256);
1229 }
1230 
1231 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1232 
1233 
1234 
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 
1239 /**
1240  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1241  * @dev See https://eips.ethereum.org/EIPS/eip-721
1242  */
1243 interface IERC721Metadata is IERC721 {
1244 
1245     /**
1246      * @dev Returns the token collection name.
1247      */
1248     function name() external view returns (string memory);
1249 
1250     /**
1251      * @dev Returns the token collection symbol.
1252      */
1253     function symbol() external view returns (string memory);
1254 
1255     /**
1256      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1257      */
1258     function tokenURI(uint256 tokenId) external view returns (string memory);
1259 }
1260 
1261 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1262 
1263 
1264 
1265 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1266 
1267 
1268 
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 /*
1273  * @dev Provides information about the current execution context, including the
1274  * sender of the transaction and its data. While these are generally available
1275  * via msg.sender and msg.data, they should not be accessed in such a direct
1276  * manner, since when dealing with GSN meta-transactions the account sending and
1277  * paying for execution may not be the actual sender (as far as an application
1278  * is concerned).
1279  *
1280  * This contract is only required for intermediate, library-like contracts.
1281  */
1282 abstract contract Context {
1283     function _msgSender() internal view virtual returns (address) {
1284         return msg.sender;
1285     }
1286 
1287     function _msgData() internal view virtual returns (bytes calldata) {
1288         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1289         return msg.data;
1290     }
1291 }
1292 
1293 
1294 
1295 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1296 
1297 
1298 
1299 
1300 pragma solidity ^0.8.0;
1301 
1302 
1303 
1304 
1305 
1306 
1307 
1308 
1309 
1310 
1311 
1312 /**
1313  * @title ERC721 Non-Fungible Token Standard basic implementation
1314  * @dev see https://eips.ethereum.org/EIPS/eip-721
1315  */
1316 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1317     using Address for address;
1318     using EnumerableSet for EnumerableSet.UintSet;
1319     using EnumerableMap for EnumerableMap.UintToAddressMap;
1320     using Strings for uint256;
1321     
1322     // Mapping from holder address to their (enumerable) set of owned tokens
1323     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1324 
1325     
1326     // Enumerable mapping from token ids to their owners
1327     EnumerableMap.UintToAddressMap private _tokenOwners;
1328 
1329     // Mapping from token ID to approved address
1330     mapping (uint256 => address) private _tokenApprovals;
1331 
1332     // Mapping from owner to operator approvals
1333     mapping (address => mapping (address => bool)) private _operatorApprovals;
1334 
1335     // Token name
1336     string private _name;
1337 
1338     // Token symbol
1339     string private _symbol;
1340 
1341     // Optional mapping for token URIs
1342     mapping (uint256 => string) private _tokenURIs;
1343 
1344     // Base URI
1345     string private _baseURI;
1346 
1347     /**
1348      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1349      */
1350     constructor (string memory name_, string memory symbol_) {
1351         _name = name_;
1352         _symbol = symbol_;
1353 
1354         // register the supported interfaces to conform to ERC721 via ERC165
1355         _registerInterface(type(IERC721).interfaceId);
1356         _registerInterface(type(IERC721Metadata).interfaceId);
1357         _registerInterface(type(IERC721Enumerable).interfaceId);
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-balanceOf}.
1362      */
1363     function balanceOf(address owner) public view virtual override returns (uint256) {
1364         require(owner != address(0), "ERC721: balance query for the zero address");
1365         return _holderTokens[owner].length();
1366     }
1367     
1368     
1369 
1370     
1371  
1372     
1373     /**
1374      * @dev See {IERC721-ownerOf}.
1375      */
1376     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1377         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-name}.
1382      */
1383     function name() public view virtual override returns (string memory) {
1384         return _name;
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Metadata-symbol}.
1389      */
1390     function symbol() public view virtual override returns (string memory) {
1391         return _symbol;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-tokenURI}.
1396      */
1397     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1398         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1399 
1400         string memory _tokenURI = _tokenURIs[tokenId];
1401         string memory base = baseURI();
1402 
1403         // If there is no base URI, return the token URI.
1404         if (bytes(base).length == 0) {
1405             return _tokenURI;
1406         }
1407         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1408         if (bytes(_tokenURI).length > 0) {
1409             return string(abi.encodePacked(base, _tokenURI));
1410         }
1411         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1412         return string(abi.encodePacked(base, tokenId.toString()));
1413     }
1414 
1415     /**
1416     * @dev Returns the base URI set via {_setBaseURI}. This will be
1417     * automatically added as a prefix in {tokenURI} to each token's URI, or
1418     * to the token ID if no specific URI is set for that token ID.
1419     */
1420     function baseURI() public view virtual returns (string memory) {
1421         return _baseURI;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1426      */
1427     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1428         return _holderTokens[owner].at(index);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-totalSupply}.
1433      */
1434     function totalSupply() public view virtual override returns (uint256) {
1435         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1436         return _tokenOwners.length();
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-tokenByIndex}.
1441      */
1442     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1443         (uint256 tokenId, ) = _tokenOwners.at(index);
1444         return tokenId;
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-approve}.
1449      */
1450     function approve(address to, uint256 tokenId) public virtual override {
1451         address owner = ERC721.ownerOf(tokenId);
1452         require(to != owner, "ERC721: approval to current owner");
1453 
1454         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1455             "ERC721: approve caller is not owner nor approved for all"
1456         );
1457 
1458         _approve(to, tokenId);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-getApproved}.
1463      */
1464     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1465         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1466 
1467         return _tokenApprovals[tokenId];
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-setApprovalForAll}.
1472      */
1473     function setApprovalForAll(address operator, bool approved) public virtual override {
1474         require(operator != _msgSender(), "ERC721: approve to caller");
1475 
1476         _operatorApprovals[_msgSender()][operator] = approved;
1477         emit ApprovalForAll(_msgSender(), operator, approved);
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-isApprovedForAll}.
1482      */
1483     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1484         return _operatorApprovals[owner][operator];
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-transferFrom}.
1489      */
1490     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1491         //solhint-disable-next-line max-line-length
1492         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1493 
1494         _transfer(from, to, tokenId);
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-safeTransferFrom}.
1499      */
1500     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1501         safeTransferFrom(from, to, tokenId, "");
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-safeTransferFrom}.
1506      */
1507     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1508         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1509         _safeTransfer(from, to, tokenId, _data);
1510     }
1511 
1512     /**
1513      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1514      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1515      *
1516      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1517      *
1518      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1519      * implement alternative mechanisms to perform token transfer, such as signature-based.
1520      *
1521      * Requirements:
1522      *
1523      * - `from` cannot be the zero address.
1524      * - `to` cannot be the zero address.
1525      * - `tokenId` token must exist and be owned by `from`.
1526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1531         _transfer(from, to, tokenId);
1532         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1533     }
1534 
1535     /**
1536      * @dev Returns whether `tokenId` exists.
1537      *
1538      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1539      *
1540      * Tokens start existing when they are minted (`_mint`),
1541      * and stop existing when they are burned (`_burn`).
1542      */
1543     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1544         return _tokenOwners.contains(tokenId);
1545     }
1546 
1547     /**
1548      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1549      *
1550      * Requirements:
1551      *
1552      * - `tokenId` must exist.
1553      */
1554     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1555         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1556         address owner = ERC721.ownerOf(tokenId);
1557         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1558     }
1559 
1560     /**
1561      * @dev Safely mints `tokenId` and transfers it to `to`.
1562      *
1563      * Requirements:
1564      d*
1565      * - `tokenId` must not exist.
1566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function _safeMint(address to, uint256 tokenId) internal virtual {
1571         _safeMint(to, tokenId, "");
1572     }
1573 
1574     /**
1575      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1576      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1577      */
1578     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1579         _mint(to, tokenId);
1580         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1581     }
1582 
1583     /**
1584      * @dev Mints `tokenId` and transfers it to `to`.
1585      *
1586      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1587      *
1588      * Requirements:
1589      *
1590      * - `tokenId` must not exist.
1591      * - `to` cannot be the zero address.
1592      *
1593      * Emits a {Transfer} event.
1594      */
1595     function _mint(address to, uint256 tokenId) internal virtual {
1596         require(to != address(0), "ERC721: mint to the zero address");
1597         require(!_exists(tokenId), "ERC721: token already minted");
1598 
1599         _beforeTokenTransfer(address(0), to, tokenId);
1600 
1601         _holderTokens[to].add(tokenId);
1602 
1603         _tokenOwners.set(tokenId, to);
1604 
1605         emit Transfer(address(0), to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev Destroys `tokenId`.
1610      * The approval is cleared when the token is burned.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function _burn(uint256 tokenId) internal virtual {
1619         address owner = ERC721.ownerOf(tokenId); // internal owner
1620 
1621         _beforeTokenTransfer(owner, address(0), tokenId);
1622 
1623         // Clear approvals
1624         _approve(address(0), tokenId);
1625 
1626         // Clear metadata (if any)
1627         if (bytes(_tokenURIs[tokenId]).length != 0) {
1628             delete _tokenURIs[tokenId];
1629         }
1630 
1631         _holderTokens[owner].remove(tokenId);
1632 
1633         _tokenOwners.remove(tokenId);
1634 
1635         emit Transfer(owner, address(0), tokenId);
1636     }
1637 
1638     /**
1639      * @dev Transfers `tokenId` from `from` to `to`.
1640      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1641      *
1642      * Requirements:
1643      *
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must be owned by `from`.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1650         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1651         require(to != address(0), "ERC721: transfer to the zero address");
1652 
1653         _beforeTokenTransfer(from, to, tokenId);
1654 
1655         // Clear approvals from the previous owner
1656         _approve(address(0), tokenId);
1657 
1658         _holderTokens[from].remove(tokenId);
1659         _holderTokens[to].add(tokenId);
1660 
1661         _tokenOwners.set(tokenId, to);
1662         emit Transfer(from, to, tokenId);
1663     }
1664 
1665     /**
1666      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must exist.
1671      */
1672     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1673         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1674         _tokenURIs[tokenId] = _tokenURI;
1675     }
1676 
1677     /**
1678      * @dev Internal function to set the base URI for all token IDs. It is
1679      * automatically added as a prefix to the value returned in {tokenURI},
1680      * or to the token ID if {tokenURI} is empty.
1681      */
1682     function _setBaseURI(string memory baseURI_) internal virtual {
1683         _baseURI = baseURI_;
1684     }
1685 
1686     /**
1687      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1688      * The call is not executed if the target address is not a contract.
1689      *
1690      * @param from address representing the previous owner of the given token ID
1691      * @param to target address that will receive the tokens
1692      * @param tokenId uint256 ID of the token to be transferred
1693      * @param _data bytes optional data to send along with the call
1694      * @return bool whether the call correctly returned the expected magic value
1695      */
1696     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1697         private returns (bool)
1698     {
1699         if (to.isContract()) {
1700             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1701                 return retval == IERC721Receiver(to).onERC721Received.selector;
1702             } catch (bytes memory reason) {
1703                 if (reason.length == 0) {
1704                     revert("ERC721: transfer to non ERC721Receiver implementer");
1705                 } else {
1706                     // solhint-disable-next-line no-inline-assembly
1707                     assembly {
1708                         revert(add(32, reason), mload(reason))
1709                     }
1710                 }
1711             }
1712         } else {
1713             return true;
1714         }
1715     }
1716 
1717     function _approve(address to, uint256 tokenId) private {
1718         _tokenApprovals[tokenId] = to;
1719         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1720     }
1721 
1722     /**
1723      * @dev Hook that is called before any token transfer. This includes minting
1724      * and burning.
1725      *
1726      * Calling conditions:
1727      *
1728      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1729      * transferred to `to`.
1730      * - When `from` is zero, `tokenId` will be minted for `to`.
1731      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1732      * - `from` cannot be the zero address.
1733      * - `to` cannot be the zero address.
1734      *
1735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1736      */
1737     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1738 }
1739 
1740 
1741 
1742 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1743 
1744 
1745 
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 /**
1750  * @dev Contract module which provides a basic access control mechanism, where
1751  * there is an account (an owner) that can be granted exclusive access to
1752  * specific functions.
1753  *
1754  * By default, the owner account will be the one that deploys the contract. This
1755  * can later be changed with {transferOwnership}.
1756  *
1757  * This module is used through inheritance. It will make available the modifier
1758  * `onlyOwner`, which can be applied to your functions to restrict their use to
1759  * the owner.
1760  */
1761 abstract contract Ownable is Context {
1762     address private _owner;
1763 
1764     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1765 
1766 
1767 
1768     /**
1769      * @dev Initializes the contract setting the deployer as the initial owner.
1770      */
1771     constructor () {
1772         address msgSender = _msgSender();
1773         _owner = msgSender;
1774         emit OwnershipTransferred(address(0), msgSender);
1775     }
1776 
1777     /**
1778      * @dev Returns the address of the current owner.
1779      */
1780     function owner() public view virtual returns (address) {
1781         return _owner;
1782     }
1783 
1784     /**
1785      * @dev Throws if called by any account other than the owner.
1786      */
1787     modifier onlyOwner() {
1788         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1789         _;
1790     }
1791 
1792     /**
1793      * @dev Leaves the contract without owner. It will not be possible to call
1794      * `onlyOwner` functions anymore. Can only be called by the current owner.
1795      *
1796      * NOTE: Renouncing ownership will leave the contract without an owner,
1797      * thereby removing any functionality that is only available to the owner.
1798      */
1799     function renounceOwnership() public virtual onlyOwner {
1800         emit OwnershipTransferred(_owner, address(0));
1801         _owner = address(0);
1802     }
1803 
1804     /**
1805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1806      * Can only be called by the current owner.
1807      */
1808     function transferOwnership(address newOwner) public virtual onlyOwner {
1809         require(newOwner != address(0), "Ownable: new owner is the zero address");
1810         emit OwnershipTransferred(_owner, newOwner);
1811         _owner = newOwner;
1812     }
1813 }
1814 
1815 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1816 
1817 
1818 
1819 
1820 pragma solidity ^0.8.0;
1821 
1822 // CAUTION
1823 // This version of SafeMath should only be used with Solidity 0.8 or later,
1824 // because it relies on the compiler's built in overflow checks.
1825 
1826 /**
1827  * @dev Wrappers over Solidity's arithmetic operations.
1828  *
1829  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1830  * now has built in overflow checking.
1831  */
1832 library SafeMath {
1833     /**
1834      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1835      *
1836      * _Available since v3.4._
1837      */
1838     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1839         unchecked {
1840             uint256 c = a + b;
1841             if (c < a) return (false, 0);
1842             return (true, c);
1843         }
1844     }
1845 
1846     /**
1847      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1848      *
1849      * _Available since v3.4._
1850      */
1851     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1852         unchecked {
1853             if (b > a) return (false, 0);
1854             return (true, a - b);
1855         }
1856     }
1857 
1858     /**
1859      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1860      *
1861      * _Available since v3.4._
1862      */
1863     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1864         unchecked {
1865             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1866             // benefit is lost if 'b' is also tested.
1867             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1868             if (a == 0) return (true, 0);
1869             uint256 c = a * b;
1870             if (c / a != b) return (false, 0);
1871             return (true, c);
1872         }
1873     }
1874 
1875     /**
1876      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1877      *
1878      * _Available since v3.4._
1879      */
1880     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1881         unchecked {
1882             if (b == 0) return (false, 0);
1883             return (true, a / b);
1884         }
1885     }
1886 
1887     /**
1888      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1889      *
1890      * _Available since v3.4._
1891      */
1892     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1893         unchecked {
1894             if (b == 0) return (false, 0);
1895             return (true, a % b);
1896         }
1897     }
1898 
1899     /**
1900      * @dev Returns the addition of two unsigned integers, reverting on
1901      * overflow.
1902      *
1903      * Counterpart to Solidity's `+` operator.
1904      *
1905      * Requirements:
1906      *
1907      * - Addition cannot overflow.
1908      */
1909     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1910         return a + b;
1911     }
1912 
1913     /**
1914      * @dev Returns the subtraction of two unsigned integers, reverting on
1915      * overflow (when the result is negative).
1916      *
1917      * Counterpart to Solidity's `-` operator.
1918      *
1919      * Requirements:
1920      *
1921      * - Subtraction cannot overflow.
1922      */
1923     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1924         return a - b;
1925     }
1926 
1927     /**
1928      * @dev Returns the multiplication of two unsigned integers, reverting on
1929      * overflow.
1930      *
1931      * Counterpart to Solidity's `*` operator.
1932      *
1933      * Requirements:
1934      *
1935      * - Multiplication cannot overflow.
1936      */
1937     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1938         return a * b;
1939     }
1940 
1941     /**
1942      * @dev Returns the integer division of two unsigned integers, reverting on
1943      * division by zero. The result is rounded towards zero.
1944      *
1945      * Counterpart to Solidity's `/` operator.
1946      *
1947      * Requirements:
1948      *
1949      * - The divisor cannot be zero.
1950      */
1951     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1952         return a / b;
1953     }
1954 
1955     /**
1956      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1957      * reverting when dividing by zero.
1958      *
1959      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1960      * opcode (which leaves remaining gas untouched) while Solidity uses an
1961      * invalid opcode to revert (consuming all remaining gas).
1962      *
1963      * Requirements:
1964      *
1965      * - The divisor cannot be zero.
1966      */
1967     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1968         return a % b;
1969     }
1970 
1971     /**
1972      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1973      * overflow (when the result is negative).
1974      *
1975      * CAUTION: This function is deprecated because it requires allocating memory for the error
1976      * message unnecessarily. For custom revert reasons use {trySub}.
1977      *
1978      * Counterpart to Solidity's `-` operator.
1979      *
1980      * Requirements:
1981      *
1982      * - Subtraction cannot overflow.
1983      */
1984     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1985         unchecked {
1986             require(b <= a, errorMessage);
1987             return a - b;
1988         }
1989     }
1990 
1991     /**
1992      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1993      * division by zero. The result is rounded towards zero.
1994      *
1995      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1996      * opcode (which leaves remaining gas untouched) while Solidity uses an
1997      * invalid opcode to revert (consuming all remaining gas).
1998      *
1999      * Counterpart to Solidity's `/` operator. Note: this function uses a
2000      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2001      * uses an invalid opcode to revert (consuming all remaining gas).
2002      *
2003      * Requirements:
2004      *
2005      * - The divisor cannot be zero.
2006      */
2007     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2008         unchecked {
2009             require(b > 0, errorMessage);
2010             return a / b;
2011         }
2012     }
2013 
2014     /**
2015      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2016      * reverting with custom message when dividing by zero.
2017      *
2018      * CAUTION: This function is deprecated because it requires allocating memory for the error
2019      * message unnecessarily. For custom revert reasons use {tryMod}.
2020      *
2021      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2022      * opcode (which leaves remaining gas untouched) while Solidity uses an
2023      * invalid opcode to revert (consuming all remaining gas).
2024      *
2025      * Requirements:
2026      *
2027      * - The divisor cannot be zero.
2028      */
2029     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2030         unchecked {
2031             require(b > 0, errorMessage);
2032             return a % b;
2033         }
2034     }
2035 }
2036 
2037 
2038 pragma solidity ^0.8.0;
2039 
2040 interface IAMABASTARD {
2041     function balanceOf(address _address) external view returns (uint256);
2042 }
2043 
2044 contract Orbits is ERC721, Ownable {
2045 
2046     using SafeMath for uint256;
2047     using Strings for uint256;
2048 
2049     uint public constant MAX_TOKENS = 1024;
2050     uint public constant MAX_SALES = 815;
2051     uint public constant MAX_FREE_MINT = 200;
2052 
2053     uint public SALE_COUNT;
2054     uint public FREE_MINT_COUNT;
2055 
2056     bool public hasSaleStarted = false;
2057 
2058     mapping (uint256 => uint256) public creationDates;
2059     mapping (uint256 => address) public creators;
2060 
2061     mapping(uint => string) public GENERATOR_SCRIPT_CODE;
2062 
2063     string public GENERATOR_ADDRESS;
2064 
2065     string public constant ORBITS_LICENSE = "YOUR orbit, YOUR CALL. If you own an NFT from this collection, you are fully permitted to do whatever you want with it (including both non-commercial/commercial uses). You can even do paid fortune telling with it lol. Also, creative derivative works are highly encouraged.";
2066 
2067     uint public constant PRICE = 77700000000000000; // 0.0777 ETH
2068     uint public constant SOS_PRICE = 42069420694206942069420690; // 42069420.694206942069420690 SOS
2069 
2070     mapping (address => bool) public didWalletFreeClaim;
2071 
2072     address private BGANPUNKSV2ADDRESS = 0x31385d3520bCED94f77AaE104b406994D8F2168C;
2073 
2074     address private BERK = 0xc5E08104c19DAfd00Fe40737490Da9552Db5bfE5;
2075     address private MEMORYCOLLECTOR = 0xEbbCF9D8576376765dba9d883145cEeeE243ad44;
2076     address private BASTARDDAO = 0x15D0F64FFCf91c39810529F805Cc3595Dc3EF83f;
2077 
2078     IERC20 SOSTOKEN = IERC20(0x3b484b82567a09e2588A13D54D032153f0c0aEe0);
2079 
2080     constructor() ERC721("ORBITSNFT","ORBITS")  {
2081         
2082         GENERATOR_SCRIPT_CODE[0] = "https://berk.mypinata.cloud/ipfs/QmTCfmKEeLsLSVAnmhUa1H96A5brNr1RQx8QAfiCbAMRMs"; // p5.min.js (IPFS)
2083         GENERATOR_SCRIPT_CODE[3] = "https://arweave.net/0LIfIHnzQMW5sgyxDV2BSioNuud-KPkd7dHpcD8GskY"; // p5.min.js (ARWEAVE)
2084         GENERATOR_SCRIPT_CODE[1] = "https://berk.mypinata.cloud/ipfs/QmYeLy8QMqq4Zp4A2zBBtgGT23574G8cDCtpu51TL7XCMB"; // slightly edited chroma.min.js (IPFS)
2085         GENERATOR_SCRIPT_CODE[4] = "https://arweave.net/LC2IBFq_Vol-8t-ZHRm9slgU8Wag-EXQdg2-vF_qllI"; // slightly edited chroma.min.js (ARWEAVE)
2086         GENERATOR_SCRIPT_CODE[2] = "https://berk.mypinata.cloud/ipfs/QmYxCmfpfu8zqvr1CKcG29pAGGLutTi4Nxju4RaX7Rnc3f"; // ørß1t$ sketch code (IPFS)
2087         GENERATOR_SCRIPT_CODE[5] = "https://arweave.net/qA_hQ7Q8976FJb7KEg1IZO8GyVJWP1V0xcRJrJs2dWw"; // ørß1t$ sketch code (ARWEAVE)
2088 
2089         setBaseURI("https://orbitsnft.art/api/token/");
2090         setGeneratorAddress("https://orbitsnft.art/generator/");
2091 
2092         _safeMint(BERK, 0); // I DESERVE THE #0
2093         creationDates[0] = block.number;
2094         creators[0] = BERK;
2095 
2096         _safeMint(MEMORYCOLLECTOR, 1); // TO MEMORYCOLLECTOR FOR HELPING
2097         creationDates[1] = block.number;
2098         creators[1] = MEMORYCOLLECTOR;
2099 
2100         _safeMint(BERK, 2); // I DESERVE THE #2
2101         creationDates[2] = block.number;
2102         creators[2] = BERK;
2103 
2104         _safeMint(MEMORYCOLLECTOR, 3); // TO MEMORYCOLLECTOR FOR HELPING
2105         creationDates[3] = block.number;
2106         creators[3] = MEMORYCOLLECTOR;
2107 
2108         _safeMint(BASTARDDAO, 4); // TO BASTARDDAO, BECAUSE WE LOVE THE BASTARDS
2109         creationDates[4] = block.number;
2110         creators[4] = BASTARDDAO;
2111 
2112         _safeMint(BASTARDDAO, 5); // TO BASTARDDAO, BECAUSE WE LOVE THE BASTARDS
2113         creationDates[5] = block.number;
2114         creators[5] = BASTARDDAO;
2115 
2116         _safeMint(BASTARDDAO, 6); // TO BASTARDDAO, BECAUSE WE LOVE THE BASTARDS
2117         creationDates[6] = block.number;
2118         creators[6] = BASTARDDAO;
2119 
2120         _safeMint(BASTARDDAO, 7); // TO BASTARDDAO, BECAUSE WE LOVE THE BASTARDS
2121         creationDates[7] = block.number;
2122         creators[7] = BASTARDDAO;
2123 
2124         _safeMint(BASTARDDAO, 8); // TO BASTARDDAO, BECAUSE WE LOVE THE BASTARDS
2125         creationDates[8] = block.number;
2126         creators[8] = BASTARDDAO;
2127 
2128     }
2129     
2130     function tokenLicense(uint _id) public view returns(string memory) {
2131         require(_id < totalSupply(), "wrong id");
2132         return ORBITS_LICENSE;
2133     }
2134 
2135     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2136         uint256 tokenCount = balanceOf(_owner);
2137         if (tokenCount == 0) {
2138             // Return an empty array
2139             return new uint256[](0);
2140         } else {
2141             uint256[] memory result = new uint256[](tokenCount);
2142             uint256 index;
2143             for (index = 0; index < tokenCount; index++) {
2144                 result[index] = tokenOfOwnerByIndex(_owner, index);
2145             }
2146             return result;
2147         }
2148     }
2149 
2150     function tokenHash(uint256 tokenId) public view returns(bytes32){
2151         require(_exists(tokenId), "DOES NOT EXIST");
2152         return bytes32(keccak256(abi.encodePacked(address(this), creationDates[tokenId], creators[tokenId], tokenId)));
2153     }
2154     
2155     function generatorAddress(uint256 tokenId) public view returns (string memory) {
2156         require(_exists(tokenId), "DOES NOT EXIST");
2157         return string(abi.encodePacked(GENERATOR_ADDRESS, tokenId.toString()));
2158     }
2159 
2160     function freeOrbitForBastard() public {
2161         require(hasSaleStarted == true, "Minting isn't open");
2162         require(FREE_MINT_COUNT < MAX_FREE_MINT, "No more free mints dear bastard :(");
2163         uint mintIndex = totalSupply();
2164         require(mintIndex < MAX_TOKENS, "No more orbit left to mint");
2165         require(IAMABASTARD(BGANPUNKSV2ADDRESS).balanceOf(msg.sender) > 0, "Wallet has no bastards!");
2166         require(didWalletFreeClaim[msg.sender] == false, "Wallet already used for free mint");
2167         didWalletFreeClaim[msg.sender] = true;
2168         _safeMint(msg.sender, mintIndex);
2169         creationDates[mintIndex] = block.number;
2170         creators[mintIndex] = msg.sender;
2171         FREE_MINT_COUNT++;
2172     }
2173 
2174     function mintOrbit() public payable {
2175         require(hasSaleStarted == true, "Minting isn't open");
2176         require(SALE_COUNT < MAX_SALES, "Sale has already ended");
2177         uint mintIndex = totalSupply();
2178         require(mintIndex < MAX_TOKENS, "No more orbit left to mint");
2179         require(msg.value >= PRICE, "Ether value sent is below the price");
2180         _safeMint(msg.sender, mintIndex);
2181         creationDates[mintIndex] = block.number;
2182         creators[mintIndex] = msg.sender;
2183         SALE_COUNT++;
2184     }
2185 
2186     function mintOrbitWithSOS() public payable {
2187         require(hasSaleStarted == true, "Minting isn't open");
2188         require(SALE_COUNT < MAX_SALES, "Sale has already ended");
2189         uint mintIndex = totalSupply();
2190         require(mintIndex < MAX_TOKENS, "No more orbit left to mint");
2191         require(SOSTOKEN.allowance(msg.sender, address(this)) >= SOS_PRICE,"Insuficient Allowance");
2192         require(SOSTOKEN.transferFrom(msg.sender,address(this),SOS_PRICE),"transfer Failed");
2193         _safeMint(msg.sender, mintIndex);
2194         creationDates[mintIndex] = block.number;
2195         creators[mintIndex] = msg.sender;
2196         SALE_COUNT++;
2197     }
2198     
2199     // ONLYOWNER FUNCTIONS
2200 
2201     function modifyScript(uint _index, string memory _code) public onlyOwner {
2202         GENERATOR_SCRIPT_CODE[_index] = _code;
2203     }
2204         
2205     function setGeneratorAddress(string memory _address) public onlyOwner {
2206         GENERATOR_ADDRESS = _address;
2207     }
2208 
2209     function setBaseURI(string memory baseURI) public onlyOwner {
2210         _setBaseURI(baseURI);
2211     }
2212     
2213     function startMint() public onlyOwner {
2214         hasSaleStarted = true;
2215     }
2216     
2217     function pauseMint() public onlyOwner {
2218         hasSaleStarted = false;
2219     }
2220 
2221     function withdrawAll() public payable onlyOwner {
2222         require(payable(msg.sender).send(address(this).balance));
2223         require(SOSTOKEN.transfer(msg.sender, SOSTOKEN.balanceOf(address(this))));
2224     }
2225     
2226     
2227 }