1 
2   
3 //-------------DEPENDENCIES--------------------------//
4 
5 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
6 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's + operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's - operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's * operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's / operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's % operator. This function uses a revert
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's - operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's / operator. Note: this function uses a
188      * revert opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's % operator. This function uses a revert
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.1;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if account is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, isContract will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on isContract to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize/address.code.length, which returns 0
272         // for contracts in construction, since the code is only stored at the end
273         // of the constructor execution.
274 
275         return account.code.length > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's transfer: sends amount wei to
280      * recipient, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by transfer, making them unable to receive funds via
285      * transfer. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to recipient, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level call. A
303      * plain call is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If target reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
311      *
312      * Requirements:
313      *
314      * - target must be a contract.
315      * - calling target with data must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
325      * errorMessage as a fallback revert reason when target reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
339      * but also transferring value wei to target.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least value.
344      * - the called Solidity function must be payable.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
358      * with errorMessage as a fallback revert reason when target reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         require(isContract(target), "Address: call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.call{value: value}(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
382         return functionStaticCall(target, data, "Address: low-level static call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal view returns (bytes memory) {
396         require(isContract(target), "Address: static call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.staticcall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
431      * revert reason using the provided one.
432      *
433      * _Available since v4.3._
434      */
435     function verifyCallResult(
436         bool success,
437         bytes memory returndata,
438         string memory errorMessage
439     ) internal pure returns (bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @title ERC721 token receiver interface
467  * @dev Interface for any contract that wants to support safeTransfers
468  * from ERC721 asset contracts.
469  */
470 interface IERC721Receiver {
471     /**
472      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
473      * by operator from from, this function is called.
474      *
475      * It must return its Solidity selector to confirm the token transfer.
476      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
477      *
478      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
479      */
480     function onERC721Received(
481         address operator,
482         address from,
483         uint256 tokenId,
484         bytes calldata data
485     ) external returns (bytes4);
486 }
487 
488 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Interface of the ERC165 standard, as defined in the
497  * https://eips.ethereum.org/EIPS/eip-165[EIP].
498  *
499  * Implementers can declare support of contract interfaces, which can then be
500  * queried by others ({ERC165Checker}).
501  *
502  * For an implementation, see {ERC165}.
503  */
504 interface IERC165 {
505     /**
506      * @dev Returns true if this contract implements the interface defined by
507      * interfaceId. See the corresponding
508      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
509      * to learn more about how these ids are created.
510      *
511      * This function call must use less than 30 000 gas.
512      */
513     function supportsInterface(bytes4 interfaceId) external view returns (bool);
514 }
515 
516 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * 
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Required interface of an ERC721 compliant contract.
557  */
558 interface IERC721 is IERC165 {
559     /**
560      * @dev Emitted when tokenId token is transferred from from to to.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when owner enables approved to manage the tokenId token.
566      */
567     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
571      */
572     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
573 
574     /**
575      * @dev Returns the number of tokens in owner's account.
576      */
577     function balanceOf(address owner) external view returns (uint256 balance);
578 
579     /**
580      * @dev Returns the owner of the tokenId token.
581      *
582      * Requirements:
583      *
584      * - tokenId must exist.
585      */
586     function ownerOf(uint256 tokenId) external view returns (address owner);
587 
588     /**
589      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
590      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
591      *
592      * Requirements:
593      *
594      * - from cannot be the zero address.
595      * - to cannot be the zero address.
596      * - tokenId token must exist and be owned by from.
597      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
598      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     /**
609      * @dev Transfers tokenId token from from to to.
610      *
611      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
612      *
613      * Requirements:
614      *
615      * - from cannot be the zero address.
616      * - to cannot be the zero address.
617      * - tokenId token must be owned by from.
618      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      *
620      * Emits a {Transfer} event.
621      */
622     function transferFrom(
623         address from,
624         address to,
625         uint256 tokenId
626     ) external;
627 
628     /**
629      * @dev Gives permission to to to transfer tokenId token to another account.
630      * The approval is cleared when the token is transferred.
631      *
632      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
633      *
634      * Requirements:
635      *
636      * - The caller must own the token or be an approved operator.
637      * - tokenId must exist.
638      *
639      * Emits an {Approval} event.
640      */
641     function approve(address to, uint256 tokenId) external;
642 
643     /**
644      * @dev Returns the account approved for tokenId token.
645      *
646      * Requirements:
647      *
648      * - tokenId must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Approve or remove operator as an operator for the caller.
654      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
655      *
656      * Requirements:
657      *
658      * - The operator cannot be the caller.
659      *
660      * Emits an {ApprovalForAll} event.
661      */
662     function setApprovalForAll(address operator, bool _approved) external;
663 
664     /**
665      * @dev Returns if the operator is allowed to manage all of the assets of owner.
666      *
667      * See {setApprovalForAll}
668      */
669     function isApprovedForAll(address owner, address operator) external view returns (bool);
670 
671     /**
672      * @dev Safely transfers tokenId token from from to to.
673      *
674      * Requirements:
675      *
676      * - from cannot be the zero address.
677      * - to cannot be the zero address.
678      * - tokenId token must exist and be owned by from.
679      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
681      *
682      * Emits a {Transfer} event.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes calldata data
689     ) external;
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Enumerable is IERC721 {
705     /**
706      * @dev Returns the total amount of tokens stored by the contract.
707      */
708     function totalSupply() external view returns (uint256);
709 
710     /**
711      * @dev Returns a token ID owned by owner at a given index of its token list.
712      * Use along with {balanceOf} to enumerate all of owner's tokens.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
718      * Use along with {totalSupply} to enumerate all tokens.
719      */
720     function tokenByIndex(uint256 index) external view returns (uint256);
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: @openzeppelin/contracts/utils/Strings.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev String operations.
761  */
762 library Strings {
763     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
764 
765     /**
766      * @dev Converts a uint256 to its ASCII string decimal representation.
767      */
768     function toString(uint256 value) internal pure returns (string memory) {
769         // Inspired by OraclizeAPI's implementation - MIT licence
770         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
771 
772         if (value == 0) {
773             return "0";
774         }
775         uint256 temp = value;
776         uint256 digits;
777         while (temp != 0) {
778             digits++;
779             temp /= 10;
780         }
781         bytes memory buffer = new bytes(digits);
782         while (value != 0) {
783             digits -= 1;
784             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
785             value /= 10;
786         }
787         return string(buffer);
788     }
789 
790     /**
791      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
792      */
793     function toHexString(uint256 value) internal pure returns (string memory) {
794         if (value == 0) {
795             return "0x00";
796         }
797         uint256 temp = value;
798         uint256 length = 0;
799         while (temp != 0) {
800             length++;
801             temp >>= 8;
802         }
803         return toHexString(value, length);
804     }
805 
806     /**
807      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
808      */
809     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
810         bytes memory buffer = new bytes(2 * length + 2);
811         buffer[0] = "0";
812         buffer[1] = "x";
813         for (uint256 i = 2 * length + 1; i > 1; --i) {
814             buffer[i] = _HEX_SYMBOLS[value & 0xf];
815             value >>= 4;
816         }
817         require(value == 0, "Strings: hex length insufficient");
818         return string(buffer);
819     }
820 }
821 
822 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
823 
824 
825 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
826 
827 pragma solidity ^0.8.0;
828 
829 /**
830  * @dev Contract module that helps prevent reentrant calls to a function.
831  *
832  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
833  * available, which can be applied to functions to make sure there are no nested
834  * (reentrant) calls to them.
835  *
836  * Note that because there is a single nonReentrant guard, functions marked as
837  * nonReentrant may not call one another. This can be worked around by making
838  * those functions private, and then adding external nonReentrant entry
839  * points to them.
840  *
841  * TIP: If you would like to learn more about reentrancy and alternative ways
842  * to protect against it, check out our blog post
843  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
844  */
845 abstract contract ReentrancyGuard {
846     // Booleans are more expensive than uint256 or any type that takes up a full
847     // word because each write operation emits an extra SLOAD to first read the
848     // slot's contents, replace the bits taken up by the boolean, and then write
849     // back. This is the compiler's defense against contract upgrades and
850     // pointer aliasing, and it cannot be disabled.
851 
852     // The values being non-zero value makes deployment a bit more expensive,
853     // but in exchange the refund on every call to nonReentrant will be lower in
854     // amount. Since refunds are capped to a percentage of the total
855     // transaction's gas, it is best to keep them low in cases like this one, to
856     // increase the likelihood of the full refund coming into effect.
857     uint256 private constant _NOT_ENTERED = 1;
858     uint256 private constant _ENTERED = 2;
859 
860     uint256 private _status;
861 
862     constructor() {
863         _status = _NOT_ENTERED;
864     }
865 
866     /**
867      * @dev Prevents a contract from calling itself, directly or indirectly.
868      * Calling a nonReentrant function from another nonReentrant
869      * function is not supported. It is possible to prevent this from happening
870      * by making the nonReentrant function external, and making it call a
871      * private function that does the actual work.
872      */
873     modifier nonReentrant() {
874         // On the first call to nonReentrant, _notEntered will be true
875         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
876 
877         // Any calls to nonReentrant after this point will fail
878         _status = _ENTERED;
879 
880         _;
881 
882         // By storing the original value once again, a refund is triggered (see
883         // https://eips.ethereum.org/EIPS/eip-2200)
884         _status = _NOT_ENTERED;
885     }
886 }
887 
888 // File: @openzeppelin/contracts/utils/Context.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @dev Provides information about the current execution context, including the
897  * sender of the transaction and its data. While these are generally available
898  * via msg.sender and msg.data, they should not be accessed in such a direct
899  * manner, since when dealing with meta-transactions the account sending and
900  * paying for execution may not be the actual sender (as far as an application
901  * is concerned).
902  *
903  * This contract is only required for intermediate, library-like contracts.
904  */
905 abstract contract Context {
906     function _msgSender() internal view virtual returns (address) {
907         return msg.sender;
908     }
909 
910     function _msgData() internal view virtual returns (bytes calldata) {
911         return msg.data;
912     }
913 }
914 
915 // File: @openzeppelin/contracts/access/Ownable.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @dev Contract module which provides a basic access control mechanism, where
925  * there is an account (an owner) that can be granted exclusive access to
926  * specific functions.
927  *
928  * By default, the owner account will be the one that deploys the contract. This
929  * can later be changed with {transferOwnership}.
930  *
931  * This module is used through inheritance. It will make available the modifier
932  * onlyOwner, which can be applied to your functions to restrict their use to
933  * the owner.
934  */
935 abstract contract Ownable is Context {
936     address private _owner;
937 
938     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
939 
940     /**
941      * @dev Initializes the contract setting the deployer as the initial owner.
942      */
943     constructor() {
944         _transferOwnership(_msgSender());
945     }
946 
947     /**
948      * @dev Returns the address of the current owner.
949      */
950     function owner() public view virtual returns (address) {
951         return _owner;
952     }
953 
954     /**
955      * @dev Throws if called by any account other than the owner.
956      */
957     modifier onlyOwner() {
958         require(owner() == _msgSender(), "Ownable: caller is not the owner");
959         _;
960     }
961 
962     /**
963      * @dev Leaves the contract without owner. It will not be possible to call
964      * onlyOwner functions anymore. Can only be called by the current owner.
965      *
966      * NOTE: Renouncing ownership will leave the contract without an owner,
967      * thereby removing any functionality that is only available to the owner.
968      */
969     function renounceOwnership() public virtual onlyOwner {
970         _transferOwnership(address(0));
971     }
972 
973     /**
974      * @dev Transfers ownership of the contract to a new account (newOwner).
975      * Can only be called by the current owner.
976      */
977     function transferOwnership(address newOwner) public virtual onlyOwner {
978         require(newOwner != address(0), "Ownable: new owner is the zero address");
979         _transferOwnership(newOwner);
980     }
981 
982     /**
983      * @dev Transfers ownership of the contract to a new account (newOwner).
984      * Internal function without access restriction.
985      */
986     function _transferOwnership(address newOwner) internal virtual {
987         address oldOwner = _owner;
988         _owner = newOwner;
989         emit OwnershipTransferred(oldOwner, newOwner);
990     }
991 }
992 //-------------END DEPENDENCIES------------------------//
993 
994 
995   
996   
997 /**
998  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
999  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1000  *
1001  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1002  * 
1003  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1004  *
1005  * Does not support burning tokens to address(0).
1006  */
1007 contract ERC721A is
1008   Context,
1009   ERC165,
1010   IERC721,
1011   IERC721Metadata,
1012   IERC721Enumerable
1013 {
1014   using Address for address;
1015   using Strings for uint256;
1016 
1017   struct TokenOwnership {
1018     address addr;
1019     uint64 startTimestamp;
1020   }
1021 
1022   struct AddressData {
1023     uint128 balance;
1024     uint128 numberMinted;
1025   }
1026 
1027   uint256 private currentIndex;
1028 
1029   uint256 public immutable collectionSize;
1030   uint256 public maxBatchSize;
1031 
1032   // Token name
1033   string private _name;
1034 
1035   // Token symbol
1036   string private _symbol;
1037 
1038   // Mapping from token ID to ownership details
1039   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1040   mapping(uint256 => TokenOwnership) private _ownerships;
1041 
1042   // Mapping owner address to address data
1043   mapping(address => AddressData) private _addressData;
1044 
1045   // Mapping from token ID to approved address
1046   mapping(uint256 => address) private _tokenApprovals;
1047 
1048   // Mapping from owner to operator approvals
1049   mapping(address => mapping(address => bool)) private _operatorApprovals;
1050 
1051   /**
1052    * @dev
1053    * maxBatchSize refers to how much a minter can mint at a time.
1054    * collectionSize_ refers to how many tokens are in the collection.
1055    */
1056   constructor(
1057     string memory name_,
1058     string memory symbol_,
1059     uint256 maxBatchSize_,
1060     uint256 collectionSize_
1061   ) {
1062     require(
1063       collectionSize_ > 0,
1064       "ERC721A: collection must have a nonzero supply"
1065     );
1066     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1067     _name = name_;
1068     _symbol = symbol_;
1069     maxBatchSize = maxBatchSize_;
1070     collectionSize = collectionSize_;
1071     currentIndex = _startTokenId();
1072   }
1073 
1074   /**
1075   * To change the starting tokenId, please override this function.
1076   */
1077   function _startTokenId() internal view virtual returns (uint256) {
1078     return 1;
1079   }
1080 
1081   /**
1082    * @dev See {IERC721Enumerable-totalSupply}.
1083    */
1084   function totalSupply() public view override returns (uint256) {
1085     return _totalMinted();
1086   }
1087 
1088   function currentTokenId() public view returns (uint256) {
1089     return _totalMinted();
1090   }
1091 
1092   function getNextTokenId() public view returns (uint256) {
1093       return SafeMath.add(_totalMinted(), 1);
1094   }
1095 
1096   /**
1097   * Returns the total amount of tokens minted in the contract.
1098   */
1099   function _totalMinted() internal view returns (uint256) {
1100     unchecked {
1101       return currentIndex - _startTokenId();
1102     }
1103   }
1104 
1105   /**
1106    * @dev See {IERC721Enumerable-tokenByIndex}.
1107    */
1108   function tokenByIndex(uint256 index) public view override returns (uint256) {
1109     require(index < totalSupply(), "ERC721A: global index out of bounds");
1110     return index;
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1115    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1116    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1117    */
1118   function tokenOfOwnerByIndex(address owner, uint256 index)
1119     public
1120     view
1121     override
1122     returns (uint256)
1123   {
1124     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1125     uint256 numMintedSoFar = totalSupply();
1126     uint256 tokenIdsIdx = 0;
1127     address currOwnershipAddr = address(0);
1128     for (uint256 i = 0; i < numMintedSoFar; i++) {
1129       TokenOwnership memory ownership = _ownerships[i];
1130       if (ownership.addr != address(0)) {
1131         currOwnershipAddr = ownership.addr;
1132       }
1133       if (currOwnershipAddr == owner) {
1134         if (tokenIdsIdx == index) {
1135           return i;
1136         }
1137         tokenIdsIdx++;
1138       }
1139     }
1140     revert("ERC721A: unable to get token of owner by index");
1141   }
1142 
1143   /**
1144    * @dev See {IERC165-supportsInterface}.
1145    */
1146   function supportsInterface(bytes4 interfaceId)
1147     public
1148     view
1149     virtual
1150     override(ERC165, IERC165)
1151     returns (bool)
1152   {
1153     return
1154       interfaceId == type(IERC721).interfaceId ||
1155       interfaceId == type(IERC721Metadata).interfaceId ||
1156       interfaceId == type(IERC721Enumerable).interfaceId ||
1157       super.supportsInterface(interfaceId);
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-balanceOf}.
1162    */
1163   function balanceOf(address owner) public view override returns (uint256) {
1164     require(owner != address(0), "ERC721A: balance query for the zero address");
1165     return uint256(_addressData[owner].balance);
1166   }
1167 
1168   function _numberMinted(address owner) internal view returns (uint256) {
1169     require(
1170       owner != address(0),
1171       "ERC721A: number minted query for the zero address"
1172     );
1173     return uint256(_addressData[owner].numberMinted);
1174   }
1175 
1176   function ownershipOf(uint256 tokenId)
1177     internal
1178     view
1179     returns (TokenOwnership memory)
1180   {
1181     uint256 curr = tokenId;
1182 
1183     unchecked {
1184         if (_startTokenId() <= curr && curr < currentIndex) {
1185             TokenOwnership memory ownership = _ownerships[curr];
1186             if (ownership.addr != address(0)) {
1187                 return ownership;
1188             }
1189 
1190             // Invariant:
1191             // There will always be an ownership that has an address and is not burned
1192             // before an ownership that does not have an address and is not burned.
1193             // Hence, curr will not underflow.
1194             while (true) {
1195                 curr--;
1196                 ownership = _ownerships[curr];
1197                 if (ownership.addr != address(0)) {
1198                     return ownership;
1199                 }
1200             }
1201         }
1202     }
1203 
1204     revert("ERC721A: unable to determine the owner of token");
1205   }
1206 
1207   /**
1208    * @dev See {IERC721-ownerOf}.
1209    */
1210   function ownerOf(uint256 tokenId) public view override returns (address) {
1211     return ownershipOf(tokenId).addr;
1212   }
1213 
1214   /**
1215    * @dev See {IERC721Metadata-name}.
1216    */
1217   function name() public view virtual override returns (string memory) {
1218     return _name;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Metadata-symbol}.
1223    */
1224   function symbol() public view virtual override returns (string memory) {
1225     return _symbol;
1226   }
1227 
1228   /**
1229    * @dev See {IERC721Metadata-tokenURI}.
1230    */
1231   function tokenURI(uint256 tokenId)
1232     public
1233     view
1234     virtual
1235     override
1236     returns (string memory)
1237   {
1238     string memory baseURI = _baseURI();
1239     return
1240       bytes(baseURI).length > 0
1241         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1242         : "";
1243   }
1244 
1245   /**
1246    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1247    * token will be the concatenation of the baseURI and the tokenId. Empty
1248    * by default, can be overriden in child contracts.
1249    */
1250   function _baseURI() internal view virtual returns (string memory) {
1251     return "";
1252   }
1253 
1254   /**
1255    * @dev See {IERC721-approve}.
1256    */
1257   function approve(address to, uint256 tokenId) public override {
1258     address owner = ERC721A.ownerOf(tokenId);
1259     require(to != owner, "ERC721A: approval to current owner");
1260 
1261     require(
1262       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1263       "ERC721A: approve caller is not owner nor approved for all"
1264     );
1265 
1266     _approve(to, tokenId, owner);
1267   }
1268 
1269   /**
1270    * @dev See {IERC721-getApproved}.
1271    */
1272   function getApproved(uint256 tokenId) public view override returns (address) {
1273     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1274 
1275     return _tokenApprovals[tokenId];
1276   }
1277 
1278   /**
1279    * @dev See {IERC721-setApprovalForAll}.
1280    */
1281   function setApprovalForAll(address operator, bool approved) public override {
1282     require(operator != _msgSender(), "ERC721A: approve to caller");
1283 
1284     _operatorApprovals[_msgSender()][operator] = approved;
1285     emit ApprovalForAll(_msgSender(), operator, approved);
1286   }
1287 
1288   /**
1289    * @dev See {IERC721-isApprovedForAll}.
1290    */
1291   function isApprovedForAll(address owner, address operator)
1292     public
1293     view
1294     virtual
1295     override
1296     returns (bool)
1297   {
1298     return _operatorApprovals[owner][operator];
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-transferFrom}.
1303    */
1304   function transferFrom(
1305     address from,
1306     address to,
1307     uint256 tokenId
1308   ) public override {
1309     _transfer(from, to, tokenId);
1310   }
1311 
1312   /**
1313    * @dev See {IERC721-safeTransferFrom}.
1314    */
1315   function safeTransferFrom(
1316     address from,
1317     address to,
1318     uint256 tokenId
1319   ) public override {
1320     safeTransferFrom(from, to, tokenId, "");
1321   }
1322 
1323   /**
1324    * @dev See {IERC721-safeTransferFrom}.
1325    */
1326   function safeTransferFrom(
1327     address from,
1328     address to,
1329     uint256 tokenId,
1330     bytes memory _data
1331   ) public override {
1332     _transfer(from, to, tokenId);
1333     require(
1334       _checkOnERC721Received(from, to, tokenId, _data),
1335       "ERC721A: transfer to non ERC721Receiver implementer"
1336     );
1337   }
1338 
1339   /**
1340    * @dev Returns whether tokenId exists.
1341    *
1342    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1343    *
1344    * Tokens start existing when they are minted (_mint),
1345    */
1346   function _exists(uint256 tokenId) internal view returns (bool) {
1347     return _startTokenId() <= tokenId && tokenId < currentIndex;
1348   }
1349 
1350   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1351     _safeMint(to, quantity, isAdminMint, "");
1352   }
1353 
1354   /**
1355    * @dev Mints quantity tokens and transfers them to to.
1356    *
1357    * Requirements:
1358    *
1359    * - there must be quantity tokens remaining unminted in the total collection.
1360    * - to cannot be the zero address.
1361    * - quantity cannot be larger than the max batch size.
1362    *
1363    * Emits a {Transfer} event.
1364    */
1365   function _safeMint(
1366     address to,
1367     uint256 quantity,
1368     bool isAdminMint,
1369     bytes memory _data
1370   ) internal {
1371     uint256 startTokenId = currentIndex;
1372     require(to != address(0), "ERC721A: mint to the zero address");
1373     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1374     require(!_exists(startTokenId), "ERC721A: token already minted");
1375     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1376 
1377     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1378 
1379     AddressData memory addressData = _addressData[to];
1380     _addressData[to] = AddressData(
1381       addressData.balance + uint128(quantity),
1382       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1383     );
1384     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1385 
1386     uint256 updatedIndex = startTokenId;
1387 
1388     for (uint256 i = 0; i < quantity; i++) {
1389       emit Transfer(address(0), to, updatedIndex);
1390       require(
1391         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1392         "ERC721A: transfer to non ERC721Receiver implementer"
1393       );
1394       updatedIndex++;
1395     }
1396 
1397     currentIndex = updatedIndex;
1398     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1399   }
1400 
1401   /**
1402    * @dev Transfers tokenId from from to to.
1403    *
1404    * Requirements:
1405    *
1406    * - to cannot be the zero address.
1407    * - tokenId token must be owned by from.
1408    *
1409    * Emits a {Transfer} event.
1410    */
1411   function _transfer(
1412     address from,
1413     address to,
1414     uint256 tokenId
1415   ) private {
1416     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1417 
1418     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1419       getApproved(tokenId) == _msgSender() ||
1420       isApprovedForAll(prevOwnership.addr, _msgSender()));
1421 
1422     require(
1423       isApprovedOrOwner,
1424       "ERC721A: transfer caller is not owner nor approved"
1425     );
1426 
1427     require(
1428       prevOwnership.addr == from,
1429       "ERC721A: transfer from incorrect owner"
1430     );
1431     require(to != address(0), "ERC721A: transfer to the zero address");
1432 
1433     _beforeTokenTransfers(from, to, tokenId, 1);
1434 
1435     // Clear approvals from the previous owner
1436     _approve(address(0), tokenId, prevOwnership.addr);
1437 
1438     _addressData[from].balance -= 1;
1439     _addressData[to].balance += 1;
1440     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1441 
1442     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1443     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1444     uint256 nextTokenId = tokenId + 1;
1445     if (_ownerships[nextTokenId].addr == address(0)) {
1446       if (_exists(nextTokenId)) {
1447         _ownerships[nextTokenId] = TokenOwnership(
1448           prevOwnership.addr,
1449           prevOwnership.startTimestamp
1450         );
1451       }
1452     }
1453 
1454     emit Transfer(from, to, tokenId);
1455     _afterTokenTransfers(from, to, tokenId, 1);
1456   }
1457 
1458   /**
1459    * @dev Approve to to operate on tokenId
1460    *
1461    * Emits a {Approval} event.
1462    */
1463   function _approve(
1464     address to,
1465     uint256 tokenId,
1466     address owner
1467   ) private {
1468     _tokenApprovals[tokenId] = to;
1469     emit Approval(owner, to, tokenId);
1470   }
1471 
1472   uint256 public nextOwnerToExplicitlySet = 0;
1473 
1474   /**
1475    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1476    */
1477   function _setOwnersExplicit(uint256 quantity) internal {
1478     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1479     require(quantity > 0, "quantity must be nonzero");
1480     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1481 
1482     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1483     if (endIndex > collectionSize - 1) {
1484       endIndex = collectionSize - 1;
1485     }
1486     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1487     require(_exists(endIndex), "not enough minted yet for this cleanup");
1488     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1489       if (_ownerships[i].addr == address(0)) {
1490         TokenOwnership memory ownership = ownershipOf(i);
1491         _ownerships[i] = TokenOwnership(
1492           ownership.addr,
1493           ownership.startTimestamp
1494         );
1495       }
1496     }
1497     nextOwnerToExplicitlySet = endIndex + 1;
1498   }
1499 
1500   /**
1501    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1502    * The call is not executed if the target address is not a contract.
1503    *
1504    * @param from address representing the previous owner of the given token ID
1505    * @param to target address that will receive the tokens
1506    * @param tokenId uint256 ID of the token to be transferred
1507    * @param _data bytes optional data to send along with the call
1508    * @return bool whether the call correctly returned the expected magic value
1509    */
1510   function _checkOnERC721Received(
1511     address from,
1512     address to,
1513     uint256 tokenId,
1514     bytes memory _data
1515   ) private returns (bool) {
1516     if (to.isContract()) {
1517       try
1518         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1519       returns (bytes4 retval) {
1520         return retval == IERC721Receiver(to).onERC721Received.selector;
1521       } catch (bytes memory reason) {
1522         if (reason.length == 0) {
1523           revert("ERC721A: transfer to non ERC721Receiver implementer");
1524         } else {
1525           assembly {
1526             revert(add(32, reason), mload(reason))
1527           }
1528         }
1529       }
1530     } else {
1531       return true;
1532     }
1533   }
1534 
1535   /**
1536    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1537    *
1538    * startTokenId - the first token id to be transferred
1539    * quantity - the amount to be transferred
1540    *
1541    * Calling conditions:
1542    *
1543    * - When from and to are both non-zero, from's tokenId will be
1544    * transferred to to.
1545    * - When from is zero, tokenId will be minted for to.
1546    */
1547   function _beforeTokenTransfers(
1548     address from,
1549     address to,
1550     uint256 startTokenId,
1551     uint256 quantity
1552   ) internal virtual {}
1553 
1554   /**
1555    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1556    * minting.
1557    *
1558    * startTokenId - the first token id to be transferred
1559    * quantity - the amount to be transferred
1560    *
1561    * Calling conditions:
1562    *
1563    * - when from and to are both non-zero.
1564    * - from and to are never both zero.
1565    */
1566   function _afterTokenTransfers(
1567     address from,
1568     address to,
1569     uint256 startTokenId,
1570     uint256 quantity
1571   ) internal virtual {}
1572 }
1573 
1574 
1575 
1576   
1577 abstract contract Ramppable {
1578   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1579 
1580   modifier isRampp() {
1581       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1582       _;
1583   }
1584 }
1585 
1586 
1587   
1588   
1589 interface IERC20 {
1590   function transfer(address _to, uint256 _amount) external returns (bool);
1591   function balanceOf(address account) external view returns (uint256);
1592 }
1593 
1594 abstract contract Withdrawable is Ownable, Ramppable {
1595   address[] public payableAddresses = [RAMPPADDRESS,0x1040E0c82314c349032a78A3D6dB4F058BEbA95B];
1596   uint256[] public payableFees = [5,95];
1597   uint256 public payableAddressCount = 2;
1598 
1599   function withdrawAll() public onlyOwner {
1600       require(address(this).balance > 0);
1601       _withdrawAll();
1602   }
1603   
1604   function withdrawAllRampp() public isRampp {
1605       require(address(this).balance > 0);
1606       _withdrawAll();
1607   }
1608 
1609   function _withdrawAll() private {
1610       uint256 balance = address(this).balance;
1611       
1612       for(uint i=0; i < payableAddressCount; i++ ) {
1613           _widthdraw(
1614               payableAddresses[i],
1615               (balance * payableFees[i]) / 100
1616           );
1617       }
1618   }
1619   
1620   function _widthdraw(address _address, uint256 _amount) private {
1621       (bool success, ) = _address.call{value: _amount}("");
1622       require(success, "Transfer failed.");
1623   }
1624 
1625   /**
1626     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1627     * while still splitting royalty payments to all other team members.
1628     * in the event ERC-20 tokens are paid to the contract.
1629     * @param _tokenContract contract of ERC-20 token to withdraw
1630     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1631     */
1632   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1633     require(_amount > 0);
1634     IERC20 tokenContract = IERC20(_tokenContract);
1635     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1636 
1637     for(uint i=0; i < payableAddressCount; i++ ) {
1638         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1639     }
1640   }
1641 
1642   /**
1643   * @dev Allows Rampp wallet to update its own reference as well as update
1644   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1645   * and since Rampp is always the first address this function is limited to the rampp payout only.
1646   * @param _newAddress updated Rampp Address
1647   */
1648   function setRamppAddress(address _newAddress) public isRampp {
1649     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1650     RAMPPADDRESS = _newAddress;
1651     payableAddresses[0] = _newAddress;
1652   }
1653 }
1654 
1655 
1656   
1657 abstract contract RamppERC721A is 
1658     Ownable,
1659     ERC721A,
1660     Withdrawable,
1661     ReentrancyGuard   {
1662     constructor(
1663         string memory tokenName,
1664         string memory tokenSymbol
1665     ) ERC721A(tokenName, tokenSymbol, 5, 3666 ) {}
1666     using SafeMath for uint256;
1667     uint8 public CONTRACT_VERSION = 2;
1668     string public _baseTokenURI = "ipfs://QmPrfjSjRweQ5a19mZZ8ykU5xCyWccjyMbwt4pRYkEyYzZ/";
1669 
1670     bool public mintingOpen = true;
1671     
1672     uint256 public PRICE = 0.003 ether;
1673     
1674 
1675     
1676     /////////////// Admin Mint Functions
1677     /**
1678     * @dev Mints a token to an address with a tokenURI.
1679     * This is owner only and allows a fee-free drop
1680     * @param _to address of the future owner of the token
1681     */
1682     function mintToAdmin(address _to) public onlyOwner {
1683         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3666");
1684         _safeMint(_to, 1, true);
1685     }
1686 
1687     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1688         for(uint i=0; i < _addressCount; i++ ) {
1689             mintToAdmin(_addresses[i]);
1690         }
1691     }
1692 
1693     
1694     /////////////// GENERIC MINT FUNCTIONS
1695     /**
1696     * @dev Mints a single token to an address.
1697     * fee may or may not be required*
1698     * @param _to address of the future owner of the token
1699     */
1700     function mintTo(address _to) public payable {
1701         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3666");
1702         require(mintingOpen == true, "Minting is not open right now!");
1703         
1704         
1705         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1706         
1707         _safeMint(_to, 1, false);
1708     }
1709 
1710     /**
1711     * @dev Mints a token to an address with a tokenURI.
1712     * fee may or may not be required*
1713     * @param _to address of the future owner of the token
1714     * @param _amount number of tokens to mint
1715     */
1716     function mintToMultiple(address _to, uint256 _amount) public payable {
1717         require(_amount >= 1, "Must mint at least 1 token");
1718         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1719         require(mintingOpen == true, "Minting is not open right now!");
1720         
1721         
1722         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3666");
1723         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1724 
1725         _safeMint(_to, _amount, false);
1726     }
1727 
1728     function openMinting() public onlyOwner {
1729         mintingOpen = true;
1730     }
1731 
1732     function stopMinting() public onlyOwner {
1733         mintingOpen = false;
1734     }
1735 
1736     
1737 
1738     
1739 
1740     
1741     /**
1742      * @dev Allows owner to set Max mints per tx
1743      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1744      */
1745      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1746          require(_newMaxMint >= 1, "Max mint must be at least 1");
1747          maxBatchSize = _newMaxMint;
1748      }
1749     
1750 
1751     
1752     function setPrice(uint256 _feeInWei) public onlyOwner {
1753         PRICE = _feeInWei;
1754     }
1755 
1756     function getPrice(uint256 _count) private view returns (uint256) {
1757         return PRICE.mul(_count);
1758     }
1759 
1760     
1761     
1762     function _baseURI() internal view virtual override returns (string memory) {
1763         return _baseTokenURI;
1764     }
1765 
1766     function baseTokenURI() public view returns (string memory) {
1767         return _baseTokenURI;
1768     }
1769 
1770     function setBaseURI(string calldata baseURI) external onlyOwner {
1771         _baseTokenURI = baseURI;
1772     }
1773 
1774     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1775         return ownershipOf(tokenId);
1776     }
1777 }
1778 
1779 
1780   
1781 // File: contracts/DevilmayCryContract.sol
1782 //SPDX-License-Identifier: MIT
1783 
1784 pragma solidity ^0.8.0;
1785 
1786 contract DevilmayCryContract is RamppERC721A {
1787     constructor() RamppERC721A("Devil may Cry", "Doom"){}
1788 
1789     function contractURI() public pure returns (string memory) {
1790       return "https://us-central1-nft-rampp.cloudfunctions.net/app/jFbw79q3RifhXi2XZ76J/contract-metadata";
1791     }
1792 }
1793   
1794 //*********************************************************************//
1795 //*********************************************************************//  
1796 //                       Rampp v2.0.1
1797 //
1798 //         This smart contract was generated by rampp.xyz.
1799 //            Rampp allows creators like you to launch 
1800 //             large scale NFT communities without code!
1801 //
1802 //    Rampp is not responsible for the content of this contract and
1803 //        hopes it is being used in a responsible and kind way.  
1804 //       Rampp is not associated or affiliated with this project.                                                    
1805 //             Twitter: @Rampp_ ---- rampp.xyz
1806 //*********************************************************************//                                                     
1807 //*********************************************************************// 
