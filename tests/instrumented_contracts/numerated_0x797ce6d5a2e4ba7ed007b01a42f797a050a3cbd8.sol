1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
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
28 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
56 
57 // SPDX-License-Identifier: MIT
58 
59 pragma solidity ^0.6.2;
60 
61 
62 /**
63  * @dev Required interface of an ERC721 compliant contract.
64  */
65 interface IERC721 is IERC165 {
66     /**
67      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
73      */
74     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
80 
81     /**
82      * @dev Returns the number of tokens in ``owner``'s account.
83      */
84     function balanceOf(address owner) external view returns (uint256 balance);
85 
86     /**
87      * @dev Returns the owner of the `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(address from, address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address from, address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171       * @dev Safely transfers `tokenId` token from `from` to `to`.
172       *
173       * Requirements:
174       *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177       * - `tokenId` token must exist and be owned by `from`.
178       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180       *
181       * Emits a {Transfer} event.
182       */
183     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
184 }
185 
186 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
187 
188 // SPDX-License-Identifier: MIT
189 
190 pragma solidity ^0.6.2;
191 
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198 
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
216 
217 // SPDX-License-Identifier: MIT
218 
219 pragma solidity ^0.6.2;
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Enumerable is IERC721 {
227 
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
247 
248 // SPDX-License-Identifier: MIT
249 
250 pragma solidity ^0.6.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
268     external returns (bytes4);
269 }
270 
271 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
272 
273 // SPDX-License-Identifier: MIT
274 
275 pragma solidity ^0.6.0;
276 
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
295     constructor () internal {
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
327 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
328 
329 // SPDX-License-Identifier: MIT
330 
331 pragma solidity ^0.6.0;
332 
333 /**
334  * @dev Wrappers over Solidity's arithmetic operations with added overflow
335  * checks.
336  *
337  * Arithmetic operations in Solidity wrap on overflow. This can easily result
338  * in bugs, because programmers usually assume that an overflow raises an
339  * error, which is the standard behavior in high level programming languages.
340  * `SafeMath` restores this intuition by reverting the transaction when an
341  * operation overflows.
342  *
343  * Using this library instead of the unchecked operations eliminates an entire
344  * class of bugs, so it's recommended to use it always.
345  */
346 library SafeMath {
347     /**
348      * @dev Returns the addition of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `+` operator.
352      *
353      * Requirements:
354      *
355      * - Addition cannot overflow.
356      */
357     function add(uint256 a, uint256 b) internal pure returns (uint256) {
358         uint256 c = a + b;
359         require(c >= a, "SafeMath: addition overflow");
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the subtraction of two unsigned integers, reverting on
366      * overflow (when the result is negative).
367      *
368      * Counterpart to Solidity's `-` operator.
369      *
370      * Requirements:
371      *
372      * - Subtraction cannot overflow.
373      */
374     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375         return sub(a, b, "SafeMath: subtraction overflow");
376     }
377 
378     /**
379      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
380      * overflow (when the result is negative).
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      *
386      * - Subtraction cannot overflow.
387      */
388     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b <= a, errorMessage);
390         uint256 c = a - b;
391 
392         return c;
393     }
394 
395     /**
396      * @dev Returns the multiplication of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `*` operator.
400      *
401      * Requirements:
402      *
403      * - Multiplication cannot overflow.
404      */
405     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
407         // benefit is lost if 'b' is also tested.
408         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
409         if (a == 0) {
410             return 0;
411         }
412 
413         uint256 c = a * b;
414         require(c / a == b, "SafeMath: multiplication overflow");
415 
416         return c;
417     }
418 
419     /**
420      * @dev Returns the integer division of two unsigned integers. Reverts on
421      * division by zero. The result is rounded towards zero.
422      *
423      * Counterpart to Solidity's `/` operator. Note: this function uses a
424      * `revert` opcode (which leaves remaining gas untouched) while Solidity
425      * uses an invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function div(uint256 a, uint256 b) internal pure returns (uint256) {
432         return div(a, b, "SafeMath: division by zero");
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator. Note: this function uses a
440      * `revert` opcode (which leaves remaining gas untouched) while Solidity
441      * uses an invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
448         require(b > 0, errorMessage);
449         uint256 c = a / b;
450         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
451 
452         return c;
453     }
454 
455     /**
456      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
457      * Reverts when dividing by zero.
458      *
459      * Counterpart to Solidity's `%` operator. This function uses a `revert`
460      * opcode (which leaves remaining gas untouched) while Solidity uses an
461      * invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
468         return mod(a, b, "SafeMath: modulo by zero");
469     }
470 
471     /**
472      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
473      * Reverts with custom message when dividing by zero.
474      *
475      * Counterpart to Solidity's `%` operator. This function uses a `revert`
476      * opcode (which leaves remaining gas untouched) while Solidity uses an
477      * invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
484         require(b != 0, errorMessage);
485         return a % b;
486     }
487 }
488 
489 // File: openzeppelin-solidity/contracts/utils/Address.sol
490 
491 // SPDX-License-Identifier: MIT
492 
493 pragma solidity ^0.6.2;
494 
495 /**
496  * @dev Collection of functions related to the address type
497  */
498 library Address {
499     /**
500      * @dev Returns true if `account` is a contract.
501      *
502      * [IMPORTANT]
503      * ====
504      * It is unsafe to assume that an address for which this function returns
505      * false is an externally-owned account (EOA) and not a contract.
506      *
507      * Among others, `isContract` will return false for the following
508      * types of addresses:
509      *
510      *  - an externally-owned account
511      *  - a contract in construction
512      *  - an address where a contract will be created
513      *  - an address where a contract lived, but was destroyed
514      * ====
515      */
516     function isContract(address account) internal view returns (bool) {
517         // This method relies in extcodesize, which returns 0 for contracts in
518         // construction, since the code is only stored at the end of the
519         // constructor execution.
520 
521         uint256 size;
522         // solhint-disable-next-line no-inline-assembly
523         assembly { size := extcodesize(account) }
524         return size > 0;
525     }
526 
527     /**
528      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
529      * `recipient`, forwarding all available gas and reverting on errors.
530      *
531      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
532      * of certain opcodes, possibly making contracts go over the 2300 gas limit
533      * imposed by `transfer`, making them unable to receive funds via
534      * `transfer`. {sendValue} removes this limitation.
535      *
536      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
537      *
538      * IMPORTANT: because control is transferred to `recipient`, care must be
539      * taken to not create reentrancy vulnerabilities. Consider using
540      * {ReentrancyGuard} or the
541      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
542      */
543     function sendValue(address payable recipient, uint256 amount) internal {
544         require(address(this).balance >= amount, "Address: insufficient balance");
545 
546         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
547         (bool success, ) = recipient.call{ value: amount }("");
548         require(success, "Address: unable to send value, recipient may have reverted");
549     }
550 
551     /**
552      * @dev Performs a Solidity function call using a low level `call`. A
553      * plain`call` is an unsafe replacement for a function call: use this
554      * function instead.
555      *
556      * If `target` reverts with a revert reason, it is bubbled up by this
557      * function (like regular Solidity function calls).
558      *
559      * Returns the raw returned data. To convert to the expected return value,
560      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
561      *
562      * Requirements:
563      *
564      * - `target` must be a contract.
565      * - calling `target` with `data` must not revert.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
570       return functionCall(target, data, "Address: low-level call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
575      * `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
580         return _functionCallWithValue(target, data, 0, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but also transferring `value` wei to `target`.
586      *
587      * Requirements:
588      *
589      * - the calling contract must have an ETH balance of at least `value`.
590      * - the called Solidity function must be `payable`.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
595         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
600      * with `errorMessage` as a fallback revert reason when `target` reverts.
601      *
602      * _Available since v3.1._
603      */
604     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
605         require(address(this).balance >= value, "Address: insufficient balance for call");
606         return _functionCallWithValue(target, data, value, errorMessage);
607     }
608 
609     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
610         require(isContract(target), "Address: call to non-contract");
611 
612         // solhint-disable-next-line avoid-low-level-calls
613         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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
633 // File: openzeppelin-solidity/contracts/utils/EnumerableSet.sol
634 
635 // SPDX-License-Identifier: MIT
636 
637 pragma solidity ^0.6.0;
638 
639 /**
640  * @dev Library for managing
641  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
642  * types.
643  *
644  * Sets have the following properties:
645  *
646  * - Elements are added, removed, and checked for existence in constant time
647  * (O(1)).
648  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
649  *
650  * ```
651  * contract Example {
652  *     // Add the library methods
653  *     using EnumerableSet for EnumerableSet.AddressSet;
654  *
655  *     // Declare a set state variable
656  *     EnumerableSet.AddressSet private mySet;
657  * }
658  * ```
659  *
660  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
661  * (`UintSet`) are supported.
662  */
663 library EnumerableSet {
664     // To implement this library for multiple types with as little code
665     // repetition as possible, we write it in terms of a generic Set type with
666     // bytes32 values.
667     // The Set implementation uses private functions, and user-facing
668     // implementations (such as AddressSet) are just wrappers around the
669     // underlying Set.
670     // This means that we can only create new EnumerableSets for types that fit
671     // in bytes32.
672 
673     struct Set {
674         // Storage of set values
675         bytes32[] _values;
676 
677         // Position of the value in the `values` array, plus 1 because index 0
678         // means a value is not in the set.
679         mapping (bytes32 => uint256) _indexes;
680     }
681 
682     /**
683      * @dev Add a value to a set. O(1).
684      *
685      * Returns true if the value was added to the set, that is if it was not
686      * already present.
687      */
688     function _add(Set storage set, bytes32 value) private returns (bool) {
689         if (!_contains(set, value)) {
690             set._values.push(value);
691             // The value is stored at length-1, but we add 1 to all indexes
692             // and use 0 as a sentinel value
693             set._indexes[value] = set._values.length;
694             return true;
695         } else {
696             return false;
697         }
698     }
699 
700     /**
701      * @dev Removes a value from a set. O(1).
702      *
703      * Returns true if the value was removed from the set, that is if it was
704      * present.
705      */
706     function _remove(Set storage set, bytes32 value) private returns (bool) {
707         // We read and store the value's index to prevent multiple reads from the same storage slot
708         uint256 valueIndex = set._indexes[value];
709 
710         if (valueIndex != 0) { // Equivalent to contains(set, value)
711             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
712             // the array, and then remove the last element (sometimes called as 'swap and pop').
713             // This modifies the order of the array, as noted in {at}.
714 
715             uint256 toDeleteIndex = valueIndex - 1;
716             uint256 lastIndex = set._values.length - 1;
717 
718             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
719             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
720 
721             bytes32 lastvalue = set._values[lastIndex];
722 
723             // Move the last value to the index where the value to delete is
724             set._values[toDeleteIndex] = lastvalue;
725             // Update the index for the moved value
726             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
727 
728             // Delete the slot where the moved value was stored
729             set._values.pop();
730 
731             // Delete the index for the deleted slot
732             delete set._indexes[value];
733 
734             return true;
735         } else {
736             return false;
737         }
738     }
739 
740     /**
741      * @dev Returns true if the value is in the set. O(1).
742      */
743     function _contains(Set storage set, bytes32 value) private view returns (bool) {
744         return set._indexes[value] != 0;
745     }
746 
747     /**
748      * @dev Returns the number of values on the set. O(1).
749      */
750     function _length(Set storage set) private view returns (uint256) {
751         return set._values.length;
752     }
753 
754    /**
755     * @dev Returns the value stored at position `index` in the set. O(1).
756     *
757     * Note that there are no guarantees on the ordering of values inside the
758     * array, and it may change when more values are added or removed.
759     *
760     * Requirements:
761     *
762     * - `index` must be strictly less than {length}.
763     */
764     function _at(Set storage set, uint256 index) private view returns (bytes32) {
765         require(set._values.length > index, "EnumerableSet: index out of bounds");
766         return set._values[index];
767     }
768 
769     // AddressSet
770 
771     struct AddressSet {
772         Set _inner;
773     }
774 
775     /**
776      * @dev Add a value to a set. O(1).
777      *
778      * Returns true if the value was added to the set, that is if it was not
779      * already present.
780      */
781     function add(AddressSet storage set, address value) internal returns (bool) {
782         return _add(set._inner, bytes32(uint256(value)));
783     }
784 
785     /**
786      * @dev Removes a value from a set. O(1).
787      *
788      * Returns true if the value was removed from the set, that is if it was
789      * present.
790      */
791     function remove(AddressSet storage set, address value) internal returns (bool) {
792         return _remove(set._inner, bytes32(uint256(value)));
793     }
794 
795     /**
796      * @dev Returns true if the value is in the set. O(1).
797      */
798     function contains(AddressSet storage set, address value) internal view returns (bool) {
799         return _contains(set._inner, bytes32(uint256(value)));
800     }
801 
802     /**
803      * @dev Returns the number of values in the set. O(1).
804      */
805     function length(AddressSet storage set) internal view returns (uint256) {
806         return _length(set._inner);
807     }
808 
809    /**
810     * @dev Returns the value stored at position `index` in the set. O(1).
811     *
812     * Note that there are no guarantees on the ordering of values inside the
813     * array, and it may change when more values are added or removed.
814     *
815     * Requirements:
816     *
817     * - `index` must be strictly less than {length}.
818     */
819     function at(AddressSet storage set, uint256 index) internal view returns (address) {
820         return address(uint256(_at(set._inner, index)));
821     }
822 
823 
824     // UintSet
825 
826     struct UintSet {
827         Set _inner;
828     }
829 
830     /**
831      * @dev Add a value to a set. O(1).
832      *
833      * Returns true if the value was added to the set, that is if it was not
834      * already present.
835      */
836     function add(UintSet storage set, uint256 value) internal returns (bool) {
837         return _add(set._inner, bytes32(value));
838     }
839 
840     /**
841      * @dev Removes a value from a set. O(1).
842      *
843      * Returns true if the value was removed from the set, that is if it was
844      * present.
845      */
846     function remove(UintSet storage set, uint256 value) internal returns (bool) {
847         return _remove(set._inner, bytes32(value));
848     }
849 
850     /**
851      * @dev Returns true if the value is in the set. O(1).
852      */
853     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
854         return _contains(set._inner, bytes32(value));
855     }
856 
857     /**
858      * @dev Returns the number of values on the set. O(1).
859      */
860     function length(UintSet storage set) internal view returns (uint256) {
861         return _length(set._inner);
862     }
863 
864    /**
865     * @dev Returns the value stored at position `index` in the set. O(1).
866     *
867     * Note that there are no guarantees on the ordering of values inside the
868     * array, and it may change when more values are added or removed.
869     *
870     * Requirements:
871     *
872     * - `index` must be strictly less than {length}.
873     */
874     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
875         return uint256(_at(set._inner, index));
876     }
877 }
878 
879 // File: openzeppelin-solidity/contracts/utils/EnumerableMap.sol
880 
881 // SPDX-License-Identifier: MIT
882 
883 pragma solidity ^0.6.0;
884 
885 /**
886  * @dev Library for managing an enumerable variant of Solidity's
887  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
888  * type.
889  *
890  * Maps have the following properties:
891  *
892  * - Entries are added, removed, and checked for existence in constant time
893  * (O(1)).
894  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
895  *
896  * ```
897  * contract Example {
898  *     // Add the library methods
899  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
900  *
901  *     // Declare a set state variable
902  *     EnumerableMap.UintToAddressMap private myMap;
903  * }
904  * ```
905  *
906  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
907  * supported.
908  */
909 library EnumerableMap {
910     // To implement this library for multiple types with as little code
911     // repetition as possible, we write it in terms of a generic Map type with
912     // bytes32 keys and values.
913     // The Map implementation uses private functions, and user-facing
914     // implementations (such as Uint256ToAddressMap) are just wrappers around
915     // the underlying Map.
916     // This means that we can only create new EnumerableMaps for types that fit
917     // in bytes32.
918 
919     struct MapEntry {
920         bytes32 _key;
921         bytes32 _value;
922     }
923 
924     struct Map {
925         // Storage of map keys and values
926         MapEntry[] _entries;
927 
928         // Position of the entry defined by a key in the `entries` array, plus 1
929         // because index 0 means a key is not in the map.
930         mapping (bytes32 => uint256) _indexes;
931     }
932 
933     /**
934      * @dev Adds a key-value pair to a map, or updates the value for an existing
935      * key. O(1).
936      *
937      * Returns true if the key was added to the map, that is if it was not
938      * already present.
939      */
940     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
941         // We read and store the key's index to prevent multiple reads from the same storage slot
942         uint256 keyIndex = map._indexes[key];
943 
944         if (keyIndex == 0) { // Equivalent to !contains(map, key)
945             map._entries.push(MapEntry({ _key: key, _value: value }));
946             // The entry is stored at length-1, but we add 1 to all indexes
947             // and use 0 as a sentinel value
948             map._indexes[key] = map._entries.length;
949             return true;
950         } else {
951             map._entries[keyIndex - 1]._value = value;
952             return false;
953         }
954     }
955 
956     /**
957      * @dev Removes a key-value pair from a map. O(1).
958      *
959      * Returns true if the key was removed from the map, that is if it was present.
960      */
961     function _remove(Map storage map, bytes32 key) private returns (bool) {
962         // We read and store the key's index to prevent multiple reads from the same storage slot
963         uint256 keyIndex = map._indexes[key];
964 
965         if (keyIndex != 0) { // Equivalent to contains(map, key)
966             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
967             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
968             // This modifies the order of the array, as noted in {at}.
969 
970             uint256 toDeleteIndex = keyIndex - 1;
971             uint256 lastIndex = map._entries.length - 1;
972 
973             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
974             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
975 
976             MapEntry storage lastEntry = map._entries[lastIndex];
977 
978             // Move the last entry to the index where the entry to delete is
979             map._entries[toDeleteIndex] = lastEntry;
980             // Update the index for the moved entry
981             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
982 
983             // Delete the slot where the moved entry was stored
984             map._entries.pop();
985 
986             // Delete the index for the deleted slot
987             delete map._indexes[key];
988 
989             return true;
990         } else {
991             return false;
992         }
993     }
994 
995     /**
996      * @dev Returns true if the key is in the map. O(1).
997      */
998     function _contains(Map storage map, bytes32 key) private view returns (bool) {
999         return map._indexes[key] != 0;
1000     }
1001 
1002     /**
1003      * @dev Returns the number of key-value pairs in the map. O(1).
1004      */
1005     function _length(Map storage map) private view returns (uint256) {
1006         return map._entries.length;
1007     }
1008 
1009    /**
1010     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1011     *
1012     * Note that there are no guarantees on the ordering of entries inside the
1013     * array, and it may change when more entries are added or removed.
1014     *
1015     * Requirements:
1016     *
1017     * - `index` must be strictly less than {length}.
1018     */
1019     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1020         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1021 
1022         MapEntry storage entry = map._entries[index];
1023         return (entry._key, entry._value);
1024     }
1025 
1026     /**
1027      * @dev Returns the value associated with `key`.  O(1).
1028      *
1029      * Requirements:
1030      *
1031      * - `key` must be in the map.
1032      */
1033     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1034         return _get(map, key, "EnumerableMap: nonexistent key");
1035     }
1036 
1037     /**
1038      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1039      */
1040     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1041         uint256 keyIndex = map._indexes[key];
1042         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1043         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1044     }
1045 
1046     // UintToAddressMap
1047 
1048     struct UintToAddressMap {
1049         Map _inner;
1050     }
1051 
1052     /**
1053      * @dev Adds a key-value pair to a map, or updates the value for an existing
1054      * key. O(1).
1055      *
1056      * Returns true if the key was added to the map, that is if it was not
1057      * already present.
1058      */
1059     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1060         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1061     }
1062 
1063     /**
1064      * @dev Removes a value from a set. O(1).
1065      *
1066      * Returns true if the key was removed from the map, that is if it was present.
1067      */
1068     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1069         return _remove(map._inner, bytes32(key));
1070     }
1071 
1072     /**
1073      * @dev Returns true if the key is in the map. O(1).
1074      */
1075     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1076         return _contains(map._inner, bytes32(key));
1077     }
1078 
1079     /**
1080      * @dev Returns the number of elements in the map. O(1).
1081      */
1082     function length(UintToAddressMap storage map) internal view returns (uint256) {
1083         return _length(map._inner);
1084     }
1085 
1086    /**
1087     * @dev Returns the element stored at position `index` in the set. O(1).
1088     * Note that there are no guarantees on the ordering of values inside the
1089     * array, and it may change when more values are added or removed.
1090     *
1091     * Requirements:
1092     *
1093     * - `index` must be strictly less than {length}.
1094     */
1095     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1096         (bytes32 key, bytes32 value) = _at(map._inner, index);
1097         return (uint256(key), address(uint256(value)));
1098     }
1099 
1100     /**
1101      * @dev Returns the value associated with `key`.  O(1).
1102      *
1103      * Requirements:
1104      *
1105      * - `key` must be in the map.
1106      */
1107     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1108         return address(uint256(_get(map._inner, bytes32(key))));
1109     }
1110 
1111     /**
1112      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1113      */
1114     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1115         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1116     }
1117 }
1118 
1119 // File: openzeppelin-solidity/contracts/utils/Strings.sol
1120 
1121 // SPDX-License-Identifier: MIT
1122 
1123 pragma solidity ^0.6.0;
1124 
1125 /**
1126  * @dev String operations.
1127  */
1128 library Strings {
1129     /**
1130      * @dev Converts a `uint256` to its ASCII `string` representation.
1131      */
1132     function toString(uint256 value) internal pure returns (string memory) {
1133         // Inspired by OraclizeAPI's implementation - MIT licence
1134         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1135 
1136         if (value == 0) {
1137             return "0";
1138         }
1139         uint256 temp = value;
1140         uint256 digits;
1141         while (temp != 0) {
1142             digits++;
1143             temp /= 10;
1144         }
1145         bytes memory buffer = new bytes(digits);
1146         uint256 index = digits - 1;
1147         temp = value;
1148         while (temp != 0) {
1149             buffer[index--] = byte(uint8(48 + temp % 10));
1150             temp /= 10;
1151         }
1152         return string(buffer);
1153     }
1154 }
1155 
1156 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1157 
1158 // SPDX-License-Identifier: MIT
1159 
1160 pragma solidity ^0.6.0;
1161 
1162 
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
1173 /**
1174  * @title ERC721 Non-Fungible Token Standard basic implementation
1175  * @dev see https://eips.ethereum.org/EIPS/eip-721
1176  */
1177 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1178     using SafeMath for uint256;
1179     using Address for address;
1180     using EnumerableSet for EnumerableSet.UintSet;
1181     using EnumerableMap for EnumerableMap.UintToAddressMap;
1182     using Strings for uint256;
1183 
1184     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1185     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1186     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1187 
1188     // Mapping from holder address to their (enumerable) set of owned tokens
1189     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1190 
1191     // Enumerable mapping from token ids to their owners
1192     EnumerableMap.UintToAddressMap private _tokenOwners;
1193 
1194     // Mapping from token ID to approved address
1195     mapping (uint256 => address) private _tokenApprovals;
1196 
1197     // Mapping from owner to operator approvals
1198     mapping (address => mapping (address => bool)) private _operatorApprovals;
1199 
1200     // Token name
1201     string private _name;
1202 
1203     // Token symbol
1204     string private _symbol;
1205 
1206     // Optional mapping for token URIs
1207     mapping (uint256 => string) private _tokenURIs;
1208 
1209     // Base URI
1210     string private _baseURI;
1211 
1212     /*
1213      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1214      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1215      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1216      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1217      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1218      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1219      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1220      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1221      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1222      *
1223      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1224      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1225      */
1226     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1227 
1228     /*
1229      *     bytes4(keccak256('name()')) == 0x06fdde03
1230      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1231      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1232      *
1233      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1234      */
1235     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1236 
1237     /*
1238      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1239      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1240      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1241      *
1242      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1243      */
1244     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1245 
1246     /**
1247      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1248      */
1249     constructor (string memory name, string memory symbol) public {
1250         _name = name;
1251         _symbol = symbol;
1252 
1253         // register the supported interfaces to conform to ERC721 via ERC165
1254         _registerInterface(_INTERFACE_ID_ERC721);
1255         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1256         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-balanceOf}.
1261      */
1262     function balanceOf(address owner) public view override returns (uint256) {
1263         require(owner != address(0), "ERC721: balance query for the zero address");
1264 
1265         return _holderTokens[owner].length();
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-ownerOf}.
1270      */
1271     function ownerOf(uint256 tokenId) public view override returns (address) {
1272         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1273     }
1274 
1275     /**
1276      * @dev See {IERC721Metadata-name}.
1277      */
1278     function name() public view override returns (string memory) {
1279         return _name;
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Metadata-symbol}.
1284      */
1285     function symbol() public view override returns (string memory) {
1286         return _symbol;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Metadata-tokenURI}.
1291      */
1292     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1293         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1294 
1295         string memory _tokenURI = _tokenURIs[tokenId];
1296 
1297         // If there is no base URI, return the token URI.
1298         if (bytes(_baseURI).length == 0) {
1299             return _tokenURI;
1300         }
1301         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1302         if (bytes(_tokenURI).length > 0) {
1303             return string(abi.encodePacked(_baseURI, _tokenURI));
1304         }
1305         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1306         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1307     }
1308 
1309     /**
1310     * @dev Returns the base URI set via {_setBaseURI}. This will be
1311     * automatically added as a prefix in {tokenURI} to each token's URI, or
1312     * to the token ID if no specific URI is set for that token ID.
1313     */
1314     function baseURI() public view returns (string memory) {
1315         return _baseURI;
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
1326      * @dev See {IERC721Enumerable-totalSupply}.
1327      */
1328     function totalSupply() public view override returns (uint256) {
1329         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1330         return _tokenOwners.length();
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Enumerable-tokenByIndex}.
1335      */
1336     function tokenByIndex(uint256 index) public view override returns (uint256) {
1337         (uint256 tokenId, ) = _tokenOwners.at(index);
1338         return tokenId;
1339     }
1340 
1341     /**
1342      * @dev See {IERC721-approve}.
1343      */
1344     function approve(address to, uint256 tokenId) public virtual override {
1345         address owner = ownerOf(tokenId);
1346         require(to != owner, "ERC721: approval to current owner");
1347 
1348         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1349             "ERC721: approve caller is not owner nor approved for all"
1350         );
1351 
1352         _approve(to, tokenId);
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-getApproved}.
1357      */
1358     function getApproved(uint256 tokenId) public view override returns (address) {
1359         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1360 
1361         return _tokenApprovals[tokenId];
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-setApprovalForAll}.
1366      */
1367     function setApprovalForAll(address operator, bool approved) public virtual override {
1368         require(operator != _msgSender(), "ERC721: approve to caller");
1369 
1370         _operatorApprovals[_msgSender()][operator] = approved;
1371         emit ApprovalForAll(_msgSender(), operator, approved);
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-isApprovedForAll}.
1376      */
1377     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1378         return _operatorApprovals[owner][operator];
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-transferFrom}.
1383      */
1384     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1385         //solhint-disable-next-line max-line-length
1386         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1387 
1388         _transfer(from, to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-safeTransferFrom}.
1393      */
1394     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1395         safeTransferFrom(from, to, tokenId, "");
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-safeTransferFrom}.
1400      */
1401     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1403         _safeTransfer(from, to, tokenId, _data);
1404     }
1405 
1406     /**
1407      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1408      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1409      *
1410      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1411      *
1412      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1413      * implement alternative mechanisms to perform token transfer, such as signature-based.
1414      *
1415      * Requirements:
1416      *
1417      * - `from` cannot be the zero address.
1418      * - `to` cannot be the zero address.
1419      * - `tokenId` token must exist and be owned by `from`.
1420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1425         _transfer(from, to, tokenId);
1426         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1427     }
1428 
1429     /**
1430      * @dev Returns whether `tokenId` exists.
1431      *
1432      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1433      *
1434      * Tokens start existing when they are minted (`_mint`),
1435      * and stop existing when they are burned (`_burn`).
1436      */
1437     function _exists(uint256 tokenId) internal view returns (bool) {
1438         return _tokenOwners.contains(tokenId);
1439     }
1440 
1441     /**
1442      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1443      *
1444      * Requirements:
1445      *
1446      * - `tokenId` must exist.
1447      */
1448     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1449         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1450         address owner = ownerOf(tokenId);
1451         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1452     }
1453 
1454     /**
1455      * @dev Safely mints `tokenId` and transfers it to `to`.
1456      *
1457      * Requirements:
1458      d*
1459      * - `tokenId` must not exist.
1460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _safeMint(address to, uint256 tokenId) internal virtual {
1465         _safeMint(to, tokenId, "");
1466     }
1467 
1468     /**
1469      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1470      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1471      */
1472     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1473         _mint(to, tokenId);
1474         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1475     }
1476 
1477     /**
1478      * @dev Mints `tokenId` and transfers it to `to`.
1479      *
1480      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1481      *
1482      * Requirements:
1483      *
1484      * - `tokenId` must not exist.
1485      * - `to` cannot be the zero address.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _mint(address to, uint256 tokenId) internal virtual {
1490         require(to != address(0), "ERC721: mint to the zero address");
1491         require(!_exists(tokenId), "ERC721: token already minted");
1492 
1493         _beforeTokenTransfer(address(0), to, tokenId);
1494 
1495         _holderTokens[to].add(tokenId);
1496 
1497         _tokenOwners.set(tokenId, to);
1498 
1499         emit Transfer(address(0), to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev Destroys `tokenId`.
1504      * The approval is cleared when the token is burned.
1505      *
1506      * Requirements:
1507      *
1508      * - `tokenId` must exist.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _burn(uint256 tokenId) internal virtual {
1513         address owner = ownerOf(tokenId);
1514 
1515         _beforeTokenTransfer(owner, address(0), tokenId);
1516 
1517         // Clear approvals
1518         _approve(address(0), tokenId);
1519 
1520         // Clear metadata (if any)
1521         if (bytes(_tokenURIs[tokenId]).length != 0) {
1522             delete _tokenURIs[tokenId];
1523         }
1524 
1525         _holderTokens[owner].remove(tokenId);
1526 
1527         _tokenOwners.remove(tokenId);
1528 
1529         emit Transfer(owner, address(0), tokenId);
1530     }
1531 
1532     /**
1533      * @dev Transfers `tokenId` from `from` to `to`.
1534      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1535      *
1536      * Requirements:
1537      *
1538      * - `to` cannot be the zero address.
1539      * - `tokenId` token must be owned by `from`.
1540      *
1541      * Emits a {Transfer} event.
1542      */
1543     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1544         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1545         require(to != address(0), "ERC721: transfer to the zero address");
1546 
1547         _beforeTokenTransfer(from, to, tokenId);
1548 
1549         // Clear approvals from the previous owner
1550         _approve(address(0), tokenId);
1551 
1552         _holderTokens[from].remove(tokenId);
1553         _holderTokens[to].add(tokenId);
1554 
1555         _tokenOwners.set(tokenId, to);
1556 
1557         emit Transfer(from, to, tokenId);
1558     }
1559 
1560     /**
1561      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1562      *
1563      * Requirements:
1564      *
1565      * - `tokenId` must exist.
1566      */
1567     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1568         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1569         _tokenURIs[tokenId] = _tokenURI;
1570     }
1571 
1572     /**
1573      * @dev Internal function to set the base URI for all token IDs. It is
1574      * automatically added as a prefix to the value returned in {tokenURI},
1575      * or to the token ID if {tokenURI} is empty.
1576      */
1577     function _setBaseURI(string memory baseURI_) internal virtual {
1578         _baseURI = baseURI_;
1579     }
1580 
1581     /**
1582      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1583      * The call is not executed if the target address is not a contract.
1584      *
1585      * @param from address representing the previous owner of the given token ID
1586      * @param to target address that will receive the tokens
1587      * @param tokenId uint256 ID of the token to be transferred
1588      * @param _data bytes optional data to send along with the call
1589      * @return bool whether the call correctly returned the expected magic value
1590      */
1591     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1592         private returns (bool)
1593     {
1594         if (!to.isContract()) {
1595             return true;
1596         }
1597         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1598             IERC721Receiver(to).onERC721Received.selector,
1599             _msgSender(),
1600             from,
1601             tokenId,
1602             _data
1603         ), "ERC721: transfer to non ERC721Receiver implementer");
1604         bytes4 retval = abi.decode(returndata, (bytes4));
1605         return (retval == _ERC721_RECEIVED);
1606     }
1607 
1608     function _approve(address to, uint256 tokenId) private {
1609         _tokenApprovals[tokenId] = to;
1610         emit Approval(ownerOf(tokenId), to, tokenId);
1611     }
1612 
1613     /**
1614      * @dev Hook that is called before any token transfer. This includes minting
1615      * and burning.
1616      *
1617      * Calling conditions:
1618      *
1619      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1620      * transferred to `to`.
1621      * - When `from` is zero, `tokenId` will be minted for `to`.
1622      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1623      * - `from` cannot be the zero address.
1624      * - `to` cannot be the zero address.
1625      *
1626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1627      */
1628     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1629 }
1630 
1631 // File: contracts/nft_test.sol
1632 
1633 pragma solidity ^0.6.0;
1634 
1635 
1636 contract TestNFT is ERC721 {
1637 
1638     uint8[] private state_limits = new uint8[](52);
1639     address private creator;
1640     mapping (address => bool) admin;
1641     mapping (bytes32 => bool) claimed;
1642 
1643     constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) public {
1644         _setBaseURI("https://mask-president-2020.s3.ap-east-1.amazonaws.com/");
1645         creator = msg.sender;
1646         admin[creator] = true;
1647         for(uint i = 0; i < 52; i++){
1648             state_limits[i] = 0;
1649         }
1650     }
1651 
1652     function mintStateToken(address claimer, uint8 state) public returns (uint256) {
1653         require(admin[msg.sender], "Not authorized.");
1654         require(!claimed[keccak256(abi.encodePacked(claimer, state))], "Already Claimed.");
1655         require(state_limits[state] > 0, "Out of stock.");
1656         uint256 _id = uint256(keccak256(abi.encodePacked(state, state_limits[state] - 1)));
1657         _safeMint(claimer, _id);
1658         state_limits[state] -= 1;
1659         claimed[keccak256(abi.encodePacked(claimer, state))] = true;
1660         return _id;
1661     }
1662 
1663     function check_availability(uint8 state) public view returns (uint8) {
1664         return state_limits[state];
1665     }
1666 
1667     function modify_limits(uint8 state, int8 delta) public {
1668         require(admin[msg.sender], "Not authorized.");
1669         require(delta < 64, "Non Overflow");        
1670         require(int8(state_limits[state]) + delta > 0, "Non Negative");        
1671         state_limits[state] = uint8(int8(state_limits[state]) + delta);
1672     }
1673 
1674     function modify_admin(address target, bool ifadmin) public {
1675         require(msg.sender == creator, "Not the contract creator");
1676         admin[target] = ifadmin;
1677     }
1678 }