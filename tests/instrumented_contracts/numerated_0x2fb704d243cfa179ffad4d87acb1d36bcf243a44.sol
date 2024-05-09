1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // AND PDX-License-Identifier: MIT
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
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 
57 pragma solidity ^0.6.2;
58 
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     /**
80      * @dev Returns the number of tokens in ``owner``'s account.
81      */
82     function balanceOf(address owner) external view returns (uint256 balance);
83 
84     /**
85      * @dev Returns the owner of the `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     /**
94      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
95      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must exist and be owned by `from`.
102      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
104      *
105      * Emits a {Transfer} event.
106      */
107     function safeTransferFrom(address from, address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(address from, address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169       * @dev Safely transfers `tokenId` token from `from` to `to`.
170       *
171       * Requirements:
172       *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175       * - `tokenId` token must exist and be owned by `from`.
176       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178       *
179       * Emits a {Transfer} event.
180       */
181     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
182 }
183 
184 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
185 
186 
187 pragma solidity ^0.6.2;
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195 
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
213 
214 
215 pragma solidity ^0.6.2;
216 
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Enumerable is IERC721 {
223 
224     /**
225      * @dev Returns the total amount of tokens stored by the contract.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
231      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
232      */
233     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
234 
235     /**
236      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
237      * Use along with {totalSupply} to enumerate all tokens.
238      */
239     function tokenByIndex(uint256 index) external view returns (uint256);
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 pragma solidity ^0.6.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by `operator` from `from`, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
261      */
262     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
263     external returns (bytes4);
264 }
265 
266 // File: @openzeppelin/contracts/introspection/ERC165.sol
267 
268 // AND SPDX-License-Identifier: MIT
269 
270 pragma solidity ^0.6.0;
271 
272 
273 /**
274  * @dev Implementation of the {IERC165} interface.
275  *
276  * Contracts may inherit from this and call {_registerInterface} to declare
277  * their support of an interface.
278  */
279 contract ERC165 is IERC165 {
280     /*
281      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
282      */
283     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
284 
285     /**
286      * @dev Mapping of interface ids to whether or not it's supported.
287      */
288     mapping(bytes4 => bool) private _supportedInterfaces;
289 
290     constructor () internal {
291         // Derived contracts need only register support for their own interfaces,
292         // we register support for ERC165 itself here
293         _registerInterface(_INTERFACE_ID_ERC165);
294     }
295 
296     /**
297      * @dev See {IERC165-supportsInterface}.
298      *
299      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
302         return _supportedInterfaces[interfaceId];
303     }
304 
305     /**
306      * @dev Registers the contract as an implementer of the interface defined by
307      * `interfaceId`. Support of the actual ERC165 interface is automatic and
308      * registering its interface id is not required.
309      *
310      * See {IERC165-supportsInterface}.
311      *
312      * Requirements:
313      *
314      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
315      */
316     function _registerInterface(bytes4 interfaceId) internal virtual {
317         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
318         _supportedInterfaces[interfaceId] = true;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/math/SafeMath.sol
323 
324 
325 pragma solidity ^0.6.0;
326 
327 /**
328  * @dev Wrappers over Solidity's arithmetic operations with added overflow
329  * checks.
330  *
331  * Arithmetic operations in Solidity wrap on overflow. This can easily result
332  * in bugs, because programmers usually assume that an overflow raises an
333  * error, which is the standard behavior in high level programming languages.
334  * `SafeMath` restores this intuition by reverting the transaction when an
335  * operation overflows.
336  *
337  * Using this library instead of the unchecked operations eliminates an entire
338  * class of bugs, so it's recommended to use it always.
339  */
340 library SafeMath {
341     /**
342      * @dev Returns the addition of two unsigned integers, reverting on
343      * overflow.
344      *
345      * Counterpart to Solidity's `+` operator.
346      *
347      * Requirements:
348      *
349      * - Addition cannot overflow.
350      */
351     function add(uint256 a, uint256 b) internal pure returns (uint256) {
352         uint256 c = a + b;
353         require(c >= a, "SafeMath: addition overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the subtraction of two unsigned integers, reverting on
360      * overflow (when the result is negative).
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
369         return sub(a, b, "SafeMath: subtraction overflow");
370     }
371 
372     /**
373      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
374      * overflow (when the result is negative).
375      *
376      * Counterpart to Solidity's `-` operator.
377      *
378      * Requirements:
379      *
380      * - Subtraction cannot overflow.
381      */
382     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
383         require(b <= a, errorMessage);
384         uint256 c = a - b;
385 
386         return c;
387     }
388 
389     /**
390      * @dev Returns the multiplication of two unsigned integers, reverting on
391      * overflow.
392      *
393      * Counterpart to Solidity's `*` operator.
394      *
395      * Requirements:
396      *
397      * - Multiplication cannot overflow.
398      */
399     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
401         // benefit is lost if 'b' is also tested.
402         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
403         if (a == 0) {
404             return 0;
405         }
406 
407         uint256 c = a * b;
408         require(c / a == b, "SafeMath: multiplication overflow");
409 
410         return c;
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers. Reverts on
415      * division by zero. The result is rounded towards zero.
416      *
417      * Counterpart to Solidity's `/` operator. Note: this function uses a
418      * `revert` opcode (which leaves remaining gas untouched) while Solidity
419      * uses an invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
423      * - The divisor cannot be zero.
424      */
425     function div(uint256 a, uint256 b) internal pure returns (uint256) {
426         return div(a, b, "SafeMath: division by zero");
427     }
428 
429     /**
430      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
431      * division by zero. The result is rounded towards zero.
432      *
433      * Counterpart to Solidity's `/` operator. Note: this function uses a
434      * `revert` opcode (which leaves remaining gas untouched) while Solidity
435      * uses an invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      *
439      * - The divisor cannot be zero.
440      */
441     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
442         require(b > 0, errorMessage);
443         uint256 c = a / b;
444         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * Reverts when dividing by zero.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
462         return mod(a, b, "SafeMath: modulo by zero");
463     }
464 
465     /**
466      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
467      * Reverts with custom message when dividing by zero.
468      *
469      * Counterpart to Solidity's `%` operator. This function uses a `revert`
470      * opcode (which leaves remaining gas untouched) while Solidity uses an
471      * invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
478         require(b != 0, errorMessage);
479         return a % b;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/Address.sol
484 
485 
486 pragma solidity ^0.6.2;
487 
488 /**
489  * @dev Collection of functions related to the address type
490  */
491 library Address {
492     /**
493      * @dev Returns true if `account` is a contract.
494      *
495      * [IMPORTANT]
496      * ====
497      * It is unsafe to assume that an address for which this function returns
498      * false is an externally-owned account (EOA) and not a contract.
499      *
500      * Among others, `isContract` will return false for the following
501      * types of addresses:
502      *
503      *  - an externally-owned account
504      *  - a contract in construction
505      *  - an address where a contract will be created
506      *  - an address where a contract lived, but was destroyed
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
511         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
512         // for accounts without code, i.e. `keccak256('')`
513         bytes32 codehash;
514         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
515         // solhint-disable-next-line no-inline-assembly
516         assembly { codehash := extcodehash(account) }
517         return (codehash != accountHash && codehash != 0x0);
518     }
519 
520     /**
521      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
522      * `recipient`, forwarding all available gas and reverting on errors.
523      *
524      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
525      * of certain opcodes, possibly making contracts go over the 2300 gas limit
526      * imposed by `transfer`, making them unable to receive funds via
527      * `transfer`. {sendValue} removes this limitation.
528      *
529      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
530      *
531      * IMPORTANT: because control is transferred to `recipient`, care must be
532      * taken to not create reentrancy vulnerabilities. Consider using
533      * {ReentrancyGuard} or the
534      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
535      */
536     function sendValue(address payable recipient, uint256 amount) internal {
537         require(address(this).balance >= amount, "Address: insufficient balance");
538 
539         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
540         (bool success, ) = recipient.call{ value: amount }("");
541         require(success, "Address: unable to send value, recipient may have reverted");
542     }
543 
544     /**
545      * @dev Performs a Solidity function call using a low level `call`. A
546      * plain`call` is an unsafe replacement for a function call: use this
547      * function instead.
548      *
549      * If `target` reverts with a revert reason, it is bubbled up by this
550      * function (like regular Solidity function calls).
551      *
552      * Returns the raw returned data. To convert to the expected return value,
553      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
554      *
555      * Requirements:
556      *
557      * - `target` must be a contract.
558      * - calling `target` with `data` must not revert.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
563       return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
573         return _functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
593      * with `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
598         require(address(this).balance >= value, "Address: insufficient balance for call");
599         return _functionCallWithValue(target, data, value, errorMessage);
600     }
601 
602     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
603         require(isContract(target), "Address: call to non-contract");
604 
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
607         if (success) {
608             return returndata;
609         } else {
610             // Look for revert reason and bubble it up if present
611             if (returndata.length > 0) {
612                 // The easiest way to bubble the revert reason is using memory via assembly
613 
614                 // solhint-disable-next-line no-inline-assembly
615                 assembly {
616                     let returndata_size := mload(returndata)
617                     revert(add(32, returndata), returndata_size)
618                 }
619             } else {
620                 revert(errorMessage);
621             }
622         }
623     }
624 }
625 
626 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
627 
628 
629 pragma solidity ^0.6.0;
630 
631 /**
632  * @dev Library for managing
633  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
634  * types.
635  *
636  * Sets have the following properties:
637  *
638  * - Elements are added, removed, and checked for existence in constant time
639  * (O(1)).
640  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
641  *
642  * ```
643  * contract Example {
644  *     // Add the library methods
645  *     using EnumerableSet for EnumerableSet.AddressSet;
646  *
647  *     // Declare a set state variable
648  *     EnumerableSet.AddressSet private mySet;
649  * }
650  * ```
651  *
652  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
653  * (`UintSet`) are supported.
654  */
655 library EnumerableSet {
656     // To implement this library for multiple types with as little code
657     // repetition as possible, we write it in terms of a generic Set type with
658     // bytes32 values.
659     // The Set implementation uses private functions, and user-facing
660     // implementations (such as AddressSet) are just wrappers around the
661     // underlying Set.
662     // This means that we can only create new EnumerableSets for types that fit
663     // in bytes32.
664 
665     struct Set {
666         // Storage of set values
667         bytes32[] _values;
668 
669         // Position of the value in the `values` array, plus 1 because index 0
670         // means a value is not in the set.
671         mapping (bytes32 => uint256) _indexes;
672     }
673 
674     /**
675      * @dev Add a value to a set. O(1).
676      *
677      * Returns true if the value was added to the set, that is if it was not
678      * already present.
679      */
680     function _add(Set storage set, bytes32 value) private returns (bool) {
681         if (!_contains(set, value)) {
682             set._values.push(value);
683             // The value is stored at length-1, but we add 1 to all indexes
684             // and use 0 as a sentinel value
685             set._indexes[value] = set._values.length;
686             return true;
687         } else {
688             return false;
689         }
690     }
691 
692     /**
693      * @dev Removes a value from a set. O(1).
694      *
695      * Returns true if the value was removed from the set, that is if it was
696      * present.
697      */
698     function _remove(Set storage set, bytes32 value) private returns (bool) {
699         // We read and store the value's index to prevent multiple reads from the same storage slot
700         uint256 valueIndex = set._indexes[value];
701 
702         if (valueIndex != 0) { // Equivalent to contains(set, value)
703             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
704             // the array, and then remove the last element (sometimes called as 'swap and pop').
705             // This modifies the order of the array, as noted in {at}.
706 
707             uint256 toDeleteIndex = valueIndex - 1;
708             uint256 lastIndex = set._values.length - 1;
709 
710             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
711             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
712 
713             bytes32 lastvalue = set._values[lastIndex];
714 
715             // Move the last value to the index where the value to delete is
716             set._values[toDeleteIndex] = lastvalue;
717             // Update the index for the moved value
718             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
719 
720             // Delete the slot where the moved value was stored
721             set._values.pop();
722 
723             // Delete the index for the deleted slot
724             delete set._indexes[value];
725 
726             return true;
727         } else {
728             return false;
729         }
730     }
731 
732     /**
733      * @dev Returns true if the value is in the set. O(1).
734      */
735     function _contains(Set storage set, bytes32 value) private view returns (bool) {
736         return set._indexes[value] != 0;
737     }
738 
739     /**
740      * @dev Returns the number of values on the set. O(1).
741      */
742     function _length(Set storage set) private view returns (uint256) {
743         return set._values.length;
744     }
745 
746    /**
747     * @dev Returns the value stored at position `index` in the set. O(1).
748     *
749     * Note that there are no guarantees on the ordering of values inside the
750     * array, and it may change when more values are added or removed.
751     *
752     * Requirements:
753     *
754     * - `index` must be strictly less than {length}.
755     */
756     function _at(Set storage set, uint256 index) private view returns (bytes32) {
757         require(set._values.length > index, "EnumerableSet: index out of bounds");
758         return set._values[index];
759     }
760 
761     // AddressSet
762 
763     struct AddressSet {
764         Set _inner;
765     }
766 
767     /**
768      * @dev Add a value to a set. O(1).
769      *
770      * Returns true if the value was added to the set, that is if it was not
771      * already present.
772      */
773     function add(AddressSet storage set, address value) internal returns (bool) {
774         return _add(set._inner, bytes32(uint256(value)));
775     }
776 
777     /**
778      * @dev Removes a value from a set. O(1).
779      *
780      * Returns true if the value was removed from the set, that is if it was
781      * present.
782      */
783     function remove(AddressSet storage set, address value) internal returns (bool) {
784         return _remove(set._inner, bytes32(uint256(value)));
785     }
786 
787     /**
788      * @dev Returns true if the value is in the set. O(1).
789      */
790     function contains(AddressSet storage set, address value) internal view returns (bool) {
791         return _contains(set._inner, bytes32(uint256(value)));
792     }
793 
794     /**
795      * @dev Returns the number of values in the set. O(1).
796      */
797     function length(AddressSet storage set) internal view returns (uint256) {
798         return _length(set._inner);
799     }
800 
801    /**
802     * @dev Returns the value stored at position `index` in the set. O(1).
803     *
804     * Note that there are no guarantees on the ordering of values inside the
805     * array, and it may change when more values are added or removed.
806     *
807     * Requirements:
808     *
809     * - `index` must be strictly less than {length}.
810     */
811     function at(AddressSet storage set, uint256 index) internal view returns (address) {
812         return address(uint256(_at(set._inner, index)));
813     }
814 
815 
816     // UintSet
817 
818     struct UintSet {
819         Set _inner;
820     }
821 
822     /**
823      * @dev Add a value to a set. O(1).
824      *
825      * Returns true if the value was added to the set, that is if it was not
826      * already present.
827      */
828     function add(UintSet storage set, uint256 value) internal returns (bool) {
829         return _add(set._inner, bytes32(value));
830     }
831 
832     /**
833      * @dev Removes a value from a set. O(1).
834      *
835      * Returns true if the value was removed from the set, that is if it was
836      * present.
837      */
838     function remove(UintSet storage set, uint256 value) internal returns (bool) {
839         return _remove(set._inner, bytes32(value));
840     }
841 
842     /**
843      * @dev Returns true if the value is in the set. O(1).
844      */
845     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
846         return _contains(set._inner, bytes32(value));
847     }
848 
849     /**
850      * @dev Returns the number of values on the set. O(1).
851      */
852     function length(UintSet storage set) internal view returns (uint256) {
853         return _length(set._inner);
854     }
855 
856    /**
857     * @dev Returns the value stored at position `index` in the set. O(1).
858     *
859     * Note that there are no guarantees on the ordering of values inside the
860     * array, and it may change when more values are added or removed.
861     *
862     * Requirements:
863     *
864     * - `index` must be strictly less than {length}.
865     */
866     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
867         return uint256(_at(set._inner, index));
868     }
869 }
870 
871 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
872 
873 
874 pragma solidity ^0.6.0;
875 
876 /**
877  * @dev Library for managing an enumerable variant of Solidity's
878  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
879  * type.
880  *
881  * Maps have the following properties:
882  *
883  * - Entries are added, removed, and checked for existence in constant time
884  * (O(1)).
885  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
886  *
887  * ```
888  * contract Example {
889  *     // Add the library methods
890  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
891  *
892  *     // Declare a set state variable
893  *     EnumerableMap.UintToAddressMap private myMap;
894  * }
895  * ```
896  *
897  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
898  * supported.
899  */
900 library EnumerableMap {
901     // To implement this library for multiple types with as little code
902     // repetition as possible, we write it in terms of a generic Map type with
903     // bytes32 keys and values.
904     // The Map implementation uses private functions, and user-facing
905     // implementations (such as Uint256ToAddressMap) are just wrappers around
906     // the underlying Map.
907     // This means that we can only create new EnumerableMaps for types that fit
908     // in bytes32.
909 
910     struct MapEntry {
911         bytes32 _key;
912         bytes32 _value;
913     }
914 
915     struct Map {
916         // Storage of map keys and values
917         MapEntry[] _entries;
918 
919         // Position of the entry defined by a key in the `entries` array, plus 1
920         // because index 0 means a key is not in the map.
921         mapping (bytes32 => uint256) _indexes;
922     }
923 
924     /**
925      * @dev Adds a key-value pair to a map, or updates the value for an existing
926      * key. O(1).
927      *
928      * Returns true if the key was added to the map, that is if it was not
929      * already present.
930      */
931     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
932         // We read and store the key's index to prevent multiple reads from the same storage slot
933         uint256 keyIndex = map._indexes[key];
934 
935         if (keyIndex == 0) { // Equivalent to !contains(map, key)
936             map._entries.push(MapEntry({ _key: key, _value: value }));
937             // The entry is stored at length-1, but we add 1 to all indexes
938             // and use 0 as a sentinel value
939             map._indexes[key] = map._entries.length;
940             return true;
941         } else {
942             map._entries[keyIndex - 1]._value = value;
943             return false;
944         }
945     }
946 
947     /**
948      * @dev Removes a key-value pair from a map. O(1).
949      *
950      * Returns true if the key was removed from the map, that is if it was present.
951      */
952     function _remove(Map storage map, bytes32 key) private returns (bool) {
953         // We read and store the key's index to prevent multiple reads from the same storage slot
954         uint256 keyIndex = map._indexes[key];
955 
956         if (keyIndex != 0) { // Equivalent to contains(map, key)
957             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
958             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
959             // This modifies the order of the array, as noted in {at}.
960 
961             uint256 toDeleteIndex = keyIndex - 1;
962             uint256 lastIndex = map._entries.length - 1;
963 
964             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
965             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
966 
967             MapEntry storage lastEntry = map._entries[lastIndex];
968 
969             // Move the last entry to the index where the entry to delete is
970             map._entries[toDeleteIndex] = lastEntry;
971             // Update the index for the moved entry
972             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
973 
974             // Delete the slot where the moved entry was stored
975             map._entries.pop();
976 
977             // Delete the index for the deleted slot
978             delete map._indexes[key];
979 
980             return true;
981         } else {
982             return false;
983         }
984     }
985 
986     /**
987      * @dev Returns true if the key is in the map. O(1).
988      */
989     function _contains(Map storage map, bytes32 key) private view returns (bool) {
990         return map._indexes[key] != 0;
991     }
992 
993     /**
994      * @dev Returns the number of key-value pairs in the map. O(1).
995      */
996     function _length(Map storage map) private view returns (uint256) {
997         return map._entries.length;
998     }
999 
1000    /**
1001     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1002     *
1003     * Note that there are no guarantees on the ordering of entries inside the
1004     * array, and it may change when more entries are added or removed.
1005     *
1006     * Requirements:
1007     *
1008     * - `index` must be strictly less than {length}.
1009     */
1010     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1011         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1012 
1013         MapEntry storage entry = map._entries[index];
1014         return (entry._key, entry._value);
1015     }
1016 
1017     /**
1018      * @dev Returns the value associated with `key`.  O(1).
1019      *
1020      * Requirements:
1021      *
1022      * - `key` must be in the map.
1023      */
1024     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1025         return _get(map, key, "EnumerableMap: nonexistent key");
1026     }
1027 
1028     /**
1029      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1030      */
1031     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1032         uint256 keyIndex = map._indexes[key];
1033         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1034         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1035     }
1036 
1037     // UintToAddressMap
1038 
1039     struct UintToAddressMap {
1040         Map _inner;
1041     }
1042 
1043     /**
1044      * @dev Adds a key-value pair to a map, or updates the value for an existing
1045      * key. O(1).
1046      *
1047      * Returns true if the key was added to the map, that is if it was not
1048      * already present.
1049      */
1050     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1051         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1052     }
1053 
1054     /**
1055      * @dev Removes a value from a set. O(1).
1056      *
1057      * Returns true if the key was removed from the map, that is if it was present.
1058      */
1059     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1060         return _remove(map._inner, bytes32(key));
1061     }
1062 
1063     /**
1064      * @dev Returns true if the key is in the map. O(1).
1065      */
1066     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1067         return _contains(map._inner, bytes32(key));
1068     }
1069 
1070     /**
1071      * @dev Returns the number of elements in the map. O(1).
1072      */
1073     function length(UintToAddressMap storage map) internal view returns (uint256) {
1074         return _length(map._inner);
1075     }
1076 
1077    /**
1078     * @dev Returns the element stored at position `index` in the set. O(1).
1079     * Note that there are no guarantees on the ordering of values inside the
1080     * array, and it may change when more values are added or removed.
1081     *
1082     * Requirements:
1083     *
1084     * - `index` must be strictly less than {length}.
1085     */
1086     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1087         (bytes32 key, bytes32 value) = _at(map._inner, index);
1088         return (uint256(key), address(uint256(value)));
1089     }
1090 
1091     /**
1092      * @dev Returns the value associated with `key`.  O(1).
1093      *
1094      * Requirements:
1095      *
1096      * - `key` must be in the map.
1097      */
1098     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1099         return address(uint256(_get(map._inner, bytes32(key))));
1100     }
1101 
1102     /**
1103      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1104      */
1105     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1106         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1107     }
1108 }
1109 
1110 // File: @openzeppelin/contracts/utils/Strings.sol
1111 
1112 
1113 pragma solidity ^0.6.0;
1114 
1115 /**
1116  * @dev String operations.
1117  */
1118 library Strings {
1119     /**
1120      * @dev Converts a `uint256` to its ASCII `string` representation.
1121      */
1122     function toString(uint256 value) internal pure returns (string memory) {
1123         // Inspired by OraclizeAPI's implementation - MIT licence
1124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1125 
1126         if (value == 0) {
1127             return "0";
1128         }
1129         uint256 temp = value;
1130         uint256 digits;
1131         while (temp != 0) {
1132             digits++;
1133             temp /= 10;
1134         }
1135         bytes memory buffer = new bytes(digits);
1136         uint256 index = digits - 1;
1137         temp = value;
1138         while (temp != 0) {
1139             buffer[index--] = byte(uint8(48 + temp % 10));
1140             temp /= 10;
1141         }
1142         return string(buffer);
1143     }
1144 }
1145 
1146 /**
1147  * @title ERC721 Non-Fungible Token Standard basic implementation
1148  * @dev see https://eips.ethereum.org/EIPS/eip-721
1149  */
1150 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1151     using SafeMath for uint256;
1152     using Address for address;
1153     using EnumerableSet for EnumerableSet.UintSet;
1154     using EnumerableMap for EnumerableMap.UintToAddressMap;
1155     using Strings for uint256;
1156 
1157     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1158     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1159     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1160 
1161     // Mapping from holder address to their (enumerable) set of owned tokens
1162     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1163 
1164     // Enumerable mapping from token ids to their owners
1165     EnumerableMap.UintToAddressMap private _tokenOwners;
1166     
1167     // Enumerable mapping from token ids to their owners
1168     EnumerableMap.UintToAddressMap private _tokenCreators;
1169 
1170     // Mapping from token ID to approved address
1171     mapping (uint256 => address) private _tokenApprovals;
1172 
1173     // Mapping from owner to operator approvals
1174     mapping (address => mapping (address => bool)) private _operatorApprovals;
1175 
1176     // Token name
1177     string private _name;
1178 
1179     // Token symbol
1180     string private _symbol;
1181 
1182     // Optional mapping for token URIs
1183     mapping(uint256 => string) private _tokenURIs;
1184 
1185 
1186     /*
1187      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1188      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1189      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1190      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1191      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1192      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1193      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1194      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1195      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1196      *
1197      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1198      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1199      */
1200     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1201 
1202     /*
1203      *     bytes4(keccak256('name()')) == 0x06fdde03
1204      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1205      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1206      *
1207      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1208      */
1209     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1210 
1211     /*
1212      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1213      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1214      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1215      *
1216      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1217      */
1218     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1219 
1220     /**
1221      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1222      */
1223     constructor (string memory name, string memory symbol) public {
1224         _name = name;
1225         _symbol = symbol;
1226 
1227         // register the supported interfaces to conform to ERC721 via ERC165
1228         _registerInterface(_INTERFACE_ID_ERC721);
1229         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1230         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-balanceOf}.
1235      */
1236     function balanceOf(address owner) public view override returns (uint256) {
1237         require(owner != address(0), "ERC721: balance query for the zero address");
1238 
1239         return _holderTokens[owner].length();
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-ownerOf}.
1244      */
1245     function ownerOf(uint256 tokenId) public view override returns (address) {
1246         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1247     }
1248 
1249     /**
1250      * @dev Returns token creator by tokenId.
1251      */
1252     function creatorOf(uint256 tokenId) public view returns (address) {
1253         return _tokenCreators.get(tokenId, "ERC721: owner query for nonexistent token");
1254     }
1255 
1256 
1257     /**
1258      * @dev See {IERC721Metadata-name}.
1259      */
1260     function name() public view override returns (string memory) {
1261         return _name;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Metadata-symbol}.
1266      */
1267     function symbol() public view override returns (string memory) {
1268         return _symbol;
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Metadata-tokenURI}.
1273      */
1274     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1275         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1276 
1277         string memory _tokenURI = _tokenURIs[tokenId];
1278         return _tokenURI;
1279     }
1280 
1281     /**
1282      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1283      */
1284     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1285         return _holderTokens[owner].at(index);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-totalSupply}.
1290      */
1291     function totalSupply() public view override returns (uint256) {
1292         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1293         return _tokenOwners.length();
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-tokenByIndex}.
1298      */
1299     function tokenByIndex(uint256 index) public view override returns (uint256) {
1300         (uint256 tokenId, ) = _tokenOwners.at(index);
1301         return tokenId;
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-approve}.
1306      */
1307     function approve(address to, uint256 tokenId) public virtual override {
1308         address owner = ownerOf(tokenId);
1309         require(to != owner, "ERC721: approval to current owner");
1310 
1311         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1312             "ERC721: approve caller is not owner nor approved for all"
1313         );
1314 
1315         _approve(to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-getApproved}.
1320      */
1321     function getApproved(uint256 tokenId) public view override returns (address) {
1322         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1323 
1324         return _tokenApprovals[tokenId];
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-setApprovalForAll}.
1329      */
1330     function setApprovalForAll(address operator, bool approved) public virtual override {
1331         require(operator != _msgSender(), "ERC721: approve to caller");
1332 
1333         _operatorApprovals[_msgSender()][operator] = approved;
1334         emit ApprovalForAll(_msgSender(), operator, approved);
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-isApprovedForAll}.
1339      */
1340     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1341         return _operatorApprovals[owner][operator];
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-transferFrom}.
1346      */
1347     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1348         //solhint-disable-next-line max-line-length
1349         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1350 
1351         _transfer(from, to, tokenId);
1352     }
1353     
1354     /**
1355      * @dev .
1356      */
1357     function mint(address _receiver,string memory _tokenURI) public returns (uint256) {
1358         uint256 id = _tokenOwners.length().add(1);
1359         _mint(_receiver,id);
1360         _setTokenURI(id, _tokenURI);
1361         
1362         return id;
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-safeTransferFrom}.
1367      */
1368     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1369         safeTransferFrom(from, to, tokenId, "");
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-safeTransferFrom}.
1374      */
1375     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1376         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1377         _safeTransfer(from, to, tokenId, _data);
1378     }
1379 
1380     /**
1381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1383      *
1384      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1385      *
1386      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1387      * implement alternative mecanisms to perform token transfer, such as signature-based.
1388      *
1389      * Requirements:
1390      *
1391      * - `from` cannot be the zero address.
1392      * - `to` cannot be the zero address.
1393      * - `tokenId` token must exist and be owned by `from`.
1394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1399         _transfer(from, to, tokenId);
1400         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted (`_mint`),
1409      * and stop existing when they are burned (`_burn`).
1410      */
1411     function _exists(uint256 tokenId) internal view returns (bool) {
1412         return _tokenOwners.contains(tokenId);
1413     }
1414 
1415     /**
1416      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1424         address owner = ownerOf(tokenId);
1425         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1426     }
1427 
1428     /**
1429      * @dev Safely mints `tokenId` and transfers it to `to`.
1430      *
1431      * Requirements:
1432      d*
1433      * - `tokenId` must not exist.
1434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _safeMint(address to, uint256 tokenId) internal virtual {
1439         _safeMint(to, tokenId, "");
1440     }
1441 
1442     /**
1443      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1444      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1445      */
1446     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1447         _mint(to, tokenId);
1448         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1449     }
1450 
1451     /**
1452      * @dev Mints `tokenId` and transfers it to `to`.
1453      *
1454      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1455      *
1456      * Requirements:
1457      *
1458      * - `tokenId` must not exist.
1459      * - `to` cannot be the zero address.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _mint(address to, uint256 tokenId) internal virtual {
1464         require(to != address(0), "ERC721: mint to the zero address");
1465         require(!_exists(tokenId), "ERC721: token already minted");
1466 
1467         _beforeTokenTransfer(address(0), to, tokenId);
1468 
1469         _holderTokens[to].add(tokenId);
1470 
1471         _tokenOwners.set(tokenId, to);
1472         
1473         _tokenCreators.set(tokenId, msg.sender);
1474 
1475         emit Transfer(address(0), to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Destroys `tokenId`.
1480      * The approval is cleared when the token is burned.
1481      *
1482      * Requirements:
1483      *
1484      * - `tokenId` must exist.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _burn(uint256 tokenId) internal virtual {
1489         address owner = ownerOf(tokenId);
1490 
1491         _beforeTokenTransfer(owner, address(0), tokenId);
1492 
1493         // Clear approvals
1494         _approve(address(0), tokenId);
1495 
1496         // Clear metadata (if any)
1497         if (bytes(_tokenURIs[tokenId]).length != 0) {
1498             delete _tokenURIs[tokenId];
1499         }
1500 
1501         _holderTokens[owner].remove(tokenId);
1502 
1503         _tokenOwners.remove(tokenId);
1504         
1505         _tokenCreators.remove(tokenId);
1506 
1507         emit Transfer(owner, address(0), tokenId);
1508     }
1509 
1510     /**
1511      * @dev Transfers `tokenId` from `from` to `to`.
1512      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      * - `tokenId` token must be owned by `from`.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1522         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1523         require(to != address(0), "ERC721: transfer to the zero address");
1524 
1525         _beforeTokenTransfer(from, to, tokenId);
1526 
1527         // Clear approvals from the previous owner
1528         _approve(address(0), tokenId);
1529 
1530         _holderTokens[from].remove(tokenId);
1531         _holderTokens[to].add(tokenId);
1532 
1533         _tokenOwners.set(tokenId, to);
1534 
1535         emit Transfer(from, to, tokenId);
1536     }
1537 
1538     /**
1539      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1540      *
1541      * Requirements:
1542      *
1543      * - `tokenId` must exist.
1544      */
1545     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1546         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1547         _tokenURIs[tokenId] = _tokenURI;
1548     }
1549 
1550     /**
1551      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1552      * The call is not executed if the target address is not a contract.
1553      *
1554      * @param from address representing the previous owner of the given token ID
1555      * @param to target address that will receive the tokens
1556      * @param tokenId uint256 ID of the token to be transferred
1557      * @param _data bytes optional data to send along with the call
1558      * @return bool whether the call correctly returned the expected magic value
1559      */
1560     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1561         private returns (bool)
1562     {
1563         if (!to.isContract()) {
1564             return true;
1565         }
1566         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1567             IERC721Receiver(to).onERC721Received.selector,
1568             _msgSender(),
1569             from,
1570             tokenId,
1571             _data
1572         ), "ERC721: transfer to non ERC721Receiver implementer");
1573         bytes4 retval = abi.decode(returndata, (bytes4));
1574         return (retval == _ERC721_RECEIVED);
1575     }
1576 
1577     function _approve(address to, uint256 tokenId) private {
1578         _tokenApprovals[tokenId] = to;
1579         emit Approval(ownerOf(tokenId), to, tokenId);
1580     }
1581 
1582     /**
1583      * @dev Hook that is called before any token transfer. This includes minting
1584      * and burning.
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` will be minted for `to`.
1591      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1592      * - `from` cannot be the zero address.
1593      * - `to` cannot be the zero address.
1594      *
1595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1596      */
1597     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1598 }
1599 
1600 // File ownable.sol
1601 
1602 
1603 pragma solidity ^0.6.0;
1604 
1605 /**
1606  * @dev Contract module which provides a basic access control mechanism, where
1607  * there is an account (an owner) that can be granted exclusive access to
1608  * specific functions.
1609  *
1610  * By default, the owner account will be the one that deploys the contract. This
1611  * can later be changed with {transferOwnership}.
1612  *
1613  * This module is used through inheritance. It will make available the modifier
1614  * `onlyOwner`, which can be applied to your functions to restrict their use to
1615  * the owner.
1616  */
1617 contract Ownable is Context {
1618     address private _owner;
1619 
1620     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1621 
1622     /**
1623      * @dev Initializes the contract setting the deployer as the initial owner.
1624      */
1625     constructor () internal {
1626         address msgSender = _msgSender();
1627         _owner = msgSender;
1628         emit OwnershipTransferred(address(0), msgSender);
1629     }
1630 
1631     /**
1632      * @dev Returns the address of the current owner.
1633      */
1634     function owner() public view returns (address) {
1635         return _owner;
1636     }
1637 
1638     /**
1639      * @dev Throws if called by any account other than the owner.
1640      */
1641     modifier onlyOwner() {
1642         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1643         _;
1644     }
1645 
1646     /**
1647      * @dev Leaves the contract without owner. It will not be possible to call
1648      * `onlyOwner` functions anymore. Can only be called by the current owner.
1649      *
1650      * NOTE: Renouncing ownership will leave the contract without an owner,
1651      * thereby removing any functionality that is only available to the owner.
1652      */
1653     function renounceOwnership() public virtual onlyOwner {
1654         emit OwnershipTransferred(_owner, address(0));
1655         _owner = address(0);
1656     }
1657 
1658     /**
1659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1660      * Can only be called by the current owner.
1661      */
1662     function transferOwnership(address newOwner) public virtual onlyOwner {
1663         require(newOwner != address(0), "Ownable: new owner is the zero address");
1664         emit OwnershipTransferred(_owner, newOwner);
1665         _owner = newOwner;
1666     }
1667 }
1668 
1669 // File: col.sol
1670 
1671 pragma solidity ^0.6.0;
1672 
1673 
1674 contract Blockparty is ERC721, Ownable {
1675     string uri;
1676     
1677     constructor(string memory tokenName, string memory tokenSymbol, string memory contractURI ) public ERC721(tokenName, tokenSymbol) {
1678         uri = contractURI;
1679     }
1680     
1681     function contractURI() external view returns (string memory) {
1682         return uri;
1683     }
1684     
1685     function setContractURI(string calldata _uri) external onlyOwner {
1686         uri = _uri;
1687     }
1688 }