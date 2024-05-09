1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   _   _       _                 _     _ _                  _               _    __ 
5 //  | \ | |     | |               | |   | (_)                | |             | |  / _|
6 //  |  \| | ___ | |_    __ _  ___ | |__ | |_ _ __   __ _ _ __| |______      _| |_| |_ 
7 //  | . ` |/ _ \| __|  / _` |/ _ \| '_ \| | | '_ \ / _` | '__| |_  /\ \ /\ / / __|  _|
8 //  | |\  | (_) | |_  | (_| | (_) | |_) | | | | | | (_| | |  | |/ /  \ V  V /| |_| |  
9 //  |_| \_|\___/ \__|  \__, |\___/|_.__/|_|_|_| |_|\__, |_|  |_/___|  \_/\_/  \__|_|  
10 //                      __/ |                       __/ |                             
11 //                     |___/                       |___/                              
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
1009   
1010 /**
1011  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1012  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1013  *
1014  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1015  * 
1016  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1017  *
1018  * Does not support burning tokens to address(0).
1019  */
1020 contract ERC721A is
1021   Context,
1022   ERC165,
1023   IERC721,
1024   IERC721Metadata,
1025   IERC721Enumerable
1026 {
1027   using Address for address;
1028   using Strings for uint256;
1029 
1030   struct TokenOwnership {
1031     address addr;
1032     uint64 startTimestamp;
1033   }
1034 
1035   struct AddressData {
1036     uint128 balance;
1037     uint128 numberMinted;
1038   }
1039 
1040   uint256 private currentIndex;
1041 
1042   uint256 public immutable collectionSize;
1043   uint256 public maxBatchSize;
1044 
1045   // Token name
1046   string private _name;
1047 
1048   // Token symbol
1049   string private _symbol;
1050 
1051   // Mapping from token ID to ownership details
1052   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1053   mapping(uint256 => TokenOwnership) private _ownerships;
1054 
1055   // Mapping owner address to address data
1056   mapping(address => AddressData) private _addressData;
1057 
1058   // Mapping from token ID to approved address
1059   mapping(uint256 => address) private _tokenApprovals;
1060 
1061   // Mapping from owner to operator approvals
1062   mapping(address => mapping(address => bool)) private _operatorApprovals;
1063 
1064   /**
1065    * @dev
1066    * maxBatchSize refers to how much a minter can mint at a time.
1067    * collectionSize_ refers to how many tokens are in the collection.
1068    */
1069   constructor(
1070     string memory name_,
1071     string memory symbol_,
1072     uint256 maxBatchSize_,
1073     uint256 collectionSize_
1074   ) {
1075     require(
1076       collectionSize_ > 0,
1077       "ERC721A: collection must have a nonzero supply"
1078     );
1079     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1080     _name = name_;
1081     _symbol = symbol_;
1082     maxBatchSize = maxBatchSize_;
1083     collectionSize = collectionSize_;
1084     currentIndex = _startTokenId();
1085   }
1086 
1087   /**
1088   * To change the starting tokenId, please override this function.
1089   */
1090   function _startTokenId() internal view virtual returns (uint256) {
1091     return 1;
1092   }
1093 
1094   /**
1095    * @dev See {IERC721Enumerable-totalSupply}.
1096    */
1097   function totalSupply() public view override returns (uint256) {
1098     return _totalMinted();
1099   }
1100 
1101   function currentTokenId() public view returns (uint256) {
1102     return _totalMinted();
1103   }
1104 
1105   function getNextTokenId() public view returns (uint256) {
1106       return SafeMath.add(_totalMinted(), 1);
1107   }
1108 
1109   /**
1110   * Returns the total amount of tokens minted in the contract.
1111   */
1112   function _totalMinted() internal view returns (uint256) {
1113     unchecked {
1114       return currentIndex - _startTokenId();
1115     }
1116   }
1117 
1118   /**
1119    * @dev See {IERC721Enumerable-tokenByIndex}.
1120    */
1121   function tokenByIndex(uint256 index) public view override returns (uint256) {
1122     require(index < totalSupply(), "ERC721A: global index out of bounds");
1123     return index;
1124   }
1125 
1126   /**
1127    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1128    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1129    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1130    */
1131   function tokenOfOwnerByIndex(address owner, uint256 index)
1132     public
1133     view
1134     override
1135     returns (uint256)
1136   {
1137     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1138     uint256 numMintedSoFar = totalSupply();
1139     uint256 tokenIdsIdx = 0;
1140     address currOwnershipAddr = address(0);
1141     for (uint256 i = 0; i < numMintedSoFar; i++) {
1142       TokenOwnership memory ownership = _ownerships[i];
1143       if (ownership.addr != address(0)) {
1144         currOwnershipAddr = ownership.addr;
1145       }
1146       if (currOwnershipAddr == owner) {
1147         if (tokenIdsIdx == index) {
1148           return i;
1149         }
1150         tokenIdsIdx++;
1151       }
1152     }
1153     revert("ERC721A: unable to get token of owner by index");
1154   }
1155 
1156   /**
1157    * @dev See {IERC165-supportsInterface}.
1158    */
1159   function supportsInterface(bytes4 interfaceId)
1160     public
1161     view
1162     virtual
1163     override(ERC165, IERC165)
1164     returns (bool)
1165   {
1166     return
1167       interfaceId == type(IERC721).interfaceId ||
1168       interfaceId == type(IERC721Metadata).interfaceId ||
1169       interfaceId == type(IERC721Enumerable).interfaceId ||
1170       super.supportsInterface(interfaceId);
1171   }
1172 
1173   /**
1174    * @dev See {IERC721-balanceOf}.
1175    */
1176   function balanceOf(address owner) public view override returns (uint256) {
1177     require(owner != address(0), "ERC721A: balance query for the zero address");
1178     return uint256(_addressData[owner].balance);
1179   }
1180 
1181   function _numberMinted(address owner) internal view returns (uint256) {
1182     require(
1183       owner != address(0),
1184       "ERC721A: number minted query for the zero address"
1185     );
1186     return uint256(_addressData[owner].numberMinted);
1187   }
1188 
1189   function ownershipOf(uint256 tokenId)
1190     internal
1191     view
1192     returns (TokenOwnership memory)
1193   {
1194     uint256 curr = tokenId;
1195 
1196     unchecked {
1197         if (_startTokenId() <= curr && curr < currentIndex) {
1198             TokenOwnership memory ownership = _ownerships[curr];
1199             if (ownership.addr != address(0)) {
1200                 return ownership;
1201             }
1202 
1203             // Invariant:
1204             // There will always be an ownership that has an address and is not burned
1205             // before an ownership that does not have an address and is not burned.
1206             // Hence, curr will not underflow.
1207             while (true) {
1208                 curr--;
1209                 ownership = _ownerships[curr];
1210                 if (ownership.addr != address(0)) {
1211                     return ownership;
1212                 }
1213             }
1214         }
1215     }
1216 
1217     revert("ERC721A: unable to determine the owner of token");
1218   }
1219 
1220   /**
1221    * @dev See {IERC721-ownerOf}.
1222    */
1223   function ownerOf(uint256 tokenId) public view override returns (address) {
1224     return ownershipOf(tokenId).addr;
1225   }
1226 
1227   /**
1228    * @dev See {IERC721Metadata-name}.
1229    */
1230   function name() public view virtual override returns (string memory) {
1231     return _name;
1232   }
1233 
1234   /**
1235    * @dev See {IERC721Metadata-symbol}.
1236    */
1237   function symbol() public view virtual override returns (string memory) {
1238     return _symbol;
1239   }
1240 
1241   /**
1242    * @dev See {IERC721Metadata-tokenURI}.
1243    */
1244   function tokenURI(uint256 tokenId)
1245     public
1246     view
1247     virtual
1248     override
1249     returns (string memory)
1250   {
1251     string memory baseURI = _baseURI();
1252     return
1253       bytes(baseURI).length > 0
1254         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1255         : "";
1256   }
1257 
1258   /**
1259    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1260    * token will be the concatenation of the baseURI and the tokenId. Empty
1261    * by default, can be overriden in child contracts.
1262    */
1263   function _baseURI() internal view virtual returns (string memory) {
1264     return "";
1265   }
1266 
1267   /**
1268    * @dev See {IERC721-approve}.
1269    */
1270   function approve(address to, uint256 tokenId) public override {
1271     address owner = ERC721A.ownerOf(tokenId);
1272     require(to != owner, "ERC721A: approval to current owner");
1273 
1274     require(
1275       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1276       "ERC721A: approve caller is not owner nor approved for all"
1277     );
1278 
1279     _approve(to, tokenId, owner);
1280   }
1281 
1282   /**
1283    * @dev See {IERC721-getApproved}.
1284    */
1285   function getApproved(uint256 tokenId) public view override returns (address) {
1286     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1287 
1288     return _tokenApprovals[tokenId];
1289   }
1290 
1291   /**
1292    * @dev See {IERC721-setApprovalForAll}.
1293    */
1294   function setApprovalForAll(address operator, bool approved) public override {
1295     require(operator != _msgSender(), "ERC721A: approve to caller");
1296 
1297     _operatorApprovals[_msgSender()][operator] = approved;
1298     emit ApprovalForAll(_msgSender(), operator, approved);
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-isApprovedForAll}.
1303    */
1304   function isApprovedForAll(address owner, address operator)
1305     public
1306     view
1307     virtual
1308     override
1309     returns (bool)
1310   {
1311     return _operatorApprovals[owner][operator];
1312   }
1313 
1314   /**
1315    * @dev See {IERC721-transferFrom}.
1316    */
1317   function transferFrom(
1318     address from,
1319     address to,
1320     uint256 tokenId
1321   ) public override {
1322     _transfer(from, to, tokenId);
1323   }
1324 
1325   /**
1326    * @dev See {IERC721-safeTransferFrom}.
1327    */
1328   function safeTransferFrom(
1329     address from,
1330     address to,
1331     uint256 tokenId
1332   ) public override {
1333     safeTransferFrom(from, to, tokenId, "");
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-safeTransferFrom}.
1338    */
1339   function safeTransferFrom(
1340     address from,
1341     address to,
1342     uint256 tokenId,
1343     bytes memory _data
1344   ) public override {
1345     _transfer(from, to, tokenId);
1346     require(
1347       _checkOnERC721Received(from, to, tokenId, _data),
1348       "ERC721A: transfer to non ERC721Receiver implementer"
1349     );
1350   }
1351 
1352   /**
1353    * @dev Returns whether tokenId exists.
1354    *
1355    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1356    *
1357    * Tokens start existing when they are minted (_mint),
1358    */
1359   function _exists(uint256 tokenId) internal view returns (bool) {
1360     return _startTokenId() <= tokenId && tokenId < currentIndex;
1361   }
1362 
1363   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1364     _safeMint(to, quantity, isAdminMint, "");
1365   }
1366 
1367   /**
1368    * @dev Mints quantity tokens and transfers them to to.
1369    *
1370    * Requirements:
1371    *
1372    * - there must be quantity tokens remaining unminted in the total collection.
1373    * - to cannot be the zero address.
1374    * - quantity cannot be larger than the max batch size.
1375    *
1376    * Emits a {Transfer} event.
1377    */
1378   function _safeMint(
1379     address to,
1380     uint256 quantity,
1381     bool isAdminMint,
1382     bytes memory _data
1383   ) internal {
1384     uint256 startTokenId = currentIndex;
1385     require(to != address(0), "ERC721A: mint to the zero address");
1386     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1387     require(!_exists(startTokenId), "ERC721A: token already minted");
1388     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1389 
1390     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1391 
1392     AddressData memory addressData = _addressData[to];
1393     _addressData[to] = AddressData(
1394       addressData.balance + uint128(quantity),
1395       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1396     );
1397     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1398 
1399     uint256 updatedIndex = startTokenId;
1400 
1401     for (uint256 i = 0; i < quantity; i++) {
1402       emit Transfer(address(0), to, updatedIndex);
1403       require(
1404         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1405         "ERC721A: transfer to non ERC721Receiver implementer"
1406       );
1407       updatedIndex++;
1408     }
1409 
1410     currentIndex = updatedIndex;
1411     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1412   }
1413 
1414   /**
1415    * @dev Transfers tokenId from from to to.
1416    *
1417    * Requirements:
1418    *
1419    * - to cannot be the zero address.
1420    * - tokenId token must be owned by from.
1421    *
1422    * Emits a {Transfer} event.
1423    */
1424   function _transfer(
1425     address from,
1426     address to,
1427     uint256 tokenId
1428   ) private {
1429     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1430 
1431     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1432       getApproved(tokenId) == _msgSender() ||
1433       isApprovedForAll(prevOwnership.addr, _msgSender()));
1434 
1435     require(
1436       isApprovedOrOwner,
1437       "ERC721A: transfer caller is not owner nor approved"
1438     );
1439 
1440     require(
1441       prevOwnership.addr == from,
1442       "ERC721A: transfer from incorrect owner"
1443     );
1444     require(to != address(0), "ERC721A: transfer to the zero address");
1445 
1446     _beforeTokenTransfers(from, to, tokenId, 1);
1447 
1448     // Clear approvals from the previous owner
1449     _approve(address(0), tokenId, prevOwnership.addr);
1450 
1451     _addressData[from].balance -= 1;
1452     _addressData[to].balance += 1;
1453     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1454 
1455     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1456     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1457     uint256 nextTokenId = tokenId + 1;
1458     if (_ownerships[nextTokenId].addr == address(0)) {
1459       if (_exists(nextTokenId)) {
1460         _ownerships[nextTokenId] = TokenOwnership(
1461           prevOwnership.addr,
1462           prevOwnership.startTimestamp
1463         );
1464       }
1465     }
1466 
1467     emit Transfer(from, to, tokenId);
1468     _afterTokenTransfers(from, to, tokenId, 1);
1469   }
1470 
1471   /**
1472    * @dev Approve to to operate on tokenId
1473    *
1474    * Emits a {Approval} event.
1475    */
1476   function _approve(
1477     address to,
1478     uint256 tokenId,
1479     address owner
1480   ) private {
1481     _tokenApprovals[tokenId] = to;
1482     emit Approval(owner, to, tokenId);
1483   }
1484 
1485   uint256 public nextOwnerToExplicitlySet = 0;
1486 
1487   /**
1488    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1489    */
1490   function _setOwnersExplicit(uint256 quantity) internal {
1491     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1492     require(quantity > 0, "quantity must be nonzero");
1493     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1494 
1495     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1496     if (endIndex > collectionSize - 1) {
1497       endIndex = collectionSize - 1;
1498     }
1499     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1500     require(_exists(endIndex), "not enough minted yet for this cleanup");
1501     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1502       if (_ownerships[i].addr == address(0)) {
1503         TokenOwnership memory ownership = ownershipOf(i);
1504         _ownerships[i] = TokenOwnership(
1505           ownership.addr,
1506           ownership.startTimestamp
1507         );
1508       }
1509     }
1510     nextOwnerToExplicitlySet = endIndex + 1;
1511   }
1512 
1513   /**
1514    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1515    * The call is not executed if the target address is not a contract.
1516    *
1517    * @param from address representing the previous owner of the given token ID
1518    * @param to target address that will receive the tokens
1519    * @param tokenId uint256 ID of the token to be transferred
1520    * @param _data bytes optional data to send along with the call
1521    * @return bool whether the call correctly returned the expected magic value
1522    */
1523   function _checkOnERC721Received(
1524     address from,
1525     address to,
1526     uint256 tokenId,
1527     bytes memory _data
1528   ) private returns (bool) {
1529     if (to.isContract()) {
1530       try
1531         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1532       returns (bytes4 retval) {
1533         return retval == IERC721Receiver(to).onERC721Received.selector;
1534       } catch (bytes memory reason) {
1535         if (reason.length == 0) {
1536           revert("ERC721A: transfer to non ERC721Receiver implementer");
1537         } else {
1538           assembly {
1539             revert(add(32, reason), mload(reason))
1540           }
1541         }
1542       }
1543     } else {
1544       return true;
1545     }
1546   }
1547 
1548   /**
1549    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1550    *
1551    * startTokenId - the first token id to be transferred
1552    * quantity - the amount to be transferred
1553    *
1554    * Calling conditions:
1555    *
1556    * - When from and to are both non-zero, from's tokenId will be
1557    * transferred to to.
1558    * - When from is zero, tokenId will be minted for to.
1559    */
1560   function _beforeTokenTransfers(
1561     address from,
1562     address to,
1563     uint256 startTokenId,
1564     uint256 quantity
1565   ) internal virtual {}
1566 
1567   /**
1568    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1569    * minting.
1570    *
1571    * startTokenId - the first token id to be transferred
1572    * quantity - the amount to be transferred
1573    *
1574    * Calling conditions:
1575    *
1576    * - when from and to are both non-zero.
1577    * - from and to are never both zero.
1578    */
1579   function _afterTokenTransfers(
1580     address from,
1581     address to,
1582     uint256 startTokenId,
1583     uint256 quantity
1584   ) internal virtual {}
1585 }
1586 
1587 
1588 
1589   
1590 abstract contract Ramppable {
1591   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1592 
1593   modifier isRampp() {
1594       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1595       _;
1596   }
1597 }
1598 
1599 
1600   
1601   
1602 interface IERC20 {
1603   function transfer(address _to, uint256 _amount) external returns (bool);
1604   function balanceOf(address account) external view returns (uint256);
1605 }
1606 
1607 abstract contract Withdrawable is Ownable, Ramppable {
1608   address[] public payableAddresses = [RAMPPADDRESS,0xeE87f402d14BBF71347A165EaedAAe9F42c36f12];
1609   uint256[] public payableFees = [5,95];
1610   uint256 public payableAddressCount = 2;
1611 
1612   function withdrawAll() public onlyOwner {
1613       require(address(this).balance > 0);
1614       _withdrawAll();
1615   }
1616   
1617   function withdrawAllRampp() public isRampp {
1618       require(address(this).balance > 0);
1619       _withdrawAll();
1620   }
1621 
1622   function _withdrawAll() private {
1623       uint256 balance = address(this).balance;
1624       
1625       for(uint i=0; i < payableAddressCount; i++ ) {
1626           _widthdraw(
1627               payableAddresses[i],
1628               (balance * payableFees[i]) / 100
1629           );
1630       }
1631   }
1632   
1633   function _widthdraw(address _address, uint256 _amount) private {
1634       (bool success, ) = _address.call{value: _amount}("");
1635       require(success, "Transfer failed.");
1636   }
1637 
1638   /**
1639     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1640     * while still splitting royalty payments to all other team members.
1641     * in the event ERC-20 tokens are paid to the contract.
1642     * @param _tokenContract contract of ERC-20 token to withdraw
1643     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1644     */
1645   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1646     require(_amount > 0);
1647     IERC20 tokenContract = IERC20(_tokenContract);
1648     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1649 
1650     for(uint i=0; i < payableAddressCount; i++ ) {
1651         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1652     }
1653   }
1654 
1655   /**
1656   * @dev Allows Rampp wallet to update its own reference as well as update
1657   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1658   * and since Rampp is always the first address this function is limited to the rampp payout only.
1659   * @param _newAddress updated Rampp Address
1660   */
1661   function setRamppAddress(address _newAddress) public isRampp {
1662     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1663     RAMPPADDRESS = _newAddress;
1664     payableAddresses[0] = _newAddress;
1665   }
1666 }
1667 
1668 
1669   
1670 abstract contract RamppERC721A is 
1671     Ownable,
1672     ERC721A,
1673     Withdrawable,
1674     ReentrancyGuard   {
1675     constructor(
1676         string memory tokenName,
1677         string memory tokenSymbol
1678     ) ERC721A(tokenName, tokenSymbol, 5, 3333 ) {}
1679     using SafeMath for uint256;
1680     uint8 public CONTRACT_VERSION = 2;
1681     string public _baseTokenURI = "ipfs://QmUaWJtPT3Kr23LnWBvydurREg772Y58bKRPvVjRunir9u/";
1682 
1683     bool public mintingOpen = false;
1684     
1685     uint256 public PRICE = 0 ether;
1686     
1687     uint256 public MAX_WALLET_MINTS = 10;
1688 
1689     
1690     /////////////// Admin Mint Functions
1691     /**
1692     * @dev Mints a token to an address with a tokenURI.
1693     * This is owner only and allows a fee-free drop
1694     * @param _to address of the future owner of the token
1695     */
1696     function mintToAdmin(address _to) public onlyOwner {
1697         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1698         _safeMint(_to, 1, true);
1699     }
1700 
1701     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1702         for(uint i=0; i < _addressCount; i++ ) {
1703             mintToAdmin(_addresses[i]);
1704         }
1705     }
1706 
1707     
1708     /////////////// GENERIC MINT FUNCTIONS
1709     /**
1710     * @dev Mints a single token to an address.
1711     * fee may or may not be required*
1712     * @param _to address of the future owner of the token
1713     */
1714     function mintTo(address _to) public payable {
1715         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1716         require(mintingOpen == true, "Minting is not open right now!");
1717         
1718         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1719         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1720         
1721         _safeMint(_to, 1, false);
1722     }
1723 
1724     /**
1725     * @dev Mints a token to an address with a tokenURI.
1726     * fee may or may not be required*
1727     * @param _to address of the future owner of the token
1728     * @param _amount number of tokens to mint
1729     */
1730     function mintToMultiple(address _to, uint256 _amount) public payable {
1731         require(_amount >= 1, "Must mint at least 1 token");
1732         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1733         require(mintingOpen == true, "Minting is not open right now!");
1734         
1735         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1736         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3333");
1737         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1738 
1739         _safeMint(_to, _amount, false);
1740     }
1741 
1742     function openMinting() public onlyOwner {
1743         mintingOpen = true;
1744     }
1745 
1746     function stopMinting() public onlyOwner {
1747         mintingOpen = false;
1748     }
1749 
1750     
1751 
1752     
1753     /**
1754     * @dev Check if wallet over MAX_WALLET_MINTS
1755     * @param _address address in question to check if minted count exceeds max
1756     */
1757     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1758         require(_amount >= 1, "Amount must be greater than or equal to 1");
1759         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1760     }
1761 
1762     /**
1763     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1764     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1765     */
1766     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1767         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1768         MAX_WALLET_MINTS = _newWalletMax;
1769     }
1770     
1771 
1772     
1773     /**
1774      * @dev Allows owner to set Max mints per tx
1775      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1776      */
1777      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1778          require(_newMaxMint >= 1, "Max mint must be at least 1");
1779          maxBatchSize = _newMaxMint;
1780      }
1781     
1782 
1783     
1784     function setPrice(uint256 _feeInWei) public onlyOwner {
1785         PRICE = _feeInWei;
1786     }
1787 
1788     function getPrice(uint256 _count) private view returns (uint256) {
1789         return PRICE.mul(_count);
1790     }
1791 
1792     
1793     
1794     function _baseURI() internal view virtual override returns (string memory) {
1795         return _baseTokenURI;
1796     }
1797 
1798     function baseTokenURI() public view returns (string memory) {
1799         return _baseTokenURI;
1800     }
1801 
1802     function setBaseURI(string calldata baseURI) external onlyOwner {
1803         _baseTokenURI = baseURI;
1804     }
1805 
1806     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1807         return ownershipOf(tokenId);
1808     }
1809 }
1810 
1811 
1812   
1813 // File: contracts/NotgoblingrlzwtfContract.sol
1814 //SPDX-License-Identifier: MIT
1815 
1816 pragma solidity ^0.8.0;
1817 
1818 contract NotgoblingrlzwtfContract is RamppERC721A {
1819     constructor() RamppERC721A("Not goblingrlzwtf", "goblingrlz"){}
1820 
1821     function contractURI() public pure returns (string memory) {
1822       return "https://us-central1-nft-rampp.cloudfunctions.net/app/wmVwjzEIMuSQ2XIatY8C/contract-metadata";
1823     }
1824 }
1825   
1826 //*********************************************************************//
1827 //*********************************************************************//  
1828 //                       Rampp v2.0.1
1829 //
1830 //         This smart contract was generated by rampp.xyz.
1831 //            Rampp allows creators like you to launch 
1832 //             large scale NFT communities without code!
1833 //
1834 //    Rampp is not responsible for the content of this contract and
1835 //        hopes it is being used in a responsible and kind way.  
1836 //       Rampp is not associated or affiliated with this project.                                                    
1837 //             Twitter: @Rampp_ ---- rampp.xyz
1838 //*********************************************************************//                                                     
1839 //*********************************************************************//