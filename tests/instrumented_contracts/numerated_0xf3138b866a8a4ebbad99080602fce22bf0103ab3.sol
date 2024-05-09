1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
30 pragma solidity >=0.6.0 <0.8.0;
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
53 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
54 
55 pragma solidity >=0.6.2 <0.8.0;
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
182 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
183 
184 pragma solidity >=0.6.2 <0.8.0;
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
209 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
210 
211 pragma solidity >=0.6.2 <0.8.0;
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
238 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
239 
240 pragma solidity >=0.6.0 <0.8.0;
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
257     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
258 }
259 
260 // File: @openzeppelin/contracts/introspection/ERC165.sol
261 
262 pragma solidity >=0.6.0 <0.8.0;
263 
264 
265 /**
266  * @dev Implementation of the {IERC165} interface.
267  *
268  * Contracts may inherit from this and call {_registerInterface} to declare
269  * their support of an interface.
270  */
271 abstract contract ERC165 is IERC165 {
272     /*
273      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
274      */
275     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
276 
277     /**
278      * @dev Mapping of interface ids to whether or not it's supported.
279      */
280     mapping(bytes4 => bool) private _supportedInterfaces;
281 
282     constructor () internal {
283         // Derived contracts need only register support for their own interfaces,
284         // we register support for ERC165 itself here
285         _registerInterface(_INTERFACE_ID_ERC165);
286     }
287 
288     /**
289      * @dev See {IERC165-supportsInterface}.
290      *
291      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
294         return _supportedInterfaces[interfaceId];
295     }
296 
297     /**
298      * @dev Registers the contract as an implementer of the interface defined by
299      * `interfaceId`. Support of the actual ERC165 interface is automatic and
300      * registering its interface id is not required.
301      *
302      * See {IERC165-supportsInterface}.
303      *
304      * Requirements:
305      *
306      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
307      */
308     function _registerInterface(bytes4 interfaceId) internal virtual {
309         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
310         _supportedInterfaces[interfaceId] = true;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/math/SafeMath.sol
315 
316 pragma solidity >=0.6.0 <0.8.0;
317 
318 /**
319  * @dev Wrappers over Solidity's arithmetic operations with added overflow
320  * checks.
321  *
322  * Arithmetic operations in Solidity wrap on overflow. This can easily result
323  * in bugs, because programmers usually assume that an overflow raises an
324  * error, which is the standard behavior in high level programming languages.
325  * `SafeMath` restores this intuition by reverting the transaction when an
326  * operation overflows.
327  *
328  * Using this library instead of the unchecked operations eliminates an entire
329  * class of bugs, so it's recommended to use it always.
330  */
331 library SafeMath {
332     /**
333      * @dev Returns the addition of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `+` operator.
337      *
338      * Requirements:
339      *
340      * - Addition cannot overflow.
341      */
342     function add(uint256 a, uint256 b) internal pure returns (uint256) {
343         uint256 c = a + b;
344         require(c >= a, "SafeMath: addition overflow");
345 
346         return c;
347     }
348 
349     /**
350      * @dev Returns the subtraction of two unsigned integers, reverting on
351      * overflow (when the result is negative).
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
360         return sub(a, b, "SafeMath: subtraction overflow");
361     }
362 
363     /**
364      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
365      * overflow (when the result is negative).
366      *
367      * Counterpart to Solidity's `-` operator.
368      *
369      * Requirements:
370      *
371      * - Subtraction cannot overflow.
372      */
373     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b <= a, errorMessage);
375         uint256 c = a - b;
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the multiplication of two unsigned integers, reverting on
382      * overflow.
383      *
384      * Counterpart to Solidity's `*` operator.
385      *
386      * Requirements:
387      *
388      * - Multiplication cannot overflow.
389      */
390     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
391         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
392         // benefit is lost if 'b' is also tested.
393         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
394         if (a == 0) {
395             return 0;
396         }
397 
398         uint256 c = a * b;
399         require(c / a == b, "SafeMath: multiplication overflow");
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers. Reverts on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function div(uint256 a, uint256 b) internal pure returns (uint256) {
417         return div(a, b, "SafeMath: division by zero");
418     }
419 
420     /**
421      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
422      * division by zero. The result is rounded towards zero.
423      *
424      * Counterpart to Solidity's `/` operator. Note: this function uses a
425      * `revert` opcode (which leaves remaining gas untouched) while Solidity
426      * uses an invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
433         require(b > 0, errorMessage);
434         uint256 c = a / b;
435         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
442      * Reverts when dividing by zero.
443      *
444      * Counterpart to Solidity's `%` operator. This function uses a `revert`
445      * opcode (which leaves remaining gas untouched) while Solidity uses an
446      * invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
453         return mod(a, b, "SafeMath: modulo by zero");
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
458      * Reverts with custom message when dividing by zero.
459      *
460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
461      * opcode (which leaves remaining gas untouched) while Solidity uses an
462      * invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
469         require(b != 0, errorMessage);
470         return a % b;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 pragma solidity >=0.6.2 <0.8.0;
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * [IMPORTANT]
486      * ====
487      * It is unsafe to assume that an address for which this function returns
488      * false is an externally-owned account (EOA) and not a contract.
489      *
490      * Among others, `isContract` will return false for the following
491      * types of addresses:
492      *
493      *  - an externally-owned account
494      *  - a contract in construction
495      *  - an address where a contract will be created
496      *  - an address where a contract lived, but was destroyed
497      * ====
498      */
499     function isContract(address account) internal view returns (bool) {
500         // This method relies on extcodesize, which returns 0 for contracts in
501         // construction, since the code is only stored at the end of the
502         // constructor execution.
503 
504         uint256 size;
505         // solhint-disable-next-line no-inline-assembly
506         assembly { size := extcodesize(account) }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
530         (bool success, ) = recipient.call{ value: amount }("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533 
534     /**
535      * @dev Performs a Solidity function call using a low level `call`. A
536      * plain`call` is an unsafe replacement for a function call: use this
537      * function instead.
538      *
539      * If `target` reverts with a revert reason, it is bubbled up by this
540      * function (like regular Solidity function calls).
541      *
542      * Returns the raw returned data. To convert to the expected return value,
543      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
544      *
545      * Requirements:
546      *
547      * - `target` must be a contract.
548      * - calling `target` with `data` must not revert.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
553       return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, 0, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but also transferring `value` wei to `target`.
569      *
570      * Requirements:
571      *
572      * - the calling contract must have an ETH balance of at least `value`.
573      * - the called Solidity function must be `payable`.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         // solhint-disable-next-line avoid-low-level-calls
592         (bool success, bytes memory returndata) = target.call{ value: value }(data);
593         return _verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
603         return functionStaticCall(target, data, "Address: low-level static call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         // solhint-disable-next-line avoid-low-level-calls
616         (bool success, bytes memory returndata) = target.staticcall(data);
617         return _verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
621         if (success) {
622             return returndata;
623         } else {
624             // Look for revert reason and bubble it up if present
625             if (returndata.length > 0) {
626                 // The easiest way to bubble the revert reason is using memory via assembly
627 
628                 // solhint-disable-next-line no-inline-assembly
629                 assembly {
630                     let returndata_size := mload(returndata)
631                     revert(add(32, returndata), returndata_size)
632                 }
633             } else {
634                 revert(errorMessage);
635             }
636         }
637     }
638 }
639 
640 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
641 
642 pragma solidity >=0.6.0 <0.8.0;
643 
644 /**
645  * @dev Library for managing
646  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
647  * types.
648  *
649  * Sets have the following properties:
650  *
651  * - Elements are added, removed, and checked for existence in constant time
652  * (O(1)).
653  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
654  *
655  * ```
656  * contract Example {
657  *     // Add the library methods
658  *     using EnumerableSet for EnumerableSet.AddressSet;
659  *
660  *     // Declare a set state variable
661  *     EnumerableSet.AddressSet private mySet;
662  * }
663  * ```
664  *
665  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
666  * and `uint256` (`UintSet`) are supported.
667  */
668 library EnumerableSet {
669     // To implement this library for multiple types with as little code
670     // repetition as possible, we write it in terms of a generic Set type with
671     // bytes32 values.
672     // The Set implementation uses private functions, and user-facing
673     // implementations (such as AddressSet) are just wrappers around the
674     // underlying Set.
675     // This means that we can only create new EnumerableSets for types that fit
676     // in bytes32.
677 
678     struct Set {
679         // Storage of set values
680         bytes32[] _values;
681 
682         // Position of the value in the `values` array, plus 1 because index 0
683         // means a value is not in the set.
684         mapping (bytes32 => uint256) _indexes;
685     }
686 
687     /**
688      * @dev Add a value to a set. O(1).
689      *
690      * Returns true if the value was added to the set, that is if it was not
691      * already present.
692      */
693     function _add(Set storage set, bytes32 value) private returns (bool) {
694         if (!_contains(set, value)) {
695             set._values.push(value);
696             // The value is stored at length-1, but we add 1 to all indexes
697             // and use 0 as a sentinel value
698             set._indexes[value] = set._values.length;
699             return true;
700         } else {
701             return false;
702         }
703     }
704 
705     /**
706      * @dev Removes a value from a set. O(1).
707      *
708      * Returns true if the value was removed from the set, that is if it was
709      * present.
710      */
711     function _remove(Set storage set, bytes32 value) private returns (bool) {
712         // We read and store the value's index to prevent multiple reads from the same storage slot
713         uint256 valueIndex = set._indexes[value];
714 
715         if (valueIndex != 0) { // Equivalent to contains(set, value)
716             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
717             // the array, and then remove the last element (sometimes called as 'swap and pop').
718             // This modifies the order of the array, as noted in {at}.
719 
720             uint256 toDeleteIndex = valueIndex - 1;
721             uint256 lastIndex = set._values.length - 1;
722 
723             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
724             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
725 
726             bytes32 lastvalue = set._values[lastIndex];
727 
728             // Move the last value to the index where the value to delete is
729             set._values[toDeleteIndex] = lastvalue;
730             // Update the index for the moved value
731             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
732 
733             // Delete the slot where the moved value was stored
734             set._values.pop();
735 
736             // Delete the index for the deleted slot
737             delete set._indexes[value];
738 
739             return true;
740         } else {
741             return false;
742         }
743     }
744 
745     /**
746      * @dev Returns true if the value is in the set. O(1).
747      */
748     function _contains(Set storage set, bytes32 value) private view returns (bool) {
749         return set._indexes[value] != 0;
750     }
751 
752     /**
753      * @dev Returns the number of values on the set. O(1).
754      */
755     function _length(Set storage set) private view returns (uint256) {
756         return set._values.length;
757     }
758 
759    /**
760     * @dev Returns the value stored at position `index` in the set. O(1).
761     *
762     * Note that there are no guarantees on the ordering of values inside the
763     * array, and it may change when more values are added or removed.
764     *
765     * Requirements:
766     *
767     * - `index` must be strictly less than {length}.
768     */
769     function _at(Set storage set, uint256 index) private view returns (bytes32) {
770         require(set._values.length > index, "EnumerableSet: index out of bounds");
771         return set._values[index];
772     }
773 
774     // Bytes32Set
775 
776     struct Bytes32Set {
777         Set _inner;
778     }
779 
780     /**
781      * @dev Add a value to a set. O(1).
782      *
783      * Returns true if the value was added to the set, that is if it was not
784      * already present.
785      */
786     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
787         return _add(set._inner, value);
788     }
789 
790     /**
791      * @dev Removes a value from a set. O(1).
792      *
793      * Returns true if the value was removed from the set, that is if it was
794      * present.
795      */
796     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
797         return _remove(set._inner, value);
798     }
799 
800     /**
801      * @dev Returns true if the value is in the set. O(1).
802      */
803     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
804         return _contains(set._inner, value);
805     }
806 
807     /**
808      * @dev Returns the number of values in the set. O(1).
809      */
810     function length(Bytes32Set storage set) internal view returns (uint256) {
811         return _length(set._inner);
812     }
813 
814    /**
815     * @dev Returns the value stored at position `index` in the set. O(1).
816     *
817     * Note that there are no guarantees on the ordering of values inside the
818     * array, and it may change when more values are added or removed.
819     *
820     * Requirements:
821     *
822     * - `index` must be strictly less than {length}.
823     */
824     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
825         return _at(set._inner, index);
826     }
827 
828     // AddressSet
829 
830     struct AddressSet {
831         Set _inner;
832     }
833 
834     /**
835      * @dev Add a value to a set. O(1).
836      *
837      * Returns true if the value was added to the set, that is if it was not
838      * already present.
839      */
840     function add(AddressSet storage set, address value) internal returns (bool) {
841         return _add(set._inner, bytes32(uint256(value)));
842     }
843 
844     /**
845      * @dev Removes a value from a set. O(1).
846      *
847      * Returns true if the value was removed from the set, that is if it was
848      * present.
849      */
850     function remove(AddressSet storage set, address value) internal returns (bool) {
851         return _remove(set._inner, bytes32(uint256(value)));
852     }
853 
854     /**
855      * @dev Returns true if the value is in the set. O(1).
856      */
857     function contains(AddressSet storage set, address value) internal view returns (bool) {
858         return _contains(set._inner, bytes32(uint256(value)));
859     }
860 
861     /**
862      * @dev Returns the number of values in the set. O(1).
863      */
864     function length(AddressSet storage set) internal view returns (uint256) {
865         return _length(set._inner);
866     }
867 
868    /**
869     * @dev Returns the value stored at position `index` in the set. O(1).
870     *
871     * Note that there are no guarantees on the ordering of values inside the
872     * array, and it may change when more values are added or removed.
873     *
874     * Requirements:
875     *
876     * - `index` must be strictly less than {length}.
877     */
878     function at(AddressSet storage set, uint256 index) internal view returns (address) {
879         return address(uint256(_at(set._inner, index)));
880     }
881 
882 
883     // UintSet
884 
885     struct UintSet {
886         Set _inner;
887     }
888 
889     /**
890      * @dev Add a value to a set. O(1).
891      *
892      * Returns true if the value was added to the set, that is if it was not
893      * already present.
894      */
895     function add(UintSet storage set, uint256 value) internal returns (bool) {
896         return _add(set._inner, bytes32(value));
897     }
898 
899     /**
900      * @dev Removes a value from a set. O(1).
901      *
902      * Returns true if the value was removed from the set, that is if it was
903      * present.
904      */
905     function remove(UintSet storage set, uint256 value) internal returns (bool) {
906         return _remove(set._inner, bytes32(value));
907     }
908 
909     /**
910      * @dev Returns true if the value is in the set. O(1).
911      */
912     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
913         return _contains(set._inner, bytes32(value));
914     }
915 
916     /**
917      * @dev Returns the number of values on the set. O(1).
918      */
919     function length(UintSet storage set) internal view returns (uint256) {
920         return _length(set._inner);
921     }
922 
923    /**
924     * @dev Returns the value stored at position `index` in the set. O(1).
925     *
926     * Note that there are no guarantees on the ordering of values inside the
927     * array, and it may change when more values are added or removed.
928     *
929     * Requirements:
930     *
931     * - `index` must be strictly less than {length}.
932     */
933     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
934         return uint256(_at(set._inner, index));
935     }
936 }
937 
938 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
939 
940 pragma solidity >=0.6.0 <0.8.0;
941 
942 /**
943  * @dev Library for managing an enumerable variant of Solidity's
944  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
945  * type.
946  *
947  * Maps have the following properties:
948  *
949  * - Entries are added, removed, and checked for existence in constant time
950  * (O(1)).
951  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
952  *
953  * ```
954  * contract Example {
955  *     // Add the library methods
956  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
957  *
958  *     // Declare a set state variable
959  *     EnumerableMap.UintToAddressMap private myMap;
960  * }
961  * ```
962  *
963  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
964  * supported.
965  */
966 library EnumerableMap {
967     // To implement this library for multiple types with as little code
968     // repetition as possible, we write it in terms of a generic Map type with
969     // bytes32 keys and values.
970     // The Map implementation uses private functions, and user-facing
971     // implementations (such as Uint256ToAddressMap) are just wrappers around
972     // the underlying Map.
973     // This means that we can only create new EnumerableMaps for types that fit
974     // in bytes32.
975 
976     struct MapEntry {
977         bytes32 _key;
978         bytes32 _value;
979     }
980 
981     struct Map {
982         // Storage of map keys and values
983         MapEntry[] _entries;
984 
985         // Position of the entry defined by a key in the `entries` array, plus 1
986         // because index 0 means a key is not in the map.
987         mapping (bytes32 => uint256) _indexes;
988     }
989 
990     /**
991      * @dev Adds a key-value pair to a map, or updates the value for an existing
992      * key. O(1).
993      *
994      * Returns true if the key was added to the map, that is if it was not
995      * already present.
996      */
997     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
998         // We read and store the key's index to prevent multiple reads from the same storage slot
999         uint256 keyIndex = map._indexes[key];
1000 
1001         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1002             map._entries.push(MapEntry({ _key: key, _value: value }));
1003             // The entry is stored at length-1, but we add 1 to all indexes
1004             // and use 0 as a sentinel value
1005             map._indexes[key] = map._entries.length;
1006             return true;
1007         } else {
1008             map._entries[keyIndex - 1]._value = value;
1009             return false;
1010         }
1011     }
1012 
1013     /**
1014      * @dev Removes a key-value pair from a map. O(1).
1015      *
1016      * Returns true if the key was removed from the map, that is if it was present.
1017      */
1018     function _remove(Map storage map, bytes32 key) private returns (bool) {
1019         // We read and store the key's index to prevent multiple reads from the same storage slot
1020         uint256 keyIndex = map._indexes[key];
1021 
1022         if (keyIndex != 0) { // Equivalent to contains(map, key)
1023             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1024             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1025             // This modifies the order of the array, as noted in {at}.
1026 
1027             uint256 toDeleteIndex = keyIndex - 1;
1028             uint256 lastIndex = map._entries.length - 1;
1029 
1030             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1031             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1032 
1033             MapEntry storage lastEntry = map._entries[lastIndex];
1034 
1035             // Move the last entry to the index where the entry to delete is
1036             map._entries[toDeleteIndex] = lastEntry;
1037             // Update the index for the moved entry
1038             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1039 
1040             // Delete the slot where the moved entry was stored
1041             map._entries.pop();
1042 
1043             // Delete the index for the deleted slot
1044             delete map._indexes[key];
1045 
1046             return true;
1047         } else {
1048             return false;
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns true if the key is in the map. O(1).
1054      */
1055     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1056         return map._indexes[key] != 0;
1057     }
1058 
1059     /**
1060      * @dev Returns the number of key-value pairs in the map. O(1).
1061      */
1062     function _length(Map storage map) private view returns (uint256) {
1063         return map._entries.length;
1064     }
1065 
1066    /**
1067     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1068     *
1069     * Note that there are no guarantees on the ordering of entries inside the
1070     * array, and it may change when more entries are added or removed.
1071     *
1072     * Requirements:
1073     *
1074     * - `index` must be strictly less than {length}.
1075     */
1076     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1077         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1078 
1079         MapEntry storage entry = map._entries[index];
1080         return (entry._key, entry._value);
1081     }
1082 
1083     /**
1084      * @dev Returns the value associated with `key`.  O(1).
1085      *
1086      * Requirements:
1087      *
1088      * - `key` must be in the map.
1089      */
1090     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1091         return _get(map, key, "EnumerableMap: nonexistent key");
1092     }
1093 
1094     /**
1095      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1096      */
1097     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1098         uint256 keyIndex = map._indexes[key];
1099         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1100         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1101     }
1102 
1103     // UintToAddressMap
1104 
1105     struct UintToAddressMap {
1106         Map _inner;
1107     }
1108 
1109     /**
1110      * @dev Adds a key-value pair to a map, or updates the value for an existing
1111      * key. O(1).
1112      *
1113      * Returns true if the key was added to the map, that is if it was not
1114      * already present.
1115      */
1116     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1117         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1118     }
1119 
1120     /**
1121      * @dev Removes a value from a set. O(1).
1122      *
1123      * Returns true if the key was removed from the map, that is if it was present.
1124      */
1125     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1126         return _remove(map._inner, bytes32(key));
1127     }
1128 
1129     /**
1130      * @dev Returns true if the key is in the map. O(1).
1131      */
1132     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1133         return _contains(map._inner, bytes32(key));
1134     }
1135 
1136     /**
1137      * @dev Returns the number of elements in the map. O(1).
1138      */
1139     function length(UintToAddressMap storage map) internal view returns (uint256) {
1140         return _length(map._inner);
1141     }
1142 
1143    /**
1144     * @dev Returns the element stored at position `index` in the set. O(1).
1145     * Note that there are no guarantees on the ordering of values inside the
1146     * array, and it may change when more values are added or removed.
1147     *
1148     * Requirements:
1149     *
1150     * - `index` must be strictly less than {length}.
1151     */
1152     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1153         (bytes32 key, bytes32 value) = _at(map._inner, index);
1154         return (uint256(key), address(uint256(value)));
1155     }
1156 
1157     /**
1158      * @dev Returns the value associated with `key`.  O(1).
1159      *
1160      * Requirements:
1161      *
1162      * - `key` must be in the map.
1163      */
1164     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1165         return address(uint256(_get(map._inner, bytes32(key))));
1166     }
1167 
1168     /**
1169      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1170      */
1171     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1172         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1173     }
1174 }
1175 
1176 // File: @openzeppelin/contracts/utils/Strings.sol
1177 
1178 pragma solidity >=0.6.0 <0.8.0;
1179 
1180 /**
1181  * @dev String operations.
1182  */
1183 library Strings {
1184     /**
1185      * @dev Converts a `uint256` to its ASCII `string` representation.
1186      */
1187     function toString(uint256 value) internal pure returns (string memory) {
1188         // Inspired by OraclizeAPI's implementation - MIT licence
1189         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1190 
1191         if (value == 0) {
1192             return "0";
1193         }
1194         uint256 temp = value;
1195         uint256 digits;
1196         while (temp != 0) {
1197             digits++;
1198             temp /= 10;
1199         }
1200         bytes memory buffer = new bytes(digits);
1201         uint256 index = digits - 1;
1202         temp = value;
1203         while (temp != 0) {
1204             buffer[index--] = byte(uint8(48 + temp % 10));
1205             temp /= 10;
1206         }
1207         return string(buffer);
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1212 
1213 pragma solidity >=0.6.0 <0.8.0;
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 
1226 /**
1227  * @title ERC721 Non-Fungible Token Standard basic implementation
1228  * @dev see https://eips.ethereum.org/EIPS/eip-721
1229  */
1230 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1231     using SafeMath for uint256;
1232     using Address for address;
1233     using EnumerableSet for EnumerableSet.UintSet;
1234     using EnumerableMap for EnumerableMap.UintToAddressMap;
1235     using Strings for uint256;
1236 
1237     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1238     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1239     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1240 
1241     // Mapping from holder address to their (enumerable) set of owned tokens
1242     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1243 
1244     // Enumerable mapping from token ids to their owners
1245     EnumerableMap.UintToAddressMap private _tokenOwners;
1246 
1247     // Mapping from token ID to approved address
1248     mapping (uint256 => address) private _tokenApprovals;
1249 
1250     // Mapping from owner to operator approvals
1251     mapping (address => mapping (address => bool)) private _operatorApprovals;
1252 
1253     // Token name
1254     string private _name;
1255 
1256     // Token symbol
1257     string private _symbol;
1258 
1259     // Optional mapping for token URIs
1260     mapping (uint256 => string) private _tokenURIs;
1261 
1262     // Base URI
1263     string private _baseURI;
1264 
1265     /*
1266      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1267      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1268      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1269      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1270      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1271      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1272      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1273      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1274      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1275      *
1276      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1277      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1278      */
1279     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1280 
1281     /*
1282      *     bytes4(keccak256('name()')) == 0x06fdde03
1283      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1284      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1285      *
1286      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1287      */
1288     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1289 
1290     /*
1291      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1292      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1293      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1294      *
1295      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1296      */
1297     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1298 
1299     /**
1300      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1301      */
1302     constructor (string memory name_, string memory symbol_) public {
1303         _name = name_;
1304         _symbol = symbol_;
1305 
1306         // register the supported interfaces to conform to ERC721 via ERC165
1307         _registerInterface(_INTERFACE_ID_ERC721);
1308         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1309         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-balanceOf}.
1314      */
1315     function balanceOf(address owner) public view override returns (uint256) {
1316         require(owner != address(0), "ERC721: balance query for the zero address");
1317 
1318         return _holderTokens[owner].length();
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-ownerOf}.
1323      */
1324     function ownerOf(uint256 tokenId) public view override returns (address) {
1325         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-name}.
1330      */
1331     function name() public view override returns (string memory) {
1332         return _name;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-symbol}.
1337      */
1338     function symbol() public view override returns (string memory) {
1339         return _symbol;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-tokenURI}.
1344      */
1345     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1346         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1347 
1348         string memory _tokenURI = _tokenURIs[tokenId];
1349 
1350         // If there is no base URI, return the token URI.
1351         if (bytes(_baseURI).length == 0) {
1352             return _tokenURI;
1353         }
1354         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1355         if (bytes(_tokenURI).length > 0) {
1356             return string(abi.encodePacked(_baseURI, _tokenURI));
1357         }
1358         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1359         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1360     }
1361 
1362     /**
1363     * @dev Returns the base URI set via {_setBaseURI}. This will be
1364     * automatically added as a prefix in {tokenURI} to each token's URI, or
1365     * to the token ID if no specific URI is set for that token ID.
1366     */
1367     function baseURI() public view returns (string memory) {
1368         return _baseURI;
1369     }
1370 
1371     /**
1372      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1373      */
1374     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1375         return _holderTokens[owner].at(index);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721Enumerable-totalSupply}.
1380      */
1381     function totalSupply() public view override returns (uint256) {
1382         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1383         return _tokenOwners.length();
1384     }
1385 
1386     /**
1387      * @dev See {IERC721Enumerable-tokenByIndex}.
1388      */
1389     function tokenByIndex(uint256 index) public view override returns (uint256) {
1390         (uint256 tokenId, ) = _tokenOwners.at(index);
1391         return tokenId;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-approve}.
1396      */
1397     function approve(address to, uint256 tokenId) public virtual override {
1398         address owner = ownerOf(tokenId);
1399         require(to != owner, "ERC721: approval to current owner");
1400 
1401         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1402             "ERC721: approve caller is not owner nor approved for all"
1403         );
1404 
1405         _approve(to, tokenId);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-getApproved}.
1410      */
1411     function getApproved(uint256 tokenId) public view override returns (address) {
1412         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1413 
1414         return _tokenApprovals[tokenId];
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-setApprovalForAll}.
1419      */
1420     function setApprovalForAll(address operator, bool approved) public virtual override {
1421         require(operator != _msgSender(), "ERC721: approve to caller");
1422 
1423         _operatorApprovals[_msgSender()][operator] = approved;
1424         emit ApprovalForAll(_msgSender(), operator, approved);
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-isApprovedForAll}.
1429      */
1430     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1431         return _operatorApprovals[owner][operator];
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-transferFrom}.
1436      */
1437     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1438         //solhint-disable-next-line max-line-length
1439         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1440 
1441         _transfer(from, to, tokenId);
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-safeTransferFrom}.
1446      */
1447     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1448         safeTransferFrom(from, to, tokenId, "");
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-safeTransferFrom}.
1453      */
1454     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1455         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1456         _safeTransfer(from, to, tokenId, _data);
1457     }
1458 
1459     /**
1460      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1461      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1462      *
1463      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1464      *
1465      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1466      * implement alternative mechanisms to perform token transfer, such as signature-based.
1467      *
1468      * Requirements:
1469      *
1470      * - `from` cannot be the zero address.
1471      * - `to` cannot be the zero address.
1472      * - `tokenId` token must exist and be owned by `from`.
1473      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1478         _transfer(from, to, tokenId);
1479         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1480     }
1481 
1482     /**
1483      * @dev Returns whether `tokenId` exists.
1484      *
1485      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1486      *
1487      * Tokens start existing when they are minted (`_mint`),
1488      * and stop existing when they are burned (`_burn`).
1489      */
1490     function _exists(uint256 tokenId) internal view returns (bool) {
1491         return _tokenOwners.contains(tokenId);
1492     }
1493 
1494     /**
1495      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must exist.
1500      */
1501     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1502         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1503         address owner = ownerOf(tokenId);
1504         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1505     }
1506 
1507     /**
1508      * @dev Safely mints `tokenId` and transfers it to `to`.
1509      *
1510      * Requirements:
1511      d*
1512      * - `tokenId` must not exist.
1513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _safeMint(address to, uint256 tokenId) internal virtual {
1518         _safeMint(to, tokenId, "");
1519     }
1520 
1521     /**
1522      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1523      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1524      */
1525     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1526         _mint(to, tokenId);
1527         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1528     }
1529 
1530     /**
1531      * @dev Mints `tokenId` and transfers it to `to`.
1532      *
1533      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1534      *
1535      * Requirements:
1536      *
1537      * - `tokenId` must not exist.
1538      * - `to` cannot be the zero address.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _mint(address to, uint256 tokenId) internal virtual {
1543         require(to != address(0), "ERC721: mint to the zero address");
1544         require(!_exists(tokenId), "ERC721: token already minted");
1545 
1546         _beforeTokenTransfer(address(0), to, tokenId);
1547 
1548         _holderTokens[to].add(tokenId);
1549 
1550         _tokenOwners.set(tokenId, to);
1551 
1552         emit Transfer(address(0), to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Destroys `tokenId`.
1557      * The approval is cleared when the token is burned.
1558      *
1559      * Requirements:
1560      *
1561      * - `tokenId` must exist.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function _burn(uint256 tokenId) internal virtual {
1566         address owner = ownerOf(tokenId);
1567 
1568         _beforeTokenTransfer(owner, address(0), tokenId);
1569 
1570         // Clear approvals
1571         _approve(address(0), tokenId);
1572 
1573         // Clear metadata (if any)
1574         if (bytes(_tokenURIs[tokenId]).length != 0) {
1575             delete _tokenURIs[tokenId];
1576         }
1577 
1578         _holderTokens[owner].remove(tokenId);
1579 
1580         _tokenOwners.remove(tokenId);
1581 
1582         emit Transfer(owner, address(0), tokenId);
1583     }
1584 
1585     /**
1586      * @dev Transfers `tokenId` from `from` to `to`.
1587      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1588      *
1589      * Requirements:
1590      *
1591      * - `to` cannot be the zero address.
1592      * - `tokenId` token must be owned by `from`.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1597         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1598         require(to != address(0), "ERC721: transfer to the zero address");
1599 
1600         _beforeTokenTransfer(from, to, tokenId);
1601 
1602         // Clear approvals from the previous owner
1603         _approve(address(0), tokenId);
1604 
1605         _holderTokens[from].remove(tokenId);
1606         _holderTokens[to].add(tokenId);
1607 
1608         _tokenOwners.set(tokenId, to);
1609 
1610         emit Transfer(from, to, tokenId);
1611     }
1612 
1613     /**
1614      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must exist.
1619      */
1620     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1621         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1622         _tokenURIs[tokenId] = _tokenURI;
1623     }
1624 
1625     /**
1626      * @dev Internal function to set the base URI for all token IDs. It is
1627      * automatically added as a prefix to the value returned in {tokenURI},
1628      * or to the token ID if {tokenURI} is empty.
1629      */
1630     function _setBaseURI(string memory baseURI_) internal virtual {
1631         _baseURI = baseURI_;
1632     }
1633 
1634     /**
1635      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1636      * The call is not executed if the target address is not a contract.
1637      *
1638      * @param from address representing the previous owner of the given token ID
1639      * @param to target address that will receive the tokens
1640      * @param tokenId uint256 ID of the token to be transferred
1641      * @param _data bytes optional data to send along with the call
1642      * @return bool whether the call correctly returned the expected magic value
1643      */
1644     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1645         private returns (bool)
1646     {
1647         if (!to.isContract()) {
1648             return true;
1649         }
1650         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1651             IERC721Receiver(to).onERC721Received.selector,
1652             _msgSender(),
1653             from,
1654             tokenId,
1655             _data
1656         ), "ERC721: transfer to non ERC721Receiver implementer");
1657         bytes4 retval = abi.decode(returndata, (bytes4));
1658         return (retval == _ERC721_RECEIVED);
1659     }
1660 
1661     function _approve(address to, uint256 tokenId) private {
1662         _tokenApprovals[tokenId] = to;
1663         emit Approval(ownerOf(tokenId), to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Hook that is called before any token transfer. This includes minting
1668      * and burning.
1669      *
1670      * Calling conditions:
1671      *
1672      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1673      * transferred to `to`.
1674      * - When `from` is zero, `tokenId` will be minted for `to`.
1675      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1676      * - `from` cannot be the zero address.
1677      * - `to` cannot be the zero address.
1678      *
1679      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1680      */
1681     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1682 }
1683 
1684 // File: @openzeppelin/contracts/access/Ownable.sol
1685 
1686 pragma solidity >=0.6.0 <0.8.0;
1687 
1688 /**
1689  * @dev Contract module which provides a basic access control mechanism, where
1690  * there is an account (an owner) that can be granted exclusive access to
1691  * specific functions.
1692  *
1693  * By default, the owner account will be the one that deploys the contract. This
1694  * can later be changed with {transferOwnership}.
1695  *
1696  * This module is used through inheritance. It will make available the modifier
1697  * `onlyOwner`, which can be applied to your functions to restrict their use to
1698  * the owner.
1699  */
1700 abstract contract Ownable is Context {
1701     address private _owner;
1702 
1703     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1704 
1705     /**
1706      * @dev Initializes the contract setting the deployer as the initial owner.
1707      */
1708     constructor () internal {
1709         address msgSender = _msgSender();
1710         _owner = msgSender;
1711         emit OwnershipTransferred(address(0), msgSender);
1712     }
1713 
1714     /**
1715      * @dev Returns the address of the current owner.
1716      */
1717     function owner() public view returns (address) {
1718         return _owner;
1719     }
1720 
1721     /**
1722      * @dev Throws if called by any account other than the owner.
1723      */
1724     modifier onlyOwner() {
1725         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1726         _;
1727     }
1728 
1729     /**
1730      * @dev Leaves the contract without owner. It will not be possible to call
1731      * `onlyOwner` functions anymore. Can only be called by the current owner.
1732      *
1733      * NOTE: Renouncing ownership will leave the contract without an owner,
1734      * thereby removing any functionality that is only available to the owner.
1735      */
1736     function renounceOwnership() public virtual onlyOwner {
1737         emit OwnershipTransferred(_owner, address(0));
1738         _owner = address(0);
1739     }
1740 
1741     /**
1742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1743      * Can only be called by the current owner.
1744      */
1745     function transferOwnership(address newOwner) public virtual onlyOwner {
1746         require(newOwner != address(0), "Ownable: new owner is the zero address");
1747         emit OwnershipTransferred(_owner, newOwner);
1748         _owner = newOwner;
1749     }
1750 }
1751 
1752 // File: @openzeppelin/contracts/utils/Counters.sol
1753 
1754 pragma solidity >=0.6.0 <0.8.0;
1755 
1756 
1757 /**
1758  * @title Counters
1759  * @author Matt Condon (@shrugs)
1760  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1761  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1762  *
1763  * Include with `using Counters for Counters.Counter;`
1764  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1765  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1766  * directly accessed.
1767  */
1768 library Counters {
1769     using SafeMath for uint256;
1770 
1771     struct Counter {
1772         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1773         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1774         // this feature: see https://github.com/ethereum/solidity/issues/4637
1775         uint256 _value; // default: 0
1776     }
1777 
1778     function current(Counter storage counter) internal view returns (uint256) {
1779         return counter._value;
1780     }
1781 
1782     function increment(Counter storage counter) internal {
1783         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1784         counter._value += 1;
1785     }
1786 
1787     function decrement(Counter storage counter) internal {
1788         counter._value = counter._value.sub(1);
1789     }
1790 }
1791 
1792 // File: contracts/EtherDirt.sol
1793 pragma solidity ^0.6.0;
1794 
1795 
1796 
1797 
1798 contract EtherDirt is ERC721, Ownable {
1799     using Counters for Counters.Counter;
1800 
1801     Counters.Counter private _tokenIds;
1802 
1803     struct Dirt {
1804         address owner;
1805         bool currentlyForSale;
1806         uint price;
1807         uint timesSold;
1808     }
1809     
1810     mapping (uint => Dirt) public dirt;
1811     
1812     mapping (address => uint[]) public dirtOwners;
1813 
1814     uint public latestNewDirtForSale;
1815     
1816     constructor(string memory baseURI) ERC721("EtherDirt", "DIRT") public {
1817             _setBaseURI(baseURI);
1818             dirt[0].price = 25 * 10**13;
1819             dirt[0].currentlyForSale = true;
1820     }
1821     
1822     function getDirtInfo (uint dirtNumber) public view returns (address, bool, uint, uint) {
1823         return (dirt[dirtNumber].owner, dirt[dirtNumber].currentlyForSale, dirt[dirtNumber].price, dirt[dirtNumber].timesSold);
1824     }
1825     
1826     function dirtOwningHistory (address _address) public view returns (uint[] memory ) {
1827         return dirtOwners[_address];
1828     }
1829     
1830     function buyDirt (uint dirtNumber) public payable {
1831         require(dirt[dirtNumber].currentlyForSale == true);
1832         require(msg.value == dirt[dirtNumber].price);
1833         dirt[dirtNumber].currentlyForSale = false;
1834         dirt[dirtNumber].timesSold++;
1835         if (dirtNumber != latestNewDirtForSale) {
1836             payable(dirt[dirtNumber].owner).transfer(dirt[dirtNumber].price);
1837             transferFrom(dirt[dirtNumber].owner, msg.sender, dirtNumber);
1838         }
1839         dirt[dirtNumber].owner = msg.sender;
1840         dirtOwners[msg.sender].push(dirtNumber);
1841         if (dirtNumber == latestNewDirtForSale) {
1842             if (dirtNumber < 99) {
1843                 _mint(msg.sender, _tokenIds.current());
1844                 _tokenIds.increment();
1845                 latestNewDirtForSale++;
1846                 dirt[latestNewDirtForSale].price = 
1847                     (10**15 + (latestNewDirtForSale**2 * 10**15))/8;
1848                 dirt[latestNewDirtForSale].currentlyForSale = true;
1849             }
1850         }
1851     }
1852     
1853     function sellDirt (uint dirtNumber, uint price) public {
1854         require(msg.sender == dirt[dirtNumber].owner);
1855         require(price > 0);
1856         dirt[dirtNumber].price = price;
1857         dirt[dirtNumber].currentlyForSale = true;
1858     }
1859     
1860     function dontSellDirt (uint dirtNumber) public {
1861         require(msg.sender == dirt[dirtNumber].owner);
1862         dirt[dirtNumber].currentlyForSale = false;
1863     }
1864     
1865     function giftDirt (uint dirtNumber, address receiver) public {
1866         require(msg.sender == dirt[dirtNumber].owner);
1867         dirt[dirtNumber].owner = receiver;
1868         dirtOwners[receiver].push(dirtNumber);
1869         transferFrom(msg.sender, receiver, dirtNumber);
1870     }
1871     
1872     function withdraw() public onlyOwner {
1873         msg.sender.transfer(address(this).balance);
1874     }
1875 
1876     // Only supported transfer from contract
1877     function transferFrom(
1878         address from,
1879         address to,
1880         uint256 tokenId
1881     ) public virtual override {  
1882         dirt[tokenId].owner = msg.sender;
1883         dirtOwners[msg.sender].push(tokenId);      
1884         super.transferFrom(from, to, tokenId);
1885     }
1886 }