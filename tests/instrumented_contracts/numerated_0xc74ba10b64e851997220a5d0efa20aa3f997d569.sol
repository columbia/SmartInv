1 pragma solidity ^0.6.12;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 
49 
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` representation.
57      */
58     function toString(uint256 value) internal pure returns (string memory) {
59         // Inspired by OraclizeAPI's implementation - MIT licence
60         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
61 
62         if (value == 0) {
63             return "0";
64         }
65         uint256 temp = value;
66         uint256 digits;
67         while (temp != 0) {
68             digits++;
69             temp /= 10;
70         }
71         bytes memory buffer = new bytes(digits);
72         uint256 index = digits - 1;
73         temp = value;
74         while (temp != 0) {
75             buffer[index--] = byte(uint8(48 + temp % 10));
76             temp /= 10;
77         }
78         return string(buffer);
79     }
80 }
81 
82 
83 
84 
85 
86 
87 /**
88  * @dev Implementation of the {IERC165} interface.
89  *
90  * Contracts may inherit from this and call {_registerInterface} to declare
91  * their support of an interface.
92  */
93 contract ERC165 is IERC165 {
94     /*
95      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
96      */
97     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
98 
99     /**
100      * @dev Mapping of interface ids to whether or not it's supported.
101      */
102     mapping(bytes4 => bool) private _supportedInterfaces;
103 
104     constructor () internal {
105         // Derived contracts need only register support for their own interfaces,
106         // we register support for ERC165 itself here
107         _registerInterface(_INTERFACE_ID_ERC165);
108     }
109 
110     /**
111      * @dev See {IERC165-supportsInterface}.
112      *
113      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
116         return _supportedInterfaces[interfaceId];
117     }
118 
119     /**
120      * @dev Registers the contract as an implementer of the interface defined by
121      * `interfaceId`. Support of the actual ERC165 interface is automatic and
122      * registering its interface id is not required.
123      *
124      * See {IERC165-supportsInterface}.
125      *
126      * Requirements:
127      *
128      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
129      */
130     function _registerInterface(bytes4 interfaceId) internal virtual {
131         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
132         _supportedInterfaces[interfaceId] = true;
133     }
134 }
135 
136 
137 
138 
139 
140 
141 
142 /**
143  * @dev Required interface of an ERC721 compliant contract.
144  */
145 interface IERC721 is IERC165 {
146     /**
147      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
153      */
154     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
160 
161     /**
162      * @dev Returns the number of tokens in ``owner``'s account.
163      */
164     function balanceOf(address owner) external view returns (uint256 balance);
165 
166     /**
167      * @dev Returns the owner of the `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function ownerOf(uint256 tokenId) external view returns (address owner);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(address from, address to, uint256 tokenId) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(address from, address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
209      * The approval is cleared when the token is transferred.
210      *
211      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external;
221 
222     /**
223      * @dev Returns the account approved for `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function getApproved(uint256 tokenId) external view returns (address operator);
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     /**
251       * @dev Safely transfers `tokenId` token from `from` to `to`.
252       *
253       * Requirements:
254       *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257       * - `tokenId` token must exist and be owned by `from`.
258       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260       *
261       * Emits a {Transfer} event.
262       */
263     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
264 }
265 
266 
267 
268 
269 
270 
271 
272 /**
273  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
274  * @dev See https://eips.ethereum.org/EIPS/eip-721
275  */
276 interface IERC721Metadata is IERC721 {
277 
278     /**
279      * @dev Returns the token collection name.
280      */
281     function name() external view returns (string memory);
282 
283     /**
284      * @dev Returns the token collection symbol.
285      */
286     function symbol() external view returns (string memory);
287 
288     /**
289      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
290      */
291     function tokenURI(uint256 tokenId) external view returns (string memory);
292 }
293 
294 
295 
296 
297 
298 
299 
300 /**
301  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
302  * @dev See https://eips.ethereum.org/EIPS/eip-721
303  */
304 interface IERC721Enumerable is IERC721 {
305 
306     /**
307      * @dev Returns the total amount of tokens stored by the contract.
308      */
309     function totalSupply() external view returns (uint256);
310 
311     /**
312      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
313      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
314      */
315     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
316 
317     /**
318      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
319      * Use along with {totalSupply} to enumerate all tokens.
320      */
321     function tokenByIndex(uint256 index) external view returns (uint256);
322 }
323 
324 
325 
326 
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
342      */
343     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
344     external returns (bytes4);
345 }
346 
347 
348 
349 
350 
351 
352 /**
353  * @dev Wrappers over Solidity's arithmetic operations with added overflow
354  * checks.
355  *
356  * Arithmetic operations in Solidity wrap on overflow. This can easily result
357  * in bugs, because programmers usually assume that an overflow raises an
358  * error, which is the standard behavior in high level programming languages.
359  * `SafeMath` restores this intuition by reverting the transaction when an
360  * operation overflows.
361  *
362  * Using this library instead of the unchecked operations eliminates an entire
363  * class of bugs, so it's recommended to use it always.
364  */
365 library SafeMath {
366     /**
367      * @dev Returns the addition of two unsigned integers, reverting on
368      * overflow.
369      *
370      * Counterpart to Solidity's `+` operator.
371      *
372      * Requirements:
373      *
374      * - Addition cannot overflow.
375      */
376     function add(uint256 a, uint256 b) internal pure returns (uint256) {
377         uint256 c = a + b;
378         require(c >= a, "SafeMath: addition overflow");
379 
380         return c;
381     }
382 
383     /**
384      * @dev Returns the subtraction of two unsigned integers, reverting on
385      * overflow (when the result is negative).
386      *
387      * Counterpart to Solidity's `-` operator.
388      *
389      * Requirements:
390      *
391      * - Subtraction cannot overflow.
392      */
393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394         return sub(a, b, "SafeMath: subtraction overflow");
395     }
396 
397     /**
398      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
399      * overflow (when the result is negative).
400      *
401      * Counterpart to Solidity's `-` operator.
402      *
403      * Requirements:
404      *
405      * - Subtraction cannot overflow.
406      */
407     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
408         require(b <= a, errorMessage);
409         uint256 c = a - b;
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `*` operator.
419      *
420      * Requirements:
421      *
422      * - Multiplication cannot overflow.
423      */
424     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
425         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
426         // benefit is lost if 'b' is also tested.
427         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
428         if (a == 0) {
429             return 0;
430         }
431 
432         uint256 c = a * b;
433         require(c / a == b, "SafeMath: multiplication overflow");
434 
435         return c;
436     }
437 
438     /**
439      * @dev Returns the integer division of two unsigned integers. Reverts on
440      * division by zero. The result is rounded towards zero.
441      *
442      * Counterpart to Solidity's `/` operator. Note: this function uses a
443      * `revert` opcode (which leaves remaining gas untouched) while Solidity
444      * uses an invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function div(uint256 a, uint256 b) internal pure returns (uint256) {
451         return div(a, b, "SafeMath: division by zero");
452     }
453 
454     /**
455      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
456      * division by zero. The result is rounded towards zero.
457      *
458      * Counterpart to Solidity's `/` operator. Note: this function uses a
459      * `revert` opcode (which leaves remaining gas untouched) while Solidity
460      * uses an invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
467         require(b > 0, errorMessage);
468         uint256 c = a / b;
469         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
476      * Reverts when dividing by zero.
477      *
478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
479      * opcode (which leaves remaining gas untouched) while Solidity uses an
480      * invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
487         return mod(a, b, "SafeMath: modulo by zero");
488     }
489 
490     /**
491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492      * Reverts with custom message when dividing by zero.
493      *
494      * Counterpart to Solidity's `%` operator. This function uses a `revert`
495      * opcode (which leaves remaining gas untouched) while Solidity uses an
496      * invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b != 0, errorMessage);
504         return a % b;
505     }
506 }
507 
508 
509 
510 
511 
512 /**
513  * @dev Collection of functions related to the address type
514  */
515 library Address {
516     /**
517      * @dev Returns true if `account` is a contract.
518      *
519      * [IMPORTANT]
520      * ====
521      * It is unsafe to assume that an address for which this function returns
522      * false is an externally-owned account (EOA) and not a contract.
523      *
524      * Among others, `isContract` will return false for the following
525      * types of addresses:
526      *
527      *  - an externally-owned account
528      *  - a contract in construction
529      *  - an address where a contract will be created
530      *  - an address where a contract lived, but was destroyed
531      * ====
532      */
533     function isContract(address account) internal view returns (bool) {
534         // This method relies in extcodesize, which returns 0 for contracts in
535         // construction, since the code is only stored at the end of the
536         // constructor execution.
537 
538         uint256 size;
539         // solhint-disable-next-line no-inline-assembly
540         assembly { size := extcodesize(account) }
541         return size > 0;
542     }
543 
544     /**
545      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
546      * `recipient`, forwarding all available gas and reverting on errors.
547      *
548      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
549      * of certain opcodes, possibly making contracts go over the 2300 gas limit
550      * imposed by `transfer`, making them unable to receive funds via
551      * `transfer`. {sendValue} removes this limitation.
552      *
553      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
554      *
555      * IMPORTANT: because control is transferred to `recipient`, care must be
556      * taken to not create reentrancy vulnerabilities. Consider using
557      * {ReentrancyGuard} or the
558      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
559      */
560     function sendValue(address payable recipient, uint256 amount) internal {
561         require(address(this).balance >= amount, "Address: insufficient balance");
562 
563         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
564         (bool success, ) = recipient.call{ value: amount }("");
565         require(success, "Address: unable to send value, recipient may have reverted");
566     }
567 
568     /**
569      * @dev Performs a Solidity function call using a low level `call`. A
570      * plain`call` is an unsafe replacement for a function call: use this
571      * function instead.
572      *
573      * If `target` reverts with a revert reason, it is bubbled up by this
574      * function (like regular Solidity function calls).
575      *
576      * Returns the raw returned data. To convert to the expected return value,
577      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
578      *
579      * Requirements:
580      *
581      * - `target` must be a contract.
582      * - calling `target` with `data` must not revert.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
587       return functionCall(target, data, "Address: low-level call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
592      * `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
597         return _functionCallWithValue(target, data, 0, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but also transferring `value` wei to `target`.
603      *
604      * Requirements:
605      *
606      * - the calling contract must have an ETH balance of at least `value`.
607      * - the called Solidity function must be `payable`.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
612         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
617      * with `errorMessage` as a fallback revert reason when `target` reverts.
618      *
619      * _Available since v3.1._
620      */
621     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
622         require(address(this).balance >= value, "Address: insufficient balance for call");
623         return _functionCallWithValue(target, data, value, errorMessage);
624     }
625 
626     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
627         require(isContract(target), "Address: call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
631         if (success) {
632             return returndata;
633         } else {
634             // Look for revert reason and bubble it up if present
635             if (returndata.length > 0) {
636                 // The easiest way to bubble the revert reason is using memory via assembly
637 
638                 // solhint-disable-next-line no-inline-assembly
639                 assembly {
640                     let returndata_size := mload(returndata)
641                     revert(add(32, returndata), returndata_size)
642                 }
643             } else {
644                 revert(errorMessage);
645             }
646         }
647     }
648 }
649 
650 
651 
652 
653 
654 /**
655  * @dev Library for managing
656  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
657  * types.
658  *
659  * Sets have the following properties:
660  *
661  * - Elements are added, removed, and checked for existence in constant time
662  * (O(1)).
663  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
664  *
665  * ```
666  * contract Example {
667  *     // Add the library methods
668  *     using EnumerableSet for EnumerableSet.AddressSet;
669  *
670  *     // Declare a set state variable
671  *     EnumerableSet.AddressSet private mySet;
672  * }
673  * ```
674  *
675  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
676  * (`UintSet`) are supported.
677  */
678 library EnumerableSet {
679     // To implement this library for multiple types with as little code
680     // repetition as possible, we write it in terms of a generic Set type with
681     // bytes32 values.
682     // The Set implementation uses private functions, and user-facing
683     // implementations (such as AddressSet) are just wrappers around the
684     // underlying Set.
685     // This means that we can only create new EnumerableSets for types that fit
686     // in bytes32.
687 
688     struct Set {
689         // Storage of set values
690         bytes32[] _values;
691 
692         // Position of the value in the `values` array, plus 1 because index 0
693         // means a value is not in the set.
694         mapping (bytes32 => uint256) _indexes;
695     }
696 
697     /**
698      * @dev Add a value to a set. O(1).
699      *
700      * Returns true if the value was added to the set, that is if it was not
701      * already present.
702      */
703     function _add(Set storage set, bytes32 value) private returns (bool) {
704         if (!_contains(set, value)) {
705             set._values.push(value);
706             // The value is stored at length-1, but we add 1 to all indexes
707             // and use 0 as a sentinel value
708             set._indexes[value] = set._values.length;
709             return true;
710         } else {
711             return false;
712         }
713     }
714 
715     /**
716      * @dev Removes a value from a set. O(1).
717      *
718      * Returns true if the value was removed from the set, that is if it was
719      * present.
720      */
721     function _remove(Set storage set, bytes32 value) private returns (bool) {
722         // We read and store the value's index to prevent multiple reads from the same storage slot
723         uint256 valueIndex = set._indexes[value];
724 
725         if (valueIndex != 0) { // Equivalent to contains(set, value)
726             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
727             // the array, and then remove the last element (sometimes called as 'swap and pop').
728             // This modifies the order of the array, as noted in {at}.
729 
730             uint256 toDeleteIndex = valueIndex - 1;
731             uint256 lastIndex = set._values.length - 1;
732 
733             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
734             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
735 
736             bytes32 lastvalue = set._values[lastIndex];
737 
738             // Move the last value to the index where the value to delete is
739             set._values[toDeleteIndex] = lastvalue;
740             // Update the index for the moved value
741             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
742 
743             // Delete the slot where the moved value was stored
744             set._values.pop();
745 
746             // Delete the index for the deleted slot
747             delete set._indexes[value];
748 
749             return true;
750         } else {
751             return false;
752         }
753     }
754 
755     /**
756      * @dev Returns true if the value is in the set. O(1).
757      */
758     function _contains(Set storage set, bytes32 value) private view returns (bool) {
759         return set._indexes[value] != 0;
760     }
761 
762     /**
763      * @dev Returns the number of values on the set. O(1).
764      */
765     function _length(Set storage set) private view returns (uint256) {
766         return set._values.length;
767     }
768 
769    /**
770     * @dev Returns the value stored at position `index` in the set. O(1).
771     *
772     * Note that there are no guarantees on the ordering of values inside the
773     * array, and it may change when more values are added or removed.
774     *
775     * Requirements:
776     *
777     * - `index` must be strictly less than {length}.
778     */
779     function _at(Set storage set, uint256 index) private view returns (bytes32) {
780         require(set._values.length > index, "EnumerableSet: index out of bounds");
781         return set._values[index];
782     }
783 
784     // AddressSet
785 
786     struct AddressSet {
787         Set _inner;
788     }
789 
790     /**
791      * @dev Add a value to a set. O(1).
792      *
793      * Returns true if the value was added to the set, that is if it was not
794      * already present.
795      */
796     function add(AddressSet storage set, address value) internal returns (bool) {
797         return _add(set._inner, bytes32(uint256(value)));
798     }
799 
800     /**
801      * @dev Removes a value from a set. O(1).
802      *
803      * Returns true if the value was removed from the set, that is if it was
804      * present.
805      */
806     function remove(AddressSet storage set, address value) internal returns (bool) {
807         return _remove(set._inner, bytes32(uint256(value)));
808     }
809 
810     /**
811      * @dev Returns true if the value is in the set. O(1).
812      */
813     function contains(AddressSet storage set, address value) internal view returns (bool) {
814         return _contains(set._inner, bytes32(uint256(value)));
815     }
816 
817     /**
818      * @dev Returns the number of values in the set. O(1).
819      */
820     function length(AddressSet storage set) internal view returns (uint256) {
821         return _length(set._inner);
822     }
823 
824    /**
825     * @dev Returns the value stored at position `index` in the set. O(1).
826     *
827     * Note that there are no guarantees on the ordering of values inside the
828     * array, and it may change when more values are added or removed.
829     *
830     * Requirements:
831     *
832     * - `index` must be strictly less than {length}.
833     */
834     function at(AddressSet storage set, uint256 index) internal view returns (address) {
835         return address(uint256(_at(set._inner, index)));
836     }
837 
838 
839     // UintSet
840 
841     struct UintSet {
842         Set _inner;
843     }
844 
845     /**
846      * @dev Add a value to a set. O(1).
847      *
848      * Returns true if the value was added to the set, that is if it was not
849      * already present.
850      */
851     function add(UintSet storage set, uint256 value) internal returns (bool) {
852         return _add(set._inner, bytes32(value));
853     }
854 
855     /**
856      * @dev Removes a value from a set. O(1).
857      *
858      * Returns true if the value was removed from the set, that is if it was
859      * present.
860      */
861     function remove(UintSet storage set, uint256 value) internal returns (bool) {
862         return _remove(set._inner, bytes32(value));
863     }
864 
865     /**
866      * @dev Returns true if the value is in the set. O(1).
867      */
868     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
869         return _contains(set._inner, bytes32(value));
870     }
871 
872     /**
873      * @dev Returns the number of values on the set. O(1).
874      */
875     function length(UintSet storage set) internal view returns (uint256) {
876         return _length(set._inner);
877     }
878 
879    /**
880     * @dev Returns the value stored at position `index` in the set. O(1).
881     *
882     * Note that there are no guarantees on the ordering of values inside the
883     * array, and it may change when more values are added or removed.
884     *
885     * Requirements:
886     *
887     * - `index` must be strictly less than {length}.
888     */
889     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
890         return uint256(_at(set._inner, index));
891     }
892 }
893 
894 
895 
896 
897 
898 /**
899  * @dev Library for managing an enumerable variant of Solidity's
900  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
901  * type.
902  *
903  * Maps have the following properties:
904  *
905  * - Entries are added, removed, and checked for existence in constant time
906  * (O(1)).
907  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
908  *
909  * ```
910  * contract Example {
911  *     // Add the library methods
912  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
913  *
914  *     // Declare a set state variable
915  *     EnumerableMap.UintToAddressMap private myMap;
916  * }
917  * ```
918  *
919  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
920  * supported.
921  */
922 library EnumerableMap {
923     // To implement this library for multiple types with as little code
924     // repetition as possible, we write it in terms of a generic Map type with
925     // bytes32 keys and values.
926     // The Map implementation uses private functions, and user-facing
927     // implementations (such as Uint256ToAddressMap) are just wrappers around
928     // the underlying Map.
929     // This means that we can only create new EnumerableMaps for types that fit
930     // in bytes32.
931 
932     struct MapEntry {
933         bytes32 _key;
934         bytes32 _value;
935     }
936 
937     struct Map {
938         // Storage of map keys and values
939         MapEntry[] _entries;
940 
941         // Position of the entry defined by a key in the `entries` array, plus 1
942         // because index 0 means a key is not in the map.
943         mapping (bytes32 => uint256) _indexes;
944     }
945 
946     /**
947      * @dev Adds a key-value pair to a map, or updates the value for an existing
948      * key. O(1).
949      *
950      * Returns true if the key was added to the map, that is if it was not
951      * already present.
952      */
953     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
954         // We read and store the key's index to prevent multiple reads from the same storage slot
955         uint256 keyIndex = map._indexes[key];
956 
957         if (keyIndex == 0) { // Equivalent to !contains(map, key)
958             map._entries.push(MapEntry({ _key: key, _value: value }));
959             // The entry is stored at length-1, but we add 1 to all indexes
960             // and use 0 as a sentinel value
961             map._indexes[key] = map._entries.length;
962             return true;
963         } else {
964             map._entries[keyIndex - 1]._value = value;
965             return false;
966         }
967     }
968 
969     /**
970      * @dev Removes a key-value pair from a map. O(1).
971      *
972      * Returns true if the key was removed from the map, that is if it was present.
973      */
974     function _remove(Map storage map, bytes32 key) private returns (bool) {
975         // We read and store the key's index to prevent multiple reads from the same storage slot
976         uint256 keyIndex = map._indexes[key];
977 
978         if (keyIndex != 0) { // Equivalent to contains(map, key)
979             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
980             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
981             // This modifies the order of the array, as noted in {at}.
982 
983             uint256 toDeleteIndex = keyIndex - 1;
984             uint256 lastIndex = map._entries.length - 1;
985 
986             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
987             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
988 
989             MapEntry storage lastEntry = map._entries[lastIndex];
990 
991             // Move the last entry to the index where the entry to delete is
992             map._entries[toDeleteIndex] = lastEntry;
993             // Update the index for the moved entry
994             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
995 
996             // Delete the slot where the moved entry was stored
997             map._entries.pop();
998 
999             // Delete the index for the deleted slot
1000             delete map._indexes[key];
1001 
1002             return true;
1003         } else {
1004             return false;
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns true if the key is in the map. O(1).
1010      */
1011     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1012         return map._indexes[key] != 0;
1013     }
1014 
1015     /**
1016      * @dev Returns the number of key-value pairs in the map. O(1).
1017      */
1018     function _length(Map storage map) private view returns (uint256) {
1019         return map._entries.length;
1020     }
1021 
1022    /**
1023     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1024     *
1025     * Note that there are no guarantees on the ordering of entries inside the
1026     * array, and it may change when more entries are added or removed.
1027     *
1028     * Requirements:
1029     *
1030     * - `index` must be strictly less than {length}.
1031     */
1032     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1033         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1034 
1035         MapEntry storage entry = map._entries[index];
1036         return (entry._key, entry._value);
1037     }
1038 
1039     /**
1040      * @dev Returns the value associated with `key`.  O(1).
1041      *
1042      * Requirements:
1043      *
1044      * - `key` must be in the map.
1045      */
1046     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1047         return _get(map, key, "EnumerableMap: nonexistent key");
1048     }
1049 
1050     /**
1051      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1052      */
1053     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1054         uint256 keyIndex = map._indexes[key];
1055         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1056         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1057     }
1058 
1059     // UintToAddressMap
1060 
1061     struct UintToAddressMap {
1062         Map _inner;
1063     }
1064 
1065     /**
1066      * @dev Adds a key-value pair to a map, or updates the value for an existing
1067      * key. O(1).
1068      *
1069      * Returns true if the key was added to the map, that is if it was not
1070      * already present.
1071      */
1072     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1073         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1074     }
1075 
1076     /**
1077      * @dev Removes a value from a set. O(1).
1078      *
1079      * Returns true if the key was removed from the map, that is if it was present.
1080      */
1081     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1082         return _remove(map._inner, bytes32(key));
1083     }
1084 
1085     /**
1086      * @dev Returns true if the key is in the map. O(1).
1087      */
1088     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1089         return _contains(map._inner, bytes32(key));
1090     }
1091 
1092     /**
1093      * @dev Returns the number of elements in the map. O(1).
1094      */
1095     function length(UintToAddressMap storage map) internal view returns (uint256) {
1096         return _length(map._inner);
1097     }
1098 
1099    /**
1100     * @dev Returns the element stored at position `index` in the set. O(1).
1101     * Note that there are no guarantees on the ordering of values inside the
1102     * array, and it may change when more values are added or removed.
1103     *
1104     * Requirements:
1105     *
1106     * - `index` must be strictly less than {length}.
1107     */
1108     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1109         (bytes32 key, bytes32 value) = _at(map._inner, index);
1110         return (uint256(key), address(uint256(value)));
1111     }
1112 
1113     /**
1114      * @dev Returns the value associated with `key`.  O(1).
1115      *
1116      * Requirements:
1117      *
1118      * - `key` must be in the map.
1119      */
1120     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1121         return address(uint256(_get(map._inner, bytes32(key))));
1122     }
1123 
1124     /**
1125      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1126      */
1127     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1128         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1129     }
1130 }
1131 
1132 
1133 
1134 /**
1135  * @title ERC721 Non-Fungible Token Standard basic implementation
1136  * @dev see https://eips.ethereum.org/EIPS/eip-721
1137  */
1138 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1139     using SafeMath for uint256;
1140     using Address for address;
1141     using EnumerableSet for EnumerableSet.UintSet;
1142     using EnumerableMap for EnumerableMap.UintToAddressMap;
1143     using Strings for uint256;
1144 
1145     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1146     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1147     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1148 
1149     // Mapping from holder address to their (enumerable) set of owned tokens
1150     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1151 
1152     // Enumerable mapping from token ids to their owners
1153     EnumerableMap.UintToAddressMap private _tokenOwners;
1154 
1155     // Mapping from token ID to approved address
1156     mapping (uint256 => address) private _tokenApprovals;
1157 
1158     // Mapping from owner to operator approvals
1159     mapping (address => mapping (address => bool)) private _operatorApprovals;
1160 
1161     // Token name
1162     string private _name;
1163 
1164     // Token symbol
1165     string private _symbol;
1166 
1167     // Optional mapping for token URIs
1168     mapping (uint256 => string) private _tokenURIs;
1169 
1170     // Base URI
1171     string private _baseURI;
1172 
1173     /*
1174      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1175      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1176      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1177      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1178      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1179      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1180      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1181      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1182      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1183      *
1184      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1185      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1186      */
1187     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1188 
1189     /*
1190      *     bytes4(keccak256('name()')) == 0x06fdde03
1191      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1192      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1193      *
1194      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1195      */
1196     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1197 
1198     /*
1199      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1200      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1201      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1202      *
1203      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1204      */
1205     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1206 
1207     /**
1208      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1209      */
1210     constructor (string memory name, string memory symbol) public {
1211         _name = name;
1212         _symbol = symbol;
1213 
1214         // register the supported interfaces to conform to ERC721 via ERC165
1215         _registerInterface(_INTERFACE_ID_ERC721);
1216         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1217         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-balanceOf}.
1222      */
1223     function balanceOf(address owner) public view override returns (uint256) {
1224         require(owner != address(0), "ERC721: balance query for the zero address");
1225 
1226         return _holderTokens[owner].length();
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-ownerOf}.
1231      */
1232     function ownerOf(uint256 tokenId) public view override returns (address) {
1233         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Metadata-name}.
1238      */
1239     function name() public view override returns (string memory) {
1240         return _name;
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Metadata-symbol}.
1245      */
1246     function symbol() public view override returns (string memory) {
1247         return _symbol;
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Metadata-tokenURI}.
1252      */
1253     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1254         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1255 
1256         string memory _tokenURI = _tokenURIs[tokenId];
1257 
1258         // If there is no base URI, return the token URI.
1259         if (bytes(_baseURI).length == 0) {
1260             return _tokenURI;
1261         }
1262         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1263         if (bytes(_tokenURI).length > 0) {
1264             return string(abi.encodePacked(_baseURI, _tokenURI));
1265         }
1266         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1267         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1268         
1269     }
1270 
1271     /**
1272     * @dev Returns the base URI set via {_setBaseURI}. This will be
1273     * automatically added as a prefix in {tokenURI} to each token's URI, or
1274     * to the token ID if no specific URI is set for that token ID.
1275     */
1276     function baseURI() public view returns (string memory) {
1277         return _baseURI;
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1282      */
1283     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1284         return _holderTokens[owner].at(index);
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Enumerable-totalSupply}.
1289      */
1290     function totalSupply() public view override returns (uint256) {
1291         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1292         return _tokenOwners.length();
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Enumerable-tokenByIndex}.
1297      */
1298     function tokenByIndex(uint256 index) public view override returns (uint256) {
1299         (uint256 tokenId, ) = _tokenOwners.at(index);
1300         return tokenId;
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-approve}.
1305      */
1306     function approve(address to, uint256 tokenId) public virtual override {
1307         address owner = ownerOf(tokenId);
1308         require(to != owner, "ERC721: approval to current owner");
1309 
1310         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1311             "ERC721: approve caller is not owner nor approved for all"
1312         );
1313 
1314         _approve(to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-getApproved}.
1319      */
1320     function getApproved(uint256 tokenId) public view override returns (address) {
1321         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1322 
1323         return _tokenApprovals[tokenId];
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-setApprovalForAll}.
1328      */
1329     function setApprovalForAll(address operator, bool approved) public virtual override {
1330         require(operator != _msgSender(), "ERC721: approve to caller");
1331 
1332         _operatorApprovals[_msgSender()][operator] = approved;
1333         emit ApprovalForAll(_msgSender(), operator, approved);
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-isApprovedForAll}.
1338      */
1339     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1340         return _operatorApprovals[owner][operator];
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-transferFrom}.
1345      */
1346     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1347         //solhint-disable-next-line max-line-length
1348         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1349         
1350         _transfer(from, to, tokenId);
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-safeTransferFrom}.
1355      */
1356     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1357         safeTransferFrom(from, to, tokenId, "");
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-safeTransferFrom}.
1362      */
1363     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1364         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1365         _safeTransfer(from, to, tokenId, _data);
1366     }
1367 
1368     /**
1369      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1370      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1371      *
1372      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1373      *
1374      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1375      * implement alternative mechanisms to perform token transfer, such as signature-based.
1376      *
1377      * Requirements:
1378      *
1379      * - `from` cannot be the zero address.
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must exist and be owned by `from`.
1382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1387         _transfer(from, to, tokenId);
1388         
1389         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1390     }
1391 
1392     /**
1393      * @dev Returns whether `tokenId` exists.
1394      *
1395      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1396      *
1397      * Tokens start existing when they are minted (`_mint`),
1398      * and stop existing when they are burned (`_burn`).
1399      */
1400     function _exists(uint256 tokenId) internal view returns (bool) {
1401         return _tokenOwners.contains(tokenId);
1402     }
1403 
1404     /**
1405      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      */
1411     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1412         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1413         address owner = ownerOf(tokenId);
1414         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1415     }
1416 
1417     /**
1418      * @dev Safely mints `tokenId` and transfers it to `to`.
1419      *
1420      * Requirements:
1421      d*
1422      * - `tokenId` must not exist.
1423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function _safeMint(address to, uint256 tokenId) internal virtual {
1428         _safeMint(to, tokenId, "");
1429     }
1430 
1431     /**
1432      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1433      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1434      */
1435     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1436         _mint(to, tokenId);
1437         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1438     }
1439 
1440     /**
1441      * @dev Mints `tokenId` and transfers it to `to`.
1442      *
1443      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1444      *
1445      * Requirements:
1446      *
1447      * - `tokenId` must not exist.
1448      * - `to` cannot be the zero address.
1449      *
1450      * Emits a {Transfer} event.
1451      */
1452     function _mint(address to, uint256 tokenId) internal virtual {
1453         require(to != address(0), "ERC721: mint to the zero address");
1454         require(!_exists(tokenId), "ERC721: token already minted");
1455 
1456         _beforeTokenTransfer(address(0), to, tokenId);
1457 
1458         _holderTokens[to].add(tokenId);
1459 
1460         _tokenOwners.set(tokenId, to);
1461 
1462         emit Transfer(address(0), to, tokenId);
1463     }
1464 
1465     /**
1466      * @dev Destroys `tokenId`.
1467      * The approval is cleared when the token is burned.
1468      *
1469      * Requirements:
1470      *
1471      * - `tokenId` must exist.
1472      *
1473      * Emits a {Transfer} event.
1474      */
1475     function _burn(uint256 tokenId) internal virtual {
1476         address owner = ownerOf(tokenId);
1477 
1478         _beforeTokenTransfer(owner, address(0), tokenId);
1479 
1480         // Clear approvals
1481         _approve(address(0), tokenId);
1482 
1483         // Clear metadata (if any)
1484         if (bytes(_tokenURIs[tokenId]).length != 0) {
1485             delete _tokenURIs[tokenId];
1486         }
1487 
1488         _holderTokens[owner].remove(tokenId);
1489 
1490         _tokenOwners.remove(tokenId);
1491 
1492         emit Transfer(owner, address(0), tokenId);
1493     }
1494 
1495     mapping (uint256 => uint256) internal decayState;
1496     
1497     function updateDecayState(uint256 tokenId) internal {
1498         decayState[tokenId] = decayState[tokenId] + 1;
1499     }
1500 
1501     /**
1502      * @dev Transfers `tokenId` from `from` to `to`.
1503      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1504      *
1505      * Requirements:
1506      *
1507      * - `to` cannot be the zero address.
1508      * - `tokenId` token must be owned by `from`.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1513         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1514         require(to != address(0), "ERC721: transfer to the zero address");
1515 
1516         _beforeTokenTransfer(from, to, tokenId);
1517 
1518         // Clear approvals from the previous owner
1519         _approve(address(0), tokenId);
1520 
1521         _holderTokens[from].remove(tokenId);
1522         _holderTokens[to].add(tokenId);
1523 
1524         _tokenOwners.set(tokenId, to);
1525         
1526         updateDecayState(tokenId);
1527 
1528         emit Transfer(from, to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must exist.
1537      */
1538     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1539         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1540         _tokenURIs[tokenId] = _tokenURI;
1541     }
1542 
1543     /**
1544      * @dev Internal function to set the base URI for all token IDs. It is
1545      * automatically added as a prefix to the value returned in {tokenURI},
1546      * or to the token ID if {tokenURI} is empty.
1547      */
1548     function _setBaseURI(string memory baseURI_) internal virtual {
1549         _baseURI = baseURI_;
1550     }
1551 
1552     /**
1553      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1554      * The call is not executed if the target address is not a contract.
1555      *
1556      * @param from address representing the previous owner of the given token ID
1557      * @param to target address that will receive the tokens
1558      * @param tokenId uint256 ID of the token to be transferred
1559      * @param _data bytes optional data to send along with the call
1560      * @return bool whether the call correctly returned the expected magic value
1561      */
1562     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1563         private returns (bool)
1564     {
1565         if (!to.isContract()) {
1566             return true;
1567         }
1568         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1569             IERC721Receiver(to).onERC721Received.selector,
1570             _msgSender(),
1571             from,
1572             tokenId,
1573             _data
1574         ), "ERC721: transfer to non ERC721Receiver implementer");
1575         bytes4 retval = abi.decode(returndata, (bytes4));
1576         return (retval == _ERC721_RECEIVED);
1577     }
1578 
1579     function _approve(address to, uint256 tokenId) private {
1580         _tokenApprovals[tokenId] = to;
1581         emit Approval(ownerOf(tokenId), to, tokenId);
1582     }
1583 
1584     /**
1585      * @dev Hook that is called before any token transfer. This includes minting
1586      * and burning.
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1594      * - `from` cannot be the zero address.
1595      * - `to` cannot be the zero address.
1596      *
1597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1598      */
1599     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1600 }
1601 
1602 
1603 
1604 
1605 
1606 
1607 
1608 /**
1609  * @dev Contract module which provides a basic access control mechanism, where
1610  * there is an account (an owner) that can be granted exclusive access to
1611  * specific functions.
1612  *
1613  * By default, the owner account will be the one that deploys the contract. This
1614  * can later be changed with {transferOwnership}.
1615  *
1616  * This module is used through inheritance. It will make available the modifier
1617  * `onlyOwner`, which can be applied to your functions to restrict their use to
1618  * the owner.
1619  */
1620 contract Ownable is Context {
1621     address private _owner;
1622 
1623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1624 
1625     /**
1626      * @dev Initializes the contract setting the deployer as the initial owner.
1627      */
1628     constructor () internal {
1629         address msgSender = _msgSender();
1630         _owner = msgSender;
1631         emit OwnershipTransferred(address(0), msgSender);
1632     }
1633 
1634     /**
1635      * @dev Returns the address of the current owner.
1636      */
1637     function owner() public view returns (address) {
1638         return _owner;
1639     }
1640 
1641     /**
1642      * @dev Throws if called by any account other than the owner.
1643      */
1644     modifier onlyOwner() {
1645         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1646         _;
1647     }
1648 
1649     /**
1650      * @dev Leaves the contract without owner. It will not be possible to call
1651      * `onlyOwner` functions anymore. Can only be called by the current owner.
1652      *
1653      * NOTE: Renouncing ownership will leave the contract without an owner,
1654      * thereby removing any functionality that is only available to the owner.
1655      */
1656     function renounceOwnership() public virtual onlyOwner {
1657         emit OwnershipTransferred(_owner, address(0));
1658         _owner = address(0);
1659     }
1660 
1661     /**
1662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1663      * Can only be called by the current owner.
1664      */
1665     function transferOwnership(address newOwner) public virtual onlyOwner {
1666         require(newOwner != address(0), "Ownable: new owner is the zero address");
1667         emit OwnershipTransferred(_owner, newOwner);
1668         _owner = newOwner;
1669     }
1670 }
1671 
1672 
1673 contract CompletelyPointlessNFT is ERC721, Ownable {
1674     using SafeMath for uint256;
1675     
1676     string public metadataURL;
1677     uint256 totalNFTs;
1678     
1679     mapping (address => bool) internal claimedNFT;
1680     mapping (uint256 => address) internal publicAddress;
1681 
1682     constructor() ERC721("Completely Pointless NFT", "WHY") public {
1683         updateURL("https://pointlessNFT.azurewebsites.net/api/HttpTrigger?id=");
1684         totalNFTs = 1;
1685     }
1686     
1687     function mintPointlessNFT() public payable {
1688         require(claimedNFT[msg.sender] == false);
1689         require(totalNFTs <= 969);
1690         require(msg.value == 42069000000000000);
1691         
1692         claimedNFT[msg.sender] = true;
1693         publicAddress[totalNFTs] = msg.sender;
1694         
1695         _mint(msg.sender, totalNFTs);
1696         payable(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3).transfer(msg.value);
1697                 
1698         totalNFTs = totalNFTs + 1;
1699     }
1700     
1701     function getDecayState(uint256 tokenID) public view returns (uint256 currentState) {
1702         currentState = decayState[tokenID];
1703     }
1704     
1705     function getTokenToAddress(uint256 tokenID) public view returns (address currentOwner, address claimAddress) {
1706         currentOwner = ownerOf(tokenID);
1707         claimAddress = publicAddress[tokenID];
1708     }
1709     
1710     function updateURL(string memory newURL) public onlyOwner {
1711         _setBaseURI(newURL);
1712     }
1713    
1714 }