1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File: @openzeppelin/contracts/introspection/IERC165.sol
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
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
169       * - `from` cannot be the zero address.
170       * - `to` cannot be the zero address.
171       * - `tokenId` token must exist and be owned by `from`.
172       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174       *
175       * Emits a {Transfer} event.
176       */
177     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
178 }
179 
180 
181 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
182 
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Metadata is IERC721 {
188     /**
189      * @dev Returns the token collection name.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the token collection symbol.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
200      */
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 
205 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Enumerable is IERC721 {
212     /**
213      * @dev Returns the total amount of tokens stored by the contract.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
219      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
220      */
221     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
222 
223     /**
224      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
225      * Use along with {totalSupply} to enumerate all tokens.
226      */
227     function tokenByIndex(uint256 index) external view returns (uint256);
228 }
229 
230 
231 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
249 }
250 
251 
252 // File: @openzeppelin/contracts/introspection/ERC165.sol
253 
254 /**
255  * @dev Implementation of the {IERC165} interface.
256  *
257  * Contracts may inherit from this and call {_registerInterface} to declare
258  * their support of an interface.
259  */
260 abstract contract ERC165 is IERC165 {
261     /*
262      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
263      */
264     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
265 
266     /**
267      * @dev Mapping of interface ids to whether or not it's supported.
268      */
269     mapping(bytes4 => bool) private _supportedInterfaces;
270 
271     constructor () {
272         // Derived contracts need only register support for their own interfaces,
273         // we register support for ERC165 itself here
274         _registerInterface(_INTERFACE_ID_ERC165);
275     }
276 
277     /**
278      * @dev See {IERC165-supportsInterface}.
279      *
280      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
283         return _supportedInterfaces[interfaceId];
284     }
285 
286     /**
287      * @dev Registers the contract as an implementer of the interface defined by
288      * `interfaceId`. Support of the actual ERC165 interface is automatic and
289      * registering its interface id is not required.
290      *
291      * See {IERC165-supportsInterface}.
292      *
293      * Requirements:
294      *
295      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
296      */
297     function _registerInterface(bytes4 interfaceId) internal virtual {
298         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
299         _supportedInterfaces[interfaceId] = true;
300     }
301 }
302 
303 
304 // File: @openzeppelin/contracts/math/SafeMath.sol
305 
306 /**
307  * @dev Wrappers over Solidity's arithmetic operations with added overflow
308  * checks.
309  *
310  * Arithmetic operations in Solidity wrap on overflow. This can easily result
311  * in bugs, because programmers usually assume that an overflow raises an
312  * error, which is the standard behavior in high level programming languages.
313  * `SafeMath` restores this intuition by reverting the transaction when an
314  * operation overflows.
315  *
316  * Using this library instead of the unchecked operations eliminates an entire
317  * class of bugs, so it's recommended to use it always.
318  */
319 library SafeMath {
320     /**
321      * @dev Returns the addition of two unsigned integers, with an overflow flag.
322      *
323      * _Available since v3.4._
324      */
325     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
326         uint256 c = a + b;
327         if (c < a) return (false, 0);
328         return (true, c);
329     }
330 
331     /**
332      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
333      *
334      * _Available since v3.4._
335      */
336     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
337         if (b > a) return (false, 0);
338         return (true, a - b);
339     }
340 
341     /**
342      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
343      *
344      * _Available since v3.4._
345      */
346     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
347         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348         // benefit is lost if 'b' is also tested.
349         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
350         if (a == 0) return (true, 0);
351         uint256 c = a * b;
352         if (c / a != b) return (false, 0);
353         return (true, c);
354     }
355 
356     /**
357      * @dev Returns the division of two unsigned integers, with a division by zero flag.
358      *
359      * _Available since v3.4._
360      */
361     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         if (b == 0) return (false, 0);
363         return (true, a / b);
364     }
365 
366     /**
367      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         if (b == 0) return (false, 0);
373         return (true, a % b);
374     }
375 
376     /**
377      * @dev Returns the addition of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `+` operator.
381      *
382      * Requirements:
383      *
384      * - Addition cannot overflow.
385      */
386     function add(uint256 a, uint256 b) internal pure returns (uint256) {
387         uint256 c = a + b;
388         require(c >= a, "SafeMath: addition overflow");
389         return c;
390     }
391 
392     /**
393      * @dev Returns the subtraction of two unsigned integers, reverting on
394      * overflow (when the result is negative).
395      *
396      * Counterpart to Solidity's `-` operator.
397      *
398      * Requirements:
399      *
400      * - Subtraction cannot overflow.
401      */
402     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403         require(b <= a, "SafeMath: subtraction overflow");
404         return a - b;
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `*` operator.
412      *
413      * Requirements:
414      *
415      * - Multiplication cannot overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         if (a == 0) return 0;
419         uint256 c = a * b;
420         require(c / a == b, "SafeMath: multiplication overflow");
421         return c;
422     }
423 
424     /**
425      * @dev Returns the integer division of two unsigned integers, reverting on
426      * division by zero. The result is rounded towards zero.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b) internal pure returns (uint256) {
437         require(b > 0, "SafeMath: division by zero");
438         return a / b;
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * reverting when dividing by zero.
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
454         require(b > 0, "SafeMath: modulo by zero");
455         return a % b;
456     }
457 
458     /**
459      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
460      * overflow (when the result is negative).
461      *
462      * CAUTION: This function is deprecated because it requires allocating memory for the error
463      * message unnecessarily. For custom revert reasons use {trySub}.
464      *
465      * Counterpart to Solidity's `-` operator.
466      *
467      * Requirements:
468      *
469      * - Subtraction cannot overflow.
470      */
471     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
472         require(b <= a, errorMessage);
473         return a - b;
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
478      * division by zero. The result is rounded towards zero.
479      *
480      * CAUTION: This function is deprecated because it requires allocating memory for the error
481      * message unnecessarily. For custom revert reasons use {tryDiv}.
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
492         require(b > 0, errorMessage);
493         return a / b;
494     }
495 
496     /**
497      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
498      * reverting with custom message when dividing by zero.
499      *
500      * CAUTION: This function is deprecated because it requires allocating memory for the error
501      * message unnecessarily. For custom revert reasons use {tryMod}.
502      *
503      * Counterpart to Solidity's `%` operator. This function uses a `revert`
504      * opcode (which leaves remaining gas untouched) while Solidity uses an
505      * invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
512         require(b > 0, errorMessage);
513         return a % b;
514     }
515 }
516 
517 
518 // File: @openzeppelin/contracts/utils/Address.sol
519 
520 /**
521  * @dev Collection of functions related to the address type
522  */
523 library Address {
524     /**
525      * @dev Returns true if `account` is a contract.
526      *
527      * [IMPORTANT]
528      * ====
529      * It is unsafe to assume that an address for which this function returns
530      * false is an externally-owned account (EOA) and not a contract.
531      *
532      * Among others, `isContract` will return false for the following
533      * types of addresses:
534      *
535      *  - an externally-owned account
536      *  - a contract in construction
537      *  - an address where a contract will be created
538      *  - an address where a contract lived, but was destroyed
539      * ====
540      */
541     function isContract(address account) internal view returns (bool) {
542         // This method relies on extcodesize, which returns 0 for contracts in
543         // construction, since the code is only stored at the end of the
544         // constructor execution.
545 
546         uint256 size;
547         // solhint-disable-next-line no-inline-assembly
548         assembly { size := extcodesize(account) }
549         return size > 0;
550     }
551 
552     /**
553      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
554      * `recipient`, forwarding all available gas and reverting on errors.
555      *
556      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
557      * of certain opcodes, possibly making contracts go over the 2300 gas limit
558      * imposed by `transfer`, making them unable to receive funds via
559      * `transfer`. {sendValue} removes this limitation.
560      *
561      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
562      *
563      * IMPORTANT: because control is transferred to `recipient`, care must be
564      * taken to not create reentrancy vulnerabilities. Consider using
565      * {ReentrancyGuard} or the
566      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
567      */
568     function sendValue(address payable recipient, uint256 amount) internal {
569         require(address(this).balance >= amount, "Address: insufficient balance");
570 
571         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
572         (bool success, ) = recipient.call{ value: amount }("");
573         require(success, "Address: unable to send value, recipient may have reverted");
574     }
575 
576     /**
577      * @dev Performs a Solidity function call using a low level `call`. A
578      * plain`call` is an unsafe replacement for a function call: use this
579      * function instead.
580      *
581      * If `target` reverts with a revert reason, it is bubbled up by this
582      * function (like regular Solidity function calls).
583      *
584      * Returns the raw returned data. To convert to the expected return value,
585      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
586      *
587      * Requirements:
588      *
589      * - `target` must be a contract.
590      * - calling `target` with `data` must not revert.
591      *
592      * _Available since v3.1._
593      */
594     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
595       return functionCall(target, data, "Address: low-level call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
600      * `errorMessage` as a fallback revert reason when `target` reverts.
601      *
602      * _Available since v3.1._
603      */
604     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, 0, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but also transferring `value` wei to `target`.
611      *
612      * Requirements:
613      *
614      * - the calling contract must have an ETH balance of at least `value`.
615      * - the called Solidity function must be `payable`.
616      *
617      * _Available since v3.1._
618      */
619     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
620         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
625      * with `errorMessage` as a fallback revert reason when `target` reverts.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
630         require(address(this).balance >= value, "Address: insufficient balance for call");
631         require(isContract(target), "Address: call to non-contract");
632 
633         // solhint-disable-next-line avoid-low-level-calls
634         (bool success, bytes memory returndata) = target.call{ value: value }(data);
635         return _verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
645         return functionStaticCall(target, data, "Address: low-level static call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
655         require(isContract(target), "Address: static call to non-contract");
656 
657         // solhint-disable-next-line avoid-low-level-calls
658         (bool success, bytes memory returndata) = target.staticcall(data);
659         return _verifyCallResult(success, returndata, errorMessage);
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
664      * but performing a delegate call.
665      *
666      * _Available since v3.4._
667      */
668     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
669         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
674      * but performing a delegate call.
675      *
676      * _Available since v3.4._
677      */
678     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
679         require(isContract(target), "Address: delegate call to non-contract");
680 
681         // solhint-disable-next-line avoid-low-level-calls
682         (bool success, bytes memory returndata) = target.delegatecall(data);
683         return _verifyCallResult(success, returndata, errorMessage);
684     }
685 
686     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
687         if (success) {
688             return returndata;
689         } else {
690             // Look for revert reason and bubble it up if present
691             if (returndata.length > 0) {
692                 // The easiest way to bubble the revert reason is using memory via assembly
693 
694                 // solhint-disable-next-line no-inline-assembly
695                 assembly {
696                     let returndata_size := mload(returndata)
697                     revert(add(32, returndata), returndata_size)
698                 }
699             } else {
700                 revert(errorMessage);
701             }
702         }
703     }
704 }
705 
706 
707 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
708 
709 /**
710  * @dev Library for managing
711  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
712  * types.
713  *
714  * Sets have the following properties:
715  *
716  * - Elements are added, removed, and checked for existence in constant time
717  * (O(1)).
718  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
719  *
720  * ```
721  * contract Example {
722  *     // Add the library methods
723  *     using EnumerableSet for EnumerableSet.AddressSet;
724  *
725  *     // Declare a set state variable
726  *     EnumerableSet.AddressSet private mySet;
727  * }
728  * ```
729  *
730  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
731  * and `uint256` (`UintSet`) are supported.
732  */
733 library EnumerableSet {
734     // To implement this library for multiple types with as little code
735     // repetition as possible, we write it in terms of a generic Set type with
736     // bytes32 values.
737     // The Set implementation uses private functions, and user-facing
738     // implementations (such as AddressSet) are just wrappers around the
739     // underlying Set.
740     // This means that we can only create new EnumerableSets for types that fit
741     // in bytes32.
742 
743     struct Set {
744         // Storage of set values
745         bytes32[] _values;
746 
747         // Position of the value in the `values` array, plus 1 because index 0
748         // means a value is not in the set.
749         mapping (bytes32 => uint256) _indexes;
750     }
751 
752     /**
753      * @dev Add a value to a set. O(1).
754      *
755      * Returns true if the value was added to the set, that is if it was not
756      * already present.
757      */
758     function _add(Set storage set, bytes32 value) private returns (bool) {
759         if (!_contains(set, value)) {
760             set._values.push(value);
761             // The value is stored at length-1, but we add 1 to all indexes
762             // and use 0 as a sentinel value
763             set._indexes[value] = set._values.length;
764             return true;
765         } else {
766             return false;
767         }
768     }
769 
770     /**
771      * @dev Removes a value from a set. O(1).
772      *
773      * Returns true if the value was removed from the set, that is if it was
774      * present.
775      */
776     function _remove(Set storage set, bytes32 value) private returns (bool) {
777         // We read and store the value's index to prevent multiple reads from the same storage slot
778         uint256 valueIndex = set._indexes[value];
779 
780         if (valueIndex != 0) { // Equivalent to contains(set, value)
781             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
782             // the array, and then remove the last element (sometimes called as 'swap and pop').
783             // This modifies the order of the array, as noted in {at}.
784 
785             uint256 toDeleteIndex = valueIndex - 1;
786             uint256 lastIndex = set._values.length - 1;
787 
788             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
789             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
790 
791             bytes32 lastvalue = set._values[lastIndex];
792 
793             // Move the last value to the index where the value to delete is
794             set._values[toDeleteIndex] = lastvalue;
795             // Update the index for the moved value
796             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
797 
798             // Delete the slot where the moved value was stored
799             set._values.pop();
800 
801             // Delete the index for the deleted slot
802             delete set._indexes[value];
803 
804             return true;
805         } else {
806             return false;
807         }
808     }
809 
810     /**
811      * @dev Returns true if the value is in the set. O(1).
812      */
813     function _contains(Set storage set, bytes32 value) private view returns (bool) {
814         return set._indexes[value] != 0;
815     }
816 
817     /**
818      * @dev Returns the number of values on the set. O(1).
819      */
820     function _length(Set storage set) private view returns (uint256) {
821         return set._values.length;
822     }
823 
824    /**
825     * @dev Returns the value stored at position `index` in the set. O(1).
826     *
827     * Note that there are no guarantees on the ordering of values inside the
828     * array, and it may change when more values are added or removed.
829     *
830     * Requirements:
831     *
832     * - `index` must be strictly less than {length}.
833     */
834     function _at(Set storage set, uint256 index) private view returns (bytes32) {
835         require(set._values.length > index, "EnumerableSet: index out of bounds");
836         return set._values[index];
837     }
838 
839     // Bytes32Set
840 
841     struct Bytes32Set {
842         Set _inner;
843     }
844 
845     /**
846      * @dev Add a value to a set. O(1).
847      *
848      * Returns true if the value was added to the set, that is if it was not
849      * already present.
850      */
851     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
852         return _add(set._inner, value);
853     }
854 
855     /**
856      * @dev Removes a value from a set. O(1).
857      *
858      * Returns true if the value was removed from the set, that is if it was
859      * present.
860      */
861     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
862         return _remove(set._inner, value);
863     }
864 
865     /**
866      * @dev Returns true if the value is in the set. O(1).
867      */
868     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
869         return _contains(set._inner, value);
870     }
871 
872     /**
873      * @dev Returns the number of values in the set. O(1).
874      */
875     function length(Bytes32Set storage set) internal view returns (uint256) {
876         return _length(set._inner);
877     }
878 
879    /**
880     * @dev Returns the value stored at position `index` in the set. O(1).
881     *
882     * Note that there are no guarantees on the ordering of values inside the
883     * array, and it may change when more values are added or removed.
884     *
885     * Requirements:
886     *
887     * - `index` must be strictly less than {length}.
888     */
889     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
890         return _at(set._inner, index);
891     }
892 
893     // AddressSet
894 
895     struct AddressSet {
896         Set _inner;
897     }
898 
899     /**
900      * @dev Add a value to a set. O(1).
901      *
902      * Returns true if the value was added to the set, that is if it was not
903      * already present.
904      */
905     function add(AddressSet storage set, address value) internal returns (bool) {
906         return _add(set._inner, bytes32(uint256(uint160(value))));
907     }
908 
909     /**
910      * @dev Removes a value from a set. O(1).
911      *
912      * Returns true if the value was removed from the set, that is if it was
913      * present.
914      */
915     function remove(AddressSet storage set, address value) internal returns (bool) {
916         return _remove(set._inner, bytes32(uint256(uint160(value))));
917     }
918 
919     /**
920      * @dev Returns true if the value is in the set. O(1).
921      */
922     function contains(AddressSet storage set, address value) internal view returns (bool) {
923         return _contains(set._inner, bytes32(uint256(uint160(value))));
924     }
925 
926     /**
927      * @dev Returns the number of values in the set. O(1).
928      */
929     function length(AddressSet storage set) internal view returns (uint256) {
930         return _length(set._inner);
931     }
932 
933    /**
934     * @dev Returns the value stored at position `index` in the set. O(1).
935     *
936     * Note that there are no guarantees on the ordering of values inside the
937     * array, and it may change when more values are added or removed.
938     *
939     * Requirements:
940     *
941     * - `index` must be strictly less than {length}.
942     */
943     function at(AddressSet storage set, uint256 index) internal view returns (address) {
944         return address(uint160(uint256(_at(set._inner, index))));
945     }
946 
947     // UintSet
948 
949     struct UintSet {
950         Set _inner;
951     }
952 
953     /**
954      * @dev Add a value to a set. O(1).
955      *
956      * Returns true if the value was added to the set, that is if it was not
957      * already present.
958      */
959     function add(UintSet storage set, uint256 value) internal returns (bool) {
960         return _add(set._inner, bytes32(value));
961     }
962 
963     /**
964      * @dev Removes a value from a set. O(1).
965      *
966      * Returns true if the value was removed from the set, that is if it was
967      * present.
968      */
969     function remove(UintSet storage set, uint256 value) internal returns (bool) {
970         return _remove(set._inner, bytes32(value));
971     }
972 
973     /**
974      * @dev Returns true if the value is in the set. O(1).
975      */
976     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
977         return _contains(set._inner, bytes32(value));
978     }
979 
980     /**
981      * @dev Returns the number of values on the set. O(1).
982      */
983     function length(UintSet storage set) internal view returns (uint256) {
984         return _length(set._inner);
985     }
986 
987    /**
988     * @dev Returns the value stored at position `index` in the set. O(1).
989     *
990     * Note that there are no guarantees on the ordering of values inside the
991     * array, and it may change when more values are added or removed.
992     *
993     * Requirements:
994     *
995     * - `index` must be strictly less than {length}.
996     */
997     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
998         return uint256(_at(set._inner, index));
999     }
1000 }
1001 
1002 
1003 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1004 
1005 /**
1006  * @dev Library for managing an enumerable variant of Solidity's
1007  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1008  * type.
1009  *
1010  * Maps have the following properties:
1011  *
1012  * - Entries are added, removed, and checked for existence in constant time
1013  * (O(1)).
1014  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1015  *
1016  * ```
1017  * contract Example {
1018  *     // Add the library methods
1019  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1020  *
1021  *     // Declare a set state variable
1022  *     EnumerableMap.UintToAddressMap private myMap;
1023  * }
1024  * ```
1025  *
1026  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1027  * supported.
1028  */
1029 library EnumerableMap {
1030     // To implement this library for multiple types with as little code
1031     // repetition as possible, we write it in terms of a generic Map type with
1032     // bytes32 keys and values.
1033     // The Map implementation uses private functions, and user-facing
1034     // implementations (such as Uint256ToAddressMap) are just wrappers around
1035     // the underlying Map.
1036     // This means that we can only create new EnumerableMaps for types that fit
1037     // in bytes32.
1038 
1039     struct MapEntry {
1040         bytes32 _key;
1041         bytes32 _value;
1042     }
1043 
1044     struct Map {
1045         // Storage of map keys and values
1046         MapEntry[] _entries;
1047 
1048         // Position of the entry defined by a key in the `entries` array, plus 1
1049         // because index 0 means a key is not in the map.
1050         mapping (bytes32 => uint256) _indexes;
1051     }
1052 
1053     /**
1054      * @dev Adds a key-value pair to a map, or updates the value for an existing
1055      * key. O(1).
1056      *
1057      * Returns true if the key was added to the map, that is if it was not
1058      * already present.
1059      */
1060     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1061         // We read and store the key's index to prevent multiple reads from the same storage slot
1062         uint256 keyIndex = map._indexes[key];
1063 
1064         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1065             map._entries.push(MapEntry({ _key: key, _value: value }));
1066             // The entry is stored at length-1, but we add 1 to all indexes
1067             // and use 0 as a sentinel value
1068             map._indexes[key] = map._entries.length;
1069             return true;
1070         } else {
1071             map._entries[keyIndex - 1]._value = value;
1072             return false;
1073         }
1074     }
1075 
1076     /**
1077      * @dev Removes a key-value pair from a map. O(1).
1078      *
1079      * Returns true if the key was removed from the map, that is if it was present.
1080      */
1081     function _remove(Map storage map, bytes32 key) private returns (bool) {
1082         // We read and store the key's index to prevent multiple reads from the same storage slot
1083         uint256 keyIndex = map._indexes[key];
1084 
1085         if (keyIndex != 0) { // Equivalent to contains(map, key)
1086             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1087             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1088             // This modifies the order of the array, as noted in {at}.
1089 
1090             uint256 toDeleteIndex = keyIndex - 1;
1091             uint256 lastIndex = map._entries.length - 1;
1092 
1093             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1094             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1095 
1096             MapEntry storage lastEntry = map._entries[lastIndex];
1097 
1098             // Move the last entry to the index where the entry to delete is
1099             map._entries[toDeleteIndex] = lastEntry;
1100             // Update the index for the moved entry
1101             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1102 
1103             // Delete the slot where the moved entry was stored
1104             map._entries.pop();
1105 
1106             // Delete the index for the deleted slot
1107             delete map._indexes[key];
1108 
1109             return true;
1110         } else {
1111             return false;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns true if the key is in the map. O(1).
1117      */
1118     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1119         return map._indexes[key] != 0;
1120     }
1121 
1122     /**
1123      * @dev Returns the number of key-value pairs in the map. O(1).
1124      */
1125     function _length(Map storage map) private view returns (uint256) {
1126         return map._entries.length;
1127     }
1128 
1129    /**
1130     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1131     *
1132     * Note that there are no guarantees on the ordering of entries inside the
1133     * array, and it may change when more entries are added or removed.
1134     *
1135     * Requirements:
1136     *
1137     * - `index` must be strictly less than {length}.
1138     */
1139     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1140         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1141 
1142         MapEntry storage entry = map._entries[index];
1143         return (entry._key, entry._value);
1144     }
1145 
1146     /**
1147      * @dev Tries to returns the value associated with `key`.  O(1).
1148      * Does not revert if `key` is not in the map.
1149      */
1150     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1151         uint256 keyIndex = map._indexes[key];
1152         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1153         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1154     }
1155 
1156     /**
1157      * @dev Returns the value associated with `key`.  O(1).
1158      *
1159      * Requirements:
1160      *
1161      * - `key` must be in the map.
1162      */
1163     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1164         uint256 keyIndex = map._indexes[key];
1165         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1166         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1167     }
1168 
1169     /**
1170      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1171      *
1172      * CAUTION: This function is deprecated because it requires allocating memory for the error
1173      * message unnecessarily. For custom revert reasons use {_tryGet}.
1174      */
1175     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1176         uint256 keyIndex = map._indexes[key];
1177         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1178         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1179     }
1180 
1181     // UintToAddressMap
1182 
1183     struct UintToAddressMap {
1184         Map _inner;
1185     }
1186 
1187     /**
1188      * @dev Adds a key-value pair to a map, or updates the value for an existing
1189      * key. O(1).
1190      *
1191      * Returns true if the key was added to the map, that is if it was not
1192      * already present.
1193      */
1194     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1195         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1196     }
1197 
1198     /**
1199      * @dev Removes a value from a set. O(1).
1200      *
1201      * Returns true if the key was removed from the map, that is if it was present.
1202      */
1203     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1204         return _remove(map._inner, bytes32(key));
1205     }
1206 
1207     /**
1208      * @dev Returns true if the key is in the map. O(1).
1209      */
1210     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1211         return _contains(map._inner, bytes32(key));
1212     }
1213 
1214     /**
1215      * @dev Returns the number of elements in the map. O(1).
1216      */
1217     function length(UintToAddressMap storage map) internal view returns (uint256) {
1218         return _length(map._inner);
1219     }
1220 
1221    /**
1222     * @dev Returns the element stored at position `index` in the set. O(1).
1223     * Note that there are no guarantees on the ordering of values inside the
1224     * array, and it may change when more values are added or removed.
1225     *
1226     * Requirements:
1227     *
1228     * - `index` must be strictly less than {length}.
1229     */
1230     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1231         (bytes32 key, bytes32 value) = _at(map._inner, index);
1232         return (uint256(key), address(uint160(uint256(value))));
1233     }
1234 
1235     /**
1236      * @dev Tries to returns the value associated with `key`.  O(1).
1237      * Does not revert if `key` is not in the map.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1242         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1243         return (success, address(uint160(uint256(value))));
1244     }
1245 
1246     /**
1247      * @dev Returns the value associated with `key`.  O(1).
1248      *
1249      * Requirements:
1250      *
1251      * - `key` must be in the map.
1252      */
1253     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1254         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1255     }
1256 
1257     /**
1258      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1259      *
1260      * CAUTION: This function is deprecated because it requires allocating memory for the error
1261      * message unnecessarily. For custom revert reasons use {tryGet}.
1262      */
1263     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1264         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1265     }
1266 }
1267 
1268 
1269 // File: @openzeppelin/contracts/utils/Strings.sol
1270 
1271 /**
1272  * @dev String operations.
1273  */
1274 library Strings {
1275     /**
1276      * @dev Converts a `uint256` to its ASCII `string` representation.
1277      */
1278     function toString(uint256 value) internal pure returns (string memory) {
1279         // Inspired by OraclizeAPI's implementation - MIT licence
1280         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1281 
1282         if (value == 0) {
1283             return "0";
1284         }
1285         uint256 temp = value;
1286         uint256 digits;
1287         while (temp != 0) {
1288             digits++;
1289             temp /= 10;
1290         }
1291         bytes memory buffer = new bytes(digits);
1292         uint256 index = digits - 1;
1293         temp = value;
1294         while (temp != 0) {
1295             buffer[index--] = bytes1(uint8(48 + temp % 10));
1296             temp /= 10;
1297         }
1298         return string(buffer);
1299     }
1300 }
1301 
1302 
1303 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1304 
1305 /**
1306  * @title ERC721 Non-Fungible Token Standard basic implementation
1307  * @dev see https://eips.ethereum.org/EIPS/eip-721
1308  */
1309 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1310     using SafeMath for uint256;
1311     using Address for address;
1312     using EnumerableSet for EnumerableSet.UintSet;
1313     using EnumerableMap for EnumerableMap.UintToAddressMap;
1314     using Strings for uint256;
1315 
1316     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1317     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1318     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1319 
1320     // Mapping from holder address to their (enumerable) set of owned tokens
1321     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1322 
1323     // Enumerable mapping from token ids to their owners
1324     EnumerableMap.UintToAddressMap private _tokenOwners;
1325 
1326     // Mapping from token ID to approved address
1327     mapping (uint256 => address) private _tokenApprovals;
1328 
1329     // Mapping from owner to operator approvals
1330     mapping (address => mapping (address => bool)) private _operatorApprovals;
1331 
1332     // Token name
1333     string private _name;
1334 
1335     // Token symbol
1336     string private _symbol;
1337 
1338     // Optional mapping for token URIs
1339     mapping (uint256 => string) private _tokenURIs;
1340 
1341     // Base URI
1342     string private _baseURI;
1343 
1344     /*
1345      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1346      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1347      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1348      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1349      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1350      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1351      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1352      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1353      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1354      *
1355      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1356      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1357      */
1358     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1359 
1360     /*
1361      *     bytes4(keccak256('name()')) == 0x06fdde03
1362      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1363      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1364      *
1365      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1366      */
1367     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1368 
1369     /*
1370      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1371      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1372      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1373      *
1374      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1375      */
1376     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1377 
1378     /**
1379      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1380      */
1381     constructor (string memory name_, string memory symbol_) {
1382         _name = name_;
1383         _symbol = symbol_;
1384 
1385         // register the supported interfaces to conform to ERC721 via ERC165
1386         _registerInterface(_INTERFACE_ID_ERC721);
1387         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1388         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-balanceOf}.
1393      */
1394     function balanceOf(address owner) public view virtual override returns (uint256) {
1395         require(owner != address(0), "ERC721: balance query for the zero address");
1396         return _holderTokens[owner].length();
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-ownerOf}.
1401      */
1402     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1403         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1404     }
1405 
1406     /**
1407      * @dev See {IERC721Metadata-name}.
1408      */
1409     function name() public view virtual override returns (string memory) {
1410         return _name;
1411     }
1412 
1413     /**
1414      * @dev See {IERC721Metadata-symbol}.
1415      */
1416     function symbol() public view virtual override returns (string memory) {
1417         return _symbol;
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Metadata-tokenURI}.
1422      */
1423     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1424         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1425 
1426         string memory _tokenURI = _tokenURIs[tokenId];
1427         string memory base = baseURI();
1428 
1429         // If there is no base URI, return the token URI.
1430         if (bytes(base).length == 0) {
1431             return _tokenURI;
1432         }
1433         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1434         if (bytes(_tokenURI).length > 0) {
1435             return string(abi.encodePacked(base, _tokenURI));
1436         }
1437         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1438         return string(abi.encodePacked(base, tokenId.toString()));
1439     }
1440 
1441     /**
1442     * @dev Returns the base URI set via {_setBaseURI}. This will be
1443     * automatically added as a prefix in {tokenURI} to each token's URI, or
1444     * to the token ID if no specific URI is set for that token ID.
1445     */
1446     function baseURI() public view virtual returns (string memory) {
1447         return _baseURI;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1452      */
1453     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1454         return _holderTokens[owner].at(index);
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-totalSupply}.
1459      */
1460     function totalSupply() public view virtual override returns (uint256) {
1461         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1462         return _tokenOwners.length();
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Enumerable-tokenByIndex}.
1467      */
1468     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1469         (uint256 tokenId, ) = _tokenOwners.at(index);
1470         return tokenId;
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-approve}.
1475      */
1476     function approve(address to, uint256 tokenId) public virtual override {
1477         address owner = ERC721.ownerOf(tokenId);
1478         require(to != owner, "ERC721: approval to current owner");
1479 
1480         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1481             "ERC721: approve caller is not owner nor approved for all"
1482         );
1483 
1484         _approve(to, tokenId);
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-getApproved}.
1489      */
1490     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1491         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1492 
1493         return _tokenApprovals[tokenId];
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-setApprovalForAll}.
1498      */
1499     function setApprovalForAll(address operator, bool approved) public virtual override {
1500         require(operator != _msgSender(), "ERC721: approve to caller");
1501 
1502         _operatorApprovals[_msgSender()][operator] = approved;
1503         emit ApprovalForAll(_msgSender(), operator, approved);
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-isApprovedForAll}.
1508      */
1509     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1510         return _operatorApprovals[owner][operator];
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-transferFrom}.
1515      */
1516     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1517         //solhint-disable-next-line max-line-length
1518         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1519 
1520         _transfer(from, to, tokenId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-safeTransferFrom}.
1525      */
1526     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1527         safeTransferFrom(from, to, tokenId, "");
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-safeTransferFrom}.
1532      */
1533     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1534         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1535         _safeTransfer(from, to, tokenId, _data);
1536     }
1537 
1538     /**
1539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1541      *
1542      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1543      *
1544      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1545      * implement alternative mechanisms to perform token transfer, such as signature-based.
1546      *
1547      * Requirements:
1548      *
1549      * - `from` cannot be the zero address.
1550      * - `to` cannot be the zero address.
1551      * - `tokenId` token must exist and be owned by `from`.
1552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1553      *
1554      * Emits a {Transfer} event.
1555      */
1556     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1557         _transfer(from, to, tokenId);
1558         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1559     }
1560 
1561     /**
1562      * @dev Returns whether `tokenId` exists.
1563      *
1564      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1565      *
1566      * Tokens start existing when they are minted (`_mint`),
1567      * and stop existing when they are burned (`_burn`).
1568      */
1569     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1570         return _tokenOwners.contains(tokenId);
1571     }
1572 
1573     /**
1574      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1575      *
1576      * Requirements:
1577      *
1578      * - `tokenId` must exist.
1579      */
1580     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1581         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1582         address owner = ERC721.ownerOf(tokenId);
1583         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1584     }
1585 
1586     /**
1587      * @dev Safely mints `tokenId` and transfers it to `to`.
1588      *
1589      * Requirements:
1590      d*
1591      * - `tokenId` must not exist.
1592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _safeMint(address to, uint256 tokenId) internal virtual {
1597         _safeMint(to, tokenId, "");
1598     }
1599 
1600     /**
1601      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1602      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1603      */
1604     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1605         _mint(to, tokenId);
1606         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1607     }
1608 
1609     /**
1610      * @dev Mints `tokenId` and transfers it to `to`.
1611      *
1612      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1613      *
1614      * Requirements:
1615      *
1616      * - `tokenId` must not exist.
1617      * - `to` cannot be the zero address.
1618      *
1619      * Emits a {Transfer} event.
1620      */
1621     function _mint(address to, uint256 tokenId) internal virtual {
1622         require(to != address(0), "ERC721: mint to the zero address");
1623         require(!_exists(tokenId), "ERC721: token already minted");
1624 
1625         _beforeTokenTransfer(address(0), to, tokenId);
1626 
1627         _holderTokens[to].add(tokenId);
1628 
1629         _tokenOwners.set(tokenId, to);
1630 
1631         emit Transfer(address(0), to, tokenId);
1632     }
1633 
1634     /**
1635      * @dev Destroys `tokenId`.
1636      * The approval is cleared when the token is burned.
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must exist.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _burn(uint256 tokenId) internal virtual {
1645         address owner = ERC721.ownerOf(tokenId); // internal owner
1646 
1647         _beforeTokenTransfer(owner, address(0), tokenId);
1648 
1649         // Clear approvals
1650         _approve(address(0), tokenId);
1651 
1652         // Clear metadata (if any)
1653         if (bytes(_tokenURIs[tokenId]).length != 0) {
1654             delete _tokenURIs[tokenId];
1655         }
1656 
1657         _holderTokens[owner].remove(tokenId);
1658 
1659         _tokenOwners.remove(tokenId);
1660 
1661         emit Transfer(owner, address(0), tokenId);
1662     }
1663 
1664     /**
1665      * @dev Transfers `tokenId` from `from` to `to`.
1666      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1667      *
1668      * Requirements:
1669      *
1670      * - `to` cannot be the zero address.
1671      * - `tokenId` token must be owned by `from`.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1676         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1677         require(to != address(0), "ERC721: transfer to the zero address");
1678 
1679         _beforeTokenTransfer(from, to, tokenId);
1680 
1681         // Clear approvals from the previous owner
1682         _approve(address(0), tokenId);
1683 
1684         _holderTokens[from].remove(tokenId);
1685         _holderTokens[to].add(tokenId);
1686 
1687         _tokenOwners.set(tokenId, to);
1688 
1689         emit Transfer(from, to, tokenId);
1690     }
1691 
1692     /**
1693      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1694      *
1695      * Requirements:
1696      *
1697      * - `tokenId` must exist.
1698      */
1699     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1700         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1701         _tokenURIs[tokenId] = _tokenURI;
1702     }
1703 
1704     /**
1705      * @dev Internal function to set the base URI for all token IDs. It is
1706      * automatically added as a prefix to the value returned in {tokenURI},
1707      * or to the token ID if {tokenURI} is empty.
1708      */
1709     function _setBaseURI(string memory baseURI_) internal virtual {
1710         _baseURI = baseURI_;
1711     }
1712 
1713     /**
1714      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1715      * The call is not executed if the target address is not a contract.
1716      *
1717      * @param from address representing the previous owner of the given token ID
1718      * @param to target address that will receive the tokens
1719      * @param tokenId uint256 ID of the token to be transferred
1720      * @param _data bytes optional data to send along with the call
1721      * @return bool whether the call correctly returned the expected magic value
1722      */
1723     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1724         private returns (bool)
1725     {
1726         if (!to.isContract()) {
1727             return true;
1728         }
1729         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1730             IERC721Receiver(to).onERC721Received.selector,
1731             _msgSender(),
1732             from,
1733             tokenId,
1734             _data
1735         ), "ERC721: transfer to non ERC721Receiver implementer");
1736         bytes4 retval = abi.decode(returndata, (bytes4));
1737         return (retval == _ERC721_RECEIVED);
1738     }
1739 
1740     /**
1741      * @dev Approve `to` to operate on `tokenId`
1742      *
1743      * Emits an {Approval} event.
1744      */
1745     function _approve(address to, uint256 tokenId) internal virtual {
1746         _tokenApprovals[tokenId] = to;
1747         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1748     }
1749 
1750     /**
1751      * @dev Hook that is called before any token transfer. This includes minting
1752      * and burning.
1753      *
1754      * Calling conditions:
1755      *
1756      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1757      * transferred to `to`.
1758      * - When `from` is zero, `tokenId` will be minted for `to`.
1759      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1760      * - `from` cannot be the zero address.
1761      * - `to` cannot be the zero address.
1762      *
1763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1764      */
1765     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1766 }
1767 
1768 
1769 // File: @openzeppelin/contracts/access/Ownable.sol
1770 
1771 /**
1772  * @dev Contract module which provides a basic access control mechanism, where
1773  * there is an account (an owner) that can be granted exclusive access to
1774  * specific functions.
1775  *
1776  * By default, the owner account will be the one that deploys the contract. This
1777  * can later be changed with {transferOwnership}.
1778  *
1779  * This module is used through inheritance. It will make available the modifier
1780  * `onlyOwner`, which can be applied to your functions to restrict their use to
1781  * the owner.
1782  */
1783 abstract contract Ownable is Context {
1784     address private _owner;
1785 
1786     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1787 
1788     /**
1789      * @dev Initializes the contract setting the deployer as the initial owner.
1790      */
1791     constructor () {
1792         address msgSender = _msgSender();
1793         _owner = msgSender;
1794         emit OwnershipTransferred(address(0), msgSender);
1795     }
1796 
1797     /**
1798      * @dev Returns the address of the current owner.
1799      */
1800     function owner() public view virtual returns (address) {
1801         return _owner;
1802     }
1803 
1804     /**
1805      * @dev Throws if called by any account other than the owner.
1806      */
1807     modifier onlyOwner() {
1808         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1809         _;
1810     }
1811 
1812     /**
1813      * @dev Leaves the contract without owner. It will not be possible to call
1814      * `onlyOwner` functions anymore. Can only be called by the current owner.
1815      *
1816      * NOTE: Renouncing ownership will leave the contract without an owner,
1817      * thereby removing any functionality that is only available to the owner.
1818      */
1819     function renounceOwnership() public virtual onlyOwner {
1820         emit OwnershipTransferred(_owner, address(0));
1821         _owner = address(0);
1822     }
1823 
1824     /**
1825      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1826      * Can only be called by the current owner.
1827      */
1828     function transferOwnership(address newOwner) public virtual onlyOwner {
1829         require(newOwner != address(0), "Ownable: new owner is the zero address");
1830         emit OwnershipTransferred(_owner, newOwner);
1831         _owner = newOwner;
1832     }
1833 }
1834 
1835 
1836 // File: contracts/TheDogePound.sol
1837 
1838 /**
1839  * @title TheDogePound contract
1840  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1841  */
1842 contract TheDogePound is ERC721, Ownable {
1843     using SafeMath for uint256;
1844 
1845     uint256 public startingIndexBlock;
1846     uint256 public startingIndex;
1847     uint256 public mintPrice;
1848     uint256 public maxToMint;
1849     uint256 public MAX_DOGE_SUPPLY;
1850     uint256 public REVEAL_TIMESTAMP;
1851 
1852     string public PROVENANCE_HASH = "";
1853     bool public saleIsActive;
1854 
1855     address wallet1;
1856     address wallet2;
1857 
1858     constructor() ERC721("The Doge Pound", "DOGGY") {
1859         MAX_DOGE_SUPPLY = 10000;
1860         REVEAL_TIMESTAMP = block.timestamp + (86400 * 7);
1861         mintPrice = 69000000000000000; // 0.069 ETH
1862         maxToMint = 30;
1863         saleIsActive = false;
1864         wallet1 = 0xbb683E735ca23fDb9Ba6F22F3608bf5eD20B845f;
1865         wallet2 = 0x1097F467E199018e1F2E506cb646431E863C417f;
1866     }
1867 
1868     /**
1869      * Get the array of token for owner.
1870      */
1871     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1872         uint256 tokenCount = balanceOf(_owner);
1873         if (tokenCount == 0) {
1874             return new uint256[](0);
1875         } else {
1876             uint256[] memory result = new uint256[](tokenCount);
1877             for (uint256 index; index < tokenCount; index++) {
1878                 result[index] = tokenOfOwnerByIndex(_owner, index);
1879             }
1880             return result;
1881         }
1882     }
1883 
1884     /**
1885      * Check if certain token id is exists.
1886      */
1887     function exists(uint256 _tokenId) public view returns (bool) {
1888         return _exists(_tokenId);
1889     }
1890 
1891     /**
1892      * Set price to mint a Doge.
1893      */
1894     function setMintPrice(uint256 _price) external onlyOwner {
1895         mintPrice = _price;
1896     }
1897 
1898     /**
1899      * Set maximum count to mint per once.
1900      */
1901     function setMaxToMint(uint256 _maxValue) external onlyOwner {
1902         maxToMint = _maxValue;
1903     }
1904 
1905     /**
1906      * Mint Doges by owner
1907      */
1908     function reserveDoges(address _to, uint256 _numberOfTokens) external onlyOwner {
1909         require(_to != address(0), "Invalid address to reserve.");
1910         uint256 supply = totalSupply();
1911         uint256 i;
1912         
1913         for (i = 0; i < _numberOfTokens; i++) {
1914             _safeMint(_to, supply + i);
1915         }
1916     }
1917 
1918     /**
1919      * Set reveal timestamp when finished the sale.
1920      */
1921     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {
1922         REVEAL_TIMESTAMP = _revealTimeStamp;
1923     } 
1924 
1925     /*     
1926     * Set provenance once it's calculated
1927     */
1928     function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
1929         PROVENANCE_HASH = _provenanceHash;
1930     }
1931 
1932     function setBaseURI(string memory baseURI) external onlyOwner {
1933         _setBaseURI(baseURI);
1934     }
1935 
1936     /*
1937     * Pause sale if active, make active if paused
1938     */
1939     function setSaleState() external onlyOwner {
1940         saleIsActive = !saleIsActive;
1941     }
1942 
1943     /**
1944     * Mints tokens
1945     */
1946     function mintDoges(uint256 numberOfTokens) external payable {
1947         require(saleIsActive, "Sale must be active to mint");
1948         require(numberOfTokens <= maxToMint, "Invalid amount to mint per once");
1949         require(totalSupply().add(numberOfTokens) <= MAX_DOGE_SUPPLY, "Purchase would exceed max supply");
1950         require(mintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1951         
1952         for(uint256 i = 0; i < numberOfTokens; i++) {
1953             uint256 mintIndex = totalSupply();
1954             if (totalSupply() < MAX_DOGE_SUPPLY) {
1955                 _safeMint(msg.sender, mintIndex);
1956             }
1957         }
1958 
1959         // If we haven't set the starting index and this is either
1960         // 1) the last saleable token or 2) the first token to be sold after
1961         // the end of pre-sale, set the starting index block
1962         if (startingIndexBlock == 0 && (totalSupply() == MAX_DOGE_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
1963             startingIndexBlock = block.number;
1964         } 
1965     }
1966 
1967     /**
1968      * Set the starting index for the collection
1969      */
1970     function setStartingIndex() external {
1971         require(startingIndex == 0, "Starting index is already set");
1972         require(startingIndexBlock != 0, "Starting index block must be set");
1973         
1974         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_DOGE_SUPPLY;
1975         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1976         if (block.number.sub(startingIndexBlock) > 255) {
1977             startingIndex = uint256(blockhash(block.number - 1)) % MAX_DOGE_SUPPLY;
1978         }
1979         // Prevent default sequence
1980         if (startingIndex == 0) {
1981             startingIndex = startingIndex.add(1);
1982         }
1983     }
1984 
1985     /**
1986      * Set the starting index block for the collection, essentially unblocking
1987      * setting starting index
1988      */
1989     function emergencySetStartingIndexBlock() external onlyOwner {
1990         require(startingIndex == 0, "Starting index is already set");
1991         
1992         startingIndexBlock = block.number;
1993     }
1994 
1995     function withdraw() external onlyOwner {
1996         uint256 balance = address(this).balance;
1997         uint256 walletBalance = balance.mul(50).div(100);
1998         payable(wallet1).transfer(walletBalance);
1999         payable(wallet2).transfer(balance.sub(walletBalance));
2000     }
2001 }