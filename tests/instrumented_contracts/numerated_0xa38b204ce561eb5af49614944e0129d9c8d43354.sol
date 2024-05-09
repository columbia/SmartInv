1 // Sources flattened with hardhat v2.13.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.2
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.2
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.2
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.2
146 
147 
148 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Required interface of an ERC721 compliant contract.
154  */
155 interface IERC721 is IERC165 {
156     /**
157      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
160 
161     /**
162      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
163      */
164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165 
166     /**
167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
168      */
169     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
170 
171     /**
172      * @dev Returns the number of tokens in ``owner``'s account.
173      */
174     function balanceOf(address owner) external view returns (uint256 balance);
175 
176     /**
177      * @dev Returns the owner of the `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function ownerOf(uint256 tokenId) external view returns (address owner);
184 
185     /**
186      * @dev Safely transfers `tokenId` token from `from` to `to`.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must exist and be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId,
202         bytes calldata data
203     ) external;
204 
205     /**
206      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
207      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must exist and be owned by `from`.
214      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
216      *
217      * Emits a {Transfer} event.
218      */
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     /**
226      * @dev Transfers `tokenId` token from `from` to `to`.
227      *
228      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
229      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
230      * understand this adds an external call which potentially creates a reentrancy vulnerability.
231      *
232      * Requirements:
233      *
234      * - `from` cannot be the zero address.
235      * - `to` cannot be the zero address.
236      * - `tokenId` token must be owned by `from`.
237      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external;
246 
247     /**
248      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
249      * The approval is cleared when the token is transferred.
250      *
251      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
252      *
253      * Requirements:
254      *
255      * - The caller must own the token or be an approved operator.
256      * - `tokenId` must exist.
257      *
258      * Emits an {Approval} event.
259      */
260     function approve(address to, uint256 tokenId) external;
261 
262     /**
263      * @dev Approve or remove `operator` as an operator for the caller.
264      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
265      *
266      * Requirements:
267      *
268      * - The `operator` cannot be the caller.
269      *
270      * Emits an {ApprovalForAll} event.
271      */
272     function setApprovalForAll(address operator, bool _approved) external;
273 
274     /**
275      * @dev Returns the account approved for `tokenId` token.
276      *
277      * Requirements:
278      *
279      * - `tokenId` must exist.
280      */
281     function getApproved(uint256 tokenId) external view returns (address operator);
282 
283     /**
284      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
285      *
286      * See {setApprovalForAll}
287      */
288     function isApprovedForAll(address owner, address operator) external view returns (bool);
289 }
290 
291 
292 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.2
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
301  * @dev See https://eips.ethereum.org/EIPS/eip-721
302  */
303 interface IERC721Metadata is IERC721 {
304     /**
305      * @dev Returns the token collection name.
306      */
307     function name() external view returns (string memory);
308 
309     /**
310      * @dev Returns the token collection symbol.
311      */
312     function symbol() external view returns (string memory);
313 
314     /**
315      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
316      */
317     function tokenURI(uint256 tokenId) external view returns (string memory);
318 }
319 
320 
321 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.2
322 
323 
324 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 
351 
352 // File @openzeppelin/contracts/utils/Address.sol@v4.8.2
353 
354 
355 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
356 
357 pragma solidity ^0.8.1;
358 
359 /**
360  * @dev Collection of functions related to the address type
361  */
362 library Address {
363     /**
364      * @dev Returns true if `account` is a contract.
365      *
366      * [IMPORTANT]
367      * ====
368      * It is unsafe to assume that an address for which this function returns
369      * false is an externally-owned account (EOA) and not a contract.
370      *
371      * Among others, `isContract` will return false for the following
372      * types of addresses:
373      *
374      *  - an externally-owned account
375      *  - a contract in construction
376      *  - an address where a contract will be created
377      *  - an address where a contract lived, but was destroyed
378      * ====
379      *
380      * [IMPORTANT]
381      * ====
382      * You shouldn't rely on `isContract` to protect against flash loan attacks!
383      *
384      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
385      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
386      * constructor.
387      * ====
388      */
389     function isContract(address account) internal view returns (bool) {
390         // This method relies on extcodesize/address.code.length, which returns 0
391         // for contracts in construction, since the code is only stored at the end
392         // of the constructor execution.
393 
394         return account.code.length > 0;
395     }
396 
397     /**
398      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
399      * `recipient`, forwarding all available gas and reverting on errors.
400      *
401      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
402      * of certain opcodes, possibly making contracts go over the 2300 gas limit
403      * imposed by `transfer`, making them unable to receive funds via
404      * `transfer`. {sendValue} removes this limitation.
405      *
406      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
407      *
408      * IMPORTANT: because control is transferred to `recipient`, care must be
409      * taken to not create reentrancy vulnerabilities. Consider using
410      * {ReentrancyGuard} or the
411      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
412      */
413     function sendValue(address payable recipient, uint256 amount) internal {
414         require(address(this).balance >= amount, "Address: insufficient balance");
415 
416         (bool success, ) = recipient.call{value: amount}("");
417         require(success, "Address: unable to send value, recipient may have reverted");
418     }
419 
420     /**
421      * @dev Performs a Solidity function call using a low level `call`. A
422      * plain `call` is an unsafe replacement for a function call: use this
423      * function instead.
424      *
425      * If `target` reverts with a revert reason, it is bubbled up by this
426      * function (like regular Solidity function calls).
427      *
428      * Returns the raw returned data. To convert to the expected return value,
429      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
430      *
431      * Requirements:
432      *
433      * - `target` must be a contract.
434      * - calling `target` with `data` must not revert.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
444      * `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, 0, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but also transferring `value` wei to `target`.
459      *
460      * Requirements:
461      *
462      * - the calling contract must have an ETH balance of at least `value`.
463      * - the called Solidity function must be `payable`.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value
471     ) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
477      * with `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(address(this).balance >= value, "Address: insufficient balance for call");
488         (bool success, bytes memory returndata) = target.call{value: value}(data);
489         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a static call.
495      *
496      * _Available since v3.3._
497      */
498     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
499         return functionStaticCall(target, data, "Address: low-level static call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a static call.
505      *
506      * _Available since v3.3._
507      */
508     function functionStaticCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal view returns (bytes memory) {
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         (bool success, bytes memory returndata) = target.delegatecall(data);
539         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
544      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
545      *
546      * _Available since v4.8._
547      */
548     function verifyCallResultFromTarget(
549         address target,
550         bool success,
551         bytes memory returndata,
552         string memory errorMessage
553     ) internal view returns (bytes memory) {
554         if (success) {
555             if (returndata.length == 0) {
556                 // only check isContract if the call was successful and the return data is empty
557                 // otherwise we already know that it was a contract
558                 require(isContract(target), "Address: call to non-contract");
559             }
560             return returndata;
561         } else {
562             _revert(returndata, errorMessage);
563         }
564     }
565 
566     /**
567      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
568      * revert reason or using the provided one.
569      *
570      * _Available since v4.3._
571      */
572     function verifyCallResult(
573         bool success,
574         bytes memory returndata,
575         string memory errorMessage
576     ) internal pure returns (bytes memory) {
577         if (success) {
578             return returndata;
579         } else {
580             _revert(returndata, errorMessage);
581         }
582     }
583 
584     function _revert(bytes memory returndata, string memory errorMessage) private pure {
585         // Look for revert reason and bubble it up if present
586         if (returndata.length > 0) {
587             // The easiest way to bubble the revert reason is using memory via assembly
588             /// @solidity memory-safe-assembly
589             assembly {
590                 let returndata_size := mload(returndata)
591                 revert(add(32, returndata), returndata_size)
592             }
593         } else {
594             revert(errorMessage);
595         }
596     }
597 }
598 
599 
600 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.2
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
611  * for the additional interface id that will be supported. For example:
612  *
613  * ```solidity
614  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
616  * }
617  * ```
618  *
619  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
620  */
621 abstract contract ERC165 is IERC165 {
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         return interfaceId == type(IERC165).interfaceId;
627     }
628 }
629 
630 
631 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.2
632 
633 
634 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Standard math utilities missing in the Solidity language.
640  */
641 library Math {
642     enum Rounding {
643         Down, // Toward negative infinity
644         Up, // Toward infinity
645         Zero // Toward zero
646     }
647 
648     /**
649      * @dev Returns the largest of two numbers.
650      */
651     function max(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a > b ? a : b;
653     }
654 
655     /**
656      * @dev Returns the smallest of two numbers.
657      */
658     function min(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a < b ? a : b;
660     }
661 
662     /**
663      * @dev Returns the average of two numbers. The result is rounded towards
664      * zero.
665      */
666     function average(uint256 a, uint256 b) internal pure returns (uint256) {
667         // (a + b) / 2 can overflow.
668         return (a & b) + (a ^ b) / 2;
669     }
670 
671     /**
672      * @dev Returns the ceiling of the division of two numbers.
673      *
674      * This differs from standard division with `/` in that it rounds up instead
675      * of rounding down.
676      */
677     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
678         // (a + b - 1) / b can overflow on addition, so we distribute.
679         return a == 0 ? 0 : (a - 1) / b + 1;
680     }
681 
682     /**
683      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
684      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
685      * with further edits by Uniswap Labs also under MIT license.
686      */
687     function mulDiv(
688         uint256 x,
689         uint256 y,
690         uint256 denominator
691     ) internal pure returns (uint256 result) {
692         unchecked {
693             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
694             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
695             // variables such that product = prod1 * 2^256 + prod0.
696             uint256 prod0; // Least significant 256 bits of the product
697             uint256 prod1; // Most significant 256 bits of the product
698             assembly {
699                 let mm := mulmod(x, y, not(0))
700                 prod0 := mul(x, y)
701                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
702             }
703 
704             // Handle non-overflow cases, 256 by 256 division.
705             if (prod1 == 0) {
706                 return prod0 / denominator;
707             }
708 
709             // Make sure the result is less than 2^256. Also prevents denominator == 0.
710             require(denominator > prod1);
711 
712             ///////////////////////////////////////////////
713             // 512 by 256 division.
714             ///////////////////////////////////////////////
715 
716             // Make division exact by subtracting the remainder from [prod1 prod0].
717             uint256 remainder;
718             assembly {
719                 // Compute remainder using mulmod.
720                 remainder := mulmod(x, y, denominator)
721 
722                 // Subtract 256 bit number from 512 bit number.
723                 prod1 := sub(prod1, gt(remainder, prod0))
724                 prod0 := sub(prod0, remainder)
725             }
726 
727             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
728             // See https://cs.stackexchange.com/q/138556/92363.
729 
730             // Does not overflow because the denominator cannot be zero at this stage in the function.
731             uint256 twos = denominator & (~denominator + 1);
732             assembly {
733                 // Divide denominator by twos.
734                 denominator := div(denominator, twos)
735 
736                 // Divide [prod1 prod0] by twos.
737                 prod0 := div(prod0, twos)
738 
739                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
740                 twos := add(div(sub(0, twos), twos), 1)
741             }
742 
743             // Shift in bits from prod1 into prod0.
744             prod0 |= prod1 * twos;
745 
746             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
747             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
748             // four bits. That is, denominator * inv = 1 mod 2^4.
749             uint256 inverse = (3 * denominator) ^ 2;
750 
751             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
752             // in modular arithmetic, doubling the correct bits in each step.
753             inverse *= 2 - denominator * inverse; // inverse mod 2^8
754             inverse *= 2 - denominator * inverse; // inverse mod 2^16
755             inverse *= 2 - denominator * inverse; // inverse mod 2^32
756             inverse *= 2 - denominator * inverse; // inverse mod 2^64
757             inverse *= 2 - denominator * inverse; // inverse mod 2^128
758             inverse *= 2 - denominator * inverse; // inverse mod 2^256
759 
760             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
761             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
762             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
763             // is no longer required.
764             result = prod0 * inverse;
765             return result;
766         }
767     }
768 
769     /**
770      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
771      */
772     function mulDiv(
773         uint256 x,
774         uint256 y,
775         uint256 denominator,
776         Rounding rounding
777     ) internal pure returns (uint256) {
778         uint256 result = mulDiv(x, y, denominator);
779         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
780             result += 1;
781         }
782         return result;
783     }
784 
785     /**
786      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
787      *
788      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
789      */
790     function sqrt(uint256 a) internal pure returns (uint256) {
791         if (a == 0) {
792             return 0;
793         }
794 
795         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
796         //
797         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
798         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
799         //
800         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
801         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
802         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
803         //
804         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
805         uint256 result = 1 << (log2(a) >> 1);
806 
807         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
808         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
809         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
810         // into the expected uint128 result.
811         unchecked {
812             result = (result + a / result) >> 1;
813             result = (result + a / result) >> 1;
814             result = (result + a / result) >> 1;
815             result = (result + a / result) >> 1;
816             result = (result + a / result) >> 1;
817             result = (result + a / result) >> 1;
818             result = (result + a / result) >> 1;
819             return min(result, a / result);
820         }
821     }
822 
823     /**
824      * @notice Calculates sqrt(a), following the selected rounding direction.
825      */
826     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
827         unchecked {
828             uint256 result = sqrt(a);
829             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
830         }
831     }
832 
833     /**
834      * @dev Return the log in base 2, rounded down, of a positive value.
835      * Returns 0 if given 0.
836      */
837     function log2(uint256 value) internal pure returns (uint256) {
838         uint256 result = 0;
839         unchecked {
840             if (value >> 128 > 0) {
841                 value >>= 128;
842                 result += 128;
843             }
844             if (value >> 64 > 0) {
845                 value >>= 64;
846                 result += 64;
847             }
848             if (value >> 32 > 0) {
849                 value >>= 32;
850                 result += 32;
851             }
852             if (value >> 16 > 0) {
853                 value >>= 16;
854                 result += 16;
855             }
856             if (value >> 8 > 0) {
857                 value >>= 8;
858                 result += 8;
859             }
860             if (value >> 4 > 0) {
861                 value >>= 4;
862                 result += 4;
863             }
864             if (value >> 2 > 0) {
865                 value >>= 2;
866                 result += 2;
867             }
868             if (value >> 1 > 0) {
869                 result += 1;
870             }
871         }
872         return result;
873     }
874 
875     /**
876      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
877      * Returns 0 if given 0.
878      */
879     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
880         unchecked {
881             uint256 result = log2(value);
882             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
883         }
884     }
885 
886     /**
887      * @dev Return the log in base 10, rounded down, of a positive value.
888      * Returns 0 if given 0.
889      */
890     function log10(uint256 value) internal pure returns (uint256) {
891         uint256 result = 0;
892         unchecked {
893             if (value >= 10**64) {
894                 value /= 10**64;
895                 result += 64;
896             }
897             if (value >= 10**32) {
898                 value /= 10**32;
899                 result += 32;
900             }
901             if (value >= 10**16) {
902                 value /= 10**16;
903                 result += 16;
904             }
905             if (value >= 10**8) {
906                 value /= 10**8;
907                 result += 8;
908             }
909             if (value >= 10**4) {
910                 value /= 10**4;
911                 result += 4;
912             }
913             if (value >= 10**2) {
914                 value /= 10**2;
915                 result += 2;
916             }
917             if (value >= 10**1) {
918                 result += 1;
919             }
920         }
921         return result;
922     }
923 
924     /**
925      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
926      * Returns 0 if given 0.
927      */
928     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
929         unchecked {
930             uint256 result = log10(value);
931             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
932         }
933     }
934 
935     /**
936      * @dev Return the log in base 256, rounded down, of a positive value.
937      * Returns 0 if given 0.
938      *
939      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
940      */
941     function log256(uint256 value) internal pure returns (uint256) {
942         uint256 result = 0;
943         unchecked {
944             if (value >> 128 > 0) {
945                 value >>= 128;
946                 result += 16;
947             }
948             if (value >> 64 > 0) {
949                 value >>= 64;
950                 result += 8;
951             }
952             if (value >> 32 > 0) {
953                 value >>= 32;
954                 result += 4;
955             }
956             if (value >> 16 > 0) {
957                 value >>= 16;
958                 result += 2;
959             }
960             if (value >> 8 > 0) {
961                 result += 1;
962             }
963         }
964         return result;
965     }
966 
967     /**
968      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
969      * Returns 0 if given 0.
970      */
971     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
972         unchecked {
973             uint256 result = log256(value);
974             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
975         }
976     }
977 }
978 
979 
980 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.2
981 
982 
983 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
984 
985 pragma solidity ^0.8.0;
986 
987 /**
988  * @dev String operations.
989  */
990 library Strings {
991     bytes16 private constant _SYMBOLS = "0123456789abcdef";
992     uint8 private constant _ADDRESS_LENGTH = 20;
993 
994     /**
995      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
996      */
997     function toString(uint256 value) internal pure returns (string memory) {
998         unchecked {
999             uint256 length = Math.log10(value) + 1;
1000             string memory buffer = new string(length);
1001             uint256 ptr;
1002             /// @solidity memory-safe-assembly
1003             assembly {
1004                 ptr := add(buffer, add(32, length))
1005             }
1006             while (true) {
1007                 ptr--;
1008                 /// @solidity memory-safe-assembly
1009                 assembly {
1010                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1011                 }
1012                 value /= 10;
1013                 if (value == 0) break;
1014             }
1015             return buffer;
1016         }
1017     }
1018 
1019     /**
1020      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1021      */
1022     function toHexString(uint256 value) internal pure returns (string memory) {
1023         unchecked {
1024             return toHexString(value, Math.log256(value) + 1);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1030      */
1031     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1032         bytes memory buffer = new bytes(2 * length + 2);
1033         buffer[0] = "0";
1034         buffer[1] = "x";
1035         for (uint256 i = 2 * length + 1; i > 1; --i) {
1036             buffer[i] = _SYMBOLS[value & 0xf];
1037             value >>= 4;
1038         }
1039         require(value == 0, "Strings: hex length insufficient");
1040         return string(buffer);
1041     }
1042 
1043     /**
1044      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1045      */
1046     function toHexString(address addr) internal pure returns (string memory) {
1047         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1048     }
1049 }
1050 
1051 
1052 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.2
1053 
1054 
1055 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 /**
1066  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1067  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1068  * {ERC721Enumerable}.
1069  */
1070 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1071     using Address for address;
1072     using Strings for uint256;
1073 
1074     // Token name
1075     string private _name;
1076 
1077     // Token symbol
1078     string private _symbol;
1079 
1080     // Mapping from token ID to owner address
1081     mapping(uint256 => address) private _owners;
1082 
1083     // Mapping owner address to token count
1084     mapping(address => uint256) private _balances;
1085 
1086     // Mapping from token ID to approved address
1087     mapping(uint256 => address) private _tokenApprovals;
1088 
1089     // Mapping from owner to operator approvals
1090     mapping(address => mapping(address => bool)) private _operatorApprovals;
1091 
1092     /**
1093      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1094      */
1095     constructor(string memory name_, string memory symbol_) {
1096         _name = name_;
1097         _symbol = symbol_;
1098     }
1099 
1100     /**
1101      * @dev See {IERC165-supportsInterface}.
1102      */
1103     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1104         return
1105             interfaceId == type(IERC721).interfaceId ||
1106             interfaceId == type(IERC721Metadata).interfaceId ||
1107             super.supportsInterface(interfaceId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-balanceOf}.
1112      */
1113     function balanceOf(address owner) public view virtual override returns (uint256) {
1114         require(owner != address(0), "ERC721: address zero is not a valid owner");
1115         return _balances[owner];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-ownerOf}.
1120      */
1121     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1122         address owner = _ownerOf(tokenId);
1123         require(owner != address(0), "ERC721: invalid token ID");
1124         return owner;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-name}.
1129      */
1130     function name() public view virtual override returns (string memory) {
1131         return _name;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-symbol}.
1136      */
1137     function symbol() public view virtual override returns (string memory) {
1138         return _symbol;
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Metadata-tokenURI}.
1143      */
1144     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1145         _requireMinted(tokenId);
1146 
1147         string memory baseURI = _baseURI();
1148         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1149     }
1150 
1151     /**
1152      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1153      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1154      * by default, can be overridden in child contracts.
1155      */
1156     function _baseURI() internal view virtual returns (string memory) {
1157         return "";
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-approve}.
1162      */
1163     function approve(address to, uint256 tokenId) public virtual override {
1164         address owner = ERC721.ownerOf(tokenId);
1165         require(to != owner, "ERC721: approval to current owner");
1166 
1167         require(
1168             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1169             "ERC721: approve caller is not token owner or approved for all"
1170         );
1171 
1172         _approve(to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-getApproved}.
1177      */
1178     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1179         _requireMinted(tokenId);
1180 
1181         return _tokenApprovals[tokenId];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-setApprovalForAll}.
1186      */
1187     function setApprovalForAll(address operator, bool approved) public virtual override {
1188         _setApprovalForAll(_msgSender(), operator, approved);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-isApprovedForAll}.
1193      */
1194     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1195         return _operatorApprovals[owner][operator];
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-transferFrom}.
1200      */
1201     function transferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public virtual override {
1206         //solhint-disable-next-line max-line-length
1207         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1208 
1209         _transfer(from, to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-safeTransferFrom}.
1214      */
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) public virtual override {
1220         safeTransferFrom(from, to, tokenId, "");
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-safeTransferFrom}.
1225      */
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory data
1231     ) public virtual override {
1232         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1233         _safeTransfer(from, to, tokenId, data);
1234     }
1235 
1236     /**
1237      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1238      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1239      *
1240      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1241      *
1242      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1243      * implement alternative mechanisms to perform token transfer, such as signature-based.
1244      *
1245      * Requirements:
1246      *
1247      * - `from` cannot be the zero address.
1248      * - `to` cannot be the zero address.
1249      * - `tokenId` token must exist and be owned by `from`.
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _safeTransfer(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory data
1259     ) internal virtual {
1260         _transfer(from, to, tokenId);
1261         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1262     }
1263 
1264     /**
1265      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1266      */
1267     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1268         return _owners[tokenId];
1269     }
1270 
1271     /**
1272      * @dev Returns whether `tokenId` exists.
1273      *
1274      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1275      *
1276      * Tokens start existing when they are minted (`_mint`),
1277      * and stop existing when they are burned (`_burn`).
1278      */
1279     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1280         return _ownerOf(tokenId) != address(0);
1281     }
1282 
1283     /**
1284      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1285      *
1286      * Requirements:
1287      *
1288      * - `tokenId` must exist.
1289      */
1290     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1291         address owner = ERC721.ownerOf(tokenId);
1292         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1293     }
1294 
1295     /**
1296      * @dev Safely mints `tokenId` and transfers it to `to`.
1297      *
1298      * Requirements:
1299      *
1300      * - `tokenId` must not exist.
1301      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _safeMint(address to, uint256 tokenId) internal virtual {
1306         _safeMint(to, tokenId, "");
1307     }
1308 
1309     /**
1310      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1311      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1312      */
1313     function _safeMint(
1314         address to,
1315         uint256 tokenId,
1316         bytes memory data
1317     ) internal virtual {
1318         _mint(to, tokenId);
1319         require(
1320             _checkOnERC721Received(address(0), to, tokenId, data),
1321             "ERC721: transfer to non ERC721Receiver implementer"
1322         );
1323     }
1324 
1325     /**
1326      * @dev Mints `tokenId` and transfers it to `to`.
1327      *
1328      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1329      *
1330      * Requirements:
1331      *
1332      * - `tokenId` must not exist.
1333      * - `to` cannot be the zero address.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _mint(address to, uint256 tokenId) internal virtual {
1338         require(to != address(0), "ERC721: mint to the zero address");
1339         require(!_exists(tokenId), "ERC721: token already minted");
1340 
1341         _beforeTokenTransfer(address(0), to, tokenId, 1);
1342 
1343         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1344         require(!_exists(tokenId), "ERC721: token already minted");
1345 
1346         unchecked {
1347             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1348             // Given that tokens are minted one by one, it is impossible in practice that
1349             // this ever happens. Might change if we allow batch minting.
1350             // The ERC fails to describe this case.
1351             _balances[to] += 1;
1352         }
1353 
1354         _owners[tokenId] = to;
1355 
1356         emit Transfer(address(0), to, tokenId);
1357 
1358         _afterTokenTransfer(address(0), to, tokenId, 1);
1359     }
1360 
1361     /**
1362      * @dev Destroys `tokenId`.
1363      * The approval is cleared when the token is burned.
1364      * This is an internal function that does not check if the sender is authorized to operate on the token.
1365      *
1366      * Requirements:
1367      *
1368      * - `tokenId` must exist.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _burn(uint256 tokenId) internal virtual {
1373         address owner = ERC721.ownerOf(tokenId);
1374 
1375         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1376 
1377         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1378         owner = ERC721.ownerOf(tokenId);
1379 
1380         // Clear approvals
1381         delete _tokenApprovals[tokenId];
1382 
1383         unchecked {
1384             // Cannot overflow, as that would require more tokens to be burned/transferred
1385             // out than the owner initially received through minting and transferring in.
1386             _balances[owner] -= 1;
1387         }
1388         delete _owners[tokenId];
1389 
1390         emit Transfer(owner, address(0), tokenId);
1391 
1392         _afterTokenTransfer(owner, address(0), tokenId, 1);
1393     }
1394 
1395     /**
1396      * @dev Transfers `tokenId` from `from` to `to`.
1397      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1398      *
1399      * Requirements:
1400      *
1401      * - `to` cannot be the zero address.
1402      * - `tokenId` token must be owned by `from`.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function _transfer(
1407         address from,
1408         address to,
1409         uint256 tokenId
1410     ) internal virtual {
1411         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1412         require(to != address(0), "ERC721: transfer to the zero address");
1413 
1414         _beforeTokenTransfer(from, to, tokenId, 1);
1415 
1416         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1417         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1418 
1419         // Clear approvals from the previous owner
1420         delete _tokenApprovals[tokenId];
1421 
1422         unchecked {
1423             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1424             // `from`'s balance is the number of token held, which is at least one before the current
1425             // transfer.
1426             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1427             // all 2**256 token ids to be minted, which in practice is impossible.
1428             _balances[from] -= 1;
1429             _balances[to] += 1;
1430         }
1431         _owners[tokenId] = to;
1432 
1433         emit Transfer(from, to, tokenId);
1434 
1435         _afterTokenTransfer(from, to, tokenId, 1);
1436     }
1437 
1438     /**
1439      * @dev Approve `to` to operate on `tokenId`
1440      *
1441      * Emits an {Approval} event.
1442      */
1443     function _approve(address to, uint256 tokenId) internal virtual {
1444         _tokenApprovals[tokenId] = to;
1445         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1446     }
1447 
1448     /**
1449      * @dev Approve `operator` to operate on all of `owner` tokens
1450      *
1451      * Emits an {ApprovalForAll} event.
1452      */
1453     function _setApprovalForAll(
1454         address owner,
1455         address operator,
1456         bool approved
1457     ) internal virtual {
1458         require(owner != operator, "ERC721: approve to caller");
1459         _operatorApprovals[owner][operator] = approved;
1460         emit ApprovalForAll(owner, operator, approved);
1461     }
1462 
1463     /**
1464      * @dev Reverts if the `tokenId` has not been minted yet.
1465      */
1466     function _requireMinted(uint256 tokenId) internal view virtual {
1467         require(_exists(tokenId), "ERC721: invalid token ID");
1468     }
1469 
1470     /**
1471      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1472      * The call is not executed if the target address is not a contract.
1473      *
1474      * @param from address representing the previous owner of the given token ID
1475      * @param to target address that will receive the tokens
1476      * @param tokenId uint256 ID of the token to be transferred
1477      * @param data bytes optional data to send along with the call
1478      * @return bool whether the call correctly returned the expected magic value
1479      */
1480     function _checkOnERC721Received(
1481         address from,
1482         address to,
1483         uint256 tokenId,
1484         bytes memory data
1485     ) private returns (bool) {
1486         if (to.isContract()) {
1487             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1488                 return retval == IERC721Receiver.onERC721Received.selector;
1489             } catch (bytes memory reason) {
1490                 if (reason.length == 0) {
1491                     revert("ERC721: transfer to non ERC721Receiver implementer");
1492                 } else {
1493                     /// @solidity memory-safe-assembly
1494                     assembly {
1495                         revert(add(32, reason), mload(reason))
1496                     }
1497                 }
1498             }
1499         } else {
1500             return true;
1501         }
1502     }
1503 
1504     /**
1505      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1506      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1507      *
1508      * Calling conditions:
1509      *
1510      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1511      * - When `from` is zero, the tokens will be minted for `to`.
1512      * - When `to` is zero, ``from``'s tokens will be burned.
1513      * - `from` and `to` are never both zero.
1514      * - `batchSize` is non-zero.
1515      *
1516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1517      */
1518     function _beforeTokenTransfer(
1519         address from,
1520         address to,
1521         uint256 firstTokenId,
1522         uint256 batchSize
1523     ) internal virtual {}
1524 
1525     /**
1526      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1527      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1528      *
1529      * Calling conditions:
1530      *
1531      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1532      * - When `from` is zero, the tokens were minted for `to`.
1533      * - When `to` is zero, ``from``'s tokens were burned.
1534      * - `from` and `to` are never both zero.
1535      * - `batchSize` is non-zero.
1536      *
1537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1538      */
1539     function _afterTokenTransfer(
1540         address from,
1541         address to,
1542         uint256 firstTokenId,
1543         uint256 batchSize
1544     ) internal virtual {}
1545 
1546     /**
1547      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1548      *
1549      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1550      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1551      * that `ownerOf(tokenId)` is `a`.
1552      */
1553     // solhint-disable-next-line func-name-mixedcase
1554     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1555         _balances[account] += amount;
1556     }
1557 }
1558 
1559 
1560 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.8.2
1561 
1562 
1563 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 /**
1568  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1569  * @dev See https://eips.ethereum.org/EIPS/eip-721
1570  */
1571 interface IERC721Enumerable is IERC721 {
1572     /**
1573      * @dev Returns the total amount of tokens stored by the contract.
1574      */
1575     function totalSupply() external view returns (uint256);
1576 
1577     /**
1578      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1579      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1580      */
1581     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1582 
1583     /**
1584      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1585      * Use along with {totalSupply} to enumerate all tokens.
1586      */
1587     function tokenByIndex(uint256 index) external view returns (uint256);
1588 }
1589 
1590 
1591 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.8.2
1592 
1593 
1594 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 
1599 /**
1600  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1601  * enumerability of all the token ids in the contract as well as all token ids owned by each
1602  * account.
1603  */
1604 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1605     // Mapping from owner to list of owned token IDs
1606     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1607 
1608     // Mapping from token ID to index of the owner tokens list
1609     mapping(uint256 => uint256) private _ownedTokensIndex;
1610 
1611     // Array with all token ids, used for enumeration
1612     uint256[] private _allTokens;
1613 
1614     // Mapping from token id to position in the allTokens array
1615     mapping(uint256 => uint256) private _allTokensIndex;
1616 
1617     /**
1618      * @dev See {IERC165-supportsInterface}.
1619      */
1620     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1621         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1622     }
1623 
1624     /**
1625      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1626      */
1627     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1628         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1629         return _ownedTokens[owner][index];
1630     }
1631 
1632     /**
1633      * @dev See {IERC721Enumerable-totalSupply}.
1634      */
1635     function totalSupply() public view virtual override returns (uint256) {
1636         return _allTokens.length;
1637     }
1638 
1639     /**
1640      * @dev See {IERC721Enumerable-tokenByIndex}.
1641      */
1642     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1643         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1644         return _allTokens[index];
1645     }
1646 
1647     /**
1648      * @dev See {ERC721-_beforeTokenTransfer}.
1649      */
1650     function _beforeTokenTransfer(
1651         address from,
1652         address to,
1653         uint256 firstTokenId,
1654         uint256 batchSize
1655     ) internal virtual override {
1656         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1657 
1658         if (batchSize > 1) {
1659             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1660             revert("ERC721Enumerable: consecutive transfers not supported");
1661         }
1662 
1663         uint256 tokenId = firstTokenId;
1664 
1665         if (from == address(0)) {
1666             _addTokenToAllTokensEnumeration(tokenId);
1667         } else if (from != to) {
1668             _removeTokenFromOwnerEnumeration(from, tokenId);
1669         }
1670         if (to == address(0)) {
1671             _removeTokenFromAllTokensEnumeration(tokenId);
1672         } else if (to != from) {
1673             _addTokenToOwnerEnumeration(to, tokenId);
1674         }
1675     }
1676 
1677     /**
1678      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1679      * @param to address representing the new owner of the given token ID
1680      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1681      */
1682     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1683         uint256 length = ERC721.balanceOf(to);
1684         _ownedTokens[to][length] = tokenId;
1685         _ownedTokensIndex[tokenId] = length;
1686     }
1687 
1688     /**
1689      * @dev Private function to add a token to this extension's token tracking data structures.
1690      * @param tokenId uint256 ID of the token to be added to the tokens list
1691      */
1692     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1693         _allTokensIndex[tokenId] = _allTokens.length;
1694         _allTokens.push(tokenId);
1695     }
1696 
1697     /**
1698      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1699      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1700      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1701      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1702      * @param from address representing the previous owner of the given token ID
1703      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1704      */
1705     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1706         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1707         // then delete the last slot (swap and pop).
1708 
1709         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1710         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1711 
1712         // When the token to delete is the last token, the swap operation is unnecessary
1713         if (tokenIndex != lastTokenIndex) {
1714             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1715 
1716             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1717             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1718         }
1719 
1720         // This also deletes the contents at the last position of the array
1721         delete _ownedTokensIndex[tokenId];
1722         delete _ownedTokens[from][lastTokenIndex];
1723     }
1724 
1725     /**
1726      * @dev Private function to remove a token from this extension's token tracking data structures.
1727      * This has O(1) time complexity, but alters the order of the _allTokens array.
1728      * @param tokenId uint256 ID of the token to be removed from the tokens list
1729      */
1730     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1731         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1732         // then delete the last slot (swap and pop).
1733 
1734         uint256 lastTokenIndex = _allTokens.length - 1;
1735         uint256 tokenIndex = _allTokensIndex[tokenId];
1736 
1737         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1738         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1739         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1740         uint256 lastTokenId = _allTokens[lastTokenIndex];
1741 
1742         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1743         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1744 
1745         // This also deletes the contents at the last position of the array
1746         delete _allTokensIndex[tokenId];
1747         _allTokens.pop();
1748     }
1749 }
1750 
1751 
1752 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.2
1753 
1754 
1755 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 /**
1760  * @dev Contract module that helps prevent reentrant calls to a function.
1761  *
1762  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1763  * available, which can be applied to functions to make sure there are no nested
1764  * (reentrant) calls to them.
1765  *
1766  * Note that because there is a single `nonReentrant` guard, functions marked as
1767  * `nonReentrant` may not call one another. This can be worked around by making
1768  * those functions `private`, and then adding `external` `nonReentrant` entry
1769  * points to them.
1770  *
1771  * TIP: If you would like to learn more about reentrancy and alternative ways
1772  * to protect against it, check out our blog post
1773  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1774  */
1775 abstract contract ReentrancyGuard {
1776     // Booleans are more expensive than uint256 or any type that takes up a full
1777     // word because each write operation emits an extra SLOAD to first read the
1778     // slot's contents, replace the bits taken up by the boolean, and then write
1779     // back. This is the compiler's defense against contract upgrades and
1780     // pointer aliasing, and it cannot be disabled.
1781 
1782     // The values being non-zero value makes deployment a bit more expensive,
1783     // but in exchange the refund on every call to nonReentrant will be lower in
1784     // amount. Since refunds are capped to a percentage of the total
1785     // transaction's gas, it is best to keep them low in cases like this one, to
1786     // increase the likelihood of the full refund coming into effect.
1787     uint256 private constant _NOT_ENTERED = 1;
1788     uint256 private constant _ENTERED = 2;
1789 
1790     uint256 private _status;
1791 
1792     constructor() {
1793         _status = _NOT_ENTERED;
1794     }
1795 
1796     /**
1797      * @dev Prevents a contract from calling itself, directly or indirectly.
1798      * Calling a `nonReentrant` function from another `nonReentrant`
1799      * function is not supported. It is possible to prevent this from happening
1800      * by making the `nonReentrant` function external, and making it call a
1801      * `private` function that does the actual work.
1802      */
1803     modifier nonReentrant() {
1804         _nonReentrantBefore();
1805         _;
1806         _nonReentrantAfter();
1807     }
1808 
1809     function _nonReentrantBefore() private {
1810         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1811         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1812 
1813         // Any calls to nonReentrant after this point will fail
1814         _status = _ENTERED;
1815     }
1816 
1817     function _nonReentrantAfter() private {
1818         // By storing the original value once again, a refund is triggered (see
1819         // https://eips.ethereum.org/EIPS/eip-2200)
1820         _status = _NOT_ENTERED;
1821     }
1822 }
1823 
1824 
1825 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.2
1826 
1827 
1828 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1829 
1830 pragma solidity ^0.8.0;
1831 
1832 /**
1833  * @dev Interface of the ERC20 standard as defined in the EIP.
1834  */
1835 interface IERC20 {
1836     /**
1837      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1838      * another (`to`).
1839      *
1840      * Note that `value` may be zero.
1841      */
1842     event Transfer(address indexed from, address indexed to, uint256 value);
1843 
1844     /**
1845      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1846      * a call to {approve}. `value` is the new allowance.
1847      */
1848     event Approval(address indexed owner, address indexed spender, uint256 value);
1849 
1850     /**
1851      * @dev Returns the amount of tokens in existence.
1852      */
1853     function totalSupply() external view returns (uint256);
1854 
1855     /**
1856      * @dev Returns the amount of tokens owned by `account`.
1857      */
1858     function balanceOf(address account) external view returns (uint256);
1859 
1860     /**
1861      * @dev Moves `amount` tokens from the caller's account to `to`.
1862      *
1863      * Returns a boolean value indicating whether the operation succeeded.
1864      *
1865      * Emits a {Transfer} event.
1866      */
1867     function transfer(address to, uint256 amount) external returns (bool);
1868 
1869     /**
1870      * @dev Returns the remaining number of tokens that `spender` will be
1871      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1872      * zero by default.
1873      *
1874      * This value changes when {approve} or {transferFrom} are called.
1875      */
1876     function allowance(address owner, address spender) external view returns (uint256);
1877 
1878     /**
1879      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1880      *
1881      * Returns a boolean value indicating whether the operation succeeded.
1882      *
1883      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1884      * that someone may use both the old and the new allowance by unfortunate
1885      * transaction ordering. One possible solution to mitigate this race
1886      * condition is to first reduce the spender's allowance to 0 and set the
1887      * desired value afterwards:
1888      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1889      *
1890      * Emits an {Approval} event.
1891      */
1892     function approve(address spender, uint256 amount) external returns (bool);
1893 
1894     /**
1895      * @dev Moves `amount` tokens from `from` to `to` using the
1896      * allowance mechanism. `amount` is then deducted from the caller's
1897      * allowance.
1898      *
1899      * Returns a boolean value indicating whether the operation succeeded.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function transferFrom(
1904         address from,
1905         address to,
1906         uint256 amount
1907     ) external returns (bool);
1908 }
1909 
1910 
1911 // File @openzeppelin/contracts/utils/Counters.sol@v4.8.2
1912 
1913 
1914 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1915 
1916 pragma solidity ^0.8.0;
1917 
1918 /**
1919  * @title Counters
1920  * @author Matt Condon (@shrugs)
1921  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1922  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1923  *
1924  * Include with `using Counters for Counters.Counter;`
1925  */
1926 library Counters {
1927     struct Counter {
1928         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1929         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1930         // this feature: see https://github.com/ethereum/solidity/issues/4637
1931         uint256 _value; // default: 0
1932     }
1933 
1934     function current(Counter storage counter) internal view returns (uint256) {
1935         return counter._value;
1936     }
1937 
1938     function increment(Counter storage counter) internal {
1939         unchecked {
1940             counter._value += 1;
1941         }
1942     }
1943 
1944     function decrement(Counter storage counter) internal {
1945         uint256 value = counter._value;
1946         require(value > 0, "Counter: decrement overflow");
1947         unchecked {
1948             counter._value = value - 1;
1949         }
1950     }
1951 
1952     function reset(Counter storage counter) internal {
1953         counter._value = 0;
1954     }
1955 }
1956 
1957 
1958 // File contracts/ActPass.sol
1959 
1960 // SPDX-License-Identifier: MIT
1961 
1962 pragma solidity ^0.8.0;
1963 
1964 
1965 
1966 
1967 
1968 
1969 contract ActPass is
1970     Context,
1971     ERC721Enumerable,
1972     ReentrancyGuard,
1973     Ownable
1974 {
1975     using Strings for uint256;
1976     using Counters for Counters.Counter;
1977 
1978     Counters.Counter private _tokenIdTracker;
1979 
1980     uint256 public constant MAX_SUPPLY = 999;
1981 
1982     mapping(address => uint256) private _whitelist;
1983 
1984     string private _baseTokenURI;
1985 
1986     constructor(
1987         string memory name,
1988         string memory symbol,
1989         string memory baseTokenURI
1990     ) ERC721(name, symbol) {
1991         _baseTokenURI = baseTokenURI;
1992         _tokenIdTracker.increment();
1993     }
1994 
1995     function _baseURI() internal view virtual override returns (string memory) {
1996         return _baseTokenURI;
1997     }
1998 
1999     function setBaseURI(string memory baseTokenURI) public virtual onlyOwner {
2000         _baseTokenURI = baseTokenURI;
2001     }
2002 
2003     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2004         _requireMinted(tokenId);
2005         string memory baseURI = _baseURI();
2006         return bytes(baseURI).length > 0 ? string(abi.encodePacked(abi.encodePacked(baseURI, tokenId.toString()), ".json")) : "";
2007     }
2008 
2009     function addWhitelist(address account, uint256 mintAllowance) external virtual onlyOwner {
2010         _whitelist[account] = mintAllowance;
2011     }
2012 
2013     function removeWhitelist(address account) external virtual onlyOwner {
2014         _whitelist[account] = 0;
2015     }
2016 
2017     function getWhitelistMintAllowance(address account) external view returns (uint256) {
2018         return _whitelist[account];
2019     }
2020 
2021     function batchMint(address toAddress, uint256 mintAmount) external virtual nonReentrant {
2022         require(_whitelist[_msgSender()] >= mintAmount, "Not enough mint allowance");
2023         require(_tokenIdTracker.current() + mintAmount - 1 <= MAX_SUPPLY, "Exceeds maximum token supply");
2024         _whitelist[_msgSender()] -= mintAmount;
2025         for (uint256 i = 0; i < mintAmount; ++i) {
2026             _mint(toAddress, _tokenIdTracker.current());
2027             _tokenIdTracker.increment();
2028         }
2029     }
2030 
2031     function mint(address toAddress) external virtual nonReentrant {
2032         require(_whitelist[_msgSender()] >= 1, "Not enough mint allowance");
2033         require(_tokenIdTracker.current() <= MAX_SUPPLY, "Exceeds maximum token supply");
2034         _whitelist[_msgSender()] -= 1;
2035         _mint(toAddress, _tokenIdTracker.current());
2036         _tokenIdTracker.increment();
2037     }
2038 
2039     function withdrawERC20(IERC20 token, uint256 amount) public onlyOwner {
2040         token.transfer(owner(), amount);
2041     }
2042 
2043     function withdraw() public onlyOwner {
2044         payable(owner()).transfer(address(this).balance);
2045     }
2046 
2047     function _beforeTokenTransfer(
2048         address from,
2049         address to,
2050         uint256 tokenId,
2051         uint256 batchSize
2052     ) internal virtual override(ERC721Enumerable) {
2053         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2054     }
2055 
2056     function supportsInterface(
2057         bytes4 interfaceId
2058     ) public view virtual override(ERC721Enumerable) returns (bool) {
2059         return super.supportsInterface(interfaceId);
2060     }
2061 }