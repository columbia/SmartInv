1 // SPDX-License-Identifier: MIT
2 // Creator: lohko.io
3 
4 pragma solidity >=0.8.17;
5 
6 
7 // ERC721A Contracts v3.3.0
8 // Creator: Chiru Labs
9 
10 
11 
12 
13 // ERC721A Contracts v3.3.0
14 // Creator: Chiru Labs
15 
16 
17 
18 
19 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
20 
21 
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
25 
26 
27 
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId,
100         bytes calldata data
101     ) external;
102 
103     /**
104      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
105      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must exist and be owned by `from`.
112      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
114      *
115      * Emits a {Transfer} event.
116      */
117     function safeTransferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Transfers `tokenId` token from `from` to `to`.
125      *
126      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
127      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
128      * understand this adds an external call which potentially creates a reentrancy vulnerability.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
147      * The approval is cleared when the token is transferred.
148      *
149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
150      *
151      * Requirements:
152      *
153      * - The caller must own the token or be an approved operator.
154      * - `tokenId` must exist.
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address to, uint256 tokenId) external;
159 
160     /**
161      * @dev Approve or remove `operator` as an operator for the caller.
162      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
163      *
164      * Requirements:
165      *
166      * - The `operator` cannot be the caller.
167      *
168      * Emits an {ApprovalForAll} event.
169      */
170     function setApprovalForAll(address operator, bool _approved) external;
171 
172     /**
173      * @dev Returns the account approved for `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function getApproved(uint256 tokenId) external view returns (address operator);
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator) external view returns (bool);
187 }
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
191 
192 
193 
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201     /**
202      * @dev Returns the token collection name.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the token collection symbol.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
213      */
214     function tokenURI(uint256 tokenId) external view returns (string memory);
215 }
216 
217 
218 /**
219  * @dev Interface of an ERC721A compliant contract.
220  */
221 interface IERC721A is IERC721, IERC721Metadata {
222     /**
223      * The caller must own the token or be an approved operator.
224      */
225     error ApprovalCallerNotOwnerNorApproved();
226 
227     /**
228      * The token does not exist.
229      */
230     error ApprovalQueryForNonexistentToken();
231 
232     /**
233      * The caller cannot approve to their own address.
234      */
235     error ApproveToCaller();
236 
237     /**
238      * The caller cannot approve to the current owner.
239      */
240     error ApprovalToCurrentOwner();
241 
242     /**
243      * Cannot query the balance for the zero address.
244      */
245     error BalanceQueryForZeroAddress();
246 
247     /**
248      * Cannot mint to the zero address.
249      */
250     error MintToZeroAddress();
251 
252     /**
253      * The quantity of tokens minted must be more than zero.
254      */
255     error MintZeroQuantity();
256 
257     /**
258      * The token does not exist.
259      */
260     error OwnerQueryForNonexistentToken();
261 
262     /**
263      * The caller must own the token or be an approved operator.
264      */
265     error TransferCallerNotOwnerNorApproved();
266 
267     /**
268      * The token must be owned by `from`.
269      */
270     error TransferFromIncorrectOwner();
271 
272     /**
273      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
274      */
275     error TransferToNonERC721ReceiverImplementer();
276 
277     /**
278      * Cannot transfer to the zero address.
279      */
280     error TransferToZeroAddress();
281 
282     /**
283      * The token does not exist.
284      */
285     error URIQueryForNonexistentToken();
286 
287     // Compiler will pack this into a single 256bit word.
288     struct TokenOwnership {
289         // The address of the owner.
290         address addr;
291         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
292         uint64 startTimestamp;
293         // Whether the token has been burned.
294         bool burned;
295     }
296 
297     // Compiler will pack this into a single 256bit word.
298     struct AddressData {
299         // Realistically, 2**64-1 is more than enough.
300         uint64 balance;
301         // Keeps track of mint count with minimal overhead for tokenomics.
302         uint64 numberMinted;
303         // Keeps track of burn count with minimal overhead for tokenomics.
304         uint64 numberBurned;
305         // For miscellaneous variable(s) pertaining to the address
306         // (e.g. number of whitelist mint slots used).
307         // If there are multiple variables, please pack them into a uint64.
308         uint64 aux;
309     }
310 
311     /**
312      * @dev Returns the total amount of tokens stored by the contract.
313      * 
314      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
315      */
316     function totalSupply() external view returns (uint256);
317 }
318 
319 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
320 
321 
322 
323 /**
324  * @title ERC721 token receiver interface
325  * @dev Interface for any contract that wants to support safeTransfers
326  * from ERC721 asset contracts.
327  */
328 interface IERC721Receiver {
329     /**
330      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
331      * by `operator` from `from`, this function is called.
332      *
333      * It must return its Solidity selector to confirm the token transfer.
334      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
335      *
336      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
337      */
338     function onERC721Received(
339         address operator,
340         address from,
341         uint256 tokenId,
342         bytes calldata data
343     ) external returns (bytes4);
344 }
345 
346 
347 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
348 
349 
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      *
372      * [IMPORTANT]
373      * ====
374      * You shouldn't rely on `isContract` to protect against flash loan attacks!
375      *
376      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
377      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
378      * constructor.
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize/address.code.length, which returns 0
383         // for contracts in construction, since the code is only stored at the end
384         // of the constructor execution.
385 
386         return account.code.length > 0;
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      */
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         (bool success, ) = recipient.call{value: amount}("");
409         require(success, "Address: unable to send value, recipient may have reverted");
410     }
411 
412     /**
413      * @dev Performs a Solidity function call using a low level `call`. A
414      * plain `call` is an unsafe replacement for a function call: use this
415      * function instead.
416      *
417      * If `target` reverts with a revert reason, it is bubbled up by this
418      * function (like regular Solidity function calls).
419      *
420      * Returns the raw returned data. To convert to the expected return value,
421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
422      *
423      * Requirements:
424      *
425      * - `target` must be a contract.
426      * - calling `target` with `data` must not revert.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
436      * `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, 0, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but also transferring `value` wei to `target`.
451      *
452      * Requirements:
453      *
454      * - the calling contract must have an ETH balance of at least `value`.
455      * - the called Solidity function must be `payable`.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
469      * with `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480         (bool success, bytes memory returndata) = target.call{value: value}(data);
481         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
491         return functionStaticCall(target, data, "Address: low-level static call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
536      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
537      *
538      * _Available since v4.8._
539      */
540     function verifyCallResultFromTarget(
541         address target,
542         bool success,
543         bytes memory returndata,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         if (success) {
547             if (returndata.length == 0) {
548                 // only check isContract if the call was successful and the return data is empty
549                 // otherwise we already know that it was a contract
550                 require(isContract(target), "Address: call to non-contract");
551             }
552             return returndata;
553         } else {
554             _revert(returndata, errorMessage);
555         }
556     }
557 
558     /**
559      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
560      * revert reason or using the provided one.
561      *
562      * _Available since v4.3._
563      */
564     function verifyCallResult(
565         bool success,
566         bytes memory returndata,
567         string memory errorMessage
568     ) internal pure returns (bytes memory) {
569         if (success) {
570             return returndata;
571         } else {
572             _revert(returndata, errorMessage);
573         }
574     }
575 
576     function _revert(bytes memory returndata, string memory errorMessage) private pure {
577         // Look for revert reason and bubble it up if present
578         if (returndata.length > 0) {
579             // The easiest way to bubble the revert reason is using memory via assembly
580             /// @solidity memory-safe-assembly
581             assembly {
582                 let returndata_size := mload(returndata)
583                 revert(add(32, returndata), returndata_size)
584             }
585         } else {
586             revert(errorMessage);
587         }
588     }
589 }
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
593 
594 
595 
596 /**
597  * @dev Provides information about the current execution context, including the
598  * sender of the transaction and its data. While these are generally available
599  * via msg.sender and msg.data, they should not be accessed in such a direct
600  * manner, since when dealing with meta-transactions the account sending and
601  * paying for execution may not be the actual sender (as far as an application
602  * is concerned).
603  *
604  * This contract is only required for intermediate, library-like contracts.
605  */
606 abstract contract Context {
607     function _msgSender() internal view virtual returns (address) {
608         return msg.sender;
609     }
610 
611     function _msgData() internal view virtual returns (bytes calldata) {
612         return msg.data;
613     }
614 }
615 
616 
617 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
618 
619 
620 
621 
622 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
623 
624 
625 
626 /**
627  * @dev Standard math utilities missing in the Solidity language.
628  */
629 library Math {
630     enum Rounding {
631         Down, // Toward negative infinity
632         Up, // Toward infinity
633         Zero // Toward zero
634     }
635 
636     /**
637      * @dev Returns the largest of two numbers.
638      */
639     function max(uint256 a, uint256 b) internal pure returns (uint256) {
640         return a > b ? a : b;
641     }
642 
643     /**
644      * @dev Returns the smallest of two numbers.
645      */
646     function min(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a < b ? a : b;
648     }
649 
650     /**
651      * @dev Returns the average of two numbers. The result is rounded towards
652      * zero.
653      */
654     function average(uint256 a, uint256 b) internal pure returns (uint256) {
655         // (a + b) / 2 can overflow.
656         return (a & b) + (a ^ b) / 2;
657     }
658 
659     /**
660      * @dev Returns the ceiling of the division of two numbers.
661      *
662      * This differs from standard division with `/` in that it rounds up instead
663      * of rounding down.
664      */
665     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
666         // (a + b - 1) / b can overflow on addition, so we distribute.
667         return a == 0 ? 0 : (a - 1) / b + 1;
668     }
669 
670     /**
671      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
672      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
673      * with further edits by Uniswap Labs also under MIT license.
674      */
675     function mulDiv(
676         uint256 x,
677         uint256 y,
678         uint256 denominator
679     ) internal pure returns (uint256 result) {
680         unchecked {
681             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
682             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
683             // variables such that product = prod1 * 2^256 + prod0.
684             uint256 prod0; // Least significant 256 bits of the product
685             uint256 prod1; // Most significant 256 bits of the product
686             assembly {
687                 let mm := mulmod(x, y, not(0))
688                 prod0 := mul(x, y)
689                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
690             }
691 
692             // Handle non-overflow cases, 256 by 256 division.
693             if (prod1 == 0) {
694                 return prod0 / denominator;
695             }
696 
697             // Make sure the result is less than 2^256. Also prevents denominator == 0.
698             require(denominator > prod1);
699 
700             ///////////////////////////////////////////////
701             // 512 by 256 division.
702             ///////////////////////////////////////////////
703 
704             // Make division exact by subtracting the remainder from [prod1 prod0].
705             uint256 remainder;
706             assembly {
707                 // Compute remainder using mulmod.
708                 remainder := mulmod(x, y, denominator)
709 
710                 // Subtract 256 bit number from 512 bit number.
711                 prod1 := sub(prod1, gt(remainder, prod0))
712                 prod0 := sub(prod0, remainder)
713             }
714 
715             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
716             // See https://cs.stackexchange.com/q/138556/92363.
717 
718             // Does not overflow because the denominator cannot be zero at this stage in the function.
719             uint256 twos = denominator & (~denominator + 1);
720             assembly {
721                 // Divide denominator by twos.
722                 denominator := div(denominator, twos)
723 
724                 // Divide [prod1 prod0] by twos.
725                 prod0 := div(prod0, twos)
726 
727                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
728                 twos := add(div(sub(0, twos), twos), 1)
729             }
730 
731             // Shift in bits from prod1 into prod0.
732             prod0 |= prod1 * twos;
733 
734             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
735             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
736             // four bits. That is, denominator * inv = 1 mod 2^4.
737             uint256 inverse = (3 * denominator) ^ 2;
738 
739             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
740             // in modular arithmetic, doubling the correct bits in each step.
741             inverse *= 2 - denominator * inverse; // inverse mod 2^8
742             inverse *= 2 - denominator * inverse; // inverse mod 2^16
743             inverse *= 2 - denominator * inverse; // inverse mod 2^32
744             inverse *= 2 - denominator * inverse; // inverse mod 2^64
745             inverse *= 2 - denominator * inverse; // inverse mod 2^128
746             inverse *= 2 - denominator * inverse; // inverse mod 2^256
747 
748             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
749             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
750             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
751             // is no longer required.
752             result = prod0 * inverse;
753             return result;
754         }
755     }
756 
757     /**
758      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
759      */
760     function mulDiv(
761         uint256 x,
762         uint256 y,
763         uint256 denominator,
764         Rounding rounding
765     ) internal pure returns (uint256) {
766         uint256 result = mulDiv(x, y, denominator);
767         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
768             result += 1;
769         }
770         return result;
771     }
772 
773     /**
774      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
775      *
776      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
777      */
778     function sqrt(uint256 a) internal pure returns (uint256) {
779         if (a == 0) {
780             return 0;
781         }
782 
783         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
784         //
785         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
786         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
787         //
788         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
789         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
790         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
791         //
792         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
793         uint256 result = 1 << (log2(a) >> 1);
794 
795         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
796         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
797         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
798         // into the expected uint128 result.
799         unchecked {
800             result = (result + a / result) >> 1;
801             result = (result + a / result) >> 1;
802             result = (result + a / result) >> 1;
803             result = (result + a / result) >> 1;
804             result = (result + a / result) >> 1;
805             result = (result + a / result) >> 1;
806             result = (result + a / result) >> 1;
807             return min(result, a / result);
808         }
809     }
810 
811     /**
812      * @notice Calculates sqrt(a), following the selected rounding direction.
813      */
814     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
815         unchecked {
816             uint256 result = sqrt(a);
817             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
818         }
819     }
820 
821     /**
822      * @dev Return the log in base 2, rounded down, of a positive value.
823      * Returns 0 if given 0.
824      */
825     function log2(uint256 value) internal pure returns (uint256) {
826         uint256 result = 0;
827         unchecked {
828             if (value >> 128 > 0) {
829                 value >>= 128;
830                 result += 128;
831             }
832             if (value >> 64 > 0) {
833                 value >>= 64;
834                 result += 64;
835             }
836             if (value >> 32 > 0) {
837                 value >>= 32;
838                 result += 32;
839             }
840             if (value >> 16 > 0) {
841                 value >>= 16;
842                 result += 16;
843             }
844             if (value >> 8 > 0) {
845                 value >>= 8;
846                 result += 8;
847             }
848             if (value >> 4 > 0) {
849                 value >>= 4;
850                 result += 4;
851             }
852             if (value >> 2 > 0) {
853                 value >>= 2;
854                 result += 2;
855             }
856             if (value >> 1 > 0) {
857                 result += 1;
858             }
859         }
860         return result;
861     }
862 
863     /**
864      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
865      * Returns 0 if given 0.
866      */
867     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
868         unchecked {
869             uint256 result = log2(value);
870             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
871         }
872     }
873 
874     /**
875      * @dev Return the log in base 10, rounded down, of a positive value.
876      * Returns 0 if given 0.
877      */
878     function log10(uint256 value) internal pure returns (uint256) {
879         uint256 result = 0;
880         unchecked {
881             if (value >= 10**64) {
882                 value /= 10**64;
883                 result += 64;
884             }
885             if (value >= 10**32) {
886                 value /= 10**32;
887                 result += 32;
888             }
889             if (value >= 10**16) {
890                 value /= 10**16;
891                 result += 16;
892             }
893             if (value >= 10**8) {
894                 value /= 10**8;
895                 result += 8;
896             }
897             if (value >= 10**4) {
898                 value /= 10**4;
899                 result += 4;
900             }
901             if (value >= 10**2) {
902                 value /= 10**2;
903                 result += 2;
904             }
905             if (value >= 10**1) {
906                 result += 1;
907             }
908         }
909         return result;
910     }
911 
912     /**
913      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
914      * Returns 0 if given 0.
915      */
916     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
917         unchecked {
918             uint256 result = log10(value);
919             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
920         }
921     }
922 
923     /**
924      * @dev Return the log in base 256, rounded down, of a positive value.
925      * Returns 0 if given 0.
926      *
927      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
928      */
929     function log256(uint256 value) internal pure returns (uint256) {
930         uint256 result = 0;
931         unchecked {
932             if (value >> 128 > 0) {
933                 value >>= 128;
934                 result += 16;
935             }
936             if (value >> 64 > 0) {
937                 value >>= 64;
938                 result += 8;
939             }
940             if (value >> 32 > 0) {
941                 value >>= 32;
942                 result += 4;
943             }
944             if (value >> 16 > 0) {
945                 value >>= 16;
946                 result += 2;
947             }
948             if (value >> 8 > 0) {
949                 result += 1;
950             }
951         }
952         return result;
953     }
954 
955     /**
956      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
957      * Returns 0 if given 0.
958      */
959     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
960         unchecked {
961             uint256 result = log256(value);
962             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
963         }
964     }
965 }
966 
967 
968 /**
969  * @dev String operations.
970  */
971 library Strings {
972     bytes16 private constant _SYMBOLS = "0123456789abcdef";
973     uint8 private constant _ADDRESS_LENGTH = 20;
974 
975     /**
976      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
977      */
978     function toString(uint256 value) internal pure returns (string memory) {
979         unchecked {
980             uint256 length = Math.log10(value) + 1;
981             string memory buffer = new string(length);
982             uint256 ptr;
983             /// @solidity memory-safe-assembly
984             assembly {
985                 ptr := add(buffer, add(32, length))
986             }
987             while (true) {
988                 ptr--;
989                 /// @solidity memory-safe-assembly
990                 assembly {
991                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
992                 }
993                 value /= 10;
994                 if (value == 0) break;
995             }
996             return buffer;
997         }
998     }
999 
1000     /**
1001      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1002      */
1003     function toHexString(uint256 value) internal pure returns (string memory) {
1004         unchecked {
1005             return toHexString(value, Math.log256(value) + 1);
1006         }
1007     }
1008 
1009     /**
1010      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1011      */
1012     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1013         bytes memory buffer = new bytes(2 * length + 2);
1014         buffer[0] = "0";
1015         buffer[1] = "x";
1016         for (uint256 i = 2 * length + 1; i > 1; --i) {
1017             buffer[i] = _SYMBOLS[value & 0xf];
1018             value >>= 4;
1019         }
1020         require(value == 0, "Strings: hex length insufficient");
1021         return string(buffer);
1022     }
1023 
1024     /**
1025      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1026      */
1027     function toHexString(address addr) internal pure returns (string memory) {
1028         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1029     }
1030 }
1031 
1032 
1033 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1034 
1035 
1036 
1037 
1038 
1039 /**
1040  * @dev Implementation of the {IERC165} interface.
1041  *
1042  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1043  * for the additional interface id that will be supported. For example:
1044  *
1045  * ```solidity
1046  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1047  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1048  * }
1049  * ```
1050  *
1051  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1052  */
1053 abstract contract ERC165 is IERC165 {
1054     /**
1055      * @dev See {IERC165-supportsInterface}.
1056      */
1057     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1058         return interfaceId == type(IERC165).interfaceId;
1059     }
1060 }
1061 
1062 
1063 /**
1064  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1065  * the Metadata extension. Built to optimize for lower gas during batch mints.
1066  *
1067  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1068  *
1069  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1070  *
1071  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1072  */
1073 contract ERC721A is Context, ERC165, IERC721A {
1074     using Address for address;
1075     using Strings for uint256;
1076 
1077     // The tokenId of the next token to be minted.
1078     uint256 internal _currentIndex;
1079 
1080     // The number of tokens burned.
1081     uint256 internal _burnCounter;
1082 
1083     // Token name
1084     string private _name;
1085 
1086     // Token symbol
1087     string private _symbol;
1088 
1089     // Mapping from token ID to ownership details
1090     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1091     mapping(uint256 => TokenOwnership) internal _ownerships;
1092 
1093     // Mapping owner address to address data
1094     mapping(address => AddressData) private _addressData;
1095 
1096     // Mapping from token ID to approved address
1097     mapping(uint256 => address) private _tokenApprovals;
1098 
1099     // Mapping from owner to operator approvals
1100     mapping(address => mapping(address => bool)) private _operatorApprovals;
1101 
1102     constructor(string memory name_, string memory symbol_) {
1103         _name = name_;
1104         _symbol = symbol_;
1105         _currentIndex = _startTokenId();
1106     }
1107 
1108     /**
1109      * To change the starting tokenId, please override this function.
1110      */
1111     function _startTokenId() internal view virtual returns (uint256) {
1112         return 0;
1113     }
1114 
1115     /**
1116      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1117      */
1118     function totalSupply() public view override returns (uint256) {
1119         // Counter underflow is impossible as _burnCounter cannot be incremented
1120         // more than _currentIndex - _startTokenId() times
1121         unchecked {
1122             return _currentIndex - _burnCounter - _startTokenId();
1123         }
1124     }
1125 
1126     /**
1127      * Returns the total amount of tokens minted in the contract.
1128      */
1129     function _totalMinted() internal view returns (uint256) {
1130         // Counter underflow is impossible as _currentIndex does not decrement,
1131         // and it is initialized to _startTokenId()
1132         unchecked {
1133             return _currentIndex - _startTokenId();
1134         }
1135     }
1136 
1137     /**
1138      * @dev See {IERC165-supportsInterface}.
1139      */
1140     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1141         return
1142             interfaceId == type(IERC721).interfaceId ||
1143             interfaceId == type(IERC721Metadata).interfaceId ||
1144             super.supportsInterface(interfaceId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-balanceOf}.
1149      */
1150     function balanceOf(address owner) public view override returns (uint256) {
1151         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1152         return uint256(_addressData[owner].balance);
1153     }
1154 
1155     /**
1156      * Returns the number of tokens minted by `owner`.
1157      */
1158     function _numberMinted(address owner) internal view returns (uint256) {
1159         return uint256(_addressData[owner].numberMinted);
1160     }
1161 
1162     /**
1163      * Returns the number of tokens burned by or on behalf of `owner`.
1164      */
1165     function _numberBurned(address owner) internal view returns (uint256) {
1166         return uint256(_addressData[owner].numberBurned);
1167     }
1168 
1169     /**
1170      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1171      */
1172     function _getAux(address owner) internal view returns (uint64) {
1173         return _addressData[owner].aux;
1174     }
1175 
1176     /**
1177      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1178      * If there are multiple variables, please pack them into a uint64.
1179      */
1180     function _setAux(address owner, uint64 aux) internal {
1181         _addressData[owner].aux = aux;
1182     }
1183 
1184     /**
1185      * Gas spent here starts off proportional to the maximum mint batch size.
1186      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1187      */
1188     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1189         uint256 curr = tokenId;
1190 
1191         unchecked {
1192             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1193                 TokenOwnership memory ownership = _ownerships[curr];
1194                 if (!ownership.burned) {
1195                     if (ownership.addr != address(0)) {
1196                         return ownership;
1197                     }
1198                     // Invariant:
1199                     // There will always be an ownership that has an address and is not burned
1200                     // before an ownership that does not have an address and is not burned.
1201                     // Hence, curr will not underflow.
1202                     while (true) {
1203                         curr--;
1204                         ownership = _ownerships[curr];
1205                         if (ownership.addr != address(0)) {
1206                             return ownership;
1207                         }
1208                     }
1209                 }
1210             }
1211         }
1212         revert OwnerQueryForNonexistentToken();
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-ownerOf}.
1217      */
1218     function ownerOf(uint256 tokenId) public view override returns (address) {
1219         return _ownershipOf(tokenId).addr;
1220     }
1221 
1222     /**
1223      * @dev See {IERC721Metadata-name}.
1224      */
1225     function name() public view virtual override returns (string memory) {
1226         return _name;
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Metadata-symbol}.
1231      */
1232     function symbol() public view virtual override returns (string memory) {
1233         return _symbol;
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Metadata-tokenURI}.
1238      */
1239     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1240         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1241 
1242         string memory baseURI = _baseURI();
1243         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1244     }
1245 
1246     /**
1247      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1248      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1249      * by default, can be overriden in child contracts.
1250      */
1251     function _baseURI() internal view virtual returns (string memory) {
1252         return '';
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-approve}.
1257      */
1258     function approve(address to, uint256 tokenId) public override {
1259         address owner = ERC721A.ownerOf(tokenId);
1260         if (to == owner) revert ApprovalToCurrentOwner();
1261 
1262         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1263             revert ApprovalCallerNotOwnerNorApproved();
1264         }
1265 
1266         _approve(to, tokenId, owner);
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-getApproved}.
1271      */
1272     function getApproved(uint256 tokenId) public view override returns (address) {
1273         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1274 
1275         return _tokenApprovals[tokenId];
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-setApprovalForAll}.
1280      */
1281     function setApprovalForAll(address operator, bool approved) public virtual override {
1282         if (operator == _msgSender()) revert ApproveToCaller();
1283 
1284         _operatorApprovals[_msgSender()][operator] = approved;
1285         emit ApprovalForAll(_msgSender(), operator, approved);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-isApprovedForAll}.
1290      */
1291     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1292         return _operatorApprovals[owner][operator];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-transferFrom}.
1297      */
1298     function transferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) public virtual override {
1303         _transfer(from, to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-safeTransferFrom}.
1308      */
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) public virtual override {
1314         safeTransferFrom(from, to, tokenId, '');
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-safeTransferFrom}.
1319      */
1320     function safeTransferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory _data
1325     ) public virtual override {
1326         _transfer(from, to, tokenId);
1327         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1328             revert TransferToNonERC721ReceiverImplementer();
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns whether `tokenId` exists.
1334      *
1335      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1336      *
1337      * Tokens start existing when they are minted (`_mint`),
1338      */
1339     function _exists(uint256 tokenId) internal view returns (bool) {
1340         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1341     }
1342 
1343     /**
1344      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1345      */
1346     function _safeMint(address to, uint256 quantity) internal {
1347         _safeMint(to, quantity, '');
1348     }
1349 
1350     /**
1351      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - If `to` refers to a smart contract, it must implement
1356      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1357      * - `quantity` must be greater than 0.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _safeMint(
1362         address to,
1363         uint256 quantity,
1364         bytes memory _data
1365     ) internal {
1366         uint256 startTokenId = _currentIndex;
1367         if (to == address(0)) revert MintToZeroAddress();
1368         if (quantity == 0) revert MintZeroQuantity();
1369 
1370         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1371 
1372         // Overflows are incredibly unrealistic.
1373         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1374         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1375         unchecked {
1376             _addressData[to].balance += uint64(quantity);
1377             _addressData[to].numberMinted += uint64(quantity);
1378 
1379             _ownerships[startTokenId].addr = to;
1380             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1381 
1382             uint256 updatedIndex = startTokenId;
1383             uint256 end = updatedIndex + quantity;
1384 
1385             if (to.isContract()) {
1386                 do {
1387                     emit Transfer(address(0), to, updatedIndex);
1388                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1389                         revert TransferToNonERC721ReceiverImplementer();
1390                     }
1391                 } while (updatedIndex < end);
1392                 // Reentrancy protection
1393                 if (_currentIndex != startTokenId) revert();
1394             } else {
1395                 do {
1396                     emit Transfer(address(0), to, updatedIndex++);
1397                 } while (updatedIndex < end);
1398             }
1399             _currentIndex = updatedIndex;
1400         }
1401         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1402     }
1403 
1404     /**
1405      * @dev Mints `quantity` tokens and transfers them to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - `to` cannot be the zero address.
1410      * - `quantity` must be greater than 0.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _mint(address to, uint256 quantity) internal {
1415         uint256 startTokenId = _currentIndex;
1416         if (to == address(0)) revert MintToZeroAddress();
1417         if (quantity == 0) revert MintZeroQuantity();
1418 
1419         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1420 
1421         // Overflows are incredibly unrealistic.
1422         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1423         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1424         unchecked {
1425             _addressData[to].balance += uint64(quantity);
1426             _addressData[to].numberMinted += uint64(quantity);
1427 
1428             _ownerships[startTokenId].addr = to;
1429             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1430 
1431             uint256 updatedIndex = startTokenId;
1432             uint256 end = updatedIndex + quantity;
1433 
1434             do {
1435                 emit Transfer(address(0), to, updatedIndex++);
1436             } while (updatedIndex < end);
1437 
1438             _currentIndex = updatedIndex;
1439         }
1440         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1441     }
1442 
1443     /**
1444      * @dev Transfers `tokenId` from `from` to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `to` cannot be the zero address.
1449      * - `tokenId` token must be owned by `from`.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function _transfer(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) private {
1458         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1459 
1460         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1461 
1462         bool isApprovedOrOwner = (_msgSender() == from ||
1463             isApprovedForAll(from, _msgSender()) ||
1464             getApproved(tokenId) == _msgSender());
1465 
1466         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1467         if (to == address(0)) revert TransferToZeroAddress();
1468 
1469         _beforeTokenTransfers(from, to, tokenId, 1);
1470 
1471         // Clear approvals from the previous owner
1472         _approve(address(0), tokenId, from);
1473 
1474         // Underflow of the sender's balance is impossible because we check for
1475         // ownership above and the recipient's balance can't realistically overflow.
1476         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1477         unchecked {
1478             _addressData[from].balance -= 1;
1479             _addressData[to].balance += 1;
1480 
1481             TokenOwnership storage currSlot = _ownerships[tokenId];
1482             currSlot.addr = to;
1483             currSlot.startTimestamp = uint64(block.timestamp);
1484 
1485             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1486             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1487             uint256 nextTokenId = tokenId + 1;
1488             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1489             if (nextSlot.addr == address(0)) {
1490                 // This will suffice for checking _exists(nextTokenId),
1491                 // as a burned slot cannot contain the zero address.
1492                 if (nextTokenId != _currentIndex) {
1493                     nextSlot.addr = from;
1494                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1495                 }
1496             }
1497         }
1498 
1499         emit Transfer(from, to, tokenId);
1500         _afterTokenTransfers(from, to, tokenId, 1);
1501     }
1502 
1503     /**
1504      * @dev Equivalent to `_burn(tokenId, false)`.
1505      */
1506     function _burn(uint256 tokenId) internal virtual {
1507         _burn(tokenId, false);
1508     }
1509 
1510     /**
1511      * @dev Destroys `tokenId`.
1512      * The approval is cleared when the token is burned.
1513      *
1514      * Requirements:
1515      *
1516      * - `tokenId` must exist.
1517      *
1518      * Emits a {Transfer} event.
1519      */
1520     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1521         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1522 
1523         address from = prevOwnership.addr;
1524 
1525         if (approvalCheck) {
1526             bool isApprovedOrOwner = (_msgSender() == from ||
1527                 isApprovedForAll(from, _msgSender()) ||
1528                 getApproved(tokenId) == _msgSender());
1529 
1530             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1531         }
1532 
1533         _beforeTokenTransfers(from, address(0), tokenId, 1);
1534 
1535         // Clear approvals from the previous owner
1536         _approve(address(0), tokenId, from);
1537 
1538         // Underflow of the sender's balance is impossible because we check for
1539         // ownership above and the recipient's balance can't realistically overflow.
1540         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1541         unchecked {
1542             AddressData storage addressData = _addressData[from];
1543             addressData.balance -= 1;
1544             addressData.numberBurned += 1;
1545 
1546             // Keep track of who burned the token, and the timestamp of burning.
1547             TokenOwnership storage currSlot = _ownerships[tokenId];
1548             currSlot.addr = from;
1549             currSlot.startTimestamp = uint64(block.timestamp);
1550             currSlot.burned = true;
1551 
1552             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1553             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1554             uint256 nextTokenId = tokenId + 1;
1555             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1556             if (nextSlot.addr == address(0)) {
1557                 // This will suffice for checking _exists(nextTokenId),
1558                 // as a burned slot cannot contain the zero address.
1559                 if (nextTokenId != _currentIndex) {
1560                     nextSlot.addr = from;
1561                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1562                 }
1563             }
1564         }
1565 
1566         emit Transfer(from, address(0), tokenId);
1567         _afterTokenTransfers(from, address(0), tokenId, 1);
1568 
1569         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1570         unchecked {
1571             _burnCounter++;
1572         }
1573     }
1574 
1575     /**
1576      * @dev Approve `to` to operate on `tokenId`
1577      *
1578      * Emits a {Approval} event.
1579      */
1580     function _approve(
1581         address to,
1582         uint256 tokenId,
1583         address owner
1584     ) private {
1585         _tokenApprovals[tokenId] = to;
1586         emit Approval(owner, to, tokenId);
1587     }
1588 
1589     /**
1590      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1591      *
1592      * @param from address representing the previous owner of the given token ID
1593      * @param to target address that will receive the tokens
1594      * @param tokenId uint256 ID of the token to be transferred
1595      * @param _data bytes optional data to send along with the call
1596      * @return bool whether the call correctly returned the expected magic value
1597      */
1598     function _checkContractOnERC721Received(
1599         address from,
1600         address to,
1601         uint256 tokenId,
1602         bytes memory _data
1603     ) private returns (bool) {
1604         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1605             return retval == IERC721Receiver(to).onERC721Received.selector;
1606         } catch (bytes memory reason) {
1607             if (reason.length == 0) {
1608                 revert TransferToNonERC721ReceiverImplementer();
1609             } else {
1610                 assembly {
1611                     revert(add(32, reason), mload(reason))
1612                 }
1613             }
1614         }
1615     }
1616 
1617     /**
1618      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1619      * And also called before burning one token.
1620      *
1621      * startTokenId - the first token id to be transferred
1622      * quantity - the amount to be transferred
1623      *
1624      * Calling conditions:
1625      *
1626      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1627      * transferred to `to`.
1628      * - When `from` is zero, `tokenId` will be minted for `to`.
1629      * - When `to` is zero, `tokenId` will be burned by `from`.
1630      * - `from` and `to` are never both zero.
1631      */
1632     function _beforeTokenTransfers(
1633         address from,
1634         address to,
1635         uint256 startTokenId,
1636         uint256 quantity
1637     ) internal virtual {}
1638 
1639     /**
1640      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1641      * minting.
1642      * And also called after one token has been burned.
1643      *
1644      * startTokenId - the first token id to be transferred
1645      * quantity - the amount to be transferred
1646      *
1647      * Calling conditions:
1648      *
1649      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1650      * transferred to `to`.
1651      * - When `from` is zero, `tokenId` has been minted for `to`.
1652      * - When `to` is zero, `tokenId` has been burned by `from`.
1653      * - `from` and `to` are never both zero.
1654      */
1655     function _afterTokenTransfers(
1656         address from,
1657         address to,
1658         uint256 startTokenId,
1659         uint256 quantity
1660     ) internal virtual {}
1661 }
1662 
1663 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1664 
1665 
1666 
1667 
1668 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1669 
1670 
1671 
1672 
1673 
1674 /**
1675  * @dev Interface for the NFT Royalty Standard.
1676  *
1677  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1678  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1679  *
1680  * _Available since v4.5._
1681  */
1682 interface IERC2981 is IERC165 {
1683     /**
1684      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1685      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1686      */
1687     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1688         external
1689         view
1690         returns (address receiver, uint256 royaltyAmount);
1691 }
1692 
1693 
1694 
1695 /**
1696  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1697  *
1698  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1699  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1700  *
1701  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1702  * fee is specified in basis points by default.
1703  *
1704  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1705  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1706  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1707  *
1708  * _Available since v4.5._
1709  */
1710 abstract contract ERC2981 is IERC2981, ERC165 {
1711     struct RoyaltyInfo {
1712         address receiver;
1713         uint96 royaltyFraction;
1714     }
1715 
1716     RoyaltyInfo private _defaultRoyaltyInfo;
1717     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1718 
1719     /**
1720      * @dev See {IERC165-supportsInterface}.
1721      */
1722     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1723         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1724     }
1725 
1726     /**
1727      * @inheritdoc IERC2981
1728      */
1729     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1730         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1731 
1732         if (royalty.receiver == address(0)) {
1733             royalty = _defaultRoyaltyInfo;
1734         }
1735 
1736         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1737 
1738         return (royalty.receiver, royaltyAmount);
1739     }
1740 
1741     /**
1742      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1743      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1744      * override.
1745      */
1746     function _feeDenominator() internal pure virtual returns (uint96) {
1747         return 10000;
1748     }
1749 
1750     /**
1751      * @dev Sets the royalty information that all ids in this contract will default to.
1752      *
1753      * Requirements:
1754      *
1755      * - `receiver` cannot be the zero address.
1756      * - `feeNumerator` cannot be greater than the fee denominator.
1757      */
1758     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1759         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1760         require(receiver != address(0), "ERC2981: invalid receiver");
1761 
1762         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1763     }
1764 
1765     /**
1766      * @dev Removes default royalty information.
1767      */
1768     function _deleteDefaultRoyalty() internal virtual {
1769         delete _defaultRoyaltyInfo;
1770     }
1771 
1772     /**
1773      * @dev Sets the royalty information for a specific token id, overriding the global default.
1774      *
1775      * Requirements:
1776      *
1777      * - `receiver` cannot be the zero address.
1778      * - `feeNumerator` cannot be greater than the fee denominator.
1779      */
1780     function _setTokenRoyalty(
1781         uint256 tokenId,
1782         address receiver,
1783         uint96 feeNumerator
1784     ) internal virtual {
1785         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1786         require(receiver != address(0), "ERC2981: Invalid parameters");
1787 
1788         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1789     }
1790 
1791     /**
1792      * @dev Resets royalty information for the token id back to the global default.
1793      */
1794     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1795         delete _tokenRoyaltyInfo[tokenId];
1796     }
1797 }
1798 
1799 
1800 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1801 
1802 
1803 
1804 
1805 
1806 /**
1807  * @dev Contract module which provides a basic access control mechanism, where
1808  * there is an account (an owner) that can be granted exclusive access to
1809  * specific functions.
1810  *
1811  * By default, the owner account will be the one that deploys the contract. This
1812  * can later be changed with {transferOwnership}.
1813  *
1814  * This module is used through inheritance. It will make available the modifier
1815  * `onlyOwner`, which can be applied to your functions to restrict their use to
1816  * the owner.
1817  */
1818 abstract contract Ownable is Context {
1819     address private _owner;
1820 
1821     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1822 
1823     /**
1824      * @dev Initializes the contract setting the deployer as the initial owner.
1825      */
1826     constructor() {
1827         _transferOwnership(_msgSender());
1828     }
1829 
1830     /**
1831      * @dev Throws if called by any account other than the owner.
1832      */
1833     modifier onlyOwner() {
1834         _checkOwner();
1835         _;
1836     }
1837 
1838     /**
1839      * @dev Returns the address of the current owner.
1840      */
1841     function owner() public view virtual returns (address) {
1842         return _owner;
1843     }
1844 
1845     /**
1846      * @dev Throws if the sender is not the owner.
1847      */
1848     function _checkOwner() internal view virtual {
1849         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1850     }
1851 
1852     /**
1853      * @dev Leaves the contract without owner. It will not be possible to call
1854      * `onlyOwner` functions anymore. Can only be called by the current owner.
1855      *
1856      * NOTE: Renouncing ownership will leave the contract without an owner,
1857      * thereby removing any functionality that is only available to the owner.
1858      */
1859     function renounceOwnership() public virtual onlyOwner {
1860         _transferOwnership(address(0));
1861     }
1862 
1863     /**
1864      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1865      * Can only be called by the current owner.
1866      */
1867     function transferOwnership(address newOwner) public virtual onlyOwner {
1868         require(newOwner != address(0), "Ownable: new owner is the zero address");
1869         _transferOwnership(newOwner);
1870     }
1871 
1872     /**
1873      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1874      * Internal function without access restriction.
1875      */
1876     function _transferOwnership(address newOwner) internal virtual {
1877         address oldOwner = _owner;
1878         _owner = newOwner;
1879         emit OwnershipTransferred(oldOwner, newOwner);
1880     }
1881 }
1882 
1883 
1884 
1885 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
1886 
1887 
1888 
1889 
1890 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1891 
1892 
1893 
1894 
1895 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1896 
1897 
1898 
1899 /**
1900  * @dev Interface of the ERC20 standard as defined in the EIP.
1901  */
1902 interface IERC20 {
1903     /**
1904      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1905      * another (`to`).
1906      *
1907      * Note that `value` may be zero.
1908      */
1909     event Transfer(address indexed from, address indexed to, uint256 value);
1910 
1911     /**
1912      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1913      * a call to {approve}. `value` is the new allowance.
1914      */
1915     event Approval(address indexed owner, address indexed spender, uint256 value);
1916 
1917     /**
1918      * @dev Returns the amount of tokens in existence.
1919      */
1920     function totalSupply() external view returns (uint256);
1921 
1922     /**
1923      * @dev Returns the amount of tokens owned by `account`.
1924      */
1925     function balanceOf(address account) external view returns (uint256);
1926 
1927     /**
1928      * @dev Moves `amount` tokens from the caller's account to `to`.
1929      *
1930      * Returns a boolean value indicating whether the operation succeeded.
1931      *
1932      * Emits a {Transfer} event.
1933      */
1934     function transfer(address to, uint256 amount) external returns (bool);
1935 
1936     /**
1937      * @dev Returns the remaining number of tokens that `spender` will be
1938      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1939      * zero by default.
1940      *
1941      * This value changes when {approve} or {transferFrom} are called.
1942      */
1943     function allowance(address owner, address spender) external view returns (uint256);
1944 
1945     /**
1946      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1947      *
1948      * Returns a boolean value indicating whether the operation succeeded.
1949      *
1950      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1951      * that someone may use both the old and the new allowance by unfortunate
1952      * transaction ordering. One possible solution to mitigate this race
1953      * condition is to first reduce the spender's allowance to 0 and set the
1954      * desired value afterwards:
1955      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1956      *
1957      * Emits an {Approval} event.
1958      */
1959     function approve(address spender, uint256 amount) external returns (bool);
1960 
1961     /**
1962      * @dev Moves `amount` tokens from `from` to `to` using the
1963      * allowance mechanism. `amount` is then deducted from the caller's
1964      * allowance.
1965      *
1966      * Returns a boolean value indicating whether the operation succeeded.
1967      *
1968      * Emits a {Transfer} event.
1969      */
1970     function transferFrom(
1971         address from,
1972         address to,
1973         uint256 amount
1974     ) external returns (bool);
1975 }
1976 
1977 
1978 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1979 
1980 
1981 
1982 /**
1983  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1984  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1985  *
1986  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1987  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1988  * need to send a transaction, and thus is not required to hold Ether at all.
1989  */
1990 interface IERC20Permit {
1991     /**
1992      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1993      * given ``owner``'s signed approval.
1994      *
1995      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1996      * ordering also apply here.
1997      *
1998      * Emits an {Approval} event.
1999      *
2000      * Requirements:
2001      *
2002      * - `spender` cannot be the zero address.
2003      * - `deadline` must be a timestamp in the future.
2004      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2005      * over the EIP712-formatted function arguments.
2006      * - the signature must use ``owner``'s current nonce (see {nonces}).
2007      *
2008      * For more information on the signature format, see the
2009      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2010      * section].
2011      */
2012     function permit(
2013         address owner,
2014         address spender,
2015         uint256 value,
2016         uint256 deadline,
2017         uint8 v,
2018         bytes32 r,
2019         bytes32 s
2020     ) external;
2021 
2022     /**
2023      * @dev Returns the current nonce for `owner`. This value must be
2024      * included whenever a signature is generated for {permit}.
2025      *
2026      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2027      * prevents a signature from being used multiple times.
2028      */
2029     function nonces(address owner) external view returns (uint256);
2030 
2031     /**
2032      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2033      */
2034     // solhint-disable-next-line func-name-mixedcase
2035     function DOMAIN_SEPARATOR() external view returns (bytes32);
2036 }
2037 
2038 
2039 
2040 /**
2041  * @title SafeERC20
2042  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2043  * contract returns false). Tokens that return no value (and instead revert or
2044  * throw on failure) are also supported, non-reverting calls are assumed to be
2045  * successful.
2046  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2047  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2048  */
2049 library SafeERC20 {
2050     using Address for address;
2051 
2052     function safeTransfer(
2053         IERC20 token,
2054         address to,
2055         uint256 value
2056     ) internal {
2057         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2058     }
2059 
2060     function safeTransferFrom(
2061         IERC20 token,
2062         address from,
2063         address to,
2064         uint256 value
2065     ) internal {
2066         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2067     }
2068 
2069     /**
2070      * @dev Deprecated. This function has issues similar to the ones found in
2071      * {IERC20-approve}, and its usage is discouraged.
2072      *
2073      * Whenever possible, use {safeIncreaseAllowance} and
2074      * {safeDecreaseAllowance} instead.
2075      */
2076     function safeApprove(
2077         IERC20 token,
2078         address spender,
2079         uint256 value
2080     ) internal {
2081         // safeApprove should only be called when setting an initial allowance,
2082         // or when resetting it to zero. To increase and decrease it, use
2083         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2084         require(
2085             (value == 0) || (token.allowance(address(this), spender) == 0),
2086             "SafeERC20: approve from non-zero to non-zero allowance"
2087         );
2088         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2089     }
2090 
2091     function safeIncreaseAllowance(
2092         IERC20 token,
2093         address spender,
2094         uint256 value
2095     ) internal {
2096         uint256 newAllowance = token.allowance(address(this), spender) + value;
2097         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2098     }
2099 
2100     function safeDecreaseAllowance(
2101         IERC20 token,
2102         address spender,
2103         uint256 value
2104     ) internal {
2105         unchecked {
2106             uint256 oldAllowance = token.allowance(address(this), spender);
2107             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2108             uint256 newAllowance = oldAllowance - value;
2109             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2110         }
2111     }
2112 
2113     function safePermit(
2114         IERC20Permit token,
2115         address owner,
2116         address spender,
2117         uint256 value,
2118         uint256 deadline,
2119         uint8 v,
2120         bytes32 r,
2121         bytes32 s
2122     ) internal {
2123         uint256 nonceBefore = token.nonces(owner);
2124         token.permit(owner, spender, value, deadline, v, r, s);
2125         uint256 nonceAfter = token.nonces(owner);
2126         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2127     }
2128 
2129     /**
2130      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2131      * on the return value: the return value is optional (but if data is returned, it must not be false).
2132      * @param token The token targeted by the call.
2133      * @param data The call data (encoded using abi.encode or one of its variants).
2134      */
2135     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2136         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2137         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2138         // the target address contains contract code and also asserts for success in the low-level call.
2139 
2140         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2141         if (returndata.length > 0) {
2142             // Return data is optional
2143             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2144         }
2145     }
2146 }
2147 
2148 
2149 
2150 
2151 /**
2152  * @title PaymentSplitter
2153  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2154  * that the Ether will be split in this way, since it is handled transparently by the contract.
2155  *
2156  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2157  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2158  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2159  * time of contract deployment and can't be updated thereafter.
2160  *
2161  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2162  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2163  * function.
2164  *
2165  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2166  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2167  * to run tests before sending real value to this contract.
2168  */
2169 contract PaymentSplitter is Context {
2170     event PayeeAdded(address account, uint256 shares);
2171     event PaymentReleased(address to, uint256 amount);
2172     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2173     event PaymentReceived(address from, uint256 amount);
2174 
2175     uint256 private _totalShares;
2176     uint256 private _totalReleased;
2177 
2178     mapping(address => uint256) private _shares;
2179     mapping(address => uint256) private _released;
2180     address[] private _payees;
2181 
2182     mapping(IERC20 => uint256) private _erc20TotalReleased;
2183     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2184 
2185     /**
2186      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2187      * the matching position in the `shares` array.
2188      *
2189      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2190      * duplicates in `payees`.
2191      */
2192     constructor(address[] memory payees, uint256[] memory shares_) payable {
2193         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2194         require(payees.length > 0, "PaymentSplitter: no payees");
2195 
2196         for (uint256 i = 0; i < payees.length; i++) {
2197             _addPayee(payees[i], shares_[i]);
2198         }
2199     }
2200 
2201     /**
2202      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2203      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2204      * reliability of the events, and not the actual splitting of Ether.
2205      *
2206      * To learn more about this see the Solidity documentation for
2207      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2208      * functions].
2209      */
2210     receive() external payable virtual {
2211         emit PaymentReceived(_msgSender(), msg.value);
2212     }
2213 
2214     /**
2215      * @dev Getter for the total shares held by payees.
2216      */
2217     function totalShares() public view returns (uint256) {
2218         return _totalShares;
2219     }
2220 
2221     /**
2222      * @dev Getter for the total amount of Ether already released.
2223      */
2224     function totalReleased() public view returns (uint256) {
2225         return _totalReleased;
2226     }
2227 
2228     /**
2229      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2230      * contract.
2231      */
2232     function totalReleased(IERC20 token) public view returns (uint256) {
2233         return _erc20TotalReleased[token];
2234     }
2235 
2236     /**
2237      * @dev Getter for the amount of shares held by an account.
2238      */
2239     function shares(address account) public view returns (uint256) {
2240         return _shares[account];
2241     }
2242 
2243     /**
2244      * @dev Getter for the amount of Ether already released to a payee.
2245      */
2246     function released(address account) public view returns (uint256) {
2247         return _released[account];
2248     }
2249 
2250     /**
2251      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2252      * IERC20 contract.
2253      */
2254     function released(IERC20 token, address account) public view returns (uint256) {
2255         return _erc20Released[token][account];
2256     }
2257 
2258     /**
2259      * @dev Getter for the address of the payee number `index`.
2260      */
2261     function payee(uint256 index) public view returns (address) {
2262         return _payees[index];
2263     }
2264 
2265     /**
2266      * @dev Getter for the amount of payee's releasable Ether.
2267      */
2268     function releasable(address account) public view returns (uint256) {
2269         uint256 totalReceived = address(this).balance + totalReleased();
2270         return _pendingPayment(account, totalReceived, released(account));
2271     }
2272 
2273     /**
2274      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2275      * IERC20 contract.
2276      */
2277     function releasable(IERC20 token, address account) public view returns (uint256) {
2278         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2279         return _pendingPayment(account, totalReceived, released(token, account));
2280     }
2281 
2282     /**
2283      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2284      * total shares and their previous withdrawals.
2285      */
2286     function release(address payable account) public virtual {
2287         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2288 
2289         uint256 payment = releasable(account);
2290 
2291         require(payment != 0, "PaymentSplitter: account is not due payment");
2292 
2293         // _totalReleased is the sum of all values in _released.
2294         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2295         _totalReleased += payment;
2296         unchecked {
2297             _released[account] += payment;
2298         }
2299 
2300         Address.sendValue(account, payment);
2301         emit PaymentReleased(account, payment);
2302     }
2303 
2304     /**
2305      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2306      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2307      * contract.
2308      */
2309     function release(IERC20 token, address account) public virtual {
2310         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2311 
2312         uint256 payment = releasable(token, account);
2313 
2314         require(payment != 0, "PaymentSplitter: account is not due payment");
2315 
2316         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2317         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2318         // cannot overflow.
2319         _erc20TotalReleased[token] += payment;
2320         unchecked {
2321             _erc20Released[token][account] += payment;
2322         }
2323 
2324         SafeERC20.safeTransfer(token, account, payment);
2325         emit ERC20PaymentReleased(token, account, payment);
2326     }
2327 
2328     /**
2329      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2330      * already released amounts.
2331      */
2332     function _pendingPayment(
2333         address account,
2334         uint256 totalReceived,
2335         uint256 alreadyReleased
2336     ) private view returns (uint256) {
2337         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2338     }
2339 
2340     /**
2341      * @dev Add a new payee to the contract.
2342      * @param account The address of the payee to add.
2343      * @param shares_ The number of shares owned by the payee.
2344      */
2345     function _addPayee(address account, uint256 shares_) private {
2346         require(account != address(0), "PaymentSplitter: account is the zero address");
2347         require(shares_ > 0, "PaymentSplitter: shares are 0");
2348         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2349 
2350         _payees.push(account);
2351         _shares[account] = shares_;
2352         _totalShares = _totalShares + shares_;
2353         emit PayeeAdded(account, shares_);
2354     }
2355 }
2356 
2357 
2358 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2359 
2360 
2361 
2362 /**
2363  * @dev These functions deal with verification of Merkle Tree proofs.
2364  *
2365  * The tree and the proofs can be generated using our
2366  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2367  * You will find a quickstart guide in the readme.
2368  *
2369  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2370  * hashing, or use a hash function other than keccak256 for hashing leaves.
2371  * This is because the concatenation of a sorted pair of internal nodes in
2372  * the merkle tree could be reinterpreted as a leaf value.
2373  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2374  * against this attack out of the box.
2375  */
2376 library MerkleProof {
2377     /**
2378      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2379      * defined by `root`. For this, a `proof` must be provided, containing
2380      * sibling hashes on the branch from the leaf to the root of the tree. Each
2381      * pair of leaves and each pair of pre-images are assumed to be sorted.
2382      */
2383     function verify(
2384         bytes32[] memory proof,
2385         bytes32 root,
2386         bytes32 leaf
2387     ) internal pure returns (bool) {
2388         return processProof(proof, leaf) == root;
2389     }
2390 
2391     /**
2392      * @dev Calldata version of {verify}
2393      *
2394      * _Available since v4.7._
2395      */
2396     function verifyCalldata(
2397         bytes32[] calldata proof,
2398         bytes32 root,
2399         bytes32 leaf
2400     ) internal pure returns (bool) {
2401         return processProofCalldata(proof, leaf) == root;
2402     }
2403 
2404     /**
2405      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2406      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2407      * hash matches the root of the tree. When processing the proof, the pairs
2408      * of leafs & pre-images are assumed to be sorted.
2409      *
2410      * _Available since v4.4._
2411      */
2412     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2413         bytes32 computedHash = leaf;
2414         for (uint256 i = 0; i < proof.length; i++) {
2415             computedHash = _hashPair(computedHash, proof[i]);
2416         }
2417         return computedHash;
2418     }
2419 
2420     /**
2421      * @dev Calldata version of {processProof}
2422      *
2423      * _Available since v4.7._
2424      */
2425     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2426         bytes32 computedHash = leaf;
2427         for (uint256 i = 0; i < proof.length; i++) {
2428             computedHash = _hashPair(computedHash, proof[i]);
2429         }
2430         return computedHash;
2431     }
2432 
2433     /**
2434      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2435      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2436      *
2437      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2438      *
2439      * _Available since v4.7._
2440      */
2441     function multiProofVerify(
2442         bytes32[] memory proof,
2443         bool[] memory proofFlags,
2444         bytes32 root,
2445         bytes32[] memory leaves
2446     ) internal pure returns (bool) {
2447         return processMultiProof(proof, proofFlags, leaves) == root;
2448     }
2449 
2450     /**
2451      * @dev Calldata version of {multiProofVerify}
2452      *
2453      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2454      *
2455      * _Available since v4.7._
2456      */
2457     function multiProofVerifyCalldata(
2458         bytes32[] calldata proof,
2459         bool[] calldata proofFlags,
2460         bytes32 root,
2461         bytes32[] memory leaves
2462     ) internal pure returns (bool) {
2463         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2464     }
2465 
2466     /**
2467      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2468      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2469      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2470      * respectively.
2471      *
2472      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2473      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2474      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2475      *
2476      * _Available since v4.7._
2477      */
2478     function processMultiProof(
2479         bytes32[] memory proof,
2480         bool[] memory proofFlags,
2481         bytes32[] memory leaves
2482     ) internal pure returns (bytes32 merkleRoot) {
2483         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2484         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2485         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2486         // the merkle tree.
2487         uint256 leavesLen = leaves.length;
2488         uint256 totalHashes = proofFlags.length;
2489 
2490         // Check proof validity.
2491         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2492 
2493         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2494         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2495         bytes32[] memory hashes = new bytes32[](totalHashes);
2496         uint256 leafPos = 0;
2497         uint256 hashPos = 0;
2498         uint256 proofPos = 0;
2499         // At each step, we compute the next hash using two values:
2500         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2501         //   get the next hash.
2502         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2503         //   `proof` array.
2504         for (uint256 i = 0; i < totalHashes; i++) {
2505             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2506             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2507             hashes[i] = _hashPair(a, b);
2508         }
2509 
2510         if (totalHashes > 0) {
2511             return hashes[totalHashes - 1];
2512         } else if (leavesLen > 0) {
2513             return leaves[0];
2514         } else {
2515             return proof[0];
2516         }
2517     }
2518 
2519     /**
2520      * @dev Calldata version of {processMultiProof}.
2521      *
2522      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2523      *
2524      * _Available since v4.7._
2525      */
2526     function processMultiProofCalldata(
2527         bytes32[] calldata proof,
2528         bool[] calldata proofFlags,
2529         bytes32[] memory leaves
2530     ) internal pure returns (bytes32 merkleRoot) {
2531         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2532         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2533         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2534         // the merkle tree.
2535         uint256 leavesLen = leaves.length;
2536         uint256 totalHashes = proofFlags.length;
2537 
2538         // Check proof validity.
2539         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2540 
2541         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2542         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2543         bytes32[] memory hashes = new bytes32[](totalHashes);
2544         uint256 leafPos = 0;
2545         uint256 hashPos = 0;
2546         uint256 proofPos = 0;
2547         // At each step, we compute the next hash using two values:
2548         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2549         //   get the next hash.
2550         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2551         //   `proof` array.
2552         for (uint256 i = 0; i < totalHashes; i++) {
2553             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2554             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2555             hashes[i] = _hashPair(a, b);
2556         }
2557 
2558         if (totalHashes > 0) {
2559             return hashes[totalHashes - 1];
2560         } else if (leavesLen > 0) {
2561             return leaves[0];
2562         } else {
2563             return proof[0];
2564         }
2565     }
2566 
2567     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2568         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2569     }
2570 
2571     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2572         /// @solidity memory-safe-assembly
2573         assembly {
2574             mstore(0x00, a)
2575             mstore(0x20, b)
2576             value := keccak256(0x00, 0x40)
2577         }
2578     }
2579 }
2580 
2581 
2582 contract Seelies is Ownable, ERC721A, ERC2981, PaymentSplitter {
2583     using Strings for uint256;
2584 
2585     /*//////////////////////////////////////////////////////////////
2586                                 CONSTANTS
2587     //////////////////////////////////////////////////////////////*/
2588 
2589     uint256 public constant maxSupplyCap = 3888;
2590 
2591     uint256 public constant publicSupplyCap = 3700;
2592     uint256 public constant maxTokensPerTx = 3;
2593     uint256 public constant price = 0.019 ether;
2594 
2595     uint256 public constant whitelistSupplyCap = 3000;
2596     uint256 public constant maxWhitelistTokensPerAddr = 3;
2597     uint256 public constant whitelistPrice = 0.014 ether;
2598 
2599     /*//////////////////////////////////////////////////////////////
2600                                 VARIABLES
2601     //////////////////////////////////////////////////////////////*/
2602 
2603     uint32 public whitelistSaleStart;
2604     uint32 public publicSaleStart;
2605     uint32 public enchantedClaimStart;
2606     uint32 public enchantedClaimEnd;
2607 
2608     bytes32 public merkleRoot;
2609 
2610     bool public revealed;
2611 
2612     string private _baseTokenURI;
2613     string private notRevealedUri;
2614 
2615     mapping(address => bool) public enchantedClaimed;
2616 
2617     /*//////////////////////////////////////////////////////////////
2618                                  ERRORS
2619     //////////////////////////////////////////////////////////////*/
2620 
2621     error SaleNotStarted();
2622     error ClaimClosed();
2623     error InvalidProof();
2624     error QuantityOffLimits();
2625     error MaxSupplyReached();
2626     error InsufficientFunds();
2627     error AlreadyClaimed();
2628     error InvalidInput();
2629     error NonExistentTokenURI();
2630 
2631     /*//////////////////////////////////////////////////////////////
2632                                CONSTRUCTOR
2633     //////////////////////////////////////////////////////////////*/
2634 
2635     constructor(
2636         string memory _initNotRevealedUri,
2637         address[] memory payees_,
2638         uint256[] memory shares_
2639     ) ERC721A("Seelies", "SEELIES") PaymentSplitter(payees_, shares_) {
2640         notRevealedUri = _initNotRevealedUri;
2641         _mint(msg.sender, 1);
2642     }
2643 
2644     /*//////////////////////////////////////////////////////////////
2645                             MINTING LOGIC
2646     //////////////////////////////////////////////////////////////*/
2647 
2648     function whitelistMint(uint256 quantity, bytes32[] memory proof)
2649         external
2650         payable
2651     {
2652         // If minting has not started, revert.
2653         if (block.timestamp < whitelistSaleStart) revert SaleNotStarted();
2654 
2655         // If provided proof is invalid, revert.
2656         if (
2657             !(
2658                 MerkleProof.verify(
2659                     proof,
2660                     merkleRoot,
2661                     keccak256(abi.encodePacked(msg.sender))
2662                 )
2663             )
2664         ) revert InvalidProof();
2665 
2666         // If supply cap is reached, revert.
2667         if (_totalMinted() + quantity > whitelistSupplyCap)
2668             revert MaxSupplyReached();
2669 
2670         // If provided value doesn't match with the price, revert.
2671         if (msg.value != whitelistPrice * quantity) revert InsufficientFunds();
2672 
2673         // If provided quantity is outside of predefined limits, revert.
2674         if (quantity == 0 || quantity > maxTokensPerTx)
2675             revert QuantityOffLimits();
2676 
2677         // If the user has already claimed their tokens, revert.
2678         uint64 _mintSlotsUsed = _getAux(msg.sender) + uint64(quantity);
2679         if (_mintSlotsUsed > maxWhitelistTokensPerAddr) revert AlreadyClaimed();
2680 
2681         _setAux(msg.sender, _mintSlotsUsed);
2682 
2683         _mint(msg.sender, quantity);
2684     }
2685 
2686     function publicMint(uint256 quantity) external payable {
2687         // If public minting has not started by reaching timestamp or minting out the whitelist supply, revert.
2688         if (
2689             _totalMinted() < whitelistSupplyCap &&
2690             block.timestamp < publicSaleStart
2691         ) {
2692             revert SaleNotStarted();
2693         }
2694 
2695         // If provided value doesn't match with the price, revert.
2696         if (msg.value != price * quantity) revert InsufficientFunds();
2697 
2698         // If provided quantity is outside of predefined limits, revert.
2699         if (quantity == 0 || quantity > maxTokensPerTx)
2700             revert QuantityOffLimits();
2701 
2702         // If enchanted claim is not ended, cap the supply to public max. If yes, free the rest of the supply for public.
2703         if (block.timestamp < enchantedClaimEnd) {
2704             if (_totalMinted() + quantity > publicSupplyCap)
2705                 revert MaxSupplyReached();
2706         } else {
2707             if (_totalMinted() + quantity > maxSupplyCap)
2708                 revert MaxSupplyReached();
2709         }
2710 
2711         _mint(msg.sender, quantity);
2712     }
2713 
2714     function enchantedClaim(bytes32[] memory proof) external payable {
2715         // If claiming has not started, revert.
2716         if (
2717             block.timestamp < enchantedClaimStart ||
2718             block.timestamp > enchantedClaimEnd
2719         ) revert ClaimClosed();
2720 
2721         // If provided proof is invalid, revert.
2722         if (
2723             !(
2724                 MerkleProof.verify(
2725                     proof,
2726                     merkleRoot,
2727                     keccak256(abi.encodePacked(msg.sender))
2728                 )
2729             )
2730         ) revert InvalidProof();
2731 
2732         // If supply cap is reached, revert.
2733         if (_totalMinted() + 1 > maxSupplyCap) revert MaxSupplyReached();
2734 
2735         // If the user has already claimed their tokens, revert.
2736         if (enchantedClaimed[msg.sender]) revert AlreadyClaimed();
2737 
2738         enchantedClaimed[msg.sender] = true;
2739 
2740         _mint(msg.sender, 1);
2741     }
2742 
2743     /*//////////////////////////////////////////////////////////////
2744                             FRONTEND HELPERS
2745     //////////////////////////////////////////////////////////////*/
2746 
2747     function isWhitelistOpen() public view returns (bool) {
2748         return block.timestamp < whitelistSaleStart ? false : true;
2749     }
2750 
2751     function isPublicOpen() public view returns (bool) {
2752         return block.timestamp < publicSaleStart ? false : true;
2753     }
2754 
2755     function isEnchantedStarted() public view returns (bool) {
2756         return block.timestamp < enchantedClaimStart ? false : true;
2757     }
2758 
2759     function isEnchantedOver() public view returns (bool) {
2760         return block.timestamp < enchantedClaimEnd ? false : true;
2761     }
2762 
2763     function earlyClaimed(address user) public view returns (uint256) {
2764         return _getAux(user);
2765     }
2766 
2767     function mintedByAddr(address addr) external view returns (uint256) {
2768         return _numberMinted(addr);
2769     }
2770 
2771     function totalMinted() external view virtual returns (uint256) {
2772         return _totalMinted();
2773     }
2774 
2775     /*//////////////////////////////////////////////////////////////
2776                                 ADMIN
2777     //////////////////////////////////////////////////////////////*/
2778 
2779     function rewardCollaborators(
2780         address[] calldata receivers,
2781         uint256[] calldata amounts
2782     ) external onlyOwner {
2783         // If there is a mismatch between receivers and amounts lengths, revert.
2784         if (receivers.length != amounts.length || receivers.length == 0)
2785             revert InvalidInput();
2786 
2787         for (uint256 i; i < receivers.length; ) {
2788             // If the supply cap is reached, revert.
2789             if (_totalMinted() + amounts[i] > maxSupplyCap)
2790                 revert MaxSupplyReached();
2791 
2792             _mint(receivers[i], amounts[i]);
2793 
2794             unchecked {
2795                 ++i;
2796             }
2797         }
2798     }
2799 
2800     function setSaleTimes(
2801         uint32 _whitelistSaleStart,
2802         uint32 _publicSaleStart,
2803         uint32 _enchantedClaimStart,
2804         uint32 _enchantedClaimEnd
2805     ) external onlyOwner {
2806         whitelistSaleStart = _whitelistSaleStart;
2807         publicSaleStart = _publicSaleStart;
2808         enchantedClaimStart = _enchantedClaimStart;
2809         enchantedClaimEnd = _enchantedClaimEnd;
2810     }
2811 
2812     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2813         notRevealedUri = _notRevealedURI;
2814     }
2815 
2816     function setBaseURI(string calldata baseURI) external onlyOwner {
2817         _baseTokenURI = baseURI;
2818     }
2819 
2820     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2821         merkleRoot = _merkleRoot;
2822     }
2823 
2824     function reveal() external onlyOwner {
2825         revealed = true;
2826     }
2827 
2828     function setDefaultRoyalty(address receiver, uint96 feeNumerator)
2829         external
2830         onlyOwner
2831     {
2832         _setDefaultRoyalty(receiver, feeNumerator);
2833     }
2834 
2835     function deleteDefaultRoyalty() external onlyOwner {
2836         _deleteDefaultRoyalty();
2837     }
2838 
2839     /*//////////////////////////////////////////////////////////////
2840                                 OVERRIDES
2841     //////////////////////////////////////////////////////////////*/
2842 
2843     function _baseURI() internal view virtual override returns (string memory) {
2844         return _baseTokenURI;
2845     }
2846 
2847     function _startTokenId() internal view virtual override returns (uint256) {
2848         return 1;
2849     }
2850 
2851     function tokenURI(uint256 tokenId)
2852         public
2853         view
2854         virtual
2855         override
2856         returns (string memory)
2857     {
2858         if (!_exists(tokenId)) revert NonExistentTokenURI();
2859         if (revealed == false) {
2860             return notRevealedUri;
2861         }
2862         string memory baseURI = _baseURI();
2863         return
2864             bytes(baseURI).length > 0
2865                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
2866                 : "";
2867     }
2868 
2869     function supportsInterface(bytes4 interfaceId)
2870         public
2871         view
2872         virtual
2873         override(ERC721A, ERC2981)
2874         returns (bool)
2875     {
2876         return
2877             ERC721A.supportsInterface(interfaceId) ||
2878             ERC2981.supportsInterface(interfaceId);
2879     }
2880 }