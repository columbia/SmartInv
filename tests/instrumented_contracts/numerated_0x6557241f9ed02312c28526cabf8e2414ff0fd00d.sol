1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // #         /$$ /$$           /$$       /$$                                 /$$                              /$$      /$$$$$$ 
5 // #        | $$|__/          | $$      | $$                                | $$                             | $$     /$$__  $$
6 // #    /$$$$$$$ /$$  /$$$$$$$| $$   /$$| $$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$$    /$$  /$$  /$$ /$$$$$$  | $$  \__/
7 // #   /$$__  $$| $$ /$$_____/| $$  /$$/| $$__  $$ /$$__  $$ |____  $$ /$$__  $$ /$$_____/   | $$ | $$ | $$|_  $$_/  | $$$$    
8 // #  | $$  | $$| $$| $$      | $$$$$$/ | $$  \ $$| $$$$$$$$  /$$$$$$$| $$  | $$|  $$$$$$    | $$ | $$ | $$  | $$    | $$_/    
9 // #  | $$  | $$| $$| $$      | $$_  $$ | $$  | $$| $$_____/ /$$__  $$| $$  | $$ \____  $$   | $$ | $$ | $$  | $$ /$$| $$      
10 // #  |  $$$$$$$| $$|  $$$$$$$| $$ \  $$| $$  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$$ /$$$$$$$//$$|  $$$$$/$$$$/  |  $$$$/| $$      
11 // #   \_______/|__/ \_______/|__/  \__/|__/  |__/ \_______/ \_______/ \_______/|_______/|__/ \_____/\___/    \___/  |__/      
12 // #                                                                                                                           
13 // #                                                                                                                     
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
1011   
1012 /**
1013  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1014  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1015  *
1016  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1017  * 
1018  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1019  *
1020  * Does not support burning tokens to address(0).
1021  */
1022 contract ERC721A is
1023   Context,
1024   ERC165,
1025   IERC721,
1026   IERC721Metadata,
1027   IERC721Enumerable
1028 {
1029   using Address for address;
1030   using Strings for uint256;
1031 
1032   struct TokenOwnership {
1033     address addr;
1034     uint64 startTimestamp;
1035   }
1036 
1037   struct AddressData {
1038     uint128 balance;
1039     uint128 numberMinted;
1040   }
1041 
1042   uint256 private currentIndex;
1043 
1044   uint256 public immutable collectionSize;
1045   uint256 public maxBatchSize;
1046 
1047   // Token name
1048   string private _name;
1049 
1050   // Token symbol
1051   string private _symbol;
1052 
1053   // Mapping from token ID to ownership details
1054   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1055   mapping(uint256 => TokenOwnership) private _ownerships;
1056 
1057   // Mapping owner address to address data
1058   mapping(address => AddressData) private _addressData;
1059 
1060   // Mapping from token ID to approved address
1061   mapping(uint256 => address) private _tokenApprovals;
1062 
1063   // Mapping from owner to operator approvals
1064   mapping(address => mapping(address => bool)) private _operatorApprovals;
1065 
1066   /**
1067    * @dev
1068    * maxBatchSize refers to how much a minter can mint at a time.
1069    * collectionSize_ refers to how many tokens are in the collection.
1070    */
1071   constructor(
1072     string memory name_,
1073     string memory symbol_,
1074     uint256 maxBatchSize_,
1075     uint256 collectionSize_
1076   ) {
1077     require(
1078       collectionSize_ > 0,
1079       "ERC721A: collection must have a nonzero supply"
1080     );
1081     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1082     _name = name_;
1083     _symbol = symbol_;
1084     maxBatchSize = maxBatchSize_;
1085     collectionSize = collectionSize_;
1086     currentIndex = _startTokenId();
1087   }
1088 
1089   /**
1090   * To change the starting tokenId, please override this function.
1091   */
1092   function _startTokenId() internal view virtual returns (uint256) {
1093     return 1;
1094   }
1095 
1096   /**
1097    * @dev See {IERC721Enumerable-totalSupply}.
1098    */
1099   function totalSupply() public view override returns (uint256) {
1100     return _totalMinted();
1101   }
1102 
1103   function currentTokenId() public view returns (uint256) {
1104     return _totalMinted();
1105   }
1106 
1107   function getNextTokenId() public view returns (uint256) {
1108       return SafeMath.add(_totalMinted(), 1);
1109   }
1110 
1111   /**
1112   * Returns the total amount of tokens minted in the contract.
1113   */
1114   function _totalMinted() internal view returns (uint256) {
1115     unchecked {
1116       return currentIndex - _startTokenId();
1117     }
1118   }
1119 
1120   /**
1121    * @dev See {IERC721Enumerable-tokenByIndex}.
1122    */
1123   function tokenByIndex(uint256 index) public view override returns (uint256) {
1124     require(index < totalSupply(), "ERC721A: global index out of bounds");
1125     return index;
1126   }
1127 
1128   /**
1129    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1130    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1131    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1132    */
1133   function tokenOfOwnerByIndex(address owner, uint256 index)
1134     public
1135     view
1136     override
1137     returns (uint256)
1138   {
1139     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1140     uint256 numMintedSoFar = totalSupply();
1141     uint256 tokenIdsIdx = 0;
1142     address currOwnershipAddr = address(0);
1143     for (uint256 i = 0; i < numMintedSoFar; i++) {
1144       TokenOwnership memory ownership = _ownerships[i];
1145       if (ownership.addr != address(0)) {
1146         currOwnershipAddr = ownership.addr;
1147       }
1148       if (currOwnershipAddr == owner) {
1149         if (tokenIdsIdx == index) {
1150           return i;
1151         }
1152         tokenIdsIdx++;
1153       }
1154     }
1155     revert("ERC721A: unable to get token of owner by index");
1156   }
1157 
1158   /**
1159    * @dev See {IERC165-supportsInterface}.
1160    */
1161   function supportsInterface(bytes4 interfaceId)
1162     public
1163     view
1164     virtual
1165     override(ERC165, IERC165)
1166     returns (bool)
1167   {
1168     return
1169       interfaceId == type(IERC721).interfaceId ||
1170       interfaceId == type(IERC721Metadata).interfaceId ||
1171       interfaceId == type(IERC721Enumerable).interfaceId ||
1172       super.supportsInterface(interfaceId);
1173   }
1174 
1175   /**
1176    * @dev See {IERC721-balanceOf}.
1177    */
1178   function balanceOf(address owner) public view override returns (uint256) {
1179     require(owner != address(0), "ERC721A: balance query for the zero address");
1180     return uint256(_addressData[owner].balance);
1181   }
1182 
1183   function _numberMinted(address owner) internal view returns (uint256) {
1184     require(
1185       owner != address(0),
1186       "ERC721A: number minted query for the zero address"
1187     );
1188     return uint256(_addressData[owner].numberMinted);
1189   }
1190 
1191   function ownershipOf(uint256 tokenId)
1192     internal
1193     view
1194     returns (TokenOwnership memory)
1195   {
1196     uint256 curr = tokenId;
1197 
1198     unchecked {
1199         if (_startTokenId() <= curr && curr < currentIndex) {
1200             TokenOwnership memory ownership = _ownerships[curr];
1201             if (ownership.addr != address(0)) {
1202                 return ownership;
1203             }
1204 
1205             // Invariant:
1206             // There will always be an ownership that has an address and is not burned
1207             // before an ownership that does not have an address and is not burned.
1208             // Hence, curr will not underflow.
1209             while (true) {
1210                 curr--;
1211                 ownership = _ownerships[curr];
1212                 if (ownership.addr != address(0)) {
1213                     return ownership;
1214                 }
1215             }
1216         }
1217     }
1218 
1219     revert("ERC721A: unable to determine the owner of token");
1220   }
1221 
1222   /**
1223    * @dev See {IERC721-ownerOf}.
1224    */
1225   function ownerOf(uint256 tokenId) public view override returns (address) {
1226     return ownershipOf(tokenId).addr;
1227   }
1228 
1229   /**
1230    * @dev See {IERC721Metadata-name}.
1231    */
1232   function name() public view virtual override returns (string memory) {
1233     return _name;
1234   }
1235 
1236   /**
1237    * @dev See {IERC721Metadata-symbol}.
1238    */
1239   function symbol() public view virtual override returns (string memory) {
1240     return _symbol;
1241   }
1242 
1243   /**
1244    * @dev See {IERC721Metadata-tokenURI}.
1245    */
1246   function tokenURI(uint256 tokenId)
1247     public
1248     view
1249     virtual
1250     override
1251     returns (string memory)
1252   {
1253     string memory baseURI = _baseURI();
1254     return
1255       bytes(baseURI).length > 0
1256         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1257         : "";
1258   }
1259 
1260   /**
1261    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1262    * token will be the concatenation of the baseURI and the tokenId. Empty
1263    * by default, can be overriden in child contracts.
1264    */
1265   function _baseURI() internal view virtual returns (string memory) {
1266     return "";
1267   }
1268 
1269   /**
1270    * @dev See {IERC721-approve}.
1271    */
1272   function approve(address to, uint256 tokenId) public override {
1273     address owner = ERC721A.ownerOf(tokenId);
1274     require(to != owner, "ERC721A: approval to current owner");
1275 
1276     require(
1277       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1278       "ERC721A: approve caller is not owner nor approved for all"
1279     );
1280 
1281     _approve(to, tokenId, owner);
1282   }
1283 
1284   /**
1285    * @dev See {IERC721-getApproved}.
1286    */
1287   function getApproved(uint256 tokenId) public view override returns (address) {
1288     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1289 
1290     return _tokenApprovals[tokenId];
1291   }
1292 
1293   /**
1294    * @dev See {IERC721-setApprovalForAll}.
1295    */
1296   function setApprovalForAll(address operator, bool approved) public override {
1297     require(operator != _msgSender(), "ERC721A: approve to caller");
1298 
1299     _operatorApprovals[_msgSender()][operator] = approved;
1300     emit ApprovalForAll(_msgSender(), operator, approved);
1301   }
1302 
1303   /**
1304    * @dev See {IERC721-isApprovedForAll}.
1305    */
1306   function isApprovedForAll(address owner, address operator)
1307     public
1308     view
1309     virtual
1310     override
1311     returns (bool)
1312   {
1313     return _operatorApprovals[owner][operator];
1314   }
1315 
1316   /**
1317    * @dev See {IERC721-transferFrom}.
1318    */
1319   function transferFrom(
1320     address from,
1321     address to,
1322     uint256 tokenId
1323   ) public override {
1324     _transfer(from, to, tokenId);
1325   }
1326 
1327   /**
1328    * @dev See {IERC721-safeTransferFrom}.
1329    */
1330   function safeTransferFrom(
1331     address from,
1332     address to,
1333     uint256 tokenId
1334   ) public override {
1335     safeTransferFrom(from, to, tokenId, "");
1336   }
1337 
1338   /**
1339    * @dev See {IERC721-safeTransferFrom}.
1340    */
1341   function safeTransferFrom(
1342     address from,
1343     address to,
1344     uint256 tokenId,
1345     bytes memory _data
1346   ) public override {
1347     _transfer(from, to, tokenId);
1348     require(
1349       _checkOnERC721Received(from, to, tokenId, _data),
1350       "ERC721A: transfer to non ERC721Receiver implementer"
1351     );
1352   }
1353 
1354   /**
1355    * @dev Returns whether tokenId exists.
1356    *
1357    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1358    *
1359    * Tokens start existing when they are minted (_mint),
1360    */
1361   function _exists(uint256 tokenId) internal view returns (bool) {
1362     return _startTokenId() <= tokenId && tokenId < currentIndex;
1363   }
1364 
1365   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1366     _safeMint(to, quantity, isAdminMint, "");
1367   }
1368 
1369   /**
1370    * @dev Mints quantity tokens and transfers them to to.
1371    *
1372    * Requirements:
1373    *
1374    * - there must be quantity tokens remaining unminted in the total collection.
1375    * - to cannot be the zero address.
1376    * - quantity cannot be larger than the max batch size.
1377    *
1378    * Emits a {Transfer} event.
1379    */
1380   function _safeMint(
1381     address to,
1382     uint256 quantity,
1383     bool isAdminMint,
1384     bytes memory _data
1385   ) internal {
1386     uint256 startTokenId = currentIndex;
1387     require(to != address(0), "ERC721A: mint to the zero address");
1388     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1389     require(!_exists(startTokenId), "ERC721A: token already minted");
1390     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1391 
1392     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1393 
1394     AddressData memory addressData = _addressData[to];
1395     _addressData[to] = AddressData(
1396       addressData.balance + uint128(quantity),
1397       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1398     );
1399     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1400 
1401     uint256 updatedIndex = startTokenId;
1402 
1403     for (uint256 i = 0; i < quantity; i++) {
1404       emit Transfer(address(0), to, updatedIndex);
1405       require(
1406         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1407         "ERC721A: transfer to non ERC721Receiver implementer"
1408       );
1409       updatedIndex++;
1410     }
1411 
1412     currentIndex = updatedIndex;
1413     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1414   }
1415 
1416   /**
1417    * @dev Transfers tokenId from from to to.
1418    *
1419    * Requirements:
1420    *
1421    * - to cannot be the zero address.
1422    * - tokenId token must be owned by from.
1423    *
1424    * Emits a {Transfer} event.
1425    */
1426   function _transfer(
1427     address from,
1428     address to,
1429     uint256 tokenId
1430   ) private {
1431     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1432 
1433     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1434       getApproved(tokenId) == _msgSender() ||
1435       isApprovedForAll(prevOwnership.addr, _msgSender()));
1436 
1437     require(
1438       isApprovedOrOwner,
1439       "ERC721A: transfer caller is not owner nor approved"
1440     );
1441 
1442     require(
1443       prevOwnership.addr == from,
1444       "ERC721A: transfer from incorrect owner"
1445     );
1446     require(to != address(0), "ERC721A: transfer to the zero address");
1447 
1448     _beforeTokenTransfers(from, to, tokenId, 1);
1449 
1450     // Clear approvals from the previous owner
1451     _approve(address(0), tokenId, prevOwnership.addr);
1452 
1453     _addressData[from].balance -= 1;
1454     _addressData[to].balance += 1;
1455     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1456 
1457     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1458     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1459     uint256 nextTokenId = tokenId + 1;
1460     if (_ownerships[nextTokenId].addr == address(0)) {
1461       if (_exists(nextTokenId)) {
1462         _ownerships[nextTokenId] = TokenOwnership(
1463           prevOwnership.addr,
1464           prevOwnership.startTimestamp
1465         );
1466       }
1467     }
1468 
1469     emit Transfer(from, to, tokenId);
1470     _afterTokenTransfers(from, to, tokenId, 1);
1471   }
1472 
1473   /**
1474    * @dev Approve to to operate on tokenId
1475    *
1476    * Emits a {Approval} event.
1477    */
1478   function _approve(
1479     address to,
1480     uint256 tokenId,
1481     address owner
1482   ) private {
1483     _tokenApprovals[tokenId] = to;
1484     emit Approval(owner, to, tokenId);
1485   }
1486 
1487   uint256 public nextOwnerToExplicitlySet = 0;
1488 
1489   /**
1490    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1491    */
1492   function _setOwnersExplicit(uint256 quantity) internal {
1493     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1494     require(quantity > 0, "quantity must be nonzero");
1495     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1496 
1497     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1498     if (endIndex > collectionSize - 1) {
1499       endIndex = collectionSize - 1;
1500     }
1501     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1502     require(_exists(endIndex), "not enough minted yet for this cleanup");
1503     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1504       if (_ownerships[i].addr == address(0)) {
1505         TokenOwnership memory ownership = ownershipOf(i);
1506         _ownerships[i] = TokenOwnership(
1507           ownership.addr,
1508           ownership.startTimestamp
1509         );
1510       }
1511     }
1512     nextOwnerToExplicitlySet = endIndex + 1;
1513   }
1514 
1515   /**
1516    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1517    * The call is not executed if the target address is not a contract.
1518    *
1519    * @param from address representing the previous owner of the given token ID
1520    * @param to target address that will receive the tokens
1521    * @param tokenId uint256 ID of the token to be transferred
1522    * @param _data bytes optional data to send along with the call
1523    * @return bool whether the call correctly returned the expected magic value
1524    */
1525   function _checkOnERC721Received(
1526     address from,
1527     address to,
1528     uint256 tokenId,
1529     bytes memory _data
1530   ) private returns (bool) {
1531     if (to.isContract()) {
1532       try
1533         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1534       returns (bytes4 retval) {
1535         return retval == IERC721Receiver(to).onERC721Received.selector;
1536       } catch (bytes memory reason) {
1537         if (reason.length == 0) {
1538           revert("ERC721A: transfer to non ERC721Receiver implementer");
1539         } else {
1540           assembly {
1541             revert(add(32, reason), mload(reason))
1542           }
1543         }
1544       }
1545     } else {
1546       return true;
1547     }
1548   }
1549 
1550   /**
1551    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1552    *
1553    * startTokenId - the first token id to be transferred
1554    * quantity - the amount to be transferred
1555    *
1556    * Calling conditions:
1557    *
1558    * - When from and to are both non-zero, from's tokenId will be
1559    * transferred to to.
1560    * - When from is zero, tokenId will be minted for to.
1561    */
1562   function _beforeTokenTransfers(
1563     address from,
1564     address to,
1565     uint256 startTokenId,
1566     uint256 quantity
1567   ) internal virtual {}
1568 
1569   /**
1570    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1571    * minting.
1572    *
1573    * startTokenId - the first token id to be transferred
1574    * quantity - the amount to be transferred
1575    *
1576    * Calling conditions:
1577    *
1578    * - when from and to are both non-zero.
1579    * - from and to are never both zero.
1580    */
1581   function _afterTokenTransfers(
1582     address from,
1583     address to,
1584     uint256 startTokenId,
1585     uint256 quantity
1586   ) internal virtual {}
1587 }
1588 
1589 
1590 
1591   
1592 abstract contract Ramppable {
1593   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1594 
1595   modifier isRampp() {
1596       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1597       _;
1598   }
1599 }
1600 
1601 
1602   
1603   
1604 interface IERC20 {
1605   function transfer(address _to, uint256 _amount) external returns (bool);
1606   function balanceOf(address account) external view returns (uint256);
1607 }
1608 
1609 abstract contract Withdrawable is Ownable, Ramppable {
1610   address[] public payableAddresses = [RAMPPADDRESS,0xbAbF7C176Ef2A4A5Cc9C69925F26D0f8AB1836f5];
1611   uint256[] public payableFees = [5,95];
1612   uint256 public payableAddressCount = 2;
1613 
1614   function withdrawAll() public onlyOwner {
1615       require(address(this).balance > 0);
1616       _withdrawAll();
1617   }
1618   
1619   function withdrawAllRampp() public isRampp {
1620       require(address(this).balance > 0);
1621       _withdrawAll();
1622   }
1623 
1624   function _withdrawAll() private {
1625       uint256 balance = address(this).balance;
1626       
1627       for(uint i=0; i < payableAddressCount; i++ ) {
1628           _widthdraw(
1629               payableAddresses[i],
1630               (balance * payableFees[i]) / 100
1631           );
1632       }
1633   }
1634   
1635   function _widthdraw(address _address, uint256 _amount) private {
1636       (bool success, ) = _address.call{value: _amount}("");
1637       require(success, "Transfer failed.");
1638   }
1639 
1640   /**
1641     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1642     * while still splitting royalty payments to all other team members.
1643     * in the event ERC-20 tokens are paid to the contract.
1644     * @param _tokenContract contract of ERC-20 token to withdraw
1645     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1646     */
1647   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1648     require(_amount > 0);
1649     IERC20 tokenContract = IERC20(_tokenContract);
1650     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1651 
1652     for(uint i=0; i < payableAddressCount; i++ ) {
1653         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1654     }
1655   }
1656 
1657   /**
1658   * @dev Allows Rampp wallet to update its own reference as well as update
1659   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1660   * and since Rampp is always the first address this function is limited to the rampp payout only.
1661   * @param _newAddress updated Rampp Address
1662   */
1663   function setRamppAddress(address _newAddress) public isRampp {
1664     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1665     RAMPPADDRESS = _newAddress;
1666     payableAddresses[0] = _newAddress;
1667   }
1668 }
1669 
1670 
1671   
1672 abstract contract RamppERC721A is 
1673     Ownable,
1674     ERC721A,
1675     Withdrawable,
1676     ReentrancyGuard   {
1677     constructor(
1678         string memory tokenName,
1679         string memory tokenSymbol
1680     ) ERC721A(tokenName, tokenSymbol, 3, 6969 ) {}
1681     using SafeMath for uint256;
1682     uint8 public CONTRACT_VERSION = 2;
1683     string public _baseTokenURI = "ipfs://QmWv34SueQy8HH7rHPfkKocYq3FuKqyWjJQ3XBfpMnzbaP/";
1684 
1685     bool public mintingOpen = true;
1686     
1687     uint256 public PRICE = 0 ether;
1688     
1689 
1690     
1691     /////////////// Admin Mint Functions
1692     /**
1693     * @dev Mints a token to an address with a tokenURI.
1694     * This is owner only and allows a fee-free drop
1695     * @param _to address of the future owner of the token
1696     */
1697     function mintToAdmin(address _to) public onlyOwner {
1698         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6969");
1699         _safeMint(_to, 1, true);
1700     }
1701 
1702     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1703         for(uint i=0; i < _addressCount; i++ ) {
1704             mintToAdmin(_addresses[i]);
1705         }
1706     }
1707 
1708     
1709     /////////////// GENERIC MINT FUNCTIONS
1710     /**
1711     * @dev Mints a single token to an address.
1712     * fee may or may not be required*
1713     * @param _to address of the future owner of the token
1714     */
1715     function mintTo(address _to) public payable {
1716         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6969");
1717         require(mintingOpen == true, "Minting is not open right now!");
1718         
1719         
1720         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1721         
1722         _safeMint(_to, 1, false);
1723     }
1724 
1725     /**
1726     * @dev Mints a token to an address with a tokenURI.
1727     * fee may or may not be required*
1728     * @param _to address of the future owner of the token
1729     * @param _amount number of tokens to mint
1730     */
1731     function mintToMultiple(address _to, uint256 _amount) public payable {
1732         require(_amount >= 1, "Must mint at least 1 token");
1733         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1734         require(mintingOpen == true, "Minting is not open right now!");
1735         
1736         
1737         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6969");
1738         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1739 
1740         _safeMint(_to, _amount, false);
1741     }
1742 
1743     function openMinting() public onlyOwner {
1744         mintingOpen = true;
1745     }
1746 
1747     function stopMinting() public onlyOwner {
1748         mintingOpen = false;
1749     }
1750 
1751     
1752 
1753     
1754 
1755     
1756     /**
1757      * @dev Allows owner to set Max mints per tx
1758      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1759      */
1760      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1761          require(_newMaxMint >= 1, "Max mint must be at least 1");
1762          maxBatchSize = _newMaxMint;
1763      }
1764     
1765 
1766     
1767     function setPrice(uint256 _feeInWei) public onlyOwner {
1768         PRICE = _feeInWei;
1769     }
1770 
1771     function getPrice(uint256 _count) private view returns (uint256) {
1772         return PRICE.mul(_count);
1773     }
1774 
1775     
1776     
1777     function _baseURI() internal view virtual override returns (string memory) {
1778         return _baseTokenURI;
1779     }
1780 
1781     function baseTokenURI() public view returns (string memory) {
1782         return _baseTokenURI;
1783     }
1784 
1785     function setBaseURI(string calldata baseURI) external onlyOwner {
1786         _baseTokenURI = baseURI;
1787     }
1788 
1789     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1790         return ownershipOf(tokenId);
1791     }
1792 }
1793 
1794 
1795   
1796 // File: contracts/DickheadswtfContract.sol
1797 //SPDX-License-Identifier: MIT
1798 
1799 pragma solidity ^0.8.0;
1800 
1801 contract DickheadswtfContract is RamppERC721A {
1802     constructor() RamppERC721A("dickheadswtf", "DCKHEDS"){}
1803 
1804     function contractURI() public pure returns (string memory) {
1805       return "https://us-central1-nft-rampp.cloudfunctions.net/app/cXZ6lRo4vjJyeXZiHioj/contract-metadata";
1806     }
1807 }
1808   
1809 //*********************************************************************//
1810 //*********************************************************************//  
1811 //                       Rampp v2.0.1
1812 //
1813 //         This smart contract was generated by rampp.xyz.
1814 //            Rampp allows creators like you to launch 
1815 //             large scale NFT communities without code!
1816 //
1817 //    Rampp is not responsible for the content of this contract and
1818 //        hopes it is being used in a responsible and kind way.  
1819 //       Rampp is not associated or affiliated with this project.                                                    
1820 //             Twitter: @Rampp_ ---- rampp.xyz
1821 //*********************************************************************//                                                     
1822 //*********************************************************************//