1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
114      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
115      * understand this adds an external call which potentially creates a reentrancy vulnerability.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
206 
207 
208 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Enumerable is IERC721 {
218     /**
219      * @dev Returns the total amount of tokens stored by the contract.
220      */
221     function totalSupply() external view returns (uint256);
222 
223     /**
224      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
225      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
226      */
227     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
228 
229     /**
230      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
231      * Use along with {totalSupply} to enumerate all tokens.
232      */
233     function tokenByIndex(uint256 index) external view returns (uint256);
234 }
235 
236 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 
244 /**
245  * @dev Implementation of the {IERC165} interface.
246  *
247  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
248  * for the additional interface id that will be supported. For example:
249  *
250  * ```solidity
251  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
252  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
253  * }
254  * ```
255  *
256  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
257  */
258 abstract contract ERC165 is IERC165 {
259     /**
260      * @dev See {IERC165-supportsInterface}.
261      */
262     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
263         return interfaceId == type(IERC165).interfaceId;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
268 
269 
270 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @title ERC721 token receiver interface
276  * @dev Interface for any contract that wants to support safeTransfers
277  * from ERC721 asset contracts.
278  */
279 interface IERC721Receiver {
280     /**
281      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
282      * by `operator` from `from`, this function is called.
283      *
284      * It must return its Solidity selector to confirm the token transfer.
285      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
286      *
287      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
288      */
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 // File: @openzeppelin/contracts/utils/Context.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         return msg.data;
321     }
322 }
323 
324 // File: @openzeppelin/contracts/access/Ownable.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Contract module which provides a basic access control mechanism, where
334  * there is an account (an owner) that can be granted exclusive access to
335  * specific functions.
336  *
337  * By default, the owner account will be the one that deploys the contract. This
338  * can later be changed with {transferOwnership}.
339  *
340  * This module is used through inheritance. It will make available the modifier
341  * `onlyOwner`, which can be applied to your functions to restrict their use to
342  * the owner.
343  */
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     /**
350      * @dev Initializes the contract setting the deployer as the initial owner.
351      */
352     constructor() {
353         _transferOwnership(_msgSender());
354     }
355 
356     /**
357      * @dev Throws if called by any account other than the owner.
358      */
359     modifier onlyOwner() {
360         _checkOwner();
361         _;
362     }
363 
364     /**
365      * @dev Returns the address of the current owner.
366      */
367     function owner() public view virtual returns (address) {
368         return _owner;
369     }
370 
371     /**
372      * @dev Throws if the sender is not the owner.
373      */
374     function _checkOwner() internal view virtual {
375         require(owner() == _msgSender(), "Ownable: caller is not the owner");
376     }
377 
378     /**
379      * @dev Leaves the contract without owner. It will not be possible to call
380      * `onlyOwner` functions anymore. Can only be called by the current owner.
381      *
382      * NOTE: Renouncing ownership will leave the contract without an owner,
383      * thereby removing any functionality that is only available to the owner.
384      */
385     function renounceOwnership() public virtual onlyOwner {
386         _transferOwnership(address(0));
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      * Can only be called by the current owner.
392      */
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         _transferOwnership(newOwner);
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Internal function without access restriction.
401      */
402     function _transferOwnership(address newOwner) internal virtual {
403         address oldOwner = _owner;
404         _owner = newOwner;
405         emit OwnershipTransferred(oldOwner, newOwner);
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
413 
414 pragma solidity ^0.8.1;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      *
437      * [IMPORTANT]
438      * ====
439      * You shouldn't rely on `isContract` to protect against flash loan attacks!
440      *
441      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
442      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
443      * constructor.
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize/address.code.length, which returns 0
448         // for contracts in construction, since the code is only stored at the end
449         // of the constructor execution.
450 
451         return account.code.length > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{value: amount}("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         (bool success, bytes memory returndata) = target.staticcall(data);
571         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
601      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
602      *
603      * _Available since v4.8._
604      */
605     function verifyCallResultFromTarget(
606         address target,
607         bool success,
608         bytes memory returndata,
609         string memory errorMessage
610     ) internal view returns (bytes memory) {
611         if (success) {
612             if (returndata.length == 0) {
613                 // only check isContract if the call was successful and the return data is empty
614                 // otherwise we already know that it was a contract
615                 require(isContract(target), "Address: call to non-contract");
616             }
617             return returndata;
618         } else {
619             _revert(returndata, errorMessage);
620         }
621     }
622 
623     /**
624      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
625      * revert reason or using the provided one.
626      *
627      * _Available since v4.3._
628      */
629     function verifyCallResult(
630         bool success,
631         bytes memory returndata,
632         string memory errorMessage
633     ) internal pure returns (bytes memory) {
634         if (success) {
635             return returndata;
636         } else {
637             _revert(returndata, errorMessage);
638         }
639     }
640 
641     function _revert(bytes memory returndata, string memory errorMessage) private pure {
642         // Look for revert reason and bubble it up if present
643         if (returndata.length > 0) {
644             // The easiest way to bubble the revert reason is using memory via assembly
645             /// @solidity memory-safe-assembly
646             assembly {
647                 let returndata_size := mload(returndata)
648                 revert(add(32, returndata), returndata_size)
649             }
650         } else {
651             revert(errorMessage);
652         }
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/math/Math.sol
657 
658 
659 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Standard math utilities missing in the Solidity language.
665  */
666 library Math {
667     enum Rounding {
668         Down, // Toward negative infinity
669         Up, // Toward infinity
670         Zero // Toward zero
671     }
672 
673     /**
674      * @dev Returns the largest of two numbers.
675      */
676     function max(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a > b ? a : b;
678     }
679 
680     /**
681      * @dev Returns the smallest of two numbers.
682      */
683     function min(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a < b ? a : b;
685     }
686 
687     /**
688      * @dev Returns the average of two numbers. The result is rounded towards
689      * zero.
690      */
691     function average(uint256 a, uint256 b) internal pure returns (uint256) {
692         // (a + b) / 2 can overflow.
693         return (a & b) + (a ^ b) / 2;
694     }
695 
696     /**
697      * @dev Returns the ceiling of the division of two numbers.
698      *
699      * This differs from standard division with `/` in that it rounds up instead
700      * of rounding down.
701      */
702     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
703         // (a + b - 1) / b can overflow on addition, so we distribute.
704         return a == 0 ? 0 : (a - 1) / b + 1;
705     }
706 
707     /**
708      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
709      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
710      * with further edits by Uniswap Labs also under MIT license.
711      */
712     function mulDiv(
713         uint256 x,
714         uint256 y,
715         uint256 denominator
716     ) internal pure returns (uint256 result) {
717         unchecked {
718             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
719             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
720             // variables such that product = prod1 * 2^256 + prod0.
721             uint256 prod0; // Least significant 256 bits of the product
722             uint256 prod1; // Most significant 256 bits of the product
723             assembly {
724                 let mm := mulmod(x, y, not(0))
725                 prod0 := mul(x, y)
726                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
727             }
728 
729             // Handle non-overflow cases, 256 by 256 division.
730             if (prod1 == 0) {
731                 return prod0 / denominator;
732             }
733 
734             // Make sure the result is less than 2^256. Also prevents denominator == 0.
735             require(denominator > prod1);
736 
737             ///////////////////////////////////////////////
738             // 512 by 256 division.
739             ///////////////////////////////////////////////
740 
741             // Make division exact by subtracting the remainder from [prod1 prod0].
742             uint256 remainder;
743             assembly {
744                 // Compute remainder using mulmod.
745                 remainder := mulmod(x, y, denominator)
746 
747                 // Subtract 256 bit number from 512 bit number.
748                 prod1 := sub(prod1, gt(remainder, prod0))
749                 prod0 := sub(prod0, remainder)
750             }
751 
752             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
753             // See https://cs.stackexchange.com/q/138556/92363.
754 
755             // Does not overflow because the denominator cannot be zero at this stage in the function.
756             uint256 twos = denominator & (~denominator + 1);
757             assembly {
758                 // Divide denominator by twos.
759                 denominator := div(denominator, twos)
760 
761                 // Divide [prod1 prod0] by twos.
762                 prod0 := div(prod0, twos)
763 
764                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
765                 twos := add(div(sub(0, twos), twos), 1)
766             }
767 
768             // Shift in bits from prod1 into prod0.
769             prod0 |= prod1 * twos;
770 
771             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
772             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
773             // four bits. That is, denominator * inv = 1 mod 2^4.
774             uint256 inverse = (3 * denominator) ^ 2;
775 
776             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
777             // in modular arithmetic, doubling the correct bits in each step.
778             inverse *= 2 - denominator * inverse; // inverse mod 2^8
779             inverse *= 2 - denominator * inverse; // inverse mod 2^16
780             inverse *= 2 - denominator * inverse; // inverse mod 2^32
781             inverse *= 2 - denominator * inverse; // inverse mod 2^64
782             inverse *= 2 - denominator * inverse; // inverse mod 2^128
783             inverse *= 2 - denominator * inverse; // inverse mod 2^256
784 
785             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
786             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
787             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
788             // is no longer required.
789             result = prod0 * inverse;
790             return result;
791         }
792     }
793 
794     /**
795      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
796      */
797     function mulDiv(
798         uint256 x,
799         uint256 y,
800         uint256 denominator,
801         Rounding rounding
802     ) internal pure returns (uint256) {
803         uint256 result = mulDiv(x, y, denominator);
804         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
805             result += 1;
806         }
807         return result;
808     }
809 
810     /**
811      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
812      *
813      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
814      */
815     function sqrt(uint256 a) internal pure returns (uint256) {
816         if (a == 0) {
817             return 0;
818         }
819 
820         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
821         //
822         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
823         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
824         //
825         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
826         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
827         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
828         //
829         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
830         uint256 result = 1 << (log2(a) >> 1);
831 
832         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
833         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
834         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
835         // into the expected uint128 result.
836         unchecked {
837             result = (result + a / result) >> 1;
838             result = (result + a / result) >> 1;
839             result = (result + a / result) >> 1;
840             result = (result + a / result) >> 1;
841             result = (result + a / result) >> 1;
842             result = (result + a / result) >> 1;
843             result = (result + a / result) >> 1;
844             return min(result, a / result);
845         }
846     }
847 
848     /**
849      * @notice Calculates sqrt(a), following the selected rounding direction.
850      */
851     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
852         unchecked {
853             uint256 result = sqrt(a);
854             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
855         }
856     }
857 
858     /**
859      * @dev Return the log in base 2, rounded down, of a positive value.
860      * Returns 0 if given 0.
861      */
862     function log2(uint256 value) internal pure returns (uint256) {
863         uint256 result = 0;
864         unchecked {
865             if (value >> 128 > 0) {
866                 value >>= 128;
867                 result += 128;
868             }
869             if (value >> 64 > 0) {
870                 value >>= 64;
871                 result += 64;
872             }
873             if (value >> 32 > 0) {
874                 value >>= 32;
875                 result += 32;
876             }
877             if (value >> 16 > 0) {
878                 value >>= 16;
879                 result += 16;
880             }
881             if (value >> 8 > 0) {
882                 value >>= 8;
883                 result += 8;
884             }
885             if (value >> 4 > 0) {
886                 value >>= 4;
887                 result += 4;
888             }
889             if (value >> 2 > 0) {
890                 value >>= 2;
891                 result += 2;
892             }
893             if (value >> 1 > 0) {
894                 result += 1;
895             }
896         }
897         return result;
898     }
899 
900     /**
901      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
902      * Returns 0 if given 0.
903      */
904     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
905         unchecked {
906             uint256 result = log2(value);
907             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
908         }
909     }
910 
911     /**
912      * @dev Return the log in base 10, rounded down, of a positive value.
913      * Returns 0 if given 0.
914      */
915     function log10(uint256 value) internal pure returns (uint256) {
916         uint256 result = 0;
917         unchecked {
918             if (value >= 10**64) {
919                 value /= 10**64;
920                 result += 64;
921             }
922             if (value >= 10**32) {
923                 value /= 10**32;
924                 result += 32;
925             }
926             if (value >= 10**16) {
927                 value /= 10**16;
928                 result += 16;
929             }
930             if (value >= 10**8) {
931                 value /= 10**8;
932                 result += 8;
933             }
934             if (value >= 10**4) {
935                 value /= 10**4;
936                 result += 4;
937             }
938             if (value >= 10**2) {
939                 value /= 10**2;
940                 result += 2;
941             }
942             if (value >= 10**1) {
943                 result += 1;
944             }
945         }
946         return result;
947     }
948 
949     /**
950      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
951      * Returns 0 if given 0.
952      */
953     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
954         unchecked {
955             uint256 result = log10(value);
956             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
957         }
958     }
959 
960     /**
961      * @dev Return the log in base 256, rounded down, of a positive value.
962      * Returns 0 if given 0.
963      *
964      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
965      */
966     function log256(uint256 value) internal pure returns (uint256) {
967         uint256 result = 0;
968         unchecked {
969             if (value >> 128 > 0) {
970                 value >>= 128;
971                 result += 16;
972             }
973             if (value >> 64 > 0) {
974                 value >>= 64;
975                 result += 8;
976             }
977             if (value >> 32 > 0) {
978                 value >>= 32;
979                 result += 4;
980             }
981             if (value >> 16 > 0) {
982                 value >>= 16;
983                 result += 2;
984             }
985             if (value >> 8 > 0) {
986                 result += 1;
987             }
988         }
989         return result;
990     }
991 
992     /**
993      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
994      * Returns 0 if given 0.
995      */
996     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
997         unchecked {
998             uint256 result = log256(value);
999             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1000         }
1001     }
1002 }
1003 
1004 // File: @openzeppelin/contracts/utils/Strings.sol
1005 
1006 
1007 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 /**
1013  * @dev String operations.
1014  */
1015 library Strings {
1016     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1017     uint8 private constant _ADDRESS_LENGTH = 20;
1018 
1019     /**
1020      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1021      */
1022     function toString(uint256 value) internal pure returns (string memory) {
1023         unchecked {
1024             uint256 length = Math.log10(value) + 1;
1025             string memory buffer = new string(length);
1026             uint256 ptr;
1027             /// @solidity memory-safe-assembly
1028             assembly {
1029                 ptr := add(buffer, add(32, length))
1030             }
1031             while (true) {
1032                 ptr--;
1033                 /// @solidity memory-safe-assembly
1034                 assembly {
1035                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1036                 }
1037                 value /= 10;
1038                 if (value == 0) break;
1039             }
1040             return buffer;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1046      */
1047     function toHexString(uint256 value) internal pure returns (string memory) {
1048         unchecked {
1049             return toHexString(value, Math.log256(value) + 1);
1050         }
1051     }
1052 
1053     /**
1054      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1055      */
1056     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1057         bytes memory buffer = new bytes(2 * length + 2);
1058         buffer[0] = "0";
1059         buffer[1] = "x";
1060         for (uint256 i = 2 * length + 1; i > 1; --i) {
1061             buffer[i] = _SYMBOLS[value & 0xf];
1062             value >>= 4;
1063         }
1064         require(value == 0, "Strings: hex length insufficient");
1065         return string(buffer);
1066     }
1067 
1068     /**
1069      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1070      */
1071     function toHexString(address addr) internal pure returns (string memory) {
1072         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1073     }
1074 }
1075 
1076 // File: contracts/Ponzi/PonziNFT/PonziNFT.sol
1077 
1078 
1079 pragma solidity ^0.8.7;
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1089 
1090 pragma solidity ^0.8.4;
1091 
1092 error ApprovalCallerNotOwnerNorApproved();
1093 error ApprovalQueryForNonexistentToken();
1094 error ApproveToCaller();
1095 error ApprovalToCurrentOwner();
1096 error BalanceQueryForZeroAddress();
1097 error MintedQueryForZeroAddress();
1098 error BurnedQueryForZeroAddress();
1099 error AuxQueryForZeroAddress();
1100 error MintToZeroAddress();
1101 error MintZeroQuantity();
1102 error OwnerIndexOutOfBounds();
1103 error OwnerQueryForNonexistentToken();
1104 error TokenIndexOutOfBounds();
1105 error TransferCallerNotOwnerNorApproved();
1106 error TransferFromIncorrectOwner();
1107 error TransferToNonERC721ReceiverImplementer();
1108 error TransferToZeroAddress();
1109 error URIQueryForNonexistentToken();
1110 
1111 /**
1112  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1113  * the Metadata extension. Built to optimize for lower gas during batch mints.
1114  *
1115  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1116  *
1117  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1118  *
1119  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1120  */
1121 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1122     using Address for address;
1123     using Strings for uint256;
1124 
1125     // Compiler will pack this into a single 256bit word.
1126     struct TokenOwnership {
1127         // The address of the owner.
1128         address addr;
1129         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1130         uint64 startTimestamp;
1131         // Whether the token has been burned.
1132         bool burned;
1133     }
1134 
1135     // Compiler will pack this into a single 256bit word.
1136     struct AddressData {
1137         // Realistically, 2**64-1 is more than enough.
1138         uint64 balance;
1139         // Keeps track of mint count with minimal overhead for tokenomics.
1140         uint64 numberMinted;
1141         // Keeps track of burn count with minimal overhead for tokenomics.
1142         uint64 numberBurned;
1143         // For miscellaneous variable(s) pertaining to the address
1144         // (e.g. number of whitelist mint slots used). 
1145         // If there are multiple variables, please pack them into a uint64.
1146         uint64 aux;
1147     }
1148 
1149     // The tokenId of the next token to be minted.
1150     uint256 internal _currentIndex;
1151 
1152     // The number of tokens burned.
1153     uint256 internal _burnCounter;
1154 
1155     // Token name
1156     string private _name;
1157 
1158     // Token symbol
1159     string private _symbol;
1160 
1161     // Mapping from token ID to ownership details
1162     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1163     mapping(uint256 => TokenOwnership) internal _ownerships;
1164 
1165     // Mapping owner address to address data
1166     mapping(address => AddressData) private _addressData;
1167 
1168     // Mapping from token ID to approved address
1169     mapping(uint256 => address) private _tokenApprovals;
1170 
1171     // Mapping from owner to operator approvals
1172     mapping(address => mapping(address => bool)) private _operatorApprovals;
1173 
1174     constructor(string memory name_, string memory symbol_) {
1175         _name = name_;
1176         _symbol = symbol_;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Enumerable-totalSupply}.
1181      */
1182     function totalSupply() public view returns (uint256) {
1183         // Counter underflow is impossible as _burnCounter cannot be incremented
1184         // more than _currentIndex times
1185         unchecked {
1186             return _currentIndex - _burnCounter;    
1187         }
1188     }
1189 
1190     /**
1191      * @dev See {IERC165-supportsInterface}.
1192      */
1193     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1194         return
1195             interfaceId == type(IERC721).interfaceId ||
1196             interfaceId == type(IERC721Metadata).interfaceId ||
1197             super.supportsInterface(interfaceId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-balanceOf}.
1202      */
1203     function balanceOf(address owner) public view override returns (uint256) {
1204         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1205         return uint256(_addressData[owner].balance);
1206     }
1207 
1208     /**
1209      * Returns the number of tokens minted by `owner`.
1210      */
1211     function _numberMinted(address owner) internal view returns (uint256) {
1212         if (owner == address(0)) revert MintedQueryForZeroAddress();
1213         return uint256(_addressData[owner].numberMinted);
1214     }
1215 
1216     /**
1217      * Returns the number of tokens burned by or on behalf of `owner`.
1218      */
1219     function _numberBurned(address owner) internal view returns (uint256) {
1220         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1221         return uint256(_addressData[owner].numberBurned);
1222     }
1223 
1224     /**
1225      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1226      */
1227     function _getAux(address owner) internal view returns (uint64) {
1228         if (owner == address(0)) revert AuxQueryForZeroAddress();
1229         return _addressData[owner].aux;
1230     }
1231 
1232     /**
1233      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1234      * If there are multiple variables, please pack them into a uint64.
1235      */
1236     function _setAux(address owner, uint64 aux) internal {
1237         if (owner == address(0)) revert AuxQueryForZeroAddress();
1238         _addressData[owner].aux = aux;
1239     }
1240 
1241     /**
1242      * Gas spent here starts off proportional to the maximum mint batch size.
1243      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1244      */
1245     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1246         uint256 curr = tokenId;
1247 
1248         unchecked {
1249             if (curr < _currentIndex) {
1250                 TokenOwnership memory ownership = _ownerships[curr];
1251                 if (!ownership.burned) {
1252                     if (ownership.addr != address(0)) {
1253                         return ownership;
1254                     }
1255                     // Invariant: 
1256                     // There will always be an ownership that has an address and is not burned 
1257                     // before an ownership that does not have an address and is not burned.
1258                     // Hence, curr will not underflow.
1259                     while (true) {
1260                         curr--;
1261                         ownership = _ownerships[curr];
1262                         if (ownership.addr != address(0)) {
1263                             return ownership;
1264                         }
1265                     }
1266                 }
1267             }
1268         }
1269         revert OwnerQueryForNonexistentToken();
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-ownerOf}.
1274      */
1275     function ownerOf(uint256 tokenId) public view override returns (address) {
1276         return ownershipOf(tokenId).addr;
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Metadata-name}.
1281      */
1282     function name() public view virtual override returns (string memory) {
1283         return _name;
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Metadata-symbol}.
1288      */
1289     function symbol() public view virtual override returns (string memory) {
1290         return _symbol;
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Metadata-tokenURI}.
1295      */
1296     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1297         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1298 
1299         string memory baseURI = _baseURI();
1300         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1301     }
1302 
1303     /**
1304      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1305      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1306      * by default, can be overriden in child contracts.
1307      */
1308     function _baseURI() internal view virtual returns (string memory) {
1309         return '';
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-approve}.
1314      */
1315     function approve(address to, uint256 tokenId) public override {
1316         address owner = ERC721A.ownerOf(tokenId);
1317         if (to == owner) revert ApprovalToCurrentOwner();
1318 
1319         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1320             revert ApprovalCallerNotOwnerNorApproved();
1321         }
1322 
1323         _approve(to, tokenId, owner);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-getApproved}.
1328      */
1329     function getApproved(uint256 tokenId) public view override returns (address) {
1330         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1331 
1332         return _tokenApprovals[tokenId];
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-setApprovalForAll}.
1337      */
1338     function setApprovalForAll(address operator, bool approved) public override {
1339         if (operator == _msgSender()) revert ApproveToCaller();
1340 
1341         _operatorApprovals[_msgSender()][operator] = approved;
1342         emit ApprovalForAll(_msgSender(), operator, approved);
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-isApprovedForAll}.
1347      */
1348     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1349         return _operatorApprovals[owner][operator];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-transferFrom}.
1354      */
1355     function transferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) public virtual override {
1360         _transfer(from, to, tokenId);
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-safeTransferFrom}.
1365      */
1366     function safeTransferFrom(
1367         address from,
1368         address to,
1369         uint256 tokenId
1370     ) public virtual override {
1371         safeTransferFrom(from, to, tokenId, '');
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-safeTransferFrom}.
1376      */
1377     function safeTransferFrom(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory _data
1382     ) public virtual override {
1383         _transfer(from, to, tokenId);
1384         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1385             revert TransferToNonERC721ReceiverImplementer();
1386         }
1387     }
1388 
1389     /**
1390      * @dev Returns whether `tokenId` exists.
1391      *
1392      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1393      *
1394      * Tokens start existing when they are minted (`_mint`),
1395      */
1396     function _exists(uint256 tokenId) internal view returns (bool) {
1397         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1398     }
1399 
1400     function _safeMint(address to, uint256 quantity) internal {
1401         _safeMint(to, quantity, '');
1402     }
1403 
1404     /**
1405      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1410      * - `quantity` must be greater than 0.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _safeMint(
1415         address to,
1416         uint256 quantity,
1417         bytes memory _data
1418     ) internal {
1419         _mint(to, quantity, _data, true);
1420     }
1421 
1422     /**
1423      * @dev Mints `quantity` tokens and transfers them to `to`.
1424      *
1425      * Requirements:
1426      *
1427      * - `to` cannot be the zero address.
1428      * - `quantity` must be greater than 0.
1429      *
1430      * Emits a {Transfer} event.
1431      */
1432     function _mint(
1433         address to,
1434         uint256 quantity,
1435         bytes memory _data,
1436         bool safe
1437     ) internal {
1438         uint256 startTokenId = _currentIndex;
1439         if (to == address(0)) revert MintToZeroAddress();
1440         if (quantity == 0) revert MintZeroQuantity();
1441 
1442         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1443 
1444         // Overflows are incredibly unrealistic.
1445         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1446         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1447         unchecked {
1448             _addressData[to].balance += uint64(quantity);
1449             _addressData[to].numberMinted += uint64(quantity);
1450 
1451             _ownerships[startTokenId].addr = to;
1452             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1453 
1454             uint256 updatedIndex = startTokenId;
1455 
1456             for (uint256 i; i < quantity; i++) {
1457                 emit Transfer(address(0), to, updatedIndex);
1458                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1459                     revert TransferToNonERC721ReceiverImplementer();
1460                 }
1461                 updatedIndex++;
1462             }
1463 
1464             _currentIndex = updatedIndex;
1465         }
1466         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1467     }
1468 
1469     /**
1470      * @dev Transfers `tokenId` from `from` to `to`.
1471      *
1472      * Requirements:
1473      *
1474      * - `to` cannot be the zero address.
1475      * - `tokenId` token must be owned by `from`.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _transfer(
1480         address from,
1481         address to,
1482         uint256 tokenId
1483     ) private {
1484         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1485 
1486         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1487             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1488             getApproved(tokenId) == _msgSender());
1489 
1490         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1491         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1492         if (to == address(0)) revert TransferToZeroAddress();
1493 
1494         _beforeTokenTransfers(from, to, tokenId, 1);
1495 
1496         // Clear approvals from the previous owner
1497         _approve(address(0), tokenId, prevOwnership.addr);
1498 
1499         // Underflow of the sender's balance is impossible because we check for
1500         // ownership above and the recipient's balance can't realistically overflow.
1501         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1502         unchecked {
1503             _addressData[from].balance -= 1;
1504             _addressData[to].balance += 1;
1505 
1506             _ownerships[tokenId].addr = to;
1507             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1508 
1509             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1510             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1511             uint256 nextTokenId = tokenId + 1;
1512             if (_ownerships[nextTokenId].addr == address(0)) {
1513                 // This will suffice for checking _exists(nextTokenId),
1514                 // as a burned slot cannot contain the zero address.
1515                 if (nextTokenId < _currentIndex) {
1516                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1517                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1518                 }
1519             }
1520         }
1521 
1522         emit Transfer(from, to, tokenId);
1523         _afterTokenTransfers(from, to, tokenId, 1);
1524     }
1525 
1526     /**
1527      * @dev Destroys `tokenId`.
1528      * The approval is cleared when the token is burned.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _burn(uint256 tokenId) internal virtual {
1537         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1538 
1539         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1540 
1541         // Clear approvals from the previous owner
1542         _approve(address(0), tokenId, prevOwnership.addr);
1543 
1544         // Underflow of the sender's balance is impossible because we check for
1545         // ownership above and the recipient's balance can't realistically overflow.
1546         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1547         unchecked {
1548             _addressData[prevOwnership.addr].balance -= 1;
1549             _addressData[prevOwnership.addr].numberBurned += 1;
1550 
1551             // Keep track of who burned the token, and the timestamp of burning.
1552             _ownerships[tokenId].addr = prevOwnership.addr;
1553             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1554             _ownerships[tokenId].burned = true;
1555 
1556             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1557             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1558             uint256 nextTokenId = tokenId + 1;
1559             if (_ownerships[nextTokenId].addr == address(0)) {
1560                 // This will suffice for checking _exists(nextTokenId),
1561                 // as a burned slot cannot contain the zero address.
1562                 if (nextTokenId < _currentIndex) {
1563                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1564                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1565                 }
1566             }
1567         }
1568 
1569         emit Transfer(prevOwnership.addr, address(0), tokenId);
1570         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1571 
1572         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1573         unchecked { 
1574             _burnCounter++;
1575         }
1576     }
1577 
1578     /**
1579      * @dev Approve `to` to operate on `tokenId`
1580      *
1581      * Emits a {Approval} event.
1582      */
1583     function _approve(
1584         address to,
1585         uint256 tokenId,
1586         address owner
1587     ) private {
1588         _tokenApprovals[tokenId] = to;
1589         emit Approval(owner, to, tokenId);
1590     }
1591 
1592     /**
1593      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1594      * The call is not executed if the target address is not a contract.
1595      *
1596      * @param from address representing the previous owner of the given token ID
1597      * @param to target address that will receive the tokens
1598      * @param tokenId uint256 ID of the token to be transferred
1599      * @param _data bytes optional data to send along with the call
1600      * @return bool whether the call correctly returned the expected magic value
1601      */
1602     function _checkOnERC721Received(
1603         address from,
1604         address to,
1605         uint256 tokenId,
1606         bytes memory _data
1607     ) private returns (bool) {
1608         if (to.isContract()) {
1609             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1610                 return retval == IERC721Receiver(to).onERC721Received.selector;
1611             } catch (bytes memory reason) {
1612                 if (reason.length == 0) {
1613                     revert TransferToNonERC721ReceiverImplementer();
1614                 } else {
1615                     assembly {
1616                         revert(add(32, reason), mload(reason))
1617                     }
1618                 }
1619             }
1620         } else {
1621             return true;
1622         }
1623     }
1624 
1625     /**
1626      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1627      * And also called before burning one token.
1628      *
1629      * startTokenId - the first token id to be transferred
1630      * quantity - the amount to be transferred
1631      *
1632      * Calling conditions:
1633      *
1634      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1635      * transferred to `to`.
1636      * - When `from` is zero, `tokenId` will be minted for `to`.
1637      * - When `to` is zero, `tokenId` will be burned by `from`.
1638      * - `from` and `to` are never both zero.
1639      */
1640     function _beforeTokenTransfers(
1641         address from,
1642         address to,
1643         uint256 startTokenId,
1644         uint256 quantity
1645     ) internal virtual {}
1646 
1647     /**
1648      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1649      * minting.
1650      * And also called after one token has been burned.
1651      *
1652      * startTokenId - the first token id to be transferred
1653      * quantity - the amount to be transferred
1654      *
1655      * Calling conditions:
1656      *
1657      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1658      * transferred to `to`.
1659      * - When `from` is zero, `tokenId` has been minted for `to`.
1660      * - When `to` is zero, `tokenId` has been burned by `from`.
1661      * - `from` and `to` are never both zero.
1662      */
1663     function _afterTokenTransfers(
1664         address from,
1665         address to,
1666         uint256 startTokenId,
1667         uint256 quantity
1668     ) internal virtual {}
1669 }
1670 
1671 contract PONZI_NFT is ERC721A, Ownable {
1672     using Strings for uint256;
1673     
1674     uint256 public MAX_SUPPLY = 6900;
1675 
1676     string private BASE_URI;
1677     string private UNREVEAL_URI;
1678 
1679     uint256 public PUBLIC_MINT_LIMIT = 1;
1680 
1681     uint256 public SALE_STEP = 0; // 0 => NONE, 1 => START
1682 
1683     constructor() ERC721A("PONZI NFT", "PONZI") {}
1684 
1685     function setPublicMintLimit(uint256 _publicMintLimit) external onlyOwner {
1686         PUBLIC_MINT_LIMIT = _publicMintLimit;
1687     }
1688     
1689     function numberMinted(address _owner) public view returns (uint256) {
1690         return _numberMinted(_owner);
1691     }
1692 
1693     function mintPublic(uint256 _mintAmount) external {
1694         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1695 
1696         require(SALE_STEP == 1, "Public Sale is not opened");
1697 
1698         require((numberMinted(msg.sender) + _mintAmount) <= PUBLIC_MINT_LIMIT, "Exceeds Max Mint Amount");
1699 
1700         _mintLoop(msg.sender, _mintAmount);
1701     }
1702 
1703     function airdrop(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
1704         require(totalSupply() + _airdropAddresses.length * _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1705 
1706         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1707             address to = _airdropAddresses[i];
1708             _mintLoop(to, _mintAmount);
1709         }
1710     }
1711 
1712     function _baseURI() internal view virtual override returns (string memory) {
1713         return BASE_URI;
1714     }
1715 
1716     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1717         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1718         string memory currentBaseURI = _baseURI();
1719         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
1720     }
1721 
1722     function setMaxSupply(uint256 _supply) external onlyOwner {
1723         MAX_SUPPLY = _supply;
1724     }
1725 
1726     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1727         BASE_URI = _newBaseURI;
1728     }
1729 
1730     function setUnrevealURI(string memory _newUnrevealURI) external onlyOwner {
1731         UNREVEAL_URI = _newUnrevealURI;
1732     }
1733 
1734     function setSaleStep(uint256 _saleStep) external onlyOwner {
1735         SALE_STEP = _saleStep;
1736     }
1737 
1738     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1739         _safeMint(_receiver, _mintAmount);
1740     }
1741 
1742     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1743         return ownershipOf(tokenId);
1744     }
1745 
1746     function withdraw() external onlyOwner {
1747         uint256 curBalance = address(this).balance;
1748         payable(msg.sender).transfer(curBalance);
1749     }
1750 }