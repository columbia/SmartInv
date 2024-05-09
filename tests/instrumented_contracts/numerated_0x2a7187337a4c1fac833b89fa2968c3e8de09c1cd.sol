1 // SPDX-License-Identifier: MIT
2 
3 // Sources flattened with hardhat v2.12.6 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
34 
35 
36 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Interface of the ERC165 standard, as defined in the
127  * https://eips.ethereum.org/EIPS/eip-165[EIP].
128  *
129  * Implementers can declare support of contract interfaces, which can then be
130  * queried by others ({ERC165Checker}).
131  *
132  * For an implementation, see {ERC165}.
133  */
134 interface IERC165 {
135     /**
136      * @dev Returns true if this contract implements the interface defined by
137      * `interfaceId`. See the corresponding
138      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
139      * to learn more about how these ids are created.
140      *
141      * This function call must use less than 30 000 gas.
142      */
143     function supportsInterface(bytes4 interfaceId) external view returns (bool);
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.1
148 
149 
150 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Required interface of an ERC721 compliant contract.
156  */
157 interface IERC721 is IERC165 {
158     /**
159      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
162 
163     /**
164      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
165      */
166     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
167 
168     /**
169      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
170      */
171     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
172 
173     /**
174      * @dev Returns the number of tokens in ``owner``'s account.
175      */
176     function balanceOf(address owner) external view returns (uint256 balance);
177 
178     /**
179      * @dev Returns the owner of the `tokenId` token.
180      *
181      * Requirements:
182      *
183      * - `tokenId` must exist.
184      */
185     function ownerOf(uint256 tokenId) external view returns (address owner);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId,
204         bytes calldata data
205     ) external;
206 
207     /**
208      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
209      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must exist and be owned by `from`.
216      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
217      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
218      *
219      * Emits a {Transfer} event.
220      */
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Transfers `tokenId` token from `from` to `to`.
229      *
230      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
231      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
232      * understand this adds an external call which potentially creates a reentrancy vulnerability.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must be owned by `from`.
239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(
244         address from,
245         address to,
246         uint256 tokenId
247     ) external;
248 
249     /**
250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
251      * The approval is cleared when the token is transferred.
252      *
253      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
254      *
255      * Requirements:
256      *
257      * - The caller must own the token or be an approved operator.
258      * - `tokenId` must exist.
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address to, uint256 tokenId) external;
263 
264     /**
265      * @dev Approve or remove `operator` as an operator for the caller.
266      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
267      *
268      * Requirements:
269      *
270      * - The `operator` cannot be the caller.
271      *
272      * Emits an {ApprovalForAll} event.
273      */
274     function setApprovalForAll(address operator, bool _approved) external;
275 
276     /**
277      * @dev Returns the account approved for `tokenId` token.
278      *
279      * Requirements:
280      *
281      * - `tokenId` must exist.
282      */
283     function getApproved(uint256 tokenId) external view returns (address operator);
284 
285     /**
286      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
287      *
288      * See {setApprovalForAll}
289      */
290     function isApprovedForAll(address owner, address operator) external view returns (bool);
291 }
292 
293 
294 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.1
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
303  * @dev See https://eips.ethereum.org/EIPS/eip-721
304  */
305 interface IERC721Metadata is IERC721 {
306     /**
307      * @dev Returns the token collection name.
308      */
309     function name() external view returns (string memory);
310 
311     /**
312      * @dev Returns the token collection symbol.
313      */
314     function symbol() external view returns (string memory);
315 
316     /**
317      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
318      */
319     function tokenURI(uint256 tokenId) external view returns (string memory);
320 }
321 
322 
323 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.1
324 
325 
326 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 
354 // File @openzeppelin/contracts/utils/Address.sol@v4.8.1
355 
356 
357 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
358 
359 pragma solidity ^0.8.1;
360 
361 /**
362  * @dev Collection of functions related to the address type
363  */
364 library Address {
365     /**
366      * @dev Returns true if `account` is a contract.
367      *
368      * [IMPORTANT]
369      * ====
370      * It is unsafe to assume that an address for which this function returns
371      * false is an externally-owned account (EOA) and not a contract.
372      *
373      * Among others, `isContract` will return false for the following
374      * types of addresses:
375      *
376      *  - an externally-owned account
377      *  - a contract in construction
378      *  - an address where a contract will be created
379      *  - an address where a contract lived, but was destroyed
380      * ====
381      *
382      * [IMPORTANT]
383      * ====
384      * You shouldn't rely on `isContract` to protect against flash loan attacks!
385      *
386      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
387      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
388      * constructor.
389      * ====
390      */
391     function isContract(address account) internal view returns (bool) {
392         // This method relies on extcodesize/address.code.length, which returns 0
393         // for contracts in construction, since the code is only stored at the end
394         // of the constructor execution.
395 
396         return account.code.length > 0;
397     }
398 
399     /**
400      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
401      * `recipient`, forwarding all available gas and reverting on errors.
402      *
403      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
404      * of certain opcodes, possibly making contracts go over the 2300 gas limit
405      * imposed by `transfer`, making them unable to receive funds via
406      * `transfer`. {sendValue} removes this limitation.
407      *
408      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
409      *
410      * IMPORTANT: because control is transferred to `recipient`, care must be
411      * taken to not create reentrancy vulnerabilities. Consider using
412      * {ReentrancyGuard} or the
413      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         (bool success, ) = recipient.call{value: amount}("");
419         require(success, "Address: unable to send value, recipient may have reverted");
420     }
421 
422     /**
423      * @dev Performs a Solidity function call using a low level `call`. A
424      * plain `call` is an unsafe replacement for a function call: use this
425      * function instead.
426      *
427      * If `target` reverts with a revert reason, it is bubbled up by this
428      * function (like regular Solidity function calls).
429      *
430      * Returns the raw returned data. To convert to the expected return value,
431      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
432      *
433      * Requirements:
434      *
435      * - `target` must be a contract.
436      * - calling `target` with `data` must not revert.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
446      * `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, 0, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but also transferring `value` wei to `target`.
461      *
462      * Requirements:
463      *
464      * - the calling contract must have an ETH balance of at least `value`.
465      * - the called Solidity function must be `payable`.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(
470         address target,
471         bytes memory data,
472         uint256 value
473     ) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
479      * with `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(address(this).balance >= value, "Address: insufficient balance for call");
490         (bool success, bytes memory returndata) = target.call{value: value}(data);
491         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
501         return functionStaticCall(target, data, "Address: low-level static call failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
506      * but performing a static call.
507      *
508      * _Available since v3.3._
509      */
510     function functionStaticCall(
511         address target,
512         bytes memory data,
513         string memory errorMessage
514     ) internal view returns (bytes memory) {
515         (bool success, bytes memory returndata) = target.staticcall(data);
516         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function functionDelegateCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
546      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
547      *
548      * _Available since v4.8._
549      */
550     function verifyCallResultFromTarget(
551         address target,
552         bool success,
553         bytes memory returndata,
554         string memory errorMessage
555     ) internal view returns (bytes memory) {
556         if (success) {
557             if (returndata.length == 0) {
558                 // only check isContract if the call was successful and the return data is empty
559                 // otherwise we already know that it was a contract
560                 require(isContract(target), "Address: call to non-contract");
561             }
562             return returndata;
563         } else {
564             _revert(returndata, errorMessage);
565         }
566     }
567 
568     /**
569      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
570      * revert reason or using the provided one.
571      *
572      * _Available since v4.3._
573      */
574     function verifyCallResult(
575         bool success,
576         bytes memory returndata,
577         string memory errorMessage
578     ) internal pure returns (bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             _revert(returndata, errorMessage);
583         }
584     }
585 
586     function _revert(bytes memory returndata, string memory errorMessage) private pure {
587         // Look for revert reason and bubble it up if present
588         if (returndata.length > 0) {
589             // The easiest way to bubble the revert reason is using memory via assembly
590             /// @solidity memory-safe-assembly
591             assembly {
592                 let returndata_size := mload(returndata)
593                 revert(add(32, returndata), returndata_size)
594             }
595         } else {
596             revert(errorMessage);
597         }
598     }
599 }
600 
601 
602 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Implementation of the {IERC165} interface.
611  *
612  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
613  * for the additional interface id that will be supported. For example:
614  *
615  * ```solidity
616  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
618  * }
619  * ```
620  *
621  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
622  */
623 abstract contract ERC165 is IERC165 {
624     /**
625      * @dev See {IERC165-supportsInterface}.
626      */
627     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628         return interfaceId == type(IERC165).interfaceId;
629     }
630 }
631 
632 
633 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1
634 
635 
636 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Standard math utilities missing in the Solidity language.
642  */
643 library Math {
644     enum Rounding {
645         Down, // Toward negative infinity
646         Up, // Toward infinity
647         Zero // Toward zero
648     }
649 
650     /**
651      * @dev Returns the largest of two numbers.
652      */
653     function max(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a > b ? a : b;
655     }
656 
657     /**
658      * @dev Returns the smallest of two numbers.
659      */
660     function min(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a < b ? a : b;
662     }
663 
664     /**
665      * @dev Returns the average of two numbers. The result is rounded towards
666      * zero.
667      */
668     function average(uint256 a, uint256 b) internal pure returns (uint256) {
669         // (a + b) / 2 can overflow.
670         return (a & b) + (a ^ b) / 2;
671     }
672 
673     /**
674      * @dev Returns the ceiling of the division of two numbers.
675      *
676      * This differs from standard division with `/` in that it rounds up instead
677      * of rounding down.
678      */
679     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
680         // (a + b - 1) / b can overflow on addition, so we distribute.
681         return a == 0 ? 0 : (a - 1) / b + 1;
682     }
683 
684     /**
685      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
686      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
687      * with further edits by Uniswap Labs also under MIT license.
688      */
689     function mulDiv(
690         uint256 x,
691         uint256 y,
692         uint256 denominator
693     ) internal pure returns (uint256 result) {
694         unchecked {
695             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
696             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
697             // variables such that product = prod1 * 2^256 + prod0.
698             uint256 prod0; // Least significant 256 bits of the product
699             uint256 prod1; // Most significant 256 bits of the product
700             assembly {
701                 let mm := mulmod(x, y, not(0))
702                 prod0 := mul(x, y)
703                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
704             }
705 
706             // Handle non-overflow cases, 256 by 256 division.
707             if (prod1 == 0) {
708                 return prod0 / denominator;
709             }
710 
711             // Make sure the result is less than 2^256. Also prevents denominator == 0.
712             require(denominator > prod1);
713 
714             ///////////////////////////////////////////////
715             // 512 by 256 division.
716             ///////////////////////////////////////////////
717 
718             // Make division exact by subtracting the remainder from [prod1 prod0].
719             uint256 remainder;
720             assembly {
721                 // Compute remainder using mulmod.
722                 remainder := mulmod(x, y, denominator)
723 
724                 // Subtract 256 bit number from 512 bit number.
725                 prod1 := sub(prod1, gt(remainder, prod0))
726                 prod0 := sub(prod0, remainder)
727             }
728 
729             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
730             // See https://cs.stackexchange.com/q/138556/92363.
731 
732             // Does not overflow because the denominator cannot be zero at this stage in the function.
733             uint256 twos = denominator & (~denominator + 1);
734             assembly {
735                 // Divide denominator by twos.
736                 denominator := div(denominator, twos)
737 
738                 // Divide [prod1 prod0] by twos.
739                 prod0 := div(prod0, twos)
740 
741                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
742                 twos := add(div(sub(0, twos), twos), 1)
743             }
744 
745             // Shift in bits from prod1 into prod0.
746             prod0 |= prod1 * twos;
747 
748             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
749             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
750             // four bits. That is, denominator * inv = 1 mod 2^4.
751             uint256 inverse = (3 * denominator) ^ 2;
752 
753             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
754             // in modular arithmetic, doubling the correct bits in each step.
755             inverse *= 2 - denominator * inverse; // inverse mod 2^8
756             inverse *= 2 - denominator * inverse; // inverse mod 2^16
757             inverse *= 2 - denominator * inverse; // inverse mod 2^32
758             inverse *= 2 - denominator * inverse; // inverse mod 2^64
759             inverse *= 2 - denominator * inverse; // inverse mod 2^128
760             inverse *= 2 - denominator * inverse; // inverse mod 2^256
761 
762             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
763             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
764             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
765             // is no longer required.
766             result = prod0 * inverse;
767             return result;
768         }
769     }
770 
771     /**
772      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
773      */
774     function mulDiv(
775         uint256 x,
776         uint256 y,
777         uint256 denominator,
778         Rounding rounding
779     ) internal pure returns (uint256) {
780         uint256 result = mulDiv(x, y, denominator);
781         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
782             result += 1;
783         }
784         return result;
785     }
786 
787     /**
788      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
789      *
790      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
791      */
792     function sqrt(uint256 a) internal pure returns (uint256) {
793         if (a == 0) {
794             return 0;
795         }
796 
797         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
798         //
799         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
800         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
801         //
802         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
803         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
804         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
805         //
806         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
807         uint256 result = 1 << (log2(a) >> 1);
808 
809         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
810         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
811         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
812         // into the expected uint128 result.
813         unchecked {
814             result = (result + a / result) >> 1;
815             result = (result + a / result) >> 1;
816             result = (result + a / result) >> 1;
817             result = (result + a / result) >> 1;
818             result = (result + a / result) >> 1;
819             result = (result + a / result) >> 1;
820             result = (result + a / result) >> 1;
821             return min(result, a / result);
822         }
823     }
824 
825     /**
826      * @notice Calculates sqrt(a), following the selected rounding direction.
827      */
828     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
829         unchecked {
830             uint256 result = sqrt(a);
831             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
832         }
833     }
834 
835     /**
836      * @dev Return the log in base 2, rounded down, of a positive value.
837      * Returns 0 if given 0.
838      */
839     function log2(uint256 value) internal pure returns (uint256) {
840         uint256 result = 0;
841         unchecked {
842             if (value >> 128 > 0) {
843                 value >>= 128;
844                 result += 128;
845             }
846             if (value >> 64 > 0) {
847                 value >>= 64;
848                 result += 64;
849             }
850             if (value >> 32 > 0) {
851                 value >>= 32;
852                 result += 32;
853             }
854             if (value >> 16 > 0) {
855                 value >>= 16;
856                 result += 16;
857             }
858             if (value >> 8 > 0) {
859                 value >>= 8;
860                 result += 8;
861             }
862             if (value >> 4 > 0) {
863                 value >>= 4;
864                 result += 4;
865             }
866             if (value >> 2 > 0) {
867                 value >>= 2;
868                 result += 2;
869             }
870             if (value >> 1 > 0) {
871                 result += 1;
872             }
873         }
874         return result;
875     }
876 
877     /**
878      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
879      * Returns 0 if given 0.
880      */
881     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
882         unchecked {
883             uint256 result = log2(value);
884             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
885         }
886     }
887 
888     /**
889      * @dev Return the log in base 10, rounded down, of a positive value.
890      * Returns 0 if given 0.
891      */
892     function log10(uint256 value) internal pure returns (uint256) {
893         uint256 result = 0;
894         unchecked {
895             if (value >= 10**64) {
896                 value /= 10**64;
897                 result += 64;
898             }
899             if (value >= 10**32) {
900                 value /= 10**32;
901                 result += 32;
902             }
903             if (value >= 10**16) {
904                 value /= 10**16;
905                 result += 16;
906             }
907             if (value >= 10**8) {
908                 value /= 10**8;
909                 result += 8;
910             }
911             if (value >= 10**4) {
912                 value /= 10**4;
913                 result += 4;
914             }
915             if (value >= 10**2) {
916                 value /= 10**2;
917                 result += 2;
918             }
919             if (value >= 10**1) {
920                 result += 1;
921             }
922         }
923         return result;
924     }
925 
926     /**
927      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
928      * Returns 0 if given 0.
929      */
930     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
931         unchecked {
932             uint256 result = log10(value);
933             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
934         }
935     }
936 
937     /**
938      * @dev Return the log in base 256, rounded down, of a positive value.
939      * Returns 0 if given 0.
940      *
941      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
942      */
943     function log256(uint256 value) internal pure returns (uint256) {
944         uint256 result = 0;
945         unchecked {
946             if (value >> 128 > 0) {
947                 value >>= 128;
948                 result += 16;
949             }
950             if (value >> 64 > 0) {
951                 value >>= 64;
952                 result += 8;
953             }
954             if (value >> 32 > 0) {
955                 value >>= 32;
956                 result += 4;
957             }
958             if (value >> 16 > 0) {
959                 value >>= 16;
960                 result += 2;
961             }
962             if (value >> 8 > 0) {
963                 result += 1;
964             }
965         }
966         return result;
967     }
968 
969     /**
970      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
971      * Returns 0 if given 0.
972      */
973     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
974         unchecked {
975             uint256 result = log256(value);
976             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
977         }
978     }
979 }
980 
981 
982 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.1
983 
984 
985 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev String operations.
991  */
992 library Strings {
993     bytes16 private constant _SYMBOLS = "0123456789abcdef";
994     uint8 private constant _ADDRESS_LENGTH = 20;
995 
996     /**
997      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
998      */
999     function toString(uint256 value) internal pure returns (string memory) {
1000         unchecked {
1001             uint256 length = Math.log10(value) + 1;
1002             string memory buffer = new string(length);
1003             uint256 ptr;
1004             /// @solidity memory-safe-assembly
1005             assembly {
1006                 ptr := add(buffer, add(32, length))
1007             }
1008             while (true) {
1009                 ptr--;
1010                 /// @solidity memory-safe-assembly
1011                 assembly {
1012                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1013                 }
1014                 value /= 10;
1015                 if (value == 0) break;
1016             }
1017             return buffer;
1018         }
1019     }
1020 
1021     /**
1022      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1023      */
1024     function toHexString(uint256 value) internal pure returns (string memory) {
1025         unchecked {
1026             return toHexString(value, Math.log256(value) + 1);
1027         }
1028     }
1029 
1030     /**
1031      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1032      */
1033     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1034         bytes memory buffer = new bytes(2 * length + 2);
1035         buffer[0] = "0";
1036         buffer[1] = "x";
1037         for (uint256 i = 2 * length + 1; i > 1; --i) {
1038             buffer[i] = _SYMBOLS[value & 0xf];
1039             value >>= 4;
1040         }
1041         require(value == 0, "Strings: hex length insufficient");
1042         return string(buffer);
1043     }
1044 
1045     /**
1046      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1047      */
1048     function toHexString(address addr) internal pure returns (string memory) {
1049         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1050     }
1051 }
1052 
1053 
1054 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.1
1055 
1056 
1057 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 
1062 
1063 
1064 
1065 
1066 
1067 /**
1068  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1069  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1070  * {ERC721Enumerable}.
1071  */
1072 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1073     using Address for address;
1074     using Strings for uint256;
1075 
1076     // Token name
1077     string private _name;
1078 
1079     // Token symbol
1080     string private _symbol;
1081 
1082     // Mapping from token ID to owner address
1083     mapping(uint256 => address) private _owners;
1084 
1085     // Mapping owner address to token count
1086     mapping(address => uint256) private _balances;
1087 
1088     // Mapping from token ID to approved address
1089     mapping(uint256 => address) private _tokenApprovals;
1090 
1091     // Mapping from owner to operator approvals
1092     mapping(address => mapping(address => bool)) private _operatorApprovals;
1093 
1094     /**
1095      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1096      */
1097     constructor(string memory name_, string memory symbol_) {
1098         _name = name_;
1099         _symbol = symbol_;
1100     }
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1106         return
1107             interfaceId == type(IERC721).interfaceId ||
1108             interfaceId == type(IERC721Metadata).interfaceId ||
1109             super.supportsInterface(interfaceId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-balanceOf}.
1114      */
1115     function balanceOf(address owner) public view virtual override returns (uint256) {
1116         require(owner != address(0), "ERC721: address zero is not a valid owner");
1117         return _balances[owner];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-ownerOf}.
1122      */
1123     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1124         address owner = _ownerOf(tokenId);
1125         require(owner != address(0), "ERC721: invalid token ID");
1126         return owner;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-name}.
1131      */
1132     function name() public view virtual override returns (string memory) {
1133         return _name;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-symbol}.
1138      */
1139     function symbol() public view virtual override returns (string memory) {
1140         return _symbol;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-tokenURI}.
1145      */
1146     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1147         _requireMinted(tokenId);
1148 
1149         string memory baseURI = _baseURI();
1150         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1151     }
1152 
1153     /**
1154      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1155      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1156      * by default, can be overridden in child contracts.
1157      */
1158     function _baseURI() internal view virtual returns (string memory) {
1159         return "";
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-approve}.
1164      */
1165     function approve(address to, uint256 tokenId) public virtual override {
1166         address owner = ERC721.ownerOf(tokenId);
1167         require(to != owner, "ERC721: approval to current owner");
1168 
1169         require(
1170             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1171             "ERC721: approve caller is not token owner or approved for all"
1172         );
1173 
1174         _approve(to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-getApproved}.
1179      */
1180     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1181         _requireMinted(tokenId);
1182 
1183         return _tokenApprovals[tokenId];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-setApprovalForAll}.
1188      */
1189     function setApprovalForAll(address operator, bool approved) public virtual override {
1190         _setApprovalForAll(_msgSender(), operator, approved);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-isApprovedForAll}.
1195      */
1196     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1197         return _operatorApprovals[owner][operator];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-transferFrom}.
1202      */
1203     function transferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) public virtual override {
1208         //solhint-disable-next-line max-line-length
1209         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1210 
1211         _transfer(from, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         safeTransferFrom(from, to, tokenId, "");
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-safeTransferFrom}.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory data
1233     ) public virtual override {
1234         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1235         _safeTransfer(from, to, tokenId, data);
1236     }
1237 
1238     /**
1239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1241      *
1242      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1243      *
1244      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1245      * implement alternative mechanisms to perform token transfer, such as signature-based.
1246      *
1247      * Requirements:
1248      *
1249      * - `from` cannot be the zero address.
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must exist and be owned by `from`.
1252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _safeTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory data
1261     ) internal virtual {
1262         _transfer(from, to, tokenId);
1263         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1264     }
1265 
1266     /**
1267      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1268      */
1269     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1270         return _owners[tokenId];
1271     }
1272 
1273     /**
1274      * @dev Returns whether `tokenId` exists.
1275      *
1276      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1277      *
1278      * Tokens start existing when they are minted (`_mint`),
1279      * and stop existing when they are burned (`_burn`).
1280      */
1281     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1282         return _ownerOf(tokenId) != address(0);
1283     }
1284 
1285     /**
1286      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1287      *
1288      * Requirements:
1289      *
1290      * - `tokenId` must exist.
1291      */
1292     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1293         address owner = ERC721.ownerOf(tokenId);
1294         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1295     }
1296 
1297     /**
1298      * @dev Safely mints `tokenId` and transfers it to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `tokenId` must not exist.
1303      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _safeMint(address to, uint256 tokenId) internal virtual {
1308         _safeMint(to, tokenId, "");
1309     }
1310 
1311     /**
1312      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1313      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1314      */
1315     function _safeMint(
1316         address to,
1317         uint256 tokenId,
1318         bytes memory data
1319     ) internal virtual {
1320         _mint(to, tokenId);
1321         require(
1322             _checkOnERC721Received(address(0), to, tokenId, data),
1323             "ERC721: transfer to non ERC721Receiver implementer"
1324         );
1325     }
1326 
1327     /**
1328      * @dev Mints `tokenId` and transfers it to `to`.
1329      *
1330      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1331      *
1332      * Requirements:
1333      *
1334      * - `tokenId` must not exist.
1335      * - `to` cannot be the zero address.
1336      *
1337      * Emits a {Transfer} event.
1338      */
1339     function _mint(address to, uint256 tokenId) internal virtual {
1340         require(to != address(0), "ERC721: mint to the zero address");
1341         require(!_exists(tokenId), "ERC721: token already minted");
1342 
1343         _beforeTokenTransfer(address(0), to, tokenId, 1);
1344 
1345         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1346         require(!_exists(tokenId), "ERC721: token already minted");
1347 
1348         unchecked {
1349             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1350             // Given that tokens are minted one by one, it is impossible in practice that
1351             // this ever happens. Might change if we allow batch minting.
1352             // The ERC fails to describe this case.
1353             _balances[to] += 1;
1354         }
1355 
1356         _owners[tokenId] = to;
1357 
1358         emit Transfer(address(0), to, tokenId);
1359 
1360         _afterTokenTransfer(address(0), to, tokenId, 1);
1361     }
1362 
1363     /**
1364      * @dev Destroys `tokenId`.
1365      * The approval is cleared when the token is burned.
1366      * This is an internal function that does not check if the sender is authorized to operate on the token.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must exist.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function _burn(uint256 tokenId) internal virtual {
1375         address owner = ERC721.ownerOf(tokenId);
1376 
1377         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1378 
1379         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1380         owner = ERC721.ownerOf(tokenId);
1381 
1382         // Clear approvals
1383         delete _tokenApprovals[tokenId];
1384 
1385         unchecked {
1386             // Cannot overflow, as that would require more tokens to be burned/transferred
1387             // out than the owner initially received through minting and transferring in.
1388             _balances[owner] -= 1;
1389         }
1390         delete _owners[tokenId];
1391 
1392         emit Transfer(owner, address(0), tokenId);
1393 
1394         _afterTokenTransfer(owner, address(0), tokenId, 1);
1395     }
1396 
1397     /**
1398      * @dev Transfers `tokenId` from `from` to `to`.
1399      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1400      *
1401      * Requirements:
1402      *
1403      * - `to` cannot be the zero address.
1404      * - `tokenId` token must be owned by `from`.
1405      *
1406      * Emits a {Transfer} event.
1407      */
1408     function _transfer(
1409         address from,
1410         address to,
1411         uint256 tokenId
1412     ) internal virtual {
1413         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1414         require(to != address(0), "ERC721: transfer to the zero address");
1415 
1416         _beforeTokenTransfer(from, to, tokenId, 1);
1417 
1418         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1419         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1420 
1421         // Clear approvals from the previous owner
1422         delete _tokenApprovals[tokenId];
1423 
1424         unchecked {
1425             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1426             // `from`'s balance is the number of token held, which is at least one before the current
1427             // transfer.
1428             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1429             // all 2**256 token ids to be minted, which in practice is impossible.
1430             _balances[from] -= 1;
1431             _balances[to] += 1;
1432         }
1433         _owners[tokenId] = to;
1434 
1435         emit Transfer(from, to, tokenId);
1436 
1437         _afterTokenTransfer(from, to, tokenId, 1);
1438     }
1439 
1440     /**
1441      * @dev Approve `to` to operate on `tokenId`
1442      *
1443      * Emits an {Approval} event.
1444      */
1445     function _approve(address to, uint256 tokenId) internal virtual {
1446         _tokenApprovals[tokenId] = to;
1447         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev Approve `operator` to operate on all of `owner` tokens
1452      *
1453      * Emits an {ApprovalForAll} event.
1454      */
1455     function _setApprovalForAll(
1456         address owner,
1457         address operator,
1458         bool approved
1459     ) internal virtual {
1460         require(owner != operator, "ERC721: approve to caller");
1461         _operatorApprovals[owner][operator] = approved;
1462         emit ApprovalForAll(owner, operator, approved);
1463     }
1464 
1465     /**
1466      * @dev Reverts if the `tokenId` has not been minted yet.
1467      */
1468     function _requireMinted(uint256 tokenId) internal view virtual {
1469         require(_exists(tokenId), "ERC721: invalid token ID");
1470     }
1471 
1472     /**
1473      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1474      * The call is not executed if the target address is not a contract.
1475      *
1476      * @param from address representing the previous owner of the given token ID
1477      * @param to target address that will receive the tokens
1478      * @param tokenId uint256 ID of the token to be transferred
1479      * @param data bytes optional data to send along with the call
1480      * @return bool whether the call correctly returned the expected magic value
1481      */
1482     function _checkOnERC721Received(
1483         address from,
1484         address to,
1485         uint256 tokenId,
1486         bytes memory data
1487     ) private returns (bool) {
1488         if (to.isContract()) {
1489             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1490                 return retval == IERC721Receiver.onERC721Received.selector;
1491             } catch (bytes memory reason) {
1492                 if (reason.length == 0) {
1493                     revert("ERC721: transfer to non ERC721Receiver implementer");
1494                 } else {
1495                     /// @solidity memory-safe-assembly
1496                     assembly {
1497                         revert(add(32, reason), mload(reason))
1498                     }
1499                 }
1500             }
1501         } else {
1502             return true;
1503         }
1504     }
1505 
1506     /**
1507      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1508      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1509      *
1510      * Calling conditions:
1511      *
1512      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1513      * - When `from` is zero, the tokens will be minted for `to`.
1514      * - When `to` is zero, ``from``'s tokens will be burned.
1515      * - `from` and `to` are never both zero.
1516      * - `batchSize` is non-zero.
1517      *
1518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1519      */
1520     function _beforeTokenTransfer(
1521         address from,
1522         address to,
1523         uint256, /* firstTokenId */
1524         uint256 batchSize
1525     ) internal virtual {
1526         if (batchSize > 1) {
1527             if (from != address(0)) {
1528                 _balances[from] -= batchSize;
1529             }
1530             if (to != address(0)) {
1531                 _balances[to] += batchSize;
1532             }
1533         }
1534     }
1535 
1536     /**
1537      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1538      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1543      * - When `from` is zero, the tokens were minted for `to`.
1544      * - When `to` is zero, ``from``'s tokens were burned.
1545      * - `from` and `to` are never both zero.
1546      * - `batchSize` is non-zero.
1547      *
1548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1549      */
1550     function _afterTokenTransfer(
1551         address from,
1552         address to,
1553         uint256 firstTokenId,
1554         uint256 batchSize
1555     ) internal virtual {}
1556 }
1557 
1558 
1559 // File erc721a/contracts/IERC721A.sol@v4.2.3
1560 
1561 
1562 // ERC721A Contracts v4.2.3
1563 // Creator: Chiru Labs
1564 
1565 pragma solidity ^0.8.4;
1566 
1567 /**
1568  * @dev Interface of ERC721A.
1569  */
1570 interface IERC721A {
1571     /**
1572      * The caller must own the token or be an approved operator.
1573      */
1574     error ApprovalCallerNotOwnerNorApproved();
1575 
1576     /**
1577      * The token does not exist.
1578      */
1579     error ApprovalQueryForNonexistentToken();
1580 
1581     /**
1582      * Cannot query the balance for the zero address.
1583      */
1584     error BalanceQueryForZeroAddress();
1585 
1586     /**
1587      * Cannot mint to the zero address.
1588      */
1589     error MintToZeroAddress();
1590 
1591     /**
1592      * The quantity of tokens minted must be more than zero.
1593      */
1594     error MintZeroQuantity();
1595 
1596     /**
1597      * The token does not exist.
1598      */
1599     error OwnerQueryForNonexistentToken();
1600 
1601     /**
1602      * The caller must own the token or be an approved operator.
1603      */
1604     error TransferCallerNotOwnerNorApproved();
1605 
1606     /**
1607      * The token must be owned by `from`.
1608      */
1609     error TransferFromIncorrectOwner();
1610 
1611     /**
1612      * Cannot safely transfer to a contract that does not implement the
1613      * ERC721Receiver interface.
1614      */
1615     error TransferToNonERC721ReceiverImplementer();
1616 
1617     /**
1618      * Cannot transfer to the zero address.
1619      */
1620     error TransferToZeroAddress();
1621 
1622     /**
1623      * The token does not exist.
1624      */
1625     error URIQueryForNonexistentToken();
1626 
1627     /**
1628      * The `quantity` minted with ERC2309 exceeds the safety limit.
1629      */
1630     error MintERC2309QuantityExceedsLimit();
1631 
1632     /**
1633      * The `extraData` cannot be set on an unintialized ownership slot.
1634      */
1635     error OwnershipNotInitializedForExtraData();
1636 
1637     // =============================================================
1638     //                            STRUCTS
1639     // =============================================================
1640 
1641     struct TokenOwnership {
1642         // The address of the owner.
1643         address addr;
1644         // Stores the start time of ownership with minimal overhead for tokenomics.
1645         uint64 startTimestamp;
1646         // Whether the token has been burned.
1647         bool burned;
1648         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1649         uint24 extraData;
1650     }
1651 
1652     // =============================================================
1653     //                         TOKEN COUNTERS
1654     // =============================================================
1655 
1656     /**
1657      * @dev Returns the total number of tokens in existence.
1658      * Burned tokens will reduce the count.
1659      * To get the total number of tokens minted, please see {_totalMinted}.
1660      */
1661     function totalSupply() external view returns (uint256);
1662 
1663     // =============================================================
1664     //                            IERC165
1665     // =============================================================
1666 
1667     /**
1668      * @dev Returns true if this contract implements the interface defined by
1669      * `interfaceId`. See the corresponding
1670      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1671      * to learn more about how these ids are created.
1672      *
1673      * This function call must use less than 30000 gas.
1674      */
1675     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1676 
1677     // =============================================================
1678     //                            IERC721
1679     // =============================================================
1680 
1681     /**
1682      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1683      */
1684     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1685 
1686     /**
1687      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1688      */
1689     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1690 
1691     /**
1692      * @dev Emitted when `owner` enables or disables
1693      * (`approved`) `operator` to manage all of its assets.
1694      */
1695     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1696 
1697     /**
1698      * @dev Returns the number of tokens in `owner`'s account.
1699      */
1700     function balanceOf(address owner) external view returns (uint256 balance);
1701 
1702     /**
1703      * @dev Returns the owner of the `tokenId` token.
1704      *
1705      * Requirements:
1706      *
1707      * - `tokenId` must exist.
1708      */
1709     function ownerOf(uint256 tokenId) external view returns (address owner);
1710 
1711     /**
1712      * @dev Safely transfers `tokenId` token from `from` to `to`,
1713      * checking first that contract recipients are aware of the ERC721 protocol
1714      * to prevent tokens from being forever locked.
1715      *
1716      * Requirements:
1717      *
1718      * - `from` cannot be the zero address.
1719      * - `to` cannot be the zero address.
1720      * - `tokenId` token must exist and be owned by `from`.
1721      * - If the caller is not `from`, it must be have been allowed to move
1722      * this token by either {approve} or {setApprovalForAll}.
1723      * - If `to` refers to a smart contract, it must implement
1724      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1725      *
1726      * Emits a {Transfer} event.
1727      */
1728     function safeTransferFrom(
1729         address from,
1730         address to,
1731         uint256 tokenId,
1732         bytes calldata data
1733     ) external payable;
1734 
1735     /**
1736      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1737      */
1738     function safeTransferFrom(
1739         address from,
1740         address to,
1741         uint256 tokenId
1742     ) external payable;
1743 
1744     /**
1745      * @dev Transfers `tokenId` from `from` to `to`.
1746      *
1747      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1748      * whenever possible.
1749      *
1750      * Requirements:
1751      *
1752      * - `from` cannot be the zero address.
1753      * - `to` cannot be the zero address.
1754      * - `tokenId` token must be owned by `from`.
1755      * - If the caller is not `from`, it must be approved to move this token
1756      * by either {approve} or {setApprovalForAll}.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function transferFrom(
1761         address from,
1762         address to,
1763         uint256 tokenId
1764     ) external payable;
1765 
1766     /**
1767      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1768      * The approval is cleared when the token is transferred.
1769      *
1770      * Only a single account can be approved at a time, so approving the
1771      * zero address clears previous approvals.
1772      *
1773      * Requirements:
1774      *
1775      * - The caller must own the token or be an approved operator.
1776      * - `tokenId` must exist.
1777      *
1778      * Emits an {Approval} event.
1779      */
1780     function approve(address to, uint256 tokenId) external payable;
1781 
1782     /**
1783      * @dev Approve or remove `operator` as an operator for the caller.
1784      * Operators can call {transferFrom} or {safeTransferFrom}
1785      * for any token owned by the caller.
1786      *
1787      * Requirements:
1788      *
1789      * - The `operator` cannot be the caller.
1790      *
1791      * Emits an {ApprovalForAll} event.
1792      */
1793     function setApprovalForAll(address operator, bool _approved) external;
1794 
1795     /**
1796      * @dev Returns the account approved for `tokenId` token.
1797      *
1798      * Requirements:
1799      *
1800      * - `tokenId` must exist.
1801      */
1802     function getApproved(uint256 tokenId) external view returns (address operator);
1803 
1804     /**
1805      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1806      *
1807      * See {setApprovalForAll}.
1808      */
1809     function isApprovedForAll(address owner, address operator) external view returns (bool);
1810 
1811     // =============================================================
1812     //                        IERC721Metadata
1813     // =============================================================
1814 
1815     /**
1816      * @dev Returns the token collection name.
1817      */
1818     function name() external view returns (string memory);
1819 
1820     /**
1821      * @dev Returns the token collection symbol.
1822      */
1823     function symbol() external view returns (string memory);
1824 
1825     /**
1826      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1827      */
1828     function tokenURI(uint256 tokenId) external view returns (string memory);
1829 
1830     // =============================================================
1831     //                           IERC2309
1832     // =============================================================
1833 
1834     /**
1835      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1836      * (inclusive) is transferred from `from` to `to`, as defined in the
1837      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1838      *
1839      * See {_mintERC2309} for more details.
1840      */
1841     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1842 }
1843 
1844 
1845 // File erc721a/contracts/ERC721A.sol@v4.2.3
1846 
1847 
1848 // ERC721A Contracts v4.2.3
1849 // Creator: Chiru Labs
1850 
1851 pragma solidity ^0.8.4;
1852 
1853 /**
1854  * @dev Interface of ERC721 token receiver.
1855  */
1856 interface ERC721A__IERC721Receiver {
1857     function onERC721Received(
1858         address operator,
1859         address from,
1860         uint256 tokenId,
1861         bytes calldata data
1862     ) external returns (bytes4);
1863 }
1864 
1865 /**
1866  * @title ERC721A
1867  *
1868  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1869  * Non-Fungible Token Standard, including the Metadata extension.
1870  * Optimized for lower gas during batch mints.
1871  *
1872  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1873  * starting from `_startTokenId()`.
1874  *
1875  * Assumptions:
1876  *
1877  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1878  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1879  */
1880 contract ERC721A is IERC721A {
1881     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1882     struct TokenApprovalRef {
1883         address value;
1884     }
1885 
1886     // =============================================================
1887     //                           CONSTANTS
1888     // =============================================================
1889 
1890     // Mask of an entry in packed address data.
1891     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1892 
1893     // The bit position of `numberMinted` in packed address data.
1894     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1895 
1896     // The bit position of `numberBurned` in packed address data.
1897     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1898 
1899     // The bit position of `aux` in packed address data.
1900     uint256 private constant _BITPOS_AUX = 192;
1901 
1902     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1903     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1904 
1905     // The bit position of `startTimestamp` in packed ownership.
1906     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1907 
1908     // The bit mask of the `burned` bit in packed ownership.
1909     uint256 private constant _BITMASK_BURNED = 1 << 224;
1910 
1911     // The bit position of the `nextInitialized` bit in packed ownership.
1912     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1913 
1914     // The bit mask of the `nextInitialized` bit in packed ownership.
1915     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1916 
1917     // The bit position of `extraData` in packed ownership.
1918     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1919 
1920     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1921     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1922 
1923     // The mask of the lower 160 bits for addresses.
1924     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1925 
1926     // The maximum `quantity` that can be minted with {_mintERC2309}.
1927     // This limit is to prevent overflows on the address data entries.
1928     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1929     // is required to cause an overflow, which is unrealistic.
1930     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1931 
1932     // The `Transfer` event signature is given by:
1933     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1934     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1935         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1936 
1937     // =============================================================
1938     //                            STORAGE
1939     // =============================================================
1940 
1941     // The next token ID to be minted.
1942     uint256 private _currentIndex;
1943 
1944     // The number of tokens burned.
1945     uint256 private _burnCounter;
1946 
1947     // Token name
1948     string private _name;
1949 
1950     // Token symbol
1951     string private _symbol;
1952 
1953     // Mapping from token ID to ownership details
1954     // An empty struct value does not necessarily mean the token is unowned.
1955     // See {_packedOwnershipOf} implementation for details.
1956     //
1957     // Bits Layout:
1958     // - [0..159]   `addr`
1959     // - [160..223] `startTimestamp`
1960     // - [224]      `burned`
1961     // - [225]      `nextInitialized`
1962     // - [232..255] `extraData`
1963     mapping(uint256 => uint256) private _packedOwnerships;
1964 
1965     // Mapping owner address to address data.
1966     //
1967     // Bits Layout:
1968     // - [0..63]    `balance`
1969     // - [64..127]  `numberMinted`
1970     // - [128..191] `numberBurned`
1971     // - [192..255] `aux`
1972     mapping(address => uint256) private _packedAddressData;
1973 
1974     // Mapping from token ID to approved address.
1975     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1976 
1977     // Mapping from owner to operator approvals
1978     mapping(address => mapping(address => bool)) private _operatorApprovals;
1979 
1980     // =============================================================
1981     //                          CONSTRUCTOR
1982     // =============================================================
1983 
1984     constructor(string memory name_, string memory symbol_) {
1985         _name = name_;
1986         _symbol = symbol_;
1987         _currentIndex = _startTokenId();
1988     }
1989 
1990     // =============================================================
1991     //                   TOKEN COUNTING OPERATIONS
1992     // =============================================================
1993 
1994     /**
1995      * @dev Returns the starting token ID.
1996      * To change the starting token ID, please override this function.
1997      */
1998     function _startTokenId() internal view virtual returns (uint256) {
1999         return 0;
2000     }
2001 
2002     /**
2003      * @dev Returns the next token ID to be minted.
2004      */
2005     function _nextTokenId() internal view virtual returns (uint256) {
2006         return _currentIndex;
2007     }
2008 
2009     /**
2010      * @dev Returns the total number of tokens in existence.
2011      * Burned tokens will reduce the count.
2012      * To get the total number of tokens minted, please see {_totalMinted}.
2013      */
2014     function totalSupply() public view virtual override returns (uint256) {
2015         // Counter underflow is impossible as _burnCounter cannot be incremented
2016         // more than `_currentIndex - _startTokenId()` times.
2017         unchecked {
2018             return _currentIndex - _burnCounter - _startTokenId();
2019         }
2020     }
2021 
2022     /**
2023      * @dev Returns the total amount of tokens minted in the contract.
2024      */
2025     function _totalMinted() internal view virtual returns (uint256) {
2026         // Counter underflow is impossible as `_currentIndex` does not decrement,
2027         // and it is initialized to `_startTokenId()`.
2028         unchecked {
2029             return _currentIndex - _startTokenId();
2030         }
2031     }
2032 
2033     /**
2034      * @dev Returns the total number of tokens burned.
2035      */
2036     function _totalBurned() internal view virtual returns (uint256) {
2037         return _burnCounter;
2038     }
2039 
2040     // =============================================================
2041     //                    ADDRESS DATA OPERATIONS
2042     // =============================================================
2043 
2044     /**
2045      * @dev Returns the number of tokens in `owner`'s account.
2046      */
2047     function balanceOf(address owner) public view virtual override returns (uint256) {
2048         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2049         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2050     }
2051 
2052     /**
2053      * Returns the number of tokens minted by `owner`.
2054      */
2055     function _numberMinted(address owner) internal view returns (uint256) {
2056         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2057     }
2058 
2059     /**
2060      * Returns the number of tokens burned by or on behalf of `owner`.
2061      */
2062     function _numberBurned(address owner) internal view returns (uint256) {
2063         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2064     }
2065 
2066     /**
2067      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2068      */
2069     function _getAux(address owner) internal view returns (uint64) {
2070         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2071     }
2072 
2073     /**
2074      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2075      * If there are multiple variables, please pack them into a uint64.
2076      */
2077     function _setAux(address owner, uint64 aux) internal virtual {
2078         uint256 packed = _packedAddressData[owner];
2079         uint256 auxCasted;
2080         // Cast `aux` with assembly to avoid redundant masking.
2081         assembly {
2082             auxCasted := aux
2083         }
2084         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2085         _packedAddressData[owner] = packed;
2086     }
2087 
2088     // =============================================================
2089     //                            IERC165
2090     // =============================================================
2091 
2092     /**
2093      * @dev Returns true if this contract implements the interface defined by
2094      * `interfaceId`. See the corresponding
2095      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2096      * to learn more about how these ids are created.
2097      *
2098      * This function call must use less than 30000 gas.
2099      */
2100     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2101         // The interface IDs are constants representing the first 4 bytes
2102         // of the XOR of all function selectors in the interface.
2103         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2104         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2105         return
2106             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2107             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2108             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2109     }
2110 
2111     // =============================================================
2112     //                        IERC721Metadata
2113     // =============================================================
2114 
2115     /**
2116      * @dev Returns the token collection name.
2117      */
2118     function name() public view virtual override returns (string memory) {
2119         return _name;
2120     }
2121 
2122     /**
2123      * @dev Returns the token collection symbol.
2124      */
2125     function symbol() public view virtual override returns (string memory) {
2126         return _symbol;
2127     }
2128 
2129     /**
2130      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2131      */
2132     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2133         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2134 
2135         string memory baseURI = _baseURI();
2136         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2137     }
2138 
2139     /**
2140      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2141      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2142      * by default, it can be overridden in child contracts.
2143      */
2144     function _baseURI() internal view virtual returns (string memory) {
2145         return '';
2146     }
2147 
2148     // =============================================================
2149     //                     OWNERSHIPS OPERATIONS
2150     // =============================================================
2151 
2152     /**
2153      * @dev Returns the owner of the `tokenId` token.
2154      *
2155      * Requirements:
2156      *
2157      * - `tokenId` must exist.
2158      */
2159     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2160         return address(uint160(_packedOwnershipOf(tokenId)));
2161     }
2162 
2163     /**
2164      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2165      * It gradually moves to O(1) as tokens get transferred around over time.
2166      */
2167     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2168         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2169     }
2170 
2171     /**
2172      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2173      */
2174     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2175         return _unpackedOwnership(_packedOwnerships[index]);
2176     }
2177 
2178     /**
2179      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2180      */
2181     function _initializeOwnershipAt(uint256 index) internal virtual {
2182         if (_packedOwnerships[index] == 0) {
2183             _packedOwnerships[index] = _packedOwnershipOf(index);
2184         }
2185     }
2186 
2187     /**
2188      * Returns the packed ownership data of `tokenId`.
2189      */
2190     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2191         uint256 curr = tokenId;
2192 
2193         unchecked {
2194             if (_startTokenId() <= curr)
2195                 if (curr < _currentIndex) {
2196                     uint256 packed = _packedOwnerships[curr];
2197                     // If not burned.
2198                     if (packed & _BITMASK_BURNED == 0) {
2199                         // Invariant:
2200                         // There will always be an initialized ownership slot
2201                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2202                         // before an unintialized ownership slot
2203                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2204                         // Hence, `curr` will not underflow.
2205                         //
2206                         // We can directly compare the packed value.
2207                         // If the address is zero, packed will be zero.
2208                         while (packed == 0) {
2209                             packed = _packedOwnerships[--curr];
2210                         }
2211                         return packed;
2212                     }
2213                 }
2214         }
2215         revert OwnerQueryForNonexistentToken();
2216     }
2217 
2218     /**
2219      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2220      */
2221     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2222         ownership.addr = address(uint160(packed));
2223         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2224         ownership.burned = packed & _BITMASK_BURNED != 0;
2225         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2226     }
2227 
2228     /**
2229      * @dev Packs ownership data into a single uint256.
2230      */
2231     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2232         assembly {
2233             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2234             owner := and(owner, _BITMASK_ADDRESS)
2235             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2236             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2237         }
2238     }
2239 
2240     /**
2241      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2242      */
2243     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2244         // For branchless setting of the `nextInitialized` flag.
2245         assembly {
2246             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2247             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2248         }
2249     }
2250 
2251     // =============================================================
2252     //                      APPROVAL OPERATIONS
2253     // =============================================================
2254 
2255     /**
2256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2257      * The approval is cleared when the token is transferred.
2258      *
2259      * Only a single account can be approved at a time, so approving the
2260      * zero address clears previous approvals.
2261      *
2262      * Requirements:
2263      *
2264      * - The caller must own the token or be an approved operator.
2265      * - `tokenId` must exist.
2266      *
2267      * Emits an {Approval} event.
2268      */
2269     function approve(address to, uint256 tokenId) public payable virtual override {
2270         address owner = ownerOf(tokenId);
2271 
2272         if (_msgSenderERC721A() != owner)
2273             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2274                 revert ApprovalCallerNotOwnerNorApproved();
2275             }
2276 
2277         _tokenApprovals[tokenId].value = to;
2278         emit Approval(owner, to, tokenId);
2279     }
2280 
2281     /**
2282      * @dev Returns the account approved for `tokenId` token.
2283      *
2284      * Requirements:
2285      *
2286      * - `tokenId` must exist.
2287      */
2288     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2289         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2290 
2291         return _tokenApprovals[tokenId].value;
2292     }
2293 
2294     /**
2295      * @dev Approve or remove `operator` as an operator for the caller.
2296      * Operators can call {transferFrom} or {safeTransferFrom}
2297      * for any token owned by the caller.
2298      *
2299      * Requirements:
2300      *
2301      * - The `operator` cannot be the caller.
2302      *
2303      * Emits an {ApprovalForAll} event.
2304      */
2305     function setApprovalForAll(address operator, bool approved) public virtual override {
2306         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2307         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2308     }
2309 
2310     /**
2311      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2312      *
2313      * See {setApprovalForAll}.
2314      */
2315     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2316         return _operatorApprovals[owner][operator];
2317     }
2318 
2319     /**
2320      * @dev Returns whether `tokenId` exists.
2321      *
2322      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2323      *
2324      * Tokens start existing when they are minted. See {_mint}.
2325      */
2326     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2327         return
2328             _startTokenId() <= tokenId &&
2329             tokenId < _currentIndex && // If within bounds,
2330             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2331     }
2332 
2333     /**
2334      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2335      */
2336     function _isSenderApprovedOrOwner(
2337         address approvedAddress,
2338         address owner,
2339         address msgSender
2340     ) private pure returns (bool result) {
2341         assembly {
2342             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2343             owner := and(owner, _BITMASK_ADDRESS)
2344             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2345             msgSender := and(msgSender, _BITMASK_ADDRESS)
2346             // `msgSender == owner || msgSender == approvedAddress`.
2347             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2348         }
2349     }
2350 
2351     /**
2352      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2353      */
2354     function _getApprovedSlotAndAddress(uint256 tokenId)
2355         private
2356         view
2357         returns (uint256 approvedAddressSlot, address approvedAddress)
2358     {
2359         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2360         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2361         assembly {
2362             approvedAddressSlot := tokenApproval.slot
2363             approvedAddress := sload(approvedAddressSlot)
2364         }
2365     }
2366 
2367     // =============================================================
2368     //                      TRANSFER OPERATIONS
2369     // =============================================================
2370 
2371     /**
2372      * @dev Transfers `tokenId` from `from` to `to`.
2373      *
2374      * Requirements:
2375      *
2376      * - `from` cannot be the zero address.
2377      * - `to` cannot be the zero address.
2378      * - `tokenId` token must be owned by `from`.
2379      * - If the caller is not `from`, it must be approved to move this token
2380      * by either {approve} or {setApprovalForAll}.
2381      *
2382      * Emits a {Transfer} event.
2383      */
2384     function transferFrom(
2385         address from,
2386         address to,
2387         uint256 tokenId
2388     ) public payable virtual override {
2389         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2390 
2391         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2392 
2393         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2394 
2395         // The nested ifs save around 20+ gas over a compound boolean condition.
2396         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2397             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2398 
2399         if (to == address(0)) revert TransferToZeroAddress();
2400 
2401         _beforeTokenTransfers(from, to, tokenId, 1);
2402 
2403         // Clear approvals from the previous owner.
2404         assembly {
2405             if approvedAddress {
2406                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2407                 sstore(approvedAddressSlot, 0)
2408             }
2409         }
2410 
2411         // Underflow of the sender's balance is impossible because we check for
2412         // ownership above and the recipient's balance can't realistically overflow.
2413         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2414         unchecked {
2415             // We can directly increment and decrement the balances.
2416             --_packedAddressData[from]; // Updates: `balance -= 1`.
2417             ++_packedAddressData[to]; // Updates: `balance += 1`.
2418 
2419             // Updates:
2420             // - `address` to the next owner.
2421             // - `startTimestamp` to the timestamp of transfering.
2422             // - `burned` to `false`.
2423             // - `nextInitialized` to `true`.
2424             _packedOwnerships[tokenId] = _packOwnershipData(
2425                 to,
2426                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2427             );
2428 
2429             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2430             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2431                 uint256 nextTokenId = tokenId + 1;
2432                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2433                 if (_packedOwnerships[nextTokenId] == 0) {
2434                     // If the next slot is within bounds.
2435                     if (nextTokenId != _currentIndex) {
2436                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2437                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2438                     }
2439                 }
2440             }
2441         }
2442 
2443         emit Transfer(from, to, tokenId);
2444         _afterTokenTransfers(from, to, tokenId, 1);
2445     }
2446 
2447     /**
2448      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2449      */
2450     function safeTransferFrom(
2451         address from,
2452         address to,
2453         uint256 tokenId
2454     ) public payable virtual override {
2455         safeTransferFrom(from, to, tokenId, '');
2456     }
2457 
2458     /**
2459      * @dev Safely transfers `tokenId` token from `from` to `to`.
2460      *
2461      * Requirements:
2462      *
2463      * - `from` cannot be the zero address.
2464      * - `to` cannot be the zero address.
2465      * - `tokenId` token must exist and be owned by `from`.
2466      * - If the caller is not `from`, it must be approved to move this token
2467      * by either {approve} or {setApprovalForAll}.
2468      * - If `to` refers to a smart contract, it must implement
2469      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2470      *
2471      * Emits a {Transfer} event.
2472      */
2473     function safeTransferFrom(
2474         address from,
2475         address to,
2476         uint256 tokenId,
2477         bytes memory _data
2478     ) public payable virtual override {
2479         transferFrom(from, to, tokenId);
2480         if (to.code.length != 0)
2481             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2482                 revert TransferToNonERC721ReceiverImplementer();
2483             }
2484     }
2485 
2486     /**
2487      * @dev Hook that is called before a set of serially-ordered token IDs
2488      * are about to be transferred. This includes minting.
2489      * And also called before burning one token.
2490      *
2491      * `startTokenId` - the first token ID to be transferred.
2492      * `quantity` - the amount to be transferred.
2493      *
2494      * Calling conditions:
2495      *
2496      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2497      * transferred to `to`.
2498      * - When `from` is zero, `tokenId` will be minted for `to`.
2499      * - When `to` is zero, `tokenId` will be burned by `from`.
2500      * - `from` and `to` are never both zero.
2501      */
2502     function _beforeTokenTransfers(
2503         address from,
2504         address to,
2505         uint256 startTokenId,
2506         uint256 quantity
2507     ) internal virtual {}
2508 
2509     /**
2510      * @dev Hook that is called after a set of serially-ordered token IDs
2511      * have been transferred. This includes minting.
2512      * And also called after one token has been burned.
2513      *
2514      * `startTokenId` - the first token ID to be transferred.
2515      * `quantity` - the amount to be transferred.
2516      *
2517      * Calling conditions:
2518      *
2519      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2520      * transferred to `to`.
2521      * - When `from` is zero, `tokenId` has been minted for `to`.
2522      * - When `to` is zero, `tokenId` has been burned by `from`.
2523      * - `from` and `to` are never both zero.
2524      */
2525     function _afterTokenTransfers(
2526         address from,
2527         address to,
2528         uint256 startTokenId,
2529         uint256 quantity
2530     ) internal virtual {}
2531 
2532     /**
2533      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2534      *
2535      * `from` - Previous owner of the given token ID.
2536      * `to` - Target address that will receive the token.
2537      * `tokenId` - Token ID to be transferred.
2538      * `_data` - Optional data to send along with the call.
2539      *
2540      * Returns whether the call correctly returned the expected magic value.
2541      */
2542     function _checkContractOnERC721Received(
2543         address from,
2544         address to,
2545         uint256 tokenId,
2546         bytes memory _data
2547     ) private returns (bool) {
2548         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2549             bytes4 retval
2550         ) {
2551             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2552         } catch (bytes memory reason) {
2553             if (reason.length == 0) {
2554                 revert TransferToNonERC721ReceiverImplementer();
2555             } else {
2556                 assembly {
2557                     revert(add(32, reason), mload(reason))
2558                 }
2559             }
2560         }
2561     }
2562 
2563     // =============================================================
2564     //                        MINT OPERATIONS
2565     // =============================================================
2566 
2567     /**
2568      * @dev Mints `quantity` tokens and transfers them to `to`.
2569      *
2570      * Requirements:
2571      *
2572      * - `to` cannot be the zero address.
2573      * - `quantity` must be greater than 0.
2574      *
2575      * Emits a {Transfer} event for each mint.
2576      */
2577     function _mint(address to, uint256 quantity) internal virtual {
2578         uint256 startTokenId = _currentIndex;
2579         if (quantity == 0) revert MintZeroQuantity();
2580 
2581         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2582 
2583         // Overflows are incredibly unrealistic.
2584         // `balance` and `numberMinted` have a maximum limit of 2**64.
2585         // `tokenId` has a maximum limit of 2**256.
2586         unchecked {
2587             // Updates:
2588             // - `balance += quantity`.
2589             // - `numberMinted += quantity`.
2590             //
2591             // We can directly add to the `balance` and `numberMinted`.
2592             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2593 
2594             // Updates:
2595             // - `address` to the owner.
2596             // - `startTimestamp` to the timestamp of minting.
2597             // - `burned` to `false`.
2598             // - `nextInitialized` to `quantity == 1`.
2599             _packedOwnerships[startTokenId] = _packOwnershipData(
2600                 to,
2601                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2602             );
2603 
2604             uint256 toMasked;
2605             uint256 end = startTokenId + quantity;
2606 
2607             // Use assembly to loop and emit the `Transfer` event for gas savings.
2608             // The duplicated `log4` removes an extra check and reduces stack juggling.
2609             // The assembly, together with the surrounding Solidity code, have been
2610             // delicately arranged to nudge the compiler into producing optimized opcodes.
2611             assembly {
2612                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2613                 toMasked := and(to, _BITMASK_ADDRESS)
2614                 // Emit the `Transfer` event.
2615                 log4(
2616                     0, // Start of data (0, since no data).
2617                     0, // End of data (0, since no data).
2618                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2619                     0, // `address(0)`.
2620                     toMasked, // `to`.
2621                     startTokenId // `tokenId`.
2622                 )
2623 
2624                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2625                 // that overflows uint256 will make the loop run out of gas.
2626                 // The compiler will optimize the `iszero` away for performance.
2627                 for {
2628                     let tokenId := add(startTokenId, 1)
2629                 } iszero(eq(tokenId, end)) {
2630                     tokenId := add(tokenId, 1)
2631                 } {
2632                     // Emit the `Transfer` event. Similar to above.
2633                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2634                 }
2635             }
2636             if (toMasked == 0) revert MintToZeroAddress();
2637 
2638             _currentIndex = end;
2639         }
2640         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2641     }
2642 
2643     /**
2644      * @dev Mints `quantity` tokens and transfers them to `to`.
2645      *
2646      * This function is intended for efficient minting only during contract creation.
2647      *
2648      * It emits only one {ConsecutiveTransfer} as defined in
2649      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2650      * instead of a sequence of {Transfer} event(s).
2651      *
2652      * Calling this function outside of contract creation WILL make your contract
2653      * non-compliant with the ERC721 standard.
2654      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2655      * {ConsecutiveTransfer} event is only permissible during contract creation.
2656      *
2657      * Requirements:
2658      *
2659      * - `to` cannot be the zero address.
2660      * - `quantity` must be greater than 0.
2661      *
2662      * Emits a {ConsecutiveTransfer} event.
2663      */
2664     function _mintERC2309(address to, uint256 quantity) internal virtual {
2665         uint256 startTokenId = _currentIndex;
2666         if (to == address(0)) revert MintToZeroAddress();
2667         if (quantity == 0) revert MintZeroQuantity();
2668         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2669 
2670         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2671 
2672         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2673         unchecked {
2674             // Updates:
2675             // - `balance += quantity`.
2676             // - `numberMinted += quantity`.
2677             //
2678             // We can directly add to the `balance` and `numberMinted`.
2679             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2680 
2681             // Updates:
2682             // - `address` to the owner.
2683             // - `startTimestamp` to the timestamp of minting.
2684             // - `burned` to `false`.
2685             // - `nextInitialized` to `quantity == 1`.
2686             _packedOwnerships[startTokenId] = _packOwnershipData(
2687                 to,
2688                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2689             );
2690 
2691             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2692 
2693             _currentIndex = startTokenId + quantity;
2694         }
2695         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2696     }
2697 
2698     /**
2699      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2700      *
2701      * Requirements:
2702      *
2703      * - If `to` refers to a smart contract, it must implement
2704      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2705      * - `quantity` must be greater than 0.
2706      *
2707      * See {_mint}.
2708      *
2709      * Emits a {Transfer} event for each mint.
2710      */
2711     function _safeMint(
2712         address to,
2713         uint256 quantity,
2714         bytes memory _data
2715     ) internal virtual {
2716         _mint(to, quantity);
2717 
2718         unchecked {
2719             if (to.code.length != 0) {
2720                 uint256 end = _currentIndex;
2721                 uint256 index = end - quantity;
2722                 do {
2723                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2724                         revert TransferToNonERC721ReceiverImplementer();
2725                     }
2726                 } while (index < end);
2727                 // Reentrancy protection.
2728                 if (_currentIndex != end) revert();
2729             }
2730         }
2731     }
2732 
2733     /**
2734      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2735      */
2736     function _safeMint(address to, uint256 quantity) internal virtual {
2737         _safeMint(to, quantity, '');
2738     }
2739 
2740     // =============================================================
2741     //                        BURN OPERATIONS
2742     // =============================================================
2743 
2744     /**
2745      * @dev Equivalent to `_burn(tokenId, false)`.
2746      */
2747     function _burn(uint256 tokenId) internal virtual {
2748         _burn(tokenId, false);
2749     }
2750 
2751     /**
2752      * @dev Destroys `tokenId`.
2753      * The approval is cleared when the token is burned.
2754      *
2755      * Requirements:
2756      *
2757      * - `tokenId` must exist.
2758      *
2759      * Emits a {Transfer} event.
2760      */
2761     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2762         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2763 
2764         address from = address(uint160(prevOwnershipPacked));
2765 
2766         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2767 
2768         if (approvalCheck) {
2769             // The nested ifs save around 20+ gas over a compound boolean condition.
2770             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2771                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2772         }
2773 
2774         _beforeTokenTransfers(from, address(0), tokenId, 1);
2775 
2776         // Clear approvals from the previous owner.
2777         assembly {
2778             if approvedAddress {
2779                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2780                 sstore(approvedAddressSlot, 0)
2781             }
2782         }
2783 
2784         // Underflow of the sender's balance is impossible because we check for
2785         // ownership above and the recipient's balance can't realistically overflow.
2786         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2787         unchecked {
2788             // Updates:
2789             // - `balance -= 1`.
2790             // - `numberBurned += 1`.
2791             //
2792             // We can directly decrement the balance, and increment the number burned.
2793             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2794             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2795 
2796             // Updates:
2797             // - `address` to the last owner.
2798             // - `startTimestamp` to the timestamp of burning.
2799             // - `burned` to `true`.
2800             // - `nextInitialized` to `true`.
2801             _packedOwnerships[tokenId] = _packOwnershipData(
2802                 from,
2803                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2804             );
2805 
2806             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2807             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2808                 uint256 nextTokenId = tokenId + 1;
2809                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2810                 if (_packedOwnerships[nextTokenId] == 0) {
2811                     // If the next slot is within bounds.
2812                     if (nextTokenId != _currentIndex) {
2813                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2814                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2815                     }
2816                 }
2817             }
2818         }
2819 
2820         emit Transfer(from, address(0), tokenId);
2821         _afterTokenTransfers(from, address(0), tokenId, 1);
2822 
2823         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2824         unchecked {
2825             _burnCounter++;
2826         }
2827     }
2828 
2829     // =============================================================
2830     //                     EXTRA DATA OPERATIONS
2831     // =============================================================
2832 
2833     /**
2834      * @dev Directly sets the extra data for the ownership data `index`.
2835      */
2836     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2837         uint256 packed = _packedOwnerships[index];
2838         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2839         uint256 extraDataCasted;
2840         // Cast `extraData` with assembly to avoid redundant masking.
2841         assembly {
2842             extraDataCasted := extraData
2843         }
2844         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2845         _packedOwnerships[index] = packed;
2846     }
2847 
2848     /**
2849      * @dev Called during each token transfer to set the 24bit `extraData` field.
2850      * Intended to be overridden by the cosumer contract.
2851      *
2852      * `previousExtraData` - the value of `extraData` before transfer.
2853      *
2854      * Calling conditions:
2855      *
2856      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2857      * transferred to `to`.
2858      * - When `from` is zero, `tokenId` will be minted for `to`.
2859      * - When `to` is zero, `tokenId` will be burned by `from`.
2860      * - `from` and `to` are never both zero.
2861      */
2862     function _extraData(
2863         address from,
2864         address to,
2865         uint24 previousExtraData
2866     ) internal view virtual returns (uint24) {}
2867 
2868     /**
2869      * @dev Returns the next extra data for the packed ownership data.
2870      * The returned result is shifted into position.
2871      */
2872     function _nextExtraData(
2873         address from,
2874         address to,
2875         uint256 prevOwnershipPacked
2876     ) private view returns (uint256) {
2877         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2878         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2879     }
2880 
2881     // =============================================================
2882     //                       OTHER OPERATIONS
2883     // =============================================================
2884 
2885     /**
2886      * @dev Returns the message sender (defaults to `msg.sender`).
2887      *
2888      * If you are writing GSN compatible contracts, you need to override this function.
2889      */
2890     function _msgSenderERC721A() internal view virtual returns (address) {
2891         return msg.sender;
2892     }
2893 
2894     /**
2895      * @dev Converts a uint256 to its ASCII string decimal representation.
2896      */
2897     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2898         assembly {
2899             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2900             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2901             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2902             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2903             let m := add(mload(0x40), 0xa0)
2904             // Update the free memory pointer to allocate.
2905             mstore(0x40, m)
2906             // Assign the `str` to the end.
2907             str := sub(m, 0x20)
2908             // Zeroize the slot after the string.
2909             mstore(str, 0)
2910 
2911             // Cache the end of the memory to calculate the length later.
2912             let end := str
2913 
2914             // We write the string from rightmost digit to leftmost digit.
2915             // The following is essentially a do-while loop that also handles the zero case.
2916             // prettier-ignore
2917             for { let temp := value } 1 {} {
2918                 str := sub(str, 1)
2919                 // Write the character to the pointer.
2920                 // The ASCII index of the '0' character is 48.
2921                 mstore8(str, add(48, mod(temp, 10)))
2922                 // Keep dividing `temp` until zero.
2923                 temp := div(temp, 10)
2924                 // prettier-ignore
2925                 if iszero(temp) { break }
2926             }
2927 
2928             let length := sub(end, str)
2929             // Move the pointer 32 bytes leftwards to make room for the length.
2930             str := sub(str, 0x20)
2931             // Store the length.
2932             mstore(str, length)
2933         }
2934     }
2935 }
2936 
2937 
2938 // File contracts/BonglerNFT.sol
2939 
2940 
2941 
2942 pragma solidity ^0.8.17;
2943 
2944 
2945 
2946 contract BonglerNFT is ERC721A, Ownable {
2947     uint256 public mintPrice = 0.042 ether;
2948 
2949     bool public saleIsActive = false;
2950 
2951     uint256 public maxPerAddressDuringMint = 5;
2952     string private _baseTokenURI;
2953 
2954     uint256 public maxSupply = 420;
2955     mapping(address => bool) public mintedFree;
2956 
2957     constructor() ERC721A("Bongler", "BNGLR") {}
2958 
2959     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
2960         _safeMint(msg.sender, numberOfTokens);
2961         require(totalSupply() <= maxSupply, "Limit reached");
2962     }
2963 
2964     function flipSaleState() public onlyOwner {
2965         saleIsActive = !saleIsActive;
2966     }
2967 
2968     function setMintPrice(uint256 newPrice) public onlyOwner {
2969         mintPrice = newPrice;
2970     }
2971 
2972     function _baseURI() internal view virtual override returns (string memory) {
2973         return _baseTokenURI;
2974     }
2975 
2976     function setBaseURI(string calldata baseURI) external onlyOwner {
2977         _baseTokenURI = baseURI;
2978     }
2979 
2980     function mint(uint256 quantity) external payable {
2981         require(saleIsActive, "Sale must be active to mint");
2982         require(quantity <= maxPerAddressDuringMint, "amount to hi");
2983 
2984         require(mintPrice * quantity <= msg.value, "price to hi men");
2985 
2986         _mint(msg.sender, quantity);
2987         require(totalSupply() <= maxSupply, "Limit reached");
2988     }
2989 
2990     function freeMint() external payable {
2991         require(saleIsActive, "Sale must be active to mint");
2992 
2993         require(
2994             isAFriend(msg.sender),
2995             "This wallet doesn't hold any friend NFTs"
2996         );
2997         require(
2998             mintedFree[msg.sender] == false,
2999             "You can only mint 1 for free"
3000         );
3001 
3002         mintedFree[msg.sender] = true;
3003         _mint(msg.sender, 1);
3004 
3005         require(totalSupply() <= maxSupply, "Limit reached");
3006     }
3007 
3008     function isAFriend(address addr) public view returns (bool) {
3009         address milady = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
3010         address bonkler = 0xABFaE8A54e6817F57F9De7796044E9a60e61ad67;
3011         address remilio = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
3012         address janklerz = 0xEB3B0Ac9E4829a92E964e723EfDa9104ce0dE5Ec;
3013         address weedz = 0xcD96d928Feb9ba8dd530FAF0515b49EEFfC6C815;
3014         address adworld = 0x62eb144FE92Ddc1B10bCAde03A0C09f6FBffBffb;
3015 
3016         return
3017             ERC721(milady).balanceOf(addr) > 0 ||
3018             ERC721(bonkler).balanceOf(addr) > 0 ||
3019             ERC721(remilio).balanceOf(addr) > 0 ||
3020             ERC721(janklerz).balanceOf(addr) > 0 ||
3021             ERC721(weedz).balanceOf(addr) > 0 ||
3022             ERC721(adworld).balanceOf(addr) > 0;
3023     }
3024 
3025     function hitBlunt() external onlyOwner {
3026         (bool success, ) = owner().call{value: address(this).balance}("");
3027         require(success, "Transfer failed.");
3028     }
3029 }