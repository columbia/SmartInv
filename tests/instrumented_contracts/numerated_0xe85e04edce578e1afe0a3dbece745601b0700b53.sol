1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //                                                                                                                                      
5 //           ____                                                                                            .--,-``-.                  
6 //         ,'  , `.                                                                                         /   /     '.      ,---,     
7 //      ,-+-,.' _ |                                  ,---,     ,--,               ,---,                    / ../        ;   .'  .' `\   
8 //   ,-+-. ;   , ||   ,---.     ,---.        ,---, ,---.'|   ,--.'|    __  ,-.  ,---.'|                    \ ``\  .`-    ',---.'     \  
9 //  ,--.'|'   |  ;|  '   ,'\   '   ,'\   ,-+-. /  ||   | :   |  |,   ,' ,'/ /|  |   | :  .--.--.            \___\/   \   :|   |  .`\  | 
10 // |   |  ,', |  ': /   /   | /   /   | ,--.'|'   |:   : :   `--'_   '  | |' |  |   | | /  /    '                \   :   |:   : |  '  | 
11 // |   | /  | |  ||.   ; ,. :.   ; ,. :|   |  ,"' |:     |,-.,' ,'|  |  |   ,',--.__| ||  :  /`./                /  /   / |   ' '  ;  : 
12 // '   | :  | :  |,'   | |: :'   | |: :|   | /  | ||   : '  |'  | |  '  :  / /   ,'   ||  :  ;_                  \  \   \ '   | ;  .  | 
13 // ;   . |  ; |--' '   | .; :'   | .; :|   | |  | ||   |  / :|  | :  |  | ' .   '  /  | \  \    `.           ___ /   :   ||   | :  |  ' 
14 // |   : |  | ,    |   :    ||   :    ||   | |  |/ '   : |: |'  : |__;  : | '   ; |:  |  `----.   \         /   /\   /   :'   : | /  ;  
15 // |   : '  |/      \   \  /  \   \  / |   | |--'  |   | '/ :|  | '.'|  , ; |   | '/  ' /  /`--'  /        / ,,/  ',-    .|   | '` ,/   
16 // ;   | |`-'        `----'    `----'  |   |/      |   :    |;  :    ;---'  |   :    :|'--'.     /         \ ''\        ; ;   :  .'     
17 // |   ;/                              '---'       /    \  / |  ,   /        \   \  /    `--'---'           \   \     .'  |   ,.'       
18 // '---'                                           `-'----'   ---`-'          `----'                         `--`-,,-'    '---'         
19 //                                                                                                                                      
20 //
21 //*********************************************************************//
22 //*********************************************************************//
23   
24 //-------------DEPENDENCIES--------------------------//
25 
26 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
27 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 // CAUTION
32 // This version of SafeMath should only be used with Solidity 0.8 or later,
33 // because it relies on the compiler's built in overflow checks.
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations.
37  *
38  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
39  * now has built in overflow checking.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             uint256 c = a + b;
50             if (c < a) return (false, 0);
51             return (true, c);
52         }
53     }
54 
55     /**
56      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
57      *
58      * _Available since v3.4._
59      */
60     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         unchecked {
62             if (b > a) return (false, 0);
63             return (true, a - b);
64         }
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {
74             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75             // benefit is lost if 'b' is also tested.
76             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77             if (a == 0) return (true, 0);
78             uint256 c = a * b;
79             if (c / a != b) return (false, 0);
80             return (true, c);
81         }
82     }
83 
84     /**
85      * @dev Returns the division of two unsigned integers, with a division by zero flag.
86      *
87      * _Available since v3.4._
88      */
89     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91             if (b == 0) return (false, 0);
92             return (true, a / b);
93         }
94     }
95 
96     /**
97      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             if (b == 0) return (false, 0);
104             return (true, a % b);
105         }
106     }
107 
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's + operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a + b;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's - operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a - b;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's * operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a * b;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers, reverting on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's / operator.
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         return a / b;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * reverting when dividing by zero.
167      *
168      * Counterpart to Solidity's % operator. This function uses a revert
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a % b;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
182      * overflow (when the result is negative).
183      *
184      * CAUTION: This function is deprecated because it requires allocating memory for the error
185      * message unnecessarily. For custom revert reasons use {trySub}.
186      *
187      * Counterpart to Solidity's - operator.
188      *
189      * Requirements:
190      *
191      * - Subtraction cannot overflow.
192      */
193     function sub(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b <= a, errorMessage);
200             return a - b;
201         }
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's / operator. Note: this function uses a
209      * revert opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a / b;
224         }
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * reverting with custom message when dividing by zero.
230      *
231      * CAUTION: This function is deprecated because it requires allocating memory for the error
232      * message unnecessarily. For custom revert reasons use {tryMod}.
233      *
234      * Counterpart to Solidity's % operator. This function uses a revert
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(
243         uint256 a,
244         uint256 b,
245         string memory errorMessage
246     ) internal pure returns (uint256) {
247         unchecked {
248             require(b > 0, errorMessage);
249             return a % b;
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if account is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, isContract will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on isContract to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's transfer: sends amount wei to
301      * recipient, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by transfer, making them unable to receive funds via
306      * transfer. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to recipient, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level call. A
324      * plain call is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If target reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
332      *
333      * Requirements:
334      *
335      * - target must be a contract.
336      * - calling target with data must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
346      * errorMessage as a fallback revert reason when target reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
360      * but also transferring value wei to target.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least value.
365      * - the called Solidity function must be payable.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
379      * with errorMessage as a fallback revert reason when target reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by operator from from, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * interfaceId. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * 
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when tokenId token is transferred from from to to.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when owner enables approved to manage the tokenId token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in owner's account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the tokenId token.
602      *
603      * Requirements:
604      *
605      * - tokenId must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - from cannot be the zero address.
616      * - to cannot be the zero address.
617      * - tokenId token must exist and be owned by from.
618      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers tokenId token from from to to.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - from cannot be the zero address.
637      * - to cannot be the zero address.
638      * - tokenId token must be owned by from.
639      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Gives permission to to to transfer tokenId token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - tokenId must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Returns the account approved for tokenId token.
666      *
667      * Requirements:
668      *
669      * - tokenId must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Approve or remove operator as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The operator cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns if the operator is allowed to manage all of the assets of owner.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 
692     /**
693      * @dev Safely transfers tokenId token from from to to.
694      *
695      * Requirements:
696      *
697      * - from cannot be the zero address.
698      * - to cannot be the zero address.
699      * - tokenId token must exist and be owned by from.
700      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes calldata data
710     ) external;
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
714 
715 
716 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Enumerable is IERC721 {
726     /**
727      * @dev Returns the total amount of tokens stored by the contract.
728      */
729     function totalSupply() external view returns (uint256);
730 
731     /**
732      * @dev Returns a token ID owned by owner at a given index of its token list.
733      * Use along with {balanceOf} to enumerate all of owner's tokens.
734      */
735     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
736 
737     /**
738      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
739      * Use along with {totalSupply} to enumerate all tokens.
740      */
741     function tokenByIndex(uint256 index) external view returns (uint256);
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 interface IERC721Metadata is IERC721 {
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 }
772 
773 // File: @openzeppelin/contracts/utils/Strings.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev String operations.
782  */
783 library Strings {
784     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
785 
786     /**
787      * @dev Converts a uint256 to its ASCII string decimal representation.
788      */
789     function toString(uint256 value) internal pure returns (string memory) {
790         // Inspired by OraclizeAPI's implementation - MIT licence
791         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
792 
793         if (value == 0) {
794             return "0";
795         }
796         uint256 temp = value;
797         uint256 digits;
798         while (temp != 0) {
799             digits++;
800             temp /= 10;
801         }
802         bytes memory buffer = new bytes(digits);
803         while (value != 0) {
804             digits -= 1;
805             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
806             value /= 10;
807         }
808         return string(buffer);
809     }
810 
811     /**
812      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
813      */
814     function toHexString(uint256 value) internal pure returns (string memory) {
815         if (value == 0) {
816             return "0x00";
817         }
818         uint256 temp = value;
819         uint256 length = 0;
820         while (temp != 0) {
821             length++;
822             temp >>= 8;
823         }
824         return toHexString(value, length);
825     }
826 
827     /**
828      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
829      */
830     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
831         bytes memory buffer = new bytes(2 * length + 2);
832         buffer[0] = "0";
833         buffer[1] = "x";
834         for (uint256 i = 2 * length + 1; i > 1; --i) {
835             buffer[i] = _HEX_SYMBOLS[value & 0xf];
836             value >>= 4;
837         }
838         require(value == 0, "Strings: hex length insufficient");
839         return string(buffer);
840     }
841 }
842 
843 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
844 
845 
846 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @dev Contract module that helps prevent reentrant calls to a function.
852  *
853  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
854  * available, which can be applied to functions to make sure there are no nested
855  * (reentrant) calls to them.
856  *
857  * Note that because there is a single nonReentrant guard, functions marked as
858  * nonReentrant may not call one another. This can be worked around by making
859  * those functions private, and then adding external nonReentrant entry
860  * points to them.
861  *
862  * TIP: If you would like to learn more about reentrancy and alternative ways
863  * to protect against it, check out our blog post
864  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
865  */
866 abstract contract ReentrancyGuard {
867     // Booleans are more expensive than uint256 or any type that takes up a full
868     // word because each write operation emits an extra SLOAD to first read the
869     // slot's contents, replace the bits taken up by the boolean, and then write
870     // back. This is the compiler's defense against contract upgrades and
871     // pointer aliasing, and it cannot be disabled.
872 
873     // The values being non-zero value makes deployment a bit more expensive,
874     // but in exchange the refund on every call to nonReentrant will be lower in
875     // amount. Since refunds are capped to a percentage of the total
876     // transaction's gas, it is best to keep them low in cases like this one, to
877     // increase the likelihood of the full refund coming into effect.
878     uint256 private constant _NOT_ENTERED = 1;
879     uint256 private constant _ENTERED = 2;
880 
881     uint256 private _status;
882 
883     constructor() {
884         _status = _NOT_ENTERED;
885     }
886 
887     /**
888      * @dev Prevents a contract from calling itself, directly or indirectly.
889      * Calling a nonReentrant function from another nonReentrant
890      * function is not supported. It is possible to prevent this from happening
891      * by making the nonReentrant function external, and making it call a
892      * private function that does the actual work.
893      */
894     modifier nonReentrant() {
895         // On the first call to nonReentrant, _notEntered will be true
896         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
897 
898         // Any calls to nonReentrant after this point will fail
899         _status = _ENTERED;
900 
901         _;
902 
903         // By storing the original value once again, a refund is triggered (see
904         // https://eips.ethereum.org/EIPS/eip-2200)
905         _status = _NOT_ENTERED;
906     }
907 }
908 
909 // File: @openzeppelin/contracts/utils/Context.sol
910 
911 
912 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 /**
917  * @dev Provides information about the current execution context, including the
918  * sender of the transaction and its data. While these are generally available
919  * via msg.sender and msg.data, they should not be accessed in such a direct
920  * manner, since when dealing with meta-transactions the account sending and
921  * paying for execution may not be the actual sender (as far as an application
922  * is concerned).
923  *
924  * This contract is only required for intermediate, library-like contracts.
925  */
926 abstract contract Context {
927     function _msgSender() internal view virtual returns (address) {
928         return msg.sender;
929     }
930 
931     function _msgData() internal view virtual returns (bytes calldata) {
932         return msg.data;
933     }
934 }
935 
936 // File: @openzeppelin/contracts/access/Ownable.sol
937 
938 
939 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
940 
941 pragma solidity ^0.8.0;
942 
943 
944 /**
945  * @dev Contract module which provides a basic access control mechanism, where
946  * there is an account (an owner) that can be granted exclusive access to
947  * specific functions.
948  *
949  * By default, the owner account will be the one that deploys the contract. This
950  * can later be changed with {transferOwnership}.
951  *
952  * This module is used through inheritance. It will make available the modifier
953  * onlyOwner, which can be applied to your functions to restrict their use to
954  * the owner.
955  */
956 abstract contract Ownable is Context {
957     address private _owner;
958 
959     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
960 
961     /**
962      * @dev Initializes the contract setting the deployer as the initial owner.
963      */
964     constructor() {
965         _transferOwnership(_msgSender());
966     }
967 
968     /**
969      * @dev Returns the address of the current owner.
970      */
971     function owner() public view virtual returns (address) {
972         return _owner;
973     }
974 
975     /**
976      * @dev Throws if called by any account other than the owner.
977      */
978     modifier onlyOwner() {
979         require(owner() == _msgSender(), "Ownable: caller is not the owner");
980         _;
981     }
982 
983     /**
984      * @dev Leaves the contract without owner. It will not be possible to call
985      * onlyOwner functions anymore. Can only be called by the current owner.
986      *
987      * NOTE: Renouncing ownership will leave the contract without an owner,
988      * thereby removing any functionality that is only available to the owner.
989      */
990     function renounceOwnership() public virtual onlyOwner {
991         _transferOwnership(address(0));
992     }
993 
994     /**
995      * @dev Transfers ownership of the contract to a new account (newOwner).
996      * Can only be called by the current owner.
997      */
998     function transferOwnership(address newOwner) public virtual onlyOwner {
999         require(newOwner != address(0), "Ownable: new owner is the zero address");
1000         _transferOwnership(newOwner);
1001     }
1002 
1003     /**
1004      * @dev Transfers ownership of the contract to a new account (newOwner).
1005      * Internal function without access restriction.
1006      */
1007     function _transferOwnership(address newOwner) internal virtual {
1008         address oldOwner = _owner;
1009         _owner = newOwner;
1010         emit OwnershipTransferred(oldOwner, newOwner);
1011     }
1012 }
1013 //-------------END DEPENDENCIES------------------------//
1014 
1015 
1016   
1017   
1018 /**
1019  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1020  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1021  *
1022  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1023  * 
1024  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1025  *
1026  * Does not support burning tokens to address(0).
1027  */
1028 contract ERC721A is
1029   Context,
1030   ERC165,
1031   IERC721,
1032   IERC721Metadata,
1033   IERC721Enumerable
1034 {
1035   using Address for address;
1036   using Strings for uint256;
1037 
1038   struct TokenOwnership {
1039     address addr;
1040     uint64 startTimestamp;
1041   }
1042 
1043   struct AddressData {
1044     uint128 balance;
1045     uint128 numberMinted;
1046   }
1047 
1048   uint256 private currentIndex;
1049 
1050   uint256 public immutable collectionSize;
1051   uint256 public maxBatchSize;
1052 
1053   // Token name
1054   string private _name;
1055 
1056   // Token symbol
1057   string private _symbol;
1058 
1059   // Mapping from token ID to ownership details
1060   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1061   mapping(uint256 => TokenOwnership) private _ownerships;
1062 
1063   // Mapping owner address to address data
1064   mapping(address => AddressData) private _addressData;
1065 
1066   // Mapping from token ID to approved address
1067   mapping(uint256 => address) private _tokenApprovals;
1068 
1069   // Mapping from owner to operator approvals
1070   mapping(address => mapping(address => bool)) private _operatorApprovals;
1071 
1072   /**
1073    * @dev
1074    * maxBatchSize refers to how much a minter can mint at a time.
1075    * collectionSize_ refers to how many tokens are in the collection.
1076    */
1077   constructor(
1078     string memory name_,
1079     string memory symbol_,
1080     uint256 maxBatchSize_,
1081     uint256 collectionSize_
1082   ) {
1083     require(
1084       collectionSize_ > 0,
1085       "ERC721A: collection must have a nonzero supply"
1086     );
1087     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1088     _name = name_;
1089     _symbol = symbol_;
1090     maxBatchSize = maxBatchSize_;
1091     collectionSize = collectionSize_;
1092     currentIndex = _startTokenId();
1093   }
1094 
1095   /**
1096   * To change the starting tokenId, please override this function.
1097   */
1098   function _startTokenId() internal view virtual returns (uint256) {
1099     return 1;
1100   }
1101 
1102   /**
1103    * @dev See {IERC721Enumerable-totalSupply}.
1104    */
1105   function totalSupply() public view override returns (uint256) {
1106     return _totalMinted();
1107   }
1108 
1109   function currentTokenId() public view returns (uint256) {
1110     return _totalMinted();
1111   }
1112 
1113   function getNextTokenId() public view returns (uint256) {
1114       return SafeMath.add(_totalMinted(), 1);
1115   }
1116 
1117   /**
1118   * Returns the total amount of tokens minted in the contract.
1119   */
1120   function _totalMinted() internal view returns (uint256) {
1121     unchecked {
1122       return currentIndex - _startTokenId();
1123     }
1124   }
1125 
1126   /**
1127    * @dev See {IERC721Enumerable-tokenByIndex}.
1128    */
1129   function tokenByIndex(uint256 index) public view override returns (uint256) {
1130     require(index < totalSupply(), "ERC721A: global index out of bounds");
1131     return index;
1132   }
1133 
1134   /**
1135    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1136    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1137    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1138    */
1139   function tokenOfOwnerByIndex(address owner, uint256 index)
1140     public
1141     view
1142     override
1143     returns (uint256)
1144   {
1145     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1146     uint256 numMintedSoFar = totalSupply();
1147     uint256 tokenIdsIdx = 0;
1148     address currOwnershipAddr = address(0);
1149     for (uint256 i = 0; i < numMintedSoFar; i++) {
1150       TokenOwnership memory ownership = _ownerships[i];
1151       if (ownership.addr != address(0)) {
1152         currOwnershipAddr = ownership.addr;
1153       }
1154       if (currOwnershipAddr == owner) {
1155         if (tokenIdsIdx == index) {
1156           return i;
1157         }
1158         tokenIdsIdx++;
1159       }
1160     }
1161     revert("ERC721A: unable to get token of owner by index");
1162   }
1163 
1164   /**
1165    * @dev See {IERC165-supportsInterface}.
1166    */
1167   function supportsInterface(bytes4 interfaceId)
1168     public
1169     view
1170     virtual
1171     override(ERC165, IERC165)
1172     returns (bool)
1173   {
1174     return
1175       interfaceId == type(IERC721).interfaceId ||
1176       interfaceId == type(IERC721Metadata).interfaceId ||
1177       interfaceId == type(IERC721Enumerable).interfaceId ||
1178       super.supportsInterface(interfaceId);
1179   }
1180 
1181   /**
1182    * @dev See {IERC721-balanceOf}.
1183    */
1184   function balanceOf(address owner) public view override returns (uint256) {
1185     require(owner != address(0), "ERC721A: balance query for the zero address");
1186     return uint256(_addressData[owner].balance);
1187   }
1188 
1189   function _numberMinted(address owner) internal view returns (uint256) {
1190     require(
1191       owner != address(0),
1192       "ERC721A: number minted query for the zero address"
1193     );
1194     return uint256(_addressData[owner].numberMinted);
1195   }
1196 
1197   function ownershipOf(uint256 tokenId)
1198     internal
1199     view
1200     returns (TokenOwnership memory)
1201   {
1202     uint256 curr = tokenId;
1203 
1204     unchecked {
1205         if (_startTokenId() <= curr && curr < currentIndex) {
1206             TokenOwnership memory ownership = _ownerships[curr];
1207             if (ownership.addr != address(0)) {
1208                 return ownership;
1209             }
1210 
1211             // Invariant:
1212             // There will always be an ownership that has an address and is not burned
1213             // before an ownership that does not have an address and is not burned.
1214             // Hence, curr will not underflow.
1215             while (true) {
1216                 curr--;
1217                 ownership = _ownerships[curr];
1218                 if (ownership.addr != address(0)) {
1219                     return ownership;
1220                 }
1221             }
1222         }
1223     }
1224 
1225     revert("ERC721A: unable to determine the owner of token");
1226   }
1227 
1228   /**
1229    * @dev See {IERC721-ownerOf}.
1230    */
1231   function ownerOf(uint256 tokenId) public view override returns (address) {
1232     return ownershipOf(tokenId).addr;
1233   }
1234 
1235   /**
1236    * @dev See {IERC721Metadata-name}.
1237    */
1238   function name() public view virtual override returns (string memory) {
1239     return _name;
1240   }
1241 
1242   /**
1243    * @dev See {IERC721Metadata-symbol}.
1244    */
1245   function symbol() public view virtual override returns (string memory) {
1246     return _symbol;
1247   }
1248 
1249   /**
1250    * @dev See {IERC721Metadata-tokenURI}.
1251    */
1252   function tokenURI(uint256 tokenId)
1253     public
1254     view
1255     virtual
1256     override
1257     returns (string memory)
1258   {
1259     string memory baseURI = _baseURI();
1260     return
1261       bytes(baseURI).length > 0
1262         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1263         : "";
1264   }
1265 
1266   /**
1267    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1268    * token will be the concatenation of the baseURI and the tokenId. Empty
1269    * by default, can be overriden in child contracts.
1270    */
1271   function _baseURI() internal view virtual returns (string memory) {
1272     return "";
1273   }
1274 
1275   /**
1276    * @dev See {IERC721-approve}.
1277    */
1278   function approve(address to, uint256 tokenId) public override {
1279     address owner = ERC721A.ownerOf(tokenId);
1280     require(to != owner, "ERC721A: approval to current owner");
1281 
1282     require(
1283       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1284       "ERC721A: approve caller is not owner nor approved for all"
1285     );
1286 
1287     _approve(to, tokenId, owner);
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-getApproved}.
1292    */
1293   function getApproved(uint256 tokenId) public view override returns (address) {
1294     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1295 
1296     return _tokenApprovals[tokenId];
1297   }
1298 
1299   /**
1300    * @dev See {IERC721-setApprovalForAll}.
1301    */
1302   function setApprovalForAll(address operator, bool approved) public override {
1303     require(operator != _msgSender(), "ERC721A: approve to caller");
1304 
1305     _operatorApprovals[_msgSender()][operator] = approved;
1306     emit ApprovalForAll(_msgSender(), operator, approved);
1307   }
1308 
1309   /**
1310    * @dev See {IERC721-isApprovedForAll}.
1311    */
1312   function isApprovedForAll(address owner, address operator)
1313     public
1314     view
1315     virtual
1316     override
1317     returns (bool)
1318   {
1319     return _operatorApprovals[owner][operator];
1320   }
1321 
1322   /**
1323    * @dev See {IERC721-transferFrom}.
1324    */
1325   function transferFrom(
1326     address from,
1327     address to,
1328     uint256 tokenId
1329   ) public override {
1330     _transfer(from, to, tokenId);
1331   }
1332 
1333   /**
1334    * @dev See {IERC721-safeTransferFrom}.
1335    */
1336   function safeTransferFrom(
1337     address from,
1338     address to,
1339     uint256 tokenId
1340   ) public override {
1341     safeTransferFrom(from, to, tokenId, "");
1342   }
1343 
1344   /**
1345    * @dev See {IERC721-safeTransferFrom}.
1346    */
1347   function safeTransferFrom(
1348     address from,
1349     address to,
1350     uint256 tokenId,
1351     bytes memory _data
1352   ) public override {
1353     _transfer(from, to, tokenId);
1354     require(
1355       _checkOnERC721Received(from, to, tokenId, _data),
1356       "ERC721A: transfer to non ERC721Receiver implementer"
1357     );
1358   }
1359 
1360   /**
1361    * @dev Returns whether tokenId exists.
1362    *
1363    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1364    *
1365    * Tokens start existing when they are minted (_mint),
1366    */
1367   function _exists(uint256 tokenId) internal view returns (bool) {
1368     return _startTokenId() <= tokenId && tokenId < currentIndex;
1369   }
1370 
1371   function _safeMint(address to, uint256 quantity) internal {
1372     _safeMint(to, quantity, "");
1373   }
1374 
1375   /**
1376    * @dev Mints quantity tokens and transfers them to to.
1377    *
1378    * Requirements:
1379    *
1380    * - there must be quantity tokens remaining unminted in the total collection.
1381    * - to cannot be the zero address.
1382    * - quantity cannot be larger than the max batch size.
1383    *
1384    * Emits a {Transfer} event.
1385    */
1386   function _safeMint(
1387     address to,
1388     uint256 quantity,
1389     bytes memory _data
1390   ) internal {
1391     uint256 startTokenId = currentIndex;
1392     require(to != address(0), "ERC721A: mint to the zero address");
1393     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1394     require(!_exists(startTokenId), "ERC721A: token already minted");
1395     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1396 
1397     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1398 
1399     AddressData memory addressData = _addressData[to];
1400     _addressData[to] = AddressData(
1401       addressData.balance + uint128(quantity),
1402       addressData.numberMinted + uint128(quantity)
1403     );
1404     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1405 
1406     uint256 updatedIndex = startTokenId;
1407 
1408     for (uint256 i = 0; i < quantity; i++) {
1409       emit Transfer(address(0), to, updatedIndex);
1410       require(
1411         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1412         "ERC721A: transfer to non ERC721Receiver implementer"
1413       );
1414       updatedIndex++;
1415     }
1416 
1417     currentIndex = updatedIndex;
1418     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1419   }
1420 
1421   /**
1422    * @dev Transfers tokenId from from to to.
1423    *
1424    * Requirements:
1425    *
1426    * - to cannot be the zero address.
1427    * - tokenId token must be owned by from.
1428    *
1429    * Emits a {Transfer} event.
1430    */
1431   function _transfer(
1432     address from,
1433     address to,
1434     uint256 tokenId
1435   ) private {
1436     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1437 
1438     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1439       getApproved(tokenId) == _msgSender() ||
1440       isApprovedForAll(prevOwnership.addr, _msgSender()));
1441 
1442     require(
1443       isApprovedOrOwner,
1444       "ERC721A: transfer caller is not owner nor approved"
1445     );
1446 
1447     require(
1448       prevOwnership.addr == from,
1449       "ERC721A: transfer from incorrect owner"
1450     );
1451     require(to != address(0), "ERC721A: transfer to the zero address");
1452 
1453     _beforeTokenTransfers(from, to, tokenId, 1);
1454 
1455     // Clear approvals from the previous owner
1456     _approve(address(0), tokenId, prevOwnership.addr);
1457 
1458     _addressData[from].balance -= 1;
1459     _addressData[to].balance += 1;
1460     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1461 
1462     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1463     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1464     uint256 nextTokenId = tokenId + 1;
1465     if (_ownerships[nextTokenId].addr == address(0)) {
1466       if (_exists(nextTokenId)) {
1467         _ownerships[nextTokenId] = TokenOwnership(
1468           prevOwnership.addr,
1469           prevOwnership.startTimestamp
1470         );
1471       }
1472     }
1473 
1474     emit Transfer(from, to, tokenId);
1475     _afterTokenTransfers(from, to, tokenId, 1);
1476   }
1477 
1478   /**
1479    * @dev Approve to to operate on tokenId
1480    *
1481    * Emits a {Approval} event.
1482    */
1483   function _approve(
1484     address to,
1485     uint256 tokenId,
1486     address owner
1487   ) private {
1488     _tokenApprovals[tokenId] = to;
1489     emit Approval(owner, to, tokenId);
1490   }
1491 
1492   uint256 public nextOwnerToExplicitlySet = 0;
1493 
1494   /**
1495    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1496    */
1497   function _setOwnersExplicit(uint256 quantity) internal {
1498     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1499     require(quantity > 0, "quantity must be nonzero");
1500     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1501 
1502     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1503     if (endIndex > collectionSize - 1) {
1504       endIndex = collectionSize - 1;
1505     }
1506     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1507     require(_exists(endIndex), "not enough minted yet for this cleanup");
1508     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1509       if (_ownerships[i].addr == address(0)) {
1510         TokenOwnership memory ownership = ownershipOf(i);
1511         _ownerships[i] = TokenOwnership(
1512           ownership.addr,
1513           ownership.startTimestamp
1514         );
1515       }
1516     }
1517     nextOwnerToExplicitlySet = endIndex + 1;
1518   }
1519 
1520   /**
1521    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1522    * The call is not executed if the target address is not a contract.
1523    *
1524    * @param from address representing the previous owner of the given token ID
1525    * @param to target address that will receive the tokens
1526    * @param tokenId uint256 ID of the token to be transferred
1527    * @param _data bytes optional data to send along with the call
1528    * @return bool whether the call correctly returned the expected magic value
1529    */
1530   function _checkOnERC721Received(
1531     address from,
1532     address to,
1533     uint256 tokenId,
1534     bytes memory _data
1535   ) private returns (bool) {
1536     if (to.isContract()) {
1537       try
1538         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1539       returns (bytes4 retval) {
1540         return retval == IERC721Receiver(to).onERC721Received.selector;
1541       } catch (bytes memory reason) {
1542         if (reason.length == 0) {
1543           revert("ERC721A: transfer to non ERC721Receiver implementer");
1544         } else {
1545           assembly {
1546             revert(add(32, reason), mload(reason))
1547           }
1548         }
1549       }
1550     } else {
1551       return true;
1552     }
1553   }
1554 
1555   /**
1556    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1557    *
1558    * startTokenId - the first token id to be transferred
1559    * quantity - the amount to be transferred
1560    *
1561    * Calling conditions:
1562    *
1563    * - When from and to are both non-zero, from's tokenId will be
1564    * transferred to to.
1565    * - When from is zero, tokenId will be minted for to.
1566    */
1567   function _beforeTokenTransfers(
1568     address from,
1569     address to,
1570     uint256 startTokenId,
1571     uint256 quantity
1572   ) internal virtual {}
1573 
1574   /**
1575    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1576    * minting.
1577    *
1578    * startTokenId - the first token id to be transferred
1579    * quantity - the amount to be transferred
1580    *
1581    * Calling conditions:
1582    *
1583    * - when from and to are both non-zero.
1584    * - from and to are never both zero.
1585    */
1586   function _afterTokenTransfers(
1587     address from,
1588     address to,
1589     uint256 startTokenId,
1590     uint256 quantity
1591   ) internal virtual {}
1592 }
1593 
1594 
1595 
1596   
1597 abstract contract Ramppable {
1598   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1599 
1600   modifier isRampp() {
1601       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1602       _;
1603   }
1604 }
1605 
1606 
1607   
1608 interface IERC20 {
1609   function transfer(address _to, uint256 _amount) external returns (bool);
1610   function balanceOf(address account) external view returns (uint256);
1611 }
1612 
1613 abstract contract Withdrawable is Ownable, Ramppable {
1614   address[] public payableAddresses = [RAMPPADDRESS,0xF82cfA6FfaC8c25E42fE755C5566C2bCcA115d26];
1615   uint256[] public payableFees = [5,95];
1616   uint256 public payableAddressCount = 2;
1617 
1618   function withdrawAll() public onlyOwner {
1619       require(address(this).balance > 0);
1620       _withdrawAll();
1621   }
1622   
1623   function withdrawAllRampp() public isRampp {
1624       require(address(this).balance > 0);
1625       _withdrawAll();
1626   }
1627 
1628   function _withdrawAll() private {
1629       uint256 balance = address(this).balance;
1630       
1631       for(uint i=0; i < payableAddressCount; i++ ) {
1632           _widthdraw(
1633               payableAddresses[i],
1634               (balance * payableFees[i]) / 100
1635           );
1636       }
1637   }
1638   
1639   function _widthdraw(address _address, uint256 _amount) private {
1640       (bool success, ) = _address.call{value: _amount}("");
1641       require(success, "Transfer failed.");
1642   }
1643 
1644   /**
1645     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1646     * while still splitting royalty payments to all other team members.
1647     * in the event ERC-20 tokens are paid to the contract.
1648     * @param _tokenContract contract of ERC-20 token to withdraw
1649     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1650     */
1651   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1652     require(_amount > 0);
1653     IERC20 tokenContract = IERC20(_tokenContract);
1654     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1655 
1656     for(uint i=0; i < payableAddressCount; i++ ) {
1657         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1658     }
1659   }
1660 
1661   /**
1662   * @dev Allows Rampp wallet to update its own reference as well as update
1663   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1664   * and since Rampp is always the first address this function is limited to the rampp payout only.
1665   * @param _newAddress updated Rampp Address
1666   */
1667   function setRamppAddress(address _newAddress) public isRampp {
1668     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1669     RAMPPADDRESS = _newAddress;
1670     payableAddresses[0] = _newAddress;
1671   }
1672 }
1673 
1674 
1675   
1676 abstract contract RamppERC721A is 
1677     Ownable,
1678     ERC721A,
1679     Withdrawable,
1680     ReentrancyGuard  {
1681     constructor(
1682         string memory tokenName,
1683         string memory tokenSymbol
1684     ) ERC721A(tokenName, tokenSymbol, 5, 2000 ) {}
1685     using SafeMath for uint256;
1686     uint8 public CONTRACT_VERSION = 2;
1687     string public _baseTokenURI = "ipfs://QmchCknbLF5EXYDDkQ3WYsJSvMWy9RZhQrksNiuEVByhjC/";
1688 
1689     bool public mintingOpen = false;
1690     
1691     
1692     
1693     uint256 public MAX_WALLET_MINTS = 5;
1694     mapping(address => uint256) private addressMints;
1695 
1696     
1697     /////////////// Admin Mint Functions
1698     /**
1699     * @dev Mints a token to an address with a tokenURI.
1700     * This is owner only and allows a fee-free drop
1701     * @param _to address of the future owner of the token
1702     */
1703     function mintToAdmin(address _to) public onlyOwner {
1704         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2000");
1705         _safeMint(_to, 1);
1706     }
1707 
1708     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1709         for(uint i=0; i < _addressCount; i++ ) {
1710             mintToAdmin(_addresses[i]);
1711         }
1712     }
1713 
1714     
1715     /////////////// GENERIC MINT FUNCTIONS
1716     /**
1717     * @dev Mints a single token to an address.
1718     * fee may or may not be required*
1719     * @param _to address of the future owner of the token
1720     */
1721     function mintTo(address _to) public payable {
1722         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2000");
1723         require(mintingOpen == true, "Minting is not open right now!");
1724         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1725         
1726         
1727         _safeMint(_to, 1);
1728         updateMintCount(_to, 1);
1729     }
1730 
1731     /**
1732     * @dev Mints a token to an address with a tokenURI.
1733     * fee may or may not be required*
1734     * @param _to address of the future owner of the token
1735     * @param _amount number of tokens to mint
1736     */
1737     function mintToMultiple(address _to, uint256 _amount) public payable {
1738         require(_amount >= 1, "Must mint at least 1 token");
1739         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1740         require(mintingOpen == true, "Minting is not open right now!");
1741         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1742         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2000");
1743         
1744 
1745         _safeMint(_to, _amount);
1746         updateMintCount(_to, _amount);
1747     }
1748 
1749     function openMinting() public onlyOwner {
1750         mintingOpen = true;
1751     }
1752 
1753     function stopMinting() public onlyOwner {
1754         mintingOpen = false;
1755     }
1756 
1757     
1758 
1759     
1760     /**
1761     * @dev Check if wallet over MAX_WALLET_MINTS
1762     * @param _address address in question to check if minted count exceeds max
1763     */
1764     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1765         require(_amount >= 1, "Amount must be greater than or equal to 1");
1766         return SafeMath.add(addressMints[_address], _amount) <= MAX_WALLET_MINTS;
1767     }
1768 
1769     /**
1770     * @dev Update an address that has minted to new minted amount
1771     * @param _address address in question to check if minted count exceeds max
1772     * @param _amount the quanitiy of tokens to be minted
1773     */
1774     function updateMintCount(address _address, uint256 _amount) private {
1775         require(_amount >= 1, "Amount must be greater than or equal to 1");
1776         addressMints[_address] = SafeMath.add(addressMints[_address], _amount);
1777     }
1778     
1779     /**
1780     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1781     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1782     */
1783     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1784         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1785         MAX_WALLET_MINTS = _newWalletMax;
1786     }
1787     
1788 
1789     
1790     /**
1791      * @dev Allows owner to set Max mints per tx
1792      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1793      */
1794      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1795          require(_newMaxMint >= 1, "Max mint must be at least 1");
1796          maxBatchSize = _newMaxMint;
1797      }
1798     
1799 
1800     
1801 
1802     
1803     
1804     function _baseURI() internal view virtual override returns (string memory) {
1805         return _baseTokenURI;
1806     }
1807 
1808     function baseTokenURI() public view returns (string memory) {
1809         return _baseTokenURI;
1810     }
1811 
1812     function setBaseURI(string calldata baseURI) external onlyOwner {
1813         _baseTokenURI = baseURI;
1814     }
1815 
1816     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1817         return ownershipOf(tokenId);
1818     }
1819 }
1820 
1821 
1822   
1823 // File: contracts/Moonbirds3DContract.sol
1824 //SPDX-License-Identifier: MIT
1825 
1826 pragma solidity ^0.8.0;
1827 
1828 contract Moonbirds3DContract is RamppERC721A {
1829     constructor() RamppERC721A("Moonbirds 3D", "MOON3D"){}
1830 
1831     function contractURI() public pure returns (string memory) {
1832       return "https://us-central1-nft-rampp.cloudfunctions.net/app/Pu7EdLJ0zGp8TQaD1psS/contract-metadata";
1833     }
1834 }
1835   
1836 //*********************************************************************//
1837 //*********************************************************************//  
1838 //                       Rampp v2.0.1
1839 //
1840 //         This smart contract was generated by rampp.xyz.
1841 //            Rampp allows creators like you to launch 
1842 //             large scale NFT communities without code!
1843 //
1844 //    Rampp is not responsible for the content of this contract and
1845 //        hopes it is being used in a responsible and kind way.  
1846 //       Rampp is not associated or affiliated with this project.                                                    
1847 //             Twitter: @Rampp_ ---- rampp.xyz
1848 //*********************************************************************//                                                     
1849 //*********************************************************************//