1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  __          __        _                     
5 //  \ \        / /       | |                    
6 //   \ \  /\  / /_ _ _ __| |__   ___   __ _ ___ 
7 //    \ \/  \/ / _` | '__| '_ \ / _ \ / _` / __|
8 //     \  /\  / (_| | |  | | | | (_) | (_| \__ \
9 //      \/  \/ \__,_|_|  |_| |_|\___/ \__, |___/
10 //                                     __/ |    
11 //                                    |___/  
12 //
13 //*********************************************************************//
14 //*********************************************************************//
15   
16 //-------------DEPENDENCIES--------------------------//
17 
18 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
19 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 // CAUTION
24 // This version of SafeMath should only be used with Solidity 0.8 or later,
25 // because it relies on the compiler's built in overflow checks.
26 
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations.
29  *
30  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
31  * now has built in overflow checking.
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             uint256 c = a + b;
42             if (c < a) return (false, 0);
43             return (true, c);
44         }
45     }
46 
47     /**
48      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b > a) return (false, 0);
55             return (true, a - b);
56         }
57     }
58 
59     /**
60      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67             // benefit is lost if 'b' is also tested.
68             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69             if (a == 0) return (true, 0);
70             uint256 c = a * b;
71             if (c / a != b) return (false, 0);
72             return (true, c);
73         }
74     }
75 
76     /**
77      * @dev Returns the division of two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a / b);
85         }
86     }
87 
88     /**
89      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             if (b == 0) return (false, 0);
96             return (true, a % b);
97         }
98     }
99 
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's + operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a + b;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's - operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a - b;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's * operator.
133      *
134      * Requirements:
135      *
136      * - Multiplication cannot overflow.
137      */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a * b;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers, reverting on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's / operator.
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a / b;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * reverting when dividing by zero.
159      *
160      * Counterpart to Solidity's % operator. This function uses a revert
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return a % b;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
174      * overflow (when the result is negative).
175      *
176      * CAUTION: This function is deprecated because it requires allocating memory for the error
177      * message unnecessarily. For custom revert reasons use {trySub}.
178      *
179      * Counterpart to Solidity's - operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(
186         uint256 a,
187         uint256 b,
188         string memory errorMessage
189     ) internal pure returns (uint256) {
190         unchecked {
191             require(b <= a, errorMessage);
192             return a - b;
193         }
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's / operator. Note: this function uses a
201      * revert opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b > 0, errorMessage);
215             return a / b;
216         }
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting with custom message when dividing by zero.
222      *
223      * CAUTION: This function is deprecated because it requires allocating memory for the error
224      * message unnecessarily. For custom revert reasons use {tryMod}.
225      *
226      * Counterpart to Solidity's % operator. This function uses a revert
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b > 0, errorMessage);
241             return a % b;
242         }
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if account is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, isContract will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on isContract to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's transfer: sends amount wei to
293      * recipient, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by transfer, making them unable to receive funds via
298      * transfer. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to recipient, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level call. A
316      * plain call is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If target reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
324      *
325      * Requirements:
326      *
327      * - target must be a contract.
328      * - calling target with data must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
338      * errorMessage as a fallback revert reason when target reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
352      * but also transferring value wei to target.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least value.
357      * - the called Solidity function must be payable.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
371      * with errorMessage as a fallback revert reason when target reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459 
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
472 
473 
474 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @title ERC721 token receiver interface
480  * @dev Interface for any contract that wants to support safeTransfers
481  * from ERC721 asset contracts.
482  */
483 interface IERC721Receiver {
484     /**
485      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
486      * by operator from from, this function is called.
487      *
488      * It must return its Solidity selector to confirm the token transfer.
489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
490      *
491      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
492      */
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Interface of the ERC165 standard, as defined in the
510  * https://eips.ethereum.org/EIPS/eip-165[EIP].
511  *
512  * Implementers can declare support of contract interfaces, which can then be
513  * queried by others ({ERC165Checker}).
514  *
515  * For an implementation, see {ERC165}.
516  */
517 interface IERC165 {
518     /**
519      * @dev Returns true if this contract implements the interface defined by
520      * interfaceId. See the corresponding
521      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
522      * to learn more about how these ids are created.
523      *
524      * This function call must use less than 30 000 gas.
525      */
526     function supportsInterface(bytes4 interfaceId) external view returns (bool);
527 }
528 
529 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Implementation of the {IERC165} interface.
539  *
540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
541  * for the additional interface id that will be supported. For example:
542  *
543  * solidity
544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
546  * }
547  * 
548  *
549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
550  */
551 abstract contract ERC165 is IERC165 {
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         return interfaceId == type(IERC165).interfaceId;
557     }
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Required interface of an ERC721 compliant contract.
570  */
571 interface IERC721 is IERC165 {
572     /**
573      * @dev Emitted when tokenId token is transferred from from to to.
574      */
575     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when owner enables approved to manage the tokenId token.
579      */
580     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
581 
582     /**
583      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
584      */
585     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
586 
587     /**
588      * @dev Returns the number of tokens in owner's account.
589      */
590     function balanceOf(address owner) external view returns (uint256 balance);
591 
592     /**
593      * @dev Returns the owner of the tokenId token.
594      *
595      * Requirements:
596      *
597      * - tokenId must exist.
598      */
599     function ownerOf(uint256 tokenId) external view returns (address owner);
600 
601     /**
602      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
603      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
604      *
605      * Requirements:
606      *
607      * - from cannot be the zero address.
608      * - to cannot be the zero address.
609      * - tokenId token must exist and be owned by from.
610      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
611      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Transfers tokenId token from from to to.
623      *
624      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
625      *
626      * Requirements:
627      *
628      * - from cannot be the zero address.
629      * - to cannot be the zero address.
630      * - tokenId token must be owned by from.
631      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Gives permission to to to transfer tokenId token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
646      *
647      * Requirements:
648      *
649      * - The caller must own the token or be an approved operator.
650      * - tokenId must exist.
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Returns the account approved for tokenId token.
658      *
659      * Requirements:
660      *
661      * - tokenId must exist.
662      */
663     function getApproved(uint256 tokenId) external view returns (address operator);
664 
665     /**
666      * @dev Approve or remove operator as an operator for the caller.
667      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
668      *
669      * Requirements:
670      *
671      * - The operator cannot be the caller.
672      *
673      * Emits an {ApprovalForAll} event.
674      */
675     function setApprovalForAll(address operator, bool _approved) external;
676 
677     /**
678      * @dev Returns if the operator is allowed to manage all of the assets of owner.
679      *
680      * See {setApprovalForAll}
681      */
682     function isApprovedForAll(address owner, address operator) external view returns (bool);
683 
684     /**
685      * @dev Safely transfers tokenId token from from to to.
686      *
687      * Requirements:
688      *
689      * - from cannot be the zero address.
690      * - to cannot be the zero address.
691      * - tokenId token must exist and be owned by from.
692      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
694      *
695      * Emits a {Transfer} event.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId,
701         bytes calldata data
702     ) external;
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
706 
707 
708 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
715  * @dev See https://eips.ethereum.org/EIPS/eip-721
716  */
717 interface IERC721Enumerable is IERC721 {
718     /**
719      * @dev Returns the total amount of tokens stored by the contract.
720      */
721     function totalSupply() external view returns (uint256);
722 
723     /**
724      * @dev Returns a token ID owned by owner at a given index of its token list.
725      * Use along with {balanceOf} to enumerate all of owner's tokens.
726      */
727     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
728 
729     /**
730      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
731      * Use along with {totalSupply} to enumerate all tokens.
732      */
733     function tokenByIndex(uint256 index) external view returns (uint256);
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
746  * @dev See https://eips.ethereum.org/EIPS/eip-721
747  */
748 interface IERC721Metadata is IERC721 {
749     /**
750      * @dev Returns the token collection name.
751      */
752     function name() external view returns (string memory);
753 
754     /**
755      * @dev Returns the token collection symbol.
756      */
757     function symbol() external view returns (string memory);
758 
759     /**
760      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
761      */
762     function tokenURI(uint256 tokenId) external view returns (string memory);
763 }
764 
765 // File: @openzeppelin/contracts/utils/Strings.sol
766 
767 
768 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 /**
773  * @dev String operations.
774  */
775 library Strings {
776     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
777 
778     /**
779      * @dev Converts a uint256 to its ASCII string decimal representation.
780      */
781     function toString(uint256 value) internal pure returns (string memory) {
782         // Inspired by OraclizeAPI's implementation - MIT licence
783         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
784 
785         if (value == 0) {
786             return "0";
787         }
788         uint256 temp = value;
789         uint256 digits;
790         while (temp != 0) {
791             digits++;
792             temp /= 10;
793         }
794         bytes memory buffer = new bytes(digits);
795         while (value != 0) {
796             digits -= 1;
797             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
798             value /= 10;
799         }
800         return string(buffer);
801     }
802 
803     /**
804      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
805      */
806     function toHexString(uint256 value) internal pure returns (string memory) {
807         if (value == 0) {
808             return "0x00";
809         }
810         uint256 temp = value;
811         uint256 length = 0;
812         while (temp != 0) {
813             length++;
814             temp >>= 8;
815         }
816         return toHexString(value, length);
817     }
818 
819     /**
820      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
821      */
822     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
823         bytes memory buffer = new bytes(2 * length + 2);
824         buffer[0] = "0";
825         buffer[1] = "x";
826         for (uint256 i = 2 * length + 1; i > 1; --i) {
827             buffer[i] = _HEX_SYMBOLS[value & 0xf];
828             value >>= 4;
829         }
830         require(value == 0, "Strings: hex length insufficient");
831         return string(buffer);
832     }
833 }
834 
835 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @dev Contract module that helps prevent reentrant calls to a function.
844  *
845  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
846  * available, which can be applied to functions to make sure there are no nested
847  * (reentrant) calls to them.
848  *
849  * Note that because there is a single nonReentrant guard, functions marked as
850  * nonReentrant may not call one another. This can be worked around by making
851  * those functions private, and then adding external nonReentrant entry
852  * points to them.
853  *
854  * TIP: If you would like to learn more about reentrancy and alternative ways
855  * to protect against it, check out our blog post
856  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
857  */
858 abstract contract ReentrancyGuard {
859     // Booleans are more expensive than uint256 or any type that takes up a full
860     // word because each write operation emits an extra SLOAD to first read the
861     // slot's contents, replace the bits taken up by the boolean, and then write
862     // back. This is the compiler's defense against contract upgrades and
863     // pointer aliasing, and it cannot be disabled.
864 
865     // The values being non-zero value makes deployment a bit more expensive,
866     // but in exchange the refund on every call to nonReentrant will be lower in
867     // amount. Since refunds are capped to a percentage of the total
868     // transaction's gas, it is best to keep them low in cases like this one, to
869     // increase the likelihood of the full refund coming into effect.
870     uint256 private constant _NOT_ENTERED = 1;
871     uint256 private constant _ENTERED = 2;
872 
873     uint256 private _status;
874 
875     constructor() {
876         _status = _NOT_ENTERED;
877     }
878 
879     /**
880      * @dev Prevents a contract from calling itself, directly or indirectly.
881      * Calling a nonReentrant function from another nonReentrant
882      * function is not supported. It is possible to prevent this from happening
883      * by making the nonReentrant function external, and making it call a
884      * private function that does the actual work.
885      */
886     modifier nonReentrant() {
887         // On the first call to nonReentrant, _notEntered will be true
888         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
889 
890         // Any calls to nonReentrant after this point will fail
891         _status = _ENTERED;
892 
893         _;
894 
895         // By storing the original value once again, a refund is triggered (see
896         // https://eips.ethereum.org/EIPS/eip-2200)
897         _status = _NOT_ENTERED;
898     }
899 }
900 
901 // File: @openzeppelin/contracts/utils/Context.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 /**
909  * @dev Provides information about the current execution context, including the
910  * sender of the transaction and its data. While these are generally available
911  * via msg.sender and msg.data, they should not be accessed in such a direct
912  * manner, since when dealing with meta-transactions the account sending and
913  * paying for execution may not be the actual sender (as far as an application
914  * is concerned).
915  *
916  * This contract is only required for intermediate, library-like contracts.
917  */
918 abstract contract Context {
919     function _msgSender() internal view virtual returns (address) {
920         return msg.sender;
921     }
922 
923     function _msgData() internal view virtual returns (bytes calldata) {
924         return msg.data;
925     }
926 }
927 
928 // File: @openzeppelin/contracts/access/Ownable.sol
929 
930 
931 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @dev Contract module which provides a basic access control mechanism, where
938  * there is an account (an owner) that can be granted exclusive access to
939  * specific functions.
940  *
941  * By default, the owner account will be the one that deploys the contract. This
942  * can later be changed with {transferOwnership}.
943  *
944  * This module is used through inheritance. It will make available the modifier
945  * onlyOwner, which can be applied to your functions to restrict their use to
946  * the owner.
947  */
948 abstract contract Ownable is Context {
949     address private _owner;
950 
951     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
952 
953     /**
954      * @dev Initializes the contract setting the deployer as the initial owner.
955      */
956     constructor() {
957         _transferOwnership(_msgSender());
958     }
959 
960     /**
961      * @dev Returns the address of the current owner.
962      */
963     function owner() public view virtual returns (address) {
964         return _owner;
965     }
966 
967     /**
968      * @dev Throws if called by any account other than the owner.
969      */
970     modifier onlyOwner() {
971         require(owner() == _msgSender(), "Ownable: caller is not the owner");
972         _;
973     }
974 
975     /**
976      * @dev Leaves the contract without owner. It will not be possible to call
977      * onlyOwner functions anymore. Can only be called by the current owner.
978      *
979      * NOTE: Renouncing ownership will leave the contract without an owner,
980      * thereby removing any functionality that is only available to the owner.
981      */
982     function renounceOwnership() public virtual onlyOwner {
983         _transferOwnership(address(0));
984     }
985 
986     /**
987      * @dev Transfers ownership of the contract to a new account (newOwner).
988      * Can only be called by the current owner.
989      */
990     function transferOwnership(address newOwner) public virtual onlyOwner {
991         require(newOwner != address(0), "Ownable: new owner is the zero address");
992         _transferOwnership(newOwner);
993     }
994 
995     /**
996      * @dev Transfers ownership of the contract to a new account (newOwner).
997      * Internal function without access restriction.
998      */
999     function _transferOwnership(address newOwner) internal virtual {
1000         address oldOwner = _owner;
1001         _owner = newOwner;
1002         emit OwnershipTransferred(oldOwner, newOwner);
1003     }
1004 }
1005 //-------------END DEPENDENCIES------------------------//
1006 
1007 
1008   
1009   pragma solidity ^0.8.0;
1010 
1011   /**
1012   * @dev These functions deal with verification of Merkle Trees proofs.
1013   *
1014   * The proofs can be generated using the JavaScript library
1015   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1016   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1017   *
1018   *
1019   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1020   * hashing, or use a hash function other than keccak256 for hashing leaves.
1021   * This is because the concatenation of a sorted pair of internal nodes in
1022   * the merkle tree could be reinterpreted as a leaf value.
1023   */
1024   library MerkleProof {
1025       /**
1026       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1027       * defined by 'root'. For this, a 'proof' must be provided, containing
1028       * sibling hashes on the branch from the leaf to the root of the tree. Each
1029       * pair of leaves and each pair of pre-images are assumed to be sorted.
1030       */
1031       function verify(
1032           bytes32[] memory proof,
1033           bytes32 root,
1034           bytes32 leaf
1035       ) internal pure returns (bool) {
1036           return processProof(proof, leaf) == root;
1037       }
1038 
1039       /**
1040       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1041       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1042       * hash matches the root of the tree. When processing the proof, the pairs
1043       * of leafs & pre-images are assumed to be sorted.
1044       *
1045       * _Available since v4.4._
1046       */
1047       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1048           bytes32 computedHash = leaf;
1049           for (uint256 i = 0; i < proof.length; i++) {
1050               bytes32 proofElement = proof[i];
1051               if (computedHash <= proofElement) {
1052                   // Hash(current computed hash + current element of the proof)
1053                   computedHash = _efficientHash(computedHash, proofElement);
1054               } else {
1055                   // Hash(current element of the proof + current computed hash)
1056                   computedHash = _efficientHash(proofElement, computedHash);
1057               }
1058           }
1059           return computedHash;
1060       }
1061 
1062       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1063           assembly {
1064               mstore(0x00, a)
1065               mstore(0x20, b)
1066               value := keccak256(0x00, 0x40)
1067           }
1068       }
1069   }
1070 
1071 
1072   // File: Allowlist.sol
1073 
1074   pragma solidity ^0.8.0;
1075 
1076   abstract contract Allowlist is Ownable {
1077     bytes32 public merkleRoot;
1078     bool public onlyAllowlistMode = false;
1079 
1080     /**
1081      * @dev Update merkle root to reflect changes in Allowlist
1082      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1083      */
1084     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1085       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1086       merkleRoot = _newMerkleRoot;
1087     }
1088 
1089     /**
1090      * @dev Check the proof of an address if valid for merkle root
1091      * @param _to address to check for proof
1092      * @param _merkleProof Proof of the address to validate against root and leaf
1093      */
1094     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1095       require(merkleRoot != 0, "Merkle root is not set!");
1096       bytes32 leaf = keccak256(abi.encodePacked(_to));
1097 
1098       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1099     }
1100 
1101     
1102     function enableAllowlistOnlyMode() public onlyOwner {
1103       onlyAllowlistMode = true;
1104     }
1105 
1106     function disableAllowlistOnlyMode() public onlyOwner {
1107         onlyAllowlistMode = false;
1108     }
1109   }
1110   
1111   
1112 /**
1113  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1114  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1115  *
1116  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1117  * 
1118  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1119  *
1120  * Does not support burning tokens to address(0).
1121  */
1122 contract ERC721A is
1123   Context,
1124   ERC165,
1125   IERC721,
1126   IERC721Metadata,
1127   IERC721Enumerable
1128 {
1129   using Address for address;
1130   using Strings for uint256;
1131 
1132   struct TokenOwnership {
1133     address addr;
1134     uint64 startTimestamp;
1135   }
1136 
1137   struct AddressData {
1138     uint128 balance;
1139     uint128 numberMinted;
1140   }
1141 
1142   uint256 private currentIndex;
1143 
1144   uint256 public immutable collectionSize;
1145   uint256 public maxBatchSize;
1146 
1147   // Token name
1148   string private _name;
1149 
1150   // Token symbol
1151   string private _symbol;
1152 
1153   // Mapping from token ID to ownership details
1154   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1155   mapping(uint256 => TokenOwnership) private _ownerships;
1156 
1157   // Mapping owner address to address data
1158   mapping(address => AddressData) private _addressData;
1159 
1160   // Mapping from token ID to approved address
1161   mapping(uint256 => address) private _tokenApprovals;
1162 
1163   // Mapping from owner to operator approvals
1164   mapping(address => mapping(address => bool)) private _operatorApprovals;
1165 
1166   /**
1167    * @dev
1168    * maxBatchSize refers to how much a minter can mint at a time.
1169    * collectionSize_ refers to how many tokens are in the collection.
1170    */
1171   constructor(
1172     string memory name_,
1173     string memory symbol_,
1174     uint256 maxBatchSize_,
1175     uint256 collectionSize_
1176   ) {
1177     require(
1178       collectionSize_ > 0,
1179       "ERC721A: collection must have a nonzero supply"
1180     );
1181     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1182     _name = name_;
1183     _symbol = symbol_;
1184     maxBatchSize = maxBatchSize_;
1185     collectionSize = collectionSize_;
1186     currentIndex = _startTokenId();
1187   }
1188 
1189   /**
1190   * To change the starting tokenId, please override this function.
1191   */
1192   function _startTokenId() internal view virtual returns (uint256) {
1193     return 1;
1194   }
1195 
1196   /**
1197    * @dev See {IERC721Enumerable-totalSupply}.
1198    */
1199   function totalSupply() public view override returns (uint256) {
1200     return _totalMinted();
1201   }
1202 
1203   function currentTokenId() public view returns (uint256) {
1204     return _totalMinted();
1205   }
1206 
1207   function getNextTokenId() public view returns (uint256) {
1208       return SafeMath.add(_totalMinted(), 1);
1209   }
1210 
1211   /**
1212   * Returns the total amount of tokens minted in the contract.
1213   */
1214   function _totalMinted() internal view returns (uint256) {
1215     unchecked {
1216       return currentIndex - _startTokenId();
1217     }
1218   }
1219 
1220   /**
1221    * @dev See {IERC721Enumerable-tokenByIndex}.
1222    */
1223   function tokenByIndex(uint256 index) public view override returns (uint256) {
1224     require(index < totalSupply(), "ERC721A: global index out of bounds");
1225     return index;
1226   }
1227 
1228   /**
1229    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1230    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1231    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1232    */
1233   function tokenOfOwnerByIndex(address owner, uint256 index)
1234     public
1235     view
1236     override
1237     returns (uint256)
1238   {
1239     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1240     uint256 numMintedSoFar = totalSupply();
1241     uint256 tokenIdsIdx = 0;
1242     address currOwnershipAddr = address(0);
1243     for (uint256 i = 0; i < numMintedSoFar; i++) {
1244       TokenOwnership memory ownership = _ownerships[i];
1245       if (ownership.addr != address(0)) {
1246         currOwnershipAddr = ownership.addr;
1247       }
1248       if (currOwnershipAddr == owner) {
1249         if (tokenIdsIdx == index) {
1250           return i;
1251         }
1252         tokenIdsIdx++;
1253       }
1254     }
1255     revert("ERC721A: unable to get token of owner by index");
1256   }
1257 
1258   /**
1259    * @dev See {IERC165-supportsInterface}.
1260    */
1261   function supportsInterface(bytes4 interfaceId)
1262     public
1263     view
1264     virtual
1265     override(ERC165, IERC165)
1266     returns (bool)
1267   {
1268     return
1269       interfaceId == type(IERC721).interfaceId ||
1270       interfaceId == type(IERC721Metadata).interfaceId ||
1271       interfaceId == type(IERC721Enumerable).interfaceId ||
1272       super.supportsInterface(interfaceId);
1273   }
1274 
1275   /**
1276    * @dev See {IERC721-balanceOf}.
1277    */
1278   function balanceOf(address owner) public view override returns (uint256) {
1279     require(owner != address(0), "ERC721A: balance query for the zero address");
1280     return uint256(_addressData[owner].balance);
1281   }
1282 
1283   function _numberMinted(address owner) internal view returns (uint256) {
1284     require(
1285       owner != address(0),
1286       "ERC721A: number minted query for the zero address"
1287     );
1288     return uint256(_addressData[owner].numberMinted);
1289   }
1290 
1291   function ownershipOf(uint256 tokenId)
1292     internal
1293     view
1294     returns (TokenOwnership memory)
1295   {
1296     uint256 curr = tokenId;
1297 
1298     unchecked {
1299         if (_startTokenId() <= curr && curr < currentIndex) {
1300             TokenOwnership memory ownership = _ownerships[curr];
1301             if (ownership.addr != address(0)) {
1302                 return ownership;
1303             }
1304 
1305             // Invariant:
1306             // There will always be an ownership that has an address and is not burned
1307             // before an ownership that does not have an address and is not burned.
1308             // Hence, curr will not underflow.
1309             while (true) {
1310                 curr--;
1311                 ownership = _ownerships[curr];
1312                 if (ownership.addr != address(0)) {
1313                     return ownership;
1314                 }
1315             }
1316         }
1317     }
1318 
1319     revert("ERC721A: unable to determine the owner of token");
1320   }
1321 
1322   /**
1323    * @dev See {IERC721-ownerOf}.
1324    */
1325   function ownerOf(uint256 tokenId) public view override returns (address) {
1326     return ownershipOf(tokenId).addr;
1327   }
1328 
1329   /**
1330    * @dev See {IERC721Metadata-name}.
1331    */
1332   function name() public view virtual override returns (string memory) {
1333     return _name;
1334   }
1335 
1336   /**
1337    * @dev See {IERC721Metadata-symbol}.
1338    */
1339   function symbol() public view virtual override returns (string memory) {
1340     return _symbol;
1341   }
1342 
1343   /**
1344    * @dev See {IERC721Metadata-tokenURI}.
1345    */
1346   function tokenURI(uint256 tokenId)
1347     public
1348     view
1349     virtual
1350     override
1351     returns (string memory)
1352   {
1353     string memory baseURI = _baseURI();
1354     return
1355       bytes(baseURI).length > 0
1356         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1357         : "";
1358   }
1359 
1360   /**
1361    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1362    * token will be the concatenation of the baseURI and the tokenId. Empty
1363    * by default, can be overriden in child contracts.
1364    */
1365   function _baseURI() internal view virtual returns (string memory) {
1366     return "";
1367   }
1368 
1369   /**
1370    * @dev See {IERC721-approve}.
1371    */
1372   function approve(address to, uint256 tokenId) public override {
1373     address owner = ERC721A.ownerOf(tokenId);
1374     require(to != owner, "ERC721A: approval to current owner");
1375 
1376     require(
1377       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1378       "ERC721A: approve caller is not owner nor approved for all"
1379     );
1380 
1381     _approve(to, tokenId, owner);
1382   }
1383 
1384   /**
1385    * @dev See {IERC721-getApproved}.
1386    */
1387   function getApproved(uint256 tokenId) public view override returns (address) {
1388     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1389 
1390     return _tokenApprovals[tokenId];
1391   }
1392 
1393   /**
1394    * @dev See {IERC721-setApprovalForAll}.
1395    */
1396   function setApprovalForAll(address operator, bool approved) public override {
1397     require(operator != _msgSender(), "ERC721A: approve to caller");
1398 
1399     _operatorApprovals[_msgSender()][operator] = approved;
1400     emit ApprovalForAll(_msgSender(), operator, approved);
1401   }
1402 
1403   /**
1404    * @dev See {IERC721-isApprovedForAll}.
1405    */
1406   function isApprovedForAll(address owner, address operator)
1407     public
1408     view
1409     virtual
1410     override
1411     returns (bool)
1412   {
1413     return _operatorApprovals[owner][operator];
1414   }
1415 
1416   /**
1417    * @dev See {IERC721-transferFrom}.
1418    */
1419   function transferFrom(
1420     address from,
1421     address to,
1422     uint256 tokenId
1423   ) public override {
1424     _transfer(from, to, tokenId);
1425   }
1426 
1427   /**
1428    * @dev See {IERC721-safeTransferFrom}.
1429    */
1430   function safeTransferFrom(
1431     address from,
1432     address to,
1433     uint256 tokenId
1434   ) public override {
1435     safeTransferFrom(from, to, tokenId, "");
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-safeTransferFrom}.
1440    */
1441   function safeTransferFrom(
1442     address from,
1443     address to,
1444     uint256 tokenId,
1445     bytes memory _data
1446   ) public override {
1447     _transfer(from, to, tokenId);
1448     require(
1449       _checkOnERC721Received(from, to, tokenId, _data),
1450       "ERC721A: transfer to non ERC721Receiver implementer"
1451     );
1452   }
1453 
1454   /**
1455    * @dev Returns whether tokenId exists.
1456    *
1457    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1458    *
1459    * Tokens start existing when they are minted (_mint),
1460    */
1461   function _exists(uint256 tokenId) internal view returns (bool) {
1462     return _startTokenId() <= tokenId && tokenId < currentIndex;
1463   }
1464 
1465   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1466     _safeMint(to, quantity, isAdminMint, "");
1467   }
1468 
1469   /**
1470    * @dev Mints quantity tokens and transfers them to to.
1471    *
1472    * Requirements:
1473    *
1474    * - there must be quantity tokens remaining unminted in the total collection.
1475    * - to cannot be the zero address.
1476    * - quantity cannot be larger than the max batch size.
1477    *
1478    * Emits a {Transfer} event.
1479    */
1480   function _safeMint(
1481     address to,
1482     uint256 quantity,
1483     bool isAdminMint,
1484     bytes memory _data
1485   ) internal {
1486     uint256 startTokenId = currentIndex;
1487     require(to != address(0), "ERC721A: mint to the zero address");
1488     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1489     require(!_exists(startTokenId), "ERC721A: token already minted");
1490 
1491     // For admin mints we do not want to enforce the maxBatchSize limit
1492     if (isAdminMint == false) {
1493         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1494     }
1495 
1496     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1497 
1498     AddressData memory addressData = _addressData[to];
1499     _addressData[to] = AddressData(
1500       addressData.balance + uint128(quantity),
1501       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1502     );
1503     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1504 
1505     uint256 updatedIndex = startTokenId;
1506 
1507     for (uint256 i = 0; i < quantity; i++) {
1508       emit Transfer(address(0), to, updatedIndex);
1509       require(
1510         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1511         "ERC721A: transfer to non ERC721Receiver implementer"
1512       );
1513       updatedIndex++;
1514     }
1515 
1516     currentIndex = updatedIndex;
1517     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1518   }
1519 
1520   /**
1521    * @dev Transfers tokenId from from to to.
1522    *
1523    * Requirements:
1524    *
1525    * - to cannot be the zero address.
1526    * - tokenId token must be owned by from.
1527    *
1528    * Emits a {Transfer} event.
1529    */
1530   function _transfer(
1531     address from,
1532     address to,
1533     uint256 tokenId
1534   ) private {
1535     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1536 
1537     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1538       getApproved(tokenId) == _msgSender() ||
1539       isApprovedForAll(prevOwnership.addr, _msgSender()));
1540 
1541     require(
1542       isApprovedOrOwner,
1543       "ERC721A: transfer caller is not owner nor approved"
1544     );
1545 
1546     require(
1547       prevOwnership.addr == from,
1548       "ERC721A: transfer from incorrect owner"
1549     );
1550     require(to != address(0), "ERC721A: transfer to the zero address");
1551 
1552     _beforeTokenTransfers(from, to, tokenId, 1);
1553 
1554     // Clear approvals from the previous owner
1555     _approve(address(0), tokenId, prevOwnership.addr);
1556 
1557     _addressData[from].balance -= 1;
1558     _addressData[to].balance += 1;
1559     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1560 
1561     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1562     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1563     uint256 nextTokenId = tokenId + 1;
1564     if (_ownerships[nextTokenId].addr == address(0)) {
1565       if (_exists(nextTokenId)) {
1566         _ownerships[nextTokenId] = TokenOwnership(
1567           prevOwnership.addr,
1568           prevOwnership.startTimestamp
1569         );
1570       }
1571     }
1572 
1573     emit Transfer(from, to, tokenId);
1574     _afterTokenTransfers(from, to, tokenId, 1);
1575   }
1576 
1577   /**
1578    * @dev Approve to to operate on tokenId
1579    *
1580    * Emits a {Approval} event.
1581    */
1582   function _approve(
1583     address to,
1584     uint256 tokenId,
1585     address owner
1586   ) private {
1587     _tokenApprovals[tokenId] = to;
1588     emit Approval(owner, to, tokenId);
1589   }
1590 
1591   uint256 public nextOwnerToExplicitlySet = 0;
1592 
1593   /**
1594    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1595    */
1596   function _setOwnersExplicit(uint256 quantity) internal {
1597     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1598     require(quantity > 0, "quantity must be nonzero");
1599     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1600 
1601     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1602     if (endIndex > collectionSize - 1) {
1603       endIndex = collectionSize - 1;
1604     }
1605     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1606     require(_exists(endIndex), "not enough minted yet for this cleanup");
1607     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1608       if (_ownerships[i].addr == address(0)) {
1609         TokenOwnership memory ownership = ownershipOf(i);
1610         _ownerships[i] = TokenOwnership(
1611           ownership.addr,
1612           ownership.startTimestamp
1613         );
1614       }
1615     }
1616     nextOwnerToExplicitlySet = endIndex + 1;
1617   }
1618 
1619   /**
1620    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1621    * The call is not executed if the target address is not a contract.
1622    *
1623    * @param from address representing the previous owner of the given token ID
1624    * @param to target address that will receive the tokens
1625    * @param tokenId uint256 ID of the token to be transferred
1626    * @param _data bytes optional data to send along with the call
1627    * @return bool whether the call correctly returned the expected magic value
1628    */
1629   function _checkOnERC721Received(
1630     address from,
1631     address to,
1632     uint256 tokenId,
1633     bytes memory _data
1634   ) private returns (bool) {
1635     if (to.isContract()) {
1636       try
1637         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1638       returns (bytes4 retval) {
1639         return retval == IERC721Receiver(to).onERC721Received.selector;
1640       } catch (bytes memory reason) {
1641         if (reason.length == 0) {
1642           revert("ERC721A: transfer to non ERC721Receiver implementer");
1643         } else {
1644           assembly {
1645             revert(add(32, reason), mload(reason))
1646           }
1647         }
1648       }
1649     } else {
1650       return true;
1651     }
1652   }
1653 
1654   /**
1655    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1656    *
1657    * startTokenId - the first token id to be transferred
1658    * quantity - the amount to be transferred
1659    *
1660    * Calling conditions:
1661    *
1662    * - When from and to are both non-zero, from's tokenId will be
1663    * transferred to to.
1664    * - When from is zero, tokenId will be minted for to.
1665    */
1666   function _beforeTokenTransfers(
1667     address from,
1668     address to,
1669     uint256 startTokenId,
1670     uint256 quantity
1671   ) internal virtual {}
1672 
1673   /**
1674    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1675    * minting.
1676    *
1677    * startTokenId - the first token id to be transferred
1678    * quantity - the amount to be transferred
1679    *
1680    * Calling conditions:
1681    *
1682    * - when from and to are both non-zero.
1683    * - from and to are never both zero.
1684    */
1685   function _afterTokenTransfers(
1686     address from,
1687     address to,
1688     uint256 startTokenId,
1689     uint256 quantity
1690   ) internal virtual {}
1691 }
1692 
1693 
1694 
1695   
1696 abstract contract Ramppable {
1697   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1698 
1699   modifier isRampp() {
1700       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1701       _;
1702   }
1703 }
1704 
1705 
1706   
1707   
1708 interface IERC20 {
1709   function transfer(address _to, uint256 _amount) external returns (bool);
1710   function balanceOf(address account) external view returns (uint256);
1711 }
1712 
1713 abstract contract Withdrawable is Ownable, Ramppable {
1714   address[] public payableAddresses = [RAMPPADDRESS,0xcD1A43393D98014c892E7ED375C62E9eFbB0E9f8];
1715   uint256[] public payableFees = [5,95];
1716   uint256 public payableAddressCount = 2;
1717 
1718   function withdrawAll() public onlyOwner {
1719       require(address(this).balance > 0);
1720       _withdrawAll();
1721   }
1722   
1723   function withdrawAllRampp() public isRampp {
1724       require(address(this).balance > 0);
1725       _withdrawAll();
1726   }
1727 
1728   function _withdrawAll() private {
1729       uint256 balance = address(this).balance;
1730       
1731       for(uint i=0; i < payableAddressCount; i++ ) {
1732           _widthdraw(
1733               payableAddresses[i],
1734               (balance * payableFees[i]) / 100
1735           );
1736       }
1737   }
1738   
1739   function _widthdraw(address _address, uint256 _amount) private {
1740       (bool success, ) = _address.call{value: _amount}("");
1741       require(success, "Transfer failed.");
1742   }
1743 
1744   /**
1745     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1746     * while still splitting royalty payments to all other team members.
1747     * in the event ERC-20 tokens are paid to the contract.
1748     * @param _tokenContract contract of ERC-20 token to withdraw
1749     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1750     */
1751   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1752     require(_amount > 0);
1753     IERC20 tokenContract = IERC20(_tokenContract);
1754     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1755 
1756     for(uint i=0; i < payableAddressCount; i++ ) {
1757         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1758     }
1759   }
1760 
1761   /**
1762   * @dev Allows Rampp wallet to update its own reference as well as update
1763   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1764   * and since Rampp is always the first address this function is limited to the rampp payout only.
1765   * @param _newAddress updated Rampp Address
1766   */
1767   function setRamppAddress(address _newAddress) public isRampp {
1768     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1769     RAMPPADDRESS = _newAddress;
1770     payableAddresses[0] = _newAddress;
1771   }
1772 }
1773 
1774 
1775   
1776 // File: isFeeable.sol
1777 abstract contract Feeable is Ownable {
1778   using SafeMath for uint256;
1779   uint256 public PRICE = 0.022 ether;
1780 
1781   function setPrice(uint256 _feeInWei) public onlyOwner {
1782     PRICE = _feeInWei;
1783   }
1784 
1785   function getPrice(uint256 _count) public view returns (uint256) {
1786     return PRICE.mul(_count);
1787   }
1788 }
1789 
1790   
1791   
1792 abstract contract RamppERC721A is 
1793     Ownable,
1794     ERC721A,
1795     Withdrawable,
1796     ReentrancyGuard 
1797     , Feeable 
1798     , Allowlist 
1799     
1800 {
1801   constructor(
1802     string memory tokenName,
1803     string memory tokenSymbol
1804   ) ERC721A(tokenName, tokenSymbol, 10, 5555) { }
1805     using SafeMath for uint256;
1806     uint8 public CONTRACT_VERSION = 2;
1807     string public _baseTokenURI = "ipfs://QmUvy5qD1jn7eb4HC5oLhsanNoEkSnNdcMqnxPnoY5A6x9/";
1808 
1809     bool public mintingOpen = true;
1810     
1811     
1812     uint256 public MAX_WALLET_MINTS = 10;
1813 
1814   
1815     /////////////// Admin Mint Functions
1816     /**
1817      * @dev Mints a token to an address with a tokenURI.
1818      * This is owner only and allows a fee-free drop
1819      * @param _to address of the future owner of the token
1820      * @param _qty amount of tokens to drop the owner
1821      */
1822      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1823          require(_qty > 0, "Must mint at least 1 token.");
1824          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5555");
1825          _safeMint(_to, _qty, true);
1826      }
1827 
1828   
1829     /////////////// GENERIC MINT FUNCTIONS
1830     /**
1831     * @dev Mints a single token to an address.
1832     * fee may or may not be required*
1833     * @param _to address of the future owner of the token
1834     */
1835     function mintTo(address _to) public payable {
1836         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1837         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1838         
1839         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1840         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1841         
1842         _safeMint(_to, 1, false);
1843     }
1844 
1845     /**
1846     * @dev Mints a token to an address with a tokenURI.
1847     * fee may or may not be required*
1848     * @param _to address of the future owner of the token
1849     * @param _amount number of tokens to mint
1850     */
1851     function mintToMultiple(address _to, uint256 _amount) public payable {
1852         require(_amount >= 1, "Must mint at least 1 token");
1853         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1854         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1855         
1856         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1857         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1858         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1859 
1860         _safeMint(_to, _amount, false);
1861     }
1862 
1863     function openMinting() public onlyOwner {
1864         mintingOpen = true;
1865     }
1866 
1867     function stopMinting() public onlyOwner {
1868         mintingOpen = false;
1869     }
1870 
1871   
1872     ///////////// ALLOWLIST MINTING FUNCTIONS
1873 
1874     /**
1875     * @dev Mints a token to an address with a tokenURI for allowlist.
1876     * fee may or may not be required*
1877     * @param _to address of the future owner of the token
1878     */
1879     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1880         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1881         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1882         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1883         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1884         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1885         
1886 
1887         _safeMint(_to, 1, false);
1888     }
1889 
1890     /**
1891     * @dev Mints a token to an address with a tokenURI for allowlist.
1892     * fee may or may not be required*
1893     * @param _to address of the future owner of the token
1894     * @param _amount number of tokens to mint
1895     */
1896     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1897         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1898         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1899         require(_amount >= 1, "Must mint at least 1 token");
1900         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1901 
1902         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1903         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1904         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1905         
1906 
1907         _safeMint(_to, _amount, false);
1908     }
1909 
1910     /**
1911      * @dev Enable allowlist minting fully by enabling both flags
1912      * This is a convenience function for the Rampp user
1913      */
1914     function openAllowlistMint() public onlyOwner {
1915         enableAllowlistOnlyMode();
1916         mintingOpen = true;
1917     }
1918 
1919     /**
1920      * @dev Close allowlist minting fully by disabling both flags
1921      * This is a convenience function for the Rampp user
1922      */
1923     function closeAllowlistMint() public onlyOwner {
1924         disableAllowlistOnlyMode();
1925         mintingOpen = false;
1926     }
1927 
1928 
1929   
1930     /**
1931     * @dev Check if wallet over MAX_WALLET_MINTS
1932     * @param _address address in question to check if minted count exceeds max
1933     */
1934     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1935         require(_amount >= 1, "Amount must be greater than or equal to 1");
1936         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1937     }
1938 
1939     /**
1940     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1941     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1942     */
1943     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1944         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1945         MAX_WALLET_MINTS = _newWalletMax;
1946     }
1947     
1948 
1949   
1950     /**
1951      * @dev Allows owner to set Max mints per tx
1952      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1953      */
1954      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1955          require(_newMaxMint >= 1, "Max mint must be at least 1");
1956          maxBatchSize = _newMaxMint;
1957      }
1958     
1959 
1960   
1961 
1962   function _baseURI() internal view virtual override returns(string memory) {
1963     return _baseTokenURI;
1964   }
1965 
1966   function baseTokenURI() public view returns(string memory) {
1967     return _baseTokenURI;
1968   }
1969 
1970   function setBaseURI(string calldata baseURI) external onlyOwner {
1971     _baseTokenURI = baseURI;
1972   }
1973 
1974   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1975     return ownershipOf(tokenId);
1976   }
1977 }
1978 
1979 
1980   
1981 // File: contracts/WarhogsContract.sol
1982 //SPDX-License-Identifier: MIT
1983 
1984 pragma solidity ^0.8.0;
1985 
1986 contract WarhogsContract is RamppERC721A {
1987     constructor() RamppERC721A("Warhogs", "WH"){}
1988 }
1989   
1990 //*********************************************************************//
1991 //*********************************************************************//  
1992 //                       Rampp v2.0.1
1993 //
1994 //         This smart contract was generated by rampp.xyz.
1995 //            Rampp allows creators like you to launch 
1996 //             large scale NFT communities without code!
1997 //
1998 //    Rampp is not responsible for the content of this contract and
1999 //        hopes it is being used in a responsible and kind way.  
2000 //       Rampp is not associated or affiliated with this project.                                                    
2001 //             Twitter: @Rampp_ ---- rampp.xyz
2002 //*********************************************************************//                                                     
2003 //*********************************************************************// 
