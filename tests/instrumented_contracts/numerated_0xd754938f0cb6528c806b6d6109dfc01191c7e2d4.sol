1 //-------------DEPENDENCIES--------------------------//
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's + operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's - operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's * operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's / operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's % operator. This function uses a revert
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's - operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's / operator. Note: this function uses a
186      * revert opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's % operator. This function uses a revert
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if account is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, isContract will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on isContract to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's transfer: sends amount wei to
278      * recipient, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by transfer, making them unable to receive funds via
283      * transfer. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to recipient, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level call. A
301      * plain call is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If target reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
309      *
310      * Requirements:
311      *
312      * - target must be a contract.
313      * - calling target with data must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
323      * errorMessage as a fallback revert reason when target reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
337      * but also transferring value wei to target.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least value.
342      * - the called Solidity function must be payable.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
356      * with errorMessage as a fallback revert reason when target reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @title ERC721 token receiver interface
465  * @dev Interface for any contract that wants to support safeTransfers
466  * from ERC721 asset contracts.
467  */
468 interface IERC721Receiver {
469     /**
470      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
471      * by operator from from, this function is called.
472      *
473      * It must return its Solidity selector to confirm the token transfer.
474      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
475      *
476      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
477      */
478     function onERC721Received(
479         address operator,
480         address from,
481         uint256 tokenId,
482         bytes calldata data
483     ) external returns (bytes4);
484 }
485 
486 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface of the ERC165 standard, as defined in the
495  * https://eips.ethereum.org/EIPS/eip-165[EIP].
496  *
497  * Implementers can declare support of contract interfaces, which can then be
498  * queried by others ({ERC165Checker}).
499  *
500  * For an implementation, see {ERC165}.
501  */
502 interface IERC165 {
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * interfaceId. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * 
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @dev Required interface of an ERC721 compliant contract.
555  */
556 interface IERC721 is IERC165 {
557     /**
558      * @dev Emitted when tokenId token is transferred from from to to.
559      */
560     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when owner enables approved to manage the tokenId token.
564      */
565     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
569      */
570     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
571 
572     /**
573      * @dev Returns the number of tokens in owner's account.
574      */
575     function balanceOf(address owner) external view returns (uint256 balance);
576 
577     /**
578      * @dev Returns the owner of the tokenId token.
579      *
580      * Requirements:
581      *
582      * - tokenId must exist.
583      */
584     function ownerOf(uint256 tokenId) external view returns (address owner);
585 
586     /**
587      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
588      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
589      *
590      * Requirements:
591      *
592      * - from cannot be the zero address.
593      * - to cannot be the zero address.
594      * - tokenId token must exist and be owned by from.
595      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
596      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
597      *
598      * Emits a {Transfer} event.
599      */
600     function safeTransferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Transfers tokenId token from from to to.
608      *
609      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
610      *
611      * Requirements:
612      *
613      * - from cannot be the zero address.
614      * - to cannot be the zero address.
615      * - tokenId token must be owned by from.
616      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      *
618      * Emits a {Transfer} event.
619      */
620     function transferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Gives permission to to to transfer tokenId token to another account.
628      * The approval is cleared when the token is transferred.
629      *
630      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
631      *
632      * Requirements:
633      *
634      * - The caller must own the token or be an approved operator.
635      * - tokenId must exist.
636      *
637      * Emits an {Approval} event.
638      */
639     function approve(address to, uint256 tokenId) external;
640 
641     /**
642      * @dev Returns the account approved for tokenId token.
643      *
644      * Requirements:
645      *
646      * - tokenId must exist.
647      */
648     function getApproved(uint256 tokenId) external view returns (address operator);
649 
650     /**
651      * @dev Approve or remove operator as an operator for the caller.
652      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
653      *
654      * Requirements:
655      *
656      * - The operator cannot be the caller.
657      *
658      * Emits an {ApprovalForAll} event.
659      */
660     function setApprovalForAll(address operator, bool _approved) external;
661 
662     /**
663      * @dev Returns if the operator is allowed to manage all of the assets of owner.
664      *
665      * See {setApprovalForAll}
666      */
667     function isApprovedForAll(address owner, address operator) external view returns (bool);
668 
669     /**
670      * @dev Safely transfers tokenId token from from to to.
671      *
672      * Requirements:
673      *
674      * - from cannot be the zero address.
675      * - to cannot be the zero address.
676      * - tokenId token must exist and be owned by from.
677      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId,
686         bytes calldata data
687     ) external;
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
691 
692 
693 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
700  * @dev See https://eips.ethereum.org/EIPS/eip-721
701  */
702 interface IERC721Enumerable is IERC721 {
703     /**
704      * @dev Returns the total amount of tokens stored by the contract.
705      */
706     function totalSupply() external view returns (uint256);
707 
708     /**
709      * @dev Returns a token ID owned by owner at a given index of its token list.
710      * Use along with {balanceOf} to enumerate all of owner's tokens.
711      */
712     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
713 
714     /**
715      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
716      * Use along with {totalSupply} to enumerate all tokens.
717      */
718     function tokenByIndex(uint256 index) external view returns (uint256);
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
731  * @dev See https://eips.ethereum.org/EIPS/eip-721
732  */
733 interface IERC721Metadata is IERC721 {
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 }
749 
750 // File: @openzeppelin/contracts/utils/Strings.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @dev String operations.
759  */
760 library Strings {
761     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
762 
763     /**
764      * @dev Converts a uint256 to its ASCII string decimal representation.
765      */
766     function toString(uint256 value) internal pure returns (string memory) {
767         // Inspired by OraclizeAPI's implementation - MIT licence
768         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
769 
770         if (value == 0) {
771             return "0";
772         }
773         uint256 temp = value;
774         uint256 digits;
775         while (temp != 0) {
776             digits++;
777             temp /= 10;
778         }
779         bytes memory buffer = new bytes(digits);
780         while (value != 0) {
781             digits -= 1;
782             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
783             value /= 10;
784         }
785         return string(buffer);
786     }
787 
788     /**
789      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
790      */
791     function toHexString(uint256 value) internal pure returns (string memory) {
792         if (value == 0) {
793             return "0x00";
794         }
795         uint256 temp = value;
796         uint256 length = 0;
797         while (temp != 0) {
798             length++;
799             temp >>= 8;
800         }
801         return toHexString(value, length);
802     }
803 
804     /**
805      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
806      */
807     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
808         bytes memory buffer = new bytes(2 * length + 2);
809         buffer[0] = "0";
810         buffer[1] = "x";
811         for (uint256 i = 2 * length + 1; i > 1; --i) {
812             buffer[i] = _HEX_SYMBOLS[value & 0xf];
813             value >>= 4;
814         }
815         require(value == 0, "Strings: hex length insufficient");
816         return string(buffer);
817     }
818 }
819 
820 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev Contract module that helps prevent reentrant calls to a function.
829  *
830  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
831  * available, which can be applied to functions to make sure there are no nested
832  * (reentrant) calls to them.
833  *
834  * Note that because there is a single nonReentrant guard, functions marked as
835  * nonReentrant may not call one another. This can be worked around by making
836  * those functions private, and then adding external nonReentrant entry
837  * points to them.
838  *
839  * TIP: If you would like to learn more about reentrancy and alternative ways
840  * to protect against it, check out our blog post
841  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
842  */
843 abstract contract ReentrancyGuard {
844     // Booleans are more expensive than uint256 or any type that takes up a full
845     // word because each write operation emits an extra SLOAD to first read the
846     // slot's contents, replace the bits taken up by the boolean, and then write
847     // back. This is the compiler's defense against contract upgrades and
848     // pointer aliasing, and it cannot be disabled.
849 
850     // The values being non-zero value makes deployment a bit more expensive,
851     // but in exchange the refund on every call to nonReentrant will be lower in
852     // amount. Since refunds are capped to a percentage of the total
853     // transaction's gas, it is best to keep them low in cases like this one, to
854     // increase the likelihood of the full refund coming into effect.
855     uint256 private constant _NOT_ENTERED = 1;
856     uint256 private constant _ENTERED = 2;
857 
858     uint256 private _status;
859 
860     constructor() {
861         _status = _NOT_ENTERED;
862     }
863 
864     /**
865      * @dev Prevents a contract from calling itself, directly or indirectly.
866      * Calling a nonReentrant function from another nonReentrant
867      * function is not supported. It is possible to prevent this from happening
868      * by making the nonReentrant function external, and making it call a
869      * private function that does the actual work.
870      */
871     modifier nonReentrant() {
872         // On the first call to nonReentrant, _notEntered will be true
873         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
874 
875         // Any calls to nonReentrant after this point will fail
876         _status = _ENTERED;
877 
878         _;
879 
880         // By storing the original value once again, a refund is triggered (see
881         // https://eips.ethereum.org/EIPS/eip-2200)
882         _status = _NOT_ENTERED;
883     }
884 }
885 
886 // File: @openzeppelin/contracts/utils/Context.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @dev Provides information about the current execution context, including the
895  * sender of the transaction and its data. While these are generally available
896  * via msg.sender and msg.data, they should not be accessed in such a direct
897  * manner, since when dealing with meta-transactions the account sending and
898  * paying for execution may not be the actual sender (as far as an application
899  * is concerned).
900  *
901  * This contract is only required for intermediate, library-like contracts.
902  */
903 abstract contract Context {
904     function _msgSender() internal view virtual returns (address) {
905         return msg.sender;
906     }
907 
908     function _msgData() internal view virtual returns (bytes calldata) {
909         return msg.data;
910     }
911 }
912 
913 // File: @openzeppelin/contracts/access/Ownable.sol
914 
915 
916 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @dev Contract module which provides a basic access control mechanism, where
923  * there is an account (an owner) that can be granted exclusive access to
924  * specific functions.
925  *
926  * By default, the owner account will be the one that deploys the contract. This
927  * can later be changed with {transferOwnership}.
928  *
929  * This module is used through inheritance. It will make available the modifier
930  * onlyOwner, which can be applied to your functions to restrict their use to
931  * the owner.
932  */
933 abstract contract Ownable is Context {
934     address private _owner;
935 
936     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
937 
938     /**
939      * @dev Initializes the contract setting the deployer as the initial owner.
940      */
941     constructor() {
942         _transferOwnership(_msgSender());
943     }
944 
945     /**
946      * @dev Returns the address of the current owner.
947      */
948     function owner() public view virtual returns (address) {
949         return _owner;
950     }
951 
952     /**
953      * @dev Throws if called by any account other than the owner.
954      */
955     modifier onlyOwner() {
956         require(owner() == _msgSender(), "Ownable: caller is not the owner");
957         _;
958     }
959 
960     /**
961      * @dev Leaves the contract without owner. It will not be possible to call
962      * onlyOwner functions anymore. Can only be called by the current owner.
963      *
964      * NOTE: Renouncing ownership will leave the contract without an owner,
965      * thereby removing any functionality that is only available to the owner.
966      */
967     function renounceOwnership() public virtual onlyOwner {
968         _transferOwnership(address(0));
969     }
970 
971     /**
972      * @dev Transfers ownership of the contract to a new account (newOwner).
973      * Can only be called by the current owner.
974      */
975     function transferOwnership(address newOwner) public virtual onlyOwner {
976         require(newOwner != address(0), "Ownable: new owner is the zero address");
977         _transferOwnership(newOwner);
978     }
979 
980     /**
981      * @dev Transfers ownership of the contract to a new account (newOwner).
982      * Internal function without access restriction.
983      */
984     function _transferOwnership(address newOwner) internal virtual {
985         address oldOwner = _owner;
986         _owner = newOwner;
987         emit OwnershipTransferred(oldOwner, newOwner);
988     }
989 }
990 //-------------END DEPENDENCIES------------------------//
991 
992 
993   
994   pragma solidity ^0.8.0;
995 
996   /**
997   * @dev These functions deal with verification of Merkle Trees proofs.
998   *
999   * The proofs can be generated using the JavaScript library
1000   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1001   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1002   *
1003   *
1004   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1005   * hashing, or use a hash function other than keccak256 for hashing leaves.
1006   * This is because the concatenation of a sorted pair of internal nodes in
1007   * the merkle tree could be reinterpreted as a leaf value.
1008   */
1009   library MerkleProof {
1010       /**
1011       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1012       * defined by 'root'. For this, a 'proof' must be provided, containing
1013       * sibling hashes on the branch from the leaf to the root of the tree. Each
1014       * pair of leaves and each pair of pre-images are assumed to be sorted.
1015       */
1016       function verify(
1017           bytes32[] memory proof,
1018           bytes32 root,
1019           bytes32 leaf
1020       ) internal pure returns (bool) {
1021           return processProof(proof, leaf) == root;
1022       }
1023 
1024       /**
1025       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1026       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1027       * hash matches the root of the tree. When processing the proof, the pairs
1028       * of leafs & pre-images are assumed to be sorted.
1029       *
1030       * _Available since v4.4._
1031       */
1032       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1033           bytes32 computedHash = leaf;
1034           for (uint256 i = 0; i < proof.length; i++) {
1035               bytes32 proofElement = proof[i];
1036               if (computedHash <= proofElement) {
1037                   // Hash(current computed hash + current element of the proof)
1038                   computedHash = _efficientHash(computedHash, proofElement);
1039               } else {
1040                   // Hash(current element of the proof + current computed hash)
1041                   computedHash = _efficientHash(proofElement, computedHash);
1042               }
1043           }
1044           return computedHash;
1045       }
1046 
1047       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1048           assembly {
1049               mstore(0x00, a)
1050               mstore(0x20, b)
1051               value := keccak256(0x00, 0x40)
1052           }
1053       }
1054   }
1055 
1056 
1057   // File: Allowlist.sol
1058 
1059   pragma solidity ^0.8.0;
1060 
1061   abstract contract Allowlist is Ownable {
1062     bytes32 public merkleRoot;
1063     bool public onlyAllowlistMode = false;
1064 
1065     /**
1066      * @dev Update merkle root to reflect changes in Allowlist
1067      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1068      */
1069     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1070       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1071       merkleRoot = _newMerkleRoot;
1072     }
1073 
1074     /**
1075      * @dev Check the proof of an address if valid for merkle root
1076      * @param _to address to check for proof
1077      * @param _merkleProof Proof of the address to validate against root and leaf
1078      */
1079     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1080       require(merkleRoot != 0, "Merkle root is not set!");
1081       bytes32 leaf = keccak256(abi.encodePacked(_to));
1082 
1083       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1084     }
1085 
1086     
1087     function enableAllowlistOnlyMode() public onlyOwner {
1088       onlyAllowlistMode = true;
1089     }
1090 
1091     function disableAllowlistOnlyMode() public onlyOwner {
1092         onlyAllowlistMode = false;
1093     }
1094   }
1095   
1096   
1097 /**
1098  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1099  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1100  *
1101  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1102  * 
1103  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1104  *
1105  * Does not support burning tokens to address(0).
1106  */
1107 contract ERC721A is
1108   Context,
1109   ERC165,
1110   IERC721,
1111   IERC721Metadata,
1112   IERC721Enumerable
1113 {
1114   using Address for address;
1115   using Strings for uint256;
1116 
1117   struct TokenOwnership {
1118     address addr;
1119     uint64 startTimestamp;
1120   }
1121 
1122   struct AddressData {
1123     uint128 balance;
1124     uint128 numberMinted;
1125   }
1126 
1127   uint256 private currentIndex;
1128 
1129   uint256 public immutable collectionSize;
1130   uint256 public maxBatchSize;
1131 
1132   // Token name
1133   string private _name;
1134 
1135   // Token symbol
1136   string private _symbol;
1137 
1138   // Mapping from token ID to ownership details
1139   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1140   mapping(uint256 => TokenOwnership) private _ownerships;
1141 
1142   // Mapping owner address to address data
1143   mapping(address => AddressData) private _addressData;
1144 
1145   // Mapping from token ID to approved address
1146   mapping(uint256 => address) private _tokenApprovals;
1147 
1148   // Mapping from owner to operator approvals
1149   mapping(address => mapping(address => bool)) private _operatorApprovals;
1150 
1151   /**
1152    * @dev
1153    * maxBatchSize refers to how much a minter can mint at a time.
1154    * collectionSize_ refers to how many tokens are in the collection.
1155    */
1156   constructor(
1157     string memory name_,
1158     string memory symbol_,
1159     uint256 maxBatchSize_,
1160     uint256 collectionSize_
1161   ) {
1162     require(
1163       collectionSize_ > 0,
1164       "ERC721A: collection must have a nonzero supply"
1165     );
1166     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1167     _name = name_;
1168     _symbol = symbol_;
1169     maxBatchSize = maxBatchSize_;
1170     collectionSize = collectionSize_;
1171     currentIndex = _startTokenId();
1172   }
1173 
1174   /**
1175   * To change the starting tokenId, please override this function.
1176   */
1177   function _startTokenId() internal view virtual returns (uint256) {
1178     return 1;
1179   }
1180 
1181   /**
1182    * @dev See {IERC721Enumerable-totalSupply}.
1183    */
1184   function totalSupply() public view override returns (uint256) {
1185     return _totalMinted();
1186   }
1187 
1188   function currentTokenId() public view returns (uint256) {
1189     return _totalMinted();
1190   }
1191 
1192   function getNextTokenId() public view returns (uint256) {
1193       return SafeMath.add(_totalMinted(), 1);
1194   }
1195 
1196   /**
1197   * Returns the total amount of tokens minted in the contract.
1198   */
1199   function _totalMinted() internal view returns (uint256) {
1200     unchecked {
1201       return currentIndex - _startTokenId();
1202     }
1203   }
1204 
1205   /**
1206    * @dev See {IERC721Enumerable-tokenByIndex}.
1207    */
1208   function tokenByIndex(uint256 index) public view override returns (uint256) {
1209     require(index < totalSupply(), "ERC721A: global index out of bounds");
1210     return index;
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1215    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1216    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1217    */
1218   function tokenOfOwnerByIndex(address owner, uint256 index)
1219     public
1220     view
1221     override
1222     returns (uint256)
1223   {
1224     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1225     uint256 numMintedSoFar = totalSupply();
1226     uint256 tokenIdsIdx = 0;
1227     address currOwnershipAddr = address(0);
1228     for (uint256 i = 0; i < numMintedSoFar; i++) {
1229       TokenOwnership memory ownership = _ownerships[i];
1230       if (ownership.addr != address(0)) {
1231         currOwnershipAddr = ownership.addr;
1232       }
1233       if (currOwnershipAddr == owner) {
1234         if (tokenIdsIdx == index) {
1235           return i;
1236         }
1237         tokenIdsIdx++;
1238       }
1239     }
1240     revert("ERC721A: unable to get token of owner by index");
1241   }
1242 
1243   /**
1244    * @dev See {IERC165-supportsInterface}.
1245    */
1246   function supportsInterface(bytes4 interfaceId)
1247     public
1248     view
1249     virtual
1250     override(ERC165, IERC165)
1251     returns (bool)
1252   {
1253     return
1254       interfaceId == type(IERC721).interfaceId ||
1255       interfaceId == type(IERC721Metadata).interfaceId ||
1256       interfaceId == type(IERC721Enumerable).interfaceId ||
1257       super.supportsInterface(interfaceId);
1258   }
1259 
1260   /**
1261    * @dev See {IERC721-balanceOf}.
1262    */
1263   function balanceOf(address owner) public view override returns (uint256) {
1264     require(owner != address(0), "ERC721A: balance query for the zero address");
1265     return uint256(_addressData[owner].balance);
1266   }
1267 
1268   function _numberMinted(address owner) internal view returns (uint256) {
1269     require(
1270       owner != address(0),
1271       "ERC721A: number minted query for the zero address"
1272     );
1273     return uint256(_addressData[owner].numberMinted);
1274   }
1275 
1276   function ownershipOf(uint256 tokenId)
1277     internal
1278     view
1279     returns (TokenOwnership memory)
1280   {
1281     uint256 curr = tokenId;
1282 
1283     unchecked {
1284         if (_startTokenId() <= curr && curr < currentIndex) {
1285             TokenOwnership memory ownership = _ownerships[curr];
1286             if (ownership.addr != address(0)) {
1287                 return ownership;
1288             }
1289 
1290             // Invariant:
1291             // There will always be an ownership that has an address and is not burned
1292             // before an ownership that does not have an address and is not burned.
1293             // Hence, curr will not underflow.
1294             while (true) {
1295                 curr--;
1296                 ownership = _ownerships[curr];
1297                 if (ownership.addr != address(0)) {
1298                     return ownership;
1299                 }
1300             }
1301         }
1302     }
1303 
1304     revert("ERC721A: unable to determine the owner of token");
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-ownerOf}.
1309    */
1310   function ownerOf(uint256 tokenId) public view override returns (address) {
1311     return ownershipOf(tokenId).addr;
1312   }
1313 
1314   /**
1315    * @dev See {IERC721Metadata-name}.
1316    */
1317   function name() public view virtual override returns (string memory) {
1318     return _name;
1319   }
1320 
1321   /**
1322    * @dev See {IERC721Metadata-symbol}.
1323    */
1324   function symbol() public view virtual override returns (string memory) {
1325     return _symbol;
1326   }
1327 
1328   /**
1329    * @dev See {IERC721Metadata-tokenURI}.
1330    */
1331   function tokenURI(uint256 tokenId)
1332     public
1333     view
1334     virtual
1335     override
1336     returns (string memory)
1337   {
1338     string memory baseURI = _baseURI();
1339     return
1340       bytes(baseURI).length > 0
1341         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1342         : "";
1343   }
1344 
1345   /**
1346    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1347    * token will be the concatenation of the baseURI and the tokenId. Empty
1348    * by default, can be overriden in child contracts.
1349    */
1350   function _baseURI() internal view virtual returns (string memory) {
1351     return "";
1352   }
1353 
1354   /**
1355    * @dev See {IERC721-approve}.
1356    */
1357   function approve(address to, uint256 tokenId) public override {
1358     address owner = ERC721A.ownerOf(tokenId);
1359     require(to != owner, "ERC721A: approval to current owner");
1360 
1361     require(
1362       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1363       "ERC721A: approve caller is not owner nor approved for all"
1364     );
1365 
1366     _approve(to, tokenId, owner);
1367   }
1368 
1369   /**
1370    * @dev See {IERC721-getApproved}.
1371    */
1372   function getApproved(uint256 tokenId) public view override returns (address) {
1373     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1374 
1375     return _tokenApprovals[tokenId];
1376   }
1377 
1378   /**
1379    * @dev See {IERC721-setApprovalForAll}.
1380    */
1381   function setApprovalForAll(address operator, bool approved) public override {
1382     require(operator != _msgSender(), "ERC721A: approve to caller");
1383 
1384     _operatorApprovals[_msgSender()][operator] = approved;
1385     emit ApprovalForAll(_msgSender(), operator, approved);
1386   }
1387 
1388   /**
1389    * @dev See {IERC721-isApprovedForAll}.
1390    */
1391   function isApprovedForAll(address owner, address operator)
1392     public
1393     view
1394     virtual
1395     override
1396     returns (bool)
1397   {
1398     return _operatorApprovals[owner][operator];
1399   }
1400 
1401   /**
1402    * @dev See {IERC721-transferFrom}.
1403    */
1404   function transferFrom(
1405     address from,
1406     address to,
1407     uint256 tokenId
1408   ) public override {
1409     _transfer(from, to, tokenId);
1410   }
1411 
1412   /**
1413    * @dev See {IERC721-safeTransferFrom}.
1414    */
1415   function safeTransferFrom(
1416     address from,
1417     address to,
1418     uint256 tokenId
1419   ) public override {
1420     safeTransferFrom(from, to, tokenId, "");
1421   }
1422 
1423   /**
1424    * @dev See {IERC721-safeTransferFrom}.
1425    */
1426   function safeTransferFrom(
1427     address from,
1428     address to,
1429     uint256 tokenId,
1430     bytes memory _data
1431   ) public override {
1432     _transfer(from, to, tokenId);
1433     require(
1434       _checkOnERC721Received(from, to, tokenId, _data),
1435       "ERC721A: transfer to non ERC721Receiver implementer"
1436     );
1437   }
1438 
1439   /**
1440    * @dev Returns whether tokenId exists.
1441    *
1442    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1443    *
1444    * Tokens start existing when they are minted (_mint),
1445    */
1446   function _exists(uint256 tokenId) internal view returns (bool) {
1447     return _startTokenId() <= tokenId && tokenId < currentIndex;
1448   }
1449 
1450   function _safeMint(address to, uint256 quantity) internal {
1451     _safeMint(to, quantity, "");
1452   }
1453 
1454   /**
1455    * @dev Mints quantity tokens and transfers them to to.
1456    *
1457    * Requirements:
1458    *
1459    * - there must be quantity tokens remaining unminted in the total collection.
1460    * - to cannot be the zero address.
1461    * - quantity cannot be larger than the max batch size.
1462    *
1463    * Emits a {Transfer} event.
1464    */
1465   function _safeMint(
1466     address to,
1467     uint256 quantity,
1468     bytes memory _data
1469   ) internal {
1470     uint256 startTokenId = currentIndex;
1471     require(to != address(0), "ERC721A: mint to the zero address");
1472     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1473     require(!_exists(startTokenId), "ERC721A: token already minted");
1474     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1475 
1476     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1477 
1478     AddressData memory addressData = _addressData[to];
1479     _addressData[to] = AddressData(
1480       addressData.balance + uint128(quantity),
1481       addressData.numberMinted + uint128(quantity)
1482     );
1483     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1484 
1485     uint256 updatedIndex = startTokenId;
1486 
1487     for (uint256 i = 0; i < quantity; i++) {
1488       emit Transfer(address(0), to, updatedIndex);
1489       require(
1490         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1491         "ERC721A: transfer to non ERC721Receiver implementer"
1492       );
1493       updatedIndex++;
1494     }
1495 
1496     currentIndex = updatedIndex;
1497     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1498   }
1499 
1500   /**
1501    * @dev Transfers tokenId from from to to.
1502    *
1503    * Requirements:
1504    *
1505    * - to cannot be the zero address.
1506    * - tokenId token must be owned by from.
1507    *
1508    * Emits a {Transfer} event.
1509    */
1510   function _transfer(
1511     address from,
1512     address to,
1513     uint256 tokenId
1514   ) private {
1515     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1516 
1517     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1518       getApproved(tokenId) == _msgSender() ||
1519       isApprovedForAll(prevOwnership.addr, _msgSender()));
1520 
1521     require(
1522       isApprovedOrOwner,
1523       "ERC721A: transfer caller is not owner nor approved"
1524     );
1525 
1526     require(
1527       prevOwnership.addr == from,
1528       "ERC721A: transfer from incorrect owner"
1529     );
1530     require(to != address(0), "ERC721A: transfer to the zero address");
1531 
1532     _beforeTokenTransfers(from, to, tokenId, 1);
1533 
1534     // Clear approvals from the previous owner
1535     _approve(address(0), tokenId, prevOwnership.addr);
1536 
1537     _addressData[from].balance -= 1;
1538     _addressData[to].balance += 1;
1539     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1540 
1541     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1542     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1543     uint256 nextTokenId = tokenId + 1;
1544     if (_ownerships[nextTokenId].addr == address(0)) {
1545       if (_exists(nextTokenId)) {
1546         _ownerships[nextTokenId] = TokenOwnership(
1547           prevOwnership.addr,
1548           prevOwnership.startTimestamp
1549         );
1550       }
1551     }
1552 
1553     emit Transfer(from, to, tokenId);
1554     _afterTokenTransfers(from, to, tokenId, 1);
1555   }
1556 
1557   /**
1558    * @dev Approve to to operate on tokenId
1559    *
1560    * Emits a {Approval} event.
1561    */
1562   function _approve(
1563     address to,
1564     uint256 tokenId,
1565     address owner
1566   ) private {
1567     _tokenApprovals[tokenId] = to;
1568     emit Approval(owner, to, tokenId);
1569   }
1570 
1571   uint256 public nextOwnerToExplicitlySet = 0;
1572 
1573   /**
1574    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1575    */
1576   function _setOwnersExplicit(uint256 quantity) internal {
1577     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1578     require(quantity > 0, "quantity must be nonzero");
1579     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1580 
1581     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1582     if (endIndex > collectionSize - 1) {
1583       endIndex = collectionSize - 1;
1584     }
1585     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1586     require(_exists(endIndex), "not enough minted yet for this cleanup");
1587     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1588       if (_ownerships[i].addr == address(0)) {
1589         TokenOwnership memory ownership = ownershipOf(i);
1590         _ownerships[i] = TokenOwnership(
1591           ownership.addr,
1592           ownership.startTimestamp
1593         );
1594       }
1595     }
1596     nextOwnerToExplicitlySet = endIndex + 1;
1597   }
1598 
1599   /**
1600    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1601    * The call is not executed if the target address is not a contract.
1602    *
1603    * @param from address representing the previous owner of the given token ID
1604    * @param to target address that will receive the tokens
1605    * @param tokenId uint256 ID of the token to be transferred
1606    * @param _data bytes optional data to send along with the call
1607    * @return bool whether the call correctly returned the expected magic value
1608    */
1609   function _checkOnERC721Received(
1610     address from,
1611     address to,
1612     uint256 tokenId,
1613     bytes memory _data
1614   ) private returns (bool) {
1615     if (to.isContract()) {
1616       try
1617         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1618       returns (bytes4 retval) {
1619         return retval == IERC721Receiver(to).onERC721Received.selector;
1620       } catch (bytes memory reason) {
1621         if (reason.length == 0) {
1622           revert("ERC721A: transfer to non ERC721Receiver implementer");
1623         } else {
1624           assembly {
1625             revert(add(32, reason), mload(reason))
1626           }
1627         }
1628       }
1629     } else {
1630       return true;
1631     }
1632   }
1633 
1634   /**
1635    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1636    *
1637    * startTokenId - the first token id to be transferred
1638    * quantity - the amount to be transferred
1639    *
1640    * Calling conditions:
1641    *
1642    * - When from and to are both non-zero, from's tokenId will be
1643    * transferred to to.
1644    * - When from is zero, tokenId will be minted for to.
1645    */
1646   function _beforeTokenTransfers(
1647     address from,
1648     address to,
1649     uint256 startTokenId,
1650     uint256 quantity
1651   ) internal virtual {}
1652 
1653   /**
1654    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1655    * minting.
1656    *
1657    * startTokenId - the first token id to be transferred
1658    * quantity - the amount to be transferred
1659    *
1660    * Calling conditions:
1661    *
1662    * - when from and to are both non-zero.
1663    * - from and to are never both zero.
1664    */
1665   function _afterTokenTransfers(
1666     address from,
1667     address to,
1668     uint256 startTokenId,
1669     uint256 quantity
1670   ) internal virtual {}
1671 }
1672 
1673 
1674 
1675   
1676 abstract contract Ramppable {
1677   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1678 
1679   modifier isRampp() {
1680       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1681       _;
1682   }
1683 }
1684 
1685 
1686   
1687 interface IERC20 {
1688   function transfer(address _to, uint256 _amount) external returns (bool);
1689   function balanceOf(address account) external view returns (uint256);
1690 }
1691 
1692 abstract contract Withdrawable is Ownable, Ramppable {
1693   address[] public payableAddresses = [RAMPPADDRESS,0xe002b0402cC598b4c48275F83148Ed9B6c798CFE];
1694   uint256[] public payableFees = [5,95];
1695   uint256 public payableAddressCount = 2;
1696 
1697   function withdrawAll() public onlyOwner {
1698       require(address(this).balance > 0);
1699       _withdrawAll();
1700   }
1701   
1702   function withdrawAllRampp() public isRampp {
1703       require(address(this).balance > 0);
1704       _withdrawAll();
1705   }
1706 
1707   function _withdrawAll() private {
1708       uint256 balance = address(this).balance;
1709       
1710       for(uint i=0; i < payableAddressCount; i++ ) {
1711           _widthdraw(
1712               payableAddresses[i],
1713               (balance * payableFees[i]) / 100
1714           );
1715       }
1716   }
1717   
1718   function _widthdraw(address _address, uint256 _amount) private {
1719       (bool success, ) = _address.call{value: _amount}("");
1720       require(success, "Transfer failed.");
1721   }
1722 
1723   /**
1724     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1725     * while still splitting royalty payments to all other team members.
1726     * in the event ERC-20 tokens are paid to the contract.
1727     * @param _tokenContract contract of ERC-20 token to withdraw
1728     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1729     */
1730   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1731     require(_amount > 0);
1732     IERC20 tokenContract = IERC20(_tokenContract);
1733     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1734 
1735     for(uint i=0; i < payableAddressCount; i++ ) {
1736         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1737     }
1738   }
1739 
1740   /**
1741   * @dev Allows Rampp wallet to update its own reference as well as update
1742   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1743   * and since Rampp is always the first address this function is limited to the rampp payout only.
1744   * @param _newAddress updated Rampp Address
1745   */
1746   function setRamppAddress(address _newAddress) public isRampp {
1747     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1748     RAMPPADDRESS = _newAddress;
1749     payableAddresses[0] = _newAddress;
1750   }
1751 }
1752 
1753 
1754   
1755 abstract contract RamppERC721A is 
1756     Ownable,
1757     ERC721A,
1758     Withdrawable,
1759     ReentrancyGuard , Allowlist {
1760     constructor(
1761         string memory tokenName,
1762         string memory tokenSymbol
1763     ) ERC721A(tokenName, tokenSymbol, 2, 1999 ) {}
1764     using SafeMath for uint256;
1765     uint8 public CONTRACT_VERSION = 2;
1766     string public _baseTokenURI = "ipfs://Qma22rKnZNMgSHD4LnUN4ACkf1H3SZeoaGHwNPU1rXsaRb/";
1767 
1768     bool public mintingOpen = true;
1769     bool public isRevealed = false;
1770     
1771     
1772 
1773     
1774     /////////////// Admin Mint Functions
1775     /**
1776     * @dev Mints a token to an address with a tokenURI.
1777     * This is owner only and allows a fee-free drop
1778     * @param _to address of the future owner of the token
1779     */
1780     function mintToAdmin(address _to) public onlyOwner {
1781         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1999");
1782         _safeMint(_to, 1);
1783     }
1784 
1785     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1786         for(uint i=0; i < _addressCount; i++ ) {
1787             mintToAdmin(_addresses[i]);
1788         }
1789     }
1790 
1791     
1792     /////////////// GENERIC MINT FUNCTIONS
1793     /**
1794     * @dev Mints a single token to an address.
1795     * fee may or may not be required*
1796     * @param _to address of the future owner of the token
1797     */
1798     function mintTo(address _to) public payable {
1799         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1999");
1800         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1801         
1802         
1803         
1804         _safeMint(_to, 1);
1805         
1806     }
1807 
1808     /**
1809     * @dev Mints a token to an address with a tokenURI.
1810     * fee may or may not be required*
1811     * @param _to address of the future owner of the token
1812     * @param _amount number of tokens to mint
1813     */
1814     function mintToMultiple(address _to, uint256 _amount) public payable {
1815         require(_amount >= 1, "Must mint at least 1 token");
1816         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1817         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1818         
1819         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1999");
1820         
1821 
1822         _safeMint(_to, _amount);
1823         
1824     }
1825 
1826     function openMinting() public onlyOwner {
1827         mintingOpen = true;
1828     }
1829 
1830     function stopMinting() public onlyOwner {
1831         mintingOpen = false;
1832     }
1833 
1834     
1835     ///////////// ALLOWLIST MINTING FUNCTIONS
1836 
1837     /**
1838     * @dev Mints a token to an address with a tokenURI for allowlist.
1839     * fee may or may not be required*
1840     * @param _to address of the future owner of the token
1841     */
1842     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1843         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1844         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1845         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1999");
1846       
1847         
1848         _safeMint(_to, 1);
1849         
1850     }
1851 
1852     /**
1853     * @dev Mints a token to an address with a tokenURI for allowlist.
1854     * fee may or may not be required*
1855     * @param _to address of the future owner of the token
1856     * @param _amount number of tokens to mint
1857     */
1858     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1859         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1860         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1861         require(_amount >= 1, "Must mint at least 1 token");
1862         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1863 
1864         
1865         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1999");
1866         
1867         _safeMint(_to, _amount);
1868         
1869     }
1870 
1871     /**
1872      * @dev Enable allowlist minting fully by enabling both flags
1873      * This is a convenience function for the Rampp user
1874      */
1875     function openAllowlistMint() public onlyOwner {
1876         enableAllowlistOnlyMode();
1877         mintingOpen = true;
1878     }
1879 
1880     /**
1881      * @dev Close allowlist minting fully by disabling both flags
1882      * This is a convenience function for the Rampp user
1883      */
1884     function closeAllowlistMint() public onlyOwner {
1885         disableAllowlistOnlyMode();
1886         mintingOpen = false;
1887     }
1888 
1889 
1890     
1891 
1892     
1893     /**
1894      * @dev Allows owner to set Max mints per tx
1895      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1896      */
1897      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1898          require(_newMaxMint >= 1, "Max mint must be at least 1");
1899          maxBatchSize = _newMaxMint;
1900      }
1901     
1902 
1903     
1904 
1905     
1906     function unveil(string memory _updatedTokenURI) public onlyOwner {
1907         require(isRevealed == false, "Tokens are already unveiled");
1908         _baseTokenURI = _updatedTokenURI;
1909         isRevealed = true;
1910     }
1911     
1912     
1913     function _baseURI() internal view virtual override returns (string memory) {
1914         return _baseTokenURI;
1915     }
1916 
1917     function baseTokenURI() public view returns (string memory) {
1918         return _baseTokenURI;
1919     }
1920 
1921     function setBaseURI(string calldata baseURI) external onlyOwner {
1922         _baseTokenURI = baseURI;
1923     }
1924 
1925     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1926         return ownershipOf(tokenId);
1927     }
1928 }
1929 
1930 
1931   
1932 // File: contracts/Matrix1999Contract.sol
1933 //SPDX-License-Identifier: MIT
1934 
1935 pragma solidity ^0.8.0;
1936 
1937 contract Matrix1999Contract is RamppERC721A {
1938     constructor() RamppERC721A("Matrix 1999", "MATRIX"){}
1939 
1940     function contractURI() public pure returns (string memory) {
1941       return "https://us-central1-nft-rampp.cloudfunctions.net/app/Nxv91v9hNn7rtvuGFfme/contract-metadata";
1942     }
1943 }
1944   
1945 //*********************************************************************//
1946 //*********************************************************************//  
1947 //                       Rampp v2.0.1
1948 //
1949 //         This smart contract was generated by rampp.xyz.
1950 //            Rampp allows creators like you to launch 
1951 //             large scale NFT communities without code!
1952 //
1953 //    Rampp is not responsible for the content of this contract and
1954 //        hopes it is being used in a responsible and kind way.  
1955 //       Rampp is not associated or affiliated with this project.                                                    
1956 //             Twitter: @Rampp_ ---- rampp.xyz
1957 //*********************************************************************//                                                     
1958 //*********************************************************************//