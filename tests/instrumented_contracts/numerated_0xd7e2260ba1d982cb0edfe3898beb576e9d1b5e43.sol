1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on `isContract` to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @title ERC721 token receiver interface
465  * @dev Interface for any contract that wants to support safeTransfers
466  * from ERC721 asset contracts.
467  */
468 interface IERC721Receiver {
469     /**
470      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
471      * by `operator` from `from`, this function is called.
472      *
473      * It must return its Solidity selector to confirm the token transfer.
474      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
475      *
476      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
477      */
478     function onERC721Received(
479         address operator,
480         address from,
481         uint256 tokenId,
482         bytes calldata data
483     ) external returns (bytes4);
484 }
485 
486 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface of the ERC165 standard, as defined in the
495  * https://eips.ethereum.org/EIPS/eip-165[EIP].
496  *
497  * Implementers can declare support of contract interfaces, which can then be
498  * queried by others ({ERC165Checker}).
499  *
500  * For an implementation, see {ERC165}.
501  */
502 interface IERC165 {
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 
553 /**
554  * @dev Required interface of an ERC721 compliant contract.
555  */
556 interface IERC721 is IERC165 {
557     /**
558      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
559      */
560     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
564      */
565     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
569      */
570     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
571 
572     /**
573      * @dev Returns the number of tokens in ``owner``'s account.
574      */
575     function balanceOf(address owner) external view returns (uint256 balance);
576 
577     /**
578      * @dev Returns the owner of the `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function ownerOf(uint256 tokenId) external view returns (address owner);
585 
586     /**
587      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
588      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must exist and be owned by `from`.
595      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
596      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
597      *
598      * Emits a {Transfer} event.
599      */
600     function safeTransferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Transfers `tokenId` token from `from` to `to`.
608      *
609      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must be owned by `from`.
616      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      *
618      * Emits a {Transfer} event.
619      */
620     function transferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
628      * The approval is cleared when the token is transferred.
629      *
630      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
631      *
632      * Requirements:
633      *
634      * - The caller must own the token or be an approved operator.
635      * - `tokenId` must exist.
636      *
637      * Emits an {Approval} event.
638      */
639     function approve(address to, uint256 tokenId) external;
640 
641     /**
642      * @dev Returns the account approved for `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function getApproved(uint256 tokenId) external view returns (address operator);
649 
650     /**
651      * @dev Approve or remove `operator` as an operator for the caller.
652      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
653      *
654      * Requirements:
655      *
656      * - The `operator` cannot be the caller.
657      *
658      * Emits an {ApprovalForAll} event.
659      */
660     function setApprovalForAll(address operator, bool _approved) external;
661 
662     /**
663      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
664      *
665      * See {setApprovalForAll}
666      */
667     function isApprovedForAll(address owner, address operator) external view returns (bool);
668 
669     /**
670      * @dev Safely transfers `tokenId` token from `from` to `to`.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId,
686         bytes calldata data
687     ) external;
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
691 
692 
693 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
700  * @dev See https://eips.ethereum.org/EIPS/eip-721
701  */
702 interface IERC721Enumerable is IERC721 {
703     /**
704      * @dev Returns the total amount of tokens stored by the contract.
705      */
706     function totalSupply() external view returns (uint256);
707 
708     /**
709      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
710      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
711      */
712     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
713 
714     /**
715      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
716      * Use along with {totalSupply} to enumerate all tokens.
717      */
718     function tokenByIndex(uint256 index) external view returns (uint256);
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
731  * @dev See https://eips.ethereum.org/EIPS/eip-721
732  */
733 interface IERC721Metadata is IERC721 {
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 }
749 
750 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @dev Contract module that helps prevent reentrant calls to a function.
759  *
760  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
761  * available, which can be applied to functions to make sure there are no nested
762  * (reentrant) calls to them.
763  *
764  * Note that because there is a single `nonReentrant` guard, functions marked as
765  * `nonReentrant` may not call one another. This can be worked around by making
766  * those functions `private`, and then adding `external` `nonReentrant` entry
767  * points to them.
768  *
769  * TIP: If you would like to learn more about reentrancy and alternative ways
770  * to protect against it, check out our blog post
771  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
772  */
773 abstract contract ReentrancyGuard {
774     // Booleans are more expensive than uint256 or any type that takes up a full
775     // word because each write operation emits an extra SLOAD to first read the
776     // slot's contents, replace the bits taken up by the boolean, and then write
777     // back. This is the compiler's defense against contract upgrades and
778     // pointer aliasing, and it cannot be disabled.
779 
780     // The values being non-zero value makes deployment a bit more expensive,
781     // but in exchange the refund on every call to nonReentrant will be lower in
782     // amount. Since refunds are capped to a percentage of the total
783     // transaction's gas, it is best to keep them low in cases like this one, to
784     // increase the likelihood of the full refund coming into effect.
785     uint256 private constant _NOT_ENTERED = 1;
786     uint256 private constant _ENTERED = 2;
787 
788     uint256 private _status;
789 
790     constructor() {
791         _status = _NOT_ENTERED;
792     }
793 
794     /**
795      * @dev Prevents a contract from calling itself, directly or indirectly.
796      * Calling a `nonReentrant` function from another `nonReentrant`
797      * function is not supported. It is possible to prevent this from happening
798      * by making the `nonReentrant` function external, and making it call a
799      * `private` function that does the actual work.
800      */
801     modifier nonReentrant() {
802         // On the first call to nonReentrant, _notEntered will be true
803         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
804 
805         // Any calls to nonReentrant after this point will fail
806         _status = _ENTERED;
807 
808         _;
809 
810         // By storing the original value once again, a refund is triggered (see
811         // https://eips.ethereum.org/EIPS/eip-2200)
812         _status = _NOT_ENTERED;
813     }
814 }
815 
816 // File: @openzeppelin/contracts/utils/Strings.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev String operations.
825  */
826 library Strings {
827     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
828 
829     /**
830      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
831      */
832     function toString(uint256 value) internal pure returns (string memory) {
833         // Inspired by OraclizeAPI's implementation - MIT licence
834         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
835 
836         if (value == 0) {
837             return "0";
838         }
839         uint256 temp = value;
840         uint256 digits;
841         while (temp != 0) {
842             digits++;
843             temp /= 10;
844         }
845         bytes memory buffer = new bytes(digits);
846         while (value != 0) {
847             digits -= 1;
848             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
849             value /= 10;
850         }
851         return string(buffer);
852     }
853 
854     /**
855      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
856      */
857     function toHexString(uint256 value) internal pure returns (string memory) {
858         if (value == 0) {
859             return "0x00";
860         }
861         uint256 temp = value;
862         uint256 length = 0;
863         while (temp != 0) {
864             length++;
865             temp >>= 8;
866         }
867         return toHexString(value, length);
868     }
869 
870     /**
871      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
872      */
873     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
874         bytes memory buffer = new bytes(2 * length + 2);
875         buffer[0] = "0";
876         buffer[1] = "x";
877         for (uint256 i = 2 * length + 1; i > 1; --i) {
878             buffer[i] = _HEX_SYMBOLS[value & 0xf];
879             value >>= 4;
880         }
881         require(value == 0, "Strings: hex length insufficient");
882         return string(buffer);
883     }
884 }
885 
886 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
887 
888 
889 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 /**
895  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
896  *
897  * These functions can be used to verify that a message was signed by the holder
898  * of the private keys of a given address.
899  */
900 library ECDSA {
901     enum RecoverError {
902         NoError,
903         InvalidSignature,
904         InvalidSignatureLength,
905         InvalidSignatureS,
906         InvalidSignatureV
907     }
908 
909     function _throwError(RecoverError error) private pure {
910         if (error == RecoverError.NoError) {
911             return; // no error: do nothing
912         } else if (error == RecoverError.InvalidSignature) {
913             revert("ECDSA: invalid signature");
914         } else if (error == RecoverError.InvalidSignatureLength) {
915             revert("ECDSA: invalid signature length");
916         } else if (error == RecoverError.InvalidSignatureS) {
917             revert("ECDSA: invalid signature 's' value");
918         } else if (error == RecoverError.InvalidSignatureV) {
919             revert("ECDSA: invalid signature 'v' value");
920         }
921     }
922 
923     /**
924      * @dev Returns the address that signed a hashed message (`hash`) with
925      * `signature` or error string. This address can then be used for verification purposes.
926      *
927      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
928      * this function rejects them by requiring the `s` value to be in the lower
929      * half order, and the `v` value to be either 27 or 28.
930      *
931      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
932      * verification to be secure: it is possible to craft signatures that
933      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
934      * this is by receiving a hash of the original message (which may otherwise
935      * be too long), and then calling {toEthSignedMessageHash} on it.
936      *
937      * Documentation for signature generation:
938      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
939      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
940      *
941      * _Available since v4.3._
942      */
943     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
944         // Check the signature length
945         // - case 65: r,s,v signature (standard)
946         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
947         if (signature.length == 65) {
948             bytes32 r;
949             bytes32 s;
950             uint8 v;
951             // ecrecover takes the signature parameters, and the only way to get them
952             // currently is to use assembly.
953             assembly {
954                 r := mload(add(signature, 0x20))
955                 s := mload(add(signature, 0x40))
956                 v := byte(0, mload(add(signature, 0x60)))
957             }
958             return tryRecover(hash, v, r, s);
959         } else if (signature.length == 64) {
960             bytes32 r;
961             bytes32 vs;
962             // ecrecover takes the signature parameters, and the only way to get them
963             // currently is to use assembly.
964             assembly {
965                 r := mload(add(signature, 0x20))
966                 vs := mload(add(signature, 0x40))
967             }
968             return tryRecover(hash, r, vs);
969         } else {
970             return (address(0), RecoverError.InvalidSignatureLength);
971         }
972     }
973 
974     /**
975      * @dev Returns the address that signed a hashed message (`hash`) with
976      * `signature`. This address can then be used for verification purposes.
977      *
978      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
979      * this function rejects them by requiring the `s` value to be in the lower
980      * half order, and the `v` value to be either 27 or 28.
981      *
982      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
983      * verification to be secure: it is possible to craft signatures that
984      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
985      * this is by receiving a hash of the original message (which may otherwise
986      * be too long), and then calling {toEthSignedMessageHash} on it.
987      */
988     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
989         (address recovered, RecoverError error) = tryRecover(hash, signature);
990         _throwError(error);
991         return recovered;
992     }
993 
994     /**
995      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
996      *
997      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
998      *
999      * _Available since v4.3._
1000      */
1001     function tryRecover(
1002         bytes32 hash,
1003         bytes32 r,
1004         bytes32 vs
1005     ) internal pure returns (address, RecoverError) {
1006         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1007         uint8 v = uint8((uint256(vs) >> 255) + 27);
1008         return tryRecover(hash, v, r, s);
1009     }
1010 
1011     /**
1012      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1013      *
1014      * _Available since v4.2._
1015      */
1016     function recover(
1017         bytes32 hash,
1018         bytes32 r,
1019         bytes32 vs
1020     ) internal pure returns (address) {
1021         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1022         _throwError(error);
1023         return recovered;
1024     }
1025 
1026     /**
1027      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1028      * `r` and `s` signature fields separately.
1029      *
1030      * _Available since v4.3._
1031      */
1032     function tryRecover(
1033         bytes32 hash,
1034         uint8 v,
1035         bytes32 r,
1036         bytes32 s
1037     ) internal pure returns (address, RecoverError) {
1038         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1039         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1040         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1041         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1042         //
1043         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1044         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1045         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1046         // these malleable signatures as well.
1047         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1048             return (address(0), RecoverError.InvalidSignatureS);
1049         }
1050         if (v != 27 && v != 28) {
1051             return (address(0), RecoverError.InvalidSignatureV);
1052         }
1053 
1054         // If the signature is valid (and not malleable), return the signer address
1055         address signer = ecrecover(hash, v, r, s);
1056         if (signer == address(0)) {
1057             return (address(0), RecoverError.InvalidSignature);
1058         }
1059 
1060         return (signer, RecoverError.NoError);
1061     }
1062 
1063     /**
1064      * @dev Overload of {ECDSA-recover} that receives the `v`,
1065      * `r` and `s` signature fields separately.
1066      */
1067     function recover(
1068         bytes32 hash,
1069         uint8 v,
1070         bytes32 r,
1071         bytes32 s
1072     ) internal pure returns (address) {
1073         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1074         _throwError(error);
1075         return recovered;
1076     }
1077 
1078     /**
1079      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1080      * produces hash corresponding to the one signed with the
1081      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1082      * JSON-RPC method as part of EIP-191.
1083      *
1084      * See {recover}.
1085      */
1086     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1087         // 32 is the length in bytes of hash,
1088         // enforced by the type signature above
1089         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1090     }
1091 
1092     /**
1093      * @dev Returns an Ethereum Signed Message, created from `s`. This
1094      * produces hash corresponding to the one signed with the
1095      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1096      * JSON-RPC method as part of EIP-191.
1097      *
1098      * See {recover}.
1099      */
1100     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1101         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1102     }
1103 
1104     /**
1105      * @dev Returns an Ethereum Signed Typed Data, created from a
1106      * `domainSeparator` and a `structHash`. This produces hash corresponding
1107      * to the one signed with the
1108      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1109      * JSON-RPC method as part of EIP-712.
1110      *
1111      * See {recover}.
1112      */
1113     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1114         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1115     }
1116 }
1117 
1118 // File: @openzeppelin/contracts/utils/Context.sol
1119 
1120 
1121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 /**
1126  * @dev Provides information about the current execution context, including the
1127  * sender of the transaction and its data. While these are generally available
1128  * via msg.sender and msg.data, they should not be accessed in such a direct
1129  * manner, since when dealing with meta-transactions the account sending and
1130  * paying for execution may not be the actual sender (as far as an application
1131  * is concerned).
1132  *
1133  * This contract is only required for intermediate, library-like contracts.
1134  */
1135 abstract contract Context {
1136     function _msgSender() internal view virtual returns (address) {
1137         return msg.sender;
1138     }
1139 
1140     function _msgData() internal view virtual returns (bytes calldata) {
1141         return msg.data;
1142     }
1143 }
1144 
1145 // File: erc721a/contracts/ERC721A.sol
1146 
1147 
1148 // Creator: Chiru Labs
1149 
1150 pragma solidity ^0.8.4;
1151 
1152 
1153 
1154 
1155 
1156 
1157 
1158 
1159 
1160 error ApprovalCallerNotOwnerNorApproved();
1161 error ApprovalQueryForNonexistentToken();
1162 error ApproveToCaller();
1163 error ApprovalToCurrentOwner();
1164 error BalanceQueryForZeroAddress();
1165 error MintedQueryForZeroAddress();
1166 error BurnedQueryForZeroAddress();
1167 error AuxQueryForZeroAddress();
1168 error MintToZeroAddress();
1169 error MintZeroQuantity();
1170 error OwnerIndexOutOfBounds();
1171 error OwnerQueryForNonexistentToken();
1172 error TokenIndexOutOfBounds();
1173 error TransferCallerNotOwnerNorApproved();
1174 error TransferFromIncorrectOwner();
1175 error TransferToNonERC721ReceiverImplementer();
1176 error TransferToZeroAddress();
1177 error URIQueryForNonexistentToken();
1178 
1179 /**
1180  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1181  * the Metadata extension. Built to optimize for lower gas during batch mints.
1182  *
1183  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1184  *
1185  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1186  *
1187  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1188  */
1189 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1190     using Address for address;
1191     using Strings for uint256;
1192 
1193     // Compiler will pack this into a single 256bit word.
1194     struct TokenOwnership {
1195         // The address of the owner.
1196         address addr;
1197         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1198         uint64 startTimestamp;
1199         // Whether the token has been burned.
1200         bool burned;
1201     }
1202 
1203     // Compiler will pack this into a single 256bit word.
1204     struct AddressData {
1205         // Realistically, 2**64-1 is more than enough.
1206         uint64 balance;
1207         // Keeps track of mint count with minimal overhead for tokenomics.
1208         uint64 numberMinted;
1209         // Keeps track of burn count with minimal overhead for tokenomics.
1210         uint64 numberBurned;
1211         // For miscellaneous variable(s) pertaining to the address
1212         // (e.g. number of whitelist mint slots used).
1213         // If there are multiple variables, please pack them into a uint64.
1214         uint64 aux;
1215     }
1216 
1217     // The tokenId of the next token to be minted.
1218     uint256 internal _currentIndex;
1219 
1220     // The number of tokens burned.
1221     uint256 internal _burnCounter;
1222 
1223     // Token name
1224     string private _name;
1225 
1226     // Token symbol
1227     string private _symbol;
1228 
1229     // Mapping from token ID to ownership details
1230     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1231     mapping(uint256 => TokenOwnership) internal _ownerships;
1232 
1233     // Mapping owner address to address data
1234     mapping(address => AddressData) private _addressData;
1235 
1236     // Mapping from token ID to approved address
1237     mapping(uint256 => address) private _tokenApprovals;
1238 
1239     // Mapping from owner to operator approvals
1240     mapping(address => mapping(address => bool)) private _operatorApprovals;
1241 
1242     constructor(string memory name_, string memory symbol_) {
1243         _name = name_;
1244         _symbol = symbol_;
1245         _currentIndex = _startTokenId();
1246     }
1247 
1248     /**
1249      * To change the starting tokenId, please override this function.
1250      */
1251     function _startTokenId() internal view virtual returns (uint256) {
1252         return 0;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-totalSupply}.
1257      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1258      */
1259     function totalSupply() public view returns (uint256) {
1260         // Counter underflow is impossible as _burnCounter cannot be incremented
1261         // more than _currentIndex - _startTokenId() times
1262         unchecked {
1263             return _currentIndex - _burnCounter - _startTokenId();
1264         }
1265     }
1266 
1267     /**
1268      * Returns the total amount of tokens minted in the contract.
1269      */
1270     function _totalMinted() internal view returns (uint256) {
1271         // Counter underflow is impossible as _currentIndex does not decrement,
1272         // and it is initialized to _startTokenId()
1273         unchecked {
1274             return _currentIndex - _startTokenId();
1275         }
1276     }
1277 
1278     /**
1279      * @dev See {IERC165-supportsInterface}.
1280      */
1281     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1282         return
1283             interfaceId == type(IERC721).interfaceId ||
1284             interfaceId == type(IERC721Metadata).interfaceId ||
1285             super.supportsInterface(interfaceId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-balanceOf}.
1290      */
1291     function balanceOf(address owner) public view override returns (uint256) {
1292         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1293         return uint256(_addressData[owner].balance);
1294     }
1295 
1296     /**
1297      * Returns the number of tokens minted by `owner`.
1298      */
1299     function _numberMinted(address owner) internal view returns (uint256) {
1300         if (owner == address(0)) revert MintedQueryForZeroAddress();
1301         return uint256(_addressData[owner].numberMinted);
1302     }
1303 
1304     /**
1305      * Returns the number of tokens burned by or on behalf of `owner`.
1306      */
1307     function _numberBurned(address owner) internal view returns (uint256) {
1308         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1309         return uint256(_addressData[owner].numberBurned);
1310     }
1311 
1312     /**
1313      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1314      */
1315     function _getAux(address owner) internal view returns (uint64) {
1316         if (owner == address(0)) revert AuxQueryForZeroAddress();
1317         return _addressData[owner].aux;
1318     }
1319 
1320     /**
1321      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1322      * If there are multiple variables, please pack them into a uint64.
1323      */
1324     function _setAux(address owner, uint64 aux) internal {
1325         if (owner == address(0)) revert AuxQueryForZeroAddress();
1326         _addressData[owner].aux = aux;
1327     }
1328 
1329     /**
1330      * Gas spent here starts off proportional to the maximum mint batch size.
1331      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1332      */
1333     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1334         uint256 curr = tokenId;
1335 
1336         unchecked {
1337             if (_startTokenId() <= curr && curr < _currentIndex) {
1338                 TokenOwnership memory ownership = _ownerships[curr];
1339                 if (!ownership.burned) {
1340                     if (ownership.addr != address(0)) {
1341                         return ownership;
1342                     }
1343                     // Invariant:
1344                     // There will always be an ownership that has an address and is not burned
1345                     // before an ownership that does not have an address and is not burned.
1346                     // Hence, curr will not underflow.
1347                     while (true) {
1348                         curr--;
1349                         ownership = _ownerships[curr];
1350                         if (ownership.addr != address(0)) {
1351                             return ownership;
1352                         }
1353                     }
1354                 }
1355             }
1356         }
1357         revert OwnerQueryForNonexistentToken();
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-ownerOf}.
1362      */
1363     function ownerOf(uint256 tokenId) public view override returns (address) {
1364         return ownershipOf(tokenId).addr;
1365     }
1366 
1367     /**
1368      * @dev See {IERC721Metadata-name}.
1369      */
1370     function name() public view virtual override returns (string memory) {
1371         return _name;
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Metadata-symbol}.
1376      */
1377     function symbol() public view virtual override returns (string memory) {
1378         return _symbol;
1379     }
1380 
1381     /**
1382      * @dev See {IERC721Metadata-tokenURI}.
1383      */
1384     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1385         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1386 
1387         string memory baseURI = _baseURI();
1388         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1389     }
1390 
1391     /**
1392      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1393      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1394      * by default, can be overriden in child contracts.
1395      */
1396     function _baseURI() internal view virtual returns (string memory) {
1397         return '';
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-approve}.
1402      */
1403     function approve(address to, uint256 tokenId) public override {
1404         address owner = ERC721A.ownerOf(tokenId);
1405         if (to == owner) revert ApprovalToCurrentOwner();
1406 
1407         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1408             revert ApprovalCallerNotOwnerNorApproved();
1409         }
1410 
1411         _approve(to, tokenId, owner);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-getApproved}.
1416      */
1417     function getApproved(uint256 tokenId) public view override returns (address) {
1418         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1419 
1420         return _tokenApprovals[tokenId];
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-setApprovalForAll}.
1425      */
1426     function setApprovalForAll(address operator, bool approved) public override {
1427         if (operator == _msgSender()) revert ApproveToCaller();
1428 
1429         _operatorApprovals[_msgSender()][operator] = approved;
1430         emit ApprovalForAll(_msgSender(), operator, approved);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-isApprovedForAll}.
1435      */
1436     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1437         return _operatorApprovals[owner][operator];
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-transferFrom}.
1442      */
1443     function transferFrom(
1444         address from,
1445         address to,
1446         uint256 tokenId
1447     ) public virtual override {
1448         _transfer(from, to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-safeTransferFrom}.
1453      */
1454     function safeTransferFrom(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) public virtual override {
1459         safeTransferFrom(from, to, tokenId, '');
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-safeTransferFrom}.
1464      */
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory _data
1470     ) public virtual override {
1471         _transfer(from, to, tokenId);
1472         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1473             revert TransferToNonERC721ReceiverImplementer();
1474         }
1475     }
1476 
1477     /**
1478      * @dev Returns whether `tokenId` exists.
1479      *
1480      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1481      *
1482      * Tokens start existing when they are minted (`_mint`),
1483      */
1484     function _exists(uint256 tokenId) internal view returns (bool) {
1485         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1486             !_ownerships[tokenId].burned;
1487     }
1488 
1489     function _safeMint(address to, uint256 quantity) internal {
1490         _safeMint(to, quantity, '');
1491     }
1492 
1493     /**
1494      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1495      *
1496      * Requirements:
1497      *
1498      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1499      * - `quantity` must be greater than 0.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _safeMint(
1504         address to,
1505         uint256 quantity,
1506         bytes memory _data
1507     ) internal {
1508         _mint(to, quantity, _data, true);
1509     }
1510 
1511     /**
1512      * @dev Mints `quantity` tokens and transfers them to `to`.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      * - `quantity` must be greater than 0.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _mint(
1522         address to,
1523         uint256 quantity,
1524         bytes memory _data,
1525         bool safe
1526     ) internal {
1527         uint256 startTokenId = _currentIndex;
1528         if (to == address(0)) revert MintToZeroAddress();
1529         if (quantity == 0) revert MintZeroQuantity();
1530 
1531         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1532 
1533         // Overflows are incredibly unrealistic.
1534         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1535         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1536         unchecked {
1537             _addressData[to].balance += uint64(quantity);
1538             _addressData[to].numberMinted += uint64(quantity);
1539 
1540             _ownerships[startTokenId].addr = to;
1541             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1542 
1543             uint256 updatedIndex = startTokenId;
1544             uint256 end = updatedIndex + quantity;
1545 
1546             if (safe && to.isContract()) {
1547                 do {
1548                     emit Transfer(address(0), to, updatedIndex);
1549                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1550                         revert TransferToNonERC721ReceiverImplementer();
1551                     }
1552                 } while (updatedIndex != end);
1553                 // Reentrancy protection
1554                 if (_currentIndex != startTokenId) revert();
1555             } else {
1556                 do {
1557                     emit Transfer(address(0), to, updatedIndex++);
1558                 } while (updatedIndex != end);
1559             }
1560             _currentIndex = updatedIndex;
1561         }
1562         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1563     }
1564 
1565     /**
1566      * @dev Transfers `tokenId` from `from` to `to`.
1567      *
1568      * Requirements:
1569      *
1570      * - `to` cannot be the zero address.
1571      * - `tokenId` token must be owned by `from`.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function _transfer(
1576         address from,
1577         address to,
1578         uint256 tokenId
1579     ) private {
1580         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1581 
1582         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1583             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1584             getApproved(tokenId) == _msgSender());
1585 
1586         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1587         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1588         if (to == address(0)) revert TransferToZeroAddress();
1589 
1590         _beforeTokenTransfers(from, to, tokenId, 1);
1591 
1592         // Clear approvals from the previous owner
1593         _approve(address(0), tokenId, prevOwnership.addr);
1594 
1595         // Underflow of the sender's balance is impossible because we check for
1596         // ownership above and the recipient's balance can't realistically overflow.
1597         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1598         unchecked {
1599             _addressData[from].balance -= 1;
1600             _addressData[to].balance += 1;
1601 
1602             _ownerships[tokenId].addr = to;
1603             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1604 
1605             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1606             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1607             uint256 nextTokenId = tokenId + 1;
1608             if (_ownerships[nextTokenId].addr == address(0)) {
1609                 // This will suffice for checking _exists(nextTokenId),
1610                 // as a burned slot cannot contain the zero address.
1611                 if (nextTokenId < _currentIndex) {
1612                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1613                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1614                 }
1615             }
1616         }
1617 
1618         emit Transfer(from, to, tokenId);
1619         _afterTokenTransfers(from, to, tokenId, 1);
1620     }
1621 
1622     /**
1623      * @dev Destroys `tokenId`.
1624      * The approval is cleared when the token is burned.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _burn(uint256 tokenId) internal virtual {
1633         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1634 
1635         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1636 
1637         // Clear approvals from the previous owner
1638         _approve(address(0), tokenId, prevOwnership.addr);
1639 
1640         // Underflow of the sender's balance is impossible because we check for
1641         // ownership above and the recipient's balance can't realistically overflow.
1642         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1643         unchecked {
1644             _addressData[prevOwnership.addr].balance -= 1;
1645             _addressData[prevOwnership.addr].numberBurned += 1;
1646 
1647             // Keep track of who burned the token, and the timestamp of burning.
1648             _ownerships[tokenId].addr = prevOwnership.addr;
1649             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1650             _ownerships[tokenId].burned = true;
1651 
1652             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1653             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1654             uint256 nextTokenId = tokenId + 1;
1655             if (_ownerships[nextTokenId].addr == address(0)) {
1656                 // This will suffice for checking _exists(nextTokenId),
1657                 // as a burned slot cannot contain the zero address.
1658                 if (nextTokenId < _currentIndex) {
1659                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1660                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1661                 }
1662             }
1663         }
1664 
1665         emit Transfer(prevOwnership.addr, address(0), tokenId);
1666         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1667 
1668         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1669         unchecked {
1670             _burnCounter++;
1671         }
1672     }
1673 
1674     /**
1675      * @dev Approve `to` to operate on `tokenId`
1676      *
1677      * Emits a {Approval} event.
1678      */
1679     function _approve(
1680         address to,
1681         uint256 tokenId,
1682         address owner
1683     ) private {
1684         _tokenApprovals[tokenId] = to;
1685         emit Approval(owner, to, tokenId);
1686     }
1687 
1688     /**
1689      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1690      *
1691      * @param from address representing the previous owner of the given token ID
1692      * @param to target address that will receive the tokens
1693      * @param tokenId uint256 ID of the token to be transferred
1694      * @param _data bytes optional data to send along with the call
1695      * @return bool whether the call correctly returned the expected magic value
1696      */
1697     function _checkContractOnERC721Received(
1698         address from,
1699         address to,
1700         uint256 tokenId,
1701         bytes memory _data
1702     ) private returns (bool) {
1703         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1704             return retval == IERC721Receiver(to).onERC721Received.selector;
1705         } catch (bytes memory reason) {
1706             if (reason.length == 0) {
1707                 revert TransferToNonERC721ReceiverImplementer();
1708             } else {
1709                 assembly {
1710                     revert(add(32, reason), mload(reason))
1711                 }
1712             }
1713         }
1714     }
1715 
1716     /**
1717      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1718      * And also called before burning one token.
1719      *
1720      * startTokenId - the first token id to be transferred
1721      * quantity - the amount to be transferred
1722      *
1723      * Calling conditions:
1724      *
1725      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1726      * transferred to `to`.
1727      * - When `from` is zero, `tokenId` will be minted for `to`.
1728      * - When `to` is zero, `tokenId` will be burned by `from`.
1729      * - `from` and `to` are never both zero.
1730      */
1731     function _beforeTokenTransfers(
1732         address from,
1733         address to,
1734         uint256 startTokenId,
1735         uint256 quantity
1736     ) internal virtual {}
1737 
1738     /**
1739      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1740      * minting.
1741      * And also called after one token has been burned.
1742      *
1743      * startTokenId - the first token id to be transferred
1744      * quantity - the amount to be transferred
1745      *
1746      * Calling conditions:
1747      *
1748      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1749      * transferred to `to`.
1750      * - When `from` is zero, `tokenId` has been minted for `to`.
1751      * - When `to` is zero, `tokenId` has been burned by `from`.
1752      * - `from` and `to` are never both zero.
1753      */
1754     function _afterTokenTransfers(
1755         address from,
1756         address to,
1757         uint256 startTokenId,
1758         uint256 quantity
1759     ) internal virtual {}
1760 }
1761 
1762 // File: @openzeppelin/contracts/access/Ownable.sol
1763 
1764 
1765 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1766 
1767 pragma solidity ^0.8.0;
1768 
1769 
1770 /**
1771  * @dev Contract module which provides a basic access control mechanism, where
1772  * there is an account (an owner) that can be granted exclusive access to
1773  * specific functions.
1774  *
1775  * By default, the owner account will be the one that deploys the contract. This
1776  * can later be changed with {transferOwnership}.
1777  *
1778  * This module is used through inheritance. It will make available the modifier
1779  * `onlyOwner`, which can be applied to your functions to restrict their use to
1780  * the owner.
1781  */
1782 abstract contract Ownable is Context {
1783     address private _owner;
1784 
1785     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1786 
1787     /**
1788      * @dev Initializes the contract setting the deployer as the initial owner.
1789      */
1790     constructor() {
1791         _transferOwnership(_msgSender());
1792     }
1793 
1794     /**
1795      * @dev Returns the address of the current owner.
1796      */
1797     function owner() public view virtual returns (address) {
1798         return _owner;
1799     }
1800 
1801     /**
1802      * @dev Throws if called by any account other than the owner.
1803      */
1804     modifier onlyOwner() {
1805         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1806         _;
1807     }
1808 
1809     /**
1810      * @dev Leaves the contract without owner. It will not be possible to call
1811      * `onlyOwner` functions anymore. Can only be called by the current owner.
1812      *
1813      * NOTE: Renouncing ownership will leave the contract without an owner,
1814      * thereby removing any functionality that is only available to the owner.
1815      */
1816     function renounceOwnership() public virtual onlyOwner {
1817         _transferOwnership(address(0));
1818     }
1819 
1820     /**
1821      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1822      * Can only be called by the current owner.
1823      */
1824     function transferOwnership(address newOwner) public virtual onlyOwner {
1825         require(newOwner != address(0), "Ownable: new owner is the zero address");
1826         _transferOwnership(newOwner);
1827     }
1828 
1829     /**
1830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1831      * Internal function without access restriction.
1832      */
1833     function _transferOwnership(address newOwner) internal virtual {
1834         address oldOwner = _owner;
1835         _owner = newOwner;
1836         emit OwnershipTransferred(oldOwner, newOwner);
1837     }
1838 }
1839 
1840 // File: contracts/SnakeXGenesis.sol
1841 
1842 
1843 
1844 pragma solidity 0.8.15;
1845 
1846 
1847 
1848 
1849 
1850 // CAUTION
1851 // This version of SafeMath should only be used with Solidity 0.8 or later,
1852 // because it relies on the compiler's built in overflow checks.
1853 
1854 
1855 
1856 //                                 WNXKOkxddollcccccccccccclloddxO0KXNWW                               
1857 //                            WNK0kdolccccc:ccc:ccccccccc::::ccccccclodk0XNWW                          
1858 //                        WNKOxolccccc::cc::ccccccccccccccccccccc:cccccccloxOKNW                       
1859 //                     WN0kolcccccccccc:cccccc:ccccccccccccccccc::cccccccccccldkKNW                    
1860 //                  WNKkoccccccccccccccclodxxkOO0000000000OOkxddolccc::cccc:cc:ccokKNW                 
1861 //                WXOdlcc::cc::ccccldxO0KNWWW                 WNNK0Oxolcc:cc::ccc:cldOXW               
1862 //              WKkoccc:cccccccldk0XNW                              WNX0kdlccc:cc:ccccokXW             
1863 //            WXklccccc:ccccldOKNW                                      WNKOdlccccccccccokXW           
1864 //          WNOoccccccccccokKWW                                            WNKkocc::ccccccoONW         
1865 //         W0dc:cccccccld0NW                                                  WN0dlccc::ccccdKW        
1866 //       WXklc::cccccld0N                                                       WN0dlc::::ccclONW      
1867 //      WKdcc:ccccccd0NW                                                           NOoc:::cccccxXW     
1868 //     WKdccccc:cclkXW                                                              WXklccccc:ccdKW    
1869 //    W0occcc:::co0W             WXKOkkkkO0XW                WX0OkkkkOKXW             N0occ:::cccoKW   
1870 //   WKoc:cccc:cdKW           WXOxocc:cccccoxKN           WN0xlcc:cccccox0NW           WKdcccc::ccdKW  
1871 //  WKdc:ccccccdXW           NOoc:ccc::cccccclxXW        WKxlccc::::cc:c:cd0N           WKdccccccccdX  
1872 //  Nxcc::ccccdKW           Nklcccccc:cc:ccccccdKW      W0occcc:c::cc::cccclkN           WKdcccccccckN 
1873 // WOlccc:cccoKW           WOlcc:ccclolccccccccco0W    N0occccccccclolcc:cccl0W           W0occccc:cl0W
1874 // Xdccccc:clOW            WX0OOOOO0KX0dccccccccclONWWNOlc:cc:::ccdKXK0OOOOO0XW            NklcccccccxX
1875 // Ol:ccccccxX                        WXxcc::ccccclkKKkl:cccc:cccxXW                        XdccccccclO
1876 // dcc:cccclOW                          Xxlccccc:cccllcccc:cc:clkN                          WOlcccc:ccx
1877 // occcccccdK                            Nklcc:ccccc::ccccc:cclON                            Koc:ccccco
1878 // ccccccccxN                             NOlccc:c:cc::ccccccoON                             Xxcc:ccccl
1879 // ccccc:cckN                              W0occ::::::::cccco0W                              Nkcccccc:c
1880 // ccccccclOW               WNK0OkkO0XW     W0occ::c::cc:ccdKW     WX0OkkO0KNW               Nkccccc:cc
1881 // ccc:cccckN             WKkolccclodkXW     NkccccccccccclkN     WKkdolcccldkKW             Nkcccccccc
1882 // c:cccccckN           WXklccclxOKNWWW     NOlccc:ccc:cccclON     WWWNKOxlccclkXW           Nxcccccccc
1883 // lccc:cccdX          WKdcc:lxKW          Nklc:cc::cccc::cclkN          WKxccccdKW          Xdcc:ccccl
1884 // occ::ccco0W         XxccccxXW          Xxccc:::ccc:ccc:ccclkN          WXxc:ccxN         W0occcccccd
1885 // xcc:ccccckN        W0l:::lOW         WXxccccc::cccccccccc:ccxXW         Nkcc:co0W        Nxcc:ccccck
1886 // 0occc::ccoKW       WOlcccco0W       N0dcccc::cccoxxoccccc:cccdKWW     WN0occcclOW       W0oc:cccccoK
1887 // Nkcccc:cccxX       W0occccclx0KXXXKOxlcccccc:clxXWWXxlcccc:ccclx0KXXXKOxlccc::oKW       Xxccc::ccckN
1888 // WKocc::cc:lON       Nkcccc:ccccllllccccccc:cco0N    N0occcccccccclllllccccccclkN       Nklc:::cccdKW
1889 //  WOlccc:::clON       Nklc::::ccccccccccc:ccokXW      WXklcccc:cccccccccccccclkN       NOlccccccco0W 
1890 //   Nklccc:ccclON       WKxlcc:cccccccc:ccldOXW          WXOdlcccccccccccccclxKW       NOlc::cccclON  
1891 //    Nkcc:cc:cclkN        WXOkdollllloodk0XN               WNKOkdoolllloodk0XW        Xklc:::ccclkN   
1892 //    WNklc::::cccxKW         WWNXXXXXNNW                        WNNXXXXNNWW         WKdccccc::clkN    
1893 //      NOlc::c::ccoON                                                             WXOocc:ccccclON     
1894 //       W0occ:cc:c:cd0N                                                         WN0dc:cc:::cco0W      
1895 //        WKxc:c::cccclx0N                                                     WN0dlcc:ccc::lxXW       
1896 //          NOocccccccccldOXW                                                WXOdcccccc:ccco0N         
1897 //           WXkoccccc::cccox0NW                                          WN0xocccc:cccccoOXW          
1898 //             WXkoccccc::ccccox0XWW                                  WNX0xoccc::ccccccokXW            
1899 //               WXkocccccccc::ccldk0KNWW                        WWNK0kdlc:ccc:::::ccdOXW              
1900 //                 WN0xlc:cc:::c:cccclodxO0KXXNNWWWWWWWWWWNNXXKOkxdolccc::::cccccclx0NW                
1901 //                   WWXOdlc:cc::cc:ccccccccllooddddddddddoollccc:ccc:ccccccc:clxOXW                   
1902 //                       WXOxolc::::ccccccccc::ccccccccc::c::ccccc::cccccccloxOXW                      
1903 //                          WNKOxdlcccccc::cccccccccc::::ccccccccccccccldxOKNW                         
1904 //                              WNX0Okxdolcccccccc::::cccccccccclodxkOKXWW                             
1905 //                                   WWNK0kxdollccccccccccllodxk0KNWW                                  
1906 
1907 
1908 // The SnakeX Revolution is here.
1909 
1910 /**
1911  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1912  * the Metadata extension.
1913  */
1914 contract SnakeXGenesis is Context, ERC721A, Ownable, ReentrancyGuard  {
1915     using SafeMath for uint256;
1916     using Strings for uint256;
1917     using ECDSA for bytes32;
1918 
1919     address public signerAddress;
1920 
1921     string public _baseTokenURI;
1922 
1923     uint256 public constant MAX_SUPPLY = 1001;
1924 
1925     // 131 reserved due to previous erroneous contract :-(
1926     // 20 for team + 111 minted by OGs
1927     // 111 will be airdropped to all who minted previously
1928     uint256 public RESERVED = 131;
1929     
1930     uint256 public OG_TRANSACTION_LIMIT = 3;
1931     uint256 public WL_TRANSACTION_LIMIT = 2;
1932     uint256 public PUBLIC_TRANSACTION_LIMIT = 1;
1933 
1934     bool public OGSale;
1935     bool public WLSale;
1936     bool public publicSale;
1937 
1938     constructor(address signer) ERC721A("SnakeX: Genesis", "SXG") {
1939         signerAddress = signer;
1940         _safeMint(msg.sender, RESERVED);
1941     }
1942 
1943     function mintOG(uint256 amount, bytes calldata signature) public payable nonReentrant {
1944         require(_validateSignature(signature), "Invalid sender!");
1945         require(OGSale, "Sale paused!");
1946         require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply!");
1947         require(amount <= OG_TRANSACTION_LIMIT, "Invalid number of NFTs allowed to mint!");
1948         _safeMint(msg.sender, amount);
1949     }
1950 
1951     function mintWL(uint256 amount, bytes calldata signature) public payable nonReentrant {
1952         require(_validateSignature(signature), "Invalid sender!");
1953         require(WLSale, "Sale paused!");
1954         require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply!");
1955         require(amount <= WL_TRANSACTION_LIMIT, "Invalid number of NFTs allowed to mint!");
1956         _safeMint(msg.sender, amount);
1957     }
1958 
1959     function mintPublic(uint256 amount, bytes calldata signature) public payable nonReentrant {
1960         require(_validateSignature(signature), "Invalid sender!");
1961         require(publicSale, "Sale paused!");
1962         require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply!");
1963         require(amount <= PUBLIC_TRANSACTION_LIMIT, "Invalid number of NFTs allowed to mint!");
1964         _safeMint(msg.sender, amount);
1965     }
1966 
1967     function emergencyMint(uint256 numTokens) public onlyOwner {
1968         require(totalSupply().add(numTokens) <= MAX_SUPPLY, "Exceeds maximum supply");
1969         _safeMint(msg.sender, numTokens);
1970     }
1971 
1972     function updateOGSale(bool status) public onlyOwner {
1973         OGSale = status;
1974     }
1975 
1976     function updateWLSale(bool status) public onlyOwner {
1977         WLSale = status;
1978     }
1979 
1980     function updatePublicSale(bool status) public onlyOwner {
1981         publicSale = status;
1982     }
1983     
1984     function setBaseURI(string memory newBaseURI) public onlyOwner {
1985         _baseTokenURI = newBaseURI;
1986     }
1987 
1988     function _baseURI() internal view virtual override returns (string memory) {
1989 		return _baseTokenURI;
1990 	}
1991     
1992     function setPublicLimit(uint256 limit) public onlyOwner {
1993         PUBLIC_TRANSACTION_LIMIT = limit;
1994     }
1995 
1996     function setWLLimit(uint256 limit) public onlyOwner {
1997         WL_TRANSACTION_LIMIT = limit;
1998     }
1999     
2000     function setOGLimit(uint256 limit) public onlyOwner {
2001         OG_TRANSACTION_LIMIT = limit;
2002     }
2003 
2004     function setSigner(address _signer) public onlyOwner {
2005         signerAddress = _signer;
2006     }
2007 
2008     function _validateSignature(bytes calldata signature) internal view returns (bool) {
2009         bytes32 message = ECDSA.toEthSignedMessageHash(abi.encodePacked(msg.sender));
2010         address receivedAddress = ECDSA.recover(message, signature);
2011         return (receivedAddress != address(0) && receivedAddress == signerAddress);
2012     }
2013 
2014     function withdraw() external onlyOwner {
2015         uint256 balance = address(this).balance;
2016         payable(owner()).transfer(balance);
2017     }
2018 }