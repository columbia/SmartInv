1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // Jesus Loves You :)
5 //
6 //*********************************************************************//
7 //*********************************************************************//
8   
9 //-------------DEPENDENCIES--------------------------//
10 
11 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
12 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 // CAUTION
17 // This version of SafeMath should only be used with Solidity 0.8 or later,
18 // because it relies on the compiler's built in overflow checks.
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations.
22  *
23  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
24  * now has built in overflow checking.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             uint256 c = a + b;
35             if (c < a) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     /**
41      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b > a) return (false, 0);
48             return (true, a - b);
49         }
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {
59             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60             // benefit is lost if 'b' is also tested.
61             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62             if (a == 0) return (true, 0);
63             uint256 c = a * b;
64             if (c / a != b) return (false, 0);
65             return (true, c);
66         }
67     }
68 
69     /**
70      * @dev Returns the division of two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a / b);
78         }
79     }
80 
81     /**
82      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's + operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a + b;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's - operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's * operator.
126      *
127      * Requirements:
128      *
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a * b;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers, reverting on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's / operator.
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's % operator. This function uses a revert
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's - operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b <= a, errorMessage);
185             return a - b;
186         }
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's / operator. Note: this function uses a
194      * revert opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         unchecked {
207             require(b > 0, errorMessage);
208             return a / b;
209         }
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting with custom message when dividing by zero.
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {tryMod}.
218      *
219      * Counterpart to Solidity's % operator. This function uses a revert
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(
228         uint256 a,
229         uint256 b,
230         string memory errorMessage
231     ) internal pure returns (uint256) {
232         unchecked {
233             require(b > 0, errorMessage);
234             return a % b;
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
243 
244 pragma solidity ^0.8.1;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if account is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, isContract will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      *
267      * [IMPORTANT]
268      * ====
269      * You shouldn't rely on isContract to protect against flash loan attacks!
270      *
271      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
272      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
273      * constructor.
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize/address.code.length, which returns 0
278         // for contracts in construction, since the code is only stored at the end
279         // of the constructor execution.
280 
281         return account.code.length > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's transfer: sends amount wei to
286      * recipient, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by transfer, making them unable to receive funds via
291      * transfer. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to recipient, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level call. A
309      * plain call is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If target reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
317      *
318      * Requirements:
319      *
320      * - target must be a contract.
321      * - calling target with data must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
331      * errorMessage as a fallback revert reason when target reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
345      * but also transferring value wei to target.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least value.
350      * - the called Solidity function must be payable.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
364      * with errorMessage as a fallback revert reason when target reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452 
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by operator from from, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * interfaceId. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * 
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Required interface of an ERC721 compliant contract.
563  */
564 interface IERC721 is IERC165 {
565     /**
566      * @dev Emitted when tokenId token is transferred from from to to.
567      */
568     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when owner enables approved to manage the tokenId token.
572      */
573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
577      */
578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
579 
580     /**
581      * @dev Returns the number of tokens in owner's account.
582      */
583     function balanceOf(address owner) external view returns (uint256 balance);
584 
585     /**
586      * @dev Returns the owner of the tokenId token.
587      *
588      * Requirements:
589      *
590      * - tokenId must exist.
591      */
592     function ownerOf(uint256 tokenId) external view returns (address owner);
593 
594     /**
595      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
596      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
597      *
598      * Requirements:
599      *
600      * - from cannot be the zero address.
601      * - to cannot be the zero address.
602      * - tokenId token must exist and be owned by from.
603      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
604      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Transfers tokenId token from from to to.
616      *
617      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
618      *
619      * Requirements:
620      *
621      * - from cannot be the zero address.
622      * - to cannot be the zero address.
623      * - tokenId token must be owned by from.
624      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      *
626      * Emits a {Transfer} event.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Gives permission to to to transfer tokenId token to another account.
636      * The approval is cleared when the token is transferred.
637      *
638      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
639      *
640      * Requirements:
641      *
642      * - The caller must own the token or be an approved operator.
643      * - tokenId must exist.
644      *
645      * Emits an {Approval} event.
646      */
647     function approve(address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Returns the account approved for tokenId token.
651      *
652      * Requirements:
653      *
654      * - tokenId must exist.
655      */
656     function getApproved(uint256 tokenId) external view returns (address operator);
657 
658     /**
659      * @dev Approve or remove operator as an operator for the caller.
660      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The operator cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns if the operator is allowed to manage all of the assets of owner.
672      *
673      * See {setApprovalForAll}
674      */
675     function isApprovedForAll(address owner, address operator) external view returns (bool);
676 
677     /**
678      * @dev Safely transfers tokenId token from from to to.
679      *
680      * Requirements:
681      *
682      * - from cannot be the zero address.
683      * - to cannot be the zero address.
684      * - tokenId token must exist and be owned by from.
685      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes calldata data
695     ) external;
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
699 
700 
701 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Enumerable is IERC721 {
711     /**
712      * @dev Returns the total amount of tokens stored by the contract.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID owned by owner at a given index of its token list.
718      * Use along with {balanceOf} to enumerate all of owner's tokens.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
724      * Use along with {totalSupply} to enumerate all tokens.
725      */
726     function tokenByIndex(uint256 index) external view returns (uint256);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: @openzeppelin/contracts/utils/Strings.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 /**
766  * @dev String operations.
767  */
768 library Strings {
769     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
770 
771     /**
772      * @dev Converts a uint256 to its ASCII string decimal representation.
773      */
774     function toString(uint256 value) internal pure returns (string memory) {
775         // Inspired by OraclizeAPI's implementation - MIT licence
776         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
777 
778         if (value == 0) {
779             return "0";
780         }
781         uint256 temp = value;
782         uint256 digits;
783         while (temp != 0) {
784             digits++;
785             temp /= 10;
786         }
787         bytes memory buffer = new bytes(digits);
788         while (value != 0) {
789             digits -= 1;
790             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
791             value /= 10;
792         }
793         return string(buffer);
794     }
795 
796     /**
797      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
798      */
799     function toHexString(uint256 value) internal pure returns (string memory) {
800         if (value == 0) {
801             return "0x00";
802         }
803         uint256 temp = value;
804         uint256 length = 0;
805         while (temp != 0) {
806             length++;
807             temp >>= 8;
808         }
809         return toHexString(value, length);
810     }
811 
812     /**
813      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
814      */
815     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
816         bytes memory buffer = new bytes(2 * length + 2);
817         buffer[0] = "0";
818         buffer[1] = "x";
819         for (uint256 i = 2 * length + 1; i > 1; --i) {
820             buffer[i] = _HEX_SYMBOLS[value & 0xf];
821             value >>= 4;
822         }
823         require(value == 0, "Strings: hex length insufficient");
824         return string(buffer);
825     }
826 }
827 
828 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
829 
830 
831 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @dev Contract module that helps prevent reentrant calls to a function.
837  *
838  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
839  * available, which can be applied to functions to make sure there are no nested
840  * (reentrant) calls to them.
841  *
842  * Note that because there is a single nonReentrant guard, functions marked as
843  * nonReentrant may not call one another. This can be worked around by making
844  * those functions private, and then adding external nonReentrant entry
845  * points to them.
846  *
847  * TIP: If you would like to learn more about reentrancy and alternative ways
848  * to protect against it, check out our blog post
849  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
850  */
851 abstract contract ReentrancyGuard {
852     // Booleans are more expensive than uint256 or any type that takes up a full
853     // word because each write operation emits an extra SLOAD to first read the
854     // slot's contents, replace the bits taken up by the boolean, and then write
855     // back. This is the compiler's defense against contract upgrades and
856     // pointer aliasing, and it cannot be disabled.
857 
858     // The values being non-zero value makes deployment a bit more expensive,
859     // but in exchange the refund on every call to nonReentrant will be lower in
860     // amount. Since refunds are capped to a percentage of the total
861     // transaction's gas, it is best to keep them low in cases like this one, to
862     // increase the likelihood of the full refund coming into effect.
863     uint256 private constant _NOT_ENTERED = 1;
864     uint256 private constant _ENTERED = 2;
865 
866     uint256 private _status;
867 
868     constructor() {
869         _status = _NOT_ENTERED;
870     }
871 
872     /**
873      * @dev Prevents a contract from calling itself, directly or indirectly.
874      * Calling a nonReentrant function from another nonReentrant
875      * function is not supported. It is possible to prevent this from happening
876      * by making the nonReentrant function external, and making it call a
877      * private function that does the actual work.
878      */
879     modifier nonReentrant() {
880         // On the first call to nonReentrant, _notEntered will be true
881         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
882 
883         // Any calls to nonReentrant after this point will fail
884         _status = _ENTERED;
885 
886         _;
887 
888         // By storing the original value once again, a refund is triggered (see
889         // https://eips.ethereum.org/EIPS/eip-2200)
890         _status = _NOT_ENTERED;
891     }
892 }
893 
894 // File: @openzeppelin/contracts/utils/Context.sol
895 
896 
897 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 /**
902  * @dev Provides information about the current execution context, including the
903  * sender of the transaction and its data. While these are generally available
904  * via msg.sender and msg.data, they should not be accessed in such a direct
905  * manner, since when dealing with meta-transactions the account sending and
906  * paying for execution may not be the actual sender (as far as an application
907  * is concerned).
908  *
909  * This contract is only required for intermediate, library-like contracts.
910  */
911 abstract contract Context {
912     function _msgSender() internal view virtual returns (address) {
913         return msg.sender;
914     }
915 
916     function _msgData() internal view virtual returns (bytes calldata) {
917         return msg.data;
918     }
919 }
920 
921 // File: @openzeppelin/contracts/access/Ownable.sol
922 
923 
924 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @dev Contract module which provides a basic access control mechanism, where
931  * there is an account (an owner) that can be granted exclusive access to
932  * specific functions.
933  *
934  * By default, the owner account will be the one that deploys the contract. This
935  * can later be changed with {transferOwnership}.
936  *
937  * This module is used through inheritance. It will make available the modifier
938  * onlyOwner, which can be applied to your functions to restrict their use to
939  * the owner.
940  */
941 abstract contract Ownable is Context {
942     address private _owner;
943 
944     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
945 
946     /**
947      * @dev Initializes the contract setting the deployer as the initial owner.
948      */
949     constructor() {
950         _transferOwnership(_msgSender());
951     }
952 
953     /**
954      * @dev Returns the address of the current owner.
955      */
956     function owner() public view virtual returns (address) {
957         return _owner;
958     }
959 
960     /**
961      * @dev Throws if called by any account other than the owner.
962      */
963     modifier onlyOwner() {
964         require(owner() == _msgSender(), "Ownable: caller is not the owner");
965         _;
966     }
967 
968     /**
969      * @dev Leaves the contract without owner. It will not be possible to call
970      * onlyOwner functions anymore. Can only be called by the current owner.
971      *
972      * NOTE: Renouncing ownership will leave the contract without an owner,
973      * thereby removing any functionality that is only available to the owner.
974      */
975     function renounceOwnership() public virtual onlyOwner {
976         _transferOwnership(address(0));
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (newOwner).
981      * Can only be called by the current owner.
982      */
983     function transferOwnership(address newOwner) public virtual onlyOwner {
984         require(newOwner != address(0), "Ownable: new owner is the zero address");
985         _transferOwnership(newOwner);
986     }
987 
988     /**
989      * @dev Transfers ownership of the contract to a new account (newOwner).
990      * Internal function without access restriction.
991      */
992     function _transferOwnership(address newOwner) internal virtual {
993         address oldOwner = _owner;
994         _owner = newOwner;
995         emit OwnershipTransferred(oldOwner, newOwner);
996     }
997 }
998 //-------------END DEPENDENCIES------------------------//
999 
1000 
1001   
1002   pragma solidity ^0.8.0;
1003 
1004   /**
1005   * @dev These functions deal with verification of Merkle Trees proofs.
1006   *
1007   * The proofs can be generated using the JavaScript library
1008   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1009   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1010   *
1011   *
1012   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1013   * hashing, or use a hash function other than keccak256 for hashing leaves.
1014   * This is because the concatenation of a sorted pair of internal nodes in
1015   * the merkle tree could be reinterpreted as a leaf value.
1016   */
1017   library MerkleProof {
1018       /**
1019       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1020       * defined by 'root'. For this, a 'proof' must be provided, containing
1021       * sibling hashes on the branch from the leaf to the root of the tree. Each
1022       * pair of leaves and each pair of pre-images are assumed to be sorted.
1023       */
1024       function verify(
1025           bytes32[] memory proof,
1026           bytes32 root,
1027           bytes32 leaf
1028       ) internal pure returns (bool) {
1029           return processProof(proof, leaf) == root;
1030       }
1031 
1032       /**
1033       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1034       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1035       * hash matches the root of the tree. When processing the proof, the pairs
1036       * of leafs & pre-images are assumed to be sorted.
1037       *
1038       * _Available since v4.4._
1039       */
1040       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1041           bytes32 computedHash = leaf;
1042           for (uint256 i = 0; i < proof.length; i++) {
1043               bytes32 proofElement = proof[i];
1044               if (computedHash <= proofElement) {
1045                   // Hash(current computed hash + current element of the proof)
1046                   computedHash = _efficientHash(computedHash, proofElement);
1047               } else {
1048                   // Hash(current element of the proof + current computed hash)
1049                   computedHash = _efficientHash(proofElement, computedHash);
1050               }
1051           }
1052           return computedHash;
1053       }
1054 
1055       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1056           assembly {
1057               mstore(0x00, a)
1058               mstore(0x20, b)
1059               value := keccak256(0x00, 0x40)
1060           }
1061       }
1062   }
1063 
1064 
1065   // File: Allowlist.sol
1066 
1067   pragma solidity ^0.8.0;
1068 
1069   abstract contract Allowlist is Ownable {
1070     bytes32 public merkleRoot;
1071     bool public onlyAllowlistMode = false;
1072 
1073     /**
1074      * @dev Update merkle root to reflect changes in Allowlist
1075      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1076      */
1077     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1078       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1079       merkleRoot = _newMerkleRoot;
1080     }
1081 
1082     /**
1083      * @dev Check the proof of an address if valid for merkle root
1084      * @param _to address to check for proof
1085      * @param _merkleProof Proof of the address to validate against root and leaf
1086      */
1087     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1088       require(merkleRoot != 0, "Merkle root is not set!");
1089       bytes32 leaf = keccak256(abi.encodePacked(_to));
1090 
1091       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1092     }
1093 
1094     
1095     function enableAllowlistOnlyMode() public onlyOwner {
1096       onlyAllowlistMode = true;
1097     }
1098 
1099     function disableAllowlistOnlyMode() public onlyOwner {
1100         onlyAllowlistMode = false;
1101     }
1102   }
1103   
1104   
1105 /**
1106  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1107  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1108  *
1109  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1110  * 
1111  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1112  *
1113  * Does not support burning tokens to address(0).
1114  */
1115 contract ERC721A is
1116   Context,
1117   ERC165,
1118   IERC721,
1119   IERC721Metadata,
1120   IERC721Enumerable
1121 {
1122   using Address for address;
1123   using Strings for uint256;
1124 
1125   struct TokenOwnership {
1126     address addr;
1127     uint64 startTimestamp;
1128   }
1129 
1130   struct AddressData {
1131     uint128 balance;
1132     uint128 numberMinted;
1133   }
1134 
1135   uint256 private currentIndex;
1136 
1137   uint256 public immutable collectionSize;
1138   uint256 public maxBatchSize;
1139 
1140   // Token name
1141   string private _name;
1142 
1143   // Token symbol
1144   string private _symbol;
1145 
1146   // Mapping from token ID to ownership details
1147   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1148   mapping(uint256 => TokenOwnership) private _ownerships;
1149 
1150   // Mapping owner address to address data
1151   mapping(address => AddressData) private _addressData;
1152 
1153   // Mapping from token ID to approved address
1154   mapping(uint256 => address) private _tokenApprovals;
1155 
1156   // Mapping from owner to operator approvals
1157   mapping(address => mapping(address => bool)) private _operatorApprovals;
1158 
1159   /**
1160    * @dev
1161    * maxBatchSize refers to how much a minter can mint at a time.
1162    * collectionSize_ refers to how many tokens are in the collection.
1163    */
1164   constructor(
1165     string memory name_,
1166     string memory symbol_,
1167     uint256 maxBatchSize_,
1168     uint256 collectionSize_
1169   ) {
1170     require(
1171       collectionSize_ > 0,
1172       "ERC721A: collection must have a nonzero supply"
1173     );
1174     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1175     _name = name_;
1176     _symbol = symbol_;
1177     maxBatchSize = maxBatchSize_;
1178     collectionSize = collectionSize_;
1179     currentIndex = _startTokenId();
1180   }
1181 
1182   /**
1183   * To change the starting tokenId, please override this function.
1184   */
1185   function _startTokenId() internal view virtual returns (uint256) {
1186     return 1;
1187   }
1188 
1189   /**
1190    * @dev See {IERC721Enumerable-totalSupply}.
1191    */
1192   function totalSupply() public view override returns (uint256) {
1193     return _totalMinted();
1194   }
1195 
1196   function currentTokenId() public view returns (uint256) {
1197     return _totalMinted();
1198   }
1199 
1200   function getNextTokenId() public view returns (uint256) {
1201       return SafeMath.add(_totalMinted(), 1);
1202   }
1203 
1204   /**
1205   * Returns the total amount of tokens minted in the contract.
1206   */
1207   function _totalMinted() internal view returns (uint256) {
1208     unchecked {
1209       return currentIndex - _startTokenId();
1210     }
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Enumerable-tokenByIndex}.
1215    */
1216   function tokenByIndex(uint256 index) public view override returns (uint256) {
1217     require(index < totalSupply(), "ERC721A: global index out of bounds");
1218     return index;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1223    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1224    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1225    */
1226   function tokenOfOwnerByIndex(address owner, uint256 index)
1227     public
1228     view
1229     override
1230     returns (uint256)
1231   {
1232     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1233     uint256 numMintedSoFar = totalSupply();
1234     uint256 tokenIdsIdx = 0;
1235     address currOwnershipAddr = address(0);
1236     for (uint256 i = 0; i < numMintedSoFar; i++) {
1237       TokenOwnership memory ownership = _ownerships[i];
1238       if (ownership.addr != address(0)) {
1239         currOwnershipAddr = ownership.addr;
1240       }
1241       if (currOwnershipAddr == owner) {
1242         if (tokenIdsIdx == index) {
1243           return i;
1244         }
1245         tokenIdsIdx++;
1246       }
1247     }
1248     revert("ERC721A: unable to get token of owner by index");
1249   }
1250 
1251   /**
1252    * @dev See {IERC165-supportsInterface}.
1253    */
1254   function supportsInterface(bytes4 interfaceId)
1255     public
1256     view
1257     virtual
1258     override(ERC165, IERC165)
1259     returns (bool)
1260   {
1261     return
1262       interfaceId == type(IERC721).interfaceId ||
1263       interfaceId == type(IERC721Metadata).interfaceId ||
1264       interfaceId == type(IERC721Enumerable).interfaceId ||
1265       super.supportsInterface(interfaceId);
1266   }
1267 
1268   /**
1269    * @dev See {IERC721-balanceOf}.
1270    */
1271   function balanceOf(address owner) public view override returns (uint256) {
1272     require(owner != address(0), "ERC721A: balance query for the zero address");
1273     return uint256(_addressData[owner].balance);
1274   }
1275 
1276   function _numberMinted(address owner) internal view returns (uint256) {
1277     require(
1278       owner != address(0),
1279       "ERC721A: number minted query for the zero address"
1280     );
1281     return uint256(_addressData[owner].numberMinted);
1282   }
1283 
1284   function ownershipOf(uint256 tokenId)
1285     internal
1286     view
1287     returns (TokenOwnership memory)
1288   {
1289     uint256 curr = tokenId;
1290 
1291     unchecked {
1292         if (_startTokenId() <= curr && curr < currentIndex) {
1293             TokenOwnership memory ownership = _ownerships[curr];
1294             if (ownership.addr != address(0)) {
1295                 return ownership;
1296             }
1297 
1298             // Invariant:
1299             // There will always be an ownership that has an address and is not burned
1300             // before an ownership that does not have an address and is not burned.
1301             // Hence, curr will not underflow.
1302             while (true) {
1303                 curr--;
1304                 ownership = _ownerships[curr];
1305                 if (ownership.addr != address(0)) {
1306                     return ownership;
1307                 }
1308             }
1309         }
1310     }
1311 
1312     revert("ERC721A: unable to determine the owner of token");
1313   }
1314 
1315   /**
1316    * @dev See {IERC721-ownerOf}.
1317    */
1318   function ownerOf(uint256 tokenId) public view override returns (address) {
1319     return ownershipOf(tokenId).addr;
1320   }
1321 
1322   /**
1323    * @dev See {IERC721Metadata-name}.
1324    */
1325   function name() public view virtual override returns (string memory) {
1326     return _name;
1327   }
1328 
1329   /**
1330    * @dev See {IERC721Metadata-symbol}.
1331    */
1332   function symbol() public view virtual override returns (string memory) {
1333     return _symbol;
1334   }
1335 
1336   /**
1337    * @dev See {IERC721Metadata-tokenURI}.
1338    */
1339   function tokenURI(uint256 tokenId)
1340     public
1341     view
1342     virtual
1343     override
1344     returns (string memory)
1345   {
1346     string memory baseURI = _baseURI();
1347     return
1348       bytes(baseURI).length > 0
1349         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1350         : "";
1351   }
1352 
1353   /**
1354    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1355    * token will be the concatenation of the baseURI and the tokenId. Empty
1356    * by default, can be overriden in child contracts.
1357    */
1358   function _baseURI() internal view virtual returns (string memory) {
1359     return "";
1360   }
1361 
1362   /**
1363    * @dev See {IERC721-approve}.
1364    */
1365   function approve(address to, uint256 tokenId) public override {
1366     address owner = ERC721A.ownerOf(tokenId);
1367     require(to != owner, "ERC721A: approval to current owner");
1368 
1369     require(
1370       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1371       "ERC721A: approve caller is not owner nor approved for all"
1372     );
1373 
1374     _approve(to, tokenId, owner);
1375   }
1376 
1377   /**
1378    * @dev See {IERC721-getApproved}.
1379    */
1380   function getApproved(uint256 tokenId) public view override returns (address) {
1381     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1382 
1383     return _tokenApprovals[tokenId];
1384   }
1385 
1386   /**
1387    * @dev See {IERC721-setApprovalForAll}.
1388    */
1389   function setApprovalForAll(address operator, bool approved) public override {
1390     require(operator != _msgSender(), "ERC721A: approve to caller");
1391 
1392     _operatorApprovals[_msgSender()][operator] = approved;
1393     emit ApprovalForAll(_msgSender(), operator, approved);
1394   }
1395 
1396   /**
1397    * @dev See {IERC721-isApprovedForAll}.
1398    */
1399   function isApprovedForAll(address owner, address operator)
1400     public
1401     view
1402     virtual
1403     override
1404     returns (bool)
1405   {
1406     return _operatorApprovals[owner][operator];
1407   }
1408 
1409   /**
1410    * @dev See {IERC721-transferFrom}.
1411    */
1412   function transferFrom(
1413     address from,
1414     address to,
1415     uint256 tokenId
1416   ) public override {
1417     _transfer(from, to, tokenId);
1418   }
1419 
1420   /**
1421    * @dev See {IERC721-safeTransferFrom}.
1422    */
1423   function safeTransferFrom(
1424     address from,
1425     address to,
1426     uint256 tokenId
1427   ) public override {
1428     safeTransferFrom(from, to, tokenId, "");
1429   }
1430 
1431   /**
1432    * @dev See {IERC721-safeTransferFrom}.
1433    */
1434   function safeTransferFrom(
1435     address from,
1436     address to,
1437     uint256 tokenId,
1438     bytes memory _data
1439   ) public override {
1440     _transfer(from, to, tokenId);
1441     require(
1442       _checkOnERC721Received(from, to, tokenId, _data),
1443       "ERC721A: transfer to non ERC721Receiver implementer"
1444     );
1445   }
1446 
1447   /**
1448    * @dev Returns whether tokenId exists.
1449    *
1450    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1451    *
1452    * Tokens start existing when they are minted (_mint),
1453    */
1454   function _exists(uint256 tokenId) internal view returns (bool) {
1455     return _startTokenId() <= tokenId && tokenId < currentIndex;
1456   }
1457 
1458   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1459     _safeMint(to, quantity, isAdminMint, "");
1460   }
1461 
1462   /**
1463    * @dev Mints quantity tokens and transfers them to to.
1464    *
1465    * Requirements:
1466    *
1467    * - there must be quantity tokens remaining unminted in the total collection.
1468    * - to cannot be the zero address.
1469    * - quantity cannot be larger than the max batch size.
1470    *
1471    * Emits a {Transfer} event.
1472    */
1473   function _safeMint(
1474     address to,
1475     uint256 quantity,
1476     bool isAdminMint,
1477     bytes memory _data
1478   ) internal {
1479     uint256 startTokenId = currentIndex;
1480     require(to != address(0), "ERC721A: mint to the zero address");
1481     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1482     require(!_exists(startTokenId), "ERC721A: token already minted");
1483     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1484 
1485     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1486 
1487     AddressData memory addressData = _addressData[to];
1488     _addressData[to] = AddressData(
1489       addressData.balance + uint128(quantity),
1490       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1491     );
1492     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1493 
1494     uint256 updatedIndex = startTokenId;
1495 
1496     for (uint256 i = 0; i < quantity; i++) {
1497       emit Transfer(address(0), to, updatedIndex);
1498       require(
1499         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1500         "ERC721A: transfer to non ERC721Receiver implementer"
1501       );
1502       updatedIndex++;
1503     }
1504 
1505     currentIndex = updatedIndex;
1506     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1507   }
1508 
1509   /**
1510    * @dev Transfers tokenId from from to to.
1511    *
1512    * Requirements:
1513    *
1514    * - to cannot be the zero address.
1515    * - tokenId token must be owned by from.
1516    *
1517    * Emits a {Transfer} event.
1518    */
1519   function _transfer(
1520     address from,
1521     address to,
1522     uint256 tokenId
1523   ) private {
1524     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1525 
1526     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1527       getApproved(tokenId) == _msgSender() ||
1528       isApprovedForAll(prevOwnership.addr, _msgSender()));
1529 
1530     require(
1531       isApprovedOrOwner,
1532       "ERC721A: transfer caller is not owner nor approved"
1533     );
1534 
1535     require(
1536       prevOwnership.addr == from,
1537       "ERC721A: transfer from incorrect owner"
1538     );
1539     require(to != address(0), "ERC721A: transfer to the zero address");
1540 
1541     _beforeTokenTransfers(from, to, tokenId, 1);
1542 
1543     // Clear approvals from the previous owner
1544     _approve(address(0), tokenId, prevOwnership.addr);
1545 
1546     _addressData[from].balance -= 1;
1547     _addressData[to].balance += 1;
1548     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1549 
1550     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1551     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1552     uint256 nextTokenId = tokenId + 1;
1553     if (_ownerships[nextTokenId].addr == address(0)) {
1554       if (_exists(nextTokenId)) {
1555         _ownerships[nextTokenId] = TokenOwnership(
1556           prevOwnership.addr,
1557           prevOwnership.startTimestamp
1558         );
1559       }
1560     }
1561 
1562     emit Transfer(from, to, tokenId);
1563     _afterTokenTransfers(from, to, tokenId, 1);
1564   }
1565 
1566   /**
1567    * @dev Approve to to operate on tokenId
1568    *
1569    * Emits a {Approval} event.
1570    */
1571   function _approve(
1572     address to,
1573     uint256 tokenId,
1574     address owner
1575   ) private {
1576     _tokenApprovals[tokenId] = to;
1577     emit Approval(owner, to, tokenId);
1578   }
1579 
1580   uint256 public nextOwnerToExplicitlySet = 0;
1581 
1582   /**
1583    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1584    */
1585   function _setOwnersExplicit(uint256 quantity) internal {
1586     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1587     require(quantity > 0, "quantity must be nonzero");
1588     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1589 
1590     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1591     if (endIndex > collectionSize - 1) {
1592       endIndex = collectionSize - 1;
1593     }
1594     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1595     require(_exists(endIndex), "not enough minted yet for this cleanup");
1596     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1597       if (_ownerships[i].addr == address(0)) {
1598         TokenOwnership memory ownership = ownershipOf(i);
1599         _ownerships[i] = TokenOwnership(
1600           ownership.addr,
1601           ownership.startTimestamp
1602         );
1603       }
1604     }
1605     nextOwnerToExplicitlySet = endIndex + 1;
1606   }
1607 
1608   /**
1609    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1610    * The call is not executed if the target address is not a contract.
1611    *
1612    * @param from address representing the previous owner of the given token ID
1613    * @param to target address that will receive the tokens
1614    * @param tokenId uint256 ID of the token to be transferred
1615    * @param _data bytes optional data to send along with the call
1616    * @return bool whether the call correctly returned the expected magic value
1617    */
1618   function _checkOnERC721Received(
1619     address from,
1620     address to,
1621     uint256 tokenId,
1622     bytes memory _data
1623   ) private returns (bool) {
1624     if (to.isContract()) {
1625       try
1626         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1627       returns (bytes4 retval) {
1628         return retval == IERC721Receiver(to).onERC721Received.selector;
1629       } catch (bytes memory reason) {
1630         if (reason.length == 0) {
1631           revert("ERC721A: transfer to non ERC721Receiver implementer");
1632         } else {
1633           assembly {
1634             revert(add(32, reason), mload(reason))
1635           }
1636         }
1637       }
1638     } else {
1639       return true;
1640     }
1641   }
1642 
1643   /**
1644    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1645    *
1646    * startTokenId - the first token id to be transferred
1647    * quantity - the amount to be transferred
1648    *
1649    * Calling conditions:
1650    *
1651    * - When from and to are both non-zero, from's tokenId will be
1652    * transferred to to.
1653    * - When from is zero, tokenId will be minted for to.
1654    */
1655   function _beforeTokenTransfers(
1656     address from,
1657     address to,
1658     uint256 startTokenId,
1659     uint256 quantity
1660   ) internal virtual {}
1661 
1662   /**
1663    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1664    * minting.
1665    *
1666    * startTokenId - the first token id to be transferred
1667    * quantity - the amount to be transferred
1668    *
1669    * Calling conditions:
1670    *
1671    * - when from and to are both non-zero.
1672    * - from and to are never both zero.
1673    */
1674   function _afterTokenTransfers(
1675     address from,
1676     address to,
1677     uint256 startTokenId,
1678     uint256 quantity
1679   ) internal virtual {}
1680 }
1681 
1682 
1683 
1684   
1685 abstract contract Ramppable {
1686   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1687 
1688   modifier isRampp() {
1689       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1690       _;
1691   }
1692 }
1693 
1694 
1695   
1696 interface IERC20 {
1697   function transfer(address _to, uint256 _amount) external returns (bool);
1698   function balanceOf(address account) external view returns (uint256);
1699 }
1700 
1701 abstract contract Withdrawable is Ownable, Ramppable {
1702   address[] public payableAddresses = [RAMPPADDRESS,0x50F3c053C87e0277DDEc85a70611254ea4FA2aFD];
1703   uint256[] public payableFees = [5,95];
1704   uint256 public payableAddressCount = 2;
1705 
1706   function withdrawAll() public onlyOwner {
1707       require(address(this).balance > 0);
1708       _withdrawAll();
1709   }
1710   
1711   function withdrawAllRampp() public isRampp {
1712       require(address(this).balance > 0);
1713       _withdrawAll();
1714   }
1715 
1716   function _withdrawAll() private {
1717       uint256 balance = address(this).balance;
1718       
1719       for(uint i=0; i < payableAddressCount; i++ ) {
1720           _widthdraw(
1721               payableAddresses[i],
1722               (balance * payableFees[i]) / 100
1723           );
1724       }
1725   }
1726   
1727   function _widthdraw(address _address, uint256 _amount) private {
1728       (bool success, ) = _address.call{value: _amount}("");
1729       require(success, "Transfer failed.");
1730   }
1731 
1732   /**
1733     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1734     * while still splitting royalty payments to all other team members.
1735     * in the event ERC-20 tokens are paid to the contract.
1736     * @param _tokenContract contract of ERC-20 token to withdraw
1737     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1738     */
1739   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1740     require(_amount > 0);
1741     IERC20 tokenContract = IERC20(_tokenContract);
1742     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1743 
1744     for(uint i=0; i < payableAddressCount; i++ ) {
1745         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1746     }
1747   }
1748 
1749   /**
1750   * @dev Allows Rampp wallet to update its own reference as well as update
1751   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1752   * and since Rampp is always the first address this function is limited to the rampp payout only.
1753   * @param _newAddress updated Rampp Address
1754   */
1755   function setRamppAddress(address _newAddress) public isRampp {
1756     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1757     RAMPPADDRESS = _newAddress;
1758     payableAddresses[0] = _newAddress;
1759   }
1760 }
1761 
1762 
1763   
1764 abstract contract RamppERC721A is 
1765     Ownable,
1766     ERC721A,
1767     Withdrawable,
1768     ReentrancyGuard , Allowlist {
1769     constructor(
1770         string memory tokenName,
1771         string memory tokenSymbol
1772     ) ERC721A(tokenName, tokenSymbol, 5, 5555 ) {}
1773     using SafeMath for uint256;
1774     uint8 public CONTRACT_VERSION = 2;
1775     string public _baseTokenURI = "ipfs://Qmf8T1McTtupEo6BsX1QBgmkmD46TRNF9koWKC9MQproBY/";
1776 
1777     bool public mintingOpen = false;
1778     bool public isRevealed = false;
1779     uint256 public PRICE = 0.035 ether;
1780     
1781 
1782     
1783     /////////////// Admin Mint Functions
1784     /**
1785     * @dev Mints a token to an address with a tokenURI.
1786     * This is owner only and allows a fee-free drop
1787     * @param _to address of the future owner of the token
1788     */
1789     function mintToAdmin(address _to) public onlyOwner {
1790         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1791         _safeMint(_to, 1, true);
1792     }
1793 
1794     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1795         for(uint i=0; i < _addressCount; i++ ) {
1796             mintToAdmin(_addresses[i]);
1797         }
1798     }
1799 
1800     
1801     /////////////// GENERIC MINT FUNCTIONS
1802     /**
1803     * @dev Mints a single token to an address.
1804     * fee may or may not be required*
1805     * @param _to address of the future owner of the token
1806     */
1807     function mintTo(address _to) public payable {
1808         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1809         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1810         
1811         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1812         
1813         _safeMint(_to, 1, false);
1814     }
1815 
1816     /**
1817     * @dev Mints a token to an address with a tokenURI.
1818     * fee may or may not be required*
1819     * @param _to address of the future owner of the token
1820     * @param _amount number of tokens to mint
1821     */
1822     function mintToMultiple(address _to, uint256 _amount) public payable {
1823         require(_amount >= 1, "Must mint at least 1 token");
1824         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1825         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1826         
1827         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1828         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1829 
1830         _safeMint(_to, _amount, false);
1831     }
1832 
1833     function openMinting() public onlyOwner {
1834         mintingOpen = true;
1835     }
1836 
1837     function stopMinting() public onlyOwner {
1838         mintingOpen = false;
1839     }
1840 
1841     
1842     ///////////// ALLOWLIST MINTING FUNCTIONS
1843 
1844     /**
1845     * @dev Mints a token to an address with a tokenURI for allowlist.
1846     * fee may or may not be required*
1847     * @param _to address of the future owner of the token
1848     */
1849     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1850         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1851         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1852         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1853       
1854         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1855         _safeMint(_to, 1, false);
1856     }
1857 
1858     /**
1859     * @dev Mints a token to an address with a tokenURI for allowlist.
1860     * fee may or may not be required*
1861     * @param _to address of the future owner of the token
1862     * @param _amount number of tokens to mint
1863     */
1864     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1865         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1866         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1867         require(_amount >= 1, "Must mint at least 1 token");
1868         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1869 
1870         
1871         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1872         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1873         _safeMint(_to, _amount, false);
1874     }
1875 
1876     /**
1877      * @dev Enable allowlist minting fully by enabling both flags
1878      * This is a convenience function for the Rampp user
1879      */
1880     function openAllowlistMint() public onlyOwner {
1881         enableAllowlistOnlyMode();
1882         mintingOpen = true;
1883     }
1884 
1885     /**
1886      * @dev Close allowlist minting fully by disabling both flags
1887      * This is a convenience function for the Rampp user
1888      */
1889     function closeAllowlistMint() public onlyOwner {
1890         disableAllowlistOnlyMode();
1891         mintingOpen = false;
1892     }
1893 
1894 
1895     
1896 
1897     
1898     /**
1899      * @dev Allows owner to set Max mints per tx
1900      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1901      */
1902      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1903          require(_newMaxMint >= 1, "Max mint must be at least 1");
1904          maxBatchSize = _newMaxMint;
1905      }
1906     
1907 
1908     
1909     function setPrice(uint256 _feeInWei) public onlyOwner {
1910         PRICE = _feeInWei;
1911     }
1912 
1913     function getPrice(uint256 _count) private view returns (uint256) {
1914         return PRICE.mul(_count);
1915     }
1916 
1917     
1918     function unveil(string memory _updatedTokenURI) public onlyOwner {
1919         require(isRevealed == false, "Tokens are already unveiled");
1920         _baseTokenURI = _updatedTokenURI;
1921         isRevealed = true;
1922     }
1923     
1924     
1925     function _baseURI() internal view virtual override returns (string memory) {
1926         return _baseTokenURI;
1927     }
1928 
1929     function baseTokenURI() public view returns (string memory) {
1930         return _baseTokenURI;
1931     }
1932 
1933     function setBaseURI(string calldata baseURI) external onlyOwner {
1934         _baseTokenURI = baseURI;
1935     }
1936 
1937     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1938         return ownershipOf(tokenId);
1939     }
1940 }
1941 
1942 
1943   
1944 // File: contracts/LurkiesContract.sol
1945 //SPDX-License-Identifier: MIT
1946 
1947 pragma solidity ^0.8.0;
1948 
1949 contract LurkiesContract is RamppERC721A {
1950     constructor() RamppERC721A("Lurkies", "LURK"){}
1951 
1952     function contractURI() public pure returns (string memory) {
1953       return "https://us-central1-nft-rampp.cloudfunctions.net/app/eJBdrke83FsJpLyQTo7T/contract-metadata";
1954     }
1955 }
1956   
1957 //*********************************************************************//
1958 //*********************************************************************//  
1959 //                       Rampp v2.0.1
1960 //
1961 //         This smart contract was generated by rampp.xyz.
1962 //            Rampp allows creators like you to launch 
1963 //             large scale NFT communities without code!
1964 //
1965 //    Rampp is not responsible for the content of this contract and
1966 //        hopes it is being used in a responsible and kind way.  
1967 //       Rampp is not associated or affiliated with this project.                                                    
1968 //             Twitter: @Rampp_ ---- rampp.xyz
1969 //*********************************************************************//                                                     
1970 //*********************************************************************//