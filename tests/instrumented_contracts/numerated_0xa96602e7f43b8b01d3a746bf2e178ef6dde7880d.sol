1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
52 
53 pragma solidity >=0.6.2 <0.8.0;
54 
55 
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 interface IERC721 is IERC165 {
60     /**
61      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
67      */
68     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
72      */
73     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
74 
75     /**
76      * @dev Returns the number of tokens in ``owner``'s account.
77      */
78     function balanceOf(address owner) external view returns (uint256 balance);
79 
80     /**
81      * @dev Returns the owner of the `tokenId` token.
82      *
83      * Requirements:
84      *
85      * - `tokenId` must exist.
86      */
87     function ownerOf(uint256 tokenId) external view returns (address owner);
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(address from, address to, uint256 tokenId) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(address from, address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
123      * The approval is cleared when the token is transferred.
124      *
125      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
126      *
127      * Requirements:
128      *
129      * - The caller must own the token or be an approved operator.
130      * - `tokenId` must exist.
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Returns the account approved for `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function getApproved(uint256 tokenId) external view returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator) external view returns (bool);
163 
164     /**
165       * @dev Safely transfers `tokenId` token from `from` to `to`.
166       *
167       * Requirements:
168       *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171       * - `tokenId` token must exist and be owned by `from`.
172       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174       *
175       * Emits a {Transfer} event.
176       */
177     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
178 }
179 
180 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
181 
182 pragma solidity >=0.6.2 <0.8.0;
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
209 pragma solidity >=0.6.2 <0.8.0;
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Enumerable is IERC721 {
217 
218     /**
219      * @dev Returns the total amount of tokens stored by the contract.
220      */
221     function totalSupply() external view returns (uint256);
222 
223     /**
224      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
225      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
226      */
227     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
228 
229     /**
230      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
231      * Use along with {totalSupply} to enumerate all tokens.
232      */
233     function tokenByIndex(uint256 index) external view returns (uint256);
234 }
235 
236 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
237 
238 pragma solidity >=0.6.0 <0.8.0;
239 
240 /**
241  * @title ERC721 token receiver interface
242  * @dev Interface for any contract that wants to support safeTransfers
243  * from ERC721 asset contracts.
244  */
245 interface IERC721Receiver {
246     /**
247      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
248      * by `operator` from `from`, this function is called.
249      *
250      * It must return its Solidity selector to confirm the token transfer.
251      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
252      *
253      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
254      */
255     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
256 }
257 
258 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
259 
260 pragma solidity >=0.6.0 <0.8.0;
261 
262 
263 /**
264  * @dev Implementation of the {IERC165} interface.
265  *
266  * Contracts may inherit from this and call {_registerInterface} to declare
267  * their support of an interface.
268  */
269 abstract contract ERC165 is IERC165 {
270     /*
271      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
272      */
273     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
274 
275     /**
276      * @dev Mapping of interface ids to whether or not it's supported.
277      */
278     mapping(bytes4 => bool) private _supportedInterfaces;
279 
280     constructor () internal {
281         // Derived contracts need only register support for their own interfaces,
282         // we register support for ERC165 itself here
283         _registerInterface(_INTERFACE_ID_ERC165);
284     }
285 
286     /**
287      * @dev See {IERC165-supportsInterface}.
288      *
289      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
290      */
291     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
292         return _supportedInterfaces[interfaceId];
293     }
294 
295     /**
296      * @dev Registers the contract as an implementer of the interface defined by
297      * `interfaceId`. Support of the actual ERC165 interface is automatic and
298      * registering its interface id is not required.
299      *
300      * See {IERC165-supportsInterface}.
301      *
302      * Requirements:
303      *
304      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
305      */
306     function _registerInterface(bytes4 interfaceId) internal virtual {
307         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
308         _supportedInterfaces[interfaceId] = true;
309     }
310 }
311 
312 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
313 
314 pragma solidity >=0.6.0 <0.8.0;
315 
316 /**
317  * @dev Wrappers over Solidity's arithmetic operations with added overflow
318  * checks.
319  *
320  * Arithmetic operations in Solidity wrap on overflow. This can easily result
321  * in bugs, because programmers usually assume that an overflow raises an
322  * error, which is the standard behavior in high level programming languages.
323  * `SafeMath` restores this intuition by reverting the transaction when an
324  * operation overflows.
325  *
326  * Using this library instead of the unchecked operations eliminates an entire
327  * class of bugs, so it's recommended to use it always.
328  */
329 library SafeMath {
330     /**
331      * @dev Returns the addition of two unsigned integers, reverting on
332      * overflow.
333      *
334      * Counterpart to Solidity's `+` operator.
335      *
336      * Requirements:
337      *
338      * - Addition cannot overflow.
339      */
340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
341         uint256 c = a + b;
342         require(c >= a, "SafeMath: addition overflow");
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the subtraction of two unsigned integers, reverting on
349      * overflow (when the result is negative).
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
358         return sub(a, b, "SafeMath: subtraction overflow");
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
363      * overflow (when the result is negative).
364      *
365      * Counterpart to Solidity's `-` operator.
366      *
367      * Requirements:
368      *
369      * - Subtraction cannot overflow.
370      */
371     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b <= a, errorMessage);
373         uint256 c = a - b;
374 
375         return c;
376     }
377 
378     /**
379      * @dev Returns the multiplication of two unsigned integers, reverting on
380      * overflow.
381      *
382      * Counterpart to Solidity's `*` operator.
383      *
384      * Requirements:
385      *
386      * - Multiplication cannot overflow.
387      */
388     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
389         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
390         // benefit is lost if 'b' is also tested.
391         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
392         if (a == 0) {
393             return 0;
394         }
395 
396         uint256 c = a * b;
397         require(c / a == b, "SafeMath: multiplication overflow");
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers. Reverts on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(uint256 a, uint256 b) internal pure returns (uint256) {
415         return div(a, b, "SafeMath: division by zero");
416     }
417 
418     /**
419      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
420      * division by zero. The result is rounded towards zero.
421      *
422      * Counterpart to Solidity's `/` operator. Note: this function uses a
423      * `revert` opcode (which leaves remaining gas untouched) while Solidity
424      * uses an invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
431         require(b > 0, errorMessage);
432         uint256 c = a / b;
433         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
434 
435         return c;
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * Reverts when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
451         return mod(a, b, "SafeMath: modulo by zero");
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
456      * Reverts with custom message when dividing by zero.
457      *
458      * Counterpart to Solidity's `%` operator. This function uses a `revert`
459      * opcode (which leaves remaining gas untouched) while Solidity uses an
460      * invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
467         require(b != 0, errorMessage);
468         return a % b;
469     }
470 }
471 
472 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
473 
474 pragma solidity >=0.6.2 <0.8.0;
475 
476 /**
477  * @dev Collection of functions related to the address type
478  */
479 library Address {
480     /**
481      * @dev Returns true if `account` is a contract.
482      *
483      * [IMPORTANT]
484      * ====
485      * It is unsafe to assume that an address for which this function returns
486      * false is an externally-owned account (EOA) and not a contract.
487      *
488      * Among others, `isContract` will return false for the following
489      * types of addresses:
490      *
491      *  - an externally-owned account
492      *  - a contract in construction
493      *  - an address where a contract will be created
494      *  - an address where a contract lived, but was destroyed
495      * ====
496      */
497     function isContract(address account) internal view returns (bool) {
498         // This method relies on extcodesize, which returns 0 for contracts in
499         // construction, since the code is only stored at the end of the
500         // constructor execution.
501 
502         uint256 size;
503         // solhint-disable-next-line no-inline-assembly
504         assembly { size := extcodesize(account) }
505         return size > 0;
506     }
507 
508     /**
509      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
510      * `recipient`, forwarding all available gas and reverting on errors.
511      *
512      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
513      * of certain opcodes, possibly making contracts go over the 2300 gas limit
514      * imposed by `transfer`, making them unable to receive funds via
515      * `transfer`. {sendValue} removes this limitation.
516      *
517      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
518      *
519      * IMPORTANT: because control is transferred to `recipient`, care must be
520      * taken to not create reentrancy vulnerabilities. Consider using
521      * {ReentrancyGuard} or the
522      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
523      */
524     function sendValue(address payable recipient, uint256 amount) internal {
525         require(address(this).balance >= amount, "Address: insufficient balance");
526 
527         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
528         (bool success, ) = recipient.call{ value: amount }("");
529         require(success, "Address: unable to send value, recipient may have reverted");
530     }
531 
532     /**
533      * @dev Performs a Solidity function call using a low level `call`. A
534      * plain`call` is an unsafe replacement for a function call: use this
535      * function instead.
536      *
537      * If `target` reverts with a revert reason, it is bubbled up by this
538      * function (like regular Solidity function calls).
539      *
540      * Returns the raw returned data. To convert to the expected return value,
541      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
542      *
543      * Requirements:
544      *
545      * - `target` must be a contract.
546      * - calling `target` with `data` must not revert.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
551       return functionCall(target, data, "Address: low-level call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
556      * `errorMessage` as a fallback revert reason when `target` reverts.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, 0, errorMessage);
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
566      * but also transferring `value` wei to `target`.
567      *
568      * Requirements:
569      *
570      * - the calling contract must have an ETH balance of at least `value`.
571      * - the called Solidity function must be `payable`.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
576         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
581      * with `errorMessage` as a fallback revert reason when `target` reverts.
582      *
583      * _Available since v3.1._
584      */
585     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
586         require(address(this).balance >= value, "Address: insufficient balance for call");
587         require(isContract(target), "Address: call to non-contract");
588 
589         // solhint-disable-next-line avoid-low-level-calls
590         (bool success, bytes memory returndata) = target.call{ value: value }(data);
591         return _verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
611         require(isContract(target), "Address: static call to non-contract");
612 
613         // solhint-disable-next-line avoid-low-level-calls
614         (bool success, bytes memory returndata) = target.staticcall(data);
615         return _verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             // Look for revert reason and bubble it up if present
623             if (returndata.length > 0) {
624                 // The easiest way to bubble the revert reason is using memory via assembly
625 
626                 // solhint-disable-next-line no-inline-assembly
627                 assembly {
628                     let returndata_size := mload(returndata)
629                     revert(add(32, returndata), returndata_size)
630                 }
631             } else {
632                 revert(errorMessage);
633             }
634         }
635     }
636 }
637 
638 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
639 
640 pragma solidity >=0.6.0 <0.8.0;
641 
642 /**
643  * @dev Library for managing
644  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
645  * types.
646  *
647  * Sets have the following properties:
648  *
649  * - Elements are added, removed, and checked for existence in constant time
650  * (O(1)).
651  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
652  *
653  * ```
654  * contract Example {
655  *     // Add the library methods
656  *     using EnumerableSet for EnumerableSet.AddressSet;
657  *
658  *     // Declare a set state variable
659  *     EnumerableSet.AddressSet private mySet;
660  * }
661  * ```
662  *
663  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
664  * and `uint256` (`UintSet`) are supported.
665  */
666 library EnumerableSet {
667     // To implement this library for multiple types with as little code
668     // repetition as possible, we write it in terms of a generic Set type with
669     // bytes32 values.
670     // The Set implementation uses private functions, and user-facing
671     // implementations (such as AddressSet) are just wrappers around the
672     // underlying Set.
673     // This means that we can only create new EnumerableSets for types that fit
674     // in bytes32.
675 
676     struct Set {
677         // Storage of set values
678         bytes32[] _values;
679 
680         // Position of the value in the `values` array, plus 1 because index 0
681         // means a value is not in the set.
682         mapping (bytes32 => uint256) _indexes;
683     }
684 
685     /**
686      * @dev Add a value to a set. O(1).
687      *
688      * Returns true if the value was added to the set, that is if it was not
689      * already present.
690      */
691     function _add(Set storage set, bytes32 value) private returns (bool) {
692         if (!_contains(set, value)) {
693             set._values.push(value);
694             // The value is stored at length-1, but we add 1 to all indexes
695             // and use 0 as a sentinel value
696             set._indexes[value] = set._values.length;
697             return true;
698         } else {
699             return false;
700         }
701     }
702 
703     /**
704      * @dev Removes a value from a set. O(1).
705      *
706      * Returns true if the value was removed from the set, that is if it was
707      * present.
708      */
709     function _remove(Set storage set, bytes32 value) private returns (bool) {
710         // We read and store the value's index to prevent multiple reads from the same storage slot
711         uint256 valueIndex = set._indexes[value];
712 
713         if (valueIndex != 0) { // Equivalent to contains(set, value)
714             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
715             // the array, and then remove the last element (sometimes called as 'swap and pop').
716             // This modifies the order of the array, as noted in {at}.
717 
718             uint256 toDeleteIndex = valueIndex - 1;
719             uint256 lastIndex = set._values.length - 1;
720 
721             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
722             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
723 
724             bytes32 lastvalue = set._values[lastIndex];
725 
726             // Move the last value to the index where the value to delete is
727             set._values[toDeleteIndex] = lastvalue;
728             // Update the index for the moved value
729             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
730 
731             // Delete the slot where the moved value was stored
732             set._values.pop();
733 
734             // Delete the index for the deleted slot
735             delete set._indexes[value];
736 
737             return true;
738         } else {
739             return false;
740         }
741     }
742 
743     /**
744      * @dev Returns true if the value is in the set. O(1).
745      */
746     function _contains(Set storage set, bytes32 value) private view returns (bool) {
747         return set._indexes[value] != 0;
748     }
749 
750     /**
751      * @dev Returns the number of values on the set. O(1).
752      */
753     function _length(Set storage set) private view returns (uint256) {
754         return set._values.length;
755     }
756 
757    /**
758     * @dev Returns the value stored at position `index` in the set. O(1).
759     *
760     * Note that there are no guarantees on the ordering of values inside the
761     * array, and it may change when more values are added or removed.
762     *
763     * Requirements:
764     *
765     * - `index` must be strictly less than {length}.
766     */
767     function _at(Set storage set, uint256 index) private view returns (bytes32) {
768         require(set._values.length > index, "EnumerableSet: index out of bounds");
769         return set._values[index];
770     }
771 
772     // Bytes32Set
773 
774     struct Bytes32Set {
775         Set _inner;
776     }
777 
778     /**
779      * @dev Add a value to a set. O(1).
780      *
781      * Returns true if the value was added to the set, that is if it was not
782      * already present.
783      */
784     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
785         return _add(set._inner, value);
786     }
787 
788     /**
789      * @dev Removes a value from a set. O(1).
790      *
791      * Returns true if the value was removed from the set, that is if it was
792      * present.
793      */
794     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
795         return _remove(set._inner, value);
796     }
797 
798     /**
799      * @dev Returns true if the value is in the set. O(1).
800      */
801     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
802         return _contains(set._inner, value);
803     }
804 
805     /**
806      * @dev Returns the number of values in the set. O(1).
807      */
808     function length(Bytes32Set storage set) internal view returns (uint256) {
809         return _length(set._inner);
810     }
811 
812    /**
813     * @dev Returns the value stored at position `index` in the set. O(1).
814     *
815     * Note that there are no guarantees on the ordering of values inside the
816     * array, and it may change when more values are added or removed.
817     *
818     * Requirements:
819     *
820     * - `index` must be strictly less than {length}.
821     */
822     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
823         return _at(set._inner, index);
824     }
825 
826     // AddressSet
827 
828     struct AddressSet {
829         Set _inner;
830     }
831 
832     /**
833      * @dev Add a value to a set. O(1).
834      *
835      * Returns true if the value was added to the set, that is if it was not
836      * already present.
837      */
838     function add(AddressSet storage set, address value) internal returns (bool) {
839         return _add(set._inner, bytes32(uint256(value)));
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the value was removed from the set, that is if it was
846      * present.
847      */
848     function remove(AddressSet storage set, address value) internal returns (bool) {
849         return _remove(set._inner, bytes32(uint256(value)));
850     }
851 
852     /**
853      * @dev Returns true if the value is in the set. O(1).
854      */
855     function contains(AddressSet storage set, address value) internal view returns (bool) {
856         return _contains(set._inner, bytes32(uint256(value)));
857     }
858 
859     /**
860      * @dev Returns the number of values in the set. O(1).
861      */
862     function length(AddressSet storage set) internal view returns (uint256) {
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
876     function at(AddressSet storage set, uint256 index) internal view returns (address) {
877         return address(uint256(_at(set._inner, index)));
878     }
879 
880 
881     // UintSet
882 
883     struct UintSet {
884         Set _inner;
885     }
886 
887     /**
888      * @dev Add a value to a set. O(1).
889      *
890      * Returns true if the value was added to the set, that is if it was not
891      * already present.
892      */
893     function add(UintSet storage set, uint256 value) internal returns (bool) {
894         return _add(set._inner, bytes32(value));
895     }
896 
897     /**
898      * @dev Removes a value from a set. O(1).
899      *
900      * Returns true if the value was removed from the set, that is if it was
901      * present.
902      */
903     function remove(UintSet storage set, uint256 value) internal returns (bool) {
904         return _remove(set._inner, bytes32(value));
905     }
906 
907     /**
908      * @dev Returns true if the value is in the set. O(1).
909      */
910     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
911         return _contains(set._inner, bytes32(value));
912     }
913 
914     /**
915      * @dev Returns the number of values on the set. O(1).
916      */
917     function length(UintSet storage set) internal view returns (uint256) {
918         return _length(set._inner);
919     }
920 
921    /**
922     * @dev Returns the value stored at position `index` in the set. O(1).
923     *
924     * Note that there are no guarantees on the ordering of values inside the
925     * array, and it may change when more values are added or removed.
926     *
927     * Requirements:
928     *
929     * - `index` must be strictly less than {length}.
930     */
931     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
932         return uint256(_at(set._inner, index));
933     }
934 }
935 
936 // File: node_modules\@openzeppelin\contracts\utils\EnumerableMap.sol
937 
938 pragma solidity >=0.6.0 <0.8.0;
939 
940 /**
941  * @dev Library for managing an enumerable variant of Solidity's
942  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
943  * type.
944  *
945  * Maps have the following properties:
946  *
947  * - Entries are added, removed, and checked for existence in constant time
948  * (O(1)).
949  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
950  *
951  * ```
952  * contract Example {
953  *     // Add the library methods
954  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
955  *
956  *     // Declare a set state variable
957  *     EnumerableMap.UintToAddressMap private myMap;
958  * }
959  * ```
960  *
961  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
962  * supported.
963  */
964 library EnumerableMap {
965     // To implement this library for multiple types with as little code
966     // repetition as possible, we write it in terms of a generic Map type with
967     // bytes32 keys and values.
968     // The Map implementation uses private functions, and user-facing
969     // implementations (such as Uint256ToAddressMap) are just wrappers around
970     // the underlying Map.
971     // This means that we can only create new EnumerableMaps for types that fit
972     // in bytes32.
973 
974     struct MapEntry {
975         bytes32 _key;
976         bytes32 _value;
977     }
978 
979     struct Map {
980         // Storage of map keys and values
981         MapEntry[] _entries;
982 
983         // Position of the entry defined by a key in the `entries` array, plus 1
984         // because index 0 means a key is not in the map.
985         mapping (bytes32 => uint256) _indexes;
986     }
987 
988     /**
989      * @dev Adds a key-value pair to a map, or updates the value for an existing
990      * key. O(1).
991      *
992      * Returns true if the key was added to the map, that is if it was not
993      * already present.
994      */
995     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
996         // We read and store the key's index to prevent multiple reads from the same storage slot
997         uint256 keyIndex = map._indexes[key];
998 
999         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1000             map._entries.push(MapEntry({ _key: key, _value: value }));
1001             // The entry is stored at length-1, but we add 1 to all indexes
1002             // and use 0 as a sentinel value
1003             map._indexes[key] = map._entries.length;
1004             return true;
1005         } else {
1006             map._entries[keyIndex - 1]._value = value;
1007             return false;
1008         }
1009     }
1010 
1011     /**
1012      * @dev Removes a key-value pair from a map. O(1).
1013      *
1014      * Returns true if the key was removed from the map, that is if it was present.
1015      */
1016     function _remove(Map storage map, bytes32 key) private returns (bool) {
1017         // We read and store the key's index to prevent multiple reads from the same storage slot
1018         uint256 keyIndex = map._indexes[key];
1019 
1020         if (keyIndex != 0) { // Equivalent to contains(map, key)
1021             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1022             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1023             // This modifies the order of the array, as noted in {at}.
1024 
1025             uint256 toDeleteIndex = keyIndex - 1;
1026             uint256 lastIndex = map._entries.length - 1;
1027 
1028             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1029             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1030 
1031             MapEntry storage lastEntry = map._entries[lastIndex];
1032 
1033             // Move the last entry to the index where the entry to delete is
1034             map._entries[toDeleteIndex] = lastEntry;
1035             // Update the index for the moved entry
1036             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1037 
1038             // Delete the slot where the moved entry was stored
1039             map._entries.pop();
1040 
1041             // Delete the index for the deleted slot
1042             delete map._indexes[key];
1043 
1044             return true;
1045         } else {
1046             return false;
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns true if the key is in the map. O(1).
1052      */
1053     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1054         return map._indexes[key] != 0;
1055     }
1056 
1057     /**
1058      * @dev Returns the number of key-value pairs in the map. O(1).
1059      */
1060     function _length(Map storage map) private view returns (uint256) {
1061         return map._entries.length;
1062     }
1063 
1064    /**
1065     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1066     *
1067     * Note that there are no guarantees on the ordering of entries inside the
1068     * array, and it may change when more entries are added or removed.
1069     *
1070     * Requirements:
1071     *
1072     * - `index` must be strictly less than {length}.
1073     */
1074     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1075         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1076 
1077         MapEntry storage entry = map._entries[index];
1078         return (entry._key, entry._value);
1079     }
1080 
1081     /**
1082      * @dev Returns the value associated with `key`.  O(1).
1083      *
1084      * Requirements:
1085      *
1086      * - `key` must be in the map.
1087      */
1088     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1089         return _get(map, key, "EnumerableMap: nonexistent key");
1090     }
1091 
1092     /**
1093      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1094      */
1095     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1096         uint256 keyIndex = map._indexes[key];
1097         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1098         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1099     }
1100 
1101     // UintToAddressMap
1102 
1103     struct UintToAddressMap {
1104         Map _inner;
1105     }
1106 
1107     /**
1108      * @dev Adds a key-value pair to a map, or updates the value for an existing
1109      * key. O(1).
1110      *
1111      * Returns true if the key was added to the map, that is if it was not
1112      * already present.
1113      */
1114     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1115         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1116     }
1117 
1118     /**
1119      * @dev Removes a value from a set. O(1).
1120      *
1121      * Returns true if the key was removed from the map, that is if it was present.
1122      */
1123     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1124         return _remove(map._inner, bytes32(key));
1125     }
1126 
1127     /**
1128      * @dev Returns true if the key is in the map. O(1).
1129      */
1130     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1131         return _contains(map._inner, bytes32(key));
1132     }
1133 
1134     /**
1135      * @dev Returns the number of elements in the map. O(1).
1136      */
1137     function length(UintToAddressMap storage map) internal view returns (uint256) {
1138         return _length(map._inner);
1139     }
1140 
1141    /**
1142     * @dev Returns the element stored at position `index` in the set. O(1).
1143     * Note that there are no guarantees on the ordering of values inside the
1144     * array, and it may change when more values are added or removed.
1145     *
1146     * Requirements:
1147     *
1148     * - `index` must be strictly less than {length}.
1149     */
1150     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1151         (bytes32 key, bytes32 value) = _at(map._inner, index);
1152         return (uint256(key), address(uint256(value)));
1153     }
1154 
1155     /**
1156      * @dev Returns the value associated with `key`.  O(1).
1157      *
1158      * Requirements:
1159      *
1160      * - `key` must be in the map.
1161      */
1162     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1163         return address(uint256(_get(map._inner, bytes32(key))));
1164     }
1165 
1166     /**
1167      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1168      */
1169     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1170         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1171     }
1172 }
1173 
1174 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
1175 
1176 pragma solidity >=0.6.0 <0.8.0;
1177 
1178 /**
1179  * @dev String operations.
1180  */
1181 library Strings {
1182     /**
1183      * @dev Converts a `uint256` to its ASCII `string` representation.
1184      */
1185     function toString(uint256 value) internal pure returns (string memory) {
1186         // Inspired by OraclizeAPI's implementation - MIT licence
1187         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1188 
1189         if (value == 0) {
1190             return "0";
1191         }
1192         uint256 temp = value;
1193         uint256 digits;
1194         while (temp != 0) {
1195             digits++;
1196             temp /= 10;
1197         }
1198         bytes memory buffer = new bytes(digits);
1199         uint256 index = digits - 1;
1200         temp = value;
1201         while (temp != 0) {
1202             buffer[index--] = byte(uint8(48 + temp % 10));
1203             temp /= 10;
1204         }
1205         return string(buffer);
1206     }
1207 }
1208 
1209 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
1210 
1211 pragma solidity >=0.6.0 <0.8.0;
1212 
1213 
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
1224 /**
1225  * @title ERC721 Non-Fungible Token Standard basic implementation
1226  * @dev see https://eips.ethereum.org/EIPS/eip-721
1227  */
1228 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1229     using SafeMath for uint256;
1230     using Address for address;
1231     using EnumerableSet for EnumerableSet.UintSet;
1232     using EnumerableMap for EnumerableMap.UintToAddressMap;
1233     using Strings for uint256;
1234 
1235     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1236     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1237     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1238 
1239     // Mapping from holder address to their (enumerable) set of owned tokens
1240     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1241 
1242     // Enumerable mapping from token ids to their owners
1243     EnumerableMap.UintToAddressMap private _tokenOwners;
1244 
1245     // Mapping from token ID to approved address
1246     mapping (uint256 => address) private _tokenApprovals;
1247 
1248     // Mapping from owner to operator approvals
1249     mapping (address => mapping (address => bool)) private _operatorApprovals;
1250 
1251     // Token name
1252     string private _name;
1253 
1254     // Token symbol
1255     string private _symbol;
1256 
1257     // Optional mapping for token URIs
1258     mapping (uint256 => string) private _tokenURIs;
1259 
1260     // Base URI
1261     string private _baseURI;
1262 
1263     /*
1264      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1265      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1266      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1267      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1268      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1269      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1270      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1271      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1272      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1273      *
1274      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1275      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1276      */
1277     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1278 
1279     /*
1280      *     bytes4(keccak256('name()')) == 0x06fdde03
1281      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1282      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1283      *
1284      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1285      */
1286     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1287 
1288     /*
1289      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1290      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1291      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1292      *
1293      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1294      */
1295     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1296 
1297     /**
1298      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1299      */
1300     constructor (string memory name_, string memory symbol_) public {
1301         _name = name_;
1302         _symbol = symbol_;
1303 
1304         // register the supported interfaces to conform to ERC721 via ERC165
1305         _registerInterface(_INTERFACE_ID_ERC721);
1306         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1307         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1308     }
1309 
1310     /**
1311      * @dev See {IERC721-balanceOf}.
1312      */
1313     function balanceOf(address owner) public view override returns (uint256) {
1314         require(owner != address(0), "ERC721: balance query for the zero address");
1315 
1316         return _holderTokens[owner].length();
1317     }
1318 
1319     /**
1320      * @dev See {IERC721-ownerOf}.
1321      */
1322     function ownerOf(uint256 tokenId) public view override returns (address) {
1323         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1324     }
1325 
1326     /**
1327      * @dev See {IERC721Metadata-name}.
1328      */
1329     function name() public view override returns (string memory) {
1330         return _name;
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Metadata-symbol}.
1335      */
1336     function symbol() public view override returns (string memory) {
1337         return _symbol;
1338     }
1339 
1340     /**
1341      * @dev See {IERC721Metadata-tokenURI}.
1342      */
1343     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1344         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1345 
1346         string memory _tokenURI = _tokenURIs[tokenId];
1347 
1348         // If there is no base URI, return the token URI.
1349         if (bytes(_baseURI).length == 0) {
1350             return _tokenURI;
1351         }
1352         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1353         if (bytes(_tokenURI).length > 0) {
1354             return string(abi.encodePacked(_baseURI, _tokenURI));
1355         }
1356         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1357         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1358     }
1359 
1360     /**
1361     * @dev Returns the base URI set via {_setBaseURI}. This will be
1362     * automatically added as a prefix in {tokenURI} to each token's URI, or
1363     * to the token ID if no specific URI is set for that token ID.
1364     */
1365     function baseURI() public view returns (string memory) {
1366         return _baseURI;
1367     }
1368 
1369     /**
1370      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1371      */
1372     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1373         return _holderTokens[owner].at(index);
1374     }
1375 
1376     /**
1377      * @dev See {IERC721Enumerable-totalSupply}.
1378      */
1379     function totalSupply() public view override returns (uint256) {
1380         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1381         return _tokenOwners.length();
1382     }
1383 
1384     /**
1385      * @dev See {IERC721Enumerable-tokenByIndex}.
1386      */
1387     function tokenByIndex(uint256 index) public view override returns (uint256) {
1388         (uint256 tokenId, ) = _tokenOwners.at(index);
1389         return tokenId;
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-approve}.
1394      */
1395     function approve(address to, uint256 tokenId) public virtual override {
1396         address owner = ownerOf(tokenId);
1397         require(to != owner, "ERC721: approval to current owner");
1398 
1399         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1400             "ERC721: approve caller is not owner nor approved for all"
1401         );
1402 
1403         _approve(to, tokenId);
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-getApproved}.
1408      */
1409     function getApproved(uint256 tokenId) public view override returns (address) {
1410         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1411 
1412         return _tokenApprovals[tokenId];
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-setApprovalForAll}.
1417      */
1418     function setApprovalForAll(address operator, bool approved) public virtual override {
1419         require(operator != _msgSender(), "ERC721: approve to caller");
1420 
1421         _operatorApprovals[_msgSender()][operator] = approved;
1422         emit ApprovalForAll(_msgSender(), operator, approved);
1423     }
1424 
1425     /**
1426      * @dev See {IERC721-isApprovedForAll}.
1427      */
1428     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1429         return _operatorApprovals[owner][operator];
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-transferFrom}.
1434      */
1435     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1436         //solhint-disable-next-line max-line-length
1437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1438 
1439         _transfer(from, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-safeTransferFrom}.
1444      */
1445     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1446         safeTransferFrom(from, to, tokenId, "");
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-safeTransferFrom}.
1451      */
1452     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1453         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1454         _safeTransfer(from, to, tokenId, _data);
1455     }
1456 
1457     /**
1458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1460      *
1461      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1462      *
1463      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1464      * implement alternative mechanisms to perform token transfer, such as signature-based.
1465      *
1466      * Requirements:
1467      *
1468      * - `from` cannot be the zero address.
1469      * - `to` cannot be the zero address.
1470      * - `tokenId` token must exist and be owned by `from`.
1471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1472      *
1473      * Emits a {Transfer} event.
1474      */
1475     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1476         _transfer(from, to, tokenId);
1477         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1478     }
1479 
1480     /**
1481      * @dev Returns whether `tokenId` exists.
1482      *
1483      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1484      *
1485      * Tokens start existing when they are minted (`_mint`),
1486      * and stop existing when they are burned (`_burn`).
1487      */
1488     function _exists(uint256 tokenId) internal view returns (bool) {
1489         return _tokenOwners.contains(tokenId);
1490     }
1491 
1492     /**
1493      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1494      *
1495      * Requirements:
1496      *
1497      * - `tokenId` must exist.
1498      */
1499     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1500         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1501         address owner = ownerOf(tokenId);
1502         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1503     }
1504 
1505     /**
1506      * @dev Safely mints `tokenId` and transfers it to `to`.
1507      *
1508      * Requirements:
1509      d*
1510      * - `tokenId` must not exist.
1511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _safeMint(address to, uint256 tokenId) internal virtual {
1516         _safeMint(to, tokenId, "");
1517     }
1518 
1519     /**
1520      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1521      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1522      */
1523     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1524         _mint(to, tokenId);
1525         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1526     }
1527 
1528     /**
1529      * @dev Mints `tokenId` and transfers it to `to`.
1530      *
1531      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1532      *
1533      * Requirements:
1534      *
1535      * - `tokenId` must not exist.
1536      * - `to` cannot be the zero address.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function _mint(address to, uint256 tokenId) internal virtual {
1541         require(to != address(0), "ERC721: mint to the zero address");
1542         require(!_exists(tokenId), "ERC721: token already minted");
1543 
1544         _beforeTokenTransfer(address(0), to, tokenId);
1545 
1546         _holderTokens[to].add(tokenId);
1547 
1548         _tokenOwners.set(tokenId, to);
1549 
1550         emit Transfer(address(0), to, tokenId);
1551     }
1552 
1553     /**
1554      * @dev Destroys `tokenId`.
1555      * The approval is cleared when the token is burned.
1556      *
1557      * Requirements:
1558      *
1559      * - `tokenId` must exist.
1560      *
1561      * Emits a {Transfer} event.
1562      */
1563     function _burn(uint256 tokenId) internal virtual {
1564         address owner = ownerOf(tokenId);
1565 
1566         _beforeTokenTransfer(owner, address(0), tokenId);
1567 
1568         // Clear approvals
1569         _approve(address(0), tokenId);
1570 
1571         // Clear metadata (if any)
1572         if (bytes(_tokenURIs[tokenId]).length != 0) {
1573             delete _tokenURIs[tokenId];
1574         }
1575 
1576         _holderTokens[owner].remove(tokenId);
1577 
1578         _tokenOwners.remove(tokenId);
1579 
1580         emit Transfer(owner, address(0), tokenId);
1581     }
1582 
1583     /**
1584      * @dev Transfers `tokenId` from `from` to `to`.
1585      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1586      *
1587      * Requirements:
1588      *
1589      * - `to` cannot be the zero address.
1590      * - `tokenId` token must be owned by `from`.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1595         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1596         require(to != address(0), "ERC721: transfer to the zero address");
1597 
1598         _beforeTokenTransfer(from, to, tokenId);
1599 
1600         // Clear approvals from the previous owner
1601         _approve(address(0), tokenId);
1602 
1603         _holderTokens[from].remove(tokenId);
1604         _holderTokens[to].add(tokenId);
1605 
1606         _tokenOwners.set(tokenId, to);
1607 
1608         emit Transfer(from, to, tokenId);
1609     }
1610 
1611     /**
1612      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1613      *
1614      * Requirements:
1615      *
1616      * - `tokenId` must exist.
1617      */
1618     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1619         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1620         _tokenURIs[tokenId] = _tokenURI;
1621     }
1622 
1623     /**
1624      * @dev Internal function to set the base URI for all token IDs. It is
1625      * automatically added as a prefix to the value returned in {tokenURI},
1626      * or to the token ID if {tokenURI} is empty.
1627      */
1628     function _setBaseURI(string memory baseURI_) internal virtual {
1629         _baseURI = baseURI_;
1630     }
1631 
1632     /**
1633      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1634      * The call is not executed if the target address is not a contract.
1635      *
1636      * @param from address representing the previous owner of the given token ID
1637      * @param to target address that will receive the tokens
1638      * @param tokenId uint256 ID of the token to be transferred
1639      * @param _data bytes optional data to send along with the call
1640      * @return bool whether the call correctly returned the expected magic value
1641      */
1642     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1643         private returns (bool)
1644     {
1645         if (!to.isContract()) {
1646             return true;
1647         }
1648         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1649             IERC721Receiver(to).onERC721Received.selector,
1650             _msgSender(),
1651             from,
1652             tokenId,
1653             _data
1654         ), "ERC721: transfer to non ERC721Receiver implementer");
1655         bytes4 retval = abi.decode(returndata, (bytes4));
1656         return (retval == _ERC721_RECEIVED);
1657     }
1658 
1659     function _approve(address to, uint256 tokenId) private {
1660         _tokenApprovals[tokenId] = to;
1661         emit Approval(ownerOf(tokenId), to, tokenId);
1662     }
1663 
1664     /**
1665      * @dev Hook that is called before any token transfer. This includes minting
1666      * and burning.
1667      *
1668      * Calling conditions:
1669      *
1670      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1671      * transferred to `to`.
1672      * - When `from` is zero, `tokenId` will be minted for `to`.
1673      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1674      * - `from` cannot be the zero address.
1675      * - `to` cannot be the zero address.
1676      *
1677      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1678      */
1679     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1680 }
1681 
1682 // File: @openzeppelin\contracts\access\Ownable.sol
1683 
1684 pragma solidity >=0.6.0 <0.8.0;
1685 
1686 /**
1687  * @dev Contract module which provides a basic access control mechanism, where
1688  * there is an account (an owner) that can be granted exclusive access to
1689  * specific functions.
1690  *
1691  * By default, the owner account will be the one that deploys the contract. This
1692  * can later be changed with {transferOwnership}.
1693  *
1694  * This module is used through inheritance. It will make available the modifier
1695  * `onlyOwner`, which can be applied to your functions to restrict their use to
1696  * the owner.
1697  */
1698 abstract contract Ownable is Context {
1699     address private _owner;
1700 
1701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1702 
1703     /**
1704      * @dev Initializes the contract setting the deployer as the initial owner.
1705      */
1706     constructor () internal {
1707         address msgSender = _msgSender();
1708         _owner = msgSender;
1709         emit OwnershipTransferred(address(0), msgSender);
1710     }
1711 
1712     /**
1713      * @dev Returns the address of the current owner.
1714      */
1715     function owner() public view returns (address) {
1716         return _owner;
1717     }
1718 
1719     /**
1720      * @dev Throws if called by any account other than the owner.
1721      */
1722     modifier onlyOwner() {
1723         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1724         _;
1725     }
1726 
1727     /**
1728      * @dev Leaves the contract without owner. It will not be possible to call
1729      * `onlyOwner` functions anymore. Can only be called by the current owner.
1730      *
1731      * NOTE: Renouncing ownership will leave the contract without an owner,
1732      * thereby removing any functionality that is only available to the owner.
1733      */
1734     function renounceOwnership() public virtual onlyOwner {
1735         emit OwnershipTransferred(_owner, address(0));
1736         _owner = address(0);
1737     }
1738 
1739     /**
1740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1741      * Can only be called by the current owner.
1742      */
1743     function transferOwnership(address newOwner) public virtual onlyOwner {
1744         require(newOwner != address(0), "Ownable: new owner is the zero address");
1745         emit OwnershipTransferred(_owner, newOwner);
1746         _owner = newOwner;
1747     }
1748 }
1749 
1750 // File: contracts\NFTRedZone.sol
1751 
1752 
1753 pragma solidity 0.7.6;
1754 pragma abicoder v2;
1755 
1756 contract NFTRedZone is ERC721, Ownable {
1757     using SafeMath for uint256;
1758 
1759     struct Whitelist {
1760         bool approved;
1761         uint256 minted;
1762     }
1763 
1764     uint256 constant public TOTAL_TOKEN_TO_MINT = 7216;
1765     uint256 constant public TOTAL_USER_ELIGIBLE_FOR_REFUND = 1400;
1766     uint256 constant public WHITELIST_MINT_PER_USER = 20;
1767     uint256 constant public ITEM_PRICE = 0.07 ether; // 0.07 ETH;
1768     bool public isSaleActive;
1769     bool public isPreSaleActive;
1770     bool public isBurnRefundActive;
1771 	uint256 public mintedTokens;
1772 	uint256 public burnedTokens;
1773     uint256 public startingIpfsId;
1774     address public fundWallet;
1775     uint256 private _lastIpfsId;
1776 
1777     mapping(address => Whitelist) public whitelistInfo;
1778 
1779     modifier beforeMint(uint256 _howMany) {
1780 	    require(_howMany > 0, "NFTRedZone: Minimum 1 tokens need to be minted");
1781 	    require(_howMany <= tokenRemainingToBeMinted(), "NFTRedZone: Mint amount is greater than the token available");
1782 		require(_howMany <= 20, "NFTRedZone: Max 20 tokens at once");
1783 		require(ITEM_PRICE.mul(_howMany) == msg.value, "NFTRedZone: Insufficient ETH to mint");
1784         _;
1785     }
1786 
1787     constructor (string memory _tokenBaseUri, address _fundWallet) ERC721("NFT RedZone", "NFTRZ") {
1788         _setBaseURI(_tokenBaseUri);
1789         fundWallet = _fundWallet;
1790     }
1791 
1792     ////////////////////
1793     // Action methods //
1794     ////////////////////
1795 
1796 	function mintNFTRZ(uint256 _howMany) beforeMint(_howMany) external payable {
1797         require(isSaleActive, "NFTRedZone: Sale is not active");
1798 		for (uint256 i = 0; i < _howMany; i++) {
1799 			_mintNFTRZ(_msgSender());
1800 		}
1801 	}
1802 
1803     function presaleMint(uint256 _howMany) beforeMint(_howMany) external payable {
1804         require(isPreSaleActive, "NFTRedZone: Presale is not active");
1805 	    require(isWhitelisted(_msgSender()), "NFTRedZone: You are not whitelist to mint in presale");
1806         require(whitelistUserMint(_msgSender()) < WHITELIST_MINT_PER_USER, "NFTRedZone: Presale max limit exceeds");
1807 		for (uint256 i = 0; i < _howMany; i++) {
1808             require(whitelistUserMint(_msgSender()) < WHITELIST_MINT_PER_USER, "NFTRedZone: Presale max limit exceeds");
1809             _mintNFTRZ(_msgSender());
1810             whitelistInfo[_msgSender()].minted++;
1811 		}
1812 	}
1813     
1814     function _mintNFTRZ(address _to) private {
1815         if(mintedTokens == 0) {
1816             _lastIpfsId = random(1, TOTAL_TOKEN_TO_MINT, uint256(uint160(address(_msgSender()))) + 1);
1817             startingIpfsId = _lastIpfsId;
1818         } else {
1819             _lastIpfsId = getIpfsIdToMint();
1820         }
1821         mintedTokens++;
1822         require(!_exists(mintedTokens), "NFTRedZone: Token already exist.");
1823         _mint(_to, mintedTokens);
1824         _setTokenURI(mintedTokens, uint2str(_lastIpfsId));
1825     }
1826 
1827     function uint2str(uint256 _i) private pure returns (string memory _uintAsString) {
1828 		if (_i == 0) {
1829 			return "0";
1830 		}
1831 		uint256 j = _i;
1832 		uint256 len;
1833 		while (j != 0) {
1834 			len++;
1835 			j /= 10;
1836 		}
1837 		bytes memory bstr = new bytes(len);
1838 		uint256 k = len;
1839 		while (_i != 0) {
1840 			k = k - 1;
1841 			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
1842 			bytes1 b1 = bytes1(temp);
1843 			bstr[k] = b1;
1844 			_i /= 10;
1845 		}
1846 		return string(bstr);
1847 	}
1848 
1849     function burn(uint256 tokenId) public {
1850         require(_exists(tokenId), "NFTRedZone: token does not exist.");
1851         require(_isApprovedOrOwner(_msgSender(), tokenId), "NFTRedZone: caller is not owner nor approved");
1852         _burn(tokenId);
1853     }
1854 
1855     function burnRefund(uint256 tokenId) public {
1856         require(isBurnRefundActive, "NFTRedZone: Feature is not active");
1857 	    require(burnedTokens < TOTAL_USER_ELIGIBLE_FOR_REFUND, "NFTRedZone: Maximum token have been burned to claim refund");
1858         burn(tokenId);
1859         burnedTokens++;
1860         payable(_msgSender()).transfer(ITEM_PRICE);
1861     }
1862 
1863     ///////////////////
1864     // Query methods //
1865     ///////////////////
1866 
1867     function exists(uint256 _tokenId) external view returns (bool) {
1868         return _exists(_tokenId);
1869     }
1870 
1871     function isWhitelisted(address _address) public view returns(bool) {
1872         return whitelistInfo[_address].approved;
1873     }
1874 
1875     function whitelistUserMint(address _address) public view returns(uint256) {
1876         return whitelistInfo[_address].minted;
1877     }
1878     
1879     function tokenRemainingToBeMinted() public view returns (uint256) {
1880         return TOTAL_TOKEN_TO_MINT.sub(mintedTokens);
1881     }
1882 
1883     function isAllTokenMinted() public view returns (bool) {
1884         return mintedTokens == TOTAL_TOKEN_TO_MINT;
1885     }
1886 
1887     function getIpfsIdToMint() public view returns(uint256 _nextIpfsId) {
1888         require(!isAllTokenMinted(), "NFTRedZone: All tokens have been minted");
1889         if(_lastIpfsId == TOTAL_TOKEN_TO_MINT && mintedTokens < TOTAL_TOKEN_TO_MINT) {
1890             _nextIpfsId = 1;
1891         } else if(mintedTokens < TOTAL_TOKEN_TO_MINT) {
1892             _nextIpfsId = _lastIpfsId + 1;
1893         }
1894     }
1895 
1896     function isApprovedOrOwner(address _spender, uint256 _tokenId) external view returns (bool) {
1897         return _isApprovedOrOwner(_spender, _tokenId);
1898     }
1899 
1900     //random number
1901 	function random(
1902 		uint256 from,
1903 		uint256 to,
1904 		uint256 salty
1905 	) public view returns (uint256) {
1906 		uint256 seed =
1907 			uint256(
1908 				keccak256(
1909 					abi.encodePacked(
1910 						block.timestamp +
1911 							block.difficulty +
1912 							((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1913 							block.gaslimit +
1914 							((uint256(keccak256(abi.encodePacked(_msgSender())))) / (block.timestamp)) +
1915 							block.number +
1916 							salty
1917 					)
1918 				)
1919 			);
1920 		return seed.mod(to - from) + from;
1921 	}
1922 
1923     /////////////
1924     // Setters //
1925     /////////////
1926 
1927     function addToWhitelistMultiple(address[] memory _addresses) external onlyOwner {
1928         for(uint256 i = 0; i < _addresses.length; i++) {
1929             addToWhitelist(_addresses[i]);
1930         }
1931     }
1932 
1933     function addToWhitelist(address _address) public onlyOwner {
1934         whitelistInfo[_address].approved = true;
1935     }
1936 
1937     function removeFromWhitelist(address _address) external onlyOwner {
1938         whitelistInfo[_address].approved = false;
1939     }
1940 
1941     function stopSale() external onlyOwner {
1942         isSaleActive = false;
1943     }
1944 
1945     function startSale() external onlyOwner {
1946         isSaleActive = true;
1947     }
1948 
1949     function startPreSale() external onlyOwner {
1950         isPreSaleActive = true;
1951     }
1952 
1953     function stopPreSale() external onlyOwner {
1954         isPreSaleActive = false;
1955     }
1956 
1957     function startBurnRefund() external onlyOwner {
1958         isBurnRefundActive = true;
1959     }
1960 
1961     function stopBurnRefund() external onlyOwner {
1962         isBurnRefundActive = false;
1963     }
1964 
1965     function changeFundWallet(address _fundWallet) external onlyOwner {
1966         fundWallet = _fundWallet;
1967     }
1968 
1969     function withdrawETH(uint256 _amount) external onlyOwner {
1970         payable(fundWallet).transfer(_amount);
1971     }
1972 
1973     function setTokenURI(uint256 _tokenId, string memory _uri) external onlyOwner {
1974         _setTokenURI(_tokenId, _uri);
1975     }
1976 
1977     function setBaseURI(string memory _baseURI) external onlyOwner {
1978         _setBaseURI(_baseURI);
1979     }
1980 
1981     function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual override(ERC721) {
1982         super._beforeTokenTransfer(_from, _to, _tokenId);
1983     }
1984     
1985     receive() payable external {
1986     }
1987 }