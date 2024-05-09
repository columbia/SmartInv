1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module that helps prevent reentrant calls to a function.
57  *
58  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
59  * available, which can be applied to functions to make sure there are no nested
60  * (reentrant) calls to them.
61  *
62  * Note that because there is a single `nonReentrant` guard, functions marked as
63  * `nonReentrant` may not call one another. This can be worked around by making
64  * those functions `private`, and then adding `external` `nonReentrant` entry
65  * points to them.
66  *
67  * TIP: If you would like to learn more about reentrancy and alternative ways
68  * to protect against it, check out our blog post
69  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
70  */
71 abstract contract ReentrancyGuard {
72     // Booleans are more expensive than uint256 or any type that takes up a full
73     // word because each write operation emits an extra SLOAD to first read the
74     // slot's contents, replace the bits taken up by the boolean, and then write
75     // back. This is the compiler's defense against contract upgrades and
76     // pointer aliasing, and it cannot be disabled.
77 
78     // The values being non-zero value makes deployment a bit more expensive,
79     // but in exchange the refund on every call to nonReentrant will be lower in
80     // amount. Since refunds are capped to a percentage of the total
81     // transaction's gas, it is best to keep them low in cases like this one, to
82     // increase the likelihood of the full refund coming into effect.
83     uint256 private constant _NOT_ENTERED = 1;
84     uint256 private constant _ENTERED = 2;
85 
86     uint256 private _status;
87 
88     constructor() {
89         _status = _NOT_ENTERED;
90     }
91 
92     /**
93      * @dev Prevents a contract from calling itself, directly or indirectly.
94      * Calling a `nonReentrant` function from another `nonReentrant`
95      * function is not supported. It is possible to prevent this from happening
96      * by making the `nonReentrant` function external, and making it call a
97      * `private` function that does the actual work.
98      */
99     modifier nonReentrant() {
100         // On the first call to nonReentrant, _notEntered will be true
101         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
102 
103         // Any calls to nonReentrant after this point will fail
104         _status = _ENTERED;
105 
106         _;
107 
108         // By storing the original value once again, a refund is triggered (see
109         // https://eips.ethereum.org/EIPS/eip-2200)
110         _status = _NOT_ENTERED;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 // File: @openzeppelin/contracts/utils/Context.sol
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 // File: @openzeppelin/contracts/access/Ownable.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Contract module which provides a basic access control mechanism, where
221  * there is an account (an owner) that can be granted exclusive access to
222  * specific functions.
223  *
224  * By default, the owner account will be the one that deploys the contract. This
225  * can later be changed with {transferOwnership}.
226  *
227  * This module is used through inheritance. It will make available the modifier
228  * `onlyOwner`, which can be applied to your functions to restrict their use to
229  * the owner.
230  */
231 abstract contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor() {
240         _transferOwnership(_msgSender());
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view virtual returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * NOTE: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public virtual onlyOwner {
266         _transferOwnership(address(0));
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         _transferOwnership(newOwner);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Internal function without access restriction.
281      */
282     function _transferOwnership(address newOwner) internal virtual {
283         address oldOwner = _owner;
284         _owner = newOwner;
285         emit OwnershipTransferred(oldOwner, newOwner);
286     }
287 }
288 
289 // File: @openzeppelin/contracts/utils/Address.sol
290 
291 
292 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
293 
294 pragma solidity ^0.8.1;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      *
317      * [IMPORTANT]
318      * ====
319      * You shouldn't rely on `isContract` to protect against flash loan attacks!
320      *
321      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
322      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
323      * constructor.
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize/address.code.length, which returns 0
328         // for contracts in construction, since the code is only stored at the end
329         // of the constructor execution.
330 
331         return account.code.length > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain `call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(address(this).balance >= value, "Address: insufficient balance for call");
425         require(isContract(target), "Address: call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.call{value: value}(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
487      * revert reason using the provided one.
488      *
489      * _Available since v4.3._
490      */
491     function verifyCallResult(
492         bool success,
493         bytes memory returndata,
494         string memory errorMessage
495     ) internal pure returns (bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 assembly {
504                     let returndata_size := mload(returndata)
505                     revert(add(32, returndata), returndata_size)
506                 }
507             } else {
508                 revert(errorMessage);
509             }
510         }
511     }
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @title ERC721 token receiver interface
523  * @dev Interface for any contract that wants to support safeTransfers
524  * from ERC721 asset contracts.
525  */
526 interface IERC721Receiver {
527     /**
528      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
529      * by `operator` from `from`, this function is called.
530      *
531      * It must return its Solidity selector to confirm the token transfer.
532      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
533      *
534      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
535      */
536     function onERC721Received(
537         address operator,
538         address from,
539         uint256 tokenId,
540         bytes calldata data
541     ) external returns (bytes4);
542 }
543 
544 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Interface of the ERC165 standard, as defined in the
553  * https://eips.ethereum.org/EIPS/eip-165[EIP].
554  *
555  * Implementers can declare support of contract interfaces, which can then be
556  * queried by others ({ERC165Checker}).
557  *
558  * For an implementation, see {ERC165}.
559  */
560 interface IERC165 {
561     /**
562      * @dev Returns true if this contract implements the interface defined by
563      * `interfaceId`. See the corresponding
564      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
565      * to learn more about how these ids are created.
566      *
567      * This function call must use less than 30 000 gas.
568      */
569     function supportsInterface(bytes4 interfaceId) external view returns (bool);
570 }
571 
572 // File: @openzeppelin/contracts/interfaces/IERC165.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Interface for the NFT Royalty Standard.
590  *
591  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
592  * support for royalty payments across all NFT marketplaces and ecosystem participants.
593  *
594  * _Available since v4.5._
595  */
596 interface IERC2981 is IERC165 {
597     /**
598      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
599      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
600      */
601     function royaltyInfo(uint256 tokenId, uint256 salePrice)
602         external
603         view
604         returns (address receiver, uint256 royaltyAmount);
605 }
606 
607 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 /**
616  * @dev Implementation of the {IERC165} interface.
617  *
618  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
619  * for the additional interface id that will be supported. For example:
620  *
621  * ```solidity
622  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
623  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
624  * }
625  * ```
626  *
627  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
628  */
629 abstract contract ERC165 is IERC165 {
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634         return interfaceId == type(IERC165).interfaceId;
635     }
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @dev Required interface of an ERC721 compliant contract.
648  */
649 interface IERC721 is IERC165 {
650     /**
651      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
652      */
653     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
654 
655     /**
656      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
657      */
658     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
659 
660     /**
661      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
662      */
663     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
664 
665     /**
666      * @dev Returns the number of tokens in ``owner``'s account.
667      */
668     function balanceOf(address owner) external view returns (uint256 balance);
669 
670     /**
671      * @dev Returns the owner of the `tokenId` token.
672      *
673      * Requirements:
674      *
675      * - `tokenId` must exist.
676      */
677     function ownerOf(uint256 tokenId) external view returns (address owner);
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
681      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Transfers `tokenId` token from `from` to `to`.
701      *
702      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
703      *
704      * Requirements:
705      *
706      * - `from` cannot be the zero address.
707      * - `to` cannot be the zero address.
708      * - `tokenId` token must be owned by `from`.
709      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
710      *
711      * Emits a {Transfer} event.
712      */
713     function transferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) external;
718 
719     /**
720      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
721      * The approval is cleared when the token is transferred.
722      *
723      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
724      *
725      * Requirements:
726      *
727      * - The caller must own the token or be an approved operator.
728      * - `tokenId` must exist.
729      *
730      * Emits an {Approval} event.
731      */
732     function approve(address to, uint256 tokenId) external;
733 
734     /**
735      * @dev Returns the account approved for `tokenId` token.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function getApproved(uint256 tokenId) external view returns (address operator);
742 
743     /**
744      * @dev Approve or remove `operator` as an operator for the caller.
745      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
746      *
747      * Requirements:
748      *
749      * - The `operator` cannot be the caller.
750      *
751      * Emits an {ApprovalForAll} event.
752      */
753     function setApprovalForAll(address operator, bool _approved) external;
754 
755     /**
756      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
757      *
758      * See {setApprovalForAll}
759      */
760     function isApprovedForAll(address owner, address operator) external view returns (bool);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
771      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
772      *
773      * Emits a {Transfer} event.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes calldata data
780     ) external;
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 /**
792  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
793  * @dev See https://eips.ethereum.org/EIPS/eip-721
794  */
795 interface IERC721Metadata is IERC721 {
796     /**
797      * @dev Returns the token collection name.
798      */
799     function name() external view returns (string memory);
800 
801     /**
802      * @dev Returns the token collection symbol.
803      */
804     function symbol() external view returns (string memory);
805 
806     /**
807      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
808      */
809     function tokenURI(uint256 tokenId) external view returns (string memory);
810 }
811 
812 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
813 
814 
815 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 
820 
821 
822 
823 
824 
825 
826 /**
827  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
828  * the Metadata extension, but not including the Enumerable extension, which is available separately as
829  * {ERC721Enumerable}.
830  */
831 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
832     using Address for address;
833     using Strings for uint256;
834 
835     // Token name
836     string private _name;
837 
838     // Token symbol
839     string private _symbol;
840 
841     // Mapping from token ID to owner address
842     mapping(uint256 => address) private _owners;
843 
844     // Mapping owner address to token count
845     mapping(address => uint256) private _balances;
846 
847     // Mapping from token ID to approved address
848     mapping(uint256 => address) private _tokenApprovals;
849 
850     // Mapping from owner to operator approvals
851     mapping(address => mapping(address => bool)) private _operatorApprovals;
852 
853     /**
854      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
855      */
856     constructor(string memory name_, string memory symbol_) {
857         _name = name_;
858         _symbol = symbol_;
859     }
860 
861     /**
862      * @dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
865         return
866             interfaceId == type(IERC721).interfaceId ||
867             interfaceId == type(IERC721Metadata).interfaceId ||
868             super.supportsInterface(interfaceId);
869     }
870 
871     /**
872      * @dev See {IERC721-balanceOf}.
873      */
874     function balanceOf(address owner) public view virtual override returns (uint256) {
875         require(owner != address(0), "ERC721: balance query for the zero address");
876         return _balances[owner];
877     }
878 
879     /**
880      * @dev See {IERC721-ownerOf}.
881      */
882     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
883         address owner = _owners[tokenId];
884         require(owner != address(0), "ERC721: owner query for nonexistent token");
885         return owner;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-name}.
890      */
891     function name() public view virtual override returns (string memory) {
892         return _name;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-symbol}.
897      */
898     function symbol() public view virtual override returns (string memory) {
899         return _symbol;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-tokenURI}.
904      */
905     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
906         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
907 
908         string memory baseURI = _baseURI();
909         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
910     }
911 
912     /**
913      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
914      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
915      * by default, can be overriden in child contracts.
916      */
917     function _baseURI() internal view virtual returns (string memory) {
918         return "";
919     }
920 
921     /**
922      * @dev See {IERC721-approve}.
923      */
924     function approve(address to, uint256 tokenId) public virtual override {
925         address owner = ERC721.ownerOf(tokenId);
926         require(to != owner, "ERC721: approval to current owner");
927 
928         require(
929             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
930             "ERC721: approve caller is not owner nor approved for all"
931         );
932 
933         _approve(to, tokenId);
934     }
935 
936     /**
937      * @dev See {IERC721-getApproved}.
938      */
939     function getApproved(uint256 tokenId) public view virtual override returns (address) {
940         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
941 
942         return _tokenApprovals[tokenId];
943     }
944 
945     /**
946      * @dev See {IERC721-setApprovalForAll}.
947      */
948     function setApprovalForAll(address operator, bool approved) public virtual override {
949         _setApprovalForAll(_msgSender(), operator, approved);
950     }
951 
952     /**
953      * @dev See {IERC721-isApprovedForAll}.
954      */
955     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev See {IERC721-transferFrom}.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public virtual override {
967         //solhint-disable-next-line max-line-length
968         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
969 
970         _transfer(from, to, tokenId);
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public virtual override {
981         safeTransferFrom(from, to, tokenId, "");
982     }
983 
984     /**
985      * @dev See {IERC721-safeTransferFrom}.
986      */
987     function safeTransferFrom(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) public virtual override {
993         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
994         _safeTransfer(from, to, tokenId, _data);
995     }
996 
997     /**
998      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
999      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1000      *
1001      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1002      *
1003      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1004      * implement alternative mechanisms to perform token transfer, such as signature-based.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must exist and be owned by `from`.
1011      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _safeTransfer(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) internal virtual {
1021         _transfer(from, to, tokenId);
1022         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1023     }
1024 
1025     /**
1026      * @dev Returns whether `tokenId` exists.
1027      *
1028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1029      *
1030      * Tokens start existing when they are minted (`_mint`),
1031      * and stop existing when they are burned (`_burn`).
1032      */
1033     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1034         return _owners[tokenId] != address(0);
1035     }
1036 
1037     /**
1038      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      */
1044     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1045         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1046         address owner = ERC721.ownerOf(tokenId);
1047         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1048     }
1049 
1050     /**
1051      * @dev Safely mints `tokenId` and transfers it to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must not exist.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _safeMint(address to, uint256 tokenId) internal virtual {
1061         _safeMint(to, tokenId, "");
1062     }
1063 
1064     /**
1065      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1066      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1067      */
1068     function _safeMint(
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) internal virtual {
1073         _mint(to, tokenId);
1074         require(
1075             _checkOnERC721Received(address(0), to, tokenId, _data),
1076             "ERC721: transfer to non ERC721Receiver implementer"
1077         );
1078     }
1079 
1080     /**
1081      * @dev Mints `tokenId` and transfers it to `to`.
1082      *
1083      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must not exist.
1088      * - `to` cannot be the zero address.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(address to, uint256 tokenId) internal virtual {
1093         require(to != address(0), "ERC721: mint to the zero address");
1094         require(!_exists(tokenId), "ERC721: token already minted");
1095 
1096         _beforeTokenTransfer(address(0), to, tokenId);
1097 
1098         _balances[to] += 1;
1099         _owners[tokenId] = to;
1100 
1101         emit Transfer(address(0), to, tokenId);
1102 
1103         _afterTokenTransfer(address(0), to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev Destroys `tokenId`.
1108      * The approval is cleared when the token is burned.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _burn(uint256 tokenId) internal virtual {
1117         address owner = ERC721.ownerOf(tokenId);
1118 
1119         _beforeTokenTransfer(owner, address(0), tokenId);
1120 
1121         // Clear approvals
1122         _approve(address(0), tokenId);
1123 
1124         _balances[owner] -= 1;
1125         delete _owners[tokenId];
1126 
1127         emit Transfer(owner, address(0), tokenId);
1128 
1129         _afterTokenTransfer(owner, address(0), tokenId);
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {
1148         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1149         require(to != address(0), "ERC721: transfer to the zero address");
1150 
1151         _beforeTokenTransfer(from, to, tokenId);
1152 
1153         // Clear approvals from the previous owner
1154         _approve(address(0), tokenId);
1155 
1156         _balances[from] -= 1;
1157         _balances[to] += 1;
1158         _owners[tokenId] = to;
1159 
1160         emit Transfer(from, to, tokenId);
1161 
1162         _afterTokenTransfer(from, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Approve `to` to operate on `tokenId`
1167      *
1168      * Emits a {Approval} event.
1169      */
1170     function _approve(address to, uint256 tokenId) internal virtual {
1171         _tokenApprovals[tokenId] = to;
1172         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Approve `operator` to operate on all of `owner` tokens
1177      *
1178      * Emits a {ApprovalForAll} event.
1179      */
1180     function _setApprovalForAll(
1181         address owner,
1182         address operator,
1183         bool approved
1184     ) internal virtual {
1185         require(owner != operator, "ERC721: approve to caller");
1186         _operatorApprovals[owner][operator] = approved;
1187         emit ApprovalForAll(owner, operator, approved);
1188     }
1189 
1190     /**
1191      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1192      * The call is not executed if the target address is not a contract.
1193      *
1194      * @param from address representing the previous owner of the given token ID
1195      * @param to target address that will receive the tokens
1196      * @param tokenId uint256 ID of the token to be transferred
1197      * @param _data bytes optional data to send along with the call
1198      * @return bool whether the call correctly returned the expected magic value
1199      */
1200     function _checkOnERC721Received(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) private returns (bool) {
1206         if (to.isContract()) {
1207             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1208                 return retval == IERC721Receiver.onERC721Received.selector;
1209             } catch (bytes memory reason) {
1210                 if (reason.length == 0) {
1211                     revert("ERC721: transfer to non ERC721Receiver implementer");
1212                 } else {
1213                     assembly {
1214                         revert(add(32, reason), mload(reason))
1215                     }
1216                 }
1217             }
1218         } else {
1219             return true;
1220         }
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before any token transfer. This includes minting
1225      * and burning.
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` will be minted for `to`.
1232      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1233      * - `from` and `to` are never both zero.
1234      *
1235      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1236      */
1237     function _beforeTokenTransfer(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Hook that is called after any transfer of tokens. This includes
1245      * minting and burning.
1246      *
1247      * Calling conditions:
1248      *
1249      * - when `from` and `to` are both non-zero.
1250      * - `from` and `to` are never both zero.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _afterTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) internal virtual {}
1259 }
1260 
1261 // File: contracts/MutantMfers.sol
1262 
1263 
1264 
1265 /*
1266 
1267  ███▄ ▄███▓ █    ██ ▄▄▄█████▓ ▄▄▄       ███▄    █ ▄▄▄█████▓    ███▄ ▄███▓  █████▒▓█████  ██▀███    ██████ 
1268 ▓██▒▀█▀ ██▒ ██  ▓██▒▓  ██▒ ▓▒▒████▄     ██ ▀█   █ ▓  ██▒ ▓▒   ▓██▒▀█▀ ██▒▓██   ▒ ▓█   ▀ ▓██ ▒ ██▒▒██    ▒ 
1269 ▓██    ▓██░▓██  ▒██░▒ ▓██░ ▒░▒██  ▀█▄  ▓██  ▀█ ██▒▒ ▓██░ ▒░   ▓██    ▓██░▒████ ░ ▒███   ▓██ ░▄█ ▒░ ▓██▄   
1270 ▒██    ▒██ ▓▓█  ░██░░ ▓██▓ ░ ░██▄▄▄▄██ ▓██▒  ▐▌██▒░ ▓██▓ ░    ▒██    ▒██ ░▓█▒  ░ ▒▓█  ▄ ▒██▀▀█▄    ▒   ██▒
1271 ▒██▒   ░██▒▒▒█████▓   ▒██▒ ░  ▓█   ▓██▒▒██░   ▓██░  ▒██▒ ░    ▒██▒   ░██▒░▒█░    ░▒████▒░██▓ ▒██▒▒██████▒▒
1272 ░ ▒░   ░  ░░▒▓▒ ▒ ▒   ▒ ░░    ▒▒   ▓▒█░░ ▒░   ▒ ▒   ▒ ░░      ░ ▒░   ░  ░ ▒ ░    ░░ ▒░ ░░ ▒▓ ░▒▓░▒ ▒▓▒ ▒ ░
1273 ░  ░      ░░░▒░ ░ ░     ░      ▒   ▒▒ ░░ ░░   ░ ▒░    ░       ░  ░      ░ ░       ░ ░  ░  ░▒ ░ ▒░░ ░▒  ░ ░
1274 ░      ░    ░░░ ░ ░   ░        ░   ▒      ░   ░ ░   ░         ░      ░    ░ ░       ░     ░░   ░ ░  ░  ░  
1275        ░      ░                    ░  ░         ░                    ░              ░  ░   ░           ░  
1276                                                                                                           
1277 */
1278 
1279 pragma solidity ^0.8.9;
1280 
1281 
1282 
1283 
1284 
1285 
1286 
1287 contract MutantMfers is ERC721, IERC2981, ReentrancyGuard, Ownable {
1288   using Counters for Counters.Counter;
1289   Counters.Counter private supplyCounter;
1290 
1291   string private customBaseURI = "https://api.mutantmfers.art/mutant/";
1292   string private customURIExt = "";
1293 
1294   uint256 private price = 26900000000000000;
1295   uint256 private royalty = 500;
1296   uint256 private constant MAX_SUPPLY = 10027;
1297   uint256 private MAX_MULTIMINT = 5;
1298 
1299   address private immutable accessTokenAddress = 0x79FCDEF22feeD20eDDacbB2587640e45491b757f;
1300 
1301   constructor() ERC721("MutantMfers", "MMFERS") {}
1302 
1303   /** URI HANDLING **/
1304 
1305   mapping(uint256 => string) private tokenURIMap;
1306 
1307   function setTokenURIMint(uint256 tokenId, string memory tokenURI_) private
1308   {
1309     tokenURIMap[tokenId] = tokenURI_;
1310   }
1311   
1312   function setTokenURI(uint256 tokenId, string memory tokenURI_) external onlyOwner
1313   {
1314     require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1315     tokenURIMap[tokenId] = tokenURI_;
1316   }
1317 
1318   function setBaseURI(string memory customBaseURI_) external onlyOwner {
1319     customBaseURI = customBaseURI_;
1320   }
1321 
1322   function setURIExt(string memory customURIExt_) external onlyOwner {
1323     customURIExt = customURIExt_;
1324   }
1325 
1326   function _baseURI() internal view virtual override returns (string memory) {
1327     return customBaseURI;
1328   }
1329 
1330   function tokenURI(uint256 tokenId) public view override
1331     returns (string memory)
1332   {
1333     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1334     string memory tokenURI_ = tokenURIMap[tokenId];
1335     if (bytes(tokenURI_).length > 0) {
1336       return tokenURI_;
1337     }
1338     return string(abi.encodePacked(super.tokenURI(tokenId), customURIExt));
1339   }
1340 
1341   /** MINTING **/
1342 
1343   function setPrice(uint256 price_) external onlyOwner
1344   {
1345     price = price_;
1346   }
1347 
1348   bool public metaMigrated = false;
1349   function setMetaMigrated(bool metaMigrated_) external onlyOwner {
1350     metaMigrated = metaMigrated_;
1351   }
1352 
1353   modifier mintCompliance(uint256[] calldata ids) {
1354     uint256 count = ids.length;
1355     require(saleIsActive, "The lab is not open");
1356     require(totalSupply() + count - 1 < MAX_SUPPLY, "Exceeds max supply");
1357     require(count <= MAX_MULTIMINT, "Mutate at most 5 mfers at a time");
1358     _;
1359   }
1360 
1361   function mint(address _recipient, uint256[] calldata ids) external onlyOwner nonReentrant mintCompliance(ids)	{
1362 		uint256 count = ids.length;
1363     require(!metaMigrated, "You can't mutate this way");  
1364     for (uint256 i = 0; i < count; i++) {
1365       uint256 id = ids[i];
1366       _mint(_recipient, id);
1367       supplyCounter.increment();
1368     }
1369   }
1370 
1371   function mutate(uint256[] calldata ids) public payable nonReentrant mintCompliance(ids) {
1372     uint256 count = ids.length;
1373     require(!metaMigrated, "You can't mutate this way");
1374     require(msg.value >= price * count, "Insufficient payment");
1375     ERC721 accessToken = ERC721(accessTokenAddress);
1376     for (uint256 i = 0; i < count; i++) {
1377       uint256 id = ids[i];
1378       if (accessTokenIsActive) {
1379         require(
1380           accessToken.ownerOf(id) == msg.sender,
1381           "Mfer not owned"
1382         );
1383       }
1384       _mint(msg.sender, id);
1385       supplyCounter.increment();
1386     }
1387   }
1388 
1389   function mutate2(uint256[] calldata ids, string[] memory syringeHash) public payable nonReentrant mintCompliance(ids) {
1390     uint256 count = ids.length;
1391     require(metaMigrated, "You can't mutate this way");
1392     require(msg.value >= price * count, "Insufficient payment");
1393     ERC721 accessToken = ERC721(accessTokenAddress);
1394     for (uint256 i = 0; i < count; i++) {
1395       uint256 id = ids[i];
1396       if (accessTokenIsActive) {
1397         require(
1398           accessToken.ownerOf(id) == msg.sender,
1399           "Mfer not owned"
1400         );
1401       }
1402       _mint(msg.sender, id);
1403       setTokenURIMint(id, syringeHash[i]);
1404       supplyCounter.increment();
1405     }
1406   }
1407 
1408   function totalSupply() public view returns (uint256) {
1409     return supplyCounter.current();
1410   }
1411 
1412   /** ACTIVATION **/
1413 
1414   bool public saleIsActive = false;
1415   function setSaleIsActive(bool saleIsActive_) external onlyOwner {
1416     saleIsActive = saleIsActive_;
1417   }
1418 
1419   bool public accessTokenIsActive = true;
1420   function setAccessTokenIsActive(bool accessTokenIsActive_) external onlyOwner
1421   {
1422     accessTokenIsActive = accessTokenIsActive_;
1423   }
1424 
1425   /** PAYOUT **/
1426 
1427   address private constant payoutAddress1 =
1428     0xffB99aaB5E7B7B9507Df1979300a52034C1c60Cc;
1429 
1430   function withdraw() public nonReentrant {
1431     uint256 balance = address(this).balance;
1432     Address.sendValue(payable(payoutAddress1), balance);
1433   }
1434 
1435   /** ROYALTIES **/
1436 
1437   function setRoyalty(uint256 royalty_) external onlyOwner
1438   {
1439     royalty = royalty_;
1440   }
1441 
1442   function royaltyInfo(uint256, uint256 salePrice) external view override
1443     returns (address receiver, uint256 royaltyAmount)
1444   {
1445     return (address(this), (salePrice * royalty) / 10000);
1446   }
1447 
1448   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165)
1449     returns (bool)
1450   {
1451     return (
1452       interfaceId == type(IERC2981).interfaceId ||
1453       super.supportsInterface(interfaceId)
1454     );
1455   }
1456 }