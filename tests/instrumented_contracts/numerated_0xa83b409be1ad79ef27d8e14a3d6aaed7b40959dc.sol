1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-04-22
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.7.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0-solc-0.7
36 
37 
38 pragma solidity ^0.7.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 
62 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.1.0-solc-0.7
63 
64 
65 pragma solidity ^0.7.0;
66 
67 /**
68  * @dev Required interface of an ERC721 compliant contract.
69  */
70 interface IERC721 is IERC165 {
71     /**
72      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(address from, address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Transfers `tokenId` token from `from` to `to`.
118      *
119      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
120      *
121      * Requirements:
122      *
123      * - `from` cannot be the zero address.
124      * - `to` cannot be the zero address.
125      * - `tokenId` token must be owned by `from`.
126      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(address from, address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 
175     /**
176       * @dev Safely transfers `tokenId` token from `from` to `to`.
177       *
178       * Requirements:
179       *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182       * - `tokenId` token must exist and be owned by `from`.
183       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185       *
186       * Emits a {Transfer} event.
187       */
188     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
189 }
190 
191 
192 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.1.0-solc-0.7
193 
194 
195 pragma solidity ^0.7.0;
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202 
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 
220 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.1.0-solc-0.7
221 
222 
223 pragma solidity ^0.7.0;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Enumerable is IERC721 {
230 
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
239      */
240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 
250 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.1.0-solc-0.7
251 
252 
253 pragma solidity ^0.7.0;
254 
255 /**
256  * @title ERC721 token receiver interface
257  * @dev Interface for any contract that wants to support safeTransfers
258  * from ERC721 asset contracts.
259  */
260 interface IERC721Receiver {
261     /**
262      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
263      * by `operator` from `from`, this function is called.
264      *
265      * It must return its Solidity selector to confirm the token transfer.
266      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
267      *
268      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
269      */
270     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
271     external returns (bytes4);
272 }
273 
274 
275 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0-solc-0.7
276 
277 
278 pragma solidity ^0.7.0;
279 
280 /**
281  * @dev Implementation of the {IERC165} interface.
282  *
283  * Contracts may inherit from this and call {_registerInterface} to declare
284  * their support of an interface.
285  */
286 contract ERC165 is IERC165 {
287     /*
288      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
289      */
290     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
291 
292     /**
293      * @dev Mapping of interface ids to whether or not it's supported.
294      */
295     mapping(bytes4 => bool) private _supportedInterfaces;
296 
297     constructor () {
298         // Derived contracts need only register support for their own interfaces,
299         // we register support for ERC165 itself here
300         _registerInterface(_INTERFACE_ID_ERC165);
301     }
302 
303     /**
304      * @dev See {IERC165-supportsInterface}.
305      *
306      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
309         return _supportedInterfaces[interfaceId];
310     }
311 
312     /**
313      * @dev Registers the contract as an implementer of the interface defined by
314      * `interfaceId`. Support of the actual ERC165 interface is automatic and
315      * registering its interface id is not required.
316      *
317      * See {IERC165-supportsInterface}.
318      *
319      * Requirements:
320      *
321      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
322      */
323     function _registerInterface(bytes4 interfaceId) internal virtual {
324         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
325         _supportedInterfaces[interfaceId] = true;
326     }
327 }
328 
329 
330 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0-solc-0.7
331 
332 
333 pragma solidity ^0.7.0;
334 
335 /**
336  * @dev Wrappers over Solidity's arithmetic operations with added overflow
337  * checks.
338  *
339  * Arithmetic operations in Solidity wrap on overflow. This can easily result
340  * in bugs, because programmers usually assume that an overflow raises an
341  * error, which is the standard behavior in high level programming languages.
342  * `SafeMath` restores this intuition by reverting the transaction when an
343  * operation overflows.
344  *
345  * Using this library instead of the unchecked operations eliminates an entire
346  * class of bugs, so it's recommended to use it always.
347  */
348 library SafeMath {
349     /**
350      * @dev Returns the addition of two unsigned integers, reverting on
351      * overflow.
352      *
353      * Counterpart to Solidity's `+` operator.
354      *
355      * Requirements:
356      *
357      * - Addition cannot overflow.
358      */
359     function add(uint256 a, uint256 b) internal pure returns (uint256) {
360         uint256 c = a + b;
361         require(c >= a, "SafeMath: addition overflow");
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the subtraction of two unsigned integers, reverting on
368      * overflow (when the result is negative).
369      *
370      * Counterpart to Solidity's `-` operator.
371      *
372      * Requirements:
373      *
374      * - Subtraction cannot overflow.
375      */
376     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
377         return sub(a, b, "SafeMath: subtraction overflow");
378     }
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
382      * overflow (when the result is negative).
383      *
384      * Counterpart to Solidity's `-` operator.
385      *
386      * Requirements:
387      *
388      * - Subtraction cannot overflow.
389      */
390     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
391         require(b <= a, errorMessage);
392         uint256 c = a - b;
393 
394         return c;
395     }
396 
397     /**
398      * @dev Returns the multiplication of two unsigned integers, reverting on
399      * overflow.
400      *
401      * Counterpart to Solidity's `*` operator.
402      *
403      * Requirements:
404      *
405      * - Multiplication cannot overflow.
406      */
407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
408         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
409         // benefit is lost if 'b' is also tested.
410         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
411         if (a == 0) {
412             return 0;
413         }
414 
415         uint256 c = a * b;
416         require(c / a == b, "SafeMath: multiplication overflow");
417 
418         return c;
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers. Reverts on
423      * division by zero. The result is rounded towards zero.
424      *
425      * Counterpart to Solidity's `/` operator. Note: this function uses a
426      * `revert` opcode (which leaves remaining gas untouched) while Solidity
427      * uses an invalid opcode to revert (consuming all remaining gas).
428      *
429      * Requirements:
430      *
431      * - The divisor cannot be zero.
432      */
433     function div(uint256 a, uint256 b) internal pure returns (uint256) {
434         return div(a, b, "SafeMath: division by zero");
435     }
436 
437     /**
438      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
439      * division by zero. The result is rounded towards zero.
440      *
441      * Counterpart to Solidity's `/` operator. Note: this function uses a
442      * `revert` opcode (which leaves remaining gas untouched) while Solidity
443      * uses an invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      *
447      * - The divisor cannot be zero.
448      */
449     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
450         require(b > 0, errorMessage);
451         uint256 c = a / b;
452         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
453 
454         return c;
455     }
456 
457     /**
458      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
459      * Reverts when dividing by zero.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
470         return mod(a, b, "SafeMath: modulo by zero");
471     }
472 
473     /**
474      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
475      * Reverts with custom message when dividing by zero.
476      *
477      * Counterpart to Solidity's `%` operator. This function uses a `revert`
478      * opcode (which leaves remaining gas untouched) while Solidity uses an
479      * invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b != 0, errorMessage);
487         return a % b;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0-solc-0.7
493 
494 
495 pragma solidity ^0.7.0;
496 
497 /**
498  * @dev Collection of functions related to the address type
499  */
500 library Address {
501     /**
502      * @dev Returns true if `account` is a contract.
503      *
504      * [IMPORTANT]
505      * ====
506      * It is unsafe to assume that an address for which this function returns
507      * false is an externally-owned account (EOA) and not a contract.
508      *
509      * Among others, `isContract` will return false for the following
510      * types of addresses:
511      *
512      *  - an externally-owned account
513      *  - a contract in construction
514      *  - an address where a contract will be created
515      *  - an address where a contract lived, but was destroyed
516      * ====
517      */
518     function isContract(address account) internal view returns (bool) {
519         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
520         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
521         // for accounts without code, i.e. `keccak256('')`
522         bytes32 codehash;
523         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
524         // solhint-disable-next-line no-inline-assembly
525         assembly { codehash := extcodehash(account) }
526         return (codehash != accountHash && codehash != 0x0);
527     }
528 
529     /**
530      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
531      * `recipient`, forwarding all available gas and reverting on errors.
532      *
533      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
534      * of certain opcodes, possibly making contracts go over the 2300 gas limit
535      * imposed by `transfer`, making them unable to receive funds via
536      * `transfer`. {sendValue} removes this limitation.
537      *
538      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
539      *
540      * IMPORTANT: because control is transferred to `recipient`, care must be
541      * taken to not create reentrancy vulnerabilities. Consider using
542      * {ReentrancyGuard} or the
543      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
544      */
545     function sendValue(address payable recipient, uint256 amount) internal {
546         require(address(this).balance >= amount, "Address: insufficient balance");
547 
548         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
549         (bool success, ) = recipient.call{ value: amount }("");
550         require(success, "Address: unable to send value, recipient may have reverted");
551     }
552 
553     /**
554      * @dev Performs a Solidity function call using a low level `call`. A
555      * plain`call` is an unsafe replacement for a function call: use this
556      * function instead.
557      *
558      * If `target` reverts with a revert reason, it is bubbled up by this
559      * function (like regular Solidity function calls).
560      *
561      * Returns the raw returned data. To convert to the expected return value,
562      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
563      *
564      * Requirements:
565      *
566      * - `target` must be a contract.
567      * - calling `target` with `data` must not revert.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
572       return functionCall(target, data, "Address: low-level call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
577      * `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
582         return _functionCallWithValue(target, data, 0, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but also transferring `value` wei to `target`.
588      *
589      * Requirements:
590      *
591      * - the calling contract must have an ETH balance of at least `value`.
592      * - the called Solidity function must be `payable`.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
602      * with `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         return _functionCallWithValue(target, data, value, errorMessage);
609     }
610 
611     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
612         require(isContract(target), "Address: call to non-contract");
613 
614         // solhint-disable-next-line avoid-low-level-calls
615         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 // solhint-disable-next-line no-inline-assembly
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 
636 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.1.0-solc-0.7
637 
638 
639 pragma solidity ^0.7.0;
640 
641 /**
642  * @dev Library for managing
643  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
644  * types.
645  *
646  * Sets have the following properties:
647  *
648  * - Elements are added, removed, and checked for existence in constant time
649  * (O(1)).
650  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
651  *
652  * ```
653  * contract Example {
654  *     // Add the library methods
655  *     using EnumerableSet for EnumerableSet.AddressSet;
656  *
657  *     // Declare a set state variable
658  *     EnumerableSet.AddressSet private mySet;
659  * }
660  * ```
661  *
662  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
663  * (`UintSet`) are supported.
664  */
665 library EnumerableSet {
666     // To implement this library for multiple types with as little code
667     // repetition as possible, we write it in terms of a generic Set type with
668     // bytes32 values.
669     // The Set implementation uses private functions, and user-facing
670     // implementations (such as AddressSet) are just wrappers around the
671     // underlying Set.
672     // This means that we can only create new EnumerableSets for types that fit
673     // in bytes32.
674 
675     struct Set {
676         // Storage of set values
677         bytes32[] _values;
678 
679         // Position of the value in the `values` array, plus 1 because index 0
680         // means a value is not in the set.
681         mapping (bytes32 => uint256) _indexes;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function _add(Set storage set, bytes32 value) private returns (bool) {
691         if (!_contains(set, value)) {
692             set._values.push(value);
693             // The value is stored at length-1, but we add 1 to all indexes
694             // and use 0 as a sentinel value
695             set._indexes[value] = set._values.length;
696             return true;
697         } else {
698             return false;
699         }
700     }
701 
702     /**
703      * @dev Removes a value from a set. O(1).
704      *
705      * Returns true if the value was removed from the set, that is if it was
706      * present.
707      */
708     function _remove(Set storage set, bytes32 value) private returns (bool) {
709         // We read and store the value's index to prevent multiple reads from the same storage slot
710         uint256 valueIndex = set._indexes[value];
711 
712         if (valueIndex != 0) { // Equivalent to contains(set, value)
713             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
714             // the array, and then remove the last element (sometimes called as 'swap and pop').
715             // This modifies the order of the array, as noted in {at}.
716 
717             uint256 toDeleteIndex = valueIndex - 1;
718             uint256 lastIndex = set._values.length - 1;
719 
720             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
721             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
722 
723             bytes32 lastvalue = set._values[lastIndex];
724 
725             // Move the last value to the index where the value to delete is
726             set._values[toDeleteIndex] = lastvalue;
727             // Update the index for the moved value
728             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
729 
730             // Delete the slot where the moved value was stored
731             set._values.pop();
732 
733             // Delete the index for the deleted slot
734             delete set._indexes[value];
735 
736             return true;
737         } else {
738             return false;
739         }
740     }
741 
742     /**
743      * @dev Returns true if the value is in the set. O(1).
744      */
745     function _contains(Set storage set, bytes32 value) private view returns (bool) {
746         return set._indexes[value] != 0;
747     }
748 
749     /**
750      * @dev Returns the number of values on the set. O(1).
751      */
752     function _length(Set storage set) private view returns (uint256) {
753         return set._values.length;
754     }
755 
756    /**
757     * @dev Returns the value stored at position `index` in the set. O(1).
758     *
759     * Note that there are no guarantees on the ordering of values inside the
760     * array, and it may change when more values are added or removed.
761     *
762     * Requirements:
763     *
764     * - `index` must be strictly less than {length}.
765     */
766     function _at(Set storage set, uint256 index) private view returns (bytes32) {
767         require(set._values.length > index, "EnumerableSet: index out of bounds");
768         return set._values[index];
769     }
770 
771     // AddressSet
772 
773     struct AddressSet {
774         Set _inner;
775     }
776 
777     /**
778      * @dev Add a value to a set. O(1).
779      *
780      * Returns true if the value was added to the set, that is if it was not
781      * already present.
782      */
783     function add(AddressSet storage set, address value) internal returns (bool) {
784         return _add(set._inner, bytes32(uint256(value)));
785     }
786 
787     /**
788      * @dev Removes a value from a set. O(1).
789      *
790      * Returns true if the value was removed from the set, that is if it was
791      * present.
792      */
793     function remove(AddressSet storage set, address value) internal returns (bool) {
794         return _remove(set._inner, bytes32(uint256(value)));
795     }
796 
797     /**
798      * @dev Returns true if the value is in the set. O(1).
799      */
800     function contains(AddressSet storage set, address value) internal view returns (bool) {
801         return _contains(set._inner, bytes32(uint256(value)));
802     }
803 
804     /**
805      * @dev Returns the number of values in the set. O(1).
806      */
807     function length(AddressSet storage set) internal view returns (uint256) {
808         return _length(set._inner);
809     }
810 
811    /**
812     * @dev Returns the value stored at position `index` in the set. O(1).
813     *
814     * Note that there are no guarantees on the ordering of values inside the
815     * array, and it may change when more values are added or removed.
816     *
817     * Requirements:
818     *
819     * - `index` must be strictly less than {length}.
820     */
821     function at(AddressSet storage set, uint256 index) internal view returns (address) {
822         return address(uint256(_at(set._inner, index)));
823     }
824 
825 
826     // UintSet
827 
828     struct UintSet {
829         Set _inner;
830     }
831 
832     /**
833      * @dev Add a value to a set. O(1).
834      *
835      * Returns true if the value was added to the set, that is if it was not
836      * already present.
837      */
838     function add(UintSet storage set, uint256 value) internal returns (bool) {
839         return _add(set._inner, bytes32(value));
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the value was removed from the set, that is if it was
846      * present.
847      */
848     function remove(UintSet storage set, uint256 value) internal returns (bool) {
849         return _remove(set._inner, bytes32(value));
850     }
851 
852     /**
853      * @dev Returns true if the value is in the set. O(1).
854      */
855     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
856         return _contains(set._inner, bytes32(value));
857     }
858 
859     /**
860      * @dev Returns the number of values on the set. O(1).
861      */
862     function length(UintSet storage set) internal view returns (uint256) {
863         return _length(set._inner);
864     }
865 
866    /**
867     * @dev Returns the value stored at position `index` in the set. O(1).
868     *
869     * Note that there are no guarantees on the ordering of values inside the
870     * array, and it may change when more values are added or removed.
871     *
872     * Requirements:
873     *
874     * - `index` must be strictly less than {length}.
875     */
876     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
877         return uint256(_at(set._inner, index));
878     }
879 }
880 
881 
882 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.1.0-solc-0.7
883 
884 
885 pragma solidity ^0.7.0;
886 
887 /**
888  * @dev Library for managing an enumerable variant of Solidity's
889  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
890  * type.
891  *
892  * Maps have the following properties:
893  *
894  * - Entries are added, removed, and checked for existence in constant time
895  * (O(1)).
896  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
897  *
898  * ```
899  * contract Example {
900  *     // Add the library methods
901  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
902  *
903  *     // Declare a set state variable
904  *     EnumerableMap.UintToAddressMap private myMap;
905  * }
906  * ```
907  *
908  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
909  * supported.
910  */
911 library EnumerableMap {
912     // To implement this library for multiple types with as little code
913     // repetition as possible, we write it in terms of a generic Map type with
914     // bytes32 keys and values.
915     // The Map implementation uses private functions, and user-facing
916     // implementations (such as Uint256ToAddressMap) are just wrappers around
917     // the underlying Map.
918     // This means that we can only create new EnumerableMaps for types that fit
919     // in bytes32.
920 
921     struct MapEntry {
922         bytes32 _key;
923         bytes32 _value;
924     }
925 
926     struct Map {
927         // Storage of map keys and values
928         MapEntry[] _entries;
929 
930         // Position of the entry defined by a key in the `entries` array, plus 1
931         // because index 0 means a key is not in the map.
932         mapping (bytes32 => uint256) _indexes;
933     }
934 
935     /**
936      * @dev Adds a key-value pair to a map, or updates the value for an existing
937      * key. O(1).
938      *
939      * Returns true if the key was added to the map, that is if it was not
940      * already present.
941      */
942     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
943         // We read and store the key's index to prevent multiple reads from the same storage slot
944         uint256 keyIndex = map._indexes[key];
945 
946         if (keyIndex == 0) { // Equivalent to !contains(map, key)
947             map._entries.push(MapEntry({ _key: key, _value: value }));
948             // The entry is stored at length-1, but we add 1 to all indexes
949             // and use 0 as a sentinel value
950             map._indexes[key] = map._entries.length;
951             return true;
952         } else {
953             map._entries[keyIndex - 1]._value = value;
954             return false;
955         }
956     }
957 
958     /**
959      * @dev Removes a key-value pair from a map. O(1).
960      *
961      * Returns true if the key was removed from the map, that is if it was present.
962      */
963     function _remove(Map storage map, bytes32 key) private returns (bool) {
964         // We read and store the key's index to prevent multiple reads from the same storage slot
965         uint256 keyIndex = map._indexes[key];
966 
967         if (keyIndex != 0) { // Equivalent to contains(map, key)
968             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
969             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
970             // This modifies the order of the array, as noted in {at}.
971 
972             uint256 toDeleteIndex = keyIndex - 1;
973             uint256 lastIndex = map._entries.length - 1;
974 
975             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
976             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
977 
978             MapEntry storage lastEntry = map._entries[lastIndex];
979 
980             // Move the last entry to the index where the entry to delete is
981             map._entries[toDeleteIndex] = lastEntry;
982             // Update the index for the moved entry
983             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
984 
985             // Delete the slot where the moved entry was stored
986             map._entries.pop();
987 
988             // Delete the index for the deleted slot
989             delete map._indexes[key];
990 
991             return true;
992         } else {
993             return false;
994         }
995     }
996 
997     /**
998      * @dev Returns true if the key is in the map. O(1).
999      */
1000     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1001         return map._indexes[key] != 0;
1002     }
1003 
1004     /**
1005      * @dev Returns the number of key-value pairs in the map. O(1).
1006      */
1007     function _length(Map storage map) private view returns (uint256) {
1008         return map._entries.length;
1009     }
1010 
1011    /**
1012     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1013     *
1014     * Note that there are no guarantees on the ordering of entries inside the
1015     * array, and it may change when more entries are added or removed.
1016     *
1017     * Requirements:
1018     *
1019     * - `index` must be strictly less than {length}.
1020     */
1021     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1022         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1023 
1024         MapEntry storage entry = map._entries[index];
1025         return (entry._key, entry._value);
1026     }
1027 
1028     /**
1029      * @dev Returns the value associated with `key`.  O(1).
1030      *
1031      * Requirements:
1032      *
1033      * - `key` must be in the map.
1034      */
1035     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1036         return _get(map, key, "EnumerableMap: nonexistent key");
1037     }
1038 
1039     /**
1040      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1041      */
1042     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1043         uint256 keyIndex = map._indexes[key];
1044         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1045         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1046     }
1047 
1048     // UintToAddressMap
1049 
1050     struct UintToAddressMap {
1051         Map _inner;
1052     }
1053 
1054     /**
1055      * @dev Adds a key-value pair to a map, or updates the value for an existing
1056      * key. O(1).
1057      *
1058      * Returns true if the key was added to the map, that is if it was not
1059      * already present.
1060      */
1061     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1062         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1063     }
1064 
1065     /**
1066      * @dev Removes a value from a set. O(1).
1067      *
1068      * Returns true if the key was removed from the map, that is if it was present.
1069      */
1070     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1071         return _remove(map._inner, bytes32(key));
1072     }
1073 
1074     /**
1075      * @dev Returns true if the key is in the map. O(1).
1076      */
1077     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1078         return _contains(map._inner, bytes32(key));
1079     }
1080 
1081     /**
1082      * @dev Returns the number of elements in the map. O(1).
1083      */
1084     function length(UintToAddressMap storage map) internal view returns (uint256) {
1085         return _length(map._inner);
1086     }
1087 
1088    /**
1089     * @dev Returns the element stored at position `index` in the set. O(1).
1090     * Note that there are no guarantees on the ordering of values inside the
1091     * array, and it may change when more values are added or removed.
1092     *
1093     * Requirements:
1094     *
1095     * - `index` must be strictly less than {length}.
1096     */
1097     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1098         (bytes32 key, bytes32 value) = _at(map._inner, index);
1099         return (uint256(key), address(uint256(value)));
1100     }
1101 
1102     /**
1103      * @dev Returns the value associated with `key`.  O(1).
1104      *
1105      * Requirements:
1106      *
1107      * - `key` must be in the map.
1108      */
1109     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1110         return address(uint256(_get(map._inner, bytes32(key))));
1111     }
1112 
1113     /**
1114      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1115      */
1116     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1117         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1118     }
1119 }
1120 
1121 
1122 // File @openzeppelin/contracts/utils/Strings.sol@v3.1.0-solc-0.7
1123 
1124 
1125 pragma solidity ^0.7.0;
1126 
1127 /**
1128  * @dev String operations.
1129  */
1130 library Strings {
1131     /**
1132      * @dev Converts a `uint256` to its ASCII `string` representation.
1133      */
1134     function toString(uint256 value) internal pure returns (string memory) {
1135         // Inspired by OraclizeAPI's implementation - MIT licence
1136         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1137 
1138         if (value == 0) {
1139             return "0";
1140         }
1141         uint256 temp = value;
1142         uint256 digits;
1143         while (temp != 0) {
1144             digits++;
1145             temp /= 10;
1146         }
1147         bytes memory buffer = new bytes(digits);
1148         uint256 index = digits - 1;
1149         temp = value;
1150         while (temp != 0) {
1151             buffer[index--] = byte(uint8(48 + temp % 10));
1152             temp /= 10;
1153         }
1154         return string(buffer);
1155     }
1156 }
1157 
1158 
1159 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.1.0-solc-0.7
1160 
1161 
1162 pragma solidity ^0.7.0;
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 /**
1175  * @title ERC721 Non-Fungible Token Standard basic implementation
1176  * @dev see https://eips.ethereum.org/EIPS/eip-721
1177  */
1178 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1179     using SafeMath for uint256;
1180     using Address for address;
1181     using EnumerableSet for EnumerableSet.UintSet;
1182     using EnumerableMap for EnumerableMap.UintToAddressMap;
1183     using Strings for uint256;
1184 
1185     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1186     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1187     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1188 
1189     // Mapping from holder address to their (enumerable) set of owned tokens
1190     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1191 
1192     // Enumerable mapping from token ids to their owners
1193     EnumerableMap.UintToAddressMap private _tokenOwners;
1194 
1195     // Mapping from token ID to approved address
1196     mapping (uint256 => address) private _tokenApprovals;
1197 
1198     // Mapping from owner to operator approvals
1199     mapping (address => mapping (address => bool)) private _operatorApprovals;
1200 
1201     // Token name
1202     string private _name;
1203 
1204     // Token symbol
1205     string private _symbol;
1206 
1207     // Optional mapping for token URIs
1208     mapping (uint256 => string) private _tokenURIs;
1209 
1210     // Base URI
1211     string private _baseURI;
1212 
1213     /*
1214      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1215      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1216      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1217      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1218      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1219      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1220      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1221      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1222      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1223      *
1224      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1225      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1226      */
1227     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1228 
1229     /*
1230      *     bytes4(keccak256('name()')) == 0x06fdde03
1231      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1232      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1233      *
1234      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1235      */
1236     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1237 
1238     /*
1239      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1240      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1241      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1242      *
1243      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1244      */
1245     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1246 
1247     /**
1248      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1249      */
1250     constructor (string memory name, string memory symbol) {
1251         _name = name;
1252         _symbol = symbol;
1253 
1254         // register the supported interfaces to conform to ERC721 via ERC165
1255         _registerInterface(_INTERFACE_ID_ERC721);
1256         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1257         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-balanceOf}.
1262      */
1263     function balanceOf(address owner) public view override returns (uint256) {
1264         require(owner != address(0), "ERC721: balance query for the zero address");
1265 
1266         return _holderTokens[owner].length();
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-ownerOf}.
1271      */
1272     function ownerOf(uint256 tokenId) public view override returns (address) {
1273         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Metadata-name}.
1278      */
1279     function name() public view override returns (string memory) {
1280         return _name;
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Metadata-symbol}.
1285      */
1286     function symbol() public view override returns (string memory) {
1287         return _symbol;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Metadata-tokenURI}.
1292      */
1293     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1294         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1295 
1296         string memory _tokenURI = _tokenURIs[tokenId];
1297 
1298         // If there is no base URI, return the token URI.
1299         if (bytes(_baseURI).length == 0) {
1300             return _tokenURI;
1301         }
1302         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1303         if (bytes(_tokenURI).length > 0) {
1304             return string(abi.encodePacked(_baseURI, _tokenURI));
1305         }
1306         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1307         return string(abi.encodePacked(_baseURI, tokenId.toString(),".json"));
1308     }
1309 
1310     /**
1311     * @dev Returns the base URI set via {_setBaseURI}. This will be
1312     * automatically added as a prefix in {tokenURI} to each token's URI, or
1313     * to the token ID if no specific URI is set for that token ID.
1314     */
1315     function baseURI() public view returns (string memory) {
1316         return _baseURI;
1317     }
1318 
1319     /**
1320      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1321      */
1322     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1323         return _holderTokens[owner].at(index);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721Enumerable-totalSupply}.
1328      */
1329     function totalSupply() public view override returns (uint256) {
1330         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1331         return _tokenOwners.length();
1332     }
1333 
1334     /**
1335      * @dev See {IERC721Enumerable-tokenByIndex}.
1336      */
1337     function tokenByIndex(uint256 index) public view override returns (uint256) {
1338         (uint256 tokenId, ) = _tokenOwners.at(index);
1339         return tokenId;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-approve}.
1344      */
1345     function approve(address to, uint256 tokenId) public virtual override {
1346         address owner = ownerOf(tokenId);
1347         require(to != owner, "ERC721: approval to current owner");
1348 
1349         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1350             "ERC721: approve caller is not owner nor approved for all"
1351         );
1352 
1353         _approve(to, tokenId);
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-getApproved}.
1358      */
1359     function getApproved(uint256 tokenId) public view override returns (address) {
1360         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1361 
1362         return _tokenApprovals[tokenId];
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-setApprovalForAll}.
1367      */
1368     function setApprovalForAll(address operator, bool approved) public virtual override {
1369         require(operator != _msgSender(), "ERC721: approve to caller");
1370 
1371         _operatorApprovals[_msgSender()][operator] = approved;
1372         emit ApprovalForAll(_msgSender(), operator, approved);
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-isApprovedForAll}.
1377      */
1378     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1379         return _operatorApprovals[owner][operator];
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-transferFrom}.
1384      */
1385     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1386         //solhint-disable-next-line max-line-length
1387         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1388 
1389         _transfer(from, to, tokenId);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-safeTransferFrom}.
1394      */
1395     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1396         safeTransferFrom(from, to, tokenId, "");
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-safeTransferFrom}.
1401      */
1402     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1403         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1404         _safeTransfer(from, to, tokenId, _data);
1405     }
1406 
1407     /**
1408      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1409      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1410      *
1411      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1412      *
1413      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1414      * implement alternative mecanisms to perform token transfer, such as signature-based.
1415      *
1416      * Requirements:
1417      *
1418      * - `from` cannot be the zero address.
1419      * - `to` cannot be the zero address.
1420      * - `tokenId` token must exist and be owned by `from`.
1421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1426         _transfer(from, to, tokenId);
1427         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1428     }
1429 
1430     /**
1431      * @dev Returns whether `tokenId` exists.
1432      *
1433      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1434      *
1435      * Tokens start existing when they are minted (`_mint`),
1436      * and stop existing when they are burned (`_burn`).
1437      */
1438     function _exists(uint256 tokenId) internal view returns (bool) {
1439         return _tokenOwners.contains(tokenId);
1440     }
1441 
1442     /**
1443      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1444      *
1445      * Requirements:
1446      *
1447      * - `tokenId` must exist.
1448      */
1449     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1450         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1451         address owner = ownerOf(tokenId);
1452         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1453     }
1454 
1455     /**
1456      * @dev Safely mints `tokenId` and transfers it to `to`.
1457      *
1458      * Requirements:
1459      d*
1460      * - `tokenId` must not exist.
1461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _safeMint(address to, uint256 tokenId) internal virtual {
1466         _safeMint(to, tokenId, "");
1467     }
1468 
1469     /**
1470      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1471      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1472      */
1473     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1474         _mint(to, tokenId);
1475         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1476     }
1477 
1478     /**
1479      * @dev Mints `tokenId` and transfers it to `to`.
1480      *
1481      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1482      *
1483      * Requirements:
1484      *
1485      * - `tokenId` must not exist.
1486      * - `to` cannot be the zero address.
1487      *
1488      * Emits a {Transfer} event.
1489      */
1490     function _mint(address to, uint256 tokenId) internal virtual {
1491         require(to != address(0), "ERC721: mint to the zero address");
1492         require(!_exists(tokenId), "ERC721: token already minted");
1493 
1494         _beforeTokenTransfer(address(0), to, tokenId);
1495 
1496         _holderTokens[to].add(tokenId);
1497 
1498         _tokenOwners.set(tokenId, to);
1499 
1500         emit Transfer(address(0), to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev Destroys `tokenId`.
1505      * The approval is cleared when the token is burned.
1506      *
1507      * Requirements:
1508      *
1509      * - `tokenId` must exist.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function _burn(uint256 tokenId) internal virtual {
1514         address owner = ownerOf(tokenId);
1515 
1516         _beforeTokenTransfer(owner, address(0), tokenId);
1517 
1518         // Clear approvals
1519         _approve(address(0), tokenId);
1520 
1521         // Clear metadata (if any)
1522         if (bytes(_tokenURIs[tokenId]).length != 0) {
1523             delete _tokenURIs[tokenId];
1524         }
1525 
1526         _holderTokens[owner].remove(tokenId);
1527 
1528         _tokenOwners.remove(tokenId);
1529 
1530         emit Transfer(owner, address(0), tokenId);
1531     }
1532 
1533     /**
1534      * @dev Transfers `tokenId` from `from` to `to`.
1535      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1536      *
1537      * Requirements:
1538      *
1539      * - `to` cannot be the zero address.
1540      * - `tokenId` token must be owned by `from`.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1545         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1546         require(to != address(0), "ERC721: transfer to the zero address");
1547 
1548         _beforeTokenTransfer(from, to, tokenId);
1549 
1550         // Clear approvals from the previous owner
1551         _approve(address(0), tokenId);
1552 
1553         _holderTokens[from].remove(tokenId);
1554         _holderTokens[to].add(tokenId);
1555 
1556         _tokenOwners.set(tokenId, to);
1557 
1558         emit Transfer(from, to, tokenId);
1559     }
1560 
1561     /**
1562      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1563      *
1564      * Requirements:
1565      *
1566      * - `tokenId` must exist.
1567      */
1568     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1569         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1570         _tokenURIs[tokenId] = _tokenURI;
1571     }
1572 
1573     /**
1574      * @dev Internal function to set the base URI for all token IDs. It is
1575      * automatically added as a prefix to the value returned in {tokenURI},
1576      * or to the token ID if {tokenURI} is empty.
1577      */
1578     function _setBaseURI(string memory baseURI_) internal virtual {
1579         _baseURI = baseURI_;
1580     }
1581 
1582     /**
1583      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1584      * The call is not executed if the target address is not a contract.
1585      *
1586      * @param from address representing the previous owner of the given token ID
1587      * @param to target address that will receive the tokens
1588      * @param tokenId uint256 ID of the token to be transferred
1589      * @param _data bytes optional data to send along with the call
1590      * @return bool whether the call correctly returned the expected magic value
1591      */
1592     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1593         private returns (bool)
1594     {
1595         if (!to.isContract()) {
1596             return true;
1597         }
1598         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1599             IERC721Receiver(to).onERC721Received.selector,
1600             _msgSender(),
1601             from,
1602             tokenId,
1603             _data
1604         ), "ERC721: transfer to non ERC721Receiver implementer");
1605         bytes4 retval = abi.decode(returndata, (bytes4));
1606         return (retval == _ERC721_RECEIVED);
1607     }
1608 
1609     function _approve(address to, uint256 tokenId) private {
1610         _tokenApprovals[tokenId] = to;
1611         emit Approval(ownerOf(tokenId), to, tokenId);
1612     }
1613 
1614     /**
1615      * @dev Hook that is called before any token transfer. This includes minting
1616      * and burning.
1617      *
1618      * Calling conditions:
1619      *
1620      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1621      * transferred to `to`.
1622      * - When `from` is zero, `tokenId` will be minted for `to`.
1623      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      *
1627      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1628      */
1629     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1630 }
1631 
1632 
1633 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0-solc-0.7
1634 
1635 
1636 pragma solidity ^0.7.0;
1637 
1638 /**
1639  * @dev Contract module which provides a basic access control mechanism, where
1640  * there is an account (an owner) that can be granted exclusive access to
1641  * specific functions.
1642  *
1643  * By default, the owner account will be the one that deploys the contract. This
1644  * can later be changed with {transferOwnership}.
1645  *
1646  * This module is used through inheritance. It will make available the modifier
1647  * `onlyOwner`, which can be applied to your functions to restrict their use to
1648  * the owner.
1649  */
1650 contract Ownable is Context {
1651     address private _owner;
1652 
1653     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1654 
1655     /**
1656      * @dev Initializes the contract setting the deployer as the initial owner.
1657      */
1658     constructor () {
1659         address msgSender = _msgSender();
1660         _owner = msgSender;
1661         emit OwnershipTransferred(address(0), msgSender);
1662     }
1663 
1664     /**
1665      * @dev Returns the address of the current owner.
1666      */
1667     function owner() public view returns (address) {
1668         return _owner;
1669     }
1670 
1671     /**
1672      * @dev Throws if called by any account other than the owner.
1673      */
1674     modifier onlyOwner() {
1675         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1676         _;
1677     }
1678 
1679     /**
1680      * @dev Leaves the contract without owner. It will not be possible to call
1681      * `onlyOwner` functions anymore. Can only be called by the current owner.
1682      *
1683      * NOTE: Renouncing ownership will leave the contract without an owner,
1684      * thereby removing any functionality that is only available to the owner.
1685      */
1686     function renounceOwnership() public virtual onlyOwner {
1687         emit OwnershipTransferred(_owner, address(0));
1688         _owner = address(0);
1689     }
1690 
1691     /**
1692      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1693      * Can only be called by the current owner.
1694      */
1695     function transferOwnership(address newOwner) public virtual onlyOwner {
1696         require(newOwner != address(0), "Ownable: new owner is the zero address");
1697         emit OwnershipTransferred(_owner, newOwner);
1698         _owner = newOwner;
1699     }
1700 }
1701 
1702 
1703 // File contracts/PROUDLIONS.sol
1704 
1705 pragma solidity ^0.7.0;
1706 
1707 interface Gene {
1708     function balanceOf(address _user) external view returns(uint256);
1709     function ownerOf(uint256 _tokenId) external view returns(address);
1710     function burnGene(uint256 _tokenId) external ;
1711 }
1712 
1713 contract PROUDLIONSCLUB is ERC721, Ownable {
1714     
1715     using SafeMath for uint256;
1716 
1717     mapping(address => bool) public isWhitelisted;
1718     
1719     uint256 public presale_price = 61600000000000000; // 0.0616 ETH
1720     uint256 public public_price = 77000000000000000; // 0.077 ETH
1721 
1722     uint256 public MAX_PROUDLIONS = 7563;
1723 
1724     uint256 public MAX_SUPPLY_FOR_ALL = 7977;
1725     
1726     uint256 public MAX_PROUDLIONS_PRE_SALE = 4500;
1727 
1728     uint256 public MAX_PROUDLIONS_PRESALE_PERWALLET = 20;
1729 
1730     uint256 public MAX_PROUDLIONS_RESERVE_GIVEAWAY = 200;
1731 
1732     uint256 public MAX_PROUDLIONS_RESERVE_MORPHING = 200;
1733 
1734     uint256 public MAX_PROUDLIONS_RESERVE_CELEBS = 14;
1735 
1736     uint256 public rareTokenId = 7864;
1737 
1738     uint256 public legendryTokenId = 7764;
1739 
1740     uint256 public celebTokenId = 7964;
1741 
1742     uint256 public giveAwayTokenId = 7564;
1743 
1744     uint256 public publicMintAllowed = 7563;
1745 
1746     uint256 public mintIndex = 0;
1747 
1748     Gene public gene;
1749 
1750     Gene public erc20Name;
1751 
1752     bool public saleIsActive = false;
1753 
1754     bool public preSaleIsActive = false;
1755 
1756     mapping (uint256 => bool) _checkStake;
1757 
1758 
1759     constructor() ERC721("Proud Lions Club", "PLC") {
1760         isWhitelisted[owner()]=true;       
1761     }
1762     
1763     function withdraw() external onlyOwner()
1764     {
1765         uint256 mainPlcWalletPart = (60 * address(this).balance) /100;
1766         uint256 marketingWalletPart  = (10 * address(this).balance) /100;
1767         uint256 communityWalletPart  = (20 * address(this).balance) /100;
1768         uint256 donationWalletPart = (10 * address(this).balance) /100;
1769         payable(0xffcCD0cc32C9Bf7c269484069dc485e0941eba35).transfer(mainPlcWalletPart);
1770         payable(0xD879F5644D4EfdB4b8D1f91D64D9C9283812De5D).transfer(marketingWalletPart);
1771         payable(0x27C179E8174aE93c3886AD42cC79820cC9F1E4FE).transfer(communityWalletPart);
1772         payable(0x4e6dee6173FD9Cf876CFc11F1C9143a42Da76bA0).transfer(donationWalletPart);
1773     }
1774     
1775     function setGeneAddress(address _addr) public onlyOwner() {
1776         gene = Gene(_addr);
1777     }
1778 
1779     function setErc20NameAddress(address _erc20NameAddress) public onlyOwner() {
1780         erc20Name = Gene(_erc20NameAddress);
1781     }
1782 
1783     function setPreSaleWalletLimit(uint256 limit) public onlyOwner(){
1784         MAX_PROUDLIONS_PRESALE_PERWALLET = limit;
1785     }
1786 
1787     function flipSaleState() public  onlyOwner(){
1788         saleIsActive = !saleIsActive;
1789     }
1790 
1791     function flipPreSaleState() public  onlyOwner(){
1792         preSaleIsActive = !preSaleIsActive;
1793     }
1794 
1795     function setBaseURI(string memory baseURI) public  onlyOwner(){
1796         _setBaseURI(baseURI);
1797     } 
1798 
1799     function setIsStake(uint256 _tokenId, bool _isStake) external  {
1800         require(msg.sender == address(erc20Name), "you are not allowed to execute this function");
1801        _checkStake[_tokenId] = _isStake;
1802     }  
1803 
1804     function transferFrom(address from, address to, uint256 tokenId) public override {
1805        
1806         require(_checkStake[tokenId] == false, "You cannot transfer this token, it's on stake");
1807         ERC721.transferFrom(from, to, tokenId);
1808     }
1809 
1810 
1811     function safeTransferFrom(address from, address to, uint256 tokenId) public override {
1812        
1813         require(_checkStake[tokenId] == false, "You cannot transfer this token, it's on stake");
1814          ERC721.safeTransferFrom(from, to, tokenId);
1815     }
1816 
1817     function setPrice(uint _price) public onlyOwner() {
1818         public_price = _price;
1819     }
1820 
1821     function setPricePresale(uint _price) public onlyOwner() {
1822         presale_price = _price;
1823     }
1824 
1825     function setTokenIdLimits(uint256 _rareTokenId, uint256 _legendryTokenId, uint256 _celebTokenId, uint256 _giveAwayTokenId) public onlyOwner() {
1826         rareTokenId = _rareTokenId;
1827         legendryTokenId = _legendryTokenId;
1828         celebTokenId = _celebTokenId;
1829         giveAwayTokenId = _giveAwayTokenId;
1830     }
1831 
1832     
1833     function morphing(uint256 tokenId1, uint256 tokenId2, uint256 geneId) external {
1834         require(tokenId1 < legendryTokenId && tokenId2 < legendryTokenId, "you are not allowed to use these tokenIds");
1835         require(gene.ownerOf(geneId) == msg.sender, "Caller is not the owner of gene");
1836         require(ownerOf(tokenId1) == msg.sender, "Caller is not the owner of token1");
1837         require(ownerOf(tokenId2) == msg.sender, "Caller is not the owner of token2");
1838         require(geneId <= 200, "Gene are ended");
1839         if(geneId <= 100) {
1840 
1841             _safeMint(msg.sender, rareTokenId);
1842             rareTokenId = rareTokenId + 1;
1843             
1844         }else{
1845             _safeMint(msg.sender, legendryTokenId);
1846             legendryTokenId = legendryTokenId + 1;
1847         }
1848             _burn(tokenId1); 
1849             _burn(tokenId2);
1850             gene.burnGene(geneId);
1851     } 
1852     
1853     function giveAway(address[] memory _addresses,  uint256[] memory _tokenId) public onlyOwner(){
1854         require(_addresses.length == _tokenId.length, "Must provide same number of address and token ids");
1855          for(uint i = 0; i < _addresses.length; i++){
1856             require(_tokenId[i] < legendryTokenId &&  _tokenId[i] >= giveAwayTokenId, "This token id is not allowed");
1857             _safeMint(_addresses[i], _tokenId[i]);
1858         }
1859                 
1860     }
1861 
1862     function giveAwayCelebs(address[] memory _addresses, uint256[] memory _tokenId) public onlyOwner(){
1863         require(_addresses.length == _tokenId.length, "Must provide same number of address and token ids");
1864          for(uint i = 0; i < _addresses.length; i++){
1865             require(_tokenId[i] <= MAX_SUPPLY_FOR_ALL &&  _tokenId[i] >= celebTokenId, "This token id is not allowed");
1866             _safeMint(_addresses[i], _tokenId[i]);
1867         }
1868     }
1869 
1870     function WhiteListMany(address[] memory _addrs, bool _isWhitelisted)
1871         external
1872         onlyOwner
1873     {
1874         uint256 addrLen = _addrs.length;
1875         for (uint256 i = 0; i < addrLen; i++) {
1876             _setIsWhitelisted(_addrs[i], _isWhitelisted);
1877         }
1878     }
1879 
1880     function WhiteListSingle(address _addr, bool _isWhitelisted) external onlyOwner {
1881         _setIsWhitelisted(_addr, _isWhitelisted);
1882     }
1883 
1884      function _setIsWhitelisted(address _addr, bool _isWhitelisted) internal {
1885         isWhitelisted[_addr] = _isWhitelisted;
1886     }
1887 
1888     function mintProudLions(uint numberOfTokens) public payable {
1889         require(saleIsActive, "Sale must be active to mint One Lions");
1890         require(mintIndex.add(numberOfTokens) <= MAX_PROUDLIONS, "Purchase would exceed max supply of One Lions");
1891         require(msg.value >= public_price.mul(numberOfTokens), "Ether value sent is not correct");
1892 
1893         for(uint i = 0; i < numberOfTokens; i++) {
1894             if (mintIndex < MAX_PROUDLIONS) {
1895                 _safeMint(msg.sender, mintIndex + 1);
1896                 mintIndex += 1;
1897             }
1898         }
1899     }
1900     
1901     function mintProudLionsPreSale(uint numberOfTokens) public payable {
1902         require(isWhitelisted[msg.sender] == true, "You are not the whiteListed member");
1903         require(preSaleIsActive, "Private Sale must be active to mint One Lions");
1904         require(numberOfTokens + balanceOf(msg.sender) <= MAX_PROUDLIONS_PRESALE_PERWALLET, "You have exceeded max ProudLions limit per wallet");
1905         require(numberOfTokens <= MAX_PROUDLIONS_PRESALE_PERWALLET, "You have exceeded max ProudLions limit per transaction for pre sale");
1906         require(mintIndex.add(numberOfTokens) <= MAX_PROUDLIONS_PRE_SALE, "Purchase would exceed max supply of One Lions");
1907         require(msg.value >= presale_price.mul(numberOfTokens), "Ether value sent is not correct");
1908 
1909         for(uint i = 0; i < numberOfTokens; i++) {
1910             if (mintIndex < MAX_PROUDLIONS_PRE_SALE) {
1911                 _safeMint(msg.sender, mintIndex + 1);
1912                 mintIndex += 1;
1913             }
1914         }
1915     }
1916     
1917 }