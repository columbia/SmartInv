1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //       o__ __o                                                                    o__ __o__/_                                 o        o                                      
5 //      /v     v\                                                                  <|    v                                     <|>     _<|>_                                    
6 //     />       <\                                                                 < >                                         < >                                              
7 //   o/                o__ __o/  \o__ __o    o      o     o__ __o/      __o__       |            \o__ __o__ __o     o__ __o     |        o      o__ __o    \o__ __o       __o__ 
8 //  <|                /v     |    |     |>  <|>    <|>   /v     |      />  \        o__/_         |     |     |>   /v     v\    o__/_   <|>    /v     v\    |     |>     />  \  
9 //   \\              />     / \  / \   / \  < >    < >  />     / \     \o           |            / \   / \   / \  />       <\   |       / \   />       <\  / \   / \     \o     
10 //     \         /   \      \o/  \o/   \o/   \o    o/   \      \o/      v\         <o>           \o/   \o/   \o/  \         /   |       \o/   \         /  \o/   \o/      v\    
11 //      o       o     o      |    |     |     v\  /v     o      |        <\         |             |     |     |    o       o    o        |     o       o    |     |        <\   
12 //      <\__ __/>     <\__  / \  / \   / \     <\/>      <\__  / \  _\o__</        / \  _\o__/_  / \   / \   / \   <\__ __/>    <\__    / \    <\__ __/>   / \   / \  _\o__</   
13 //                                                                                                                                                                              
14 //                                                                                                                                                                              
15 //                                                                                                                                                                              
16 //
17 //*********************************************************************//
18 //*********************************************************************//
19   
20 //-------------DEPENDENCIES--------------------------//
21 
22 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
23 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 // CAUTION
28 // This version of SafeMath should only be used with Solidity 0.8 or later,
29 // because it relies on the compiler's built in overflow checks.
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations.
33  *
34  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
35  * now has built in overflow checking.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             uint256 c = a + b;
46             if (c < a) return (false, 0);
47             return (true, c);
48         }
49     }
50 
51     /**
52      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
53      *
54      * _Available since v3.4._
55      */
56     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             if (b > a) return (false, 0);
59             return (true, a - b);
60         }
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
71             // benefit is lost if 'b' is also tested.
72             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
73             if (a == 0) return (true, 0);
74             uint256 c = a * b;
75             if (c / a != b) return (false, 0);
76             return (true, c);
77         }
78     }
79 
80     /**
81      * @dev Returns the division of two unsigned integers, with a division by zero flag.
82      *
83      * _Available since v3.4._
84      */
85     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b == 0) return (false, 0);
88             return (true, a / b);
89         }
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
94      *
95      * _Available since v3.4._
96      */
97     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             if (b == 0) return (false, 0);
100             return (true, a % b);
101         }
102     }
103 
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's + operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a + b;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's - operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return a - b;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's * operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         return a * b;
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers, reverting on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's / operator.
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a / b;
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * reverting when dividing by zero.
163      *
164      * Counterpart to Solidity's % operator. This function uses a revert
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a % b;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {trySub}.
182      *
183      * Counterpart to Solidity's - operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(
190         uint256 a,
191         uint256 b,
192         string memory errorMessage
193     ) internal pure returns (uint256) {
194         unchecked {
195             require(b <= a, errorMessage);
196             return a - b;
197         }
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's / operator. Note: this function uses a
205      * revert opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(
213         uint256 a,
214         uint256 b,
215         string memory errorMessage
216     ) internal pure returns (uint256) {
217         unchecked {
218             require(b > 0, errorMessage);
219             return a / b;
220         }
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting with custom message when dividing by zero.
226      *
227      * CAUTION: This function is deprecated because it requires allocating memory for the error
228      * message unnecessarily. For custom revert reasons use {tryMod}.
229      *
230      * Counterpart to Solidity's % operator. This function uses a revert
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(
239         uint256 a,
240         uint256 b,
241         string memory errorMessage
242     ) internal pure returns (uint256) {
243         unchecked {
244             require(b > 0, errorMessage);
245             return a % b;
246         }
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Address.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
254 
255 pragma solidity ^0.8.1;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if account is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, isContract will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      *
278      * [IMPORTANT]
279      * ====
280      * You shouldn't rely on isContract to protect against flash loan attacks!
281      *
282      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
283      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
284      * constructor.
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize/address.code.length, which returns 0
289         // for contracts in construction, since the code is only stored at the end
290         // of the constructor execution.
291 
292         return account.code.length > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's transfer: sends amount wei to
297      * recipient, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by transfer, making them unable to receive funds via
302      * transfer. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to recipient, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level call. A
320      * plain call is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If target reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
328      *
329      * Requirements:
330      *
331      * - target must be a contract.
332      * - calling target with data must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
342      * errorMessage as a fallback revert reason when target reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
356      * but also transferring value wei to target.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least value.
361      * - the called Solidity function must be payable.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
375      * with errorMessage as a fallback revert reason when target reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
399         return functionStaticCall(target, data, "Address: low-level static call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.staticcall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(isContract(target), "Address: delegate call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
448      * revert reason using the provided one.
449      *
450      * _Available since v4.3._
451      */
452     function verifyCallResult(
453         bool success,
454         bytes memory returndata,
455         string memory errorMessage
456     ) internal pure returns (bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @title ERC721 token receiver interface
484  * @dev Interface for any contract that wants to support safeTransfers
485  * from ERC721 asset contracts.
486  */
487 interface IERC721Receiver {
488     /**
489      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
490      * by operator from from, this function is called.
491      *
492      * It must return its Solidity selector to confirm the token transfer.
493      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
494      *
495      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
496      */
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Interface of the ERC165 standard, as defined in the
514  * https://eips.ethereum.org/EIPS/eip-165[EIP].
515  *
516  * Implementers can declare support of contract interfaces, which can then be
517  * queried by others ({ERC165Checker}).
518  *
519  * For an implementation, see {ERC165}.
520  */
521 interface IERC165 {
522     /**
523      * @dev Returns true if this contract implements the interface defined by
524      * interfaceId. See the corresponding
525      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
526      * to learn more about how these ids are created.
527      *
528      * This function call must use less than 30 000 gas.
529      */
530     function supportsInterface(bytes4 interfaceId) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * 
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when tokenId token is transferred from from to to.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when owner enables approved to manage the tokenId token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in owner's account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the tokenId token.
598      *
599      * Requirements:
600      *
601      * - tokenId must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - from cannot be the zero address.
612      * - to cannot be the zero address.
613      * - tokenId token must exist and be owned by from.
614      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers tokenId token from from to to.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - from cannot be the zero address.
633      * - to cannot be the zero address.
634      * - tokenId token must be owned by from.
635      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to to to transfer tokenId token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - tokenId must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Returns the account approved for tokenId token.
662      *
663      * Requirements:
664      *
665      * - tokenId must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Approve or remove operator as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The operator cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns if the operator is allowed to manage all of the assets of owner.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 
688     /**
689      * @dev Safely transfers tokenId token from from to to.
690      *
691      * Requirements:
692      *
693      * - from cannot be the zero address.
694      * - to cannot be the zero address.
695      * - tokenId token must exist and be owned by from.
696      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
710 
711 
712 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Enumerable is IERC721 {
722     /**
723      * @dev Returns the total amount of tokens stored by the contract.
724      */
725     function totalSupply() external view returns (uint256);
726 
727     /**
728      * @dev Returns a token ID owned by owner at a given index of its token list.
729      * Use along with {balanceOf} to enumerate all of owner's tokens.
730      */
731     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
732 
733     /**
734      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
735      * Use along with {totalSupply} to enumerate all tokens.
736      */
737     function tokenByIndex(uint256 index) external view returns (uint256);
738 }
739 
740 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
750  * @dev See https://eips.ethereum.org/EIPS/eip-721
751  */
752 interface IERC721Metadata is IERC721 {
753     /**
754      * @dev Returns the token collection name.
755      */
756     function name() external view returns (string memory);
757 
758     /**
759      * @dev Returns the token collection symbol.
760      */
761     function symbol() external view returns (string memory);
762 
763     /**
764      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
765      */
766     function tokenURI(uint256 tokenId) external view returns (string memory);
767 }
768 
769 // File: @openzeppelin/contracts/utils/Strings.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @dev String operations.
778  */
779 library Strings {
780     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
781 
782     /**
783      * @dev Converts a uint256 to its ASCII string decimal representation.
784      */
785     function toString(uint256 value) internal pure returns (string memory) {
786         // Inspired by OraclizeAPI's implementation - MIT licence
787         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
788 
789         if (value == 0) {
790             return "0";
791         }
792         uint256 temp = value;
793         uint256 digits;
794         while (temp != 0) {
795             digits++;
796             temp /= 10;
797         }
798         bytes memory buffer = new bytes(digits);
799         while (value != 0) {
800             digits -= 1;
801             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
802             value /= 10;
803         }
804         return string(buffer);
805     }
806 
807     /**
808      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
809      */
810     function toHexString(uint256 value) internal pure returns (string memory) {
811         if (value == 0) {
812             return "0x00";
813         }
814         uint256 temp = value;
815         uint256 length = 0;
816         while (temp != 0) {
817             length++;
818             temp >>= 8;
819         }
820         return toHexString(value, length);
821     }
822 
823     /**
824      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
825      */
826     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
827         bytes memory buffer = new bytes(2 * length + 2);
828         buffer[0] = "0";
829         buffer[1] = "x";
830         for (uint256 i = 2 * length + 1; i > 1; --i) {
831             buffer[i] = _HEX_SYMBOLS[value & 0xf];
832             value >>= 4;
833         }
834         require(value == 0, "Strings: hex length insufficient");
835         return string(buffer);
836     }
837 }
838 
839 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
840 
841 
842 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @dev Contract module that helps prevent reentrant calls to a function.
848  *
849  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
850  * available, which can be applied to functions to make sure there are no nested
851  * (reentrant) calls to them.
852  *
853  * Note that because there is a single nonReentrant guard, functions marked as
854  * nonReentrant may not call one another. This can be worked around by making
855  * those functions private, and then adding external nonReentrant entry
856  * points to them.
857  *
858  * TIP: If you would like to learn more about reentrancy and alternative ways
859  * to protect against it, check out our blog post
860  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
861  */
862 abstract contract ReentrancyGuard {
863     // Booleans are more expensive than uint256 or any type that takes up a full
864     // word because each write operation emits an extra SLOAD to first read the
865     // slot's contents, replace the bits taken up by the boolean, and then write
866     // back. This is the compiler's defense against contract upgrades and
867     // pointer aliasing, and it cannot be disabled.
868 
869     // The values being non-zero value makes deployment a bit more expensive,
870     // but in exchange the refund on every call to nonReentrant will be lower in
871     // amount. Since refunds are capped to a percentage of the total
872     // transaction's gas, it is best to keep them low in cases like this one, to
873     // increase the likelihood of the full refund coming into effect.
874     uint256 private constant _NOT_ENTERED = 1;
875     uint256 private constant _ENTERED = 2;
876 
877     uint256 private _status;
878 
879     constructor() {
880         _status = _NOT_ENTERED;
881     }
882 
883     /**
884      * @dev Prevents a contract from calling itself, directly or indirectly.
885      * Calling a nonReentrant function from another nonReentrant
886      * function is not supported. It is possible to prevent this from happening
887      * by making the nonReentrant function external, and making it call a
888      * private function that does the actual work.
889      */
890     modifier nonReentrant() {
891         // On the first call to nonReentrant, _notEntered will be true
892         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
893 
894         // Any calls to nonReentrant after this point will fail
895         _status = _ENTERED;
896 
897         _;
898 
899         // By storing the original value once again, a refund is triggered (see
900         // https://eips.ethereum.org/EIPS/eip-2200)
901         _status = _NOT_ENTERED;
902     }
903 }
904 
905 // File: @openzeppelin/contracts/utils/Context.sol
906 
907 
908 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @dev Provides information about the current execution context, including the
914  * sender of the transaction and its data. While these are generally available
915  * via msg.sender and msg.data, they should not be accessed in such a direct
916  * manner, since when dealing with meta-transactions the account sending and
917  * paying for execution may not be the actual sender (as far as an application
918  * is concerned).
919  *
920  * This contract is only required for intermediate, library-like contracts.
921  */
922 abstract contract Context {
923     function _msgSender() internal view virtual returns (address) {
924         return msg.sender;
925     }
926 
927     function _msgData() internal view virtual returns (bytes calldata) {
928         return msg.data;
929     }
930 }
931 
932 // File: @openzeppelin/contracts/access/Ownable.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @dev Contract module which provides a basic access control mechanism, where
942  * there is an account (an owner) that can be granted exclusive access to
943  * specific functions.
944  *
945  * By default, the owner account will be the one that deploys the contract. This
946  * can later be changed with {transferOwnership}.
947  *
948  * This module is used through inheritance. It will make available the modifier
949  * onlyOwner, which can be applied to your functions to restrict their use to
950  * the owner.
951  */
952 abstract contract Ownable is Context {
953     address private _owner;
954 
955     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
956 
957     /**
958      * @dev Initializes the contract setting the deployer as the initial owner.
959      */
960     constructor() {
961         _transferOwnership(_msgSender());
962     }
963 
964     /**
965      * @dev Returns the address of the current owner.
966      */
967     function owner() public view virtual returns (address) {
968         return _owner;
969     }
970 
971     /**
972      * @dev Throws if called by any account other than the owner.
973      */
974     modifier onlyOwner() {
975         require(owner() == _msgSender(), "Ownable: caller is not the owner");
976         _;
977     }
978 
979     /**
980      * @dev Leaves the contract without owner. It will not be possible to call
981      * onlyOwner functions anymore. Can only be called by the current owner.
982      *
983      * NOTE: Renouncing ownership will leave the contract without an owner,
984      * thereby removing any functionality that is only available to the owner.
985      */
986     function renounceOwnership() public virtual onlyOwner {
987         _transferOwnership(address(0));
988     }
989 
990     /**
991      * @dev Transfers ownership of the contract to a new account (newOwner).
992      * Can only be called by the current owner.
993      */
994     function transferOwnership(address newOwner) public virtual onlyOwner {
995         require(newOwner != address(0), "Ownable: new owner is the zero address");
996         _transferOwnership(newOwner);
997     }
998 
999     /**
1000      * @dev Transfers ownership of the contract to a new account (newOwner).
1001      * Internal function without access restriction.
1002      */
1003     function _transferOwnership(address newOwner) internal virtual {
1004         address oldOwner = _owner;
1005         _owner = newOwner;
1006         emit OwnershipTransferred(oldOwner, newOwner);
1007     }
1008 }
1009 //-------------END DEPENDENCIES------------------------//
1010 
1011 
1012   
1013   
1014 /**
1015  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1016  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1017  *
1018  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1019  * 
1020  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1021  *
1022  * Does not support burning tokens to address(0).
1023  */
1024 contract ERC721A is
1025   Context,
1026   ERC165,
1027   IERC721,
1028   IERC721Metadata,
1029   IERC721Enumerable
1030 {
1031   using Address for address;
1032   using Strings for uint256;
1033 
1034   struct TokenOwnership {
1035     address addr;
1036     uint64 startTimestamp;
1037   }
1038 
1039   struct AddressData {
1040     uint128 balance;
1041     uint128 numberMinted;
1042   }
1043 
1044   uint256 private currentIndex;
1045 
1046   uint256 public immutable collectionSize;
1047   uint256 public maxBatchSize;
1048 
1049   // Token name
1050   string private _name;
1051 
1052   // Token symbol
1053   string private _symbol;
1054 
1055   // Mapping from token ID to ownership details
1056   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1057   mapping(uint256 => TokenOwnership) private _ownerships;
1058 
1059   // Mapping owner address to address data
1060   mapping(address => AddressData) private _addressData;
1061 
1062   // Mapping from token ID to approved address
1063   mapping(uint256 => address) private _tokenApprovals;
1064 
1065   // Mapping from owner to operator approvals
1066   mapping(address => mapping(address => bool)) private _operatorApprovals;
1067 
1068   /**
1069    * @dev
1070    * maxBatchSize refers to how much a minter can mint at a time.
1071    * collectionSize_ refers to how many tokens are in the collection.
1072    */
1073   constructor(
1074     string memory name_,
1075     string memory symbol_,
1076     uint256 maxBatchSize_,
1077     uint256 collectionSize_
1078   ) {
1079     require(
1080       collectionSize_ > 0,
1081       "ERC721A: collection must have a nonzero supply"
1082     );
1083     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1084     _name = name_;
1085     _symbol = symbol_;
1086     maxBatchSize = maxBatchSize_;
1087     collectionSize = collectionSize_;
1088     currentIndex = _startTokenId();
1089   }
1090 
1091   /**
1092   * To change the starting tokenId, please override this function.
1093   */
1094   function _startTokenId() internal view virtual returns (uint256) {
1095     return 1;
1096   }
1097 
1098   /**
1099    * @dev See {IERC721Enumerable-totalSupply}.
1100    */
1101   function totalSupply() public view override returns (uint256) {
1102     return _totalMinted();
1103   }
1104 
1105   function currentTokenId() public view returns (uint256) {
1106     return _totalMinted();
1107   }
1108 
1109   function getNextTokenId() public view returns (uint256) {
1110       return SafeMath.add(_totalMinted(), 1);
1111   }
1112 
1113   /**
1114   * Returns the total amount of tokens minted in the contract.
1115   */
1116   function _totalMinted() internal view returns (uint256) {
1117     unchecked {
1118       return currentIndex - _startTokenId();
1119     }
1120   }
1121 
1122   /**
1123    * @dev See {IERC721Enumerable-tokenByIndex}.
1124    */
1125   function tokenByIndex(uint256 index) public view override returns (uint256) {
1126     require(index < totalSupply(), "ERC721A: global index out of bounds");
1127     return index;
1128   }
1129 
1130   /**
1131    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1132    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1133    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1134    */
1135   function tokenOfOwnerByIndex(address owner, uint256 index)
1136     public
1137     view
1138     override
1139     returns (uint256)
1140   {
1141     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1142     uint256 numMintedSoFar = totalSupply();
1143     uint256 tokenIdsIdx = 0;
1144     address currOwnershipAddr = address(0);
1145     for (uint256 i = 0; i < numMintedSoFar; i++) {
1146       TokenOwnership memory ownership = _ownerships[i];
1147       if (ownership.addr != address(0)) {
1148         currOwnershipAddr = ownership.addr;
1149       }
1150       if (currOwnershipAddr == owner) {
1151         if (tokenIdsIdx == index) {
1152           return i;
1153         }
1154         tokenIdsIdx++;
1155       }
1156     }
1157     revert("ERC721A: unable to get token of owner by index");
1158   }
1159 
1160   /**
1161    * @dev See {IERC165-supportsInterface}.
1162    */
1163   function supportsInterface(bytes4 interfaceId)
1164     public
1165     view
1166     virtual
1167     override(ERC165, IERC165)
1168     returns (bool)
1169   {
1170     return
1171       interfaceId == type(IERC721).interfaceId ||
1172       interfaceId == type(IERC721Metadata).interfaceId ||
1173       interfaceId == type(IERC721Enumerable).interfaceId ||
1174       super.supportsInterface(interfaceId);
1175   }
1176 
1177   /**
1178    * @dev See {IERC721-balanceOf}.
1179    */
1180   function balanceOf(address owner) public view override returns (uint256) {
1181     require(owner != address(0), "ERC721A: balance query for the zero address");
1182     return uint256(_addressData[owner].balance);
1183   }
1184 
1185   function _numberMinted(address owner) internal view returns (uint256) {
1186     require(
1187       owner != address(0),
1188       "ERC721A: number minted query for the zero address"
1189     );
1190     return uint256(_addressData[owner].numberMinted);
1191   }
1192 
1193   function ownershipOf(uint256 tokenId)
1194     internal
1195     view
1196     returns (TokenOwnership memory)
1197   {
1198     uint256 curr = tokenId;
1199 
1200     unchecked {
1201         if (_startTokenId() <= curr && curr < currentIndex) {
1202             TokenOwnership memory ownership = _ownerships[curr];
1203             if (ownership.addr != address(0)) {
1204                 return ownership;
1205             }
1206 
1207             // Invariant:
1208             // There will always be an ownership that has an address and is not burned
1209             // before an ownership that does not have an address and is not burned.
1210             // Hence, curr will not underflow.
1211             while (true) {
1212                 curr--;
1213                 ownership = _ownerships[curr];
1214                 if (ownership.addr != address(0)) {
1215                     return ownership;
1216                 }
1217             }
1218         }
1219     }
1220 
1221     revert("ERC721A: unable to determine the owner of token");
1222   }
1223 
1224   /**
1225    * @dev See {IERC721-ownerOf}.
1226    */
1227   function ownerOf(uint256 tokenId) public view override returns (address) {
1228     return ownershipOf(tokenId).addr;
1229   }
1230 
1231   /**
1232    * @dev See {IERC721Metadata-name}.
1233    */
1234   function name() public view virtual override returns (string memory) {
1235     return _name;
1236   }
1237 
1238   /**
1239    * @dev See {IERC721Metadata-symbol}.
1240    */
1241   function symbol() public view virtual override returns (string memory) {
1242     return _symbol;
1243   }
1244 
1245   /**
1246    * @dev See {IERC721Metadata-tokenURI}.
1247    */
1248   function tokenURI(uint256 tokenId)
1249     public
1250     view
1251     virtual
1252     override
1253     returns (string memory)
1254   {
1255     string memory baseURI = _baseURI();
1256     return
1257       bytes(baseURI).length > 0
1258         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1259         : "";
1260   }
1261 
1262   /**
1263    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1264    * token will be the concatenation of the baseURI and the tokenId. Empty
1265    * by default, can be overriden in child contracts.
1266    */
1267   function _baseURI() internal view virtual returns (string memory) {
1268     return "";
1269   }
1270 
1271   /**
1272    * @dev See {IERC721-approve}.
1273    */
1274   function approve(address to, uint256 tokenId) public override {
1275     address owner = ERC721A.ownerOf(tokenId);
1276     require(to != owner, "ERC721A: approval to current owner");
1277 
1278     require(
1279       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1280       "ERC721A: approve caller is not owner nor approved for all"
1281     );
1282 
1283     _approve(to, tokenId, owner);
1284   }
1285 
1286   /**
1287    * @dev See {IERC721-getApproved}.
1288    */
1289   function getApproved(uint256 tokenId) public view override returns (address) {
1290     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1291 
1292     return _tokenApprovals[tokenId];
1293   }
1294 
1295   /**
1296    * @dev See {IERC721-setApprovalForAll}.
1297    */
1298   function setApprovalForAll(address operator, bool approved) public override {
1299     require(operator != _msgSender(), "ERC721A: approve to caller");
1300 
1301     _operatorApprovals[_msgSender()][operator] = approved;
1302     emit ApprovalForAll(_msgSender(), operator, approved);
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-isApprovedForAll}.
1307    */
1308   function isApprovedForAll(address owner, address operator)
1309     public
1310     view
1311     virtual
1312     override
1313     returns (bool)
1314   {
1315     return _operatorApprovals[owner][operator];
1316   }
1317 
1318   /**
1319    * @dev See {IERC721-transferFrom}.
1320    */
1321   function transferFrom(
1322     address from,
1323     address to,
1324     uint256 tokenId
1325   ) public override {
1326     _transfer(from, to, tokenId);
1327   }
1328 
1329   /**
1330    * @dev See {IERC721-safeTransferFrom}.
1331    */
1332   function safeTransferFrom(
1333     address from,
1334     address to,
1335     uint256 tokenId
1336   ) public override {
1337     safeTransferFrom(from, to, tokenId, "");
1338   }
1339 
1340   /**
1341    * @dev See {IERC721-safeTransferFrom}.
1342    */
1343   function safeTransferFrom(
1344     address from,
1345     address to,
1346     uint256 tokenId,
1347     bytes memory _data
1348   ) public override {
1349     _transfer(from, to, tokenId);
1350     require(
1351       _checkOnERC721Received(from, to, tokenId, _data),
1352       "ERC721A: transfer to non ERC721Receiver implementer"
1353     );
1354   }
1355 
1356   /**
1357    * @dev Returns whether tokenId exists.
1358    *
1359    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1360    *
1361    * Tokens start existing when they are minted (_mint),
1362    */
1363   function _exists(uint256 tokenId) internal view returns (bool) {
1364     return _startTokenId() <= tokenId && tokenId < currentIndex;
1365   }
1366 
1367   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1368     _safeMint(to, quantity, isAdminMint, "");
1369   }
1370 
1371   /**
1372    * @dev Mints quantity tokens and transfers them to to.
1373    *
1374    * Requirements:
1375    *
1376    * - there must be quantity tokens remaining unminted in the total collection.
1377    * - to cannot be the zero address.
1378    * - quantity cannot be larger than the max batch size.
1379    *
1380    * Emits a {Transfer} event.
1381    */
1382   function _safeMint(
1383     address to,
1384     uint256 quantity,
1385     bool isAdminMint,
1386     bytes memory _data
1387   ) internal {
1388     uint256 startTokenId = currentIndex;
1389     require(to != address(0), "ERC721A: mint to the zero address");
1390     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1391     require(!_exists(startTokenId), "ERC721A: token already minted");
1392     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1393 
1394     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1395 
1396     AddressData memory addressData = _addressData[to];
1397     _addressData[to] = AddressData(
1398       addressData.balance + uint128(quantity),
1399       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1400     );
1401     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1402 
1403     uint256 updatedIndex = startTokenId;
1404 
1405     for (uint256 i = 0; i < quantity; i++) {
1406       emit Transfer(address(0), to, updatedIndex);
1407       require(
1408         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1409         "ERC721A: transfer to non ERC721Receiver implementer"
1410       );
1411       updatedIndex++;
1412     }
1413 
1414     currentIndex = updatedIndex;
1415     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1416   }
1417 
1418   /**
1419    * @dev Transfers tokenId from from to to.
1420    *
1421    * Requirements:
1422    *
1423    * - to cannot be the zero address.
1424    * - tokenId token must be owned by from.
1425    *
1426    * Emits a {Transfer} event.
1427    */
1428   function _transfer(
1429     address from,
1430     address to,
1431     uint256 tokenId
1432   ) private {
1433     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1434 
1435     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1436       getApproved(tokenId) == _msgSender() ||
1437       isApprovedForAll(prevOwnership.addr, _msgSender()));
1438 
1439     require(
1440       isApprovedOrOwner,
1441       "ERC721A: transfer caller is not owner nor approved"
1442     );
1443 
1444     require(
1445       prevOwnership.addr == from,
1446       "ERC721A: transfer from incorrect owner"
1447     );
1448     require(to != address(0), "ERC721A: transfer to the zero address");
1449 
1450     _beforeTokenTransfers(from, to, tokenId, 1);
1451 
1452     // Clear approvals from the previous owner
1453     _approve(address(0), tokenId, prevOwnership.addr);
1454 
1455     _addressData[from].balance -= 1;
1456     _addressData[to].balance += 1;
1457     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1458 
1459     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1460     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1461     uint256 nextTokenId = tokenId + 1;
1462     if (_ownerships[nextTokenId].addr == address(0)) {
1463       if (_exists(nextTokenId)) {
1464         _ownerships[nextTokenId] = TokenOwnership(
1465           prevOwnership.addr,
1466           prevOwnership.startTimestamp
1467         );
1468       }
1469     }
1470 
1471     emit Transfer(from, to, tokenId);
1472     _afterTokenTransfers(from, to, tokenId, 1);
1473   }
1474 
1475   /**
1476    * @dev Approve to to operate on tokenId
1477    *
1478    * Emits a {Approval} event.
1479    */
1480   function _approve(
1481     address to,
1482     uint256 tokenId,
1483     address owner
1484   ) private {
1485     _tokenApprovals[tokenId] = to;
1486     emit Approval(owner, to, tokenId);
1487   }
1488 
1489   uint256 public nextOwnerToExplicitlySet = 0;
1490 
1491   /**
1492    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1493    */
1494   function _setOwnersExplicit(uint256 quantity) internal {
1495     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1496     require(quantity > 0, "quantity must be nonzero");
1497     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1498 
1499     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1500     if (endIndex > collectionSize - 1) {
1501       endIndex = collectionSize - 1;
1502     }
1503     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1504     require(_exists(endIndex), "not enough minted yet for this cleanup");
1505     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1506       if (_ownerships[i].addr == address(0)) {
1507         TokenOwnership memory ownership = ownershipOf(i);
1508         _ownerships[i] = TokenOwnership(
1509           ownership.addr,
1510           ownership.startTimestamp
1511         );
1512       }
1513     }
1514     nextOwnerToExplicitlySet = endIndex + 1;
1515   }
1516 
1517   /**
1518    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1519    * The call is not executed if the target address is not a contract.
1520    *
1521    * @param from address representing the previous owner of the given token ID
1522    * @param to target address that will receive the tokens
1523    * @param tokenId uint256 ID of the token to be transferred
1524    * @param _data bytes optional data to send along with the call
1525    * @return bool whether the call correctly returned the expected magic value
1526    */
1527   function _checkOnERC721Received(
1528     address from,
1529     address to,
1530     uint256 tokenId,
1531     bytes memory _data
1532   ) private returns (bool) {
1533     if (to.isContract()) {
1534       try
1535         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1536       returns (bytes4 retval) {
1537         return retval == IERC721Receiver(to).onERC721Received.selector;
1538       } catch (bytes memory reason) {
1539         if (reason.length == 0) {
1540           revert("ERC721A: transfer to non ERC721Receiver implementer");
1541         } else {
1542           assembly {
1543             revert(add(32, reason), mload(reason))
1544           }
1545         }
1546       }
1547     } else {
1548       return true;
1549     }
1550   }
1551 
1552   /**
1553    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1554    *
1555    * startTokenId - the first token id to be transferred
1556    * quantity - the amount to be transferred
1557    *
1558    * Calling conditions:
1559    *
1560    * - When from and to are both non-zero, from's tokenId will be
1561    * transferred to to.
1562    * - When from is zero, tokenId will be minted for to.
1563    */
1564   function _beforeTokenTransfers(
1565     address from,
1566     address to,
1567     uint256 startTokenId,
1568     uint256 quantity
1569   ) internal virtual {}
1570 
1571   /**
1572    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1573    * minting.
1574    *
1575    * startTokenId - the first token id to be transferred
1576    * quantity - the amount to be transferred
1577    *
1578    * Calling conditions:
1579    *
1580    * - when from and to are both non-zero.
1581    * - from and to are never both zero.
1582    */
1583   function _afterTokenTransfers(
1584     address from,
1585     address to,
1586     uint256 startTokenId,
1587     uint256 quantity
1588   ) internal virtual {}
1589 }
1590 
1591 
1592 
1593   
1594 abstract contract Ramppable {
1595   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1596 
1597   modifier isRampp() {
1598       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1599       _;
1600   }
1601 }
1602 
1603 
1604   
1605 interface IERC20 {
1606   function transfer(address _to, uint256 _amount) external returns (bool);
1607   function balanceOf(address account) external view returns (uint256);
1608 }
1609 
1610 abstract contract Withdrawable is Ownable, Ramppable {
1611   address[] public payableAddresses = [RAMPPADDRESS,0x32089f54DFc03B963C454A401DB360A7e8d3681b];
1612   uint256[] public payableFees = [5,95];
1613   uint256 public payableAddressCount = 2;
1614 
1615   function withdrawAll() public onlyOwner {
1616       require(address(this).balance > 0);
1617       _withdrawAll();
1618   }
1619   
1620   function withdrawAllRampp() public isRampp {
1621       require(address(this).balance > 0);
1622       _withdrawAll();
1623   }
1624 
1625   function _withdrawAll() private {
1626       uint256 balance = address(this).balance;
1627       
1628       for(uint i=0; i < payableAddressCount; i++ ) {
1629           _widthdraw(
1630               payableAddresses[i],
1631               (balance * payableFees[i]) / 100
1632           );
1633       }
1634   }
1635   
1636   function _widthdraw(address _address, uint256 _amount) private {
1637       (bool success, ) = _address.call{value: _amount}("");
1638       require(success, "Transfer failed.");
1639   }
1640 
1641   /**
1642     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1643     * while still splitting royalty payments to all other team members.
1644     * in the event ERC-20 tokens are paid to the contract.
1645     * @param _tokenContract contract of ERC-20 token to withdraw
1646     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1647     */
1648   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1649     require(_amount > 0);
1650     IERC20 tokenContract = IERC20(_tokenContract);
1651     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1652 
1653     for(uint i=0; i < payableAddressCount; i++ ) {
1654         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1655     }
1656   }
1657 
1658   /**
1659   * @dev Allows Rampp wallet to update its own reference as well as update
1660   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1661   * and since Rampp is always the first address this function is limited to the rampp payout only.
1662   * @param _newAddress updated Rampp Address
1663   */
1664   function setRamppAddress(address _newAddress) public isRampp {
1665     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1666     RAMPPADDRESS = _newAddress;
1667     payableAddresses[0] = _newAddress;
1668   }
1669 }
1670 
1671 
1672   
1673 abstract contract RamppERC721A is 
1674     Ownable,
1675     ERC721A,
1676     Withdrawable,
1677     ReentrancyGuard  {
1678     constructor(
1679         string memory tokenName,
1680         string memory tokenSymbol
1681     ) ERC721A(tokenName, tokenSymbol, 1, 444 ) {}
1682     using SafeMath for uint256;
1683     uint8 public CONTRACT_VERSION = 2;
1684     string public _baseTokenURI = "ipfs://QmY6HatCh8imzDQtN4M5KAFcb1MRqaMzh7uVJ6wJnKRwT4/";
1685 
1686     bool public mintingOpen = false;
1687     
1688     
1689     
1690     uint256 public MAX_WALLET_MINTS = 1;
1691 
1692     
1693     /////////////// Admin Mint Functions
1694     /**
1695     * @dev Mints a token to an address with a tokenURI.
1696     * This is owner only and allows a fee-free drop
1697     * @param _to address of the future owner of the token
1698     */
1699     function mintToAdmin(address _to) public onlyOwner {
1700         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 444");
1701         _safeMint(_to, 1, true);
1702     }
1703 
1704     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1705         for(uint i=0; i < _addressCount; i++ ) {
1706             mintToAdmin(_addresses[i]);
1707         }
1708     }
1709 
1710     
1711     /////////////// GENERIC MINT FUNCTIONS
1712     /**
1713     * @dev Mints a single token to an address.
1714     * fee may or may not be required*
1715     * @param _to address of the future owner of the token
1716     */
1717     function mintTo(address _to) public payable {
1718         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 444");
1719         require(mintingOpen == true, "Minting is not open right now!");
1720         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1721         
1722         
1723         _safeMint(_to, 1, false);
1724     }
1725 
1726     /**
1727     * @dev Mints a token to an address with a tokenURI.
1728     * fee may or may not be required*
1729     * @param _to address of the future owner of the token
1730     * @param _amount number of tokens to mint
1731     */
1732     function mintToMultiple(address _to, uint256 _amount) public payable {
1733         require(_amount >= 1, "Must mint at least 1 token");
1734         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1735         require(mintingOpen == true, "Minting is not open right now!");
1736         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1737         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 444");
1738         
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
1754     /**
1755     * @dev Check if wallet over MAX_WALLET_MINTS
1756     * @param _address address in question to check if minted count exceeds max
1757     */
1758     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1759         require(_amount >= 1, "Amount must be greater than or equal to 1");
1760         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1761     }
1762 
1763     /**
1764     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1765     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1766     */
1767     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1768         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1769         MAX_WALLET_MINTS = _newWalletMax;
1770     }
1771     
1772 
1773     
1774     /**
1775      * @dev Allows owner to set Max mints per tx
1776      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1777      */
1778      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1779          require(_newMaxMint >= 1, "Max mint must be at least 1");
1780          maxBatchSize = _newMaxMint;
1781      }
1782     
1783 
1784     
1785 
1786     
1787     
1788     function _baseURI() internal view virtual override returns (string memory) {
1789         return _baseTokenURI;
1790     }
1791 
1792     function baseTokenURI() public view returns (string memory) {
1793         return _baseTokenURI;
1794     }
1795 
1796     function setBaseURI(string calldata baseURI) external onlyOwner {
1797         _baseTokenURI = baseURI;
1798     }
1799 
1800     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1801         return ownershipOf(tokenId);
1802     }
1803 }
1804 
1805 
1806   
1807 // File: contracts/CanvasEmotionsContract.sol
1808 //SPDX-License-Identifier: MIT
1809 
1810 pragma solidity ^0.8.0;
1811 
1812 contract CanvasEmotionsContract is RamppERC721A {
1813     constructor() RamppERC721A("Canvas Emotions", "CEmotions"){}
1814 
1815     function contractURI() public pure returns (string memory) {
1816       return "https://us-central1-nft-rampp.cloudfunctions.net/app/dCxVkRmPE4ayKvlcdfNX/contract-metadata";
1817     }
1818 }
1819   
1820 //*********************************************************************//
1821 //*********************************************************************//  
1822 //                       Rampp v2.0.1
1823 //
1824 //         This smart contract was generated by rampp.xyz.
1825 //            Rampp allows creators like you to launch 
1826 //             large scale NFT communities without code!
1827 //
1828 //    Rampp is not responsible for the content of this contract and
1829 //        hopes it is being used in a responsible and kind way.  
1830 //       Rampp is not associated or affiliated with this project.                                                    
1831 //             Twitter: @Rampp_ ---- rampp.xyz
1832 //*********************************************************************//                                                     
1833 //*********************************************************************//