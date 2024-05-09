1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // File: @openzeppelin/contracts/utils/Context.sol
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
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
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
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
51 
52 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
53 
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65      */
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(address from, address to, uint256 tokenId) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(address from, address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId) external view returns (address operator);
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
161 
162     /**
163       * @dev Safely transfers `tokenId` token from `from` to `to`.
164       *
165       * Requirements:
166       *
167       * - `from` cannot be the zero address.
168       * - `to` cannot be the zero address.
169       * - `tokenId` token must exist and be owned by `from`.
170       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172       *
173       * Emits a {Transfer} event.
174       */
175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
176 }
177 
178 
179 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Metadata is IERC721 {
186     /**
187      * @dev Returns the token collection name.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the token collection symbol.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
198      */
199     function tokenURI(uint256 tokenId) external view returns (string memory);
200 }
201 
202 
203 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Enumerable is IERC721 {
210     /**
211      * @dev Returns the total amount of tokens stored by the contract.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
217      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
218      */
219     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
220 
221     /**
222      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
223      * Use along with {totalSupply} to enumerate all tokens.
224      */
225     function tokenByIndex(uint256 index) external view returns (uint256);
226 }
227 
228 
229 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
230 
231 /**
232  * @title ERC721 token receiver interface
233  * @dev Interface for any contract that wants to support safeTransfers
234  * from ERC721 asset contracts.
235  */
236 interface IERC721Receiver {
237     /**
238      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
239      * by `operator` from `from`, this function is called.
240      *
241      * It must return its Solidity selector to confirm the token transfer.
242      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
243      *
244      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
245      */
246     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
247 }
248 
249 
250 // File: @openzeppelin/contracts/introspection/ERC165.sol
251 
252 /**
253  * @dev Implementation of the {IERC165} interface.
254  *
255  * Contracts may inherit from this and call {_registerInterface} to declare
256  * their support of an interface.
257  */
258 abstract contract ERC165 is IERC165 {
259     /*
260      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
261      */
262     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
263 
264     /**
265      * @dev Mapping of interface ids to whether or not it's supported.
266      */
267     mapping(bytes4 => bool) private _supportedInterfaces;
268 
269     constructor () {
270         // Derived contracts need only register support for their own interfaces,
271         // we register support for ERC165 itself here
272         _registerInterface(_INTERFACE_ID_ERC165);
273     }
274 
275     /**
276      * @dev See {IERC165-supportsInterface}.
277      *
278      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
279      */
280     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
281         return _supportedInterfaces[interfaceId];
282     }
283 
284     /**
285      * @dev Registers the contract as an implementer of the interface defined by
286      * `interfaceId`. Support of the actual ERC165 interface is automatic and
287      * registering its interface id is not required.
288      *
289      * See {IERC165-supportsInterface}.
290      *
291      * Requirements:
292      *
293      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
294      */
295     function _registerInterface(bytes4 interfaceId) internal virtual {
296         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
297         _supportedInterfaces[interfaceId] = true;
298     }
299 }
300 
301 
302 // File: @openzeppelin/contracts/math/SafeMath.sol
303 
304 /**
305  * @dev Wrappers over Solidity's arithmetic operations with added overflow
306  * checks.
307  *
308  * Arithmetic operations in Solidity wrap on overflow. This can easily result
309  * in bugs, because programmers usually assume that an overflow raises an
310  * error, which is the standard behavior in high level programming languages.
311  * `SafeMath` restores this intuition by reverting the transaction when an
312  * operation overflows.
313  *
314  * Using this library instead of the unchecked operations eliminates an entire
315  * class of bugs, so it's recommended to use it always.
316  */
317 library SafeMath {
318     /**
319      * @dev Returns the addition of two unsigned integers, with an overflow flag.
320      *
321      * _Available since v3.4._
322      */
323     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
324         uint256 c = a + b;
325         if (c < a) return (false, 0);
326         return (true, c);
327     }
328 
329     /**
330      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
331      *
332      * _Available since v3.4._
333      */
334     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
335         if (b > a) return (false, 0);
336         return (true, a - b);
337     }
338 
339     /**
340      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
341      *
342      * _Available since v3.4._
343      */
344     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) return (true, 0);
349         uint256 c = a * b;
350         if (c / a != b) return (false, 0);
351         return (true, c);
352     }
353 
354     /**
355      * @dev Returns the division of two unsigned integers, with a division by zero flag.
356      *
357      * _Available since v3.4._
358      */
359     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         if (b == 0) return (false, 0);
361         return (true, a / b);
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
366      *
367      * _Available since v3.4._
368      */
369     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         if (b == 0) return (false, 0);
371         return (true, a % b);
372     }
373 
374     /**
375      * @dev Returns the addition of two unsigned integers, reverting on
376      * overflow.
377      *
378      * Counterpart to Solidity's `+` operator.
379      *
380      * Requirements:
381      *
382      * - Addition cannot overflow.
383      */
384     function add(uint256 a, uint256 b) internal pure returns (uint256) {
385         uint256 c = a + b;
386         require(c >= a, "SafeMath: addition overflow");
387         return c;
388     }
389 
390     /**
391      * @dev Returns the subtraction of two unsigned integers, reverting on
392      * overflow (when the result is negative).
393      *
394      * Counterpart to Solidity's `-` operator.
395      *
396      * Requirements:
397      *
398      * - Subtraction cannot overflow.
399      */
400     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
401         require(b <= a, "SafeMath: subtraction overflow");
402         return a - b;
403     }
404 
405     /**
406      * @dev Returns the multiplication of two unsigned integers, reverting on
407      * overflow.
408      *
409      * Counterpart to Solidity's `*` operator.
410      *
411      * Requirements:
412      *
413      * - Multiplication cannot overflow.
414      */
415     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
416         if (a == 0) return 0;
417         uint256 c = a * b;
418         require(c / a == b, "SafeMath: multiplication overflow");
419         return c;
420     }
421 
422     /**
423      * @dev Returns the integer division of two unsigned integers, reverting on
424      * division by zero. The result is rounded towards zero.
425      *
426      * Counterpart to Solidity's `/` operator. Note: this function uses a
427      * `revert` opcode (which leaves remaining gas untouched) while Solidity
428      * uses an invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function div(uint256 a, uint256 b) internal pure returns (uint256) {
435         require(b > 0, "SafeMath: division by zero");
436         return a / b;
437     }
438 
439     /**
440      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
441      * reverting when dividing by zero.
442      *
443      * Counterpart to Solidity's `%` operator. This function uses a `revert`
444      * opcode (which leaves remaining gas untouched) while Solidity uses an
445      * invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
452         require(b > 0, "SafeMath: modulo by zero");
453         return a % b;
454     }
455 
456     /**
457      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
458      * overflow (when the result is negative).
459      *
460      * CAUTION: This function is deprecated because it requires allocating memory for the error
461      * message unnecessarily. For custom revert reasons use {trySub}.
462      *
463      * Counterpart to Solidity's `-` operator.
464      *
465      * Requirements:
466      *
467      * - Subtraction cannot overflow.
468      */
469     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
470         require(b <= a, errorMessage);
471         return a - b;
472     }
473 
474     /**
475      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
476      * division by zero. The result is rounded towards zero.
477      *
478      * CAUTION: This function is deprecated because it requires allocating memory for the error
479      * message unnecessarily. For custom revert reasons use {tryDiv}.
480      *
481      * Counterpart to Solidity's `/` operator. Note: this function uses a
482      * `revert` opcode (which leaves remaining gas untouched) while Solidity
483      * uses an invalid opcode to revert (consuming all remaining gas).
484      *
485      * Requirements:
486      *
487      * - The divisor cannot be zero.
488      */
489     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
490         require(b > 0, errorMessage);
491         return a / b;
492     }
493 
494     /**
495      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
496      * reverting with custom message when dividing by zero.
497      *
498      * CAUTION: This function is deprecated because it requires allocating memory for the error
499      * message unnecessarily. For custom revert reasons use {tryMod}.
500      *
501      * Counterpart to Solidity's `%` operator. This function uses a `revert`
502      * opcode (which leaves remaining gas untouched) while Solidity uses an
503      * invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b > 0, errorMessage);
511         return a % b;
512     }
513 }
514 
515 
516 // File: @openzeppelin/contracts/utils/Address.sol
517 
518 /**
519  * @dev Collection of functions related to the address type
520  */
521 library Address {
522     /**
523      * @dev Returns true if `account` is a contract.
524      *
525      * [IMPORTANT]
526      * ====
527      * It is unsafe to assume that an address for which this function returns
528      * false is an externally-owned account (EOA) and not a contract.
529      *
530      * Among others, `isContract` will return false for the following
531      * types of addresses:
532      *
533      *  - an externally-owned account
534      *  - a contract in construction
535      *  - an address where a contract will be created
536      *  - an address where a contract lived, but was destroyed
537      * ====
538      */
539     function isContract(address account) internal view returns (bool) {
540         // This method relies on extcodesize, which returns 0 for contracts in
541         // construction, since the code is only stored at the end of the
542         // constructor execution.
543 
544         uint256 size;
545         // solhint-disable-next-line no-inline-assembly
546         assembly { size := extcodesize(account) }
547         return size > 0;
548     }
549 
550     /**
551      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
552      * `recipient`, forwarding all available gas and reverting on errors.
553      *
554      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
555      * of certain opcodes, possibly making contracts go over the 2300 gas limit
556      * imposed by `transfer`, making them unable to receive funds via
557      * `transfer`. {sendValue} removes this limitation.
558      *
559      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
560      *
561      * IMPORTANT: because control is transferred to `recipient`, care must be
562      * taken to not create reentrancy vulnerabilities. Consider using
563      * {ReentrancyGuard} or the
564      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
565      */
566     function sendValue(address payable recipient, uint256 amount) internal {
567         require(address(this).balance >= amount, "Address: insufficient balance");
568 
569         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
570         (bool success, ) = recipient.call{ value: amount }("");
571         require(success, "Address: unable to send value, recipient may have reverted");
572     }
573 
574     /**
575      * @dev Performs a Solidity function call using a low level `call`. A
576      * plain`call` is an unsafe replacement for a function call: use this
577      * function instead.
578      *
579      * If `target` reverts with a revert reason, it is bubbled up by this
580      * function (like regular Solidity function calls).
581      *
582      * Returns the raw returned data. To convert to the expected return value,
583      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
584      *
585      * Requirements:
586      *
587      * - `target` must be a contract.
588      * - calling `target` with `data` must not revert.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
593       return functionCall(target, data, "Address: low-level call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
598      * `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, 0, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but also transferring `value` wei to `target`.
609      *
610      * Requirements:
611      *
612      * - the calling contract must have an ETH balance of at least `value`.
613      * - the called Solidity function must be `payable`.
614      *
615      * _Available since v3.1._
616      */
617     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
618         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
623      * with `errorMessage` as a fallback revert reason when `target` reverts.
624      *
625      * _Available since v3.1._
626      */
627     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
628         require(address(this).balance >= value, "Address: insufficient balance for call");
629         require(isContract(target), "Address: call to non-contract");
630 
631         // solhint-disable-next-line avoid-low-level-calls
632         (bool success, bytes memory returndata) = target.call{ value: value }(data);
633         return _verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
643         return functionStaticCall(target, data, "Address: low-level static call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
648      * but performing a static call.
649      *
650      * _Available since v3.3._
651      */
652     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
653         require(isContract(target), "Address: static call to non-contract");
654 
655         // solhint-disable-next-line avoid-low-level-calls
656         (bool success, bytes memory returndata) = target.staticcall(data);
657         return _verifyCallResult(success, returndata, errorMessage);
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
662      * but performing a delegate call.
663      *
664      * _Available since v3.4._
665      */
666     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
667         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
672      * but performing a delegate call.
673      *
674      * _Available since v3.4._
675      */
676     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
677         require(isContract(target), "Address: delegate call to non-contract");
678 
679         // solhint-disable-next-line avoid-low-level-calls
680         (bool success, bytes memory returndata) = target.delegatecall(data);
681         return _verifyCallResult(success, returndata, errorMessage);
682     }
683 
684     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 // solhint-disable-next-line no-inline-assembly
693                 assembly {
694                     let returndata_size := mload(returndata)
695                     revert(add(32, returndata), returndata_size)
696                 }
697             } else {
698                 revert(errorMessage);
699             }
700         }
701     }
702 }
703 
704 
705 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
706 
707 /**
708  * @dev Library for managing
709  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
710  * types.
711  *
712  * Sets have the following properties:
713  *
714  * - Elements are added, removed, and checked for existence in constant time
715  * (O(1)).
716  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
717  *
718  * ```
719  * contract Example {
720  *     // Add the library methods
721  *     using EnumerableSet for EnumerableSet.AddressSet;
722  *
723  *     // Declare a set state variable
724  *     EnumerableSet.AddressSet private mySet;
725  * }
726  * ```
727  *
728  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
729  * and `uint256` (`UintSet`) are supported.
730  */
731 library EnumerableSet {
732     // To implement this library for multiple types with as little code
733     // repetition as possible, we write it in terms of a generic Set type with
734     // bytes32 values.
735     // The Set implementation uses private functions, and user-facing
736     // implementations (such as AddressSet) are just wrappers around the
737     // underlying Set.
738     // This means that we can only create new EnumerableSets for types that fit
739     // in bytes32.
740 
741     struct Set {
742         // Storage of set values
743         bytes32[] _values;
744 
745         // Position of the value in the `values` array, plus 1 because index 0
746         // means a value is not in the set.
747         mapping (bytes32 => uint256) _indexes;
748     }
749 
750     /**
751      * @dev Add a value to a set. O(1).
752      *
753      * Returns true if the value was added to the set, that is if it was not
754      * already present.
755      */
756     function _add(Set storage set, bytes32 value) private returns (bool) {
757         if (!_contains(set, value)) {
758             set._values.push(value);
759             // The value is stored at length-1, but we add 1 to all indexes
760             // and use 0 as a sentinel value
761             set._indexes[value] = set._values.length;
762             return true;
763         } else {
764             return false;
765         }
766     }
767 
768     /**
769      * @dev Removes a value from a set. O(1).
770      *
771      * Returns true if the value was removed from the set, that is if it was
772      * present.
773      */
774     function _remove(Set storage set, bytes32 value) private returns (bool) {
775         // We read and store the value's index to prevent multiple reads from the same storage slot
776         uint256 valueIndex = set._indexes[value];
777 
778         if (valueIndex != 0) { // Equivalent to contains(set, value)
779             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
780             // the array, and then remove the last element (sometimes called as 'swap and pop').
781             // This modifies the order of the array, as noted in {at}.
782 
783             uint256 toDeleteIndex = valueIndex - 1;
784             uint256 lastIndex = set._values.length - 1;
785 
786             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
787             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
788 
789             bytes32 lastvalue = set._values[lastIndex];
790 
791             // Move the last value to the index where the value to delete is
792             set._values[toDeleteIndex] = lastvalue;
793             // Update the index for the moved value
794             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
795 
796             // Delete the slot where the moved value was stored
797             set._values.pop();
798 
799             // Delete the index for the deleted slot
800             delete set._indexes[value];
801 
802             return true;
803         } else {
804             return false;
805         }
806     }
807 
808     /**
809      * @dev Returns true if the value is in the set. O(1).
810      */
811     function _contains(Set storage set, bytes32 value) private view returns (bool) {
812         return set._indexes[value] != 0;
813     }
814 
815     /**
816      * @dev Returns the number of values on the set. O(1).
817      */
818     function _length(Set storage set) private view returns (uint256) {
819         return set._values.length;
820     }
821 
822    /**
823     * @dev Returns the value stored at position `index` in the set. O(1).
824     *
825     * Note that there are no guarantees on the ordering of values inside the
826     * array, and it may change when more values are added or removed.
827     *
828     * Requirements:
829     *
830     * - `index` must be strictly less than {length}.
831     */
832     function _at(Set storage set, uint256 index) private view returns (bytes32) {
833         require(set._values.length > index, "EnumerableSet: index out of bounds");
834         return set._values[index];
835     }
836 
837     // Bytes32Set
838 
839     struct Bytes32Set {
840         Set _inner;
841     }
842 
843     /**
844      * @dev Add a value to a set. O(1).
845      *
846      * Returns true if the value was added to the set, that is if it was not
847      * already present.
848      */
849     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
850         return _add(set._inner, value);
851     }
852 
853     /**
854      * @dev Removes a value from a set. O(1).
855      *
856      * Returns true if the value was removed from the set, that is if it was
857      * present.
858      */
859     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
860         return _remove(set._inner, value);
861     }
862 
863     /**
864      * @dev Returns true if the value is in the set. O(1).
865      */
866     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
867         return _contains(set._inner, value);
868     }
869 
870     /**
871      * @dev Returns the number of values in the set. O(1).
872      */
873     function length(Bytes32Set storage set) internal view returns (uint256) {
874         return _length(set._inner);
875     }
876 
877    /**
878     * @dev Returns the value stored at position `index` in the set. O(1).
879     *
880     * Note that there are no guarantees on the ordering of values inside the
881     * array, and it may change when more values are added or removed.
882     *
883     * Requirements:
884     *
885     * - `index` must be strictly less than {length}.
886     */
887     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
888         return _at(set._inner, index);
889     }
890 
891     // AddressSet
892 
893     struct AddressSet {
894         Set _inner;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function add(AddressSet storage set, address value) internal returns (bool) {
904         return _add(set._inner, bytes32(uint256(uint160(value))));
905     }
906 
907     /**
908      * @dev Removes a value from a set. O(1).
909      *
910      * Returns true if the value was removed from the set, that is if it was
911      * present.
912      */
913     function remove(AddressSet storage set, address value) internal returns (bool) {
914         return _remove(set._inner, bytes32(uint256(uint160(value))));
915     }
916 
917     /**
918      * @dev Returns true if the value is in the set. O(1).
919      */
920     function contains(AddressSet storage set, address value) internal view returns (bool) {
921         return _contains(set._inner, bytes32(uint256(uint160(value))));
922     }
923 
924     /**
925      * @dev Returns the number of values in the set. O(1).
926      */
927     function length(AddressSet storage set) internal view returns (uint256) {
928         return _length(set._inner);
929     }
930 
931    /**
932     * @dev Returns the value stored at position `index` in the set. O(1).
933     *
934     * Note that there are no guarantees on the ordering of values inside the
935     * array, and it may change when more values are added or removed.
936     *
937     * Requirements:
938     *
939     * - `index` must be strictly less than {length}.
940     */
941     function at(AddressSet storage set, uint256 index) internal view returns (address) {
942         return address(uint160(uint256(_at(set._inner, index))));
943     }
944 
945     // UintSet
946 
947     struct UintSet {
948         Set _inner;
949     }
950 
951     /**
952      * @dev Add a value to a set. O(1).
953      *
954      * Returns true if the value was added to the set, that is if it was not
955      * already present.
956      */
957     function add(UintSet storage set, uint256 value) internal returns (bool) {
958         return _add(set._inner, bytes32(value));
959     }
960 
961     /**
962      * @dev Removes a value from a set. O(1).
963      *
964      * Returns true if the value was removed from the set, that is if it was
965      * present.
966      */
967     function remove(UintSet storage set, uint256 value) internal returns (bool) {
968         return _remove(set._inner, bytes32(value));
969     }
970 
971     /**
972      * @dev Returns true if the value is in the set. O(1).
973      */
974     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
975         return _contains(set._inner, bytes32(value));
976     }
977 
978     /**
979      * @dev Returns the number of values on the set. O(1).
980      */
981     function length(UintSet storage set) internal view returns (uint256) {
982         return _length(set._inner);
983     }
984 
985    /**
986     * @dev Returns the value stored at position `index` in the set. O(1).
987     *
988     * Note that there are no guarantees on the ordering of values inside the
989     * array, and it may change when more values are added or removed.
990     *
991     * Requirements:
992     *
993     * - `index` must be strictly less than {length}.
994     */
995     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
996         return uint256(_at(set._inner, index));
997     }
998 }
999 
1000 
1001 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1002 
1003 /**
1004  * @dev Library for managing an enumerable variant of Solidity's
1005  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1006  * type.
1007  *
1008  * Maps have the following properties:
1009  *
1010  * - Entries are added, removed, and checked for existence in constant time
1011  * (O(1)).
1012  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1013  *
1014  * ```
1015  * contract Example {
1016  *     // Add the library methods
1017  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1018  *
1019  *     // Declare a set state variable
1020  *     EnumerableMap.UintToAddressMap private myMap;
1021  * }
1022  * ```
1023  *
1024  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1025  * supported.
1026  */
1027 library EnumerableMap {
1028     // To implement this library for multiple types with as little code
1029     // repetition as possible, we write it in terms of a generic Map type with
1030     // bytes32 keys and values.
1031     // The Map implementation uses private functions, and user-facing
1032     // implementations (such as Uint256ToAddressMap) are just wrappers around
1033     // the underlying Map.
1034     // This means that we can only create new EnumerableMaps for types that fit
1035     // in bytes32.
1036 
1037     struct MapEntry {
1038         bytes32 _key;
1039         bytes32 _value;
1040     }
1041 
1042     struct Map {
1043         // Storage of map keys and values
1044         MapEntry[] _entries;
1045 
1046         // Position of the entry defined by a key in the `entries` array, plus 1
1047         // because index 0 means a key is not in the map.
1048         mapping (bytes32 => uint256) _indexes;
1049     }
1050 
1051     /**
1052      * @dev Adds a key-value pair to a map, or updates the value for an existing
1053      * key. O(1).
1054      *
1055      * Returns true if the key was added to the map, that is if it was not
1056      * already present.
1057      */
1058     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1059         // We read and store the key's index to prevent multiple reads from the same storage slot
1060         uint256 keyIndex = map._indexes[key];
1061 
1062         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1063             map._entries.push(MapEntry({ _key: key, _value: value }));
1064             // The entry is stored at length-1, but we add 1 to all indexes
1065             // and use 0 as a sentinel value
1066             map._indexes[key] = map._entries.length;
1067             return true;
1068         } else {
1069             map._entries[keyIndex - 1]._value = value;
1070             return false;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Removes a key-value pair from a map. O(1).
1076      *
1077      * Returns true if the key was removed from the map, that is if it was present.
1078      */
1079     function _remove(Map storage map, bytes32 key) private returns (bool) {
1080         // We read and store the key's index to prevent multiple reads from the same storage slot
1081         uint256 keyIndex = map._indexes[key];
1082 
1083         if (keyIndex != 0) { // Equivalent to contains(map, key)
1084             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1085             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1086             // This modifies the order of the array, as noted in {at}.
1087 
1088             uint256 toDeleteIndex = keyIndex - 1;
1089             uint256 lastIndex = map._entries.length - 1;
1090 
1091             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1092             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1093 
1094             MapEntry storage lastEntry = map._entries[lastIndex];
1095 
1096             // Move the last entry to the index where the entry to delete is
1097             map._entries[toDeleteIndex] = lastEntry;
1098             // Update the index for the moved entry
1099             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1100 
1101             // Delete the slot where the moved entry was stored
1102             map._entries.pop();
1103 
1104             // Delete the index for the deleted slot
1105             delete map._indexes[key];
1106 
1107             return true;
1108         } else {
1109             return false;
1110         }
1111     }
1112 
1113     /**
1114      * @dev Returns true if the key is in the map. O(1).
1115      */
1116     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1117         return map._indexes[key] != 0;
1118     }
1119 
1120     /**
1121      * @dev Returns the number of key-value pairs in the map. O(1).
1122      */
1123     function _length(Map storage map) private view returns (uint256) {
1124         return map._entries.length;
1125     }
1126 
1127    /**
1128     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1129     *
1130     * Note that there are no guarantees on the ordering of entries inside the
1131     * array, and it may change when more entries are added or removed.
1132     *
1133     * Requirements:
1134     *
1135     * - `index` must be strictly less than {length}.
1136     */
1137     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1138         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1139 
1140         MapEntry storage entry = map._entries[index];
1141         return (entry._key, entry._value);
1142     }
1143 
1144     /**
1145      * @dev Tries to returns the value associated with `key`.  O(1).
1146      * Does not revert if `key` is not in the map.
1147      */
1148     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1149         uint256 keyIndex = map._indexes[key];
1150         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1151         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1152     }
1153 
1154     /**
1155      * @dev Returns the value associated with `key`.  O(1).
1156      *
1157      * Requirements:
1158      *
1159      * - `key` must be in the map.
1160      */
1161     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1162         uint256 keyIndex = map._indexes[key];
1163         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1164         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1165     }
1166 
1167     /**
1168      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1169      *
1170      * CAUTION: This function is deprecated because it requires allocating memory for the error
1171      * message unnecessarily. For custom revert reasons use {_tryGet}.
1172      */
1173     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1174         uint256 keyIndex = map._indexes[key];
1175         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1176         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1177     }
1178 
1179     // UintToAddressMap
1180 
1181     struct UintToAddressMap {
1182         Map _inner;
1183     }
1184 
1185     /**
1186      * @dev Adds a key-value pair to a map, or updates the value for an existing
1187      * key. O(1).
1188      *
1189      * Returns true if the key was added to the map, that is if it was not
1190      * already present.
1191      */
1192     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1193         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1194     }
1195 
1196     /**
1197      * @dev Removes a value from a set. O(1).
1198      *
1199      * Returns true if the key was removed from the map, that is if it was present.
1200      */
1201     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1202         return _remove(map._inner, bytes32(key));
1203     }
1204 
1205     /**
1206      * @dev Returns true if the key is in the map. O(1).
1207      */
1208     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1209         return _contains(map._inner, bytes32(key));
1210     }
1211 
1212     /**
1213      * @dev Returns the number of elements in the map. O(1).
1214      */
1215     function length(UintToAddressMap storage map) internal view returns (uint256) {
1216         return _length(map._inner);
1217     }
1218 
1219    /**
1220     * @dev Returns the element stored at position `index` in the set. O(1).
1221     * Note that there are no guarantees on the ordering of values inside the
1222     * array, and it may change when more values are added or removed.
1223     *
1224     * Requirements:
1225     *
1226     * - `index` must be strictly less than {length}.
1227     */
1228     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1229         (bytes32 key, bytes32 value) = _at(map._inner, index);
1230         return (uint256(key), address(uint160(uint256(value))));
1231     }
1232 
1233     /**
1234      * @dev Tries to returns the value associated with `key`.  O(1).
1235      * Does not revert if `key` is not in the map.
1236      *
1237      * _Available since v3.4._
1238      */
1239     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1240         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1241         return (success, address(uint160(uint256(value))));
1242     }
1243 
1244     /**
1245      * @dev Returns the value associated with `key`.  O(1).
1246      *
1247      * Requirements:
1248      *
1249      * - `key` must be in the map.
1250      */
1251     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1252         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1253     }
1254 
1255     /**
1256      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1257      *
1258      * CAUTION: This function is deprecated because it requires allocating memory for the error
1259      * message unnecessarily. For custom revert reasons use {tryGet}.
1260      */
1261     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1262         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1263     }
1264 }
1265 
1266 
1267 // File: @openzeppelin/contracts/utils/Strings.sol
1268 
1269 /**
1270  * @dev String operations.
1271  */
1272 library Strings {
1273     /**
1274      * @dev Converts a `uint256` to its ASCII `string` representation.
1275      */
1276     function toString(uint256 value) internal pure returns (string memory) {
1277         // Inspired by OraclizeAPI's implementation - MIT licence
1278         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1279 
1280         if (value == 0) {
1281             return "0";
1282         }
1283         uint256 temp = value;
1284         uint256 digits;
1285         while (temp != 0) {
1286             digits++;
1287             temp /= 10;
1288         }
1289         bytes memory buffer = new bytes(digits);
1290         uint256 index = digits - 1;
1291         temp = value;
1292         while (temp != 0) {
1293             buffer[index--] = bytes1(uint8(48 + temp % 10));
1294             temp /= 10;
1295         }
1296         return string(buffer);
1297     }
1298 
1299 }
1300 
1301 
1302 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1303 
1304 /**
1305  * @title ERC721 Non-Fungible Token Standard basic implementation
1306  * @dev see https://eips.ethereum.org/EIPS/eip-721
1307  */
1308 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1309     using SafeMath for uint256;
1310     using Address for address;
1311     using EnumerableSet for EnumerableSet.UintSet;
1312     using EnumerableMap for EnumerableMap.UintToAddressMap;
1313     using Strings for uint256;
1314 
1315     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1316     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1317     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1318 
1319     // Mapping from holder address to their (enumerable) set of owned tokens
1320     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1321 
1322     // Enumerable mapping from token ids to their owners
1323     EnumerableMap.UintToAddressMap private _tokenOwners;
1324 
1325     // Mapping from token ID to approved address
1326     mapping (uint256 => address) private _tokenApprovals;
1327 
1328     // Mapping from owner to operator approvals
1329     mapping (address => mapping (address => bool)) private _operatorApprovals;
1330 
1331     // Token name
1332     string private _name;
1333 
1334     // Token symbol
1335     string private _symbol;
1336 
1337     // Optional mapping for token URIs
1338     mapping (uint256 => string) private _tokenURIs;
1339 
1340     // Base URI
1341     string private _baseURI;
1342 
1343     /*
1344      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1345      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1346      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1347      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1348      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1349      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1350      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1351      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1352      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1353      *
1354      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1355      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1356      */
1357     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1358 
1359     /*
1360      *     bytes4(keccak256('name()')) == 0x06fdde03
1361      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1362      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1363      *
1364      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1365      */
1366     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1367 
1368     /*
1369      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1370      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1371      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1372      *
1373      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1374      */
1375     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1376 
1377     /**
1378      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1379      */
1380     constructor (string memory name_, string memory symbol_) {
1381         _name = name_;
1382         _symbol = symbol_;
1383 
1384         // register the supported interfaces to conform to ERC721 via ERC165
1385         _registerInterface(_INTERFACE_ID_ERC721);
1386         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1387         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-balanceOf}.
1392      */
1393     function balanceOf(address owner) public view virtual override returns (uint256) {
1394         require(owner != address(0), "ERC721: balance query for the zero address");
1395         return _holderTokens[owner].length();
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-ownerOf}.
1400      */
1401     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1402         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Metadata-name}.
1407      */
1408     function name() public view virtual override returns (string memory) {
1409         return _name;
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Metadata-symbol}.
1414      */
1415     function symbol() public view virtual override returns (string memory) {
1416         return _symbol;
1417     }
1418 
1419     /**
1420      * @dev See {IERC721Metadata-tokenURI}.
1421      */
1422     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1423         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1424 
1425         string memory _tokenURI = _tokenURIs[tokenId];
1426         string memory base = baseURI();
1427 
1428         // If there is no base URI, return the token URI.
1429         if (bytes(base).length == 0) {
1430             return _tokenURI;
1431         }
1432         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1433         if (bytes(_tokenURI).length > 0) {
1434             return string(abi.encodePacked(base, _tokenURI));
1435         }
1436         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1437         return string(abi.encodePacked(base, tokenId.toString()));
1438     }
1439 
1440     /**
1441     * @dev Returns the base URI set via {_setBaseURI}. This will be
1442     * automatically added as a prefix in {tokenURI} to each token's URI, or
1443     * to the token ID if no specific URI is set for that token ID.
1444     */
1445     function baseURI() public view virtual returns (string memory) {
1446         return _baseURI;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1451      */
1452     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1453         return _holderTokens[owner].at(index);
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-totalSupply}.
1458      */
1459     function totalSupply() public view virtual override returns (uint256) {
1460         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1461         return _tokenOwners.length();
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Enumerable-tokenByIndex}.
1466      */
1467     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1468         (uint256 tokenId, ) = _tokenOwners.at(index);
1469         return tokenId;
1470     }
1471 
1472     /**
1473      * @dev See {IERC721-approve}.
1474      */
1475     function approve(address to, uint256 tokenId) public virtual override {
1476         address owner = ERC721.ownerOf(tokenId);
1477         require(to != owner, "ERC721: approval to current owner");
1478 
1479         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1480             "ERC721: approve caller is not owner nor approved for all"
1481         );
1482 
1483         _approve(to, tokenId);
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-getApproved}.
1488      */
1489     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1490         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1491 
1492         return _tokenApprovals[tokenId];
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-setApprovalForAll}.
1497      */
1498     function setApprovalForAll(address operator, bool approved) public virtual override {
1499         require(operator != _msgSender(), "ERC721: approve to caller");
1500 
1501         _operatorApprovals[_msgSender()][operator] = approved;
1502         emit ApprovalForAll(_msgSender(), operator, approved);
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-isApprovedForAll}.
1507      */
1508     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1509         return _operatorApprovals[owner][operator];
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-transferFrom}.
1514      */
1515     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1516         //solhint-disable-next-line max-line-length
1517         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1518 
1519         _transfer(from, to, tokenId);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-safeTransferFrom}.
1524      */
1525     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1526         safeTransferFrom(from, to, tokenId, "");
1527     }
1528 
1529     /**
1530      * @dev See {IERC721-safeTransferFrom}.
1531      */
1532     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1533         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1534         _safeTransfer(from, to, tokenId, _data);
1535     }
1536 
1537     /**
1538      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1539      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1540      *
1541      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1542      *
1543      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1544      * implement alternative mechanisms to perform token transfer, such as signature-based.
1545      *
1546      * Requirements:
1547      *
1548      * - `from` cannot be the zero address.
1549      * - `to` cannot be the zero address.
1550      * - `tokenId` token must exist and be owned by `from`.
1551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1552      *
1553      * Emits a {Transfer} event.
1554      */
1555     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1556         _transfer(from, to, tokenId);
1557         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1558     }
1559 
1560     /**
1561      * @dev Returns whether `tokenId` exists.
1562      *
1563      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1564      *
1565      * Tokens start existing when they are minted (`_mint`),
1566      * and stop existing when they are burned (`_burn`).
1567      */
1568     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1569         return _tokenOwners.contains(tokenId);
1570     }
1571 
1572     /**
1573      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1574      *
1575      * Requirements:
1576      *
1577      * - `tokenId` must exist.
1578      */
1579     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1580         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1581         address owner = ERC721.ownerOf(tokenId);
1582         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1583     }
1584 
1585     /**
1586      * @dev Safely mints `tokenId` and transfers it to `to`.
1587      *
1588      * Requirements:
1589      d*
1590      * - `tokenId` must not exist.
1591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1592      *
1593      * Emits a {Transfer} event.
1594      */
1595     function _safeMint(address to, uint256 tokenId) internal virtual {
1596         _safeMint(to, tokenId, "");
1597     }
1598 
1599     /**
1600      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1601      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1602      */
1603     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1604         _mint(to, tokenId);
1605         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1606     }
1607 
1608     /**
1609      * @dev Mints `tokenId` and transfers it to `to`.
1610      *
1611      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1612      *
1613      * Requirements:
1614      *
1615      * - `tokenId` must not exist.
1616      * - `to` cannot be the zero address.
1617      *
1618      * Emits a {Transfer} event.
1619      */
1620     function _mint(address to, uint256 tokenId) internal virtual {
1621         require(to != address(0), "ERC721: mint to the zero address");
1622         require(!_exists(tokenId), "ERC721: token already minted");
1623 
1624         _beforeTokenTransfer(address(0), to, tokenId);
1625 
1626         _holderTokens[to].add(tokenId);
1627 
1628         _tokenOwners.set(tokenId, to);
1629 
1630         emit Transfer(address(0), to, tokenId);
1631     }
1632 
1633     /**
1634      * @dev Destroys `tokenId`.
1635      * The approval is cleared when the token is burned.
1636      *
1637      * Requirements:
1638      *
1639      * - `tokenId` must exist.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _burn(uint256 tokenId) internal virtual {
1644         address owner = ERC721.ownerOf(tokenId); // internal owner
1645 
1646         _beforeTokenTransfer(owner, address(0), tokenId);
1647 
1648         // Clear approvals
1649         _approve(address(0), tokenId);
1650 
1651         // Clear metadata (if any)
1652         if (bytes(_tokenURIs[tokenId]).length != 0) {
1653             delete _tokenURIs[tokenId];
1654         }
1655 
1656         _holderTokens[owner].remove(tokenId);
1657 
1658         _tokenOwners.remove(tokenId);
1659 
1660         emit Transfer(owner, address(0), tokenId);
1661     }
1662 
1663     /**
1664      * @dev Transfers `tokenId` from `from` to `to`.
1665      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1666      *
1667      * Requirements:
1668      *
1669      * - `to` cannot be the zero address.
1670      * - `tokenId` token must be owned by `from`.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1675         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1676         require(to != address(0), "ERC721: transfer to the zero address");
1677 
1678         _beforeTokenTransfer(from, to, tokenId);
1679 
1680         // Clear approvals from the previous owner
1681         _approve(address(0), tokenId);
1682 
1683         _holderTokens[from].remove(tokenId);
1684         _holderTokens[to].add(tokenId);
1685 
1686         _tokenOwners.set(tokenId, to);
1687 
1688         emit Transfer(from, to, tokenId);
1689     }
1690 
1691     /**
1692      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1693      *
1694      * Requirements:
1695      *
1696      * - `tokenId` must exist.
1697      */
1698     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1699         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1700         _tokenURIs[tokenId] = _tokenURI;
1701     }
1702 
1703     /**
1704      * @dev Internal function to set the base URI for all token IDs. It is
1705      * automatically added as a prefix to the value returned in {tokenURI},
1706      * or to the token ID if {tokenURI} is empty.
1707      */
1708     function _setBaseURI(string memory baseURI_) internal virtual {
1709         _baseURI = baseURI_;
1710     }
1711 
1712     /**
1713      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1714      * The call is not executed if the target address is not a contract.
1715      *
1716      * @param from address representing the previous owner of the given token ID
1717      * @param to target address that will receive the tokens
1718      * @param tokenId uint256 ID of the token to be transferred
1719      * @param _data bytes optional data to send along with the call
1720      * @return bool whether the call correctly returned the expected magic value
1721      */
1722     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1723         private returns (bool)
1724     {
1725         if (!to.isContract()) {
1726             return true;
1727         }
1728         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1729             IERC721Receiver(to).onERC721Received.selector,
1730             _msgSender(),
1731             from,
1732             tokenId,
1733             _data
1734         ), "ERC721: transfer to non ERC721Receiver implementer");
1735         bytes4 retval = abi.decode(returndata, (bytes4));
1736         return (retval == _ERC721_RECEIVED);
1737     }
1738 
1739     /**
1740      * @dev Approve `to` to operate on `tokenId`
1741      *
1742      * Emits an {Approval} event.
1743      */
1744     function _approve(address to, uint256 tokenId) internal virtual {
1745         _tokenApprovals[tokenId] = to;
1746         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1747     }
1748 
1749     /**
1750      * @dev Hook that is called before any token transfer. This includes minting
1751      * and burning.
1752      *
1753      * Calling conditions:
1754      *
1755      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1756      * transferred to `to`.
1757      * - When `from` is zero, `tokenId` will be minted for `to`.
1758      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1759      * - `from` cannot be the zero address.
1760      * - `to` cannot be the zero address.
1761      *
1762      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1763      */
1764     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1765 }
1766 
1767 
1768 // File: @openzeppelin/contracts/access/Ownable.sol
1769 
1770 /**
1771  * @dev Contract module which provides a basic access control mechanism, where
1772  * there is an account (an owner) that can be granted exclusive access to
1773  * specific functions.
1774  *
1775  * By default, the owner account will be the one that deploys the contract. This
1776  * can later be changed with {transferOwnership}.
1777  *
1778  * This module is used through inheritance. It will make available the modifier
1779  * `onlyOwner`, which can be applied to your functions to restrict their use to
1780  * the owner.
1781  */
1782 abstract contract Ownable is Context {
1783     address private _owner;
1784 
1785     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1786 
1787     /**
1788      * @dev Initializes the contract setting the deployer as the initial owner.
1789      */
1790     constructor () {
1791         address msgSender = _msgSender();
1792         _owner = msgSender;
1793         emit OwnershipTransferred(address(0), msgSender);
1794     }
1795 
1796     /**
1797      * @dev Returns the address of the current owner.
1798      */
1799     function owner() public view virtual returns (address) {
1800         return _owner;
1801     }
1802 
1803     /**
1804      * @dev Throws if called by any account other than the owner.
1805      */
1806     modifier onlyOwner() {
1807         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1808         _;
1809     }
1810 
1811     /**
1812      * @dev Leaves the contract without owner. It will not be possible to call
1813      * `onlyOwner` functions anymore. Can only be called by the current owner.
1814      *
1815      * NOTE: Renouncing ownership will leave the contract without an owner,
1816      * thereby removing any functionality that is only available to the owner.
1817      */
1818     function renounceOwnership() public virtual onlyOwner {
1819         emit OwnershipTransferred(_owner, address(0));
1820         _owner = address(0);
1821     }
1822 
1823     /**
1824      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1825      * Can only be called by the current owner.
1826      */
1827     function transferOwnership(address newOwner) public virtual onlyOwner {
1828         require(newOwner != address(0), "Ownable: new owner is the zero address");
1829         emit OwnershipTransferred(_owner, newOwner);
1830         _owner = newOwner;
1831     }
1832 }
1833 
1834 // File: contracts/RubyMazurLips.sol
1835 
1836 /**
1837  * @title RubyMazurLips contract
1838  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1839  */
1840 contract RubyMazurLips is ERC721, Ownable {
1841     using SafeMath for uint256;
1842     using Strings for uint256;
1843 
1844     uint256 public MAX_TOKEN_SUPPLY;
1845     uint256 public maxToMint;
1846     uint256 maxWhitelistMints;
1847     uint256 maxTeamReserveMints;
1848     uint256 maxGiveawayMints;
1849     uint256 numTeamReserveMinted;
1850     uint256 numGiveawayMinted;
1851 
1852     bool public saleIsActive;
1853     bool public whitelistIsActive;
1854 
1855     bytes32[] _whitelistRootHash;
1856     bytes32[] _giveawayRootHash;
1857     mapping(address => uint256) public numberOfWhitelistMints;
1858     mapping(address => uint256) public numberOfGiveawayMints;
1859 
1860     address payoutWallet1;
1861     address payoutWallet2;
1862    
1863     uint256 public whitelistMintPrice;
1864     uint256 public regularMintPrice;
1865     uint256 bytPayoutPercentage;
1866 
1867     string private prerevealURI;
1868     bool public revealIsActive;
1869     uint256 maxTokenIdRevealed;
1870 
1871     constructor() ERC721("Ruby Mazur Lips", "LIPS") {
1872         MAX_TOKEN_SUPPLY = 5050;
1873         prerevealURI = "https://gateway.pinata.cloud/ipfs/QmZG77XuF7Yu8y9cUKrpYxR2yEp4qviu2ND78SnMT7ztJj";
1874         whitelistMintPrice = 150000000000000000; // 0.15 ETH
1875         regularMintPrice = 200000000000000000; //0.2 ETH
1876         maxToMint = 5;
1877         maxWhitelistMints = 3;
1878         maxTeamReserveMints = 131;
1879         maxGiveawayMints = 115;
1880         saleIsActive = false;
1881         whitelistIsActive = false;
1882         revealIsActive = false;
1883         payoutWallet1 = 0xe5C24ad2bcBBf4b547247417A8a8877dD885D029;// cosmic payout wallet
1884         payoutWallet2 = 0x80E20FF6568A8C23D971165f99aD61FA19F9E084;// byt payout wallet
1885         bytPayoutPercentage = 15;
1886     }
1887 
1888     fallback() external payable {}
1889 
1890     function addToWhitelistRootHash(bytes32 _hash) external onlyOwner{
1891         _whitelistRootHash.push(_hash);
1892     }
1893 
1894     function addToGiveawayRootHash(bytes32 _hash) external onlyOwner{
1895         _giveawayRootHash.push(_hash);
1896     }
1897 
1898     function setWhitelistMintPrice(uint256 _price) external onlyOwner {
1899         whitelistMintPrice = _price;
1900     }
1901     
1902     function setRegularMintPrice(uint256 _price) external onlyOwner {
1903         regularMintPrice = _price;
1904     }
1905 
1906     function setMaxToMint(uint256 _maxValue) external onlyOwner {
1907         maxToMint = _maxValue;
1908     }
1909 
1910     function setMaxTeamReserveMints(uint256 _maxValue) external onlyOwner {
1911         maxTeamReserveMints = _maxValue;
1912     }
1913 
1914     function setMaxGiveawayMints(uint256 _maxValue) external onlyOwner {
1915         maxGiveawayMints = _maxValue;
1916     }
1917 
1918     function setBaseURI(string memory baseURI) external onlyOwner {
1919         _setBaseURI(baseURI);
1920     }
1921 
1922     function setPrerevealURI(string memory prerevealURI_) external onlyOwner {
1923         prerevealURI = prerevealURI_;
1924     }
1925 
1926     function setRevealState() external onlyOwner {
1927         revealIsActive = !revealIsActive;
1928     }
1929 
1930     function setMaxTokenIdRevealed(uint256 tokenId) external onlyOwner {
1931         maxTokenIdRevealed = tokenId;
1932     }
1933 
1934     function setSaleState() external onlyOwner {
1935         saleIsActive = !saleIsActive;
1936     }
1937 
1938     function setWhitelistState() external onlyOwner {
1939         whitelistIsActive = !whitelistIsActive;
1940     }
1941 
1942     function setPayoutWallet1(address wallet) external onlyOwner {
1943         payoutWallet1 = wallet;
1944     }
1945 
1946     function setPayoutWallet2(address wallet) external onlyOwner {
1947         payoutWallet2 = wallet;
1948     }
1949 
1950     function whitelistMint(uint256 numberOfTokens, uint256 spotInWhitelist, bytes32[] memory proof) external payable {
1951         require(whitelistIsActive, "The whitelist is not active yet");
1952         require(saleIsActive == false, "The whitelist mint has closed");
1953         require(numberOfTokens <= maxToMint, "Invalid amount to mint per txn");
1954         require(totalSupply().add(numberOfTokens) <= MAX_TOKEN_SUPPLY, "Purchase would exceed max supply");
1955         require(whitelistValidated(_msgSender(), 1, spotInWhitelist, proof, _whitelistRootHash), "You're not on the whitelist");
1956         require((numberOfWhitelistMints[_msgSender()] + numberOfTokens) <= maxWhitelistMints, "This transaction exceeds the max whitelist mints");
1957         require(whitelistMintPrice.mul(numberOfTokens) <= msg.value, "Ether value set is not correct");
1958 
1959         numberOfWhitelistMints[_msgSender()] += numberOfTokens;
1960 
1961         uint256 tokenID = totalSupply();
1962         uint256 i;
1963 
1964         for (i = 0; i < numberOfTokens; i++) {
1965             _safeMint(_msgSender(), tokenID.add(i));
1966         }
1967     }
1968 
1969     function giveawayMint(uint256 amount, uint256 spotInWhitelist, bytes32[] memory proof) external {
1970         require(whitelistIsActive, "Giveaway must be active to mint");
1971         require(numGiveawayMinted.add(amount) <= maxGiveawayMints, "Mint would exeed max giveaway mints");
1972         require(totalSupply().add(amount) <= MAX_TOKEN_SUPPLY, "Mint would exceed max supply");
1973         require(whitelistValidated(_msgSender(), amount, spotInWhitelist, proof, _giveawayRootHash), "You're not on the giveaway list");
1974         require(numberOfGiveawayMints[_msgSender()] == 0, "This address already received a giveaway mint");
1975 
1976         uint256 tokenID = totalSupply();
1977         uint256 i;
1978 
1979         numberOfGiveawayMints[_msgSender()] = amount;
1980         numGiveawayMinted += amount;
1981 
1982         for (i = 0; i < amount; i++) {
1983             _safeMint(_msgSender(), tokenID.add(i));
1984         }
1985     }
1986 
1987     function mint(uint256 numberOfTokens) external payable {
1988         require(saleIsActive, "Sale must be active to mint");
1989         require(numberOfTokens <= maxToMint, "Invalid amount to mint per txn");
1990         require(totalSupply().add(numberOfTokens) <= MAX_TOKEN_SUPPLY, "Purchase would exceed max supply");
1991         require(regularMintPrice.mul(numberOfTokens) <= msg.value, "Ether value set is not correct");
1992 
1993         uint256 tokenID = totalSupply();
1994         uint256 i;
1995 
1996         for (i = 0; i < numberOfTokens; i++) {
1997             _safeMint(_msgSender(), tokenID.add(i));
1998         }
1999     }
2000 
2001     function teamReserveMint(uint256 numberOfTokens, address _to) external onlyOwner {
2002         require(totalSupply().add(numberOfTokens) <= MAX_TOKEN_SUPPLY, "Purchase would exceed max supply");
2003         require(numTeamReserveMinted.add(numberOfTokens) <= maxTeamReserveMints, "Purchase would exceed max reserved amount");
2004 
2005         numTeamReserveMinted += numberOfTokens;
2006         uint256 supply = totalSupply();
2007         uint256 i;
2008 
2009         for (i = 0; i < numberOfTokens; i++) {
2010             _safeMint(_to, supply.add(i));
2011         }
2012      }
2013 
2014     function whitelistValidated(address wallet, uint256 _amount, uint256 index, bytes32[] memory proof, bytes32[] memory _rootHash) internal pure returns (bool) {
2015         uint256 amount = _amount;
2016 
2017         // Compute the merkle root
2018         bytes32 node = keccak256(abi.encodePacked(index, wallet, amount));
2019         uint256 path = index;
2020         for (uint16 i = 0; i < proof.length; i++) {
2021             if ((path & 0x01) == 1) {
2022                 node = keccak256(abi.encodePacked(proof[i], node));
2023             } else {
2024                 node = keccak256(abi.encodePacked(node, proof[i]));
2025             }
2026             path /= 2;
2027         }
2028 
2029         // Check the merkle proof against the root hash array
2030         for(uint i = 0; i < _rootHash.length; i++)
2031         {
2032             if (node == _rootHash[i])
2033             {
2034                 return true;
2035             }
2036         }
2037 
2038         return false;
2039     }
2040 
2041     function withdraw() external onlyOwner {
2042         require(payoutWallet1 != address(0), "wallet 1 not set");
2043         require(payoutWallet2 != address(0), "wallet 2 not set");
2044         uint256 balance = address(this).balance;
2045         uint256 walletBalance = balance.mul(100 - bytPayoutPercentage).div(100);
2046         payable(payoutWallet1).transfer(walletBalance);
2047         payable(payoutWallet2).transfer(balance.sub(walletBalance));
2048     }
2049 
2050     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2051         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2052 
2053         if(revealIsActive && tokenId <= maxTokenIdRevealed) {
2054             return string(abi.encodePacked(baseURI(), tokenId.toString()));
2055         } else {
2056             return prerevealURI;
2057         }
2058     }
2059 }