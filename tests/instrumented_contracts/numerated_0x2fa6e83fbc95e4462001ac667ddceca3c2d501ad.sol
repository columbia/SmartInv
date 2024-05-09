1 // SPDX-License-Identifier: MIT
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
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 
49 /**
50  * @dev Required interface of an ERC721 compliant contract.
51  */
52 interface IERC721 is IERC165 {
53     /**
54      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
60      */
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
65      */
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158       * @dev Safely transfers `tokenId` token from `from` to `to`.
159       *
160       * Requirements:
161       *
162       * - `from` cannot be the zero address.
163       * - `to` cannot be the zero address.
164       * - `tokenId` token must exist and be owned by `from`.
165       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167       *
168       * Emits a {Transfer} event.
169       */
170     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
171 }
172 
173 
174 /**
175  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
176  * @dev See https://eips.ethereum.org/EIPS/eip-721
177  */
178 interface IERC721Metadata is IERC721 {
179 
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token collection symbol.
187      */
188     function symbol() external view returns (string memory);
189 
190     /**
191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
192      */
193     function tokenURI(uint256 tokenId) external view returns (string memory);
194 }
195 
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Enumerable is IERC721 {
202 
203     /**
204      * @dev Returns the total amount of tokens stored by the contract.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
210      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
211      */
212     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
213 
214     /**
215      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
216      * Use along with {totalSupply} to enumerate all tokens.
217      */
218     function tokenByIndex(uint256 index) external view returns (uint256);
219 }
220 
221 /**
222  * @title ERC721 token receiver interface
223  * @dev Interface for any contract that wants to support safeTransfers
224  * from ERC721 asset contracts.
225  */
226 interface IERC721Receiver {
227     /**
228      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
229      * by `operator` from `from`, this function is called.
230      *
231      * It must return its Solidity selector to confirm the token transfer.
232      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
233      *
234      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
235      */
236     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
237 }
238 
239 /**
240  * @dev Implementation of the {IERC165} interface.
241  *
242  * Contracts may inherit from this and call {_registerInterface} to declare
243  * their support of an interface.
244  */
245 abstract contract ERC165 is IERC165 {
246     /*
247      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
248      */
249     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
250 
251     /**
252      * @dev Mapping of interface ids to whether or not it's supported.
253      */
254     mapping(bytes4 => bool) private _supportedInterfaces;
255 
256     constructor () {
257         // Derived contracts need only register support for their own interfaces,
258         // we register support for ERC165 itself here
259         _registerInterface(_INTERFACE_ID_ERC165);
260     }
261 
262     /**
263      * @dev See {IERC165-supportsInterface}.
264      *
265      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
266      */
267     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
268         return _supportedInterfaces[interfaceId];
269     }
270 
271     /**
272      * @dev Registers the contract as an implementer of the interface defined by
273      * `interfaceId`. Support of the actual ERC165 interface is automatic and
274      * registering its interface id is not required.
275      *
276      * See {IERC165-supportsInterface}.
277      *
278      * Requirements:
279      *
280      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
281      */
282     function _registerInterface(bytes4 interfaceId) internal virtual {
283         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
284         _supportedInterfaces[interfaceId] = true;
285     }
286 }
287 
288 
289 
290 /**
291  * @dev Wrappers over Solidity's arithmetic operations with added overflow
292  * checks.
293  *
294  * Arithmetic operations in Solidity wrap on overflow. This can easily result
295  * in bugs, because programmers usually assume that an overflow raises an
296  * error, which is the standard behavior in high level programming languages.
297  * `SafeMath` restores this intuition by reverting the transaction when an
298  * operation overflows.
299  *
300  * Using this library instead of the unchecked operations eliminates an entire
301  * class of bugs, so it's recommended to use it always.
302  */
303 library SafeMath {
304     /**
305      * @dev Returns the addition of two unsigned integers, with an overflow flag.
306      *
307      * _Available since v3.4._
308      */
309     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
310         uint256 c = a + b;
311         if (c < a) return (false, 0);
312         return (true, c);
313     }
314 
315     /**
316      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
317      *
318      * _Available since v3.4._
319      */
320     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
321         if (b > a) return (false, 0);
322         return (true, a - b);
323     }
324 
325     /**
326      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
327      *
328      * _Available since v3.4._
329      */
330     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
332         // benefit is lost if 'b' is also tested.
333         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
334         if (a == 0) return (true, 0);
335         uint256 c = a * b;
336         if (c / a != b) return (false, 0);
337         return (true, c);
338     }
339 
340     /**
341      * @dev Returns the division of two unsigned integers, with a division by zero flag.
342      *
343      * _Available since v3.4._
344      */
345     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
346         if (b == 0) return (false, 0);
347         return (true, a / b);
348     }
349 
350     /**
351      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b == 0) return (false, 0);
357         return (true, a % b);
358     }
359 
360     /**
361      * @dev Returns the addition of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `+` operator.
365      *
366      * Requirements:
367      *
368      * - Addition cannot overflow.
369      */
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         uint256 c = a + b;
372         require(c >= a, "SafeMath: addition overflow");
373         return c;
374     }
375 
376     /**
377      * @dev Returns the subtraction of two unsigned integers, reverting on
378      * overflow (when the result is negative).
379      *
380      * Counterpart to Solidity's `-` operator.
381      *
382      * Requirements:
383      *
384      * - Subtraction cannot overflow.
385      */
386     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387         require(b <= a, "SafeMath: subtraction overflow");
388         return a - b;
389     }
390 
391     /**
392      * @dev Returns the multiplication of two unsigned integers, reverting on
393      * overflow.
394      *
395      * Counterpart to Solidity's `*` operator.
396      *
397      * Requirements:
398      *
399      * - Multiplication cannot overflow.
400      */
401     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
402         if (a == 0) return 0;
403         uint256 c = a * b;
404         require(c / a == b, "SafeMath: multiplication overflow");
405         return c;
406     }
407 
408     /**
409      * @dev Returns the integer division of two unsigned integers, reverting on
410      * division by zero. The result is rounded towards zero.
411      *
412      * Counterpart to Solidity's `/` operator. Note: this function uses a
413      * `revert` opcode (which leaves remaining gas untouched) while Solidity
414      * uses an invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      *
418      * - The divisor cannot be zero.
419      */
420     function div(uint256 a, uint256 b) internal pure returns (uint256) {
421         require(b > 0, "SafeMath: division by zero");
422         return a / b;
423     }
424 
425     /**
426      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
427      * reverting when dividing by zero.
428      *
429      * Counterpart to Solidity's `%` operator. This function uses a `revert`
430      * opcode (which leaves remaining gas untouched) while Solidity uses an
431      * invalid opcode to revert (consuming all remaining gas).
432      *
433      * Requirements:
434      *
435      * - The divisor cannot be zero.
436      */
437     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
438         require(b > 0, "SafeMath: modulo by zero");
439         return a % b;
440     }
441 
442     /**
443      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
444      * overflow (when the result is negative).
445      *
446      * CAUTION: This function is deprecated because it requires allocating memory for the error
447      * message unnecessarily. For custom revert reasons use {trySub}.
448      *
449      * Counterpart to Solidity's `-` operator.
450      *
451      * Requirements:
452      *
453      * - Subtraction cannot overflow.
454      */
455     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         require(b <= a, errorMessage);
457         return a - b;
458     }
459 
460     /**
461      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
462      * division by zero. The result is rounded towards zero.
463      *
464      * CAUTION: This function is deprecated because it requires allocating memory for the error
465      * message unnecessarily. For custom revert reasons use {tryDiv}.
466      *
467      * Counterpart to Solidity's `/` operator. Note: this function uses a
468      * `revert` opcode (which leaves remaining gas untouched) while Solidity
469      * uses an invalid opcode to revert (consuming all remaining gas).
470      *
471      * Requirements:
472      *
473      * - The divisor cannot be zero.
474      */
475     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         require(b > 0, errorMessage);
477         return a / b;
478     }
479 
480     /**
481      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
482      * reverting with custom message when dividing by zero.
483      *
484      * CAUTION: This function is deprecated because it requires allocating memory for the error
485      * message unnecessarily. For custom revert reasons use {tryMod}.
486      *
487      * Counterpart to Solidity's `%` operator. This function uses a `revert`
488      * opcode (which leaves remaining gas untouched) while Solidity uses an
489      * invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
496         require(b > 0, errorMessage);
497         return a % b;
498     }
499 }
500 
501 
502 /**
503  * @dev Collection of functions related to the address type
504  */
505 library Address {
506     /**
507      * @dev Returns true if `account` is a contract.
508      *
509      * [IMPORTANT]
510      * ====
511      * It is unsafe to assume that an address for which this function returns
512      * false is an externally-owned account (EOA) and not a contract.
513      *
514      * Among others, `isContract` will return false for the following
515      * types of addresses:
516      *
517      *  - an externally-owned account
518      *  - a contract in construction
519      *  - an address where a contract will be created
520      *  - an address where a contract lived, but was destroyed
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // This method relies on extcodesize, which returns 0 for contracts in
525         // construction, since the code is only stored at the end of the
526         // constructor execution.
527 
528         uint256 size;
529         // solhint-disable-next-line no-inline-assembly
530         assembly { size := extcodesize(account) }
531         return size > 0;
532     }
533 
534     /**
535      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
536      * `recipient`, forwarding all available gas and reverting on errors.
537      *
538      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
539      * of certain opcodes, possibly making contracts go over the 2300 gas limit
540      * imposed by `transfer`, making them unable to receive funds via
541      * `transfer`. {sendValue} removes this limitation.
542      *
543      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
544      *
545      * IMPORTANT: because control is transferred to `recipient`, care must be
546      * taken to not create reentrancy vulnerabilities. Consider using
547      * {ReentrancyGuard} or the
548      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
549      */
550     function sendValue(address payable recipient, uint256 amount) internal {
551         require(address(this).balance >= amount, "Address: insufficient balance");
552 
553         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
554         (bool success, ) = recipient.call{ value: amount }("");
555         require(success, "Address: unable to send value, recipient may have reverted");
556     }
557 
558     /**
559      * @dev Performs a Solidity function call using a low level `call`. A
560      * plain`call` is an unsafe replacement for a function call: use this
561      * function instead.
562      *
563      * If `target` reverts with a revert reason, it is bubbled up by this
564      * function (like regular Solidity function calls).
565      *
566      * Returns the raw returned data. To convert to the expected return value,
567      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
568      *
569      * Requirements:
570      *
571      * - `target` must be a contract.
572      * - calling `target` with `data` must not revert.
573      *
574      * _Available since v3.1._
575      */
576     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
577       return functionCall(target, data, "Address: low-level call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
582      * `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, 0, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but also transferring `value` wei to `target`.
593      *
594      * Requirements:
595      *
596      * - the calling contract must have an ETH balance of at least `value`.
597      * - the called Solidity function must be `payable`.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
607      * with `errorMessage` as a fallback revert reason when `target` reverts.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
612         require(address(this).balance >= value, "Address: insufficient balance for call");
613         require(isContract(target), "Address: call to non-contract");
614 
615         // solhint-disable-next-line avoid-low-level-calls
616         (bool success, bytes memory returndata) = target.call{ value: value }(data);
617         return _verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a static call.
623      *
624      * _Available since v3.3._
625      */
626     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
627         return functionStaticCall(target, data, "Address: low-level static call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
632      * but performing a static call.
633      *
634      * _Available since v3.3._
635      */
636     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
637         require(isContract(target), "Address: static call to non-contract");
638 
639         // solhint-disable-next-line avoid-low-level-calls
640         (bool success, bytes memory returndata) = target.staticcall(data);
641         return _verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but performing a delegate call.
647      *
648      * _Available since v3.4._
649      */
650     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
651         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
656      * but performing a delegate call.
657      *
658      * _Available since v3.4._
659      */
660     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
661         require(isContract(target), "Address: delegate call to non-contract");
662 
663         // solhint-disable-next-line avoid-low-level-calls
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return _verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
669         if (success) {
670             return returndata;
671         } else {
672             // Look for revert reason and bubble it up if present
673             if (returndata.length > 0) {
674                 // The easiest way to bubble the revert reason is using memory via assembly
675 
676                 // solhint-disable-next-line no-inline-assembly
677                 assembly {
678                     let returndata_size := mload(returndata)
679                     revert(add(32, returndata), returndata_size)
680                 }
681             } else {
682                 revert(errorMessage);
683             }
684         }
685     }
686 }
687 
688 /**
689  * @dev Library for managing
690  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
691  * types.
692  *
693  * Sets have the following properties:
694  *
695  * - Elements are added, removed, and checked for existence in constant time
696  * (O(1)).
697  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
698  *
699  * ```
700  * contract Example {
701  *     // Add the library methods
702  *     using EnumerableSet for EnumerableSet.AddressSet;
703  *
704  *     // Declare a set state variable
705  *     EnumerableSet.AddressSet private mySet;
706  * }
707  * ```
708  *
709  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
710  * and `uint256` (`UintSet`) are supported.
711  */
712 library EnumerableSet {
713     // To implement this library for multiple types with as little code
714     // repetition as possible, we write it in terms of a generic Set type with
715     // bytes32 values.
716     // The Set implementation uses private functions, and user-facing
717     // implementations (such as AddressSet) are just wrappers around the
718     // underlying Set.
719     // This means that we can only create new EnumerableSets for types that fit
720     // in bytes32.
721 
722     struct Set {
723         // Storage of set values
724         bytes32[] _values;
725 
726         // Position of the value in the `values` array, plus 1 because index 0
727         // means a value is not in the set.
728         mapping (bytes32 => uint256) _indexes;
729     }
730 
731     /**
732      * @dev Add a value to a set. O(1).
733      *
734      * Returns true if the value was added to the set, that is if it was not
735      * already present.
736      */
737     function _add(Set storage set, bytes32 value) private returns (bool) {
738         if (!_contains(set, value)) {
739             set._values.push(value);
740             // The value is stored at length-1, but we add 1 to all indexes
741             // and use 0 as a sentinel value
742             set._indexes[value] = set._values.length;
743             return true;
744         } else {
745             return false;
746         }
747     }
748 
749     /**
750      * @dev Removes a value from a set. O(1).
751      *
752      * Returns true if the value was removed from the set, that is if it was
753      * present.
754      */
755     function _remove(Set storage set, bytes32 value) private returns (bool) {
756         // We read and store the value's index to prevent multiple reads from the same storage slot
757         uint256 valueIndex = set._indexes[value];
758 
759         if (valueIndex != 0) { // Equivalent to contains(set, value)
760             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
761             // the array, and then remove the last element (sometimes called as 'swap and pop').
762             // This modifies the order of the array, as noted in {at}.
763 
764             uint256 toDeleteIndex = valueIndex - 1;
765             uint256 lastIndex = set._values.length - 1;
766 
767             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
768             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
769 
770             bytes32 lastvalue = set._values[lastIndex];
771 
772             // Move the last value to the index where the value to delete is
773             set._values[toDeleteIndex] = lastvalue;
774             // Update the index for the moved value
775             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
776 
777             // Delete the slot where the moved value was stored
778             set._values.pop();
779 
780             // Delete the index for the deleted slot
781             delete set._indexes[value];
782 
783             return true;
784         } else {
785             return false;
786         }
787     }
788 
789     /**
790      * @dev Returns true if the value is in the set. O(1).
791      */
792     function _contains(Set storage set, bytes32 value) private view returns (bool) {
793         return set._indexes[value] != 0;
794     }
795 
796     /**
797      * @dev Returns the number of values on the set. O(1).
798      */
799     function _length(Set storage set) private view returns (uint256) {
800         return set._values.length;
801     }
802 
803    /**
804     * @dev Returns the value stored at position `index` in the set. O(1).
805     *
806     * Note that there are no guarantees on the ordering of values inside the
807     * array, and it may change when more values are added or removed.
808     *
809     * Requirements:
810     *
811     * - `index` must be strictly less than {length}.
812     */
813     function _at(Set storage set, uint256 index) private view returns (bytes32) {
814         require(set._values.length > index, "EnumerableSet: index out of bounds");
815         return set._values[index];
816     }
817 
818     // Bytes32Set
819 
820     struct Bytes32Set {
821         Set _inner;
822     }
823 
824     /**
825      * @dev Add a value to a set. O(1).
826      *
827      * Returns true if the value was added to the set, that is if it was not
828      * already present.
829      */
830     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
831         return _add(set._inner, value);
832     }
833 
834     /**
835      * @dev Removes a value from a set. O(1).
836      *
837      * Returns true if the value was removed from the set, that is if it was
838      * present.
839      */
840     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
841         return _remove(set._inner, value);
842     }
843 
844     /**
845      * @dev Returns true if the value is in the set. O(1).
846      */
847     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
848         return _contains(set._inner, value);
849     }
850 
851     /**
852      * @dev Returns the number of values in the set. O(1).
853      */
854     function length(Bytes32Set storage set) internal view returns (uint256) {
855         return _length(set._inner);
856     }
857 
858    /**
859     * @dev Returns the value stored at position `index` in the set. O(1).
860     *
861     * Note that there are no guarantees on the ordering of values inside the
862     * array, and it may change when more values are added or removed.
863     *
864     * Requirements:
865     *
866     * - `index` must be strictly less than {length}.
867     */
868     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
869         return _at(set._inner, index);
870     }
871 
872     // AddressSet
873 
874     struct AddressSet {
875         Set _inner;
876     }
877 
878     /**
879      * @dev Add a value to a set. O(1).
880      *
881      * Returns true if the value was added to the set, that is if it was not
882      * already present.
883      */
884     function add(AddressSet storage set, address value) internal returns (bool) {
885         return _add(set._inner, bytes32(uint256(uint160(value))));
886     }
887 
888     /**
889      * @dev Removes a value from a set. O(1).
890      *
891      * Returns true if the value was removed from the set, that is if it was
892      * present.
893      */
894     function remove(AddressSet storage set, address value) internal returns (bool) {
895         return _remove(set._inner, bytes32(uint256(uint160(value))));
896     }
897 
898     /**
899      * @dev Returns true if the value is in the set. O(1).
900      */
901     function contains(AddressSet storage set, address value) internal view returns (bool) {
902         return _contains(set._inner, bytes32(uint256(uint160(value))));
903     }
904 
905     /**
906      * @dev Returns the number of values in the set. O(1).
907      */
908     function length(AddressSet storage set) internal view returns (uint256) {
909         return _length(set._inner);
910     }
911 
912    /**
913     * @dev Returns the value stored at position `index` in the set. O(1).
914     *
915     * Note that there are no guarantees on the ordering of values inside the
916     * array, and it may change when more values are added or removed.
917     *
918     * Requirements:
919     *
920     * - `index` must be strictly less than {length}.
921     */
922     function at(AddressSet storage set, uint256 index) internal view returns (address) {
923         return address(uint160(uint256(_at(set._inner, index))));
924     }
925 
926 
927     // UintSet
928 
929     struct UintSet {
930         Set _inner;
931     }
932 
933     /**
934      * @dev Add a value to a set. O(1).
935      *
936      * Returns true if the value was added to the set, that is if it was not
937      * already present.
938      */
939     function add(UintSet storage set, uint256 value) internal returns (bool) {
940         return _add(set._inner, bytes32(value));
941     }
942 
943     /**
944      * @dev Removes a value from a set. O(1).
945      *
946      * Returns true if the value was removed from the set, that is if it was
947      * present.
948      */
949     function remove(UintSet storage set, uint256 value) internal returns (bool) {
950         return _remove(set._inner, bytes32(value));
951     }
952 
953     /**
954      * @dev Returns true if the value is in the set. O(1).
955      */
956     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
957         return _contains(set._inner, bytes32(value));
958     }
959 
960     /**
961      * @dev Returns the number of values on the set. O(1).
962      */
963     function length(UintSet storage set) internal view returns (uint256) {
964         return _length(set._inner);
965     }
966 
967    /**
968     * @dev Returns the value stored at position `index` in the set. O(1).
969     *
970     * Note that there are no guarantees on the ordering of values inside the
971     * array, and it may change when more values are added or removed.
972     *
973     * Requirements:
974     *
975     * - `index` must be strictly less than {length}.
976     */
977     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
978         return uint256(_at(set._inner, index));
979     }
980 }
981 
982 
983 /**
984  * @dev Library for managing an enumerable variant of Solidity's
985  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
986  * type.
987  *
988  * Maps have the following properties:
989  *
990  * - Entries are added, removed, and checked for existence in constant time
991  * (O(1)).
992  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
993  *
994  * ```
995  * contract Example {
996  *     // Add the library methods
997  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
998  *
999  *     // Declare a set state variable
1000  *     EnumerableMap.UintToAddressMap private myMap;
1001  * }
1002  * ```
1003  *
1004  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1005  * supported.
1006  */
1007 library EnumerableMap {
1008     // To implement this library for multiple types with as little code
1009     // repetition as possible, we write it in terms of a generic Map type with
1010     // bytes32 keys and values.
1011     // The Map implementation uses private functions, and user-facing
1012     // implementations (such as Uint256ToAddressMap) are just wrappers around
1013     // the underlying Map.
1014     // This means that we can only create new EnumerableMaps for types that fit
1015     // in bytes32.
1016 
1017     struct MapEntry {
1018         bytes32 _key;
1019         bytes32 _value;
1020     }
1021 
1022     struct Map {
1023         // Storage of map keys and values
1024         MapEntry[] _entries;
1025 
1026         // Position of the entry defined by a key in the `entries` array, plus 1
1027         // because index 0 means a key is not in the map.
1028         mapping (bytes32 => uint256) _indexes;
1029     }
1030 
1031     /**
1032      * @dev Adds a key-value pair to a map, or updates the value for an existing
1033      * key. O(1).
1034      *
1035      * Returns true if the key was added to the map, that is if it was not
1036      * already present.
1037      */
1038     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1039         // We read and store the key's index to prevent multiple reads from the same storage slot
1040         uint256 keyIndex = map._indexes[key];
1041 
1042         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1043             map._entries.push(MapEntry({ _key: key, _value: value }));
1044             // The entry is stored at length-1, but we add 1 to all indexes
1045             // and use 0 as a sentinel value
1046             map._indexes[key] = map._entries.length;
1047             return true;
1048         } else {
1049             map._entries[keyIndex - 1]._value = value;
1050             return false;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Removes a key-value pair from a map. O(1).
1056      *
1057      * Returns true if the key was removed from the map, that is if it was present.
1058      */
1059     function _remove(Map storage map, bytes32 key) private returns (bool) {
1060         // We read and store the key's index to prevent multiple reads from the same storage slot
1061         uint256 keyIndex = map._indexes[key];
1062 
1063         if (keyIndex != 0) { // Equivalent to contains(map, key)
1064             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1065             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1066             // This modifies the order of the array, as noted in {at}.
1067 
1068             uint256 toDeleteIndex = keyIndex - 1;
1069             uint256 lastIndex = map._entries.length - 1;
1070 
1071             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1072             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1073 
1074             MapEntry storage lastEntry = map._entries[lastIndex];
1075 
1076             // Move the last entry to the index where the entry to delete is
1077             map._entries[toDeleteIndex] = lastEntry;
1078             // Update the index for the moved entry
1079             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1080 
1081             // Delete the slot where the moved entry was stored
1082             map._entries.pop();
1083 
1084             // Delete the index for the deleted slot
1085             delete map._indexes[key];
1086 
1087             return true;
1088         } else {
1089             return false;
1090         }
1091     }
1092 
1093     /**
1094      * @dev Returns true if the key is in the map. O(1).
1095      */
1096     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1097         return map._indexes[key] != 0;
1098     }
1099 
1100     /**
1101      * @dev Returns the number of key-value pairs in the map. O(1).
1102      */
1103     function _length(Map storage map) private view returns (uint256) {
1104         return map._entries.length;
1105     }
1106 
1107    /**
1108     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1109     *
1110     * Note that there are no guarantees on the ordering of entries inside the
1111     * array, and it may change when more entries are added or removed.
1112     *
1113     * Requirements:
1114     *
1115     * - `index` must be strictly less than {length}.
1116     */
1117     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1118         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1119 
1120         MapEntry storage entry = map._entries[index];
1121         return (entry._key, entry._value);
1122     }
1123 
1124     /**
1125      * @dev Tries to returns the value associated with `key`.  O(1).
1126      * Does not revert if `key` is not in the map.
1127      */
1128     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1129         uint256 keyIndex = map._indexes[key];
1130         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1131         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1132     }
1133 
1134     /**
1135      * @dev Returns the value associated with `key`.  O(1).
1136      *
1137      * Requirements:
1138      *
1139      * - `key` must be in the map.
1140      */
1141     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1142         uint256 keyIndex = map._indexes[key];
1143         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1144         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1145     }
1146 
1147     /**
1148      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1149      *
1150      * CAUTION: This function is deprecated because it requires allocating memory for the error
1151      * message unnecessarily. For custom revert reasons use {_tryGet}.
1152      */
1153     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1154         uint256 keyIndex = map._indexes[key];
1155         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1156         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1157     }
1158 
1159     // UintToAddressMap
1160 
1161     struct UintToAddressMap {
1162         Map _inner;
1163     }
1164 
1165     /**
1166      * @dev Adds a key-value pair to a map, or updates the value for an existing
1167      * key. O(1).
1168      *
1169      * Returns true if the key was added to the map, that is if it was not
1170      * already present.
1171      */
1172     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1173         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1174     }
1175 
1176     /**
1177      * @dev Removes a value from a set. O(1).
1178      *
1179      * Returns true if the key was removed from the map, that is if it was present.
1180      */
1181     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1182         return _remove(map._inner, bytes32(key));
1183     }
1184 
1185     /**
1186      * @dev Returns true if the key is in the map. O(1).
1187      */
1188     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1189         return _contains(map._inner, bytes32(key));
1190     }
1191 
1192     /**
1193      * @dev Returns the number of elements in the map. O(1).
1194      */
1195     function length(UintToAddressMap storage map) internal view returns (uint256) {
1196         return _length(map._inner);
1197     }
1198 
1199    /**
1200     * @dev Returns the element stored at position `index` in the set. O(1).
1201     * Note that there are no guarantees on the ordering of values inside the
1202     * array, and it may change when more values are added or removed.
1203     *
1204     * Requirements:
1205     *
1206     * - `index` must be strictly less than {length}.
1207     */
1208     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1209         (bytes32 key, bytes32 value) = _at(map._inner, index);
1210         return (uint256(key), address(uint160(uint256(value))));
1211     }
1212 
1213     /**
1214      * @dev Tries to returns the value associated with `key`.  O(1).
1215      * Does not revert if `key` is not in the map.
1216      *
1217      * _Available since v3.4._
1218      */
1219     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1220         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1221         return (success, address(uint160(uint256(value))));
1222     }
1223 
1224     /**
1225      * @dev Returns the value associated with `key`.  O(1).
1226      *
1227      * Requirements:
1228      *
1229      * - `key` must be in the map.
1230      */
1231     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1232         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1233     }
1234 
1235     /**
1236      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1237      *
1238      * CAUTION: This function is deprecated because it requires allocating memory for the error
1239      * message unnecessarily. For custom revert reasons use {tryGet}.
1240      */
1241     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1242         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1243     }
1244 }
1245 
1246 /**
1247  * @dev String operations.
1248  */
1249 library Strings {
1250     /**
1251      * @dev Converts a `uint256` to its ASCII `string` representation.
1252      */
1253     function toString(uint256 value) internal pure returns (string memory) {
1254         // Inspired by OraclizeAPI's implementation - MIT licence
1255         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1256 
1257         if (value == 0) {
1258             return "0";
1259         }
1260         uint256 temp = value;
1261         uint256 digits;
1262         while (temp != 0) {
1263             digits++;
1264             temp /= 10;
1265         }
1266         bytes memory buffer = new bytes(digits);
1267         uint256 index = digits - 1;
1268         temp = value;
1269         while (temp != 0) {
1270             buffer[index--] = bytes1(uint8(48 + temp % 10));
1271             temp /= 10;
1272         }
1273         return string(buffer);
1274     }
1275 }
1276 
1277 
1278 
1279 /**
1280  * @title ERC721 Non-Fungible Token Standard basic implementation
1281  * @dev see https://eips.ethereum.org/EIPS/eip-721
1282  */
1283 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1284     using SafeMath for uint256;
1285     using Address for address;
1286     using EnumerableSet for EnumerableSet.UintSet;
1287     using EnumerableMap for EnumerableMap.UintToAddressMap;
1288     using Strings for uint256;
1289 
1290     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1291     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1292     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1293 
1294     // Mapping from holder address to their (enumerable) set of owned tokens
1295     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1296 
1297     // Enumerable mapping from token ids to their owners
1298     EnumerableMap.UintToAddressMap private _tokenOwners;
1299 
1300     // Mapping from token ID to approved address
1301     mapping (uint256 => address) private _tokenApprovals;
1302 
1303     // Mapping from owner to operator approvals
1304     mapping (address => mapping (address => bool)) private _operatorApprovals;
1305 
1306     // Token name
1307     string private _name;
1308 
1309     // Token symbol
1310     string private _symbol;
1311 
1312     // Optional mapping for token URIs
1313     mapping (uint256 => string) private _tokenURIs;
1314 
1315     // Base URI
1316     string private _baseURI;
1317 
1318     /*
1319      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1320      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1321      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1322      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1323      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1324      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1325      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1326      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1327      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1328      *
1329      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1330      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1331      */
1332     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1333 
1334     /*
1335      *     bytes4(keccak256('name()')) == 0x06fdde03
1336      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1337      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1338      *
1339      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1340      */
1341     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1342 
1343     /*
1344      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1345      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1346      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1347      *
1348      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1349      */
1350     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1351 
1352     /**
1353      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1354      */
1355     constructor (string memory name_, string memory symbol_) {
1356         _name = name_;
1357         _symbol = symbol_;
1358 
1359         // register the supported interfaces to conform to ERC721 via ERC165
1360         _registerInterface(_INTERFACE_ID_ERC721);
1361         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1362         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-balanceOf}.
1367      */
1368     function balanceOf(address owner) public view virtual override returns (uint256) {
1369         require(owner != address(0), "ERC721: balance query for the zero address");
1370         return _holderTokens[owner].length();
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-ownerOf}.
1375      */
1376     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1377         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-name}.
1382      */
1383     function name() public view virtual override returns (string memory) {
1384         return _name;
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Metadata-symbol}.
1389      */
1390     function symbol() public view virtual override returns (string memory) {
1391         return _symbol;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-tokenURI}.
1396      */
1397     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1398         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1399 
1400         string memory _tokenURI = _tokenURIs[tokenId];
1401         string memory base = baseURI();
1402 
1403         // If there is no base URI, return the token URI.
1404         if (bytes(base).length == 0) {
1405             return _tokenURI;
1406         }
1407         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1408         if (bytes(_tokenURI).length > 0) {
1409             return string(abi.encodePacked(base, _tokenURI));
1410         }
1411         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1412         return string(abi.encodePacked(base, tokenId.toString()));
1413     }
1414 
1415     /**
1416     * @dev Returns the base URI set via {_setBaseURI}. This will be
1417     * automatically added as a prefix in {tokenURI} to each token's URI, or
1418     * to the token ID if no specific URI is set for that token ID.
1419     */
1420     function baseURI() public view virtual returns (string memory) {
1421         return _baseURI;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1426      */
1427     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1428         return _holderTokens[owner].at(index);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-totalSupply}.
1433      */
1434     function totalSupply() public view virtual override returns (uint256) {
1435         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1436         return _tokenOwners.length();
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-tokenByIndex}.
1441      */
1442     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1443         (uint256 tokenId, ) = _tokenOwners.at(index);
1444         return tokenId;
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-approve}.
1449      */
1450     function approve(address to, uint256 tokenId) public virtual override {
1451         address owner = ERC721.ownerOf(tokenId);
1452         require(to != owner, "ERC721: approval to current owner");
1453 
1454         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1455             "ERC721: approve caller is not owner nor approved for all"
1456         );
1457 
1458         _approve(to, tokenId);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-getApproved}.
1463      */
1464     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1465         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1466 
1467         return _tokenApprovals[tokenId];
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-setApprovalForAll}.
1472      */
1473     function setApprovalForAll(address operator, bool approved) public virtual override {
1474         require(operator != _msgSender(), "ERC721: approve to caller");
1475 
1476         _operatorApprovals[_msgSender()][operator] = approved;
1477         emit ApprovalForAll(_msgSender(), operator, approved);
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-isApprovedForAll}.
1482      */
1483     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1484         return _operatorApprovals[owner][operator];
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-transferFrom}.
1489      */
1490     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1491         //solhint-disable-next-line max-line-length
1492         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1493 
1494         _transfer(from, to, tokenId);
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-safeTransferFrom}.
1499      */
1500     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1501         safeTransferFrom(from, to, tokenId, "");
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-safeTransferFrom}.
1506      */
1507     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1508         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1509         _safeTransfer(from, to, tokenId, _data);
1510     }
1511 
1512     /**
1513      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1514      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1515      *
1516      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1517      *
1518      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1519      * implement alternative mechanisms to perform token transfer, such as signature-based.
1520      *
1521      * Requirements:
1522      *
1523      * - `from` cannot be the zero address.
1524      * - `to` cannot be the zero address.
1525      * - `tokenId` token must exist and be owned by `from`.
1526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1531         _transfer(from, to, tokenId);
1532         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1533     }
1534 
1535     /**
1536      * @dev Returns whether `tokenId` exists.
1537      *
1538      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1539      *
1540      * Tokens start existing when they are minted (`_mint`),
1541      * and stop existing when they are burned (`_burn`).
1542      */
1543     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1544         return _tokenOwners.contains(tokenId);
1545     }
1546 
1547     /**
1548      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1549      *
1550      * Requirements:
1551      *
1552      * - `tokenId` must exist.
1553      */
1554     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1555         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1556         address owner = ERC721.ownerOf(tokenId);
1557         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1558     }
1559 
1560     /**
1561      * @dev Safely mints `tokenId` and transfers it to `to`.
1562      *
1563      * Requirements:
1564      d*
1565      * - `tokenId` must not exist.
1566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function _safeMint(address to, uint256 tokenId) internal virtual {
1571         _safeMint(to, tokenId, "");
1572     }
1573 
1574     /**
1575      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1576      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1577      */
1578     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1579         _mint(to, tokenId);
1580         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1581     }
1582 
1583     /**
1584      * @dev Mints `tokenId` and transfers it to `to`.
1585      *
1586      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1587      *
1588      * Requirements:
1589      *
1590      * - `tokenId` must not exist.
1591      * - `to` cannot be the zero address.
1592      *
1593      * Emits a {Transfer} event.
1594      */
1595     function _mint(address to, uint256 tokenId) internal virtual {
1596         require(to != address(0), "ERC721: mint to the zero address");
1597         require(!_exists(tokenId), "ERC721: token already minted");
1598 
1599         _beforeTokenTransfer(address(0), to, tokenId);
1600 
1601         _holderTokens[to].add(tokenId);
1602 
1603         _tokenOwners.set(tokenId, to);
1604 
1605         emit Transfer(address(0), to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev Destroys `tokenId`.
1610      * The approval is cleared when the token is burned.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function _burn(uint256 tokenId) internal virtual {
1619         address owner = ERC721.ownerOf(tokenId); // internal owner
1620 
1621         _beforeTokenTransfer(owner, address(0), tokenId);
1622 
1623         // Clear approvals
1624         _approve(address(0), tokenId);
1625 
1626         // Clear metadata (if any)
1627         if (bytes(_tokenURIs[tokenId]).length != 0) {
1628             delete _tokenURIs[tokenId];
1629         }
1630 
1631         _holderTokens[owner].remove(tokenId);
1632 
1633         _tokenOwners.remove(tokenId);
1634 
1635         emit Transfer(owner, address(0), tokenId);
1636     }
1637 
1638     /**
1639      * @dev Transfers `tokenId` from `from` to `to`.
1640      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1641      *
1642      * Requirements:
1643      *
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must be owned by `from`.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1650         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1651         require(to != address(0), "ERC721: transfer to the zero address");
1652 
1653         _beforeTokenTransfer(from, to, tokenId);
1654 
1655         // Clear approvals from the previous owner
1656         _approve(address(0), tokenId);
1657 
1658         _holderTokens[from].remove(tokenId);
1659         _holderTokens[to].add(tokenId);
1660 
1661         _tokenOwners.set(tokenId, to);
1662 
1663         emit Transfer(from, to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1668      *
1669      * Requirements:
1670      *
1671      * - `tokenId` must exist.
1672      */
1673     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1674         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1675         _tokenURIs[tokenId] = _tokenURI;
1676     }
1677 
1678     /**
1679      * @dev Internal function to set the base URI for all token IDs. It is
1680      * automatically added as a prefix to the value returned in {tokenURI},
1681      * or to the token ID if {tokenURI} is empty.
1682      */
1683     function _setBaseURI(string memory baseURI_) internal virtual {
1684         _baseURI = baseURI_;
1685     }
1686 
1687     /**
1688      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1689      * The call is not executed if the target address is not a contract.
1690      *
1691      * @param from address representing the previous owner of the given token ID
1692      * @param to target address that will receive the tokens
1693      * @param tokenId uint256 ID of the token to be transferred
1694      * @param _data bytes optional data to send along with the call
1695      * @return bool whether the call correctly returned the expected magic value
1696      */
1697     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1698         private returns (bool)
1699     {
1700         if (!to.isContract()) {
1701             return true;
1702         }
1703         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1704             IERC721Receiver(to).onERC721Received.selector,
1705             _msgSender(),
1706             from,
1707             tokenId,
1708             _data
1709         ), "ERC721: transfer to non ERC721Receiver implementer");
1710         bytes4 retval = abi.decode(returndata, (bytes4));
1711         return (retval == _ERC721_RECEIVED);
1712     }
1713 
1714     /**
1715      * @dev Approve `to` to operate on `tokenId`
1716      *
1717      * Emits an {Approval} event.
1718      */
1719     function _approve(address to, uint256 tokenId) internal virtual {
1720         _tokenApprovals[tokenId] = to;
1721         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1722     }
1723 
1724     /**
1725      * @dev Hook that is called before any token transfer. This includes minting
1726      * and burning.
1727      *
1728      * Calling conditions:
1729      *
1730      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1731      * transferred to `to`.
1732      * - When `from` is zero, `tokenId` will be minted for `to`.
1733      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1734      * - `from` cannot be the zero address.
1735      * - `to` cannot be the zero address.
1736      *
1737      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1738      */
1739     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1740 }
1741 
1742 /**
1743  * @dev Contract module which provides a basic access control mechanism, where
1744  * there is an account (an owner) that can be granted exclusive access to
1745  * specific functions.
1746  *
1747  * By default, the owner account will be the one that deploys the contract. This
1748  * can later be changed with {transferOwnership}.
1749  *
1750  * This module is used through inheritance. It will make available the modifier
1751  * `onlyOwner`, which can be applied to your functions to restrict their use to
1752  * the owner.
1753  */
1754 abstract contract Ownable is Context {
1755     address private _owner;
1756 
1757     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1758 
1759     /**
1760      * @dev Initializes the contract setting the deployer as the initial owner.
1761      */
1762     constructor () {
1763         address msgSender = _msgSender();
1764         _owner = msgSender;
1765         emit OwnershipTransferred(address(0), msgSender);
1766     }
1767 
1768     /**
1769      * @dev Returns the address of the current owner.
1770      */
1771     function owner() public view virtual returns (address) {
1772         return _owner;
1773     }
1774 
1775     /**
1776      * @dev Throws if called by any account other than the owner.
1777      */
1778     modifier onlyOwner() {
1779         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1780         _;
1781     }
1782 
1783     /**
1784      * @dev Leaves the contract without owner. It will not be possible to call
1785      * `onlyOwner` functions anymore. Can only be called by the current owner.
1786      *
1787      * NOTE: Renouncing ownership will leave the contract without an owner,
1788      * thereby removing any functionality that is only available to the owner.
1789      */
1790     function renounceOwnership() public virtual onlyOwner {
1791         emit OwnershipTransferred(_owner, address(0));
1792         _owner = address(0);
1793     }
1794 
1795     /**
1796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1797      * Can only be called by the current owner.
1798      */
1799     function transferOwnership(address newOwner) public virtual onlyOwner {
1800         require(newOwner != address(0), "Ownable: new owner is the zero address");
1801         emit OwnershipTransferred(_owner, newOwner);
1802         _owner = newOwner;
1803     }
1804 }
1805 
1806 
1807 /**
1808  * @title SSC Contract
1809  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1810  */
1811 contract SSC is ERC721, Ownable {
1812     using SafeMath for uint256;
1813 
1814     uint256 public constant price = 80000000000000000; //0.08 ETH
1815 
1816     uint public constant maxPurchase = 20;
1817 
1818     uint256 public MAX = 8888;
1819 
1820     bool public saleIsActive = false;
1821     
1822     mapping (address => bool) public whitelisted;
1823     mapping (address => bool) public trxDone;
1824     bool public whitelistedPhase = true;
1825     
1826     
1827     
1828     function whitelist(address[] memory wallets) public onlyOwner{
1829         for(uint256 i = 0 ; i< wallets.length ; i++){
1830             whitelisted[wallets[i]] = true;
1831         }
1832     }
1833 
1834     constructor() ERC721("Sovereign Sphynx Council", "SSC") {
1835     }
1836     
1837 
1838     function withdraw() public onlyOwner {
1839         uint balance = address(this).balance;
1840         
1841         address payable one = 0xdAdEC7a9eC9a423A4Ab43102E3bf3Cf57b77044B;
1842         address payable two = 0xe2339E4483aBa0877d760872304ddECd5e275C6C;
1843         address payable three = 0x56e11B783b3d90d58Eb921c7382Af50976DfD421;
1844         address payable four = 0x24834C2878d9cEAAfa97d7Cab3e2142A0819F0E8;
1845         address payable five = 0xAa894D037129991aBb3D1F3A2c4c3332df4d88f0;
1846         address payable six = 0xa0D0fdB7e2B68662fA9C06cB90B7B5eaDeF48D02;
1847         address payable seven = 0xBE1a3485Ce0b625c7416F650eEdd1E2b20E1E641;
1848         address payable eight = 0x8f0229108eace4612f33cFCf5DDA7eDfFa8E5d77;
1849         
1850         
1851         one.transfer(balance.mul(20).div(100));
1852         two.transfer(balance.mul(21).div(100));
1853         three.transfer(balance.mul(10).div(100));
1854         four.transfer(balance.mul(10).div(100));
1855         five.transfer(balance.mul(10).div(100));
1856         six.transfer(balance.mul(10).div(100));
1857         seven.transfer(balance.mul(6).div(100));
1858         eight.transfer(balance.mul(4).div(100));
1859 
1860         address payable nine = 0x5BFE64E390B9daD3fCa364Ea17Dbeb0c7cf7a2d5;
1861         address payable ten = 0xAB6201b7211829d58dB8CA15b121fb63B5040010;
1862         
1863         uint balanceAgain = balance;
1864         
1865         nine.transfer(balanceAgain.mul(7).div(100));
1866         ten.transfer(balanceAgain.mul(2).div(100));
1867         
1868     }
1869 
1870     function setBaseURI(string memory baseURI) public onlyOwner {
1871         _setBaseURI(baseURI);
1872     }
1873 
1874     /*
1875     * Pause sale if active, make active if paused
1876     */
1877     function flipSaleState() public onlyOwner {
1878         saleIsActive = !saleIsActive;
1879     }
1880     
1881       /*
1882     * Include so everyone can participate
1883     */
1884     function includeEveryone() public onlyOwner {
1885         whitelistedPhase = false;
1886     }
1887     
1888     
1889     /**
1890     * Mints SSC
1891     */
1892     function mintSSC(uint numberOfTokens) public payable {
1893         require(saleIsActive, "Sale must be active to mint SSC");
1894         require(numberOfTokens <= maxPurchase, "Can only mint 20 tokens at a time");
1895         require(price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1896         require(totalSupply().add(numberOfTokens) <= MAX, "Purchase would exceed max supply of SSC");
1897         
1898         if(whitelistedPhase){
1899             require(whitelisted[msg.sender], 'Only whitelisted wallets can participate right now');
1900             require(!trxDone[msg.sender] , "Can only do One successful transaction");
1901             trxDone[msg.sender] = true;
1902         }
1903         
1904         
1905         for(uint i = 0; i < numberOfTokens; i++) {
1906             uint mintIndex = totalSupply();
1907             if (totalSupply() < MAX) {
1908                 _safeMint(msg.sender, mintIndex);
1909             }
1910         }
1911     }
1912 }