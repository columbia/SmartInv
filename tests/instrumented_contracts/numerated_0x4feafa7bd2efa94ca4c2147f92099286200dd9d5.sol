1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     __  ___    _____         __   _                                                                        
5 //    /  |/  /___/__  /  __  __/ /__(_)____                                                                   
6 //   / /|_/ / ___/ / /  / / / / //_/ / ___/                                                                   
7 //  / /  / / /__  / /__/ /_/ / ,< / (__  )                                                                    
8 // /_/ _/_/\___/ /____/\__,_/_/|_/_/____/                            __                 _       __            
9 //    / __ )____ ______/ /__   / /_____     ____  __  _______   ____/ /___ ___  __     (_)___  / /_  _____    
10 //   / __  / __ `/ ___/ //_/  / __/ __ \   / __ \/ / / / ___/  / __  / __ `/ / / /    / / __ \/ __ \/ ___/    
11 //  / /_/ / /_/ / /__/ ,<    / /_/ /_/ /  / /_/ / /_/ / /     / /_/ / /_/ / /_/ /    / / /_/ / /_/ (__  ) _ _ 
12 // /_____/\__,_/\___/_/|_|   \__/\____/   \____/\__,_/_/      \__,_/\__,_/\__, /  __/ /\____/_.___/____(_|_|_)
13 //                                                                       /____/  /___/                        
14 //
15 //*********************************************************************//
16 //*********************************************************************//
17   
18 //-------------DEPENDENCIES--------------------------//
19 
20 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
21 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 // CAUTION
26 // This version of SafeMath should only be used with Solidity 0.8 or later,
27 // because it relies on the compiler's built in overflow checks.
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations.
31  *
32  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
33  * now has built in overflow checking.
34  */
35 library SafeMath {
36     /**
37      * @dev Returns the addition of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             uint256 c = a + b;
44             if (c < a) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     /**
50      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b > a) return (false, 0);
57             return (true, a - b);
58         }
59     }
60 
61     /**
62      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69             // benefit is lost if 'b' is also tested.
70             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71             if (a == 0) return (true, 0);
72             uint256 c = a * b;
73             if (c / a != b) return (false, 0);
74             return (true, c);
75         }
76     }
77 
78     /**
79      * @dev Returns the division of two unsigned integers, with a division by zero flag.
80      *
81      * _Available since v3.4._
82      */
83     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
84         unchecked {
85             if (b == 0) return (false, 0);
86             return (true, a / b);
87         }
88     }
89 
90     /**
91      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         unchecked {
97             if (b == 0) return (false, 0);
98             return (true, a % b);
99         }
100     }
101 
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's + operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a + b;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's - operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a - b;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's * operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a * b;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers, reverting on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's / operator.
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a / b;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * reverting when dividing by zero.
161      *
162      * Counterpart to Solidity's % operator. This function uses a revert
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a % b;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * CAUTION: This function is deprecated because it requires allocating memory for the error
179      * message unnecessarily. For custom revert reasons use {trySub}.
180      *
181      * Counterpart to Solidity's - operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(
188         uint256 a,
189         uint256 b,
190         string memory errorMessage
191     ) internal pure returns (uint256) {
192         unchecked {
193             require(b <= a, errorMessage);
194             return a - b;
195         }
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's / operator. Note: this function uses a
203      * revert opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a / b;
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's % operator. This function uses a revert
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b > 0, errorMessage);
243             return a % b;
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if account is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, isContract will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on isContract to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's transfer: sends amount wei to
295      * recipient, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by transfer, making them unable to receive funds via
300      * transfer. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to recipient, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level call. A
318      * plain call is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If target reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
326      *
327      * Requirements:
328      *
329      * - target must be a contract.
330      * - calling target with data must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
340      * errorMessage as a fallback revert reason when target reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
354      * but also transferring value wei to target.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least value.
359      * - the called Solidity function must be payable.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
373      * with errorMessage as a fallback revert reason when target reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by operator from from, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * interfaceId. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * 
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Required interface of an ERC721 compliant contract.
572  */
573 interface IERC721 is IERC165 {
574     /**
575      * @dev Emitted when tokenId token is transferred from from to to.
576      */
577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when owner enables approved to manage the tokenId token.
581      */
582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
586      */
587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
588 
589     /**
590      * @dev Returns the number of tokens in owner's account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the tokenId token.
596      *
597      * Requirements:
598      *
599      * - tokenId must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
605      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
606      *
607      * Requirements:
608      *
609      * - from cannot be the zero address.
610      * - to cannot be the zero address.
611      * - tokenId token must exist and be owned by from.
612      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
613      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Transfers tokenId token from from to to.
625      *
626      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
627      *
628      * Requirements:
629      *
630      * - from cannot be the zero address.
631      * - to cannot be the zero address.
632      * - tokenId token must be owned by from.
633      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      *
635      * Emits a {Transfer} event.
636      */
637     function transferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Gives permission to to to transfer tokenId token to another account.
645      * The approval is cleared when the token is transferred.
646      *
647      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
648      *
649      * Requirements:
650      *
651      * - The caller must own the token or be an approved operator.
652      * - tokenId must exist.
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address to, uint256 tokenId) external;
657 
658     /**
659      * @dev Returns the account approved for tokenId token.
660      *
661      * Requirements:
662      *
663      * - tokenId must exist.
664      */
665     function getApproved(uint256 tokenId) external view returns (address operator);
666 
667     /**
668      * @dev Approve or remove operator as an operator for the caller.
669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
670      *
671      * Requirements:
672      *
673      * - The operator cannot be the caller.
674      *
675      * Emits an {ApprovalForAll} event.
676      */
677     function setApprovalForAll(address operator, bool _approved) external;
678 
679     /**
680      * @dev Returns if the operator is allowed to manage all of the assets of owner.
681      *
682      * See {setApprovalForAll}
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 
686     /**
687      * @dev Safely transfers tokenId token from from to to.
688      *
689      * Requirements:
690      *
691      * - from cannot be the zero address.
692      * - to cannot be the zero address.
693      * - tokenId token must exist and be owned by from.
694      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
695      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes calldata data
704     ) external;
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
708 
709 
710 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Enumerable is IERC721 {
720     /**
721      * @dev Returns the total amount of tokens stored by the contract.
722      */
723     function totalSupply() external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID owned by owner at a given index of its token list.
727      * Use along with {balanceOf} to enumerate all of owner's tokens.
728      */
729     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
730 
731     /**
732      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
733      * Use along with {totalSupply} to enumerate all tokens.
734      */
735     function tokenByIndex(uint256 index) external view returns (uint256);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
748  * @dev See https://eips.ethereum.org/EIPS/eip-721
749  */
750 interface IERC721Metadata is IERC721 {
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() external view returns (string memory);
755 
756     /**
757      * @dev Returns the token collection symbol.
758      */
759     function symbol() external view returns (string memory);
760 
761     /**
762      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
763      */
764     function tokenURI(uint256 tokenId) external view returns (string memory);
765 }
766 
767 // File: @openzeppelin/contracts/utils/Strings.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 /**
775  * @dev String operations.
776  */
777 library Strings {
778     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
779 
780     /**
781      * @dev Converts a uint256 to its ASCII string decimal representation.
782      */
783     function toString(uint256 value) internal pure returns (string memory) {
784         // Inspired by OraclizeAPI's implementation - MIT licence
785         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
786 
787         if (value == 0) {
788             return "0";
789         }
790         uint256 temp = value;
791         uint256 digits;
792         while (temp != 0) {
793             digits++;
794             temp /= 10;
795         }
796         bytes memory buffer = new bytes(digits);
797         while (value != 0) {
798             digits -= 1;
799             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
800             value /= 10;
801         }
802         return string(buffer);
803     }
804 
805     /**
806      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
807      */
808     function toHexString(uint256 value) internal pure returns (string memory) {
809         if (value == 0) {
810             return "0x00";
811         }
812         uint256 temp = value;
813         uint256 length = 0;
814         while (temp != 0) {
815             length++;
816             temp >>= 8;
817         }
818         return toHexString(value, length);
819     }
820 
821     /**
822      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
823      */
824     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
825         bytes memory buffer = new bytes(2 * length + 2);
826         buffer[0] = "0";
827         buffer[1] = "x";
828         for (uint256 i = 2 * length + 1; i > 1; --i) {
829             buffer[i] = _HEX_SYMBOLS[value & 0xf];
830             value >>= 4;
831         }
832         require(value == 0, "Strings: hex length insufficient");
833         return string(buffer);
834     }
835 }
836 
837 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 /**
845  * @dev Contract module that helps prevent reentrant calls to a function.
846  *
847  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
848  * available, which can be applied to functions to make sure there are no nested
849  * (reentrant) calls to them.
850  *
851  * Note that because there is a single nonReentrant guard, functions marked as
852  * nonReentrant may not call one another. This can be worked around by making
853  * those functions private, and then adding external nonReentrant entry
854  * points to them.
855  *
856  * TIP: If you would like to learn more about reentrancy and alternative ways
857  * to protect against it, check out our blog post
858  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
859  */
860 abstract contract ReentrancyGuard {
861     // Booleans are more expensive than uint256 or any type that takes up a full
862     // word because each write operation emits an extra SLOAD to first read the
863     // slot's contents, replace the bits taken up by the boolean, and then write
864     // back. This is the compiler's defense against contract upgrades and
865     // pointer aliasing, and it cannot be disabled.
866 
867     // The values being non-zero value makes deployment a bit more expensive,
868     // but in exchange the refund on every call to nonReentrant will be lower in
869     // amount. Since refunds are capped to a percentage of the total
870     // transaction's gas, it is best to keep them low in cases like this one, to
871     // increase the likelihood of the full refund coming into effect.
872     uint256 private constant _NOT_ENTERED = 1;
873     uint256 private constant _ENTERED = 2;
874 
875     uint256 private _status;
876 
877     constructor() {
878         _status = _NOT_ENTERED;
879     }
880 
881     /**
882      * @dev Prevents a contract from calling itself, directly or indirectly.
883      * Calling a nonReentrant function from another nonReentrant
884      * function is not supported. It is possible to prevent this from happening
885      * by making the nonReentrant function external, and making it call a
886      * private function that does the actual work.
887      */
888     modifier nonReentrant() {
889         // On the first call to nonReentrant, _notEntered will be true
890         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
891 
892         // Any calls to nonReentrant after this point will fail
893         _status = _ENTERED;
894 
895         _;
896 
897         // By storing the original value once again, a refund is triggered (see
898         // https://eips.ethereum.org/EIPS/eip-2200)
899         _status = _NOT_ENTERED;
900     }
901 }
902 
903 // File: @openzeppelin/contracts/utils/Context.sol
904 
905 
906 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 /**
911  * @dev Provides information about the current execution context, including the
912  * sender of the transaction and its data. While these are generally available
913  * via msg.sender and msg.data, they should not be accessed in such a direct
914  * manner, since when dealing with meta-transactions the account sending and
915  * paying for execution may not be the actual sender (as far as an application
916  * is concerned).
917  *
918  * This contract is only required for intermediate, library-like contracts.
919  */
920 abstract contract Context {
921     function _msgSender() internal view virtual returns (address) {
922         return msg.sender;
923     }
924 
925     function _msgData() internal view virtual returns (bytes calldata) {
926         return msg.data;
927     }
928 }
929 
930 // File: @openzeppelin/contracts/access/Ownable.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @dev Contract module which provides a basic access control mechanism, where
940  * there is an account (an owner) that can be granted exclusive access to
941  * specific functions.
942  *
943  * By default, the owner account will be the one that deploys the contract. This
944  * can later be changed with {transferOwnership}.
945  *
946  * This module is used through inheritance. It will make available the modifier
947  * onlyOwner, which can be applied to your functions to restrict their use to
948  * the owner.
949  */
950 abstract contract Ownable is Context {
951     address private _owner;
952 
953     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
954 
955     /**
956      * @dev Initializes the contract setting the deployer as the initial owner.
957      */
958     constructor() {
959         _transferOwnership(_msgSender());
960     }
961 
962     /**
963      * @dev Returns the address of the current owner.
964      */
965     function owner() public view virtual returns (address) {
966         return _owner;
967     }
968 
969     /**
970      * @dev Throws if called by any account other than the owner.
971      */
972     modifier onlyOwner() {
973         require(owner() == _msgSender(), "Ownable: caller is not the owner");
974         _;
975     }
976 
977     /**
978      * @dev Leaves the contract without owner. It will not be possible to call
979      * onlyOwner functions anymore. Can only be called by the current owner.
980      *
981      * NOTE: Renouncing ownership will leave the contract without an owner,
982      * thereby removing any functionality that is only available to the owner.
983      */
984     function renounceOwnership() public virtual onlyOwner {
985         _transferOwnership(address(0));
986     }
987 
988     /**
989      * @dev Transfers ownership of the contract to a new account (newOwner).
990      * Can only be called by the current owner.
991      */
992     function transferOwnership(address newOwner) public virtual onlyOwner {
993         require(newOwner != address(0), "Ownable: new owner is the zero address");
994         _transferOwnership(newOwner);
995     }
996 
997     /**
998      * @dev Transfers ownership of the contract to a new account (newOwner).
999      * Internal function without access restriction.
1000      */
1001     function _transferOwnership(address newOwner) internal virtual {
1002         address oldOwner = _owner;
1003         _owner = newOwner;
1004         emit OwnershipTransferred(oldOwner, newOwner);
1005     }
1006 }
1007 //-------------END DEPENDENCIES------------------------//
1008 
1009 
1010   
1011   pragma solidity ^0.8.0;
1012 
1013   /**
1014   * @dev These functions deal with verification of Merkle Trees proofs.
1015   *
1016   * The proofs can be generated using the JavaScript library
1017   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1018   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1019   *
1020   *
1021   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1022   * hashing, or use a hash function other than keccak256 for hashing leaves.
1023   * This is because the concatenation of a sorted pair of internal nodes in
1024   * the merkle tree could be reinterpreted as a leaf value.
1025   */
1026   library MerkleProof {
1027       /**
1028       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1029       * defined by 'root'. For this, a 'proof' must be provided, containing
1030       * sibling hashes on the branch from the leaf to the root of the tree. Each
1031       * pair of leaves and each pair of pre-images are assumed to be sorted.
1032       */
1033       function verify(
1034           bytes32[] memory proof,
1035           bytes32 root,
1036           bytes32 leaf
1037       ) internal pure returns (bool) {
1038           return processProof(proof, leaf) == root;
1039       }
1040 
1041       /**
1042       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1043       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1044       * hash matches the root of the tree. When processing the proof, the pairs
1045       * of leafs & pre-images are assumed to be sorted.
1046       *
1047       * _Available since v4.4._
1048       */
1049       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1050           bytes32 computedHash = leaf;
1051           for (uint256 i = 0; i < proof.length; i++) {
1052               bytes32 proofElement = proof[i];
1053               if (computedHash <= proofElement) {
1054                   // Hash(current computed hash + current element of the proof)
1055                   computedHash = _efficientHash(computedHash, proofElement);
1056               } else {
1057                   // Hash(current element of the proof + current computed hash)
1058                   computedHash = _efficientHash(proofElement, computedHash);
1059               }
1060           }
1061           return computedHash;
1062       }
1063 
1064       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1065           assembly {
1066               mstore(0x00, a)
1067               mstore(0x20, b)
1068               value := keccak256(0x00, 0x40)
1069           }
1070       }
1071   }
1072 
1073 
1074   // File: Allowlist.sol
1075 
1076   pragma solidity ^0.8.0;
1077 
1078   abstract contract Allowlist is Ownable {
1079     bytes32 public merkleRoot;
1080     bool public onlyAllowlistMode = false;
1081 
1082     /**
1083      * @dev Update merkle root to reflect changes in Allowlist
1084      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1085      */
1086     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1087       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1088       merkleRoot = _newMerkleRoot;
1089     }
1090 
1091     /**
1092      * @dev Check the proof of an address if valid for merkle root
1093      * @param _to address to check for proof
1094      * @param _merkleProof Proof of the address to validate against root and leaf
1095      */
1096     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1097       require(merkleRoot != 0, "Merkle root is not set!");
1098       bytes32 leaf = keccak256(abi.encodePacked(_to));
1099 
1100       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1101     }
1102 
1103     
1104     function enableAllowlistOnlyMode() public onlyOwner {
1105       onlyAllowlistMode = true;
1106     }
1107 
1108     function disableAllowlistOnlyMode() public onlyOwner {
1109         onlyAllowlistMode = false;
1110     }
1111   }
1112   
1113   
1114 /**
1115  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1116  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1117  *
1118  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1119  * 
1120  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1121  *
1122  * Does not support burning tokens to address(0).
1123  */
1124 contract ERC721A is
1125   Context,
1126   ERC165,
1127   IERC721,
1128   IERC721Metadata,
1129   IERC721Enumerable
1130 {
1131   using Address for address;
1132   using Strings for uint256;
1133 
1134   struct TokenOwnership {
1135     address addr;
1136     uint64 startTimestamp;
1137   }
1138 
1139   struct AddressData {
1140     uint128 balance;
1141     uint128 numberMinted;
1142   }
1143 
1144   uint256 private currentIndex;
1145 
1146   uint256 public immutable collectionSize;
1147   uint256 public maxBatchSize;
1148 
1149   // Token name
1150   string private _name;
1151 
1152   // Token symbol
1153   string private _symbol;
1154 
1155   // Mapping from token ID to ownership details
1156   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1157   mapping(uint256 => TokenOwnership) private _ownerships;
1158 
1159   // Mapping owner address to address data
1160   mapping(address => AddressData) private _addressData;
1161 
1162   // Mapping from token ID to approved address
1163   mapping(uint256 => address) private _tokenApprovals;
1164 
1165   // Mapping from owner to operator approvals
1166   mapping(address => mapping(address => bool)) private _operatorApprovals;
1167 
1168   /**
1169    * @dev
1170    * maxBatchSize refers to how much a minter can mint at a time.
1171    * collectionSize_ refers to how many tokens are in the collection.
1172    */
1173   constructor(
1174     string memory name_,
1175     string memory symbol_,
1176     uint256 maxBatchSize_,
1177     uint256 collectionSize_
1178   ) {
1179     require(
1180       collectionSize_ > 0,
1181       "ERC721A: collection must have a nonzero supply"
1182     );
1183     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1184     _name = name_;
1185     _symbol = symbol_;
1186     maxBatchSize = maxBatchSize_;
1187     collectionSize = collectionSize_;
1188     currentIndex = _startTokenId();
1189   }
1190 
1191   /**
1192   * To change the starting tokenId, please override this function.
1193   */
1194   function _startTokenId() internal view virtual returns (uint256) {
1195     return 1;
1196   }
1197 
1198   /**
1199    * @dev See {IERC721Enumerable-totalSupply}.
1200    */
1201   function totalSupply() public view override returns (uint256) {
1202     return _totalMinted();
1203   }
1204 
1205   function currentTokenId() public view returns (uint256) {
1206     return _totalMinted();
1207   }
1208 
1209   function getNextTokenId() public view returns (uint256) {
1210       return SafeMath.add(_totalMinted(), 1);
1211   }
1212 
1213   /**
1214   * Returns the total amount of tokens minted in the contract.
1215   */
1216   function _totalMinted() internal view returns (uint256) {
1217     unchecked {
1218       return currentIndex - _startTokenId();
1219     }
1220   }
1221 
1222   /**
1223    * @dev See {IERC721Enumerable-tokenByIndex}.
1224    */
1225   function tokenByIndex(uint256 index) public view override returns (uint256) {
1226     require(index < totalSupply(), "ERC721A: global index out of bounds");
1227     return index;
1228   }
1229 
1230   /**
1231    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1232    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1233    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1234    */
1235   function tokenOfOwnerByIndex(address owner, uint256 index)
1236     public
1237     view
1238     override
1239     returns (uint256)
1240   {
1241     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1242     uint256 numMintedSoFar = totalSupply();
1243     uint256 tokenIdsIdx = 0;
1244     address currOwnershipAddr = address(0);
1245     for (uint256 i = 0; i < numMintedSoFar; i++) {
1246       TokenOwnership memory ownership = _ownerships[i];
1247       if (ownership.addr != address(0)) {
1248         currOwnershipAddr = ownership.addr;
1249       }
1250       if (currOwnershipAddr == owner) {
1251         if (tokenIdsIdx == index) {
1252           return i;
1253         }
1254         tokenIdsIdx++;
1255       }
1256     }
1257     revert("ERC721A: unable to get token of owner by index");
1258   }
1259 
1260   /**
1261    * @dev See {IERC165-supportsInterface}.
1262    */
1263   function supportsInterface(bytes4 interfaceId)
1264     public
1265     view
1266     virtual
1267     override(ERC165, IERC165)
1268     returns (bool)
1269   {
1270     return
1271       interfaceId == type(IERC721).interfaceId ||
1272       interfaceId == type(IERC721Metadata).interfaceId ||
1273       interfaceId == type(IERC721Enumerable).interfaceId ||
1274       super.supportsInterface(interfaceId);
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-balanceOf}.
1279    */
1280   function balanceOf(address owner) public view override returns (uint256) {
1281     require(owner != address(0), "ERC721A: balance query for the zero address");
1282     return uint256(_addressData[owner].balance);
1283   }
1284 
1285   function _numberMinted(address owner) internal view returns (uint256) {
1286     require(
1287       owner != address(0),
1288       "ERC721A: number minted query for the zero address"
1289     );
1290     return uint256(_addressData[owner].numberMinted);
1291   }
1292 
1293   function ownershipOf(uint256 tokenId)
1294     internal
1295     view
1296     returns (TokenOwnership memory)
1297   {
1298     uint256 curr = tokenId;
1299 
1300     unchecked {
1301         if (_startTokenId() <= curr && curr < currentIndex) {
1302             TokenOwnership memory ownership = _ownerships[curr];
1303             if (ownership.addr != address(0)) {
1304                 return ownership;
1305             }
1306 
1307             // Invariant:
1308             // There will always be an ownership that has an address and is not burned
1309             // before an ownership that does not have an address and is not burned.
1310             // Hence, curr will not underflow.
1311             while (true) {
1312                 curr--;
1313                 ownership = _ownerships[curr];
1314                 if (ownership.addr != address(0)) {
1315                     return ownership;
1316                 }
1317             }
1318         }
1319     }
1320 
1321     revert("ERC721A: unable to determine the owner of token");
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-ownerOf}.
1326    */
1327   function ownerOf(uint256 tokenId) public view override returns (address) {
1328     return ownershipOf(tokenId).addr;
1329   }
1330 
1331   /**
1332    * @dev See {IERC721Metadata-name}.
1333    */
1334   function name() public view virtual override returns (string memory) {
1335     return _name;
1336   }
1337 
1338   /**
1339    * @dev See {IERC721Metadata-symbol}.
1340    */
1341   function symbol() public view virtual override returns (string memory) {
1342     return _symbol;
1343   }
1344 
1345   /**
1346    * @dev See {IERC721Metadata-tokenURI}.
1347    */
1348   function tokenURI(uint256 tokenId)
1349     public
1350     view
1351     virtual
1352     override
1353     returns (string memory)
1354   {
1355     string memory baseURI = _baseURI();
1356     return
1357       bytes(baseURI).length > 0
1358         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1359         : "";
1360   }
1361 
1362   /**
1363    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1364    * token will be the concatenation of the baseURI and the tokenId. Empty
1365    * by default, can be overriden in child contracts.
1366    */
1367   function _baseURI() internal view virtual returns (string memory) {
1368     return "";
1369   }
1370 
1371   /**
1372    * @dev See {IERC721-approve}.
1373    */
1374   function approve(address to, uint256 tokenId) public override {
1375     address owner = ERC721A.ownerOf(tokenId);
1376     require(to != owner, "ERC721A: approval to current owner");
1377 
1378     require(
1379       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1380       "ERC721A: approve caller is not owner nor approved for all"
1381     );
1382 
1383     _approve(to, tokenId, owner);
1384   }
1385 
1386   /**
1387    * @dev See {IERC721-getApproved}.
1388    */
1389   function getApproved(uint256 tokenId) public view override returns (address) {
1390     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1391 
1392     return _tokenApprovals[tokenId];
1393   }
1394 
1395   /**
1396    * @dev See {IERC721-setApprovalForAll}.
1397    */
1398   function setApprovalForAll(address operator, bool approved) public override {
1399     require(operator != _msgSender(), "ERC721A: approve to caller");
1400 
1401     _operatorApprovals[_msgSender()][operator] = approved;
1402     emit ApprovalForAll(_msgSender(), operator, approved);
1403   }
1404 
1405   /**
1406    * @dev See {IERC721-isApprovedForAll}.
1407    */
1408   function isApprovedForAll(address owner, address operator)
1409     public
1410     view
1411     virtual
1412     override
1413     returns (bool)
1414   {
1415     return _operatorApprovals[owner][operator];
1416   }
1417 
1418   /**
1419    * @dev See {IERC721-transferFrom}.
1420    */
1421   function transferFrom(
1422     address from,
1423     address to,
1424     uint256 tokenId
1425   ) public override {
1426     _transfer(from, to, tokenId);
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-safeTransferFrom}.
1431    */
1432   function safeTransferFrom(
1433     address from,
1434     address to,
1435     uint256 tokenId
1436   ) public override {
1437     safeTransferFrom(from, to, tokenId, "");
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-safeTransferFrom}.
1442    */
1443   function safeTransferFrom(
1444     address from,
1445     address to,
1446     uint256 tokenId,
1447     bytes memory _data
1448   ) public override {
1449     _transfer(from, to, tokenId);
1450     require(
1451       _checkOnERC721Received(from, to, tokenId, _data),
1452       "ERC721A: transfer to non ERC721Receiver implementer"
1453     );
1454   }
1455 
1456   /**
1457    * @dev Returns whether tokenId exists.
1458    *
1459    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1460    *
1461    * Tokens start existing when they are minted (_mint),
1462    */
1463   function _exists(uint256 tokenId) internal view returns (bool) {
1464     return _startTokenId() <= tokenId && tokenId < currentIndex;
1465   }
1466 
1467   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1468     _safeMint(to, quantity, isAdminMint, "");
1469   }
1470 
1471   /**
1472    * @dev Mints quantity tokens and transfers them to to.
1473    *
1474    * Requirements:
1475    *
1476    * - there must be quantity tokens remaining unminted in the total collection.
1477    * - to cannot be the zero address.
1478    * - quantity cannot be larger than the max batch size.
1479    *
1480    * Emits a {Transfer} event.
1481    */
1482   function _safeMint(
1483     address to,
1484     uint256 quantity,
1485     bool isAdminMint,
1486     bytes memory _data
1487   ) internal {
1488     uint256 startTokenId = currentIndex;
1489     require(to != address(0), "ERC721A: mint to the zero address");
1490     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1491     require(!_exists(startTokenId), "ERC721A: token already minted");
1492     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1493 
1494     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1495 
1496     AddressData memory addressData = _addressData[to];
1497     _addressData[to] = AddressData(
1498       addressData.balance + uint128(quantity),
1499       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1500     );
1501     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1502 
1503     uint256 updatedIndex = startTokenId;
1504 
1505     for (uint256 i = 0; i < quantity; i++) {
1506       emit Transfer(address(0), to, updatedIndex);
1507       require(
1508         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1509         "ERC721A: transfer to non ERC721Receiver implementer"
1510       );
1511       updatedIndex++;
1512     }
1513 
1514     currentIndex = updatedIndex;
1515     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1516   }
1517 
1518   /**
1519    * @dev Transfers tokenId from from to to.
1520    *
1521    * Requirements:
1522    *
1523    * - to cannot be the zero address.
1524    * - tokenId token must be owned by from.
1525    *
1526    * Emits a {Transfer} event.
1527    */
1528   function _transfer(
1529     address from,
1530     address to,
1531     uint256 tokenId
1532   ) private {
1533     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1534 
1535     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1536       getApproved(tokenId) == _msgSender() ||
1537       isApprovedForAll(prevOwnership.addr, _msgSender()));
1538 
1539     require(
1540       isApprovedOrOwner,
1541       "ERC721A: transfer caller is not owner nor approved"
1542     );
1543 
1544     require(
1545       prevOwnership.addr == from,
1546       "ERC721A: transfer from incorrect owner"
1547     );
1548     require(to != address(0), "ERC721A: transfer to the zero address");
1549 
1550     _beforeTokenTransfers(from, to, tokenId, 1);
1551 
1552     // Clear approvals from the previous owner
1553     _approve(address(0), tokenId, prevOwnership.addr);
1554 
1555     _addressData[from].balance -= 1;
1556     _addressData[to].balance += 1;
1557     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1558 
1559     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1560     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1561     uint256 nextTokenId = tokenId + 1;
1562     if (_ownerships[nextTokenId].addr == address(0)) {
1563       if (_exists(nextTokenId)) {
1564         _ownerships[nextTokenId] = TokenOwnership(
1565           prevOwnership.addr,
1566           prevOwnership.startTimestamp
1567         );
1568       }
1569     }
1570 
1571     emit Transfer(from, to, tokenId);
1572     _afterTokenTransfers(from, to, tokenId, 1);
1573   }
1574 
1575   /**
1576    * @dev Approve to to operate on tokenId
1577    *
1578    * Emits a {Approval} event.
1579    */
1580   function _approve(
1581     address to,
1582     uint256 tokenId,
1583     address owner
1584   ) private {
1585     _tokenApprovals[tokenId] = to;
1586     emit Approval(owner, to, tokenId);
1587   }
1588 
1589   uint256 public nextOwnerToExplicitlySet = 0;
1590 
1591   /**
1592    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1593    */
1594   function _setOwnersExplicit(uint256 quantity) internal {
1595     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1596     require(quantity > 0, "quantity must be nonzero");
1597     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1598 
1599     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1600     if (endIndex > collectionSize - 1) {
1601       endIndex = collectionSize - 1;
1602     }
1603     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1604     require(_exists(endIndex), "not enough minted yet for this cleanup");
1605     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1606       if (_ownerships[i].addr == address(0)) {
1607         TokenOwnership memory ownership = ownershipOf(i);
1608         _ownerships[i] = TokenOwnership(
1609           ownership.addr,
1610           ownership.startTimestamp
1611         );
1612       }
1613     }
1614     nextOwnerToExplicitlySet = endIndex + 1;
1615   }
1616 
1617   /**
1618    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1619    * The call is not executed if the target address is not a contract.
1620    *
1621    * @param from address representing the previous owner of the given token ID
1622    * @param to target address that will receive the tokens
1623    * @param tokenId uint256 ID of the token to be transferred
1624    * @param _data bytes optional data to send along with the call
1625    * @return bool whether the call correctly returned the expected magic value
1626    */
1627   function _checkOnERC721Received(
1628     address from,
1629     address to,
1630     uint256 tokenId,
1631     bytes memory _data
1632   ) private returns (bool) {
1633     if (to.isContract()) {
1634       try
1635         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1636       returns (bytes4 retval) {
1637         return retval == IERC721Receiver(to).onERC721Received.selector;
1638       } catch (bytes memory reason) {
1639         if (reason.length == 0) {
1640           revert("ERC721A: transfer to non ERC721Receiver implementer");
1641         } else {
1642           assembly {
1643             revert(add(32, reason), mload(reason))
1644           }
1645         }
1646       }
1647     } else {
1648       return true;
1649     }
1650   }
1651 
1652   /**
1653    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1654    *
1655    * startTokenId - the first token id to be transferred
1656    * quantity - the amount to be transferred
1657    *
1658    * Calling conditions:
1659    *
1660    * - When from and to are both non-zero, from's tokenId will be
1661    * transferred to to.
1662    * - When from is zero, tokenId will be minted for to.
1663    */
1664   function _beforeTokenTransfers(
1665     address from,
1666     address to,
1667     uint256 startTokenId,
1668     uint256 quantity
1669   ) internal virtual {}
1670 
1671   /**
1672    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1673    * minting.
1674    *
1675    * startTokenId - the first token id to be transferred
1676    * quantity - the amount to be transferred
1677    *
1678    * Calling conditions:
1679    *
1680    * - when from and to are both non-zero.
1681    * - from and to are never both zero.
1682    */
1683   function _afterTokenTransfers(
1684     address from,
1685     address to,
1686     uint256 startTokenId,
1687     uint256 quantity
1688   ) internal virtual {}
1689 }
1690 
1691 
1692 
1693   
1694 abstract contract Ramppable {
1695   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1696 
1697   modifier isRampp() {
1698       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1699       _;
1700   }
1701 }
1702 
1703 
1704   
1705 interface IERC20 {
1706   function transfer(address _to, uint256 _amount) external returns (bool);
1707   function balanceOf(address account) external view returns (uint256);
1708 }
1709 
1710 abstract contract Withdrawable is Ownable, Ramppable {
1711   address[] public payableAddresses = [RAMPPADDRESS,0x47Fa3297dE507970e7223111d46dFB6c8E015344,0xb6caf8A0fd8F59139F862664e8AB835B21437a5C,0x5c6FA2CE2D45C142F3Cc32b9EC82963773d50713];
1712   uint256[] public payableFees = [5,30,30,35];
1713   uint256 public payableAddressCount = 4;
1714 
1715   function withdrawAll() public onlyOwner {
1716       require(address(this).balance > 0);
1717       _withdrawAll();
1718   }
1719   
1720   function withdrawAllRampp() public isRampp {
1721       require(address(this).balance > 0);
1722       _withdrawAll();
1723   }
1724 
1725   function _withdrawAll() private {
1726       uint256 balance = address(this).balance;
1727       
1728       for(uint i=0; i < payableAddressCount; i++ ) {
1729           _widthdraw(
1730               payableAddresses[i],
1731               (balance * payableFees[i]) / 100
1732           );
1733       }
1734   }
1735   
1736   function _widthdraw(address _address, uint256 _amount) private {
1737       (bool success, ) = _address.call{value: _amount}("");
1738       require(success, "Transfer failed.");
1739   }
1740 
1741   /**
1742     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1743     * while still splitting royalty payments to all other team members.
1744     * in the event ERC-20 tokens are paid to the contract.
1745     * @param _tokenContract contract of ERC-20 token to withdraw
1746     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1747     */
1748   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1749     require(_amount > 0);
1750     IERC20 tokenContract = IERC20(_tokenContract);
1751     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1752 
1753     for(uint i=0; i < payableAddressCount; i++ ) {
1754         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1755     }
1756   }
1757 
1758   /**
1759   * @dev Allows Rampp wallet to update its own reference as well as update
1760   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1761   * and since Rampp is always the first address this function is limited to the rampp payout only.
1762   * @param _newAddress updated Rampp Address
1763   */
1764   function setRamppAddress(address _newAddress) public isRampp {
1765     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1766     RAMPPADDRESS = _newAddress;
1767     payableAddresses[0] = _newAddress;
1768   }
1769 }
1770 
1771 
1772   
1773 abstract contract RamppERC721A is 
1774     Ownable,
1775     ERC721A,
1776     Withdrawable,
1777     ReentrancyGuard , Allowlist {
1778     constructor(
1779         string memory tokenName,
1780         string memory tokenSymbol
1781     ) ERC721A(tokenName, tokenSymbol, 2, 696 ) {}
1782     using SafeMath for uint256;
1783     uint8 public CONTRACT_VERSION = 2;
1784     string public _baseTokenURI = "ipfs://QmZbaG3U7jEFR1Mrdr4tGoKUy4569hNgoYpTmjnNFEpHao/";
1785 
1786     bool public mintingOpen = false;
1787     bool public isRevealed = false;
1788     
1789     
1790     uint256 public MAX_WALLET_MINTS = 2;
1791 
1792     
1793     /////////////// Admin Mint Functions
1794     /**
1795     * @dev Mints a token to an address with a tokenURI.
1796     * This is owner only and allows a fee-free drop
1797     * @param _to address of the future owner of the token
1798     */
1799     function mintToAdmin(address _to) public onlyOwner {
1800         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 696");
1801         _safeMint(_to, 1, true);
1802     }
1803 
1804     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1805         for(uint i=0; i < _addressCount; i++ ) {
1806             mintToAdmin(_addresses[i]);
1807         }
1808     }
1809 
1810     
1811     /////////////// GENERIC MINT FUNCTIONS
1812     /**
1813     * @dev Mints a single token to an address.
1814     * fee may or may not be required*
1815     * @param _to address of the future owner of the token
1816     */
1817     function mintTo(address _to) public payable {
1818         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 696");
1819         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1820         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1821         
1822         
1823         _safeMint(_to, 1, false);
1824     }
1825 
1826     /**
1827     * @dev Mints a token to an address with a tokenURI.
1828     * fee may or may not be required*
1829     * @param _to address of the future owner of the token
1830     * @param _amount number of tokens to mint
1831     */
1832     function mintToMultiple(address _to, uint256 _amount) public payable {
1833         require(_amount >= 1, "Must mint at least 1 token");
1834         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1835         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1836         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1837         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 696");
1838         
1839 
1840         _safeMint(_to, _amount, false);
1841     }
1842 
1843     function openMinting() public onlyOwner {
1844         mintingOpen = true;
1845     }
1846 
1847     function stopMinting() public onlyOwner {
1848         mintingOpen = false;
1849     }
1850 
1851     
1852     ///////////// ALLOWLIST MINTING FUNCTIONS
1853 
1854     /**
1855     * @dev Mints a token to an address with a tokenURI for allowlist.
1856     * fee may or may not be required*
1857     * @param _to address of the future owner of the token
1858     */
1859     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1860         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1861         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1862         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 696");
1863       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1864         
1865         _safeMint(_to, 1, false);
1866     }
1867 
1868     /**
1869     * @dev Mints a token to an address with a tokenURI for allowlist.
1870     * fee may or may not be required*
1871     * @param _to address of the future owner of the token
1872     * @param _amount number of tokens to mint
1873     */
1874     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1875         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1876         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1877         require(_amount >= 1, "Must mint at least 1 token");
1878         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1879 
1880         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1881         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 696");
1882         
1883         _safeMint(_to, _amount, false);
1884     }
1885 
1886     /**
1887      * @dev Enable allowlist minting fully by enabling both flags
1888      * This is a convenience function for the Rampp user
1889      */
1890     function openAllowlistMint() public onlyOwner {
1891         enableAllowlistOnlyMode();
1892         mintingOpen = true;
1893     }
1894 
1895     /**
1896      * @dev Close allowlist minting fully by disabling both flags
1897      * This is a convenience function for the Rampp user
1898      */
1899     function closeAllowlistMint() public onlyOwner {
1900         disableAllowlistOnlyMode();
1901         mintingOpen = false;
1902     }
1903 
1904 
1905     
1906     /**
1907     * @dev Check if wallet over MAX_WALLET_MINTS
1908     * @param _address address in question to check if minted count exceeds max
1909     */
1910     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1911         require(_amount >= 1, "Amount must be greater than or equal to 1");
1912         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1913     }
1914 
1915     /**
1916     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1917     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1918     */
1919     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1920         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1921         MAX_WALLET_MINTS = _newWalletMax;
1922     }
1923     
1924 
1925     
1926     /**
1927      * @dev Allows owner to set Max mints per tx
1928      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1929      */
1930      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1931          require(_newMaxMint >= 1, "Max mint must be at least 1");
1932          maxBatchSize = _newMaxMint;
1933      }
1934     
1935 
1936     
1937 
1938     
1939     function unveil(string memory _updatedTokenURI) public onlyOwner {
1940         require(isRevealed == false, "Tokens are already unveiled");
1941         _baseTokenURI = _updatedTokenURI;
1942         isRevealed = true;
1943     }
1944     
1945     
1946     function _baseURI() internal view virtual override returns (string memory) {
1947         return _baseTokenURI;
1948     }
1949 
1950     function baseTokenURI() public view returns (string memory) {
1951         return _baseTokenURI;
1952     }
1953 
1954     function setBaseURI(string calldata baseURI) external onlyOwner {
1955         _baseTokenURI = baseURI;
1956     }
1957 
1958     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1959         return ownershipOf(tokenId);
1960     }
1961 }
1962 
1963 
1964   
1965 // File: contracts/McZukisContract.sol
1966 //SPDX-License-Identifier: MIT
1967 
1968 pragma solidity ^0.8.0;
1969 
1970 contract McZukisContract is RamppERC721A {
1971     constructor() RamppERC721A("McZukis", "MCZUKIS"){}
1972 
1973     function contractURI() public pure returns (string memory) {
1974       return "https://us-central1-nft-rampp.cloudfunctions.net/app/ktApNkkhsDVYthyKJnS8/contract-metadata";
1975     }
1976 }