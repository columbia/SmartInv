1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //            _____                    _____     _____                    _____                    _____          
5 //          /\    \                  /\    \   /\    \                  /\    \                  /\    \         
6 //         /::\____\                /::\____\ /::\    \                /::\    \                /::\    \        
7 //        /:::/    /               /:::/    / \:::\    \              /::::\    \              /::::\    \       
8 //       /:::/    /               /:::/    /   \:::\    \            /::::::\    \            /::::::\    \      
9 //      /:::/    /               /:::/    /     \:::\    \          /:::/\:::\    \          /:::/\:::\    \     
10 //     /:::/    /               /:::/    /       \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \    
11 //    /:::/    /               /:::/    /        /::::\    \      /::::\   \:::\    \      /::::\   \:::\    \   
12 //   /:::/    /      _____    /:::/    /        /::::::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \  
13 //  /:::/____/      /\    \  /:::/    /        /:::/\:::\    \  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \ 
14 // |:::|    /      /::\____\/:::/____/        /:::/  \:::\____\/:::/  \:::\   \:::|    |/:::/  \:::\   \:::\____\
15 // |:::|____\     /:::/    /\:::\    \       /:::/    \::/    /\::/   |::::\  /:::|____|\::/    \:::\  /:::/    /
16 //  \:::\    \   /:::/    /  \:::\    \     /:::/    / \/____/  \/____|:::::\/:::/    /  \/____/ \:::\/:::/    / 
17 //   \:::\    \ /:::/    /    \:::\    \   /:::/    /                 |:::::::::/    /            \::::::/    /  
18 //    \:::\    /:::/    /      \:::\    \ /:::/    /                  |::|\::::/    /              \::::/    /   
19 //     \:::\__/:::/    /        \:::\    \\::/    /                   |::| \::/____/               /:::/    /    
20 //      \::::::::/    /          \:::\    \\/____/                    |::|  ~|                    /:::/    /     
21 //       \::::::/    /            \:::\    \                          |::|   |                   /:::/    /      
22 //        \::::/    /              \:::\____\                         \::|   |                  /:::/    /       
23 //         \::/____/                \::/    /                          \:|   |                  \::/    /        
24 //          ~~                       \/____/                            \|___|                   \/____/         
25 //                                                                                                               
26 //
27 //*********************************************************************//
28 //*********************************************************************//
29   
30 //-------------DEPENDENCIES--------------------------//
31 
32 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
33 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 // CAUTION
38 // This version of SafeMath should only be used with Solidity 0.8 or later,
39 // because it relies on the compiler's built in overflow checks.
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations.
43  *
44  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
45  * now has built in overflow checking.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             uint256 c = a + b;
56             if (c < a) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
63      *
64      * _Available since v3.4._
65      */
66     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b > a) return (false, 0);
69             return (true, a - b);
70         }
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81             // benefit is lost if 'b' is also tested.
82             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83             if (a == 0) return (true, 0);
84             uint256 c = a * b;
85             if (c / a != b) return (false, 0);
86             return (true, c);
87         }
88     }
89 
90     /**
91      * @dev Returns the division of two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         unchecked {
97             if (b == 0) return (false, 0);
98             return (true, a / b);
99         }
100     }
101 
102     /**
103      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b == 0) return (false, 0);
110             return (true, a % b);
111         }
112     }
113 
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's + operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a + b;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's - operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a - b;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's * operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a * b;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers, reverting on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's / operator.
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         return a / b;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * reverting when dividing by zero.
173      *
174      * Counterpart to Solidity's % operator. This function uses a revert
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a % b;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
188      * overflow (when the result is negative).
189      *
190      * CAUTION: This function is deprecated because it requires allocating memory for the error
191      * message unnecessarily. For custom revert reasons use {trySub}.
192      *
193      * Counterpart to Solidity's - operator.
194      *
195      * Requirements:
196      *
197      * - Subtraction cannot overflow.
198      */
199     function sub(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b <= a, errorMessage);
206             return a - b;
207         }
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's / operator. Note: this function uses a
215      * revert opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a / b;
230         }
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * reverting with custom message when dividing by zero.
236      *
237      * CAUTION: This function is deprecated because it requires allocating memory for the error
238      * message unnecessarily. For custom revert reasons use {tryMod}.
239      *
240      * Counterpart to Solidity's % operator. This function uses a revert
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b > 0, errorMessage);
255             return a % b;
256         }
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
264 
265 pragma solidity ^0.8.1;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if account is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, isContract will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      *
288      * [IMPORTANT]
289      * ====
290      * You shouldn't rely on isContract to protect against flash loan attacks!
291      *
292      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
293      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
294      * constructor.
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize/address.code.length, which returns 0
299         // for contracts in construction, since the code is only stored at the end
300         // of the constructor execution.
301 
302         return account.code.length > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's transfer: sends amount wei to
307      * recipient, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by transfer, making them unable to receive funds via
312      * transfer. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to recipient, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         (bool success, ) = recipient.call{value: amount}("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level call. A
330      * plain call is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If target reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
338      *
339      * Requirements:
340      *
341      * - target must be a contract.
342      * - calling target with data must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
352      * errorMessage as a fallback revert reason when target reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
366      * but also transferring value wei to target.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least value.
371      * - the called Solidity function must be payable.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
385      * with errorMessage as a fallback revert reason when target reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @title ERC721 token receiver interface
494  * @dev Interface for any contract that wants to support safeTransfers
495  * from ERC721 asset contracts.
496  */
497 interface IERC721Receiver {
498     /**
499      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
500      * by operator from from, this function is called.
501      *
502      * It must return its Solidity selector to confirm the token transfer.
503      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
504      *
505      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
506      */
507     function onERC721Received(
508         address operator,
509         address from,
510         uint256 tokenId,
511         bytes calldata data
512     ) external returns (bytes4);
513 }
514 
515 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Interface of the ERC165 standard, as defined in the
524  * https://eips.ethereum.org/EIPS/eip-165[EIP].
525  *
526  * Implementers can declare support of contract interfaces, which can then be
527  * queried by others ({ERC165Checker}).
528  *
529  * For an implementation, see {ERC165}.
530  */
531 interface IERC165 {
532     /**
533      * @dev Returns true if this contract implements the interface defined by
534      * interfaceId. See the corresponding
535      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
536      * to learn more about how these ids are created.
537      *
538      * This function call must use less than 30 000 gas.
539      */
540     function supportsInterface(bytes4 interfaceId) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * 
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Required interface of an ERC721 compliant contract.
584  */
585 interface IERC721 is IERC165 {
586     /**
587      * @dev Emitted when tokenId token is transferred from from to to.
588      */
589     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when owner enables approved to manage the tokenId token.
593      */
594     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
598      */
599     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
600 
601     /**
602      * @dev Returns the number of tokens in owner's account.
603      */
604     function balanceOf(address owner) external view returns (uint256 balance);
605 
606     /**
607      * @dev Returns the owner of the tokenId token.
608      *
609      * Requirements:
610      *
611      * - tokenId must exist.
612      */
613     function ownerOf(uint256 tokenId) external view returns (address owner);
614 
615     /**
616      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
618      *
619      * Requirements:
620      *
621      * - from cannot be the zero address.
622      * - to cannot be the zero address.
623      * - tokenId token must exist and be owned by from.
624      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
625      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Transfers tokenId token from from to to.
637      *
638      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
639      *
640      * Requirements:
641      *
642      * - from cannot be the zero address.
643      * - to cannot be the zero address.
644      * - tokenId token must be owned by from.
645      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
646      *
647      * Emits a {Transfer} event.
648      */
649     function transferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Gives permission to to to transfer tokenId token to another account.
657      * The approval is cleared when the token is transferred.
658      *
659      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
660      *
661      * Requirements:
662      *
663      * - The caller must own the token or be an approved operator.
664      * - tokenId must exist.
665      *
666      * Emits an {Approval} event.
667      */
668     function approve(address to, uint256 tokenId) external;
669 
670     /**
671      * @dev Returns the account approved for tokenId token.
672      *
673      * Requirements:
674      *
675      * - tokenId must exist.
676      */
677     function getApproved(uint256 tokenId) external view returns (address operator);
678 
679     /**
680      * @dev Approve or remove operator as an operator for the caller.
681      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
682      *
683      * Requirements:
684      *
685      * - The operator cannot be the caller.
686      *
687      * Emits an {ApprovalForAll} event.
688      */
689     function setApprovalForAll(address operator, bool _approved) external;
690 
691     /**
692      * @dev Returns if the operator is allowed to manage all of the assets of owner.
693      *
694      * See {setApprovalForAll}
695      */
696     function isApprovedForAll(address owner, address operator) external view returns (bool);
697 
698     /**
699      * @dev Safely transfers tokenId token from from to to.
700      *
701      * Requirements:
702      *
703      * - from cannot be the zero address.
704      * - to cannot be the zero address.
705      * - tokenId token must exist and be owned by from.
706      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
708      *
709      * Emits a {Transfer} event.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId,
715         bytes calldata data
716     ) external;
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
720 
721 
722 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
729  * @dev See https://eips.ethereum.org/EIPS/eip-721
730  */
731 interface IERC721Enumerable is IERC721 {
732     /**
733      * @dev Returns the total amount of tokens stored by the contract.
734      */
735     function totalSupply() external view returns (uint256);
736 
737     /**
738      * @dev Returns a token ID owned by owner at a given index of its token list.
739      * Use along with {balanceOf} to enumerate all of owner's tokens.
740      */
741     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
742 
743     /**
744      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
745      * Use along with {totalSupply} to enumerate all tokens.
746      */
747     function tokenByIndex(uint256 index) external view returns (uint256);
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
760  * @dev See https://eips.ethereum.org/EIPS/eip-721
761  */
762 interface IERC721Metadata is IERC721 {
763     /**
764      * @dev Returns the token collection name.
765      */
766     function name() external view returns (string memory);
767 
768     /**
769      * @dev Returns the token collection symbol.
770      */
771     function symbol() external view returns (string memory);
772 
773     /**
774      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
775      */
776     function tokenURI(uint256 tokenId) external view returns (string memory);
777 }
778 
779 // File: @openzeppelin/contracts/utils/Strings.sol
780 
781 
782 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @dev String operations.
788  */
789 library Strings {
790     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
791 
792     /**
793      * @dev Converts a uint256 to its ASCII string decimal representation.
794      */
795     function toString(uint256 value) internal pure returns (string memory) {
796         // Inspired by OraclizeAPI's implementation - MIT licence
797         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
798 
799         if (value == 0) {
800             return "0";
801         }
802         uint256 temp = value;
803         uint256 digits;
804         while (temp != 0) {
805             digits++;
806             temp /= 10;
807         }
808         bytes memory buffer = new bytes(digits);
809         while (value != 0) {
810             digits -= 1;
811             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
812             value /= 10;
813         }
814         return string(buffer);
815     }
816 
817     /**
818      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
819      */
820     function toHexString(uint256 value) internal pure returns (string memory) {
821         if (value == 0) {
822             return "0x00";
823         }
824         uint256 temp = value;
825         uint256 length = 0;
826         while (temp != 0) {
827             length++;
828             temp >>= 8;
829         }
830         return toHexString(value, length);
831     }
832 
833     /**
834      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
835      */
836     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
837         bytes memory buffer = new bytes(2 * length + 2);
838         buffer[0] = "0";
839         buffer[1] = "x";
840         for (uint256 i = 2 * length + 1; i > 1; --i) {
841             buffer[i] = _HEX_SYMBOLS[value & 0xf];
842             value >>= 4;
843         }
844         require(value == 0, "Strings: hex length insufficient");
845         return string(buffer);
846     }
847 }
848 
849 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 /**
857  * @dev Contract module that helps prevent reentrant calls to a function.
858  *
859  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
860  * available, which can be applied to functions to make sure there are no nested
861  * (reentrant) calls to them.
862  *
863  * Note that because there is a single nonReentrant guard, functions marked as
864  * nonReentrant may not call one another. This can be worked around by making
865  * those functions private, and then adding external nonReentrant entry
866  * points to them.
867  *
868  * TIP: If you would like to learn more about reentrancy and alternative ways
869  * to protect against it, check out our blog post
870  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
871  */
872 abstract contract ReentrancyGuard {
873     // Booleans are more expensive than uint256 or any type that takes up a full
874     // word because each write operation emits an extra SLOAD to first read the
875     // slot's contents, replace the bits taken up by the boolean, and then write
876     // back. This is the compiler's defense against contract upgrades and
877     // pointer aliasing, and it cannot be disabled.
878 
879     // The values being non-zero value makes deployment a bit more expensive,
880     // but in exchange the refund on every call to nonReentrant will be lower in
881     // amount. Since refunds are capped to a percentage of the total
882     // transaction's gas, it is best to keep them low in cases like this one, to
883     // increase the likelihood of the full refund coming into effect.
884     uint256 private constant _NOT_ENTERED = 1;
885     uint256 private constant _ENTERED = 2;
886 
887     uint256 private _status;
888 
889     constructor() {
890         _status = _NOT_ENTERED;
891     }
892 
893     /**
894      * @dev Prevents a contract from calling itself, directly or indirectly.
895      * Calling a nonReentrant function from another nonReentrant
896      * function is not supported. It is possible to prevent this from happening
897      * by making the nonReentrant function external, and making it call a
898      * private function that does the actual work.
899      */
900     modifier nonReentrant() {
901         // On the first call to nonReentrant, _notEntered will be true
902         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
903 
904         // Any calls to nonReentrant after this point will fail
905         _status = _ENTERED;
906 
907         _;
908 
909         // By storing the original value once again, a refund is triggered (see
910         // https://eips.ethereum.org/EIPS/eip-2200)
911         _status = _NOT_ENTERED;
912     }
913 }
914 
915 // File: @openzeppelin/contracts/utils/Context.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Provides information about the current execution context, including the
924  * sender of the transaction and its data. While these are generally available
925  * via msg.sender and msg.data, they should not be accessed in such a direct
926  * manner, since when dealing with meta-transactions the account sending and
927  * paying for execution may not be the actual sender (as far as an application
928  * is concerned).
929  *
930  * This contract is only required for intermediate, library-like contracts.
931  */
932 abstract contract Context {
933     function _msgSender() internal view virtual returns (address) {
934         return msg.sender;
935     }
936 
937     function _msgData() internal view virtual returns (bytes calldata) {
938         return msg.data;
939     }
940 }
941 
942 // File: @openzeppelin/contracts/access/Ownable.sol
943 
944 
945 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 
950 /**
951  * @dev Contract module which provides a basic access control mechanism, where
952  * there is an account (an owner) that can be granted exclusive access to
953  * specific functions.
954  *
955  * By default, the owner account will be the one that deploys the contract. This
956  * can later be changed with {transferOwnership}.
957  *
958  * This module is used through inheritance. It will make available the modifier
959  * onlyOwner, which can be applied to your functions to restrict their use to
960  * the owner.
961  */
962 abstract contract Ownable is Context {
963     address private _owner;
964 
965     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
966 
967     /**
968      * @dev Initializes the contract setting the deployer as the initial owner.
969      */
970     constructor() {
971         _transferOwnership(_msgSender());
972     }
973 
974     /**
975      * @dev Returns the address of the current owner.
976      */
977     function owner() public view virtual returns (address) {
978         return _owner;
979     }
980 
981     /**
982      * @dev Throws if called by any account other than the owner.
983      */
984     modifier onlyOwner() {
985         require(owner() == _msgSender(), "Ownable: caller is not the owner");
986         _;
987     }
988 
989     /**
990      * @dev Leaves the contract without owner. It will not be possible to call
991      * onlyOwner functions anymore. Can only be called by the current owner.
992      *
993      * NOTE: Renouncing ownership will leave the contract without an owner,
994      * thereby removing any functionality that is only available to the owner.
995      */
996     function renounceOwnership() public virtual onlyOwner {
997         _transferOwnership(address(0));
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (newOwner).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(newOwner != address(0), "Ownable: new owner is the zero address");
1006         _transferOwnership(newOwner);
1007     }
1008 
1009     /**
1010      * @dev Transfers ownership of the contract to a new account (newOwner).
1011      * Internal function without access restriction.
1012      */
1013     function _transferOwnership(address newOwner) internal virtual {
1014         address oldOwner = _owner;
1015         _owner = newOwner;
1016         emit OwnershipTransferred(oldOwner, newOwner);
1017     }
1018 }
1019 //-------------END DEPENDENCIES------------------------//
1020 
1021 
1022   
1023   pragma solidity ^0.8.0;
1024 
1025   /**
1026   * @dev These functions deal with verification of Merkle Trees proofs.
1027   *
1028   * The proofs can be generated using the JavaScript library
1029   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1030   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1031   *
1032   *
1033   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1034   * hashing, or use a hash function other than keccak256 for hashing leaves.
1035   * This is because the concatenation of a sorted pair of internal nodes in
1036   * the merkle tree could be reinterpreted as a leaf value.
1037   */
1038   library MerkleProof {
1039       /**
1040       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1041       * defined by 'root'. For this, a 'proof' must be provided, containing
1042       * sibling hashes on the branch from the leaf to the root of the tree. Each
1043       * pair of leaves and each pair of pre-images are assumed to be sorted.
1044       */
1045       function verify(
1046           bytes32[] memory proof,
1047           bytes32 root,
1048           bytes32 leaf
1049       ) internal pure returns (bool) {
1050           return processProof(proof, leaf) == root;
1051       }
1052 
1053       /**
1054       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1055       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1056       * hash matches the root of the tree. When processing the proof, the pairs
1057       * of leafs & pre-images are assumed to be sorted.
1058       *
1059       * _Available since v4.4._
1060       */
1061       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1062           bytes32 computedHash = leaf;
1063           for (uint256 i = 0; i < proof.length; i++) {
1064               bytes32 proofElement = proof[i];
1065               if (computedHash <= proofElement) {
1066                   // Hash(current computed hash + current element of the proof)
1067                   computedHash = _efficientHash(computedHash, proofElement);
1068               } else {
1069                   // Hash(current element of the proof + current computed hash)
1070                   computedHash = _efficientHash(proofElement, computedHash);
1071               }
1072           }
1073           return computedHash;
1074       }
1075 
1076       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1077           assembly {
1078               mstore(0x00, a)
1079               mstore(0x20, b)
1080               value := keccak256(0x00, 0x40)
1081           }
1082       }
1083   }
1084 
1085 
1086   // File: Allowlist.sol
1087 
1088   pragma solidity ^0.8.0;
1089 
1090   abstract contract Allowlist is Ownable {
1091     bytes32 public merkleRoot;
1092     bool public onlyAllowlistMode = false;
1093 
1094     /**
1095      * @dev Update merkle root to reflect changes in Allowlist
1096      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1097      */
1098     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
1099       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1100       merkleRoot = _newMerkleRoot;
1101     }
1102 
1103     /**
1104      * @dev Check the proof of an address if valid for merkle root
1105      * @param _to address to check for proof
1106      * @param _merkleProof Proof of the address to validate against root and leaf
1107      */
1108     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1109       require(merkleRoot != 0, "Merkle root is not set!");
1110       bytes32 leaf = keccak256(abi.encodePacked(_to));
1111 
1112       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1113     }
1114 
1115     
1116     function enableAllowlistOnlyMode() public onlyOwner {
1117       onlyAllowlistMode = true;
1118     }
1119 
1120     function disableAllowlistOnlyMode() public onlyOwner {
1121         onlyAllowlistMode = false;
1122     }
1123   }
1124   
1125   
1126 /**
1127  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1128  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1129  *
1130  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1131  * 
1132  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1133  *
1134  * Does not support burning tokens to address(0).
1135  */
1136 contract ERC721A is
1137   Context,
1138   ERC165,
1139   IERC721,
1140   IERC721Metadata,
1141   IERC721Enumerable
1142 {
1143   using Address for address;
1144   using Strings for uint256;
1145 
1146   struct TokenOwnership {
1147     address addr;
1148     uint64 startTimestamp;
1149   }
1150 
1151   struct AddressData {
1152     uint128 balance;
1153     uint128 numberMinted;
1154   }
1155 
1156   uint256 private currentIndex;
1157 
1158   uint256 public immutable collectionSize;
1159   uint256 public maxBatchSize;
1160 
1161   // Token name
1162   string private _name;
1163 
1164   // Token symbol
1165   string private _symbol;
1166 
1167   // Mapping from token ID to ownership details
1168   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1169   mapping(uint256 => TokenOwnership) private _ownerships;
1170 
1171   // Mapping owner address to address data
1172   mapping(address => AddressData) private _addressData;
1173 
1174   // Mapping from token ID to approved address
1175   mapping(uint256 => address) private _tokenApprovals;
1176 
1177   // Mapping from owner to operator approvals
1178   mapping(address => mapping(address => bool)) private _operatorApprovals;
1179 
1180   /**
1181    * @dev
1182    * maxBatchSize refers to how much a minter can mint at a time.
1183    * collectionSize_ refers to how many tokens are in the collection.
1184    */
1185   constructor(
1186     string memory name_,
1187     string memory symbol_,
1188     uint256 maxBatchSize_,
1189     uint256 collectionSize_
1190   ) {
1191     require(
1192       collectionSize_ > 0,
1193       "ERC721A: collection must have a nonzero supply"
1194     );
1195     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1196     _name = name_;
1197     _symbol = symbol_;
1198     maxBatchSize = maxBatchSize_;
1199     collectionSize = collectionSize_;
1200     currentIndex = _startTokenId();
1201   }
1202 
1203   /**
1204   * To change the starting tokenId, please override this function.
1205   */
1206   function _startTokenId() internal view virtual returns (uint256) {
1207     return 1;
1208   }
1209 
1210   /**
1211    * @dev See {IERC721Enumerable-totalSupply}.
1212    */
1213   function totalSupply() public view override returns (uint256) {
1214     return _totalMinted();
1215   }
1216 
1217   function currentTokenId() public view returns (uint256) {
1218     return _totalMinted();
1219   }
1220 
1221   function getNextTokenId() public view returns (uint256) {
1222       return SafeMath.add(_totalMinted(), 1);
1223   }
1224 
1225   /**
1226   * Returns the total amount of tokens minted in the contract.
1227   */
1228   function _totalMinted() internal view returns (uint256) {
1229     unchecked {
1230       return currentIndex - _startTokenId();
1231     }
1232   }
1233 
1234   /**
1235    * @dev See {IERC721Enumerable-tokenByIndex}.
1236    */
1237   function tokenByIndex(uint256 index) public view override returns (uint256) {
1238     require(index < totalSupply(), "ERC721A: global index out of bounds");
1239     return index;
1240   }
1241 
1242   /**
1243    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1244    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1245    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1246    */
1247   function tokenOfOwnerByIndex(address owner, uint256 index)
1248     public
1249     view
1250     override
1251     returns (uint256)
1252   {
1253     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1254     uint256 numMintedSoFar = totalSupply();
1255     uint256 tokenIdsIdx = 0;
1256     address currOwnershipAddr = address(0);
1257     for (uint256 i = 0; i < numMintedSoFar; i++) {
1258       TokenOwnership memory ownership = _ownerships[i];
1259       if (ownership.addr != address(0)) {
1260         currOwnershipAddr = ownership.addr;
1261       }
1262       if (currOwnershipAddr == owner) {
1263         if (tokenIdsIdx == index) {
1264           return i;
1265         }
1266         tokenIdsIdx++;
1267       }
1268     }
1269     revert("ERC721A: unable to get token of owner by index");
1270   }
1271 
1272   /**
1273    * @dev See {IERC165-supportsInterface}.
1274    */
1275   function supportsInterface(bytes4 interfaceId)
1276     public
1277     view
1278     virtual
1279     override(ERC165, IERC165)
1280     returns (bool)
1281   {
1282     return
1283       interfaceId == type(IERC721).interfaceId ||
1284       interfaceId == type(IERC721Metadata).interfaceId ||
1285       interfaceId == type(IERC721Enumerable).interfaceId ||
1286       super.supportsInterface(interfaceId);
1287   }
1288 
1289   /**
1290    * @dev See {IERC721-balanceOf}.
1291    */
1292   function balanceOf(address owner) public view override returns (uint256) {
1293     require(owner != address(0), "ERC721A: balance query for the zero address");
1294     return uint256(_addressData[owner].balance);
1295   }
1296 
1297   function _numberMinted(address owner) internal view returns (uint256) {
1298     require(
1299       owner != address(0),
1300       "ERC721A: number minted query for the zero address"
1301     );
1302     return uint256(_addressData[owner].numberMinted);
1303   }
1304 
1305   function ownershipOf(uint256 tokenId)
1306     internal
1307     view
1308     returns (TokenOwnership memory)
1309   {
1310     uint256 curr = tokenId;
1311 
1312     unchecked {
1313         if (_startTokenId() <= curr && curr < currentIndex) {
1314             TokenOwnership memory ownership = _ownerships[curr];
1315             if (ownership.addr != address(0)) {
1316                 return ownership;
1317             }
1318 
1319             // Invariant:
1320             // There will always be an ownership that has an address and is not burned
1321             // before an ownership that does not have an address and is not burned.
1322             // Hence, curr will not underflow.
1323             while (true) {
1324                 curr--;
1325                 ownership = _ownerships[curr];
1326                 if (ownership.addr != address(0)) {
1327                     return ownership;
1328                 }
1329             }
1330         }
1331     }
1332 
1333     revert("ERC721A: unable to determine the owner of token");
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-ownerOf}.
1338    */
1339   function ownerOf(uint256 tokenId) public view override returns (address) {
1340     return ownershipOf(tokenId).addr;
1341   }
1342 
1343   /**
1344    * @dev See {IERC721Metadata-name}.
1345    */
1346   function name() public view virtual override returns (string memory) {
1347     return _name;
1348   }
1349 
1350   /**
1351    * @dev See {IERC721Metadata-symbol}.
1352    */
1353   function symbol() public view virtual override returns (string memory) {
1354     return _symbol;
1355   }
1356 
1357   /**
1358    * @dev See {IERC721Metadata-tokenURI}.
1359    */
1360   function tokenURI(uint256 tokenId)
1361     public
1362     view
1363     virtual
1364     override
1365     returns (string memory)
1366   {
1367     string memory baseURI = _baseURI();
1368     return
1369       bytes(baseURI).length > 0
1370         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1371         : "";
1372   }
1373 
1374   /**
1375    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1376    * token will be the concatenation of the baseURI and the tokenId. Empty
1377    * by default, can be overriden in child contracts.
1378    */
1379   function _baseURI() internal view virtual returns (string memory) {
1380     return "";
1381   }
1382 
1383   /**
1384    * @dev See {IERC721-approve}.
1385    */
1386   function approve(address to, uint256 tokenId) public override {
1387     address owner = ERC721A.ownerOf(tokenId);
1388     require(to != owner, "ERC721A: approval to current owner");
1389 
1390     require(
1391       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1392       "ERC721A: approve caller is not owner nor approved for all"
1393     );
1394 
1395     _approve(to, tokenId, owner);
1396   }
1397 
1398   /**
1399    * @dev See {IERC721-getApproved}.
1400    */
1401   function getApproved(uint256 tokenId) public view override returns (address) {
1402     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1403 
1404     return _tokenApprovals[tokenId];
1405   }
1406 
1407   /**
1408    * @dev See {IERC721-setApprovalForAll}.
1409    */
1410   function setApprovalForAll(address operator, bool approved) public override {
1411     require(operator != _msgSender(), "ERC721A: approve to caller");
1412 
1413     _operatorApprovals[_msgSender()][operator] = approved;
1414     emit ApprovalForAll(_msgSender(), operator, approved);
1415   }
1416 
1417   /**
1418    * @dev See {IERC721-isApprovedForAll}.
1419    */
1420   function isApprovedForAll(address owner, address operator)
1421     public
1422     view
1423     virtual
1424     override
1425     returns (bool)
1426   {
1427     return _operatorApprovals[owner][operator];
1428   }
1429 
1430   /**
1431    * @dev See {IERC721-transferFrom}.
1432    */
1433   function transferFrom(
1434     address from,
1435     address to,
1436     uint256 tokenId
1437   ) public override {
1438     _transfer(from, to, tokenId);
1439   }
1440 
1441   /**
1442    * @dev See {IERC721-safeTransferFrom}.
1443    */
1444   function safeTransferFrom(
1445     address from,
1446     address to,
1447     uint256 tokenId
1448   ) public override {
1449     safeTransferFrom(from, to, tokenId, "");
1450   }
1451 
1452   /**
1453    * @dev See {IERC721-safeTransferFrom}.
1454    */
1455   function safeTransferFrom(
1456     address from,
1457     address to,
1458     uint256 tokenId,
1459     bytes memory _data
1460   ) public override {
1461     _transfer(from, to, tokenId);
1462     require(
1463       _checkOnERC721Received(from, to, tokenId, _data),
1464       "ERC721A: transfer to non ERC721Receiver implementer"
1465     );
1466   }
1467 
1468   /**
1469    * @dev Returns whether tokenId exists.
1470    *
1471    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1472    *
1473    * Tokens start existing when they are minted (_mint),
1474    */
1475   function _exists(uint256 tokenId) internal view returns (bool) {
1476     return _startTokenId() <= tokenId && tokenId < currentIndex;
1477   }
1478 
1479   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1480     _safeMint(to, quantity, isAdminMint, "");
1481   }
1482 
1483   /**
1484    * @dev Mints quantity tokens and transfers them to to.
1485    *
1486    * Requirements:
1487    *
1488    * - there must be quantity tokens remaining unminted in the total collection.
1489    * - to cannot be the zero address.
1490    * - quantity cannot be larger than the max batch size.
1491    *
1492    * Emits a {Transfer} event.
1493    */
1494   function _safeMint(
1495     address to,
1496     uint256 quantity,
1497     bool isAdminMint,
1498     bytes memory _data
1499   ) internal {
1500     uint256 startTokenId = currentIndex;
1501     require(to != address(0), "ERC721A: mint to the zero address");
1502     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1503     require(!_exists(startTokenId), "ERC721A: token already minted");
1504     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1505 
1506     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1507 
1508     AddressData memory addressData = _addressData[to];
1509     _addressData[to] = AddressData(
1510       addressData.balance + uint128(quantity),
1511       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1512     );
1513     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1514 
1515     uint256 updatedIndex = startTokenId;
1516 
1517     for (uint256 i = 0; i < quantity; i++) {
1518       emit Transfer(address(0), to, updatedIndex);
1519       require(
1520         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1521         "ERC721A: transfer to non ERC721Receiver implementer"
1522       );
1523       updatedIndex++;
1524     }
1525 
1526     currentIndex = updatedIndex;
1527     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1528   }
1529 
1530   /**
1531    * @dev Transfers tokenId from from to to.
1532    *
1533    * Requirements:
1534    *
1535    * - to cannot be the zero address.
1536    * - tokenId token must be owned by from.
1537    *
1538    * Emits a {Transfer} event.
1539    */
1540   function _transfer(
1541     address from,
1542     address to,
1543     uint256 tokenId
1544   ) private {
1545     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1546 
1547     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1548       getApproved(tokenId) == _msgSender() ||
1549       isApprovedForAll(prevOwnership.addr, _msgSender()));
1550 
1551     require(
1552       isApprovedOrOwner,
1553       "ERC721A: transfer caller is not owner nor approved"
1554     );
1555 
1556     require(
1557       prevOwnership.addr == from,
1558       "ERC721A: transfer from incorrect owner"
1559     );
1560     require(to != address(0), "ERC721A: transfer to the zero address");
1561 
1562     _beforeTokenTransfers(from, to, tokenId, 1);
1563 
1564     // Clear approvals from the previous owner
1565     _approve(address(0), tokenId, prevOwnership.addr);
1566 
1567     _addressData[from].balance -= 1;
1568     _addressData[to].balance += 1;
1569     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1570 
1571     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1572     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1573     uint256 nextTokenId = tokenId + 1;
1574     if (_ownerships[nextTokenId].addr == address(0)) {
1575       if (_exists(nextTokenId)) {
1576         _ownerships[nextTokenId] = TokenOwnership(
1577           prevOwnership.addr,
1578           prevOwnership.startTimestamp
1579         );
1580       }
1581     }
1582 
1583     emit Transfer(from, to, tokenId);
1584     _afterTokenTransfers(from, to, tokenId, 1);
1585   }
1586 
1587   /**
1588    * @dev Approve to to operate on tokenId
1589    *
1590    * Emits a {Approval} event.
1591    */
1592   function _approve(
1593     address to,
1594     uint256 tokenId,
1595     address owner
1596   ) private {
1597     _tokenApprovals[tokenId] = to;
1598     emit Approval(owner, to, tokenId);
1599   }
1600 
1601   uint256 public nextOwnerToExplicitlySet = 0;
1602 
1603   /**
1604    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1605    */
1606   function _setOwnersExplicit(uint256 quantity) internal {
1607     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1608     require(quantity > 0, "quantity must be nonzero");
1609     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1610 
1611     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1612     if (endIndex > collectionSize - 1) {
1613       endIndex = collectionSize - 1;
1614     }
1615     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1616     require(_exists(endIndex), "not enough minted yet for this cleanup");
1617     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1618       if (_ownerships[i].addr == address(0)) {
1619         TokenOwnership memory ownership = ownershipOf(i);
1620         _ownerships[i] = TokenOwnership(
1621           ownership.addr,
1622           ownership.startTimestamp
1623         );
1624       }
1625     }
1626     nextOwnerToExplicitlySet = endIndex + 1;
1627   }
1628 
1629   /**
1630    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1631    * The call is not executed if the target address is not a contract.
1632    *
1633    * @param from address representing the previous owner of the given token ID
1634    * @param to target address that will receive the tokens
1635    * @param tokenId uint256 ID of the token to be transferred
1636    * @param _data bytes optional data to send along with the call
1637    * @return bool whether the call correctly returned the expected magic value
1638    */
1639   function _checkOnERC721Received(
1640     address from,
1641     address to,
1642     uint256 tokenId,
1643     bytes memory _data
1644   ) private returns (bool) {
1645     if (to.isContract()) {
1646       try
1647         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1648       returns (bytes4 retval) {
1649         return retval == IERC721Receiver(to).onERC721Received.selector;
1650       } catch (bytes memory reason) {
1651         if (reason.length == 0) {
1652           revert("ERC721A: transfer to non ERC721Receiver implementer");
1653         } else {
1654           assembly {
1655             revert(add(32, reason), mload(reason))
1656           }
1657         }
1658       }
1659     } else {
1660       return true;
1661     }
1662   }
1663 
1664   /**
1665    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1666    *
1667    * startTokenId - the first token id to be transferred
1668    * quantity - the amount to be transferred
1669    *
1670    * Calling conditions:
1671    *
1672    * - When from and to are both non-zero, from's tokenId will be
1673    * transferred to to.
1674    * - When from is zero, tokenId will be minted for to.
1675    */
1676   function _beforeTokenTransfers(
1677     address from,
1678     address to,
1679     uint256 startTokenId,
1680     uint256 quantity
1681   ) internal virtual {}
1682 
1683   /**
1684    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1685    * minting.
1686    *
1687    * startTokenId - the first token id to be transferred
1688    * quantity - the amount to be transferred
1689    *
1690    * Calling conditions:
1691    *
1692    * - when from and to are both non-zero.
1693    * - from and to are never both zero.
1694    */
1695   function _afterTokenTransfers(
1696     address from,
1697     address to,
1698     uint256 startTokenId,
1699     uint256 quantity
1700   ) internal virtual {}
1701 }
1702 
1703 
1704 
1705   
1706 abstract contract Ramppable {
1707   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1708 
1709   modifier isRampp() {
1710       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1711       _;
1712   }
1713 }
1714 
1715 
1716   
1717 /** TimedDrop.sol
1718 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1719 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1720 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1721 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1722 */
1723 abstract contract TimedDrop is Ownable {
1724   bool public enforcePublicDropTime = false;
1725   uint256 public publicDropTime = 0;
1726   
1727   /**
1728   * @dev Allow the contract owner to set the public time to mint.
1729   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1730   */
1731   function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
1732     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1733     publicDropTime = _newDropTime;
1734   }
1735 
1736   function usePublicDropTime() public onlyOwner {
1737     enforcePublicDropTime = true;
1738   }
1739 
1740   function disablePublicDropTime() public onlyOwner {
1741     enforcePublicDropTime = false;
1742   }
1743 
1744   /**
1745   * @dev determine if the public droptime has passed.
1746   * if the feature is disabled then assume the time has passed.
1747   */
1748   function publicDropTimePassed() public view returns(bool) {
1749     if(enforcePublicDropTime == false) {
1750       return true;
1751     }
1752     return block.timestamp >= publicDropTime;
1753   }
1754   
1755   // Allowlist implementation of the Timed Drop feature
1756   bool public enforceAllowlistDropTime = false;
1757   uint256 public allowlistDropTime = 0;
1758 
1759   /**
1760   * @dev Allow the contract owner to set the allowlist time to mint.
1761   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1762   */
1763   function setAllowlistDropTime(uint256 _newDropTime) public onlyOwner {
1764     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1765     allowlistDropTime = _newDropTime;
1766   }
1767 
1768   function useAllowlistDropTime() public onlyOwner {
1769     enforceAllowlistDropTime = true;
1770   }
1771 
1772   function disableAllowlistDropTime() public onlyOwner {
1773     enforceAllowlistDropTime = false;
1774   }
1775 
1776   function allowlistDropTimePassed() public view returns(bool) {
1777     if(enforceAllowlistDropTime == false) {
1778       return true;
1779     }
1780 
1781     return block.timestamp >= allowlistDropTime;
1782   }
1783 }
1784 
1785   
1786 interface IERC20 {
1787   function transfer(address _to, uint256 _amount) external returns (bool);
1788   function balanceOf(address account) external view returns (uint256);
1789 }
1790 
1791 abstract contract Withdrawable is Ownable, Ramppable {
1792   address[] public payableAddresses = [RAMPPADDRESS,0xAF4bf19AFA5120426744c209FAe560CD7d8643CC,0x68dF6DF7e68A068419E89af54bb3D6D30F0a13E5];
1793   uint256[] public payableFees = [5,47,48];
1794   uint256 public payableAddressCount = 3;
1795 
1796   function withdrawAll() public onlyOwner {
1797       require(address(this).balance > 0);
1798       _withdrawAll();
1799   }
1800   
1801   function withdrawAllRampp() public isRampp {
1802       require(address(this).balance > 0);
1803       _withdrawAll();
1804   }
1805 
1806   function _withdrawAll() private {
1807       uint256 balance = address(this).balance;
1808       
1809       for(uint i=0; i < payableAddressCount; i++ ) {
1810           _widthdraw(
1811               payableAddresses[i],
1812               (balance * payableFees[i]) / 100
1813           );
1814       }
1815   }
1816   
1817   function _widthdraw(address _address, uint256 _amount) private {
1818       (bool success, ) = _address.call{value: _amount}("");
1819       require(success, "Transfer failed.");
1820   }
1821 
1822   /**
1823     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1824     * while still splitting royalty payments to all other team members.
1825     * in the event ERC-20 tokens are paid to the contract.
1826     * @param _tokenContract contract of ERC-20 token to withdraw
1827     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1828     */
1829   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1830     require(_amount > 0);
1831     IERC20 tokenContract = IERC20(_tokenContract);
1832     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1833 
1834     for(uint i=0; i < payableAddressCount; i++ ) {
1835         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1836     }
1837   }
1838 
1839   /**
1840   * @dev Allows Rampp wallet to update its own reference as well as update
1841   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1842   * and since Rampp is always the first address this function is limited to the rampp payout only.
1843   * @param _newAddress updated Rampp Address
1844   */
1845   function setRamppAddress(address _newAddress) public isRampp {
1846     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1847     RAMPPADDRESS = _newAddress;
1848     payableAddresses[0] = _newAddress;
1849   }
1850 }
1851 
1852 
1853   
1854 abstract contract RamppERC721A is 
1855     Ownable,
1856     ERC721A,
1857     Withdrawable,
1858     ReentrancyGuard , Allowlist , TimedDrop {
1859     constructor(
1860         string memory tokenName,
1861         string memory tokenSymbol
1862     ) ERC721A(tokenName, tokenSymbol, 3, 5000 ) {}
1863     using SafeMath for uint256;
1864     uint8 public CONTRACT_VERSION = 2;
1865     string public _baseTokenURI = "ipfs://QmfS9TgYKk9gepywth1rYM3oLtxaoUwWETZSffSYM7hyZi/";
1866 
1867     bool public mintingOpen = false;
1868     bool public isRevealed = false;
1869     uint256 public PRICE = 0.01 ether;
1870     
1871     uint256 public MAX_WALLET_MINTS = 3;
1872 
1873     
1874     /////////////// Admin Mint Functions
1875     /**
1876     * @dev Mints a token to an address with a tokenURI.
1877     * This is owner only and allows a fee-free drop
1878     * @param _to address of the future owner of the token
1879     */
1880     function mintToAdmin(address _to) public onlyOwner {
1881         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1882         _safeMint(_to, 1, true);
1883     }
1884 
1885     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1886         for(uint i=0; i < _addressCount; i++ ) {
1887             mintToAdmin(_addresses[i]);
1888         }
1889     }
1890 
1891     
1892     /////////////// GENERIC MINT FUNCTIONS
1893     /**
1894     * @dev Mints a single token to an address.
1895     * fee may or may not be required*
1896     * @param _to address of the future owner of the token
1897     */
1898     function mintTo(address _to) public payable {
1899         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1900         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1901         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1902         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1903         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1904         
1905         _safeMint(_to, 1, false);
1906     }
1907 
1908     /**
1909     * @dev Mints a token to an address with a tokenURI.
1910     * fee may or may not be required*
1911     * @param _to address of the future owner of the token
1912     * @param _amount number of tokens to mint
1913     */
1914     function mintToMultiple(address _to, uint256 _amount) public payable {
1915         require(_amount >= 1, "Must mint at least 1 token");
1916         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1917         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1918         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1919         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1920         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1921         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1922 
1923         _safeMint(_to, _amount, false);
1924     }
1925 
1926     function openMinting() public onlyOwner {
1927         mintingOpen = true;
1928     }
1929 
1930     function stopMinting() public onlyOwner {
1931         mintingOpen = false;
1932     }
1933 
1934     
1935     ///////////// ALLOWLIST MINTING FUNCTIONS
1936 
1937     /**
1938     * @dev Mints a token to an address with a tokenURI for allowlist.
1939     * fee may or may not be required*
1940     * @param _to address of the future owner of the token
1941     */
1942     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1943         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1944         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1945         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1946         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1947         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1948         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1949 
1950         _safeMint(_to, 1, false);
1951     }
1952 
1953     /**
1954     * @dev Mints a token to an address with a tokenURI for allowlist.
1955     * fee may or may not be required*
1956     * @param _to address of the future owner of the token
1957     * @param _amount number of tokens to mint
1958     */
1959     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1960         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1961         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1962         require(_amount >= 1, "Must mint at least 1 token");
1963         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1964 
1965         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1966         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1967         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1968         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1969 
1970         _safeMint(_to, _amount, false);
1971     }
1972 
1973     /**
1974      * @dev Enable allowlist minting fully by enabling both flags
1975      * This is a convenience function for the Rampp user
1976      */
1977     function openAllowlistMint() public onlyOwner {
1978         enableAllowlistOnlyMode();
1979         mintingOpen = true;
1980     }
1981 
1982     /**
1983      * @dev Close allowlist minting fully by disabling both flags
1984      * This is a convenience function for the Rampp user
1985      */
1986     function closeAllowlistMint() public onlyOwner {
1987         disableAllowlistOnlyMode();
1988         mintingOpen = false;
1989     }
1990 
1991 
1992     
1993     /**
1994     * @dev Check if wallet over MAX_WALLET_MINTS
1995     * @param _address address in question to check if minted count exceeds max
1996     */
1997     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1998         require(_amount >= 1, "Amount must be greater than or equal to 1");
1999         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
2000     }
2001 
2002     /**
2003     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2004     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2005     */
2006     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
2007         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2008         MAX_WALLET_MINTS = _newWalletMax;
2009     }
2010     
2011 
2012     
2013     /**
2014      * @dev Allows owner to set Max mints per tx
2015      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2016      */
2017      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
2018          require(_newMaxMint >= 1, "Max mint must be at least 1");
2019          maxBatchSize = _newMaxMint;
2020      }
2021     
2022 
2023     
2024     function setPrice(uint256 _feeInWei) public onlyOwner {
2025         PRICE = _feeInWei;
2026     }
2027 
2028     function getPrice(uint256 _count) private view returns (uint256) {
2029         return PRICE.mul(_count);
2030     }
2031 
2032     
2033     function unveil(string memory _updatedTokenURI) public onlyOwner {
2034         require(isRevealed == false, "Tokens are already unveiled");
2035         _baseTokenURI = _updatedTokenURI;
2036         isRevealed = true;
2037     }
2038     
2039     
2040     function _baseURI() internal view virtual override returns (string memory) {
2041         return _baseTokenURI;
2042     }
2043 
2044     function baseTokenURI() public view returns (string memory) {
2045         return _baseTokenURI;
2046     }
2047 
2048     function setBaseURI(string calldata baseURI) external onlyOwner {
2049         _baseTokenURI = baseURI;
2050     }
2051 
2052     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
2053         return ownershipOf(tokenId);
2054     }
2055 }
2056 
2057 
2058   
2059 // File: contracts/UltraContract.sol
2060 //SPDX-License-Identifier: MIT
2061 
2062 pragma solidity ^0.8.0;
2063 
2064 contract UltraContract is RamppERC721A {
2065     constructor() RamppERC721A("ULTRA", "ULTRA"){}
2066 
2067     function contractURI() public pure returns (string memory) {
2068       return "https://us-central1-nft-rampp.cloudfunctions.net/app/PTh3HZaL3b34p9bkOBHT/contract-metadata";
2069     }
2070 }
2071   
2072 //*********************************************************************//
2073 //*********************************************************************//  
2074 //                       Rampp v2.0.1
2075 //
2076 //         This smart contract was generated by rampp.xyz.
2077 //            Rampp allows creators like you to launch 
2078 //             large scale NFT communities without code!
2079 //
2080 //    Rampp is not responsible for the content of this contract and
2081 //        hopes it is being used in a responsible and kind way.  
2082 //       Rampp is not associated or affiliated with this project.                                                    
2083 //             Twitter: @Rampp_ ---- rampp.xyz
2084 //*********************************************************************//                                                     
2085 //*********************************************************************// 
