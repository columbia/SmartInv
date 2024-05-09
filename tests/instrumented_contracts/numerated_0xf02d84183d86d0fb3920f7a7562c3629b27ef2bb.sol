1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 //pragma solidity ^0.6.2;
6 pragma solidity ^0.6.12;
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
29 
30 
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
54 
55 
56 
57 /**
58  * @dev Required interface of an ERC721 compliant contract.
59  */
60 interface IERC721 is IERC165 {
61     /**
62      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
68      */
69     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
73      */
74     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
75 
76     /**
77      * @dev Returns the number of tokens in ``owner``'s account.
78      */
79     function balanceOf(address owner) external view returns (uint256 balance);
80 
81     /**
82      * @dev Returns the owner of the `tokenId` token.
83      *
84      * Requirements:
85      *
86      * - `tokenId` must exist.
87      */
88     function ownerOf(uint256 tokenId) external view returns (address owner);
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(address from, address to, uint256 tokenId) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address from, address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId) external view returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator) external view returns (bool);
164 
165     /**
166       * @dev Safely transfers `tokenId` token from `from` to `to`.
167       *
168       * Requirements:
169       *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172       * - `tokenId` token must exist and be owned by `from`.
173       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175       *
176       * Emits a {Transfer} event.
177       */
178     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
179 }
180 
181 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
182 
183 
184 
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Metadata is IERC721 {
190 
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Enumerable.sol
208 
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Enumerable is IERC721 {
216 
217     /**
218      * @dev Returns the total amount of tokens stored by the contract.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
224      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
225      */
226     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
227 
228     /**
229      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
230      * Use along with {totalSupply} to enumerate all tokens.
231      */
232     function tokenByIndex(uint256 index) external view returns (uint256);
233 }
234 
235 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
236 
237 
238 /**
239  * @title ERC721 token receiver interface
240  * @dev Interface for any contract that wants to support safeTransfers
241  * from ERC721 asset contracts.
242  */
243 interface IERC721Receiver {
244     /**
245      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
246      * by `operator` from `from`, this function is called.
247      *
248      * It must return its Solidity selector to confirm the token transfer.
249      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
250      *
251      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
252      */
253     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
254     external returns (bytes4);
255 }
256 
257 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
258 
259 
260 
261 /**
262  * @dev Implementation of the {IERC165} interface.
263  *
264  * Contracts may inherit from this and call {_registerInterface} to declare
265  * their support of an interface.
266  */
267 contract ERC165 is IERC165 {
268     /*
269      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
270      */
271     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
272 
273     /**
274      * @dev Mapping of interface ids to whether or not it's supported.
275      */
276     mapping(bytes4 => bool) private _supportedInterfaces;
277 
278     constructor () internal {
279         // Derived contracts need only register support for their own interfaces,
280         // we register support for ERC165 itself here
281         _registerInterface(_INTERFACE_ID_ERC165);
282     }
283 
284     /**
285      * @dev See {IERC165-supportsInterface}.
286      *
287      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
290         return _supportedInterfaces[interfaceId];
291     }
292 
293     /**
294      * @dev Registers the contract as an implementer of the interface defined by
295      * `interfaceId`. Support of the actual ERC165 interface is automatic and
296      * registering its interface id is not required.
297      *
298      * See {IERC165-supportsInterface}.
299      *
300      * Requirements:
301      *
302      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
303      */
304     function _registerInterface(bytes4 interfaceId) internal virtual {
305         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
306         _supportedInterfaces[interfaceId] = true;
307     }
308 }
309 
310 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
311 
312 
313 
314 /**
315  * @dev Wrappers over Solidity's arithmetic operations with added overflow
316  * checks.
317  *
318  * Arithmetic operations in Solidity wrap on overflow. This can easily result
319  * in bugs, because programmers usually assume that an overflow raises an
320  * error, which is the standard behavior in high level programming languages.
321  * `SafeMath` restores this intuition by reverting the transaction when an
322  * operation overflows.
323  *
324  * Using this library instead of the unchecked operations eliminates an entire
325  * class of bugs, so it's recommended to use it always.
326  */
327 library SafeMath {
328     /**
329      * @dev Returns the addition of two unsigned integers, reverting on
330      * overflow.
331      *
332      * Counterpart to Solidity's `+` operator.
333      *
334      * Requirements:
335      *
336      * - Addition cannot overflow.
337      */
338     function add(uint256 a, uint256 b) internal pure returns (uint256) {
339         uint256 c = a + b;
340         require(c >= a, "SafeMath: addition overflow");
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356         return sub(a, b, "SafeMath: subtraction overflow");
357     }
358 
359     /**
360      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
361      * overflow (when the result is negative).
362      *
363      * Counterpart to Solidity's `-` operator.
364      *
365      * Requirements:
366      *
367      * - Subtraction cannot overflow.
368      */
369     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
370         require(b <= a, errorMessage);
371         uint256 c = a - b;
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `*` operator.
381      *
382      * Requirements:
383      *
384      * - Multiplication cannot overflow.
385      */
386     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
387         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
388         // benefit is lost if 'b' is also tested.
389         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
390         if (a == 0) {
391             return 0;
392         }
393 
394         uint256 c = a * b;
395         require(c / a == b, "SafeMath: multiplication overflow");
396 
397         return c;
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers. Reverts on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(uint256 a, uint256 b) internal pure returns (uint256) {
413         return div(a, b, "SafeMath: division by zero");
414     }
415 
416     /**
417      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
418      * division by zero. The result is rounded towards zero.
419      *
420      * Counterpart to Solidity's `/` operator. Note: this function uses a
421      * `revert` opcode (which leaves remaining gas untouched) while Solidity
422      * uses an invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b > 0, errorMessage);
430         uint256 c = a / b;
431         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
438      * Reverts when dividing by zero.
439      *
440      * Counterpart to Solidity's `%` operator. This function uses a `revert`
441      * opcode (which leaves remaining gas untouched) while Solidity uses an
442      * invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
449         return mod(a, b, "SafeMath: modulo by zero");
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * Reverts with custom message when dividing by zero.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b != 0, errorMessage);
466         return a % b;
467     }
468 }
469 
470 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
471 
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies in extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         // solhint-disable-next-line no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
525         (bool success, ) = recipient.call{ value: amount }("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain`call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548       return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         return _functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         return _functionCallWithValue(target, data, value, errorMessage);
585     }
586 
587     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
588         require(isContract(target), "Address: call to non-contract");
589 
590         // solhint-disable-next-line avoid-low-level-calls
591         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 // solhint-disable-next-line no-inline-assembly
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
612 
613 
614 
615 /**
616  * @dev Library for managing
617  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
618  * types.
619  *
620  * Sets have the following properties:
621  *
622  * - Elements are added, removed, and checked for existence in constant time
623  * (O(1)).
624  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
625  *
626  * ```
627  * contract Example {
628  *     // Add the library methods
629  *     using EnumerableSet for EnumerableSet.AddressSet;
630  *
631  *     // Declare a set state variable
632  *     EnumerableSet.AddressSet private mySet;
633  * }
634  * ```
635  *
636  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
637  * (`UintSet`) are supported.
638  */
639 library EnumerableSet {
640     // To implement this library for multiple types with as little code
641     // repetition as possible, we write it in terms of a generic Set type with
642     // bytes32 values.
643     // The Set implementation uses private functions, and user-facing
644     // implementations (such as AddressSet) are just wrappers around the
645     // underlying Set.
646     // This means that we can only create new EnumerableSets for types that fit
647     // in bytes32.
648 
649     struct Set {
650         // Storage of set values
651         bytes32[] _values;
652 
653         // Position of the value in the `values` array, plus 1 because index 0
654         // means a value is not in the set.
655         mapping (bytes32 => uint256) _indexes;
656     }
657 
658     /**
659      * @dev Add a value to a set. O(1).
660      *
661      * Returns true if the value was added to the set, that is if it was not
662      * already present.
663      */
664     function _add(Set storage set, bytes32 value) private returns (bool) {
665         if (!_contains(set, value)) {
666             set._values.push(value);
667             // The value is stored at length-1, but we add 1 to all indexes
668             // and use 0 as a sentinel value
669             set._indexes[value] = set._values.length;
670             return true;
671         } else {
672             return false;
673         }
674     }
675 
676     /**
677      * @dev Removes a value from a set. O(1).
678      *
679      * Returns true if the value was removed from the set, that is if it was
680      * present.
681      */
682     function _remove(Set storage set, bytes32 value) private returns (bool) {
683         // We read and store the value's index to prevent multiple reads from the same storage slot
684         uint256 valueIndex = set._indexes[value];
685 
686         if (valueIndex != 0) { // Equivalent to contains(set, value)
687             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
688             // the array, and then remove the last element (sometimes called as 'swap and pop').
689             // This modifies the order of the array, as noted in {at}.
690 
691             uint256 toDeleteIndex = valueIndex - 1;
692             uint256 lastIndex = set._values.length - 1;
693 
694             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
695             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
696 
697             bytes32 lastvalue = set._values[lastIndex];
698 
699             // Move the last value to the index where the value to delete is
700             set._values[toDeleteIndex] = lastvalue;
701             // Update the index for the moved value
702             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
703 
704             // Delete the slot where the moved value was stored
705             set._values.pop();
706 
707             // Delete the index for the deleted slot
708             delete set._indexes[value];
709 
710             return true;
711         } else {
712             return false;
713         }
714     }
715 
716     /**
717      * @dev Returns true if the value is in the set. O(1).
718      */
719     function _contains(Set storage set, bytes32 value) private view returns (bool) {
720         return set._indexes[value] != 0;
721     }
722 
723     /**
724      * @dev Returns the number of values on the set. O(1).
725      */
726     function _length(Set storage set) private view returns (uint256) {
727         return set._values.length;
728     }
729 
730    /**
731     * @dev Returns the value stored at position `index` in the set. O(1).
732     *
733     * Note that there are no guarantees on the ordering of values inside the
734     * array, and it may change when more values are added or removed.
735     *
736     * Requirements:
737     *
738     * - `index` must be strictly less than {length}.
739     */
740     function _at(Set storage set, uint256 index) private view returns (bytes32) {
741         require(set._values.length > index, "EnumerableSet: index out of bounds");
742         return set._values[index];
743     }
744 
745     // AddressSet
746 
747     struct AddressSet {
748         Set _inner;
749     }
750 
751     /**
752      * @dev Add a value to a set. O(1).
753      *
754      * Returns true if the value was added to the set, that is if it was not
755      * already present.
756      */
757     function add(AddressSet storage set, address value) internal returns (bool) {
758         return _add(set._inner, bytes32(uint256(value)));
759     }
760 
761     /**
762      * @dev Removes a value from a set. O(1).
763      *
764      * Returns true if the value was removed from the set, that is if it was
765      * present.
766      */
767     function remove(AddressSet storage set, address value) internal returns (bool) {
768         return _remove(set._inner, bytes32(uint256(value)));
769     }
770 
771     /**
772      * @dev Returns true if the value is in the set. O(1).
773      */
774     function contains(AddressSet storage set, address value) internal view returns (bool) {
775         return _contains(set._inner, bytes32(uint256(value)));
776     }
777 
778     /**
779      * @dev Returns the number of values in the set. O(1).
780      */
781     function length(AddressSet storage set) internal view returns (uint256) {
782         return _length(set._inner);
783     }
784 
785    /**
786     * @dev Returns the value stored at position `index` in the set. O(1).
787     *
788     * Note that there are no guarantees on the ordering of values inside the
789     * array, and it may change when more values are added or removed.
790     *
791     * Requirements:
792     *
793     * - `index` must be strictly less than {length}.
794     */
795     function at(AddressSet storage set, uint256 index) internal view returns (address) {
796         return address(uint256(_at(set._inner, index)));
797     }
798 
799 
800     // UintSet
801 
802     struct UintSet {
803         Set _inner;
804     }
805 
806     /**
807      * @dev Add a value to a set. O(1).
808      *
809      * Returns true if the value was added to the set, that is if it was not
810      * already present.
811      */
812     function add(UintSet storage set, uint256 value) internal returns (bool) {
813         return _add(set._inner, bytes32(value));
814     }
815 
816     /**
817      * @dev Removes a value from a set. O(1).
818      *
819      * Returns true if the value was removed from the set, that is if it was
820      * present.
821      */
822     function remove(UintSet storage set, uint256 value) internal returns (bool) {
823         return _remove(set._inner, bytes32(value));
824     }
825 
826     /**
827      * @dev Returns true if the value is in the set. O(1).
828      */
829     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
830         return _contains(set._inner, bytes32(value));
831     }
832 
833     /**
834      * @dev Returns the number of values on the set. O(1).
835      */
836     function length(UintSet storage set) internal view returns (uint256) {
837         return _length(set._inner);
838     }
839 
840    /**
841     * @dev Returns the value stored at position `index` in the set. O(1).
842     *
843     * Note that there are no guarantees on the ordering of values inside the
844     * array, and it may change when more values are added or removed.
845     *
846     * Requirements:
847     *
848     * - `index` must be strictly less than {length}.
849     */
850     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
851         return uint256(_at(set._inner, index));
852     }
853 }
854 
855 // File: node_modules\@openzeppelin\contracts\utils\EnumerableMap.sol
856 
857 
858 
859 /**
860  * @dev Library for managing an enumerable variant of Solidity's
861  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
862  * type.
863  *
864  * Maps have the following properties:
865  *
866  * - Entries are added, removed, and checked for existence in constant time
867  * (O(1)).
868  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
869  *
870  * ```
871  * contract Example {
872  *     // Add the library methods
873  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
874  *
875  *     // Declare a set state variable
876  *     EnumerableMap.UintToAddressMap private myMap;
877  * }
878  * ```
879  *
880  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
881  * supported.
882  */
883 library EnumerableMap {
884     // To implement this library for multiple types with as little code
885     // repetition as possible, we write it in terms of a generic Map type with
886     // bytes32 keys and values.
887     // The Map implementation uses private functions, and user-facing
888     // implementations (such as Uint256ToAddressMap) are just wrappers around
889     // the underlying Map.
890     // This means that we can only create new EnumerableMaps for types that fit
891     // in bytes32.
892 
893     struct MapEntry {
894         bytes32 _key;
895         bytes32 _value;
896     }
897 
898     struct Map {
899         // Storage of map keys and values
900         MapEntry[] _entries;
901 
902         // Position of the entry defined by a key in the `entries` array, plus 1
903         // because index 0 means a key is not in the map.
904         mapping (bytes32 => uint256) _indexes;
905     }
906 
907     /**
908      * @dev Adds a key-value pair to a map, or updates the value for an existing
909      * key. O(1).
910      *
911      * Returns true if the key was added to the map, that is if it was not
912      * already present.
913      */
914     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
915         // We read and store the key's index to prevent multiple reads from the same storage slot
916         uint256 keyIndex = map._indexes[key];
917 
918         if (keyIndex == 0) { // Equivalent to !contains(map, key)
919             map._entries.push(MapEntry({ _key: key, _value: value }));
920             // The entry is stored at length-1, but we add 1 to all indexes
921             // and use 0 as a sentinel value
922             map._indexes[key] = map._entries.length;
923             return true;
924         } else {
925             map._entries[keyIndex - 1]._value = value;
926             return false;
927         }
928     }
929 
930     /**
931      * @dev Removes a key-value pair from a map. O(1).
932      *
933      * Returns true if the key was removed from the map, that is if it was present.
934      */
935     function _remove(Map storage map, bytes32 key) private returns (bool) {
936         // We read and store the key's index to prevent multiple reads from the same storage slot
937         uint256 keyIndex = map._indexes[key];
938 
939         if (keyIndex != 0) { // Equivalent to contains(map, key)
940             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
941             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
942             // This modifies the order of the array, as noted in {at}.
943 
944             uint256 toDeleteIndex = keyIndex - 1;
945             uint256 lastIndex = map._entries.length - 1;
946 
947             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
948             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
949 
950             MapEntry storage lastEntry = map._entries[lastIndex];
951 
952             // Move the last entry to the index where the entry to delete is
953             map._entries[toDeleteIndex] = lastEntry;
954             // Update the index for the moved entry
955             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
956 
957             // Delete the slot where the moved entry was stored
958             map._entries.pop();
959 
960             // Delete the index for the deleted slot
961             delete map._indexes[key];
962 
963             return true;
964         } else {
965             return false;
966         }
967     }
968 
969     /**
970      * @dev Returns true if the key is in the map. O(1).
971      */
972     function _contains(Map storage map, bytes32 key) private view returns (bool) {
973         return map._indexes[key] != 0;
974     }
975 
976     /**
977      * @dev Returns the number of key-value pairs in the map. O(1).
978      */
979     function _length(Map storage map) private view returns (uint256) {
980         return map._entries.length;
981     }
982 
983    /**
984     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
985     *
986     * Note that there are no guarantees on the ordering of entries inside the
987     * array, and it may change when more entries are added or removed.
988     *
989     * Requirements:
990     *
991     * - `index` must be strictly less than {length}.
992     */
993     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
994         require(map._entries.length > index, "EnumerableMap: index out of bounds");
995 
996         MapEntry storage entry = map._entries[index];
997         return (entry._key, entry._value);
998     }
999 
1000     /**
1001      * @dev Returns the value associated with `key`.  O(1).
1002      *
1003      * Requirements:
1004      *
1005      * - `key` must be in the map.
1006      */
1007     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1008         return _get(map, key, "EnumerableMap: nonexistent key");
1009     }
1010 
1011     /**
1012      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1013      */
1014     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1015         uint256 keyIndex = map._indexes[key];
1016         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1017         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1018     }
1019 
1020     // UintToAddressMap
1021 
1022     struct UintToAddressMap {
1023         Map _inner;
1024     }
1025 
1026     /**
1027      * @dev Adds a key-value pair to a map, or updates the value for an existing
1028      * key. O(1).
1029      *
1030      * Returns true if the key was added to the map, that is if it was not
1031      * already present.
1032      */
1033     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1034         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1035     }
1036 
1037     /**
1038      * @dev Removes a value from a set. O(1).
1039      *
1040      * Returns true if the key was removed from the map, that is if it was present.
1041      */
1042     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1043         return _remove(map._inner, bytes32(key));
1044     }
1045 
1046     /**
1047      * @dev Returns true if the key is in the map. O(1).
1048      */
1049     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1050         return _contains(map._inner, bytes32(key));
1051     }
1052 
1053     /**
1054      * @dev Returns the number of elements in the map. O(1).
1055      */
1056     function length(UintToAddressMap storage map) internal view returns (uint256) {
1057         return _length(map._inner);
1058     }
1059 
1060    /**
1061     * @dev Returns the element stored at position `index` in the set. O(1).
1062     * Note that there are no guarantees on the ordering of values inside the
1063     * array, and it may change when more values are added or removed.
1064     *
1065     * Requirements:
1066     *
1067     * - `index` must be strictly less than {length}.
1068     */
1069     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1070         (bytes32 key, bytes32 value) = _at(map._inner, index);
1071         return (uint256(key), address(uint256(value)));
1072     }
1073 
1074     /**
1075      * @dev Returns the value associated with `key`.  O(1).
1076      *
1077      * Requirements:
1078      *
1079      * - `key` must be in the map.
1080      */
1081     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1082         return address(uint256(_get(map._inner, bytes32(key))));
1083     }
1084 
1085     /**
1086      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1087      */
1088     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1089         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1090     }
1091 }
1092 
1093 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
1094 
1095 
1096 
1097 /**
1098  * @dev String operations.
1099  */
1100 library Strings {
1101     /**
1102      * @dev Converts a `uint256` to its ASCII `string` representation.
1103      */
1104     function toString(uint256 value) internal pure returns (string memory) {
1105         // Inspired by OraclizeAPI's implementation - MIT licence
1106         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1107 
1108         if (value == 0) {
1109             return "0";
1110         }
1111         uint256 temp = value;
1112         uint256 digits;
1113         while (temp != 0) {
1114             digits++;
1115             temp /= 10;
1116         }
1117         bytes memory buffer = new bytes(digits);
1118         uint256 index = digits - 1;
1119         temp = value;
1120         while (temp != 0) {
1121             buffer[index--] = byte(uint8(48 + temp % 10));
1122             temp /= 10;
1123         }
1124         return string(buffer);
1125     }
1126 }
1127 
1128 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 /**
1144  * @title ERC721 Non-Fungible Token Standard basic implementation
1145  * @dev see https://eips.ethereum.org/EIPS/eip-721
1146  */
1147 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1148     using SafeMath for uint256;
1149     using Address for address;
1150     using EnumerableSet for EnumerableSet.UintSet;
1151     using EnumerableMap for EnumerableMap.UintToAddressMap;
1152     using Strings for uint256;
1153 
1154     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1155     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1156     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1157 
1158     // Mapping from holder address to their (enumerable) set of owned tokens
1159     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1160 
1161     // Enumerable mapping from token ids to their owners
1162     EnumerableMap.UintToAddressMap private _tokenOwners;
1163 
1164     // Mapping from token ID to approved address
1165     mapping (uint256 => address) private _tokenApprovals;
1166 
1167     // Mapping from owner to operator approvals
1168     mapping (address => mapping (address => bool)) private _operatorApprovals;
1169 
1170     // Token name
1171     string private _name;
1172 
1173     // Token symbol
1174     string private _symbol;
1175 
1176     // Optional mapping for token URIs
1177     mapping (uint256 => string) private _tokenURIs;
1178 
1179     // Base URI
1180     string private _baseURI;
1181 
1182     /*
1183      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1184      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1185      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1186      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1187      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1188      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1189      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1190      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1191      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1192      *
1193      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1194      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1195      */
1196     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1197 
1198     /*
1199      *     bytes4(keccak256('name()')) == 0x06fdde03
1200      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1201      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1202      *
1203      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1204      */
1205     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1206 
1207     /*
1208      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1209      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1210      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1211      *
1212      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1213      */
1214     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1215 
1216     /**
1217      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1218      */
1219     constructor (string memory name, string memory symbol) public {
1220         _name = name;
1221         _symbol = symbol;
1222 
1223         // register the supported interfaces to conform to ERC721 via ERC165
1224         _registerInterface(_INTERFACE_ID_ERC721);
1225         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1226         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-balanceOf}.
1231      */
1232     function balanceOf(address owner) public view override returns (uint256) {
1233         require(owner != address(0), "ERC721: balance query for the zero address");
1234 
1235         return _holderTokens[owner].length();
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-ownerOf}.
1240      */
1241     function ownerOf(uint256 tokenId) public view override returns (address) {
1242         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-name}.
1247      */
1248     function name() public view override returns (string memory) {
1249         return _name;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-symbol}.
1254      */
1255     function symbol() public view override returns (string memory) {
1256         return _symbol;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721Metadata-tokenURI}.
1261      */
1262     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1263         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1264 
1265         string memory _tokenURI = _tokenURIs[tokenId];
1266 
1267         // If there is no base URI, return the token URI.
1268         if (bytes(_baseURI).length == 0) {
1269             return _tokenURI;
1270         }
1271         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1272         if (bytes(_tokenURI).length > 0) {
1273             return string(abi.encodePacked(_baseURI, _tokenURI));
1274         }
1275         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1276         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1277     }
1278 
1279     /**
1280     * @dev Returns the base URI set via {_setBaseURI}. This will be
1281     * automatically added as a prefix in {tokenURI} to each token's URI, or
1282     * to the token ID if no specific URI is set for that token ID.
1283     */
1284     function baseURI() public view returns (string memory) {
1285         return _baseURI;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1290      */
1291     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1292         return _holderTokens[owner].at(index);
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Enumerable-totalSupply}.
1297      */
1298     function totalSupply() public view override returns (uint256) {
1299         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1300         return _tokenOwners.length();
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenByIndex}.
1305      */
1306     function tokenByIndex(uint256 index) public view override returns (uint256) {
1307         (uint256 tokenId, ) = _tokenOwners.at(index);
1308         return tokenId;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721-approve}.
1313      */
1314     function approve(address to, uint256 tokenId) public virtual override {
1315         address owner = ownerOf(tokenId);
1316         require(to != owner, "ERC721: approval to current owner");
1317 
1318         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1319             "ERC721: approve caller is not owner nor approved for all"
1320         );
1321 
1322         _approve(to, tokenId);
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-getApproved}.
1327      */
1328     function getApproved(uint256 tokenId) public view override returns (address) {
1329         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1330 
1331         return _tokenApprovals[tokenId];
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-setApprovalForAll}.
1336      */
1337     function setApprovalForAll(address operator, bool approved) public virtual override {
1338         require(operator != _msgSender(), "ERC721: approve to caller");
1339 
1340         _operatorApprovals[_msgSender()][operator] = approved;
1341         emit ApprovalForAll(_msgSender(), operator, approved);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-isApprovedForAll}.
1346      */
1347     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1348         return _operatorApprovals[owner][operator];
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-transferFrom}.
1353      */
1354     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1355         //solhint-disable-next-line max-line-length
1356         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1357 
1358         _transfer(from, to, tokenId);
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-safeTransferFrom}.
1363      */
1364     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1365         safeTransferFrom(from, to, tokenId, "");
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-safeTransferFrom}.
1370      */
1371     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1372         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1373         _safeTransfer(from, to, tokenId, _data);
1374     }
1375 
1376     /**
1377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1379      *
1380      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1381      *
1382      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1383      * implement alternative mechanisms to perform token transfer, such as signature-based.
1384      *
1385      * Requirements:
1386      *
1387      * - `from` cannot be the zero address.
1388      * - `to` cannot be the zero address.
1389      * - `tokenId` token must exist and be owned by `from`.
1390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1395         _transfer(from, to, tokenId);
1396         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1397     }
1398 
1399     /**
1400      * @dev Returns whether `tokenId` exists.
1401      *
1402      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1403      *
1404      * Tokens start existing when they are minted (`_mint`),
1405      * and stop existing when they are burned (`_burn`).
1406      */
1407     function _exists(uint256 tokenId) internal view returns (bool) {
1408         return _tokenOwners.contains(tokenId);
1409     }
1410 
1411     /**
1412      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1413      *
1414      * Requirements:
1415      *
1416      * - `tokenId` must exist.
1417      */
1418     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1419         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1420         address owner = ownerOf(tokenId);
1421         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1422     }
1423 
1424     /**
1425      * @dev Safely mints `tokenId` and transfers it to `to`.
1426      *
1427      * Requirements:
1428      d*
1429      * - `tokenId` must not exist.
1430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function _safeMint(address to, uint256 tokenId) internal virtual {
1435         _safeMint(to, tokenId, "");
1436     }
1437 
1438     /**
1439      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1440      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1441      */
1442     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1443         _mint(to, tokenId);
1444         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1445     }
1446 
1447     /**
1448      * @dev Mints `tokenId` and transfers it to `to`.
1449      *
1450      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must not exist.
1455      * - `to` cannot be the zero address.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _mint(address to, uint256 tokenId) internal virtual {
1460         require(to != address(0), "ERC721: mint to the zero address");
1461         require(!_exists(tokenId), "ERC721: token already minted");
1462 
1463         _beforeTokenTransfer(address(0), to, tokenId);
1464 
1465         _holderTokens[to].add(tokenId);
1466 
1467         _tokenOwners.set(tokenId, to);
1468 
1469         emit Transfer(address(0), to, tokenId);
1470     }
1471 
1472     /**
1473      * @dev Destroys `tokenId`.
1474      * The approval is cleared when the token is burned.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _burn(uint256 tokenId) internal virtual {
1483         address owner = ownerOf(tokenId);
1484 
1485         _beforeTokenTransfer(owner, address(0), tokenId);
1486 
1487         // Clear approvals
1488         _approve(address(0), tokenId);
1489 
1490         // Clear metadata (if any)
1491         if (bytes(_tokenURIs[tokenId]).length != 0) {
1492             delete _tokenURIs[tokenId];
1493         }
1494 
1495         _holderTokens[owner].remove(tokenId);
1496 
1497         _tokenOwners.remove(tokenId);
1498 
1499         emit Transfer(owner, address(0), tokenId);
1500     }
1501 
1502     /**
1503      * @dev Transfers `tokenId` from `from` to `to`.
1504      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1505      *
1506      * Requirements:
1507      *
1508      * - `to` cannot be the zero address.
1509      * - `tokenId` token must be owned by `from`.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1514         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1515         require(to != address(0), "ERC721: transfer to the zero address");
1516 
1517         _beforeTokenTransfer(from, to, tokenId);
1518 
1519         // Clear approvals from the previous owner
1520         _approve(address(0), tokenId);
1521 
1522         _holderTokens[from].remove(tokenId);
1523         _holderTokens[to].add(tokenId);
1524 
1525         _tokenOwners.set(tokenId, to);
1526 
1527         emit Transfer(from, to, tokenId);
1528     }
1529 
1530     /**
1531      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1532      *
1533      * Requirements:
1534      *
1535      * - `tokenId` must exist.
1536      */
1537     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1538         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1539         _tokenURIs[tokenId] = _tokenURI;
1540     }
1541 
1542     /**
1543      * @dev Internal function to set the base URI for all token IDs. It is
1544      * automatically added as a prefix to the value returned in {tokenURI},
1545      * or to the token ID if {tokenURI} is empty.
1546      */
1547     function _setBaseURI(string memory baseURI_) internal virtual {
1548         _baseURI = baseURI_;
1549     }
1550 
1551     /**
1552      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1553      * The call is not executed if the target address is not a contract.
1554      *
1555      * @param from address representing the previous owner of the given token ID
1556      * @param to target address that will receive the tokens
1557      * @param tokenId uint256 ID of the token to be transferred
1558      * @param _data bytes optional data to send along with the call
1559      * @return bool whether the call correctly returned the expected magic value
1560      */
1561     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1562         private returns (bool)
1563     {
1564         if (!to.isContract()) {
1565             return true;
1566         }
1567         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1568             IERC721Receiver(to).onERC721Received.selector,
1569             _msgSender(),
1570             from,
1571             tokenId,
1572             _data
1573         ), "ERC721: transfer to non ERC721Receiver implementer");
1574         bytes4 retval = abi.decode(returndata, (bytes4));
1575         return (retval == _ERC721_RECEIVED);
1576     }
1577 
1578     function _approve(address to, uint256 tokenId) private {
1579         _tokenApprovals[tokenId] = to;
1580         emit Approval(ownerOf(tokenId), to, tokenId);
1581     }
1582 
1583     /**
1584      * @dev Hook that is called before any token transfer. This includes minting
1585      * and burning.
1586      *
1587      * Calling conditions:
1588      *
1589      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1590      * transferred to `to`.
1591      * - When `from` is zero, `tokenId` will be minted for `to`.
1592      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1593      * - `from` cannot be the zero address.
1594      * - `to` cannot be the zero address.
1595      *
1596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1597      */
1598     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1599 }
1600 
1601 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
1602 
1603 
1604 
1605 /**
1606  * @dev Interface of the ERC20 standard as defined in the EIP.
1607  */
1608 interface IERC20 {
1609     /**
1610      * @dev Returns the amount of tokens in existence.
1611      */
1612     function totalSupply() external view returns (uint256);
1613 
1614     /**
1615      * @dev Returns the amount of tokens owned by `account`.
1616      */
1617     function balanceOf(address account) external view returns (uint256);
1618 
1619     /**
1620      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1621      *
1622      * Returns a boolean value indicating whether the operation succeeded.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function transfer(address recipient, uint256 amount) external returns (bool);
1627 
1628     /**
1629      * @dev Returns the remaining number of tokens that `spender` will be
1630      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1631      * zero by default.
1632      *
1633      * This value changes when {approve} or {transferFrom} are called.
1634      */
1635     function allowance(address owner, address spender) external view returns (uint256);
1636 
1637     /**
1638      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1639      *
1640      * Returns a boolean value indicating whether the operation succeeded.
1641      *
1642      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1643      * that someone may use both the old and the new allowance by unfortunate
1644      * transaction ordering. One possible solution to mitigate this race
1645      * condition is to first reduce the spender's allowance to 0 and set the
1646      * desired value afterwards:
1647      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1648      *
1649      * Emits an {Approval} event.
1650      */
1651     function approve(address spender, uint256 amount) external returns (bool);
1652 
1653     /**
1654      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1655      * allowance mechanism. `amount` is then deducted from the caller's
1656      * allowance.
1657      *
1658      * Returns a boolean value indicating whether the operation succeeded.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1663 
1664     /**
1665      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1666      * another (`to`).
1667      *
1668      * Note that `value` may be zero.
1669      */
1670     event Transfer(address indexed from, address indexed to, uint256 value);
1671 
1672     /**
1673      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1674      * a call to {approve}. `value` is the new allowance.
1675      */
1676     event Approval(address indexed owner, address indexed spender, uint256 value);
1677 }
1678 
1679 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
1680 
1681 
1682 
1683 
1684 
1685 
1686 /**
1687  * @dev Implementation of the {IERC20} interface.
1688  *
1689  * This implementation is agnostic to the way tokens are created. This means
1690  * that a supply mechanism has to be added in a derived contract using {_mint}.
1691  * For a generic mechanism see {ERC20PresetMinterPauser}.
1692  *
1693  * TIP: For a detailed writeup see our guide
1694  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1695  * to implement supply mechanisms].
1696  *
1697  * We have followed general OpenZeppelin guidelines: functions revert instead
1698  * of returning `false` on failure. This behavior is nonetheless conventional
1699  * and does not conflict with the expectations of ERC20 applications.
1700  *
1701  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1702  * This allows applications to reconstruct the allowance for all accounts just
1703  * by listening to said events. Other implementations of the EIP may not emit
1704  * these events, as it isn't required by the specification.
1705  *
1706  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1707  * functions have been added to mitigate the well-known issues around setting
1708  * allowances. See {IERC20-approve}.
1709  */
1710 contract ERC20 is Context, IERC20 {
1711     using SafeMath for uint256;
1712     using Address for address;
1713 
1714     mapping (address => uint256) private _balances;
1715 
1716     mapping (address => mapping (address => uint256)) private _allowances;
1717 
1718     uint256 private _totalSupply;
1719 
1720     string private _name;
1721     string private _symbol;
1722     uint8 private _decimals;
1723 
1724     /**
1725      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1726      * a default value of 18.
1727      *
1728      * To select a different value for {decimals}, use {_setupDecimals}.
1729      *
1730      * All three of these values are immutable: they can only be set once during
1731      * construction.
1732      */
1733     constructor (string memory name, string memory symbol) public {
1734         _name = name;
1735         _symbol = symbol;
1736         _decimals = 18;
1737     }
1738 
1739     /**
1740      * @dev Returns the name of the token.
1741      */
1742     function name() public view returns (string memory) {
1743         return _name;
1744     }
1745 
1746     /**
1747      * @dev Returns the symbol of the token, usually a shorter version of the
1748      * name.
1749      */
1750     function symbol() public view returns (string memory) {
1751         return _symbol;
1752     }
1753 
1754     /**
1755      * @dev Returns the number of decimals used to get its user representation.
1756      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1757      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1758      *
1759      * Tokens usually opt for a value of 18, imitating the relationship between
1760      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1761      * called.
1762      *
1763      * NOTE: This information is only used for _display_ purposes: it in
1764      * no way affects any of the arithmetic of the contract, including
1765      * {IERC20-balanceOf} and {IERC20-transfer}.
1766      */
1767     function decimals() public view returns (uint8) {
1768         return _decimals;
1769     }
1770 
1771     /**
1772      * @dev See {IERC20-totalSupply}.
1773      */
1774     function totalSupply() public view override returns (uint256) {
1775         return _totalSupply;
1776     }
1777 
1778     /**
1779      * @dev See {IERC20-balanceOf}.
1780      */
1781     function balanceOf(address account) public view override returns (uint256) {
1782         return _balances[account];
1783     }
1784 
1785     /**
1786      * @dev See {IERC20-transfer}.
1787      *
1788      * Requirements:
1789      *
1790      * - `recipient` cannot be the zero address.
1791      * - the caller must have a balance of at least `amount`.
1792      */
1793     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1794         _transfer(_msgSender(), recipient, amount);
1795         return true;
1796     }
1797 
1798     /**
1799      * @dev See {IERC20-allowance}.
1800      */
1801     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1802         return _allowances[owner][spender];
1803     }
1804 
1805     /**
1806      * @dev See {IERC20-approve}.
1807      *
1808      * Requirements:
1809      *
1810      * - `spender` cannot be the zero address.
1811      */
1812     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1813         _approve(_msgSender(), spender, amount);
1814         return true;
1815     }
1816 
1817     /**
1818      * @dev See {IERC20-transferFrom}.
1819      *
1820      * Emits an {Approval} event indicating the updated allowance. This is not
1821      * required by the EIP. See the note at the beginning of {ERC20};
1822      *
1823      * Requirements:
1824      * - `sender` and `recipient` cannot be the zero address.
1825      * - `sender` must have a balance of at least `amount`.
1826      * - the caller must have allowance for ``sender``'s tokens of at least
1827      * `amount`.
1828      */
1829     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1830         _transfer(sender, recipient, amount);
1831         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1832         return true;
1833     }
1834 
1835     /**
1836      * @dev Atomically increases the allowance granted to `spender` by the caller.
1837      *
1838      * This is an alternative to {approve} that can be used as a mitigation for
1839      * problems described in {IERC20-approve}.
1840      *
1841      * Emits an {Approval} event indicating the updated allowance.
1842      *
1843      * Requirements:
1844      *
1845      * - `spender` cannot be the zero address.
1846      */
1847     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1848         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1849         return true;
1850     }
1851 
1852     /**
1853      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1854      *
1855      * This is an alternative to {approve} that can be used as a mitigation for
1856      * problems described in {IERC20-approve}.
1857      *
1858      * Emits an {Approval} event indicating the updated allowance.
1859      *
1860      * Requirements:
1861      *
1862      * - `spender` cannot be the zero address.
1863      * - `spender` must have allowance for the caller of at least
1864      * `subtractedValue`.
1865      */
1866     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1867         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1868         return true;
1869     }
1870 
1871     /**
1872      * @dev Moves tokens `amount` from `sender` to `recipient`.
1873      *
1874      * This is internal function is equivalent to {transfer}, and can be used to
1875      * e.g. implement automatic token fees, slashing mechanisms, etc.
1876      *
1877      * Emits a {Transfer} event.
1878      *
1879      * Requirements:
1880      *
1881      * - `sender` cannot be the zero address.
1882      * - `recipient` cannot be the zero address.
1883      * - `sender` must have a balance of at least `amount`.
1884      */
1885     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1886         require(sender != address(0), "ERC20: transfer from the zero address");
1887         require(recipient != address(0), "ERC20: transfer to the zero address");
1888 
1889         _beforeTokenTransfer(sender, recipient, amount);
1890 
1891         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1892         _balances[recipient] = _balances[recipient].add(amount);
1893         emit Transfer(sender, recipient, amount);
1894     }
1895 
1896     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1897      * the total supply.
1898      *
1899      * Emits a {Transfer} event with `from` set to the zero address.
1900      *
1901      * Requirements
1902      *
1903      * - `to` cannot be the zero address.
1904      */
1905     function _mint(address account, uint256 amount) internal virtual {
1906         require(account != address(0), "ERC20: mint to the zero address");
1907 
1908         _beforeTokenTransfer(address(0), account, amount);
1909 
1910         _totalSupply = _totalSupply.add(amount);
1911         _balances[account] = _balances[account].add(amount);
1912         emit Transfer(address(0), account, amount);
1913     }
1914 
1915     /**
1916      * @dev Destroys `amount` tokens from `account`, reducing the
1917      * total supply.
1918      *
1919      * Emits a {Transfer} event with `to` set to the zero address.
1920      *
1921      * Requirements
1922      *
1923      * - `account` cannot be the zero address.
1924      * - `account` must have at least `amount` tokens.
1925      */
1926     function _burn(address account, uint256 amount) internal virtual {
1927         require(account != address(0), "ERC20: burn from the zero address");
1928 
1929         _beforeTokenTransfer(account, address(0), amount);
1930 
1931         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1932         _totalSupply = _totalSupply.sub(amount);
1933         emit Transfer(account, address(0), amount);
1934     }
1935 
1936     /**
1937      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1938      *
1939      * This internal function is equivalent to `approve`, and can be used to
1940      * e.g. set automatic allowances for certain subsystems, etc.
1941      *
1942      * Emits an {Approval} event.
1943      *
1944      * Requirements:
1945      *
1946      * - `owner` cannot be the zero address.
1947      * - `spender` cannot be the zero address.
1948      */
1949     function _approve(address owner, address spender, uint256 amount) internal virtual {
1950         require(owner != address(0), "ERC20: approve from the zero address");
1951         require(spender != address(0), "ERC20: approve to the zero address");
1952 
1953         _allowances[owner][spender] = amount;
1954         emit Approval(owner, spender, amount);
1955     }
1956 
1957     /**
1958      * @dev Sets {decimals} to a value other than the default one of 18.
1959      *
1960      * WARNING: This function should only be called from the constructor. Most
1961      * applications that interact with token contracts will not expect
1962      * {decimals} to ever change, and may work incorrectly if it does.
1963      */
1964     function _setupDecimals(uint8 decimals_) internal {
1965         _decimals = decimals_;
1966     }
1967 
1968     /**
1969      * @dev Hook that is called before any transfer of tokens. This includes
1970      * minting and burning.
1971      *
1972      * Calling conditions:
1973      *
1974      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1975      * will be to transferred to `to`.
1976      * - when `from` is zero, `amount` tokens will be minted for `to`.
1977      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1978      * - `from` and `to` are never both zero.
1979      *
1980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1981      */
1982     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1983 }
1984 
1985 // File: @openzeppelin\contracts\access\Ownable.sol
1986 
1987 
1988 
1989 /**
1990  * @dev Contract module which provides a basic access control mechanism, where
1991  * there is an account (an owner) that can be granted exclusive access to
1992  * specific functions.
1993  *
1994  * By default, the owner account will be the one that deploys the contract. This
1995  * can later be changed with {transferOwnership}.
1996  *
1997  * This module is used through inheritance. It will make available the modifier
1998  * `onlyOwner`, which can be applied to your functions to restrict their use to
1999  * the owner.
2000  */
2001 contract Ownable is Context {
2002     address private _owner;
2003 
2004     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2005 
2006     /**
2007      * @dev Initializes the contract setting the deployer as the initial owner.
2008      */
2009     constructor () internal {
2010         address msgSender = _msgSender();
2011         _owner = msgSender;
2012         emit OwnershipTransferred(address(0), msgSender);
2013     }
2014 
2015     /**
2016      * @dev Returns the address of the current owner.
2017      */
2018     function owner() public view returns (address) {
2019         return _owner;
2020     }
2021 
2022     /**
2023      * @dev Throws if called by any account other than the owner.
2024      */
2025     modifier onlyOwner() {
2026         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2027         _;
2028     }
2029 
2030     /**
2031      * @dev Leaves the contract without owner. It will not be possible to call
2032      * `onlyOwner` functions anymore. Can only be called by the current owner.
2033      *
2034      * NOTE: Renouncing ownership will leave the contract without an owner,
2035      * thereby removing any functionality that is only available to the owner.
2036      */
2037     function renounceOwnership() public virtual onlyOwner {
2038         emit OwnershipTransferred(_owner, address(0));
2039         _owner = address(0);
2040     }
2041 
2042     /**
2043      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2044      * Can only be called by the current owner.
2045      */
2046     function transferOwnership(address newOwner) public virtual onlyOwner {
2047         require(newOwner != address(0), "Ownable: new owner is the zero address");
2048         emit OwnershipTransferred(_owner, newOwner);
2049         _owner = newOwner;
2050     }
2051 }
2052 
2053 // File: contracts\KingClubNft.sol
2054 
2055 
2056 
2057 
2058 
2059 /**
2060  * @title KingClub contract
2061  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2062  */
2063 contract KingClub is ERC721, Ownable {
2064     using SafeMath for uint256;
2065 
2066     string public KingHead_PROVENANCE = "";
2067 
2068     uint256 public constant kingHeadPrice = 1000000000000000000; //1 ETH
2069 
2070     uint public constant maxKingHeadPurchase = 10;
2071     uint256 public MAX_KingHead;
2072 
2073     bool public saleIsActive = false;
2074 
2075     //bool public customKingHeadMinted = false;
2076 
2077     constructor() ERC721("kingclub", "KINGCLUB") public{
2078         MAX_KingHead = 700;
2079     }
2080 
2081     function withdraw() public onlyOwner {
2082         uint balance = address(this).balance;
2083         msg.sender.transfer(balance);
2084     }
2085 
2086     /**
2087      * Set some KingHead aside
2088      */
2089     function reserveKingHead(uint numKingHead) public onlyOwner {        
2090         uint supply = totalSupply();
2091         uint i;
2092         for (i = 0; i < numKingHead; i++) {
2093             _safeMint(msg.sender, supply + i);
2094         }
2095     }
2096 
2097     /*     
2098     * Set provenance once it's calculated
2099     */
2100     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2101         KingHead_PROVENANCE = provenanceHash;
2102     }
2103 
2104     function setBaseURI(string memory baseURI) public onlyOwner {
2105         _setBaseURI(baseURI);
2106     }
2107 
2108     function openSecondSeason() public onlyOwner {
2109         require(MAX_KingHead < 1400, "only MAX_KingHead < 1400");
2110         MAX_KingHead = 1400;
2111     }
2112 
2113     function openThirdSeason() public onlyOwner {
2114         require(MAX_KingHead < 2100, "only MAX_KingHead < 2100");
2115         MAX_KingHead = 2100;
2116     }
2117 
2118 
2119     /*
2120     * Pause sale if active, make active if paused
2121     */
2122     function flipSaleState() public onlyOwner {
2123         saleIsActive = !saleIsActive;
2124     }
2125 
2126     /**
2127     * Mint KingHead
2128     */
2129     function mint() public payable {
2130         mintKingHead(1);
2131     }
2132 
2133     /**
2134     * Mints KingHead
2135     */
2136     function mintKingHead(uint numberOfTokens) public payable {
2137         require(saleIsActive, "Sale must be active to mint KingHead");
2138         require(numberOfTokens <= maxKingHeadPurchase, "Can only mint 10 tokens at a time");
2139         require(totalSupply().add(numberOfTokens) <= MAX_KingHead, "Purchase would exceed max supply of KingHead");
2140         require(kingHeadPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2141         mintNumberOfTokens(numberOfTokens);
2142     }
2143 
2144     function mintNumberOfTokens(uint numberOfTokens) private{
2145         for(uint i = 0; i < numberOfTokens; i++) {
2146             uint mintIndex = totalSupply();
2147             if (totalSupply() < MAX_KingHead) {
2148                 _safeMint(msg.sender, mintIndex);
2149             }
2150         }
2151     }
2152 
2153 
2154   function burn(uint256 tokenId)
2155     private
2156   {
2157     require(_isApprovedOrOwner(msg.sender, tokenId));
2158     require(_exists(tokenId));
2159     require(ERC721.ownerOf(tokenId) == msg.sender, string(abi.encodePacked("ERC721: Sender does not own TokenId: ", tokenId)));
2160     _burn(tokenId);
2161   }
2162 
2163   function getTokenURI(uint256 tokenId) public view returns(string memory){
2164       return ERC721.tokenURI(tokenId);
2165   }
2166 
2167 }