1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //      
6 //      
7 //      
8 //      
9 //      
10 //      
11 //      
12 //      
13 //      
14 //      
15 //      
16 //      
17 //      
18 //      
19 //      
20 //      
21 //      
22 //      
23 //      
24 //            █▀▀██▄▄▄▄▄       ▄                                    ▄▄      █▀███████═     ▄██▀█▀▀██─
25 //           ┌█   ╔  ▀ ██╖    █▄▀█─    █▀▀▀▀▀▀▀█      █▀▀▀▀▀▀▌▄    █▄▀▀▄   █▀ ▄ ┌▄▄ ██    ▄█  ▄██▄ ╙█
26 //           █▄▄┌┌███   ▐█   ▐▌ └▀█    █  ███▌ ┌█▌    █╝╙└██▄ ▀█   █  ▀█   ▐█▀▀ █▀▀█▀█▄   ██─▀▀▀█████
27 //           ▐█  ▀▄▄▀╨─└██   ▐█  ╙█    █╙═▀╧╚ ▄██╛    █  ╓██▌  █▌  █  └█╤   █   ▄▄████▌  ╓████▄╒   ▀█
28 //           █▌   ███▀  ▐█    █   █   ╒█  ███▀ ▀█     █▄  ▀█▀  █▌  █▄┌ █─  █▌  ▀▀██████  ▐▌▄▄████▄▐▀▀█
29 //           ▐█─╝▀ ▀▀  ▌██    █▄█▌█▄   ████▄▀████▌    █▄▐███████   █████▌  █▄██▄▄▄▄▄▄██   █▌▄ ╨▀█  ▄█▀
30 //           █▄  ▌██████▀╨    ▀█▀▀▀    ▀▀▀╛  ╚▀▀▀     └▀▀▀▀▀▀▀╙    └▀╙└╝   ╙▀▀▀▀▀██▀▀█▀   ▐█████████▀
31 //           ╙███▀▀▀▀╙                                                                       └└╝▀└
32 //      
33 //      
34 //      
35 //      
36 //      
37 //      
38 //      
39 //      
40 //      
41 //      
42 //      
43 //      
44 //      
45 //      
46 //      
47 //      
48 //      
49 //      
50 //      
51 //      
52 //      
53 //      
54 //      
55 //     
56 // ---
57 //
58 //
59 //
60 //
61 //
62 //*********************************************************************//
63 //*********************************************************************//
64   
65 //-------------DEPENDENCIES--------------------------//
66 
67 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
68 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 // CAUTION
73 // This version of SafeMath should only be used with Solidity 0.8 or later,
74 // because it relies on the compiler's built in overflow checks.
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations.
78  *
79  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
80  * now has built in overflow checking.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, with an overflow flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             uint256 c = a + b;
91             if (c < a) return (false, 0);
92             return (true, c);
93         }
94     }
95 
96     /**
97      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             if (b > a) return (false, 0);
104             return (true, a - b);
105         }
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116             // benefit is lost if 'b' is also tested.
117             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118             if (a == 0) return (true, 0);
119             uint256 c = a * b;
120             if (c / a != b) return (false, 0);
121             return (true, c);
122         }
123     }
124 
125     /**
126      * @dev Returns the division of two unsigned integers, with a division by zero flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b == 0) return (false, 0);
133             return (true, a / b);
134         }
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             if (b == 0) return (false, 0);
145             return (true, a % b);
146         }
147     }
148 
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's + operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a + b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's - operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's * operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a * b;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's / operator.
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a / b;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting when dividing by zero.
208      *
209      * Counterpart to Solidity's % operator. This function uses a revert
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a % b;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
223      * overflow (when the result is negative).
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {trySub}.
227      *
228      * Counterpart to Solidity's - operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b <= a, errorMessage);
241             return a - b;
242         }
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's / operator. Note: this function uses a
250      * revert opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a / b;
265         }
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * reverting with custom message when dividing by zero.
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {tryMod}.
274      *
275      * Counterpart to Solidity's % operator. This function uses a revert
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a % b;
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
299 
300 pragma solidity ^0.8.1;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if account is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, isContract will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      *
323      * [IMPORTANT]
324      * ====
325      * You shouldn't rely on isContract to protect against flash loan attacks!
326      *
327      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
328      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
329      * constructor.
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize/address.code.length, which returns 0
334         // for contracts in construction, since the code is only stored at the end
335         // of the constructor execution.
336 
337         return account.code.length > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's transfer: sends amount wei to
342      * recipient, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by transfer, making them unable to receive funds via
347      * transfer. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to recipient, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level call. A
365      * plain call is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If target reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
373      *
374      * Requirements:
375      *
376      * - target must be a contract.
377      * - calling target with data must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
387      * errorMessage as a fallback revert reason when target reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
401      * but also transferring value wei to target.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least value.
406      * - the called Solidity function must be payable.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
420      * with errorMessage as a fallback revert reason when target reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @title ERC721 token receiver interface
529  * @dev Interface for any contract that wants to support safeTransfers
530  * from ERC721 asset contracts.
531  */
532 interface IERC721Receiver {
533     /**
534      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
535      * by operator from from, this function is called.
536      *
537      * It must return its Solidity selector to confirm the token transfer.
538      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
539      *
540      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
541      */
542     function onERC721Received(
543         address operator,
544         address from,
545         uint256 tokenId,
546         bytes calldata data
547     ) external returns (bytes4);
548 }
549 
550 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Interface of the ERC165 standard, as defined in the
559  * https://eips.ethereum.org/EIPS/eip-165[EIP].
560  *
561  * Implementers can declare support of contract interfaces, which can then be
562  * queried by others ({ERC165Checker}).
563  *
564  * For an implementation, see {ERC165}.
565  */
566 interface IERC165 {
567     /**
568      * @dev Returns true if this contract implements the interface defined by
569      * interfaceId. See the corresponding
570      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
571      * to learn more about how these ids are created.
572      *
573      * This function call must use less than 30 000 gas.
574      */
575     function supportsInterface(bytes4 interfaceId) external view returns (bool);
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Implementation of the {IERC165} interface.
588  *
589  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
590  * for the additional interface id that will be supported. For example:
591  *
592  * solidity
593  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
595  * }
596  * 
597  *
598  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
599  */
600 abstract contract ERC165 is IERC165 {
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605         return interfaceId == type(IERC165).interfaceId;
606     }
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Required interface of an ERC721 compliant contract.
619  */
620 interface IERC721 is IERC165 {
621     /**
622      * @dev Emitted when tokenId token is transferred from from to to.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when owner enables approved to manage the tokenId token.
628      */
629     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
633      */
634     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
635 
636     /**
637      * @dev Returns the number of tokens in owner's account.
638      */
639     function balanceOf(address owner) external view returns (uint256 balance);
640 
641     /**
642      * @dev Returns the owner of the tokenId token.
643      *
644      * Requirements:
645      *
646      * - tokenId must exist.
647      */
648     function ownerOf(uint256 tokenId) external view returns (address owner);
649 
650     /**
651      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
653      *
654      * Requirements:
655      *
656      * - from cannot be the zero address.
657      * - to cannot be the zero address.
658      * - tokenId token must exist and be owned by from.
659      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
660      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
661      *
662      * Emits a {Transfer} event.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) external;
669 
670     /**
671      * @dev Transfers tokenId token from from to to.
672      *
673      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
674      *
675      * Requirements:
676      *
677      * - from cannot be the zero address.
678      * - to cannot be the zero address.
679      * - tokenId token must be owned by from.
680      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) external;
689 
690     /**
691      * @dev Gives permission to to to transfer tokenId token to another account.
692      * The approval is cleared when the token is transferred.
693      *
694      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
695      *
696      * Requirements:
697      *
698      * - The caller must own the token or be an approved operator.
699      * - tokenId must exist.
700      *
701      * Emits an {Approval} event.
702      */
703     function approve(address to, uint256 tokenId) external;
704 
705     /**
706      * @dev Returns the account approved for tokenId token.
707      *
708      * Requirements:
709      *
710      * - tokenId must exist.
711      */
712     function getApproved(uint256 tokenId) external view returns (address operator);
713 
714     /**
715      * @dev Approve or remove operator as an operator for the caller.
716      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
717      *
718      * Requirements:
719      *
720      * - The operator cannot be the caller.
721      *
722      * Emits an {ApprovalForAll} event.
723      */
724     function setApprovalForAll(address operator, bool _approved) external;
725 
726     /**
727      * @dev Returns if the operator is allowed to manage all of the assets of owner.
728      *
729      * See {setApprovalForAll}
730      */
731     function isApprovedForAll(address owner, address operator) external view returns (bool);
732 
733     /**
734      * @dev Safely transfers tokenId token from from to to.
735      *
736      * Requirements:
737      *
738      * - from cannot be the zero address.
739      * - to cannot be the zero address.
740      * - tokenId token must exist and be owned by from.
741      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
742      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external;
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
755 
756 
757 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
764  * @dev See https://eips.ethereum.org/EIPS/eip-721
765  */
766 interface IERC721Enumerable is IERC721 {
767     /**
768      * @dev Returns the total amount of tokens stored by the contract.
769      */
770     function totalSupply() external view returns (uint256);
771 
772     /**
773      * @dev Returns a token ID owned by owner at a given index of its token list.
774      * Use along with {balanceOf} to enumerate all of owner's tokens.
775      */
776     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
777 
778     /**
779      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
780      * Use along with {totalSupply} to enumerate all tokens.
781      */
782     function tokenByIndex(uint256 index) external view returns (uint256);
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
795  * @dev See https://eips.ethereum.org/EIPS/eip-721
796  */
797 interface IERC721Metadata is IERC721 {
798     /**
799      * @dev Returns the token collection name.
800      */
801     function name() external view returns (string memory);
802 
803     /**
804      * @dev Returns the token collection symbol.
805      */
806     function symbol() external view returns (string memory);
807 
808     /**
809      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
810      */
811     function tokenURI(uint256 tokenId) external view returns (string memory);
812 }
813 
814 // File: @openzeppelin/contracts/utils/Strings.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev String operations.
823  */
824 library Strings {
825     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
826 
827     /**
828      * @dev Converts a uint256 to its ASCII string decimal representation.
829      */
830     function toString(uint256 value) internal pure returns (string memory) {
831         // Inspired by OraclizeAPI's implementation - MIT licence
832         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
833 
834         if (value == 0) {
835             return "0";
836         }
837         uint256 temp = value;
838         uint256 digits;
839         while (temp != 0) {
840             digits++;
841             temp /= 10;
842         }
843         bytes memory buffer = new bytes(digits);
844         while (value != 0) {
845             digits -= 1;
846             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
847             value /= 10;
848         }
849         return string(buffer);
850     }
851 
852     /**
853      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
854      */
855     function toHexString(uint256 value) internal pure returns (string memory) {
856         if (value == 0) {
857             return "0x00";
858         }
859         uint256 temp = value;
860         uint256 length = 0;
861         while (temp != 0) {
862             length++;
863             temp >>= 8;
864         }
865         return toHexString(value, length);
866     }
867 
868     /**
869      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
870      */
871     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
872         bytes memory buffer = new bytes(2 * length + 2);
873         buffer[0] = "0";
874         buffer[1] = "x";
875         for (uint256 i = 2 * length + 1; i > 1; --i) {
876             buffer[i] = _HEX_SYMBOLS[value & 0xf];
877             value >>= 4;
878         }
879         require(value == 0, "Strings: hex length insufficient");
880         return string(buffer);
881     }
882 }
883 
884 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 /**
892  * @dev Contract module that helps prevent reentrant calls to a function.
893  *
894  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
895  * available, which can be applied to functions to make sure there are no nested
896  * (reentrant) calls to them.
897  *
898  * Note that because there is a single nonReentrant guard, functions marked as
899  * nonReentrant may not call one another. This can be worked around by making
900  * those functions private, and then adding external nonReentrant entry
901  * points to them.
902  *
903  * TIP: If you would like to learn more about reentrancy and alternative ways
904  * to protect against it, check out our blog post
905  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
906  */
907 abstract contract ReentrancyGuard {
908     // Booleans are more expensive than uint256 or any type that takes up a full
909     // word because each write operation emits an extra SLOAD to first read the
910     // slot's contents, replace the bits taken up by the boolean, and then write
911     // back. This is the compiler's defense against contract upgrades and
912     // pointer aliasing, and it cannot be disabled.
913 
914     // The values being non-zero value makes deployment a bit more expensive,
915     // but in exchange the refund on every call to nonReentrant will be lower in
916     // amount. Since refunds are capped to a percentage of the total
917     // transaction's gas, it is best to keep them low in cases like this one, to
918     // increase the likelihood of the full refund coming into effect.
919     uint256 private constant _NOT_ENTERED = 1;
920     uint256 private constant _ENTERED = 2;
921 
922     uint256 private _status;
923 
924     constructor() {
925         _status = _NOT_ENTERED;
926     }
927 
928     /**
929      * @dev Prevents a contract from calling itself, directly or indirectly.
930      * Calling a nonReentrant function from another nonReentrant
931      * function is not supported. It is possible to prevent this from happening
932      * by making the nonReentrant function external, and making it call a
933      * private function that does the actual work.
934      */
935     modifier nonReentrant() {
936         // On the first call to nonReentrant, _notEntered will be true
937         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
938 
939         // Any calls to nonReentrant after this point will fail
940         _status = _ENTERED;
941 
942         _;
943 
944         // By storing the original value once again, a refund is triggered (see
945         // https://eips.ethereum.org/EIPS/eip-2200)
946         _status = _NOT_ENTERED;
947     }
948 }
949 
950 // File: @openzeppelin/contracts/utils/Context.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @dev Provides information about the current execution context, including the
959  * sender of the transaction and its data. While these are generally available
960  * via msg.sender and msg.data, they should not be accessed in such a direct
961  * manner, since when dealing with meta-transactions the account sending and
962  * paying for execution may not be the actual sender (as far as an application
963  * is concerned).
964  *
965  * This contract is only required for intermediate, library-like contracts.
966  */
967 abstract contract Context {
968     function _msgSender() internal view virtual returns (address) {
969         return msg.sender;
970     }
971 
972     function _msgData() internal view virtual returns (bytes calldata) {
973         return msg.data;
974     }
975 }
976 
977 // File: @openzeppelin/contracts/access/Ownable.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @dev Contract module which provides a basic access control mechanism, where
987  * there is an account (an owner) that can be granted exclusive access to
988  * specific functions.
989  *
990  * By default, the owner account will be the one that deploys the contract. This
991  * can later be changed with {transferOwnership}.
992  *
993  * This module is used through inheritance. It will make available the modifier
994  * onlyOwner, which can be applied to your functions to restrict their use to
995  * the owner.
996  */
997 abstract contract Ownable is Context {
998     address private _owner;
999 
1000     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1001 
1002     /**
1003      * @dev Initializes the contract setting the deployer as the initial owner.
1004      */
1005     constructor() {
1006         _transferOwnership(_msgSender());
1007     }
1008 
1009     /**
1010      * @dev Returns the address of the current owner.
1011      */
1012     function owner() public view virtual returns (address) {
1013         return _owner;
1014     }
1015 
1016     /**
1017      * @dev Throws if called by any account other than the owner.
1018      */
1019     modifier onlyOwner() {
1020         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1021         _;
1022     }
1023 
1024     /**
1025      * @dev Leaves the contract without owner. It will not be possible to call
1026      * onlyOwner functions anymore. Can only be called by the current owner.
1027      *
1028      * NOTE: Renouncing ownership will leave the contract without an owner,
1029      * thereby removing any functionality that is only available to the owner.
1030      */
1031     function renounceOwnership() public virtual onlyOwner {
1032         _transferOwnership(address(0));
1033     }
1034 
1035     /**
1036      * @dev Transfers ownership of the contract to a new account (newOwner).
1037      * Can only be called by the current owner.
1038      */
1039     function transferOwnership(address newOwner) public virtual onlyOwner {
1040         require(newOwner != address(0), "Ownable: new owner is the zero address");
1041         _transferOwnership(newOwner);
1042     }
1043 
1044     /**
1045      * @dev Transfers ownership of the contract to a new account (newOwner).
1046      * Internal function without access restriction.
1047      */
1048     function _transferOwnership(address newOwner) internal virtual {
1049         address oldOwner = _owner;
1050         _owner = newOwner;
1051         emit OwnershipTransferred(oldOwner, newOwner);
1052     }
1053 }
1054 //-------------END DEPENDENCIES------------------------//
1055 
1056 
1057   
1058   pragma solidity ^0.8.0;
1059 
1060   /**
1061   * @dev These functions deal with verification of Merkle Trees proofs.
1062   *
1063   * The proofs can be generated using the JavaScript library
1064   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1065   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1066   *
1067   *
1068   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1069   * hashing, or use a hash function other than keccak256 for hashing leaves.
1070   * This is because the concatenation of a sorted pair of internal nodes in
1071   * the merkle tree could be reinterpreted as a leaf value.
1072   */
1073   library MerkleProof {
1074       /**
1075       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1076       * defined by 'root'. For this, a 'proof' must be provided, containing
1077       * sibling hashes on the branch from the leaf to the root of the tree. Each
1078       * pair of leaves and each pair of pre-images are assumed to be sorted.
1079       */
1080       function verify(
1081           bytes32[] memory proof,
1082           bytes32 root,
1083           bytes32 leaf
1084       ) internal pure returns (bool) {
1085           return processProof(proof, leaf) == root;
1086       }
1087 
1088       /**
1089       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1090       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1091       * hash matches the root of the tree. When processing the proof, the pairs
1092       * of leafs & pre-images are assumed to be sorted.
1093       *
1094       * _Available since v4.4._
1095       */
1096       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1097           bytes32 computedHash = leaf;
1098           for (uint256 i = 0; i < proof.length; i++) {
1099               bytes32 proofElement = proof[i];
1100               if (computedHash <= proofElement) {
1101                   // Hash(current computed hash + current element of the proof)
1102                   computedHash = _efficientHash(computedHash, proofElement);
1103               } else {
1104                   // Hash(current element of the proof + current computed hash)
1105                   computedHash = _efficientHash(proofElement, computedHash);
1106               }
1107           }
1108           return computedHash;
1109       }
1110 
1111       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1112           assembly {
1113               mstore(0x00, a)
1114               mstore(0x20, b)
1115               value := keccak256(0x00, 0x40)
1116           }
1117       }
1118   }
1119 
1120 
1121   // File: Allowlist.sol
1122 
1123   pragma solidity ^0.8.0;
1124 
1125   abstract contract Allowlist is Ownable {
1126     bytes32 public merkleRoot;
1127     bool public onlyAllowlistMode = false;
1128 
1129     /**
1130      * @dev Update merkle root to reflect changes in Allowlist
1131      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1132      */
1133     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1134       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1135       merkleRoot = _newMerkleRoot;
1136     }
1137 
1138     /**
1139      * @dev Check the proof of an address if valid for merkle root
1140      * @param _to address to check for proof
1141      * @param _merkleProof Proof of the address to validate against root and leaf
1142      */
1143     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1144       require(merkleRoot != 0, "Merkle root is not set!");
1145       bytes32 leaf = keccak256(abi.encodePacked(_to));
1146 
1147       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1148     }
1149 
1150     
1151     function enableAllowlistOnlyMode() public onlyOwner {
1152       onlyAllowlistMode = true;
1153     }
1154 
1155     function disableAllowlistOnlyMode() public onlyOwner {
1156         onlyAllowlistMode = false;
1157     }
1158   }
1159   
1160   
1161 /**
1162  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1163  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1164  *
1165  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1166  * 
1167  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1168  *
1169  * Does not support burning tokens to address(0).
1170  */
1171 contract ERC721A is
1172   Context,
1173   ERC165,
1174   IERC721,
1175   IERC721Metadata,
1176   IERC721Enumerable
1177 {
1178   using Address for address;
1179   using Strings for uint256;
1180 
1181   struct TokenOwnership {
1182     address addr;
1183     uint64 startTimestamp;
1184   }
1185 
1186   struct AddressData {
1187     uint128 balance;
1188     uint128 numberMinted;
1189   }
1190 
1191   uint256 private currentIndex;
1192 
1193   uint256 public immutable collectionSize;
1194   uint256 public maxBatchSize;
1195 
1196   // Token name
1197   string private _name;
1198 
1199   // Token symbol
1200   string private _symbol;
1201 
1202   // Mapping from token ID to ownership details
1203   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1204   mapping(uint256 => TokenOwnership) private _ownerships;
1205 
1206   // Mapping owner address to address data
1207   mapping(address => AddressData) private _addressData;
1208 
1209   // Mapping from token ID to approved address
1210   mapping(uint256 => address) private _tokenApprovals;
1211 
1212   // Mapping from owner to operator approvals
1213   mapping(address => mapping(address => bool)) private _operatorApprovals;
1214 
1215   /**
1216    * @dev
1217    * maxBatchSize refers to how much a minter can mint at a time.
1218    * collectionSize_ refers to how many tokens are in the collection.
1219    */
1220   constructor(
1221     string memory name_,
1222     string memory symbol_,
1223     uint256 maxBatchSize_,
1224     uint256 collectionSize_
1225   ) {
1226     require(
1227       collectionSize_ > 0,
1228       "ERC721A: collection must have a nonzero supply"
1229     );
1230     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1231     _name = name_;
1232     _symbol = symbol_;
1233     maxBatchSize = maxBatchSize_;
1234     collectionSize = collectionSize_;
1235     currentIndex = _startTokenId();
1236   }
1237 
1238   /**
1239   * To change the starting tokenId, please override this function.
1240   */
1241   function _startTokenId() internal view virtual returns (uint256) {
1242     return 1;
1243   }
1244 
1245   /**
1246    * @dev See {IERC721Enumerable-totalSupply}.
1247    */
1248   function totalSupply() public view override returns (uint256) {
1249     return _totalMinted();
1250   }
1251 
1252   function currentTokenId() public view returns (uint256) {
1253     return _totalMinted();
1254   }
1255 
1256   function getNextTokenId() public view returns (uint256) {
1257       return SafeMath.add(_totalMinted(), 1);
1258   }
1259 
1260   /**
1261   * Returns the total amount of tokens minted in the contract.
1262   */
1263   function _totalMinted() internal view returns (uint256) {
1264     unchecked {
1265       return currentIndex - _startTokenId();
1266     }
1267   }
1268 
1269   /**
1270    * @dev See {IERC721Enumerable-tokenByIndex}.
1271    */
1272   function tokenByIndex(uint256 index) public view override returns (uint256) {
1273     require(index < totalSupply(), "ERC721A: global index out of bounds");
1274     return index;
1275   }
1276 
1277   /**
1278    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1279    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1280    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1281    */
1282   function tokenOfOwnerByIndex(address owner, uint256 index)
1283     public
1284     view
1285     override
1286     returns (uint256)
1287   {
1288     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1289     uint256 numMintedSoFar = totalSupply();
1290     uint256 tokenIdsIdx = 0;
1291     address currOwnershipAddr = address(0);
1292     for (uint256 i = 0; i < numMintedSoFar; i++) {
1293       TokenOwnership memory ownership = _ownerships[i];
1294       if (ownership.addr != address(0)) {
1295         currOwnershipAddr = ownership.addr;
1296       }
1297       if (currOwnershipAddr == owner) {
1298         if (tokenIdsIdx == index) {
1299           return i;
1300         }
1301         tokenIdsIdx++;
1302       }
1303     }
1304     revert("ERC721A: unable to get token of owner by index");
1305   }
1306 
1307   /**
1308    * @dev See {IERC165-supportsInterface}.
1309    */
1310   function supportsInterface(bytes4 interfaceId)
1311     public
1312     view
1313     virtual
1314     override(ERC165, IERC165)
1315     returns (bool)
1316   {
1317     return
1318       interfaceId == type(IERC721).interfaceId ||
1319       interfaceId == type(IERC721Metadata).interfaceId ||
1320       interfaceId == type(IERC721Enumerable).interfaceId ||
1321       super.supportsInterface(interfaceId);
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-balanceOf}.
1326    */
1327   function balanceOf(address owner) public view override returns (uint256) {
1328     require(owner != address(0), "ERC721A: balance query for the zero address");
1329     return uint256(_addressData[owner].balance);
1330   }
1331 
1332   function _numberMinted(address owner) internal view returns (uint256) {
1333     require(
1334       owner != address(0),
1335       "ERC721A: number minted query for the zero address"
1336     );
1337     return uint256(_addressData[owner].numberMinted);
1338   }
1339 
1340   function ownershipOf(uint256 tokenId)
1341     internal
1342     view
1343     returns (TokenOwnership memory)
1344   {
1345     uint256 curr = tokenId;
1346 
1347     unchecked {
1348         if (_startTokenId() <= curr && curr < currentIndex) {
1349             TokenOwnership memory ownership = _ownerships[curr];
1350             if (ownership.addr != address(0)) {
1351                 return ownership;
1352             }
1353 
1354             // Invariant:
1355             // There will always be an ownership that has an address and is not burned
1356             // before an ownership that does not have an address and is not burned.
1357             // Hence, curr will not underflow.
1358             while (true) {
1359                 curr--;
1360                 ownership = _ownerships[curr];
1361                 if (ownership.addr != address(0)) {
1362                     return ownership;
1363                 }
1364             }
1365         }
1366     }
1367 
1368     revert("ERC721A: unable to determine the owner of token");
1369   }
1370 
1371   /**
1372    * @dev See {IERC721-ownerOf}.
1373    */
1374   function ownerOf(uint256 tokenId) public view override returns (address) {
1375     return ownershipOf(tokenId).addr;
1376   }
1377 
1378   /**
1379    * @dev See {IERC721Metadata-name}.
1380    */
1381   function name() public view virtual override returns (string memory) {
1382     return _name;
1383   }
1384 
1385   /**
1386    * @dev See {IERC721Metadata-symbol}.
1387    */
1388   function symbol() public view virtual override returns (string memory) {
1389     return _symbol;
1390   }
1391 
1392   /**
1393    * @dev See {IERC721Metadata-tokenURI}.
1394    */
1395   function tokenURI(uint256 tokenId)
1396     public
1397     view
1398     virtual
1399     override
1400     returns (string memory)
1401   {
1402     string memory baseURI = _baseURI();
1403     return
1404       bytes(baseURI).length > 0
1405         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1406         : "";
1407   }
1408 
1409   /**
1410    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1411    * token will be the concatenation of the baseURI and the tokenId. Empty
1412    * by default, can be overriden in child contracts.
1413    */
1414   function _baseURI() internal view virtual returns (string memory) {
1415     return "";
1416   }
1417 
1418   /**
1419    * @dev See {IERC721-approve}.
1420    */
1421   function approve(address to, uint256 tokenId) public override {
1422     address owner = ERC721A.ownerOf(tokenId);
1423     require(to != owner, "ERC721A: approval to current owner");
1424 
1425     require(
1426       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1427       "ERC721A: approve caller is not owner nor approved for all"
1428     );
1429 
1430     _approve(to, tokenId, owner);
1431   }
1432 
1433   /**
1434    * @dev See {IERC721-getApproved}.
1435    */
1436   function getApproved(uint256 tokenId) public view override returns (address) {
1437     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1438 
1439     return _tokenApprovals[tokenId];
1440   }
1441 
1442   /**
1443    * @dev See {IERC721-setApprovalForAll}.
1444    */
1445   function setApprovalForAll(address operator, bool approved) public override {
1446     require(operator != _msgSender(), "ERC721A: approve to caller");
1447 
1448     _operatorApprovals[_msgSender()][operator] = approved;
1449     emit ApprovalForAll(_msgSender(), operator, approved);
1450   }
1451 
1452   /**
1453    * @dev See {IERC721-isApprovedForAll}.
1454    */
1455   function isApprovedForAll(address owner, address operator)
1456     public
1457     view
1458     virtual
1459     override
1460     returns (bool)
1461   {
1462     return _operatorApprovals[owner][operator];
1463   }
1464 
1465   /**
1466    * @dev See {IERC721-transferFrom}.
1467    */
1468   function transferFrom(
1469     address from,
1470     address to,
1471     uint256 tokenId
1472   ) public override {
1473     _transfer(from, to, tokenId);
1474   }
1475 
1476   /**
1477    * @dev See {IERC721-safeTransferFrom}.
1478    */
1479   function safeTransferFrom(
1480     address from,
1481     address to,
1482     uint256 tokenId
1483   ) public override {
1484     safeTransferFrom(from, to, tokenId, "");
1485   }
1486 
1487   /**
1488    * @dev See {IERC721-safeTransferFrom}.
1489    */
1490   function safeTransferFrom(
1491     address from,
1492     address to,
1493     uint256 tokenId,
1494     bytes memory _data
1495   ) public override {
1496     _transfer(from, to, tokenId);
1497     require(
1498       _checkOnERC721Received(from, to, tokenId, _data),
1499       "ERC721A: transfer to non ERC721Receiver implementer"
1500     );
1501   }
1502 
1503   /**
1504    * @dev Returns whether tokenId exists.
1505    *
1506    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1507    *
1508    * Tokens start existing when they are minted (_mint),
1509    */
1510   function _exists(uint256 tokenId) internal view returns (bool) {
1511     return _startTokenId() <= tokenId && tokenId < currentIndex;
1512   }
1513 
1514   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1515     _safeMint(to, quantity, isAdminMint, "");
1516   }
1517 
1518   /**
1519    * @dev Mints quantity tokens and transfers them to to.
1520    *
1521    * Requirements:
1522    *
1523    * - there must be quantity tokens remaining unminted in the total collection.
1524    * - to cannot be the zero address.
1525    * - quantity cannot be larger than the max batch size.
1526    *
1527    * Emits a {Transfer} event.
1528    */
1529   function _safeMint(
1530     address to,
1531     uint256 quantity,
1532     bool isAdminMint,
1533     bytes memory _data
1534   ) internal {
1535     uint256 startTokenId = currentIndex;
1536     require(to != address(0), "ERC721A: mint to the zero address");
1537     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1538     require(!_exists(startTokenId), "ERC721A: token already minted");
1539     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1540 
1541     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1542 
1543     AddressData memory addressData = _addressData[to];
1544     _addressData[to] = AddressData(
1545       addressData.balance + uint128(quantity),
1546       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1547     );
1548     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1549 
1550     uint256 updatedIndex = startTokenId;
1551 
1552     for (uint256 i = 0; i < quantity; i++) {
1553       emit Transfer(address(0), to, updatedIndex);
1554       require(
1555         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1556         "ERC721A: transfer to non ERC721Receiver implementer"
1557       );
1558       updatedIndex++;
1559     }
1560 
1561     currentIndex = updatedIndex;
1562     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1563   }
1564 
1565   /**
1566    * @dev Transfers tokenId from from to to.
1567    *
1568    * Requirements:
1569    *
1570    * - to cannot be the zero address.
1571    * - tokenId token must be owned by from.
1572    *
1573    * Emits a {Transfer} event.
1574    */
1575   function _transfer(
1576     address from,
1577     address to,
1578     uint256 tokenId
1579   ) private {
1580     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1581 
1582     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1583       getApproved(tokenId) == _msgSender() ||
1584       isApprovedForAll(prevOwnership.addr, _msgSender()));
1585 
1586     require(
1587       isApprovedOrOwner,
1588       "ERC721A: transfer caller is not owner nor approved"
1589     );
1590 
1591     require(
1592       prevOwnership.addr == from,
1593       "ERC721A: transfer from incorrect owner"
1594     );
1595     require(to != address(0), "ERC721A: transfer to the zero address");
1596 
1597     _beforeTokenTransfers(from, to, tokenId, 1);
1598 
1599     // Clear approvals from the previous owner
1600     _approve(address(0), tokenId, prevOwnership.addr);
1601 
1602     _addressData[from].balance -= 1;
1603     _addressData[to].balance += 1;
1604     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1605 
1606     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1607     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1608     uint256 nextTokenId = tokenId + 1;
1609     if (_ownerships[nextTokenId].addr == address(0)) {
1610       if (_exists(nextTokenId)) {
1611         _ownerships[nextTokenId] = TokenOwnership(
1612           prevOwnership.addr,
1613           prevOwnership.startTimestamp
1614         );
1615       }
1616     }
1617 
1618     emit Transfer(from, to, tokenId);
1619     _afterTokenTransfers(from, to, tokenId, 1);
1620   }
1621 
1622   /**
1623    * @dev Approve to to operate on tokenId
1624    *
1625    * Emits a {Approval} event.
1626    */
1627   function _approve(
1628     address to,
1629     uint256 tokenId,
1630     address owner
1631   ) private {
1632     _tokenApprovals[tokenId] = to;
1633     emit Approval(owner, to, tokenId);
1634   }
1635 
1636   uint256 public nextOwnerToExplicitlySet = 0;
1637 
1638   /**
1639    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1640    */
1641   function _setOwnersExplicit(uint256 quantity) internal {
1642     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1643     require(quantity > 0, "quantity must be nonzero");
1644     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1645 
1646     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1647     if (endIndex > collectionSize - 1) {
1648       endIndex = collectionSize - 1;
1649     }
1650     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1651     require(_exists(endIndex), "not enough minted yet for this cleanup");
1652     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1653       if (_ownerships[i].addr == address(0)) {
1654         TokenOwnership memory ownership = ownershipOf(i);
1655         _ownerships[i] = TokenOwnership(
1656           ownership.addr,
1657           ownership.startTimestamp
1658         );
1659       }
1660     }
1661     nextOwnerToExplicitlySet = endIndex + 1;
1662   }
1663 
1664   /**
1665    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1666    * The call is not executed if the target address is not a contract.
1667    *
1668    * @param from address representing the previous owner of the given token ID
1669    * @param to target address that will receive the tokens
1670    * @param tokenId uint256 ID of the token to be transferred
1671    * @param _data bytes optional data to send along with the call
1672    * @return bool whether the call correctly returned the expected magic value
1673    */
1674   function _checkOnERC721Received(
1675     address from,
1676     address to,
1677     uint256 tokenId,
1678     bytes memory _data
1679   ) private returns (bool) {
1680     if (to.isContract()) {
1681       try
1682         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1683       returns (bytes4 retval) {
1684         return retval == IERC721Receiver(to).onERC721Received.selector;
1685       } catch (bytes memory reason) {
1686         if (reason.length == 0) {
1687           revert("ERC721A: transfer to non ERC721Receiver implementer");
1688         } else {
1689           assembly {
1690             revert(add(32, reason), mload(reason))
1691           }
1692         }
1693       }
1694     } else {
1695       return true;
1696     }
1697   }
1698 
1699   /**
1700    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1701    *
1702    * startTokenId - the first token id to be transferred
1703    * quantity - the amount to be transferred
1704    *
1705    * Calling conditions:
1706    *
1707    * - When from and to are both non-zero, from's tokenId will be
1708    * transferred to to.
1709    * - When from is zero, tokenId will be minted for to.
1710    */
1711   function _beforeTokenTransfers(
1712     address from,
1713     address to,
1714     uint256 startTokenId,
1715     uint256 quantity
1716   ) internal virtual {}
1717 
1718   /**
1719    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1720    * minting.
1721    *
1722    * startTokenId - the first token id to be transferred
1723    * quantity - the amount to be transferred
1724    *
1725    * Calling conditions:
1726    *
1727    * - when from and to are both non-zero.
1728    * - from and to are never both zero.
1729    */
1730   function _afterTokenTransfers(
1731     address from,
1732     address to,
1733     uint256 startTokenId,
1734     uint256 quantity
1735   ) internal virtual {}
1736 }
1737 
1738 
1739 
1740   
1741 abstract contract Ramppable {
1742   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1743 
1744   modifier isRampp() {
1745       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1746       _;
1747   }
1748 }
1749 
1750 
1751   
1752 /** TimedDrop.sol
1753 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1754 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1755 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1756 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1757 */
1758 abstract contract TimedDrop is Ownable {
1759   bool public enforcePublicDropTime = true;
1760   uint256 public publicDropTime = 1654448400;
1761   
1762   /**
1763   * @dev Allow the contract owner to set the public time to mint.
1764   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1765   */
1766   function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
1767     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1768     publicDropTime = _newDropTime;
1769   }
1770 
1771   function usePublicDropTime() public onlyOwner {
1772     enforcePublicDropTime = true;
1773   }
1774 
1775   function disablePublicDropTime() public onlyOwner {
1776     enforcePublicDropTime = false;
1777   }
1778 
1779   /**
1780   * @dev determine if the public droptime has passed.
1781   * if the feature is disabled then assume the time has passed.
1782   */
1783   function publicDropTimePassed() public view returns(bool) {
1784     if(enforcePublicDropTime == false) {
1785       return true;
1786     }
1787     return block.timestamp >= publicDropTime;
1788   }
1789   
1790   // Allowlist implementation of the Timed Drop feature
1791   bool public enforceAllowlistDropTime = true;
1792   uint256 public allowlistDropTime = 1654362000;
1793 
1794   /**
1795   * @dev Allow the contract owner to set the allowlist time to mint.
1796   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1797   */
1798   function setAllowlistDropTime(uint256 _newDropTime) public onlyOwner {
1799     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1800     allowlistDropTime = _newDropTime;
1801   }
1802 
1803   function useAllowlistDropTime() public onlyOwner {
1804     enforceAllowlistDropTime = true;
1805   }
1806 
1807   function disableAllowlistDropTime() public onlyOwner {
1808     enforceAllowlistDropTime = false;
1809   }
1810 
1811   function allowlistDropTimePassed() public view returns(bool) {
1812     if(enforceAllowlistDropTime == false) {
1813       return true;
1814     }
1815 
1816     return block.timestamp >= allowlistDropTime;
1817   }
1818 }
1819 
1820   
1821 interface IERC20 {
1822   function transfer(address _to, uint256 _amount) external returns (bool);
1823   function balanceOf(address account) external view returns (uint256);
1824 }
1825 
1826 abstract contract Withdrawable is Ownable, Ramppable {
1827   address[] public payableAddresses = [RAMPPADDRESS,0xb5a00442CD48E1Ec749327594Fc64E16795bbC31];
1828   uint256[] public payableFees = [5,95];
1829   uint256 public payableAddressCount = 2;
1830 
1831   function withdrawAll() public onlyOwner {
1832       require(address(this).balance > 0);
1833       _withdrawAll();
1834   }
1835   
1836   function withdrawAllRampp() public isRampp {
1837       require(address(this).balance > 0);
1838       _withdrawAll();
1839   }
1840 
1841   function _withdrawAll() private {
1842       uint256 balance = address(this).balance;
1843       
1844       for(uint i=0; i < payableAddressCount; i++ ) {
1845           _widthdraw(
1846               payableAddresses[i],
1847               (balance * payableFees[i]) / 100
1848           );
1849       }
1850   }
1851   
1852   function _widthdraw(address _address, uint256 _amount) private {
1853       (bool success, ) = _address.call{value: _amount}("");
1854       require(success, "Transfer failed.");
1855   }
1856 
1857   /**
1858     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1859     * while still splitting royalty payments to all other team members.
1860     * in the event ERC-20 tokens are paid to the contract.
1861     * @param _tokenContract contract of ERC-20 token to withdraw
1862     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1863     */
1864   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1865     require(_amount > 0);
1866     IERC20 tokenContract = IERC20(_tokenContract);
1867     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1868 
1869     for(uint i=0; i < payableAddressCount; i++ ) {
1870         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1871     }
1872   }
1873 
1874   /**
1875   * @dev Allows Rampp wallet to update its own reference as well as update
1876   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1877   * and since Rampp is always the first address this function is limited to the rampp payout only.
1878   * @param _newAddress updated Rampp Address
1879   */
1880   function setRamppAddress(address _newAddress) public isRampp {
1881     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1882     RAMPPADDRESS = _newAddress;
1883     payableAddresses[0] = _newAddress;
1884   }
1885 }
1886 
1887 
1888   
1889 abstract contract RamppERC721A is 
1890     Ownable,
1891     ERC721A,
1892     Withdrawable,
1893     ReentrancyGuard , Allowlist , TimedDrop {
1894     constructor(
1895         string memory tokenName,
1896         string memory tokenSymbol
1897     ) ERC721A(tokenName, tokenSymbol, 2, 3456 ) {}
1898     using SafeMath for uint256;
1899     uint8 public CONTRACT_VERSION = 2;
1900     string public _baseTokenURI = "ipfs://QmY9xdD9NzVM87FJsGjNzUEWMwBnwwrymEkZDD1M4boRKS/";
1901 
1902     bool public mintingOpen = true;
1903     bool public isRevealed = false;
1904     uint256 public PRICE = 0 ether;
1905     
1906     uint256 public MAX_WALLET_MINTS = 2;
1907 
1908     
1909     /////////////// Admin Mint Functions
1910     /**
1911     * @dev Mints a token to an address with a tokenURI.
1912     * This is owner only and allows a fee-free drop
1913     * @param _to address of the future owner of the token
1914     */
1915     function mintToAdmin(address _to) public onlyOwner {
1916         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3456");
1917         _safeMint(_to, 1, true);
1918     }
1919 
1920     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1921         for(uint i=0; i < _addressCount; i++ ) {
1922             mintToAdmin(_addresses[i]);
1923         }
1924     }
1925 
1926     
1927     /////////////// GENERIC MINT FUNCTIONS
1928     /**
1929     * @dev Mints a single token to an address.
1930     * fee may or may not be required*
1931     * @param _to address of the future owner of the token
1932     */
1933     function mintTo(address _to) public payable {
1934         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3456");
1935         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1936         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1937         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1938         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1939         
1940         _safeMint(_to, 1, false);
1941     }
1942 
1943     /**
1944     * @dev Mints a token to an address with a tokenURI.
1945     * fee may or may not be required*
1946     * @param _to address of the future owner of the token
1947     * @param _amount number of tokens to mint
1948     */
1949     function mintToMultiple(address _to, uint256 _amount) public payable {
1950         require(_amount >= 1, "Must mint at least 1 token");
1951         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1952         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1953         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1954         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1955         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3456");
1956         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1957 
1958         _safeMint(_to, _amount, false);
1959     }
1960 
1961     function openMinting() public onlyOwner {
1962         mintingOpen = true;
1963     }
1964 
1965     function stopMinting() public onlyOwner {
1966         mintingOpen = false;
1967     }
1968 
1969     
1970     ///////////// ALLOWLIST MINTING FUNCTIONS
1971 
1972     /**
1973     * @dev Mints a token to an address with a tokenURI for allowlist.
1974     * fee may or may not be required*
1975     * @param _to address of the future owner of the token
1976     */
1977     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1978         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1979         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1980         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3456");
1981         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1982         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1983         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1984 
1985         _safeMint(_to, 1, false);
1986     }
1987 
1988     /**
1989     * @dev Mints a token to an address with a tokenURI for allowlist.
1990     * fee may or may not be required*
1991     * @param _to address of the future owner of the token
1992     * @param _amount number of tokens to mint
1993     */
1994     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1995         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1996         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1997         require(_amount >= 1, "Must mint at least 1 token");
1998         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1999 
2000         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2001         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3456");
2002         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2003         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2004 
2005         _safeMint(_to, _amount, false);
2006     }
2007 
2008     /**
2009      * @dev Enable allowlist minting fully by enabling both flags
2010      * This is a convenience function for the Rampp user
2011      */
2012     function openAllowlistMint() public onlyOwner {
2013         enableAllowlistOnlyMode();
2014         mintingOpen = true;
2015     }
2016 
2017     /**
2018      * @dev Close allowlist minting fully by disabling both flags
2019      * This is a convenience function for the Rampp user
2020      */
2021     function closeAllowlistMint() public onlyOwner {
2022         disableAllowlistOnlyMode();
2023         mintingOpen = false;
2024     }
2025 
2026 
2027     
2028     /**
2029     * @dev Check if wallet over MAX_WALLET_MINTS
2030     * @param _address address in question to check if minted count exceeds max
2031     */
2032     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2033         require(_amount >= 1, "Amount must be greater than or equal to 1");
2034         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
2035     }
2036 
2037     /**
2038     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2039     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2040     */
2041     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
2042         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2043         MAX_WALLET_MINTS = _newWalletMax;
2044     }
2045     
2046 
2047     
2048     /**
2049      * @dev Allows owner to set Max mints per tx
2050      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2051      */
2052      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
2053          require(_newMaxMint >= 1, "Max mint must be at least 1");
2054          maxBatchSize = _newMaxMint;
2055      }
2056     
2057 
2058     
2059     function setPrice(uint256 _feeInWei) public onlyOwner {
2060         PRICE = _feeInWei;
2061     }
2062 
2063     function getPrice(uint256 _count) private view returns (uint256) {
2064         return PRICE.mul(_count);
2065     }
2066 
2067     
2068     function unveil(string memory _updatedTokenURI) public onlyOwner {
2069         require(isRevealed == false, "Tokens are already unveiled");
2070         _baseTokenURI = _updatedTokenURI;
2071         isRevealed = true;
2072     }
2073     
2074     
2075     function _baseURI() internal view virtual override returns (string memory) {
2076         return _baseTokenURI;
2077     }
2078 
2079     function baseTokenURI() public view returns (string memory) {
2080         return _baseTokenURI;
2081     }
2082 
2083     function setBaseURI(string calldata baseURI) external onlyOwner {
2084         _baseTokenURI = baseURI;
2085     }
2086 
2087     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2088         return ownershipOf(tokenId);
2089     }
2090 }
2091 
2092 
2093   
2094 // File: contracts/TheBirdiesContract.sol
2095 //SPDX-License-Identifier: MIT
2096 
2097 pragma solidity ^0.8.0;
2098 
2099 contract TheBirdiesContract is RamppERC721A {
2100     constructor() RamppERC721A("The Birdies", "TBRD"){}
2101 
2102     function contractURI() public pure returns (string memory) {
2103       return "https://us-central1-nft-rampp.cloudfunctions.net/app/Z9ZW8y6NRDRM55qh9Z82/contract-metadata";
2104     }
2105 }
2106   
2107 //*********************************************************************//
2108 //*********************************************************************//  
2109 //                       Rampp v2.0.1
2110 //
2111 //         This smart contract was generated by rampp.xyz.
2112 //            Rampp allows creators like you to launch 
2113 //             large scale NFT communities without code!
2114 //
2115 //    Rampp is not responsible for the content of this contract and
2116 //        hopes it is being used in a responsible and kind way.  
2117 //       Rampp is not associated or affiliated with this project.                                                    
2118 //             Twitter: @Rampp_ ---- rampp.xyz
2119 //*********************************************************************//                                                     
2120 //*********************************************************************// 
