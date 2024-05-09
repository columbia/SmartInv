1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  +-+-+-+-+-+-+-+-+ +-+-+-+
5 //  |m|0|0|n|b|o|y|s| |N|F|T|
6 //  +-+-+-+-+-+-+-+-+ +-+-+-+
7 //
8 //*********************************************************************//
9 //*********************************************************************//
10   
11 //-------------DEPENDENCIES--------------------------//
12 
13 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
14 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 // CAUTION
19 // This version of SafeMath should only be used with Solidity 0.8 or later,
20 // because it relies on the compiler's built in overflow checks.
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations.
24  *
25  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
26  * now has built in overflow checking.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     /**
43      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b > a) return (false, 0);
50             return (true, a - b);
51         }
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62             // benefit is lost if 'b' is also tested.
63             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64             if (a == 0) return (true, 0);
65             uint256 c = a * b;
66             if (c / a != b) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the division of two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a / b);
80         }
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a % b);
92         }
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's + operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a + b;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's - operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a - b;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's * operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers, reverting on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's / operator.
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * reverting when dividing by zero.
154      *
155      * Counterpart to Solidity's % operator. This function uses a revert
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a % b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's - operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b <= a, errorMessage);
187             return a - b;
188         }
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's / operator. Note: this function uses a
196      * revert opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         unchecked {
209             require(b > 0, errorMessage);
210             return a / b;
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's % operator. This function uses a revert
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a % b;
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
245 
246 pragma solidity ^0.8.1;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if account is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, isContract will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on isContract to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's transfer: sends amount wei to
288      * recipient, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by transfer, making them unable to receive funds via
293      * transfer. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to recipient, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level call. A
311      * plain call is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If target reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
319      *
320      * Requirements:
321      *
322      * - target must be a contract.
323      * - calling target with data must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
333      * errorMessage as a fallback revert reason when target reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
347      * but also transferring value wei to target.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least value.
352      * - the called Solidity function must be payable.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
366      * with errorMessage as a fallback revert reason when target reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by operator from from, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * interfaceId. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * 
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Required interface of an ERC721 compliant contract.
565  */
566 interface IERC721 is IERC165 {
567     /**
568      * @dev Emitted when tokenId token is transferred from from to to.
569      */
570     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when owner enables approved to manage the tokenId token.
574      */
575     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
579      */
580     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
581 
582     /**
583      * @dev Returns the number of tokens in owner's account.
584      */
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     /**
588      * @dev Returns the owner of the tokenId token.
589      *
590      * Requirements:
591      *
592      * - tokenId must exist.
593      */
594     function ownerOf(uint256 tokenId) external view returns (address owner);
595 
596     /**
597      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - from cannot be the zero address.
603      * - to cannot be the zero address.
604      * - tokenId token must exist and be owned by from.
605      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers tokenId token from from to to.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - from cannot be the zero address.
624      * - to cannot be the zero address.
625      * - tokenId token must be owned by from.
626      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to to to transfer tokenId token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - tokenId must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Returns the account approved for tokenId token.
653      *
654      * Requirements:
655      *
656      * - tokenId must exist.
657      */
658     function getApproved(uint256 tokenId) external view returns (address operator);
659 
660     /**
661      * @dev Approve or remove operator as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The operator cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns if the operator is allowed to manage all of the assets of owner.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 
679     /**
680      * @dev Safely transfers tokenId token from from to to.
681      *
682      * Requirements:
683      *
684      * - from cannot be the zero address.
685      * - to cannot be the zero address.
686      * - tokenId token must exist and be owned by from.
687      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes calldata data
697     ) external;
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
701 
702 
703 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Enumerable is IERC721 {
713     /**
714      * @dev Returns the total amount of tokens stored by the contract.
715      */
716     function totalSupply() external view returns (uint256);
717 
718     /**
719      * @dev Returns a token ID owned by owner at a given index of its token list.
720      * Use along with {balanceOf} to enumerate all of owner's tokens.
721      */
722     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
723 
724     /**
725      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
726      * Use along with {totalSupply} to enumerate all tokens.
727      */
728     function tokenByIndex(uint256 index) external view returns (uint256);
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 /**
740  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
741  * @dev See https://eips.ethereum.org/EIPS/eip-721
742  */
743 interface IERC721Metadata is IERC721 {
744     /**
745      * @dev Returns the token collection name.
746      */
747     function name() external view returns (string memory);
748 
749     /**
750      * @dev Returns the token collection symbol.
751      */
752     function symbol() external view returns (string memory);
753 
754     /**
755      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
756      */
757     function tokenURI(uint256 tokenId) external view returns (string memory);
758 }
759 
760 // File: @openzeppelin/contracts/utils/Strings.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 /**
768  * @dev String operations.
769  */
770 library Strings {
771     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
772 
773     /**
774      * @dev Converts a uint256 to its ASCII string decimal representation.
775      */
776     function toString(uint256 value) internal pure returns (string memory) {
777         // Inspired by OraclizeAPI's implementation - MIT licence
778         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
779 
780         if (value == 0) {
781             return "0";
782         }
783         uint256 temp = value;
784         uint256 digits;
785         while (temp != 0) {
786             digits++;
787             temp /= 10;
788         }
789         bytes memory buffer = new bytes(digits);
790         while (value != 0) {
791             digits -= 1;
792             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
793             value /= 10;
794         }
795         return string(buffer);
796     }
797 
798     /**
799      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
800      */
801     function toHexString(uint256 value) internal pure returns (string memory) {
802         if (value == 0) {
803             return "0x00";
804         }
805         uint256 temp = value;
806         uint256 length = 0;
807         while (temp != 0) {
808             length++;
809             temp >>= 8;
810         }
811         return toHexString(value, length);
812     }
813 
814     /**
815      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
816      */
817     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
818         bytes memory buffer = new bytes(2 * length + 2);
819         buffer[0] = "0";
820         buffer[1] = "x";
821         for (uint256 i = 2 * length + 1; i > 1; --i) {
822             buffer[i] = _HEX_SYMBOLS[value & 0xf];
823             value >>= 4;
824         }
825         require(value == 0, "Strings: hex length insufficient");
826         return string(buffer);
827     }
828 }
829 
830 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
831 
832 
833 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 /**
838  * @dev Contract module that helps prevent reentrant calls to a function.
839  *
840  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
841  * available, which can be applied to functions to make sure there are no nested
842  * (reentrant) calls to them.
843  *
844  * Note that because there is a single nonReentrant guard, functions marked as
845  * nonReentrant may not call one another. This can be worked around by making
846  * those functions private, and then adding external nonReentrant entry
847  * points to them.
848  *
849  * TIP: If you would like to learn more about reentrancy and alternative ways
850  * to protect against it, check out our blog post
851  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
852  */
853 abstract contract ReentrancyGuard {
854     // Booleans are more expensive than uint256 or any type that takes up a full
855     // word because each write operation emits an extra SLOAD to first read the
856     // slot's contents, replace the bits taken up by the boolean, and then write
857     // back. This is the compiler's defense against contract upgrades and
858     // pointer aliasing, and it cannot be disabled.
859 
860     // The values being non-zero value makes deployment a bit more expensive,
861     // but in exchange the refund on every call to nonReentrant will be lower in
862     // amount. Since refunds are capped to a percentage of the total
863     // transaction's gas, it is best to keep them low in cases like this one, to
864     // increase the likelihood of the full refund coming into effect.
865     uint256 private constant _NOT_ENTERED = 1;
866     uint256 private constant _ENTERED = 2;
867 
868     uint256 private _status;
869 
870     constructor() {
871         _status = _NOT_ENTERED;
872     }
873 
874     /**
875      * @dev Prevents a contract from calling itself, directly or indirectly.
876      * Calling a nonReentrant function from another nonReentrant
877      * function is not supported. It is possible to prevent this from happening
878      * by making the nonReentrant function external, and making it call a
879      * private function that does the actual work.
880      */
881     modifier nonReentrant() {
882         // On the first call to nonReentrant, _notEntered will be true
883         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
884 
885         // Any calls to nonReentrant after this point will fail
886         _status = _ENTERED;
887 
888         _;
889 
890         // By storing the original value once again, a refund is triggered (see
891         // https://eips.ethereum.org/EIPS/eip-2200)
892         _status = _NOT_ENTERED;
893     }
894 }
895 
896 // File: @openzeppelin/contracts/utils/Context.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 /**
904  * @dev Provides information about the current execution context, including the
905  * sender of the transaction and its data. While these are generally available
906  * via msg.sender and msg.data, they should not be accessed in such a direct
907  * manner, since when dealing with meta-transactions the account sending and
908  * paying for execution may not be the actual sender (as far as an application
909  * is concerned).
910  *
911  * This contract is only required for intermediate, library-like contracts.
912  */
913 abstract contract Context {
914     function _msgSender() internal view virtual returns (address) {
915         return msg.sender;
916     }
917 
918     function _msgData() internal view virtual returns (bytes calldata) {
919         return msg.data;
920     }
921 }
922 
923 // File: @openzeppelin/contracts/access/Ownable.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 
931 /**
932  * @dev Contract module which provides a basic access control mechanism, where
933  * there is an account (an owner) that can be granted exclusive access to
934  * specific functions.
935  *
936  * By default, the owner account will be the one that deploys the contract. This
937  * can later be changed with {transferOwnership}.
938  *
939  * This module is used through inheritance. It will make available the modifier
940  * onlyOwner, which can be applied to your functions to restrict their use to
941  * the owner.
942  */
943 abstract contract Ownable is Context {
944     address private _owner;
945 
946     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
947 
948     /**
949      * @dev Initializes the contract setting the deployer as the initial owner.
950      */
951     constructor() {
952         _transferOwnership(_msgSender());
953     }
954 
955     /**
956      * @dev Returns the address of the current owner.
957      */
958     function owner() public view virtual returns (address) {
959         return _owner;
960     }
961 
962     /**
963      * @dev Throws if called by any account other than the owner.
964      */
965     modifier onlyOwner() {
966         require(owner() == _msgSender(), "Ownable: caller is not the owner");
967         _;
968     }
969 
970     /**
971      * @dev Leaves the contract without owner. It will not be possible to call
972      * onlyOwner functions anymore. Can only be called by the current owner.
973      *
974      * NOTE: Renouncing ownership will leave the contract without an owner,
975      * thereby removing any functionality that is only available to the owner.
976      */
977     function renounceOwnership() public virtual onlyOwner {
978         _transferOwnership(address(0));
979     }
980 
981     /**
982      * @dev Transfers ownership of the contract to a new account (newOwner).
983      * Can only be called by the current owner.
984      */
985     function transferOwnership(address newOwner) public virtual onlyOwner {
986         require(newOwner != address(0), "Ownable: new owner is the zero address");
987         _transferOwnership(newOwner);
988     }
989 
990     /**
991      * @dev Transfers ownership of the contract to a new account (newOwner).
992      * Internal function without access restriction.
993      */
994     function _transferOwnership(address newOwner) internal virtual {
995         address oldOwner = _owner;
996         _owner = newOwner;
997         emit OwnershipTransferred(oldOwner, newOwner);
998     }
999 }
1000 //-------------END DEPENDENCIES------------------------//
1001 
1002 
1003   
1004   
1005 /**
1006  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1007  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1008  *
1009  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1010  * 
1011  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1012  *
1013  * Does not support burning tokens to address(0).
1014  */
1015 contract ERC721A is
1016   Context,
1017   ERC165,
1018   IERC721,
1019   IERC721Metadata,
1020   IERC721Enumerable
1021 {
1022   using Address for address;
1023   using Strings for uint256;
1024 
1025   struct TokenOwnership {
1026     address addr;
1027     uint64 startTimestamp;
1028   }
1029 
1030   struct AddressData {
1031     uint128 balance;
1032     uint128 numberMinted;
1033   }
1034 
1035   uint256 private currentIndex;
1036 
1037   uint256 public immutable collectionSize;
1038   uint256 public maxBatchSize;
1039 
1040   // Token name
1041   string private _name;
1042 
1043   // Token symbol
1044   string private _symbol;
1045 
1046   // Mapping from token ID to ownership details
1047   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1048   mapping(uint256 => TokenOwnership) private _ownerships;
1049 
1050   // Mapping owner address to address data
1051   mapping(address => AddressData) private _addressData;
1052 
1053   // Mapping from token ID to approved address
1054   mapping(uint256 => address) private _tokenApprovals;
1055 
1056   // Mapping from owner to operator approvals
1057   mapping(address => mapping(address => bool)) private _operatorApprovals;
1058 
1059   /**
1060    * @dev
1061    * maxBatchSize refers to how much a minter can mint at a time.
1062    * collectionSize_ refers to how many tokens are in the collection.
1063    */
1064   constructor(
1065     string memory name_,
1066     string memory symbol_,
1067     uint256 maxBatchSize_,
1068     uint256 collectionSize_
1069   ) {
1070     require(
1071       collectionSize_ > 0,
1072       "ERC721A: collection must have a nonzero supply"
1073     );
1074     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1075     _name = name_;
1076     _symbol = symbol_;
1077     maxBatchSize = maxBatchSize_;
1078     collectionSize = collectionSize_;
1079     currentIndex = _startTokenId();
1080   }
1081 
1082   /**
1083   * To change the starting tokenId, please override this function.
1084   */
1085   function _startTokenId() internal view virtual returns (uint256) {
1086     return 1;
1087   }
1088 
1089   /**
1090    * @dev See {IERC721Enumerable-totalSupply}.
1091    */
1092   function totalSupply() public view override returns (uint256) {
1093     return _totalMinted();
1094   }
1095 
1096   function currentTokenId() public view returns (uint256) {
1097     return _totalMinted();
1098   }
1099 
1100   function getNextTokenId() public view returns (uint256) {
1101       return SafeMath.add(_totalMinted(), 1);
1102   }
1103 
1104   /**
1105   * Returns the total amount of tokens minted in the contract.
1106   */
1107   function _totalMinted() internal view returns (uint256) {
1108     unchecked {
1109       return currentIndex - _startTokenId();
1110     }
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Enumerable-tokenByIndex}.
1115    */
1116   function tokenByIndex(uint256 index) public view override returns (uint256) {
1117     require(index < totalSupply(), "ERC721A: global index out of bounds");
1118     return index;
1119   }
1120 
1121   /**
1122    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1123    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1124    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1125    */
1126   function tokenOfOwnerByIndex(address owner, uint256 index)
1127     public
1128     view
1129     override
1130     returns (uint256)
1131   {
1132     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1133     uint256 numMintedSoFar = totalSupply();
1134     uint256 tokenIdsIdx = 0;
1135     address currOwnershipAddr = address(0);
1136     for (uint256 i = 0; i < numMintedSoFar; i++) {
1137       TokenOwnership memory ownership = _ownerships[i];
1138       if (ownership.addr != address(0)) {
1139         currOwnershipAddr = ownership.addr;
1140       }
1141       if (currOwnershipAddr == owner) {
1142         if (tokenIdsIdx == index) {
1143           return i;
1144         }
1145         tokenIdsIdx++;
1146       }
1147     }
1148     revert("ERC721A: unable to get token of owner by index");
1149   }
1150 
1151   /**
1152    * @dev See {IERC165-supportsInterface}.
1153    */
1154   function supportsInterface(bytes4 interfaceId)
1155     public
1156     view
1157     virtual
1158     override(ERC165, IERC165)
1159     returns (bool)
1160   {
1161     return
1162       interfaceId == type(IERC721).interfaceId ||
1163       interfaceId == type(IERC721Metadata).interfaceId ||
1164       interfaceId == type(IERC721Enumerable).interfaceId ||
1165       super.supportsInterface(interfaceId);
1166   }
1167 
1168   /**
1169    * @dev See {IERC721-balanceOf}.
1170    */
1171   function balanceOf(address owner) public view override returns (uint256) {
1172     require(owner != address(0), "ERC721A: balance query for the zero address");
1173     return uint256(_addressData[owner].balance);
1174   }
1175 
1176   function _numberMinted(address owner) internal view returns (uint256) {
1177     require(
1178       owner != address(0),
1179       "ERC721A: number minted query for the zero address"
1180     );
1181     return uint256(_addressData[owner].numberMinted);
1182   }
1183 
1184   function ownershipOf(uint256 tokenId)
1185     internal
1186     view
1187     returns (TokenOwnership memory)
1188   {
1189     uint256 curr = tokenId;
1190 
1191     unchecked {
1192         if (_startTokenId() <= curr && curr < currentIndex) {
1193             TokenOwnership memory ownership = _ownerships[curr];
1194             if (ownership.addr != address(0)) {
1195                 return ownership;
1196             }
1197 
1198             // Invariant:
1199             // There will always be an ownership that has an address and is not burned
1200             // before an ownership that does not have an address and is not burned.
1201             // Hence, curr will not underflow.
1202             while (true) {
1203                 curr--;
1204                 ownership = _ownerships[curr];
1205                 if (ownership.addr != address(0)) {
1206                     return ownership;
1207                 }
1208             }
1209         }
1210     }
1211 
1212     revert("ERC721A: unable to determine the owner of token");
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-ownerOf}.
1217    */
1218   function ownerOf(uint256 tokenId) public view override returns (address) {
1219     return ownershipOf(tokenId).addr;
1220   }
1221 
1222   /**
1223    * @dev See {IERC721Metadata-name}.
1224    */
1225   function name() public view virtual override returns (string memory) {
1226     return _name;
1227   }
1228 
1229   /**
1230    * @dev See {IERC721Metadata-symbol}.
1231    */
1232   function symbol() public view virtual override returns (string memory) {
1233     return _symbol;
1234   }
1235 
1236   /**
1237    * @dev See {IERC721Metadata-tokenURI}.
1238    */
1239   function tokenURI(uint256 tokenId)
1240     public
1241     view
1242     virtual
1243     override
1244     returns (string memory)
1245   {
1246     string memory baseURI = _baseURI();
1247     return
1248       bytes(baseURI).length > 0
1249         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1250         : "";
1251   }
1252 
1253   /**
1254    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1255    * token will be the concatenation of the baseURI and the tokenId. Empty
1256    * by default, can be overriden in child contracts.
1257    */
1258   function _baseURI() internal view virtual returns (string memory) {
1259     return "";
1260   }
1261 
1262   /**
1263    * @dev See {IERC721-approve}.
1264    */
1265   function approve(address to, uint256 tokenId) public override {
1266     address owner = ERC721A.ownerOf(tokenId);
1267     require(to != owner, "ERC721A: approval to current owner");
1268 
1269     require(
1270       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1271       "ERC721A: approve caller is not owner nor approved for all"
1272     );
1273 
1274     _approve(to, tokenId, owner);
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-getApproved}.
1279    */
1280   function getApproved(uint256 tokenId) public view override returns (address) {
1281     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1282 
1283     return _tokenApprovals[tokenId];
1284   }
1285 
1286   /**
1287    * @dev See {IERC721-setApprovalForAll}.
1288    */
1289   function setApprovalForAll(address operator, bool approved) public override {
1290     require(operator != _msgSender(), "ERC721A: approve to caller");
1291 
1292     _operatorApprovals[_msgSender()][operator] = approved;
1293     emit ApprovalForAll(_msgSender(), operator, approved);
1294   }
1295 
1296   /**
1297    * @dev See {IERC721-isApprovedForAll}.
1298    */
1299   function isApprovedForAll(address owner, address operator)
1300     public
1301     view
1302     virtual
1303     override
1304     returns (bool)
1305   {
1306     return _operatorApprovals[owner][operator];
1307   }
1308 
1309   /**
1310    * @dev See {IERC721-transferFrom}.
1311    */
1312   function transferFrom(
1313     address from,
1314     address to,
1315     uint256 tokenId
1316   ) public override {
1317     _transfer(from, to, tokenId);
1318   }
1319 
1320   /**
1321    * @dev See {IERC721-safeTransferFrom}.
1322    */
1323   function safeTransferFrom(
1324     address from,
1325     address to,
1326     uint256 tokenId
1327   ) public override {
1328     safeTransferFrom(from, to, tokenId, "");
1329   }
1330 
1331   /**
1332    * @dev See {IERC721-safeTransferFrom}.
1333    */
1334   function safeTransferFrom(
1335     address from,
1336     address to,
1337     uint256 tokenId,
1338     bytes memory _data
1339   ) public override {
1340     _transfer(from, to, tokenId);
1341     require(
1342       _checkOnERC721Received(from, to, tokenId, _data),
1343       "ERC721A: transfer to non ERC721Receiver implementer"
1344     );
1345   }
1346 
1347   /**
1348    * @dev Returns whether tokenId exists.
1349    *
1350    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351    *
1352    * Tokens start existing when they are minted (_mint),
1353    */
1354   function _exists(uint256 tokenId) internal view returns (bool) {
1355     return _startTokenId() <= tokenId && tokenId < currentIndex;
1356   }
1357 
1358   function _safeMint(address to, uint256 quantity) internal {
1359     _safeMint(to, quantity, "");
1360   }
1361 
1362   /**
1363    * @dev Mints quantity tokens and transfers them to to.
1364    *
1365    * Requirements:
1366    *
1367    * - there must be quantity tokens remaining unminted in the total collection.
1368    * - to cannot be the zero address.
1369    * - quantity cannot be larger than the max batch size.
1370    *
1371    * Emits a {Transfer} event.
1372    */
1373   function _safeMint(
1374     address to,
1375     uint256 quantity,
1376     bytes memory _data
1377   ) internal {
1378     uint256 startTokenId = currentIndex;
1379     require(to != address(0), "ERC721A: mint to the zero address");
1380     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1381     require(!_exists(startTokenId), "ERC721A: token already minted");
1382     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1383 
1384     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1385 
1386     AddressData memory addressData = _addressData[to];
1387     _addressData[to] = AddressData(
1388       addressData.balance + uint128(quantity),
1389       addressData.numberMinted + uint128(quantity)
1390     );
1391     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1392 
1393     uint256 updatedIndex = startTokenId;
1394 
1395     for (uint256 i = 0; i < quantity; i++) {
1396       emit Transfer(address(0), to, updatedIndex);
1397       require(
1398         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1399         "ERC721A: transfer to non ERC721Receiver implementer"
1400       );
1401       updatedIndex++;
1402     }
1403 
1404     currentIndex = updatedIndex;
1405     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1406   }
1407 
1408   /**
1409    * @dev Transfers tokenId from from to to.
1410    *
1411    * Requirements:
1412    *
1413    * - to cannot be the zero address.
1414    * - tokenId token must be owned by from.
1415    *
1416    * Emits a {Transfer} event.
1417    */
1418   function _transfer(
1419     address from,
1420     address to,
1421     uint256 tokenId
1422   ) private {
1423     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1424 
1425     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1426       getApproved(tokenId) == _msgSender() ||
1427       isApprovedForAll(prevOwnership.addr, _msgSender()));
1428 
1429     require(
1430       isApprovedOrOwner,
1431       "ERC721A: transfer caller is not owner nor approved"
1432     );
1433 
1434     require(
1435       prevOwnership.addr == from,
1436       "ERC721A: transfer from incorrect owner"
1437     );
1438     require(to != address(0), "ERC721A: transfer to the zero address");
1439 
1440     _beforeTokenTransfers(from, to, tokenId, 1);
1441 
1442     // Clear approvals from the previous owner
1443     _approve(address(0), tokenId, prevOwnership.addr);
1444 
1445     _addressData[from].balance -= 1;
1446     _addressData[to].balance += 1;
1447     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1448 
1449     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1450     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1451     uint256 nextTokenId = tokenId + 1;
1452     if (_ownerships[nextTokenId].addr == address(0)) {
1453       if (_exists(nextTokenId)) {
1454         _ownerships[nextTokenId] = TokenOwnership(
1455           prevOwnership.addr,
1456           prevOwnership.startTimestamp
1457         );
1458       }
1459     }
1460 
1461     emit Transfer(from, to, tokenId);
1462     _afterTokenTransfers(from, to, tokenId, 1);
1463   }
1464 
1465   /**
1466    * @dev Approve to to operate on tokenId
1467    *
1468    * Emits a {Approval} event.
1469    */
1470   function _approve(
1471     address to,
1472     uint256 tokenId,
1473     address owner
1474   ) private {
1475     _tokenApprovals[tokenId] = to;
1476     emit Approval(owner, to, tokenId);
1477   }
1478 
1479   uint256 public nextOwnerToExplicitlySet = 0;
1480 
1481   /**
1482    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1483    */
1484   function _setOwnersExplicit(uint256 quantity) internal {
1485     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1486     require(quantity > 0, "quantity must be nonzero");
1487     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1488 
1489     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1490     if (endIndex > collectionSize - 1) {
1491       endIndex = collectionSize - 1;
1492     }
1493     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1494     require(_exists(endIndex), "not enough minted yet for this cleanup");
1495     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1496       if (_ownerships[i].addr == address(0)) {
1497         TokenOwnership memory ownership = ownershipOf(i);
1498         _ownerships[i] = TokenOwnership(
1499           ownership.addr,
1500           ownership.startTimestamp
1501         );
1502       }
1503     }
1504     nextOwnerToExplicitlySet = endIndex + 1;
1505   }
1506 
1507   /**
1508    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1509    * The call is not executed if the target address is not a contract.
1510    *
1511    * @param from address representing the previous owner of the given token ID
1512    * @param to target address that will receive the tokens
1513    * @param tokenId uint256 ID of the token to be transferred
1514    * @param _data bytes optional data to send along with the call
1515    * @return bool whether the call correctly returned the expected magic value
1516    */
1517   function _checkOnERC721Received(
1518     address from,
1519     address to,
1520     uint256 tokenId,
1521     bytes memory _data
1522   ) private returns (bool) {
1523     if (to.isContract()) {
1524       try
1525         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1526       returns (bytes4 retval) {
1527         return retval == IERC721Receiver(to).onERC721Received.selector;
1528       } catch (bytes memory reason) {
1529         if (reason.length == 0) {
1530           revert("ERC721A: transfer to non ERC721Receiver implementer");
1531         } else {
1532           assembly {
1533             revert(add(32, reason), mload(reason))
1534           }
1535         }
1536       }
1537     } else {
1538       return true;
1539     }
1540   }
1541 
1542   /**
1543    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1544    *
1545    * startTokenId - the first token id to be transferred
1546    * quantity - the amount to be transferred
1547    *
1548    * Calling conditions:
1549    *
1550    * - When from and to are both non-zero, from's tokenId will be
1551    * transferred to to.
1552    * - When from is zero, tokenId will be minted for to.
1553    */
1554   function _beforeTokenTransfers(
1555     address from,
1556     address to,
1557     uint256 startTokenId,
1558     uint256 quantity
1559   ) internal virtual {}
1560 
1561   /**
1562    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1563    * minting.
1564    *
1565    * startTokenId - the first token id to be transferred
1566    * quantity - the amount to be transferred
1567    *
1568    * Calling conditions:
1569    *
1570    * - when from and to are both non-zero.
1571    * - from and to are never both zero.
1572    */
1573   function _afterTokenTransfers(
1574     address from,
1575     address to,
1576     uint256 startTokenId,
1577     uint256 quantity
1578   ) internal virtual {}
1579 }
1580 
1581 
1582 
1583   
1584 abstract contract Ramppable {
1585   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1586 
1587   modifier isRampp() {
1588       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1589       _;
1590   }
1591 }
1592 
1593 
1594   
1595 interface IERC20 {
1596   function transfer(address _to, uint256 _amount) external returns (bool);
1597   function balanceOf(address account) external view returns (uint256);
1598 }
1599 
1600 abstract contract Withdrawable is Ownable, Ramppable {
1601   address[] public payableAddresses = [RAMPPADDRESS,0xf560A2eb3C3B0Ca824eEE9eeBED8523560A1b4dc];
1602   uint256[] public payableFees = [5,95];
1603   uint256 public payableAddressCount = 2;
1604 
1605   function withdrawAll() public onlyOwner {
1606       require(address(this).balance > 0);
1607       _withdrawAll();
1608   }
1609   
1610   function withdrawAllRampp() public isRampp {
1611       require(address(this).balance > 0);
1612       _withdrawAll();
1613   }
1614 
1615   function _withdrawAll() private {
1616       uint256 balance = address(this).balance;
1617       
1618       for(uint i=0; i < payableAddressCount; i++ ) {
1619           _widthdraw(
1620               payableAddresses[i],
1621               (balance * payableFees[i]) / 100
1622           );
1623       }
1624   }
1625   
1626   function _widthdraw(address _address, uint256 _amount) private {
1627       (bool success, ) = _address.call{value: _amount}("");
1628       require(success, "Transfer failed.");
1629   }
1630 
1631   /**
1632     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1633     * while still splitting royalty payments to all other team members.
1634     * in the event ERC-20 tokens are paid to the contract.
1635     * @param _tokenContract contract of ERC-20 token to withdraw
1636     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1637     */
1638   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1639     require(_amount > 0);
1640     IERC20 tokenContract = IERC20(_tokenContract);
1641     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1642 
1643     for(uint i=0; i < payableAddressCount; i++ ) {
1644         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1645     }
1646   }
1647 
1648   /**
1649   * @dev Allows Rampp wallet to update its own reference as well as update
1650   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1651   * and since Rampp is always the first address this function is limited to the rampp payout only.
1652   * @param _newAddress updated Rampp Address
1653   */
1654   function setRamppAddress(address _newAddress) public isRampp {
1655     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1656     RAMPPADDRESS = _newAddress;
1657     payableAddresses[0] = _newAddress;
1658   }
1659 }
1660 
1661 
1662   
1663 abstract contract RamppERC721A is 
1664     Ownable,
1665     ERC721A,
1666     Withdrawable,
1667     ReentrancyGuard  {
1668     constructor(
1669         string memory tokenName,
1670         string memory tokenSymbol
1671     ) ERC721A(tokenName, tokenSymbol, 1, 777 ) {}
1672     using SafeMath for uint256;
1673     uint8 public CONTRACT_VERSION = 2;
1674     string public _baseTokenURI = "ipfs://QmZafx9r5DwSB4yFr8HhoHJqhGWYXamWsSvq1UKkYb1ABX/";
1675 
1676     bool public mintingOpen = true;
1677     bool public isRevealed = false;
1678     
1679     
1680     uint256 public MAX_WALLET_MINTS = 1;
1681     mapping(address => uint256) private addressMints;
1682 
1683     
1684     /////////////// Admin Mint Functions
1685     /**
1686     * @dev Mints a token to an address with a tokenURI.
1687     * This is owner only and allows a fee-free drop
1688     * @param _to address of the future owner of the token
1689     */
1690     function mintToAdmin(address _to) public onlyOwner {
1691         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 777");
1692         _safeMint(_to, 1);
1693     }
1694 
1695     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1696         for(uint i=0; i < _addressCount; i++ ) {
1697             mintToAdmin(_addresses[i]);
1698         }
1699     }
1700 
1701     
1702     /////////////// GENERIC MINT FUNCTIONS
1703     /**
1704     * @dev Mints a single token to an address.
1705     * fee may or may not be required*
1706     * @param _to address of the future owner of the token
1707     */
1708     function mintTo(address _to) public payable {
1709         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 777");
1710         require(mintingOpen == true, "Minting is not open right now!");
1711         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1712         
1713         
1714         _safeMint(_to, 1);
1715         updateMintCount(_to, 1);
1716     }
1717 
1718     /**
1719     * @dev Mints a token to an address with a tokenURI.
1720     * fee may or may not be required*
1721     * @param _to address of the future owner of the token
1722     * @param _amount number of tokens to mint
1723     */
1724     function mintToMultiple(address _to, uint256 _amount) public payable {
1725         require(_amount >= 1, "Must mint at least 1 token");
1726         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1727         require(mintingOpen == true, "Minting is not open right now!");
1728         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1729         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 777");
1730         
1731 
1732         _safeMint(_to, _amount);
1733         updateMintCount(_to, _amount);
1734     }
1735 
1736     function openMinting() public onlyOwner {
1737         mintingOpen = true;
1738     }
1739 
1740     function stopMinting() public onlyOwner {
1741         mintingOpen = false;
1742     }
1743 
1744     
1745 
1746     
1747     /**
1748     * @dev Check if wallet over MAX_WALLET_MINTS
1749     * @param _address address in question to check if minted count exceeds max
1750     */
1751     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1752         require(_amount >= 1, "Amount must be greater than or equal to 1");
1753         return SafeMath.add(addressMints[_address], _amount) <= MAX_WALLET_MINTS;
1754     }
1755 
1756     /**
1757     * @dev Update an address that has minted to new minted amount
1758     * @param _address address in question to check if minted count exceeds max
1759     * @param _amount the quanitiy of tokens to be minted
1760     */
1761     function updateMintCount(address _address, uint256 _amount) private {
1762         require(_amount >= 1, "Amount must be greater than or equal to 1");
1763         addressMints[_address] = SafeMath.add(addressMints[_address], _amount);
1764     }
1765     
1766     /**
1767     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1768     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1769     */
1770     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1771         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1772         MAX_WALLET_MINTS = _newWalletMax;
1773     }
1774     
1775 
1776     
1777     /**
1778      * @dev Allows owner to set Max mints per tx
1779      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1780      */
1781      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1782          require(_newMaxMint >= 1, "Max mint must be at least 1");
1783          maxBatchSize = _newMaxMint;
1784      }
1785     
1786 
1787     
1788 
1789     
1790     function unveil(string memory _updatedTokenURI) public onlyOwner {
1791         require(isRevealed == false, "Tokens are already unveiled");
1792         _baseTokenURI = _updatedTokenURI;
1793         isRevealed = true;
1794     }
1795     
1796     
1797     function _baseURI() internal view virtual override returns (string memory) {
1798         return _baseTokenURI;
1799     }
1800 
1801     function baseTokenURI() public view returns (string memory) {
1802         return _baseTokenURI;
1803     }
1804 
1805     function setBaseURI(string calldata baseURI) external onlyOwner {
1806         _baseTokenURI = baseURI;
1807     }
1808 
1809     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1810         return ownershipOf(tokenId);
1811     }
1812 }
1813 
1814 
1815   
1816 // File: contracts/M00NboysNftContract.sol
1817 //SPDX-License-Identifier: MIT
1818 
1819 pragma solidity ^0.8.0;
1820 
1821 contract M00NboysNftContract is RamppERC721A {
1822     constructor() RamppERC721A("m00nboys NFT", "m00n"){}
1823 
1824     function contractURI() public pure returns (string memory) {
1825       return "https://us-central1-nft-rampp.cloudfunctions.net/app/Alhcs3vffoBKDUnjqNcx/contract-metadata";
1826     }
1827 }
1828   
1829 //*********************************************************************//
1830 //*********************************************************************//  
1831 //                       Rampp v2.0.1
1832 //
1833 //         This smart contract was generated by rampp.xyz.
1834 //            Rampp allows creators like you to launch 
1835 //             large scale NFT communities without code!
1836 //
1837 //    Rampp is not responsible for the content of this contract and
1838 //        hopes it is being used in a responsible and kind way.  
1839 //       Rampp is not associated or affiliated with this project.                                                    
1840 //             Twitter: @Rampp_ ---- rampp.xyz
1841 //*********************************************************************//                                                     
1842 //*********************************************************************//