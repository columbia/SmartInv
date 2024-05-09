1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // __/\\\\\\\\\\\\\\\__/\\\______________________________________/\\\\\\\\\\\\______________________/\\\\\\___________________/\\\____________/\\\\\____________/\\\\\___/\\\\\\\\\\\\\\\_         
5 //  _\///////\\\/////__\/\\\____________________________________/\\\//////////______________________\////\\\_______________/\\\\\\\________/\\\\////_________/\\\\////___\/\\\///////////__        
6 //   _______\/\\\_______\/\\\___________________________________/\\\______________/\\\__________________\/\\\______________\/////\\\_____/\\\///___________/\\\///________\/\\\_____________       
7 //    _______\/\\\_______\/\\\_____________/\\\\\\\\____________\/\\\____/\\\\\\\_\///___/\\/\\\\\\\_____\/\\\__________________\/\\\___/\\\\\\\\\\\______/\\\\\\\\\\\_____\/\\\\\\\\\\\\_____     
8 //     _______\/\\\_______\/\\\\\\\\\\____/\\\/////\\\___________\/\\\___\/////\\\__/\\\_\/\\\/////\\\____\/\\\__________________\/\\\__/\\\\///////\\\___/\\\\///////\\\___\////////////\\\___    
9 //      _______\/\\\_______\/\\\/////\\\__/\\\\\\\\\\\____________\/\\\_______\/\\\_\/\\\_\/\\\___\///_____\/\\\__________________\/\\\_\/\\\______\//\\\_\/\\\______\//\\\_____________\//\\\__   
10 //       _______\/\\\_______\/\\\___\/\\\_\//\\///////_____________\/\\\_______\/\\\_\/\\\_\/\\\____________\/\\\__________________\/\\\_\//\\\______/\\\__\//\\\______/\\\___/\\\________\/\\\__  
11 //        _______\/\\\_______\/\\\___\/\\\__\//\\\\\\\\\\___________\//\\\\\\\\\\\\/__\/\\\_\/\\\__________/\\\\\\\\\_______________\/\\\__\///\\\\\\\\\/____\///\\\\\\\\\/___\//\\\\\\\\\\\\\/___ 
12 //         _______\///________\///____\///____\//////////_____________\////////////____\///__\///__________\/////////________________\///_____\/////////________\/////////______\/////////////_____
13 //
14 //*********************************************************************//
15 //*********************************************************************//
16   
17 //-------------DEPENDENCIES--------------------------//
18 
19 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
20 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 // CAUTION
25 // This version of SafeMath should only be used with Solidity 0.8 or later,
26 // because it relies on the compiler's built in overflow checks.
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations.
30  *
31  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
32  * now has built in overflow checking.
33  */
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             uint256 c = a + b;
43             if (c < a) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     /**
49      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             if (b > a) return (false, 0);
56             return (true, a - b);
57         }
58     }
59 
60     /**
61      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68             // benefit is lost if 'b' is also tested.
69             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70             if (a == 0) return (true, 0);
71             uint256 c = a * b;
72             if (c / a != b) return (false, 0);
73             return (true, c);
74         }
75     }
76 
77     /**
78      * @dev Returns the division of two unsigned integers, with a division by zero flag.
79      *
80      * _Available since v3.4._
81      */
82     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a / b);
86         }
87     }
88 
89     /**
90      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a % b);
98         }
99     }
100 
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's + operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a + b;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's - operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a - b;
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's * operator.
134      *
135      * Requirements:
136      *
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a * b;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers, reverting on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's / operator.
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a / b;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * reverting when dividing by zero.
160      *
161      * Counterpart to Solidity's % operator. This function uses a revert
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a % b;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * CAUTION: This function is deprecated because it requires allocating memory for the error
178      * message unnecessarily. For custom revert reasons use {trySub}.
179      *
180      * Counterpart to Solidity's - operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         unchecked {
192             require(b <= a, errorMessage);
193             return a - b;
194         }
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's / operator. Note: this function uses a
202      * revert opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(
210         uint256 a,
211         uint256 b,
212         string memory errorMessage
213     ) internal pure returns (uint256) {
214         unchecked {
215             require(b > 0, errorMessage);
216             return a / b;
217         }
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * reverting with custom message when dividing by zero.
223      *
224      * CAUTION: This function is deprecated because it requires allocating memory for the error
225      * message unnecessarily. For custom revert reasons use {tryMod}.
226      *
227      * Counterpart to Solidity's % operator. This function uses a revert
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(
236         uint256 a,
237         uint256 b,
238         string memory errorMessage
239     ) internal pure returns (uint256) {
240         unchecked {
241             require(b > 0, errorMessage);
242             return a % b;
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 
250 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
251 
252 pragma solidity ^0.8.1;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if account is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, isContract will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      *
275      * [IMPORTANT]
276      * ====
277      * You shouldn't rely on isContract to protect against flash loan attacks!
278      *
279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
281      * constructor.
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize/address.code.length, which returns 0
286         // for contracts in construction, since the code is only stored at the end
287         // of the constructor execution.
288 
289         return account.code.length > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's transfer: sends amount wei to
294      * recipient, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by transfer, making them unable to receive funds via
299      * transfer. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to recipient, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         (bool success, ) = recipient.call{value: amount}("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level call. A
317      * plain call is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If target reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
325      *
326      * Requirements:
327      *
328      * - target must be a contract.
329      * - calling target with data must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
339      * errorMessage as a fallback revert reason when target reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
353      * but also transferring value wei to target.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least value.
358      * - the called Solidity function must be payable.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
372      * with errorMessage as a fallback revert reason when target reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         require(isContract(target), "Address: call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.call{value: value}(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
396         return functionStaticCall(target, data, "Address: low-level static call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.staticcall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
423         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(isContract(target), "Address: delegate call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.delegatecall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
445      * revert reason using the provided one.
446      *
447      * _Available since v4.3._
448      */
449     function verifyCallResult(
450         bool success,
451         bytes memory returndata,
452         string memory errorMessage
453     ) internal pure returns (bytes memory) {
454         if (success) {
455             return returndata;
456         } else {
457             // Look for revert reason and bubble it up if present
458             if (returndata.length > 0) {
459                 // The easiest way to bubble the revert reason is using memory via assembly
460 
461                 assembly {
462                     let returndata_size := mload(returndata)
463                     revert(add(32, returndata), returndata_size)
464                 }
465             } else {
466                 revert(errorMessage);
467             }
468         }
469     }
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @title ERC721 token receiver interface
481  * @dev Interface for any contract that wants to support safeTransfers
482  * from ERC721 asset contracts.
483  */
484 interface IERC721Receiver {
485     /**
486      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
487      * by operator from from, this function is called.
488      *
489      * It must return its Solidity selector to confirm the token transfer.
490      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
491      *
492      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
493      */
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev Interface of the ERC165 standard, as defined in the
511  * https://eips.ethereum.org/EIPS/eip-165[EIP].
512  *
513  * Implementers can declare support of contract interfaces, which can then be
514  * queried by others ({ERC165Checker}).
515  *
516  * For an implementation, see {ERC165}.
517  */
518 interface IERC165 {
519     /**
520      * @dev Returns true if this contract implements the interface defined by
521      * interfaceId. See the corresponding
522      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
523      * to learn more about how these ids are created.
524      *
525      * This function call must use less than 30 000 gas.
526      */
527     function supportsInterface(bytes4 interfaceId) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * 
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Required interface of an ERC721 compliant contract.
571  */
572 interface IERC721 is IERC165 {
573     /**
574      * @dev Emitted when tokenId token is transferred from from to to.
575      */
576     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when owner enables approved to manage the tokenId token.
580      */
581     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
585      */
586     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
587 
588     /**
589      * @dev Returns the number of tokens in owner's account.
590      */
591     function balanceOf(address owner) external view returns (uint256 balance);
592 
593     /**
594      * @dev Returns the owner of the tokenId token.
595      *
596      * Requirements:
597      *
598      * - tokenId must exist.
599      */
600     function ownerOf(uint256 tokenId) external view returns (address owner);
601 
602     /**
603      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
604      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
605      *
606      * Requirements:
607      *
608      * - from cannot be the zero address.
609      * - to cannot be the zero address.
610      * - tokenId token must exist and be owned by from.
611      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
612      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Transfers tokenId token from from to to.
624      *
625      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
626      *
627      * Requirements:
628      *
629      * - from cannot be the zero address.
630      * - to cannot be the zero address.
631      * - tokenId token must be owned by from.
632      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      *
634      * Emits a {Transfer} event.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external;
641 
642     /**
643      * @dev Gives permission to to to transfer tokenId token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - tokenId must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Returns the account approved for tokenId token.
659      *
660      * Requirements:
661      *
662      * - tokenId must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Approve or remove operator as an operator for the caller.
668      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
669      *
670      * Requirements:
671      *
672      * - The operator cannot be the caller.
673      *
674      * Emits an {ApprovalForAll} event.
675      */
676     function setApprovalForAll(address operator, bool _approved) external;
677 
678     /**
679      * @dev Returns if the operator is allowed to manage all of the assets of owner.
680      *
681      * See {setApprovalForAll}
682      */
683     function isApprovedForAll(address owner, address operator) external view returns (bool);
684 
685     /**
686      * @dev Safely transfers tokenId token from from to to.
687      *
688      * Requirements:
689      *
690      * - from cannot be the zero address.
691      * - to cannot be the zero address.
692      * - tokenId token must exist and be owned by from.
693      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
694      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes calldata data
703     ) external;
704 }
705 
706 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
707 
708 
709 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
716  * @dev See https://eips.ethereum.org/EIPS/eip-721
717  */
718 interface IERC721Enumerable is IERC721 {
719     /**
720      * @dev Returns the total amount of tokens stored by the contract.
721      */
722     function totalSupply() external view returns (uint256);
723 
724     /**
725      * @dev Returns a token ID owned by owner at a given index of its token list.
726      * Use along with {balanceOf} to enumerate all of owner's tokens.
727      */
728     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
729 
730     /**
731      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
732      * Use along with {totalSupply} to enumerate all tokens.
733      */
734     function tokenByIndex(uint256 index) external view returns (uint256);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
747  * @dev See https://eips.ethereum.org/EIPS/eip-721
748  */
749 interface IERC721Metadata is IERC721 {
750     /**
751      * @dev Returns the token collection name.
752      */
753     function name() external view returns (string memory);
754 
755     /**
756      * @dev Returns the token collection symbol.
757      */
758     function symbol() external view returns (string memory);
759 
760     /**
761      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
762      */
763     function tokenURI(uint256 tokenId) external view returns (string memory);
764 }
765 
766 // File: @openzeppelin/contracts/utils/Strings.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @dev String operations.
775  */
776 library Strings {
777     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
778 
779     /**
780      * @dev Converts a uint256 to its ASCII string decimal representation.
781      */
782     function toString(uint256 value) internal pure returns (string memory) {
783         // Inspired by OraclizeAPI's implementation - MIT licence
784         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
785 
786         if (value == 0) {
787             return "0";
788         }
789         uint256 temp = value;
790         uint256 digits;
791         while (temp != 0) {
792             digits++;
793             temp /= 10;
794         }
795         bytes memory buffer = new bytes(digits);
796         while (value != 0) {
797             digits -= 1;
798             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
799             value /= 10;
800         }
801         return string(buffer);
802     }
803 
804     /**
805      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
806      */
807     function toHexString(uint256 value) internal pure returns (string memory) {
808         if (value == 0) {
809             return "0x00";
810         }
811         uint256 temp = value;
812         uint256 length = 0;
813         while (temp != 0) {
814             length++;
815             temp >>= 8;
816         }
817         return toHexString(value, length);
818     }
819 
820     /**
821      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
822      */
823     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
824         bytes memory buffer = new bytes(2 * length + 2);
825         buffer[0] = "0";
826         buffer[1] = "x";
827         for (uint256 i = 2 * length + 1; i > 1; --i) {
828             buffer[i] = _HEX_SYMBOLS[value & 0xf];
829             value >>= 4;
830         }
831         require(value == 0, "Strings: hex length insufficient");
832         return string(buffer);
833     }
834 }
835 
836 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
837 
838 
839 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
840 
841 pragma solidity ^0.8.0;
842 
843 /**
844  * @dev Contract module that helps prevent reentrant calls to a function.
845  *
846  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
847  * available, which can be applied to functions to make sure there are no nested
848  * (reentrant) calls to them.
849  *
850  * Note that because there is a single nonReentrant guard, functions marked as
851  * nonReentrant may not call one another. This can be worked around by making
852  * those functions private, and then adding external nonReentrant entry
853  * points to them.
854  *
855  * TIP: If you would like to learn more about reentrancy and alternative ways
856  * to protect against it, check out our blog post
857  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
858  */
859 abstract contract ReentrancyGuard {
860     // Booleans are more expensive than uint256 or any type that takes up a full
861     // word because each write operation emits an extra SLOAD to first read the
862     // slot's contents, replace the bits taken up by the boolean, and then write
863     // back. This is the compiler's defense against contract upgrades and
864     // pointer aliasing, and it cannot be disabled.
865 
866     // The values being non-zero value makes deployment a bit more expensive,
867     // but in exchange the refund on every call to nonReentrant will be lower in
868     // amount. Since refunds are capped to a percentage of the total
869     // transaction's gas, it is best to keep them low in cases like this one, to
870     // increase the likelihood of the full refund coming into effect.
871     uint256 private constant _NOT_ENTERED = 1;
872     uint256 private constant _ENTERED = 2;
873 
874     uint256 private _status;
875 
876     constructor() {
877         _status = _NOT_ENTERED;
878     }
879 
880     /**
881      * @dev Prevents a contract from calling itself, directly or indirectly.
882      * Calling a nonReentrant function from another nonReentrant
883      * function is not supported. It is possible to prevent this from happening
884      * by making the nonReentrant function external, and making it call a
885      * private function that does the actual work.
886      */
887     modifier nonReentrant() {
888         // On the first call to nonReentrant, _notEntered will be true
889         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
890 
891         // Any calls to nonReentrant after this point will fail
892         _status = _ENTERED;
893 
894         _;
895 
896         // By storing the original value once again, a refund is triggered (see
897         // https://eips.ethereum.org/EIPS/eip-2200)
898         _status = _NOT_ENTERED;
899     }
900 }
901 
902 // File: @openzeppelin/contracts/utils/Context.sol
903 
904 
905 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @dev Provides information about the current execution context, including the
911  * sender of the transaction and its data. While these are generally available
912  * via msg.sender and msg.data, they should not be accessed in such a direct
913  * manner, since when dealing with meta-transactions the account sending and
914  * paying for execution may not be the actual sender (as far as an application
915  * is concerned).
916  *
917  * This contract is only required for intermediate, library-like contracts.
918  */
919 abstract contract Context {
920     function _msgSender() internal view virtual returns (address) {
921         return msg.sender;
922     }
923 
924     function _msgData() internal view virtual returns (bytes calldata) {
925         return msg.data;
926     }
927 }
928 
929 // File: @openzeppelin/contracts/access/Ownable.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 /**
938  * @dev Contract module which provides a basic access control mechanism, where
939  * there is an account (an owner) that can be granted exclusive access to
940  * specific functions.
941  *
942  * By default, the owner account will be the one that deploys the contract. This
943  * can later be changed with {transferOwnership}.
944  *
945  * This module is used through inheritance. It will make available the modifier
946  * onlyOwner, which can be applied to your functions to restrict their use to
947  * the owner.
948  */
949 abstract contract Ownable is Context {
950     address private _owner;
951 
952     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
953 
954     /**
955      * @dev Initializes the contract setting the deployer as the initial owner.
956      */
957     constructor() {
958         _transferOwnership(_msgSender());
959     }
960 
961     /**
962      * @dev Returns the address of the current owner.
963      */
964     function owner() public view virtual returns (address) {
965         return _owner;
966     }
967 
968     /**
969      * @dev Throws if called by any account other than the owner.
970      */
971     modifier onlyOwner() {
972         require(owner() == _msgSender(), "Ownable: caller is not the owner");
973         _;
974     }
975 
976     /**
977      * @dev Leaves the contract without owner. It will not be possible to call
978      * onlyOwner functions anymore. Can only be called by the current owner.
979      *
980      * NOTE: Renouncing ownership will leave the contract without an owner,
981      * thereby removing any functionality that is only available to the owner.
982      */
983     function renounceOwnership() public virtual onlyOwner {
984         _transferOwnership(address(0));
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (newOwner).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public virtual onlyOwner {
992         require(newOwner != address(0), "Ownable: new owner is the zero address");
993         _transferOwnership(newOwner);
994     }
995 
996     /**
997      * @dev Transfers ownership of the contract to a new account (newOwner).
998      * Internal function without access restriction.
999      */
1000     function _transferOwnership(address newOwner) internal virtual {
1001         address oldOwner = _owner;
1002         _owner = newOwner;
1003         emit OwnershipTransferred(oldOwner, newOwner);
1004     }
1005 }
1006 //-------------END DEPENDENCIES------------------------//
1007 
1008 
1009   
1010   
1011 /**
1012  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1013  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1014  *
1015  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1016  * 
1017  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1018  *
1019  * Does not support burning tokens to address(0).
1020  */
1021 contract ERC721A is
1022   Context,
1023   ERC165,
1024   IERC721,
1025   IERC721Metadata,
1026   IERC721Enumerable
1027 {
1028   using Address for address;
1029   using Strings for uint256;
1030 
1031   struct TokenOwnership {
1032     address addr;
1033     uint64 startTimestamp;
1034   }
1035 
1036   struct AddressData {
1037     uint128 balance;
1038     uint128 numberMinted;
1039   }
1040 
1041   uint256 private currentIndex;
1042 
1043   uint256 public immutable collectionSize;
1044   uint256 public maxBatchSize;
1045 
1046   // Token name
1047   string private _name;
1048 
1049   // Token symbol
1050   string private _symbol;
1051 
1052   // Mapping from token ID to ownership details
1053   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1054   mapping(uint256 => TokenOwnership) private _ownerships;
1055 
1056   // Mapping owner address to address data
1057   mapping(address => AddressData) private _addressData;
1058 
1059   // Mapping from token ID to approved address
1060   mapping(uint256 => address) private _tokenApprovals;
1061 
1062   // Mapping from owner to operator approvals
1063   mapping(address => mapping(address => bool)) private _operatorApprovals;
1064 
1065   /**
1066    * @dev
1067    * maxBatchSize refers to how much a minter can mint at a time.
1068    * collectionSize_ refers to how many tokens are in the collection.
1069    */
1070   constructor(
1071     string memory name_,
1072     string memory symbol_,
1073     uint256 maxBatchSize_,
1074     uint256 collectionSize_
1075   ) {
1076     require(
1077       collectionSize_ > 0,
1078       "ERC721A: collection must have a nonzero supply"
1079     );
1080     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1081     _name = name_;
1082     _symbol = symbol_;
1083     maxBatchSize = maxBatchSize_;
1084     collectionSize = collectionSize_;
1085     currentIndex = _startTokenId();
1086   }
1087 
1088   /**
1089   * To change the starting tokenId, please override this function.
1090   */
1091   function _startTokenId() internal view virtual returns (uint256) {
1092     return 1;
1093   }
1094 
1095   /**
1096    * @dev See {IERC721Enumerable-totalSupply}.
1097    */
1098   function totalSupply() public view override returns (uint256) {
1099     return _totalMinted();
1100   }
1101 
1102   function currentTokenId() public view returns (uint256) {
1103     return _totalMinted();
1104   }
1105 
1106   function getNextTokenId() public view returns (uint256) {
1107       return SafeMath.add(_totalMinted(), 1);
1108   }
1109 
1110   /**
1111   * Returns the total amount of tokens minted in the contract.
1112   */
1113   function _totalMinted() internal view returns (uint256) {
1114     unchecked {
1115       return currentIndex - _startTokenId();
1116     }
1117   }
1118 
1119   /**
1120    * @dev See {IERC721Enumerable-tokenByIndex}.
1121    */
1122   function tokenByIndex(uint256 index) public view override returns (uint256) {
1123     require(index < totalSupply(), "ERC721A: global index out of bounds");
1124     return index;
1125   }
1126 
1127   /**
1128    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1129    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1130    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1131    */
1132   function tokenOfOwnerByIndex(address owner, uint256 index)
1133     public
1134     view
1135     override
1136     returns (uint256)
1137   {
1138     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1139     uint256 numMintedSoFar = totalSupply();
1140     uint256 tokenIdsIdx = 0;
1141     address currOwnershipAddr = address(0);
1142     for (uint256 i = 0; i < numMintedSoFar; i++) {
1143       TokenOwnership memory ownership = _ownerships[i];
1144       if (ownership.addr != address(0)) {
1145         currOwnershipAddr = ownership.addr;
1146       }
1147       if (currOwnershipAddr == owner) {
1148         if (tokenIdsIdx == index) {
1149           return i;
1150         }
1151         tokenIdsIdx++;
1152       }
1153     }
1154     revert("ERC721A: unable to get token of owner by index");
1155   }
1156 
1157   /**
1158    * @dev See {IERC165-supportsInterface}.
1159    */
1160   function supportsInterface(bytes4 interfaceId)
1161     public
1162     view
1163     virtual
1164     override(ERC165, IERC165)
1165     returns (bool)
1166   {
1167     return
1168       interfaceId == type(IERC721).interfaceId ||
1169       interfaceId == type(IERC721Metadata).interfaceId ||
1170       interfaceId == type(IERC721Enumerable).interfaceId ||
1171       super.supportsInterface(interfaceId);
1172   }
1173 
1174   /**
1175    * @dev See {IERC721-balanceOf}.
1176    */
1177   function balanceOf(address owner) public view override returns (uint256) {
1178     require(owner != address(0), "ERC721A: balance query for the zero address");
1179     return uint256(_addressData[owner].balance);
1180   }
1181 
1182   function _numberMinted(address owner) internal view returns (uint256) {
1183     require(
1184       owner != address(0),
1185       "ERC721A: number minted query for the zero address"
1186     );
1187     return uint256(_addressData[owner].numberMinted);
1188   }
1189 
1190   function ownershipOf(uint256 tokenId)
1191     internal
1192     view
1193     returns (TokenOwnership memory)
1194   {
1195     uint256 curr = tokenId;
1196 
1197     unchecked {
1198         if (_startTokenId() <= curr && curr < currentIndex) {
1199             TokenOwnership memory ownership = _ownerships[curr];
1200             if (ownership.addr != address(0)) {
1201                 return ownership;
1202             }
1203 
1204             // Invariant:
1205             // There will always be an ownership that has an address and is not burned
1206             // before an ownership that does not have an address and is not burned.
1207             // Hence, curr will not underflow.
1208             while (true) {
1209                 curr--;
1210                 ownership = _ownerships[curr];
1211                 if (ownership.addr != address(0)) {
1212                     return ownership;
1213                 }
1214             }
1215         }
1216     }
1217 
1218     revert("ERC721A: unable to determine the owner of token");
1219   }
1220 
1221   /**
1222    * @dev See {IERC721-ownerOf}.
1223    */
1224   function ownerOf(uint256 tokenId) public view override returns (address) {
1225     return ownershipOf(tokenId).addr;
1226   }
1227 
1228   /**
1229    * @dev See {IERC721Metadata-name}.
1230    */
1231   function name() public view virtual override returns (string memory) {
1232     return _name;
1233   }
1234 
1235   /**
1236    * @dev See {IERC721Metadata-symbol}.
1237    */
1238   function symbol() public view virtual override returns (string memory) {
1239     return _symbol;
1240   }
1241 
1242   /**
1243    * @dev See {IERC721Metadata-tokenURI}.
1244    */
1245   function tokenURI(uint256 tokenId)
1246     public
1247     view
1248     virtual
1249     override
1250     returns (string memory)
1251   {
1252     string memory baseURI = _baseURI();
1253     return
1254       bytes(baseURI).length > 0
1255         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1256         : "";
1257   }
1258 
1259   /**
1260    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1261    * token will be the concatenation of the baseURI and the tokenId. Empty
1262    * by default, can be overriden in child contracts.
1263    */
1264   function _baseURI() internal view virtual returns (string memory) {
1265     return "";
1266   }
1267 
1268   /**
1269    * @dev See {IERC721-approve}.
1270    */
1271   function approve(address to, uint256 tokenId) public override {
1272     address owner = ERC721A.ownerOf(tokenId);
1273     require(to != owner, "ERC721A: approval to current owner");
1274 
1275     require(
1276       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1277       "ERC721A: approve caller is not owner nor approved for all"
1278     );
1279 
1280     _approve(to, tokenId, owner);
1281   }
1282 
1283   /**
1284    * @dev See {IERC721-getApproved}.
1285    */
1286   function getApproved(uint256 tokenId) public view override returns (address) {
1287     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1288 
1289     return _tokenApprovals[tokenId];
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-setApprovalForAll}.
1294    */
1295   function setApprovalForAll(address operator, bool approved) public override {
1296     require(operator != _msgSender(), "ERC721A: approve to caller");
1297 
1298     _operatorApprovals[_msgSender()][operator] = approved;
1299     emit ApprovalForAll(_msgSender(), operator, approved);
1300   }
1301 
1302   /**
1303    * @dev See {IERC721-isApprovedForAll}.
1304    */
1305   function isApprovedForAll(address owner, address operator)
1306     public
1307     view
1308     virtual
1309     override
1310     returns (bool)
1311   {
1312     return _operatorApprovals[owner][operator];
1313   }
1314 
1315   /**
1316    * @dev See {IERC721-transferFrom}.
1317    */
1318   function transferFrom(
1319     address from,
1320     address to,
1321     uint256 tokenId
1322   ) public override {
1323     _transfer(from, to, tokenId);
1324   }
1325 
1326   /**
1327    * @dev See {IERC721-safeTransferFrom}.
1328    */
1329   function safeTransferFrom(
1330     address from,
1331     address to,
1332     uint256 tokenId
1333   ) public override {
1334     safeTransferFrom(from, to, tokenId, "");
1335   }
1336 
1337   /**
1338    * @dev See {IERC721-safeTransferFrom}.
1339    */
1340   function safeTransferFrom(
1341     address from,
1342     address to,
1343     uint256 tokenId,
1344     bytes memory _data
1345   ) public override {
1346     _transfer(from, to, tokenId);
1347     require(
1348       _checkOnERC721Received(from, to, tokenId, _data),
1349       "ERC721A: transfer to non ERC721Receiver implementer"
1350     );
1351   }
1352 
1353   /**
1354    * @dev Returns whether tokenId exists.
1355    *
1356    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1357    *
1358    * Tokens start existing when they are minted (_mint),
1359    */
1360   function _exists(uint256 tokenId) internal view returns (bool) {
1361     return _startTokenId() <= tokenId && tokenId < currentIndex;
1362   }
1363 
1364   function _safeMint(address to, uint256 quantity) internal {
1365     _safeMint(to, quantity, "");
1366   }
1367 
1368   /**
1369    * @dev Mints quantity tokens and transfers them to to.
1370    *
1371    * Requirements:
1372    *
1373    * - there must be quantity tokens remaining unminted in the total collection.
1374    * - to cannot be the zero address.
1375    * - quantity cannot be larger than the max batch size.
1376    *
1377    * Emits a {Transfer} event.
1378    */
1379   function _safeMint(
1380     address to,
1381     uint256 quantity,
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
1395       addressData.numberMinted + uint128(quantity)
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
1601 interface IERC20 {
1602   function transfer(address _to, uint256 _amount) external returns (bool);
1603   function balanceOf(address account) external view returns (uint256);
1604 }
1605 
1606 abstract contract Withdrawable is Ownable, Ramppable {
1607   address[] public payableAddresses = [RAMPPADDRESS,0x33aDe537c7a0149029521364e02795baAeEB70b1,0xa46ac25AcC7A1270534C469BF2a0D270c45F80E8,0x1bAAb5183ADe5E4d05670a0d2651B4E032f47bFD];
1608   uint256[] public payableFees = [5,31,32,32];
1609   uint256 public payableAddressCount = 4;
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
1673     ReentrancyGuard  {
1674     constructor(
1675         string memory tokenName,
1676         string memory tokenSymbol
1677     ) ERC721A(tokenName, tokenSymbol, 2, 1665 ) {}
1678     using SafeMath for uint256;
1679     uint8 public CONTRACT_VERSION = 2;
1680     string public _baseTokenURI = "ipfs://QmcRTvfzwuwtgWSEBjWyVVocpRGubEmDBaVSt7dZLgVFgS/";
1681 
1682     bool public mintingOpen = true;
1683     bool public isRevealed = false;
1684     
1685     
1686     uint256 public MAX_WALLET_MINTS = 4;
1687     mapping(address => uint256) private addressMints;
1688 
1689     
1690     /////////////// Admin Mint Functions
1691     /**
1692     * @dev Mints a token to an address with a tokenURI.
1693     * This is owner only and allows a fee-free drop
1694     * @param _to address of the future owner of the token
1695     */
1696     function mintToAdmin(address _to) public onlyOwner {
1697         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1665");
1698         _safeMint(_to, 1);
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
1715         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1665");
1716         require(mintingOpen == true, "Minting is not open right now!");
1717         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1718         
1719         
1720         _safeMint(_to, 1);
1721         updateMintCount(_to, 1);
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
1734         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1735         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1665");
1736         
1737 
1738         _safeMint(_to, _amount);
1739         updateMintCount(_to, _amount);
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
1759         return SafeMath.add(addressMints[_address], _amount) <= MAX_WALLET_MINTS;
1760     }
1761 
1762     /**
1763     * @dev Update an address that has minted to new minted amount
1764     * @param _address address in question to check if minted count exceeds max
1765     * @param _amount the quanitiy of tokens to be minted
1766     */
1767     function updateMintCount(address _address, uint256 _amount) private {
1768         require(_amount >= 1, "Amount must be greater than or equal to 1");
1769         addressMints[_address] = SafeMath.add(addressMints[_address], _amount);
1770     }
1771     
1772     /**
1773     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1774     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1775     */
1776     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1777         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1778         MAX_WALLET_MINTS = _newWalletMax;
1779     }
1780     
1781 
1782     
1783     /**
1784      * @dev Allows owner to set Max mints per tx
1785      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1786      */
1787      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1788          require(_newMaxMint >= 1, "Max mint must be at least 1");
1789          maxBatchSize = _newMaxMint;
1790      }
1791     
1792 
1793     
1794 
1795     
1796     function unveil(string memory _updatedTokenURI) public onlyOwner {
1797         require(isRevealed == false, "Tokens are already unveiled");
1798         _baseTokenURI = _updatedTokenURI;
1799         isRevealed = true;
1800     }
1801     
1802     
1803     function _baseURI() internal view virtual override returns (string memory) {
1804         return _baseTokenURI;
1805     }
1806 
1807     function baseTokenURI() public view returns (string memory) {
1808         return _baseTokenURI;
1809     }
1810 
1811     function setBaseURI(string calldata baseURI) external onlyOwner {
1812         _baseTokenURI = baseURI;
1813     }
1814 
1815     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1816         return ownershipOf(tokenId);
1817     }
1818 }
1819 
1820 
1821   
1822 // File: contracts/TheGirl1665Contract.sol
1823 //SPDX-License-Identifier: MIT
1824 
1825 pragma solidity ^0.8.0;
1826 
1827 contract TheGirl1665Contract is RamppERC721A {
1828     constructor() RamppERC721A("The Girl 1665", "TheGirl"){}
1829 
1830     function contractURI() public pure returns (string memory) {
1831       return "https://us-central1-nft-rampp.cloudfunctions.net/app/0zay6xg6xc921aedTygQ/contract-metadata";
1832     }
1833 }
1834   
1835 //*********************************************************************//
1836 //*********************************************************************//  
1837 //                       Rampp v2.0.1
1838 //
1839 //         This smart contract was generated by rampp.xyz.
1840 //            Rampp allows creators like you to launch 
1841 //             large scale NFT communities without code!
1842 //
1843 //    Rampp is not responsible for the content of this contract and
1844 //        hopes it is being used in a responsible and kind way.  
1845 //       Rampp is not associated or affiliated with this project.                                                    
1846 //             Twitter: @Rampp_ ---- rampp.xyz
1847 //*********************************************************************//                                                     
1848 //*********************************************************************//