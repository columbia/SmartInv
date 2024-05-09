1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0-solc-0.7
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0-solc-0.7
32 
33 
34 pragma solidity ^0.7.0;
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55 }
56 
57 
58 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.1.0-solc-0.7
59 
60 
61 pragma solidity ^0.7.0;
62 
63 /**
64  * @dev Required interface of an ERC721 compliant contract.
65  */
66 interface IERC721 is IERC165 {
67     /**
68      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
74      */
75     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
76 
77     /**
78      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
79      */
80     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
81 
82     /**
83      * @dev Returns the number of tokens in ``owner``'s account.
84      */
85     function balanceOf(address owner) external view returns (uint256 balance);
86 
87     /**
88      * @dev Returns the owner of the `tokenId` token.
89      *
90      * Requirements:
91      *
92      * - `tokenId` must exist.
93      */
94     function ownerOf(uint256 tokenId) external view returns (address owner);
95 
96     /**
97      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
98      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must exist and be owned by `from`.
105      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
107      *
108      * Emits a {Transfer} event.
109      */
110     function safeTransferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(address from, address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172       * @dev Safely transfers `tokenId` token from `from` to `to`.
173       *
174       * Requirements:
175       *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178       * - `tokenId` token must exist and be owned by `from`.
179       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181       *
182       * Emits a {Transfer} event.
183       */
184     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
185 }
186 
187 
188 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.1.0-solc-0.7
189 
190 
191 pragma solidity ^0.7.0;
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
215 
216 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.1.0-solc-0.7
217 
218 
219 pragma solidity ^0.7.0;
220 
221 /**
222  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
223  * @dev See https://eips.ethereum.org/EIPS/eip-721
224  */
225 interface IERC721Enumerable is IERC721 {
226 
227     /**
228      * @dev Returns the total amount of tokens stored by the contract.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
234      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
235      */
236     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
237 
238     /**
239      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
240      * Use along with {totalSupply} to enumerate all tokens.
241      */
242     function tokenByIndex(uint256 index) external view returns (uint256);
243 }
244 
245 
246 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.1.0-solc-0.7
247 
248 
249 pragma solidity ^0.7.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by `operator` from `from`, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
265      */
266     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
267     external returns (bytes4);
268 }
269 
270 
271 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0-solc-0.7
272 
273 
274 pragma solidity ^0.7.0;
275 
276 /**
277  * @dev Implementation of the {IERC165} interface.
278  *
279  * Contracts may inherit from this and call {_registerInterface} to declare
280  * their support of an interface.
281  */
282 contract ERC165 is IERC165 {
283     /*
284      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
285      */
286     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
287 
288     /**
289      * @dev Mapping of interface ids to whether or not it's supported.
290      */
291     mapping(bytes4 => bool) private _supportedInterfaces;
292 
293     constructor () {
294         // Derived contracts need only register support for their own interfaces,
295         // we register support for ERC165 itself here
296         _registerInterface(_INTERFACE_ID_ERC165);
297     }
298 
299     /**
300      * @dev See {IERC165-supportsInterface}.
301      *
302      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
303      */
304     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
305         return _supportedInterfaces[interfaceId];
306     }
307 
308     /**
309      * @dev Registers the contract as an implementer of the interface defined by
310      * `interfaceId`. Support of the actual ERC165 interface is automatic and
311      * registering its interface id is not required.
312      *
313      * See {IERC165-supportsInterface}.
314      *
315      * Requirements:
316      *
317      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
318      */
319     function _registerInterface(bytes4 interfaceId) internal virtual {
320         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
321         _supportedInterfaces[interfaceId] = true;
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0-solc-0.7
327 
328 
329 pragma solidity ^0.7.0;
330 
331 /**
332  * @dev Wrappers over Solidity's arithmetic operations with added overflow
333  * checks.
334  *
335  * Arithmetic operations in Solidity wrap on overflow. This can easily result
336  * in bugs, because programmers usually assume that an overflow raises an
337  * error, which is the standard behavior in high level programming languages.
338  * `SafeMath` restores this intuition by reverting the transaction when an
339  * operation overflows.
340  *
341  * Using this library instead of the unchecked operations eliminates an entire
342  * class of bugs, so it's recommended to use it always.
343  */
344 library SafeMath {
345     /**
346      * @dev Returns the addition of two unsigned integers, reverting on
347      * overflow.
348      *
349      * Counterpart to Solidity's `+` operator.
350      *
351      * Requirements:
352      *
353      * - Addition cannot overflow.
354      */
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         require(c >= a, "SafeMath: addition overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the subtraction of two unsigned integers, reverting on
364      * overflow (when the result is negative).
365      *
366      * Counterpart to Solidity's `-` operator.
367      *
368      * Requirements:
369      *
370      * - Subtraction cannot overflow.
371      */
372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
373         return sub(a, b, "SafeMath: subtraction overflow");
374     }
375 
376     /**
377      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
378      * overflow (when the result is negative).
379      *
380      * Counterpart to Solidity's `-` operator.
381      *
382      * Requirements:
383      *
384      * - Subtraction cannot overflow.
385      */
386     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b <= a, errorMessage);
388         uint256 c = a - b;
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the multiplication of two unsigned integers, reverting on
395      * overflow.
396      *
397      * Counterpart to Solidity's `*` operator.
398      *
399      * Requirements:
400      *
401      * - Multiplication cannot overflow.
402      */
403     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
404         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
405         // benefit is lost if 'b' is also tested.
406         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
407         if (a == 0) {
408             return 0;
409         }
410 
411         uint256 c = a * b;
412         require(c / a == b, "SafeMath: multiplication overflow");
413 
414         return c;
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers. Reverts on
419      * division by zero. The result is rounded towards zero.
420      *
421      * Counterpart to Solidity's `/` operator. Note: this function uses a
422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
423      * uses an invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      *
427      * - The divisor cannot be zero.
428      */
429     function div(uint256 a, uint256 b) internal pure returns (uint256) {
430         return div(a, b, "SafeMath: division by zero");
431     }
432 
433     /**
434      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
435      * division by zero. The result is rounded towards zero.
436      *
437      * Counterpart to Solidity's `/` operator. Note: this function uses a
438      * `revert` opcode (which leaves remaining gas untouched) while Solidity
439      * uses an invalid opcode to revert (consuming all remaining gas).
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         require(b > 0, errorMessage);
447         uint256 c = a / b;
448         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
455      * Reverts when dividing by zero.
456      *
457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
458      * opcode (which leaves remaining gas untouched) while Solidity uses an
459      * invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
466         return mod(a, b, "SafeMath: modulo by zero");
467     }
468 
469     /**
470      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
471      * Reverts with custom message when dividing by zero.
472      *
473      * Counterpart to Solidity's `%` operator. This function uses a `revert`
474      * opcode (which leaves remaining gas untouched) while Solidity uses an
475      * invalid opcode to revert (consuming all remaining gas).
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b != 0, errorMessage);
483         return a % b;
484     }
485 }
486 
487 
488 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0-solc-0.7
489 
490 
491 pragma solidity ^0.7.0;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
516         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
517         // for accounts without code, i.e. `keccak256('')`
518         bytes32 codehash;
519         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
520         // solhint-disable-next-line no-inline-assembly
521         assembly { codehash := extcodehash(account) }
522         return (codehash != accountHash && codehash != 0x0);
523     }
524 
525     /**
526      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
527      * `recipient`, forwarding all available gas and reverting on errors.
528      *
529      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
530      * of certain opcodes, possibly making contracts go over the 2300 gas limit
531      * imposed by `transfer`, making them unable to receive funds via
532      * `transfer`. {sendValue} removes this limitation.
533      *
534      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
535      *
536      * IMPORTANT: because control is transferred to `recipient`, care must be
537      * taken to not create reentrancy vulnerabilities. Consider using
538      * {ReentrancyGuard} or the
539      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
540      */
541     function sendValue(address payable recipient, uint256 amount) internal {
542         require(address(this).balance >= amount, "Address: insufficient balance");
543 
544         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
545         (bool success, ) = recipient.call{ value: amount }("");
546         require(success, "Address: unable to send value, recipient may have reverted");
547     }
548 
549     /**
550      * @dev Performs a Solidity function call using a low level `call`. A
551      * plain`call` is an unsafe replacement for a function call: use this
552      * function instead.
553      *
554      * If `target` reverts with a revert reason, it is bubbled up by this
555      * function (like regular Solidity function calls).
556      *
557      * Returns the raw returned data. To convert to the expected return value,
558      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
559      *
560      * Requirements:
561      *
562      * - `target` must be a contract.
563      * - calling `target` with `data` must not revert.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
568       return functionCall(target, data, "Address: low-level call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
573      * `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
578         return _functionCallWithValue(target, data, 0, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but also transferring `value` wei to `target`.
584      *
585      * Requirements:
586      *
587      * - the calling contract must have an ETH balance of at least `value`.
588      * - the called Solidity function must be `payable`.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
603         require(address(this).balance >= value, "Address: insufficient balance for call");
604         return _functionCallWithValue(target, data, value, errorMessage);
605     }
606 
607     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
608         require(isContract(target), "Address: call to non-contract");
609 
610         // solhint-disable-next-line avoid-low-level-calls
611         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
612         if (success) {
613             return returndata;
614         } else {
615             // Look for revert reason and bubble it up if present
616             if (returndata.length > 0) {
617                 // The easiest way to bubble the revert reason is using memory via assembly
618 
619                 // solhint-disable-next-line no-inline-assembly
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.1.0-solc-0.7
633 
634 
635 pragma solidity ^0.7.0;
636 
637 /**
638  * @dev Library for managing
639  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
640  * types.
641  *
642  * Sets have the following properties:
643  *
644  * - Elements are added, removed, and checked for existence in constant time
645  * (O(1)).
646  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
647  *
648  * ```
649  * contract Example {
650  *     // Add the library methods
651  *     using EnumerableSet for EnumerableSet.AddressSet;
652  *
653  *     // Declare a set state variable
654  *     EnumerableSet.AddressSet private mySet;
655  * }
656  * ```
657  *
658  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
659  * (`UintSet`) are supported.
660  */
661 library EnumerableSet {
662     // To implement this library for multiple types with as little code
663     // repetition as possible, we write it in terms of a generic Set type with
664     // bytes32 values.
665     // The Set implementation uses private functions, and user-facing
666     // implementations (such as AddressSet) are just wrappers around the
667     // underlying Set.
668     // This means that we can only create new EnumerableSets for types that fit
669     // in bytes32.
670 
671     struct Set {
672         // Storage of set values
673         bytes32[] _values;
674 
675         // Position of the value in the `values` array, plus 1 because index 0
676         // means a value is not in the set.
677         mapping (bytes32 => uint256) _indexes;
678     }
679 
680     /**
681      * @dev Add a value to a set. O(1).
682      *
683      * Returns true if the value was added to the set, that is if it was not
684      * already present.
685      */
686     function _add(Set storage set, bytes32 value) private returns (bool) {
687         if (!_contains(set, value)) {
688             set._values.push(value);
689             // The value is stored at length-1, but we add 1 to all indexes
690             // and use 0 as a sentinel value
691             set._indexes[value] = set._values.length;
692             return true;
693         } else {
694             return false;
695         }
696     }
697 
698     /**
699      * @dev Removes a value from a set. O(1).
700      *
701      * Returns true if the value was removed from the set, that is if it was
702      * present.
703      */
704     function _remove(Set storage set, bytes32 value) private returns (bool) {
705         // We read and store the value's index to prevent multiple reads from the same storage slot
706         uint256 valueIndex = set._indexes[value];
707 
708         if (valueIndex != 0) { // Equivalent to contains(set, value)
709             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
710             // the array, and then remove the last element (sometimes called as 'swap and pop').
711             // This modifies the order of the array, as noted in {at}.
712 
713             uint256 toDeleteIndex = valueIndex - 1;
714             uint256 lastIndex = set._values.length - 1;
715 
716             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
717             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
718 
719             bytes32 lastvalue = set._values[lastIndex];
720 
721             // Move the last value to the index where the value to delete is
722             set._values[toDeleteIndex] = lastvalue;
723             // Update the index for the moved value
724             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
725 
726             // Delete the slot where the moved value was stored
727             set._values.pop();
728 
729             // Delete the index for the deleted slot
730             delete set._indexes[value];
731 
732             return true;
733         } else {
734             return false;
735         }
736     }
737 
738     /**
739      * @dev Returns true if the value is in the set. O(1).
740      */
741     function _contains(Set storage set, bytes32 value) private view returns (bool) {
742         return set._indexes[value] != 0;
743     }
744 
745     /**
746      * @dev Returns the number of values on the set. O(1).
747      */
748     function _length(Set storage set) private view returns (uint256) {
749         return set._values.length;
750     }
751 
752    /**
753     * @dev Returns the value stored at position `index` in the set. O(1).
754     *
755     * Note that there are no guarantees on the ordering of values inside the
756     * array, and it may change when more values are added or removed.
757     *
758     * Requirements:
759     *
760     * - `index` must be strictly less than {length}.
761     */
762     function _at(Set storage set, uint256 index) private view returns (bytes32) {
763         require(set._values.length > index, "EnumerableSet: index out of bounds");
764         return set._values[index];
765     }
766 
767     // AddressSet
768 
769     struct AddressSet {
770         Set _inner;
771     }
772 
773     /**
774      * @dev Add a value to a set. O(1).
775      *
776      * Returns true if the value was added to the set, that is if it was not
777      * already present.
778      */
779     function add(AddressSet storage set, address value) internal returns (bool) {
780         return _add(set._inner, bytes32(uint256(value)));
781     }
782 
783     /**
784      * @dev Removes a value from a set. O(1).
785      *
786      * Returns true if the value was removed from the set, that is if it was
787      * present.
788      */
789     function remove(AddressSet storage set, address value) internal returns (bool) {
790         return _remove(set._inner, bytes32(uint256(value)));
791     }
792 
793     /**
794      * @dev Returns true if the value is in the set. O(1).
795      */
796     function contains(AddressSet storage set, address value) internal view returns (bool) {
797         return _contains(set._inner, bytes32(uint256(value)));
798     }
799 
800     /**
801      * @dev Returns the number of values in the set. O(1).
802      */
803     function length(AddressSet storage set) internal view returns (uint256) {
804         return _length(set._inner);
805     }
806 
807    /**
808     * @dev Returns the value stored at position `index` in the set. O(1).
809     *
810     * Note that there are no guarantees on the ordering of values inside the
811     * array, and it may change when more values are added or removed.
812     *
813     * Requirements:
814     *
815     * - `index` must be strictly less than {length}.
816     */
817     function at(AddressSet storage set, uint256 index) internal view returns (address) {
818         return address(uint256(_at(set._inner, index)));
819     }
820 
821 
822     // UintSet
823 
824     struct UintSet {
825         Set _inner;
826     }
827 
828     /**
829      * @dev Add a value to a set. O(1).
830      *
831      * Returns true if the value was added to the set, that is if it was not
832      * already present.
833      */
834     function add(UintSet storage set, uint256 value) internal returns (bool) {
835         return _add(set._inner, bytes32(value));
836     }
837 
838     /**
839      * @dev Removes a value from a set. O(1).
840      *
841      * Returns true if the value was removed from the set, that is if it was
842      * present.
843      */
844     function remove(UintSet storage set, uint256 value) internal returns (bool) {
845         return _remove(set._inner, bytes32(value));
846     }
847 
848     /**
849      * @dev Returns true if the value is in the set. O(1).
850      */
851     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
852         return _contains(set._inner, bytes32(value));
853     }
854 
855     /**
856      * @dev Returns the number of values on the set. O(1).
857      */
858     function length(UintSet storage set) internal view returns (uint256) {
859         return _length(set._inner);
860     }
861 
862    /**
863     * @dev Returns the value stored at position `index` in the set. O(1).
864     *
865     * Note that there are no guarantees on the ordering of values inside the
866     * array, and it may change when more values are added or removed.
867     *
868     * Requirements:
869     *
870     * - `index` must be strictly less than {length}.
871     */
872     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
873         return uint256(_at(set._inner, index));
874     }
875 }
876 
877 
878 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.1.0-solc-0.7
879 
880 
881 pragma solidity ^0.7.0;
882 
883 /**
884  * @dev Library for managing an enumerable variant of Solidity's
885  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
886  * type.
887  *
888  * Maps have the following properties:
889  *
890  * - Entries are added, removed, and checked for existence in constant time
891  * (O(1)).
892  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
893  *
894  * ```
895  * contract Example {
896  *     // Add the library methods
897  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
898  *
899  *     // Declare a set state variable
900  *     EnumerableMap.UintToAddressMap private myMap;
901  * }
902  * ```
903  *
904  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
905  * supported.
906  */
907 library EnumerableMap {
908     // To implement this library for multiple types with as little code
909     // repetition as possible, we write it in terms of a generic Map type with
910     // bytes32 keys and values.
911     // The Map implementation uses private functions, and user-facing
912     // implementations (such as Uint256ToAddressMap) are just wrappers around
913     // the underlying Map.
914     // This means that we can only create new EnumerableMaps for types that fit
915     // in bytes32.
916 
917     struct MapEntry {
918         bytes32 _key;
919         bytes32 _value;
920     }
921 
922     struct Map {
923         // Storage of map keys and values
924         MapEntry[] _entries;
925 
926         // Position of the entry defined by a key in the `entries` array, plus 1
927         // because index 0 means a key is not in the map.
928         mapping (bytes32 => uint256) _indexes;
929     }
930 
931     /**
932      * @dev Adds a key-value pair to a map, or updates the value for an existing
933      * key. O(1).
934      *
935      * Returns true if the key was added to the map, that is if it was not
936      * already present.
937      */
938     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
939         // We read and store the key's index to prevent multiple reads from the same storage slot
940         uint256 keyIndex = map._indexes[key];
941 
942         if (keyIndex == 0) { // Equivalent to !contains(map, key)
943             map._entries.push(MapEntry({ _key: key, _value: value }));
944             // The entry is stored at length-1, but we add 1 to all indexes
945             // and use 0 as a sentinel value
946             map._indexes[key] = map._entries.length;
947             return true;
948         } else {
949             map._entries[keyIndex - 1]._value = value;
950             return false;
951         }
952     }
953 
954     /**
955      * @dev Removes a key-value pair from a map. O(1).
956      *
957      * Returns true if the key was removed from the map, that is if it was present.
958      */
959     function _remove(Map storage map, bytes32 key) private returns (bool) {
960         // We read and store the key's index to prevent multiple reads from the same storage slot
961         uint256 keyIndex = map._indexes[key];
962 
963         if (keyIndex != 0) { // Equivalent to contains(map, key)
964             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
965             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
966             // This modifies the order of the array, as noted in {at}.
967 
968             uint256 toDeleteIndex = keyIndex - 1;
969             uint256 lastIndex = map._entries.length - 1;
970 
971             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
972             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
973 
974             MapEntry storage lastEntry = map._entries[lastIndex];
975 
976             // Move the last entry to the index where the entry to delete is
977             map._entries[toDeleteIndex] = lastEntry;
978             // Update the index for the moved entry
979             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
980 
981             // Delete the slot where the moved entry was stored
982             map._entries.pop();
983 
984             // Delete the index for the deleted slot
985             delete map._indexes[key];
986 
987             return true;
988         } else {
989             return false;
990         }
991     }
992 
993     /**
994      * @dev Returns true if the key is in the map. O(1).
995      */
996     function _contains(Map storage map, bytes32 key) private view returns (bool) {
997         return map._indexes[key] != 0;
998     }
999 
1000     /**
1001      * @dev Returns the number of key-value pairs in the map. O(1).
1002      */
1003     function _length(Map storage map) private view returns (uint256) {
1004         return map._entries.length;
1005     }
1006 
1007    /**
1008     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1009     *
1010     * Note that there are no guarantees on the ordering of entries inside the
1011     * array, and it may change when more entries are added or removed.
1012     *
1013     * Requirements:
1014     *
1015     * - `index` must be strictly less than {length}.
1016     */
1017     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1018         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1019 
1020         MapEntry storage entry = map._entries[index];
1021         return (entry._key, entry._value);
1022     }
1023 
1024     /**
1025      * @dev Returns the value associated with `key`.  O(1).
1026      *
1027      * Requirements:
1028      *
1029      * - `key` must be in the map.
1030      */
1031     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1032         return _get(map, key, "EnumerableMap: nonexistent key");
1033     }
1034 
1035     /**
1036      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1037      */
1038     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1039         uint256 keyIndex = map._indexes[key];
1040         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1041         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1042     }
1043 
1044     // UintToAddressMap
1045 
1046     struct UintToAddressMap {
1047         Map _inner;
1048     }
1049 
1050     /**
1051      * @dev Adds a key-value pair to a map, or updates the value for an existing
1052      * key. O(1).
1053      *
1054      * Returns true if the key was added to the map, that is if it was not
1055      * already present.
1056      */
1057     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1058         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1059     }
1060 
1061     /**
1062      * @dev Removes a value from a set. O(1).
1063      *
1064      * Returns true if the key was removed from the map, that is if it was present.
1065      */
1066     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1067         return _remove(map._inner, bytes32(key));
1068     }
1069 
1070     /**
1071      * @dev Returns true if the key is in the map. O(1).
1072      */
1073     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1074         return _contains(map._inner, bytes32(key));
1075     }
1076 
1077     /**
1078      * @dev Returns the number of elements in the map. O(1).
1079      */
1080     function length(UintToAddressMap storage map) internal view returns (uint256) {
1081         return _length(map._inner);
1082     }
1083 
1084    /**
1085     * @dev Returns the element stored at position `index` in the set. O(1).
1086     * Note that there are no guarantees on the ordering of values inside the
1087     * array, and it may change when more values are added or removed.
1088     *
1089     * Requirements:
1090     *
1091     * - `index` must be strictly less than {length}.
1092     */
1093     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1094         (bytes32 key, bytes32 value) = _at(map._inner, index);
1095         return (uint256(key), address(uint256(value)));
1096     }
1097 
1098     /**
1099      * @dev Returns the value associated with `key`.  O(1).
1100      *
1101      * Requirements:
1102      *
1103      * - `key` must be in the map.
1104      */
1105     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1106         return address(uint256(_get(map._inner, bytes32(key))));
1107     }
1108 
1109     /**
1110      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1111      */
1112     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1113         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1114     }
1115 }
1116 
1117 
1118 // File @openzeppelin/contracts/utils/Strings.sol@v3.1.0-solc-0.7
1119 
1120 
1121 pragma solidity ^0.7.0;
1122 
1123 /**
1124  * @dev String operations.
1125  */
1126 library Strings {
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` representation.
1129      */
1130     function toString(uint256 value) internal pure returns (string memory) {
1131         // Inspired by OraclizeAPI's implementation - MIT licence
1132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1133 
1134         if (value == 0) {
1135             return "0";
1136         }
1137         uint256 temp = value;
1138         uint256 digits;
1139         while (temp != 0) {
1140             digits++;
1141             temp /= 10;
1142         }
1143         bytes memory buffer = new bytes(digits);
1144         uint256 index = digits - 1;
1145         temp = value;
1146         while (temp != 0) {
1147             buffer[index--] = byte(uint8(48 + temp % 10));
1148             temp /= 10;
1149         }
1150         return string(buffer);
1151     }
1152 }
1153 
1154 
1155 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.1.0-solc-0.7
1156 
1157 
1158 pragma solidity ^0.7.0;
1159 
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 /**
1171  * @title ERC721 Non-Fungible Token Standard basic implementation
1172  * @dev see https://eips.ethereum.org/EIPS/eip-721
1173  */
1174 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1175     using SafeMath for uint256;
1176     using Address for address;
1177     using EnumerableSet for EnumerableSet.UintSet;
1178     using EnumerableMap for EnumerableMap.UintToAddressMap;
1179     using Strings for uint256;
1180 
1181     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1182     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1183     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1184 
1185     // Mapping from holder address to their (enumerable) set of owned tokens
1186     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1187 
1188     // Enumerable mapping from token ids to their owners
1189     EnumerableMap.UintToAddressMap private _tokenOwners;
1190 
1191     // Mapping from token ID to approved address
1192     mapping (uint256 => address) private _tokenApprovals;
1193 
1194     // Mapping from owner to operator approvals
1195     mapping (address => mapping (address => bool)) private _operatorApprovals;
1196 
1197     // Token name
1198     string private _name;
1199 
1200     // Token symbol
1201     string private _symbol;
1202 
1203     // Optional mapping for token URIs
1204     mapping (uint256 => string) private _tokenURIs;
1205 
1206     // Base URI
1207     string private _baseURI;
1208 
1209     /*
1210      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1211      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1212      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1213      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1214      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1215      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1216      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1217      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1218      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1219      *
1220      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1221      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1222      */
1223     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1224 
1225     /*
1226      *     bytes4(keccak256('name()')) == 0x06fdde03
1227      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1228      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1229      *
1230      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1231      */
1232     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1233 
1234     /*
1235      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1236      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1237      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1238      *
1239      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1240      */
1241     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1242 
1243     /**
1244      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1245      */
1246     constructor (string memory name, string memory symbol) {
1247         _name = name;
1248         _symbol = symbol;
1249 
1250         // register the supported interfaces to conform to ERC721 via ERC165
1251         _registerInterface(_INTERFACE_ID_ERC721);
1252         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1253         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-balanceOf}.
1258      */
1259     function balanceOf(address owner) public view override returns (uint256) {
1260         require(owner != address(0), "ERC721: balance query for the zero address");
1261 
1262         return _holderTokens[owner].length();
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-ownerOf}.
1267      */
1268     function ownerOf(uint256 tokenId) public view override returns (address) {
1269         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Metadata-name}.
1274      */
1275     function name() public view override returns (string memory) {
1276         return _name;
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Metadata-symbol}.
1281      */
1282     function symbol() public view override returns (string memory) {
1283         return _symbol;
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Metadata-tokenURI}.
1288      */
1289     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1290         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1291 
1292         string memory _tokenURI = _tokenURIs[tokenId];
1293 
1294         // If there is no base URI, return the token URI.
1295         if (bytes(_baseURI).length == 0) {
1296             return _tokenURI;
1297         }
1298         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1299         if (bytes(_tokenURI).length > 0) {
1300             return string(abi.encodePacked(_baseURI, _tokenURI));
1301         }
1302         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1303         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1304     }
1305 
1306     /**
1307     * @dev Returns the base URI set via {_setBaseURI}. This will be
1308     * automatically added as a prefix in {tokenURI} to each token's URI, or
1309     * to the token ID if no specific URI is set for that token ID.
1310     */
1311     function baseURI() public view returns (string memory) {
1312         return _baseURI;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1317      */
1318     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1319         return _holderTokens[owner].at(index);
1320     }
1321 
1322     /**
1323      * @dev See {IERC721Enumerable-totalSupply}.
1324      */
1325     function totalSupply() public view override returns (uint256) {
1326         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1327         return _tokenOwners.length();
1328     }
1329 
1330     /**
1331      * @dev See {IERC721Enumerable-tokenByIndex}.
1332      */
1333     function tokenByIndex(uint256 index) public view override returns (uint256) {
1334         (uint256 tokenId, ) = _tokenOwners.at(index);
1335         return tokenId;
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-approve}.
1340      */
1341     function approve(address to, uint256 tokenId) public virtual override {
1342         address owner = ownerOf(tokenId);
1343         require(to != owner, "ERC721: approval to current owner");
1344 
1345         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1346             "ERC721: approve caller is not owner nor approved for all"
1347         );
1348 
1349         _approve(to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-getApproved}.
1354      */
1355     function getApproved(uint256 tokenId) public view override returns (address) {
1356         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1357 
1358         return _tokenApprovals[tokenId];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-setApprovalForAll}.
1363      */
1364     function setApprovalForAll(address operator, bool approved) public virtual override {
1365         require(operator != _msgSender(), "ERC721: approve to caller");
1366 
1367         _operatorApprovals[_msgSender()][operator] = approved;
1368         emit ApprovalForAll(_msgSender(), operator, approved);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-isApprovedForAll}.
1373      */
1374     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1375         return _operatorApprovals[owner][operator];
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-transferFrom}.
1380      */
1381     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1382         //solhint-disable-next-line max-line-length
1383         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1384 
1385         _transfer(from, to, tokenId);
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-safeTransferFrom}.
1390      */
1391     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1392         safeTransferFrom(from, to, tokenId, "");
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-safeTransferFrom}.
1397      */
1398     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1399         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1400         _safeTransfer(from, to, tokenId, _data);
1401     }
1402 
1403     /**
1404      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1405      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1406      *
1407      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1408      *
1409      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1410      * implement alternative mecanisms to perform token transfer, such as signature-based.
1411      *
1412      * Requirements:
1413      *
1414      * - `from` cannot be the zero address.
1415      * - `to` cannot be the zero address.
1416      * - `tokenId` token must exist and be owned by `from`.
1417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1422         _transfer(from, to, tokenId);
1423         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1424     }
1425 
1426     /**
1427      * @dev Returns whether `tokenId` exists.
1428      *
1429      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1430      *
1431      * Tokens start existing when they are minted (`_mint`),
1432      * and stop existing when they are burned (`_burn`).
1433      */
1434     function _exists(uint256 tokenId) internal view returns (bool) {
1435         return _tokenOwners.contains(tokenId);
1436     }
1437 
1438     /**
1439      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1440      *
1441      * Requirements:
1442      *
1443      * - `tokenId` must exist.
1444      */
1445     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1446         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1447         address owner = ownerOf(tokenId);
1448         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1449     }
1450 
1451     /**
1452      * @dev Safely mints `tokenId` and transfers it to `to`.
1453      *
1454      * Requirements:
1455      d*
1456      * - `tokenId` must not exist.
1457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _safeMint(address to, uint256 tokenId) internal virtual {
1462         _safeMint(to, tokenId, "");
1463     }
1464 
1465     /**
1466      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1467      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1468      */
1469     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1470         _mint(to, tokenId);
1471         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1472     }
1473 
1474     /**
1475      * @dev Mints `tokenId` and transfers it to `to`.
1476      *
1477      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must not exist.
1482      * - `to` cannot be the zero address.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _mint(address to, uint256 tokenId) internal virtual {
1487         require(to != address(0), "ERC721: mint to the zero address");
1488         require(!_exists(tokenId), "ERC721: token already minted");
1489 
1490         _beforeTokenTransfer(address(0), to, tokenId);
1491 
1492         _holderTokens[to].add(tokenId);
1493 
1494         _tokenOwners.set(tokenId, to);
1495 
1496         emit Transfer(address(0), to, tokenId);
1497     }
1498 
1499     /**
1500      * @dev Destroys `tokenId`.
1501      * The approval is cleared when the token is burned.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must exist.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _burn(uint256 tokenId) internal virtual {
1510         address owner = ownerOf(tokenId);
1511 
1512         _beforeTokenTransfer(owner, address(0), tokenId);
1513 
1514         // Clear approvals
1515         _approve(address(0), tokenId);
1516 
1517         // Clear metadata (if any)
1518         if (bytes(_tokenURIs[tokenId]).length != 0) {
1519             delete _tokenURIs[tokenId];
1520         }
1521 
1522         _holderTokens[owner].remove(tokenId);
1523 
1524         _tokenOwners.remove(tokenId);
1525 
1526         emit Transfer(owner, address(0), tokenId);
1527     }
1528 
1529     /**
1530      * @dev Transfers `tokenId` from `from` to `to`.
1531      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1532      *
1533      * Requirements:
1534      *
1535      * - `to` cannot be the zero address.
1536      * - `tokenId` token must be owned by `from`.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1541         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1542         require(to != address(0), "ERC721: transfer to the zero address");
1543 
1544         _beforeTokenTransfer(from, to, tokenId);
1545 
1546         // Clear approvals from the previous owner
1547         _approve(address(0), tokenId);
1548 
1549         _holderTokens[from].remove(tokenId);
1550         _holderTokens[to].add(tokenId);
1551 
1552         _tokenOwners.set(tokenId, to);
1553 
1554         emit Transfer(from, to, tokenId);
1555     }
1556 
1557     /**
1558      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1559      *
1560      * Requirements:
1561      *
1562      * - `tokenId` must exist.
1563      */
1564     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1565         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1566         _tokenURIs[tokenId] = _tokenURI;
1567     }
1568 
1569     /**
1570      * @dev Internal function to set the base URI for all token IDs. It is
1571      * automatically added as a prefix to the value returned in {tokenURI},
1572      * or to the token ID if {tokenURI} is empty.
1573      */
1574     function _setBaseURI(string memory baseURI_) internal virtual {
1575         _baseURI = baseURI_;
1576     }
1577 
1578     /**
1579      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1580      * The call is not executed if the target address is not a contract.
1581      *
1582      * @param from address representing the previous owner of the given token ID
1583      * @param to target address that will receive the tokens
1584      * @param tokenId uint256 ID of the token to be transferred
1585      * @param _data bytes optional data to send along with the call
1586      * @return bool whether the call correctly returned the expected magic value
1587      */
1588     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1589         private returns (bool)
1590     {
1591         if (!to.isContract()) {
1592             return true;
1593         }
1594         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1595             IERC721Receiver(to).onERC721Received.selector,
1596             _msgSender(),
1597             from,
1598             tokenId,
1599             _data
1600         ), "ERC721: transfer to non ERC721Receiver implementer");
1601         bytes4 retval = abi.decode(returndata, (bytes4));
1602         return (retval == _ERC721_RECEIVED);
1603     }
1604 
1605     function _approve(address to, uint256 tokenId) private {
1606         _tokenApprovals[tokenId] = to;
1607         emit Approval(ownerOf(tokenId), to, tokenId);
1608     }
1609 
1610     /**
1611      * @dev Hook that is called before any token transfer. This includes minting
1612      * and burning.
1613      *
1614      * Calling conditions:
1615      *
1616      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1617      * transferred to `to`.
1618      * - When `from` is zero, `tokenId` will be minted for `to`.
1619      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1620      * - `from` cannot be the zero address.
1621      * - `to` cannot be the zero address.
1622      *
1623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1624      */
1625     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1626 }
1627 
1628 
1629 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0-solc-0.7
1630 
1631 
1632 pragma solidity ^0.7.0;
1633 
1634 /**
1635  * @dev Contract module which provides a basic access control mechanism, where
1636  * there is an account (an owner) that can be granted exclusive access to
1637  * specific functions.
1638  *
1639  * By default, the owner account will be the one that deploys the contract. This
1640  * can later be changed with {transferOwnership}.
1641  *
1642  * This module is used through inheritance. It will make available the modifier
1643  * `onlyOwner`, which can be applied to your functions to restrict their use to
1644  * the owner.
1645  */
1646 contract Ownable is Context {
1647     address private _owner;
1648 
1649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1650 
1651     /**
1652      * @dev Initializes the contract setting the deployer as the initial owner.
1653      */
1654     constructor () {
1655         address msgSender = _msgSender();
1656         _owner = msgSender;
1657         emit OwnershipTransferred(address(0), msgSender);
1658     }
1659 
1660     /**
1661      * @dev Returns the address of the current owner.
1662      */
1663     function owner() public view returns (address) {
1664         return _owner;
1665     }
1666 
1667     /**
1668      * @dev Throws if called by any account other than the owner.
1669      */
1670     modifier onlyOwner() {
1671         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1672         _;
1673     }
1674 
1675     /**
1676      * @dev Leaves the contract without owner. It will not be possible to call
1677      * `onlyOwner` functions anymore. Can only be called by the current owner.
1678      *
1679      * NOTE: Renouncing ownership will leave the contract without an owner,
1680      * thereby removing any functionality that is only available to the owner.
1681      */
1682     function renounceOwnership() public virtual onlyOwner {
1683         emit OwnershipTransferred(_owner, address(0));
1684         _owner = address(0);
1685     }
1686 
1687     /**
1688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1689      * Can only be called by the current owner.
1690      */
1691     function transferOwnership(address newOwner) public virtual onlyOwner {
1692         require(newOwner != address(0), "Ownable: new owner is the zero address");
1693         emit OwnershipTransferred(_owner, newOwner);
1694         _owner = newOwner;
1695     }
1696 }
1697 
1698 
1699 // File contracts/OneShogun.sol
1700 
1701 pragma solidity ^0.7.0;
1702 
1703 
1704 contract OneShogun is ERC721, Ownable {
1705     
1706     using SafeMath for uint256;
1707 
1708     uint256 public price = 100000000000000000; // 0.1 ETH
1709 
1710     uint256 public MAX_ONESHOGUN = 10000;
1711 
1712     uint256 public MAX_ONESHOGUN_PRIVATE_SALE = 7500;
1713 
1714     uint256 public MAX_ONESHOGUN_PURCHASE = 5; // Change it to 25 after private sale
1715 
1716     uint256 public MAD_ONESHOGUN_RESERVE = 300;
1717 
1718     bool public privateSaleIsActive = false;
1719 
1720     bool public saleIsActive = false;
1721 
1722     bool public preSaleIsActive = false;
1723 
1724     mapping (address => bool) whitelist;
1725 
1726     constructor() ERC721("One Shogun", "OS") { }
1727     
1728     function withdraw() public onlyOwner {
1729         uint balance = address(this).balance;
1730         msg.sender.transfer(balance);
1731     }
1732 
1733     function isEligiblePrivateSale(address _wallet) public view virtual returns (bool){
1734         return whitelist[_wallet];
1735     }
1736 
1737     function addWalletsToWhiteList(address[] memory _wallets) public onlyOwner{
1738         for(uint i = 0; i < _wallets.length; i++) {
1739             whitelist[_wallets[i]] = true;
1740         }
1741     }
1742 
1743     function flipSaleState() public onlyOwner {
1744         saleIsActive = !saleIsActive;
1745     }
1746 
1747     function flipPreSaleState() public onlyOwner {
1748         preSaleIsActive = !preSaleIsActive;
1749     }
1750 
1751     function flipPrivateSaleState() public onlyOwner {
1752         privateSaleIsActive = !privateSaleIsActive;
1753     }
1754 
1755     function setBaseURI(string memory baseURI) public onlyOwner {
1756         _setBaseURI(baseURI);
1757     }   
1758 
1759     function setPrice(uint _price) public onlyOwner {
1760         price = _price;
1761     }
1762 
1763     function reserveOneShoguns(uint256 numberOfTokens) public onlyOwner {
1764         require(numberOfTokens > 0 && numberOfTokens <= MAD_ONESHOGUN_RESERVE, "Not enough reserve left for team");
1765 
1766         for(uint256 i = 0; i < numberOfTokens; i++) {
1767             uint256 mintIndex = totalSupply();
1768             _safeMint(msg.sender, mintIndex);
1769         }
1770 
1771         MAD_ONESHOGUN_RESERVE = MAD_ONESHOGUN_RESERVE.sub(numberOfTokens);
1772     }
1773 
1774     function mintOneShoguns(uint numberOfTokens) public payable {
1775         require(saleIsActive, "Sale must be active to mint One Shoguns");
1776         require(numberOfTokens <= 25, "Can only mint 25 tokens at a time");
1777         require(totalSupply().add(numberOfTokens) <= MAX_ONESHOGUN, "Purchase would exceed max supply of One Shoguns");
1778         require(msg.value >= price.mul(numberOfTokens), "Ether value sent is not correct");
1779 
1780         for(uint i = 0; i < numberOfTokens; i++) {
1781             uint256 mintIndex = totalSupply();
1782             if (totalSupply() < MAX_ONESHOGUN) {
1783                 _safeMint(msg.sender, mintIndex);
1784             }
1785         }
1786     }
1787 
1788     function mintOneShogunsPrivateSale(uint numberOfTokens) public payable {
1789         require(privateSaleIsActive, "Private Sale must be active to mint One Shoguns");
1790         require(numberOfTokens + balanceOf(msg.sender) <= 5, "Can have 5 OneShoguns per wallet");
1791         require(isEligiblePrivateSale(msg.sender), "The sender isn't eligible for private sale");
1792         require(totalSupply().add(numberOfTokens) <= MAX_ONESHOGUN_PRIVATE_SALE, "Purchase would exceed max supply of One Shoguns");
1793         require(msg.value >= price.mul(numberOfTokens), "Ether value sent is not correct");
1794 
1795         for(uint i = 0; i < numberOfTokens; i++) {
1796             uint256 mintIndex = totalSupply();
1797             if (totalSupply() < MAX_ONESHOGUN_PRIVATE_SALE) {
1798                 _safeMint(msg.sender, mintIndex);
1799             }
1800         }
1801     }
1802     
1803 }