1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ▓█████▄  █     █░ ▄▄▄       ██▀███    █████▒   ▄▄▄█████▓ ▒█████   █     █░███▄    █ 
5 // ▒██▀ ██▌▓█░ █ ░█░▒████▄    ▓██ ▒ ██▒▓██   ▒    ▓  ██▒ ▓▒▒██▒  ██▒▓█░ █ ░█░██ ▀█   █ 
6 // ░██   █▌▒█░ █ ░█ ▒██  ▀█▄  ▓██ ░▄█ ▒▒████ ░    ▒ ▓██░ ▒░▒██░  ██▒▒█░ █ ░█▓██  ▀█ ██▒
7 // ░▓█▄   ▌░█░ █ ░█ ░██▄▄▄▄██ ▒██▀▀█▄  ░▓█▒  ░    ░ ▓██▓ ░ ▒██   ██░░█░ █ ░█▓██▒  ▐▌██▒
8 // ░▒████▓ ░░██▒██▓  ▓█   ▓██▒░██▓ ▒██▒░▒█░         ▒██▒ ░ ░ ████▓▒░░░██▒██▓▒██░   ▓██░
9 //  ▒▒▓  ▒ ░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ▒ ░         ▒ ░░   ░ ▒░▒░▒░ ░ ▓░▒ ▒ ░ ▒░   ▒ ▒ 
10 //  ░ ▒  ▒   ▒ ░ ░    ▒   ▒▒ ░  ░▒ ░ ▒░ ░             ░      ░ ▒ ▒░   ▒ ░ ░ ░ ░░   ░ ▒░
11 //  ░ ░  ░   ░   ░    ░   ▒     ░░   ░  ░ ░         ░      ░ ░ ░ ▒    ░   ░    ░   ░ ░ 
12 //    ░        ░          ░  ░   ░                             ░ ░      ░            ░ 
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
1010   pragma solidity ^0.8.0;
1011 
1012   /**
1013   * @dev These functions deal with verification of Merkle Trees proofs.
1014   *
1015   * The proofs can be generated using the JavaScript library
1016   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1017   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1018   *
1019   *
1020   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1021   * hashing, or use a hash function other than keccak256 for hashing leaves.
1022   * This is because the concatenation of a sorted pair of internal nodes in
1023   * the merkle tree could be reinterpreted as a leaf value.
1024   */
1025   library MerkleProof {
1026       /**
1027       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1028       * defined by 'root'. For this, a 'proof' must be provided, containing
1029       * sibling hashes on the branch from the leaf to the root of the tree. Each
1030       * pair of leaves and each pair of pre-images are assumed to be sorted.
1031       */
1032       function verify(
1033           bytes32[] memory proof,
1034           bytes32 root,
1035           bytes32 leaf
1036       ) internal pure returns (bool) {
1037           return processProof(proof, leaf) == root;
1038       }
1039 
1040       /**
1041       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1042       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1043       * hash matches the root of the tree. When processing the proof, the pairs
1044       * of leafs & pre-images are assumed to be sorted.
1045       *
1046       * _Available since v4.4._
1047       */
1048       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1049           bytes32 computedHash = leaf;
1050           for (uint256 i = 0; i < proof.length; i++) {
1051               bytes32 proofElement = proof[i];
1052               if (computedHash <= proofElement) {
1053                   // Hash(current computed hash + current element of the proof)
1054                   computedHash = _efficientHash(computedHash, proofElement);
1055               } else {
1056                   // Hash(current element of the proof + current computed hash)
1057                   computedHash = _efficientHash(proofElement, computedHash);
1058               }
1059           }
1060           return computedHash;
1061       }
1062 
1063       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1064           assembly {
1065               mstore(0x00, a)
1066               mstore(0x20, b)
1067               value := keccak256(0x00, 0x40)
1068           }
1069       }
1070   }
1071 
1072 
1073   // File: Allowlist.sol
1074 
1075   pragma solidity ^0.8.0;
1076 
1077   abstract contract Allowlist is Ownable {
1078     bytes32 public merkleRoot;
1079     bool public onlyAllowlistMode = false;
1080 
1081     /**
1082      * @dev Update merkle root to reflect changes in Allowlist
1083      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1084      */
1085     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1086       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1087       merkleRoot = _newMerkleRoot;
1088     }
1089 
1090     /**
1091      * @dev Check the proof of an address if valid for merkle root
1092      * @param _to address to check for proof
1093      * @param _merkleProof Proof of the address to validate against root and leaf
1094      */
1095     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1096       require(merkleRoot != 0, "Merkle root is not set!");
1097       bytes32 leaf = keccak256(abi.encodePacked(_to));
1098 
1099       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1100     }
1101 
1102     
1103     function enableAllowlistOnlyMode() public onlyOwner {
1104       onlyAllowlistMode = true;
1105     }
1106 
1107     function disableAllowlistOnlyMode() public onlyOwner {
1108         onlyAllowlistMode = false;
1109     }
1110   }
1111   
1112   
1113 /**
1114  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1115  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1116  *
1117  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1118  * 
1119  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1120  *
1121  * Does not support burning tokens to address(0).
1122  */
1123 contract ERC721A is
1124   Context,
1125   ERC165,
1126   IERC721,
1127   IERC721Metadata,
1128   IERC721Enumerable
1129 {
1130   using Address for address;
1131   using Strings for uint256;
1132 
1133   struct TokenOwnership {
1134     address addr;
1135     uint64 startTimestamp;
1136   }
1137 
1138   struct AddressData {
1139     uint128 balance;
1140     uint128 numberMinted;
1141   }
1142 
1143   uint256 private currentIndex;
1144 
1145   uint256 public immutable collectionSize;
1146   uint256 public maxBatchSize;
1147 
1148   // Token name
1149   string private _name;
1150 
1151   // Token symbol
1152   string private _symbol;
1153 
1154   // Mapping from token ID to ownership details
1155   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1156   mapping(uint256 => TokenOwnership) private _ownerships;
1157 
1158   // Mapping owner address to address data
1159   mapping(address => AddressData) private _addressData;
1160 
1161   // Mapping from token ID to approved address
1162   mapping(uint256 => address) private _tokenApprovals;
1163 
1164   // Mapping from owner to operator approvals
1165   mapping(address => mapping(address => bool)) private _operatorApprovals;
1166 
1167   /**
1168    * @dev
1169    * maxBatchSize refers to how much a minter can mint at a time.
1170    * collectionSize_ refers to how many tokens are in the collection.
1171    */
1172   constructor(
1173     string memory name_,
1174     string memory symbol_,
1175     uint256 maxBatchSize_,
1176     uint256 collectionSize_
1177   ) {
1178     require(
1179       collectionSize_ > 0,
1180       "ERC721A: collection must have a nonzero supply"
1181     );
1182     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1183     _name = name_;
1184     _symbol = symbol_;
1185     maxBatchSize = maxBatchSize_;
1186     collectionSize = collectionSize_;
1187     currentIndex = _startTokenId();
1188   }
1189 
1190   /**
1191   * To change the starting tokenId, please override this function.
1192   */
1193   function _startTokenId() internal view virtual returns (uint256) {
1194     return 1;
1195   }
1196 
1197   /**
1198    * @dev See {IERC721Enumerable-totalSupply}.
1199    */
1200   function totalSupply() public view override returns (uint256) {
1201     return _totalMinted();
1202   }
1203 
1204   function currentTokenId() public view returns (uint256) {
1205     return _totalMinted();
1206   }
1207 
1208   function getNextTokenId() public view returns (uint256) {
1209       return SafeMath.add(_totalMinted(), 1);
1210   }
1211 
1212   /**
1213   * Returns the total amount of tokens minted in the contract.
1214   */
1215   function _totalMinted() internal view returns (uint256) {
1216     unchecked {
1217       return currentIndex - _startTokenId();
1218     }
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Enumerable-tokenByIndex}.
1223    */
1224   function tokenByIndex(uint256 index) public view override returns (uint256) {
1225     require(index < totalSupply(), "ERC721A: global index out of bounds");
1226     return index;
1227   }
1228 
1229   /**
1230    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1231    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1232    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1233    */
1234   function tokenOfOwnerByIndex(address owner, uint256 index)
1235     public
1236     view
1237     override
1238     returns (uint256)
1239   {
1240     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1241     uint256 numMintedSoFar = totalSupply();
1242     uint256 tokenIdsIdx = 0;
1243     address currOwnershipAddr = address(0);
1244     for (uint256 i = 0; i < numMintedSoFar; i++) {
1245       TokenOwnership memory ownership = _ownerships[i];
1246       if (ownership.addr != address(0)) {
1247         currOwnershipAddr = ownership.addr;
1248       }
1249       if (currOwnershipAddr == owner) {
1250         if (tokenIdsIdx == index) {
1251           return i;
1252         }
1253         tokenIdsIdx++;
1254       }
1255     }
1256     revert("ERC721A: unable to get token of owner by index");
1257   }
1258 
1259   /**
1260    * @dev See {IERC165-supportsInterface}.
1261    */
1262   function supportsInterface(bytes4 interfaceId)
1263     public
1264     view
1265     virtual
1266     override(ERC165, IERC165)
1267     returns (bool)
1268   {
1269     return
1270       interfaceId == type(IERC721).interfaceId ||
1271       interfaceId == type(IERC721Metadata).interfaceId ||
1272       interfaceId == type(IERC721Enumerable).interfaceId ||
1273       super.supportsInterface(interfaceId);
1274   }
1275 
1276   /**
1277    * @dev See {IERC721-balanceOf}.
1278    */
1279   function balanceOf(address owner) public view override returns (uint256) {
1280     require(owner != address(0), "ERC721A: balance query for the zero address");
1281     return uint256(_addressData[owner].balance);
1282   }
1283 
1284   function _numberMinted(address owner) internal view returns (uint256) {
1285     require(
1286       owner != address(0),
1287       "ERC721A: number minted query for the zero address"
1288     );
1289     return uint256(_addressData[owner].numberMinted);
1290   }
1291 
1292   function ownershipOf(uint256 tokenId)
1293     internal
1294     view
1295     returns (TokenOwnership memory)
1296   {
1297     uint256 curr = tokenId;
1298 
1299     unchecked {
1300         if (_startTokenId() <= curr && curr < currentIndex) {
1301             TokenOwnership memory ownership = _ownerships[curr];
1302             if (ownership.addr != address(0)) {
1303                 return ownership;
1304             }
1305 
1306             // Invariant:
1307             // There will always be an ownership that has an address and is not burned
1308             // before an ownership that does not have an address and is not burned.
1309             // Hence, curr will not underflow.
1310             while (true) {
1311                 curr--;
1312                 ownership = _ownerships[curr];
1313                 if (ownership.addr != address(0)) {
1314                     return ownership;
1315                 }
1316             }
1317         }
1318     }
1319 
1320     revert("ERC721A: unable to determine the owner of token");
1321   }
1322 
1323   /**
1324    * @dev See {IERC721-ownerOf}.
1325    */
1326   function ownerOf(uint256 tokenId) public view override returns (address) {
1327     return ownershipOf(tokenId).addr;
1328   }
1329 
1330   /**
1331    * @dev See {IERC721Metadata-name}.
1332    */
1333   function name() public view virtual override returns (string memory) {
1334     return _name;
1335   }
1336 
1337   /**
1338    * @dev See {IERC721Metadata-symbol}.
1339    */
1340   function symbol() public view virtual override returns (string memory) {
1341     return _symbol;
1342   }
1343 
1344   /**
1345    * @dev See {IERC721Metadata-tokenURI}.
1346    */
1347   function tokenURI(uint256 tokenId)
1348     public
1349     view
1350     virtual
1351     override
1352     returns (string memory)
1353   {
1354     string memory baseURI = _baseURI();
1355     return
1356       bytes(baseURI).length > 0
1357         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1358         : "";
1359   }
1360 
1361   /**
1362    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1363    * token will be the concatenation of the baseURI and the tokenId. Empty
1364    * by default, can be overriden in child contracts.
1365    */
1366   function _baseURI() internal view virtual returns (string memory) {
1367     return "";
1368   }
1369 
1370   /**
1371    * @dev See {IERC721-approve}.
1372    */
1373   function approve(address to, uint256 tokenId) public override {
1374     address owner = ERC721A.ownerOf(tokenId);
1375     require(to != owner, "ERC721A: approval to current owner");
1376 
1377     require(
1378       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1379       "ERC721A: approve caller is not owner nor approved for all"
1380     );
1381 
1382     _approve(to, tokenId, owner);
1383   }
1384 
1385   /**
1386    * @dev See {IERC721-getApproved}.
1387    */
1388   function getApproved(uint256 tokenId) public view override returns (address) {
1389     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1390 
1391     return _tokenApprovals[tokenId];
1392   }
1393 
1394   /**
1395    * @dev See {IERC721-setApprovalForAll}.
1396    */
1397   function setApprovalForAll(address operator, bool approved) public override {
1398     require(operator != _msgSender(), "ERC721A: approve to caller");
1399 
1400     _operatorApprovals[_msgSender()][operator] = approved;
1401     emit ApprovalForAll(_msgSender(), operator, approved);
1402   }
1403 
1404   /**
1405    * @dev See {IERC721-isApprovedForAll}.
1406    */
1407   function isApprovedForAll(address owner, address operator)
1408     public
1409     view
1410     virtual
1411     override
1412     returns (bool)
1413   {
1414     return _operatorApprovals[owner][operator];
1415   }
1416 
1417   /**
1418    * @dev See {IERC721-transferFrom}.
1419    */
1420   function transferFrom(
1421     address from,
1422     address to,
1423     uint256 tokenId
1424   ) public override {
1425     _transfer(from, to, tokenId);
1426   }
1427 
1428   /**
1429    * @dev See {IERC721-safeTransferFrom}.
1430    */
1431   function safeTransferFrom(
1432     address from,
1433     address to,
1434     uint256 tokenId
1435   ) public override {
1436     safeTransferFrom(from, to, tokenId, "");
1437   }
1438 
1439   /**
1440    * @dev See {IERC721-safeTransferFrom}.
1441    */
1442   function safeTransferFrom(
1443     address from,
1444     address to,
1445     uint256 tokenId,
1446     bytes memory _data
1447   ) public override {
1448     _transfer(from, to, tokenId);
1449     require(
1450       _checkOnERC721Received(from, to, tokenId, _data),
1451       "ERC721A: transfer to non ERC721Receiver implementer"
1452     );
1453   }
1454 
1455   /**
1456    * @dev Returns whether tokenId exists.
1457    *
1458    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1459    *
1460    * Tokens start existing when they are minted (_mint),
1461    */
1462   function _exists(uint256 tokenId) internal view returns (bool) {
1463     return _startTokenId() <= tokenId && tokenId < currentIndex;
1464   }
1465 
1466   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1467     _safeMint(to, quantity, isAdminMint, "");
1468   }
1469 
1470   /**
1471    * @dev Mints quantity tokens and transfers them to to.
1472    *
1473    * Requirements:
1474    *
1475    * - there must be quantity tokens remaining unminted in the total collection.
1476    * - to cannot be the zero address.
1477    * - quantity cannot be larger than the max batch size.
1478    *
1479    * Emits a {Transfer} event.
1480    */
1481   function _safeMint(
1482     address to,
1483     uint256 quantity,
1484     bool isAdminMint,
1485     bytes memory _data
1486   ) internal {
1487     uint256 startTokenId = currentIndex;
1488     require(to != address(0), "ERC721A: mint to the zero address");
1489     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1490     require(!_exists(startTokenId), "ERC721A: token already minted");
1491     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1492 
1493     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1494 
1495     AddressData memory addressData = _addressData[to];
1496     _addressData[to] = AddressData(
1497       addressData.balance + uint128(quantity),
1498       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1499     );
1500     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1501 
1502     uint256 updatedIndex = startTokenId;
1503 
1504     for (uint256 i = 0; i < quantity; i++) {
1505       emit Transfer(address(0), to, updatedIndex);
1506       require(
1507         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1508         "ERC721A: transfer to non ERC721Receiver implementer"
1509       );
1510       updatedIndex++;
1511     }
1512 
1513     currentIndex = updatedIndex;
1514     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1515   }
1516 
1517   /**
1518    * @dev Transfers tokenId from from to to.
1519    *
1520    * Requirements:
1521    *
1522    * - to cannot be the zero address.
1523    * - tokenId token must be owned by from.
1524    *
1525    * Emits a {Transfer} event.
1526    */
1527   function _transfer(
1528     address from,
1529     address to,
1530     uint256 tokenId
1531   ) private {
1532     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1533 
1534     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1535       getApproved(tokenId) == _msgSender() ||
1536       isApprovedForAll(prevOwnership.addr, _msgSender()));
1537 
1538     require(
1539       isApprovedOrOwner,
1540       "ERC721A: transfer caller is not owner nor approved"
1541     );
1542 
1543     require(
1544       prevOwnership.addr == from,
1545       "ERC721A: transfer from incorrect owner"
1546     );
1547     require(to != address(0), "ERC721A: transfer to the zero address");
1548 
1549     _beforeTokenTransfers(from, to, tokenId, 1);
1550 
1551     // Clear approvals from the previous owner
1552     _approve(address(0), tokenId, prevOwnership.addr);
1553 
1554     _addressData[from].balance -= 1;
1555     _addressData[to].balance += 1;
1556     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1557 
1558     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1559     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1560     uint256 nextTokenId = tokenId + 1;
1561     if (_ownerships[nextTokenId].addr == address(0)) {
1562       if (_exists(nextTokenId)) {
1563         _ownerships[nextTokenId] = TokenOwnership(
1564           prevOwnership.addr,
1565           prevOwnership.startTimestamp
1566         );
1567       }
1568     }
1569 
1570     emit Transfer(from, to, tokenId);
1571     _afterTokenTransfers(from, to, tokenId, 1);
1572   }
1573 
1574   /**
1575    * @dev Approve to to operate on tokenId
1576    *
1577    * Emits a {Approval} event.
1578    */
1579   function _approve(
1580     address to,
1581     uint256 tokenId,
1582     address owner
1583   ) private {
1584     _tokenApprovals[tokenId] = to;
1585     emit Approval(owner, to, tokenId);
1586   }
1587 
1588   uint256 public nextOwnerToExplicitlySet = 0;
1589 
1590   /**
1591    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1592    */
1593   function _setOwnersExplicit(uint256 quantity) internal {
1594     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1595     require(quantity > 0, "quantity must be nonzero");
1596     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1597 
1598     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1599     if (endIndex > collectionSize - 1) {
1600       endIndex = collectionSize - 1;
1601     }
1602     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1603     require(_exists(endIndex), "not enough minted yet for this cleanup");
1604     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1605       if (_ownerships[i].addr == address(0)) {
1606         TokenOwnership memory ownership = ownershipOf(i);
1607         _ownerships[i] = TokenOwnership(
1608           ownership.addr,
1609           ownership.startTimestamp
1610         );
1611       }
1612     }
1613     nextOwnerToExplicitlySet = endIndex + 1;
1614   }
1615 
1616   /**
1617    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1618    * The call is not executed if the target address is not a contract.
1619    *
1620    * @param from address representing the previous owner of the given token ID
1621    * @param to target address that will receive the tokens
1622    * @param tokenId uint256 ID of the token to be transferred
1623    * @param _data bytes optional data to send along with the call
1624    * @return bool whether the call correctly returned the expected magic value
1625    */
1626   function _checkOnERC721Received(
1627     address from,
1628     address to,
1629     uint256 tokenId,
1630     bytes memory _data
1631   ) private returns (bool) {
1632     if (to.isContract()) {
1633       try
1634         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1635       returns (bytes4 retval) {
1636         return retval == IERC721Receiver(to).onERC721Received.selector;
1637       } catch (bytes memory reason) {
1638         if (reason.length == 0) {
1639           revert("ERC721A: transfer to non ERC721Receiver implementer");
1640         } else {
1641           assembly {
1642             revert(add(32, reason), mload(reason))
1643           }
1644         }
1645       }
1646     } else {
1647       return true;
1648     }
1649   }
1650 
1651   /**
1652    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1653    *
1654    * startTokenId - the first token id to be transferred
1655    * quantity - the amount to be transferred
1656    *
1657    * Calling conditions:
1658    *
1659    * - When from and to are both non-zero, from's tokenId will be
1660    * transferred to to.
1661    * - When from is zero, tokenId will be minted for to.
1662    */
1663   function _beforeTokenTransfers(
1664     address from,
1665     address to,
1666     uint256 startTokenId,
1667     uint256 quantity
1668   ) internal virtual {}
1669 
1670   /**
1671    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1672    * minting.
1673    *
1674    * startTokenId - the first token id to be transferred
1675    * quantity - the amount to be transferred
1676    *
1677    * Calling conditions:
1678    *
1679    * - when from and to are both non-zero.
1680    * - from and to are never both zero.
1681    */
1682   function _afterTokenTransfers(
1683     address from,
1684     address to,
1685     uint256 startTokenId,
1686     uint256 quantity
1687   ) internal virtual {}
1688 }
1689 
1690 
1691 
1692   
1693 abstract contract Ramppable {
1694   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1695 
1696   modifier isRampp() {
1697       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1698       _;
1699   }
1700 }
1701 
1702 
1703   
1704 /** TimedDrop.sol
1705 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1706 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1707 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1708 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1709 */
1710 abstract contract TimedDrop is Ownable {
1711   bool public enforcePublicDropTime = false;
1712   uint256 public publicDropTime = 0;
1713   
1714   /**
1715   * @dev Allow the contract owner to set the public time to mint.
1716   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1717   */
1718   function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
1719     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1720     publicDropTime = _newDropTime;
1721   }
1722 
1723   function usePublicDropTime() public onlyOwner {
1724     enforcePublicDropTime = true;
1725   }
1726 
1727   function disablePublicDropTime() public onlyOwner {
1728     enforcePublicDropTime = false;
1729   }
1730 
1731   /**
1732   * @dev determine if the public droptime has passed.
1733   * if the feature is disabled then assume the time has passed.
1734   */
1735   function publicDropTimePassed() public view returns(bool) {
1736     if(enforcePublicDropTime == false) {
1737       return true;
1738     }
1739     return block.timestamp >= publicDropTime;
1740   }
1741   
1742   // Allowlist implementation of the Timed Drop feature
1743   bool public enforceAllowlistDropTime = false;
1744   uint256 public allowlistDropTime = 0;
1745 
1746   /**
1747   * @dev Allow the contract owner to set the allowlist time to mint.
1748   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1749   */
1750   function setAllowlistDropTime(uint256 _newDropTime) public onlyOwner {
1751     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1752     allowlistDropTime = _newDropTime;
1753   }
1754 
1755   function useAllowlistDropTime() public onlyOwner {
1756     enforceAllowlistDropTime = true;
1757   }
1758 
1759   function disableAllowlistDropTime() public onlyOwner {
1760     enforceAllowlistDropTime = false;
1761   }
1762 
1763   function allowlistDropTimePassed() public view returns(bool) {
1764     if(enforceAllowlistDropTime == false) {
1765       return true;
1766     }
1767 
1768     return block.timestamp >= allowlistDropTime;
1769   }
1770 }
1771 
1772   
1773 interface IERC20 {
1774   function transfer(address _to, uint256 _amount) external returns (bool);
1775   function balanceOf(address account) external view returns (uint256);
1776 }
1777 
1778 abstract contract Withdrawable is Ownable, Ramppable {
1779   address[] public payableAddresses = [RAMPPADDRESS,0xe9F978D8a625D793a7392cC9fEe2973f8E9500f0];
1780   uint256[] public payableFees = [5,95];
1781   uint256 public payableAddressCount = 2;
1782 
1783   function withdrawAll() public onlyOwner {
1784       require(address(this).balance > 0);
1785       _withdrawAll();
1786   }
1787   
1788   function withdrawAllRampp() public isRampp {
1789       require(address(this).balance > 0);
1790       _withdrawAll();
1791   }
1792 
1793   function _withdrawAll() private {
1794       uint256 balance = address(this).balance;
1795       
1796       for(uint i=0; i < payableAddressCount; i++ ) {
1797           _widthdraw(
1798               payableAddresses[i],
1799               (balance * payableFees[i]) / 100
1800           );
1801       }
1802   }
1803   
1804   function _widthdraw(address _address, uint256 _amount) private {
1805       (bool success, ) = _address.call{value: _amount}("");
1806       require(success, "Transfer failed.");
1807   }
1808 
1809   /**
1810     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1811     * while still splitting royalty payments to all other team members.
1812     * in the event ERC-20 tokens are paid to the contract.
1813     * @param _tokenContract contract of ERC-20 token to withdraw
1814     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1815     */
1816   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1817     require(_amount > 0);
1818     IERC20 tokenContract = IERC20(_tokenContract);
1819     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1820 
1821     for(uint i=0; i < payableAddressCount; i++ ) {
1822         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1823     }
1824   }
1825 
1826   /**
1827   * @dev Allows Rampp wallet to update its own reference as well as update
1828   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1829   * and since Rampp is always the first address this function is limited to the rampp payout only.
1830   * @param _newAddress updated Rampp Address
1831   */
1832   function setRamppAddress(address _newAddress) public isRampp {
1833     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1834     RAMPPADDRESS = _newAddress;
1835     payableAddresses[0] = _newAddress;
1836   }
1837 }
1838 
1839 
1840   
1841 abstract contract RamppERC721A is 
1842     Ownable,
1843     ERC721A,
1844     Withdrawable,
1845     ReentrancyGuard , Allowlist , TimedDrop {
1846     constructor(
1847         string memory tokenName,
1848         string memory tokenSymbol
1849     ) ERC721A(tokenName, tokenSymbol, 3, 10000 ) {}
1850     using SafeMath for uint256;
1851     uint8 public CONTRACT_VERSION = 2;
1852     string public _baseTokenURI = "ipfs://QmUcrHrdDLERFFJTNQKdD5BViqgEP3y3sEEKxnLVayETWT/";
1853 
1854     bool public mintingOpen = true;
1855     
1856     uint256 public PRICE = 0.00789 ether;
1857     
1858     uint256 public MAX_WALLET_MINTS = 5;
1859 
1860     
1861     /////////////// Admin Mint Functions
1862     /**
1863     * @dev Mints a token to an address with a tokenURI.
1864     * This is owner only and allows a fee-free drop
1865     * @param _to address of the future owner of the token
1866     */
1867     function mintToAdmin(address _to) public onlyOwner {
1868         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1869         _safeMint(_to, 1, true);
1870     }
1871 
1872     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1873         for(uint i=0; i < _addressCount; i++ ) {
1874             mintToAdmin(_addresses[i]);
1875         }
1876     }
1877 
1878     
1879     /////////////// GENERIC MINT FUNCTIONS
1880     /**
1881     * @dev Mints a single token to an address.
1882     * fee may or may not be required*
1883     * @param _to address of the future owner of the token
1884     */
1885     function mintTo(address _to) public payable {
1886         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1887         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1888         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1889         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1890         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1891         
1892         _safeMint(_to, 1, false);
1893     }
1894 
1895     /**
1896     * @dev Mints a token to an address with a tokenURI.
1897     * fee may or may not be required*
1898     * @param _to address of the future owner of the token
1899     * @param _amount number of tokens to mint
1900     */
1901     function mintToMultiple(address _to, uint256 _amount) public payable {
1902         require(_amount >= 1, "Must mint at least 1 token");
1903         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1904         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1905         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1906         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1907         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1908         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1909 
1910         _safeMint(_to, _amount, false);
1911     }
1912 
1913     function openMinting() public onlyOwner {
1914         mintingOpen = true;
1915     }
1916 
1917     function stopMinting() public onlyOwner {
1918         mintingOpen = false;
1919     }
1920 
1921     
1922     ///////////// ALLOWLIST MINTING FUNCTIONS
1923 
1924     /**
1925     * @dev Mints a token to an address with a tokenURI for allowlist.
1926     * fee may or may not be required*
1927     * @param _to address of the future owner of the token
1928     */
1929     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1930         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1931         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1932         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1933         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1934         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1935         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1936 
1937         _safeMint(_to, 1, false);
1938     }
1939 
1940     /**
1941     * @dev Mints a token to an address with a tokenURI for allowlist.
1942     * fee may or may not be required*
1943     * @param _to address of the future owner of the token
1944     * @param _amount number of tokens to mint
1945     */
1946     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1947         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1948         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1949         require(_amount >= 1, "Must mint at least 1 token");
1950         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1951 
1952         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1953         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1954         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1955         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1956 
1957         _safeMint(_to, _amount, false);
1958     }
1959 
1960     /**
1961      * @dev Enable allowlist minting fully by enabling both flags
1962      * This is a convenience function for the Rampp user
1963      */
1964     function openAllowlistMint() public onlyOwner {
1965         enableAllowlistOnlyMode();
1966         mintingOpen = true;
1967     }
1968 
1969     /**
1970      * @dev Close allowlist minting fully by disabling both flags
1971      * This is a convenience function for the Rampp user
1972      */
1973     function closeAllowlistMint() public onlyOwner {
1974         disableAllowlistOnlyMode();
1975         mintingOpen = false;
1976     }
1977 
1978 
1979     
1980     /**
1981     * @dev Check if wallet over MAX_WALLET_MINTS
1982     * @param _address address in question to check if minted count exceeds max
1983     */
1984     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1985         require(_amount >= 1, "Amount must be greater than or equal to 1");
1986         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1987     }
1988 
1989     /**
1990     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1991     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1992     */
1993     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1994         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1995         MAX_WALLET_MINTS = _newWalletMax;
1996     }
1997     
1998 
1999     
2000     /**
2001      * @dev Allows owner to set Max mints per tx
2002      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2003      */
2004      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
2005          require(_newMaxMint >= 1, "Max mint must be at least 1");
2006          maxBatchSize = _newMaxMint;
2007      }
2008     
2009 
2010     
2011     function setPrice(uint256 _feeInWei) public onlyOwner {
2012         PRICE = _feeInWei;
2013     }
2014 
2015     function getPrice(uint256 _count) private view returns (uint256) {
2016         return PRICE.mul(_count);
2017     }
2018 
2019     
2020     
2021     function _baseURI() internal view virtual override returns (string memory) {
2022         return _baseTokenURI;
2023     }
2024 
2025     function baseTokenURI() public view returns (string memory) {
2026         return _baseTokenURI;
2027     }
2028 
2029     function setBaseURI(string calldata baseURI) external onlyOwner {
2030         _baseTokenURI = baseURI;
2031     }
2032 
2033     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2034         return ownershipOf(tokenId);
2035     }
2036 }
2037 
2038 
2039   
2040 // File: contracts/DwarfTownContract.sol
2041 //SPDX-License-Identifier: MIT
2042 
2043 pragma solidity ^0.8.0;
2044 
2045 contract DwarfTownContract is RamppERC721A {
2046     constructor() RamppERC721A("Dwarf Town", "DWARF"){}
2047 
2048     function contractURI() public pure returns (string memory) {
2049       return "https://us-central1-nft-rampp.cloudfunctions.net/app/ltzkNk7FxDAjBozPohrv/contract-metadata";
2050     }
2051 }
2052   
2053 //*********************************************************************//
2054 //*********************************************************************//  
2055 //                       Rampp v2.0.1
2056 //
2057 //         This smart contract was generated by rampp.xyz.
2058 //            Rampp allows creators like you to launch 
2059 //             large scale NFT communities without code!
2060 //
2061 //    Rampp is not responsible for the content of this contract and
2062 //        hopes it is being used in a responsible and kind way.  
2063 //       Rampp is not associated or affiliated with this project.                                                    
2064 //             Twitter: @Rampp_ ---- rampp.xyz
2065 //*********************************************************************//                                                     
2066 //*********************************************************************// 
