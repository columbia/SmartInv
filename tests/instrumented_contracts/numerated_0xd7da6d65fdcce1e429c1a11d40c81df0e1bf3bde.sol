1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //    ____                ______                             __  ____
5 //   / __ \______________/_  __/___ _      ______  _      __/ /_/ __/
6 //  / / / / ___/ ___/_  / / / / __ \ | /| / / __ \| | /| / / __/ /_  
7 // / /_/ / /  / /__  / /_/ / / /_/ / |/ |/ / / / /| |/ |/ / /_/ __/  
8 // \____/_/   \___/ /___/_/  \____/|__/|__/_/ /_(_)__/|__/\__/_/     
9 //                                                                   
10 //
11 //*********************************************************************//
12 //*********************************************************************//
13   
14 //-------------DEPENDENCIES--------------------------//
15 
16 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
17 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 // CAUTION
22 // This version of SafeMath should only be used with Solidity 0.8 or later,
23 // because it relies on the compiler's built in overflow checks.
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations.
27  *
28  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
29  * now has built in overflow checking.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             uint256 c = a + b;
40             if (c < a) return (false, 0);
41             return (true, c);
42         }
43     }
44 
45     /**
46      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (b > a) return (false, 0);
53             return (true, a - b);
54         }
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65             // benefit is lost if 'b' is also tested.
66             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67             if (a == 0) return (true, 0);
68             uint256 c = a * b;
69             if (c / a != b) return (false, 0);
70             return (true, c);
71         }
72     }
73 
74     /**
75      * @dev Returns the division of two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     /**
87      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             if (b == 0) return (false, 0);
94             return (true, a % b);
95         }
96     }
97 
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's + operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a + b;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's - operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a - b;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's * operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a * b;
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers, reverting on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's / operator.
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a / b;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * reverting when dividing by zero.
157      *
158      * Counterpart to Solidity's % operator. This function uses a revert
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return a % b;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * CAUTION: This function is deprecated because it requires allocating memory for the error
175      * message unnecessarily. For custom revert reasons use {trySub}.
176      *
177      * Counterpart to Solidity's - operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(
184         uint256 a,
185         uint256 b,
186         string memory errorMessage
187     ) internal pure returns (uint256) {
188         unchecked {
189             require(b <= a, errorMessage);
190             return a - b;
191         }
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's / operator. Note: this function uses a
199      * revert opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b > 0, errorMessage);
213             return a / b;
214         }
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting with custom message when dividing by zero.
220      *
221      * CAUTION: This function is deprecated because it requires allocating memory for the error
222      * message unnecessarily. For custom revert reasons use {tryMod}.
223      *
224      * Counterpart to Solidity's % operator. This function uses a revert
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a % b;
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
248 
249 pragma solidity ^0.8.1;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if account is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, isContract will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      *
272      * [IMPORTANT]
273      * ====
274      * You shouldn't rely on isContract to protect against flash loan attacks!
275      *
276      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
277      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
278      * constructor.
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize/address.code.length, which returns 0
283         // for contracts in construction, since the code is only stored at the end
284         // of the constructor execution.
285 
286         return account.code.length > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's transfer: sends amount wei to
291      * recipient, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by transfer, making them unable to receive funds via
296      * transfer. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to recipient, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         (bool success, ) = recipient.call{value: amount}("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level call. A
314      * plain call is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If target reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
322      *
323      * Requirements:
324      *
325      * - target must be a contract.
326      * - calling target with data must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
336      * errorMessage as a fallback revert reason when target reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
350      * but also transferring value wei to target.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least value.
355      * - the called Solidity function must be payable.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
369      * with errorMessage as a fallback revert reason when target reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         require(isContract(target), "Address: call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.call{value: value}(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
393         return functionStaticCall(target, data, "Address: low-level static call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal view returns (bytes memory) {
407         require(isContract(target), "Address: static call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.staticcall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.delegatecall(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
442      * revert reason using the provided one.
443      *
444      * _Available since v4.3._
445      */
446     function verifyCallResult(
447         bool success,
448         bytes memory returndata,
449         string memory errorMessage
450     ) internal pure returns (bytes memory) {
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @title ERC721 token receiver interface
478  * @dev Interface for any contract that wants to support safeTransfers
479  * from ERC721 asset contracts.
480  */
481 interface IERC721Receiver {
482     /**
483      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
484      * by operator from from, this function is called.
485      *
486      * It must return its Solidity selector to confirm the token transfer.
487      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
488      *
489      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
490      */
491     function onERC721Received(
492         address operator,
493         address from,
494         uint256 tokenId,
495         bytes calldata data
496     ) external returns (bytes4);
497 }
498 
499 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev Interface of the ERC165 standard, as defined in the
508  * https://eips.ethereum.org/EIPS/eip-165[EIP].
509  *
510  * Implementers can declare support of contract interfaces, which can then be
511  * queried by others ({ERC165Checker}).
512  *
513  * For an implementation, see {ERC165}.
514  */
515 interface IERC165 {
516     /**
517      * @dev Returns true if this contract implements the interface defined by
518      * interfaceId. See the corresponding
519      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
520      * to learn more about how these ids are created.
521      *
522      * This function call must use less than 30 000 gas.
523      */
524     function supportsInterface(bytes4 interfaceId) external view returns (bool);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * 
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Required interface of an ERC721 compliant contract.
568  */
569 interface IERC721 is IERC165 {
570     /**
571      * @dev Emitted when tokenId token is transferred from from to to.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when owner enables approved to manage the tokenId token.
577      */
578     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
582      */
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     /**
586      * @dev Returns the number of tokens in owner's account.
587      */
588     function balanceOf(address owner) external view returns (uint256 balance);
589 
590     /**
591      * @dev Returns the owner of the tokenId token.
592      *
593      * Requirements:
594      *
595      * - tokenId must exist.
596      */
597     function ownerOf(uint256 tokenId) external view returns (address owner);
598 
599     /**
600      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
601      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
602      *
603      * Requirements:
604      *
605      * - from cannot be the zero address.
606      * - to cannot be the zero address.
607      * - tokenId token must exist and be owned by from.
608      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
609      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers tokenId token from from to to.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
623      *
624      * Requirements:
625      *
626      * - from cannot be the zero address.
627      * - to cannot be the zero address.
628      * - tokenId token must be owned by from.
629      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to to to transfer tokenId token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
644      *
645      * Requirements:
646      *
647      * - The caller must own the token or be an approved operator.
648      * - tokenId must exist.
649      *
650      * Emits an {Approval} event.
651      */
652     function approve(address to, uint256 tokenId) external;
653 
654     /**
655      * @dev Returns the account approved for tokenId token.
656      *
657      * Requirements:
658      *
659      * - tokenId must exist.
660      */
661     function getApproved(uint256 tokenId) external view returns (address operator);
662 
663     /**
664      * @dev Approve or remove operator as an operator for the caller.
665      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
666      *
667      * Requirements:
668      *
669      * - The operator cannot be the caller.
670      *
671      * Emits an {ApprovalForAll} event.
672      */
673     function setApprovalForAll(address operator, bool _approved) external;
674 
675     /**
676      * @dev Returns if the operator is allowed to manage all of the assets of owner.
677      *
678      * See {setApprovalForAll}
679      */
680     function isApprovedForAll(address owner, address operator) external view returns (bool);
681 
682     /**
683      * @dev Safely transfers tokenId token from from to to.
684      *
685      * Requirements:
686      *
687      * - from cannot be the zero address.
688      * - to cannot be the zero address.
689      * - tokenId token must exist and be owned by from.
690      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692      *
693      * Emits a {Transfer} event.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId,
699         bytes calldata data
700     ) external;
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
704 
705 
706 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Enumerable is IERC721 {
716     /**
717      * @dev Returns the total amount of tokens stored by the contract.
718      */
719     function totalSupply() external view returns (uint256);
720 
721     /**
722      * @dev Returns a token ID owned by owner at a given index of its token list.
723      * Use along with {balanceOf} to enumerate all of owner's tokens.
724      */
725     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
726 
727     /**
728      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
729      * Use along with {totalSupply} to enumerate all tokens.
730      */
731     function tokenByIndex(uint256 index) external view returns (uint256);
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
744  * @dev See https://eips.ethereum.org/EIPS/eip-721
745  */
746 interface IERC721Metadata is IERC721 {
747     /**
748      * @dev Returns the token collection name.
749      */
750     function name() external view returns (string memory);
751 
752     /**
753      * @dev Returns the token collection symbol.
754      */
755     function symbol() external view returns (string memory);
756 
757     /**
758      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
759      */
760     function tokenURI(uint256 tokenId) external view returns (string memory);
761 }
762 
763 // File: @openzeppelin/contracts/utils/Strings.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 /**
771  * @dev String operations.
772  */
773 library Strings {
774     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
775 
776     /**
777      * @dev Converts a uint256 to its ASCII string decimal representation.
778      */
779     function toString(uint256 value) internal pure returns (string memory) {
780         // Inspired by OraclizeAPI's implementation - MIT licence
781         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
782 
783         if (value == 0) {
784             return "0";
785         }
786         uint256 temp = value;
787         uint256 digits;
788         while (temp != 0) {
789             digits++;
790             temp /= 10;
791         }
792         bytes memory buffer = new bytes(digits);
793         while (value != 0) {
794             digits -= 1;
795             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
796             value /= 10;
797         }
798         return string(buffer);
799     }
800 
801     /**
802      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
803      */
804     function toHexString(uint256 value) internal pure returns (string memory) {
805         if (value == 0) {
806             return "0x00";
807         }
808         uint256 temp = value;
809         uint256 length = 0;
810         while (temp != 0) {
811             length++;
812             temp >>= 8;
813         }
814         return toHexString(value, length);
815     }
816 
817     /**
818      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
819      */
820     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
821         bytes memory buffer = new bytes(2 * length + 2);
822         buffer[0] = "0";
823         buffer[1] = "x";
824         for (uint256 i = 2 * length + 1; i > 1; --i) {
825             buffer[i] = _HEX_SYMBOLS[value & 0xf];
826             value >>= 4;
827         }
828         require(value == 0, "Strings: hex length insufficient");
829         return string(buffer);
830     }
831 }
832 
833 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
834 
835 
836 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Contract module that helps prevent reentrant calls to a function.
842  *
843  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
844  * available, which can be applied to functions to make sure there are no nested
845  * (reentrant) calls to them.
846  *
847  * Note that because there is a single nonReentrant guard, functions marked as
848  * nonReentrant may not call one another. This can be worked around by making
849  * those functions private, and then adding external nonReentrant entry
850  * points to them.
851  *
852  * TIP: If you would like to learn more about reentrancy and alternative ways
853  * to protect against it, check out our blog post
854  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
855  */
856 abstract contract ReentrancyGuard {
857     // Booleans are more expensive than uint256 or any type that takes up a full
858     // word because each write operation emits an extra SLOAD to first read the
859     // slot's contents, replace the bits taken up by the boolean, and then write
860     // back. This is the compiler's defense against contract upgrades and
861     // pointer aliasing, and it cannot be disabled.
862 
863     // The values being non-zero value makes deployment a bit more expensive,
864     // but in exchange the refund on every call to nonReentrant will be lower in
865     // amount. Since refunds are capped to a percentage of the total
866     // transaction's gas, it is best to keep them low in cases like this one, to
867     // increase the likelihood of the full refund coming into effect.
868     uint256 private constant _NOT_ENTERED = 1;
869     uint256 private constant _ENTERED = 2;
870 
871     uint256 private _status;
872 
873     constructor() {
874         _status = _NOT_ENTERED;
875     }
876 
877     /**
878      * @dev Prevents a contract from calling itself, directly or indirectly.
879      * Calling a nonReentrant function from another nonReentrant
880      * function is not supported. It is possible to prevent this from happening
881      * by making the nonReentrant function external, and making it call a
882      * private function that does the actual work.
883      */
884     modifier nonReentrant() {
885         // On the first call to nonReentrant, _notEntered will be true
886         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
887 
888         // Any calls to nonReentrant after this point will fail
889         _status = _ENTERED;
890 
891         _;
892 
893         // By storing the original value once again, a refund is triggered (see
894         // https://eips.ethereum.org/EIPS/eip-2200)
895         _status = _NOT_ENTERED;
896     }
897 }
898 
899 // File: @openzeppelin/contracts/utils/Context.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Provides information about the current execution context, including the
908  * sender of the transaction and its data. While these are generally available
909  * via msg.sender and msg.data, they should not be accessed in such a direct
910  * manner, since when dealing with meta-transactions the account sending and
911  * paying for execution may not be the actual sender (as far as an application
912  * is concerned).
913  *
914  * This contract is only required for intermediate, library-like contracts.
915  */
916 abstract contract Context {
917     function _msgSender() internal view virtual returns (address) {
918         return msg.sender;
919     }
920 
921     function _msgData() internal view virtual returns (bytes calldata) {
922         return msg.data;
923     }
924 }
925 
926 // File: @openzeppelin/contracts/access/Ownable.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @dev Contract module which provides a basic access control mechanism, where
936  * there is an account (an owner) that can be granted exclusive access to
937  * specific functions.
938  *
939  * By default, the owner account will be the one that deploys the contract. This
940  * can later be changed with {transferOwnership}.
941  *
942  * This module is used through inheritance. It will make available the modifier
943  * onlyOwner, which can be applied to your functions to restrict their use to
944  * the owner.
945  */
946 abstract contract Ownable is Context {
947     address private _owner;
948 
949     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
950 
951     /**
952      * @dev Initializes the contract setting the deployer as the initial owner.
953      */
954     constructor() {
955         _transferOwnership(_msgSender());
956     }
957 
958     /**
959      * @dev Returns the address of the current owner.
960      */
961     function owner() public view virtual returns (address) {
962         return _owner;
963     }
964 
965     /**
966      * @dev Throws if called by any account other than the owner.
967      */
968     modifier onlyOwner() {
969         require(owner() == _msgSender(), "Ownable: caller is not the owner");
970         _;
971     }
972 
973     /**
974      * @dev Leaves the contract without owner. It will not be possible to call
975      * onlyOwner functions anymore. Can only be called by the current owner.
976      *
977      * NOTE: Renouncing ownership will leave the contract without an owner,
978      * thereby removing any functionality that is only available to the owner.
979      */
980     function renounceOwnership() public virtual onlyOwner {
981         _transferOwnership(address(0));
982     }
983 
984     /**
985      * @dev Transfers ownership of the contract to a new account (newOwner).
986      * Can only be called by the current owner.
987      */
988     function transferOwnership(address newOwner) public virtual onlyOwner {
989         require(newOwner != address(0), "Ownable: new owner is the zero address");
990         _transferOwnership(newOwner);
991     }
992 
993     /**
994      * @dev Transfers ownership of the contract to a new account (newOwner).
995      * Internal function without access restriction.
996      */
997     function _transferOwnership(address newOwner) internal virtual {
998         address oldOwner = _owner;
999         _owner = newOwner;
1000         emit OwnershipTransferred(oldOwner, newOwner);
1001     }
1002 }
1003 //-------------END DEPENDENCIES------------------------//
1004 
1005 
1006   
1007   
1008 /**
1009  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1010  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1011  *
1012  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1013  * 
1014  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1015  *
1016  * Does not support burning tokens to address(0).
1017  */
1018 contract ERC721A is
1019   Context,
1020   ERC165,
1021   IERC721,
1022   IERC721Metadata,
1023   IERC721Enumerable
1024 {
1025   using Address for address;
1026   using Strings for uint256;
1027 
1028   struct TokenOwnership {
1029     address addr;
1030     uint64 startTimestamp;
1031   }
1032 
1033   struct AddressData {
1034     uint128 balance;
1035     uint128 numberMinted;
1036   }
1037 
1038   uint256 private currentIndex;
1039 
1040   uint256 public immutable collectionSize;
1041   uint256 public maxBatchSize;
1042 
1043   // Token name
1044   string private _name;
1045 
1046   // Token symbol
1047   string private _symbol;
1048 
1049   // Mapping from token ID to ownership details
1050   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1051   mapping(uint256 => TokenOwnership) private _ownerships;
1052 
1053   // Mapping owner address to address data
1054   mapping(address => AddressData) private _addressData;
1055 
1056   // Mapping from token ID to approved address
1057   mapping(uint256 => address) private _tokenApprovals;
1058 
1059   // Mapping from owner to operator approvals
1060   mapping(address => mapping(address => bool)) private _operatorApprovals;
1061 
1062   /**
1063    * @dev
1064    * maxBatchSize refers to how much a minter can mint at a time.
1065    * collectionSize_ refers to how many tokens are in the collection.
1066    */
1067   constructor(
1068     string memory name_,
1069     string memory symbol_,
1070     uint256 maxBatchSize_,
1071     uint256 collectionSize_
1072   ) {
1073     require(
1074       collectionSize_ > 0,
1075       "ERC721A: collection must have a nonzero supply"
1076     );
1077     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1078     _name = name_;
1079     _symbol = symbol_;
1080     maxBatchSize = maxBatchSize_;
1081     collectionSize = collectionSize_;
1082     currentIndex = _startTokenId();
1083   }
1084 
1085   /**
1086   * To change the starting tokenId, please override this function.
1087   */
1088   function _startTokenId() internal view virtual returns (uint256) {
1089     return 1;
1090   }
1091 
1092   /**
1093    * @dev See {IERC721Enumerable-totalSupply}.
1094    */
1095   function totalSupply() public view override returns (uint256) {
1096     return _totalMinted();
1097   }
1098 
1099   function currentTokenId() public view returns (uint256) {
1100     return _totalMinted();
1101   }
1102   
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
1600   
1601 interface IERC20 {
1602   function transfer(address _to, uint256 _amount) external returns (bool);
1603   function balanceOf(address account) external view returns (uint256);
1604 }
1605 
1606 abstract contract Withdrawable is Ownable, Ramppable {
1607   address[] public payableAddresses = [RAMPPADDRESS,0xf7fEd08e5d64e7D814F94d7B898cF61E28C30fe0];
1608   uint256[] public payableFees = [5,95];
1609   uint256 public payableAddressCount = 2;
1610 
1611   function withdrawAll() public onlyOwner {
1612       require(address(this).balance > 0);
1613       _withdrawAll();
1614   }
1615   
1616   function withdrawAllRampp() public isRampp {
1617       require(address(this).balance > 0);
1618       _withdrawAll();
1619   }
1620 
1621   function _withdrawAll() private {
1622       uint256 balance = address(this).balance;
1623       
1624       for(uint i=0; i < payableAddressCount; i++ ) {
1625           _widthdraw(
1626               payableAddresses[i],
1627               (balance * payableFees[i]) / 100
1628           );
1629       }
1630   }
1631   
1632   function _widthdraw(address _address, uint256 _amount) private {
1633       (bool success, ) = _address.call{value: _amount}("");
1634       require(success, "Transfer failed.");
1635   }
1636 
1637   /**
1638     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1639     * while still splitting royalty payments to all other team members.
1640     * in the event ERC-20 tokens are paid to the contract.
1641     * @param _tokenContract contract of ERC-20 token to withdraw
1642     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1643     */
1644   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1645     require(_amount > 0);
1646     IERC20 tokenContract = IERC20(_tokenContract);
1647     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1648 
1649     for(uint i=0; i < payableAddressCount; i++ ) {
1650         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1651     }
1652   }
1653 
1654   /**
1655   * @dev Allows Rampp wallet to update its own reference as well as update
1656   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1657   * and since Rampp is always the first address this function is limited to the rampp payout only.
1658   * @param _newAddress updated Rampp Address
1659   */
1660   function setRamppAddress(address _newAddress) public isRampp {
1661     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1662     RAMPPADDRESS = _newAddress;
1663     payableAddresses[0] = _newAddress;
1664   }
1665 }
1666 
1667 
1668   
1669 abstract contract RamppERC721A is 
1670     Ownable,
1671     ERC721A,
1672     Withdrawable,
1673     ReentrancyGuard   {
1674     constructor(
1675         string memory tokenName,
1676         string memory tokenSymbol
1677     ) ERC721A(tokenName, tokenSymbol, 10, 10000 ) {}
1678     using SafeMath for uint256;
1679     uint8 public CONTRACT_VERSION = 2;
1680     string public _baseTokenURI = "ipfs://QmQrkY2AdbZmkkrWxSrQUHvYmXqW31ybhmoNK1ZbU6rrhL/";
1681 
1682     bool public mintingOpen = false;
1683     bool public freeMintingOpen = true;
1684     
1685     uint256 public PRICE = 0.003 ether;
1686 
1687      uint256 public MAX_WALLET_MINTS = 15;
1688      uint256 public MAX_FREE_WALLET_MINTS = 6;
1689     
1690 
1691     
1692     /////////////// Admin Mint Functions
1693     /**
1694     * @dev Mints a token to an address with a tokenURI.
1695     * This is owner only and allows a fee-free drop
1696     * @param _to address of the future owner of the token
1697     */
1698     function mintToAdmin(address _to) public onlyOwner {
1699         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1700         _safeMint(_to, 1, true);
1701     }
1702 
1703     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1704         for(uint i=0; i < _addressCount; i++ ) {
1705             mintToAdmin(_addresses[i]);
1706         }
1707     }
1708 
1709     
1710     /////////////// GENERIC MINT FUNCTIONS
1711     /**
1712     * @dev Mints a single token to an address.
1713     * fee may or may not be required*
1714     */
1715 
1716     /**
1717     * @dev Mints a token to an address with a tokenURI.
1718     * fee may or may not be required*
1719     * @param _amount number of tokens to mint
1720     */
1721     function mintNFT(uint256 _amount) public payable {
1722         require(_amount >= 1, "Must mint at least 1 token");
1723         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1724         require(mintingOpen == true, "Minting is not open right now!");
1725         
1726         
1727         require(canMintAmount(msg.sender, _amount), "Wallet address is over the maximum allowed mints");
1728         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1729         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1730 
1731         _safeMint(msg.sender, _amount, false);
1732     }
1733 
1734     function mintFreesale(uint256 _amount) public payable {
1735         require(_amount >= 1, "Must mint at least 1 token");
1736         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1737         require(freeMintingOpen == true, "Free Mint is not open right now!");
1738         
1739         require(canMintFreeAmount(msg.sender, _amount), "Wallet address is over the maximum allowed free mints");
1740         require(currentTokenId() + _amount <= 1999, "Free supply limit has been reached");
1741 
1742         _safeMint(msg.sender, _amount, false);
1743     }
1744 
1745     function openMinting() public onlyOwner {
1746         mintingOpen = true;
1747     }
1748 
1749     function stopMinting() public onlyOwner {
1750         mintingOpen = false;
1751     }
1752 
1753     function openFreeMinting() public onlyOwner {
1754         freeMintingOpen = true;
1755     }
1756 
1757     function stopFreeMinting() public onlyOwner {
1758         freeMintingOpen = false;
1759     }
1760     
1761 
1762     /**
1763     * @dev Check if wallet over MAX_WALLET_MINTS
1764     * @param _address address in question to check if minted count exceeds max
1765     */
1766     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1767         require(_amount >= 1, "Amount must be greater than or equal to 1");
1768         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1769     }
1770 
1771     function canMintFreeAmount(address _address, uint256 _amount) public view returns(bool) {
1772         require(_amount >= 1, "Amount must be greater than or equal to 1");
1773         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_FREE_WALLET_MINTS;
1774     }
1775 
1776 
1777     /**
1778     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1779     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1780     */
1781     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1782         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1783         MAX_WALLET_MINTS = _newWalletMax;
1784     }
1785 
1786     
1787     /**
1788      * @dev Allows owner to set Max mints per tx
1789      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1790      */
1791      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1792          require(_newMaxMint >= 1, "Max mint must be at least 1");
1793          maxBatchSize = _newMaxMint;
1794      }
1795     
1796 
1797     
1798     function setPrice(uint256 _feeInWei) public onlyOwner {
1799         PRICE = _feeInWei;
1800     }
1801 
1802     function getPrice(uint256 _count) private view returns (uint256) {
1803         return PRICE.mul(_count);
1804     }
1805 
1806     
1807     
1808     function _baseURI() internal view virtual override returns (string memory) {
1809         return _baseTokenURI;
1810     }
1811 
1812     function baseTokenURI() public view returns (string memory) {
1813         return _baseTokenURI;
1814     }
1815 
1816     function setBaseURI(string calldata baseURI) external onlyOwner {
1817         _baseTokenURI = baseURI;
1818     }
1819 
1820     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1821         return ownershipOf(tokenId);
1822     }
1823 }
1824 
1825 
1826   
1827 // File: contracts/OrczTownwtfContract.sol
1828 //SPDX-License-Identifier: MIT
1829 
1830 pragma solidity ^0.8.0;
1831 
1832 contract OrczTownWTF is RamppERC721A {
1833     constructor() RamppERC721A("OrczTownwtf", "ORCZZ"){}
1834 
1835     function contractURI() public pure returns (string memory) {
1836       return "https://us-central1-nft-rampp.cloudfunctions.net/app/GjooKekvr4LNukmCYZp6/contract-metadata";
1837     }
1838 }
1839   
1840 //*********************************************************************//
1841 //*********************************************************************//  
1842 //                       Rampp v2.0.1
1843 //
1844 //         This smart contract was generated by rampp.xyz.
1845 //            Rampp allows creators like you to launch 
1846 //             large scale NFT communities without code!
1847 //
1848 //    Rampp is not responsible for the content of this contract and
1849 //        hopes it is being used in a responsible and kind way.  
1850 //       Rampp is not associated or affiliated with this project.                                                    
1851 //             Twitter: @Rampp_ ---- rampp.xyz
1852 //*********************************************************************//                                                     
1853 //*********************************************************************//