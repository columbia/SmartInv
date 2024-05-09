1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-27
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File contracts/libs/IERC165.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  */
36 interface IERC165 {
37     function supportsInterface(bytes4 interfaceId) external view returns (bool);
38 }
39 
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Implementation of the {IERC165} interface.
45  */
46 abstract contract ERC165 is IERC165 {
47     /**
48      * @dev See {IERC165-supportsInterface}.
49      */
50     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
51         return interfaceId == type(IERC165).interfaceId;
52     }
53 }
54 
55 
56 pragma solidity ^0.8.0;
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
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 
196 pragma solidity ^0.8.0;
197 
198 // CAUTION
199 // This version of SafeMath should only be used with Solidity 0.8 or later,
200 // because it relies on the compiler's built in overflow checks.
201 
202 /**
203  * @dev Wrappers over Solidity's arithmetic operations.
204  *
205  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
206  * now has built in overflow checking.
207  */
208 library SafeMath {
209     /**
210      * @dev Returns the addition of two unsigned integers, with an overflow flag.
211      *
212      * _Available since v3.4._
213      */
214     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         unchecked {
216             uint256 c = a + b;
217             if (c < a) return (false, 0);
218             return (true, c);
219         }
220     }
221 
222     /**
223      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
224      *
225      * _Available since v3.4._
226      */
227     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
228         unchecked {
229             if (b > a) return (false, 0);
230             return (true, a - b);
231         }
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
236      *
237      * _Available since v3.4._
238      */
239     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242             // benefit is lost if 'b' is also tested.
243             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244             if (a == 0) return (true, 0);
245             uint256 c = a * b;
246             if (c / a != b) return (false, 0);
247             return (true, c);
248         }
249     }
250 
251     /**
252      * @dev Returns the division of two unsigned integers, with a division by zero flag.
253      *
254      * _Available since v3.4._
255      */
256     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b == 0) return (false, 0);
259             return (true, a / b);
260         }
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b == 0) return (false, 0);
271             return (true, a % b);
272         }
273     }
274 
275     /**
276      * @dev Returns the addition of two unsigned integers, reverting on
277      * overflow.
278      *
279      * Counterpart to Solidity's `+` operator.
280      *
281      * Requirements:
282      *
283      * - Addition cannot overflow.
284      */
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a + b;
287     }
288 
289     /**
290      * @dev Returns the subtraction of two unsigned integers, reverting on
291      * overflow (when the result is negative).
292      *
293      * Counterpart to Solidity's `-` operator.
294      *
295      * Requirements:
296      *
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a - b;
301     }
302 
303     /**
304      * @dev Returns the multiplication of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `*` operator.
308      *
309      * Requirements:
310      *
311      * - Multiplication cannot overflow.
312      */
313     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a * b;
315     }
316 
317     /**
318      * @dev Returns the integer division of two unsigned integers, reverting on
319      * division by zero. The result is rounded towards zero.
320      *
321      * Counterpart to Solidity's `/` operator.
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a / b;
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * reverting when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
344         return a % b;
345     }
346 
347     /**
348      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
349      * overflow (when the result is negative).
350      *
351      * CAUTION: This function is deprecated because it requires allocating memory for the error
352      * message unnecessarily. For custom revert reasons use {trySub}.
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(
361         uint256 a,
362         uint256 b,
363         string memory errorMessage
364     ) internal pure returns (uint256) {
365         unchecked {
366             require(b <= a, errorMessage);
367             return a - b;
368         }
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator. Note: this function uses a
376      * `revert` opcode (which leaves remaining gas untouched) while Solidity
377      * uses an invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function div(
384         uint256 a,
385         uint256 b,
386         string memory errorMessage
387     ) internal pure returns (uint256) {
388         unchecked {
389             require(b > 0, errorMessage);
390             return a / b;
391         }
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * reverting with custom message when dividing by zero.
397      *
398      * CAUTION: This function is deprecated because it requires allocating memory for the error
399      * message unnecessarily. For custom revert reasons use {tryMod}.
400      *
401      * Counterpart to Solidity's `%` operator. This function uses a `revert`
402      * opcode (which leaves remaining gas untouched) while Solidity uses an
403      * invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function mod(
410         uint256 a,
411         uint256 b,
412         string memory errorMessage
413     ) internal pure returns (uint256) {
414         unchecked {
415             require(b > 0, errorMessage);
416             return a % b;
417         }
418     }
419 }
420 
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Collection of functions related to the address type
426  */
427 library Address {
428     /**
429      * @dev Returns true if `account` is a contract.
430      *
431      * [IMPORTANT]
432      * ====
433      * It is unsafe to assume that an address for which this function returns
434      * false is an externally-owned account (EOA) and not a contract.
435      *
436      * Among others, `isContract` will return false for the following
437      * types of addresses:
438      *
439      *  - an externally-owned account
440      *  - a contract in construction
441      *  - an address where a contract will be created
442      *  - an address where a contract lived, but was destroyed
443      * ====
444      */
445     function isContract(address account) internal view returns (bool) {
446         // This method relies on extcodesize, which returns 0 for contracts in
447         // construction, since the code is only stored at the end of the
448         // constructor execution.
449 
450         uint256 size;
451         assembly {
452             size := extcodesize(account)
453         }
454         return size > 0;
455     }
456 
457     /**
458      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
459      * `recipient`, forwarding all available gas and reverting on errors.
460      *
461      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
462      * of certain opcodes, possibly making contracts go over the 2300 gas limit
463      * imposed by `transfer`, making them unable to receive funds via
464      * `transfer`. {sendValue} removes this limitation.
465      *
466      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
467      *
468      * IMPORTANT: because control is transferred to `recipient`, care must be
469      * taken to not create reentrancy vulnerabilities. Consider using
470      * {ReentrancyGuard} or the
471      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
472      */
473     function sendValue(address payable recipient, uint256 amount) internal {
474         require(address(this).balance >= amount, "Address: insufficient balance");
475 
476         (bool success, ) = recipient.call{value: amount}("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 
480     /**
481      * @dev Performs a Solidity function call using a low level `call`. A
482      * plain `call` is an unsafe replacement for a function call: use this
483      * function instead.
484      *
485      * If `target` reverts with a revert reason, it is bubbled up by this
486      * function (like regular Solidity function calls).
487      *
488      * Returns the raw returned data. To convert to the expected return value,
489      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
490      *
491      * Requirements:
492      *
493      * - `target` must be a contract.
494      * - calling `target` with `data` must not revert.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionCall(target, data, "Address: low-level call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, 0, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but also transferring `value` wei to `target`.
519      *
520      * Requirements:
521      *
522      * - the calling contract must have an ETH balance of at least `value`.
523      * - the called Solidity function must be `payable`.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value
531     ) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(address(this).balance >= value, "Address: insufficient balance for call");
548         require(isContract(target), "Address: call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.call{value: value}(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
561         return functionStaticCall(target, data, "Address: low-level static call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a delegate call.
594      *
595      * _Available since v3.4._
596      */
597     function functionDelegateCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(isContract(target), "Address: delegate call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.delegatecall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
610      * revert reason using the provided one.
611      *
612      * _Available since v4.3._
613      */
614     function verifyCallResult(
615         bool success,
616         bytes memory returndata,
617         string memory errorMessage
618     ) internal pure returns (bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             // Look for revert reason and bubble it up if present
623             if (returndata.length > 0) {
624                 // The easiest way to bubble the revert reason is using memory via assembly
625 
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @title Counters
642  * @author Matt Condon (@shrugs)
643  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
644  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
645  *
646  * Include with `using Counters for Counters.Counter;`
647  */
648 library Counters {
649     struct Counter {
650         // This variable should never be directly accessed by users of the library: interactions must be restricted to
651         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
652         // this feature: see https://github.com/ethereum/solidity/issues/4637
653         uint256 _value; // default: 0
654     }
655 
656     function current(Counter storage counter) internal view returns (uint256) {
657         return counter._value;
658     }
659 
660     function increment(Counter storage counter) internal {
661         unchecked {
662             counter._value += 1;
663         }
664     }
665 
666     function decrement(Counter storage counter) internal {
667         uint256 value = counter._value;
668         require(value > 0, "Counter: decrement overflow");
669         unchecked {
670             counter._value = value - 1;
671         }
672     }
673 
674     function reset(Counter storage counter) internal {
675         counter._value = 0;
676     }
677 }
678 
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @title ERC721 token receiver interface
684  * @dev Interface for any contract that wants to support safeTransfers
685  * from ERC721 asset contracts.
686  */
687 interface IERC721Receiver {
688     /**
689      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
690      * by `operator` from `from`, this function is called.
691      *
692      * It must return its Solidity selector to confirm the token transfer.
693      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
694      *
695      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
696      */
697     function onERC721Received(
698         address operator,
699         address from,
700         uint256 tokenId,
701         bytes calldata data
702     ) external returns (bytes4);
703 }
704 
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Metadata is IERC721 {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension, but not including the Enumerable extension, which is available separately as
735  * {ERC721Enumerable}.
736  */
737 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
738     using Address for address;
739     using Strings for uint256;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) private _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) private _balances;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     /**
760      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
761      */
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view virtual override returns (uint256) {
781         require(owner != address(0), "ERC721: balance query for the zero address");
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
789         address owner = _owners[tokenId];
790         require(owner != address(0), "ERC721: owner query for nonexistent token");
791         return owner;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return "";
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public virtual override {
831         address owner = ERC721.ownerOf(tokenId);
832         require(to != owner, "ERC721: approval to current owner");
833 
834         require(
835             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
836             "ERC721: approve caller is not owner nor approved for all"
837         );
838 
839         _approve(to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-getApproved}.
844      */
845     function getApproved(uint256 tokenId) public view virtual override returns (address) {
846         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
847 
848         return _tokenApprovals[tokenId];
849     }
850 
851     /**
852      * @dev See {IERC721-setApprovalForAll}.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         require(operator != _msgSender(), "ERC721: approve to caller");
856 
857         _operatorApprovals[_msgSender()][operator] = approved;
858         emit ApprovalForAll(_msgSender(), operator, approved);
859     }
860 
861     /**
862      * @dev See {IERC721-isApprovedForAll}.
863      */
864     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
865         return _operatorApprovals[owner][operator];
866     }
867 
868     /**
869      * @dev See {IERC721-transferFrom}.
870      */
871     function transferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         //solhint-disable-next-line max-line-length
877         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
878 
879         _transfer(from, to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         safeTransferFrom(from, to, tokenId, "");
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) public virtual override {
902         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
903         _safeTransfer(from, to, tokenId, _data);
904     }
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
908      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
909      *
910      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
911      *
912      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
913      * implement alternative mechanisms to perform token transfer, such as signature-based.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _safeTransfer(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) internal virtual {
930         _transfer(from, to, tokenId);
931         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
932     }
933 
934     /**
935      * @dev Returns whether `tokenId` exists.
936      *
937      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
938      *
939      * Tokens start existing when they are minted (`_mint`),
940      * and stop existing when they are burned (`_burn`).
941      */
942     function _exists(uint256 tokenId) internal view virtual returns (bool) {
943         return _owners[tokenId] != address(0);
944     }
945 
946     /**
947      * @dev Returns whether `spender` is allowed to manage `tokenId`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      */
953     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
954         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
955         address owner = ERC721.ownerOf(tokenId);
956         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
957     }
958 
959     /**
960      * @dev Safely mints `tokenId` and transfers it to `to`.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(address to, uint256 tokenId) internal virtual {
970         _safeMint(to, tokenId, "");
971     }
972 
973     /**
974      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
975      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
976      */
977     function _safeMint(
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) internal virtual {
982         _mint(to, tokenId);
983         require(
984             _checkOnERC721Received(address(0), to, tokenId, _data),
985             "ERC721: transfer to non ERC721Receiver implementer"
986         );
987     }
988 
989     /**
990      * @dev Mints `tokenId` and transfers it to `to`.
991      *
992      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
993      *
994      * Requirements:
995      *
996      * - `tokenId` must not exist.
997      * - `to` cannot be the zero address.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _mint(address to, uint256 tokenId) internal virtual {
1002         require(to != address(0), "ERC721: mint to the zero address");
1003         require(!_exists(tokenId), "ERC721: token already minted");
1004 
1005         _beforeTokenTransfer(address(0), to, tokenId);
1006 
1007         _balances[to] += 1;
1008         _owners[tokenId] = to;
1009 
1010         emit Transfer(address(0), to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Destroys `tokenId`.
1015      * The approval is cleared when the token is burned.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _burn(uint256 tokenId) internal virtual {
1024         address owner = ERC721.ownerOf(tokenId);
1025 
1026         _beforeTokenTransfer(owner, address(0), tokenId);
1027 
1028         // Clear approvals
1029         _approve(address(0), tokenId);
1030 
1031         _balances[owner] -= 1;
1032         delete _owners[tokenId];
1033 
1034         emit Transfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1054         require(to != address(0), "ERC721: transfer to the zero address");
1055 
1056         _beforeTokenTransfer(from, to, tokenId);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId);
1060 
1061         _balances[from] -= 1;
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits a {Approval} event.
1072      */
1073     function _approve(address to, uint256 tokenId) internal virtual {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param _data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1096                 return retval == IERC721Receiver.onERC721Received.selector;
1097             } catch (bytes memory reason) {
1098                 if (reason.length == 0) {
1099                     revert("ERC721: transfer to non ERC721Receiver implementer");
1100                 } else {
1101                     assembly {
1102                         revert(add(32, reason), mload(reason))
1103                     }
1104                 }
1105             }
1106         } else {
1107             return true;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1121      * - `from` and `to` are never both zero.
1122      *
1123      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1124      */
1125     function _beforeTokenTransfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) internal virtual {}
1130 }
1131 
1132 pragma solidity ^0.8.0;
1133 /**
1134  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1135  * @dev See https://eips.ethereum.org/EIPS/eip-721
1136  */
1137 interface IERC721Enumerable is IERC721 {
1138     /**
1139      * @dev Returns the total amount of tokens stored by the contract.
1140      */
1141     function totalSupply() external view returns (uint256);
1142 
1143     /**
1144      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1145      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1146      */
1147     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1148 
1149     /**
1150      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1151      * Use along with {totalSupply} to enumerate all tokens.
1152      */
1153     function tokenByIndex(uint256 index) external view returns (uint256);
1154 }
1155 
1156 
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1162  * enumerability of all the token ids in the contract as well as all token ids owned by each
1163  * account.
1164  */
1165 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1166     // Mapping from owner to list of owned token IDs
1167     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1168 
1169     // Mapping from token ID to index of the owner tokens list
1170     mapping(uint256 => uint256) private _ownedTokensIndex;
1171 
1172     // Array with all token ids, used for enumeration
1173     uint256[] private _allTokens;
1174 
1175     // Mapping from token id to position in the allTokens array
1176     mapping(uint256 => uint256) private _allTokensIndex;
1177 
1178     /**
1179      * @dev See {IERC165-supportsInterface}.
1180      */
1181     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1182         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1189         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1190         return _ownedTokens[owner][index];
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-totalSupply}.
1195      */
1196     function totalSupply() public view virtual override returns (uint256) {
1197         return _allTokens.length;
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Enumerable-tokenByIndex}.
1202      */
1203     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1204         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1205         return _allTokens[index];
1206     }
1207 
1208     /**
1209      * @dev Hook that is called before any token transfer. This includes minting
1210      * and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` will be minted for `to`.
1217      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1218      * - `from` cannot be the zero address.
1219      * - `to` cannot be the zero address.
1220      *
1221      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1222      */
1223     function _beforeTokenTransfer(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) internal virtual override {
1228         super._beforeTokenTransfer(from, to, tokenId);
1229 
1230         if (from == address(0)) {
1231             _addTokenToAllTokensEnumeration(tokenId);
1232         } else if (from != to) {
1233             _removeTokenFromOwnerEnumeration(from, tokenId);
1234         }
1235         if (to == address(0)) {
1236             _removeTokenFromAllTokensEnumeration(tokenId);
1237         } else if (to != from) {
1238             _addTokenToOwnerEnumeration(to, tokenId);
1239         }
1240     }
1241 
1242     /**
1243      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1244      * @param to address representing the new owner of the given token ID
1245      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1246      */
1247     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1248         uint256 length = ERC721.balanceOf(to);
1249         _ownedTokens[to][length] = tokenId;
1250         _ownedTokensIndex[tokenId] = length;
1251     }
1252 
1253     /**
1254      * @dev Private function to add a token to this extension's token tracking data structures.
1255      * @param tokenId uint256 ID of the token to be added to the tokens list
1256      */
1257     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1258         _allTokensIndex[tokenId] = _allTokens.length;
1259         _allTokens.push(tokenId);
1260     }
1261 
1262     /**
1263      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1264      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1265      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1266      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1267      * @param from address representing the previous owner of the given token ID
1268      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1269      */
1270     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1271         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1272         // then delete the last slot (swap and pop).
1273 
1274         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1275         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1276 
1277         // When the token to delete is the last token, the swap operation is unnecessary
1278         if (tokenIndex != lastTokenIndex) {
1279             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1280 
1281             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1282             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1283         }
1284 
1285         // This also deletes the contents at the last position of the array
1286         delete _ownedTokensIndex[tokenId];
1287         delete _ownedTokens[from][lastTokenIndex];
1288     }
1289 
1290     /**
1291      * @dev Private function to remove a token from this extension's token tracking data structures.
1292      * This has O(1) time complexity, but alters the order of the _allTokens array.
1293      * @param tokenId uint256 ID of the token to be removed from the tokens list
1294      */
1295     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1296         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1297         // then delete the last slot (swap and pop).
1298 
1299         uint256 lastTokenIndex = _allTokens.length - 1;
1300         uint256 tokenIndex = _allTokensIndex[tokenId];
1301 
1302         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1303         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1304         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1305         uint256 lastTokenId = _allTokens[lastTokenIndex];
1306 
1307         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1308         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1309 
1310         // This also deletes the contents at the last position of the array
1311         delete _allTokensIndex[tokenId];
1312         _allTokens.pop();
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/access/Ownable.sol
1317 pragma solidity ^0.8.0;
1318 
1319 /**
1320  * @dev Contract module which provides a basic access control mechanism, where
1321  * there is an account (an owner) that can be granted exclusive access to
1322  * specific functions.
1323  *
1324  * By default, the owner account will be the one that deploys the contract. This
1325  * can later be changed with {transferOwnership}.
1326  *
1327  * This module is used through inheritance. It will make available the modifier
1328  * `onlyOwner`, which can be applied to your functions to restrict their use to
1329  * the owner.
1330  */
1331 abstract contract Ownable is Context {
1332     address private _owner;
1333 
1334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1335 
1336     /**
1337      * @dev Initializes the contract setting the deployer as the initial owner.
1338      */
1339     constructor () {
1340         address msgSender = _msgSender();
1341         _owner = msgSender;
1342         emit OwnershipTransferred(address(0), msgSender);
1343     }
1344 
1345     /**
1346      * @dev Returns the address of the current owner.
1347      */
1348     function owner() public view virtual returns (address) {
1349         return _owner;
1350     }
1351 
1352     /**
1353      * @dev Throws if called by any account other than the owner.
1354      */
1355     modifier onlyOwner() {
1356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Leaves the contract without owner. It will not be possible to call
1362      * `onlyOwner` functions anymore. Can only be called by the current owner.
1363      *
1364      * NOTE: Renouncing ownership will leave the contract without an owner,
1365      * thereby removing any functionality that is only available to the owner.
1366      */
1367     function renounceOwnership() public virtual onlyOwner {
1368         emit OwnershipTransferred(_owner, address(0));
1369         _owner = address(0);
1370     }
1371 
1372     /**
1373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1374      * Can only be called by the current owner.
1375      */
1376     function transferOwnership(address newOwner) public virtual onlyOwner {
1377         require(newOwner != address(0), "Ownable: new owner is the zero address");
1378         emit OwnershipTransferred(_owner, newOwner);
1379         _owner = newOwner;
1380     }
1381 }
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 /**
1386  * @dev String operations.
1387  */
1388 library Strings {
1389     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1390 
1391     /**
1392      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1393      */
1394     function toString(uint256 value) internal pure returns (string memory) {
1395         // Inspired by OraclizeAPI's implementation - MIT licence
1396         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1397 
1398         if (value == 0) {
1399             return "0";
1400         }
1401         uint256 temp = value;
1402         uint256 digits;
1403         while (temp != 0) {
1404             digits++;
1405             temp /= 10;
1406         }
1407         bytes memory buffer = new bytes(digits);
1408         while (value != 0) {
1409             digits -= 1;
1410             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1411             value /= 10;
1412         }
1413         return string(buffer);
1414     }
1415 
1416     /**
1417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1418      */
1419     function toHexString(uint256 value) internal pure returns (string memory) {
1420         if (value == 0) {
1421             return "0x00";
1422         }
1423         uint256 temp = value;
1424         uint256 length = 0;
1425         while (temp != 0) {
1426             length++;
1427             temp >>= 8;
1428         }
1429         return toHexString(value, length);
1430     }
1431 
1432     /**
1433      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1434      */
1435     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1436         bytes memory buffer = new bytes(2 * length + 2);
1437         buffer[0] = "0";
1438         buffer[1] = "x";
1439         for (uint256 i = 2 * length + 1; i > 1; --i) {
1440             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1441             value >>= 4;
1442         }
1443         require(value == 0, "Strings: hex length insufficient");
1444         return string(buffer);
1445     }
1446 }
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 /**
1451  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1452  *
1453  * These functions can be used to verify that a message was signed by the holder
1454  * of the private keys of a given address.
1455  */
1456 library ECDSA {
1457     enum RecoverError {
1458         NoError,
1459         InvalidSignature,
1460         InvalidSignatureLength,
1461         InvalidSignatureS,
1462         InvalidSignatureV
1463     }
1464 
1465     function _throwError(RecoverError error) private pure {
1466         if (error == RecoverError.NoError) {
1467             return; // no error: do nothing
1468         } else if (error == RecoverError.InvalidSignature) {
1469             revert("ECDSA: invalid signature");
1470         } else if (error == RecoverError.InvalidSignatureLength) {
1471             revert("ECDSA: invalid signature length");
1472         } else if (error == RecoverError.InvalidSignatureS) {
1473             revert("ECDSA: invalid signature 's' value");
1474         } else if (error == RecoverError.InvalidSignatureV) {
1475             revert("ECDSA: invalid signature 'v' value");
1476         }
1477     }
1478 
1479     /**
1480      * @dev Returns the address that signed a hashed message (`hash`) with
1481      * `signature` or error string. This address can then be used for verification purposes.
1482      *
1483      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1484      * this function rejects them by requiring the `s` value to be in the lower
1485      * half order, and the `v` value to be either 27 or 28.
1486      *
1487      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1488      * verification to be secure: it is possible to craft signatures that
1489      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1490      * this is by receiving a hash of the original message (which may otherwise
1491      * be too long), and then calling {toEthSignedMessageHash} on it.
1492      *
1493      * Documentation for signature generation:
1494      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1495      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1496      *
1497      * _Available since v4.3._
1498      */
1499     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1500         // Check the signature length
1501         // - case 65: r,s,v signature (standard)
1502         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1503         if (signature.length == 65) {
1504             bytes32 r;
1505             bytes32 s;
1506             uint8 v;
1507             // ecrecover takes the signature parameters, and the only way to get them
1508             // currently is to use assembly.
1509             assembly {
1510                 r := mload(add(signature, 0x20))
1511                 s := mload(add(signature, 0x40))
1512                 v := byte(0, mload(add(signature, 0x60)))
1513             }
1514             return tryRecover(hash, v, r, s);
1515         } else if (signature.length == 64) {
1516             bytes32 r;
1517             bytes32 vs;
1518             // ecrecover takes the signature parameters, and the only way to get them
1519             // currently is to use assembly.
1520             assembly {
1521                 r := mload(add(signature, 0x20))
1522                 vs := mload(add(signature, 0x40))
1523             }
1524             return tryRecover(hash, r, vs);
1525         } else {
1526             return (address(0), RecoverError.InvalidSignatureLength);
1527         }
1528     }
1529 
1530     /**
1531      * @dev Returns the address that signed a hashed message (`hash`) with
1532      * `signature`. This address can then be used for verification purposes.
1533      *
1534      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1535      * this function rejects them by requiring the `s` value to be in the lower
1536      * half order, and the `v` value to be either 27 or 28.
1537      *
1538      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1539      * verification to be secure: it is possible to craft signatures that
1540      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1541      * this is by receiving a hash of the original message (which may otherwise
1542      * be too long), and then calling {toEthSignedMessageHash} on it.
1543      */
1544     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1545         (address recovered, RecoverError error) = tryRecover(hash, signature);
1546         _throwError(error);
1547         return recovered;
1548     }
1549 
1550     /**
1551      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1552      *
1553      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1554      *
1555      * _Available since v4.3._
1556      */
1557     function tryRecover(
1558         bytes32 hash,
1559         bytes32 r,
1560         bytes32 vs
1561     ) internal pure returns (address, RecoverError) {
1562         bytes32 s;
1563         uint8 v;
1564         assembly {
1565             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1566             v := add(shr(255, vs), 27)
1567         }
1568         return tryRecover(hash, v, r, s);
1569     }
1570 
1571     /**
1572      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1573      *
1574      * _Available since v4.2._
1575      */
1576     function recover(
1577         bytes32 hash,
1578         bytes32 r,
1579         bytes32 vs
1580     ) internal pure returns (address) {
1581         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1582         _throwError(error);
1583         return recovered;
1584     }
1585 
1586     /**
1587      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1588      * `r` and `s` signature fields separately.
1589      *
1590      * _Available since v4.3._
1591      */
1592     function tryRecover(
1593         bytes32 hash,
1594         uint8 v,
1595         bytes32 r,
1596         bytes32 s
1597     ) internal pure returns (address, RecoverError) {
1598         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1599         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1600         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1601         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1602         //
1603         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1604         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1605         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1606         // these malleable signatures as well.
1607         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1608             return (address(0), RecoverError.InvalidSignatureS);
1609         }
1610         if (v != 27 && v != 28) {
1611             return (address(0), RecoverError.InvalidSignatureV);
1612         }
1613 
1614         // If the signature is valid (and not malleable), return the signer address
1615         address signer = ecrecover(hash, v, r, s);
1616         if (signer == address(0)) {
1617             return (address(0), RecoverError.InvalidSignature);
1618         }
1619 
1620         return (signer, RecoverError.NoError);
1621     }
1622 
1623     /**
1624      * @dev Overload of {ECDSA-recover} that receives the `v`,
1625      * `r` and `s` signature fields separately.
1626      */
1627     function recover(
1628         bytes32 hash,
1629         uint8 v,
1630         bytes32 r,
1631         bytes32 s
1632     ) internal pure returns (address) {
1633         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1634         _throwError(error);
1635         return recovered;
1636     }
1637 
1638     /**
1639      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1640      * produces hash corresponding to the one signed with the
1641      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1642      * JSON-RPC method as part of EIP-191.
1643      *
1644      * See {recover}.
1645      */
1646     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1647         // 32 is the length in bytes of hash,
1648         // enforced by the type signature above
1649         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1650     }
1651 
1652     /**
1653      * @dev Returns an Ethereum Signed Typed Data, created from a
1654      * `domainSeparator` and a `structHash`. This produces hash corresponding
1655      * to the one signed with the
1656      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1657      * JSON-RPC method as part of EIP-712.
1658      *
1659      * See {recover}.
1660      */
1661     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1662         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1663     }
1664 }
1665 
1666 abstract contract KinesisERC721Enumerable is ERC721Enumerable {
1667     function showTokenHashes(uint _tokenId) external view virtual returns (bytes32[] memory);
1668 }
1669 
1670 // SPDX-License-Identifier: MIT
1671 // File: contracts/Kinesis.sol
1672 pragma solidity ^0.8.0;
1673 
1674 contract Atlanta3D is ERC721Enumerable, Ownable {
1675     using SafeMath for uint256;
1676     using Strings for uint256;
1677     using ECDSA for bytes32;
1678 
1679     event Mint(
1680         address indexed _to,
1681         uint256 indexed _tokenId
1682     );
1683     uint256 constant ONE_MILLION = 1_000_000;
1684     uint256 public tokenIdStart = 0;
1685     uint256 public tokenIdEnd = 3599;
1686     uint256 public numTokens = 3600;
1687     uint256 public numClaimed = 0;
1688 
1689     bool public active = false;
1690     string public projectName = "Atlanta3D";
1691     string public artist = "Grant.oe";
1692     string public website = "";
1693     string public description = "";
1694     string public script = "";
1695     string public projectBaseURI = "";
1696 
1697     address public kinesisContractAddress = 0xeb113c5d09bfc3a7b27A75Da4432FB3484f90c6A;
1698     KinesisERC721Enumerable public kinesisContract;
1699     mapping(uint256 => bool) public tokenIdClaimed;
1700 
1701     mapping(uint256 => bytes32[]) internal tokenIdToHashes;
1702 
1703     address public admin;
1704     mapping(address => bool) public isAuthorized;
1705 
1706     modifier onlyValidTokenId(uint256 _tokenId) {
1707         require(_exists(_tokenId), "Token ID does not exist");
1708         _;
1709     }
1710 
1711     modifier onlyAdmin() {
1712         require(msg.sender == admin, "Only admin");
1713         _;
1714     }
1715 
1716     modifier onlyAuthorized() {
1717         require(isAuthorized[msg.sender], "Only authorized");
1718         _;
1719     }
1720 
1721     constructor() ERC721("Atlanta3D", "ATLANTA3D") {
1722         transferOwnership(msg.sender);
1723         admin = msg.sender;
1724         isAuthorized[msg.sender] = true;
1725         kinesisContract = KinesisERC721Enumerable(kinesisContractAddress);
1726     }
1727 
1728     /// @notice Claim Atlanta3D for given Atlanta token
1729     /// @param tokenId The tokenId of the Atlanta NFT
1730     function claimById(uint256 tokenId) external {
1731         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
1732         // attacks
1733 
1734         // Checks
1735 
1736         // Check that the msgSender owns the token that is being claimed
1737         require(
1738             _msgSender() == kinesisContract.ownerOf(tokenId),
1739             "MUST_OWN_TOKEN_ID"
1740         );
1741 
1742         // Further Checks, Effects, and Interactions are contained within the
1743         // _claim() function
1744         _claim(tokenId, _msgSender());
1745     }
1746     
1747     /// @notice Claim Atlanta3D for all Atlanta tokens owned by the sender
1748     /// @notice This function will run out of gas if you have too many Atlantas! If
1749     /// this is a concern, you should use claimRangeForOwner and claim Atlanta3D in batches.
1750     function claimAllForOwner() external {
1751         uint256 tokenBalanceOwner = kinesisContract.balanceOf(_msgSender());
1752 
1753         // Checks
1754         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
1755         uint256 tokenId;
1756         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
1757         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
1758             // Further Checks, Effects, and Interactions are contained within
1759             // the _claim() function
1760             tokenId = kinesisContract.tokenOfOwnerByIndex(_msgSender(), i);
1761             if (tokenId < ONE_MILLION) {
1762                 _claim(
1763                     tokenId,
1764                     _msgSender()
1765                 );
1766             }
1767         }
1768     }
1769 
1770     /// @notice Claim Atlanta3D for all tokens owned by the sender within a
1771     /// given range
1772     /// @notice This function is useful if you own too much bloot to claim all at
1773     /// once or if you want to leave some bloot unclaimed. If you leave bloot
1774     /// unclaimed, however, you cannot claim it once the next season starts.
1775     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
1776         external
1777     {
1778         uint256 tokenBalanceOwner = kinesisContract.balanceOf(_msgSender());
1779 
1780         // Checks
1781         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
1782 
1783         // We use < for ownerIndexEnd and tokenBalanceOwner because
1784         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
1785         require(
1786             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
1787             "INDEX_OUT_OF_RANGE"
1788         );
1789         
1790         uint256 tokenId;
1791         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
1792         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
1793             // Further Checks, Effects, and Interactions are contained within
1794             // the _claim() function
1795             tokenId = kinesisContract.tokenOfOwnerByIndex(_msgSender(), i);
1796             if (tokenId < ONE_MILLION) {
1797                 _claim(
1798                     tokenId,
1799                     _msgSender()
1800                 );
1801             }
1802         }
1803     }
1804 
1805     /// @dev Internal function to mint Atlanta3D upon claiming
1806     function _claim(uint256 tokenId, address tokenOwner) internal {
1807         // Checks
1808         // Check that the token ID is in range
1809         // We use >= and <= to here because all of the token IDs are 0-indexed
1810         require(
1811             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
1812             "TOKEN_ID_OUT_OF_RANGE"
1813         );
1814         
1815         require(
1816             active, "Project not active!"
1817         );
1818 
1819         // Check that Atlanta3D has not already been claimed for a given tokenId
1820         require(
1821             !tokenIdClaimed[tokenId],
1822             "TOKEN_ALREADY_CLAIMED"
1823         );
1824 
1825         // Effects
1826 
1827         // Mark that Atlanta3D has been claimed for this season for the
1828         // given tokenId
1829         tokenIdClaimed[tokenId] = true;
1830         numClaimed = numClaimed + 1;
1831         tokenIdToHashes[tokenId] = kinesisContract.showTokenHashes(tokenId);
1832         // Interactions
1833 
1834         // Send Atlanta3D to the owner of the token ID
1835         _safeMint(tokenOwner, tokenId);
1836 
1837         emit Mint(tokenOwner, tokenId);
1838     }
1839 
1840     function addAuthorized(address _address) public onlyAdmin {
1841         isAuthorized[_address] = true;
1842     }
1843 
1844     function removeAuthorized(address _address) public onlyAdmin {
1845         isAuthorized[_address] = false;
1846     }
1847 
1848     function toggleProjectIsActive() public onlyAuthorized {
1849         active = !active;
1850     }
1851 
1852     function updateProjectName(string memory _projectName) onlyAuthorized external {
1853         projectName = _projectName;
1854     }
1855 
1856     function updateProjectArtistName(string memory _projectArtistName) onlyAuthorized external {
1857         artist = _projectArtistName;
1858     }
1859 
1860     function updateProjectDescription(string memory _projectDescription) onlyAuthorized external {
1861         description = _projectDescription;
1862     }
1863 
1864     function updateProjectWebsite(string memory _projectWebsite) onlyAuthorized external {
1865         website = _projectWebsite;
1866     }
1867 
1868     function setProjectScript(string memory _script) onlyAuthorized() external {
1869         script = _script;
1870     }
1871 
1872     function updateProjectBaseURI(string memory _newBaseURI) onlyAuthorized external {
1873         projectBaseURI = _newBaseURI;
1874     }
1875 
1876     function showTokenHashes(uint _tokenId) public view returns (bytes32[] memory){
1877         return tokenIdToHashes[_tokenId];
1878     }
1879 
1880     function tokenURI(uint256 _tokenId) public view virtual override onlyValidTokenId(_tokenId) returns (string memory) {
1881         return string(abi.encodePacked(projectBaseURI, Strings.toString(_tokenId)));
1882     }
1883 
1884     function transferOwnership(address newOwner) public override onlyOwner {
1885         require(newOwner != address(0), "Ownable: new owner is the zero address");
1886         admin = newOwner;
1887         isAuthorized[newOwner] = true;
1888         super.transferOwnership(newOwner);
1889     }
1890 }