1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 //  _______  ______    __   __  _______  _______  _______    _______  _______  _______  __   __  ___
6 // |       ||    _ |  |  | |  ||       ||       ||       |  |       ||       ||       ||  | |  ||   |
7 // |       ||   | ||  |  |_|  ||    _  ||_     _||   _   |  |    _  ||   _   ||       ||  |_|  ||   |
8 // |       ||   |_||_ |       ||   |_| |  |   |  |  | |  |  |   |_| ||  | |  ||       ||       ||   |
9 // |      _||    __  ||_     _||    ___|  |   |  |  |_|  |  |    ___||  |_|  ||      _||       ||   |
10 // |     |_ |   |  | |  |   |  |   |      |   |  |       |  |   |    |       ||     |_ |   _   ||   |
11 // |_______||___|  |_|  |___|  |___|      |___|  |_______|  |___|    |_______||_______||__| |__||___|
12 //
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 }
43 
44 /**
45  * @dev Collection of functions related to the address type
46  */
47 library Address {
48     /**
49      * @dev Returns true if `account` is a contract.
50      *
51      * [IMPORTANT]
52      * ====
53      * It is unsafe to assume that an address for which this function returns
54      * false is an externally-owned account (EOA) and not a contract.
55      *
56      * Among others, `isContract` will return false for the following
57      * types of addresses:
58      *
59      *  - an externally-owned account
60      *  - a contract in construction
61      *  - an address where a contract will be created
62      *  - an address where a contract lived, but was destroyed
63      * ====
64      */
65     function isContract(address account) internal view returns (bool) {
66         // This method relies on extcodesize, which returns 0 for contracts in
67         // construction, since the code is only stored at the end of the
68         // constructor execution.
69 
70         uint256 size;
71         // solhint-disable-next-line no-inline-assembly
72         assembly {
73             size := extcodesize(account)
74         }
75         return size > 0;
76     }
77 
78     /**
79      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
80      * `recipient`, forwarding all available gas and reverting on errors.
81      *
82      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
83      * of certain opcodes, possibly making contracts go over the 2300 gas limit
84      * imposed by `transfer`, making them unable to receive funds via
85      * `transfer`. {sendValue} removes this limitation.
86      *
87      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
88      *
89      * IMPORTANT: because control is transferred to `recipient`, care must be
90      * taken to not create reentrancy vulnerabilities. Consider using
91      * {ReentrancyGuard} or the
92      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
93      */
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{value: amount}("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     /**
103      * @dev Performs a Solidity function call using a low level `call`. A
104      * plain`call` is an unsafe replacement for a function call: use this
105      * function instead.
106      *
107      * If `target` reverts with a revert reason, it is bubbled up by this
108      * function (like regular Solidity function calls).
109      *
110      * Returns the raw returned data. To convert to the expected return value,
111      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
112      *
113      * Requirements:
114      *
115      * - `target` must be a contract.
116      * - calling `target` with `data` must not revert.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
121         return functionCall(target, data, "Address: low-level call failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
126      * `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but also transferring `value` wei to `target`.
141      *
142      * Requirements:
143      *
144      * - the calling contract must have an ETH balance of at least `value`.
145      * - the called Solidity function must be `payable`.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
159      * with `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         require(isContract(target), "Address: call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = target.call{value: value}(data);
174         return _verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but performing a static call.
180      *
181      * _Available since v3.3._
182      */
183     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
184         return functionStaticCall(target, data, "Address: low-level static call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
189      * but performing a static call.
190      *
191      * _Available since v3.3._
192      */
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return _verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a delegate call.
208      *
209      * _Available since v3.3._
210      */
211     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a delegate call.
218      *
219      * _Available since v3.3._
220      */
221     function functionDelegateCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(isContract(target), "Address: delegate call to non-contract");
227 
228         // solhint-disable-next-line avoid-low-level-calls
229         (bool success, bytes memory returndata) = target.delegatecall(data);
230         return _verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     function _verifyCallResult(
234         bool success,
235         bytes memory returndata,
236         string memory errorMessage
237     ) private pure returns (bytes memory) {
238         if (success) {
239             return returndata;
240         } else {
241             // Look for revert reason and bubble it up if present
242             if (returndata.length > 0) {
243                 // The easiest way to bubble the revert reason is using memory via assembly
244 
245                 // solhint-disable-next-line no-inline-assembly
246                 assembly {
247                     let returndata_size := mload(returndata)
248                     revert(add(32, returndata), returndata_size)
249                 }
250             } else {
251                 revert(errorMessage);
252             }
253         }
254     }
255 }
256 
257 /**
258  * @dev Interface of the ERC165 standard, as defined in the
259  * https://eips.ethereum.org/EIPS/eip-165[EIP].
260  *
261  * Implementers can declare support of contract interfaces, which can then be
262  * queried by others ({ERC165Checker}).
263  *
264  * For an implementation, see {ERC165}.
265  */
266 interface IERC165 {
267     /**
268      * @dev Returns true if this contract implements the interface defined by
269      * `interfaceId`. See the corresponding
270      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
271      * to learn more about how these ids are created.
272      *
273      * This function call must use less than 30 000 gas.
274      */
275     function supportsInterface(bytes4 interfaceId) external view returns (bool);
276 }
277 
278 /**
279  * @dev Implementation of the {IERC165} interface.
280  *
281  * Contracts may inherit from this and call {_registerInterface} to declare
282  * their support of an interface.
283  */
284 contract ERC165 is IERC165 {
285     /*
286      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
287      */
288     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
289 
290     /**
291      * @dev Mapping of interface ids to whether or not it's supported.
292      */
293     mapping(bytes4 => bool) private _supportedInterfaces;
294 
295     constructor() {
296         // Derived contracts need only register support for their own interfaces,
297         // we register support for ERC165 itself here
298         _registerInterface(_INTERFACE_ID_ERC165);
299     }
300 
301     /**
302      * @dev See {IERC165-supportsInterface}.
303      *
304      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
305      */
306     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
307         return _supportedInterfaces[interfaceId];
308     }
309 
310     /**
311      * @dev Registers the contract as an implementer of the interface defined by
312      * `interfaceId`. Support of the actual ERC165 interface is automatic and
313      * registering its interface id is not required.
314      *
315      * See {IERC165-supportsInterface}.
316      *
317      * Requirements:
318      *
319      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
320      */
321     function _registerInterface(bytes4 interfaceId) internal virtual {
322         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
323         _supportedInterfaces[interfaceId] = true;
324     }
325 }
326 
327 /**
328  * @dev Interface of the ERC20 standard as defined in the EIP.
329  */
330 interface IERC20 {
331     function totalSupply() external view returns (uint256);
332 
333     function balanceOf(address account) external view returns (uint256);
334 
335     function transfer(address recipient, uint256 amount) external returns (bool);
336 
337     function allowance(address owner, address spender) external view returns (uint256);
338 
339     function approve(address spender, uint256 amount) external returns (bool);
340 
341     function transferFrom(
342         address sender,
343         address recipient,
344         uint256 amount
345     ) external returns (bool);
346 
347     function burn(uint256 burnQuantity) external returns (bool);
348 
349     event Transfer(address indexed from, address indexed to, uint256 value);
350     event Approval(address indexed owner, address indexed spender, uint256 value);
351 }
352 
353 /**
354  * @dev Required interface of an ERC721 compliant contract.
355  */
356 interface IERC721 is IERC165 {
357     /**
358      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
361 
362     /**
363      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
364      */
365     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
369      */
370     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
371 
372     /**
373      * @dev Returns the number of tokens in ``owner``'s account.
374      */
375     function balanceOf(address owner) external view returns (uint256 balance);
376 
377     /**
378      * @dev Returns the owner of the `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386     /**
387      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
388      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must exist and be owned by `from`.
395      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
396      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
397      *
398      * Emits a {Transfer} event.
399      */
400     function safeTransferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Transfers `tokenId` token from `from` to `to`.
408      *
409      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must be owned by `from`.
416      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
417      *
418      * Emits a {Transfer} event.
419      */
420     function transferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) external;
425 
426     /**
427      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
428      * The approval is cleared when the token is transferred.
429      *
430      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
431      *
432      * Requirements:
433      *
434      * - The caller must own the token or be an approved operator.
435      * - `tokenId` must exist.
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address to, uint256 tokenId) external;
440 
441     /**
442      * @dev Returns the account approved for `tokenId` token.
443      *
444      * Requirements:
445      *
446      * - `tokenId` must exist.
447      */
448     function getApproved(uint256 tokenId) external view returns (address operator);
449 
450     /**
451      * @dev Approve or remove `operator` as an operator for the caller.
452      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
453      *
454      * Requirements:
455      *
456      * - The `operator` cannot be the caller.
457      *
458      * Emits an {ApprovalForAll} event.
459      */
460     function setApprovalForAll(address operator, bool _approved) external;
461 
462     /**
463      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
464      *
465      * See {setApprovalForAll}
466      */
467     function isApprovedForAll(address owner, address operator) external view returns (bool);
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must exist and be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId,
486         bytes calldata data
487     ) external;
488 }
489 
490 /**
491  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
492  * @dev See https://eips.ethereum.org/EIPS/eip-721
493  */
494 interface IERC721Enumerable is IERC721 {
495     /**
496      * @dev Returns the total amount of tokens stored by the contract.
497      */
498     function totalSupply() external view returns (uint256);
499 
500     /**
501      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
502      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
503      */
504     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
505 
506     /**
507      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
508      * Use along with {totalSupply} to enumerate all tokens.
509      */
510     function tokenByIndex(uint256 index) external view returns (uint256);
511 }
512 
513 /**
514  * @dev Library for managing an enumerable variant of Solidity's
515  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
516  * type.
517  *
518  * Maps have the following properties:
519  *
520  * - Entries are added, removed, and checked for existence in constant time
521  * (O(1)).
522  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
523  *
524  * ```
525  * contract Example {
526  *     // Add the library methods
527  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
528  *
529  *     // Declare a set state variable
530  *     EnumerableMap.UintToAddressMap private myMap;
531  * }
532  * ```
533  *
534  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
535  * supported.
536  */
537 library EnumerableMap {
538     // To implement this library for multiple types with as little code
539     // repetition as possible, we write it in terms of a generic Map type with
540     // bytes32 keys and values.
541     // The Map implementation uses private functions, and user-facing
542     // implementations (such as Uint256ToAddressMap) are just wrappers around
543     // the underlying Map.
544     // This means that we can only create new EnumerableMaps for types that fit
545     // in bytes32.
546 
547     struct MapEntry {
548         bytes32 _key;
549         bytes32 _value;
550     }
551 
552     struct Map {
553         // Storage of map keys and values
554         MapEntry[] _entries;
555         // Position of the entry defined by a key in the `entries` array, plus 1
556         // because index 0 means a key is not in the map.
557         mapping(bytes32 => uint256) _indexes;
558     }
559 
560     /**
561      * @dev Adds a key-value pair to a map, or updates the value for an existing
562      * key. O(1).
563      *
564      * Returns true if the key was added to the map, that is if it was not
565      * already present.
566      */
567     function _set(
568         Map storage map,
569         bytes32 key,
570         bytes32 value
571     ) private returns (bool) {
572         // We read and store the key's index to prevent multiple reads from the same storage slot
573         uint256 keyIndex = map._indexes[key];
574 
575         // Equivalent to !contains(map, key)
576         if (keyIndex == 0) {
577             map._entries.push(MapEntry({_key: key, _value: value}));
578             // The entry is stored at length-1, but we add 1 to all indexes
579             // and use 0 as a sentinel value
580             map._indexes[key] = map._entries.length;
581             return true;
582         } else {
583             map._entries[keyIndex - 1]._value = value;
584             return false;
585         }
586     }
587 
588     /**
589      * @dev Removes a key-value pair from a map. O(1).
590      *
591      * Returns true if the key was removed from the map, that is if it was present.
592      */
593     function _remove(Map storage map, bytes32 key) private returns (bool) {
594         // We read and store the key's index to prevent multiple reads from the same storage slot
595         uint256 keyIndex = map._indexes[key];
596 
597         // Equivalent to contains(map, key)
598         if (keyIndex != 0) {
599             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
600             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
601             // This modifies the order of the array, as noted in {at}.
602 
603             uint256 toDeleteIndex = keyIndex - 1;
604             uint256 lastIndex = map._entries.length - 1;
605 
606             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
607             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
608 
609             MapEntry storage lastEntry = map._entries[lastIndex];
610 
611             // Move the last entry to the index where the entry to delete is
612             map._entries[toDeleteIndex] = lastEntry;
613             // Update the index for the moved entry
614             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
615 
616             // Delete the slot where the moved entry was stored
617             map._entries.pop();
618 
619             // Delete the index for the deleted slot
620             delete map._indexes[key];
621 
622             return true;
623         } else {
624             return false;
625         }
626     }
627 
628     /**
629      * @dev Returns true if the key is in the map. O(1).
630      */
631     function _contains(Map storage map, bytes32 key) private view returns (bool) {
632         return map._indexes[key] != 0;
633     }
634 
635     /**
636      * @dev Returns the number of key-value pairs in the map. O(1).
637      */
638     function _length(Map storage map) private view returns (uint256) {
639         return map._entries.length;
640     }
641 
642     /**
643      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
644      *
645      * Note that there are no guarantees on the ordering of entries inside the
646      * array, and it may change when more entries are added or removed.
647      *
648      * Requirements:
649      *
650      * - `index` must be strictly less than {length}.
651      */
652     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
653         require(map._entries.length > index, "EnumerableMap: index out of bounds");
654 
655         MapEntry storage entry = map._entries[index];
656         return (entry._key, entry._value);
657     }
658 
659     /**
660      * @dev Returns the value associated with `key`.  O(1).
661      *
662      * Requirements:
663      *
664      * - `key` must be in the map.
665      */
666     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
667         return _get(map, key, "EnumerableMap: nonexistent key");
668     }
669 
670     /**
671      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
672      */
673     function _get(
674         Map storage map,
675         bytes32 key,
676         string memory errorMessage
677     ) private view returns (bytes32) {
678         uint256 keyIndex = map._indexes[key];
679         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
680         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
681     }
682 
683     // UintToAddressMap
684 
685     struct UintToAddressMap {
686         Map _inner;
687     }
688 
689     /**
690      * @dev Adds a key-value pair to a map, or updates the value for an existing
691      * key. O(1).
692      *
693      * Returns true if the key was added to the map, that is if it was not
694      * already present.
695      */
696     function set(
697         UintToAddressMap storage map,
698         uint256 key,
699         address value
700     ) internal returns (bool) {
701         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
702     }
703 
704     /**
705      * @dev Removes a value from a set. O(1).
706      *
707      * Returns true if the key was removed from the map, that is if it was present.
708      */
709     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
710         return _remove(map._inner, bytes32(key));
711     }
712 
713     /**
714      * @dev Returns true if the key is in the map. O(1).
715      */
716     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
717         return _contains(map._inner, bytes32(key));
718     }
719 
720     /**
721      * @dev Returns the number of elements in the map. O(1).
722      */
723     function length(UintToAddressMap storage map) internal view returns (uint256) {
724         return _length(map._inner);
725     }
726 
727     /**
728      * @dev Returns the element stored at position `index` in the set. O(1).
729      * Note that there are no guarantees on the ordering of values inside the
730      * array, and it may change when more values are added or removed.
731      *
732      * Requirements:
733      *
734      * - `index` must be strictly less than {length}.
735      */
736     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
737         (bytes32 key, bytes32 value) = _at(map._inner, index);
738         return (uint256(key), address(uint160(uint256(value))));
739     }
740 
741     /**
742      * @dev Returns the value associated with `key`.  O(1).
743      *
744      * Requirements:
745      *
746      * - `key` must be in the map.
747      */
748     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
749         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
750     }
751 
752     /**
753      * @dev Same as {get}, with a custom error message when `key` is not in the map.
754      */
755     function get(
756         UintToAddressMap storage map,
757         uint256 key,
758         string memory errorMessage
759     ) internal view returns (address) {
760         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
761     }
762 }
763 
764 /**
765  * @dev Library for managing
766  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
767  * types.
768  *
769  * Sets have the following properties:
770  *
771  * - Elements are added, removed, and checked for existence in constant time
772  * (O(1)).
773  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
774  *
775  * ```
776  * contract Example {
777  *     // Add the library methods
778  *     using EnumerableSet for EnumerableSet.AddressSet;
779  *
780  *     // Declare a set state variable
781  *     EnumerableSet.AddressSet private mySet;
782  * }
783  * ```
784  *
785  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
786  * (`UintSet`) are supported.
787  */
788 library EnumerableSet {
789     // To implement this library for multiple types with as little code
790     // repetition as possible, we write it in terms of a generic Set type with
791     // bytes32 values.
792     // The Set implementation uses private functions, and user-facing
793     // implementations (such as AddressSet) are just wrappers around the
794     // underlying Set.
795     // This means that we can only create new EnumerableSets for types that fit
796     // in bytes32.
797 
798     struct Set {
799         // Storage of set values
800         bytes32[] _values;
801         // Position of the value in the `values` array, plus 1 because index 0
802         // means a value is not in the set.
803         mapping(bytes32 => uint256) _indexes;
804     }
805 
806     /**
807      * @dev Add a value to a set. O(1).
808      *
809      * Returns true if the value was added to the set, that is if it was not
810      * already present.
811      */
812     function _add(Set storage set, bytes32 value) private returns (bool) {
813         if (!_contains(set, value)) {
814             set._values.push(value);
815             // The value is stored at length-1, but we add 1 to all indexes
816             // and use 0 as a sentinel value
817             set._indexes[value] = set._values.length;
818             return true;
819         } else {
820             return false;
821         }
822     }
823 
824     /**
825      * @dev Removes a value from a set. O(1).
826      *
827      * Returns true if the value was removed from the set, that is if it was
828      * present.
829      */
830     function _remove(Set storage set, bytes32 value) private returns (bool) {
831         // We read and store the value's index to prevent multiple reads from the same storage slot
832         uint256 valueIndex = set._indexes[value];
833 
834         // Equivalent to contains(set, value)
835         if (valueIndex != 0) {
836             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
837             // the array, and then remove the last element (sometimes called as 'swap and pop').
838             // This modifies the order of the array, as noted in {at}.
839 
840             uint256 toDeleteIndex = valueIndex - 1;
841             uint256 lastIndex = set._values.length - 1;
842 
843             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
844             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
845 
846             bytes32 lastvalue = set._values[lastIndex];
847 
848             // Move the last value to the index where the value to delete is
849             set._values[toDeleteIndex] = lastvalue;
850             // Update the index for the moved value
851             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
852 
853             // Delete the slot where the moved value was stored
854             set._values.pop();
855 
856             // Delete the index for the deleted slot
857             delete set._indexes[value];
858 
859             return true;
860         } else {
861             return false;
862         }
863     }
864 
865     /**
866      * @dev Returns true if the value is in the set. O(1).
867      */
868     function _contains(Set storage set, bytes32 value) private view returns (bool) {
869         return set._indexes[value] != 0;
870     }
871 
872     /**
873      * @dev Returns the number of values on the set. O(1).
874      */
875     function _length(Set storage set) private view returns (uint256) {
876         return set._values.length;
877     }
878 
879     /**
880      * @dev Returns the value stored at position `index` in the set. O(1).
881      *
882      * Note that there are no guarantees on the ordering of values inside the
883      * array, and it may change when more values are added or removed.
884      *
885      * Requirements:
886      *
887      * - `index` must be strictly less than {length}.
888      */
889     function _at(Set storage set, uint256 index) private view returns (bytes32) {
890         require(set._values.length > index, "EnumerableSet: index out of bounds");
891         return set._values[index];
892     }
893 
894     // AddressSet
895 
896     struct AddressSet {
897         Set _inner;
898     }
899 
900     /**
901      * @dev Add a value to a set. O(1).
902      *
903      * Returns true if the value was added to the set, that is if it was not
904      * already present.
905      */
906     function add(AddressSet storage set, address value) internal returns (bool) {
907         return _add(set._inner, bytes32(uint256(uint160(value))));
908     }
909 
910     /**
911      * @dev Removes a value from a set. O(1).
912      *
913      * Returns true if the value was removed from the set, that is if it was
914      * present.
915      */
916     function remove(AddressSet storage set, address value) internal returns (bool) {
917         return _remove(set._inner, bytes32(uint256(uint160(value))));
918     }
919 
920     /**
921      * @dev Returns true if the value is in the set. O(1).
922      */
923     function contains(AddressSet storage set, address value) internal view returns (bool) {
924         return _contains(set._inner, bytes32(uint256(uint160(value))));
925     }
926 
927     /**
928      * @dev Returns the number of values in the set. O(1).
929      */
930     function length(AddressSet storage set) internal view returns (uint256) {
931         return _length(set._inner);
932     }
933 
934     /**
935      * @dev Returns the value stored at position `index` in the set. O(1).
936      *
937      * Note that there are no guarantees on the ordering of values inside the
938      * array, and it may change when more values are added or removed.
939      *
940      * Requirements:
941      *
942      * - `index` must be strictly less than {length}.
943      */
944     function at(AddressSet storage set, uint256 index) internal view returns (address) {
945         return address(uint160(uint256(_at(set._inner, index))));
946     }
947 
948     // UintSet
949 
950     struct UintSet {
951         Set _inner;
952     }
953 
954     /**
955      * @dev Add a value to a set. O(1).
956      *
957      * Returns true if the value was added to the set, that is if it was not
958      * already present.
959      */
960     function add(UintSet storage set, uint256 value) internal returns (bool) {
961         return _add(set._inner, bytes32(value));
962     }
963 
964     /**
965      * @dev Removes a value from a set. O(1).
966      *
967      * Returns true if the value was removed from the set, that is if it was
968      * present.
969      */
970     function remove(UintSet storage set, uint256 value) internal returns (bool) {
971         return _remove(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
978         return _contains(set._inner, bytes32(value));
979     }
980 
981     /**
982      * @dev Returns the number of values on the set. O(1).
983      */
984     function length(UintSet storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988     /**
989      * @dev Returns the value stored at position `index` in the set. O(1).
990      *
991      * Note that there are no guarantees on the ordering of values inside the
992      * array, and it may change when more values are added or removed.
993      *
994      * Requirements:
995      *
996      * - `index` must be strictly less than {length}.
997      */
998     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
999         return uint256(_at(set._inner, index));
1000     }
1001 }
1002 
1003 contract Ownable {
1004     address private _owner;
1005     address public newOwner;
1006 
1007     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1008 
1009     /**
1010      * @dev Initializes the contract setting the deployer as the initial owner.
1011      */
1012     constructor() {
1013         _owner = msg.sender;
1014         emit OwnershipTransferred(address(0), msg.sender);
1015     }
1016 
1017     /**
1018      * @dev Returns the address of the current owner.
1019      */
1020     function owner() public view returns (address) {
1021         return _owner;
1022     }
1023 
1024     /**
1025      * @dev Throws if called by any account other than the owner.
1026      */
1027     modifier onlyDeployer() {
1028         require(_owner == msg.sender, "Ownable: caller is not the owner");
1029         _;
1030     }
1031 
1032     /**
1033      * @dev Leaves the contract without owner. It will not be possible to call
1034      * `onlyDeployer` functions anymore. Can only be called by the current deployer.
1035      *
1036      * NOTE: Renouncing ownership will leave the contract without an owner,
1037      * thereby removing any functionality that is only available to the owner.
1038      */
1039     function renounceOwnership() external virtual onlyDeployer {
1040         emit OwnershipTransferred(_owner, address(0));
1041         _owner = address(0);
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1046      * Can only be called by the current owner.
1047      */
1048     function transferOwnership(address _newOwner) external virtual onlyDeployer {
1049         require(_newOwner != newOwner);
1050         require(_newOwner != _owner);
1051         newOwner = _newOwner;
1052     }
1053 
1054     function acceptOwnership() external {
1055         require(msg.sender == newOwner);
1056         emit OwnershipTransferred(_owner, newOwner);
1057         _owner = newOwner;
1058         newOwner = address(0);
1059     }
1060 }
1061 
1062 /**
1063  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1064  * @dev See https://eips.ethereum.org/EIPS/eip-721
1065  */
1066 interface IERC721Metadata is IERC721 {
1067     /**
1068      * @dev Returns the token collection name.
1069      */
1070     function name() external view returns (string memory);
1071 
1072     /**
1073      * @dev Returns the token collection symbol.
1074      */
1075     function symbol() external view returns (string memory);
1076 }
1077 
1078 /**
1079  * @title ERC721 token receiver interface
1080  * @dev Interface for any contract that wants to support safeTransfers
1081  * from ERC721 asset contracts.
1082  */
1083 interface IERC721Receiver {
1084     /**
1085      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1086      * by `operator` from `from`, this function is called.
1087      *
1088      * It must return its Solidity selector to confirm the token transfer.
1089      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1090      *
1091      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1092      */
1093     function onERC721Received(
1094         address operator,
1095         address from,
1096         uint256 tokenId,
1097         bytes calldata data
1098     ) external returns (bytes4);
1099 }
1100 
1101 /**
1102  * @dev Contract module that helps prevent reentrant calls to a function.
1103  *
1104  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1105  * available, which can be applied to functions to make sure there are no nested
1106  * (reentrant) calls to them.
1107  *
1108  * Note that because there is a single `nonReentrant` guard, functions marked as
1109  * `nonReentrant` may not call one another. This can be worked around by making
1110  * those functions `private`, and then adding `external` `nonReentrant` entry
1111  * points to them.
1112  *
1113  * TIP: If you would like to learn more about reentrancy and alternative ways
1114  * to protect against it, check out our blog post
1115  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1116  */
1117 abstract contract ReentrancyGuard {
1118     // Booleans are more expensive than uint256 or any type that takes up a full
1119     // word because each write operation emits an extra SLOAD to first read the
1120     // slot's contents, replace the bits taken up by the boolean, and then write
1121     // back. This is the compiler's defense against contract upgrades and
1122     // pointer aliasing, and it cannot be disabled.
1123 
1124     // The values being non-zero value makes deployment a bit more expensive,
1125     // but in exchange the refund on every call to nonReentrant will be lower in
1126     // amount. Since refunds are capped to a percentage of the total
1127     // transaction's gas, it is best to keep them low in cases like this one, to
1128     // increase the likelihood of the full refund coming into effect.
1129     uint256 private constant _NOT_ENTERED = 1;
1130     uint256 private constant _ENTERED = 2;
1131 
1132     uint256 private _status;
1133 
1134     constructor() {
1135         _status = _NOT_ENTERED;
1136     }
1137 
1138     /**
1139      * @dev Prevents a contract from calling itself, directly or indirectly.
1140      * Calling a `nonReentrant` function from another `nonReentrant`
1141      * function is not supported. It is possible to prevent this from happening
1142      * by making the `nonReentrant` function external, and make it call a
1143      * `private` function that does the actual work.
1144      */
1145     modifier nonReentrant() {
1146         // On the first call to nonReentrant, _notEntered will be true
1147         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1148 
1149         // Any calls to nonReentrant after this point will fail
1150         _status = _ENTERED;
1151 
1152         _;
1153 
1154         // By storing the original value once again, a refund is triggered (see
1155         // https://eips.ethereum.org/EIPS/eip-2200)
1156         _status = _NOT_ENTERED;
1157     }
1158 }
1159 
1160 /**
1161  * @title CryptoPochi - an interactive NFT project
1162  *
1163  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1164  */
1165 contract Pochi is ReentrancyGuard, Ownable, ERC165, IERC721Enumerable, IERC721Metadata {
1166     using Address for address;
1167     using EnumerableSet for EnumerableSet.UintSet;
1168     using EnumerableMap for EnumerableMap.UintToAddressMap;
1169     using Strings for uint256;
1170 
1171     uint256 public constant MAX_NFT_SUPPLY = 1500;
1172     uint256 public constant MAX_EARLY_ACCESS_SUPPLY = 750;
1173 
1174     // This will be set after the collection is fully minted and before sealing the contract
1175     string public PROVENANCE = "";
1176 
1177     uint256 public EARLY_ACCESS_START_TIMESTAMP = 1630854000; // 2021-09-05 15:00:00 UTC
1178     uint256 public SALE_START_TIMESTAMP = 1630940400; // 2021-09-06 15:00:00 UTC
1179 
1180     // The unit here is per half hour. Price decreases in a step function every half hour
1181     uint256 public SALE_DURATION = 12;
1182     uint256 public SALE_DURATION_SEC_PER_STEP = 1800; // 30 minutes
1183 
1184     uint256 public DUTCH_AUCTION_START_FEE = 8 ether;
1185     uint256 public DUTCH_AUCTION_END_FEE = 2 ether;
1186 
1187     uint256 public EARLY_ACCESS_MINT_FEE = 0.5 ether;
1188     uint256 public earlyAccessMinted;
1189 
1190     uint256 public POCHI_ACTION_PUBLIC_FEE = 0.01 ether;
1191     uint256 public POCHI_ACTION_OWNER_FEE = 0 ether;
1192 
1193     uint256 public constant POCHI_ACTION_PLEASE_JUMP = 1;
1194     uint256 public constant POCHI_ACTION_PLEASE_SAY_SOMETHING = 2;
1195     uint256 public constant POCHI_ACTION_PLEASE_GO_HAM = 3;
1196 
1197     // Seal contracts for minting, provenance
1198     bool public contractSealed;
1199 
1200     // tokenId -> tokenHash
1201     mapping(uint256 => bytes32) public tokenIdToHash;
1202 
1203     // Early access for ham holders
1204     mapping(address => uint256) public earlyAccessList;
1205 
1206     string private _baseURI;
1207 
1208     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1209     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1210     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1211 
1212     // Mapping from holder address to their (enumerable) set of owned tokens
1213     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1214 
1215     // Enumerable mapping from token ids to their owners
1216     EnumerableMap.UintToAddressMap private _tokenOwners;
1217 
1218     // Mapping from token ID to approved address
1219     mapping(uint256 => address) private _tokenApprovals;
1220 
1221     // Mapping from owner to operator approvals
1222     mapping(address => mapping(address => bool)) private _operatorApprovals;
1223 
1224     // Token name
1225     string private _name;
1226 
1227     // Token symbol
1228     string private _symbol;
1229 
1230     /*
1231      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1232      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1233      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1234      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1235      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1236      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1237      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1238      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1239      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1240      *
1241      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1242      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1243      */
1244     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1245 
1246     /*
1247      *     bytes4(keccak256('name()')) == 0x06fdde03
1248      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1249      *
1250      *     => 0x06fdde03 ^ 0x95d89b41 == 0x93254542
1251      */
1252     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x93254542;
1253 
1254     /*
1255      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1256      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1257      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1258      *
1259      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1260      */
1261     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1262 
1263     // Events
1264     event NewTokenHash(uint256 indexed tokenId, bytes32 tokenHash);
1265     event PochiAction(uint256 indexed timestamp, uint256 actionType, string actionText, string actionTarget, address indexed requester);
1266 
1267     /**
1268      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1269      */
1270     constructor(string memory finalName, string memory finalSymbol) {
1271         _name = finalName;
1272         _symbol = finalSymbol;
1273 
1274         // register the supported interfaces to conform to ERC721 via ERC165
1275         _registerInterface(_INTERFACE_ID_ERC721);
1276         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1277         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Enumerable-totalSupply}.
1282      */
1283     function totalSupply() public view override returns (uint256) {
1284         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1285         return _tokenOwners.length();
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-balanceOf}.
1290      */
1291     function balanceOf(address owner) public view override returns (uint256) {
1292         require(owner != address(0), "ERC721: balance query for the zero address");
1293 
1294         return _holderTokens[owner].length();
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-ownerOf}.
1299      */
1300     function ownerOf(uint256 tokenId) public view override returns (address) {
1301         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Metadata-name}.
1306      */
1307     function name() external view override returns (string memory) {
1308         return _name;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Metadata-symbol}.
1313      */
1314     function symbol() external view override returns (string memory) {
1315         return _symbol;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1320      */
1321     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1322         return _holderTokens[owner].at(index);
1323     }
1324 
1325     /**
1326      * @dev Fetch all tokens owned by an address
1327      */
1328     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1329         uint256 tokenCount = balanceOf(_owner);
1330         if (tokenCount == 0) {
1331             // Return an empty array
1332             return new uint256[](0);
1333         } else {
1334             uint256[] memory result = new uint256[](tokenCount);
1335             uint256 index;
1336             for (index = 0; index < tokenCount; index++) {
1337                 result[index] = tokenOfOwnerByIndex(_owner, index);
1338             }
1339             return result;
1340         }
1341     }
1342 
1343     /**
1344      * @dev Fetch all tokens and their tokenHash owned by an address
1345      */
1346     function tokenHashesOfOwner(address _owner) external view returns (uint256[] memory, bytes32[] memory) {
1347         uint256 tokenCount = balanceOf(_owner);
1348         if (tokenCount == 0) {
1349             // Return an empty array
1350             return (new uint256[](0), new bytes32[](0));
1351         } else {
1352             uint256[] memory result = new uint256[](tokenCount);
1353             bytes32[] memory hashes = new bytes32[](tokenCount);
1354             uint256 index;
1355             for (index = 0; index < tokenCount; index++) {
1356                 result[index] = tokenOfOwnerByIndex(_owner, index);
1357                 hashes[index] = tokenIdToHash[index];
1358             }
1359             return (result, hashes);
1360         }
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Enumerable-tokenByIndex}.
1365      */
1366     function tokenByIndex(uint256 index) external view override returns (uint256) {
1367         (uint256 tokenId, ) = _tokenOwners.at(index);
1368         return tokenId;
1369     }
1370 
1371     /**
1372      * @dev Returns current token price
1373      */
1374     function getNFTPrice() public view returns (uint256) {
1375         require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started");
1376 
1377         uint256 count = totalSupply();
1378         require(count < MAX_NFT_SUPPLY, "Sale has already ended");
1379 
1380         uint256 elapsed = block.timestamp - SALE_START_TIMESTAMP;
1381         if (elapsed >= SALE_DURATION * SALE_DURATION_SEC_PER_STEP) {
1382             return DUTCH_AUCTION_END_FEE;
1383         } else {
1384             return (((SALE_DURATION * SALE_DURATION_SEC_PER_STEP - elapsed - 1) / SALE_DURATION_SEC_PER_STEP + 1) * (DUTCH_AUCTION_START_FEE - DUTCH_AUCTION_END_FEE)) / SALE_DURATION + DUTCH_AUCTION_END_FEE;
1385         }
1386     }
1387 
1388     /**
1389      * @dev Mint tokens and refund any excessive amount of ETH sent in
1390      */
1391     function mintAndRefundExcess(uint256 numberOfNfts) external payable nonReentrant {
1392         // Checks
1393         require(!contractSealed, "Contract sealed");
1394 
1395         require(block.timestamp >= SALE_START_TIMESTAMP, "Sale has not started");
1396 
1397         require(numberOfNfts > 0, "Cannot mint 0 NFTs");
1398         require(numberOfNfts <= 50, "Cannot mint more than 50 in 1 tx");
1399 
1400         uint256 total = totalSupply();
1401         require(total + numberOfNfts <= MAX_NFT_SUPPLY, "Sold out");
1402 
1403         uint256 price = getNFTPrice();
1404         require(msg.value >= numberOfNfts * price, "Ether value sent is insufficient");
1405 
1406         // Effects
1407         _safeMintWithHash(msg.sender, numberOfNfts, total);
1408 
1409         if (msg.value > numberOfNfts * price) {
1410             (bool success, ) = msg.sender.call{value: msg.value - numberOfNfts * price}("");
1411             require(success, "Refund excess failed.");
1412         }
1413     }
1414 
1415     /**
1416      * @dev Mint early access tokens
1417      */
1418     function mintEarlyAccess(uint256 numberOfNfts) external payable nonReentrant {
1419         // Checks
1420         require(!contractSealed, "Contract sealed");
1421 
1422         require(block.timestamp < SALE_START_TIMESTAMP, "Early access is over");
1423         require(block.timestamp >= EARLY_ACCESS_START_TIMESTAMP, "Early access has not started");
1424 
1425         require(numberOfNfts > 0, "Cannot mint 0 NFTs");
1426         require(numberOfNfts <= 50, "Cannot mint more than 50 in 1 tx");
1427 
1428         uint256 total = totalSupply();
1429         require(total + numberOfNfts <= MAX_NFT_SUPPLY, "Sold out");
1430         require(earlyAccessMinted + numberOfNfts <= MAX_EARLY_ACCESS_SUPPLY, "No more early access tokens left");
1431 
1432         require(earlyAccessList[msg.sender] >= numberOfNfts, "Invalid early access mint");
1433 
1434         require(msg.value == numberOfNfts * EARLY_ACCESS_MINT_FEE, "Ether value sent is incorrect");
1435 
1436         // Effects
1437         earlyAccessList[msg.sender] = earlyAccessList[msg.sender] - numberOfNfts;
1438         earlyAccessMinted = earlyAccessMinted + numberOfNfts;
1439 
1440         _safeMintWithHash(msg.sender, numberOfNfts, total);
1441     }
1442 
1443     /**
1444      * @dev Return if we are in the early access time period
1445      */
1446     function isInEarlyAccess() external view returns (bool) {
1447         return block.timestamp >= EARLY_ACCESS_START_TIMESTAMP && block.timestamp < SALE_START_TIMESTAMP;
1448     }
1449 
1450     /**
1451      * @dev Interact with Pochi. Directly from Ethereum!
1452      */
1453     function pochiAction(
1454         uint256 actionType,
1455         string calldata actionText,
1456         string calldata actionTarget
1457     ) external payable {
1458         if (balanceOf(msg.sender) > 0) {
1459             require(msg.value >= POCHI_ACTION_OWNER_FEE, "Ether value sent is incorrect");
1460         } else {
1461             require(msg.value >= POCHI_ACTION_PUBLIC_FEE, "Ether value sent is incorrect");
1462         }
1463 
1464         emit PochiAction(block.timestamp, actionType, actionText, actionTarget, msg.sender);
1465     }
1466 
1467     /**
1468      * @dev Internal function to set the base URI for all token IDs. It is
1469      * automatically added as a prefix to the value returned in {tokenURI},
1470      * or to the token ID if {tokenURI} is empty.
1471      */
1472     function _setBaseURI(string memory baseURI_) internal virtual {
1473         _baseURI = baseURI_;
1474     }
1475 
1476     /**
1477      * @dev Returns the base URI set via {_setBaseURI}. This will be
1478      * automatically added as a prefix in {tokenURI} to each token's URI, or
1479      * to the token ID if no specific URI is set for that token ID.
1480      */
1481     function baseURI() public view virtual returns (string memory) {
1482         return _baseURI;
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Metadata-tokenURI}.
1487      */
1488     function tokenURI(uint256 tokenId) external view virtual returns (string memory) {
1489         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1490 
1491         string memory base = baseURI();
1492 
1493         // If there is no base URI, return the token id.
1494         if (bytes(base).length == 0) {
1495             return tokenId.toString();
1496         }
1497 
1498         return string(abi.encodePacked(base, tokenId.toString()));
1499     }
1500 
1501     /**
1502      * @dev See {IERC721-approve}.
1503      */
1504     function approve(address to, uint256 tokenId) external virtual override {
1505         address owner = ownerOf(tokenId);
1506         require(to != owner, "ERC721: approval to current owner");
1507 
1508         require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");
1509 
1510         _approve(to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-getApproved}.
1515      */
1516     function getApproved(uint256 tokenId) public view override returns (address) {
1517         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1518 
1519         return _tokenApprovals[tokenId];
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-setApprovalForAll}.
1524      */
1525     function setApprovalForAll(address operator, bool approved) external virtual override {
1526         require(operator != msg.sender, "ERC721: approve to caller");
1527 
1528         _operatorApprovals[msg.sender][operator] = approved;
1529         emit ApprovalForAll(msg.sender, operator, approved);
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-isApprovedForAll}.
1534      */
1535     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1536         return _operatorApprovals[owner][operator];
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-transferFrom}.
1541      */
1542     function transferFrom(
1543         address from,
1544         address to,
1545         uint256 tokenId
1546     ) external virtual override {
1547         //solhint-disable-next-line max-line-length
1548         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1549 
1550         _transfer(from, to, tokenId);
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-safeTransferFrom}.
1555      */
1556     function safeTransferFrom(
1557         address from,
1558         address to,
1559         uint256 tokenId
1560     ) public virtual override {
1561         safeTransferFrom(from, to, tokenId, "");
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-safeTransferFrom}.
1566      */
1567     function safeTransferFrom(
1568         address from,
1569         address to,
1570         uint256 tokenId,
1571         bytes memory _data
1572     ) public virtual override {
1573         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1574         _safeTransfer(from, to, tokenId, _data);
1575     }
1576 
1577     /**
1578      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1579      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1580      *
1581      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1582      *
1583      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1584      * implement alternative mechanisms to perform token transfer, such as signature-based.
1585      *
1586      * Requirements:
1587      *
1588      * - `from` cannot be the zero address.
1589      * - `to` cannot be the zero address.
1590      * - `tokenId` token must exist and be owned by `from`.
1591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1592      *
1593      * Emits a {Transfer} event.
1594      */
1595     function _safeTransfer(
1596         address from,
1597         address to,
1598         uint256 tokenId,
1599         bytes memory _data
1600     ) internal virtual {
1601         _transfer(from, to, tokenId);
1602         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1603     }
1604 
1605     /**
1606      * @dev Returns whether `tokenId` exists.
1607      *
1608      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1609      *
1610      * Tokens start existing when they are minted (`_mint`),
1611      * and stop existing when they are burned (`_burn`).
1612      */
1613     function _exists(uint256 tokenId) internal view returns (bool) {
1614         return _tokenOwners.contains(tokenId);
1615     }
1616 
1617     /**
1618      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1619      *
1620      * Requirements:
1621      *
1622      * - `tokenId` must exist.
1623      */
1624     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1625         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1626         address owner = ownerOf(tokenId);
1627         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1628     }
1629 
1630     /**
1631      * @dev Safely mint tokens, and assign tokenHash to the new tokens
1632      *
1633      * Emits a {NewTokenHash} event.
1634      */
1635     function _safeMintWithHash(
1636         address to,
1637         uint256 numberOfNfts,
1638         uint256 startingTokenId
1639     ) internal virtual {
1640         for (uint256 i = 0; i < numberOfNfts; i++) {
1641             uint256 tokenId = startingTokenId + i;
1642             bytes32 tokenHash = keccak256(abi.encodePacked(tokenId, block.number, block.coinbase, block.timestamp, blockhash(block.number - 1), msg.sender));
1643 
1644             tokenIdToHash[tokenId] = tokenHash;
1645 
1646             _safeMint(to, tokenId, "");
1647 
1648             emit NewTokenHash(tokenId, tokenHash);
1649         }
1650     }
1651 
1652     /**
1653      * @dev Safely mints `tokenId` and transfers it to `to`.
1654      *
1655      * Requirements:
1656      *
1657      * - `tokenId` must not exist.
1658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function _safeMint(address to, uint256 tokenId) internal virtual {
1663         _safeMint(to, tokenId, "");
1664     }
1665 
1666     /**
1667      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1668      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1669      */
1670     function _safeMint(
1671         address to,
1672         uint256 tokenId,
1673         bytes memory _data
1674     ) internal virtual {
1675         _mint(to, tokenId);
1676         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1677     }
1678 
1679     /**
1680      * @dev Mints `tokenId` and transfers it to `to`.
1681      *
1682      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1683      *
1684      * Requirements:
1685      *
1686      * - `tokenId` must not exist.
1687      * - `to` cannot be the zero address.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _mint(address to, uint256 tokenId) internal virtual {
1692         require(to != address(0), "ERC721: mint to the zero address");
1693         require(!_exists(tokenId), "ERC721: token already minted");
1694 
1695         _beforeTokenTransfer(address(0), to, tokenId);
1696 
1697         _holderTokens[to].add(tokenId);
1698 
1699         _tokenOwners.set(tokenId, to);
1700 
1701         emit Transfer(address(0), to, tokenId);
1702     }
1703 
1704     /**
1705      * @dev Destroys `tokenId`.
1706      * The approval is cleared when the token is burned.
1707      *
1708      * Requirements:
1709      *
1710      * - `tokenId` must exist.
1711      *
1712      * Emits a {Transfer} event.
1713      */
1714     function _burn(uint256 tokenId) internal virtual {
1715         address owner = ownerOf(tokenId);
1716 
1717         _beforeTokenTransfer(owner, address(0), tokenId);
1718 
1719         // Clear approvals
1720         _approve(address(0), tokenId);
1721 
1722         _holderTokens[owner].remove(tokenId);
1723 
1724         // Burn the token by reassigning owner to the null address
1725         _tokenOwners.set(tokenId, address(0));
1726 
1727         emit Transfer(owner, address(0), tokenId);
1728     }
1729 
1730     /**
1731      * @dev Transfers `tokenId` from `from` to `to`.
1732      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1733      *
1734      * Requirements:
1735      *
1736      * - `to` cannot be the zero address.
1737      * - `tokenId` token must be owned by `from`.
1738      *
1739      * Emits a {Transfer} event.
1740      */
1741     function _transfer(
1742         address from,
1743         address to,
1744         uint256 tokenId
1745     ) internal virtual {
1746         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1747         require(to != address(0), "ERC721: transfer to the zero address");
1748 
1749         _beforeTokenTransfer(from, to, tokenId);
1750 
1751         // Clear approvals from the previous owner
1752         _approve(address(0), tokenId);
1753 
1754         _holderTokens[from].remove(tokenId);
1755         _holderTokens[to].add(tokenId);
1756 
1757         _tokenOwners.set(tokenId, to);
1758 
1759         emit Transfer(from, to, tokenId);
1760     }
1761 
1762     /**
1763      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1764      * The call is not executed if the target address is not a contract.
1765      *
1766      * @param from address representing the previous owner of the given token ID
1767      * @param to target address that will receive the tokens
1768      * @param tokenId uint256 ID of the token to be transferred
1769      * @param _data bytes optional data to send along with the call
1770      * @return bool whether the call correctly returned the expected magic value
1771      */
1772     function _checkOnERC721Received(
1773         address from,
1774         address to,
1775         uint256 tokenId,
1776         bytes memory _data
1777     ) private returns (bool) {
1778         if (!to.isContract()) {
1779             return true;
1780         }
1781         bytes memory returndata = to.functionCall(abi.encodeWithSelector(IERC721Receiver(to).onERC721Received.selector, msg.sender, from, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1782         bytes4 retval = abi.decode(returndata, (bytes4));
1783         return (retval == _ERC721_RECEIVED);
1784     }
1785 
1786     function _approve(address to, uint256 tokenId) private {
1787         _tokenApprovals[tokenId] = to;
1788         emit Approval(ownerOf(tokenId), to, tokenId);
1789     }
1790 
1791     /**
1792      * @dev Hook that is called before any token transfer. This includes minting
1793      * and burning.
1794      *
1795      * Calling conditions:
1796      *
1797      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1798      * transferred to `to`.
1799      * - When `from` is zero, `tokenId` will be minted for `to`.
1800      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1801      * - `from` cannot be the zero address.
1802      * - `to` cannot be the zero address.
1803      *
1804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1805      */
1806     function _beforeTokenTransfer(
1807         address from,
1808         address to,
1809         uint256 tokenId
1810     ) internal virtual {}
1811 
1812     /**
1813      * @dev Deployer parameters
1814      */
1815     function deployerSetParam(uint256 key, uint256 value) external onlyDeployer {
1816         require(!contractSealed, "Contract sealed");
1817 
1818         if (key == 0) {
1819             EARLY_ACCESS_START_TIMESTAMP = value;
1820         } else if (key == 1) {
1821             SALE_START_TIMESTAMP = value;
1822         } else if (key == 2) {
1823             SALE_DURATION = value;
1824         } else if (key == 3) {
1825             SALE_DURATION_SEC_PER_STEP = value;
1826         } else if (key == 10) {
1827             EARLY_ACCESS_MINT_FEE = value;
1828         } else if (key == 11) {
1829             DUTCH_AUCTION_START_FEE = value;
1830         } else if (key == 12) {
1831             DUTCH_AUCTION_END_FEE = value;
1832         } else if (key == 20) {
1833             POCHI_ACTION_PUBLIC_FEE = value;
1834         } else if (key == 21) {
1835             POCHI_ACTION_OWNER_FEE = value;
1836         } else {
1837             revert();
1838         }
1839     }
1840 
1841     /**
1842      * @dev Add to the early access list
1843      */
1844     function deployerAddEarlyAccess(address[] calldata recipients, uint256[] calldata limits) external onlyDeployer {
1845         require(!contractSealed, "Contract sealed");
1846 
1847         for (uint256 i = 0; i < recipients.length; i++) {
1848             require(recipients[i] != address(0), "Can't add the null address");
1849 
1850             earlyAccessList[recipients[i]] = limits[i];
1851         }
1852     }
1853 
1854     /**
1855      * @dev Remove from the early access list
1856      */
1857     function deployerRemoveEarlyAccess(address[] calldata recipients) external onlyDeployer {
1858         require(!contractSealed, "Contract sealed");
1859 
1860         for (uint256 i = 0; i < recipients.length; i++) {
1861             require(recipients[i] != address(0), "Can't remove the null address");
1862 
1863             earlyAccessList[recipients[i]] = 0;
1864         }
1865     }
1866 
1867     /**
1868      * @dev Reserve dev tokens and air drop tokens to craft ham holders
1869      */
1870     function deployerMintMultiple(address[] calldata recipients) external payable onlyDeployer {
1871         require(!contractSealed, "Contract sealed");
1872 
1873         uint256 total = totalSupply();
1874         require(total + recipients.length <= MAX_NFT_SUPPLY, "Sold out");
1875 
1876         for (uint256 i = 0; i < recipients.length; i++) {
1877             require(recipients[i] != address(0), "Can't mint to null address");
1878 
1879             _safeMintWithHash(recipients[i], 1, total + i);
1880         }
1881     }
1882 
1883     /**
1884      * @dev Deployer withdraws ether from this contract
1885      */
1886     function deployerWithdraw(uint256 amount) external onlyDeployer {
1887         (bool success, ) = msg.sender.call{value: amount}("");
1888         require(success, "Transfer failed.");
1889     }
1890 
1891     /**
1892      * @dev Deployer withdraws ERC20s
1893      */
1894     function deployerWithdraw20(IERC20 token) external onlyDeployer {
1895         if (address(token) == 0x0000000000000000000000000000000000000000) {
1896             payable(owner()).transfer(address(this).balance);
1897             (bool success, ) = owner().call{value: address(this).balance}("");
1898             require(success, "Transfer failed.");
1899         } else {
1900             token.transfer(owner(), token.balanceOf(address(this)));
1901         }
1902     }
1903 
1904     /**
1905      * @dev Deployer sets baseURI
1906      */
1907     function deployerSetBaseURI(string memory finalBaseURI) external onlyDeployer {
1908         _setBaseURI(finalBaseURI);
1909     }
1910 
1911     /**
1912      * @dev Deployer sets PROVENANCE
1913      */
1914     function deployerSetProvenance(string memory finalProvenance) external onlyDeployer {
1915         require(!contractSealed, "Contract sealed");
1916         PROVENANCE = finalProvenance;
1917     }
1918 
1919     /**
1920      * @dev Seal this contract
1921      */
1922     function deployerSealContract() external onlyDeployer {
1923         require(bytes(PROVENANCE).length != 0, "PROVENANCE must be set first");
1924         contractSealed = true;
1925     }
1926 }