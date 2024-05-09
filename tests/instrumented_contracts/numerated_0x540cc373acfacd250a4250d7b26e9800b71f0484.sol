1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-23
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.6;
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
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
64      */
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
69      */
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of tokens in ``owner``'s account.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the `tokenId` token.
79      *
80      * Requirements:
81      *
82      * - `tokenId` must exist.
83      */
84     function ownerOf(uint256 tokenId) external view returns (address owner);
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(address from, address to, uint256 tokenId) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(address from, address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162       * @dev Safely transfers `tokenId` token from `from` to `to`.
163       *
164       * Requirements:
165       *
166       * - `from` cannot be the zero address.
167       * - `to` cannot be the zero address.
168       * - `tokenId` token must exist and be owned by `from`.
169       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171       *
172       * Emits a {Transfer} event.
173       */
174     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
175 }
176 
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
180  * @dev See https://eips.ethereum.org/EIPS/eip-721
181  */
182 interface IERC721Metadata is IERC721 {
183 
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
196      */
197     function tokenURI(uint256 tokenId) external view returns (string memory);
198 }
199 
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Enumerable is IERC721 {
206 
207     /**
208      * @dev Returns the total amount of tokens stored by the contract.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
214      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
215      */
216     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
217 
218     /**
219      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
220      * Use along with {totalSupply} to enumerate all tokens.
221      */
222     function tokenByIndex(uint256 index) external view returns (uint256);
223 }
224 
225 
226 pragma solidity >=0.6.0 <0.8.0;
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
244 }
245 
246 
247 /**
248  * @dev Implementation of the {IERC165} interface.
249  *
250  * Contracts may inherit from this and call {_registerInterface} to declare
251  * their support of an interface.
252  */
253 abstract contract ERC165 is IERC165 {
254     /*
255      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
256      */
257     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
258 
259     /**
260      * @dev Mapping of interface ids to whether or not it's supported.
261      */
262     mapping(bytes4 => bool) private _supportedInterfaces;
263 
264     constructor () {
265         // Derived contracts need only register support for their own interfaces,
266         // we register support for ERC165 itself here
267         _registerInterface(_INTERFACE_ID_ERC165);
268     }
269 
270     /**
271      * @dev See {IERC165-supportsInterface}.
272      *
273      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
274      */
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return _supportedInterfaces[interfaceId];
277     }
278 
279     /**
280      * @dev Registers the contract as an implementer of the interface defined by
281      * `interfaceId`. Support of the actual ERC165 interface is automatic and
282      * registering its interface id is not required.
283      *
284      * See {IERC165-supportsInterface}.
285      *
286      * Requirements:
287      *
288      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
289      */
290     function _registerInterface(bytes4 interfaceId) internal virtual {
291         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
292         _supportedInterfaces[interfaceId] = true;
293     }
294 }
295 
296 
297 pragma solidity >=0.6.0 <0.8.0;
298 
299 /**
300  * @dev Wrappers over Solidity's arithmetic operations with added overflow
301  * checks.
302  *
303  * Arithmetic operations in Solidity wrap on overflow. This can easily result
304  * in bugs, because programmers usually assume that an overflow raises an
305  * error, which is the standard behavior in high level programming languages.
306  * `SafeMath` restores this intuition by reverting the transaction when an
307  * operation overflows.
308  *
309  * Using this library instead of the unchecked operations eliminates an entire
310  * class of bugs, so it's recommended to use it always.
311  */
312 library SafeMath {
313     /**
314      * @dev Returns the addition of two unsigned integers, with an overflow flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
319         uint256 c = a + b;
320         if (c < a) return (false, 0);
321         return (true, c);
322     }
323 
324     /**
325      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
326      *
327      * _Available since v3.4._
328      */
329     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         if (b > a) return (false, 0);
331         return (true, a - b);
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
336      *
337      * _Available since v3.4._
338      */
339     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
340         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341         // benefit is lost if 'b' is also tested.
342         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
343         if (a == 0) return (true, 0);
344         uint256 c = a * b;
345         if (c / a != b) return (false, 0);
346         return (true, c);
347     }
348 
349     /**
350      * @dev Returns the division of two unsigned integers, with a division by zero flag.
351      *
352      * _Available since v3.4._
353      */
354     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         if (b == 0) return (false, 0);
356         return (true, a / b);
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
361      *
362      * _Available since v3.4._
363      */
364     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
365         if (b == 0) return (false, 0);
366         return (true, a % b);
367     }
368 
369     /**
370      * @dev Returns the addition of two unsigned integers, reverting on
371      * overflow.
372      *
373      * Counterpart to Solidity's `+` operator.
374      *
375      * Requirements:
376      *
377      * - Addition cannot overflow.
378      */
379     function add(uint256 a, uint256 b) internal pure returns (uint256) {
380         uint256 c = a + b;
381         require(c >= a, "SafeMath: addition overflow");
382         return c;
383     }
384 
385     /**
386      * @dev Returns the subtraction of two unsigned integers, reverting on
387      * overflow (when the result is negative).
388      *
389      * Counterpart to Solidity's `-` operator.
390      *
391      * Requirements:
392      *
393      * - Subtraction cannot overflow.
394      */
395     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
396         require(b <= a, "SafeMath: subtraction overflow");
397         return a - b;
398     }
399 
400     /**
401      * @dev Returns the multiplication of two unsigned integers, reverting on
402      * overflow.
403      *
404      * Counterpart to Solidity's `*` operator.
405      *
406      * Requirements:
407      *
408      * - Multiplication cannot overflow.
409      */
410     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
411         if (a == 0) return 0;
412         uint256 c = a * b;
413         require(c / a == b, "SafeMath: multiplication overflow");
414         return c;
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers, reverting on
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
430         require(b > 0, "SafeMath: division by zero");
431         return a / b;
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * reverting when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b > 0, "SafeMath: modulo by zero");
448         return a % b;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
453      * overflow (when the result is negative).
454      *
455      * CAUTION: This function is deprecated because it requires allocating memory for the error
456      * message unnecessarily. For custom revert reasons use {trySub}.
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b <= a, errorMessage);
466         return a - b;
467     }
468 
469     /**
470      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
471      * division by zero. The result is rounded towards zero.
472      *
473      * CAUTION: This function is deprecated because it requires allocating memory for the error
474      * message unnecessarily. For custom revert reasons use {tryDiv}.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         require(b > 0, errorMessage);
486         return a / b;
487     }
488 
489     /**
490      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
491      * reverting with custom message when dividing by zero.
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {tryMod}.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b > 0, errorMessage);
506         return a % b;
507     }
508 }
509 
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // This method relies on extcodesize, which returns 0 for contracts in
534         // construction, since the code is only stored at the end of the
535         // constructor execution.
536 
537         uint256 size;
538         // solhint-disable-next-line no-inline-assembly
539         assembly { size := extcodesize(account) }
540         return size > 0;
541     }
542 
543     /**
544      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
545      * `recipient`, forwarding all available gas and reverting on errors.
546      *
547      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
548      * of certain opcodes, possibly making contracts go over the 2300 gas limit
549      * imposed by `transfer`, making them unable to receive funds via
550      * `transfer`. {sendValue} removes this limitation.
551      *
552      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
553      *
554      * IMPORTANT: because control is transferred to `recipient`, care must be
555      * taken to not create reentrancy vulnerabilities. Consider using
556      * {ReentrancyGuard} or the
557      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
558      */
559     function sendValue(address payable recipient, uint256 amount) internal {
560         require(address(this).balance >= amount, "Address: insufficient balance");
561 
562         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
563         (bool success, ) = recipient.call{ value: amount }("");
564         require(success, "Address: unable to send value, recipient may have reverted");
565     }
566 
567     /**
568      * @dev Performs a Solidity function call using a low level `call`. A
569      * plain`call` is an unsafe replacement for a function call: use this
570      * function instead.
571      *
572      * If `target` reverts with a revert reason, it is bubbled up by this
573      * function (like regular Solidity function calls).
574      *
575      * Returns the raw returned data. To convert to the expected return value,
576      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
577      *
578      * Requirements:
579      *
580      * - `target` must be a contract.
581      * - calling `target` with `data` must not revert.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
586       return functionCall(target, data, "Address: low-level call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
591      * `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, 0, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but also transferring `value` wei to `target`.
602      *
603      * Requirements:
604      *
605      * - the calling contract must have an ETH balance of at least `value`.
606      * - the called Solidity function must be `payable`.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
611         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
616      * with `errorMessage` as a fallback revert reason when `target` reverts.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
621         require(address(this).balance >= value, "Address: insufficient balance for call");
622         require(isContract(target), "Address: call to non-contract");
623 
624         // solhint-disable-next-line avoid-low-level-calls
625         (bool success, bytes memory returndata) = target.call{ value: value }(data);
626         return _verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a static call.
632      *
633      * _Available since v3.3._
634      */
635     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
636         return functionStaticCall(target, data, "Address: low-level static call failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
641      * but performing a static call.
642      *
643      * _Available since v3.3._
644      */
645     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
646         require(isContract(target), "Address: static call to non-contract");
647 
648         // solhint-disable-next-line avoid-low-level-calls
649         (bool success, bytes memory returndata) = target.staticcall(data);
650         return _verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
660         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
665      * but performing a delegate call.
666      *
667      * _Available since v3.4._
668      */
669     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
670         require(isContract(target), "Address: delegate call to non-contract");
671 
672         // solhint-disable-next-line avoid-low-level-calls
673         (bool success, bytes memory returndata) = target.delegatecall(data);
674         return _verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
678         if (success) {
679             return returndata;
680         } else {
681             // Look for revert reason and bubble it up if present
682             if (returndata.length > 0) {
683                 // The easiest way to bubble the revert reason is using memory via assembly
684 
685                 // solhint-disable-next-line no-inline-assembly
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 
698 pragma solidity >=0.6.0 <0.8.0;
699 
700 /**
701  * @dev Library for managing
702  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
703  * types.
704  *
705  * Sets have the following properties:
706  *
707  * - Elements are added, removed, and checked for existence in constant time
708  * (O(1)).
709  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
710  *
711  * ```
712  * contract Example {
713  *     // Add the library methods
714  *     using EnumerableSet for EnumerableSet.AddressSet;
715  *
716  *     // Declare a set state variable
717  *     EnumerableSet.AddressSet private mySet;
718  * }
719  * ```
720  *
721  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
722  * and `uint256` (`UintSet`) are supported.
723  */
724 library EnumerableSet {
725     // To implement this library for multiple types with as little code
726     // repetition as possible, we write it in terms of a generic Set type with
727     // bytes32 values.
728     // The Set implementation uses private functions, and user-facing
729     // implementations (such as AddressSet) are just wrappers around the
730     // underlying Set.
731     // This means that we can only create new EnumerableSets for types that fit
732     // in bytes32.
733 
734     struct Set {
735         // Storage of set values
736         bytes32[] _values;
737 
738         // Position of the value in the `values` array, plus 1 because index 0
739         // means a value is not in the set.
740         mapping (bytes32 => uint256) _indexes;
741     }
742 
743     /**
744      * @dev Add a value to a set. O(1).
745      *
746      * Returns true if the value was added to the set, that is if it was not
747      * already present.
748      */
749     function _add(Set storage set, bytes32 value) private returns (bool) {
750         if (!_contains(set, value)) {
751             set._values.push(value);
752             // The value is stored at length-1, but we add 1 to all indexes
753             // and use 0 as a sentinel value
754             set._indexes[value] = set._values.length;
755             return true;
756         } else {
757             return false;
758         }
759     }
760 
761     /**
762      * @dev Removes a value from a set. O(1).
763      *
764      * Returns true if the value was removed from the set, that is if it was
765      * present.
766      */
767     function _remove(Set storage set, bytes32 value) private returns (bool) {
768         // We read and store the value's index to prevent multiple reads from the same storage slot
769         uint256 valueIndex = set._indexes[value];
770 
771         if (valueIndex != 0) { // Equivalent to contains(set, value)
772             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
773             // the array, and then remove the last element (sometimes called as 'swap and pop').
774             // This modifies the order of the array, as noted in {at}.
775 
776             uint256 toDeleteIndex = valueIndex - 1;
777             uint256 lastIndex = set._values.length - 1;
778 
779             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
780             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
781 
782             bytes32 lastvalue = set._values[lastIndex];
783 
784             // Move the last value to the index where the value to delete is
785             set._values[toDeleteIndex] = lastvalue;
786             // Update the index for the moved value
787             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
788 
789             // Delete the slot where the moved value was stored
790             set._values.pop();
791 
792             // Delete the index for the deleted slot
793             delete set._indexes[value];
794 
795             return true;
796         } else {
797             return false;
798         }
799     }
800 
801     /**
802      * @dev Returns true if the value is in the set. O(1).
803      */
804     function _contains(Set storage set, bytes32 value) private view returns (bool) {
805         return set._indexes[value] != 0;
806     }
807 
808     /**
809      * @dev Returns the number of values on the set. O(1).
810      */
811     function _length(Set storage set) private view returns (uint256) {
812         return set._values.length;
813     }
814 
815    /**
816     * @dev Returns the value stored at position `index` in the set. O(1).
817     *
818     * Note that there are no guarantees on the ordering of values inside the
819     * array, and it may change when more values are added or removed.
820     *
821     * Requirements:
822     *
823     * - `index` must be strictly less than {length}.
824     */
825     function _at(Set storage set, uint256 index) private view returns (bytes32) {
826         require(set._values.length > index, "EnumerableSet: index out of bounds");
827         return set._values[index];
828     }
829 
830     // Bytes32Set
831 
832     struct Bytes32Set {
833         Set _inner;
834     }
835 
836     /**
837      * @dev Add a value to a set. O(1).
838      *
839      * Returns true if the value was added to the set, that is if it was not
840      * already present.
841      */
842     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
843         return _add(set._inner, value);
844     }
845 
846     /**
847      * @dev Removes a value from a set. O(1).
848      *
849      * Returns true if the value was removed from the set, that is if it was
850      * present.
851      */
852     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
853         return _remove(set._inner, value);
854     }
855 
856     /**
857      * @dev Returns true if the value is in the set. O(1).
858      */
859     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
860         return _contains(set._inner, value);
861     }
862 
863     /**
864      * @dev Returns the number of values in the set. O(1).
865      */
866     function length(Bytes32Set storage set) internal view returns (uint256) {
867         return _length(set._inner);
868     }
869 
870    /**
871     * @dev Returns the value stored at position `index` in the set. O(1).
872     *
873     * Note that there are no guarantees on the ordering of values inside the
874     * array, and it may change when more values are added or removed.
875     *
876     * Requirements:
877     *
878     * - `index` must be strictly less than {length}.
879     */
880     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
881         return _at(set._inner, index);
882     }
883 
884     // AddressSet
885 
886     struct AddressSet {
887         Set _inner;
888     }
889 
890     /**
891      * @dev Add a value to a set. O(1).
892      *
893      * Returns true if the value was added to the set, that is if it was not
894      * already present.
895      */
896     function add(AddressSet storage set, address value) internal returns (bool) {
897         return _add(set._inner, bytes32(uint256(uint160(value))));
898     }
899 
900     /**
901      * @dev Removes a value from a set. O(1).
902      *
903      * Returns true if the value was removed from the set, that is if it was
904      * present.
905      */
906     function remove(AddressSet storage set, address value) internal returns (bool) {
907         return _remove(set._inner, bytes32(uint256(uint160(value))));
908     }
909 
910     /**
911      * @dev Returns true if the value is in the set. O(1).
912      */
913     function contains(AddressSet storage set, address value) internal view returns (bool) {
914         return _contains(set._inner, bytes32(uint256(uint160(value))));
915     }
916 
917     /**
918      * @dev Returns the number of values in the set. O(1).
919      */
920     function length(AddressSet storage set) internal view returns (uint256) {
921         return _length(set._inner);
922     }
923 
924    /**
925     * @dev Returns the value stored at position `index` in the set. O(1).
926     *
927     * Note that there are no guarantees on the ordering of values inside the
928     * array, and it may change when more values are added or removed.
929     *
930     * Requirements:
931     *
932     * - `index` must be strictly less than {length}.
933     */
934     function at(AddressSet storage set, uint256 index) internal view returns (address) {
935         return address(uint160(uint256(_at(set._inner, index))));
936     }
937 
938 
939     // UintSet
940 
941     struct UintSet {
942         Set _inner;
943     }
944 
945     /**
946      * @dev Add a value to a set. O(1).
947      *
948      * Returns true if the value was added to the set, that is if it was not
949      * already present.
950      */
951     function add(UintSet storage set, uint256 value) internal returns (bool) {
952         return _add(set._inner, bytes32(value));
953     }
954 
955     /**
956      * @dev Removes a value from a set. O(1).
957      *
958      * Returns true if the value was removed from the set, that is if it was
959      * present.
960      */
961     function remove(UintSet storage set, uint256 value) internal returns (bool) {
962         return _remove(set._inner, bytes32(value));
963     }
964 
965     /**
966      * @dev Returns true if the value is in the set. O(1).
967      */
968     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
969         return _contains(set._inner, bytes32(value));
970     }
971 
972     /**
973      * @dev Returns the number of values on the set. O(1).
974      */
975     function length(UintSet storage set) internal view returns (uint256) {
976         return _length(set._inner);
977     }
978 
979    /**
980     * @dev Returns the value stored at position `index` in the set. O(1).
981     *
982     * Note that there are no guarantees on the ordering of values inside the
983     * array, and it may change when more values are added or removed.
984     *
985     * Requirements:
986     *
987     * - `index` must be strictly less than {length}.
988     */
989     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
990         return uint256(_at(set._inner, index));
991     }
992 }
993 
994 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
995 
996 
997 
998 pragma solidity >=0.6.0 <0.8.0;
999 
1000 /**
1001  * @dev Library for managing an enumerable variant of Solidity's
1002  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1003  * type.
1004  *
1005  * Maps have the following properties:
1006  *
1007  * - Entries are added, removed, and checked for existence in constant time
1008  * (O(1)).
1009  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1010  *
1011  * ```
1012  * contract Example {
1013  *     // Add the library methods
1014  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1015  *
1016  *     // Declare a set state variable
1017  *     EnumerableMap.UintToAddressMap private myMap;
1018  * }
1019  * ```
1020  *
1021  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1022  * supported.
1023  */
1024 library EnumerableMap {
1025     // To implement this library for multiple types with as little code
1026     // repetition as possible, we write it in terms of a generic Map type with
1027     // bytes32 keys and values.
1028     // The Map implementation uses private functions, and user-facing
1029     // implementations (such as Uint256ToAddressMap) are just wrappers around
1030     // the underlying Map.
1031     // This means that we can only create new EnumerableMaps for types that fit
1032     // in bytes32.
1033 
1034     struct MapEntry {
1035         bytes32 _key;
1036         bytes32 _value;
1037     }
1038 
1039     struct Map {
1040         // Storage of map keys and values
1041         MapEntry[] _entries;
1042 
1043         // Position of the entry defined by a key in the `entries` array, plus 1
1044         // because index 0 means a key is not in the map.
1045         mapping (bytes32 => uint256) _indexes;
1046     }
1047 
1048     /**
1049      * @dev Adds a key-value pair to a map, or updates the value for an existing
1050      * key. O(1).
1051      *
1052      * Returns true if the key was added to the map, that is if it was not
1053      * already present.
1054      */
1055     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1056         // We read and store the key's index to prevent multiple reads from the same storage slot
1057         uint256 keyIndex = map._indexes[key];
1058 
1059         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1060             map._entries.push(MapEntry({ _key: key, _value: value }));
1061             // The entry is stored at length-1, but we add 1 to all indexes
1062             // and use 0 as a sentinel value
1063             map._indexes[key] = map._entries.length;
1064             return true;
1065         } else {
1066             map._entries[keyIndex - 1]._value = value;
1067             return false;
1068         }
1069     }
1070 
1071     /**
1072      * @dev Removes a key-value pair from a map. O(1).
1073      *
1074      * Returns true if the key was removed from the map, that is if it was present.
1075      */
1076     function _remove(Map storage map, bytes32 key) private returns (bool) {
1077         // We read and store the key's index to prevent multiple reads from the same storage slot
1078         uint256 keyIndex = map._indexes[key];
1079 
1080         if (keyIndex != 0) { // Equivalent to contains(map, key)
1081             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1082             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1083             // This modifies the order of the array, as noted in {at}.
1084 
1085             uint256 toDeleteIndex = keyIndex - 1;
1086             uint256 lastIndex = map._entries.length - 1;
1087 
1088             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1089             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1090 
1091             MapEntry storage lastEntry = map._entries[lastIndex];
1092 
1093             // Move the last entry to the index where the entry to delete is
1094             map._entries[toDeleteIndex] = lastEntry;
1095             // Update the index for the moved entry
1096             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1097 
1098             // Delete the slot where the moved entry was stored
1099             map._entries.pop();
1100 
1101             // Delete the index for the deleted slot
1102             delete map._indexes[key];
1103 
1104             return true;
1105         } else {
1106             return false;
1107         }
1108     }
1109 
1110     /**
1111      * @dev Returns true if the key is in the map. O(1).
1112      */
1113     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1114         return map._indexes[key] != 0;
1115     }
1116 
1117     /**
1118      * @dev Returns the number of key-value pairs in the map. O(1).
1119      */
1120     function _length(Map storage map) private view returns (uint256) {
1121         return map._entries.length;
1122     }
1123 
1124    /**
1125     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1126     *
1127     * Note that there are no guarantees on the ordering of entries inside the
1128     * array, and it may change when more entries are added or removed.
1129     *
1130     * Requirements:
1131     *
1132     * - `index` must be strictly less than {length}.
1133     */
1134     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1135         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1136 
1137         MapEntry storage entry = map._entries[index];
1138         return (entry._key, entry._value);
1139     }
1140 
1141     /**
1142      * @dev Tries to returns the value associated with `key`.  O(1).
1143      * Does not revert if `key` is not in the map.
1144      */
1145     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1146         uint256 keyIndex = map._indexes[key];
1147         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1148         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1149     }
1150 
1151     /**
1152      * @dev Returns the value associated with `key`.  O(1).
1153      *
1154      * Requirements:
1155      *
1156      * - `key` must be in the map.
1157      */
1158     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1159         uint256 keyIndex = map._indexes[key];
1160         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1161         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1162     }
1163 
1164     /**
1165      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1166      *
1167      * CAUTION: This function is deprecated because it requires allocating memory for the error
1168      * message unnecessarily. For custom revert reasons use {_tryGet}.
1169      */
1170     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1171         uint256 keyIndex = map._indexes[key];
1172         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1173         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1174     }
1175 
1176     // UintToAddressMap
1177 
1178     struct UintToAddressMap {
1179         Map _inner;
1180     }
1181 
1182     /**
1183      * @dev Adds a key-value pair to a map, or updates the value for an existing
1184      * key. O(1).
1185      *
1186      * Returns true if the key was added to the map, that is if it was not
1187      * already present.
1188      */
1189     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1190         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1191     }
1192 
1193     /**
1194      * @dev Removes a value from a set. O(1).
1195      *
1196      * Returns true if the key was removed from the map, that is if it was present.
1197      */
1198     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1199         return _remove(map._inner, bytes32(key));
1200     }
1201 
1202     /**
1203      * @dev Returns true if the key is in the map. O(1).
1204      */
1205     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1206         return _contains(map._inner, bytes32(key));
1207     }
1208 
1209     /**
1210      * @dev Returns the number of elements in the map. O(1).
1211      */
1212     function length(UintToAddressMap storage map) internal view returns (uint256) {
1213         return _length(map._inner);
1214     }
1215 
1216    /**
1217     * @dev Returns the element stored at position `index` in the set. O(1).
1218     * Note that there are no guarantees on the ordering of values inside the
1219     * array, and it may change when more values are added or removed.
1220     *
1221     * Requirements:
1222     *
1223     * - `index` must be strictly less than {length}.
1224     */
1225     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1226         (bytes32 key, bytes32 value) = _at(map._inner, index);
1227         return (uint256(key), address(uint160(uint256(value))));
1228     }
1229 
1230     /**
1231      * @dev Tries to returns the value associated with `key`.  O(1).
1232      * Does not revert if `key` is not in the map.
1233      *
1234      * _Available since v3.4._
1235      */
1236     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1237         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1238         return (success, address(uint160(uint256(value))));
1239     }
1240 
1241     /**
1242      * @dev Returns the value associated with `key`.  O(1).
1243      *
1244      * Requirements:
1245      *
1246      * - `key` must be in the map.
1247      */
1248     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1249         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1250     }
1251 
1252     /**
1253      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1254      *
1255      * CAUTION: This function is deprecated because it requires allocating memory for the error
1256      * message unnecessarily. For custom revert reasons use {tryGet}.
1257      */
1258     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1259         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1260     }
1261 }
1262 
1263 
1264 /**
1265  * @dev String operations.
1266  */
1267 library Strings {
1268     /**
1269      * @dev Converts a `uint256` to its ASCII `string` representation.
1270      */
1271     function toString(uint256 value) internal pure returns (string memory) {
1272         // Inspired by OraclizeAPI's implementation - MIT licence
1273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1274 
1275         if (value == 0) {
1276             return "0";
1277         }
1278         uint256 temp = value;
1279         uint256 digits;
1280         while (temp != 0) {
1281             digits++;
1282             temp /= 10;
1283         }
1284         bytes memory buffer = new bytes(digits);
1285         uint256 index = digits - 1;
1286         temp = value;
1287         while (temp != 0) {
1288             buffer[index--] = bytes1(uint8(48 + temp % 10));
1289             temp /= 10;
1290         }
1291         return string(buffer);
1292     }
1293 }
1294 
1295 
1296 /**
1297  * @title ERC721 Non-Fungible Token Standard basic implementation
1298  * @dev see https://eips.ethereum.org/EIPS/eip-721
1299  */
1300 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1301     using SafeMath for uint256;
1302     using Address for address;
1303     using EnumerableSet for EnumerableSet.UintSet;
1304     using EnumerableMap for EnumerableMap.UintToAddressMap;
1305     using Strings for uint256;
1306 
1307     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1308     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1309     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1310 
1311     // Mapping from holder address to their (enumerable) set of owned tokens
1312     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1313 
1314     // Enumerable mapping from token ids to their owners
1315     EnumerableMap.UintToAddressMap private _tokenOwners;
1316 
1317     // Mapping from token ID to approved address
1318     mapping (uint256 => address) private _tokenApprovals;
1319 
1320     // Mapping from owner to operator approvals
1321     mapping (address => mapping (address => bool)) private _operatorApprovals;
1322 
1323     // Token name
1324     string private _name;
1325 
1326     // Token symbol
1327     string private _symbol;
1328 
1329     // Optional mapping for token URIs
1330     mapping (uint256 => string) private _tokenURIs;
1331 
1332     // Base URI
1333     string private _baseURI;
1334 
1335     /*
1336      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1337      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1338      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1339      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1340      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1341      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1342      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1343      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1344      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1345      *
1346      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1347      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1348      */
1349     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1350 
1351     /*
1352      *     bytes4(keccak256('name()')) == 0x06fdde03
1353      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1354      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1355      *
1356      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1357      */
1358     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1359 
1360     /*
1361      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1362      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1363      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1364      *
1365      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1366      */
1367     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1368 
1369     /**
1370      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1371      */
1372     constructor (string memory name_, string memory symbol_) {
1373         _name = name_;
1374         _symbol = symbol_;
1375 
1376         // register the supported interfaces to conform to ERC721 via ERC165
1377         _registerInterface(_INTERFACE_ID_ERC721);
1378         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1379         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-balanceOf}.
1384      */
1385     function balanceOf(address owner) public view virtual override returns (uint256) {
1386         require(owner != address(0), "ERC721: balance query for the zero address");
1387         return _holderTokens[owner].length();
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-ownerOf}.
1392      */
1393     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1394         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Metadata-name}.
1399      */
1400     function name() public view virtual override returns (string memory) {
1401         return _name;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Metadata-symbol}.
1406      */
1407     function symbol() public view virtual override returns (string memory) {
1408         return _symbol;
1409     }
1410 
1411     /**
1412      * @dev See {IERC721Metadata-tokenURI}.
1413      */
1414     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1415         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1416 
1417         string memory _tokenURI = _tokenURIs[tokenId];
1418         string memory base = baseURI();
1419 
1420         // If there is no base URI, return the token URI.
1421         if (bytes(base).length == 0) {
1422             return _tokenURI;
1423         }
1424         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1425         if (bytes(_tokenURI).length > 0) {
1426             return string(abi.encodePacked(base, _tokenURI));
1427         }
1428         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1429         return string(abi.encodePacked(base, tokenId.toString()));
1430     }
1431 
1432     /**
1433     * @dev Returns the base URI set via {_setBaseURI}. This will be
1434     * automatically added as a prefix in {tokenURI} to each token's URI, or
1435     * to the token ID if no specific URI is set for that token ID.
1436     */
1437     function baseURI() public view virtual returns (string memory) {
1438         return _baseURI;
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1443      */
1444     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1445         return _holderTokens[owner].at(index);
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Enumerable-totalSupply}.
1450      */
1451     function totalSupply() public view virtual override returns (uint256) {
1452         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1453         return _tokenOwners.length();
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-tokenByIndex}.
1458      */
1459     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1460         (uint256 tokenId, ) = _tokenOwners.at(index);
1461         return tokenId;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-approve}.
1466      */
1467     function approve(address to, uint256 tokenId) public virtual override {
1468         address owner = ERC721.ownerOf(tokenId);
1469         require(to != owner, "ERC721: approval to current owner");
1470 
1471         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1472             "ERC721: approve caller is not owner nor approved for all"
1473         );
1474 
1475         _approve(to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev See {IERC721-getApproved}.
1480      */
1481     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1482         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1483 
1484         return _tokenApprovals[tokenId];
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-setApprovalForAll}.
1489      */
1490     function setApprovalForAll(address operator, bool approved) public virtual override {
1491         require(operator != _msgSender(), "ERC721: approve to caller");
1492 
1493         _operatorApprovals[_msgSender()][operator] = approved;
1494         emit ApprovalForAll(_msgSender(), operator, approved);
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-isApprovedForAll}.
1499      */
1500     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1501         return _operatorApprovals[owner][operator];
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-transferFrom}.
1506      */
1507     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1508         //solhint-disable-next-line max-line-length
1509         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1510 
1511         _transfer(from, to, tokenId);
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-safeTransferFrom}.
1516      */
1517     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1518         safeTransferFrom(from, to, tokenId, "");
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-safeTransferFrom}.
1523      */
1524     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1525         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1526         _safeTransfer(from, to, tokenId, _data);
1527     }
1528 
1529     /**
1530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1532      *
1533      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1534      *
1535      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1536      * implement alternative mechanisms to perform token transfer, such as signature-based.
1537      *
1538      * Requirements:
1539      *
1540      * - `from` cannot be the zero address.
1541      * - `to` cannot be the zero address.
1542      * - `tokenId` token must exist and be owned by `from`.
1543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1548         _transfer(from, to, tokenId);
1549         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1550     }
1551 
1552     /**
1553      * @dev Returns whether `tokenId` exists.
1554      *
1555      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1556      *
1557      * Tokens start existing when they are minted (`_mint`),
1558      * and stop existing when they are burned (`_burn`).
1559      */
1560     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1561         return _tokenOwners.contains(tokenId);
1562     }
1563 
1564     /**
1565      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1566      *
1567      * Requirements:
1568      *
1569      * - `tokenId` must exist.
1570      */
1571     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1572         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1573         address owner = ERC721.ownerOf(tokenId);
1574         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1575     }
1576 
1577     /**
1578      * @dev Safely mints `tokenId` and transfers it to `to`.
1579      *
1580      * Requirements:
1581      d*
1582      * - `tokenId` must not exist.
1583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1584      *
1585      * Emits a {Transfer} event.
1586      */
1587     function _safeMint(address to, uint256 tokenId) internal virtual {
1588         _safeMint(to, tokenId, "");
1589     }
1590 
1591     /**
1592      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1593      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1594      */
1595     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1596         _mint(to, tokenId);
1597         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1598     }
1599 
1600     /**
1601      * @dev Mints `tokenId` and transfers it to `to`.
1602      *
1603      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1604      *
1605      * Requirements:
1606      *
1607      * - `tokenId` must not exist.
1608      * - `to` cannot be the zero address.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _mint(address to, uint256 tokenId) internal virtual {
1613         require(to != address(0), "ERC721: mint to the zero address");
1614         require(!_exists(tokenId), "ERC721: token already minted");
1615 
1616         _beforeTokenTransfer(address(0), to, tokenId);
1617 
1618         _holderTokens[to].add(tokenId);
1619 
1620         _tokenOwners.set(tokenId, to);
1621 
1622         emit Transfer(address(0), to, tokenId);
1623     }
1624 
1625     /**
1626      * @dev Destroys `tokenId`.
1627      * The approval is cleared when the token is burned.
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must exist.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function _burn(uint256 tokenId) internal virtual {
1636         address owner = ERC721.ownerOf(tokenId); // internal owner
1637 
1638         _beforeTokenTransfer(owner, address(0), tokenId);
1639 
1640         // Clear approvals
1641         _approve(address(0), tokenId);
1642 
1643         // Clear metadata (if any)
1644         if (bytes(_tokenURIs[tokenId]).length != 0) {
1645             delete _tokenURIs[tokenId];
1646         }
1647 
1648         _holderTokens[owner].remove(tokenId);
1649 
1650         _tokenOwners.remove(tokenId);
1651 
1652         emit Transfer(owner, address(0), tokenId);
1653     }
1654 
1655     /**
1656      * @dev Transfers `tokenId` from `from` to `to`.
1657      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1658      *
1659      * Requirements:
1660      *
1661      * - `to` cannot be the zero address.
1662      * - `tokenId` token must be owned by `from`.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1667         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1668         require(to != address(0), "ERC721: transfer to the zero address");
1669 
1670         _beforeTokenTransfer(from, to, tokenId);
1671 
1672         // Clear approvals from the previous owner
1673         _approve(address(0), tokenId);
1674 
1675         _holderTokens[from].remove(tokenId);
1676         _holderTokens[to].add(tokenId);
1677 
1678         _tokenOwners.set(tokenId, to);
1679 
1680         emit Transfer(from, to, tokenId);
1681     }
1682 
1683     /**
1684      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1685      *
1686      * Requirements:
1687      *
1688      * - `tokenId` must exist.
1689      */
1690     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1691         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1692         _tokenURIs[tokenId] = _tokenURI;
1693     }
1694 
1695     /**
1696      * @dev Internal function to set the base URI for all token IDs. It is
1697      * automatically added as a prefix to the value returned in {tokenURI},
1698      * or to the token ID if {tokenURI} is empty.
1699      */
1700     function _setBaseURI(string memory baseURI_) internal virtual {
1701         _baseURI = baseURI_;
1702     }
1703 
1704     /**
1705      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1706      * The call is not executed if the target address is not a contract.
1707      *
1708      * @param from address representing the previous owner of the given token ID
1709      * @param to target address that will receive the tokens
1710      * @param tokenId uint256 ID of the token to be transferred
1711      * @param _data bytes optional data to send along with the call
1712      * @return bool whether the call correctly returned the expected magic value
1713      */
1714     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1715         private returns (bool)
1716     {
1717         if (!to.isContract()) {
1718             return true;
1719         }
1720         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1721             IERC721Receiver(to).onERC721Received.selector,
1722             _msgSender(),
1723             from,
1724             tokenId,
1725             _data
1726         ), "ERC721: transfer to non ERC721Receiver implementer");
1727         bytes4 retval = abi.decode(returndata, (bytes4));
1728         return (retval == _ERC721_RECEIVED);
1729     }
1730 
1731     /**
1732      * @dev Approve `to` to operate on `tokenId`
1733      *
1734      * Emits an {Approval} event.
1735      */
1736     function _approve(address to, uint256 tokenId) internal virtual {
1737         _tokenApprovals[tokenId] = to;
1738         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1739     }
1740 
1741     /**
1742      * @dev Hook that is called before any token transfer. This includes minting
1743      * and burning.
1744      *
1745      * Calling conditions:
1746      *
1747      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1748      * transferred to `to`.
1749      * - When `from` is zero, `tokenId` will be minted for `to`.
1750      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1751      * - `from` cannot be the zero address.
1752      * - `to` cannot be the zero address.
1753      *
1754      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1755      */
1756     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1757 }
1758 
1759 
1760 /**
1761  * @dev Contract module which provides a basic access control mechanism, where
1762  * there is an account (an owner) that can be granted exclusive access to
1763  * specific functions.
1764  *
1765  * By default, the owner account will be the one that deploys the contract. This
1766  * can later be changed with {transferOwnership}.
1767  *
1768  * This module is used through inheritance. It will make available the modifier
1769  * `onlyOwner`, which can be applied to your functions to restrict their use to
1770  * the owner.
1771  */
1772 abstract contract Ownable is Context {
1773     address private _owner;
1774 
1775     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1776 
1777     /**
1778      * @dev Initializes the contract setting the deployer as the initial owner.
1779      */
1780     constructor () {
1781         address msgSender = _msgSender();
1782         _owner = msgSender;
1783         emit OwnershipTransferred(address(0), msgSender);
1784     }
1785 
1786     /**
1787      * @dev Returns the address of the current owner.
1788      */
1789     function owner() public view virtual returns (address) {
1790         return _owner;
1791     }
1792 
1793     /**
1794      * @dev Throws if called by any account other than the owner.
1795      */
1796     modifier onlyOwner() {
1797         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1798         _;
1799     }
1800 
1801     /**
1802      * @dev Leaves the contract without owner. It will not be possible to call
1803      * `onlyOwner` functions anymore. Can only be called by the current owner.
1804      *
1805      * NOTE: Renouncing ownership will leave the contract without an owner,
1806      * thereby removing any functionality that is only available to the owner.
1807      */
1808     function renounceOwnership() public virtual onlyOwner {
1809         emit OwnershipTransferred(_owner, address(0));
1810         _owner = address(0);
1811     }
1812 
1813     /**
1814      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1815      * Can only be called by the current owner.
1816      */
1817     function transferOwnership(address newOwner) public virtual onlyOwner {
1818         require(newOwner != address(0), "Ownable: new owner is the zero address");
1819         emit OwnershipTransferred(_owner, newOwner);
1820         _owner = newOwner;
1821     }
1822 }
1823 
1824 /**
1825  * @title contract
1826  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1827  */
1828 contract DirtyDogs is ERC721, Ownable {
1829     using SafeMath for uint256;
1830 
1831     uint256 public mintPrice;
1832     uint256 public maxPublicToMint;
1833     uint256 public maxPresaleToMint;
1834     uint256 public maxNftSupply;
1835     uint256 public maxPresaleSupply;
1836     uint256 public curTicketId;
1837 
1838     mapping(address => uint256) public presaleNumOfUser;
1839     mapping(address => uint256) public publicNumOfUser;
1840     mapping(address => uint256) public totalClaimed;
1841 
1842     address private wallet1;
1843     address private wallet2;
1844     address private wallet3;
1845     address private wallet4;
1846 
1847     bool public presaleAllowed;
1848     bool public publicSaleAllowed;    
1849     uint256 public presaleStartTimestamp;
1850     uint256 public publicSaleStartTimestamp;    
1851 
1852     mapping(address => bool) private presaleWhitelist;
1853 
1854     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1855         maxNftSupply = 7777;
1856         maxPresaleSupply = 1500;
1857         mintPrice = 0.065 ether;
1858         maxPublicToMint = 20;
1859         maxPresaleToMint = 3;
1860         curTicketId = 0;
1861 
1862         presaleAllowed = false;
1863         publicSaleAllowed = false;
1864 
1865         presaleStartTimestamp = 0;
1866         publicSaleStartTimestamp = 0;
1867 
1868         wallet1 = 0x4257c7c9c214c576d8F55f6F0529B773ac3fADc5;
1869         wallet2 = 0x0B77a829632184283cdbfc0C108401e9fcd7cec9;
1870         wallet3 = 0xef04ee0505cdEAA260Ce73bBd8D1114623f840f1;
1871         wallet4 = 0x3Ad7Df572F750B891557cDc9C078c6b236208c5F;
1872     }
1873 
1874     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1875         uint256 tokenCount = balanceOf(_owner);
1876         if (tokenCount == 0) {
1877             return new uint256[](0);
1878         } else {
1879             uint256[] memory result = new uint256[](tokenCount);
1880             for (uint256 index; index < tokenCount; index++) {
1881                 result[index] = tokenOfOwnerByIndex(_owner, index);
1882             }
1883             return result;
1884         }
1885     }
1886 
1887     function exists(uint256 _tokenId) public view returns (bool) {
1888         return _exists(_tokenId);
1889     }
1890 
1891     function isPresaleLive() public view returns(bool) {
1892         uint256 curTimestamp = block.timestamp;
1893         if (presaleAllowed && presaleStartTimestamp <= curTimestamp && curTicketId < maxPresaleSupply) {
1894             return true;
1895         }
1896         return false;
1897     }
1898 
1899     function isPublicSaleLive() public view returns(bool) {
1900         uint256 curTimestamp = block.timestamp;
1901         if (publicSaleAllowed && publicSaleStartTimestamp <= curTimestamp) {
1902             return true;
1903         }
1904         return false;
1905     }
1906 
1907     function setMintPrice(uint256 _price) external onlyOwner {
1908         mintPrice = _price;
1909     }
1910 
1911     function setMaxNftSupply(uint256 _maxValue) external onlyOwner {
1912         maxNftSupply = _maxValue;
1913     }
1914 
1915     function setMaxPresaleSupply(uint256 _maxValue) external onlyOwner {
1916         maxPresaleSupply = _maxValue;
1917     }
1918 
1919     function setMaxPresaleToMint(uint256 _maxValue) external onlyOwner {
1920         maxPresaleToMint = _maxValue;
1921     }
1922 
1923     function setMaxPublicToMint(uint256 _maxValue) external onlyOwner {
1924         maxPublicToMint = _maxValue;
1925     }
1926 
1927     function reserveNfts(address _to, uint256 _numberOfTokens) external onlyOwner {
1928         uint256 supply = totalSupply();
1929         require(_to != address(0), "Invalid address to reserve.");
1930         require(supply == curTicketId, "Ticket id and supply not matched.");
1931         uint256 i;
1932         
1933         for (i = 0; i < _numberOfTokens; i++) {
1934             _safeMint(_to, supply + i);
1935         }
1936 
1937         curTicketId = curTicketId.add(_numberOfTokens);
1938     }
1939 
1940     function setBaseURI(string memory baseURI) external onlyOwner {
1941         _setBaseURI(baseURI);
1942     }
1943 
1944     function updatePresaleState(bool newStatus, uint256 timeDiff) external onlyOwner {
1945         uint256 curTimestamp = block.timestamp;
1946         presaleAllowed = newStatus;
1947         presaleStartTimestamp = curTimestamp.add(timeDiff);
1948     }
1949 
1950     function updatePublicSaleState(bool newStatus, uint256 timeDiff) external onlyOwner {
1951         uint256 curTimestamp = block.timestamp;
1952         publicSaleAllowed = newStatus;
1953         publicSaleStartTimestamp = curTimestamp.add(timeDiff);
1954     }
1955 
1956     function addToPresale(address[] calldata addresses) external onlyOwner {
1957         for (uint256 i = 0; i < addresses.length; i++) {
1958             presaleWhitelist[addresses[i]] = true;
1959         }
1960     }
1961 
1962     function removeToPresale(address[] calldata addresses) external onlyOwner {
1963         for (uint256 i = 0; i < addresses.length; i++) {
1964             presaleWhitelist[addresses[i]] = false;
1965         }
1966     }
1967 
1968     function isInWhitelist(address user) external view returns (bool) {
1969         return presaleWhitelist[user];
1970     }
1971 
1972     function doPresale(uint256 numberOfTokens) external payable {
1973         uint256 numOfUser = presaleNumOfUser[_msgSender()];
1974 
1975         require(isPresaleLive(), "Presale has not started yet");
1976         require(presaleWhitelist[_msgSender()], "You are not on white list");
1977         require(numberOfTokens.add(numOfUser) <= maxPresaleToMint, "Exceeds max presale allowed per user");
1978         require(curTicketId.add(numberOfTokens) <= maxPresaleSupply, "Exceeds max presale supply");
1979         require(numberOfTokens > 0, "Must mint at least one token");
1980         require(mintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1981 
1982         presaleNumOfUser[_msgSender()] = numberOfTokens.add(presaleNumOfUser[_msgSender()]);
1983         curTicketId = curTicketId.add(numberOfTokens);
1984     }
1985 
1986     function doPublic(uint256 numberOfTokens) external payable {
1987         uint256 numOfUser = publicNumOfUser[_msgSender()];
1988         require(isPublicSaleLive(), "Public sale has not started yet");
1989         require(numberOfTokens.add(numOfUser) <= maxPublicToMint, "Exceeds max public sale allowed per user");
1990         require(curTicketId.add(numberOfTokens) <= maxNftSupply, "Exceeds max supply");
1991         require(numberOfTokens > 0, "Must mint at least one token");
1992         require(mintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1993 
1994         publicNumOfUser[_msgSender()] = numberOfTokens.add(publicNumOfUser[_msgSender()]);
1995         curTicketId = curTicketId.add(numberOfTokens);
1996     }
1997 
1998     function getUserClaimableTicketCount(address user) public view returns (uint256) {
1999         return presaleNumOfUser[user].add(publicNumOfUser[user]).sub(totalClaimed[user]);
2000     }
2001 
2002     function claimDogs() external {
2003         uint256 numbersOfTickets = getUserClaimableTicketCount(_msgSender());
2004         
2005         for(uint256 i = 0; i < numbersOfTickets; i++) {
2006             uint256 mintIndex = totalSupply();
2007             _safeMint(_msgSender(), mintIndex);
2008         }
2009 
2010         totalClaimed[_msgSender()] = numbersOfTickets.add(totalClaimed[_msgSender()]);
2011     }
2012 
2013     function withdraw() external onlyOwner {
2014         uint256 balance = address(this).balance;
2015         uint256 balance2 = balance.mul(40).div(100);
2016         uint256 balance3 = balance.mul(10).div(100);
2017         payable(wallet4).transfer(balance2);
2018         payable(wallet3).transfer(balance2);
2019         payable(wallet2).transfer(balance3);
2020         payable(wallet1).transfer(balance3);
2021     }
2022 }