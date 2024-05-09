1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
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
28 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
29 
30 pragma solidity ^0.7.0;
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
55 pragma solidity ^0.7.0;
56 
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(address from, address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(address from, address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167       * @dev Safely transfers `tokenId` token from `from` to `to`.
168       *
169       * Requirements:
170       *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173       * - `tokenId` token must exist and be owned by `from`.
174       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176       *
177       * Emits a {Transfer} event.
178       */
179     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
180 }
181 
182 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
183 
184 pragma solidity ^0.7.0;
185 
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192 
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Enumerable.sol
210 
211 pragma solidity ^0.7.0;
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Enumerable is IERC721 {
219 
220     /**
221      * @dev Returns the total amount of tokens stored by the contract.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
227      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
228      */
229     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
230 
231     /**
232      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
233      * Use along with {totalSupply} to enumerate all tokens.
234      */
235     function tokenByIndex(uint256 index) external view returns (uint256);
236 }
237 
238 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
239 
240 pragma solidity ^0.7.0;
241 
242 /**
243  * @title ERC721 token receiver interface
244  * @dev Interface for any contract that wants to support safeTransfers
245  * from ERC721 asset contracts.
246  */
247 interface IERC721Receiver {
248     /**
249      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
250      * by `operator` from `from`, this function is called.
251      *
252      * It must return its Solidity selector to confirm the token transfer.
253      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
254      *
255      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
256      */
257     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
258     external returns (bytes4);
259 }
260 
261 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
262 
263 pragma solidity ^0.7.0;
264 
265 
266 /**
267  * @dev Implementation of the {IERC165} interface.
268  *
269  * Contracts may inherit from this and call {_registerInterface} to declare
270  * their support of an interface.
271  */
272 abstract contract ERC165 is IERC165 {
273     /*
274      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
275      */
276     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
277 
278     /**
279      * @dev Mapping of interface ids to whether or not it's supported.
280      */
281     mapping(bytes4 => bool) private _supportedInterfaces;
282 
283     constructor () {
284         // Derived contracts need only register support for their own interfaces,
285         // we register support for ERC165 itself here
286         _registerInterface(_INTERFACE_ID_ERC165);
287     }
288 
289     /**
290      * @dev See {IERC165-supportsInterface}.
291      *
292      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
295         return _supportedInterfaces[interfaceId];
296     }
297 
298     /**
299      * @dev Registers the contract as an implementer of the interface defined by
300      * `interfaceId`. Support of the actual ERC165 interface is automatic and
301      * registering its interface id is not required.
302      *
303      * See {IERC165-supportsInterface}.
304      *
305      * Requirements:
306      *
307      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
308      */
309     function _registerInterface(bytes4 interfaceId) internal virtual {
310         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
311         _supportedInterfaces[interfaceId] = true;
312     }
313 }
314 
315 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
316 
317 pragma solidity ^0.7.0;
318 
319 /**
320  * @dev Wrappers over Solidity's arithmetic operations with added overflow
321  * checks.
322  *
323  * Arithmetic operations in Solidity wrap on overflow. This can easily result
324  * in bugs, because programmers usually assume that an overflow raises an
325  * error, which is the standard behavior in high level programming languages.
326  * `SafeMath` restores this intuition by reverting the transaction when an
327  * operation overflows.
328  *
329  * Using this library instead of the unchecked operations eliminates an entire
330  * class of bugs, so it's recommended to use it always.
331  */
332 library SafeMath {
333     /**
334      * @dev Returns the addition of two unsigned integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `+` operator.
338      *
339      * Requirements:
340      *
341      * - Addition cannot overflow.
342      */
343     function add(uint256 a, uint256 b) internal pure returns (uint256) {
344         uint256 c = a + b;
345         require(c >= a, "SafeMath: addition overflow");
346 
347         return c;
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting on
352      * overflow (when the result is negative).
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
361         return sub(a, b, "SafeMath: subtraction overflow");
362     }
363 
364     /**
365      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
366      * overflow (when the result is negative).
367      *
368      * Counterpart to Solidity's `-` operator.
369      *
370      * Requirements:
371      *
372      * - Subtraction cannot overflow.
373      */
374     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
375         require(b <= a, errorMessage);
376         uint256 c = a - b;
377 
378         return c;
379     }
380 
381     /**
382      * @dev Returns the multiplication of two unsigned integers, reverting on
383      * overflow.
384      *
385      * Counterpart to Solidity's `*` operator.
386      *
387      * Requirements:
388      *
389      * - Multiplication cannot overflow.
390      */
391     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
392         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
393         // benefit is lost if 'b' is also tested.
394         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
395         if (a == 0) {
396             return 0;
397         }
398 
399         uint256 c = a * b;
400         require(c / a == b, "SafeMath: multiplication overflow");
401 
402         return c;
403     }
404 
405     /**
406      * @dev Returns the integer division of two unsigned integers. Reverts on
407      * division by zero. The result is rounded towards zero.
408      *
409      * Counterpart to Solidity's `/` operator. Note: this function uses a
410      * `revert` opcode (which leaves remaining gas untouched) while Solidity
411      * uses an invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      *
415      * - The divisor cannot be zero.
416      */
417     function div(uint256 a, uint256 b) internal pure returns (uint256) {
418         return div(a, b, "SafeMath: division by zero");
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
433     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
434         require(b > 0, errorMessage);
435         uint256 c = a / b;
436         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
437 
438         return c;
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * Reverts when dividing by zero.
444      *
445      * Counterpart to Solidity's `%` operator. This function uses a `revert`
446      * opcode (which leaves remaining gas untouched) while Solidity uses an
447      * invalid opcode to revert (consuming all remaining gas).
448      *
449      * Requirements:
450      *
451      * - The divisor cannot be zero.
452      */
453     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
454         return mod(a, b, "SafeMath: modulo by zero");
455     }
456 
457     /**
458      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
459      * Reverts with custom message when dividing by zero.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
470         require(b != 0, errorMessage);
471         return a % b;
472     }
473 }
474 
475 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
476 
477 pragma solidity ^0.7.0;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      */
500     function isContract(address account) internal view returns (bool) {
501         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
502         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
503         // for accounts without code, i.e. `keccak256('')`
504         bytes32 codehash;
505         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
506         // solhint-disable-next-line no-inline-assembly
507         assembly { codehash := extcodehash(account) }
508         return (codehash != accountHash && codehash != 0x0);
509     }
510 
511     /**
512      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
513      * `recipient`, forwarding all available gas and reverting on errors.
514      *
515      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
516      * of certain opcodes, possibly making contracts go over the 2300 gas limit
517      * imposed by `transfer`, making them unable to receive funds via
518      * `transfer`. {sendValue} removes this limitation.
519      *
520      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
521      *
522      * IMPORTANT: because control is transferred to `recipient`, care must be
523      * taken to not create reentrancy vulnerabilities. Consider using
524      * {ReentrancyGuard} or the
525      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
526      */
527     function sendValue(address payable recipient, uint256 amount) internal {
528         require(address(this).balance >= amount, "Address: insufficient balance");
529 
530         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
531         (bool success, ) = recipient.call{ value: amount }("");
532         require(success, "Address: unable to send value, recipient may have reverted");
533     }
534 
535     /**
536      * @dev Performs a Solidity function call using a low level `call`. A
537      * plain`call` is an unsafe replacement for a function call: use this
538      * function instead.
539      *
540      * If `target` reverts with a revert reason, it is bubbled up by this
541      * function (like regular Solidity function calls).
542      *
543      * Returns the raw returned data. To convert to the expected return value,
544      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
545      *
546      * Requirements:
547      *
548      * - `target` must be a contract.
549      * - calling `target` with `data` must not revert.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
554       return functionCall(target, data, "Address: low-level call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
559      * `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
564         return _functionCallWithValue(target, data, 0, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but also transferring `value` wei to `target`.
570      *
571      * Requirements:
572      *
573      * - the calling contract must have an ETH balance of at least `value`.
574      * - the called Solidity function must be `payable`.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
579         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
584      * with `errorMessage` as a fallback revert reason when `target` reverts.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
589         require(address(this).balance >= value, "Address: insufficient balance for call");
590         return _functionCallWithValue(target, data, value, errorMessage);
591     }
592 
593     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
594         require(isContract(target), "Address: call to non-contract");
595 
596         // solhint-disable-next-line avoid-low-level-calls
597         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
598         if (success) {
599             return returndata;
600         } else {
601             // Look for revert reason and bubble it up if present
602             if (returndata.length > 0) {
603                 // The easiest way to bubble the revert reason is using memory via assembly
604 
605                 // solhint-disable-next-line no-inline-assembly
606                 assembly {
607                     let returndata_size := mload(returndata)
608                     revert(add(32, returndata), returndata_size)
609                 }
610             } else {
611                 revert(errorMessage);
612             }
613         }
614     }
615 }
616 
617 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
618 
619 pragma solidity ^0.7.0;
620 
621 /**
622  * @dev Library for managing
623  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
624  * types.
625  *
626  * Sets have the following properties:
627  *
628  * - Elements are added, removed, and checked for existence in constant time
629  * (O(1)).
630  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
631  *
632  * ```
633  * contract Example {
634  *     // Add the library methods
635  *     using EnumerableSet for EnumerableSet.AddressSet;
636  *
637  *     // Declare a set state variable
638  *     EnumerableSet.AddressSet private mySet;
639  * }
640  * ```
641  *
642  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
643  * (`UintSet`) are supported.
644  */
645 library EnumerableSet {
646     // To implement this library for multiple types with as little code
647     // repetition as possible, we write it in terms of a generic Set type with
648     // bytes32 values.
649     // The Set implementation uses private functions, and user-facing
650     // implementations (such as AddressSet) are just wrappers around the
651     // underlying Set.
652     // This means that we can only create new EnumerableSets for types that fit
653     // in bytes32.
654 
655     struct Set {
656         // Storage of set values
657         bytes32[] _values;
658 
659         // Position of the value in the `values` array, plus 1 because index 0
660         // means a value is not in the set.
661         mapping (bytes32 => uint256) _indexes;
662     }
663 
664     /**
665      * @dev Add a value to a set. O(1).
666      *
667      * Returns true if the value was added to the set, that is if it was not
668      * already present.
669      */
670     function _add(Set storage set, bytes32 value) private returns (bool) {
671         if (!_contains(set, value)) {
672             set._values.push(value);
673             // The value is stored at length-1, but we add 1 to all indexes
674             // and use 0 as a sentinel value
675             set._indexes[value] = set._values.length;
676             return true;
677         } else {
678             return false;
679         }
680     }
681 
682     /**
683      * @dev Removes a value from a set. O(1).
684      *
685      * Returns true if the value was removed from the set, that is if it was
686      * present.
687      */
688     function _remove(Set storage set, bytes32 value) private returns (bool) {
689         // We read and store the value's index to prevent multiple reads from the same storage slot
690         uint256 valueIndex = set._indexes[value];
691 
692         if (valueIndex != 0) { // Equivalent to contains(set, value)
693             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
694             // the array, and then remove the last element (sometimes called as 'swap and pop').
695             // This modifies the order of the array, as noted in {at}.
696 
697             uint256 toDeleteIndex = valueIndex - 1;
698             uint256 lastIndex = set._values.length - 1;
699 
700             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
701             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
702 
703             bytes32 lastvalue = set._values[lastIndex];
704 
705             // Move the last value to the index where the value to delete is
706             set._values[toDeleteIndex] = lastvalue;
707             // Update the index for the moved value
708             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
709 
710             // Delete the slot where the moved value was stored
711             set._values.pop();
712 
713             // Delete the index for the deleted slot
714             delete set._indexes[value];
715 
716             return true;
717         } else {
718             return false;
719         }
720     }
721 
722     /**
723      * @dev Returns true if the value is in the set. O(1).
724      */
725     function _contains(Set storage set, bytes32 value) private view returns (bool) {
726         return set._indexes[value] != 0;
727     }
728 
729     /**
730      * @dev Returns the number of values on the set. O(1).
731      */
732     function _length(Set storage set) private view returns (uint256) {
733         return set._values.length;
734     }
735 
736    /**
737     * @dev Returns the value stored at position `index` in the set. O(1).
738     *
739     * Note that there are no guarantees on the ordering of values inside the
740     * array, and it may change when more values are added or removed.
741     *
742     * Requirements:
743     *
744     * - `index` must be strictly less than {length}.
745     */
746     function _at(Set storage set, uint256 index) private view returns (bytes32) {
747         require(set._values.length > index, "EnumerableSet: index out of bounds");
748         return set._values[index];
749     }
750 
751     // AddressSet
752 
753     struct AddressSet {
754         Set _inner;
755     }
756 
757     /**
758      * @dev Add a value to a set. O(1).
759      *
760      * Returns true if the value was added to the set, that is if it was not
761      * already present.
762      */
763     function add(AddressSet storage set, address value) internal returns (bool) {
764         return _add(set._inner, bytes32(uint256(value)));
765     }
766 
767     /**
768      * @dev Removes a value from a set. O(1).
769      *
770      * Returns true if the value was removed from the set, that is if it was
771      * present.
772      */
773     function remove(AddressSet storage set, address value) internal returns (bool) {
774         return _remove(set._inner, bytes32(uint256(value)));
775     }
776 
777     /**
778      * @dev Returns true if the value is in the set. O(1).
779      */
780     function contains(AddressSet storage set, address value) internal view returns (bool) {
781         return _contains(set._inner, bytes32(uint256(value)));
782     }
783 
784     /**
785      * @dev Returns the number of values in the set. O(1).
786      */
787     function length(AddressSet storage set) internal view returns (uint256) {
788         return _length(set._inner);
789     }
790 
791    /**
792     * @dev Returns the value stored at position `index` in the set. O(1).
793     *
794     * Note that there are no guarantees on the ordering of values inside the
795     * array, and it may change when more values are added or removed.
796     *
797     * Requirements:
798     *
799     * - `index` must be strictly less than {length}.
800     */
801     function at(AddressSet storage set, uint256 index) internal view returns (address) {
802         return address(uint256(_at(set._inner, index)));
803     }
804 
805 
806     // UintSet
807 
808     struct UintSet {
809         Set _inner;
810     }
811 
812     /**
813      * @dev Add a value to a set. O(1).
814      *
815      * Returns true if the value was added to the set, that is if it was not
816      * already present.
817      */
818     function add(UintSet storage set, uint256 value) internal returns (bool) {
819         return _add(set._inner, bytes32(value));
820     }
821 
822     /**
823      * @dev Removes a value from a set. O(1).
824      *
825      * Returns true if the value was removed from the set, that is if it was
826      * present.
827      */
828     function remove(UintSet storage set, uint256 value) internal returns (bool) {
829         return _remove(set._inner, bytes32(value));
830     }
831 
832     /**
833      * @dev Returns true if the value is in the set. O(1).
834      */
835     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
836         return _contains(set._inner, bytes32(value));
837     }
838 
839     /**
840      * @dev Returns the number of values on the set. O(1).
841      */
842     function length(UintSet storage set) internal view returns (uint256) {
843         return _length(set._inner);
844     }
845 
846    /**
847     * @dev Returns the value stored at position `index` in the set. O(1).
848     *
849     * Note that there are no guarantees on the ordering of values inside the
850     * array, and it may change when more values are added or removed.
851     *
852     * Requirements:
853     *
854     * - `index` must be strictly less than {length}.
855     */
856     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
857         return uint256(_at(set._inner, index));
858     }
859 }
860 
861 // File: node_modules\@openzeppelin\contracts\utils\EnumerableMap.sol
862 
863 pragma solidity ^0.7.0;
864 
865 /**
866  * @dev Library for managing an enumerable variant of Solidity's
867  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
868  * type.
869  *
870  * Maps have the following properties:
871  *
872  * - Entries are added, removed, and checked for existence in constant time
873  * (O(1)).
874  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
875  *
876  * ```
877  * contract Example {
878  *     // Add the library methods
879  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
880  *
881  *     // Declare a set state variable
882  *     EnumerableMap.UintToAddressMap private myMap;
883  * }
884  * ```
885  *
886  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
887  * supported.
888  */
889 library EnumerableMap {
890     // To implement this library for multiple types with as little code
891     // repetition as possible, we write it in terms of a generic Map type with
892     // bytes32 keys and values.
893     // The Map implementation uses private functions, and user-facing
894     // implementations (such as Uint256ToAddressMap) are just wrappers around
895     // the underlying Map.
896     // This means that we can only create new EnumerableMaps for types that fit
897     // in bytes32.
898 
899     struct MapEntry {
900         bytes32 _key;
901         bytes32 _value;
902     }
903 
904     struct Map {
905         // Storage of map keys and values
906         MapEntry[] _entries;
907 
908         // Position of the entry defined by a key in the `entries` array, plus 1
909         // because index 0 means a key is not in the map.
910         mapping (bytes32 => uint256) _indexes;
911     }
912 
913     /**
914      * @dev Adds a key-value pair to a map, or updates the value for an existing
915      * key. O(1).
916      *
917      * Returns true if the key was added to the map, that is if it was not
918      * already present.
919      */
920     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
921         // We read and store the key's index to prevent multiple reads from the same storage slot
922         uint256 keyIndex = map._indexes[key];
923 
924         if (keyIndex == 0) { // Equivalent to !contains(map, key)
925             map._entries.push(MapEntry({ _key: key, _value: value }));
926             // The entry is stored at length-1, but we add 1 to all indexes
927             // and use 0 as a sentinel value
928             map._indexes[key] = map._entries.length;
929             return true;
930         } else {
931             map._entries[keyIndex - 1]._value = value;
932             return false;
933         }
934     }
935 
936     /**
937      * @dev Removes a key-value pair from a map. O(1).
938      *
939      * Returns true if the key was removed from the map, that is if it was present.
940      */
941     function _remove(Map storage map, bytes32 key) private returns (bool) {
942         // We read and store the key's index to prevent multiple reads from the same storage slot
943         uint256 keyIndex = map._indexes[key];
944 
945         if (keyIndex != 0) { // Equivalent to contains(map, key)
946             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
947             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
948             // This modifies the order of the array, as noted in {at}.
949 
950             uint256 toDeleteIndex = keyIndex - 1;
951             uint256 lastIndex = map._entries.length - 1;
952 
953             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
954             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
955 
956             MapEntry storage lastEntry = map._entries[lastIndex];
957 
958             // Move the last entry to the index where the entry to delete is
959             map._entries[toDeleteIndex] = lastEntry;
960             // Update the index for the moved entry
961             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
962 
963             // Delete the slot where the moved entry was stored
964             map._entries.pop();
965 
966             // Delete the index for the deleted slot
967             delete map._indexes[key];
968 
969             return true;
970         } else {
971             return false;
972         }
973     }
974 
975     /**
976      * @dev Returns true if the key is in the map. O(1).
977      */
978     function _contains(Map storage map, bytes32 key) private view returns (bool) {
979         return map._indexes[key] != 0;
980     }
981 
982     /**
983      * @dev Returns the number of key-value pairs in the map. O(1).
984      */
985     function _length(Map storage map) private view returns (uint256) {
986         return map._entries.length;
987     }
988 
989    /**
990     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
991     *
992     * Note that there are no guarantees on the ordering of entries inside the
993     * array, and it may change when more entries are added or removed.
994     *
995     * Requirements:
996     *
997     * - `index` must be strictly less than {length}.
998     */
999     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1000         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1001 
1002         MapEntry storage entry = map._entries[index];
1003         return (entry._key, entry._value);
1004     }
1005 
1006     /**
1007      * @dev Returns the value associated with `key`.  O(1).
1008      *
1009      * Requirements:
1010      *
1011      * - `key` must be in the map.
1012      */
1013     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1014         return _get(map, key, "EnumerableMap: nonexistent key");
1015     }
1016 
1017     /**
1018      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1019      */
1020     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1021         uint256 keyIndex = map._indexes[key];
1022         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1023         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1024     }
1025 
1026     // UintToAddressMap
1027 
1028     struct UintToAddressMap {
1029         Map _inner;
1030     }
1031 
1032     /**
1033      * @dev Adds a key-value pair to a map, or updates the value for an existing
1034      * key. O(1).
1035      *
1036      * Returns true if the key was added to the map, that is if it was not
1037      * already present.
1038      */
1039     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1040         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1041     }
1042 
1043     /**
1044      * @dev Removes a value from a set. O(1).
1045      *
1046      * Returns true if the key was removed from the map, that is if it was present.
1047      */
1048     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1049         return _remove(map._inner, bytes32(key));
1050     }
1051 
1052     /**
1053      * @dev Returns true if the key is in the map. O(1).
1054      */
1055     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1056         return _contains(map._inner, bytes32(key));
1057     }
1058 
1059     /**
1060      * @dev Returns the number of elements in the map. O(1).
1061      */
1062     function length(UintToAddressMap storage map) internal view returns (uint256) {
1063         return _length(map._inner);
1064     }
1065 
1066    /**
1067     * @dev Returns the element stored at position `index` in the set. O(1).
1068     * Note that there are no guarantees on the ordering of values inside the
1069     * array, and it may change when more values are added or removed.
1070     *
1071     * Requirements:
1072     *
1073     * - `index` must be strictly less than {length}.
1074     */
1075     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1076         (bytes32 key, bytes32 value) = _at(map._inner, index);
1077         return (uint256(key), address(uint256(value)));
1078     }
1079 
1080     /**
1081      * @dev Returns the value associated with `key`.  O(1).
1082      *
1083      * Requirements:
1084      *
1085      * - `key` must be in the map.
1086      */
1087     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1088         return address(uint256(_get(map._inner, bytes32(key))));
1089     }
1090 
1091     /**
1092      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1093      */
1094     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1095         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1096     }
1097 }
1098 
1099 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
1100 
1101 pragma solidity ^0.7.0;
1102 
1103 /**
1104  * @dev String operations.
1105  */
1106 library Strings {
1107     /**
1108      * @dev Converts a `uint256` to its ASCII `string` representation.
1109      */
1110     function toString(uint256 value) internal pure returns (string memory) {
1111         // Inspired by OraclizeAPI's implementation - MIT licence
1112         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1113 
1114         if (value == 0) {
1115             return "0";
1116         }
1117         uint256 temp = value;
1118         uint256 digits;
1119         while (temp != 0) {
1120             digits++;
1121             temp /= 10;
1122         }
1123         bytes memory buffer = new bytes(digits);
1124         uint256 index = digits - 1;
1125         temp = value;
1126         while (temp != 0) {
1127             buffer[index--] = byte(uint8(48 + temp % 10));
1128             temp /= 10;
1129         }
1130         return string(buffer);
1131     }
1132 }
1133 
1134 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
1135 
1136 pragma solidity ^0.7.0;
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 /**
1150  * @title ERC721 Non-Fungible Token Standard basic implementation
1151  * @dev see https://eips.ethereum.org/EIPS/eip-721
1152  */
1153 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1154     using SafeMath for uint256;
1155     using Address for address;
1156     using EnumerableSet for EnumerableSet.UintSet;
1157     using EnumerableMap for EnumerableMap.UintToAddressMap;
1158     using Strings for uint256;
1159 
1160     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1161     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1162     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1163 
1164     // Mapping from holder address to their (enumerable) set of owned tokens
1165     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1166 
1167     // Enumerable mapping from token ids to their owners
1168     EnumerableMap.UintToAddressMap private _tokenOwners;
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
1183     mapping (uint256 => string) private _tokenURIs;
1184 
1185     // Base URI
1186     string private _baseURI;
1187 
1188     /*
1189      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1190      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1191      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1192      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1193      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1194      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1195      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1196      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1197      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1198      *
1199      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1200      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1201      */
1202     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1203 
1204     /*
1205      *     bytes4(keccak256('name()')) == 0x06fdde03
1206      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1207      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1208      *
1209      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1210      */
1211     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1212 
1213     /*
1214      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1215      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1216      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1217      *
1218      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1219      */
1220     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1221 
1222     /**
1223      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1224      */
1225     constructor (string memory name_, string memory symbol_) {
1226         _name = name_;
1227         _symbol = symbol_;
1228 
1229         // register the supported interfaces to conform to ERC721 via ERC165
1230         _registerInterface(_INTERFACE_ID_ERC721);
1231         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1232         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-balanceOf}.
1237      */
1238     function balanceOf(address owner) public view override returns (uint256) {
1239         require(owner != address(0), "ERC721: balance query for the zero address");
1240 
1241         return _holderTokens[owner].length();
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-ownerOf}.
1246      */
1247     function ownerOf(uint256 tokenId) public view override returns (address) {
1248         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Metadata-name}.
1253      */
1254     function name() public view override returns (string memory) {
1255         return _name;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-symbol}.
1260      */
1261     function symbol() public view override returns (string memory) {
1262         return _symbol;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-tokenURI}.
1267      */
1268     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1269         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1270 
1271         string memory _tokenURI = _tokenURIs[tokenId];
1272 
1273         // If there is no base URI, return the token URI.
1274         if (bytes(_baseURI).length == 0) {
1275             return _tokenURI;
1276         }
1277         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1278         if (bytes(_tokenURI).length > 0) {
1279             return string(abi.encodePacked(_baseURI, _tokenURI));
1280         }
1281         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1282         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1283     }
1284 
1285     /**
1286     * @dev Returns the base URI set via {_setBaseURI}. This will be
1287     * automatically added as a prefix in {tokenURI} to each token's URI, or
1288     * to the token ID if no specific URI is set for that token ID.
1289     */
1290     function baseURI() public view returns (string memory) {
1291         return _baseURI;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1296      */
1297     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1298         return _holderTokens[owner].at(index);
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Enumerable-totalSupply}.
1303      */
1304     function totalSupply() public view override returns (uint256) {
1305         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1306         return _tokenOwners.length();
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Enumerable-tokenByIndex}.
1311      */
1312     function tokenByIndex(uint256 index) public view override returns (uint256) {
1313         (uint256 tokenId, ) = _tokenOwners.at(index);
1314         return tokenId;
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-approve}.
1319      */
1320     function approve(address to, uint256 tokenId) public virtual override {
1321         address owner = ownerOf(tokenId);
1322         require(to != owner, "ERC721: approval to current owner");
1323 
1324         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1325             "ERC721: approve caller is not owner nor approved for all"
1326         );
1327 
1328         _approve(to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-getApproved}.
1333      */
1334     function getApproved(uint256 tokenId) public view override returns (address) {
1335         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1336 
1337         return _tokenApprovals[tokenId];
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-setApprovalForAll}.
1342      */
1343     function setApprovalForAll(address operator, bool approved) public virtual override {
1344         require(operator != _msgSender(), "ERC721: approve to caller");
1345 
1346         _operatorApprovals[_msgSender()][operator] = approved;
1347         emit ApprovalForAll(_msgSender(), operator, approved);
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-isApprovedForAll}.
1352      */
1353     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1354         return _operatorApprovals[owner][operator];
1355     }
1356 
1357     /**
1358      * @dev See {IERC721-transferFrom}.
1359      */
1360     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1361         //solhint-disable-next-line max-line-length
1362         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1363 
1364         _transfer(from, to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-safeTransferFrom}.
1369      */
1370     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1371         safeTransferFrom(from, to, tokenId, "");
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-safeTransferFrom}.
1376      */
1377     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1378         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1379         _safeTransfer(from, to, tokenId, _data);
1380     }
1381 
1382     /**
1383      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1384      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1385      *
1386      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1387      *
1388      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1389      * implement alternative mechanisms to perform token transfer, such as signature-based.
1390      *
1391      * Requirements:
1392      *
1393      * - `from` cannot be the zero address.
1394      * - `to` cannot be the zero address.
1395      * - `tokenId` token must exist and be owned by `from`.
1396      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1397      *
1398      * Emits a {Transfer} event.
1399      */
1400     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1401         _transfer(from, to, tokenId);
1402         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1403     }
1404 
1405     /**
1406      * @dev Returns whether `tokenId` exists.
1407      *
1408      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1409      *
1410      * Tokens start existing when they are minted (`_mint`),
1411      * and stop existing when they are burned (`_burn`).
1412      */
1413     function _exists(uint256 tokenId) internal view returns (bool) {
1414         return _tokenOwners.contains(tokenId);
1415     }
1416 
1417     /**
1418      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1419      *
1420      * Requirements:
1421      *
1422      * - `tokenId` must exist.
1423      */
1424     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1425         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1426         address owner = ownerOf(tokenId);
1427         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1428     }
1429 
1430     /**
1431      * @dev Safely mints `tokenId` and transfers it to `to`.
1432      *
1433      * Requirements:
1434      d*
1435      * - `tokenId` must not exist.
1436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function _safeMint(address to, uint256 tokenId) internal virtual {
1441         _safeMint(to, tokenId, "");
1442     }
1443 
1444     /**
1445      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1446      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1447      */
1448     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1449         _mint(to, tokenId);
1450         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1451     }
1452 
1453     /**
1454      * @dev Mints `tokenId` and transfers it to `to`.
1455      *
1456      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1457      *
1458      * Requirements:
1459      *
1460      * - `tokenId` must not exist.
1461      * - `to` cannot be the zero address.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _mint(address to, uint256 tokenId) internal virtual {
1466         require(to != address(0), "ERC721: mint to the zero address");
1467         require(!_exists(tokenId), "ERC721: token already minted");
1468 
1469         _beforeTokenTransfer(address(0), to, tokenId);
1470 
1471         _holderTokens[to].add(tokenId);
1472 
1473         _tokenOwners.set(tokenId, to);
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
1505         emit Transfer(owner, address(0), tokenId);
1506     }
1507 
1508     /**
1509      * @dev Transfers `tokenId` from `from` to `to`.
1510      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1511      *
1512      * Requirements:
1513      *
1514      * - `to` cannot be the zero address.
1515      * - `tokenId` token must be owned by `from`.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1520         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1521         require(to != address(0), "ERC721: transfer to the zero address");
1522 
1523         _beforeTokenTransfer(from, to, tokenId);
1524 
1525         // Clear approvals from the previous owner
1526         _approve(address(0), tokenId);
1527 
1528         _holderTokens[from].remove(tokenId);
1529         _holderTokens[to].add(tokenId);
1530 
1531         _tokenOwners.set(tokenId, to);
1532 
1533         emit Transfer(from, to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1538      *
1539      * Requirements:
1540      *
1541      * - `tokenId` must exist.
1542      */
1543     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1544         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1545         _tokenURIs[tokenId] = _tokenURI;
1546     }
1547 
1548     /**
1549      * @dev Internal function to set the base URI for all token IDs. It is
1550      * automatically added as a prefix to the value returned in {tokenURI},
1551      * or to the token ID if {tokenURI} is empty.
1552      */
1553     function _setBaseURI(string memory baseURI_) internal virtual {
1554         _baseURI = baseURI_;
1555     }
1556 
1557     /**
1558      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1559      * The call is not executed if the target address is not a contract.
1560      *
1561      * @param from address representing the previous owner of the given token ID
1562      * @param to target address that will receive the tokens
1563      * @param tokenId uint256 ID of the token to be transferred
1564      * @param _data bytes optional data to send along with the call
1565      * @return bool whether the call correctly returned the expected magic value
1566      */
1567     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1568         private returns (bool)
1569     {
1570         if (!to.isContract()) {
1571             return true;
1572         }
1573         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1574             IERC721Receiver(to).onERC721Received.selector,
1575             _msgSender(),
1576             from,
1577             tokenId,
1578             _data
1579         ), "ERC721: transfer to non ERC721Receiver implementer");
1580         bytes4 retval = abi.decode(returndata, (bytes4));
1581         return (retval == _ERC721_RECEIVED);
1582     }
1583 
1584     function _approve(address to, uint256 tokenId) private {
1585         _tokenApprovals[tokenId] = to;
1586         emit Approval(ownerOf(tokenId), to, tokenId);
1587     }
1588 
1589     /**
1590      * @dev Hook that is called before any token transfer. This includes minting
1591      * and burning.
1592      *
1593      * Calling conditions:
1594      *
1595      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1596      * transferred to `to`.
1597      * - When `from` is zero, `tokenId` will be minted for `to`.
1598      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1599      * - `from` cannot be the zero address.
1600      * - `to` cannot be the zero address.
1601      *
1602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1603      */
1604     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1605 }
1606 
1607 // File: contracts\GFarmNFT.sol
1608 
1609 pragma solidity 0.7.5;
1610 
1611 
1612 contract GFarmNFT is ERC721{
1613 
1614 	// Current supply for each leverage
1615 	uint16[8] supply = [0, 0, 0, 0, 0, 0, 0, 0];
1616 	// Get the corresponding leverage for each NFT minted
1617 	mapping(uint => uint16) idToLeverage;
1618 	// Only the GFARM smart contract can mint new NFTs
1619 	address immutable public owner;
1620 
1621 	constructor() ERC721("GFarmNFT", "GFARMNFT"){
1622 		owner = msg.sender;
1623 	}
1624 
1625 	// Verify leverage value (75,100,125,150,175,200,225,250)
1626 	modifier correctLeverage(uint16 _leverage){
1627 		require(_leverage >= 75 && _leverage <= 250 && _leverage % 25 == 0, "Wrong leverage value");
1628 		_;
1629 	}
1630 	// Get ID from leverage (for arrays)
1631 	function leverageID(uint16 _leverage) public pure correctLeverage(_leverage) returns(uint16){
1632 		return (_leverage-50)/25-1;
1633 	}
1634 	// Required credits for each leverage (constant)
1635 	function requiredCreditsArray() public pure returns(uint24[8] memory){
1636 		// (blocks) => 2, 5, 7, 10, 12, 15, 17, 30 (days)
1637 		return [12800, 32000, 44800, 64000, 76800, 96000, 108800, 192000];
1638 	}
1639 	// Max supply for each leverage (constant)
1640 	function maxSupplyArray() public pure returns(uint16[8] memory){
1641 		return [1000, 500, 400, 300, 200, 150, 100, 50];
1642 	}
1643 	// Get required credits from leverage based on the constant array
1644 	function requiredCredits(uint16 _leverage) public pure returns(uint24){
1645 		return requiredCreditsArray()[leverageID(_leverage)];
1646 	}
1647 	// Get max supply from leverage based on the constant array
1648 	function maxSupply(uint16 _leverage) public pure returns(uint16){
1649 		return maxSupplyArray()[leverageID(_leverage)];
1650 	}
1651 	// Get current supply from leverage
1652 	function currentSupply(uint16 _leverage) public view returns(uint16){
1653 		return supply[leverageID(_leverage)];
1654 	}
1655 
1656 	// Mint a leverage NFT to a user (increases supply)
1657 	function mint(uint16 _leverage, uint _userCredits, address _userAddress) external{
1658 		require(msg.sender == owner, "Caller must be the GFarm smart contract.");
1659 		require(_userCredits >= requiredCredits(_leverage), "Not enough NFT credits");
1660 		require(currentSupply(_leverage) < maxSupply(_leverage), "Max supply reached for this leverage");
1661 
1662 		uint nftID = totalSupply();
1663 		_mint(_userAddress, nftID);
1664 
1665 		idToLeverage[nftID] = _leverage;
1666 		supply[leverageID(_leverage)] += 1;
1667 	}
1668 
1669 	// Useful external functions
1670 	function getLeverageFromID(uint id) external view returns(uint16){
1671 		return idToLeverage[id];
1672 	}
1673 	function currentSupplyArray() external view returns(uint16[8] memory){
1674 		return supply;
1675 	}
1676 }
1677 
1678 // File: contracts\GFarmTokenInterface.sol
1679 
1680 pragma solidity 0.7.5;
1681 
1682 interface GFarmTokenInterface{
1683 	function balanceOf(address account) external view returns (uint256);
1684     function transferFrom(address from, address to, uint256 value) external returns (bool);
1685     function transfer(address to, uint256 value) external returns (bool);
1686     function approve(address spender, uint256 value) external returns (bool);
1687     function allowance(address owner, address spender) external view returns (uint256);
1688     function burn(address from, uint256 amount) external;
1689     function mint(address to, uint256 amount) external;
1690 }
1691 
1692 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Pair.sol
1693 
1694 pragma solidity >=0.5.0;
1695 
1696 interface IUniswapV2Pair {
1697     event Approval(address indexed owner, address indexed spender, uint value);
1698     event Transfer(address indexed from, address indexed to, uint value);
1699 
1700     function name() external pure returns (string memory);
1701     function symbol() external pure returns (string memory);
1702     function decimals() external pure returns (uint8);
1703     function totalSupply() external view returns (uint);
1704     function balanceOf(address owner) external view returns (uint);
1705     function allowance(address owner, address spender) external view returns (uint);
1706 
1707     function approve(address spender, uint value) external returns (bool);
1708     function transfer(address to, uint value) external returns (bool);
1709     function transferFrom(address from, address to, uint value) external returns (bool);
1710 
1711     function DOMAIN_SEPARATOR() external view returns (bytes32);
1712     function PERMIT_TYPEHASH() external pure returns (bytes32);
1713     function nonces(address owner) external view returns (uint);
1714 
1715     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1716 
1717     event Mint(address indexed sender, uint amount0, uint amount1);
1718     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1719     event Swap(
1720         address indexed sender,
1721         uint amount0In,
1722         uint amount1In,
1723         uint amount0Out,
1724         uint amount1Out,
1725         address indexed to
1726     );
1727     event Sync(uint112 reserve0, uint112 reserve1);
1728 
1729     function MINIMUM_LIQUIDITY() external pure returns (uint);
1730     function factory() external view returns (address);
1731     function token0() external view returns (address);
1732     function token1() external view returns (address);
1733     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1734     function price0CumulativeLast() external view returns (uint);
1735     function price1CumulativeLast() external view returns (uint);
1736     function kLast() external view returns (uint);
1737 
1738     function mint(address to) external returns (uint liquidity);
1739     function burn(address to) external returns (uint amount0, uint amount1);
1740     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1741     function skim(address to) external;
1742     function sync() external;
1743 
1744     function initialize(address, address) external;
1745 }
1746 
1747 // File: contracts\GFarm.sol
1748 
1749 pragma solidity 0.7.5;
1750 
1751 
1752 
1753 
1754 
1755 contract GFarm {
1756 
1757 	using SafeMath for uint;
1758 
1759 	// Tokens
1760 	GFarmTokenInterface public immutable token;
1761 	GFarmNFT public immutable nft;
1762 	IUniswapV2Pair public immutable lp;
1763 
1764     // POOL 1
1765 
1766 	// Constants
1767 	uint constant POOL1_MULTIPLIER_1 = 10;
1768 	uint constant POOL1_MULTIPLIER_2 = 5;
1769 	uint constant POOL1_MULTIPLIER_1_DURATION = 100000; // 2 weeks
1770 	uint constant POOL1_MULTIPLIER_2_DURATION = 200000; // 4 weeks
1771 	uint immutable POOL1_MULTIPLIER_1_END;
1772 	uint immutable POOL1_MULTIPLIER_2_END;
1773 	uint constant POOL1_REFERRAL_P = 5;
1774 	uint constant POOL1_CREDITS_MIN_P = 1;
1775 
1776 	// Storage variables
1777 	uint public POOL1_lastRewardBlock;
1778 	uint public POOL1_accTokensPerLP; // divide by 1e18 for real value
1779 
1780 	// POOL 2
1781 
1782     // Constants
1783 	uint public constant POOL2_DURATION = 100000; // 2 weeks
1784 	uint public immutable POOL2_END;
1785 
1786 	// Storage variables
1787 	uint public POOL2_lastRewardBlock;
1788 	uint public POOL2_accTokensPerETH; // divide by 1e18 for real value
1789 
1790 	// POOL 1 & POOL 2: Constants
1791 	uint public immutable POOLS_START;
1792 	uint public constant POOLS_TOKENS_PER_BLOCK = 1; // 1 token per block
1793 	uint public constant POOLS_START_DELAY = 51000; // 8 days => 27th of december
1794 
1795 	// Useful Uniswap addresses (for TVL & APY)
1796 	address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1797 	IUniswapV2Pair constant ETH_USDC_PAIR = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
1798 
1799     // Dev fund
1800     address immutable DEV_FUND;
1801     uint constant DEV_FUND_PERCENTAGE = 10;
1802 
1803 	// Info about each user
1804 	struct User {
1805         uint POOL1_provided;
1806         uint POOL1_rewardDebt;
1807         address POOL1_referral;
1808         uint POOL1_referralReward;
1809 
1810         uint POOL2_provided;
1811         uint POOL2_rewardDebt;
1812 
1813         uint NFT_CREDITS_amount;
1814         uint NFT_CREDITS_lastUpdated;
1815         bool NFT_CREDITS_receiving;
1816     }
1817     mapping(address => User) public users;
1818 
1819     //uint public fakeBlockNumber; // REPLACE EVERYWHERE BY BLOCK.NUMBER
1820 
1821 	constructor(
1822 		GFarmTokenInterface _token,
1823         IUniswapV2Pair _lp){
1824 
1825 		token = _token;
1826         lp = _lp;
1827 		DEV_FUND = msg.sender;
1828 
1829 		POOL1_MULTIPLIER_1_END = block.number.add(POOLS_START_DELAY).add(POOL1_MULTIPLIER_1_DURATION);
1830 		POOL1_MULTIPLIER_2_END = block.number.add(POOLS_START_DELAY).add(POOL1_MULTIPLIER_1_DURATION).add(POOL1_MULTIPLIER_2_DURATION);
1831 		POOL2_END = block.number.add(POOLS_START_DELAY).add(POOL2_DURATION);
1832 		POOLS_START = block.number.add(POOLS_START_DELAY);
1833 
1834 		nft = new GFarmNFT();
1835 
1836         //fakeBlockNumber = block.number;
1837 	}
1838 
1839     /*function increaseBlock(uint b) external { fakeBlockNumber += b; }
1840     function decreaseBlock(uint b) external { fakeBlockNumber -= b; }*/
1841 
1842     // Get token reward between two blocks
1843     function POOL1_getReward(uint _from, uint _to) private view returns (uint){
1844     	uint blocksWithMultiplier;
1845 
1846         if(_from >= POOLS_START && _to >= POOLS_START){
1847         	// Multiplier 1
1848         	if(_from <= POOL1_MULTIPLIER_1_END && _to <= POOL1_MULTIPLIER_1_END){
1849         		blocksWithMultiplier = _to.sub(_from).mul(POOL1_MULTIPLIER_1);
1850         	// Between multiplier 1 and multiplier 2
1851         	} else if(_from <= POOL1_MULTIPLIER_1_END && _to > POOL1_MULTIPLIER_1_END && _to <= POOL1_MULTIPLIER_2_END){
1852         		blocksWithMultiplier = POOL1_MULTIPLIER_1_END.sub(_from).mul(POOL1_MULTIPLIER_1).add(
1853         			_to.sub(POOL1_MULTIPLIER_1_END).mul(POOL1_MULTIPLIER_2)
1854         		);
1855         	// Between multiplier 1 and no multiplier (pretty unlikely)
1856         	} else if(_from <= POOL1_MULTIPLIER_1_END && _to > POOL1_MULTIPLIER_2_END){
1857         		blocksWithMultiplier = POOL1_MULTIPLIER_1_END.sub(_from).mul(POOL1_MULTIPLIER_1).add(
1858         			POOL1_MULTIPLIER_2_END.sub(POOL1_MULTIPLIER_1_END).mul(POOL1_MULTIPLIER_2).add(
1859         				_to.sub(POOL1_MULTIPLIER_2_END)
1860         			)
1861         		);
1862         	// Multplier 2
1863         	}else if(_from > POOL1_MULTIPLIER_1_END && _from <= POOL1_MULTIPLIER_2_END && _to <= POOL1_MULTIPLIER_2_END){
1864         		blocksWithMultiplier = _to.sub(_from).mul(POOL1_MULTIPLIER_2);
1865         	// Between multiplier 2 and no multiplier
1866         	} else if(_from > POOL1_MULTIPLIER_1_END && _from <= POOL1_MULTIPLIER_2_END && _to > POOL1_MULTIPLIER_2_END){
1867         		blocksWithMultiplier = POOL1_MULTIPLIER_2_END.sub(_from).mul(POOL1_MULTIPLIER_2).add(
1868         			_to.sub(POOL1_MULTIPLIER_2_END)
1869         		);
1870         	// No multiplier
1871         	}else{
1872         		blocksWithMultiplier = _to.sub(_from);
1873         	}
1874         }
1875 
1876     	return blocksWithMultiplier.mul(POOLS_TOKENS_PER_BLOCK).mul(1e18);
1877     }
1878     function POOL2_getReward(uint _from, uint _to) private view returns (uint){
1879     	uint blocksWithMultiplier;
1880 
1881         if(_from >= POOLS_START && _to >= POOLS_START){
1882         	// Before pool 2 has ended
1883         	if(_from <= POOL2_END && _to <= POOL2_END){
1884         		blocksWithMultiplier = _to.sub(_from);
1885         	// Between before and after pool 2 has ended
1886         	}else if(_from <= POOL2_END && _to > POOL2_END){
1887         		blocksWithMultiplier = POOL2_END.sub(_from);
1888         	// After pool 2 has ended
1889         	}else if(_from > POOL2_END && _to > POOL2_END){
1890         		blocksWithMultiplier = 0;
1891         	}
1892         }
1893 
1894     	return blocksWithMultiplier.mul(POOLS_TOKENS_PER_BLOCK).mul(1e18);
1895     }
1896 
1897     // Updates the pool storage variables
1898 	function POOL1_update() private {
1899 		uint lpSupply = lp.balanceOf(address(this));
1900 
1901         if (POOL1_lastRewardBlock == 0 || lpSupply == 0) {
1902             POOL1_lastRewardBlock = block.number;
1903             return;
1904         }
1905 
1906 		uint reward = POOL1_getReward(POOL1_lastRewardBlock, block.number);
1907         
1908     	token.mint(address(this), reward);
1909     	token.mint(DEV_FUND, reward.mul(DEV_FUND_PERCENTAGE).div(100));
1910 
1911     	POOL1_accTokensPerLP = POOL1_accTokensPerLP.add(reward.mul(1e18).div(lpSupply));
1912         POOL1_lastRewardBlock = block.number;
1913 	}	
1914 	function POOL2_update(uint ethJustStaked) private {
1915 		// Here we retrieve the balance before the last transfer,
1916 		// Because solidity updates the balance before the rest of the code is executed
1917 		// (Unlike the first pool, where we transfer the lp tokens to the farm after POOL1_update is called)
1918 		uint ethSupply = address(this).balance.sub(ethJustStaked);
1919 
1920 		if (POOL2_lastRewardBlock == 0 || ethSupply == 0) {
1921             POOL2_lastRewardBlock = block.number;
1922             return;
1923         }
1924 
1925 		uint reward = POOL2_getReward(POOL2_lastRewardBlock, block.number);
1926         
1927     	token.mint(address(this), reward);
1928     	token.mint(DEV_FUND, reward.mul(DEV_FUND_PERCENTAGE).div(100));
1929 
1930     	POOL2_accTokensPerETH = POOL2_accTokensPerETH.add(reward.mul(1e18).div(ethSupply));
1931         POOL2_lastRewardBlock = block.number;
1932 	}
1933 
1934 	// Pending reward
1935 	function POOL1_pendingReward() external view returns(uint){
1936 		return _POOL1_pendingReward(users[msg.sender]);
1937 	}
1938 	function POOL2_pendingReward() external view returns(uint){
1939 		return _POOL2_pendingReward(users[msg.sender], 0);
1940 	}
1941 	function _POOL1_pendingReward(User memory u) private view returns(uint){
1942 		uint _POOL1_accTokensPerLP = POOL1_accTokensPerLP;
1943 		uint lpSupply = lp.balanceOf(address(this));
1944 
1945 		if (block.number > POOL1_lastRewardBlock && lpSupply != 0) {
1946 			uint pendingReward = POOL1_getReward(POOL1_lastRewardBlock, block.number);
1947             _POOL1_accTokensPerLP = _POOL1_accTokensPerLP.add(pendingReward.mul(1e18).div(lpSupply));
1948         }
1949 
1950 		return u.POOL1_provided.mul(_POOL1_accTokensPerLP).div(1e18).sub(u.POOL1_rewardDebt);
1951 	}
1952 	function _POOL2_pendingReward(User memory u, uint ethJustStaked) private view returns(uint){
1953 		uint _POOL2_accTokensPerETH = POOL2_accTokensPerETH;
1954         // Here we retrieve the balance before the last transfer,
1955         // Because solidity updates the balance before the rest of the code is executed
1956         // (Unlike the first pool, where we transfer the lp tokens to the farm after POOL1_update is called)
1957 		uint ethSupply = address(this).balance.sub(ethJustStaked);
1958 
1959 		if (block.number > POOL2_lastRewardBlock && ethSupply != 0) {
1960             uint pendingReward = POOL2_getReward(POOL2_lastRewardBlock, block.number);
1961             _POOL2_accTokensPerETH = _POOL2_accTokensPerETH.add(pendingReward.mul(1e18).div(ethSupply));
1962         }
1963 
1964 		return u.POOL2_provided.mul(_POOL2_accTokensPerETH).div(1e18).sub(u.POOL2_rewardDebt);
1965 	}
1966 
1967 	// Claim reward (harvest)
1968 	function POOL1_harvest() external{
1969 		_POOL1_harvest(msg.sender);
1970 	}
1971 	function POOL2_harvest() external{
1972 		_POOL2_harvest(msg.sender, 0);
1973 	}
1974 	function _POOL1_harvest(address a) private{
1975 		User storage u = users[a];
1976 		uint pending = _POOL1_pendingReward(u);
1977 		POOL1_update();
1978 
1979 		if(pending > 0){
1980 			if(u.POOL1_referral == address(0)){
1981 				POOLS_safeTokenTransfer(a, pending);
1982 				token.burn(a, pending.mul(POOL1_REFERRAL_P).div(100));
1983 			}else{
1984 				uint referralReward = pending.mul(POOL1_REFERRAL_P).div(100);
1985 				uint userReward = pending.sub(referralReward);
1986 
1987 				POOLS_safeTokenTransfer(a, userReward);
1988 				POOLS_safeTokenTransfer(u.POOL1_referral, referralReward);
1989 
1990 				User storage referralUser = users[u.POOL1_referral];
1991 				referralUser.POOL1_referralReward = referralUser.POOL1_referralReward.add(referralReward);
1992 			}
1993 		}
1994 
1995 		u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
1996 	}
1997 	function _POOL2_harvest(address a, uint ethJustStaked) private{
1998 		User storage u = users[a];
1999 		uint pending = _POOL2_pendingReward(u, ethJustStaked);
2000 		POOL2_update(ethJustStaked);
2001 
2002 		if(pending > 0){
2003 			POOLS_safeTokenTransfer(a, pending);
2004 		}
2005 
2006 		u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
2007 	}
2008 
2009 	// Stake
2010 	function POOL1_stake(uint amount, address referral) external{
2011 		require(block.number >= POOLS_START, "Pool hasn't started yet.");
2012 		require(amount > 0, "Staking 0 lp.");
2013 
2014         uint lpSupplyBefore = lp.balanceOf(address(this));
2015 
2016 		_POOL1_harvest(msg.sender);
2017 		lp.transferFrom(msg.sender, address(this), amount);
2018 
2019 		User storage u = users[msg.sender];
2020 		u.POOL1_provided = u.POOL1_provided.add(amount);
2021 		u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
2022 
2023 		if(!u.NFT_CREDITS_receiving && u.POOL1_provided >= lpSupplyBefore.mul(POOL1_CREDITS_MIN_P).div(100)){
2024 			u.NFT_CREDITS_receiving = true;
2025 			u.NFT_CREDITS_lastUpdated = block.number;
2026 		}
2027 
2028 		if(u.POOL1_referral == address(0) && referral != address(0) && referral != msg.sender){
2029 			u.POOL1_referral = referral;
2030 		}
2031 	}
2032 	function POOL2_stake() payable external{
2033 		require(block.number >= POOLS_START, "Pool hasn't started yet.");
2034 		require(block.number <= POOL2_END, "Pool is finished, no more staking.");
2035 		require(msg.value > 0, "Staking 0 ETH.");
2036 
2037 		_POOL2_harvest(msg.sender, msg.value);
2038 
2039 		User storage u = users[msg.sender];
2040 		u.POOL2_provided = u.POOL2_provided.add(msg.value);
2041 		u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
2042 	}
2043 
2044 	// Unstake
2045 	function POOL1_unstake(uint amount) external{
2046 		User storage u = users[msg.sender];
2047 		require(amount > 0, "Unstaking 0 lp.");
2048 		require(u.POOL1_provided >= amount, "Unstaking more than currently staked.");
2049 
2050 		_POOL1_harvest(msg.sender);
2051 		lp.transfer(msg.sender, amount);
2052 
2053 		u.POOL1_provided = u.POOL1_provided.sub(amount);
2054 		u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
2055 
2056 		uint lpSupply = lp.balanceOf(address(this));
2057 
2058 		if(u.NFT_CREDITS_receiving && u.POOL1_provided < lpSupply.mul(POOL1_CREDITS_MIN_P).div(100) || u.NFT_CREDITS_receiving && lpSupply == 0){
2059 			u.NFT_CREDITS_amount = NFT_CREDITS_amount();
2060 			u.NFT_CREDITS_receiving = false;
2061 			u.NFT_CREDITS_lastUpdated = block.number;
2062 		}
2063 	}
2064 	function POOL2_unstake(uint amount) external{
2065 		User storage u = users[msg.sender];
2066 		require(amount > 0, "Unstaking 0 ETH.");
2067 		require(u.POOL2_provided >= amount, "Unstaking more than currently staked.");
2068 
2069 		_POOL2_harvest(msg.sender, 0);
2070 		msg.sender.transfer(amount);
2071 
2072 		u.POOL2_provided = u.POOL2_provided.sub(amount);
2073 		u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
2074 	}
2075 
2076 	// NFTs
2077 	function NFT_claim(uint16 _leverage) external{
2078 		User storage u = users[msg.sender];
2079 		nft.mint(_leverage, NFT_CREDITS_amount(), msg.sender);
2080 		uint requiredCredits = nft.requiredCredits(_leverage);
2081 		u.NFT_CREDITS_amount = NFT_CREDITS_amount().sub(requiredCredits);
2082 		u.NFT_CREDITS_lastUpdated = block.number;
2083 	}
2084 	function NFT_CREDITS_amount() public view returns(uint){
2085     	User memory u = users[msg.sender];
2086     	if(u.NFT_CREDITS_receiving){
2087     		return u.NFT_CREDITS_amount.add(block.number.sub(u.NFT_CREDITS_lastUpdated));
2088     	}else{
2089     		return u.NFT_CREDITS_amount;
2090     	}
2091     }
2092 
2093 	// Prevent rounding errors
2094 	function POOLS_safeTokenTransfer(address _to, uint _amount) private {
2095         uint bal = token.balanceOf(address(this));
2096         if (_amount > bal) {
2097             token.transfer(_to, bal);
2098         } else {
2099             token.transfer(_to, _amount);
2100         }
2101     }
2102 
2103     // USEFUL PRICING FUNCTIONS (FOR TVL & APY)
2104 
2105     // divide by 1e5 for real value
2106     function getEthPrice() private view returns(uint){
2107         (uint112 reserves0, uint112 reserves1, ) = ETH_USDC_PAIR.getReserves();
2108         uint reserveUSDC;
2109         uint reserveETH;
2110 
2111         if(WETH == ETH_USDC_PAIR.token0()){
2112             reserveETH = reserves0;
2113             reserveUSDC = reserves1;
2114         }else{
2115             reserveUSDC = reserves0;
2116             reserveETH = reserves1;
2117         }
2118         // Divide number of USDC by number of ETH
2119         // we multiply by 1e12 because USDC only has 6 decimals
2120         return reserveUSDC.mul(1e12).mul(1e5).div(reserveETH);
2121     }
2122     // divide by 1e5 for real value
2123     function getGFarmPriceEth() private view returns(uint){
2124         (uint112 reserves0, uint112 reserves1, ) = lp.getReserves();
2125 
2126         uint reserveETH;
2127         uint reserveGFARM;
2128 
2129         if(WETH == lp.token0()){
2130             reserveETH = reserves0;
2131             reserveGFARM = reserves1;
2132         }else{
2133             reserveGFARM = reserves0;
2134             reserveETH = reserves1;
2135         }
2136 
2137         return reserveETH.mul(1e5).div(reserveGFARM);
2138     }
2139 
2140     // UI VIEW FUNCTIONS (READ-ONLY)
2141     
2142     function POOLS_blocksLeftUntilStart() external view returns(uint){
2143     	if(block.number > POOLS_START){ return 0; }
2144     	return POOLS_START.sub(block.number);
2145     }
2146 	function POOL1_getMultiplier() public view returns (uint) {
2147 		if(block.number < POOLS_START){
2148 			return 0;
2149 		}
2150         if(block.number <= POOL1_MULTIPLIER_1_END){
2151         	return POOL1_MULTIPLIER_1;
2152         }else if(block.number <= POOL1_MULTIPLIER_2_END){
2153         	return POOL1_MULTIPLIER_2;
2154         }
2155         return 1;
2156     }
2157 	function POOL2_getMultiplier() public view returns (uint) {
2158 		if(block.number < POOLS_START || block.number > POOL2_END){
2159 			return 0;
2160 		}
2161         return 1;
2162     }
2163     function POOL1_rewardPerBlock() external view returns(uint){
2164     	return POOL1_getMultiplier().mul(POOLS_TOKENS_PER_BLOCK).mul(1e18);
2165     }
2166     function POOL2_rewardPerBlock() external view returns(uint){
2167     	return POOL2_getMultiplier().mul(POOLS_TOKENS_PER_BLOCK).mul(1e18);
2168     }
2169     function POOL1_provided() external view returns(uint){
2170     	return users[msg.sender].POOL1_provided;
2171     }
2172     function POOL2_provided() external view returns(uint){
2173     	return users[msg.sender].POOL2_provided;
2174     }
2175     function POOL1_referralReward() external view returns(uint){
2176     	return users[msg.sender].POOL1_referralReward;
2177     }
2178     function POOL2_blocksLeft() external view returns(uint){
2179     	if(block.number > POOL2_END){
2180     		return 0;
2181     	}
2182     	return POOL2_END.sub(block.number);
2183     }
2184     function POOL1_referral() external view returns(address){
2185         return users[msg.sender].POOL1_referral;
2186     }
2187     function POOL1_minLpsNftCredits() external view returns(uint){
2188     	return lp.balanceOf(address(this)).mul(POOL1_CREDITS_MIN_P).div(100);
2189     }
2190     // divide by 1e5 for real value
2191     function POOL1_tvl() public view returns(uint){
2192     	if(lp.totalSupply() == 0){ return 0; }
2193 
2194     	(uint112 reserves0, uint112 reserves1, ) = lp.getReserves();
2195     	uint reserveEth;
2196 
2197     	if(WETH == lp.token0()){
2198     		reserveEth = reserves0;
2199     	}else{
2200 			reserveEth = reserves1;
2201     	}
2202 
2203     	uint lpPriceEth = reserveEth.mul(1e5).mul(2).div(lp.totalSupply());
2204     	uint lpPriceUsd = lpPriceEth.mul(getEthPrice()).div(1e5);
2205 
2206     	return lp.balanceOf(address(this)).mul(lpPriceUsd).div(1e18);
2207     }
2208     // divide by 1e5 for real value
2209     function POOL2_tvl() public view returns(uint){
2210     	return address(this).balance.mul(getEthPrice()).div(1e18);
2211     }
2212     // divide by 1e5 for real value
2213     function POOLS_tvl() external view returns(uint){
2214     	return POOL1_tvl().add(POOL2_tvl());
2215     }
2216     // divide by 1e5 for real value
2217     function POOL1_apy() external view returns(uint){
2218     	if(POOL1_tvl() == 0){ return 0; }
2219     	return POOLS_TOKENS_PER_BLOCK.mul(POOL1_getMultiplier()).mul(2336000).mul(getGFarmPriceEth()).mul(getEthPrice()).mul(100).div(POOL1_tvl());
2220     }
2221     // divide by 1e5 for real value
2222     function POOL2_apy() external view returns(uint){
2223     	if(POOL2_tvl() == 0){ return 0; }
2224     	return POOLS_TOKENS_PER_BLOCK.mul(POOL2_getMultiplier()).mul(2336000).mul(getGFarmPriceEth()).mul(getEthPrice()).mul(100).div(POOL2_tvl());
2225     }
2226     function NFT_owned() external view returns(uint[8] memory nfts){
2227     	for(uint i = 0; i < nft.balanceOf(msg.sender); i++){
2228             uint id = nft.leverageID(nft.getLeverageFromID(nft.tokenOfOwnerByIndex(msg.sender, i)));
2229             nfts[id] = nfts[id].add(1);
2230         }
2231     }
2232     function NFT_requiredCreditsArray() external view returns(uint24[8] memory){
2233     	return nft.requiredCreditsArray();
2234     }
2235 	function NFT_maxSupplyArray() external view returns(uint16[8] memory){
2236 		return nft.maxSupplyArray();
2237 	}
2238 	function NFT_currentSupplyArray() external view returns(uint16[8] memory){
2239 		return nft.currentSupplyArray();
2240 	}
2241 }