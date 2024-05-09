1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _________  __              _____  _____   ______    ______  
5 // |  _   _  |[  |            |_   _||_   _|.' ___  | .' ___  | 
6 // |_/ | | \_| | |--.  .---.    | |    | | / .'   \_|/ .'   \_| 
7 //     | |     | .-. |/ /__\\   | '    ' | | |       | |        
8 //    _| |_    | | | || \__.,    \ \__/ /  \ `.___.'\\ `.___.'\ 
9 //   |_____|  [___]|__]'.__.'     `.__.'    `.____ .' `.____ .' 
10 //                                                              
11 //
12 //*********************************************************************//
13 //*********************************************************************//
14   
15 //-------------DEPENDENCIES--------------------------//
16 
17 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
18 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 // CAUTION
23 // This version of SafeMath should only be used with Solidity 0.8 or later,
24 // because it relies on the compiler's built in overflow checks.
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations.
28  *
29  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
30  * now has built in overflow checking.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             uint256 c = a + b;
41             if (c < a) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b > a) return (false, 0);
54             return (true, a - b);
55         }
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66             // benefit is lost if 'b' is also tested.
67             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68             if (a == 0) return (true, 0);
69             uint256 c = a * b;
70             if (c / a != b) return (false, 0);
71             return (true, c);
72         }
73     }
74 
75     /**
76      * @dev Returns the division of two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a / b);
84         }
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a % b);
96         }
97     }
98 
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's + operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a + b;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's - operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a - b;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's * operator.
132      *
133      * Requirements:
134      *
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a * b;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers, reverting on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's / operator.
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a / b;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * reverting when dividing by zero.
158      *
159      * Counterpart to Solidity's % operator. This function uses a revert
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a % b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * CAUTION: This function is deprecated because it requires allocating memory for the error
176      * message unnecessarily. For custom revert reasons use {trySub}.
177      *
178      * Counterpart to Solidity's - operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's / operator. Note: this function uses a
200      * revert opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a / b;
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting with custom message when dividing by zero.
221      *
222      * CAUTION: This function is deprecated because it requires allocating memory for the error
223      * message unnecessarily. For custom revert reasons use {tryMod}.
224      *
225      * Counterpart to Solidity's % operator. This function uses a revert
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a % b;
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
249 
250 pragma solidity ^0.8.1;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if account is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, isContract will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      *
273      * [IMPORTANT]
274      * ====
275      * You shouldn't rely on isContract to protect against flash loan attacks!
276      *
277      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
278      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
279      * constructor.
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies on extcodesize/address.code.length, which returns 0
284         // for contracts in construction, since the code is only stored at the end
285         // of the constructor execution.
286 
287         return account.code.length > 0;
288     }
289 
290     /**
291      * @dev Replacement for Solidity's transfer: sends amount wei to
292      * recipient, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by transfer, making them unable to receive funds via
297      * transfer. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to recipient, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         (bool success, ) = recipient.call{value: amount}("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level call. A
315      * plain call is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If target reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
323      *
324      * Requirements:
325      *
326      * - target must be a contract.
327      * - calling target with data must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
337      * errorMessage as a fallback revert reason when target reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
351      * but also transferring value wei to target.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least value.
356      * - the called Solidity function must be payable.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
370      * with errorMessage as a fallback revert reason when target reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         require(isContract(target), "Address: call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.call{value: value}(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
394         return functionStaticCall(target, data, "Address: low-level static call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.staticcall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
416      * but performing a delegate call.
417      *
418      * _Available since v3.4._
419      */
420     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
421         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(isContract(target), "Address: delegate call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.delegatecall(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
443      * revert reason using the provided one.
444      *
445      * _Available since v4.3._
446      */
447     function verifyCallResult(
448         bool success,
449         bytes memory returndata,
450         string memory errorMessage
451     ) internal pure returns (bytes memory) {
452         if (success) {
453             return returndata;
454         } else {
455             // Look for revert reason and bubble it up if present
456             if (returndata.length > 0) {
457                 // The easiest way to bubble the revert reason is using memory via assembly
458 
459                 assembly {
460                     let returndata_size := mload(returndata)
461                     revert(add(32, returndata), returndata_size)
462                 }
463             } else {
464                 revert(errorMessage);
465             }
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @title ERC721 token receiver interface
479  * @dev Interface for any contract that wants to support safeTransfers
480  * from ERC721 asset contracts.
481  */
482 interface IERC721Receiver {
483     /**
484      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
485      * by operator from from, this function is called.
486      *
487      * It must return its Solidity selector to confirm the token transfer.
488      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
489      *
490      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
491      */
492     function onERC721Received(
493         address operator,
494         address from,
495         uint256 tokenId,
496         bytes calldata data
497     ) external returns (bytes4);
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Interface of the ERC165 standard, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-165[EIP].
510  *
511  * Implementers can declare support of contract interfaces, which can then be
512  * queried by others ({ERC165Checker}).
513  *
514  * For an implementation, see {ERC165}.
515  */
516 interface IERC165 {
517     /**
518      * @dev Returns true if this contract implements the interface defined by
519      * interfaceId. See the corresponding
520      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
521      * to learn more about how these ids are created.
522      *
523      * This function call must use less than 30 000 gas.
524      */
525     function supportsInterface(bytes4 interfaceId) external view returns (bool);
526 }
527 
528 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Implementation of the {IERC165} interface.
538  *
539  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
540  * for the additional interface id that will be supported. For example:
541  *
542  * solidity
543  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
545  * }
546  * 
547  *
548  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
549  */
550 abstract contract ERC165 is IERC165 {
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         return interfaceId == type(IERC165).interfaceId;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Required interface of an ERC721 compliant contract.
569  */
570 interface IERC721 is IERC165 {
571     /**
572      * @dev Emitted when tokenId token is transferred from from to to.
573      */
574     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when owner enables approved to manage the tokenId token.
578      */
579     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
583      */
584     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
585 
586     /**
587      * @dev Returns the number of tokens in owner's account.
588      */
589     function balanceOf(address owner) external view returns (uint256 balance);
590 
591     /**
592      * @dev Returns the owner of the tokenId token.
593      *
594      * Requirements:
595      *
596      * - tokenId must exist.
597      */
598     function ownerOf(uint256 tokenId) external view returns (address owner);
599 
600     /**
601      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * Requirements:
605      *
606      * - from cannot be the zero address.
607      * - to cannot be the zero address.
608      * - tokenId token must exist and be owned by from.
609      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
610      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Transfers tokenId token from from to to.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
624      *
625      * Requirements:
626      *
627      * - from cannot be the zero address.
628      * - to cannot be the zero address.
629      * - tokenId token must be owned by from.
630      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to to to transfer tokenId token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - tokenId must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Returns the account approved for tokenId token.
657      *
658      * Requirements:
659      *
660      * - tokenId must exist.
661      */
662     function getApproved(uint256 tokenId) external view returns (address operator);
663 
664     /**
665      * @dev Approve or remove operator as an operator for the caller.
666      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
667      *
668      * Requirements:
669      *
670      * - The operator cannot be the caller.
671      *
672      * Emits an {ApprovalForAll} event.
673      */
674     function setApprovalForAll(address operator, bool _approved) external;
675 
676     /**
677      * @dev Returns if the operator is allowed to manage all of the assets of owner.
678      *
679      * See {setApprovalForAll}
680      */
681     function isApprovedForAll(address owner, address operator) external view returns (bool);
682 
683     /**
684      * @dev Safely transfers tokenId token from from to to.
685      *
686      * Requirements:
687      *
688      * - from cannot be the zero address.
689      * - to cannot be the zero address.
690      * - tokenId token must exist and be owned by from.
691      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes calldata data
701     ) external;
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Enumerable is IERC721 {
717     /**
718      * @dev Returns the total amount of tokens stored by the contract.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID owned by owner at a given index of its token list.
724      * Use along with {balanceOf} to enumerate all of owner's tokens.
725      */
726     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
727 
728     /**
729      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
730      * Use along with {totalSupply} to enumerate all tokens.
731      */
732     function tokenByIndex(uint256 index) external view returns (uint256);
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
745  * @dev See https://eips.ethereum.org/EIPS/eip-721
746  */
747 interface IERC721Metadata is IERC721 {
748     /**
749      * @dev Returns the token collection name.
750      */
751     function name() external view returns (string memory);
752 
753     /**
754      * @dev Returns the token collection symbol.
755      */
756     function symbol() external view returns (string memory);
757 
758     /**
759      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
760      */
761     function tokenURI(uint256 tokenId) external view returns (string memory);
762 }
763 
764 // File: @openzeppelin/contracts/utils/Strings.sol
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev String operations.
773  */
774 library Strings {
775     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
776 
777     /**
778      * @dev Converts a uint256 to its ASCII string decimal representation.
779      */
780     function toString(uint256 value) internal pure returns (string memory) {
781         // Inspired by OraclizeAPI's implementation - MIT licence
782         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
783 
784         if (value == 0) {
785             return "0";
786         }
787         uint256 temp = value;
788         uint256 digits;
789         while (temp != 0) {
790             digits++;
791             temp /= 10;
792         }
793         bytes memory buffer = new bytes(digits);
794         while (value != 0) {
795             digits -= 1;
796             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
797             value /= 10;
798         }
799         return string(buffer);
800     }
801 
802     /**
803      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
804      */
805     function toHexString(uint256 value) internal pure returns (string memory) {
806         if (value == 0) {
807             return "0x00";
808         }
809         uint256 temp = value;
810         uint256 length = 0;
811         while (temp != 0) {
812             length++;
813             temp >>= 8;
814         }
815         return toHexString(value, length);
816     }
817 
818     /**
819      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
820      */
821     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
822         bytes memory buffer = new bytes(2 * length + 2);
823         buffer[0] = "0";
824         buffer[1] = "x";
825         for (uint256 i = 2 * length + 1; i > 1; --i) {
826             buffer[i] = _HEX_SYMBOLS[value & 0xf];
827             value >>= 4;
828         }
829         require(value == 0, "Strings: hex length insufficient");
830         return string(buffer);
831     }
832 }
833 
834 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
835 
836 
837 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 /**
842  * @dev Contract module that helps prevent reentrant calls to a function.
843  *
844  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
845  * available, which can be applied to functions to make sure there are no nested
846  * (reentrant) calls to them.
847  *
848  * Note that because there is a single nonReentrant guard, functions marked as
849  * nonReentrant may not call one another. This can be worked around by making
850  * those functions private, and then adding external nonReentrant entry
851  * points to them.
852  *
853  * TIP: If you would like to learn more about reentrancy and alternative ways
854  * to protect against it, check out our blog post
855  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
856  */
857 abstract contract ReentrancyGuard {
858     // Booleans are more expensive than uint256 or any type that takes up a full
859     // word because each write operation emits an extra SLOAD to first read the
860     // slot's contents, replace the bits taken up by the boolean, and then write
861     // back. This is the compiler's defense against contract upgrades and
862     // pointer aliasing, and it cannot be disabled.
863 
864     // The values being non-zero value makes deployment a bit more expensive,
865     // but in exchange the refund on every call to nonReentrant will be lower in
866     // amount. Since refunds are capped to a percentage of the total
867     // transaction's gas, it is best to keep them low in cases like this one, to
868     // increase the likelihood of the full refund coming into effect.
869     uint256 private constant _NOT_ENTERED = 1;
870     uint256 private constant _ENTERED = 2;
871 
872     uint256 private _status;
873 
874     constructor() {
875         _status = _NOT_ENTERED;
876     }
877 
878     /**
879      * @dev Prevents a contract from calling itself, directly or indirectly.
880      * Calling a nonReentrant function from another nonReentrant
881      * function is not supported. It is possible to prevent this from happening
882      * by making the nonReentrant function external, and making it call a
883      * private function that does the actual work.
884      */
885     modifier nonReentrant() {
886         // On the first call to nonReentrant, _notEntered will be true
887         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
888 
889         // Any calls to nonReentrant after this point will fail
890         _status = _ENTERED;
891 
892         _;
893 
894         // By storing the original value once again, a refund is triggered (see
895         // https://eips.ethereum.org/EIPS/eip-2200)
896         _status = _NOT_ENTERED;
897     }
898 }
899 
900 // File: @openzeppelin/contracts/utils/Context.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Provides information about the current execution context, including the
909  * sender of the transaction and its data. While these are generally available
910  * via msg.sender and msg.data, they should not be accessed in such a direct
911  * manner, since when dealing with meta-transactions the account sending and
912  * paying for execution may not be the actual sender (as far as an application
913  * is concerned).
914  *
915  * This contract is only required for intermediate, library-like contracts.
916  */
917 abstract contract Context {
918     function _msgSender() internal view virtual returns (address) {
919         return msg.sender;
920     }
921 
922     function _msgData() internal view virtual returns (bytes calldata) {
923         return msg.data;
924     }
925 }
926 
927 // File: @openzeppelin/contracts/access/Ownable.sol
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @dev Contract module which provides a basic access control mechanism, where
937  * there is an account (an owner) that can be granted exclusive access to
938  * specific functions.
939  *
940  * By default, the owner account will be the one that deploys the contract. This
941  * can later be changed with {transferOwnership}.
942  *
943  * This module is used through inheritance. It will make available the modifier
944  * onlyOwner, which can be applied to your functions to restrict their use to
945  * the owner.
946  */
947 abstract contract Ownable is Context {
948     address private _owner;
949 
950     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
951 
952     /**
953      * @dev Initializes the contract setting the deployer as the initial owner.
954      */
955     constructor() {
956         _transferOwnership(_msgSender());
957     }
958 
959     /**
960      * @dev Returns the address of the current owner.
961      */
962     function owner() public view virtual returns (address) {
963         return _owner;
964     }
965 
966     /**
967      * @dev Throws if called by any account other than the owner.
968      */
969     modifier onlyOwner() {
970         require(owner() == _msgSender(), "Ownable: caller is not the owner");
971         _;
972     }
973 
974     /**
975      * @dev Leaves the contract without owner. It will not be possible to call
976      * onlyOwner functions anymore. Can only be called by the current owner.
977      *
978      * NOTE: Renouncing ownership will leave the contract without an owner,
979      * thereby removing any functionality that is only available to the owner.
980      */
981     function renounceOwnership() public virtual onlyOwner {
982         _transferOwnership(address(0));
983     }
984 
985     /**
986      * @dev Transfers ownership of the contract to a new account (newOwner).
987      * Can only be called by the current owner.
988      */
989     function transferOwnership(address newOwner) public virtual onlyOwner {
990         require(newOwner != address(0), "Ownable: new owner is the zero address");
991         _transferOwnership(newOwner);
992     }
993 
994     /**
995      * @dev Transfers ownership of the contract to a new account (newOwner).
996      * Internal function without access restriction.
997      */
998     function _transferOwnership(address newOwner) internal virtual {
999         address oldOwner = _owner;
1000         _owner = newOwner;
1001         emit OwnershipTransferred(oldOwner, newOwner);
1002     }
1003 }
1004 //-------------END DEPENDENCIES------------------------//
1005 
1006 
1007   
1008   
1009 /**
1010  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1011  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1012  *
1013  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1014  * 
1015  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1016  *
1017  * Does not support burning tokens to address(0).
1018  */
1019 contract ERC721A is
1020   Context,
1021   ERC165,
1022   IERC721,
1023   IERC721Metadata,
1024   IERC721Enumerable
1025 {
1026   using Address for address;
1027   using Strings for uint256;
1028 
1029   struct TokenOwnership {
1030     address addr;
1031     uint64 startTimestamp;
1032   }
1033 
1034   struct AddressData {
1035     uint128 balance;
1036     uint128 numberMinted;
1037   }
1038 
1039   uint256 private currentIndex;
1040 
1041   uint256 public immutable collectionSize;
1042   uint256 public maxBatchSize;
1043 
1044   // Token name
1045   string private _name;
1046 
1047   // Token symbol
1048   string private _symbol;
1049 
1050   // Mapping from token ID to ownership details
1051   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1052   mapping(uint256 => TokenOwnership) private _ownerships;
1053 
1054   // Mapping owner address to address data
1055   mapping(address => AddressData) private _addressData;
1056 
1057   // Mapping from token ID to approved address
1058   mapping(uint256 => address) private _tokenApprovals;
1059 
1060   // Mapping from owner to operator approvals
1061   mapping(address => mapping(address => bool)) private _operatorApprovals;
1062 
1063   /**
1064    * @dev
1065    * maxBatchSize refers to how much a minter can mint at a time.
1066    * collectionSize_ refers to how many tokens are in the collection.
1067    */
1068   constructor(
1069     string memory name_,
1070     string memory symbol_,
1071     uint256 maxBatchSize_,
1072     uint256 collectionSize_
1073   ) {
1074     require(
1075       collectionSize_ > 0,
1076       "ERC721A: collection must have a nonzero supply"
1077     );
1078     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1079     _name = name_;
1080     _symbol = symbol_;
1081     maxBatchSize = maxBatchSize_;
1082     collectionSize = collectionSize_;
1083     currentIndex = _startTokenId();
1084   }
1085 
1086   /**
1087   * To change the starting tokenId, please override this function.
1088   */
1089   function _startTokenId() internal view virtual returns (uint256) {
1090     return 1;
1091   }
1092 
1093   /**
1094    * @dev See {IERC721Enumerable-totalSupply}.
1095    */
1096   function totalSupply() public view override returns (uint256) {
1097     return _totalMinted();
1098   }
1099 
1100   function currentTokenId() public view returns (uint256) {
1101     return _totalMinted();
1102   }
1103 
1104   function getNextTokenId() public view returns (uint256) {
1105       return SafeMath.add(_totalMinted(), 1);
1106   }
1107 
1108   /**
1109   * Returns the total amount of tokens minted in the contract.
1110   */
1111   function _totalMinted() internal view returns (uint256) {
1112     unchecked {
1113       return currentIndex - _startTokenId();
1114     }
1115   }
1116 
1117   /**
1118    * @dev See {IERC721Enumerable-tokenByIndex}.
1119    */
1120   function tokenByIndex(uint256 index) public view override returns (uint256) {
1121     require(index < totalSupply(), "ERC721A: global index out of bounds");
1122     return index;
1123   }
1124 
1125   /**
1126    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1127    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1128    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1129    */
1130   function tokenOfOwnerByIndex(address owner, uint256 index)
1131     public
1132     view
1133     override
1134     returns (uint256)
1135   {
1136     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1137     uint256 numMintedSoFar = totalSupply();
1138     uint256 tokenIdsIdx = 0;
1139     address currOwnershipAddr = address(0);
1140     for (uint256 i = 0; i < numMintedSoFar; i++) {
1141       TokenOwnership memory ownership = _ownerships[i];
1142       if (ownership.addr != address(0)) {
1143         currOwnershipAddr = ownership.addr;
1144       }
1145       if (currOwnershipAddr == owner) {
1146         if (tokenIdsIdx == index) {
1147           return i;
1148         }
1149         tokenIdsIdx++;
1150       }
1151     }
1152     revert("ERC721A: unable to get token of owner by index");
1153   }
1154 
1155   /**
1156    * @dev See {IERC165-supportsInterface}.
1157    */
1158   function supportsInterface(bytes4 interfaceId)
1159     public
1160     view
1161     virtual
1162     override(ERC165, IERC165)
1163     returns (bool)
1164   {
1165     return
1166       interfaceId == type(IERC721).interfaceId ||
1167       interfaceId == type(IERC721Metadata).interfaceId ||
1168       interfaceId == type(IERC721Enumerable).interfaceId ||
1169       super.supportsInterface(interfaceId);
1170   }
1171 
1172   /**
1173    * @dev See {IERC721-balanceOf}.
1174    */
1175   function balanceOf(address owner) public view override returns (uint256) {
1176     require(owner != address(0), "ERC721A: balance query for the zero address");
1177     return uint256(_addressData[owner].balance);
1178   }
1179 
1180   function _numberMinted(address owner) internal view returns (uint256) {
1181     require(
1182       owner != address(0),
1183       "ERC721A: number minted query for the zero address"
1184     );
1185     return uint256(_addressData[owner].numberMinted);
1186   }
1187 
1188   function ownershipOf(uint256 tokenId)
1189     internal
1190     view
1191     returns (TokenOwnership memory)
1192   {
1193     uint256 curr = tokenId;
1194 
1195     unchecked {
1196         if (_startTokenId() <= curr && curr < currentIndex) {
1197             TokenOwnership memory ownership = _ownerships[curr];
1198             if (ownership.addr != address(0)) {
1199                 return ownership;
1200             }
1201 
1202             // Invariant:
1203             // There will always be an ownership that has an address and is not burned
1204             // before an ownership that does not have an address and is not burned.
1205             // Hence, curr will not underflow.
1206             while (true) {
1207                 curr--;
1208                 ownership = _ownerships[curr];
1209                 if (ownership.addr != address(0)) {
1210                     return ownership;
1211                 }
1212             }
1213         }
1214     }
1215 
1216     revert("ERC721A: unable to determine the owner of token");
1217   }
1218 
1219   /**
1220    * @dev See {IERC721-ownerOf}.
1221    */
1222   function ownerOf(uint256 tokenId) public view override returns (address) {
1223     return ownershipOf(tokenId).addr;
1224   }
1225 
1226   /**
1227    * @dev See {IERC721Metadata-name}.
1228    */
1229   function name() public view virtual override returns (string memory) {
1230     return _name;
1231   }
1232 
1233   /**
1234    * @dev See {IERC721Metadata-symbol}.
1235    */
1236   function symbol() public view virtual override returns (string memory) {
1237     return _symbol;
1238   }
1239 
1240   /**
1241    * @dev See {IERC721Metadata-tokenURI}.
1242    */
1243   function tokenURI(uint256 tokenId)
1244     public
1245     view
1246     virtual
1247     override
1248     returns (string memory)
1249   {
1250     string memory baseURI = _baseURI();
1251     return
1252       bytes(baseURI).length > 0
1253         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1254         : "";
1255   }
1256 
1257   /**
1258    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1259    * token will be the concatenation of the baseURI and the tokenId. Empty
1260    * by default, can be overriden in child contracts.
1261    */
1262   function _baseURI() internal view virtual returns (string memory) {
1263     return "";
1264   }
1265 
1266   /**
1267    * @dev See {IERC721-approve}.
1268    */
1269   function approve(address to, uint256 tokenId) public override {
1270     address owner = ERC721A.ownerOf(tokenId);
1271     require(to != owner, "ERC721A: approval to current owner");
1272 
1273     require(
1274       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1275       "ERC721A: approve caller is not owner nor approved for all"
1276     );
1277 
1278     _approve(to, tokenId, owner);
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-getApproved}.
1283    */
1284   function getApproved(uint256 tokenId) public view override returns (address) {
1285     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1286 
1287     return _tokenApprovals[tokenId];
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-setApprovalForAll}.
1292    */
1293   function setApprovalForAll(address operator, bool approved) public override {
1294     require(operator != _msgSender(), "ERC721A: approve to caller");
1295 
1296     _operatorApprovals[_msgSender()][operator] = approved;
1297     emit ApprovalForAll(_msgSender(), operator, approved);
1298   }
1299 
1300   /**
1301    * @dev See {IERC721-isApprovedForAll}.
1302    */
1303   function isApprovedForAll(address owner, address operator)
1304     public
1305     view
1306     virtual
1307     override
1308     returns (bool)
1309   {
1310     return _operatorApprovals[owner][operator];
1311   }
1312 
1313   /**
1314    * @dev See {IERC721-transferFrom}.
1315    */
1316   function transferFrom(
1317     address from,
1318     address to,
1319     uint256 tokenId
1320   ) public override {
1321     _transfer(from, to, tokenId);
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-safeTransferFrom}.
1326    */
1327   function safeTransferFrom(
1328     address from,
1329     address to,
1330     uint256 tokenId
1331   ) public override {
1332     safeTransferFrom(from, to, tokenId, "");
1333   }
1334 
1335   /**
1336    * @dev See {IERC721-safeTransferFrom}.
1337    */
1338   function safeTransferFrom(
1339     address from,
1340     address to,
1341     uint256 tokenId,
1342     bytes memory _data
1343   ) public override {
1344     _transfer(from, to, tokenId);
1345     require(
1346       _checkOnERC721Received(from, to, tokenId, _data),
1347       "ERC721A: transfer to non ERC721Receiver implementer"
1348     );
1349   }
1350 
1351   /**
1352    * @dev Returns whether tokenId exists.
1353    *
1354    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1355    *
1356    * Tokens start existing when they are minted (_mint),
1357    */
1358   function _exists(uint256 tokenId) internal view returns (bool) {
1359     return _startTokenId() <= tokenId && tokenId < currentIndex;
1360   }
1361 
1362   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1363     _safeMint(to, quantity, isAdminMint, "");
1364   }
1365 
1366   /**
1367    * @dev Mints quantity tokens and transfers them to to.
1368    *
1369    * Requirements:
1370    *
1371    * - there must be quantity tokens remaining unminted in the total collection.
1372    * - to cannot be the zero address.
1373    * - quantity cannot be larger than the max batch size.
1374    *
1375    * Emits a {Transfer} event.
1376    */
1377   function _safeMint(
1378     address to,
1379     uint256 quantity,
1380     bool isAdminMint,
1381     bytes memory _data
1382   ) internal {
1383     uint256 startTokenId = currentIndex;
1384     require(to != address(0), "ERC721A: mint to the zero address");
1385     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1386     require(!_exists(startTokenId), "ERC721A: token already minted");
1387     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1388 
1389     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1390 
1391     AddressData memory addressData = _addressData[to];
1392     _addressData[to] = AddressData(
1393       addressData.balance + uint128(quantity),
1394       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1395     );
1396     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1397 
1398     uint256 updatedIndex = startTokenId;
1399 
1400     for (uint256 i = 0; i < quantity; i++) {
1401       emit Transfer(address(0), to, updatedIndex);
1402       require(
1403         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1404         "ERC721A: transfer to non ERC721Receiver implementer"
1405       );
1406       updatedIndex++;
1407     }
1408 
1409     currentIndex = updatedIndex;
1410     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1411   }
1412 
1413   /**
1414    * @dev Transfers tokenId from from to to.
1415    *
1416    * Requirements:
1417    *
1418    * - to cannot be the zero address.
1419    * - tokenId token must be owned by from.
1420    *
1421    * Emits a {Transfer} event.
1422    */
1423   function _transfer(
1424     address from,
1425     address to,
1426     uint256 tokenId
1427   ) private {
1428     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1429 
1430     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1431       getApproved(tokenId) == _msgSender() ||
1432       isApprovedForAll(prevOwnership.addr, _msgSender()));
1433 
1434     require(
1435       isApprovedOrOwner,
1436       "ERC721A: transfer caller is not owner nor approved"
1437     );
1438 
1439     require(
1440       prevOwnership.addr == from,
1441       "ERC721A: transfer from incorrect owner"
1442     );
1443     require(to != address(0), "ERC721A: transfer to the zero address");
1444 
1445     _beforeTokenTransfers(from, to, tokenId, 1);
1446 
1447     // Clear approvals from the previous owner
1448     _approve(address(0), tokenId, prevOwnership.addr);
1449 
1450     _addressData[from].balance -= 1;
1451     _addressData[to].balance += 1;
1452     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1453 
1454     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1455     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1456     uint256 nextTokenId = tokenId + 1;
1457     if (_ownerships[nextTokenId].addr == address(0)) {
1458       if (_exists(nextTokenId)) {
1459         _ownerships[nextTokenId] = TokenOwnership(
1460           prevOwnership.addr,
1461           prevOwnership.startTimestamp
1462         );
1463       }
1464     }
1465 
1466     emit Transfer(from, to, tokenId);
1467     _afterTokenTransfers(from, to, tokenId, 1);
1468   }
1469 
1470   /**
1471    * @dev Approve to to operate on tokenId
1472    *
1473    * Emits a {Approval} event.
1474    */
1475   function _approve(
1476     address to,
1477     uint256 tokenId,
1478     address owner
1479   ) private {
1480     _tokenApprovals[tokenId] = to;
1481     emit Approval(owner, to, tokenId);
1482   }
1483 
1484   uint256 public nextOwnerToExplicitlySet = 0;
1485 
1486   /**
1487    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1488    */
1489   function _setOwnersExplicit(uint256 quantity) internal {
1490     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1491     require(quantity > 0, "quantity must be nonzero");
1492     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1493 
1494     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1495     if (endIndex > collectionSize - 1) {
1496       endIndex = collectionSize - 1;
1497     }
1498     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1499     require(_exists(endIndex), "not enough minted yet for this cleanup");
1500     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1501       if (_ownerships[i].addr == address(0)) {
1502         TokenOwnership memory ownership = ownershipOf(i);
1503         _ownerships[i] = TokenOwnership(
1504           ownership.addr,
1505           ownership.startTimestamp
1506         );
1507       }
1508     }
1509     nextOwnerToExplicitlySet = endIndex + 1;
1510   }
1511 
1512   /**
1513    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1514    * The call is not executed if the target address is not a contract.
1515    *
1516    * @param from address representing the previous owner of the given token ID
1517    * @param to target address that will receive the tokens
1518    * @param tokenId uint256 ID of the token to be transferred
1519    * @param _data bytes optional data to send along with the call
1520    * @return bool whether the call correctly returned the expected magic value
1521    */
1522   function _checkOnERC721Received(
1523     address from,
1524     address to,
1525     uint256 tokenId,
1526     bytes memory _data
1527   ) private returns (bool) {
1528     if (to.isContract()) {
1529       try
1530         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1531       returns (bytes4 retval) {
1532         return retval == IERC721Receiver(to).onERC721Received.selector;
1533       } catch (bytes memory reason) {
1534         if (reason.length == 0) {
1535           revert("ERC721A: transfer to non ERC721Receiver implementer");
1536         } else {
1537           assembly {
1538             revert(add(32, reason), mload(reason))
1539           }
1540         }
1541       }
1542     } else {
1543       return true;
1544     }
1545   }
1546 
1547   /**
1548    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1549    *
1550    * startTokenId - the first token id to be transferred
1551    * quantity - the amount to be transferred
1552    *
1553    * Calling conditions:
1554    *
1555    * - When from and to are both non-zero, from's tokenId will be
1556    * transferred to to.
1557    * - When from is zero, tokenId will be minted for to.
1558    */
1559   function _beforeTokenTransfers(
1560     address from,
1561     address to,
1562     uint256 startTokenId,
1563     uint256 quantity
1564   ) internal virtual {}
1565 
1566   /**
1567    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1568    * minting.
1569    *
1570    * startTokenId - the first token id to be transferred
1571    * quantity - the amount to be transferred
1572    *
1573    * Calling conditions:
1574    *
1575    * - when from and to are both non-zero.
1576    * - from and to are never both zero.
1577    */
1578   function _afterTokenTransfers(
1579     address from,
1580     address to,
1581     uint256 startTokenId,
1582     uint256 quantity
1583   ) internal virtual {}
1584 }
1585 
1586 
1587 
1588   
1589 abstract contract Ramppable {
1590   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1591 
1592   modifier isRampp() {
1593       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1594       _;
1595   }
1596 }
1597 
1598 
1599   
1600 interface IERC20 {
1601   function transfer(address _to, uint256 _amount) external returns (bool);
1602   function balanceOf(address account) external view returns (uint256);
1603 }
1604 
1605 abstract contract Withdrawable is Ownable, Ramppable {
1606   address[] public payableAddresses = [RAMPPADDRESS,0x7AA0F5c54c1c52745E1ddc34DB82ee7FA816B6C3];
1607   uint256[] public payableFees = [5,95];
1608   uint256 public payableAddressCount = 2;
1609 
1610   function withdrawAll() public onlyOwner {
1611       require(address(this).balance > 0);
1612       _withdrawAll();
1613   }
1614   
1615   function withdrawAllRampp() public isRampp {
1616       require(address(this).balance > 0);
1617       _withdrawAll();
1618   }
1619 
1620   function _withdrawAll() private {
1621       uint256 balance = address(this).balance;
1622       
1623       for(uint i=0; i < payableAddressCount; i++ ) {
1624           _widthdraw(
1625               payableAddresses[i],
1626               (balance * payableFees[i]) / 100
1627           );
1628       }
1629   }
1630   
1631   function _widthdraw(address _address, uint256 _amount) private {
1632       (bool success, ) = _address.call{value: _amount}("");
1633       require(success, "Transfer failed.");
1634   }
1635 
1636   /**
1637     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1638     * while still splitting royalty payments to all other team members.
1639     * in the event ERC-20 tokens are paid to the contract.
1640     * @param _tokenContract contract of ERC-20 token to withdraw
1641     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1642     */
1643   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1644     require(_amount > 0);
1645     IERC20 tokenContract = IERC20(_tokenContract);
1646     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1647 
1648     for(uint i=0; i < payableAddressCount; i++ ) {
1649         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1650     }
1651   }
1652 
1653   /**
1654   * @dev Allows Rampp wallet to update its own reference as well as update
1655   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1656   * and since Rampp is always the first address this function is limited to the rampp payout only.
1657   * @param _newAddress updated Rampp Address
1658   */
1659   function setRamppAddress(address _newAddress) public isRampp {
1660     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1661     RAMPPADDRESS = _newAddress;
1662     payableAddresses[0] = _newAddress;
1663   }
1664 }
1665 
1666 
1667   
1668 abstract contract RamppERC721A is 
1669     Ownable,
1670     ERC721A,
1671     Withdrawable,
1672     ReentrancyGuard  {
1673     constructor(
1674         string memory tokenName,
1675         string memory tokenSymbol
1676     ) ERC721A(tokenName, tokenSymbol, 1000, 5000 ) {}
1677     using SafeMath for uint256;
1678     uint8 public CONTRACT_VERSION = 2;
1679     string public _baseTokenURI = "ipfs://QmUcEnG6qb1p1yTFfcoTgCiZy64KKR596CfCnKAtQ3hZsR/";
1680 
1681     bool public mintingOpen = true;
1682     
1683     uint256 public PRICE = 0.05 ether;
1684     
1685 
1686     
1687     /////////////// Admin Mint Functions
1688     /**
1689     * @dev Mints a token to an address with a tokenURI.
1690     * This is owner only and allows a fee-free drop
1691     * @param _to address of the future owner of the token
1692     */
1693     function mintToAdmin(address _to) public onlyOwner {
1694         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1695         _safeMint(_to, 1, true);
1696     }
1697 
1698     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1699         for(uint i=0; i < _addressCount; i++ ) {
1700             mintToAdmin(_addresses[i]);
1701         }
1702     }
1703 
1704     
1705     /////////////// GENERIC MINT FUNCTIONS
1706     /**
1707     * @dev Mints a single token to an address.
1708     * fee may or may not be required*
1709     * @param _to address of the future owner of the token
1710     */
1711     function mintTo(address _to) public payable {
1712         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1713         require(mintingOpen == true, "Minting is not open right now!");
1714         
1715         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1716         
1717         _safeMint(_to, 1, false);
1718     }
1719 
1720     /**
1721     * @dev Mints a token to an address with a tokenURI.
1722     * fee may or may not be required*
1723     * @param _to address of the future owner of the token
1724     * @param _amount number of tokens to mint
1725     */
1726     function mintToMultiple(address _to, uint256 _amount) public payable {
1727         require(_amount >= 1, "Must mint at least 1 token");
1728         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1729         require(mintingOpen == true, "Minting is not open right now!");
1730         
1731         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1732         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1733 
1734         _safeMint(_to, _amount, false);
1735     }
1736 
1737     function openMinting() public onlyOwner {
1738         mintingOpen = true;
1739     }
1740 
1741     function stopMinting() public onlyOwner {
1742         mintingOpen = false;
1743     }
1744 
1745     
1746 
1747     
1748 
1749     
1750     /**
1751      * @dev Allows owner to set Max mints per tx
1752      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1753      */
1754      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1755          require(_newMaxMint >= 1, "Max mint must be at least 1");
1756          maxBatchSize = _newMaxMint;
1757      }
1758     
1759 
1760     
1761     function setPrice(uint256 _feeInWei) public onlyOwner {
1762         PRICE = _feeInWei;
1763     }
1764 
1765     function getPrice(uint256 _count) private view returns (uint256) {
1766         return PRICE.mul(_count);
1767     }
1768 
1769     
1770     
1771     function _baseURI() internal view virtual override returns (string memory) {
1772         return _baseTokenURI;
1773     }
1774 
1775     function baseTokenURI() public view returns (string memory) {
1776         return _baseTokenURI;
1777     }
1778 
1779     function setBaseURI(string calldata baseURI) external onlyOwner {
1780         _baseTokenURI = baseURI;
1781     }
1782 
1783     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1784         return ownershipOf(tokenId);
1785     }
1786 }
1787 
1788 
1789   
1790 // File: contracts/TheUncannyCountryClubContract.sol
1791 //SPDX-License-Identifier: MIT
1792 
1793 pragma solidity ^0.8.0;
1794 
1795 contract TheUncannyCountryClubContract is RamppERC721A {
1796     constructor() RamppERC721A("The Uncanny Country Club", "RAMPP"){}
1797 
1798     function contractURI() public pure returns (string memory) {
1799       return "https://us-central1-nft-rampp.cloudfunctions.net/app/51Otsvf44EbcBCFjVodt/contract-metadata";
1800     }
1801 }
1802   
1803 //*********************************************************************//
1804 //*********************************************************************//  
1805 //                       Rampp v2.0.1
1806 //
1807 //         This smart contract was generated by rampp.xyz.
1808 //            Rampp allows creators like you to launch 
1809 //             large scale NFT communities without code!
1810 //
1811 //    Rampp is not responsible for the content of this contract and
1812 //        hopes it is being used in a responsible and kind way.  
1813 //       Rampp is not associated or affiliated with this project.                                                    
1814 //             Twitter: @Rampp_ ---- rampp.xyz
1815 //*********************************************************************//                                                     
1816 //*********************************************************************//