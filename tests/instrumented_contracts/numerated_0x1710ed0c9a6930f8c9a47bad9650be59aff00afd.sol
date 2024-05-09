1 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 
67 /**
68  * @dev Implementation of the {IERC165} interface.
69  *
70  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
71  * for the additional interface id that will be supported. For example:
72  *
73  * ```solidity
74  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
75  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
76  * }
77  * ```
78  *
79  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
80  */
81 abstract contract ERC165 is IERC165 {
82     /**
83      * @dev See {IERC165-supportsInterface}.
84      */
85     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
86         return interfaceId == type(IERC165).interfaceId;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
91 
92 
93 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 
98 /**
99  * @dev Required interface of an ERC721 compliant contract.
100  */
101 interface IERC721 is IERC165 {
102     /**
103      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
106 
107     /**
108      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
109      */
110     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
114      */
115     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
116 
117     /**
118      * @dev Returns the number of tokens in ``owner``'s account.
119      */
120     function balanceOf(address owner) external view returns (uint256 balance);
121 
122     /**
123      * @dev Returns the owner of the `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function ownerOf(uint256 tokenId) external view returns (address owner);
130 
131     /**
132      * @dev Safely transfers `tokenId` token from `from` to `to`.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must exist and be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
141      *
142      * Emits a {Transfer} event.
143      */
144     function safeTransferFrom(
145         address from,
146         address to,
147         uint256 tokenId,
148         bytes calldata data
149     ) external;
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId
169     ) external;
170 
171     /**
172      * @dev Transfers `tokenId` token from `from` to `to`.
173      *
174      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
175      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
176      * understand this adds an external call which potentially creates a reentrancy vulnerability.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
195      * The approval is cleared when the token is transferred.
196      *
197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
198      *
199      * Requirements:
200      *
201      * - The caller must own the token or be an approved operator.
202      * - `tokenId` must exist.
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address to, uint256 tokenId) external;
207 
208     /**
209      * @dev Approve or remove `operator` as an operator for the caller.
210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
211      *
212      * Requirements:
213      *
214      * - The `operator` cannot be the caller.
215      *
216      * Emits an {ApprovalForAll} event.
217      */
218     function setApprovalForAll(address operator, bool _approved) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 
245 /**
246  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
247  * @dev See https://eips.ethereum.org/EIPS/eip-721
248  */
249 interface IERC721Enumerable is IERC721 {
250     /**
251      * @dev Returns the total amount of tokens stored by the contract.
252      */
253     function totalSupply() external view returns (uint256);
254 
255     /**
256      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
257      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
258      */
259     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
260 
261     /**
262      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
263      * Use along with {totalSupply} to enumerate all tokens.
264      */
265     function tokenByIndex(uint256 index) external view returns (uint256);
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Metadata is IERC721 {
281     /**
282      * @dev Returns the token collection name.
283      */
284     function name() external view returns (string memory);
285 
286     /**
287      * @dev Returns the token collection symbol.
288      */
289     function symbol() external view returns (string memory);
290 
291     /**
292      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
293      */
294     function tokenURI(uint256 tokenId) external view returns (string memory);
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
1076 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1077 
1078 
1079 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 /**
1091  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1092  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1093  * {ERC721Enumerable}.
1094  */
1095 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1096     using Address for address;
1097     using Strings for uint256;
1098 
1099     // Token name
1100     string private _name;
1101 
1102     // Token symbol
1103     string private _symbol;
1104 
1105     // Mapping from token ID to owner address
1106     mapping(uint256 => address) private _owners;
1107 
1108     // Mapping owner address to token count
1109     mapping(address => uint256) private _balances;
1110 
1111     // Mapping from token ID to approved address
1112     mapping(uint256 => address) private _tokenApprovals;
1113 
1114     // Mapping from owner to operator approvals
1115     mapping(address => mapping(address => bool)) private _operatorApprovals;
1116 
1117     /**
1118      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1119      */
1120     constructor(string memory name_, string memory symbol_) {
1121         _name = name_;
1122         _symbol = symbol_;
1123     }
1124 
1125     /**
1126      * @dev See {IERC165-supportsInterface}.
1127      */
1128     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1129         return
1130             interfaceId == type(IERC721).interfaceId ||
1131             interfaceId == type(IERC721Metadata).interfaceId ||
1132             super.supportsInterface(interfaceId);
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-balanceOf}.
1137      */
1138     function balanceOf(address owner) public view virtual override returns (uint256) {
1139         require(owner != address(0), "ERC721: address zero is not a valid owner");
1140         return _balances[owner];
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-ownerOf}.
1145      */
1146     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1147         address owner = _ownerOf(tokenId);
1148         require(owner != address(0), "ERC721: invalid token ID");
1149         return owner;
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Metadata-name}.
1154      */
1155     function name() public view virtual override returns (string memory) {
1156         return _name;
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Metadata-symbol}.
1161      */
1162     function symbol() public view virtual override returns (string memory) {
1163         return _symbol;
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Metadata-tokenURI}.
1168      */
1169     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1170         _requireMinted(tokenId);
1171 
1172         string memory baseURI = _baseURI();
1173         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1174     }
1175 
1176     /**
1177      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1178      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1179      * by default, can be overridden in child contracts.
1180      */
1181     function _baseURI() internal view virtual returns (string memory) {
1182         return "";
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-approve}.
1187      */
1188     function approve(address to, uint256 tokenId) public virtual override {
1189         address owner = ERC721.ownerOf(tokenId);
1190         require(to != owner, "ERC721: approval to current owner");
1191 
1192         require(
1193             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1194             "ERC721: approve caller is not token owner or approved for all"
1195         );
1196 
1197         _approve(to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-getApproved}.
1202      */
1203     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1204         _requireMinted(tokenId);
1205 
1206         return _tokenApprovals[tokenId];
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-setApprovalForAll}.
1211      */
1212     function setApprovalForAll(address operator, bool approved) public virtual override {
1213         _setApprovalForAll(_msgSender(), operator, approved);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-isApprovedForAll}.
1218      */
1219     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1220         return _operatorApprovals[owner][operator];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-transferFrom}.
1225      */
1226     function transferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) public virtual override {
1231         //solhint-disable-next-line max-line-length
1232         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1233 
1234         _transfer(from, to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-safeTransferFrom}.
1239      */
1240     function safeTransferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public virtual override {
1245         safeTransferFrom(from, to, tokenId, "");
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-safeTransferFrom}.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory data
1256     ) public virtual override {
1257         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1258         _safeTransfer(from, to, tokenId, data);
1259     }
1260 
1261     /**
1262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1264      *
1265      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1266      *
1267      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1268      * implement alternative mechanisms to perform token transfer, such as signature-based.
1269      *
1270      * Requirements:
1271      *
1272      * - `from` cannot be the zero address.
1273      * - `to` cannot be the zero address.
1274      * - `tokenId` token must exist and be owned by `from`.
1275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _safeTransfer(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory data
1284     ) internal virtual {
1285         _transfer(from, to, tokenId);
1286         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1287     }
1288 
1289     /**
1290      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1291      */
1292     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1293         return _owners[tokenId];
1294     }
1295 
1296     /**
1297      * @dev Returns whether `tokenId` exists.
1298      *
1299      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1300      *
1301      * Tokens start existing when they are minted (`_mint`),
1302      * and stop existing when they are burned (`_burn`).
1303      */
1304     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1305         return _ownerOf(tokenId) != address(0);
1306     }
1307 
1308     /**
1309      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      */
1315     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1316         address owner = ERC721.ownerOf(tokenId);
1317         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1318     }
1319 
1320     /**
1321      * @dev Safely mints `tokenId` and transfers it to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must not exist.
1326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _safeMint(address to, uint256 tokenId) internal virtual {
1331         _safeMint(to, tokenId, "");
1332     }
1333 
1334     /**
1335      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1336      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1337      */
1338     function _safeMint(
1339         address to,
1340         uint256 tokenId,
1341         bytes memory data
1342     ) internal virtual {
1343         _mint(to, tokenId);
1344         require(
1345             _checkOnERC721Received(address(0), to, tokenId, data),
1346             "ERC721: transfer to non ERC721Receiver implementer"
1347         );
1348     }
1349 
1350     /**
1351      * @dev Mints `tokenId` and transfers it to `to`.
1352      *
1353      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must not exist.
1358      * - `to` cannot be the zero address.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _mint(address to, uint256 tokenId) internal virtual {
1363         require(to != address(0), "ERC721: mint to the zero address");
1364         require(!_exists(tokenId), "ERC721: token already minted");
1365 
1366         _beforeTokenTransfer(address(0), to, tokenId, 1);
1367 
1368         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1369         require(!_exists(tokenId), "ERC721: token already minted");
1370 
1371         unchecked {
1372             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1373             // Given that tokens are minted one by one, it is impossible in practice that
1374             // this ever happens. Might change if we allow batch minting.
1375             // The ERC fails to describe this case.
1376             _balances[to] += 1;
1377         }
1378 
1379         _owners[tokenId] = to;
1380 
1381         emit Transfer(address(0), to, tokenId);
1382 
1383         _afterTokenTransfer(address(0), to, tokenId, 1);
1384     }
1385 
1386     /**
1387      * @dev Destroys `tokenId`.
1388      * The approval is cleared when the token is burned.
1389      * This is an internal function that does not check if the sender is authorized to operate on the token.
1390      *
1391      * Requirements:
1392      *
1393      * - `tokenId` must exist.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _burn(uint256 tokenId) internal virtual {
1398         address owner = ERC721.ownerOf(tokenId);
1399 
1400         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1401 
1402         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1403         owner = ERC721.ownerOf(tokenId);
1404 
1405         // Clear approvals
1406         delete _tokenApprovals[tokenId];
1407 
1408         unchecked {
1409             // Cannot overflow, as that would require more tokens to be burned/transferred
1410             // out than the owner initially received through minting and transferring in.
1411             _balances[owner] -= 1;
1412         }
1413         delete _owners[tokenId];
1414 
1415         emit Transfer(owner, address(0), tokenId);
1416 
1417         _afterTokenTransfer(owner, address(0), tokenId, 1);
1418     }
1419 
1420     /**
1421      * @dev Transfers `tokenId` from `from` to `to`.
1422      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1423      *
1424      * Requirements:
1425      *
1426      * - `to` cannot be the zero address.
1427      * - `tokenId` token must be owned by `from`.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _transfer(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) internal virtual {
1436         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1437         require(to != address(0), "ERC721: transfer to the zero address");
1438 
1439         _beforeTokenTransfer(from, to, tokenId, 1);
1440 
1441         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1442         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1443 
1444         // Clear approvals from the previous owner
1445         delete _tokenApprovals[tokenId];
1446 
1447         unchecked {
1448             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1449             // `from`'s balance is the number of token held, which is at least one before the current
1450             // transfer.
1451             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1452             // all 2**256 token ids to be minted, which in practice is impossible.
1453             _balances[from] -= 1;
1454             _balances[to] += 1;
1455         }
1456         _owners[tokenId] = to;
1457 
1458         emit Transfer(from, to, tokenId);
1459 
1460         _afterTokenTransfer(from, to, tokenId, 1);
1461     }
1462 
1463     /**
1464      * @dev Approve `to` to operate on `tokenId`
1465      *
1466      * Emits an {Approval} event.
1467      */
1468     function _approve(address to, uint256 tokenId) internal virtual {
1469         _tokenApprovals[tokenId] = to;
1470         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Approve `operator` to operate on all of `owner` tokens
1475      *
1476      * Emits an {ApprovalForAll} event.
1477      */
1478     function _setApprovalForAll(
1479         address owner,
1480         address operator,
1481         bool approved
1482     ) internal virtual {
1483         require(owner != operator, "ERC721: approve to caller");
1484         _operatorApprovals[owner][operator] = approved;
1485         emit ApprovalForAll(owner, operator, approved);
1486     }
1487 
1488     /**
1489      * @dev Reverts if the `tokenId` has not been minted yet.
1490      */
1491     function _requireMinted(uint256 tokenId) internal view virtual {
1492         require(_exists(tokenId), "ERC721: invalid token ID");
1493     }
1494 
1495     /**
1496      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1497      * The call is not executed if the target address is not a contract.
1498      *
1499      * @param from address representing the previous owner of the given token ID
1500      * @param to target address that will receive the tokens
1501      * @param tokenId uint256 ID of the token to be transferred
1502      * @param data bytes optional data to send along with the call
1503      * @return bool whether the call correctly returned the expected magic value
1504      */
1505     function _checkOnERC721Received(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes memory data
1510     ) private returns (bool) {
1511         if (to.isContract()) {
1512             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1513                 return retval == IERC721Receiver.onERC721Received.selector;
1514             } catch (bytes memory reason) {
1515                 if (reason.length == 0) {
1516                     revert("ERC721: transfer to non ERC721Receiver implementer");
1517                 } else {
1518                     /// @solidity memory-safe-assembly
1519                     assembly {
1520                         revert(add(32, reason), mload(reason))
1521                     }
1522                 }
1523             }
1524         } else {
1525             return true;
1526         }
1527     }
1528 
1529     /**
1530      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1531      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1532      *
1533      * Calling conditions:
1534      *
1535      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1536      * - When `from` is zero, the tokens will be minted for `to`.
1537      * - When `to` is zero, ``from``'s tokens will be burned.
1538      * - `from` and `to` are never both zero.
1539      * - `batchSize` is non-zero.
1540      *
1541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1542      */
1543     function _beforeTokenTransfer(
1544         address from,
1545         address to,
1546         uint256, /* firstTokenId */
1547         uint256 batchSize
1548     ) internal virtual {
1549         if (batchSize > 1) {
1550             if (from != address(0)) {
1551                 _balances[from] -= batchSize;
1552             }
1553             if (to != address(0)) {
1554                 _balances[to] += batchSize;
1555             }
1556         }
1557     }
1558 
1559     /**
1560      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1561      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1566      * - When `from` is zero, the tokens were minted for `to`.
1567      * - When `to` is zero, ``from``'s tokens were burned.
1568      * - `from` and `to` are never both zero.
1569      * - `batchSize` is non-zero.
1570      *
1571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1572      */
1573     function _afterTokenTransfer(
1574         address from,
1575         address to,
1576         uint256 firstTokenId,
1577         uint256 batchSize
1578     ) internal virtual {}
1579 }
1580 
1581 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1582 
1583 
1584 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 
1590 /**
1591  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1592  * enumerability of all the token ids in the contract as well as all token ids owned by each
1593  * account.
1594  */
1595 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1596     // Mapping from owner to list of owned token IDs
1597     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1598 
1599     // Mapping from token ID to index of the owner tokens list
1600     mapping(uint256 => uint256) private _ownedTokensIndex;
1601 
1602     // Array with all token ids, used for enumeration
1603     uint256[] private _allTokens;
1604 
1605     // Mapping from token id to position in the allTokens array
1606     mapping(uint256 => uint256) private _allTokensIndex;
1607 
1608     /**
1609      * @dev See {IERC165-supportsInterface}.
1610      */
1611     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1612         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1613     }
1614 
1615     /**
1616      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1617      */
1618     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1619         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1620         return _ownedTokens[owner][index];
1621     }
1622 
1623     /**
1624      * @dev See {IERC721Enumerable-totalSupply}.
1625      */
1626     function totalSupply() public view virtual override returns (uint256) {
1627         return _allTokens.length;
1628     }
1629 
1630     /**
1631      * @dev See {IERC721Enumerable-tokenByIndex}.
1632      */
1633     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1634         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1635         return _allTokens[index];
1636     }
1637 
1638     /**
1639      * @dev See {ERC721-_beforeTokenTransfer}.
1640      */
1641     function _beforeTokenTransfer(
1642         address from,
1643         address to,
1644         uint256 firstTokenId,
1645         uint256 batchSize
1646     ) internal virtual override {
1647         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1648 
1649         if (batchSize > 1) {
1650             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1651             revert("ERC721Enumerable: consecutive transfers not supported");
1652         }
1653 
1654         uint256 tokenId = firstTokenId;
1655 
1656         if (from == address(0)) {
1657             _addTokenToAllTokensEnumeration(tokenId);
1658         } else if (from != to) {
1659             _removeTokenFromOwnerEnumeration(from, tokenId);
1660         }
1661         if (to == address(0)) {
1662             _removeTokenFromAllTokensEnumeration(tokenId);
1663         } else if (to != from) {
1664             _addTokenToOwnerEnumeration(to, tokenId);
1665         }
1666     }
1667 
1668     /**
1669      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1670      * @param to address representing the new owner of the given token ID
1671      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1672      */
1673     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1674         uint256 length = ERC721.balanceOf(to);
1675         _ownedTokens[to][length] = tokenId;
1676         _ownedTokensIndex[tokenId] = length;
1677     }
1678 
1679     /**
1680      * @dev Private function to add a token to this extension's token tracking data structures.
1681      * @param tokenId uint256 ID of the token to be added to the tokens list
1682      */
1683     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1684         _allTokensIndex[tokenId] = _allTokens.length;
1685         _allTokens.push(tokenId);
1686     }
1687 
1688     /**
1689      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1690      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1691      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1692      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1693      * @param from address representing the previous owner of the given token ID
1694      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1695      */
1696     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1697         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1698         // then delete the last slot (swap and pop).
1699 
1700         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1701         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1702 
1703         // When the token to delete is the last token, the swap operation is unnecessary
1704         if (tokenIndex != lastTokenIndex) {
1705             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1706 
1707             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1708             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1709         }
1710 
1711         // This also deletes the contents at the last position of the array
1712         delete _ownedTokensIndex[tokenId];
1713         delete _ownedTokens[from][lastTokenIndex];
1714     }
1715 
1716     /**
1717      * @dev Private function to remove a token from this extension's token tracking data structures.
1718      * This has O(1) time complexity, but alters the order of the _allTokens array.
1719      * @param tokenId uint256 ID of the token to be removed from the tokens list
1720      */
1721     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1722         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1723         // then delete the last slot (swap and pop).
1724 
1725         uint256 lastTokenIndex = _allTokens.length - 1;
1726         uint256 tokenIndex = _allTokensIndex[tokenId];
1727 
1728         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1729         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1730         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1731         uint256 lastTokenId = _allTokens[lastTokenIndex];
1732 
1733         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1734         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1735 
1736         // This also deletes the contents at the last position of the array
1737         delete _allTokensIndex[tokenId];
1738         _allTokens.pop();
1739     }
1740 }
1741 
1742 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1743 
1744 
1745 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 /**
1750  * @dev These functions deal with verification of Merkle Tree proofs.
1751  *
1752  * The tree and the proofs can be generated using our
1753  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1754  * You will find a quickstart guide in the readme.
1755  *
1756  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1757  * hashing, or use a hash function other than keccak256 for hashing leaves.
1758  * This is because the concatenation of a sorted pair of internal nodes in
1759  * the merkle tree could be reinterpreted as a leaf value.
1760  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1761  * against this attack out of the box.
1762  */
1763 library MerkleProof {
1764     /**
1765      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1766      * defined by `root`. For this, a `proof` must be provided, containing
1767      * sibling hashes on the branch from the leaf to the root of the tree. Each
1768      * pair of leaves and each pair of pre-images are assumed to be sorted.
1769      */
1770     function verify(
1771         bytes32[] memory proof,
1772         bytes32 root,
1773         bytes32 leaf
1774     ) internal pure returns (bool) {
1775         return processProof(proof, leaf) == root;
1776     }
1777 
1778     /**
1779      * @dev Calldata version of {verify}
1780      *
1781      * _Available since v4.7._
1782      */
1783     function verifyCalldata(
1784         bytes32[] calldata proof,
1785         bytes32 root,
1786         bytes32 leaf
1787     ) internal pure returns (bool) {
1788         return processProofCalldata(proof, leaf) == root;
1789     }
1790 
1791     /**
1792      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1793      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1794      * hash matches the root of the tree. When processing the proof, the pairs
1795      * of leafs & pre-images are assumed to be sorted.
1796      *
1797      * _Available since v4.4._
1798      */
1799     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1800         bytes32 computedHash = leaf;
1801         for (uint256 i = 0; i < proof.length; i++) {
1802             computedHash = _hashPair(computedHash, proof[i]);
1803         }
1804         return computedHash;
1805     }
1806 
1807     /**
1808      * @dev Calldata version of {processProof}
1809      *
1810      * _Available since v4.7._
1811      */
1812     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1813         bytes32 computedHash = leaf;
1814         for (uint256 i = 0; i < proof.length; i++) {
1815             computedHash = _hashPair(computedHash, proof[i]);
1816         }
1817         return computedHash;
1818     }
1819 
1820     /**
1821      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1822      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1823      *
1824      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1825      *
1826      * _Available since v4.7._
1827      */
1828     function multiProofVerify(
1829         bytes32[] memory proof,
1830         bool[] memory proofFlags,
1831         bytes32 root,
1832         bytes32[] memory leaves
1833     ) internal pure returns (bool) {
1834         return processMultiProof(proof, proofFlags, leaves) == root;
1835     }
1836 
1837     /**
1838      * @dev Calldata version of {multiProofVerify}
1839      *
1840      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1841      *
1842      * _Available since v4.7._
1843      */
1844     function multiProofVerifyCalldata(
1845         bytes32[] calldata proof,
1846         bool[] calldata proofFlags,
1847         bytes32 root,
1848         bytes32[] memory leaves
1849     ) internal pure returns (bool) {
1850         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1851     }
1852 
1853     /**
1854      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1855      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1856      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1857      * respectively.
1858      *
1859      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1860      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1861      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1862      *
1863      * _Available since v4.7._
1864      */
1865     function processMultiProof(
1866         bytes32[] memory proof,
1867         bool[] memory proofFlags,
1868         bytes32[] memory leaves
1869     ) internal pure returns (bytes32 merkleRoot) {
1870         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1871         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1872         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1873         // the merkle tree.
1874         uint256 leavesLen = leaves.length;
1875         uint256 totalHashes = proofFlags.length;
1876 
1877         // Check proof validity.
1878         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1879 
1880         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1881         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1882         bytes32[] memory hashes = new bytes32[](totalHashes);
1883         uint256 leafPos = 0;
1884         uint256 hashPos = 0;
1885         uint256 proofPos = 0;
1886         // At each step, we compute the next hash using two values:
1887         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1888         //   get the next hash.
1889         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1890         //   `proof` array.
1891         for (uint256 i = 0; i < totalHashes; i++) {
1892             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1893             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1894             hashes[i] = _hashPair(a, b);
1895         }
1896 
1897         if (totalHashes > 0) {
1898             return hashes[totalHashes - 1];
1899         } else if (leavesLen > 0) {
1900             return leaves[0];
1901         } else {
1902             return proof[0];
1903         }
1904     }
1905 
1906     /**
1907      * @dev Calldata version of {processMultiProof}.
1908      *
1909      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1910      *
1911      * _Available since v4.7._
1912      */
1913     function processMultiProofCalldata(
1914         bytes32[] calldata proof,
1915         bool[] calldata proofFlags,
1916         bytes32[] memory leaves
1917     ) internal pure returns (bytes32 merkleRoot) {
1918         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1919         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1920         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1921         // the merkle tree.
1922         uint256 leavesLen = leaves.length;
1923         uint256 totalHashes = proofFlags.length;
1924 
1925         // Check proof validity.
1926         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1927 
1928         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1929         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1930         bytes32[] memory hashes = new bytes32[](totalHashes);
1931         uint256 leafPos = 0;
1932         uint256 hashPos = 0;
1933         uint256 proofPos = 0;
1934         // At each step, we compute the next hash using two values:
1935         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1936         //   get the next hash.
1937         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1938         //   `proof` array.
1939         for (uint256 i = 0; i < totalHashes; i++) {
1940             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1941             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1942             hashes[i] = _hashPair(a, b);
1943         }
1944 
1945         if (totalHashes > 0) {
1946             return hashes[totalHashes - 1];
1947         } else if (leavesLen > 0) {
1948             return leaves[0];
1949         } else {
1950             return proof[0];
1951         }
1952     }
1953 
1954     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1955         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1956     }
1957 
1958     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1959         /// @solidity memory-safe-assembly
1960         assembly {
1961             mstore(0x00, a)
1962             mstore(0x20, b)
1963             value := keccak256(0x00, 0x40)
1964         }
1965     }
1966 }
1967 
1968 // File: contracts/MetaverseMonkeys.sol
1969 
1970 
1971 pragma solidity ^0.8.7;
1972 
1973 
1974 
1975 
1976 
1977 
1978 contract MetaverseMonkeys is ERC721Enumerable, Ownable {
1979     using Strings for uint256;
1980     
1981     uint256 public MAX_SUPPLY = 333;
1982 
1983     string private BASE_URI;
1984     string private UNREVEAL_URI;
1985 
1986     bytes32 public PRIVATE_ROOT;
1987     bytes32 public WHITELIST_ROOT;
1988 
1989     uint256 public PRICE = 0.92 ether;
1990     uint256 public PUBLIC_MINT_LIMIT = 2;
1991 
1992     uint256 public SALE_STEP = 0; // 0 => NONE, 1 => PRIVATE, 2 => WHITELIST, 3 => PUBLIC
1993 
1994     mapping(address=>uint256) private MAP_MINTED;
1995     uint256 public SPECIAL_INDEX = 1;
1996     uint256 public PUBLIC_INDEX = 56;
1997     constructor() ERC721("Metaverse Monkeys", "MM") {}
1998 
1999     function setPrivateRoot(bytes32 _root) external onlyOwner {
2000         PRIVATE_ROOT = _root;
2001     }
2002     function setWhitelistRoot(bytes32 _root) external onlyOwner {
2003         WHITELIST_ROOT = _root;
2004     }
2005     function setMintPrice(uint256 _price) external onlyOwner {
2006         PRICE = _price;
2007     }
2008     function setPublicMintLimit(uint256 _publicMintLimit) external onlyOwner {
2009         PUBLIC_MINT_LIMIT = _publicMintLimit;
2010     }
2011 
2012     
2013     function isPrivateListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
2014         return MerkleProof.verify(_proof, PRIVATE_ROOT, _leafNode);
2015     }
2016     function isWhiteListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
2017         return MerkleProof.verify(_proof, WHITELIST_ROOT, _leafNode);
2018     }
2019     function toLeaf(address account, uint256 index, uint256 amount) public pure returns (bytes32) {
2020         return keccak256(abi.encodePacked(index, account, amount));
2021     }
2022     
2023     function numberMinted(address _owner) public view returns (uint256) {
2024         return MAP_MINTED[_owner];
2025     }
2026 
2027     function mintPrivatelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external payable {
2028         require(PUBLIC_INDEX + _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Supply");
2029 
2030         require(SALE_STEP >= 1, "Private sale is not opened");
2031 
2032         require(PRICE * _mintAmount <= msg.value, "ETH not enough");
2033 
2034         require(isPrivateListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
2035         
2036         require((numberMinted(msg.sender) + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
2037 
2038         if (numberMinted(msg.sender) == 0 && SPECIAL_INDEX <= 55) {
2039             _mintLoopSpecial(msg.sender, 1);
2040             _mintLoopPublic(msg.sender, _mintAmount - 1);
2041         } else {
2042             _mintLoopPublic(msg.sender, _mintAmount);
2043         }
2044     }
2045 
2046     function mintWhitelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external payable {
2047         require(PUBLIC_INDEX + _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Supply");
2048 
2049         require(SALE_STEP >= 2, "Whitelist sale is not opened");
2050 
2051         require(PRICE * _mintAmount <= msg.value, "ETH not enough");
2052 
2053         require(isWhiteListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
2054         
2055         require((numberMinted(msg.sender) + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
2056 
2057         _mintLoopPublic(msg.sender, _mintAmount);
2058     }
2059 
2060     function mintPublic(uint256 _mintAmount) external payable {
2061         require(PUBLIC_INDEX + _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Supply");
2062 
2063         require(SALE_STEP == 3, "Public Sale is not opened");
2064 
2065         require(PRICE * _mintAmount <= msg.value, "ETH not enough");
2066         
2067         require((numberMinted(msg.sender) + _mintAmount) <= PUBLIC_MINT_LIMIT, "Exceeds Max Mint Amount");
2068 
2069         _mintLoopPublic(msg.sender, _mintAmount);
2070     }
2071 
2072     function airdropSpecial(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
2073         require(SPECIAL_INDEX + _airdropAddresses.length * _mintAmount <= 56, "Exceeds Max Supply");
2074 
2075         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
2076             address to = _airdropAddresses[i];
2077             _mintLoopSpecial(to, _mintAmount);
2078         }
2079     }
2080 
2081     function airdropPublic(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
2082         require(PUBLIC_INDEX + _airdropAddresses.length * _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Supply");
2083 
2084         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
2085             address to = _airdropAddresses[i];
2086             _mintLoopPublic(to, _mintAmount);
2087         }
2088     }
2089 
2090     function _baseURI() internal view virtual override returns (string memory) {
2091         return BASE_URI;
2092     }
2093 
2094     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2095         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2096         string memory currentBaseURI = _baseURI();
2097         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
2098     }
2099 
2100     function setMaxSupply(uint256 _supply) external onlyOwner {
2101         MAX_SUPPLY = _supply;
2102     }
2103 
2104     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2105         BASE_URI = _newBaseURI;
2106     }
2107 
2108     function setUnrevealURI(string memory _newUnrevealURI) external onlyOwner {
2109         UNREVEAL_URI = _newUnrevealURI;
2110     }
2111 
2112     function setSaleStep(uint256 _saleStep) external onlyOwner {
2113         SALE_STEP = _saleStep;
2114     }
2115 
2116     function _mintLoopSpecial(address _receiver, uint256 _mintAmount) internal {
2117         for (uint256 i = 0; i < _mintAmount; i++) {
2118             _safeMint(_receiver, SPECIAL_INDEX + i);
2119         }
2120         SPECIAL_INDEX += _mintAmount;
2121         MAP_MINTED[_receiver] += _mintAmount;
2122     }
2123     function _mintLoopPublic(address _receiver, uint256 _mintAmount) internal {
2124         for (uint256 i = 0; i < _mintAmount; i++) {
2125             _safeMint(_receiver, PUBLIC_INDEX + i);
2126         }
2127         PUBLIC_INDEX += _mintAmount;
2128         MAP_MINTED[_receiver] += _mintAmount;
2129     }
2130 
2131     function withdraw() external onlyOwner {
2132         uint256 curBalance = address(this).balance;
2133         payable(msg.sender).transfer(curBalance);
2134     }
2135 }