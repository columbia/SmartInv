1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with GSN meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 
51 
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         uint256 index = digits - 1;
75         temp = value;
76         while (temp != 0) {
77             buffer[index--] = byte(uint8(48 + temp % 10));
78             temp /= 10;
79         }
80         return string(buffer);
81     }
82 }
83 
84 
85 interface IVendingMachine {
86 
87 	function NFTMachineFor(uint256 NFTId, address _recipient) external;
88 }
89 pragma experimental ABIEncoderV2;
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 
100 
101 
102 /**
103  * @dev Required interface of an ERC721 compliant contract.
104  */
105 interface IERC721 is IERC165 {
106     /**
107      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
110 
111     /**
112      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
113      */
114     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
118      */
119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
120 
121     /**
122      * @dev Returns the number of tokens in ``owner``'s account.
123      */
124     function balanceOf(address owner) external view returns (uint256 balance);
125 
126     /**
127      * @dev Returns the owner of the `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function ownerOf(uint256 tokenId) external view returns (address owner);
134 
135     /**
136      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
137      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(address from, address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Transfers `tokenId` token from `from` to `to`.
153      *
154      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(address from, address to, uint256 tokenId) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211       * @dev Safely transfers `tokenId` token from `from` to `to`.
212       *
213       * Requirements:
214       *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217       * - `tokenId` token must exist and be owned by `from`.
218       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220       *
221       * Emits a {Transfer} event.
222       */
223     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
224 }
225 
226 
227 
228 
229 
230 
231 
232 /**
233  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
234  * @dev See https://eips.ethereum.org/EIPS/eip-721
235  */
236 interface IERC721Metadata is IERC721 {
237 
238     /**
239      * @dev Returns the token collection name.
240      */
241     function name() external view returns (string memory);
242 
243     /**
244      * @dev Returns the token collection symbol.
245      */
246     function symbol() external view returns (string memory);
247 
248     /**
249      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
250      */
251     function tokenURI(uint256 tokenId) external view returns (string memory);
252 }
253 
254 
255 
256 
257 
258 
259 
260 /**
261  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
262  * @dev See https://eips.ethereum.org/EIPS/eip-721
263  */
264 interface IERC721Enumerable is IERC721 {
265 
266     /**
267      * @dev Returns the total amount of tokens stored by the contract.
268      */
269     function totalSupply() external view returns (uint256);
270 
271     /**
272      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
273      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
274      */
275     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
276 
277     /**
278      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
279      * Use along with {totalSupply} to enumerate all tokens.
280      */
281     function tokenByIndex(uint256 index) external view returns (uint256);
282 }
283 
284 
285 
286 
287 
288 /**
289  * @title ERC721 token receiver interface
290  * @dev Interface for any contract that wants to support safeTransfers
291  * from ERC721 asset contracts.
292  */
293 interface IERC721Receiver {
294     /**
295      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
296      * by `operator` from `from`, this function is called.
297      *
298      * It must return its Solidity selector to confirm the token transfer.
299      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
300      *
301      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
302      */
303     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
304     external returns (bytes4);
305 }
306 
307 
308 
309 
310 
311 
312 
313 /**
314  * @dev Implementation of the {IERC165} interface.
315  *
316  * Contracts may inherit from this and call {_registerInterface} to declare
317  * their support of an interface.
318  */
319 contract ERC165 is IERC165 {
320     /*
321      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
322      */
323     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
324 
325     /**
326      * @dev Mapping of interface ids to whether or not it's supported.
327      */
328     mapping(bytes4 => bool) private _supportedInterfaces;
329 
330     constructor () internal {
331         // Derived contracts need only register support for their own interfaces,
332         // we register support for ERC165 itself here
333         _registerInterface(_INTERFACE_ID_ERC165);
334     }
335 
336     /**
337      * @dev See {IERC165-supportsInterface}.
338      *
339      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
342         return _supportedInterfaces[interfaceId];
343     }
344 
345     /**
346      * @dev Registers the contract as an implementer of the interface defined by
347      * `interfaceId`. Support of the actual ERC165 interface is automatic and
348      * registering its interface id is not required.
349      *
350      * See {IERC165-supportsInterface}.
351      *
352      * Requirements:
353      *
354      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
355      */
356     function _registerInterface(bytes4 interfaceId) internal virtual {
357         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
358         _supportedInterfaces[interfaceId] = true;
359     }
360 }
361 
362 
363 
364 
365 
366 /**
367  * @dev Wrappers over Solidity's arithmetic operations with added overflow
368  * checks.
369  *
370  * Arithmetic operations in Solidity wrap on overflow. This can easily result
371  * in bugs, because programmers usually assume that an overflow raises an
372  * error, which is the standard behavior in high level programming languages.
373  * `SafeMath` restores this intuition by reverting the transaction when an
374  * operation overflows.
375  *
376  * Using this library instead of the unchecked operations eliminates an entire
377  * class of bugs, so it's recommended to use it always.
378  */
379 library SafeMath {
380     /**
381      * @dev Returns the addition of two unsigned integers, reverting on
382      * overflow.
383      *
384      * Counterpart to Solidity's `+` operator.
385      *
386      * Requirements:
387      *
388      * - Addition cannot overflow.
389      */
390     function add(uint256 a, uint256 b) internal pure returns (uint256) {
391         uint256 c = a + b;
392         require(c >= a, "SafeMath: addition overflow");
393 
394         return c;
395     }
396 
397     /**
398      * @dev Returns the subtraction of two unsigned integers, reverting on
399      * overflow (when the result is negative).
400      *
401      * Counterpart to Solidity's `-` operator.
402      *
403      * Requirements:
404      *
405      * - Subtraction cannot overflow.
406      */
407     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
408         return sub(a, b, "SafeMath: subtraction overflow");
409     }
410 
411     /**
412      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
413      * overflow (when the result is negative).
414      *
415      * Counterpart to Solidity's `-` operator.
416      *
417      * Requirements:
418      *
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b <= a, errorMessage);
423         uint256 c = a - b;
424 
425         return c;
426     }
427 
428     /**
429      * @dev Returns the multiplication of two unsigned integers, reverting on
430      * overflow.
431      *
432      * Counterpart to Solidity's `*` operator.
433      *
434      * Requirements:
435      *
436      * - Multiplication cannot overflow.
437      */
438     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
439         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
440         // benefit is lost if 'b' is also tested.
441         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
442         if (a == 0) {
443             return 0;
444         }
445 
446         uint256 c = a * b;
447         require(c / a == b, "SafeMath: multiplication overflow");
448 
449         return c;
450     }
451 
452     /**
453      * @dev Returns the integer division of two unsigned integers. Reverts on
454      * division by zero. The result is rounded towards zero.
455      *
456      * Counterpart to Solidity's `/` operator. Note: this function uses a
457      * `revert` opcode (which leaves remaining gas untouched) while Solidity
458      * uses an invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function div(uint256 a, uint256 b) internal pure returns (uint256) {
465         return div(a, b, "SafeMath: division by zero");
466     }
467 
468     /**
469      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
470      * division by zero. The result is rounded towards zero.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
481         require(b > 0, errorMessage);
482         uint256 c = a / b;
483         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
490      * Reverts when dividing by zero.
491      *
492      * Counterpart to Solidity's `%` operator. This function uses a `revert`
493      * opcode (which leaves remaining gas untouched) while Solidity uses an
494      * invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
501         return mod(a, b, "SafeMath: modulo by zero");
502     }
503 
504     /**
505      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
506      * Reverts with custom message when dividing by zero.
507      *
508      * Counterpart to Solidity's `%` operator. This function uses a `revert`
509      * opcode (which leaves remaining gas untouched) while Solidity uses an
510      * invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
517         require(b != 0, errorMessage);
518         return a % b;
519     }
520 }
521 
522 
523 
524 
525 
526 /**
527  * @dev Collection of functions related to the address type
528  */
529 library Address {
530     /**
531      * @dev Returns true if `account` is a contract.
532      *
533      * [IMPORTANT]
534      * ====
535      * It is unsafe to assume that an address for which this function returns
536      * false is an externally-owned account (EOA) and not a contract.
537      *
538      * Among others, `isContract` will return false for the following
539      * types of addresses:
540      *
541      *  - an externally-owned account
542      *  - a contract in construction
543      *  - an address where a contract will be created
544      *  - an address where a contract lived, but was destroyed
545      * ====
546      */
547     function isContract(address account) internal view returns (bool) {
548         // This method relies in extcodesize, which returns 0 for contracts in
549         // construction, since the code is only stored at the end of the
550         // constructor execution.
551 
552         uint256 size;
553         // solhint-disable-next-line no-inline-assembly
554         assembly { size := extcodesize(account) }
555         return size > 0;
556     }
557 
558     /**
559      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
560      * `recipient`, forwarding all available gas and reverting on errors.
561      *
562      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
563      * of certain opcodes, possibly making contracts go over the 2300 gas limit
564      * imposed by `transfer`, making them unable to receive funds via
565      * `transfer`. {sendValue} removes this limitation.
566      *
567      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
568      *
569      * IMPORTANT: because control is transferred to `recipient`, care must be
570      * taken to not create reentrancy vulnerabilities. Consider using
571      * {ReentrancyGuard} or the
572      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
573      */
574     function sendValue(address payable recipient, uint256 amount) internal {
575         require(address(this).balance >= amount, "Address: insufficient balance");
576 
577         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
578         (bool success, ) = recipient.call{ value: amount }("");
579         require(success, "Address: unable to send value, recipient may have reverted");
580     }
581 
582     /**
583      * @dev Performs a Solidity function call using a low level `call`. A
584      * plain`call` is an unsafe replacement for a function call: use this
585      * function instead.
586      *
587      * If `target` reverts with a revert reason, it is bubbled up by this
588      * function (like regular Solidity function calls).
589      *
590      * Returns the raw returned data. To convert to the expected return value,
591      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
592      *
593      * Requirements:
594      *
595      * - `target` must be a contract.
596      * - calling `target` with `data` must not revert.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
601       return functionCall(target, data, "Address: low-level call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
606      * `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
611         return _functionCallWithValue(target, data, 0, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but also transferring `value` wei to `target`.
617      *
618      * Requirements:
619      *
620      * - the calling contract must have an ETH balance of at least `value`.
621      * - the called Solidity function must be `payable`.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
631      * with `errorMessage` as a fallback revert reason when `target` reverts.
632      *
633      * _Available since v3.1._
634      */
635     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
636         require(address(this).balance >= value, "Address: insufficient balance for call");
637         return _functionCallWithValue(target, data, value, errorMessage);
638     }
639 
640     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
641         require(isContract(target), "Address: call to non-contract");
642 
643         // solhint-disable-next-line avoid-low-level-calls
644         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 // solhint-disable-next-line no-inline-assembly
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 
666 
667 
668 /**
669  * @dev Library for managing
670  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
671  * types.
672  *
673  * Sets have the following properties:
674  *
675  * - Elements are added, removed, and checked for existence in constant time
676  * (O(1)).
677  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
678  *
679  * ```
680  * contract Example {
681  *     // Add the library methods
682  *     using EnumerableSet for EnumerableSet.AddressSet;
683  *
684  *     // Declare a set state variable
685  *     EnumerableSet.AddressSet private mySet;
686  * }
687  * ```
688  *
689  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
690  * (`UintSet`) are supported.
691  */
692 library EnumerableSet {
693     // To implement this library for multiple types with as little code
694     // repetition as possible, we write it in terms of a generic Set type with
695     // bytes32 values.
696     // The Set implementation uses private functions, and user-facing
697     // implementations (such as AddressSet) are just wrappers around the
698     // underlying Set.
699     // This means that we can only create new EnumerableSets for types that fit
700     // in bytes32.
701 
702     struct Set {
703         // Storage of set values
704         bytes32[] _values;
705 
706         // Position of the value in the `values` array, plus 1 because index 0
707         // means a value is not in the set.
708         mapping (bytes32 => uint256) _indexes;
709     }
710 
711     /**
712      * @dev Add a value to a set. O(1).
713      *
714      * Returns true if the value was added to the set, that is if it was not
715      * already present.
716      */
717     function _add(Set storage set, bytes32 value) private returns (bool) {
718         if (!_contains(set, value)) {
719             set._values.push(value);
720             // The value is stored at length-1, but we add 1 to all indexes
721             // and use 0 as a sentinel value
722             set._indexes[value] = set._values.length;
723             return true;
724         } else {
725             return false;
726         }
727     }
728 
729     /**
730      * @dev Removes a value from a set. O(1).
731      *
732      * Returns true if the value was removed from the set, that is if it was
733      * present.
734      */
735     function _remove(Set storage set, bytes32 value) private returns (bool) {
736         // We read and store the value's index to prevent multiple reads from the same storage slot
737         uint256 valueIndex = set._indexes[value];
738 
739         if (valueIndex != 0) { // Equivalent to contains(set, value)
740             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
741             // the array, and then remove the last element (sometimes called as 'swap and pop').
742             // This modifies the order of the array, as noted in {at}.
743 
744             uint256 toDeleteIndex = valueIndex - 1;
745             uint256 lastIndex = set._values.length - 1;
746 
747             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
748             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
749 
750             bytes32 lastvalue = set._values[lastIndex];
751 
752             // Move the last value to the index where the value to delete is
753             set._values[toDeleteIndex] = lastvalue;
754             // Update the index for the moved value
755             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
756 
757             // Delete the slot where the moved value was stored
758             set._values.pop();
759 
760             // Delete the index for the deleted slot
761             delete set._indexes[value];
762 
763             return true;
764         } else {
765             return false;
766         }
767     }
768 
769     /**
770      * @dev Returns true if the value is in the set. O(1).
771      */
772     function _contains(Set storage set, bytes32 value) private view returns (bool) {
773         return set._indexes[value] != 0;
774     }
775 
776     /**
777      * @dev Returns the number of values on the set. O(1).
778      */
779     function _length(Set storage set) private view returns (uint256) {
780         return set._values.length;
781     }
782 
783    /**
784     * @dev Returns the value stored at position `index` in the set. O(1).
785     *
786     * Note that there are no guarantees on the ordering of values inside the
787     * array, and it may change when more values are added or removed.
788     *
789     * Requirements:
790     *
791     * - `index` must be strictly less than {length}.
792     */
793     function _at(Set storage set, uint256 index) private view returns (bytes32) {
794         require(set._values.length > index, "EnumerableSet: index out of bounds");
795         return set._values[index];
796     }
797 
798     // AddressSet
799 
800     struct AddressSet {
801         Set _inner;
802     }
803 
804     /**
805      * @dev Add a value to a set. O(1).
806      *
807      * Returns true if the value was added to the set, that is if it was not
808      * already present.
809      */
810     function add(AddressSet storage set, address value) internal returns (bool) {
811         return _add(set._inner, bytes32(uint256(value)));
812     }
813 
814     /**
815      * @dev Removes a value from a set. O(1).
816      *
817      * Returns true if the value was removed from the set, that is if it was
818      * present.
819      */
820     function remove(AddressSet storage set, address value) internal returns (bool) {
821         return _remove(set._inner, bytes32(uint256(value)));
822     }
823 
824     /**
825      * @dev Returns true if the value is in the set. O(1).
826      */
827     function contains(AddressSet storage set, address value) internal view returns (bool) {
828         return _contains(set._inner, bytes32(uint256(value)));
829     }
830 
831     /**
832      * @dev Returns the number of values in the set. O(1).
833      */
834     function length(AddressSet storage set) internal view returns (uint256) {
835         return _length(set._inner);
836     }
837 
838    /**
839     * @dev Returns the value stored at position `index` in the set. O(1).
840     *
841     * Note that there are no guarantees on the ordering of values inside the
842     * array, and it may change when more values are added or removed.
843     *
844     * Requirements:
845     *
846     * - `index` must be strictly less than {length}.
847     */
848     function at(AddressSet storage set, uint256 index) internal view returns (address) {
849         return address(uint256(_at(set._inner, index)));
850     }
851 
852 
853     // UintSet
854 
855     struct UintSet {
856         Set _inner;
857     }
858 
859     /**
860      * @dev Add a value to a set. O(1).
861      *
862      * Returns true if the value was added to the set, that is if it was not
863      * already present.
864      */
865     function add(UintSet storage set, uint256 value) internal returns (bool) {
866         return _add(set._inner, bytes32(value));
867     }
868 
869     /**
870      * @dev Removes a value from a set. O(1).
871      *
872      * Returns true if the value was removed from the set, that is if it was
873      * present.
874      */
875     function remove(UintSet storage set, uint256 value) internal returns (bool) {
876         return _remove(set._inner, bytes32(value));
877     }
878 
879     /**
880      * @dev Returns true if the value is in the set. O(1).
881      */
882     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
883         return _contains(set._inner, bytes32(value));
884     }
885 
886     /**
887      * @dev Returns the number of values on the set. O(1).
888      */
889     function length(UintSet storage set) internal view returns (uint256) {
890         return _length(set._inner);
891     }
892 
893    /**
894     * @dev Returns the value stored at position `index` in the set. O(1).
895     *
896     * Note that there are no guarantees on the ordering of values inside the
897     * array, and it may change when more values are added or removed.
898     *
899     * Requirements:
900     *
901     * - `index` must be strictly less than {length}.
902     */
903     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
904         return uint256(_at(set._inner, index));
905     }
906 }
907 
908 
909 
910 
911 
912 /**
913  * @dev Library for managing an enumerable variant of Solidity's
914  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
915  * type.
916  *
917  * Maps have the following properties:
918  *
919  * - Entries are added, removed, and checked for existence in constant time
920  * (O(1)).
921  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
922  *
923  * ```
924  * contract Example {
925  *     // Add the library methods
926  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
927  *
928  *     // Declare a set state variable
929  *     EnumerableMap.UintToAddressMap private myMap;
930  * }
931  * ```
932  *
933  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
934  * supported.
935  */
936 library EnumerableMap {
937     // To implement this library for multiple types with as little code
938     // repetition as possible, we write it in terms of a generic Map type with
939     // bytes32 keys and values.
940     // The Map implementation uses private functions, and user-facing
941     // implementations (such as Uint256ToAddressMap) are just wrappers around
942     // the underlying Map.
943     // This means that we can only create new EnumerableMaps for types that fit
944     // in bytes32.
945 
946     struct MapEntry {
947         bytes32 _key;
948         bytes32 _value;
949     }
950 
951     struct Map {
952         // Storage of map keys and values
953         MapEntry[] _entries;
954 
955         // Position of the entry defined by a key in the `entries` array, plus 1
956         // because index 0 means a key is not in the map.
957         mapping (bytes32 => uint256) _indexes;
958     }
959 
960     /**
961      * @dev Adds a key-value pair to a map, or updates the value for an existing
962      * key. O(1).
963      *
964      * Returns true if the key was added to the map, that is if it was not
965      * already present.
966      */
967     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
968         // We read and store the key's index to prevent multiple reads from the same storage slot
969         uint256 keyIndex = map._indexes[key];
970 
971         if (keyIndex == 0) { // Equivalent to !contains(map, key)
972             map._entries.push(MapEntry({ _key: key, _value: value }));
973             // The entry is stored at length-1, but we add 1 to all indexes
974             // and use 0 as a sentinel value
975             map._indexes[key] = map._entries.length;
976             return true;
977         } else {
978             map._entries[keyIndex - 1]._value = value;
979             return false;
980         }
981     }
982 
983     /**
984      * @dev Removes a key-value pair from a map. O(1).
985      *
986      * Returns true if the key was removed from the map, that is if it was present.
987      */
988     function _remove(Map storage map, bytes32 key) private returns (bool) {
989         // We read and store the key's index to prevent multiple reads from the same storage slot
990         uint256 keyIndex = map._indexes[key];
991 
992         if (keyIndex != 0) { // Equivalent to contains(map, key)
993             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
994             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
995             // This modifies the order of the array, as noted in {at}.
996 
997             uint256 toDeleteIndex = keyIndex - 1;
998             uint256 lastIndex = map._entries.length - 1;
999 
1000             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1001             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1002 
1003             MapEntry storage lastEntry = map._entries[lastIndex];
1004 
1005             // Move the last entry to the index where the entry to delete is
1006             map._entries[toDeleteIndex] = lastEntry;
1007             // Update the index for the moved entry
1008             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1009 
1010             // Delete the slot where the moved entry was stored
1011             map._entries.pop();
1012 
1013             // Delete the index for the deleted slot
1014             delete map._indexes[key];
1015 
1016             return true;
1017         } else {
1018             return false;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Returns true if the key is in the map. O(1).
1024      */
1025     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1026         return map._indexes[key] != 0;
1027     }
1028 
1029     /**
1030      * @dev Returns the number of key-value pairs in the map. O(1).
1031      */
1032     function _length(Map storage map) private view returns (uint256) {
1033         return map._entries.length;
1034     }
1035 
1036    /**
1037     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1038     *
1039     * Note that there are no guarantees on the ordering of entries inside the
1040     * array, and it may change when more entries are added or removed.
1041     *
1042     * Requirements:
1043     *
1044     * - `index` must be strictly less than {length}.
1045     */
1046     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1047         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1048 
1049         MapEntry storage entry = map._entries[index];
1050         return (entry._key, entry._value);
1051     }
1052 
1053     /**
1054      * @dev Returns the value associated with `key`.  O(1).
1055      *
1056      * Requirements:
1057      *
1058      * - `key` must be in the map.
1059      */
1060     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1061         return _get(map, key, "EnumerableMap: nonexistent key");
1062     }
1063 
1064     /**
1065      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1066      */
1067     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1068         uint256 keyIndex = map._indexes[key];
1069         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1070         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1071     }
1072 
1073     // UintToAddressMap
1074 
1075     struct UintToAddressMap {
1076         Map _inner;
1077     }
1078 
1079     /**
1080      * @dev Adds a key-value pair to a map, or updates the value for an existing
1081      * key. O(1).
1082      *
1083      * Returns true if the key was added to the map, that is if it was not
1084      * already present.
1085      */
1086     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1087         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1088     }
1089 
1090     /**
1091      * @dev Removes a value from a set. O(1).
1092      *
1093      * Returns true if the key was removed from the map, that is if it was present.
1094      */
1095     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1096         return _remove(map._inner, bytes32(key));
1097     }
1098 
1099     /**
1100      * @dev Returns true if the key is in the map. O(1).
1101      */
1102     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1103         return _contains(map._inner, bytes32(key));
1104     }
1105 
1106     /**
1107      * @dev Returns the number of elements in the map. O(1).
1108      */
1109     function length(UintToAddressMap storage map) internal view returns (uint256) {
1110         return _length(map._inner);
1111     }
1112 
1113    /**
1114     * @dev Returns the element stored at position `index` in the set. O(1).
1115     * Note that there are no guarantees on the ordering of values inside the
1116     * array, and it may change when more values are added or removed.
1117     *
1118     * Requirements:
1119     *
1120     * - `index` must be strictly less than {length}.
1121     */
1122     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1123         (bytes32 key, bytes32 value) = _at(map._inner, index);
1124         return (uint256(key), address(uint256(value)));
1125     }
1126 
1127     /**
1128      * @dev Returns the value associated with `key`.  O(1).
1129      *
1130      * Requirements:
1131      *
1132      * - `key` must be in the map.
1133      */
1134     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1135         return address(uint256(_get(map._inner, bytes32(key))));
1136     }
1137 
1138     /**
1139      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1140      */
1141     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1142         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1143     }
1144 }
1145 
1146 
1147 
1148 /**
1149  * @title ERC721 Non-Fungible Token Standard basic implementation
1150  * @dev see https://eips.ethereum.org/EIPS/eip-721
1151  */
1152 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1153     using SafeMath for uint256;
1154     using Address for address;
1155     using EnumerableSet for EnumerableSet.UintSet;
1156     using EnumerableMap for EnumerableMap.UintToAddressMap;
1157     using Strings for uint256;
1158 
1159     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1160     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1161     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1162 
1163     // Mapping from holder address to their (enumerable) set of owned tokens
1164     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1165 
1166     // Enumerable mapping from token ids to their owners
1167     EnumerableMap.UintToAddressMap private _tokenOwners;
1168 
1169     // Mapping from token ID to approved address
1170     mapping (uint256 => address) private _tokenApprovals;
1171 
1172     // Mapping from owner to operator approvals
1173     mapping (address => mapping (address => bool)) private _operatorApprovals;
1174 
1175     // Token name
1176     string private _name;
1177 
1178     // Token symbol
1179     string private _symbol;
1180 
1181     // Optional mapping for token URIs
1182     mapping (uint256 => string) private _tokenURIs;
1183 
1184     // Base URI
1185     string private _baseURI;
1186 
1187     /*
1188      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1189      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1190      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1191      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1192      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1193      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1194      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1195      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1196      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1197      *
1198      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1199      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1200      */
1201     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1202 
1203     /*
1204      *     bytes4(keccak256('name()')) == 0x06fdde03
1205      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1206      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1207      *
1208      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1209      */
1210     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1211 
1212     /*
1213      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1214      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1215      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1216      *
1217      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1218      */
1219     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1220 
1221     /**
1222      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1223      */
1224     constructor (string memory name, string memory symbol) public {
1225         _name = name;
1226         _symbol = symbol;
1227 
1228         // register the supported interfaces to conform to ERC721 via ERC165
1229         _registerInterface(_INTERFACE_ID_ERC721);
1230         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1231         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-balanceOf}.
1236      */
1237     function balanceOf(address owner) public view override returns (uint256) {
1238         require(owner != address(0), "ERC721: balance query for the zero address");
1239 
1240         return _holderTokens[owner].length();
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-ownerOf}.
1245      */
1246     function ownerOf(uint256 tokenId) public view override returns (address) {
1247         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Metadata-name}.
1252      */
1253     function name() public view override returns (string memory) {
1254         return _name;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Metadata-symbol}.
1259      */
1260     function symbol() public view override returns (string memory) {
1261         return _symbol;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Metadata-tokenURI}.
1266      */
1267     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1268         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1269 
1270         string memory _tokenURI = _tokenURIs[tokenId];
1271 
1272         // If there is no base URI, return the token URI.
1273         if (bytes(_baseURI).length == 0) {
1274             return _tokenURI;
1275         }
1276         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1277         if (bytes(_tokenURI).length > 0) {
1278             return string(abi.encodePacked(_baseURI, _tokenURI));
1279         }
1280         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1281         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1282     }
1283 
1284     /**
1285     * @dev Returns the base URI set via {_setBaseURI}. This will be
1286     * automatically added as a prefix in {tokenURI} to each token's URI, or
1287     * to the token ID if no specific URI is set for that token ID.
1288     */
1289     function baseURI() public view returns (string memory) {
1290         return _baseURI;
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1297         return _holderTokens[owner].at(index);
1298     }
1299 
1300     /**
1301      * @dev See {IERC721Enumerable-totalSupply}.
1302      */
1303     function totalSupply() public view override returns (uint256) {
1304         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1305         return _tokenOwners.length();
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Enumerable-tokenByIndex}.
1310      */
1311     function tokenByIndex(uint256 index) public view override returns (uint256) {
1312         (uint256 tokenId, ) = _tokenOwners.at(index);
1313         return tokenId;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-approve}.
1318      */
1319     function approve(address to, uint256 tokenId) public virtual override {
1320         address owner = ownerOf(tokenId);
1321         require(to != owner, "ERC721: approval to current owner");
1322 
1323         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1324             "ERC721: approve caller is not owner nor approved for all"
1325         );
1326 
1327         _approve(to, tokenId);
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-getApproved}.
1332      */
1333     function getApproved(uint256 tokenId) public view override returns (address) {
1334         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1335 
1336         return _tokenApprovals[tokenId];
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-setApprovalForAll}.
1341      */
1342     function setApprovalForAll(address operator, bool approved) public virtual override {
1343         require(operator != _msgSender(), "ERC721: approve to caller");
1344 
1345         _operatorApprovals[_msgSender()][operator] = approved;
1346         emit ApprovalForAll(_msgSender(), operator, approved);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-isApprovedForAll}.
1351      */
1352     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1353         return _operatorApprovals[owner][operator];
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-transferFrom}.
1358      */
1359     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1360         //solhint-disable-next-line max-line-length
1361         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1362 
1363         _transfer(from, to, tokenId);
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-safeTransferFrom}.
1368      */
1369     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1370         safeTransferFrom(from, to, tokenId, "");
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-safeTransferFrom}.
1375      */
1376     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1377         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1378         _safeTransfer(from, to, tokenId, _data);
1379     }
1380 
1381     /**
1382      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1383      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1384      *
1385      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1386      *
1387      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1388      * implement alternative mechanisms to perform token transfer, such as signature-based.
1389      *
1390      * Requirements:
1391      *
1392      * - `from` cannot be the zero address.
1393      * - `to` cannot be the zero address.
1394      * - `tokenId` token must exist and be owned by `from`.
1395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1400         _transfer(from, to, tokenId);
1401         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1402     }
1403 
1404     /**
1405      * @dev Returns whether `tokenId` exists.
1406      *
1407      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1408      *
1409      * Tokens start existing when they are minted (`_mint`),
1410      * and stop existing when they are burned (`_burn`).
1411      */
1412     function _exists(uint256 tokenId) internal view returns (bool) {
1413         return _tokenOwners.contains(tokenId);
1414     }
1415 
1416     /**
1417      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      */
1423     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1424         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1425         address owner = ownerOf(tokenId);
1426         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1427     }
1428 
1429     /**
1430      * @dev Safely mints `tokenId` and transfers it to `to`.
1431      *
1432      * Requirements:
1433      d*
1434      * - `tokenId` must not exist.
1435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function _safeMint(address to, uint256 tokenId) internal virtual {
1440         _safeMint(to, tokenId, "");
1441     }
1442 
1443     /**
1444      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1445      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1446      */
1447     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1448         _mint(to, tokenId);
1449         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1450     }
1451 
1452     /**
1453      * @dev Mints `tokenId` and transfers it to `to`.
1454      *
1455      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1456      *
1457      * Requirements:
1458      *
1459      * - `tokenId` must not exist.
1460      * - `to` cannot be the zero address.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _mint(address to, uint256 tokenId) internal virtual {
1465         require(to != address(0), "ERC721: mint to the zero address");
1466         require(!_exists(tokenId), "ERC721: token already minted");
1467 
1468         _beforeTokenTransfer(address(0), to, tokenId);
1469 
1470         _holderTokens[to].add(tokenId);
1471 
1472         _tokenOwners.set(tokenId, to);
1473 
1474         emit Transfer(address(0), to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev Destroys `tokenId`.
1479      * The approval is cleared when the token is burned.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _burn(uint256 tokenId) internal virtual {
1488         address owner = ownerOf(tokenId);
1489 
1490         _beforeTokenTransfer(owner, address(0), tokenId);
1491 
1492         // Clear approvals
1493         _approve(address(0), tokenId);
1494 
1495         // Clear metadata (if any)
1496         if (bytes(_tokenURIs[tokenId]).length != 0) {
1497             delete _tokenURIs[tokenId];
1498         }
1499 
1500         _holderTokens[owner].remove(tokenId);
1501 
1502         _tokenOwners.remove(tokenId);
1503 
1504         emit Transfer(owner, address(0), tokenId);
1505     }
1506 
1507     /**
1508      * @dev Transfers `tokenId` from `from` to `to`.
1509      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1510      *
1511      * Requirements:
1512      *
1513      * - `to` cannot be the zero address.
1514      * - `tokenId` token must be owned by `from`.
1515      *
1516      * Emits a {Transfer} event.
1517      */
1518     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1519         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1520         require(to != address(0), "ERC721: transfer to the zero address");
1521 
1522         _beforeTokenTransfer(from, to, tokenId);
1523 
1524         // Clear approvals from the previous owner
1525         _approve(address(0), tokenId);
1526 
1527         _holderTokens[from].remove(tokenId);
1528         _holderTokens[to].add(tokenId);
1529 
1530         _tokenOwners.set(tokenId, to);
1531 
1532         emit Transfer(from, to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1537      *
1538      * Requirements:
1539      *
1540      * - `tokenId` must exist.
1541      */
1542     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1543         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1544         _tokenURIs[tokenId] = _tokenURI;
1545     }
1546 
1547     /**
1548      * @dev Internal function to set the base URI for all token IDs. It is
1549      * automatically added as a prefix to the value returned in {tokenURI},
1550      * or to the token ID if {tokenURI} is empty.
1551      */
1552     function _setBaseURI(string memory baseURI_) internal virtual {
1553         _baseURI = baseURI_;
1554     }
1555 
1556     /**
1557      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1558      * The call is not executed if the target address is not a contract.
1559      *
1560      * @param from address representing the previous owner of the given token ID
1561      * @param to target address that will receive the tokens
1562      * @param tokenId uint256 ID of the token to be transferred
1563      * @param _data bytes optional data to send along with the call
1564      * @return bool whether the call correctly returned the expected magic value
1565      */
1566     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1567         private returns (bool)
1568     {
1569         if (!to.isContract()) {
1570             return true;
1571         }
1572         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1573             IERC721Receiver(to).onERC721Received.selector,
1574             _msgSender(),
1575             from,
1576             tokenId,
1577             _data
1578         ), "ERC721: transfer to non ERC721Receiver implementer");
1579         bytes4 retval = abi.decode(returndata, (bytes4));
1580         return (retval == _ERC721_RECEIVED);
1581     }
1582 
1583     function _approve(address to, uint256 tokenId) private {
1584         _tokenApprovals[tokenId] = to;
1585         emit Approval(ownerOf(tokenId), to, tokenId);
1586     }
1587 
1588     /**
1589      * @dev Hook that is called before any token transfer. This includes minting
1590      * and burning.
1591      *
1592      * Calling conditions:
1593      *
1594      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1595      * transferred to `to`.
1596      * - When `from` is zero, `tokenId` will be minted for `to`.
1597      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      *
1601      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1602      */
1603     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1604 }
1605 
1606 
1607 
1608 
1609 
1610 
1611 
1612 /**
1613  * @dev Contract module which provides a basic access control mechanism, where
1614  * there is an account (an owner) that can be granted exclusive access to
1615  * specific functions.
1616  *
1617  * By default, the owner account will be the one that deploys the contract. This
1618  * can later be changed with {transferOwnership}.
1619  *
1620  * This module is used through inheritance. It will make available the modifier
1621  * `onlyOwner`, which can be applied to your functions to restrict their use to
1622  * the owner.
1623  */
1624 contract Ownable is Context {
1625     address private _owner;
1626 
1627     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1628 
1629     /**
1630      * @dev Initializes the contract setting the deployer as the initial owner.
1631      */
1632     constructor () internal {
1633         address msgSender = _msgSender();
1634         _owner = msgSender;
1635         emit OwnershipTransferred(address(0), msgSender);
1636     }
1637 
1638     /**
1639      * @dev Returns the address of the current owner.
1640      */
1641     function owner() public view returns (address) {
1642         return _owner;
1643     }
1644 
1645     /**
1646      * @dev Throws if called by any account other than the owner.
1647      */
1648     modifier onlyOwner() {
1649         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1650         _;
1651     }
1652 
1653     /**
1654      * @dev Leaves the contract without owner. It will not be possible to call
1655      * `onlyOwner` functions anymore. Can only be called by the current owner.
1656      *
1657      * NOTE: Renouncing ownership will leave the contract without an owner,
1658      * thereby removing any functionality that is only available to the owner.
1659      */
1660     function renounceOwnership() public virtual onlyOwner {
1661         emit OwnershipTransferred(_owner, address(0));
1662         _owner = address(0);
1663     }
1664 
1665     /**
1666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1667      * Can only be called by the current owner.
1668      */
1669     function transferOwnership(address newOwner) public virtual onlyOwner {
1670         require(newOwner != address(0), "Ownable: new owner is the zero address");
1671         emit OwnershipTransferred(_owner, newOwner);
1672         _owner = newOwner;
1673     }
1674 }
1675 
1676 
1677 contract HasSecondaryBoxSaleFees is ERC165 {
1678     
1679     address payable teamAddress;
1680     uint256 teamSecondaryBps;  
1681         
1682    /*
1683     * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1684     * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1685     *
1686     * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1687     */
1688     
1689     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1690     
1691     constructor() public {
1692         _registerInterface(_INTERFACE_ID_FEES);
1693     }
1694 
1695     function getFeeRecipients(uint256 id) public view returns (address payable[] memory){
1696         address payable[] memory addressArray;
1697         addressArray[0] = teamAddress;
1698         return addressArray;
1699     }
1700     
1701     function getFeeBps(uint256 id) public view returns (uint[] memory){
1702         uint[] memory bpsArray;
1703         bpsArray[0] = teamSecondaryBps; 
1704         return bpsArray;
1705     }
1706  
1707 }
1708 
1709 
1710 contract NFTBoxesBox is ERC721("NFTBox", "[BOX]"), Ownable, HasSecondaryBoxSaleFees {
1711     
1712 	struct BoxMould{
1713 		uint8				live; // bool
1714 		uint8				shared; // bool
1715 		uint128				maxEdition;
1716 		uint152				maxBuyAmount;
1717 		uint128				currentEditionCount;
1718 		uint256				price;
1719 		address payable[]	artists;
1720 		uint256[]			shares;
1721 		string				name;
1722 		string				series;
1723 		string				theme;
1724 		string				ipfsHash;
1725 		string				arweaveHash;
1726 	}
1727 
1728 	struct Box {
1729 		uint256				mouldId;
1730 		uint256				edition;
1731 	}
1732 
1733 	IVendingMachine public	vendingMachine;
1734 	uint256 public			boxMouldCount;
1735 
1736 	uint256 constant public TOTAL_SHARES = 1000;
1737 
1738 	mapping(uint256 => BoxMould) public	boxMoulds;
1739 	mapping(uint256 =>  Box) public	boxes;
1740 	mapping(uint256 => bool) public lockedBoxes;
1741 
1742 	mapping(address => uint256) public teamShare;
1743 	address payable[] public team;
1744 
1745 	mapping(address => bool) public authorisedCaller;
1746 
1747 	event BoxMouldCreated(uint256 id);
1748 	event BoxBought(uint256 indexed boxMould, uint256 boxEdition, uint256 tokenId);
1749 
1750 	constructor() public {
1751 		_setBaseURI("https://nftboxesbox.azurewebsites.net/api/HttpTrigger?id=");
1752 		team.push(payable(0x3428B1746Dfd26C7C725913D829BE2706AA89B2e));
1753 		team.push(payable(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3));
1754 		team.push(payable(0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073));
1755 		team.push(payable(0xf521Bb7437bEc77b0B15286dC3f49A87b9946773));
1756 		team.push(payable(0x3945476E477De76d53b4833a46c806Ef3D72b21E));
1757 
1758 		teamShare[address(0x3428B1746Dfd26C7C725913D829BE2706AA89B2e)] = 580;
1759 		teamShare[address(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3)] = 10;
1760 		teamShare[address(0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073)] = 30;
1761 		teamShare[address(0xf521Bb7437bEc77b0B15286dC3f49A87b9946773)] = 30;
1762 		teamShare[address(0x3945476E477De76d53b4833a46c806Ef3D72b21E)] = 10;
1763 	}
1764 
1765 	function updateURI(string memory newURI) public onlyOwner {
1766 		_setBaseURI(newURI);
1767 	}
1768 
1769 	modifier authorised() {
1770 		require(authorisedCaller[msg.sender] || msg.sender == owner(), "NFTBoxes: Not authorised to execute.");
1771 		_;
1772 	}
1773 
1774 	function setCaller(address _caller, bool _value) external onlyOwner {
1775 		authorisedCaller[_caller] = _value;
1776 	}
1777 
1778 	function addTeamMember(address payable _member) external onlyOwner {
1779 		for (uint256 i = 0; i < team.length; i++)
1780 			require( _member != team[i], "NFTBoxes: members exists already");
1781 		team.push(_member);
1782 	}
1783 
1784 	function removeTeamMember(address payable _member) external onlyOwner {
1785 		for (uint256 i = 0; i < team.length; i++)
1786 			if (team[i] == _member) {
1787 				delete teamShare[_member];
1788 				team[i] = team[team.length - 1];
1789 				team.pop();
1790 			}
1791 	}
1792 
1793 	function setTeamShare(address _member, uint _share) external onlyOwner {
1794 		require(_share <= TOTAL_SHARES, "NFTBoxes: share must be below 1000");
1795 		for (uint256 i = 0; i < team.length; i++)
1796 			if (team[i] == _member)
1797 				teamShare[_member] = _share;
1798 	}
1799 
1800 	function setLockOnBox(uint256 _id, bool _lock) external authorised {
1801 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1802 		lockedBoxes[_id] = _lock;
1803 	}
1804 
1805 	function createBoxMould(
1806 		uint128 _max,
1807 		uint128 _maxBuyAmount,
1808 		uint256 _price,
1809 		address payable[] memory _artists,
1810 		uint256[] memory _shares,
1811 		string memory _name,
1812 		string memory _series,
1813 		string memory _theme,
1814 		string memory _ipfsHash,
1815 		string memory _arweaveHash)
1816 		external
1817 		onlyOwner {
1818 		require(_artists.length == _shares.length, "NFTBoxes: arrays are not of same length.");
1819 		boxMoulds[boxMouldCount + 1] = BoxMould({
1820 			live: uint8(0),
1821 			shared: uint8(0),
1822 			maxEdition: _max,
1823 			maxBuyAmount: _maxBuyAmount,
1824 			currentEditionCount: 0,
1825 			price: _price,
1826 			artists: _artists,
1827 			shares: _shares,
1828 			name: _name,
1829 			series: _series,
1830 			theme: _theme,
1831 			ipfsHash: _ipfsHash,
1832 			arweaveHash: _arweaveHash
1833 		});
1834 		boxMouldCount++;
1835 		lockedBoxes[boxMouldCount] = true;
1836 		emit BoxMouldCreated(boxMouldCount);
1837 	}
1838 
1839 	function removeArtist(uint256 _id, address payable _artist) external onlyOwner {
1840 		BoxMould storage boxMould = boxMoulds[_id];
1841 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1842 		for (uint256 i = 0; i < boxMould.artists.length; i++) {
1843 			if (boxMould.artists[i] == _artist) {
1844 				boxMould.artists[i] = boxMould.artists[boxMould.artists.length - 1];
1845 				boxMould.artists.pop();
1846 				boxMould.shares[i] = boxMould.shares[boxMould.shares.length - 1];
1847 				boxMould.shares.pop();
1848 			}
1849 		}
1850 	}
1851 	
1852 	function addArtists(uint256 _id, address payable _artist, uint256 _share) external onlyOwner {
1853 		BoxMould storage boxMould = boxMoulds[_id];
1854 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1855 		boxMould.artists.push(_artist);
1856 		boxMould.shares.push(_share);
1857 	}
1858 
1859 	// dont even need this tbh?
1860 	function getArtistRoyalties(uint256 _id) external view returns (address payable[] memory artists, uint256[] memory royalties) {
1861 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1862 		BoxMould memory boxMould = boxMoulds[_id];
1863 		artists = boxMould.artists;
1864 		royalties = boxMould.shares;
1865 	}
1866 
1867 	function buyManyBoxes(uint256 _id, uint128 _quantity) external payable {
1868 		BoxMould storage boxMould = boxMoulds[_id];
1869 		uint128 currentEdition = boxMould.currentEditionCount;
1870 		uint128 max = boxMould.maxEdition;
1871 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1872 		require(!lockedBoxes[_id], "NFTBoxes: Box is locked");
1873 		require(boxMould.price.mul(_quantity) == msg.value, "NFTBoxes: Wrong total price.");
1874 		require(currentEdition + _quantity <= max, "NFTBoxes: Minting too many boxes.");
1875 		require(_quantity <= boxMould.maxBuyAmount, "NFTBoxes: Cannot buy this many boxes.");
1876 
1877 		for (uint128 i = 0; i < _quantity; i++)
1878 			_buy(currentEdition, _id, i);
1879 		boxMould.currentEditionCount += _quantity;
1880 		if (currentEdition + _quantity == max)
1881 			boxMould.live = uint8(1);
1882 	}
1883 
1884 	function _buy(uint128 _currentEdition, uint256 _id, uint256 _new) internal {
1885 		boxes[totalSupply() + 1] = Box(_id, _currentEdition + _new + 1);
1886 		//safe mint?
1887 		emit BoxBought(_id, _currentEdition + _new, totalSupply());
1888 		_mint(msg.sender, totalSupply() + 1);
1889 	}
1890 
1891 	// close a sale if not sold out
1892 	function closeBox(uint256 _id) external authorised {
1893 		BoxMould storage boxMould = boxMoulds[_id];
1894 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1895 		boxMould.live = uint8(1);
1896 	}
1897 
1898 	function setVendingMachine(address _machine) external onlyOwner {
1899 		vendingMachine = IVendingMachine(_machine);
1900 	}
1901 
1902 	function distributeOffchain(uint256 _id, address[][] calldata _recipients, uint256[] calldata _ids) external authorised {
1903 		BoxMould memory boxMould= boxMoulds[_id];
1904 		require(boxMould.live == 1, "NTFBoxes: Box is still live, cannot start distribution");
1905 		require (_recipients[0].length == _ids.length, "NFTBoxes: Wrong array size.");
1906 
1907 		// i is batch number
1908 		for (uint256 i = 0; i < _recipients.length; i++) {
1909 			// j is for the index of nft ID to send
1910 			for (uint256 j = 0;j <  _recipients[0].length; j++)
1911 				vendingMachine.NFTMachineFor(_ids[j], _recipients[i][j]);
1912 		}
1913 	}
1914 
1915 	function distributeShares(uint256 _id) external {
1916 		BoxMould storage boxMould= boxMoulds[_id];
1917 		require(_id <= boxMouldCount && _id > 0, "NFTBoxes: Mould ID does not exist.");
1918 		require(boxMould.live == 1 && boxMould.shared == 0,  "NFTBoxes: cannot distribute shares yet.");
1919 		require(is100(_id), "NFTBoxes: shares do not add up to 100%.");
1920 
1921 		boxMould.shared = 1;
1922 		uint256 rev = uint256(boxMould.currentEditionCount).mul(boxMould.price);
1923 		uint256 share;
1924 		for (uint256 i = 0; i < team.length; i++) {
1925 			share = rev.mul(teamShare[team[i]]).div(TOTAL_SHARES);
1926 			team[i].transfer(share);
1927 		}
1928 		for (uint256 i = 0; i < boxMould.artists.length; i++) {
1929 			share = rev.mul(boxMould.shares[i]).div(TOTAL_SHARES);
1930 			boxMould.artists[i].transfer(share);
1931 		}
1932 	}
1933 
1934 	function is100(uint256 _id) internal returns(bool) {
1935 		BoxMould storage boxMould= boxMoulds[_id];
1936 		uint256 total;
1937 		for (uint256 i = 0; i < team.length; i++) {
1938 			total = total.add(teamShare[team[i]]);
1939 		}
1940 		for (uint256 i = 0; i < boxMould.shares.length; i++) {
1941 			total = total.add(boxMould.shares[i]);
1942 		}
1943 		return total == TOTAL_SHARES;
1944 	}
1945 
1946 	function _getNewSeed(bytes32 _seed) public pure returns (bytes32) {
1947 		return keccak256(abi.encodePacked(_seed));
1948 	}
1949 
1950 	function getArtist(uint256 _id) external view returns (address payable[] memory) {
1951 		return boxMoulds[_id].artists;
1952 	}
1953 
1954 	function getArtistShares(uint256 _id) external view returns (uint256[] memory) {
1955 		return boxMoulds[_id].shares;
1956 	}
1957 
1958     function updateTeamAddress(address payable newTeamAddress) public onlyOwner {
1959         teamAddress = newTeamAddress;
1960     }
1961     
1962     function updateSecondaryFee(uint256 newSecondaryBps) public onlyOwner {
1963         teamSecondaryBps = newSecondaryBps;
1964     }
1965 
1966     function getBoxMetaData(uint256 _id) external view returns 
1967     (uint256 boxId, uint256 boxEdition, uint128 boxMax, string memory boxName, string memory boxSeries, string memory boxTheme, string memory boxHashIPFS, string memory boxHashArweave) {
1968         Box memory box = boxes[_id];
1969         BoxMould memory mould = boxMoulds[box.mouldId];
1970         return (box.mouldId, box.edition, mould.maxEdition, mould.name, mould.series, mould.theme, mould.ipfsHash, mould.arweaveHash);
1971     }
1972 
1973 	function _transfer(address from, address to, uint256 tokenId) internal override {
1974 		Box memory box = boxes[tokenId];
1975 		require(!lockedBoxes[box.mouldId], "NFTBoxes: Box is locked");
1976 		super._transfer(from, to, tokenId);
1977 	}
1978 }