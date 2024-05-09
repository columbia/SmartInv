1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _             _      _      _  _    _                                         _     __ 
5 // | |__    ___  | |__  | |__  (_)| |_ | |_   ___  __      __ _ __     __      __| |_  / _|
6 // | '_ \  / _ \ | '_ \ | '_ \ | || __|| __| / _ \ \ \ /\ / /| '_ \    \ \ /\ / /| __|| |_ 
7 // | | | || (_) || |_) || |_) || || |_ | |_ | (_) | \ V  V / | | | | _  \ V  V / | |_ |  _|
8 // |_| |_| \___/ |_.__/ |_.__/ |_| \__| \__| \___/   \_/\_/  |_| |_|(_)  \_/\_/   \__||_|  
9 //
10 //*********************************************************************//
11 //*********************************************************************//
12   
13 //-------------DEPENDENCIES--------------------------//
14 
15 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
16 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 // CAUTION
21 // This version of SafeMath should only be used with Solidity 0.8 or later,
22 // because it relies on the compiler's built in overflow checks.
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations.
26  *
27  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
28  * now has built in overflow checking.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a / b);
82         }
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a % b);
94         }
95     }
96 
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's + operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a + b;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's - operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's * operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's / operator.
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a / b;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * reverting when dividing by zero.
156      *
157      * Counterpart to Solidity's % operator. This function uses a revert
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a % b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {trySub}.
175      *
176      * Counterpart to Solidity's - operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(
183         uint256 a,
184         uint256 b,
185         string memory errorMessage
186     ) internal pure returns (uint256) {
187         unchecked {
188             require(b <= a, errorMessage);
189             return a - b;
190         }
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's / operator. Note: this function uses a
198      * revert opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a / b;
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * reverting with custom message when dividing by zero.
219      *
220      * CAUTION: This function is deprecated because it requires allocating memory for the error
221      * message unnecessarily. For custom revert reasons use {tryMod}.
222      *
223      * Counterpart to Solidity's % operator. This function uses a revert
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a % b;
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
247 
248 pragma solidity ^0.8.1;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if account is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, isContract will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      *
271      * [IMPORTANT]
272      * ====
273      * You shouldn't rely on isContract to protect against flash loan attacks!
274      *
275      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
276      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
277      * constructor.
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies on extcodesize/address.code.length, which returns 0
282         // for contracts in construction, since the code is only stored at the end
283         // of the constructor execution.
284 
285         return account.code.length > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's transfer: sends amount wei to
290      * recipient, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by transfer, making them unable to receive funds via
295      * transfer. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to recipient, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         (bool success, ) = recipient.call{value: amount}("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level call. A
313      * plain call is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If target reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
321      *
322      * Requirements:
323      *
324      * - target must be a contract.
325      * - calling target with data must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
335      * errorMessage as a fallback revert reason when target reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
349      * but also transferring value wei to target.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least value.
354      * - the called Solidity function must be payable.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
368      * with errorMessage as a fallback revert reason when target reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         require(isContract(target), "Address: call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.call{value: value}(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
392         return functionStaticCall(target, data, "Address: low-level static call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
397      * but performing a static call.
398      *
399      * _Available since v3.3._
400      */
401     function functionStaticCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         require(isContract(target), "Address: static call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.staticcall(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
424      * but performing a delegate call.
425      *
426      * _Available since v3.4._
427      */
428     function functionDelegateCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(isContract(target), "Address: delegate call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
441      * revert reason using the provided one.
442      *
443      * _Available since v4.3._
444      */
445     function verifyCallResult(
446         bool success,
447         bytes memory returndata,
448         string memory errorMessage
449     ) internal pure returns (bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 interface IERC721Receiver {
481     /**
482      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
483      * by operator from from, this function is called.
484      *
485      * It must return its Solidity selector to confirm the token transfer.
486      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
487      *
488      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
489      */
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Interface of the ERC165 standard, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-165[EIP].
508  *
509  * Implementers can declare support of contract interfaces, which can then be
510  * queried by others ({ERC165Checker}).
511  *
512  * For an implementation, see {ERC165}.
513  */
514 interface IERC165 {
515     /**
516      * @dev Returns true if this contract implements the interface defined by
517      * interfaceId. See the corresponding
518      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
519      * to learn more about how these ids are created.
520      *
521      * This function call must use less than 30 000 gas.
522      */
523     function supportsInterface(bytes4 interfaceId) external view returns (bool);
524 }
525 
526 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * 
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Required interface of an ERC721 compliant contract.
567  */
568 interface IERC721 is IERC165 {
569     /**
570      * @dev Emitted when tokenId token is transferred from from to to.
571      */
572     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when owner enables approved to manage the tokenId token.
576      */
577     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
581      */
582     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
583 
584     /**
585      * @dev Returns the number of tokens in owner's account.
586      */
587     function balanceOf(address owner) external view returns (uint256 balance);
588 
589     /**
590      * @dev Returns the owner of the tokenId token.
591      *
592      * Requirements:
593      *
594      * - tokenId must exist.
595      */
596     function ownerOf(uint256 tokenId) external view returns (address owner);
597 
598     /**
599      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
601      *
602      * Requirements:
603      *
604      * - from cannot be the zero address.
605      * - to cannot be the zero address.
606      * - tokenId token must exist and be owned by from.
607      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
608      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Transfers tokenId token from from to to.
620      *
621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
622      *
623      * Requirements:
624      *
625      * - from cannot be the zero address.
626      * - to cannot be the zero address.
627      * - tokenId token must be owned by from.
628      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Gives permission to to to transfer tokenId token to another account.
640      * The approval is cleared when the token is transferred.
641      *
642      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
643      *
644      * Requirements:
645      *
646      * - The caller must own the token or be an approved operator.
647      * - tokenId must exist.
648      *
649      * Emits an {Approval} event.
650      */
651     function approve(address to, uint256 tokenId) external;
652 
653     /**
654      * @dev Returns the account approved for tokenId token.
655      *
656      * Requirements:
657      *
658      * - tokenId must exist.
659      */
660     function getApproved(uint256 tokenId) external view returns (address operator);
661 
662     /**
663      * @dev Approve or remove operator as an operator for the caller.
664      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
665      *
666      * Requirements:
667      *
668      * - The operator cannot be the caller.
669      *
670      * Emits an {ApprovalForAll} event.
671      */
672     function setApprovalForAll(address operator, bool _approved) external;
673 
674     /**
675      * @dev Returns if the operator is allowed to manage all of the assets of owner.
676      *
677      * See {setApprovalForAll}
678      */
679     function isApprovedForAll(address owner, address operator) external view returns (bool);
680 
681     /**
682      * @dev Safely transfers tokenId token from from to to.
683      *
684      * Requirements:
685      *
686      * - from cannot be the zero address.
687      * - to cannot be the zero address.
688      * - tokenId token must exist and be owned by from.
689      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes calldata data
699     ) external;
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
712  * @dev See https://eips.ethereum.org/EIPS/eip-721
713  */
714 interface IERC721Enumerable is IERC721 {
715     /**
716      * @dev Returns the total amount of tokens stored by the contract.
717      */
718     function totalSupply() external view returns (uint256);
719 
720     /**
721      * @dev Returns a token ID owned by owner at a given index of its token list.
722      * Use along with {balanceOf} to enumerate all of owner's tokens.
723      */
724     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
725 
726     /**
727      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
728      * Use along with {totalSupply} to enumerate all tokens.
729      */
730     function tokenByIndex(uint256 index) external view returns (uint256);
731 }
732 
733 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
734 
735 
736 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Metadata is IERC721 {
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 }
761 
762 // File: @openzeppelin/contracts/utils/Strings.sol
763 
764 
765 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @dev String operations.
771  */
772 library Strings {
773     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
774 
775     /**
776      * @dev Converts a uint256 to its ASCII string decimal representation.
777      */
778     function toString(uint256 value) internal pure returns (string memory) {
779         // Inspired by OraclizeAPI's implementation - MIT licence
780         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
781 
782         if (value == 0) {
783             return "0";
784         }
785         uint256 temp = value;
786         uint256 digits;
787         while (temp != 0) {
788             digits++;
789             temp /= 10;
790         }
791         bytes memory buffer = new bytes(digits);
792         while (value != 0) {
793             digits -= 1;
794             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
795             value /= 10;
796         }
797         return string(buffer);
798     }
799 
800     /**
801      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
802      */
803     function toHexString(uint256 value) internal pure returns (string memory) {
804         if (value == 0) {
805             return "0x00";
806         }
807         uint256 temp = value;
808         uint256 length = 0;
809         while (temp != 0) {
810             length++;
811             temp >>= 8;
812         }
813         return toHexString(value, length);
814     }
815 
816     /**
817      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
818      */
819     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
820         bytes memory buffer = new bytes(2 * length + 2);
821         buffer[0] = "0";
822         buffer[1] = "x";
823         for (uint256 i = 2 * length + 1; i > 1; --i) {
824             buffer[i] = _HEX_SYMBOLS[value & 0xf];
825             value >>= 4;
826         }
827         require(value == 0, "Strings: hex length insufficient");
828         return string(buffer);
829     }
830 }
831 
832 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
833 
834 
835 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @dev Contract module that helps prevent reentrant calls to a function.
841  *
842  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
843  * available, which can be applied to functions to make sure there are no nested
844  * (reentrant) calls to them.
845  *
846  * Note that because there is a single nonReentrant guard, functions marked as
847  * nonReentrant may not call one another. This can be worked around by making
848  * those functions private, and then adding external nonReentrant entry
849  * points to them.
850  *
851  * TIP: If you would like to learn more about reentrancy and alternative ways
852  * to protect against it, check out our blog post
853  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
854  */
855 abstract contract ReentrancyGuard {
856     // Booleans are more expensive than uint256 or any type that takes up a full
857     // word because each write operation emits an extra SLOAD to first read the
858     // slot's contents, replace the bits taken up by the boolean, and then write
859     // back. This is the compiler's defense against contract upgrades and
860     // pointer aliasing, and it cannot be disabled.
861 
862     // The values being non-zero value makes deployment a bit more expensive,
863     // but in exchange the refund on every call to nonReentrant will be lower in
864     // amount. Since refunds are capped to a percentage of the total
865     // transaction's gas, it is best to keep them low in cases like this one, to
866     // increase the likelihood of the full refund coming into effect.
867     uint256 private constant _NOT_ENTERED = 1;
868     uint256 private constant _ENTERED = 2;
869 
870     uint256 private _status;
871 
872     constructor() {
873         _status = _NOT_ENTERED;
874     }
875 
876     /**
877      * @dev Prevents a contract from calling itself, directly or indirectly.
878      * Calling a nonReentrant function from another nonReentrant
879      * function is not supported. It is possible to prevent this from happening
880      * by making the nonReentrant function external, and making it call a
881      * private function that does the actual work.
882      */
883     modifier nonReentrant() {
884         // On the first call to nonReentrant, _notEntered will be true
885         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
886 
887         // Any calls to nonReentrant after this point will fail
888         _status = _ENTERED;
889 
890         _;
891 
892         // By storing the original value once again, a refund is triggered (see
893         // https://eips.ethereum.org/EIPS/eip-2200)
894         _status = _NOT_ENTERED;
895     }
896 }
897 
898 // File: @openzeppelin/contracts/utils/Context.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Provides information about the current execution context, including the
907  * sender of the transaction and its data. While these are generally available
908  * via msg.sender and msg.data, they should not be accessed in such a direct
909  * manner, since when dealing with meta-transactions the account sending and
910  * paying for execution may not be the actual sender (as far as an application
911  * is concerned).
912  *
913  * This contract is only required for intermediate, library-like contracts.
914  */
915 abstract contract Context {
916     function _msgSender() internal view virtual returns (address) {
917         return msg.sender;
918     }
919 
920     function _msgData() internal view virtual returns (bytes calldata) {
921         return msg.data;
922     }
923 }
924 
925 // File: @openzeppelin/contracts/access/Ownable.sol
926 
927 
928 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @dev Contract module which provides a basic access control mechanism, where
935  * there is an account (an owner) that can be granted exclusive access to
936  * specific functions.
937  *
938  * By default, the owner account will be the one that deploys the contract. This
939  * can later be changed with {transferOwnership}.
940  *
941  * This module is used through inheritance. It will make available the modifier
942  * onlyOwner, which can be applied to your functions to restrict their use to
943  * the owner.
944  */
945 abstract contract Ownable is Context {
946     address private _owner;
947 
948     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
949 
950     /**
951      * @dev Initializes the contract setting the deployer as the initial owner.
952      */
953     constructor() {
954         _transferOwnership(_msgSender());
955     }
956 
957     /**
958      * @dev Returns the address of the current owner.
959      */
960     function owner() public view virtual returns (address) {
961         return _owner;
962     }
963 
964     /**
965      * @dev Throws if called by any account other than the owner.
966      */
967     modifier onlyOwner() {
968         require(owner() == _msgSender(), "Ownable: caller is not the owner");
969         _;
970     }
971 
972     /**
973      * @dev Leaves the contract without owner. It will not be possible to call
974      * onlyOwner functions anymore. Can only be called by the current owner.
975      *
976      * NOTE: Renouncing ownership will leave the contract without an owner,
977      * thereby removing any functionality that is only available to the owner.
978      */
979     function renounceOwnership() public virtual onlyOwner {
980         _transferOwnership(address(0));
981     }
982 
983     /**
984      * @dev Transfers ownership of the contract to a new account (newOwner).
985      * Can only be called by the current owner.
986      */
987     function transferOwnership(address newOwner) public virtual onlyOwner {
988         require(newOwner != address(0), "Ownable: new owner is the zero address");
989         _transferOwnership(newOwner);
990     }
991 
992     /**
993      * @dev Transfers ownership of the contract to a new account (newOwner).
994      * Internal function without access restriction.
995      */
996     function _transferOwnership(address newOwner) internal virtual {
997         address oldOwner = _owner;
998         _owner = newOwner;
999         emit OwnershipTransferred(oldOwner, newOwner);
1000     }
1001 }
1002 //-------------END DEPENDENCIES------------------------//
1003 
1004 
1005   
1006   
1007 /**
1008  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1009  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1010  *
1011  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1012  * 
1013  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1014  *
1015  * Does not support burning tokens to address(0).
1016  */
1017 contract ERC721A is
1018   Context,
1019   ERC165,
1020   IERC721,
1021   IERC721Metadata,
1022   IERC721Enumerable
1023 {
1024   using Address for address;
1025   using Strings for uint256;
1026 
1027   struct TokenOwnership {
1028     address addr;
1029     uint64 startTimestamp;
1030   }
1031 
1032   struct AddressData {
1033     uint128 balance;
1034     uint128 numberMinted;
1035   }
1036 
1037   uint256 private currentIndex;
1038 
1039   uint256 public immutable collectionSize;
1040   uint256 public maxBatchSize;
1041 
1042   // Token name
1043   string private _name;
1044 
1045   // Token symbol
1046   string private _symbol;
1047 
1048   // Mapping from token ID to ownership details
1049   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1050   mapping(uint256 => TokenOwnership) private _ownerships;
1051 
1052   // Mapping owner address to address data
1053   mapping(address => AddressData) private _addressData;
1054 
1055   // Mapping from token ID to approved address
1056   mapping(uint256 => address) private _tokenApprovals;
1057 
1058   // Mapping from owner to operator approvals
1059   mapping(address => mapping(address => bool)) private _operatorApprovals;
1060 
1061   /**
1062    * @dev
1063    * maxBatchSize refers to how much a minter can mint at a time.
1064    * collectionSize_ refers to how many tokens are in the collection.
1065    */
1066   constructor(
1067     string memory name_,
1068     string memory symbol_,
1069     uint256 maxBatchSize_,
1070     uint256 collectionSize_
1071   ) {
1072     require(
1073       collectionSize_ > 0,
1074       "ERC721A: collection must have a nonzero supply"
1075     );
1076     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1077     _name = name_;
1078     _symbol = symbol_;
1079     maxBatchSize = maxBatchSize_;
1080     collectionSize = collectionSize_;
1081     currentIndex = _startTokenId();
1082   }
1083 
1084   /**
1085   * To change the starting tokenId, please override this function.
1086   */
1087   function _startTokenId() internal view virtual returns (uint256) {
1088     return 1;
1089   }
1090 
1091   /**
1092    * @dev See {IERC721Enumerable-totalSupply}.
1093    */
1094   function totalSupply() public view override returns (uint256) {
1095     return _totalMinted();
1096   }
1097 
1098   function currentTokenId() public view returns (uint256) {
1099     return _totalMinted();
1100   }
1101 
1102   function getNextTokenId() public view returns (uint256) {
1103       return SafeMath.add(_totalMinted(), 1);
1104   }
1105 
1106   /**
1107   * Returns the total amount of tokens minted in the contract.
1108   */
1109   function _totalMinted() internal view returns (uint256) {
1110     unchecked {
1111       return currentIndex - _startTokenId();
1112     }
1113   }
1114 
1115   /**
1116    * @dev See {IERC721Enumerable-tokenByIndex}.
1117    */
1118   function tokenByIndex(uint256 index) public view override returns (uint256) {
1119     require(index < totalSupply(), "ERC721A: global index out of bounds");
1120     return index;
1121   }
1122 
1123   /**
1124    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1125    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1126    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1127    */
1128   function tokenOfOwnerByIndex(address owner, uint256 index)
1129     public
1130     view
1131     override
1132     returns (uint256)
1133   {
1134     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1135     uint256 numMintedSoFar = totalSupply();
1136     uint256 tokenIdsIdx = 0;
1137     address currOwnershipAddr = address(0);
1138     for (uint256 i = 0; i < numMintedSoFar; i++) {
1139       TokenOwnership memory ownership = _ownerships[i];
1140       if (ownership.addr != address(0)) {
1141         currOwnershipAddr = ownership.addr;
1142       }
1143       if (currOwnershipAddr == owner) {
1144         if (tokenIdsIdx == index) {
1145           return i;
1146         }
1147         tokenIdsIdx++;
1148       }
1149     }
1150     revert("ERC721A: unable to get token of owner by index");
1151   }
1152 
1153   /**
1154    * @dev See {IERC165-supportsInterface}.
1155    */
1156   function supportsInterface(bytes4 interfaceId)
1157     public
1158     view
1159     virtual
1160     override(ERC165, IERC165)
1161     returns (bool)
1162   {
1163     return
1164       interfaceId == type(IERC721).interfaceId ||
1165       interfaceId == type(IERC721Metadata).interfaceId ||
1166       interfaceId == type(IERC721Enumerable).interfaceId ||
1167       super.supportsInterface(interfaceId);
1168   }
1169 
1170   /**
1171    * @dev See {IERC721-balanceOf}.
1172    */
1173   function balanceOf(address owner) public view override returns (uint256) {
1174     require(owner != address(0), "ERC721A: balance query for the zero address");
1175     return uint256(_addressData[owner].balance);
1176   }
1177 
1178   function _numberMinted(address owner) internal view returns (uint256) {
1179     require(
1180       owner != address(0),
1181       "ERC721A: number minted query for the zero address"
1182     );
1183     return uint256(_addressData[owner].numberMinted);
1184   }
1185 
1186   function ownershipOf(uint256 tokenId)
1187     internal
1188     view
1189     returns (TokenOwnership memory)
1190   {
1191     uint256 curr = tokenId;
1192 
1193     unchecked {
1194         if (_startTokenId() <= curr && curr < currentIndex) {
1195             TokenOwnership memory ownership = _ownerships[curr];
1196             if (ownership.addr != address(0)) {
1197                 return ownership;
1198             }
1199 
1200             // Invariant:
1201             // There will always be an ownership that has an address and is not burned
1202             // before an ownership that does not have an address and is not burned.
1203             // Hence, curr will not underflow.
1204             while (true) {
1205                 curr--;
1206                 ownership = _ownerships[curr];
1207                 if (ownership.addr != address(0)) {
1208                     return ownership;
1209                 }
1210             }
1211         }
1212     }
1213 
1214     revert("ERC721A: unable to determine the owner of token");
1215   }
1216 
1217   /**
1218    * @dev See {IERC721-ownerOf}.
1219    */
1220   function ownerOf(uint256 tokenId) public view override returns (address) {
1221     return ownershipOf(tokenId).addr;
1222   }
1223 
1224   /**
1225    * @dev See {IERC721Metadata-name}.
1226    */
1227   function name() public view virtual override returns (string memory) {
1228     return _name;
1229   }
1230 
1231   /**
1232    * @dev See {IERC721Metadata-symbol}.
1233    */
1234   function symbol() public view virtual override returns (string memory) {
1235     return _symbol;
1236   }
1237 
1238   /**
1239    * @dev See {IERC721Metadata-tokenURI}.
1240    */
1241   function tokenURI(uint256 tokenId)
1242     public
1243     view
1244     virtual
1245     override
1246     returns (string memory)
1247   {
1248     string memory baseURI = _baseURI();
1249     return
1250       bytes(baseURI).length > 0
1251         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1252         : "";
1253   }
1254 
1255   /**
1256    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1257    * token will be the concatenation of the baseURI and the tokenId. Empty
1258    * by default, can be overriden in child contracts.
1259    */
1260   function _baseURI() internal view virtual returns (string memory) {
1261     return "";
1262   }
1263 
1264   /**
1265    * @dev See {IERC721-approve}.
1266    */
1267   function approve(address to, uint256 tokenId) public override {
1268     address owner = ERC721A.ownerOf(tokenId);
1269     require(to != owner, "ERC721A: approval to current owner");
1270 
1271     require(
1272       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1273       "ERC721A: approve caller is not owner nor approved for all"
1274     );
1275 
1276     _approve(to, tokenId, owner);
1277   }
1278 
1279   /**
1280    * @dev See {IERC721-getApproved}.
1281    */
1282   function getApproved(uint256 tokenId) public view override returns (address) {
1283     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1284 
1285     return _tokenApprovals[tokenId];
1286   }
1287 
1288   /**
1289    * @dev See {IERC721-setApprovalForAll}.
1290    */
1291   function setApprovalForAll(address operator, bool approved) public override {
1292     require(operator != _msgSender(), "ERC721A: approve to caller");
1293 
1294     _operatorApprovals[_msgSender()][operator] = approved;
1295     emit ApprovalForAll(_msgSender(), operator, approved);
1296   }
1297 
1298   /**
1299    * @dev See {IERC721-isApprovedForAll}.
1300    */
1301   function isApprovedForAll(address owner, address operator)
1302     public
1303     view
1304     virtual
1305     override
1306     returns (bool)
1307   {
1308     return _operatorApprovals[owner][operator];
1309   }
1310 
1311   /**
1312    * @dev See {IERC721-transferFrom}.
1313    */
1314   function transferFrom(
1315     address from,
1316     address to,
1317     uint256 tokenId
1318   ) public override {
1319     _transfer(from, to, tokenId);
1320   }
1321 
1322   /**
1323    * @dev See {IERC721-safeTransferFrom}.
1324    */
1325   function safeTransferFrom(
1326     address from,
1327     address to,
1328     uint256 tokenId
1329   ) public override {
1330     safeTransferFrom(from, to, tokenId, "");
1331   }
1332 
1333   /**
1334    * @dev See {IERC721-safeTransferFrom}.
1335    */
1336   function safeTransferFrom(
1337     address from,
1338     address to,
1339     uint256 tokenId,
1340     bytes memory _data
1341   ) public override {
1342     _transfer(from, to, tokenId);
1343     require(
1344       _checkOnERC721Received(from, to, tokenId, _data),
1345       "ERC721A: transfer to non ERC721Receiver implementer"
1346     );
1347   }
1348 
1349   /**
1350    * @dev Returns whether tokenId exists.
1351    *
1352    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353    *
1354    * Tokens start existing when they are minted (_mint),
1355    */
1356   function _exists(uint256 tokenId) internal view returns (bool) {
1357     return _startTokenId() <= tokenId && tokenId < currentIndex;
1358   }
1359 
1360   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1361     _safeMint(to, quantity, isAdminMint, "");
1362   }
1363 
1364   /**
1365    * @dev Mints quantity tokens and transfers them to to.
1366    *
1367    * Requirements:
1368    *
1369    * - there must be quantity tokens remaining unminted in the total collection.
1370    * - to cannot be the zero address.
1371    * - quantity cannot be larger than the max batch size.
1372    *
1373    * Emits a {Transfer} event.
1374    */
1375   function _safeMint(
1376     address to,
1377     uint256 quantity,
1378     bool isAdminMint,
1379     bytes memory _data
1380   ) internal {
1381     uint256 startTokenId = currentIndex;
1382     require(to != address(0), "ERC721A: mint to the zero address");
1383     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1384     require(!_exists(startTokenId), "ERC721A: token already minted");
1385     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1386 
1387     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1388 
1389     AddressData memory addressData = _addressData[to];
1390     _addressData[to] = AddressData(
1391       addressData.balance + uint128(quantity),
1392       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1393     );
1394     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1395 
1396     uint256 updatedIndex = startTokenId;
1397 
1398     for (uint256 i = 0; i < quantity; i++) {
1399       emit Transfer(address(0), to, updatedIndex);
1400       require(
1401         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1402         "ERC721A: transfer to non ERC721Receiver implementer"
1403       );
1404       updatedIndex++;
1405     }
1406 
1407     currentIndex = updatedIndex;
1408     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1409   }
1410 
1411   /**
1412    * @dev Transfers tokenId from from to to.
1413    *
1414    * Requirements:
1415    *
1416    * - to cannot be the zero address.
1417    * - tokenId token must be owned by from.
1418    *
1419    * Emits a {Transfer} event.
1420    */
1421   function _transfer(
1422     address from,
1423     address to,
1424     uint256 tokenId
1425   ) private {
1426     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1427 
1428     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1429       getApproved(tokenId) == _msgSender() ||
1430       isApprovedForAll(prevOwnership.addr, _msgSender()));
1431 
1432     require(
1433       isApprovedOrOwner,
1434       "ERC721A: transfer caller is not owner nor approved"
1435     );
1436 
1437     require(
1438       prevOwnership.addr == from,
1439       "ERC721A: transfer from incorrect owner"
1440     );
1441     require(to != address(0), "ERC721A: transfer to the zero address");
1442 
1443     _beforeTokenTransfers(from, to, tokenId, 1);
1444 
1445     // Clear approvals from the previous owner
1446     _approve(address(0), tokenId, prevOwnership.addr);
1447 
1448     _addressData[from].balance -= 1;
1449     _addressData[to].balance += 1;
1450     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1451 
1452     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1453     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1454     uint256 nextTokenId = tokenId + 1;
1455     if (_ownerships[nextTokenId].addr == address(0)) {
1456       if (_exists(nextTokenId)) {
1457         _ownerships[nextTokenId] = TokenOwnership(
1458           prevOwnership.addr,
1459           prevOwnership.startTimestamp
1460         );
1461       }
1462     }
1463 
1464     emit Transfer(from, to, tokenId);
1465     _afterTokenTransfers(from, to, tokenId, 1);
1466   }
1467 
1468   /**
1469    * @dev Approve to to operate on tokenId
1470    *
1471    * Emits a {Approval} event.
1472    */
1473   function _approve(
1474     address to,
1475     uint256 tokenId,
1476     address owner
1477   ) private {
1478     _tokenApprovals[tokenId] = to;
1479     emit Approval(owner, to, tokenId);
1480   }
1481 
1482   uint256 public nextOwnerToExplicitlySet = 0;
1483 
1484   /**
1485    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1486    */
1487   function _setOwnersExplicit(uint256 quantity) internal {
1488     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1489     require(quantity > 0, "quantity must be nonzero");
1490     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1491 
1492     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1493     if (endIndex > collectionSize - 1) {
1494       endIndex = collectionSize - 1;
1495     }
1496     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1497     require(_exists(endIndex), "not enough minted yet for this cleanup");
1498     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1499       if (_ownerships[i].addr == address(0)) {
1500         TokenOwnership memory ownership = ownershipOf(i);
1501         _ownerships[i] = TokenOwnership(
1502           ownership.addr,
1503           ownership.startTimestamp
1504         );
1505       }
1506     }
1507     nextOwnerToExplicitlySet = endIndex + 1;
1508   }
1509 
1510   /**
1511    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1512    * The call is not executed if the target address is not a contract.
1513    *
1514    * @param from address representing the previous owner of the given token ID
1515    * @param to target address that will receive the tokens
1516    * @param tokenId uint256 ID of the token to be transferred
1517    * @param _data bytes optional data to send along with the call
1518    * @return bool whether the call correctly returned the expected magic value
1519    */
1520   function _checkOnERC721Received(
1521     address from,
1522     address to,
1523     uint256 tokenId,
1524     bytes memory _data
1525   ) private returns (bool) {
1526     if (to.isContract()) {
1527       try
1528         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1529       returns (bytes4 retval) {
1530         return retval == IERC721Receiver(to).onERC721Received.selector;
1531       } catch (bytes memory reason) {
1532         if (reason.length == 0) {
1533           revert("ERC721A: transfer to non ERC721Receiver implementer");
1534         } else {
1535           assembly {
1536             revert(add(32, reason), mload(reason))
1537           }
1538         }
1539       }
1540     } else {
1541       return true;
1542     }
1543   }
1544 
1545   /**
1546    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1547    *
1548    * startTokenId - the first token id to be transferred
1549    * quantity - the amount to be transferred
1550    *
1551    * Calling conditions:
1552    *
1553    * - When from and to are both non-zero, from's tokenId will be
1554    * transferred to to.
1555    * - When from is zero, tokenId will be minted for to.
1556    */
1557   function _beforeTokenTransfers(
1558     address from,
1559     address to,
1560     uint256 startTokenId,
1561     uint256 quantity
1562   ) internal virtual {}
1563 
1564   /**
1565    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1566    * minting.
1567    *
1568    * startTokenId - the first token id to be transferred
1569    * quantity - the amount to be transferred
1570    *
1571    * Calling conditions:
1572    *
1573    * - when from and to are both non-zero.
1574    * - from and to are never both zero.
1575    */
1576   function _afterTokenTransfers(
1577     address from,
1578     address to,
1579     uint256 startTokenId,
1580     uint256 quantity
1581   ) internal virtual {}
1582 }
1583 
1584 
1585 
1586   
1587 abstract contract Ramppable {
1588   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1589 
1590   modifier isRampp() {
1591       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1592       _;
1593   }
1594 }
1595 
1596 
1597   
1598   
1599 interface IERC20 {
1600   function transfer(address _to, uint256 _amount) external returns (bool);
1601   function balanceOf(address account) external view returns (uint256);
1602 }
1603 
1604 abstract contract Withdrawable is Ownable, Ramppable {
1605   address[] public payableAddresses = [RAMPPADDRESS,0xF67D6Fdc4FA83ef88DA0D1b5f04f5c1b55BC358B];
1606   uint256[] public payableFees = [5,95];
1607   uint256 public payableAddressCount = 2;
1608 
1609   function withdrawAll() public onlyOwner {
1610       require(address(this).balance > 0);
1611       _withdrawAll();
1612   }
1613   
1614   function withdrawAllRampp() public isRampp {
1615       require(address(this).balance > 0);
1616       _withdrawAll();
1617   }
1618 
1619   function _withdrawAll() private {
1620       uint256 balance = address(this).balance;
1621       
1622       for(uint i=0; i < payableAddressCount; i++ ) {
1623           _widthdraw(
1624               payableAddresses[i],
1625               (balance * payableFees[i]) / 100
1626           );
1627       }
1628   }
1629   
1630   function _widthdraw(address _address, uint256 _amount) private {
1631       (bool success, ) = _address.call{value: _amount}("");
1632       require(success, "Transfer failed.");
1633   }
1634 
1635   /**
1636     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1637     * while still splitting royalty payments to all other team members.
1638     * in the event ERC-20 tokens are paid to the contract.
1639     * @param _tokenContract contract of ERC-20 token to withdraw
1640     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1641     */
1642   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1643     require(_amount > 0);
1644     IERC20 tokenContract = IERC20(_tokenContract);
1645     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1646 
1647     for(uint i=0; i < payableAddressCount; i++ ) {
1648         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1649     }
1650   }
1651 
1652   /**
1653   * @dev Allows Rampp wallet to update its own reference as well as update
1654   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1655   * and since Rampp is always the first address this function is limited to the rampp payout only.
1656   * @param _newAddress updated Rampp Address
1657   */
1658   function setRamppAddress(address _newAddress) public isRampp {
1659     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1660     RAMPPADDRESS = _newAddress;
1661     payableAddresses[0] = _newAddress;
1662   }
1663 }
1664 
1665 
1666   
1667 abstract contract RamppERC721A is 
1668     Ownable,
1669     ERC721A,
1670     Withdrawable,
1671     ReentrancyGuard   {
1672     constructor(
1673         string memory tokenName,
1674         string memory tokenSymbol
1675     ) ERC721A(tokenName, tokenSymbol, 7, 6900 ) {}
1676     using SafeMath for uint256;
1677     uint8 public CONTRACT_VERSION = 2;
1678     string public _baseTokenURI = "ipfs://QmQ557AF9kv8Yzm3nxNU9Df5x6zUeNSHE8Ho8p2kLgB55o/";
1679 
1680     bool public mintingOpen = false;
1681     
1682     uint256 public PRICE = 0.003 ether;
1683     
1684     uint256 public MAX_WALLET_MINTS = 3;
1685 
1686     
1687     /////////////// Admin Mint Functions
1688     /**
1689     * @dev Mints a token to an address with a tokenURI.
1690     * This is owner only and allows a fee-free drop
1691     * @param _to address of the future owner of the token
1692     */
1693     function mintToAdmin(address _to) public onlyOwner {
1694         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6900");
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
1712         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6900");
1713         require(mintingOpen == true, "Minting is not open right now!");
1714         
1715         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1716         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1717         
1718         _safeMint(_to, 1, false);
1719     }
1720 
1721     /**
1722     * @dev Mints a token to an address with a tokenURI.
1723     * fee may or may not be required*
1724     * @param _to address of the future owner of the token
1725     * @param _amount number of tokens to mint
1726     */
1727     function mintToMultiple(address _to, uint256 _amount) public payable {
1728         require(_amount >= 1, "Must mint at least 1 token");
1729         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1730         require(mintingOpen == true, "Minting is not open right now!");
1731         
1732         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1733         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6900");
1734         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1735 
1736         _safeMint(_to, _amount, false);
1737     }
1738 
1739     function openMinting() public onlyOwner {
1740         mintingOpen = true;
1741     }
1742 
1743     function stopMinting() public onlyOwner {
1744         mintingOpen = false;
1745     }
1746 
1747     
1748 
1749     
1750     /**
1751     * @dev Check if wallet over MAX_WALLET_MINTS
1752     * @param _address address in question to check if minted count exceeds max
1753     */
1754     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1755         require(_amount >= 1, "Amount must be greater than or equal to 1");
1756         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1757     }
1758 
1759     /**
1760     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1761     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1762     */
1763     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1764         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1765         MAX_WALLET_MINTS = _newWalletMax;
1766     }
1767     
1768 
1769     
1770     /**
1771      * @dev Allows owner to set Max mints per tx
1772      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1773      */
1774      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1775          require(_newMaxMint >= 1, "Max mint must be at least 1");
1776          maxBatchSize = _newMaxMint;
1777      }
1778     
1779 
1780     
1781     function setPrice(uint256 _feeInWei) public onlyOwner {
1782         PRICE = _feeInWei;
1783     }
1784 
1785     function getPrice(uint256 _count) private view returns (uint256) {
1786         return PRICE.mul(_count);
1787     }
1788 
1789     
1790     
1791     function _baseURI() internal view virtual override returns (string memory) {
1792         return _baseTokenURI;
1793     }
1794 
1795     function baseTokenURI() public view returns (string memory) {
1796         return _baseTokenURI;
1797     }
1798 
1799     function setBaseURI(string calldata baseURI) external onlyOwner {
1800         _baseTokenURI = baseURI;
1801     }
1802 
1803     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1804         return ownershipOf(tokenId);
1805     }
1806 }
1807 
1808 
1809   
1810 // File: contracts/HobbittownwtfContract.sol
1811 //SPDX-License-Identifier: MIT
1812 
1813 pragma solidity ^0.8.0;
1814 
1815 contract HobbittownwtfContract is RamppERC721A {
1816     constructor() RamppERC721A("hobbittownwtf ", "HOBBIT"){}
1817 
1818     function contractURI() public pure returns (string memory) {
1819       return "https://us-central1-nft-rampp.cloudfunctions.net/app/DaJC3CseN4J3OVOSNTYw/contract-metadata";
1820     }
1821 }
1822   
1823 //*********************************************************************//
1824 //*********************************************************************//  
1825 //                       Rampp v2.0.1
1826 //
1827 //         This smart contract was generated by rampp.xyz.
1828 //            Rampp allows creators like you to launch 
1829 //             large scale NFT communities without code!
1830 //
1831 //    Rampp is not responsible for the content of this contract and
1832 //        hopes it is being used in a responsible and kind way.  
1833 //       Rampp is not associated or affiliated with this project.                                                    
1834 //             Twitter: @Rampp_ ---- rampp.xyz
1835 //*********************************************************************//                                                     
1836 //*********************************************************************// 
