1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity = 0.8.9;
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
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 /**
48  * @dev Required interface of an ERC721 compliant contract.
49  */
50 interface IERC721 is IERC165 {
51     /**
52      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
53      */
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
65 
66     /**
67      * @dev Returns the number of tokens in ``owner``'s account.
68      */
69     function balanceOf(address owner) external view returns (uint256 balance);
70 
71     /**
72      * @dev Returns the owner of the `tokenId` token.
73      *
74      * Requirements:
75      *
76      * - `tokenId` must exist.
77      */
78     function ownerOf(uint256 tokenId) external view returns (address owner);
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(address from, address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156       * @dev Safely transfers `tokenId` token from `from` to `to`.
157       *
158       * Requirements:
159       *
160       * - `from` cannot be the zero address.
161       * - `to` cannot be the zero address.
162       * - `tokenId` token must exist and be owned by `from`.
163       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165       *
166       * Emits a {Transfer} event.
167       */
168     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
169 }
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Metadata is IERC721 {
176 
177     /**
178      * @dev Returns the token collection name.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the token collection symbol.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
189      */
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191     
192 }
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Enumerable is IERC721 {
199 
200     /**
201      * @dev Returns the total amount of tokens stored by the contract.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
207      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
208      */
209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
210 
211     /**
212      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
213      * Use along with {totalSupply} to enumerate all tokens.
214      */
215     function tokenByIndex(uint256 index) external view returns (uint256);
216 }
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  * from ERC721 asset contracts.
222  */
223 interface IERC721Receiver {
224     /**
225      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
226      * by `operator` from `from`, this function is called.
227      *
228      * It must return its Solidity selector to confirm the token transfer.
229      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
230      *
231      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
232      */
233     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
234 }
235 
236 /**
237  * @dev Implementation of the {IERC165} interface.
238  *
239  * Contracts may inherit from this and call {_registerInterface} to declare
240  * their support of an interface.
241  */
242 abstract contract ERC165 is IERC165 {
243     /*
244      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
245      */
246     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
247 
248     /**
249      * @dev Mapping of interface ids to whether or not it's supported.
250      */
251     mapping(bytes4 => bool) private _supportedInterfaces;
252 
253     constructor () {
254         // Derived contracts need only register support for their own interfaces,
255         // we register support for ERC165 itself here
256         _registerInterface(_INTERFACE_ID_ERC165);
257     }
258 
259     /**
260      * @dev See {IERC165-supportsInterface}.
261      *
262      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
263      */
264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265         return _supportedInterfaces[interfaceId];
266     }
267 
268     /**
269      * @dev Registers the contract as an implementer of the interface defined by
270      * `interfaceId`. Support of the actual ERC165 interface is automatic and
271      * registering its interface id is not required.
272      *
273      * See {IERC165-supportsInterface}.
274      *
275      * Requirements:
276      *
277      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
278      */
279     function _registerInterface(bytes4 interfaceId) internal virtual {
280         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
281         _supportedInterfaces[interfaceId] = true;
282     }
283 }
284 
285 /**
286  * @dev Wrappers over Solidity's arithmetic operations with added overflow
287  * checks.
288  *
289  * Arithmetic operations in Solidity wrap on overflow. This can easily result
290  * in bugs, because programmers usually assume that an overflow raises an
291  * error, which is the standard behavior in high level programming languages.
292  * `SafeMath` restores this intuition by reverting the transaction when an
293  * operation overflows.
294  *
295  * Using this library instead of the unchecked operations eliminates an entire
296  * class of bugs, so it's recommended to use it always.
297  */
298 library SafeMath {
299     /**
300      * @dev Returns the addition of two unsigned integers, with an overflow flag.
301      *
302      * _Available since v3.4._
303      */
304     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         uint256 c = a + b;
306         if (c < a) return (false, 0);
307         return (true, c);
308     }
309 
310     /**
311      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
312      *
313      * _Available since v3.4._
314      */
315     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
316         if (b > a) return (false, 0);
317         return (true, a - b);
318     }
319 
320     /**
321      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
322      *
323      * _Available since v3.4._
324      */
325     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
326         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
327         // benefit is lost if 'b' is also tested.
328         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
329         if (a == 0) return (true, 0);
330         uint256 c = a * b;
331         if (c / a != b) return (false, 0);
332         return (true, c);
333     }
334 
335     /**
336      * @dev Returns the division of two unsigned integers, with a division by zero flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         if (b == 0) return (false, 0);
342         return (true, a / b);
343     }
344 
345     /**
346      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
347      *
348      * _Available since v3.4._
349      */
350     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
351         if (b == 0) return (false, 0);
352         return (true, a % b);
353     }
354 
355     /**
356      * @dev Returns the addition of two unsigned integers, reverting on
357      * overflow.
358      *
359      * Counterpart to Solidity's `+` operator.
360      *
361      * Requirements:
362      *
363      * - Addition cannot overflow.
364      */
365     function add(uint256 a, uint256 b) internal pure returns (uint256) {
366         uint256 c = a + b;
367         require(c >= a, "SafeMath: addition overflow");
368         return c;
369     }
370 
371     /**
372      * @dev Returns the subtraction of two unsigned integers, reverting on
373      * overflow (when the result is negative).
374      *
375      * Counterpart to Solidity's `-` operator.
376      *
377      * Requirements:
378      *
379      * - Subtraction cannot overflow.
380      */
381     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
382         require(b <= a, "SafeMath: subtraction overflow");
383         return a - b;
384     }
385 
386     /**
387      * @dev Returns the multiplication of two unsigned integers, reverting on
388      * overflow.
389      *
390      * Counterpart to Solidity's `*` operator.
391      *
392      * Requirements:
393      *
394      * - Multiplication cannot overflow.
395      */
396     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
397         if (a == 0) return 0;
398         uint256 c = a * b;
399         require(c / a == b, "SafeMath: multiplication overflow");
400         return c;
401     }
402 
403     /**
404      * @dev Returns the integer division of two unsigned integers, reverting on
405      * division by zero. The result is rounded towards zero.
406      *
407      * Counterpart to Solidity's `/` operator. Note: this function uses a
408      * `revert` opcode (which leaves remaining gas untouched) while Solidity
409      * uses an invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function div(uint256 a, uint256 b) internal pure returns (uint256) {
416         require(b > 0, "SafeMath: division by zero");
417         return a / b;
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * reverting when dividing by zero.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
433         require(b > 0, "SafeMath: modulo by zero");
434         return a % b;
435     }
436 
437     /**
438      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
439      * overflow (when the result is negative).
440      *
441      * CAUTION: This function is deprecated because it requires allocating memory for the error
442      * message unnecessarily. For custom revert reasons use {trySub}.
443      *
444      * Counterpart to Solidity's `-` operator.
445      *
446      * Requirements:
447      *
448      * - Subtraction cannot overflow.
449      */
450     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b <= a, errorMessage);
452         return a - b;
453     }
454 
455     /**
456      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
457      * division by zero. The result is rounded towards zero.
458      *
459      * CAUTION: This function is deprecated because it requires allocating memory for the error
460      * message unnecessarily. For custom revert reasons use {tryDiv}.
461      *
462      * Counterpart to Solidity's `/` operator. Note: this function uses a
463      * `revert` opcode (which leaves remaining gas untouched) while Solidity
464      * uses an invalid opcode to revert (consuming all remaining gas).
465      *
466      * Requirements:
467      *
468      * - The divisor cannot be zero.
469      */
470     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
471         require(b > 0, errorMessage);
472         return a / b;
473     }
474 
475     /**
476      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
477      * reverting with custom message when dividing by zero.
478      *
479      * CAUTION: This function is deprecated because it requires allocating memory for the error
480      * message unnecessarily. For custom revert reasons use {tryMod}.
481      *
482      * Counterpart to Solidity's `%` operator. This function uses a `revert`
483      * opcode (which leaves remaining gas untouched) while Solidity uses an
484      * invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      *
488      * - The divisor cannot be zero.
489      */
490     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
491         require(b > 0, errorMessage);
492         return a % b;
493     }
494 }
495 
496 /**
497  * @dev Collection of functions related to the address type
498  */
499 library Address {
500     /**
501      * @dev Returns true if `account` is a contract.
502      *
503      * [IMPORTANT]
504      * ====
505      * It is unsafe to assume that an address for which this function returns
506      * false is an externally-owned account (EOA) and not a contract.
507      *
508      * Among others, `isContract` will return false for the following
509      * types of addresses:
510      *
511      *  - an externally-owned account
512      *  - a contract in construction
513      *  - an address where a contract will be created
514      *  - an address where a contract lived, but was destroyed
515      * ====
516      */
517     function isContract(address account) internal view returns (bool) {
518         // This method relies on extcodesize, which returns 0 for contracts in
519         // construction, since the code is only stored at the end of the
520         // constructor execution.
521 
522         uint256 size;
523         // solhint-disable-next-line no-inline-assembly
524         assembly { size := extcodesize(account) }
525         return size > 0;
526     }
527 
528     /**
529      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
530      * `recipient`, forwarding all available gas and reverting on errors.
531      *
532      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
533      * of certain opcodes, possibly making contracts go over the 2300 gas limit
534      * imposed by `transfer`, making them unable to receive funds via
535      * `transfer`. {sendValue} removes this limitation.
536      *
537      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
538      *
539      * IMPORTANT: because control is transferred to `recipient`, care must be
540      * taken to not create reentrancy vulnerabilities. Consider using
541      * {ReentrancyGuard} or the
542      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
543      */
544     function sendValue(address payable recipient, uint256 amount) internal {
545         require(address(this).balance >= amount, "Address: insufficient balance");
546 
547         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
548         (bool success, ) = recipient.call{ value: amount }("");
549         require(success, "Address: unable to send value, recipient may have reverted");
550     }
551 
552     /**
553      * @dev Performs a Solipragma solidity >=0.6.0 <0.8.0;dity function call using a low level `call`. A
554      * plain`call` is an unsafe replacement for a function call: use this
555      * function instead.
556      *
557      * If `target` reverts with a revert reason, it is bubbled up by this
558      * function (like regular Solidity function calls).
559      *
560      * Returns the raw returned data. To convert to the expected return value,
561      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
562      *
563      * Requirements:
564      *
565      * - `target` must be a contract.
566      * - calling `target` with `data` must not revert.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
571       return functionCall(target, data, "Address: low-level call failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
576      * `errorMessage` as a fallback revert reason when `target` reverts.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
581         return functionCallWithValue(target, data, 0, errorMessage);
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
586      * but also transferring `value` wei to `target`.
587      *
588      * Requirements:
589      *
590      * - the calling contract must have an ETH balance of at least `value`.
591      * - the called Solidity function must be `payable`.
592      *
593      * _Available since v3.1._
594      */
595     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
601      * with `errorMessage` as a fallback revert reason when `target` reverts.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
606         require(address(this).balance >= value, "Address: insufficient balance for call");
607         require(isContract(target), "Address: call to non-contract");
608 
609         // solhint-disable-next-line avoid-low-level-calls
610         (bool success, bytes memory returndata) = target.call{ value: value }(data);
611         return _verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
631         require(isContract(target), "Address: static call to non-contract");
632 
633         // solhint-disable-next-line avoid-low-level-calls
634         (bool success, bytes memory returndata) = target.staticcall(data);
635         return _verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
655         require(isContract(target), "Address: delegate call to non-contract");
656 
657         // solhint-disable-next-line avoid-low-level-calls
658         (bool success, bytes memory returndata) = target.delegatecall(data);
659         return _verifyCallResult(success, returndata, errorMessage);
660     }
661 
662     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
663         if (success) {
664             return returndata;
665         } else {
666             // Look for revert reason and bubble it up if present
667             if (returndata.length > 0) {
668                 // The easiest way to bubble the revert reason is using memory via assembly
669 
670                 // solhint-disable-next-line no-inline-assembly
671                 assembly {
672                     let returndata_size := mload(returndata)
673                     revert(add(32, returndata), returndata_size)
674                 }
675             } else {
676                 revert(errorMessage);
677             }
678         }
679     }
680 }
681 
682 /**
683  * @dev Library for managing
684  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
685  * types.
686  *
687  * Sets have the following properties:
688  *
689  * - Elements are added, removed, and checked for existence in constant time
690  * (O(1)).
691  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
692  *
693  * ```
694  * contract Example {
695  *     // Add the library methods
696  *     using EnumerableSet for EnumerableSet.AddressSet;
697  *
698  *     // Declare a set state variable
699  *     EnumerableSet.AddressSet private mySet;
700  * }
701  * ```
702  *
703  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
704  * and `uint256` (`UintSet`) are supported.
705  */
706 library EnumerableSet {
707     // To implement this library for multiple types with as little code
708     // repetition as possible, we write it in terms of a generic Set type with
709     // bytes32 values.
710     // The Set implementation uses private functions, and user-facing
711     // implementations (such as AddressSet) are just wrappers around the
712     // underlying Set.
713     // This means that we can only create new EnumerableSets for types that fit
714     // in bytes32.
715 
716     struct Set {
717         // Storage of set values
718         bytes32[] _values;
719 
720         // Position of the value in the `values` array, plus 1 because index 0
721         // means a value is not in the set.
722         mapping (bytes32 => uint256) _indexes;
723     }
724 
725     /**
726      * @dev Add a value to a set. O(1).
727      *
728      * Returns true if the value was added to the set, that is if it was not
729      * already present.
730      */
731     function _add(Set storage set, bytes32 value) private returns (bool) {
732         if (!_contains(set, value)) {
733             set._values.push(value);
734             // The value is stored at length-1, but we add 1 to all indexes
735             // and use 0 as a sentinel value
736             set._indexes[value] = set._values.length;
737             return true;
738         } else {
739             return false;
740         }
741     }
742 
743     /**
744      * @dev Removes a value from a set. O(1).
745      *
746      * Returns true if the value was removed from the set, that is if it was
747      * present.
748      */
749     function _remove(Set storage set, bytes32 value) private returns (bool) {
750         // We read and store the value's index to prevent multiple reads from the same storage slot
751         uint256 valueIndex = set._indexes[value];
752 
753         if (valueIndex != 0) { // Equivalent to contains(set, value)
754             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
755             // the array, and then remove the last element (sometimes called as 'swap and pop').
756             // This modifies the order of the array, as noted in {at}.
757 
758             uint256 toDeleteIndex = valueIndex - 1;
759             uint256 lastIndex = set._values.length - 1;
760 
761             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
762             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
763 
764             bytes32 lastvalue = set._values[lastIndex];
765 
766             // Move the last value to the index where the value to delete is
767             set._values[toDeleteIndex] = lastvalue;
768             // Update the index for the moved value
769             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
770 
771             // Delete the slot where the moved value was stored
772             set._values.pop();
773 
774             // Delete the index for the deleted slot
775             delete set._indexes[value];
776 
777             return true;
778         } else {
779             return false;
780         }
781     }
782 
783     /**
784      * @dev Returns true if the value is in the set. O(1).
785      */
786     function _contains(Set storage set, bytes32 value) private view returns (bool) {
787         return set._indexes[value] != 0;
788     }
789 
790     /**
791      * @dev Returns the number of values on the set. O(1).
792      */
793     function _length(Set storage set) private view returns (uint256) {
794         return set._values.length;
795     }
796 
797    /**
798     * @dev Returns the value stored at position `index` in the set. O(1).
799     *
800     * Note that there are no guarantees on the ordering of values inside the
801     * array, and it may change when more values are added or removed.
802     *
803     * Requirements:
804     *
805     * - `index` must be strictly less than {length}.
806     */
807     function _at(Set storage set, uint256 index) private view returns (bytes32) {
808         require(set._values.length > index, "EnumerableSet: index out of bounds");
809         return set._values[index];
810     }
811 
812     // Bytes32Set
813 
814     struct Bytes32Set {
815         Set _inner;
816     }
817 
818     /**
819      * @dev Add a value to a set. O(1).
820      *
821      * Returns true if the value was added to the set, that is if it was not
822      * already present.
823      */
824     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
825         return _add(set._inner, value);
826     }
827 
828     /**
829      * @dev Removes a value from a set. O(1).
830      *
831      * Returns true if the value was removed from the set, that is if it was
832      * present.
833      */
834     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
835         return _remove(set._inner, value);
836     }
837 
838     /**
839      * @dev Returns true if the value is in the set. O(1).
840      */
841     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
842         return _contains(set._inner, value);
843     }
844 
845     /**
846      * @dev Returns the number of values in the set. O(1).
847      */
848     function length(Bytes32Set storage set) internal view returns (uint256) {
849         return _length(set._inner);
850     }
851 
852    /**
853     * @dev Returns the value stored at position `index` in the set. O(1).
854     *
855     * Note that there are no guarantees on the ordering of values inside the
856     * array, and it may change when more values are added or removed.
857     *
858     * Requirements:
859     *
860     * - `index` must be strictly less than {length}.
861     */
862     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
863         return _at(set._inner, index);
864     }
865 
866     // AddressSet
867 
868     struct AddressSet {
869         Set _inner;
870     }
871 
872     /**
873      * @dev Add a value to a set. O(1).
874      *
875      * Returns true if the value was added to the set, that is if it was not
876      * already present.
877      */
878     function add(AddressSet storage set, address value) internal returns (bool) {
879         return _add(set._inner, bytes32(uint256(uint160(value))));
880     }
881 
882     /**
883      * @dev Removes a value from a set. O(1).
884      *
885      * Returns true if the value was removed from the set, that is if it was
886      * present.
887      */
888     function remove(AddressSet storage set, address value) internal returns (bool) {
889         return _remove(set._inner, bytes32(uint256(uint160(value))));
890     }
891 
892     /**
893      * @dev Returns true if the value is in the set. O(1).
894      */
895     function contains(AddressSet storage set, address value) internal view returns (bool) {
896         return _contains(set._inner, bytes32(uint256(uint160(value))));
897     }
898 
899     /**
900      * @dev Returns the number of values in the set. O(1).
901      */
902     function length(AddressSet storage set) internal view returns (uint256) {
903         return _length(set._inner);
904     }
905 
906    /**
907     * @dev Returns the value stored at position `index` in the set. O(1).
908     *
909     * Note that there are no guarantees on the ordering of values inside the
910     * array, and it may change when more values are added or removed.
911     *
912     * Requirements:
913     *
914     * - `index` must be strictly less than {length}.
915     */
916     function at(AddressSet storage set, uint256 index) internal view returns (address) {
917         return address(uint160(uint256(_at(set._inner, index))));
918     }
919 
920 
921     // UintSet
922 
923     struct UintSet {
924         Set _inner;
925     }
926 
927     /**
928      * @dev Add a value to a set. O(1).
929      *
930      * Returns true if the value was added to the set, that is if it was not
931      * already present.
932      */
933     function add(UintSet storage set, uint256 value) internal returns (bool) {
934         return _add(set._inner, bytes32(value));
935     }
936 
937     /**
938      * @dev Removes a value from a set. O(1).
939      *
940      * Returns true if the value was removed from the set, that is if it was
941      * present.
942      */
943     function remove(UintSet storage set, uint256 value) internal returns (bool) {
944         return _remove(set._inner, bytes32(value));
945     }
946 
947     /**
948      * @dev Returns true if the value is in the set. O(1).
949      */
950     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
951         return _contains(set._inner, bytes32(value));
952     }
953 
954     /**
955      * @dev Returns the number of values on the set. O(1).
956      */
957     function length(UintSet storage set) internal view returns (uint256) {
958         return _length(set._inner);
959     }
960 
961    /**
962     * @dev Returns the value stored at position `index` in the set. O(1).
963     *
964     * Note that there are no guarantees on the ordering of values inside the
965     * array, and it may change when more values are added or removed.
966     *
967     * Requirements:
968     *
969     * - `index` must be strictly less than {length}.
970     */
971     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
972         return uint256(_at(set._inner, index));
973     }
974 }
975 
976 /**
977  * @dev Library for managing an enumerable variant of Solidity's
978  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
979  * type.
980  *
981  * Maps have the following properties:
982  *
983  * - Entries are added, removed, and checked for existence in constant time
984  * (O(1)).
985  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
986  *
987  * ```
988  * contract Example {
989  *     // Add the library methods
990  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
991  *
992  *     // Declare a set state variable
993  *     EnumerableMap.UintToAddressMap private myMap;
994  * }
995  * ```
996  *
997  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
998  * supported.
999  */
1000 library EnumerableMap {
1001     // To implement this library for multiple types with as little code
1002     // repetition as possible, we write it in terms of a generic Map type with
1003     // bytes32 keys and values.
1004     // The Map implementation uses private functions, and user-facing
1005     // implementations (such as Uint256ToAddressMap) are just wrappers around
1006     // the underlying Map.
1007     // This means that we can only create new EnumerableMaps for types that fit
1008     // in bytes32.
1009 
1010     struct MapEntry {
1011         bytes32 _key;
1012         bytes32 _value;
1013     }
1014 
1015     struct Map {
1016         // Storage of map keys and values
1017         MapEntry[] _entries;
1018 
1019         // Position of the entry defined by a key in the `entries` array, plus 1
1020         // because index 0 means a key is not in the map.
1021         mapping (bytes32 => uint256) _indexes;
1022     }
1023 
1024     /**
1025      * @dev Adds a key-value pair to a map, or updates the value for an existing
1026      * key. O(1).
1027      *
1028      * Returns true if the key was added to the map, that is if it was not
1029      * already present.
1030      */
1031     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1032         // We read and store the key's index to prevent multiple reads from the same storage slot
1033         uint256 keyIndex = map._indexes[key];
1034 
1035         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1036             map._entries.push(MapEntry({ _key: key, _value: value }));
1037             // The entry is stored at length-1, but we add 1 to all indexes
1038             // and use 0 as a sentinel value
1039             map._indexes[key] = map._entries.length;
1040             return true;
1041         } else {
1042             map._entries[keyIndex - 1]._value = value;
1043             return false;
1044         }
1045     }
1046 
1047     /**
1048      * @dev Removes a key-value pair from a map. O(1).
1049      *
1050      * Returns true if the key was removed from the map, that is if it was present.
1051      */
1052     function _remove(Map storage map, bytes32 key) private returns (bool) {
1053         // We read and store the key's index to prevent multiple reads from the same storage slot
1054         uint256 keyIndex = map._indexes[key];
1055 
1056         if (keyIndex != 0) { // Equivalent to contains(map, key)
1057             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1058             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1059             // This modifies the order of the array, as noted in {at}.
1060 
1061             uint256 toDeleteIndex = keyIndex - 1;
1062             uint256 lastIndex = map._entries.length - 1;
1063 
1064             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1065             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1066 
1067             MapEntry storage lastEntry = map._entries[lastIndex];
1068 
1069             // Move the last entry to the index where the entry to delete is
1070             map._entries[toDeleteIndex] = lastEntry;
1071             // Update the index for the moved entry
1072             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1073 
1074             // Delete the slot where the moved entry was stored
1075             map._entries.pop();
1076 
1077             // Delete the index for the deleted slot
1078             delete map._indexes[key];
1079 
1080             return true;
1081         } else {
1082             return false;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns true if the key is in the map. O(1).
1088      */
1089     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1090         return map._indexes[key] != 0;
1091     }
1092 
1093     /**
1094      * @dev Returns the number of key-value pairs in the map. O(1).
1095      */
1096     function _length(Map storage map) private view returns (uint256) {
1097         return map._entries.length;
1098     }
1099 
1100    /**
1101     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1102     *
1103     * Note that there are no guarantees on the ordering of entries inside the
1104     * array, and it may change when more entries are added or removed.
1105     *
1106     * Requirements:
1107     *
1108     * - `index` must be strictly less than {length}.
1109     */
1110     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1111         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1112 
1113         MapEntry storage entry = map._entries[index];
1114         return (entry._key, entry._value);
1115     }
1116 
1117     /**
1118      * @dev Tries to returns the value associated with `key`.  O(1).
1119      * Does not revert if `key` is not in the map.
1120      */
1121     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1122         uint256 keyIndex = map._indexes[key];
1123         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1124         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1125     }
1126 
1127     /**
1128      * @dev Returns the value associated with `key`.  O(1).
1129      *
1130      * Requirements:
1131      *
1132      * - `key` must be in the map.
1133      */
1134     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1135         uint256 keyIndex = map._indexes[key];
1136         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1137         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1138     }
1139 
1140     /**
1141      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1142      *
1143      * CAUTION: This function is deprecated because it requires allocating memory for the error
1144      * message unnecessarily. For custom revert reasons use {_tryGet}.
1145      */
1146     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1147         uint256 keyIndex = map._indexes[key];
1148         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1149         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1150     }
1151 
1152     // UintToAddressMap
1153 
1154     struct UintToAddressMap {
1155         Map _inner;
1156     }
1157 
1158     /**
1159      * @dev Adds a key-value pair to a map, or updates the value for an existing
1160      * key. O(1).
1161      *
1162      * Returns true if the key was added to the map, that is if it was not
1163      * already present.
1164      */
1165     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1166         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1167     }
1168 
1169     /**
1170      * @dev Removes a value from a set. O(1).
1171      *
1172      * Returns true if the key was removed from the map, that is if it was present.
1173      */
1174     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1175         return _remove(map._inner, bytes32(key));
1176     }
1177 
1178     /**
1179      * @dev Returns true if the key is in the map. O(1).
1180      */
1181     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1182         return _contains(map._inner, bytes32(key));
1183     }
1184 
1185     /**
1186      * @dev Returns the number of elements in the map. O(1).
1187      */
1188     function length(UintToAddressMap storage map) internal view returns (uint256) {
1189         return _length(map._inner);
1190     }
1191 
1192    /**
1193     * @dev Returns the element stored at position `index` in the set. O(1).
1194     * Note that there are no guarantees on the ordering of values inside the
1195     * array, and it may change when more values are added or removed.
1196     *
1197     * Requirements:
1198     *
1199     * - `index` must be strictly less than {length}.
1200     */
1201     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1202         (bytes32 key, bytes32 value) = _at(map._inner, index);
1203         return (uint256(key), address(uint160(uint256(value))));
1204     }
1205 
1206     /**
1207      * @dev Tries to returns the value associated with `key`.  O(1).
1208      * Does not revert if `key` is not in the map.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1213         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1214         return (success, address(uint160(uint256(value))));
1215     }
1216 
1217     /**
1218      * @dev Returns the value associated with `key`.  O(1).
1219      *
1220      * Requirements:
1221      *
1222      * - `key` must be in the map.
1223      */
1224     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1225         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1226     }
1227 
1228     /**
1229      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1230      *
1231      * CAUTION: This function is deprecated because it requires allocating memory for the error
1232      * message unnecessarily. For custom revert reasons use {tryGet}.
1233      */
1234     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1235         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1236     }
1237 }
1238 
1239 /**
1240  * @dev String operations.
1241  */
1242 library Strings {
1243     bytes16 private constant alphabet = "0123456789abcdef";
1244 
1245     /**
1246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1247      */
1248     function toString(uint256 value) internal pure returns (string memory) {
1249         // Inspired by OraclizeAPI's implementation - MIT licence
1250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1251 
1252         if (value == 0) {
1253             return "0";
1254         }
1255         uint256 temp = value;
1256         uint256 digits;
1257         while (temp != 0) {
1258             digits++;
1259             temp /= 10;
1260         }
1261         bytes memory buffer = new bytes(digits);
1262         while (value != 0) {
1263             digits -= 1;
1264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1265             value /= 10;
1266         }
1267         return string(buffer);
1268     }
1269 
1270     /**
1271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1272      */
1273     function toHexString(uint256 value) internal pure returns (string memory) {
1274         if (value == 0) {
1275             return "0x00";
1276         }
1277         uint256 temp = value;
1278         uint256 length = 0;
1279         while (temp != 0) {
1280             length++;
1281             temp >>= 8;
1282         }
1283         return toHexString(value, length);
1284     }
1285 
1286     /**
1287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1288      */
1289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1290         bytes memory buffer = new bytes(2 * length + 2);
1291         buffer[0] = "0";
1292         buffer[1] = "x";
1293         for (uint256 i = 2 * length + 1; i > 1; --i) {
1294             buffer[i] = alphabet[value & 0xf];
1295             value >>= 4;
1296         }
1297         require(value == 0, "Strings: hex length insufficient");
1298         return string(buffer);
1299     }
1300 
1301 }
1302 
1303 /**
1304  * @title ERC721 Non-Fungible Token Standard basic implementation
1305  * @dev see https://eips.ethereum.org/EIPS/eip-721
1306  */
1307 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1308     using SafeMath for uint256;
1309     using Address for address;
1310     using EnumerableSet for EnumerableSet.UintSet;
1311     using EnumerableMap for EnumerableMap.UintToAddressMap;
1312     using Strings for uint256;
1313 
1314     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1315     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1316     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1317 
1318     // Mapping from holder address to their (enumerable) set of owned tokens
1319     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1320 
1321     // Enumerable mapping from token ids to their owners
1322     EnumerableMap.UintToAddressMap private _tokenOwners;
1323 
1324     // Mapping from token ID to approved address
1325     mapping (uint256 => address) private _tokenApprovals;
1326 
1327     // Mapping from owner to operator approvals
1328     mapping (address => mapping (address => bool)) private _operatorApprovals;
1329 
1330     // Token name
1331     string private _name;
1332 
1333     // Token symbol
1334     string private _symbol;
1335 
1336     // Optional mapping for token URIs
1337     mapping (uint256 => string) private _tokenURIs;
1338 
1339     // Base URI
1340     string private _baseURI;
1341 
1342     /*
1343      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1344      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1345      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1346      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1347      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1348      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1349      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1350      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1351      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1352      *
1353      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1354      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1355      */
1356     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1357 
1358     /*
1359      *     bytes4(keccak256('name()')) == 0x06fdde03
1360      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1361      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1362      *
1363      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1364      */
1365     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1366 
1367     /*
1368      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1369      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1370      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1371      *
1372      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1373      */
1374     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1375 
1376     /**
1377      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1378      */
1379     constructor (string memory name_, string memory symbol_)  {
1380         _name = name_;
1381         _symbol = symbol_;
1382 
1383         // register the supported interfaces to conform to ERC721 via ERC165
1384         _registerInterface(_INTERFACE_ID_ERC721);
1385         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1386         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-balanceOf}.
1391      */
1392     function balanceOf(address owner) public view virtual override returns (uint256) {
1393         require(owner != address(0), "ERC721: balance query for the zero address");
1394         return _holderTokens[owner].length();
1395     }
1396 
1397     /**
1398      * @dev See {IERC721-ownerOf}.
1399      */
1400     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1401         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Metadata-name}.
1406      */
1407     function name() public view virtual override returns (string memory) {
1408         return _name;
1409     }
1410 
1411     /**
1412      * @dev See {IERC721Metadata-symbol}.
1413      */
1414     function symbol() public view virtual override returns (string memory) {
1415         return _symbol;
1416     }
1417 
1418     /**
1419      * @dev See {IERC721Metadata-tokenURI}.
1420      */
1421     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1422         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1423 
1424         string memory _tokenURI = _tokenURIs[tokenId];
1425         string memory base = baseURI();
1426 
1427         // If there is no base URI, return the token URI.
1428         if (bytes(base).length == 0) {
1429             return _tokenURI;
1430         }
1431         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1432         if (bytes(_tokenURI).length > 0) {
1433             return string(abi.encodePacked(base, _tokenURI));
1434         }
1435         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1436         return string(abi.encodePacked(base, tokenId.toString()));
1437     }
1438 
1439     /**
1440     * @dev Returns the base URI set via {_setBaseURI}. This will be
1441     * automatically added as a prefix in {tokenURI} to each token's URI, or
1442     * to the token ID if no specific URI is set for that token ID.
1443     */
1444     function baseURI() public view virtual returns (string memory) {
1445         return _baseURI;
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1450      */
1451     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1452         return _holderTokens[owner].at(index);
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Enumerable-totalSupply}.
1457      */
1458     function totalSupply() public view virtual override returns (uint256) {
1459         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1460         return _tokenOwners.length();
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Enumerable-tokenByIndex}.
1465      */
1466     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1467         (uint256 tokenId, ) = _tokenOwners.at(index);
1468         return tokenId;
1469     }
1470 
1471     /**
1472      * @dev See {IERC721-approve}.
1473      */
1474     function approve(address to, uint256 tokenId) public virtual override {
1475         address owner = ERC721.ownerOf(tokenId);
1476         require(to != owner, "ERC721: approval to current owner");
1477 
1478         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1479             "ERC721: approve caller is not owner nor approved for all"
1480         );
1481 
1482         _approve(to, tokenId);
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-getApproved}.
1487      */
1488     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1489         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1490 
1491         return _tokenApprovals[tokenId];
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-setApprovalForAll}.
1496      */
1497     function setApprovalForAll(address operator, bool approved) public virtual override {
1498         require(operator != _msgSender(), "ERC721: approve to caller");
1499 
1500         _operatorApprovals[_msgSender()][operator] = approved;
1501         emit ApprovalForAll(_msgSender(), operator, approved);
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-isApprovedForAll}.
1506      */
1507     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1508         return _operatorApprovals[owner][operator];
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-transferFrom}.
1513      */
1514     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1515         //solhint-disable-next-line max-line-length
1516         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1517 
1518         _transfer(from, to, tokenId);
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-safeTransferFrom}.
1523      */
1524     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1525         safeTransferFrom(from, to, tokenId, "");
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-safeTransferFrom}.
1530      */
1531     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1532         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1533         _safeTransfer(from, to, tokenId, _data);
1534     }
1535 
1536     /**
1537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1539      *
1540      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1541      *
1542      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1543      * implement alternative mechanisms to perform token transfer, such as signature-based.
1544      *
1545      * Requirements:
1546      *
1547      * - `from` cannot be the zero address.
1548      * - `to` cannot be the zero address.
1549      * - `tokenId` token must exist and be owned by `from`.
1550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1551      *
1552      * Emits a {Transfer} event.
1553      */
1554     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1555         _transfer(from, to, tokenId);
1556         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1557     }
1558 
1559     /**
1560      * @dev Returns whether `tokenId` exists.
1561      *
1562      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1563      *
1564      * Tokens start existing when they are minted (`_mint`),
1565      * and stop existing when they are burned (`_burn`).
1566      */
1567     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1568         return _tokenOwners.contains(tokenId);
1569     }
1570 
1571     /**
1572      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must exist.
1577      */
1578     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1579         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1580         address owner = ERC721.ownerOf(tokenId);
1581         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1582     }
1583 
1584     /**
1585      * @dev Safely mints `tokenId` and transfers it to `to`.
1586      *
1587      * Requirements:
1588      d*
1589      * - `tokenId` must not exist.
1590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _safeMint(address to, uint256 tokenId) internal virtual {
1595         _safeMint(to, tokenId, "");
1596     }
1597 
1598     /**
1599      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1600      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1601      */
1602     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1603         _mint(to, tokenId);
1604         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1605     }
1606 
1607     /**
1608      * @dev Mints `tokenId` and transfers it to `to`.
1609      *
1610      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must not exist.
1615      * - `to` cannot be the zero address.
1616      *
1617      * Emits a {Transfer} event.
1618      */
1619     function _mint(address to, uint256 tokenId) internal virtual {
1620         require(to != address(0), "ERC721: mint to the zero address");
1621         require(!_exists(tokenId), "ERC721: token already minted");
1622 
1623         _beforeTokenTransfer(address(0), to, tokenId);
1624 
1625         _holderTokens[to].add(tokenId);
1626 
1627         _tokenOwners.set(tokenId, to);
1628 
1629         emit Transfer(address(0), to, tokenId);
1630     }
1631 
1632     /**
1633      * @dev Destroys `tokenId`.
1634      * The approval is cleared when the token is burned.
1635      *
1636      * Requirements:
1637      *
1638      * - `tokenId` must exist.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function _burn(uint256 tokenId) internal virtual {
1643         address owner = ERC721.ownerOf(tokenId); // internal owner
1644 
1645         _beforeTokenTransfer(owner, address(0), tokenId);
1646 
1647         // Clear approvals
1648         _approve(address(0), tokenId);
1649 
1650         // Clear metadata (if any)
1651         if (bytes(_tokenURIs[tokenId]).length != 0) {
1652             delete _tokenURIs[tokenId];
1653         }
1654 
1655         _holderTokens[owner].remove(tokenId);
1656 
1657         _tokenOwners.remove(tokenId);
1658 
1659         emit Transfer(owner, address(0), tokenId);
1660     }
1661 
1662     /**
1663      * @dev Transfers `tokenId` from `from` to `to`.
1664      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1665      *
1666      * Requirements:
1667      *
1668      * - `to` cannot be the zero address.
1669      * - `tokenId` token must be owned by `from`.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1674         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1675         require(to != address(0), "ERC721: transfer to the zero address");
1676 
1677         _beforeTokenTransfer(from, to, tokenId);
1678 
1679         // Clear approvals from the previous owner
1680         _approve(address(0), tokenId);
1681 
1682         _holderTokens[from].remove(tokenId);
1683         _holderTokens[to].add(tokenId);
1684 
1685         _tokenOwners.set(tokenId, to);
1686 
1687         emit Transfer(from, to, tokenId);
1688     }
1689 
1690     /**
1691      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must exist.
1696      */
1697     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1698         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1699         _tokenURIs[tokenId] = _tokenURI;
1700     }
1701 
1702     /**
1703      * @dev Internal function to set the base URI for all token IDs. It is
1704      * automatically added as a prefix to the value returned in {tokenURI},
1705      * or to the token ID if {tokenURI} is empty.
1706      */
1707     function _setBaseURI(string memory baseURI_) internal virtual {
1708         _baseURI = baseURI_;
1709     }
1710 
1711     /**
1712      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1713      * The call is not executed if the target address is not a contract.
1714      *
1715      * @param from address representing the previous owner of the given token ID
1716      * @param to target address that will receive the tokens
1717      * @param tokenId uint256 ID of the token to be transferred
1718      * @param _data bytes optional data to send along with the call
1719      * @return bool whether the call correctly returned the expected magic value
1720      */
1721     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1722         private returns (bool)
1723     {
1724         if (!to.isContract()) {
1725             return true;
1726         }
1727         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1728             IERC721Receiver(to).onERC721Received.selector,
1729             _msgSender(),
1730             from,
1731             tokenId,
1732             _data
1733         ), "ERC721: transfer to non ERC721Receiver implementer");
1734         bytes4 retval = abi.decode(returndata, (bytes4));
1735         return (retval == _ERC721_RECEIVED);
1736     }
1737 
1738     /**
1739      * @dev Approve `to` to operate on `tokenId`
1740      *
1741      * Emits an {Approval} event.
1742      */
1743     function _approve(address to, uint256 tokenId) internal virtual {
1744         _tokenApprovals[tokenId] = to;
1745         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1746     }
1747 
1748     /**
1749      * @dev Hook that is called before any token transfer. This includes minting
1750      * and burning.
1751      *
1752      * Calling conditions:
1753      *
1754      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1755      * transferred to `to`.
1756      * - When `from` is zero, `tokenId` will be minted for `to`.
1757      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1758      * - `from` cannot be the zero address.
1759      * - `to` cannot be the zero address.
1760      *
1761      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1762      */
1763     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1764 }
1765 
1766 /**
1767  * @dev Contract module which provides a basic access control mechanism, where
1768  * there is an account (an owner) that can be granted exclusive access to
1769  * specific functions.
1770  *
1771  * By default, the owner account will be the one that deploys the contract. This
1772  * can later be changed with {transferOwnership}.
1773  *
1774  * This module is used through inheritance. It will make available the modifier
1775  * `onlyOwner`, which can be applied to your functions to restrict their use to
1776  * the owner.
1777  */
1778 abstract contract Ownable is Context {
1779     address private _owner;
1780 
1781     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1782 
1783     /**
1784      * @dev Initializes the contract setting the deployer as the initial owner.
1785      */
1786     constructor () {
1787         address msgSender = _msgSender();
1788         _owner = msgSender;
1789         emit OwnershipTransferred(address(0), msgSender);
1790     }
1791 
1792     /**
1793      * @dev Returns the address of the current owner.
1794      */
1795     function owner() public view virtual returns (address) {
1796         return _owner;
1797     }
1798 
1799     /**
1800      * @dev Throws if called by any account other than the owner.
1801      */
1802     modifier onlyOwner() {
1803         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1804         _;
1805     }
1806 
1807     /**
1808      * @dev Leaves the contract without owner. It will not be possible to call
1809      * `onlyOwner` functions anymore. Can only be called by the current owner.
1810      *
1811      * NOTE: Renouncing ownership will leave the contract without an owner,
1812      * thereby removing any functionality that is only available to the owner.
1813      */
1814     function renounceOwnership() public virtual onlyOwner {
1815         emit OwnershipTransferred(_owner, address(0));
1816         _owner = address(0);
1817     }
1818 
1819     /**
1820      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1821      * Can only be called by the current owner.
1822      */
1823     function transferOwnership(address newOwner) public virtual onlyOwner {
1824         require(newOwner != address(0), "Ownable: new owner is the zero address");
1825         emit OwnershipTransferred(_owner, newOwner);
1826         _owner = newOwner;
1827     }
1828 }
1829 
1830 abstract contract ReentrancyGuard {
1831     // Booleans are more expensive than uint256 or any type that takes up a full
1832     // word because each write operation emits an extra SLOAD to first read the
1833     // slot's contents, replace the bits taken up by the boolean, and then write
1834     // back. This is the compiler's defense against contract upgrades and
1835     // pointer aliasing, and it cannot be disabled.
1836 
1837     // The values being non-zero value makes deployment a bit more expensive,
1838     // but in exchange the refund on every call to nonReentrant will be lower in
1839     // amount. Since refunds are capped to a percentage of the total
1840     // transaction's gas, it is best to keep them low in cases like this one, to
1841     // increase the likelihood of the full refund coming into effect.
1842     uint256 private constant _NOT_ENTERED = 1;
1843     uint256 private constant _ENTERED = 2;
1844 
1845     uint256 private _status;
1846 
1847     constructor () {
1848         _status = _NOT_ENTERED;
1849     }
1850 
1851     /**voucherPresaleNfts
1852      * @dev Prevents a contract from calling itself, directly or indirectly.
1853      * Calling a `nonReentrant` function from another `nonReentrant`
1854      * function is not supported. It is possible to prevent this from happening
1855      * by making the `nonReentrant` function external, and make it call a
1856      * `private` function that does the actual work.
1857      */
1858     modifier nonReentrant() {
1859         // On the first call to nonReentrant, _notEntered will be true
1860         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1861 
1862         // Any calls to nonReentrant after this point will fail
1863         _status = _ENTERED;
1864 
1865         _;
1866 
1867         // By storing the original value once again, a refund is triggered (see
1868         // https://eips.ethereum.org/EIPS/eip-2200)
1869         _status = _NOT_ENTERED;
1870     }
1871 
1872     modifier isHuman() {
1873         require(tx.origin == msg.sender, "sorry humans only");
1874         _;
1875     }
1876 }
1877 
1878 /**
1879  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1880 */
1881 contract Incrowd is ERC721, Ownable, ReentrancyGuard {
1882     using SafeMath for uint256;
1883 
1884     uint256 public nftPrice = .45 ether;
1885     uint256 public wlNftPrice = .45 ether;
1886 
1887     uint public maxNftPurchase = 3;
1888     uint public maxNftWallet = 3;
1889 
1890     uint256 public MAX_NFTS;
1891 
1892     bool public saleIsActive = false;
1893     bool public presaleIsActive = false;
1894 
1895    
1896     mapping (address => bool) private _isWhitelisted;
1897     mapping (address => bool) private _isTokenAdmin;
1898 
1899     constructor() ERC721("In Crowd Alpha", "INCROWD") {
1900         MAX_NFTS = 1850;
1901         setBaseURI("https://incrowdalpha.mypinata.cloud/ipfs/QmVPBFgudeSBWryruoyXT3t5uurCZm25DQtBCJdi2Qh8Y8/");
1902     }
1903 
1904     modifier OnlyTokenAdmin() {
1905         require(_isTokenAdmin[_msgSender()] || _msgSender() == owner(), "Sorry: You are not a Token Admin");
1906         _;
1907     }
1908 
1909     function setNftPrice(uint256 price) external onlyOwner {
1910         nftPrice = price;
1911     }
1912 
1913     function setMax(uint256 qty) external onlyOwner {
1914         MAX_NFTS = qty;
1915     }
1916 
1917     function setWlNftPrice(uint256 price) external onlyOwner {
1918         wlNftPrice = price;
1919     }
1920 
1921     function setMaxPurchase(uint256 amount) external onlyOwner {
1922         maxNftPurchase = amount;
1923     }
1924 
1925     function setMaxWallet(uint256 amount) external onlyOwner {
1926         maxNftWallet = amount;
1927     }
1928 
1929     function withdraw() external onlyOwner {
1930         uint256 balance = address(this).balance;
1931         payable(owner()).transfer(balance);
1932     }
1933 
1934     function setTokenAdmin(address account, bool enabled) public onlyOwner {
1935         _isTokenAdmin[account] = enabled;
1936     }
1937 
1938     function reserveNfts(uint256 _count) public OnlyTokenAdmin {        
1939         uint supply = totalSupply();
1940         uint i;
1941         for (i = 0; i < _count; i++) {
1942             _safeMint(msg.sender, supply + i);
1943         }
1944     }
1945 
1946     function setBaseURI(string memory baseURI) public onlyOwner {
1947         _setBaseURI(baseURI);
1948     }
1949 
1950     /*
1951     * Pause sale if active, make active if paused
1952     */
1953     function flipSaleState() public OnlyTokenAdmin {
1954         saleIsActive = !saleIsActive;
1955     }
1956 
1957     function flipPreSaleState() public OnlyTokenAdmin {
1958         presaleIsActive = !presaleIsActive;
1959     }
1960 
1961     function addToPresale(address[] calldata addresses) external OnlyTokenAdmin {
1962         for (uint256 i = 0; i < addresses.length; i++) {
1963             _isWhitelisted[addresses[i]] = true;
1964         }
1965     }
1966 
1967     function removeFromPresale(address[] calldata addresses) external OnlyTokenAdmin {
1968         for (uint256 i = 0; i < addresses.length; i++) {
1969             _isWhitelisted[addresses[i]] = false;
1970         }
1971     }
1972 
1973     function isWhiteListed(address account) public view returns (bool) {
1974         return _isWhitelisted[account];
1975     }
1976 
1977     function isTokenAdmin(address account) public view returns (bool) {
1978         return _isTokenAdmin[account] || _msgSender() == owner();
1979     }
1980 
1981     function mint(uint numberOfTokens) isHuman nonReentrant external payable {
1982         require(saleIsActive || (presaleIsActive && _isWhitelisted[msg.sender]), "Sale must be active to mint");
1983         require(balanceOf(_msgSender()).add(numberOfTokens) <= maxNftWallet, "Can only mint 3 per wallet");
1984         require(numberOfTokens <= maxNftPurchase, "Can only mint 2 at a time");
1985         require(totalSupply().add(numberOfTokens) <= MAX_NFTS, "Purchase would exceed max supply");
1986         require(nftPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1987         
1988         for(uint i = 0; i < numberOfTokens; i++) {
1989             uint mintIndex = totalSupply();
1990             if (totalSupply() < MAX_NFTS) {
1991                 _safeMint(msg.sender, mintIndex);
1992             }
1993         }
1994     }
1995 
1996     function preMint(uint numberOfTokens) isHuman nonReentrant external payable {
1997         require(presaleIsActive, "Presale must be active to mint");
1998         require(balanceOf(_msgSender()).add(numberOfTokens) <= maxNftWallet, "Can only mint 3 per wallet");
1999         require(_isWhitelisted[_msgSender()], "Account is not White Listed");
2000         require(numberOfTokens <= maxNftPurchase, "Can only mint 12 at a time");
2001         require(totalSupply().add(numberOfTokens) <= MAX_NFTS, "Purchase would exceed max supply");
2002         require(wlNftPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");      
2003         
2004         for(uint i = 0; i < numberOfTokens; i++) {
2005             uint mintIndex = totalSupply();
2006             if (totalSupply() < MAX_NFTS) {
2007                 _safeMint(msg.sender, mintIndex);
2008             }
2009         }       
2010     }
2011 }