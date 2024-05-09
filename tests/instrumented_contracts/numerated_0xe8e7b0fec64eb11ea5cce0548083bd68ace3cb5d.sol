1 // File: contracts/MetadataUtils.sol
2 
3 pragma solidity ^0.8.0;
4 
5 function toString(uint256 value) pure returns (string memory) {
6     // Inspired by OraclizeAPI's implementation - MIT license
7     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
8 
9     if (value == 0) {
10         return "0";
11     }
12     uint256 temp = value;
13     uint256 digits;
14     while (temp != 0) {
15         digits++;
16         temp /= 10;
17     }
18     bytes memory buffer = new bytes(digits);
19     while (value != 0) {
20         digits -= 1;
21         buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
22         value /= 10;
23     }
24     return string(buffer);
25 }
26 
27 /// [MIT License]
28 /// @title Base64
29 /// @notice Provides a function for encoding some bytes in base64
30 /// @author Brecht Devos <brecht@loopring.org>
31 library Base64 {
32     bytes internal constant TABLE =
33         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
34 
35     /// @notice Encodes some bytes to the base64 representation
36     function encode(bytes memory data) internal pure returns (string memory) {
37         uint256 len = data.length;
38         if (len == 0) return "";
39 
40         // multiply by 4/3 rounded up
41         uint256 encodedLen = 4 * ((len + 2) / 3);
42 
43         // Add some extra buffer at the end
44         bytes memory result = new bytes(encodedLen + 32);
45 
46         bytes memory table = TABLE;
47 
48         assembly {
49             let tablePtr := add(table, 1)
50             let resultPtr := add(result, 32)
51 
52             for {
53                 let i := 0
54             } lt(i, len) {
55 
56             } {
57                 i := add(i, 3)
58                 let input := and(mload(add(data, i)), 0xffffff)
59 
60                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
61                 out := shl(8, out)
62                 out := add(
63                     out,
64                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
65                 )
66                 out := shl(8, out)
67                 out := add(
68                     out,
69                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
70                 )
71                 out := shl(8, out)
72                 out := add(
73                     out,
74                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
75                 )
76                 out := shl(224, out)
77 
78                 mstore(resultPtr, out)
79 
80                 resultPtr := add(resultPtr, 4)
81             }
82 
83             switch mod(len, 3)
84             case 1 {
85                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
86             }
87             case 2 {
88                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
89             }
90 
91             mstore(result, encodedLen)
92         }
93 
94         return string(result);
95     }
96 }
97 // File: contracts/Context.sol
98 
99 
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         return msg.data;
120     }
121 }
122 // File: contracts/Ownable.sol
123 
124 pragma solidity ^0.8.0;
125 
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor() {
148         _setOwner(_msgSender());
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         _setOwner(address(0));
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         _setOwner(newOwner);
184     }
185 
186     function _setOwner(address newOwner) private {
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 // File: contracts/ReentrancyGuard.sol
193 
194 pragma solidity ^0.8.0;
195 
196 
197 /**
198  * @dev Contract module that helps prevent reentrant calls to a function.
199  *
200  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
201  * available, which can be applied to functions to make sure there are no nested
202  * (reentrant) calls to them.
203  *
204  * Note that because there is a single `nonReentrant` guard, functions marked as
205  * `nonReentrant` may not call one another. This can be worked around by making
206  * those functions `private`, and then adding `external` `nonReentrant` entry
207  * points to them.
208  *
209  * TIP: If you would like to learn more about reentrancy and alternative ways
210  * to protect against it, check out our blog post
211  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
212  */
213 abstract contract ReentrancyGuard {
214     // Booleans are more expensive than uint256 or any type that takes up a full
215     // word because each write operation emits an extra SLOAD to first read the
216     // slot's contents, replace the bits taken up by the boolean, and then write
217     // back. This is the compiler's defense against contract upgrades and
218     // pointer aliasing, and it cannot be disabled.
219 
220     // The values being non-zero value makes deployment a bit more expensive,
221     // but in exchange the refund on every call to nonReentrant will be lower in
222     // amount. Since refunds are capped to a percentage of the total
223     // transaction's gas, it is best to keep them low in cases like this one, to
224     // increase the likelihood of the full refund coming into effect.
225     uint256 private constant _NOT_ENTERED = 1;
226     uint256 private constant _ENTERED = 2;
227 
228     uint256 private _status;
229 
230     constructor() {
231         _status = _NOT_ENTERED;
232     }
233 
234     /**
235      * @dev Prevents a contract from calling itself, directly or indirectly.
236      * Calling a `nonReentrant` function from another `nonReentrant`
237      * function is not supported. It is possible to prevent this from happening
238      * by making the `nonReentrant` function external, and make it call a
239      * `private` function that does the actual work.
240      */
241     modifier nonReentrant() {
242         // On the first call to nonReentrant, _notEntered will be true
243         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
244 
245         // Any calls to nonReentrant after this point will fail
246         _status = _ENTERED;
247 
248         _;
249 
250         // By storing the original value once again, a refund is triggered (see
251         // https://eips.ethereum.org/EIPS/eip-2200)
252         _status = _NOT_ENTERED;
253     }
254 }
255 // File: contracts/IERC165.sol
256 
257 
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Interface of the ERC165 standard, as defined in the
263  * https://eips.ethereum.org/EIPS/eip-165[EIP].
264  *
265  * Implementers can declare support of contract interfaces, which can then be
266  * queried by others ({ERC165Checker}).
267  *
268  * For an implementation, see {ERC165}.
269  */
270 interface IERC165 {
271     /**
272      * @dev Returns true if this contract implements the interface defined by
273      * `interfaceId`. See the corresponding
274      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
275      * to learn more about how these ids are created.
276      *
277      * This function call must use less than 30 000 gas.
278      */
279     function supportsInterface(bytes4 interfaceId) external view returns (bool);
280 }
281 
282 // File: contracts/IERC1155.sol
283 
284 
285 
286 pragma solidity ^0.8.0;
287 
288 
289 /**
290  * @dev Required interface of an ERC1155 compliant contract, as defined in the
291  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
292  *
293  * _Available since v3.1._
294  */
295 interface IERC1155 is IERC165 {
296     /**
297      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
298      */
299     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
300 
301     /**
302      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
303      * transfers.
304      */
305     event TransferBatch(
306         address indexed operator,
307         address indexed from,
308         address indexed to,
309         uint256[] ids,
310         uint256[] values
311     );
312 
313     /**
314      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
315      * `approved`.
316      */
317     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
318 
319     /**
320      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
321      *
322      * If an {URI} event was emitted for `id`, the standard
323      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
324      * returned by {IERC1155MetadataURI-uri}.
325      */
326     event URI(string value, uint256 indexed id);
327 
328     /**
329      * @dev Returns the amount of tokens of token type `id` owned by `account`.
330      *
331      * Requirements:
332      *
333      * - `account` cannot be the zero address.
334      */
335     function balanceOf(address account, uint256 id) external view returns (uint256);
336 
337     /**
338      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
339      *
340      * Requirements:
341      *
342      * - `accounts` and `ids` must have the same length.
343      */
344     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
345         external
346         view
347         returns (uint256[] memory);
348 
349     /**
350      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
351      *
352      * Emits an {ApprovalForAll} event.
353      *
354      * Requirements:
355      *
356      * - `operator` cannot be the caller.
357      */
358     function setApprovalForAll(address operator, bool approved) external;
359 
360     /**
361      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
362      *
363      * See {setApprovalForAll}.
364      */
365     function isApprovedForAll(address account, address operator) external view returns (bool);
366 
367     /**
368      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
369      *
370      * Emits a {TransferSingle} event.
371      *
372      * Requirements:
373      *
374      * - `to` cannot be the zero address.
375      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
376      * - `from` must have a balance of tokens of type `id` of at least `amount`.
377      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
378      * acceptance magic value.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 id,
384         uint256 amount,
385         bytes calldata data
386     ) external;
387 
388     /**
389      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
390      *
391      * Emits a {TransferBatch} event.
392      *
393      * Requirements:
394      *
395      * - `ids` and `amounts` must have the same length.
396      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
397      * acceptance magic value.
398      */
399     function safeBatchTransferFrom(
400         address from,
401         address to,
402         uint256[] calldata ids,
403         uint256[] calldata amounts,
404         bytes calldata data
405     ) external;
406 }
407 
408 // File: contracts/IERC721.sol
409 
410 
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Required interface of an ERC721 compliant contract.
417  */
418 interface IERC721 is IERC165 {
419     /**
420      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
426      */
427     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
431      */
432     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
433 
434     /**
435      * @dev Returns the number of tokens in ``owner``'s account.
436      */
437     function balanceOf(address owner) external view returns (uint256 balance);
438 
439     /**
440      * @dev Returns the owner of the `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function ownerOf(uint256 tokenId) external view returns (address owner);
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 }
551 // File: contracts/IERC721Enumerable.sol
552 
553 
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
560  * @dev See https://eips.ethereum.org/EIPS/eip-721
561  */
562 interface IERC721Enumerable is IERC721 {
563     /**
564      * @dev Returns the total amount of tokens stored by the contract.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     /**
569      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
570      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
571      */
572     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
573 
574     /**
575      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
576      * Use along with {totalSupply} to enumerate all tokens.
577      */
578     function tokenByIndex(uint256 index) external view returns (uint256);
579 }
580 // File: contracts/ERC165.sol
581 
582 
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Implementation of the {IERC165} interface.
589  *
590  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
591  * for the additional interface id that will be supported. For example:
592  *
593  * ```solidity
594  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
596  * }
597  * ```
598  *
599  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
600  */
601 abstract contract ERC165 is IERC165 {
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         return interfaceId == type(IERC165).interfaceId;
607     }
608 }
609 
610 // File: contracts/Address.sol
611 
612 
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Collection of functions related to the address type
618  */
619 library Address {
620     /**
621      * @dev Returns true if `account` is a contract.
622      *
623      * [IMPORTANT]
624      * ====
625      * It is unsafe to assume that an address for which this function returns
626      * false is an externally-owned account (EOA) and not a contract.
627      *
628      * Among others, `isContract` will return false for the following
629      * types of addresses:
630      *
631      *  - an externally-owned account
632      *  - a contract in construction
633      *  - an address where a contract will be created
634      *  - an address where a contract lived, but was destroyed
635      * ====
636      */
637     function isContract(address account) internal view returns (bool) {
638         // This method relies on extcodesize, which returns 0 for contracts in
639         // construction, since the code is only stored at the end of the
640         // constructor execution.
641 
642         uint256 size;
643         assembly {
644             size := extcodesize(account)
645         }
646         return size > 0;
647     }
648 
649     /**
650      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
651      * `recipient`, forwarding all available gas and reverting on errors.
652      *
653      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
654      * of certain opcodes, possibly making contracts go over the 2300 gas limit
655      * imposed by `transfer`, making them unable to receive funds via
656      * `transfer`. {sendValue} removes this limitation.
657      *
658      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
659      *
660      * IMPORTANT: because control is transferred to `recipient`, care must be
661      * taken to not create reentrancy vulnerabilities. Consider using
662      * {ReentrancyGuard} or the
663      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
664      */
665     function sendValue(address payable recipient, uint256 amount) internal {
666         require(address(this).balance >= amount, "Address: insufficient balance");
667 
668         (bool success, ) = recipient.call{value: amount}("");
669         require(success, "Address: unable to send value, recipient may have reverted");
670     }
671 
672     /**
673      * @dev Performs a Solidity function call using a low level `call`. A
674      * plain `call` is an unsafe replacement for a function call: use this
675      * function instead.
676      *
677      * If `target` reverts with a revert reason, it is bubbled up by this
678      * function (like regular Solidity function calls).
679      *
680      * Returns the raw returned data. To convert to the expected return value,
681      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
682      *
683      * Requirements:
684      *
685      * - `target` must be a contract.
686      * - calling `target` with `data` must not revert.
687      *
688      * _Available since v3.1._
689      */
690     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
691         return functionCall(target, data, "Address: low-level call failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
696      * `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(
701         address target,
702         bytes memory data,
703         string memory errorMessage
704     ) internal returns (bytes memory) {
705         return functionCallWithValue(target, data, 0, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but also transferring `value` wei to `target`.
711      *
712      * Requirements:
713      *
714      * - the calling contract must have an ETH balance of at least `value`.
715      * - the called Solidity function must be `payable`.
716      *
717      * _Available since v3.1._
718      */
719     function functionCallWithValue(
720         address target,
721         bytes memory data,
722         uint256 value
723     ) internal returns (bytes memory) {
724         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
729      * with `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         require(address(this).balance >= value, "Address: insufficient balance for call");
740         require(isContract(target), "Address: call to non-contract");
741 
742         (bool success, bytes memory returndata) = target.call{value: value}(data);
743         return verifyCallResult(success, returndata, errorMessage);
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
748      * but performing a static call.
749      *
750      * _Available since v3.3._
751      */
752     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
753         return functionStaticCall(target, data, "Address: low-level static call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
758      * but performing a static call.
759      *
760      * _Available since v3.3._
761      */
762     function functionStaticCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal view returns (bytes memory) {
767         require(isContract(target), "Address: static call to non-contract");
768 
769         (bool success, bytes memory returndata) = target.staticcall(data);
770         return verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a delegate call.
776      *
777      * _Available since v3.4._
778      */
779     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
780         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a delegate call.
786      *
787      * _Available since v3.4._
788      */
789     function functionDelegateCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal returns (bytes memory) {
794         require(isContract(target), "Address: delegate call to non-contract");
795 
796         (bool success, bytes memory returndata) = target.delegatecall(data);
797         return verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
802      * revert reason using the provided one.
803      *
804      * _Available since v4.3._
805      */
806     function verifyCallResult(
807         bool success,
808         bytes memory returndata,
809         string memory errorMessage
810     ) internal pure returns (bytes memory) {
811         if (success) {
812             return returndata;
813         } else {
814             // Look for revert reason and bubble it up if present
815             if (returndata.length > 0) {
816                 // The easiest way to bubble the revert reason is using memory via assembly
817 
818                 assembly {
819                     let returndata_size := mload(returndata)
820                     revert(add(32, returndata), returndata_size)
821                 }
822             } else {
823                 revert(errorMessage);
824             }
825         }
826     }
827 }
828 // File: contracts/IERC1155MetadataURI.sol
829 
830 
831 
832 pragma solidity ^0.8.0;
833 
834 
835 /**
836  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
837  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
838  *
839  * _Available since v3.1._
840  */
841 interface IERC1155MetadataURI is IERC1155 {
842     /**
843      * @dev Returns the URI for token type `id`.
844      *
845      * If the `\{id\}` substring is present in the URI, it must be replaced by
846      * clients with the actual token type ID.
847      */
848     function uri(uint256 id) external view returns (string memory);
849 }
850 // File: contracts/IERC1155Receiver.sol
851 
852 
853 
854 pragma solidity ^0.8.0;
855 
856 
857 /**
858  * @dev _Available since v3.1._
859  */
860 interface IERC1155Receiver is IERC165 {
861     /**
862         @dev Handles the receipt of a single ERC1155 token type. This function is
863         called at the end of a `safeTransferFrom` after the balance has been updated.
864         To accept the transfer, this must return
865         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
866         (i.e. 0xf23a6e61, or its own function selector).
867         @param operator The address which initiated the transfer (i.e. msg.sender)
868         @param from The address which previously owned the token
869         @param id The ID of the token being transferred
870         @param value The amount of tokens being transferred
871         @param data Additional data with no specified format
872         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
873     */
874     function onERC1155Received(
875         address operator,
876         address from,
877         uint256 id,
878         uint256 value,
879         bytes calldata data
880     ) external returns (bytes4);
881 
882     /**
883         @dev Handles the receipt of a multiple ERC1155 token types. This function
884         is called at the end of a `safeBatchTransferFrom` after the balances have
885         been updated. To accept the transfer(s), this must return
886         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
887         (i.e. 0xbc197c81, or its own function selector).
888         @param operator The address which initiated the batch transfer (i.e. msg.sender)
889         @param from The address which previously owned the token
890         @param ids An array containing ids of each token being transferred (order and length must match values array)
891         @param values An array containing amounts of each token being transferred (order and length must match ids array)
892         @param data Additional data with no specified format
893         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
894     */
895     function onERC1155BatchReceived(
896         address operator,
897         address from,
898         uint256[] calldata ids,
899         uint256[] calldata values,
900         bytes calldata data
901     ) external returns (bytes4);
902 }
903 
904 // File: contracts/ERC1155.sol
905 
906 
907 
908 pragma solidity ^0.8.0;
909 
910 
911 
912 
913 
914 
915 
916 /**
917  * @dev Implementation of the basic standard multi-token.
918  * See https://eips.ethereum.org/EIPS/eip-1155
919  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
920  *
921  * _Available since v3.1._
922  */
923 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
924     using Address for address;
925 
926     // Mapping from token ID to account balances
927     mapping(uint256 => mapping(address => uint256)) internal _balances;
928 
929     // Mapping from account to operator approvals
930     mapping(address => mapping(address => bool)) private _operatorApprovals;
931 
932     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
933     string private _uri;
934 
935     /**
936      * @dev See {_setURI}.
937      */
938     constructor(string memory uri_) {
939         _setURI(uri_);
940     }
941 
942     /**
943      * @dev See {IERC165-supportsInterface}.
944      */
945     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
946         return
947             interfaceId == type(IERC1155).interfaceId ||
948             interfaceId == type(IERC1155MetadataURI).interfaceId ||
949             super.supportsInterface(interfaceId);
950     }
951 
952     /**
953      * @dev See {IERC1155MetadataURI-uri}.
954      *
955      * This implementation returns the same URI for *all* token types. It relies
956      * on the token type ID substitution mechanism
957      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
958      *
959      * Clients calling this function must replace the `\{id\}` substring with the
960      * actual token type ID.
961      */
962     function uri(uint256) public view virtual override returns (string memory) {
963         return _uri;
964     }
965 
966     /**
967      * @dev See {IERC1155-balanceOf}.
968      *
969      * Requirements:
970      *
971      * - `account` cannot be the zero address.
972      */
973     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
974         require(account != address(0), "ERC1155: balance query for the zero address");
975         return _balances[id][account];
976     }
977 
978     /**
979      * @dev See {IERC1155-balanceOfBatch}.
980      *
981      * Requirements:
982      *
983      * - `accounts` and `ids` must have the same length.
984      */
985     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
986         public
987         view
988         virtual
989         override
990         returns (uint256[] memory)
991     {
992         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
993 
994         uint256[] memory batchBalances = new uint256[](accounts.length);
995 
996         for (uint256 i = 0; i < accounts.length; ++i) {
997             batchBalances[i] = balanceOf(accounts[i], ids[i]);
998         }
999 
1000         return batchBalances;
1001     }
1002 
1003     /**
1004      * @dev See {IERC1155-setApprovalForAll}.
1005      */
1006     function setApprovalForAll(address operator, bool approved) public virtual override {
1007         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1008 
1009         _operatorApprovals[_msgSender()][operator] = approved;
1010         emit ApprovalForAll(_msgSender(), operator, approved);
1011     }
1012 
1013     /**
1014      * @dev See {IERC1155-isApprovedForAll}.
1015      */
1016     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1017         return _operatorApprovals[account][operator];
1018     }
1019 
1020     /**
1021      * @dev See {IERC1155-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 id,
1027         uint256 amount,
1028         bytes memory data
1029     ) public virtual override {
1030         require(
1031             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1032             "ERC1155: caller is not owner nor approved"
1033         );
1034         _safeTransferFrom(from, to, id, amount, data);
1035     }
1036 
1037     /**
1038      * @dev See {IERC1155-safeBatchTransferFrom}.
1039      */
1040     function safeBatchTransferFrom(
1041         address from,
1042         address to,
1043         uint256[] memory ids,
1044         uint256[] memory amounts,
1045         bytes memory data
1046     ) public virtual override {
1047         require(
1048             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1049             "ERC1155: transfer caller is not owner nor approved"
1050         );
1051         _safeBatchTransferFrom(from, to, ids, amounts, data);
1052     }
1053 
1054     /**
1055      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1056      *
1057      * Emits a {TransferSingle} event.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1063      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1064      * acceptance magic value.
1065      */
1066     function _safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 id,
1070         uint256 amount,
1071         bytes memory data
1072     ) internal virtual {
1073         require(to != address(0), "ERC1155: transfer to the zero address");
1074 
1075         address operator = _msgSender();
1076 
1077         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1078 
1079         uint256 fromBalance = _balances[id][from];
1080         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1081         unchecked {
1082             _balances[id][from] = fromBalance - amount;
1083         }
1084         _balances[id][to] += amount;
1085 
1086         emit TransferSingle(operator, from, to, id, amount);
1087 
1088         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1089     }
1090 
1091     /**
1092      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1093      *
1094      * Emits a {TransferBatch} event.
1095      *
1096      * Requirements:
1097      *
1098      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1099      * acceptance magic value.
1100      */
1101     function _safeBatchTransferFrom(
1102         address from,
1103         address to,
1104         uint256[] memory ids,
1105         uint256[] memory amounts,
1106         bytes memory data
1107     ) internal virtual {
1108         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1109         require(to != address(0), "ERC1155: transfer to the zero address");
1110 
1111         address operator = _msgSender();
1112 
1113         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1114 
1115         for (uint256 i = 0; i < ids.length; ++i) {
1116             uint256 id = ids[i];
1117             uint256 amount = amounts[i];
1118 
1119             uint256 fromBalance = _balances[id][from];
1120             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1121             unchecked {
1122                 _balances[id][from] = fromBalance - amount;
1123             }
1124             _balances[id][to] += amount;
1125         }
1126 
1127         emit TransferBatch(operator, from, to, ids, amounts);
1128 
1129         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1130     }
1131 
1132     /**
1133      * @dev Sets a new URI for all token types, by relying on the token type ID
1134      * substitution mechanism
1135      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1136      *
1137      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1138      * URI or any of the amounts in the JSON file at said URI will be replaced by
1139      * clients with the token type ID.
1140      *
1141      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1142      * interpreted by clients as
1143      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1144      * for token type ID 0x4cce0.
1145      *
1146      * See {uri}.
1147      *
1148      * Because these URIs cannot be meaningfully represented by the {URI} event,
1149      * this function emits no events.
1150      */
1151     function _setURI(string memory newuri) internal virtual {
1152         _uri = newuri;
1153     }
1154 
1155     /**
1156      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1157      *
1158      * Emits a {TransferSingle} event.
1159      *
1160      * Requirements:
1161      *
1162      * - `account` cannot be the zero address.
1163      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1164      * acceptance magic value.
1165      */
1166     function _mint(
1167         address account,
1168         uint256 id,
1169         uint256 amount,
1170         bytes memory data
1171     ) internal virtual {
1172         require(account != address(0), "ERC1155: mint to the zero address");
1173 
1174         address operator = _msgSender();
1175 
1176         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1177 
1178         _balances[id][account] += amount;
1179         emit TransferSingle(operator, address(0), account, id, amount);
1180 
1181         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1182     }
1183 
1184     /**
1185      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1186      *
1187      * Requirements:
1188      *
1189      * - `ids` and `amounts` must have the same length.
1190      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1191      * acceptance magic value.
1192      */
1193     function _mintBatch(
1194         address to,
1195         uint256[] memory ids,
1196         uint256[] memory amounts,
1197         bytes memory data
1198     ) internal virtual {
1199         require(to != address(0), "ERC1155: mint to the zero address");
1200         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1201 
1202         address operator = _msgSender();
1203 
1204         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1205 
1206         for (uint256 i = 0; i < ids.length; i++) {
1207             _balances[ids[i]][to] += amounts[i];
1208         }
1209 
1210         emit TransferBatch(operator, address(0), to, ids, amounts);
1211 
1212         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1213     }
1214 
1215     /**
1216      * @dev Destroys `amount` tokens of token type `id` from `account`
1217      *
1218      * Requirements:
1219      *
1220      * - `account` cannot be the zero address.
1221      * - `account` must have at least `amount` tokens of token type `id`.
1222      */
1223     function _burn(
1224         address account,
1225         uint256 id,
1226         uint256 amount
1227     ) internal virtual {
1228         require(account != address(0), "ERC1155: burn from the zero address");
1229 
1230         address operator = _msgSender();
1231 
1232         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1233 
1234         uint256 accountBalance = _balances[id][account];
1235         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1236         unchecked {
1237             _balances[id][account] = accountBalance - amount;
1238         }
1239 
1240         emit TransferSingle(operator, account, address(0), id, amount);
1241     }
1242 
1243     /**
1244      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1245      *
1246      * Requirements:
1247      *
1248      * - `ids` and `amounts` must have the same length.
1249      */
1250     function _burnBatch(
1251         address account,
1252         uint256[] memory ids,
1253         uint256[] memory amounts
1254     ) internal virtual {
1255         require(account != address(0), "ERC1155: burn from the zero address");
1256         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1257 
1258         address operator = _msgSender();
1259 
1260         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1261 
1262         for (uint256 i = 0; i < ids.length; i++) {
1263             uint256 id = ids[i];
1264             uint256 amount = amounts[i];
1265 
1266             uint256 accountBalance = _balances[id][account];
1267             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1268             unchecked {
1269                 _balances[id][account] = accountBalance - amount;
1270             }
1271         }
1272 
1273         emit TransferBatch(operator, account, address(0), ids, amounts);
1274     }
1275 
1276     /**
1277      * @dev Hook that is called before any token transfer. This includes minting
1278      * and burning, as well as batched variants.
1279      *
1280      * The same hook is called on both single and batched variants. For single
1281      * transfers, the length of the `id` and `amount` arrays will be 1.
1282      *
1283      * Calling conditions (for each `id` and `amount` pair):
1284      *
1285      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1286      * of token type `id` will be  transferred to `to`.
1287      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1288      * for `to`.
1289      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1290      * will be burned.
1291      * - `from` and `to` are never both zero.
1292      * - `ids` and `amounts` have the same, non-zero length.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(
1297         address operator,
1298         address from,
1299         address to,
1300         uint256[] memory ids,
1301         uint256[] memory amounts,
1302         bytes memory data
1303     ) internal virtual {}
1304 
1305     function _doSafeTransferAcceptanceCheck(
1306         address operator,
1307         address from,
1308         address to,
1309         uint256 id,
1310         uint256 amount,
1311         bytes memory data
1312     ) private {
1313         if (to.isContract()) {
1314             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1315                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1316                     revert("ERC1155: ERC1155Receiver rejected tokens");
1317                 }
1318             } catch Error(string memory reason) {
1319                 revert(reason);
1320             } catch {
1321                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1322             }
1323         }
1324     }
1325 
1326     function _doSafeBatchTransferAcceptanceCheck(
1327         address operator,
1328         address from,
1329         address to,
1330         uint256[] memory ids,
1331         uint256[] memory amounts,
1332         bytes memory data
1333     ) private {
1334         if (to.isContract()) {
1335             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1336                 bytes4 response
1337             ) {
1338                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1339                     revert("ERC1155: ERC1155Receiver rejected tokens");
1340                 }
1341             } catch Error(string memory reason) {
1342                 revert(reason);
1343             } catch {
1344                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1345             }
1346         }
1347     }
1348 
1349     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1350         uint256[] memory array = new uint256[](1);
1351         array[0] = element;
1352 
1353         return array;
1354     }
1355 }
1356 // File: contracts/Skills.sol
1357 //SPDX-License-Identifier: GPL-3.0
1358 pragma solidity ^0.8.7;
1359 
1360 contract Skills is ERC1155, ReentrancyGuard, Ownable {
1361     // first 4 are Epic, second 4 are Rare, remaining are Common
1362 	string[] private meleeAttacks = [
1363 		"Mortal Wound", // 0
1364 		"Heart Thrust", // 1
1365 		"Berserker", // 2
1366 		"Killing Spree", // 3
1367 		"Rage of the Ape", // 4
1368 		"Spinal Slice", // 5
1369 		"Death Blow", // 6
1370 		"Ocular Slash ", // 7
1371 		"Grasp of the Kraken", // 8
1372 		"Heroic Strike", // 9
1373 		"Sweep", // 10
1374 		"Backstab", // 11
1375 		"Silent Strike", // 12
1376 		"Skull Bash", // 13
1377 		"Garrote", // 14
1378 		"Mutilating Blow", // 15
1379 		"Tiger Maul", // 16
1380 		"Rune Strike", // 17
1381 		"Cleave", // 18
1382 		"Dragon Tail Swipe", // 19
1383 		"Punch in the Mouth" // 20
1384 	];
1385 
1386 	string[] private rangeAttacks = [
1387 		"Multishot", // 0
1388 		"Kill Shot", // 1
1389 		"Shot Through The Heart", // 2
1390 		"Hit and Run", // 3
1391 		"Blot Out the Sun", // 4
1392 		"Barrage of Bullets", // 5
1393 		"Ancestral Arrow", // 6
1394 		"Arrow of Armageddon", // 7
1395 		"Double Strafe", // 8
1396 		"Poison Arrow", // 9
1397 		"Tranquilizing Dart", // 10
1398 		"Frost Shot", // 11
1399 		"Burning Arrow", // 12
1400 		"Blinding Bolt", // 13
1401 		"Degenerate Dart", // 14
1402 		"Shaft of Glory" // 15
1403 	];
1404 
1405     string[] private elementalSpells = [
1406         "Meteor", // 0
1407         "Earthquake", // 1
1408         "Ball Lightning", // 2
1409         "Blizzard", // 3
1410         "Cataclysm", // 4
1411         "Maelstrom Bolt", // 5
1412         "Black Dragon Breath", // 6
1413         "Comet Strike", // 7
1414         "Fireball", // 8
1415         "Firewall", // 9
1416         "Firestorm", // 10
1417         "Dragon Breath", // 11
1418         "Ice Spear", // 12
1419         "Frost Touch", // 13
1420         "Frozen Heart", // 14
1421         "Frost Cone", // 15
1422         "Electric Personality", // 16
1423         "Lightning Strike", // 17
1424         "Chain Lightning", // 18
1425         "Electric Boogaloo", // 19
1426         "Landslide", // 20
1427         "Sinking Sand", // 21
1428         "Earth Spike", // 22
1429         "Drowning Deluge" // 23
1430     ];
1431 
1432 	string[] private spiritualSpells = [
1433 		"Searing Sun", // 0
1434 		"Divine Indignation", // 1
1435 		"Death and Decay", // 2
1436 		"Hurricane of the Mother", // 3
1437 		"Divine Retribution", // 4
1438 		"Demonic Despair", // 5
1439 		"Praise The Sun", // 6
1440 		"Pandemonium", // 7
1441 		"Light of the Moon", // 8
1442 		"Spear of Brilliance", // 9
1443 		"Raise Dead", // 10
1444 		"Seraph Smite", // 11
1445 		"Soul Arrow", // 12
1446 		"Arrow of Evil", // 13
1447 		"Bolt of Rage", // 14
1448 		"Wroth of the Mother", // 15
1449 		"Devilish Deed", // 16
1450 		"Demon Soul" // 17
1451 	];
1452 
1453 	string[] private curses = [
1454 		"Doom", // 0
1455 		"Regress to the Mean", // 1
1456 		"Curse of the Winner", // 2
1457 		"Not Gonna Make It", // 3
1458 		"Plague of Frogs", // 4
1459 		"Curse of the Ape", // 5
1460 		"Bad Morning", // 6
1461 		"Demise of the Degenerate", // 7
1462 		"Touch of Sorrow", // 8
1463 		"Curse of Down Bad", // 9
1464 		"Kiss of Death", // 10
1465 		"Blight of the Moon", // 11
1466 		"Morbid Sun", // 12
1467 		"Torment of Titans", // 13
1468 		"Agonizing Gaze", // 14
1469 		"Change of Heart", // 15
1470 		"Curse of Anger" // 16
1471 	];
1472 
1473     string[] private heals = [
1474         "Divine Touch", // 0
1475         "Soul Glow", // 1
1476         "Time Heals All Wounds", // 2
1477         "Innervate", // 3
1478         "Infectious Heal", // 4
1479         "Raise the Dead", // 5
1480         "Healed and Shield", // 6
1481         "You're Gonna Make It", // 7
1482         "Healing Touch", // 8
1483         "Restoring Wind", // 9
1484         "Healing Current", // 10
1485         "Wellspring", // 11
1486         "Reviving Touch", // 12
1487         "Rejuvenating Surge" // 13
1488     ];
1489       
1490 	string[] private buffs = [
1491 		"We're All Gonna Make It", // 0
1492 		"Vigor of the Twins", // 1
1493 		"Fury of the Ape", // 2
1494 		"Invigorating Touch", // 3
1495 		"Frozen Touch", // 4
1496 		"Blessing of Good Morning", // 5
1497 		"Ancient Vitriol", // 6
1498 		"Luck and Leverage", // 7
1499 		"Dragonskin", // 8
1500 		"Sight of Enlightenment", // 9
1501 		"Wind In Your Back", // 10
1502 		"Fury of Giants", // 11
1503 		"Song of Power", // 12
1504 		"Cleverness of the Fox", // 13
1505 		"Strength of Vengeance", // 14
1506 		"Wind Walker", // 15
1507 		"Scent of Blood", // 16
1508 		"Thick Skin", // 17
1509 		"Hymn of Protection", // 18
1510 		"Blessing of Light", // 19
1511 		"Iron Flesh" // 20
1512 	];
1513 
1514 	string[] private defensiveSkills = [
1515 		"Haste of the Fox", // 0
1516 		"Blessing of Protection", // 1
1517 		"Vanish", // 2
1518 		"Sacrifice of the Martyr", // 3
1519 		"Evasive Maneuver", // 4
1520 		"Perfect Roll", // 5
1521 		"Taunt 'Em All", // 6
1522 		"Determination of a Degenerate", // 7
1523 		"Dodge", // 8
1524 		"Protect", // 9
1525 		"Taunt", // 10
1526 		"Feign Death", // 11
1527 		"Counter", // 12
1528 		"Shield Block" // 13
1529 	];
1530 
1531 	string[] private namePrefixes = [
1532 		"", // 0
1533 		"Dom", // 1
1534 		"Hoffman", // 2
1535 		"Nish", // 3
1536 		"Nuge", // 4
1537 		"Orgeos", // 5
1538 		"Looter", // 6
1539 		"Italik", // 7
1540 		"Reppap", // 8
1541 		"Oni", // 9
1542 		"Zurhahs", // 10
1543 		"Ackson", // 11
1544 		"gm enjoyer", // 12
1545 		"Chad", // 13
1546 		"Adventurer"  // 14
1547 	];
1548 
1549     // Mapping from token ID to owner address
1550     mapping(uint256 => address) private _owners;
1551 
1552     IERC721Enumerable constant lootContract = IERC721Enumerable(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
1553 
1554     mapping(uint256 => uint256) _genSkillCooldown;
1555 
1556 	uint256 constant skillIdOffset = 57896044618658097711785492504343953926634992332820282019728792003956564819968; // offset skill ids to halfway into the token id range
1557 	uint16 constant setCap = 16000;
1558 
1559 	uint256 lastMintedSetId = 8223;
1560 
1561     // Minting functions
1562     function _claimSet(uint256 setId) private {
1563 		uint256[] memory tokenIds = _getSetSkillIds(setId);
1564 
1565 		uint256[] memory amounts = new uint256[](9);
1566 		amounts[0] = uint256(1);
1567 		amounts[1] = uint256(1);
1568 		amounts[2] = uint256(1);
1569 		amounts[3] = uint256(1);
1570 		amounts[4] = uint256(1);
1571 		amounts[5] = uint256(1);
1572 		amounts[6] = uint256(1);
1573 		amounts[7] = uint256(1);
1574 		amounts[8] = uint256(1);
1575 		
1576 		_mintBatch(_msgSender(), tokenIds, amounts, "");
1577         _owners[setId] = _msgSender();
1578     }
1579 
1580 	function claimAvailableSet() public {
1581 		require(lastMintedSetId <= setCap, "All available sets have been claimed");
1582 
1583 		_claimSet(lastMintedSetId);
1584 		lastMintedSetId++;
1585 	}
1586 
1587     function claimWithLoot(uint256 tokenId) public {
1588 		require(lootContract.ownerOf(tokenId) == _msgSender(), "you do not own the lootbag for this set of skill");
1589 		require(!_exists(tokenId), "Set has already been claimed");
1590 		_claimSet(tokenId);
1591     }
1592 
1593 	function claimAllWithLoot() public {
1594         uint256 tokenBalanceOwner = lootContract.balanceOf(_msgSender());
1595 
1596         require(tokenBalanceOwner > 0, "You do not own any Loot bags");
1597 
1598         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
1599             uint256 lootId = lootContract.tokenOfOwnerByIndex(_msgSender(), i);
1600             if(!_exists(lootId)) {
1601                 _claimSet(lootId);
1602             }
1603         }
1604     }
1605 
1606     function ownerClaimSet(uint256 setId) public onlyOwner {
1607         require( setId > 8000 && setId < 8223, "Not a reserved Set ID");
1608 		require(!_exists(setId), "You already own this set");
1609         _claimSet(setId);
1610     }
1611 
1612 	function skillUp(uint256 skillId) public {
1613         require(skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1614 		skillId += skillIdOffset;
1615 		_burn(_msgSender(), skillId, 2);
1616 		uint256 skillId1Up = skillId + 2175; // total skills * total name prefixes
1617 		_mint(_msgSender(), skillId1Up, 1, "");
1618 	}
1619 
1620 	function skillDown(uint256 skillId) public {
1621         require(skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1622 		skillId += skillIdOffset;
1623 		_burn(_msgSender(), skillId, 1);
1624 		uint256 skillId1Down = skillId - 2175;
1625 		_mint(_msgSender(), skillId1Down, 2, "");
1626 	}
1627 
1628     function skillUpMulti(uint256 skillId, uint256 steps) public {
1629         require(skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1630         require(steps > 0, "Invalid amount of steps");
1631 
1632 		skillId += skillIdOffset;
1633 
1634 		_burn(_msgSender(), skillId, 1 << steps);
1635 		uint256 skillId1Up = skillId + (2175 * steps) ; // total skills * total name prefixes
1636 		_mint(_msgSender(), skillId1Up, 1, "");
1637 	}
1638 
1639     function skillDownMulti(uint256 skillId, uint256 steps) public {
1640         require(skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1641         require(steps > 0, "Invalid amount of steps");
1642 
1643 		skillId += skillIdOffset;
1644 
1645 		_burn(_msgSender(), skillId, 1);
1646 		uint256 skillId1Up = skillId - (2175 * steps) ; // total skills * total name prefixes
1647 		_mint(_msgSender(), skillId1Up, 1 << steps, "");
1648     }
1649 
1650 	function generateSkill(uint256 setId) public {
1651         require(_balances[setId][_msgSender()] > 0, "You do not own this set");
1652         uint256 lastBlock = _genSkillCooldown[setId];
1653 
1654         require(lastBlock == 0 || block.number >= lastBlock, "This set has generated a skill too recently");
1655         
1656         uint256 rand = uint256(keccak256(abi.encodePacked(setId, block.number ^ block.basefee ^ tx.gasprice )));
1657         uint8 categoryIndex = uint8(rand % 8);
1658         uint8 categoryLength;
1659 
1660         if(categoryIndex == 0) categoryLength = 21;
1661         else if(categoryIndex == 1) categoryLength = 16;
1662         else if(categoryIndex == 2) categoryLength = 24;
1663         else if(categoryIndex == 3) categoryLength = 18;
1664         else if(categoryIndex == 4) categoryLength = 17;
1665         else if(categoryIndex == 5) categoryLength = 14;
1666         else if(categoryIndex == 6) categoryLength = 21;
1667         else categoryLength = 14;
1668         
1669 		uint256 skillId = _getSkillId(rand, categoryIndex, categoryLength) + skillIdOffset;
1670 
1671         _mint(_msgSender(), skillId, 1, "");
1672 
1673         if( ownsWholeSet(setId) ) _genSkillCooldown[setId] = block.number + 50000;
1674         else _genSkillCooldown[setId] = block.number + 250000;
1675     }
1676 
1677     function _exists(uint256 setId) internal view returns (bool) {
1678         return _owners[setId] != address(0);
1679     }
1680 
1681     function ownsWholeSet(uint256 setId) public view returns( bool ){
1682         uint256[] memory tokenIds = _getSetSkillIds(setId);
1683         for( uint256 i = 0; i < 9; i++)
1684         {
1685             if( _balances[tokenIds[i]][_msgSender()] == 0 ) return false;
1686         }
1687         return true;
1688     }
1689 
1690     // Transfer functions
1691 	function transferSkill(address from, address to, uint256 skillId, uint256 amount, bytes memory data) public {
1692         require(
1693             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1694             "ERC1155: caller is not owner nor approved"
1695         );
1696         require(skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1697 		_safeTransferFrom(from, to, skillId + skillIdOffset, amount, data);
1698 	}
1699 
1700 	function batchTransferSkills(address from, address to, uint256[] memory skillIds, uint256[] memory amounts, bytes memory data) public {
1701         require(
1702             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1703             "ERC1155: caller is not owner nor approved"
1704         );
1705 		for( uint256 i = 0; i < 145; i++)
1706 		{
1707             require(skillIds[i] < skillIdOffset, "Please use the Skill ID, not the token ID");
1708 			skillIds[i] += skillIdOffset;
1709 		}
1710 		_safeBatchTransferFrom(from, to, skillIds, amounts, data);
1711 	}
1712 
1713 	function transferSet(address from, address to, uint256 setId, bytes memory data) public {
1714         require(
1715             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1716             "ERC1155: caller is not owner nor approved"
1717         );
1718 		uint256[] memory tokenIds = _getSetSkillIds(setId);
1719 
1720 		uint256[] memory amounts = new uint256[](9);
1721 		amounts[0] = uint256(1);
1722 		amounts[1] = uint256(1);
1723 		amounts[2] = uint256(1);
1724 		amounts[3] = uint256(1);
1725 		amounts[4] = uint256(1);
1726 		amounts[5] = uint256(1);
1727 		amounts[6] = uint256(1);
1728 		amounts[7] = uint256(1);
1729 		amounts[8] = uint256(1);
1730 		
1731 		_safeBatchTransferFrom(from, to, tokenIds, amounts, data);
1732 	}
1733 
1734     // Override 1155 transfer functions to handle Set/Skill ID offset
1735     function safeTransferFrom( address from, address to, uint256 id, uint256 amount, bytes memory data ) public override {
1736         if( id >= skillIdOffset ) 
1737         {
1738             require(
1739                 from == _msgSender() || isApprovedForAll(from, _msgSender()),
1740                 "ERC1155: caller is not owner nor approved"
1741             );
1742             _safeTransferFrom(from, to, id, amount, data);
1743         }
1744         else
1745         {
1746             transferSet(from, to, id, data);
1747         }
1748     }
1749 
1750     function safeBatchTransferFrom( address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data ) public virtual override {
1751         require(
1752             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1753             "ERC1155: transfer caller is not owner nor approved"
1754         );
1755         bool setFound = false;
1756         bool skillFound = false;
1757         for( uint256 i = 0; i < ids.length; i++ )
1758         {
1759             if( ids[i] >= skillIdOffset ) 
1760             {
1761                 skillFound = true;
1762             }
1763             else
1764             {
1765                 require(amounts[i] == 1, "You cannot transfer more than 1 set as there is only 1 of each");
1766                 setFound = true;
1767             }
1768         }
1769 
1770         require( !(setFound && skillFound), "Please attempt to only transfer Set IDs or Skill IDs in one batch" );
1771         
1772         if( skillFound )
1773         {
1774             _safeBatchTransferFrom(from, to, ids, amounts, data);
1775         }
1776         else
1777         {
1778             for( uint256 i = 0; i < ids.length; i++ )
1779             {
1780                 transferSet(from, to, ids[i], data);
1781             }
1782         }
1783     }
1784 
1785     // Skill data
1786 	function getSkillString(uint256 skillId) public view returns (string memory)
1787 	{
1788 		string memory output;
1789 		uint256 skillIndex = skillId / 145;
1790 		uint256 skillBaseId = skillId % 145;
1791 		
1792 		if( skillBaseId < 21 )
1793 		{
1794 			output = meleeAttacks[skillBaseId];
1795 		}
1796 		else if( skillBaseId < 37 )
1797 		{
1798 			output = rangeAttacks[skillBaseId - 21];
1799 		}
1800 		else if( skillBaseId < 61 )
1801 		{
1802 			output = elementalSpells[skillBaseId - 37];
1803 		}
1804 		else if( skillBaseId < 79 )
1805 		{
1806 			output = spiritualSpells[skillBaseId - 61];
1807 		}
1808 		else if( skillBaseId < 96 )
1809 		{
1810 			output = curses[skillBaseId - 79];
1811 		}
1812 		else if( skillBaseId < 110 )
1813 		{
1814 			output = heals[skillBaseId - 96];
1815 		}
1816 		else if( skillBaseId < 131 )
1817 		{
1818 			output = buffs[skillBaseId - 110];
1819 		}
1820 		else
1821 		{
1822 			output = defensiveSkills[skillBaseId - 131];
1823 		}
1824 
1825 		uint256 skillNamePrefix = skillIndex % 15; // namePrefixes.length
1826 
1827 		if( skillNamePrefix > 0 )
1828 		{
1829 			output = string(abi.encodePacked(namePrefixes[skillNamePrefix], "'s ", output));
1830 		}
1831 
1832 		uint256 skillLevel = skillIndex / 15; // namePrefixes.length
1833 		if( skillLevel > 0 )
1834 		{
1835 			output = string(abi.encodePacked(output, " +", toString(skillLevel)));
1836 		}
1837 
1838 		return output;
1839 	}
1840 
1841 	function _getSkillId(uint256 setId, uint8 categoryIndex, uint8 categoryLength) internal view returns (uint256 skillId) {
1842         uint256 rand = uint256(keccak256(abi.encodePacked(setId, categoryIndex)));
1843         uint256 rarity = rand % 1000;
1844         if (rarity < 4)
1845         {
1846             skillId = rand % categoryLength % 4;
1847         }
1848         else if (rarity < 40)
1849         {
1850             skillId = rand % categoryLength % 4 + 4;
1851         }
1852         else
1853         {
1854             skillId = rand % (categoryLength - 8) + 8;
1855         }
1856 
1857 		skillId += categoryIndex;
1858         
1859 		uint256 nameRand = uint256(keccak256(abi.encodePacked(rand))) % 1000;
1860 		if (nameRand < 40)
1861 		{
1862 			skillId = (nameRand % 15) * 145 + skillId;
1863 		}
1864         return skillId;
1865     }
1866     
1867 	function _getSetSkillIds(uint256 setId) internal view returns (uint256[] memory) {
1868 		uint256[] memory tokenIds = new uint256[](9);
1869 
1870 		tokenIds[0] = _getSkillId(setId, 0, 21) + skillIdOffset; // meleeAttacks
1871 		tokenIds[1] = _getSkillId(setId, 21, 16) + skillIdOffset; // rangeAttacks
1872 		tokenIds[2] = _getSkillId(setId, 37, 24) + skillIdOffset; // elementalSpells
1873 		tokenIds[3] = _getSkillId(setId, 61, 18) + skillIdOffset; // spiritualSpells
1874 		tokenIds[4] = _getSkillId(setId, 79, 17) + skillIdOffset; // curses
1875 		tokenIds[5] = _getSkillId(setId, 96, 14) + skillIdOffset; // heals
1876 		tokenIds[6] = _getSkillId(setId, 110, 21) + skillIdOffset; // buffs
1877 		tokenIds[7] = _getSkillId(setId, 131, 14) + skillIdOffset; // defensiveSkills
1878 
1879 		tokenIds[8] = setId;
1880 
1881 		return tokenIds;
1882 	}
1883 
1884     // get functions
1885     function getGenSkillCooldown(uint256 setId) public view returns (uint256) {
1886 		require( setId < skillIdOffset, "Not a valid Set ID");
1887         return _genSkillCooldown[setId];
1888     }
1889 
1890     function balanceOfSkill(address account, uint256 skillId) public view returns (uint256) {
1891         require( skillId < skillIdOffset, "Please use the Skill ID, not the token ID");
1892         return _balances[skillId + skillIdOffset][account];
1893     }
1894 
1895 	function getMeleeAttack(uint256 setId) public view returns (string memory) {
1896 		require( setId < skillIdOffset, "Not a valid Set ID");
1897 		return getSkillString(_getSkillId(setId, 0, 21));
1898 	}
1899 	
1900 	function getRangeAttack(uint256 setId) public view returns (string memory) {
1901 		require( setId < skillIdOffset, "Not a valid Set ID");
1902 		return getSkillString(_getSkillId(setId, 21, 16));
1903 	}
1904 	
1905 	function getElementalSpell(uint256 setId) public view returns (string memory) {
1906 		require( setId < skillIdOffset, "Not a valid Set ID");
1907 		return getSkillString(_getSkillId(setId, 37, 24));
1908 	}
1909 	
1910 	function getSpiritualSpell(uint256 setId) public view returns (string memory) {
1911 		require( setId < skillIdOffset, "Not a valid Set ID");
1912 		return getSkillString(_getSkillId(setId, 61, 18));
1913 	}
1914 
1915 	function getCurse(uint256 setId) public view returns (string memory) {
1916 		require( setId < skillIdOffset, "Not a valid Set ID");
1917 		return getSkillString(_getSkillId(setId, 79, 17));
1918 	}
1919 	
1920     function getHeal(uint256 setId) public view returns (string memory) {
1921 		require( setId < skillIdOffset, "Not a valid Set ID");
1922         return getSkillString(_getSkillId(setId, 96, 14));
1923     }
1924       
1925 	function getBuff(uint256 setId) public view returns (string memory) {
1926 		require( setId < skillIdOffset, "Not a valid Set ID");
1927 		return getSkillString(_getSkillId(setId, 110, 21));
1928 	}
1929 	
1930 	function getDefensiveSkill(uint256 setId) public view returns (string memory) {
1931 		require( setId < skillIdOffset, "Not a valid Set ID");
1932 		return getSkillString(_getSkillId(setId, 131, 14));
1933 	}
1934     
1935     function uri(uint256 tokenId) override public view returns (string memory) {
1936 		if( tokenId > skillIdOffset )
1937 		{
1938 			string[3] memory parts;
1939         	parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1940         	parts[1] = getSkillString(tokenId - skillIdOffset);
1941 			parts[2] = '</text></svg>';
1942 
1943 			string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));
1944 			
1945 			string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Skill #', toString(tokenId - skillIdOffset), '", "description": "Skills are randomized adventurer abilities generated and stored on chain.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1946 			output = string(abi.encodePacked('data:application/json;base64,', json));
1947 
1948 			return output;
1949 		}
1950 		else
1951 		{
1952 			string[17] memory parts;
1953 			parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1954 
1955 			parts[1] = getMeleeAttack(tokenId);
1956 
1957 			parts[2] = '</text><text x="10" y="40" class="base">';
1958 
1959 			parts[3] = getRangeAttack(tokenId);
1960 
1961 			parts[4] = '</text><text x="10" y="60" class="base">';
1962 
1963 			parts[5] = getElementalSpell(tokenId);
1964 
1965 			parts[6] = '</text><text x="10" y="80" class="base">';
1966 
1967 			parts[7] = getSpiritualSpell(tokenId);
1968 
1969 			parts[8] = '</text><text x="10" y="100" class="base">';
1970 
1971 			parts[9] = getCurse(tokenId);
1972 
1973 			parts[10] = '</text><text x="10" y="120" class="base">';
1974 
1975 			parts[11] = getHeal(tokenId);
1976 
1977 			parts[12] = '</text><text x="10" y="140" class="base">';
1978 
1979 			parts[13] = getBuff(tokenId);
1980 
1981 			parts[14] = '</text><text x="10" y="160" class="base">';
1982 
1983 			parts[15] = getDefensiveSkill(tokenId);
1984 
1985 			parts[16] = '</text></svg>';
1986 
1987 			string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1988 			output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1989 			
1990 			string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Set #', toString(tokenId), '", "description": "Skills are randomized adventurer abilities generated and stored on chain.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1991 			output = string(abi.encodePacked('data:application/json;base64,', json));
1992 
1993 			return output;
1994 		}
1995     }
1996 
1997     constructor() ERC1155("Skills") Ownable() {}
1998 }