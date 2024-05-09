1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.1;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      *
26      * [IMPORTANT]
27      * ====
28      * You shouldn't rely on `isContract` to protect against flash loan attacks!
29      *
30      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
31      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
32      * constructor.
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // This method relies on extcodesize/address.code.length, which returns 0
37         // for contracts in construction, since the code is only stored at the end
38         // of the constructor execution.
39 
40         return account.code.length > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Contract module that helps prevent reentrant calls to a function.
232  *
233  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
234  * available, which can be applied to functions to make sure there are no nested
235  * (reentrant) calls to them.
236  *
237  * Note that because there is a single `nonReentrant` guard, functions marked as
238  * `nonReentrant` may not call one another. This can be worked around by making
239  * those functions `private`, and then adding `external` `nonReentrant` entry
240  * points to them.
241  *
242  * TIP: If you would like to learn more about reentrancy and alternative ways
243  * to protect against it, check out our blog post
244  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
245  */
246 abstract contract ReentrancyGuard {
247     // Booleans are more expensive than uint256 or any type that takes up a full
248     // word because each write operation emits an extra SLOAD to first read the
249     // slot's contents, replace the bits taken up by the boolean, and then write
250     // back. This is the compiler's defense against contract upgrades and
251     // pointer aliasing, and it cannot be disabled.
252 
253     // The values being non-zero value makes deployment a bit more expensive,
254     // but in exchange the refund on every call to nonReentrant will be lower in
255     // amount. Since refunds are capped to a percentage of the total
256     // transaction's gas, it is best to keep them low in cases like this one, to
257     // increase the likelihood of the full refund coming into effect.
258     uint256 private constant _NOT_ENTERED = 1;
259     uint256 private constant _ENTERED = 2;
260 
261     uint256 private _status;
262 
263     constructor() {
264         _status = _NOT_ENTERED;
265     }
266 
267     /**
268      * @dev Prevents a contract from calling itself, directly or indirectly.
269      * Calling a `nonReentrant` function from another `nonReentrant`
270      * function is not supported. It is possible to prevent this from happening
271      * by making the `nonReentrant` function external, and making it call a
272      * `private` function that does the actual work.
273      */
274     modifier nonReentrant() {
275         // On the first call to nonReentrant, _notEntered will be true
276         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
277 
278         // Any calls to nonReentrant after this point will fail
279         _status = _ENTERED;
280 
281         _;
282 
283         // By storing the original value once again, a refund is triggered (see
284         // https://eips.ethereum.org/EIPS/eip-2200)
285         _status = _NOT_ENTERED;
286     }
287 }
288 
289 // FILE 2: Context.sol
290 pragma solidity ^0.8.0;
291 
292 /*
293  * @dev Provides information about the current execution context, including the
294  * sender of the transaction and its data. While these are generally available
295  * via msg.sender and msg.data, they should not be accessed in such a direct
296  * manner, since when dealing with meta-transactions the account sending and
297  * paying for execution may not be the actual sender (as far as an application
298  * is concerned).
299  *
300  * This contract is only required for intermediate, library-like contracts.
301  */
302 abstract contract Context {
303     function _msgSender() internal view virtual returns (address) {
304         return msg.sender;
305     }
306 
307     function _msgData() internal view virtual returns (bytes calldata) {
308         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
309         return msg.data;
310     }
311 }
312 
313 // File 3: Strings.sol
314 
315 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev String operations.
321  */
322 library Strings {
323     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
324 
325     /**
326      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
327      */
328     function toString(uint256 value) internal pure returns (string memory) {
329         // Inspired by OraclizeAPI's implementation - MIT licence
330         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
331 
332         if (value == 0) {
333             return "0";
334         }
335         uint256 temp = value;
336         uint256 digits;
337         while (temp != 0) {
338             digits++;
339             temp /= 10;
340         }
341         bytes memory buffer = new bytes(digits);
342         while (value != 0) {
343             digits -= 1;
344             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
345             value /= 10;
346         }
347         return string(buffer);
348     }
349 
350     /**
351      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
352      */
353     function toHexString(uint256 value) internal pure returns (string memory) {
354         if (value == 0) {
355             return "0x00";
356         }
357         uint256 temp = value;
358         uint256 length = 0;
359         while (temp != 0) {
360             length++;
361             temp >>= 8;
362         }
363         return toHexString(value, length);
364     }
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
368      */
369     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
370         bytes memory buffer = new bytes(2 * length + 2);
371         buffer[0] = "0";
372         buffer[1] = "x";
373         for (uint256 i = 2 * length + 1; i > 1; --i) {
374             buffer[i] = _HEX_SYMBOLS[value & 0xf];
375             value >>= 4;
376         }
377         require(value == 0, "Strings: hex length insufficient");
378         return string(buffer);
379     }
380 }
381 
382 
383 // File: @openzeppelin/contracts/utils/Counters.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @title Counters
392  * @author Matt Condon (@shrugs)
393  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
394  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
395  *
396  * Include with `using Counters for Counters.Counter;`
397  */
398 library Counters {
399     struct Counter {
400         // This variable should never be directly accessed by users of the library: interactions must be restricted to
401         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
402         // this feature: see https://github.com/ethereum/solidity/issues/4637
403         uint256 _value; // default: 0
404     }
405 
406     function current(Counter storage counter) internal view returns (uint256) {
407         return counter._value;
408     }
409 
410     function increment(Counter storage counter) internal {
411         unchecked {
412             counter._value += 1;
413         }
414     }
415 
416     function decrement(Counter storage counter) internal {
417         uint256 value = counter._value;
418         require(value > 0, "Counter: decrement overflow");
419         unchecked {
420             counter._value = value - 1;
421         }
422     }
423 
424     function reset(Counter storage counter) internal {
425         counter._value = 0;
426     }
427 }
428 
429 // File 4: Ownable.sol
430 
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @dev Contract module which provides a basic access control mechanism, where
437  * there is an account (an owner) that can be granted exclusive access to
438  * specific functions.
439  *
440  * By default, the owner account will be the one that deploys the contract. This
441  * can later be changed with {transferOwnership}.
442  *
443  * This module is used through inheritance. It will make available the modifier
444  * `onlyOwner`, which can be applied to your functions to restrict their use to
445  * the owner.
446  */
447 abstract contract Ownable is Context {
448     address private _owner;
449 
450     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
451 
452     /**
453      * @dev Initializes the contract setting the deployer as the initial owner.
454      */
455     constructor () {
456         address msgSender = _msgSender();
457         _owner = msgSender;
458         emit OwnershipTransferred(address(0), msgSender);
459     }
460 
461     /**
462      * @dev Returns the address of the current owner.
463      */
464     function owner() public view virtual returns (address) {
465         return _owner;
466     }
467 
468     /**
469      * @dev Throws if called by any account other than the owner.
470      */
471     modifier onlyOwner() {
472         require(owner() == _msgSender(), "Ownable: caller is not the owner");
473         _;
474     }
475 
476     /**
477      * @dev Leaves the contract without owner. It will not be possible to call
478      * `onlyOwner` functions anymore. Can only be called by the current owner.
479      *
480      * NOTE: Renouncing ownership will leave the contract without an owner,
481      * thereby removing any functionality that is only available to the owner.
482      */
483     function renounceOwnership() public virtual onlyOwner {
484         emit OwnershipTransferred(_owner, address(0));
485         _owner = address(0);
486     }
487 
488     /**
489      * @dev Transfers ownership of the contract to a new account (`newOwner`).
490      * Can only be called by the current owner.
491      */
492     function transferOwnership(address newOwner) public virtual onlyOwner {
493         require(newOwner != address(0), "Ownable: new owner is the zero address");
494         emit OwnershipTransferred(_owner, newOwner);
495         _owner = newOwner;
496     }
497 }
498 
499 
500 
501 
502 
503 // File 5: IERC165.sol
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Interface of the ERC165 standard, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-165[EIP].
510  *
511  * Implementers can declare support of contract interfaces, which can then be
512  * queried by others ({ERC165Checker}).
513  *
514  * For an implementation, see {ERC165}.
515  */
516 interface IERC165 {
517     /**
518      * @dev Returns true if this contract implements the interface defined by
519      * `interfaceId`. See the corresponding
520      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
521      * to learn more about how these ids are created.
522      *
523      * This function call must use less than 30 000 gas.
524      */
525     function supportsInterface(bytes4 interfaceId) external view returns (bool);
526 }
527 
528 
529 // File 6: IERC721.sol
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Required interface of an ERC721 compliant contract.
536  */
537 interface IERC721 is IERC165 {
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
545      */
546     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
550      */
551     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
552 
553     /**
554      * @dev Returns the number of tokens in ``owner``'s account.
555      */
556     function balanceOf(address owner) external view returns (uint256 balance);
557 
558     /**
559      * @dev Returns the owner of the `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function ownerOf(uint256 tokenId) external view returns (address owner);
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
569      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
578      *
579      * Emits a {Transfer} event.
580      */
581     function safeTransferFrom(address from, address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Transfers `tokenId` token from `from` to `to`.
585      *
586      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(address from, address to, uint256 tokenId) external;
598 
599     /**
600      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
601      * The approval is cleared when the token is transferred.
602      *
603      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
604      *
605      * Requirements:
606      *
607      * - The caller must own the token or be an approved operator.
608      * - `tokenId` must exist.
609      *
610      * Emits an {Approval} event.
611      */
612     function approve(address to, uint256 tokenId) external;
613 
614     /**
615      * @dev Returns the account approved for `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function getApproved(uint256 tokenId) external view returns (address operator);
622 
623     /**
624      * @dev Approve or remove `operator` as an operator for the caller.
625      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
637      *
638      * See {setApprovalForAll}
639      */
640     function isApprovedForAll(address owner, address operator) external view returns (bool);
641 
642     /**
643       * @dev Safely transfers `tokenId` token from `from` to `to`.
644       *
645       * Requirements:
646       *
647       * - `from` cannot be the zero address.
648       * - `to` cannot be the zero address.
649       * - `tokenId` token must exist and be owned by `from`.
650       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
652       *
653       * Emits a {Transfer} event.
654       */
655     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
656 }
657 
658 
659 
660 // File 7: IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external returns (string memory);
687 }
688 
689 
690 
691 
692 // File 8: ERC165.sol
693 
694 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Implementation of the {IERC165} interface.
701  *
702  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
703  * for the additional interface id that will be supported. For example:
704  *
705  * ```solidity
706  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
708  * }
709  * ```
710  *
711  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
712  */
713 abstract contract ERC165 is IERC165 {
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         return interfaceId == type(IERC165).interfaceId;
719     }
720 }
721 
722 
723 // File 9: ERC721.sol
724 
725 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension, but not including the Enumerable extension, which is available separately as
733  * {ERC721Enumerable}.
734  */
735 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to owner address
746     mapping(uint256 => address) private _owners;
747 
748     // Mapping owner address to token count
749     mapping(address => uint256) private _balances;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     /**
758      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view virtual override returns (uint256) {
779         require(owner != address(0), "ERC721: balance query for the zero address");
780         return _balances[owner];
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _owners[tokenId];
788         require(owner != address(0), "ERC721: owner query for nonexistent token");
789         return owner;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-tokenURI}.
808      */
809     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
810         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overridden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not owner nor approved for all"
835         );
836         if (to.isContract()) {
837             revert ("Token transfer to contract address is not allowed.");
838         } else {
839             _approve(to, tokenId);
840         }
841         // _approve(to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view virtual override returns (address) {
848         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         _setApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev See {IERC721-transferFrom}.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         //solhint-disable-next-line max-line-length
876         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
877 
878         _transfer(from, to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         safeTransferFrom(from, to, tokenId, "");
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) public virtual override {
901         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
902         _safeTransfer(from, to, tokenId, _data);
903     }
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
907      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
908      *
909      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
910      *
911      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
912      * implement alternative mechanisms to perform token transfer, such as signature-based.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must exist and be owned by `from`.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeTransfer(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) internal virtual {
929         _transfer(from, to, tokenId);
930         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
931     }
932 
933     /**
934      * @dev Returns whether `tokenId` exists.
935      *
936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
937      *
938      * Tokens start existing when they are minted (`_mint`),
939      * and stop existing when they are burned (`_burn`).
940      */
941     function _exists(uint256 tokenId) internal view virtual returns (bool) {
942         return _owners[tokenId] != address(0);
943     }
944 
945     /**
946      * @dev Returns whether `spender` is allowed to manage `tokenId`.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
953         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
954         address owner = ERC721.ownerOf(tokenId);
955         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
956     }
957 
958     /**
959      * @dev Safely mints `tokenId` and transfers it to `to`.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _safeMint(address to, uint256 tokenId) internal virtual {
969         _safeMint(to, tokenId, "");
970     }
971 
972     /**
973      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
974      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
975      */
976     function _safeMint(
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) internal virtual {
981         _mint(to, tokenId);
982         require(
983             _checkOnERC721Received(address(0), to, tokenId, _data),
984             "ERC721: transfer to non ERC721Receiver implementer"
985         );
986     }
987 
988     /**
989      * @dev Mints `tokenId` and transfers it to `to`.
990      *
991      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
992      *
993      * Requirements:
994      *
995      * - `tokenId` must not exist.
996      * - `to` cannot be the zero address.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _mint(address to, uint256 tokenId) internal virtual {
1001         require(to != address(0), "ERC721: mint to the zero address");
1002         require(!_exists(tokenId), "ERC721: token already minted");
1003 
1004         _beforeTokenTransfer(address(0), to, tokenId);
1005 
1006         _balances[to] += 1;
1007         _owners[tokenId] = to;
1008 
1009         emit Transfer(address(0), to, tokenId);
1010 
1011         _afterTokenTransfer(address(0), to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Destroys `tokenId`.
1016      * The approval is cleared when the token is burned.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _burn(uint256 tokenId) internal virtual {
1025         address owner = ERC721.ownerOf(tokenId);
1026 
1027         _beforeTokenTransfer(owner, address(0), tokenId);
1028 
1029         // Clear approvals
1030         _approve(address(0), tokenId);
1031 
1032         _balances[owner] -= 1;
1033         delete _owners[tokenId];
1034 
1035         emit Transfer(owner, address(0), tokenId);
1036 
1037         _afterTokenTransfer(owner, address(0), tokenId);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {
1056         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063 
1064         _balances[from] -= 1;
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(from, to, tokenId);
1069 
1070         _afterTokenTransfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(address to, uint256 tokenId) internal virtual {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `operator` to operate on all of `owner` tokens
1085      *
1086      * Emits a {ApprovalForAll} event.
1087      */
1088     function _setApprovalForAll(
1089         address owner,
1090         address operator,
1091         bool approved
1092     ) internal virtual {
1093         require(owner != operator, "ERC721: approve to caller");
1094         _operatorApprovals[owner][operator] = approved;
1095         emit ApprovalForAll(owner, operator, approved);
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param _data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Hook that is called before any token transfer. This includes minting
1133      * and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 
1151     /**
1152      * @dev Hook that is called after any transfer of tokens. This includes
1153      * minting and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - when `from` and `to` are both non-zero.
1158      * - `from` and `to` are never both zero.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _afterTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {}
1167 }
1168 
1169 
1170 
1171 
1172 
1173 // File 10: IERC721Enumerable.sol
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1180  * @dev See https://eips.ethereum.org/EIPS/eip-721
1181  */
1182 interface IERC721Enumerable is IERC721 {
1183 
1184     /**
1185      * @dev Returns the total amount of tokens stored by the contract.
1186      */
1187     function totalSupply() external view returns (uint256);
1188 
1189     /**
1190      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1191      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1192      */
1193     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1194 
1195     /**
1196      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1197      * Use along with {totalSupply} to enumerate all tokens.
1198      */
1199     function tokenByIndex(uint256 index) external view returns (uint256);
1200 }
1201 
1202 
1203 
1204 
1205 
1206 
1207 // File 11: ERC721Enumerable.sol
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 
1212 /**
1213  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1214  * enumerability of all the token ids in the contract as well as all token ids owned by each
1215  * account.
1216  */
1217 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1218     // Mapping from owner to list of owned token IDs
1219     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1220 
1221     // Mapping from token ID to index of the owner tokens list
1222     mapping(uint256 => uint256) private _ownedTokensIndex;
1223 
1224     // Array with all token ids, used for enumeration
1225     uint256[] private _allTokens;
1226 
1227     // Mapping from token id to position in the allTokens array
1228     mapping(uint256 => uint256) private _allTokensIndex;
1229 
1230     /**
1231      * @dev See {IERC165-supportsInterface}.
1232      */
1233     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1234         return interfaceId == type(IERC721Enumerable).interfaceId
1235             || super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1240      */
1241     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1242         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1243         return _ownedTokens[owner][index];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Enumerable-totalSupply}.
1248      */
1249     function totalSupply() public view virtual override returns (uint256) {
1250         return _allTokens.length;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Enumerable-tokenByIndex}.
1255      */
1256     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1257         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1258         return _allTokens[index];
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before any token transfer. This includes minting
1263      * and burning.
1264      *
1265      * Calling conditions:
1266      *
1267      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1268      * transferred to `to`.
1269      * - When `from` is zero, `tokenId` will be minted for `to`.
1270      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1271      * - `from` cannot be the zero address.
1272      * - `to` cannot be the zero address.
1273      *
1274      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1275      */
1276     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1277         super._beforeTokenTransfer(from, to, tokenId);
1278 
1279         if (from == address(0)) {
1280             _addTokenToAllTokensEnumeration(tokenId);
1281         } else if (from != to) {
1282             _removeTokenFromOwnerEnumeration(from, tokenId);
1283         }
1284         if (to == address(0)) {
1285             _removeTokenFromAllTokensEnumeration(tokenId);
1286         } else if (to != from) {
1287             _addTokenToOwnerEnumeration(to, tokenId);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1293      * @param to address representing the new owner of the given token ID
1294      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1295      */
1296     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1297         uint256 length = ERC721.balanceOf(to);
1298         _ownedTokens[to][length] = tokenId;
1299         _ownedTokensIndex[tokenId] = length;
1300     }
1301 
1302     /**
1303      * @dev Private function to add a token to this extension's token tracking data structures.
1304      * @param tokenId uint256 ID of the token to be added to the tokens list
1305      */
1306     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1307         _allTokensIndex[tokenId] = _allTokens.length;
1308         _allTokens.push(tokenId);
1309     }
1310 
1311     /**
1312      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1313      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1314      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1315      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1316      * @param from address representing the previous owner of the given token ID
1317      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1318      */
1319     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1320         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1321         // then delete the last slot (swap and pop).
1322 
1323         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1324         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1325 
1326         // When the token to delete is the last token, the swap operation is unnecessary
1327         if (tokenIndex != lastTokenIndex) {
1328             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1329 
1330             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1331             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1332         }
1333 
1334         // This also deletes the contents at the last position of the array
1335         delete _ownedTokensIndex[tokenId];
1336         delete _ownedTokens[from][lastTokenIndex];
1337     }
1338 
1339     /**
1340      * @dev Private function to remove a token from this extension's token tracking data structures.
1341      * This has O(1) time complexity, but alters the order of the _allTokens array.
1342      * @param tokenId uint256 ID of the token to be removed from the tokens list
1343      */
1344     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1345         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1346         // then delete the last slot (swap and pop).
1347 
1348         uint256 lastTokenIndex = _allTokens.length - 1;
1349         uint256 tokenIndex = _allTokensIndex[tokenId];
1350 
1351         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1352         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1353         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1354         uint256 lastTokenId = _allTokens[lastTokenIndex];
1355 
1356         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1357         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1358 
1359         // This also deletes the contents at the last position of the array
1360         delete _allTokensIndex[tokenId];
1361         _allTokens.pop();
1362     }
1363 }
1364 
1365 
1366 
1367 // File 12: IERC721Receiver.sol
1368 
1369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 /**
1374  * @title ERC721 token receiver interface
1375  * @dev Interface for any contract that wants to support safeTransfers
1376  * from ERC721 asset contracts.
1377  */
1378 interface IERC721Receiver {
1379     /**
1380      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1381      * by `operator` from `from`, this function is called.
1382      *
1383      * It must return its Solidity selector to confirm the token transfer.
1384      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1385      *
1386      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1387      */
1388     function onERC721Received(
1389         address operator,
1390         address from,
1391         uint256 tokenId,
1392         bytes calldata data
1393     ) external returns (bytes4);
1394 }
1395 
1396 
1397 
1398 // File 13: ERC721A.sol
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 
1403 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1404     using Address for address;
1405     using Strings for uint256;
1406 
1407     struct TokenOwnership {
1408         address addr;
1409         uint64 startTimestamp;
1410     }
1411 
1412     struct AddressData {
1413         uint128 balance;
1414         uint128 numberMinted;
1415     }
1416 
1417     uint256 internal currentIndex;
1418 
1419     // Token name
1420     string private _name;
1421 
1422     // Token symbol
1423     string private _symbol;
1424 
1425     // Mapping from token ID to ownership details
1426     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1427     mapping(uint256 => TokenOwnership) internal _ownerships;
1428 
1429     // Mapping owner address to address data
1430     mapping(address => AddressData) private _addressData;
1431 
1432     // Mapping from token ID to approved address
1433     mapping(uint256 => address) private _tokenApprovals;
1434 
1435     // Mapping from owner to operator approvals
1436     mapping(address => mapping(address => bool)) private _operatorApprovals;
1437 
1438     constructor(string memory name_, string memory symbol_) {
1439         _name = name_;
1440         _symbol = symbol_;
1441     }
1442 
1443     /**
1444      * @dev See {IERC721Enumerable-totalSupply}.
1445      */
1446     function totalSupply() public view override virtual returns (uint256) {
1447         return currentIndex;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Enumerable-tokenByIndex}.
1452      */
1453     function tokenByIndex(uint256 index) public view override returns (uint256) {
1454         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1455         return index;
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1460      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1461      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1462      */
1463     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1464         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1465         uint256 numMintedSoFar = totalSupply();
1466         uint256 tokenIdsIdx;
1467         address currOwnershipAddr;
1468 
1469         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1470         unchecked {
1471             for (uint256 i; i < numMintedSoFar; i++) {
1472                 TokenOwnership memory ownership = _ownerships[i];
1473                 if (ownership.addr != address(0)) {
1474                     currOwnershipAddr = ownership.addr;
1475                 }
1476                 if (currOwnershipAddr == owner) {
1477                     if (tokenIdsIdx == index) {
1478                         return i;
1479                     }
1480                     tokenIdsIdx++;
1481                 }
1482             }
1483         }
1484 
1485         revert('ERC721A: unable to get token of owner by index');
1486     }
1487 
1488     /**
1489      * @dev See {IERC165-supportsInterface}.
1490      */
1491     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1492         return
1493             interfaceId == type(IERC721).interfaceId ||
1494             interfaceId == type(IERC721Metadata).interfaceId ||
1495             interfaceId == type(IERC721Enumerable).interfaceId ||
1496             super.supportsInterface(interfaceId);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721-balanceOf}.
1501      */
1502     function balanceOf(address owner) public view override returns (uint256) {
1503         require(owner != address(0), 'ERC721A: balance query for the zero address');
1504         return uint256(_addressData[owner].balance);
1505     }
1506 
1507     function _numberMinted(address owner) internal view returns (uint256) {
1508         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1509         return uint256(_addressData[owner].numberMinted);
1510     }
1511 
1512     /**
1513      * Gas spent here starts off proportional to the maximum mint batch size.
1514      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1515      */
1516     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1517         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1518 
1519         unchecked {
1520             for (uint256 curr = tokenId; curr >= 0; curr--) {
1521                 TokenOwnership memory ownership = _ownerships[curr];
1522                 if (ownership.addr != address(0)) {
1523                     return ownership;
1524                 }
1525             }
1526         }
1527 
1528         revert('ERC721A: unable to determine the owner of token');
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-ownerOf}.
1533      */
1534     function ownerOf(uint256 tokenId) public view override returns (address) {
1535         return ownershipOf(tokenId).addr;
1536     }
1537 
1538     /**
1539      * @dev See {IERC721Metadata-name}.
1540      */
1541     function name() public view virtual override returns (string memory) {
1542         return _name;
1543     }
1544 
1545     /**
1546      * @dev See {IERC721Metadata-symbol}.
1547      */
1548     function symbol() public view virtual override returns (string memory) {
1549         return _symbol;
1550     }
1551 
1552     /**
1553      * @dev See {IERC721Metadata-tokenURI}.
1554      */
1555     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1556         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1557 
1558         string memory baseURI = _baseURI();
1559         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1560     }
1561 
1562     /**
1563      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1564      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1565      * by default, can be overriden in child contracts.
1566      */
1567     function _baseURI() internal view virtual returns (string memory) {
1568         return '';
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-approve}.
1573      */
1574     function approve(address to, uint256 tokenId) public override {
1575         address owner = ERC721A.ownerOf(tokenId);
1576         require(to != owner, 'ERC721A: approval to current owner');
1577 
1578         require(
1579             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1580             'ERC721A: approve caller is not owner nor approved for all'
1581         );
1582 
1583         _approve(to, tokenId, owner);
1584     }
1585 
1586     /**
1587      * @dev See {IERC721-getApproved}.
1588      */
1589     function getApproved(uint256 tokenId) public view override returns (address) {
1590         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1591 
1592         return _tokenApprovals[tokenId];
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-setApprovalForAll}.
1597      */
1598     function setApprovalForAll(address operator, bool approved) public override {
1599         require(operator != _msgSender(), 'ERC721A: approve to caller');
1600 
1601         _operatorApprovals[_msgSender()][operator] = approved;
1602         emit ApprovalForAll(_msgSender(), operator, approved);
1603     }
1604 
1605     /**
1606      * @dev See {IERC721-isApprovedForAll}.
1607      */
1608     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1609         return _operatorApprovals[owner][operator];
1610     }
1611 
1612     /**
1613      * @dev See {IERC721-transferFrom}.
1614      */
1615     function transferFrom(
1616         address from,
1617         address to,
1618         uint256 tokenId
1619     ) public override {
1620         _transfer(from, to, tokenId);
1621     }
1622 
1623     /**
1624      * @dev See {IERC721-safeTransferFrom}.
1625      */
1626     function safeTransferFrom(
1627         address from,
1628         address to,
1629         uint256 tokenId
1630     ) public override {
1631         safeTransferFrom(from, to, tokenId, '');
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-safeTransferFrom}.
1636      */
1637     function safeTransferFrom(
1638         address from,
1639         address to,
1640         uint256 tokenId,
1641         bytes memory _data
1642     ) public override {
1643         _transfer(from, to, tokenId);
1644         require(
1645             _checkOnERC721Received(from, to, tokenId, _data),
1646             'ERC721A: transfer to non ERC721Receiver implementer'
1647         );
1648     }
1649 
1650     /**
1651      * @dev Returns whether `tokenId` exists.
1652      *
1653      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1654      *
1655      * Tokens start existing when they are minted (`_mint`),
1656      */
1657     function _exists(uint256 tokenId) internal view returns (bool) {
1658         return tokenId < currentIndex;
1659     }
1660 
1661     function _safeMint(address to, uint256 quantity) internal {
1662         _safeMint(to, quantity, '');
1663     }
1664 
1665     /**
1666      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1667      *
1668      * Requirements:
1669      *
1670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1671      * - `quantity` must be greater than 0.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _safeMint(
1676         address to,
1677         uint256 quantity,
1678         bytes memory _data
1679     ) internal {
1680         _mint(to, quantity, _data, true);
1681     }
1682 
1683     /**
1684      * @dev Mints `quantity` tokens and transfers them to `to`.
1685      *
1686      * Requirements:
1687      *
1688      * - `to` cannot be the zero address.
1689      * - `quantity` must be greater than 0.
1690      *
1691      * Emits a {Transfer} event.
1692      */
1693     function _mint(
1694         address to,
1695         uint256 quantity,
1696         bytes memory _data,
1697         bool safe
1698     ) internal {
1699         uint256 startTokenId = currentIndex;
1700         require(to != address(0), 'ERC721A: mint to the zero address');
1701         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1702 
1703         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1704 
1705         // Overflows are incredibly unrealistic.
1706         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1707         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1708         unchecked {
1709             _addressData[to].balance += uint128(quantity);
1710             _addressData[to].numberMinted += uint128(quantity);
1711 
1712             _ownerships[startTokenId].addr = to;
1713             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1714 
1715             uint256 updatedIndex = startTokenId;
1716 
1717             for (uint256 i; i < quantity; i++) {
1718                 emit Transfer(address(0), to, updatedIndex);
1719                 if (safe) {
1720                     require(
1721                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1722                         'ERC721A: transfer to non ERC721Receiver implementer'
1723                     );
1724                 }
1725 
1726                 updatedIndex++;
1727             }
1728 
1729             currentIndex = updatedIndex;
1730         }
1731 
1732         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1733     }
1734 
1735     /**
1736      * @dev Transfers `tokenId` from `from` to `to`.
1737      *
1738      * Requirements:
1739      *
1740      * - `to` cannot be the zero address.
1741      * - `tokenId` token must be owned by `from`.
1742      *
1743      * Emits a {Transfer} event.
1744      */
1745     function _transfer(
1746         address from,
1747         address to,
1748         uint256 tokenId
1749     ) private {
1750         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1751 
1752         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1753             getApproved(tokenId) == _msgSender() ||
1754             isApprovedForAll(prevOwnership.addr, _msgSender()));
1755 
1756         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1757 
1758         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1759         require(to != address(0), 'ERC721A: transfer to the zero address');
1760 
1761         _beforeTokenTransfers(from, to, tokenId, 1);
1762 
1763         // Clear approvals from the previous owner
1764         _approve(address(0), tokenId, prevOwnership.addr);
1765 
1766         // Underflow of the sender's balance is impossible because we check for
1767         // ownership above and the recipient's balance can't realistically overflow.
1768         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1769         unchecked {
1770             _addressData[from].balance -= 1;
1771             _addressData[to].balance += 1;
1772 
1773             _ownerships[tokenId].addr = to;
1774             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1775 
1776             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1777             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1778             uint256 nextTokenId = tokenId + 1;
1779             if (_ownerships[nextTokenId].addr == address(0)) {
1780                 if (_exists(nextTokenId)) {
1781                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1782                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1783                 }
1784             }
1785         }
1786 
1787         emit Transfer(from, to, tokenId);
1788         _afterTokenTransfers(from, to, tokenId, 1);
1789     }
1790 
1791     /**
1792      * @dev Approve `to` to operate on `tokenId`
1793      *
1794      * Emits a {Approval} event.
1795      */
1796     function _approve(
1797         address to,
1798         uint256 tokenId,
1799         address owner
1800     ) private {
1801         _tokenApprovals[tokenId] = to;
1802         emit Approval(owner, to, tokenId);
1803     }
1804 
1805     /**
1806      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1807      * The call is not executed if the target address is not a contract.
1808      *
1809      * @param from address representing the previous owner of the given token ID
1810      * @param to target address that will receive the tokens
1811      * @param tokenId uint256 ID of the token to be transferred
1812      * @param _data bytes optional data to send along with the call
1813      * @return bool whether the call correctly returned the expected magic value
1814      */
1815     function _checkOnERC721Received(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory _data
1820     ) private returns (bool) {
1821         if (to.isContract()) {
1822             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1823                 return retval == IERC721Receiver(to).onERC721Received.selector;
1824             } catch (bytes memory reason) {
1825                 if (reason.length == 0) {
1826                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1827                 } else {
1828                     assembly {
1829                         revert(add(32, reason), mload(reason))
1830                     }
1831                 }
1832             }
1833         } else {
1834             return true;
1835         }
1836     }
1837 
1838     /**
1839      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1840      *
1841      * startTokenId - the first token id to be transferred
1842      * quantity - the amount to be transferred
1843      *
1844      * Calling conditions:
1845      *
1846      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1847      * transferred to `to`.
1848      * - When `from` is zero, `tokenId` will be minted for `to`.
1849      */
1850     function _beforeTokenTransfers(
1851         address from,
1852         address to,
1853         uint256 startTokenId,
1854         uint256 quantity
1855     ) internal virtual {}
1856 
1857     /**
1858      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1859      * minting.
1860      *
1861      * startTokenId - the first token id to be transferred
1862      * quantity - the amount to be transferred
1863      *
1864      * Calling conditions:
1865      *
1866      * - when `from` and `to` are both non-zero.
1867      * - `from` and `to` are never both zero.
1868      */
1869     function _afterTokenTransfers(
1870         address from,
1871         address to,
1872         uint256 startTokenId,
1873         uint256 quantity
1874     ) internal virtual {}
1875 }
1876 
1877 
1878 pragma solidity ^0.8.0;
1879 
1880 contract TopG is ERC721A, Ownable, ReentrancyGuard {
1881   using Strings for uint256;
1882   using Counters for Counters.Counter;
1883 
1884   string private uriPrefix = "";
1885   string public uriSuffix = ".json";
1886   string private hiddenMetadataUri;
1887 
1888     constructor() ERC721A("Top G Digital Trading Cards", "TGDTC") {
1889         setHiddenMetadataUri("ipfs://Qmdpn5pgG9AQgdGVcH6xZAN3sR32UY4revtL8XqHFSeroD/hidden.json");
1890     }
1891 
1892     uint256 public price = 0 ether;
1893     uint256 public maxPerWallet = 11;
1894     uint256 public maxSupply = 3333;
1895      
1896     bool public paused = true;
1897     bool public revealed = false;
1898 
1899     mapping(address => uint) public addressToMinted;
1900 
1901     function changePrice(uint256 _newPrice) external onlyOwner {
1902         price = _newPrice;
1903     }
1904 
1905     function withdraw() external onlyOwner {
1906         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1907         require(success, "Transfer failed.");
1908     }
1909 
1910     function mint(uint256 mintAmount) public payable {
1911         require(!paused, "The contract is paused!");
1912         require(addressToMinted[msg.sender] + mintAmount <= maxPerWallet, "TOO MANY.");
1913         require(totalSupply() + mintAmount <= maxSupply, "NO MORE.");
1914 
1915         require(msg.value >= (price * mintAmount), "MORE MONEY.");
1916         
1917         addressToMinted[msg.sender] += mintAmount;
1918 
1919         _safeMint(msg.sender, mintAmount);
1920     }
1921 
1922     function walletOfOwner(address _owner)
1923         public
1924         view
1925         returns (uint256[] memory)
1926     {
1927         uint256 ownerTokenCount = balanceOf(_owner);
1928         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1929         uint256 currentTokenId = 1;
1930         uint256 ownedTokenIndex = 0;
1931 
1932         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1933         address currentTokenOwner = ownerOf(currentTokenId);
1934             if (currentTokenOwner == _owner) {
1935                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1936                 ownedTokenIndex++;
1937             }
1938         currentTokenId++;
1939         }
1940         return ownedTokenIds;
1941     }
1942   
1943   function tokenURI(uint256 _tokenId)
1944     public
1945     view
1946     virtual
1947     override
1948     returns (string memory)
1949   {
1950     require(
1951       _exists(_tokenId),
1952       "ERC721Metadata: URI query for nonexistent token"
1953     );
1954     if (revealed == false) {
1955       return hiddenMetadataUri;
1956     }
1957     string memory currentBaseURI = _baseURI();
1958     return bytes(currentBaseURI).length > 0
1959         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1960         : "";
1961   }
1962 
1963   function setPaused(bool _state) public onlyOwner {
1964     paused = _state;
1965   }
1966 
1967   function setRevealed(bool _state) public onlyOwner {
1968     revealed = _state;
1969   }  
1970 
1971   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1972     maxSupply = _maxSupply;
1973   }
1974 
1975   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1976     hiddenMetadataUri = _hiddenMetadataUri;
1977   }  
1978 
1979   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1980     uriPrefix = _uriPrefix;
1981   }  
1982 
1983   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1984     uriSuffix = _uriSuffix;
1985   }
1986 
1987   function _baseURI() internal view virtual override returns (string memory) {
1988     return uriPrefix;
1989   }
1990 }