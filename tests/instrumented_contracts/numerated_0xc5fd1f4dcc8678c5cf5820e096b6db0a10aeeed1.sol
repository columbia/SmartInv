1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
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
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(address from, address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(address from, address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId) external view returns (address operator);
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
153      *
154      * See {setApprovalForAll}
155      */
156     function isApprovedForAll(address owner, address operator) external view returns (bool);
157 
158     /**
159       * @dev Safely transfers `tokenId` token from `from` to `to`.
160       *
161       * Requirements:
162       *
163       * - `from` cannot be the zero address.
164       * - `to` cannot be the zero address.
165       * - `tokenId` token must exist and be owned by `from`.
166       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168       *
169       * Emits a {Transfer} event.
170       */
171     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
172 }
173 
174 
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
177  * @dev See https://eips.ethereum.org/EIPS/eip-721
178  */
179 interface IERC721Metadata is IERC721 {
180 
181     /**
182      * @dev Returns the token collection name.
183      */
184     function name() external view returns (string memory);
185 
186     /**
187      * @dev Returns the token collection symbol.
188      */
189     function symbol() external view returns (string memory);
190 
191     /**
192      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
193      */
194     function tokenURI(uint256 tokenId) external view returns (string memory);
195 }
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Enumerable is IERC721 {
203 
204     /**
205      * @dev Returns the total amount of tokens stored by the contract.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
211      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
212      */
213     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
214 
215     /**
216      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
217      * Use along with {totalSupply} to enumerate all tokens.
218      */
219     function tokenByIndex(uint256 index) external view returns (uint256);
220 }
221 
222 /**
223  * @title ERC721 token receiver interface
224  * @dev Interface for any contract that wants to support safeTransfers
225  * from ERC721 asset contracts.
226  */
227 interface IERC721Receiver {
228     /**
229      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
230      * by `operator` from `from`, this function is called.
231      *
232      * It must return its Solidity selector to confirm the token transfer.
233      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
234      *
235      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
236      */
237     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
238 }
239 
240 
241 /**
242  * @dev Implementation of the {IERC165} interface.
243  *
244  * Contracts may inherit from this and call {_registerInterface} to declare
245  * their support of an interface.
246  */
247 abstract contract ERC165 is IERC165 {
248     /*
249      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
250      */
251     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
252 
253     /**
254      * @dev Mapping of interface ids to whether or not it's supported.
255      */
256     mapping(bytes4 => bool) private _supportedInterfaces;
257 
258     constructor () {
259         // Derived contracts need only register support for their own interfaces,
260         // we register support for ERC165 itself here
261         _registerInterface(_INTERFACE_ID_ERC165);
262     }
263 
264     /**
265      * @dev See {IERC165-supportsInterface}.
266      *
267      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
268      */
269     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270         return _supportedInterfaces[interfaceId];
271     }
272 
273     /**
274      * @dev Registers the contract as an implementer of the interface defined by
275      * `interfaceId`. Support of the actual ERC165 interface is automatic and
276      * registering its interface id is not required.
277      *
278      * See {IERC165-supportsInterface}.
279      *
280      * Requirements:
281      *
282      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
283      */
284     function _registerInterface(bytes4 interfaceId) internal virtual {
285         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
286         _supportedInterfaces[interfaceId] = true;
287     }
288 }
289 
290 
291 /**
292  * @dev Wrappers over Solidity's arithmetic operations with added overflow
293  * checks.
294  *
295  * Arithmetic operations in Solidity wrap on overflow. This can easily result
296  * in bugs, because programmers usually assume that an overflow raises an
297  * error, which is the standard behavior in high level programming languages.
298  * `SafeMath` restores this intuition by reverting the transaction when an
299  * operation overflows.
300  *
301  * Using this library instead of the unchecked operations eliminates an entire
302  * class of bugs, so it's recommended to use it always.
303  */
304 library SafeMath {
305     /**
306      * @dev Returns the addition of two unsigned integers, with an overflow flag.
307      *
308      * _Available since v3.4._
309      */
310     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
311         uint256 c = a + b;
312         if (c < a) return (false, 0);
313         return (true, c);
314     }
315 
316     /**
317      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
318      *
319      * _Available since v3.4._
320      */
321     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
322         if (b > a) return (false, 0);
323         return (true, a - b);
324     }
325 
326     /**
327      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
328      *
329      * _Available since v3.4._
330      */
331     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
332         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
333         // benefit is lost if 'b' is also tested.
334         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
335         if (a == 0) return (true, 0);
336         uint256 c = a * b;
337         if (c / a != b) return (false, 0);
338         return (true, c);
339     }
340 
341     /**
342      * @dev Returns the division of two unsigned integers, with a division by zero flag.
343      *
344      * _Available since v3.4._
345      */
346     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
347         if (b == 0) return (false, 0);
348         return (true, a / b);
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
353      *
354      * _Available since v3.4._
355      */
356     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
357         if (b == 0) return (false, 0);
358         return (true, a % b);
359     }
360 
361     /**
362      * @dev Returns the addition of two unsigned integers, reverting on
363      * overflow.
364      *
365      * Counterpart to Solidity's `+` operator.
366      *
367      * Requirements:
368      *
369      * - Addition cannot overflow.
370      */
371     function add(uint256 a, uint256 b) internal pure returns (uint256) {
372         uint256 c = a + b;
373         require(c >= a, "SafeMath: addition overflow");
374         return c;
375     }
376 
377     /**
378      * @dev Returns the subtraction of two unsigned integers, reverting on
379      * overflow (when the result is negative).
380      *
381      * Counterpart to Solidity's `-` operator.
382      *
383      * Requirements:
384      *
385      * - Subtraction cannot overflow.
386      */
387     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
388         require(b <= a, "SafeMath: subtraction overflow");
389         return a - b;
390     }
391 
392     /**
393      * @dev Returns the multiplication of two unsigned integers, reverting on
394      * overflow.
395      *
396      * Counterpart to Solidity's `*` operator.
397      *
398      * Requirements:
399      *
400      * - Multiplication cannot overflow.
401      */
402     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
403         if (a == 0) return 0;
404         uint256 c = a * b;
405         require(c / a == b, "SafeMath: multiplication overflow");
406         return c;
407     }
408 
409     /**
410      * @dev Returns the integer division of two unsigned integers, reverting on
411      * division by zero. The result is rounded towards zero.
412      *
413      * Counterpart to Solidity's `/` operator. Note: this function uses a
414      * `revert` opcode (which leaves remaining gas untouched) while Solidity
415      * uses an invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function div(uint256 a, uint256 b) internal pure returns (uint256) {
422         require(b > 0, "SafeMath: division by zero");
423         return a / b;
424     }
425 
426     /**
427      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
428      * reverting when dividing by zero.
429      *
430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
431      * opcode (which leaves remaining gas untouched) while Solidity uses an
432      * invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
439         require(b > 0, "SafeMath: modulo by zero");
440         return a % b;
441     }
442 
443     /**
444      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
445      * overflow (when the result is negative).
446      *
447      * CAUTION: This function is deprecated because it requires allocating memory for the error
448      * message unnecessarily. For custom revert reasons use {trySub}.
449      *
450      * Counterpart to Solidity's `-` operator.
451      *
452      * Requirements:
453      *
454      * - Subtraction cannot overflow.
455      */
456     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
457         require(b <= a, errorMessage);
458         return a - b;
459     }
460 
461     /**
462      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
463      * division by zero. The result is rounded towards zero.
464      *
465      * CAUTION: This function is deprecated because it requires allocating memory for the error
466      * message unnecessarily. For custom revert reasons use {tryDiv}.
467      *
468      * Counterpart to Solidity's `/` operator. Note: this function uses a
469      * `revert` opcode (which leaves remaining gas untouched) while Solidity
470      * uses an invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      *
474      * - The divisor cannot be zero.
475      */
476     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
477         require(b > 0, errorMessage);
478         return a / b;
479     }
480 
481     /**
482      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
483      * reverting with custom message when dividing by zero.
484      *
485      * CAUTION: This function is deprecated because it requires allocating memory for the error
486      * message unnecessarily. For custom revert reasons use {tryMod}.
487      *
488      * Counterpart to Solidity's `%` operator. This function uses a `revert`
489      * opcode (which leaves remaining gas untouched) while Solidity uses an
490      * invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b > 0, errorMessage);
498         return a % b;
499     }
500 }
501 
502 
503 /**
504  * @dev Collection of functions related to the address type
505  */
506 library Address {
507     /**
508      * @dev Returns true if `account` is a contract.
509      *
510      * [IMPORTANT]
511      * ====
512      * It is unsafe to assume that an address for which this function returns
513      * false is an externally-owned account (EOA) and not a contract.
514      *
515      * Among others, `isContract` will return false for the following
516      * types of addresses:
517      *
518      *  - an externally-owned account
519      *  - a contract in construction
520      *  - an address where a contract will be created
521      *  - an address where a contract lived, but was destroyed
522      * ====
523      */
524     function isContract(address account) internal view returns (bool) {
525         // This method relies on extcodesize, which returns 0 for contracts in
526         // construction, since the code is only stored at the end of the
527         // constructor execution.
528 
529         uint256 size;
530         // solhint-disable-next-line no-inline-assembly
531         assembly { size := extcodesize(account) }
532         return size > 0;
533     }
534 
535     /**
536      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
537      * `recipient`, forwarding all available gas and reverting on errors.
538      *
539      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
540      * of certain opcodes, possibly making contracts go over the 2300 gas limit
541      * imposed by `transfer`, making them unable to receive funds via
542      * `transfer`. {sendValue} removes this limitation.
543      *
544      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
545      *
546      * IMPORTANT: because control is transferred to `recipient`, care must be
547      * taken to not create reentrancy vulnerabilities. Consider using
548      * {ReentrancyGuard} or the
549      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
550      */
551     function sendValue(address payable recipient, uint256 amount) internal {
552         require(address(this).balance >= amount, "Address: insufficient balance");
553 
554         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
555         (bool success, ) = recipient.call{ value: amount }("");
556         require(success, "Address: unable to send value, recipient may have reverted");
557     }
558 
559     /**
560      * @dev Performs a Solidity function call using a low level `call`. A
561      * plain`call` is an unsafe replacement for a function call: use this
562      * function instead.
563      *
564      * If `target` reverts with a revert reason, it is bubbled up by this
565      * function (like regular Solidity function calls).
566      *
567      * Returns the raw returned data. To convert to the expected return value,
568      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
569      *
570      * Requirements:
571      *
572      * - `target` must be a contract.
573      * - calling `target` with `data` must not revert.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
578       return functionCall(target, data, "Address: low-level call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
583      * `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, 0, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but also transferring `value` wei to `target`.
594      *
595      * Requirements:
596      *
597      * - the calling contract must have an ETH balance of at least `value`.
598      * - the called Solidity function must be `payable`.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
608      * with `errorMessage` as a fallback revert reason when `target` reverts.
609      *
610      * _Available since v3.1._
611      */
612     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
613         require(address(this).balance >= value, "Address: insufficient balance for call");
614         require(isContract(target), "Address: call to non-contract");
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = target.call{ value: value }(data);
618         return _verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
628         return functionStaticCall(target, data, "Address: low-level static call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
638         require(isContract(target), "Address: static call to non-contract");
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return _verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         // solhint-disable-next-line avoid-low-level-calls
665         (bool success, bytes memory returndata) = target.delegatecall(data);
666         return _verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
670         if (success) {
671             return returndata;
672         } else {
673             // Look for revert reason and bubble it up if present
674             if (returndata.length > 0) {
675                 // The easiest way to bubble the revert reason is using memory via assembly
676 
677                 // solhint-disable-next-line no-inline-assembly
678                 assembly {
679                     let returndata_size := mload(returndata)
680                     revert(add(32, returndata), returndata_size)
681                 }
682             } else {
683                 revert(errorMessage);
684             }
685         }
686     }
687 }
688 
689 
690 /**
691  * @dev Library for managing
692  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
693  * types.
694  *
695  * Sets have the following properties:
696  *
697  * - Elements are added, removed, and checked for existence in constant time
698  * (O(1)).
699  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
700  *
701  * ```
702  * contract Example {
703  *     // Add the library methods
704  *     using EnumerableSet for EnumerableSet.AddressSet;
705  *
706  *     // Declare a set state variable
707  *     EnumerableSet.AddressSet private mySet;
708  * }
709  * ```
710  *
711  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
712  * and `uint256` (`UintSet`) are supported.
713  */
714 library EnumerableSet {
715     // To implement this library for multiple types with as little code
716     // repetition as possible, we write it in terms of a generic Set type with
717     // bytes32 values.
718     // The Set implementation uses private functions, and user-facing
719     // implementations (such as AddressSet) are just wrappers around the
720     // underlying Set.
721     // This means that we can only create new EnumerableSets for types that fit
722     // in bytes32.
723 
724     struct Set {
725         // Storage of set values
726         bytes32[] _values;
727 
728         // Position of the value in the `values` array, plus 1 because index 0
729         // means a value is not in the set.
730         mapping (bytes32 => uint256) _indexes;
731     }
732 
733     /**
734      * @dev Add a value to a set. O(1).
735      *
736      * Returns true if the value was added to the set, that is if it was not
737      * already present.
738      */
739     function _add(Set storage set, bytes32 value) private returns (bool) {
740         if (!_contains(set, value)) {
741             set._values.push(value);
742             // The value is stored at length-1, but we add 1 to all indexes
743             // and use 0 as a sentinel value
744             set._indexes[value] = set._values.length;
745             return true;
746         } else {
747             return false;
748         }
749     }
750 
751     /**
752      * @dev Removes a value from a set. O(1).
753      *
754      * Returns true if the value was removed from the set, that is if it was
755      * present.
756      */
757     function _remove(Set storage set, bytes32 value) private returns (bool) {
758         // We read and store the value's index to prevent multiple reads from the same storage slot
759         uint256 valueIndex = set._indexes[value];
760 
761         if (valueIndex != 0) { // Equivalent to contains(set, value)
762             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
763             // the array, and then remove the last element (sometimes called as 'swap and pop').
764             // This modifies the order of the array, as noted in {at}.
765 
766             uint256 toDeleteIndex = valueIndex - 1;
767             uint256 lastIndex = set._values.length - 1;
768 
769             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
770             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
771 
772             bytes32 lastvalue = set._values[lastIndex];
773 
774             // Move the last value to the index where the value to delete is
775             set._values[toDeleteIndex] = lastvalue;
776             // Update the index for the moved value
777             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
778 
779             // Delete the slot where the moved value was stored
780             set._values.pop();
781 
782             // Delete the index for the deleted slot
783             delete set._indexes[value];
784 
785             return true;
786         } else {
787             return false;
788         }
789     }
790 
791     /**
792      * @dev Returns true if the value is in the set. O(1).
793      */
794     function _contains(Set storage set, bytes32 value) private view returns (bool) {
795         return set._indexes[value] != 0;
796     }
797 
798     /**
799      * @dev Returns the number of values on the set. O(1).
800      */
801     function _length(Set storage set) private view returns (uint256) {
802         return set._values.length;
803     }
804 
805    /**
806     * @dev Returns the value stored at position `index` in the set. O(1).
807     *
808     * Note that there are no guarantees on the ordering of values inside the
809     * array, and it may change when more values are added or removed.
810     *
811     * Requirements:
812     *
813     * - `index` must be strictly less than {length}.
814     */
815     function _at(Set storage set, uint256 index) private view returns (bytes32) {
816         require(set._values.length > index, "EnumerableSet: index out of bounds");
817         return set._values[index];
818     }
819 
820     // Bytes32Set
821 
822     struct Bytes32Set {
823         Set _inner;
824     }
825 
826     /**
827      * @dev Add a value to a set. O(1).
828      *
829      * Returns true if the value was added to the set, that is if it was not
830      * already present.
831      */
832     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
833         return _add(set._inner, value);
834     }
835 
836     /**
837      * @dev Removes a value from a set. O(1).
838      *
839      * Returns true if the value was removed from the set, that is if it was
840      * present.
841      */
842     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
843         return _remove(set._inner, value);
844     }
845 
846     /**
847      * @dev Returns true if the value is in the set. O(1).
848      */
849     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
850         return _contains(set._inner, value);
851     }
852 
853     /**
854      * @dev Returns the number of values in the set. O(1).
855      */
856     function length(Bytes32Set storage set) internal view returns (uint256) {
857         return _length(set._inner);
858     }
859 
860    /**
861     * @dev Returns the value stored at position `index` in the set. O(1).
862     *
863     * Note that there are no guarantees on the ordering of values inside the
864     * array, and it may change when more values are added or removed.
865     *
866     * Requirements:
867     *
868     * - `index` must be strictly less than {length}.
869     */
870     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
871         return _at(set._inner, index);
872     }
873 
874     // AddressSet
875 
876     struct AddressSet {
877         Set _inner;
878     }
879 
880     /**
881      * @dev Add a value to a set. O(1).
882      *
883      * Returns true if the value was added to the set, that is if it was not
884      * already present.
885      */
886     function add(AddressSet storage set, address value) internal returns (bool) {
887         return _add(set._inner, bytes32(uint256(uint160(value))));
888     }
889 
890     /**
891      * @dev Removes a value from a set. O(1).
892      *
893      * Returns true if the value was removed from the set, that is if it was
894      * present.
895      */
896     function remove(AddressSet storage set, address value) internal returns (bool) {
897         return _remove(set._inner, bytes32(uint256(uint160(value))));
898     }
899 
900     /**
901      * @dev Returns true if the value is in the set. O(1).
902      */
903     function contains(AddressSet storage set, address value) internal view returns (bool) {
904         return _contains(set._inner, bytes32(uint256(uint160(value))));
905     }
906 
907     /**
908      * @dev Returns the number of values in the set. O(1).
909      */
910     function length(AddressSet storage set) internal view returns (uint256) {
911         return _length(set._inner);
912     }
913 
914    /**
915     * @dev Returns the value stored at position `index` in the set. O(1).
916     *
917     * Note that there are no guarantees on the ordering of values inside the
918     * array, and it may change when more values are added or removed.
919     *
920     * Requirements:
921     *
922     * - `index` must be strictly less than {length}.
923     */
924     function at(AddressSet storage set, uint256 index) internal view returns (address) {
925         return address(uint160(uint256(_at(set._inner, index))));
926     }
927 
928 
929     // UintSet
930 
931     struct UintSet {
932         Set _inner;
933     }
934 
935     /**
936      * @dev Add a value to a set. O(1).
937      *
938      * Returns true if the value was added to the set, that is if it was not
939      * already present.
940      */
941     function add(UintSet storage set, uint256 value) internal returns (bool) {
942         return _add(set._inner, bytes32(value));
943     }
944 
945     /**
946      * @dev Removes a value from a set. O(1).
947      *
948      * Returns true if the value was removed from the set, that is if it was
949      * present.
950      */
951     function remove(UintSet storage set, uint256 value) internal returns (bool) {
952         return _remove(set._inner, bytes32(value));
953     }
954 
955     /**
956      * @dev Returns true if the value is in the set. O(1).
957      */
958     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
959         return _contains(set._inner, bytes32(value));
960     }
961 
962     /**
963      * @dev Returns the number of values on the set. O(1).
964      */
965     function length(UintSet storage set) internal view returns (uint256) {
966         return _length(set._inner);
967     }
968 
969    /**
970     * @dev Returns the value stored at position `index` in the set. O(1).
971     *
972     * Note that there are no guarantees on the ordering of values inside the
973     * array, and it may change when more values are added or removed.
974     *
975     * Requirements:
976     *
977     * - `index` must be strictly less than {length}.
978     */
979     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
980         return uint256(_at(set._inner, index));
981     }
982 }
983 
984 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
985 
986 /**
987  * @dev Library for managing an enumerable variant of Solidity's
988  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
989  * type.
990  *
991  * Maps have the following properties:
992  *
993  * - Entries are added, removed, and checked for existence in constant time
994  * (O(1)).
995  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
996  *
997  * ```
998  * contract Example {
999  *     // Add the library methods
1000  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1001  *
1002  *     // Declare a set state variable
1003  *     EnumerableMap.UintToAddressMap private myMap;
1004  * }
1005  * ```
1006  *
1007  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1008  * supported.
1009  */
1010 library EnumerableMap {
1011     // To implement this library for multiple types with as little code
1012     // repetition as possible, we write it in terms of a generic Map type with
1013     // bytes32 keys and values.
1014     // The Map implementation uses private functions, and user-facing
1015     // implementations (such as Uint256ToAddressMap) are just wrappers around
1016     // the underlying Map.
1017     // This means that we can only create new EnumerableMaps for types that fit
1018     // in bytes32.
1019 
1020     struct MapEntry {
1021         bytes32 _key;
1022         bytes32 _value;
1023     }
1024 
1025     struct Map {
1026         // Storage of map keys and values
1027         MapEntry[] _entries;
1028 
1029         // Position of the entry defined by a key in the `entries` array, plus 1
1030         // because index 0 means a key is not in the map.
1031         mapping (bytes32 => uint256) _indexes;
1032     }
1033 
1034     /**
1035      * @dev Adds a key-value pair to a map, or updates the value for an existing
1036      * key. O(1).
1037      *
1038      * Returns true if the key was added to the map, that is if it was not
1039      * already present.
1040      */
1041     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1042         // We read and store the key's index to prevent multiple reads from the same storage slot
1043         uint256 keyIndex = map._indexes[key];
1044 
1045         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1046             map._entries.push(MapEntry({ _key: key, _value: value }));
1047             // The entry is stored at length-1, but we add 1 to all indexes
1048             // and use 0 as a sentinel value
1049             map._indexes[key] = map._entries.length;
1050             return true;
1051         } else {
1052             map._entries[keyIndex - 1]._value = value;
1053             return false;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Removes a key-value pair from a map. O(1).
1059      *
1060      * Returns true if the key was removed from the map, that is if it was present.
1061      */
1062     function _remove(Map storage map, bytes32 key) private returns (bool) {
1063         // We read and store the key's index to prevent multiple reads from the same storage slot
1064         uint256 keyIndex = map._indexes[key];
1065 
1066         if (keyIndex != 0) { // Equivalent to contains(map, key)
1067             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1068             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1069             // This modifies the order of the array, as noted in {at}.
1070 
1071             uint256 toDeleteIndex = keyIndex - 1;
1072             uint256 lastIndex = map._entries.length - 1;
1073 
1074             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1075             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1076 
1077             MapEntry storage lastEntry = map._entries[lastIndex];
1078 
1079             // Move the last entry to the index where the entry to delete is
1080             map._entries[toDeleteIndex] = lastEntry;
1081             // Update the index for the moved entry
1082             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1083 
1084             // Delete the slot where the moved entry was stored
1085             map._entries.pop();
1086 
1087             // Delete the index for the deleted slot
1088             delete map._indexes[key];
1089 
1090             return true;
1091         } else {
1092             return false;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns true if the key is in the map. O(1).
1098      */
1099     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1100         return map._indexes[key] != 0;
1101     }
1102 
1103     /**
1104      * @dev Returns the number of key-value pairs in the map. O(1).
1105      */
1106     function _length(Map storage map) private view returns (uint256) {
1107         return map._entries.length;
1108     }
1109 
1110    /**
1111     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1112     *
1113     * Note that there are no guarantees on the ordering of entries inside the
1114     * array, and it may change when more entries are added or removed.
1115     *
1116     * Requirements:
1117     *
1118     * - `index` must be strictly less than {length}.
1119     */
1120     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1121         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1122 
1123         MapEntry storage entry = map._entries[index];
1124         return (entry._key, entry._value);
1125     }
1126 
1127     /**
1128      * @dev Tries to returns the value associated with `key`.  O(1).
1129      * Does not revert if `key` is not in the map.
1130      */
1131     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1132         uint256 keyIndex = map._indexes[key];
1133         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1134         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1135     }
1136 
1137     /**
1138      * @dev Returns the value associated with `key`.  O(1).
1139      *
1140      * Requirements:
1141      *
1142      * - `key` must be in the map.
1143      */
1144     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1145         uint256 keyIndex = map._indexes[key];
1146         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1147         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1148     }
1149 
1150     /**
1151      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1152      *
1153      * CAUTION: This function is deprecated because it requires allocating memory for the error
1154      * message unnecessarily. For custom revert reasons use {_tryGet}.
1155      */
1156     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1157         uint256 keyIndex = map._indexes[key];
1158         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1159         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1160     }
1161 
1162     // UintToAddressMap
1163 
1164     struct UintToAddressMap {
1165         Map _inner;
1166     }
1167 
1168     /**
1169      * @dev Adds a key-value pair to a map, or updates the value for an existing
1170      * key. O(1).
1171      *
1172      * Returns true if the key was added to the map, that is if it was not
1173      * already present.
1174      */
1175     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1176         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1177     }
1178 
1179     /**
1180      * @dev Removes a value from a set. O(1).
1181      *
1182      * Returns true if the key was removed from the map, that is if it was present.
1183      */
1184     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1185         return _remove(map._inner, bytes32(key));
1186     }
1187 
1188     /**
1189      * @dev Returns true if the key is in the map. O(1).
1190      */
1191     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1192         return _contains(map._inner, bytes32(key));
1193     }
1194 
1195     /**
1196      * @dev Returns the number of elements in the map. O(1).
1197      */
1198     function length(UintToAddressMap storage map) internal view returns (uint256) {
1199         return _length(map._inner);
1200     }
1201 
1202    /**
1203     * @dev Returns the element stored at position `index` in the set. O(1).
1204     * Note that there are no guarantees on the ordering of values inside the
1205     * array, and it may change when more values are added or removed.
1206     *
1207     * Requirements:
1208     *
1209     * - `index` must be strictly less than {length}.
1210     */
1211     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1212         (bytes32 key, bytes32 value) = _at(map._inner, index);
1213         return (uint256(key), address(uint160(uint256(value))));
1214     }
1215 
1216     /**
1217      * @dev Tries to returns the value associated with `key`.  O(1).
1218      * Does not revert if `key` is not in the map.
1219      *
1220      * _Available since v3.4._
1221      */
1222     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1223         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1224         return (success, address(uint160(uint256(value))));
1225     }
1226 
1227     /**
1228      * @dev Returns the value associated with `key`.  O(1).
1229      *
1230      * Requirements:
1231      *
1232      * - `key` must be in the map.
1233      */
1234     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1235         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1236     }
1237 
1238     /**
1239      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1240      *
1241      * CAUTION: This function is deprecated because it requires allocating memory for the error
1242      * message unnecessarily. For custom revert reasons use {tryGet}.
1243      */
1244     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1245         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1246     }
1247 }
1248 
1249 
1250 /**
1251  * @dev String operations.
1252  */
1253 library Strings {
1254     bytes16 private constant alphabet = "0123456789abcdef";
1255 
1256     /**
1257      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1258      */
1259     function toString(uint256 value) internal pure returns (string memory) {
1260         // Inspired by OraclizeAPI's implementation - MIT licence
1261         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1262 
1263         if (value == 0) {
1264             return "0";
1265         }
1266         uint256 temp = value;
1267         uint256 digits;
1268         while (temp != 0) {
1269             digits++;
1270             temp /= 10;
1271         }
1272         bytes memory buffer = new bytes(digits);
1273         while (value != 0) {
1274             digits -= 1;
1275             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1276             value /= 10;
1277         }
1278         return string(buffer);
1279     }
1280 
1281     /**
1282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1283      */
1284     function toHexString(uint256 value) internal pure returns (string memory) {
1285         if (value == 0) {
1286             return "0x00";
1287         }
1288         uint256 temp = value;
1289         uint256 length = 0;
1290         while (temp != 0) {
1291             length++;
1292             temp >>= 8;
1293         }
1294         return toHexString(value, length);
1295     }
1296 
1297     /**
1298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1299      */
1300     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1301         bytes memory buffer = new bytes(2 * length + 2);
1302         buffer[0] = "0";
1303         buffer[1] = "x";
1304         for (uint256 i = 2 * length + 1; i > 1; --i) {
1305             buffer[i] = alphabet[value & 0xf];
1306             value >>= 4;
1307         }
1308         require(value == 0, "Strings: hex length insufficient");
1309         return string(buffer);
1310     }
1311 
1312 }
1313 
1314 
1315 
1316 /**
1317  * @title ERC721 Non-Fungible Token Standard basic implementation
1318  * @dev see https://eips.ethereum.org/EIPS/eip-721
1319  */
1320 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1321     using SafeMath for uint256;
1322     using Address for address;
1323     using EnumerableSet for EnumerableSet.UintSet;
1324     using EnumerableMap for EnumerableMap.UintToAddressMap;
1325     using Strings for uint256;
1326 
1327     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1328     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1329     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1330 
1331     // Mapping from holder address to their (enumerable) set of owned tokens
1332     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1333 
1334     // Enumerable mapping from token ids to their owners
1335     EnumerableMap.UintToAddressMap private _tokenOwners;
1336 
1337     // Mapping from token ID to approved address
1338     mapping (uint256 => address) private _tokenApprovals;
1339 
1340     // Mapping from owner to operator approvals
1341     mapping (address => mapping (address => bool)) private _operatorApprovals;
1342 
1343     // Token name
1344     string private _name;
1345 
1346     // Token symbol
1347     string private _symbol;
1348 
1349     // Optional mapping for token URIs
1350     mapping (uint256 => string) private _tokenURIs;
1351 
1352     // Base URI
1353     string private _baseURI;
1354 
1355     /*
1356      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1357      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1358      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1359      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1360      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1361      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1362      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1363      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1364      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1365      *
1366      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1367      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1368      */
1369     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1370 
1371     /*
1372      *     bytes4(keccak256('name()')) == 0x06fdde03
1373      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1374      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1375      *
1376      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1377      */
1378     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1379 
1380     /*
1381      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1382      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1383      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1384      *
1385      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1386      */
1387     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1388 
1389     /**
1390      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1391      */
1392     constructor (string memory name_, string memory symbol_) {
1393         _name = name_;
1394         _symbol = symbol_;
1395 
1396         // register the supported interfaces to conform to ERC721 via ERC165
1397         _registerInterface(_INTERFACE_ID_ERC721);
1398         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1399         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-balanceOf}.
1404      */
1405     function balanceOf(address owner) public view virtual override returns (uint256) {
1406         require(owner != address(0), "ERC721: balance query for the zero address");
1407         return _holderTokens[owner].length();
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-ownerOf}.
1412      */
1413     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1414         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1415     }
1416 
1417     /**
1418      * @dev See {IERC721Metadata-name}.
1419      */
1420     function name() public view virtual override returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Metadata-symbol}.
1426      */
1427     function symbol() public view virtual override returns (string memory) {
1428         return _symbol;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Metadata-tokenURI}.
1433      */
1434     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1435         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1436 
1437         string memory _tokenURI = _tokenURIs[tokenId];
1438         string memory base = baseURI();
1439 
1440         // If there is no base URI, return the token URI.
1441         if (bytes(base).length == 0) {
1442             return _tokenURI;
1443         }
1444         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1445         if (bytes(_tokenURI).length > 0) {
1446             return string(abi.encodePacked(base, _tokenURI));
1447         }
1448         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1449         return string(abi.encodePacked(base, tokenId.toString()));
1450     }
1451 
1452     /**
1453     * @dev Returns the base URI set via {_setBaseURI}. This will be
1454     * automatically added as a prefix in {tokenURI} to each token's URI, or
1455     * to the token ID if no specific URI is set for that token ID.
1456     */
1457     function baseURI() public view virtual returns (string memory) {
1458         return _baseURI;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1463      */
1464     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1465         return _holderTokens[owner].at(index);
1466     }
1467 
1468     /**
1469      * @dev See {IERC721Enumerable-totalSupply}.
1470      */
1471     function totalSupply() public view virtual override returns (uint256) {
1472         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1473         return _tokenOwners.length();
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-tokenByIndex}.
1478      */
1479     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1480         (uint256 tokenId, ) = _tokenOwners.at(index);
1481         return tokenId;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-approve}.
1486      */
1487     function approve(address to, uint256 tokenId) public virtual override {
1488         address owner = ERC721.ownerOf(tokenId);
1489         require(to != owner, "ERC721: approval to current owner");
1490 
1491         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1492             "ERC721: approve caller is not owner nor approved for all"
1493         );
1494 
1495         _approve(to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-getApproved}.
1500      */
1501     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1502         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1503 
1504         return _tokenApprovals[tokenId];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-setApprovalForAll}.
1509      */
1510     function setApprovalForAll(address operator, bool approved) public virtual override {
1511         require(operator != _msgSender(), "ERC721: approve to caller");
1512 
1513         _operatorApprovals[_msgSender()][operator] = approved;
1514         emit ApprovalForAll(_msgSender(), operator, approved);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-isApprovedForAll}.
1519      */
1520     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1521         return _operatorApprovals[owner][operator];
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-transferFrom}.
1526      */
1527     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1528         //solhint-disable-next-line max-line-length
1529         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1530 
1531         _transfer(from, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-safeTransferFrom}.
1536      */
1537     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1538         safeTransferFrom(from, to, tokenId, "");
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-safeTransferFrom}.
1543      */
1544     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1545         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1546         _safeTransfer(from, to, tokenId, _data);
1547     }
1548 
1549     /**
1550      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1551      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1552      *
1553      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1554      *
1555      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1556      * implement alternative mechanisms to perform token transfer, such as signature-based.
1557      *
1558      * Requirements:
1559      *
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      * - `tokenId` token must exist and be owned by `from`.
1563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1568         _transfer(from, to, tokenId);
1569         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1570     }
1571 
1572     /**
1573      * @dev Returns whether `tokenId` exists.
1574      *
1575      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1576      *
1577      * Tokens start existing when they are minted (`_mint`),
1578      * and stop existing when they are burned (`_burn`).
1579      */
1580     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1581         return _tokenOwners.contains(tokenId);
1582     }
1583 
1584     /**
1585      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1586      *
1587      * Requirements:
1588      *
1589      * - `tokenId` must exist.
1590      */
1591     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1592         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1593         address owner = ERC721.ownerOf(tokenId);
1594         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1595     }
1596 
1597     /**
1598      * @dev Safely mints `tokenId` and transfers it to `to`.
1599      *
1600      * Requirements:
1601      d*
1602      * - `tokenId` must not exist.
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _safeMint(address to, uint256 tokenId) internal virtual {
1608         _safeMint(to, tokenId, "");
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1613      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1614      */
1615     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1616         _mint(to, tokenId);
1617         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1618     }
1619 
1620     /**
1621      * @dev Mints `tokenId` and transfers it to `to`.
1622      *
1623      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must not exist.
1628      * - `to` cannot be the zero address.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _mint(address to, uint256 tokenId) internal virtual {
1633         require(to != address(0), "ERC721: mint to the zero address");
1634         require(!_exists(tokenId), "ERC721: token already minted");
1635 
1636         _beforeTokenTransfer(address(0), to, tokenId);
1637 
1638         _holderTokens[to].add(tokenId);
1639 
1640         _tokenOwners.set(tokenId, to);
1641 
1642         emit Transfer(address(0), to, tokenId);
1643     }
1644 
1645     /**
1646      * @dev Destroys `tokenId`.
1647      * The approval is cleared when the token is burned.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _burn(uint256 tokenId) internal virtual {
1656         address owner = ERC721.ownerOf(tokenId); // internal owner
1657 
1658         _beforeTokenTransfer(owner, address(0), tokenId);
1659 
1660         // Clear approvals
1661         _approve(address(0), tokenId);
1662 
1663         // Clear metadata (if any)
1664         if (bytes(_tokenURIs[tokenId]).length != 0) {
1665             delete _tokenURIs[tokenId];
1666         }
1667 
1668         _holderTokens[owner].remove(tokenId);
1669 
1670         _tokenOwners.remove(tokenId);
1671 
1672         emit Transfer(owner, address(0), tokenId);
1673     }
1674 
1675     /**
1676      * @dev Transfers `tokenId` from `from` to `to`.
1677      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - `tokenId` token must be owned by `from`.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1687         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1688         require(to != address(0), "ERC721: transfer to the zero address");
1689 
1690         _beforeTokenTransfer(from, to, tokenId);
1691 
1692         // Clear approvals from the previous owner
1693         _approve(address(0), tokenId);
1694 
1695         _holderTokens[from].remove(tokenId);
1696         _holderTokens[to].add(tokenId);
1697 
1698         _tokenOwners.set(tokenId, to);
1699 
1700         emit Transfer(from, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      */
1710     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1711         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1712         _tokenURIs[tokenId] = _tokenURI;
1713     }
1714 
1715     /**
1716      * @dev Internal function to set the base URI for all token IDs. It is
1717      * automatically added as a prefix to the value returned in {tokenURI},
1718      * or to the token ID if {tokenURI} is empty.
1719      */
1720     function _setBaseURI(string memory baseURI_) internal virtual {
1721         _baseURI = baseURI_;
1722     }
1723 
1724     /**
1725      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1726      * The call is not executed if the target address is not a contract.
1727      *
1728      * @param from address representing the previous owner of the given token ID
1729      * @param to target address that will receive the tokens
1730      * @param tokenId uint256 ID of the token to be transferred
1731      * @param _data bytes optional data to send along with the call
1732      * @return bool whether the call correctly returned the expected magic value
1733      */
1734     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1735         private returns (bool)
1736     {
1737         if (!to.isContract()) {
1738             return true;
1739         }
1740         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1741             IERC721Receiver(to).onERC721Received.selector,
1742             _msgSender(),
1743             from,
1744             tokenId,
1745             _data
1746         ), "ERC721: transfer to non ERC721Receiver implementer");
1747         bytes4 retval = abi.decode(returndata, (bytes4));
1748         return (retval == _ERC721_RECEIVED);
1749     }
1750 
1751     /**
1752      * @dev Approve `to` to operate on `tokenId`
1753      *
1754      * Emits an {Approval} event.
1755      */
1756     function _approve(address to, uint256 tokenId) internal virtual {
1757         _tokenApprovals[tokenId] = to;
1758         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1759     }
1760 
1761     /**
1762      * @dev Hook that is called before any token transfer. This includes minting
1763      * and burning.
1764      *
1765      * Calling conditions:
1766      *
1767      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1768      * transferred to `to`.
1769      * - When `from` is zero, `tokenId` will be minted for `to`.
1770      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1771      * - `from` cannot be the zero address.
1772      * - `to` cannot be the zero address.
1773      *
1774      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1775      */
1776     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1777 }
1778 
1779 
1780 /**
1781  * @dev Contract module which provides a basic access control mechanism, where
1782  * there is an account (an owner) that can be granted exclusive access to
1783  * specific functions.
1784  *
1785  * By default, the owner account will be the one that deploys the contract. This
1786  * can later be changed with {transferOwnership}.
1787  *
1788  * This module is used through inheritance. It will make available the modifier
1789  * `onlyOwner`, which can be applied to your functions to restrict their use to
1790  * the owner.
1791  */
1792 abstract contract Ownable is Context {
1793     address private _owner;
1794 
1795     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1796 
1797     /**
1798      * @dev Initializes the contract setting the deployer as the initial owner.
1799      */
1800     constructor () {
1801         address msgSender = _msgSender();
1802         _owner = msgSender;
1803         emit OwnershipTransferred(address(0), msgSender);
1804     }
1805 
1806     /**
1807      * @dev Returns the address of the current owner.
1808      */
1809     function owner() public view virtual returns (address) {
1810         return _owner;
1811     }
1812 
1813     /**
1814      * @dev Throws if called by any account other than the owner.
1815      */
1816     modifier onlyOwner() {
1817         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1818         _;
1819     }
1820 
1821     /**
1822      * @dev Leaves the contract without owner. It will not be possible to call
1823      * `onlyOwner` functions anymore. Can only be called by the current owner.
1824      *
1825      * NOTE: Renouncing ownership will leave the contract without an owner,
1826      * thereby removing any functionality that is only available to the owner.
1827      */
1828     function renounceOwnership() public virtual onlyOwner {
1829         emit OwnershipTransferred(_owner, address(0));
1830         _owner = address(0);
1831     }
1832 
1833     /**
1834      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1835      * Can only be called by the current owner.
1836      */
1837     function transferOwnership(address newOwner) public virtual onlyOwner {
1838         require(newOwner != address(0), "Ownable: new owner is the zero address");
1839         emit OwnershipTransferred(_owner, newOwner);
1840         _owner = newOwner;
1841     }
1842 }
1843 
1844 abstract contract ReentrancyGuard {
1845     // Booleans are more expensive than uint256 or any type that takes up a full
1846     // word because each write operation emits an extra SLOAD to first read the
1847     // slot's contents, replace the bits taken up by the boolean, and then write
1848     // back. This is the compiler's defense against contract upgrades and
1849     // pointer aliasing, and it cannot be disabled.
1850 
1851     // The values being non-zero value makes deployment a bit more expensive,
1852     // but in exchange the refund on every call to nonReentrant will be lower in
1853     // amount. Since refunds are capped to a percentage of the total
1854     // transaction's gas, it is best to keep them low in cases like this one, to
1855     // increase the likelihood of the full refund coming into effect.
1856     uint256 private constant _NOT_ENTERED = 1;
1857     uint256 private constant _ENTERED = 2;
1858 
1859     uint256 private _status;
1860 
1861     constructor () {
1862         _status = _NOT_ENTERED;
1863     }
1864 
1865     /**voucherPresaleNfts
1866      * @dev Prevents a contract from calling itself, directly or indirectly.
1867      * Calling a `nonReentrant` function from another `nonReentrant`
1868      * function is not supported. It is possible to prevent this from happening
1869      * by making the `nonReentrant` function external, and make it call a
1870      * `private` function that does the actual work.
1871      */
1872     modifier nonReentrant() {
1873         // On the first call to nonReentrant, _notEntered will be true
1874         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1875 
1876         // Any calls to nonReentrant after this point will fail
1877         _status = _ENTERED;
1878 
1879         _;
1880 
1881         // By storing the original value once again, a refund is triggered (see
1882         // https://eips.ethereum.org/EIPS/eip-2200)
1883         _status = _NOT_ENTERED;
1884     }
1885 
1886     modifier isHuman() {
1887         require(tx.origin == msg.sender, "sorry humans only");
1888         _;
1889     }
1890 }
1891 
1892 /**
1893  * @title contract
1894  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1895  */
1896 contract three333 is ERC721, Ownable, ReentrancyGuard {
1897     using SafeMath for uint256;
1898 
1899     uint256 public mintPrice;
1900     uint256 public presaleMintPrice;
1901     uint256 public maxPublicToMint;
1902     uint256 public maxPresaleToMint;
1903     uint256 public maxNftSupply;
1904     uint256 public maxPresaleSupply;
1905     uint256 public curTicketId;
1906 
1907     mapping(address => uint256) public presaleNumOfUser;
1908     mapping(address => uint256) public publicNumOfUser;
1909     mapping(address => uint256) public totalClaimed;
1910 
1911     bool public presaleAllowed;
1912     bool public publicSaleAllowed;    
1913     uint256 public presaleStartTimestamp;
1914     uint256 public publicSaleStartTimestamp;    
1915 
1916     mapping(address => bool) private presaleWhitelist;
1917 
1918     constructor() ERC721("Project3333", "3333")  {
1919         maxNftSupply = 3333;
1920         maxPresaleSupply = 1333;
1921         mintPrice = 0.25 ether;
1922         presaleMintPrice = 0.15 ether;
1923         maxPublicToMint = 10;
1924         maxPresaleToMint = 5;
1925         curTicketId = 0;
1926 
1927         presaleAllowed = false;
1928         publicSaleAllowed = false;
1929 
1930         presaleStartTimestamp = 0;
1931         publicSaleStartTimestamp = 0;
1932 
1933     }
1934 
1935     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1936         uint256 tokenCount = balanceOf(_owner);
1937         if (tokenCount == 0) {
1938             return new uint256[](0);
1939         } else {
1940             uint256[] memory result = new uint256[](tokenCount);
1941             for (uint256 index; index < tokenCount; index++) {
1942                 result[index] = tokenOfOwnerByIndex(_owner, index);
1943             }
1944             return result;
1945         }
1946     }
1947 
1948     function exists(uint256 _tokenId) public view returns (bool) {
1949         return _exists(_tokenId);
1950     }
1951 
1952     function isPresaleLive() public view returns(bool) {
1953         uint256 curTimestamp = block.timestamp;
1954         if (presaleAllowed && presaleStartTimestamp <= curTimestamp && curTicketId < maxPresaleSupply) {
1955             return true;
1956         }
1957         return false;
1958     }
1959 
1960     function isPublicSaleLive() public view returns(bool) {
1961         uint256 curTimestamp = block.timestamp;
1962         if (publicSaleAllowed && publicSaleStartTimestamp <= curTimestamp) {
1963             return true;
1964         }
1965         return false;
1966     }
1967 
1968     function setMintPrice(uint256 _price) external onlyOwner {
1969         mintPrice = _price;
1970     }
1971 
1972     function setPresaleMintPrice(uint256 _price) external onlyOwner {
1973         presaleMintPrice = _price;
1974     }
1975 
1976     function setMaxNftSupply(uint256 _maxValue) external onlyOwner {
1977         maxNftSupply = _maxValue;
1978     }
1979 
1980     function setMaxPresaleSupply(uint256 _maxValue) external onlyOwner {
1981         maxPresaleSupply = _maxValue;
1982     }
1983 
1984     function setMaxPresaleToMint(uint256 _maxValue) external onlyOwner {
1985         maxPresaleToMint = _maxValue;
1986     }
1987 
1988     function setMaxPublicToMint(uint256 _maxValue) external onlyOwner {
1989         maxPublicToMint = _maxValue;
1990     }
1991 
1992     function reserveNfts(address _to, uint256 _numberOfTokens) external onlyOwner {
1993         uint256 supply = totalSupply();
1994         require(_to != address(0), "Invalid address to reserve.");
1995         require(supply == curTicketId, "Ticket id and supply not matched.");
1996         uint256 i;
1997         
1998         for (i = 0; i < _numberOfTokens; i++) {
1999             _safeMint(_to, supply + i);
2000         }
2001 
2002         curTicketId = curTicketId.add(_numberOfTokens);
2003     }
2004 
2005     function setBaseURI(string memory baseURI) external onlyOwner {
2006         _setBaseURI(baseURI);
2007     }
2008 
2009     function updatePresaleState(bool newStatus, uint256 timestamp) external onlyOwner {
2010         presaleAllowed = newStatus;
2011         if (timestamp != 0) {
2012             presaleStartTimestamp = timestamp;
2013         }        
2014     }
2015 
2016     function updatePublicSaleState(bool newStatus, uint256 timestamp) external onlyOwner {
2017         publicSaleAllowed = newStatus;
2018         if (timestamp != 0) {
2019             publicSaleStartTimestamp = timestamp;
2020         } 
2021     }
2022 
2023     function addToPresale(address[] calldata addresses) external onlyOwner {
2024         for (uint256 i = 0; i < addresses.length; i++) {
2025             presaleWhitelist[addresses[i]] = true;
2026         }
2027     }
2028 
2029     function removeToPresale(address[] calldata addresses) external onlyOwner {
2030         for (uint256 i = 0; i < addresses.length; i++) {
2031             presaleWhitelist[addresses[i]] = false;
2032         }
2033     }
2034 
2035     function isInWhitelist(address user) external view returns (bool) {
2036         return presaleWhitelist[user];
2037     }
2038 
2039     function doPresale(uint256 numberOfTokens) isHuman nonReentrant external payable {
2040         uint256 numOfUser = presaleNumOfUser[_msgSender()];
2041 
2042         require(isPresaleLive(), "Presale has not started yet");
2043         require(presaleWhitelist[_msgSender()], "You are not on white list");
2044         require(numberOfTokens.add(numOfUser) <= maxPresaleToMint, "Exceeds max presale allowed per user");
2045         require(curTicketId.add(numberOfTokens) <= maxPresaleSupply, "Exceeds max presale supply");
2046         require(numberOfTokens > 0, "Must mint at least one token");
2047         require(presaleMintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2048 
2049         presaleNumOfUser[_msgSender()] = numberOfTokens.add(presaleNumOfUser[_msgSender()]);
2050         curTicketId = curTicketId.add(numberOfTokens);
2051     }
2052 
2053     function doPublic(uint256 numberOfTokens) isHuman nonReentrant external payable {
2054         uint256 numOfUser = publicNumOfUser[_msgSender()];
2055         require(isPublicSaleLive(), "Public sale has not started yet");
2056         require(numberOfTokens.add(numOfUser) <= maxPublicToMint, "Exceeds max public sale allowed per user");
2057         require(curTicketId.add(numberOfTokens) <= maxNftSupply, "Exceeds max supply");
2058         require(numberOfTokens > 0, "Must mint at least one token");
2059         require(mintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2060 
2061         publicNumOfUser[_msgSender()] = numberOfTokens.add(publicNumOfUser[_msgSender()]);
2062         curTicketId = curTicketId.add(numberOfTokens);
2063     }
2064 
2065     function getUserClaimableTicketCount(address user) public view returns (uint256) {
2066         return presaleNumOfUser[user].add(publicNumOfUser[user]).sub(totalClaimed[user]);
2067     }
2068 
2069     function claimNfts() isHuman nonReentrant external {
2070         uint256 numbersOfTickets = getUserClaimableTicketCount(_msgSender());
2071         
2072         for(uint256 i = 0; i < numbersOfTickets; i++) {
2073             uint256 mintIndex = totalSupply();
2074             _safeMint(_msgSender(), mintIndex);
2075         }
2076 
2077         totalClaimed[_msgSender()] = numbersOfTickets.add(totalClaimed[_msgSender()]);
2078     }
2079 
2080     function withdraw() external onlyOwner {
2081         uint256 balance = address(this).balance;
2082         payable(owner()).transfer(balance);
2083     }
2084 }