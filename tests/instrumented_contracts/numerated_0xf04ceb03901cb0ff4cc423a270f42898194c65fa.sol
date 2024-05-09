1 //SPDX-License-Identifier: UNLICENSED 
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     } 
18  
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts/introspection/IERC165.sol
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
49 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
50 
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 interface IERC721 is IERC165 {
55     /**
56      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
57      */
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62      */
63     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(address from, address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160       * @dev Safely transfers `tokenId` token from `from` to `to`.
161       *
162       * Requirements:
163       *
164       * - `from` cannot be the zero address.
165       * - `to` cannot be the zero address.
166       * - `tokenId` token must exist and be owned by `from`.
167       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169       *
170       * Emits a {Transfer} event.
171       */
172     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
176 
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Metadata is IERC721 {
184 
185     /**
186      * @dev Returns the token collection name.
187      */
188     function name() external view returns (string memory);
189 
190     /**
191      * @dev Returns the token collection symbol.
192      */
193     function symbol() external view returns (string memory);
194 
195     /**
196      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
197      */
198     function tokenURI(uint256 tokenId) external view returns (string memory);
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
202 
203 
204 
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
208  * @dev See https://eips.ethereum.org/EIPS/eip-721
209  */
210 interface IERC721Enumerable is IERC721 {
211 
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
230 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
231 
232 
233 
234 /**
235  * @title ERC721 token receiver interface
236  * @dev Interface for any contract that wants to support safeTransfers
237  * from ERC721 asset contracts.
238  */
239 interface IERC721Receiver {
240     /**
241      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
242      * by `operator` from `from`, this function is called.
243      *
244      * It must return its Solidity selector to confirm the token transfer.
245      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
246      *
247      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
248      */
249     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
250 }
251 
252 // File: @openzeppelin/contracts/introspection/ERC165.sol
253 
254 
255 /**
256  * @dev Implementation of the {IERC165} interface.
257  *
258  * Contracts may inherit from this and call {_registerInterface} to declare
259  * their support of an interface.
260  */
261 abstract contract ERC165 is IERC165 {
262     /*
263      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
264      */
265     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
266 
267     /**
268      * @dev Mapping of interface ids to whether or not it's supported.
269      */
270     mapping(bytes4 => bool) private _supportedInterfaces;
271 
272     constructor ()  internal  {
273         // Derived contracts need only register support for their own interfaces,
274         // we register support for ERC165 itself here
275         _registerInterface(_INTERFACE_ID_ERC165);
276     }
277 
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      *
281      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return _supportedInterfaces[interfaceId];
285     }
286 
287     /**
288      * @dev Registers the contract as an implementer of the interface defined by
289      * `interfaceId`. Support of the actual ERC165 interface is automatic and
290      * registering its interface id is not required.
291      *
292      * See {IERC165-supportsInterface}.
293      *
294      * Requirements:
295      *
296      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
297      */
298     function _registerInterface(bytes4 interfaceId) internal virtual {
299         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
300         _supportedInterfaces[interfaceId] = true;
301     }
302 }
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
517 // File: @openzeppelin/contracts/utils/Address.sol
518 
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
706 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
707 
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
947 
948     // UintSet
949 
950     struct UintSet {
951         Set _inner;
952     }
953 
954     /**
955      * @dev Add a value to a set. O(1).
956      *
957      * Returns true if the value was added to the set, that is if it was not
958      * already present.
959      */
960     function add(UintSet storage set, uint256 value) internal returns (bool) {
961         return _add(set._inner, bytes32(value));
962     }
963 
964     /**
965      * @dev Removes a value from a set. O(1).
966      *
967      * Returns true if the value was removed from the set, that is if it was
968      * present.
969      */
970     function remove(UintSet storage set, uint256 value) internal returns (bool) {
971         return _remove(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
978         return _contains(set._inner, bytes32(value));
979     }
980 
981     /**
982      * @dev Returns the number of values on the set. O(1).
983      */
984     function length(UintSet storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988    /**
989     * @dev Returns the value stored at position `index` in the set. O(1).
990     *
991     * Note that there are no guarantees on the ordering of values inside the
992     * array, and it may change when more values are added or removed.
993     *
994     * Requirements:
995     *
996     * - `index` must be strictly less than {length}.
997     */
998     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
999         return uint256(_at(set._inner, index));
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1004 
1005 
1006 /**
1007  * @dev Library for managing an enumerable variant of Solidity's
1008  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1009  * type.
1010  *
1011  * Maps have the following properties:
1012  *
1013  * - Entries are added, removed, and checked for existence in constant time
1014  * (O(1)).
1015  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1016  *
1017  * ```
1018  * contract Example {
1019  *     // Add the library methods
1020  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1021  *
1022  *     // Declare a set state variable
1023  *     EnumerableMap.UintToAddressMap private myMap;
1024  * }
1025  * ```
1026  *
1027  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1028  * supported.
1029  */
1030 library EnumerableMap {
1031     // To implement this library for multiple types with as little code
1032     // repetition as possible, we write it in terms of a generic Map type with
1033     // bytes32 keys and values.
1034     // The Map implementation uses private functions, and user-facing
1035     // implementations (such as Uint256ToAddressMap) are just wrappers around
1036     // the underlying Map.
1037     // This means that we can only create new EnumerableMaps for types that fit
1038     // in bytes32.
1039 
1040     struct MapEntry {
1041         bytes32 _key;
1042         bytes32 _value;
1043     }
1044 
1045     struct Map {
1046         // Storage of map keys and values
1047         MapEntry[] _entries;
1048 
1049         // Position of the entry defined by a key in the `entries` array, plus 1
1050         // because index 0 means a key is not in the map.
1051         mapping (bytes32 => uint256) _indexes;
1052     }
1053 
1054     /**
1055      * @dev Adds a key-value pair to a map, or updates the value for an existing
1056      * key. O(1).
1057      *
1058      * Returns true if the key was added to the map, that is if it was not
1059      * already present.
1060      */
1061     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1062         // We read and store the key's index to prevent multiple reads from the same storage slot
1063         uint256 keyIndex = map._indexes[key];
1064 
1065         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1066             map._entries.push(MapEntry({ _key: key, _value: value }));
1067             // The entry is stored at length-1, but we add 1 to all indexes
1068             // and use 0 as a sentinel value
1069             map._indexes[key] = map._entries.length;
1070             return true;
1071         } else {
1072             map._entries[keyIndex - 1]._value = value;
1073             return false;
1074         }
1075     }
1076 
1077     /**
1078      * @dev Removes a key-value pair from a map. O(1).
1079      *
1080      * Returns true if the key was removed from the map, that is if it was present.
1081      */
1082     function _remove(Map storage map, bytes32 key) private returns (bool) {
1083         // We read and store the key's index to prevent multiple reads from the same storage slot
1084         uint256 keyIndex = map._indexes[key];
1085 
1086         if (keyIndex != 0) { // Equivalent to contains(map, key)
1087             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1088             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1089             // This modifies the order of the array, as noted in {at}.
1090 
1091             uint256 toDeleteIndex = keyIndex - 1;
1092             uint256 lastIndex = map._entries.length - 1;
1093 
1094             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1095             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1096 
1097             MapEntry storage lastEntry = map._entries[lastIndex];
1098 
1099             // Move the last entry to the index where the entry to delete is
1100             map._entries[toDeleteIndex] = lastEntry;
1101             // Update the index for the moved entry
1102             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1103 
1104             // Delete the slot where the moved entry was stored
1105             map._entries.pop();
1106 
1107             // Delete the index for the deleted slot
1108             delete map._indexes[key];
1109 
1110             return true;
1111         } else {
1112             return false;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Returns true if the key is in the map. O(1).
1118      */
1119     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1120         return map._indexes[key] != 0;
1121     }
1122 
1123     /**
1124      * @dev Returns the number of key-value pairs in the map. O(1).
1125      */
1126     function _length(Map storage map) private view returns (uint256) {
1127         return map._entries.length;
1128     }
1129 
1130    /**
1131     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1132     *
1133     * Note that there are no guarantees on the ordering of entries inside the
1134     * array, and it may change when more entries are added or removed.
1135     *
1136     * Requirements:
1137     *
1138     * - `index` must be strictly less than {length}.
1139     */
1140     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1141         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1142 
1143         MapEntry storage entry = map._entries[index];
1144         return (entry._key, entry._value);
1145     }
1146 
1147     /**
1148      * @dev Tries to returns the value associated with `key`.  O(1).
1149      * Does not revert if `key` is not in the map.
1150      */
1151     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1152         uint256 keyIndex = map._indexes[key];
1153         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1154         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1155     }
1156 
1157     /**
1158      * @dev Returns the value associated with `key`.  O(1).
1159      *
1160      * Requirements:
1161      *
1162      * - `key` must be in the map.
1163      */
1164     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1165         uint256 keyIndex = map._indexes[key];
1166         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1167         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1168     }
1169 
1170     /**
1171      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1172      *
1173      * CAUTION: This function is deprecated because it requires allocating memory for the error
1174      * message unnecessarily. For custom revert reasons use {_tryGet}.
1175      */
1176     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1177         uint256 keyIndex = map._indexes[key];
1178         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1179         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1180     }
1181 
1182     // UintToAddressMap
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
1266 
1267     // AddressToUintMap
1268     struct AddressToUintMap {
1269         Map _inner;
1270     }
1271     function set(AddressToUintMap storage map, address key, uint value) internal returns (bool) {
1272        return _set(map._inner,bytes32(uint256(uint160(key))),bytes32(value));
1273     }
1274 
1275     function remove(AddressToUintMap storage map, address key) internal returns (bool) {
1276         return _remove(map._inner, bytes32(uint256(uint160(key))));
1277     }
1278 
1279     function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
1280         return _contains(map._inner, bytes32(uint256(uint160(key))));
1281     }
1282  
1283     function length(AddressToUintMap storage map) internal view returns (uint256) {
1284         return _length(map._inner);
1285     }
1286  
1287     function at(AddressToUintMap storage map, uint256 index) internal view returns (address,uint256) {
1288         (bytes32 key, bytes32 value) = _at(map._inner, index);
1289         return (address(uint160(uint256(key))),uint256(key));
1290     }
1291 
1292     function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
1293         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(uint256(uint160(key))));
1294         return (success,  uint256(value));
1295     }
1296      
1297     function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
1298         return uint256(_get(map._inner,bytes32(uint256(uint160(key)))));
1299     }
1300     function get(AddressToUintMap storage map, address key, string memory errorMessage) internal view returns (uint256) {
1301          return uint256(_get(map._inner,bytes32(uint256(uint160(key))),errorMessage));
1302     }
1303 }
1304 
1305 // File: @openzeppelin/contracts/utils/Strings.sol
1306 
1307 /**
1308  * @dev String operations.
1309  */
1310 library Strings {
1311     /**
1312      * @dev Converts a `uint256` to its ASCII `string` representation.
1313      */
1314     function toString(uint256 value) internal pure returns (string memory) {
1315         // Inspired by OraclizeAPI's implementation - MIT licence
1316         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1317 
1318         if (value == 0) {
1319             return "0";
1320         }
1321         uint256 temp = value;
1322         uint256 digits;
1323         while (temp != 0) {
1324             digits++;
1325             temp /= 10;
1326         }
1327         bytes memory buffer = new bytes(digits);
1328         uint256 index = digits - 1;
1329         temp = value;
1330         while (temp != 0) {
1331             buffer[index--] = bytes1(uint8(48 + temp % 10));
1332             temp /= 10;
1333         }
1334         return string(buffer);
1335     }
1336 }
1337 
1338 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1339 
1340 /**
1341  * @title ERC721 Non-Fungible Token Standard basic implementation
1342  * @dev see https://eips.ethereum.org/EIPS/eip-721
1343  */
1344 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1345     using SafeMath for uint256;
1346     using Address for address;
1347     using EnumerableSet for EnumerableSet.UintSet;
1348     using EnumerableMap for EnumerableMap.UintToAddressMap;
1349     using Strings for uint256;
1350 
1351     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1352     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1353     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1354 
1355     // Mapping from holder address to their (enumerable) set of owned tokens
1356     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1357 
1358     // Enumerable mapping from token ids to their owners
1359     EnumerableMap.UintToAddressMap private _tokenOwners;
1360 
1361     // Mapping from token ID to approved address
1362     mapping (uint256 => address) private _tokenApprovals;
1363 
1364     // Mapping from owner to operator approvals
1365     mapping (address => mapping (address => bool)) private _operatorApprovals;
1366     
1367     // Token name
1368     string private _name;
1369 
1370     // Token symbol
1371     string private _symbol;
1372 
1373     // Optional mapping for token URIs
1374     mapping (uint256 => string) private _tokenURIs;
1375 
1376     // Base URI
1377     string private _baseURI;
1378 
1379     /*
1380      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1381      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1382      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1383      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1384      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1385      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1386      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1387      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1388      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1389      *
1390      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1391      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1392      */
1393     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1394 
1395     /*
1396      *     bytes4(keccak256('name()')) == 0x06fdde03
1397      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1398      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1399      *
1400      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1401      */
1402     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1403 
1404     /*
1405      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1406      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1407      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1408      *
1409      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1410      */
1411     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1412 
1413     /**
1414      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1415      */
1416     constructor (string memory name_, string memory symbol_) public {
1417         _name = name_;
1418         _symbol = symbol_;
1419 
1420         // register the supported interfaces to conform to ERC721 via ERC165
1421         _registerInterface(_INTERFACE_ID_ERC721);
1422         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1423         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1424     }
1425 
1426     /**
1427      * @dev See {IERC721-balanceOf}.
1428      */
1429     function balanceOf(address owner) public view virtual override returns (uint256) {
1430         require(owner != address(0), "ERC721: balance query for the zero address");
1431         return _holderTokens[owner].length();
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-ownerOf}.
1436      */
1437     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1438         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Metadata-name}.
1443      */
1444     function name() public view virtual override returns (string memory) {
1445         return _name;
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Metadata-symbol}.
1450      */
1451     function symbol() public view virtual override returns (string memory) {
1452         return _symbol;
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Metadata-tokenURI}.
1457      */
1458     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1459         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1460 
1461         string memory _tokenURI = _tokenURIs[tokenId];
1462         string memory base = baseURI();
1463 
1464         // If there is no base URI, return the token URI.
1465         if (bytes(base).length == 0) {
1466             return _tokenURI;
1467         }
1468         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1469         if (bytes(_tokenURI).length > 0) {
1470             return string(abi.encodePacked(base, _tokenURI));
1471         }
1472         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1473         return string(abi.encodePacked(base, tokenId.toString()));
1474     }
1475 
1476     /**
1477     * @dev Returns the base URI set via {_setBaseURI}. This will be
1478     * automatically added as a prefix in {tokenURI} to each token's URI, or
1479     * to the token ID if no specific URI is set for that token ID.
1480     */
1481     function baseURI() public view virtual returns (string memory) {
1482         return _baseURI;
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1487      */
1488     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1489         return _holderTokens[owner].at(index);
1490     }
1491 
1492     /**
1493      * @dev See {IERC721Enumerable-totalSupply}.
1494      */
1495     function totalSupply() public view virtual override returns (uint256) {
1496         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1497         return _tokenOwners.length();
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-tokenByIndex}.
1502      */
1503     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1504         (uint256 tokenId, ) = _tokenOwners.at(index);
1505         return tokenId;
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-approve}.
1510      */
1511     function approve(address to, uint256 tokenId) public virtual override {
1512         address owner = ERC721.ownerOf(tokenId);
1513         require(to != owner, "ERC721: approval to current owner");
1514 
1515         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1516             "ERC721: approve caller is not owner nor approved for all"
1517         );
1518 
1519         _approve(to, tokenId);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-getApproved}.
1524      */
1525     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1526         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1527 
1528         return _tokenApprovals[tokenId];
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-setApprovalForAll}.
1533      */
1534     function setApprovalForAll(address operator, bool approved) public virtual override {
1535         require(operator != _msgSender(), "ERC721: approve to caller");
1536 
1537         _operatorApprovals[_msgSender()][operator] = approved;
1538         emit ApprovalForAll(_msgSender(), operator, approved);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-isApprovedForAll}.
1543      */
1544     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1545         return _operatorApprovals[owner][operator];
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-transferFrom}.
1550      */
1551    function transferFrom(address from, address to, uint256 tokenId)  public virtual override {
1552         //solhint-disable-next-line max-line-length
1553         //require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1554        // _transfer(from, to, tokenId);
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-safeTransferFrom}.
1559      */
1560     function safeTransferFrom(address from, address to, uint256 tokenId)  public virtual override {
1561         //safeTransferFrom(from, to, tokenId, "");
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-safeTransferFrom}.
1566      */
1567     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data)   public virtual override {
1568          // require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1569         //_safeTransfer(from, to, tokenId, _data);
1570     }
1571 
1572     /**
1573      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1574      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1575      *
1576      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1577      *
1578      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1579      * implement alternative mechanisms to perform token transfer, such as signature-based.
1580      *
1581      * Requirements:
1582      *
1583      * - `from` cannot be the zero address.
1584      * - `to` cannot be the zero address.
1585      * - `tokenId` token must exist and be owned by `from`.
1586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1587      *
1588      * Emits a {Transfer} event.
1589      */
1590     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1591         _transfer(from, to, tokenId);
1592         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1593     }
1594 
1595     /**
1596      * @dev Returns whether `tokenId` exists.
1597      *
1598      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1599      *
1600      * Tokens start existing when they are minted (`_mint`),
1601      * and stop existing when they are burned (`_burn`).
1602      */
1603     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1604         return _tokenOwners.contains(tokenId);
1605     }
1606 
1607     /**
1608      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1609      *
1610      * Requirements:
1611      *
1612      * - `tokenId` must exist.
1613      */
1614     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1615         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1616         address owner = ERC721.ownerOf(tokenId);
1617         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1618     }
1619 
1620     /**
1621      * @dev Safely mints `tokenId` and transfers it to `to`.
1622      *
1623      * Requirements:
1624      d*
1625      * - `tokenId` must not exist.
1626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _safeMint(address to, uint256 tokenId) internal virtual {
1631         _safeMint(to, tokenId, "");
1632     }
1633 
1634     /**
1635      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1636      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1637      */
1638     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1639         _mint(to, tokenId);
1640         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1641     }
1642 
1643     /**
1644      * @dev Mints `tokenId` and transfers it to `to`.
1645      *
1646      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1647      *
1648      * Requirements:
1649      *
1650      * - `tokenId` must not exist.
1651      * - `to` cannot be the zero address.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _mint(address to, uint256 tokenId) internal virtual {
1656         require(to != address(0), "ERC721: mint to the zero address");
1657         require(!_exists(tokenId), "ERC721: token already minted");
1658 
1659         _beforeTokenTransfer(address(0), to, tokenId);
1660 
1661         _holderTokens[to].add(tokenId);
1662 
1663         _tokenOwners.set(tokenId, to);
1664 
1665         emit Transfer(address(0), to, tokenId);
1666     }
1667 
1668     /**
1669      * @dev Destroys `tokenId`.
1670      * The approval is cleared when the token is burned.
1671      *
1672      * Requirements:
1673      *
1674      * - `tokenId` must exist.
1675      *
1676      * Emits a {Transfer} event.
1677      */
1678     function _burn(uint256 tokenId) internal virtual {
1679         address owner = ERC721.ownerOf(tokenId); // internal owner
1680 
1681         _beforeTokenTransfer(owner, address(0), tokenId);
1682 
1683         // Clear approvals
1684         _approve(address(0), tokenId);
1685 
1686         // Clear metadata (if any)
1687         if (bytes(_tokenURIs[tokenId]).length != 0) {
1688             delete _tokenURIs[tokenId];
1689         }
1690 
1691         _holderTokens[owner].remove(tokenId);
1692 
1693         _tokenOwners.remove(tokenId);
1694 
1695         emit Transfer(owner, address(0), tokenId);
1696     }
1697 
1698     /**
1699      * @dev Transfers `tokenId` from `from` to `to`.
1700      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1701      *
1702      * Requirements:
1703      *
1704      * - `to` cannot be the zero address.
1705      * - `tokenId` token must be owned by `from`.
1706      *
1707      * Emits a {Transfer} event.
1708      */
1709     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1710         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1711         require(to != address(0), "ERC721: transfer to the zero address");
1712 
1713         _beforeTokenTransfer(from, to, tokenId);
1714 
1715         // Clear approvals from the previous owner
1716         _approve(address(0), tokenId);
1717 
1718         _holderTokens[from].remove(tokenId);
1719         _holderTokens[to].add(tokenId);
1720 
1721         _tokenOwners.set(tokenId, to);
1722 
1723         emit Transfer(from, to, tokenId);
1724     }
1725 
1726     /**
1727      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1728      *
1729      * Requirements:
1730      *
1731      * - `tokenId` must exist.
1732      */
1733     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1734         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1735         _tokenURIs[tokenId] = _tokenURI;
1736     }
1737 
1738     /**
1739      * @dev Internal function to set the base URI for all token IDs. It is
1740      * automatically added as a prefix to the value returned in {tokenURI},
1741      * or to the token ID if {tokenURI} is empty.
1742      */
1743     function _setBaseURI(string memory baseURI_) internal virtual {
1744         _baseURI = baseURI_;
1745     }
1746 
1747     /**
1748      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1749      * The call is not executed if the target address is not a contract.
1750      *
1751      * @param from address representing the previous owner of the given token ID
1752      * @param to target address that will receive the tokens
1753      * @param tokenId uint256 ID of the token to be transferred
1754      * @param _data bytes optional data to send along with the call
1755      * @return bool whether the call correctly returned the expected magic value
1756      */
1757     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1758         private returns (bool)
1759     {
1760         if (!to.isContract()) {
1761             return true;
1762         }
1763         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1764             IERC721Receiver(to).onERC721Received.selector,
1765             _msgSender(),
1766             from,
1767             tokenId,
1768             _data
1769         ), "ERC721: transfer to non ERC721Receiver implementer");
1770         bytes4 retval = abi.decode(returndata, (bytes4));
1771         return (retval == _ERC721_RECEIVED);
1772     }
1773 
1774     /**
1775      * @dev Approve `to` to operate on `tokenId`
1776      *
1777      * Emits an {Approval} event.
1778      */
1779     function _approve(address to, uint256 tokenId) internal virtual {
1780         _tokenApprovals[tokenId] = to;
1781         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1782     }
1783 
1784     /**
1785      * @dev Hook that is called before any token transfer. This includes minting
1786      * and burning.
1787      *
1788      * Calling conditions:
1789      *
1790      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1791      * transferred to `to`.
1792      * - When `from` is zero, `tokenId` will be minted for `to`.
1793      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1794      * - `from` cannot be the zero address.
1795      * - `to` cannot be the zero address.
1796      *
1797      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1798      */
1799     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1800 }
1801 
1802 // File: @openzeppelin/contracts/access/Ownable.sol
1803 
1804 
1805 /**
1806  * @dev Contract module which provides a basic access control mechanism, where
1807  * there is an account (an owner) that can be granted exclusive access to
1808  * specific functions.
1809  *
1810  * By default, the owner account will be the one that deploys the contract. This
1811  * can later be changed with {transferOwnership}.
1812  *
1813  * This module is used through inheritance. It will make available the modifier
1814  * `onlyOwner`, which can be applied to your functions to restrict their use to
1815  * the owner.
1816  */
1817 abstract contract Ownable is Context {
1818     address private _owner;
1819 
1820     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1821 
1822     /**
1823      * @dev Initializes the contract setting the deployer as the initial owner.
1824      */
1825     constructor () internal {
1826         address msgSender = _msgSender();
1827         _owner = msgSender;
1828         emit OwnershipTransferred(address(0), msgSender);
1829     }
1830 
1831     /**
1832      * @dev Returns the address of the current owner.
1833      */
1834     function owner() public view virtual returns (address) {
1835         return _owner;
1836     }
1837 
1838     /**
1839      * @dev Throws if called by any account other than the owner.
1840      */
1841     modifier onlyOwner() {
1842         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1843         _;
1844     }
1845 
1846     /**
1847      * @dev Leaves the contract without owner. It will not be possible to call
1848      * `onlyOwner` functions anymore. Can only be called by the current owner.
1849      *
1850      * NOTE: Renouncing ownership will leave the contract without an owner,
1851      * thereby removing any functionality that is only available to the owner.
1852      */
1853     function renounceOwnership() public virtual onlyOwner {
1854         emit OwnershipTransferred(_owner, address(0));
1855         _owner = address(0);
1856     }
1857 
1858     /**
1859      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1860      * Can only be called by the current owner.
1861      */
1862     function transferOwnership(address newOwner) public virtual onlyOwner {
1863         require(newOwner != address(0), "Ownable: new owner is the zero address");
1864         emit OwnershipTransferred(_owner, newOwner);
1865         _owner = newOwner;
1866     }
1867 }
1868  
1869 
1870 contract Metart is ERC721,Ownable{
1871 
1872     using EnumerableSet for EnumerableSet.AddressSet;
1873     using EnumerableMap for EnumerableMap.AddressToUintMap;
1874  
1875     using SafeMath for uint256;
1876     string public verifyHash = "";
1877  
1878     uint256 public constant Max_Number = 8248;
1879   
1880 
1881     bool public saleIsActive = false;
1882  
1883     bool public secondSale = false;
1884  
1885     uint256 public indexReserveSale = 0;
1886  
1887     uint256 public   startOvertSale = 889;
1888  
1889     uint256 public mint_Number_Curr = 1624;
1890     //init 0.08 ETH
1891     uint256 public nftPrice = 80000000000000000;  
1892  
1893     mapping (uint256 => address) private _tokenPledge;
1894 
1895  
1896     // White List
1897     EnumerableMap.AddressToUintMap private whiteList;
1898     // black List
1899     EnumerableSet.AddressSet private blackList;
1900 
1901     event  SetWhiteList(address _address);
1902 
1903     event  SetBlackList(address _address);
1904 
1905     event  RemoveWhiteList(address _address);
1906 
1907     event  RemoveBlackList(address _address);
1908 
1909     event  MintMetart(address _address,uint256 _token,uint8 _style,uint256 _price);
1910 
1911     event  SetActiveSalePlan(uint index);
1912     event  Pledge(uint256 tokenid,address to);
1913 
1914     event SetMintCurrMax(uint256 _mintCurrMax ,uint256 _price);
1915     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1916     
1917     }
1918     function _pledge(address to, uint256 tokenId) internal  {
1919         _tokenPledge[tokenId] = to;
1920         emit Pledge(tokenId,to);
1921     }
1922 
1923     function pledge(address to, uint256 tokenId) public   {
1924         address owner = ERC721.ownerOf(tokenId);
1925         require(to != owner, "pledge to current owner");
1926         require(_msgSender() == owner   ,"pledge caller is not owner" );
1927         _pledge(to, tokenId);
1928     }
1929 
1930     function removePledge(uint256 tokenId) public   {
1931         address pledgeadress = _tokenPledge[tokenId]; 
1932         require(_msgSender() == pledgeadress ||_msgSender()== Ownable.owner(),"pledge caller is not owner" );
1933         _pledge(address(0), tokenId);
1934     }
1935 
1936     function pledegeOf(uint256 _tokenid) public  view returns(address){ 
1937         return _tokenPledge[_tokenid];
1938     }
1939     function setMintCurrMax(uint256 mintCurrMax,uint256 price) public onlyOwner{
1940         require(mintCurrMax >= totalSupply().sub(indexReserveSale).add(startOvertSale) && mintCurrMax <=Max_Number ,"mintCurrMax failed");
1941         mint_Number_Curr = mintCurrMax;
1942         nftPrice = price;
1943         emit SetMintCurrMax(mintCurrMax,price);
1944     }
1945 
1946     
1947     function setWhiteList(address _address)  public onlyOwner{
1948         require(_address != address(0), "zero address");
1949         require(!whiteList.contains(_address),"The whitelist already exists");
1950         whiteList.set(_address,0);
1951         emit  SetWhiteList(_address);
1952     }
1953 
1954     function removeWhileList(address _address) public onlyOwner{
1955         require(_address != address(0), "zero address");
1956         require(whiteList.get(_address) == 0,"address mint NFT cannot be removed");
1957         whiteList.remove(_address);
1958         emit  RemoveWhiteList(_address);
1959     }
1960 
1961     function existsWhileList(address _address) public view returns(bool,uint256){ 
1962         require(_address != address(0), "zero address");
1963         return whiteList.tryGet(_address); 
1964     }
1965 
1966      function setBlackList(address _address)  public onlyOwner{
1967         require(_address != address(0), "zero address");
1968         require(!blackList.contains(_address),"The blacklist already exists");
1969         blackList.add(_address);
1970         emit  SetBlackList(_address);
1971     }
1972 
1973     function removeBlackList(address _address) public onlyOwner{
1974         require(_address != address(0), "zero address");
1975         blackList.remove(_address);
1976         emit  RemoveBlackList(_address);
1977     }
1978 
1979     function existsBlackList(address _address) public view returns(bool){ 
1980         require(_address != address(0), "zero address");
1981         return blackList.contains(_address);
1982     }
1983     
1984     function setVerifyHash(string memory _hash) public onlyOwner {
1985         require(bytes(_hash).length != 0,"can only be set one");
1986         verifyHash = _hash;
1987     }
1988 
1989     
1990     function withdraw() public onlyOwner {
1991         uint balance = address(this).balance;
1992         msg.sender.transfer(balance);
1993     }
1994  
1995     /*
1996     * Pause sale if active, make active if paused
1997     */
1998     function flipSaleState() public onlyOwner {
1999         saleIsActive = !saleIsActive;
2000     }
2001 
2002     function flipSecondSale() public onlyOwner { 
2003         secondSale = !secondSale;
2004     }
2005 
2006     function setBaseURI(string memory baseURI) public onlyOwner {
2007         _setBaseURI(baseURI);
2008     }
2009     
2010     /**
2011      * @dev See {IERC721-transferFrom}.
2012      */
2013     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2014       
2015         _checkTransfer(from, tokenId);
2016         _transfer(from, to, tokenId);
2017          
2018     }
2019 
2020     /**
2021      * @dev See {IERC721-safeTransferFrom}.
2022      */
2023     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2024         safeTransferFrom(from, to, tokenId, "");
2025     }
2026 
2027     function _checkTransfer(address from,   uint256 tokenId) internal view {
2028         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2029         require(secondSale,"Not transferable for the time being");
2030         require(!blackList.contains(from),"The address is in the blacklist");
2031         require(pledegeOf(tokenId) == address(0),"the NFT is currently pledged");
2032     }
2033 
2034     /**
2035      * @dev See {IERC721-safeTransferFrom}.
2036      */
2037     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2038     
2039         _checkTransfer(from, tokenId);
2040         _safeTransfer(from, to, tokenId, _data);
2041         
2042     } 
2043     function  mintPreSales(address[] memory _addresss) public onlyOwner{
2044         require(saleIsActive, "Sale must be active to mint Metart");
2045         require(totalSupply().sub(indexReserveSale).add(startOvertSale).add(_addresss.length) <=mint_Number_Curr  , "Purchase would exceed max supply of Tokens");
2046         for(uint256 i = 0; i < _addresss.length; i++) {
2047             uint256 mintIndex = totalSupply().sub(indexReserveSale).add(startOvertSale); 
2048             if (mintIndex <= mint_Number_Curr) {
2049                 _safeMint(_addresss[i], mintIndex); 
2050                 emit  MintMetart(msg.sender,mintIndex,3,0);
2051             }
2052         } 
2053   
2054     }
2055     
2056     function mintPreSalesBatch(address _addresss, uint8  _number) public onlyOwner   {
2057         require(saleIsActive, "Sale must be active to mint Metart");
2058         require(totalSupply().sub(indexReserveSale).add(startOvertSale).add(_number) <=mint_Number_Curr  , "Purchase would exceed max supply of Tokens");
2059         for (uint256 j=0;j<_number;j++){
2060             uint256 mintIndex = totalSupply().sub(indexReserveSale).add(startOvertSale); 
2061                 if (mintIndex <= mint_Number_Curr) {
2062                     _safeMint(_addresss, mintIndex); 
2063                     emit  MintMetart(msg.sender,mintIndex,3,0);
2064                 }
2065         }  
2066     }
2067    
2068     /**
2069     * Mint NFT Coin
2070     */
2071     function mintMetart(uint numberOfTokens) public payable {
2072         require(saleIsActive, "Sale must be active to mint Metart");
2073         require(numberOfTokens <= 20, "Can only mint 20 tokens at a time");
2074         uint mintToken = totalSupply().sub(indexReserveSale).add(startOvertSale);
2075         require(mintToken.add(numberOfTokens) <= mint_Number_Curr, "Purchase would exceed max supply of tokens");
2076         require(nftPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2077         for(uint i = 0; i < numberOfTokens; i++) {  
2078             uint mintIndex = totalSupply().sub(indexReserveSale).add(startOvertSale); 
2079             if (mintIndex <= mint_Number_Curr) {
2080                 _safeMint(msg.sender, mintIndex);
2081                 emit MintMetart(msg.sender,mintIndex,1,nftPrice);
2082             }
2083         }
2084     
2085     }
2086  
2087     function mintMetartReserve() public   {
2088         require(saleIsActive, "Sale must be active to mint Metart");
2089         require(indexReserveSale < startOvertSale-1,"The remaining NFT has been cast");
2090         (bool isexist,uint256 number) =  whiteList.tryGet(msg.sender);
2091         require(isexist && number < 1,"Addresses are not whitelisted or addresses have been cast in NFT");
2092 
2093         _safeMint(msg.sender, indexReserveSale+1);
2094         emit MintMetart(msg.sender,indexReserveSale+1,2,0);
2095         indexReserveSale = indexReserveSale + 1;
2096         whiteList.set(msg.sender,number+1);
2097     }
2098 }