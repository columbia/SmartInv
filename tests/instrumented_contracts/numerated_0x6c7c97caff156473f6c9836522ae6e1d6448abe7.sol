1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes calldata data
183     ) external returns (bytes4);
184 }
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Enumerable is IERC721 {
212     /**
213      * @dev Returns the total amount of tokens stored by the contract.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
219      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
220      */
221     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
222 
223     /**
224      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
225      * Use along with {totalSupply} to enumerate all tokens.
226      */
227     function tokenByIndex(uint256 index) external view returns (uint256);
228 }
229 
230 /// @title IERC2981Royalties
231 /// @dev Interface for the ERC2981 - Token Royalty standard
232 interface IERC2981Royalties {
233     /// @notice Called with the sale price to determine how much royalty
234     //          is owed and to whom.
235     /// @param _tokenId - the NFT asset queried for royalty information
236     /// @param _value - the sale price of the NFT asset specified by _tokenId
237     /// @return _receiver - address of who should be sent the royalty payment
238     /// @return _royaltyAmount - the royalty payment amount for value sale price
239     function royaltyInfo(uint256 _tokenId, uint256 _value)
240         external
241         view
242         returns (address _receiver, uint256 _royaltyAmount);
243 }
244 
245 /**
246  * @dev Implementation of the {IERC165} interface.
247  *
248  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
249  * for the additional interface id that will be supported. For example:
250  *
251  * ```solidity
252  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
254  * }
255  * ```
256  *
257  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
258  */
259 abstract contract ERC165 is IERC165 {
260     /**
261      * @dev See {IERC165-supportsInterface}.
262      */
263     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
264         return interfaceId == type(IERC165).interfaceId;
265     }
266 }
267 
268 /**
269  * @dev Provides information about the current execution context, including the
270  * sender of the transaction and its data. While these are generally available
271  * via msg.sender and msg.data, they should not be accessed in such a direct
272  * manner, since when dealing with meta-transactions the account sending and
273  * paying for execution may not be the actual sender (as far as an application
274  * is concerned).
275  *
276  * This contract is only required for intermediate, library-like contracts.
277  */
278 abstract contract Context {
279     function _msgSender() internal view virtual returns (address) {
280         return msg.sender;
281     }
282 
283     function _msgData() internal view virtual returns (bytes calldata) {
284         return msg.data;
285     }
286 }
287 
288 /**
289  * @dev Contract module which provides a basic access control mechanism, where
290  * there is an account (an owner) that can be granted exclusive access to
291  * specific functions.
292  *
293  * By default, the owner account will be the one that deploys the contract. This
294  * can later be changed with {transferOwnership}.
295  *
296  * This module is used through inheritance. It will make available the modifier
297  * `onlyOwner`, which can be applied to your functions to restrict their use to
298  * the owner.
299  */
300 abstract contract Ownable is Context {
301     address private _owner;
302 
303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
304 
305     /**
306      * @dev Initializes the contract setting the deployer as the initial owner.
307      */
308     constructor() {
309         _transferOwnership(_msgSender());
310     }
311 
312     /**
313      * @dev Returns the address of the current owner.
314      */
315     function owner() public view virtual returns (address) {
316         return _owner;
317     }
318 
319     /**
320      * @dev Throws if called by any account other than the owner.
321      */
322     modifier onlyOwner() {
323         require(owner() == _msgSender(), "Ownable: caller is not the owner");
324         _;
325     }
326 
327     /**
328      * @dev Leaves the contract without owner. It will not be possible to call
329      * `onlyOwner` functions anymore. Can only be called by the current owner.
330      *
331      * NOTE: Renouncing ownership will leave the contract without an owner,
332      * thereby removing any functionality that is only available to the owner.
333      */
334     function renounceOwnership() public virtual onlyOwner {
335         _transferOwnership(address(0));
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Can only be called by the current owner.
341      */
342     function transferOwnership(address newOwner) public virtual onlyOwner {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         _transferOwnership(newOwner);
345     }
346 
347 
348     function _setOwner(address newOwner) private {
349         address oldOwner = _owner;
350         _owner = newOwner;
351         emit OwnershipTransferred(oldOwner, newOwner);
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Internal function without access restriction.
357      */
358     function _transferOwnership(address newOwner) internal virtual {
359         address oldOwner = _owner;
360         _owner = newOwner;
361         emit OwnershipTransferred(oldOwner, newOwner);
362     }
363 }
364 
365 /**
366  * @dev Contract module that helps prevent reentrant calls to a function.
367  *
368  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
369  * available, which can be applied to functions to make sure there are no nested
370  * (reentrant) calls to them.
371  *
372  * Note that because there is a single `nonReentrant` guard, functions marked as
373  * `nonReentrant` may not call one another. This can be worked around by making
374  * those functions `private`, and then adding `external` `nonReentrant` entry
375  * points to them.
376  *
377  * TIP: If you would like to learn more about reentrancy and alternative ways
378  * to protect against it, check out our blog post
379  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
380  */
381 abstract contract ReentrancyGuard {
382     // Booleans are more expensive than uint256 or any type that takes up a full
383     // word because each write operation emits an extra SLOAD to first read the
384     // slot's contents, replace the bits taken up by the boolean, and then write
385     // back. This is the compiler's defense against contract upgrades and
386     // pointer aliasing, and it cannot be disabled.
387 
388     // The values being non-zero value makes deployment a bit more expensive,
389     // but in exchange the refund on every call to nonReentrant will be lower in
390     // amount. Since refunds are capped to a percentage of the total
391     // transaction's gas, it is best to keep them low in cases like this one, to
392     // increase the likelihood of the full refund coming into effect.
393     uint256 private constant _NOT_ENTERED = 1;
394     uint256 private constant _ENTERED = 2;
395 
396     uint256 private _status;
397 
398     constructor() {
399         _status = _NOT_ENTERED;
400     }
401 
402     /**
403      * @dev Prevents a contract from calling itself, directly or indirectly.
404      * Calling a `nonReentrant` function from another `nonReentrant`
405      * function is not supported. It is possible to prevent this from happening
406      * by making the `nonReentrant` function external, and making it call a
407      * `private` function that does the actual work.
408      */
409     modifier nonReentrant() {
410         // On the first call to nonReentrant, _notEntered will be true
411         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
412 
413         // Any calls to nonReentrant after this point will fail
414         _status = _ENTERED;
415 
416         _;
417 
418         // By storing the original value once again, a refund is triggered (see
419         // https://eips.ethereum.org/EIPS/eip-2200)
420         _status = _NOT_ENTERED;
421     }
422 }
423 
424 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
425 /// @dev This implementation has the same royalties for each and every tokens
426 abstract contract ERC2981ContractWideRoyalties is ERC165, IERC2981Royalties {
427     address private _royaltiesRecipient;
428     uint256 private _royaltiesValue;
429 
430     /// @inheritdoc	ERC165
431     function supportsInterface(bytes4 interfaceId)
432         public
433         view
434         virtual
435         override
436         returns (bool)
437     {
438         return
439             interfaceId == type(IERC2981Royalties).interfaceId ||
440             super.supportsInterface(interfaceId);
441     }
442 
443     /// @dev Sets token royalties
444     /// @param recipient recipient of the royalties
445     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
446     function _setRoyalties(address recipient, uint256 value) internal {
447         require(value <= 10000, 'ERC2981Royalties: Too high');
448         _royaltiesRecipient = recipient;
449         _royaltiesValue = value;
450     }
451 
452     /// @inheritdoc	IERC2981Royalties
453     function royaltyInfo(uint256, uint256 value)
454         external
455         view
456         override
457         returns (address receiver, uint256 royaltyAmount)
458     {
459         return (_royaltiesRecipient, (value * _royaltiesValue) / 10000);
460     }
461 }
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      */
484     function isContract(address account) internal view returns (bool) {
485         // This method relies on extcodesize, which returns 0 for contracts in
486         // construction, since the code is only stored at the end of the
487         // constructor execution.
488 
489         uint256 size;
490         assembly {
491             size := extcodesize(account)
492         }
493         return size > 0;
494     }
495 
496     /**
497      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
498      * `recipient`, forwarding all available gas and reverting on errors.
499      *
500      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
501      * of certain opcodes, possibly making contracts go over the 2300 gas limit
502      * imposed by `transfer`, making them unable to receive funds via
503      * `transfer`. {sendValue} removes this limitation.
504      *
505      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
506      *
507      * IMPORTANT: because control is transferred to `recipient`, care must be
508      * taken to not create reentrancy vulnerabilities. Consider using
509      * {ReentrancyGuard} or the
510      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(address(this).balance >= amount, "Address: insufficient balance");
514 
515         (bool success, ) = recipient.call{value: amount}("");
516         require(success, "Address: unable to send value, recipient may have reverted");
517     }
518 
519     /**
520      * @dev Performs a Solidity function call using a low level `call`. A
521      * plain`call` is an unsafe replacement for a function call: use this
522      * function instead.
523      *
524      * If `target` reverts with a revert reason, it is bubbled up by this
525      * function (like regular Solidity function calls).
526      *
527      * Returns the raw returned data. To convert to the expected return value,
528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
529      *
530      * Requirements:
531      *
532      * - `target` must be a contract.
533      * - calling `target` with `data` must not revert.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
538         return functionCall(target, data, "Address: low-level call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
543      * `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, 0, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but also transferring `value` wei to `target`.
558      *
559      * Requirements:
560      *
561      * - the calling contract must have an ETH balance of at least `value`.
562      * - the called Solidity function must be `payable`.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value
570     ) internal returns (bytes memory) {
571         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
576      * with `errorMessage` as a fallback revert reason when `target` reverts.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(address(this).balance >= value, "Address: insufficient balance for call");
587         require(isContract(target), "Address: call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.call{value: value}(data);
590         return _verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
600         return functionStaticCall(target, data, "Address: low-level static call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(
610         address target,
611         bytes memory data,
612         string memory errorMessage
613     ) internal view returns (bytes memory) {
614         require(isContract(target), "Address: static call to non-contract");
615 
616         (bool success, bytes memory returndata) = target.staticcall(data);
617         return _verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
627         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
632      * but performing a delegate call.
633      *
634      * _Available since v3.4._
635      */
636     function functionDelegateCall(
637         address target,
638         bytes memory data,
639         string memory errorMessage
640     ) internal returns (bytes memory) {
641         require(isContract(target), "Address: delegate call to non-contract");
642 
643         (bool success, bytes memory returndata) = target.delegatecall(data);
644         return _verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     function _verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) private pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 /**
671  * @dev String operations.
672  */
673 library Strings {
674     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
678      */
679     function toString(uint256 value) internal pure returns (string memory) {
680         // Inspired by OraclizeAPI's implementation - MIT licence
681         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
682 
683         if (value == 0) {
684             return "0";
685         }
686         uint256 temp = value;
687         uint256 digits;
688         while (temp != 0) {
689             digits++;
690             temp /= 10;
691         }
692         bytes memory buffer = new bytes(digits);
693         while (value != 0) {
694             digits -= 1;
695             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
696             value /= 10;
697         }
698         return string(buffer);
699     }
700 
701     /**
702      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
703      */
704     function toHexString(uint256 value) internal pure returns (string memory) {
705         if (value == 0) {
706             return "0x00";
707         }
708         uint256 temp = value;
709         uint256 length = 0;
710         while (temp != 0) {
711             length++;
712             temp >>= 8;
713         }
714         return toHexString(value, length);
715     }
716 
717     /**
718      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
719      */
720     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
721         bytes memory buffer = new bytes(2 * length + 2);
722         buffer[0] = "0";
723         buffer[1] = "x";
724         for (uint256 i = 2 * length + 1; i > 1; --i) {
725             buffer[i] = _HEX_SYMBOLS[value & 0xf];
726             value >>= 4;
727         }
728         require(value == 0, "Strings: hex length insufficient");
729         return string(buffer);
730     }
731 }
732 
733 /// [MIT License]
734 /// @title Base64
735 /// @notice Provides a function for encoding some bytes in base64
736 /// @author Brecht Devos <brecht@loopring.org>
737 library Base64 {
738     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
739 
740     /// @notice Encodes some bytes to the base64 representation
741     function encode(bytes memory data) internal pure returns (string memory) {
742         uint256 len = data.length;
743         if (len == 0) return "";
744 
745         // multiply by 4/3 rounded up
746         uint256 encodedLen = 4 * ((len + 2) / 3);
747 
748         // Add some extra buffer at the end
749         bytes memory result = new bytes(encodedLen + 32);
750 
751         bytes memory table = TABLE;
752 
753         assembly {
754             let tablePtr := add(table, 1)
755             let resultPtr := add(result, 32)
756 
757             for {
758                 let i := 0
759             } lt(i, len) {
760 
761             } {
762                 i := add(i, 3)
763                 let input := and(mload(add(data, i)), 0xffffff)
764 
765                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
766                 out := shl(8, out)
767                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
768                 out := shl(8, out)
769                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
770                 out := shl(8, out)
771                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
772                 out := shl(224, out)
773 
774                 mstore(resultPtr, out)
775 
776                 resultPtr := add(resultPtr, 4)
777             }
778 
779             switch mod(len, 3)
780             case 1 {
781                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
782             }
783             case 2 {
784                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
785             }
786 
787             mstore(result, encodedLen)
788         }
789 
790         return string(result);
791     }
792 }
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata extension, but not including the Enumerable extension, which is available separately as
797  * {ERC721Enumerable}.
798  */
799 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
800     using Address for address;
801     using Strings for uint256;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to owner address
810     mapping(uint256 => address) private _owners;
811 
812     // Mapping owner address to token count
813     mapping(address => uint256) private _balances;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     /**
822      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
823      */
824     constructor(string memory name_, string memory symbol_) {
825         _name = name_;
826         _symbol = symbol_;
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
833         return
834             interfaceId == type(IERC721).interfaceId ||
835             interfaceId == type(IERC721Metadata).interfaceId ||
836             super.supportsInterface(interfaceId);
837     }
838 
839     /**
840      * @dev See {IERC721-balanceOf}.
841      */
842     function balanceOf(address owner) public view virtual override returns (uint256) {
843         require(owner != address(0), "ERC721: balance query for the zero address");
844         return _balances[owner];
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
851         address owner = _owners[tokenId];
852         require(owner != address(0), "ERC721: owner query for nonexistent token");
853         return owner;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-name}.
858      */
859     function name() public view virtual override returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-symbol}.
865      */
866     function symbol() public view virtual override returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-tokenURI}.
872      */
873     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
874         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
875 
876         string memory baseURI = _baseURI();
877         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
878     }
879 
880     /**
881      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883      * by default, can be overriden in child contracts.
884      */
885     function _baseURI() internal view virtual returns (string memory) {
886         return "";
887     }
888 
889     /**
890      * @dev See {IERC721-approve}.
891      */
892     function approve(address to, uint256 tokenId) public virtual override {
893         address owner = ERC721.ownerOf(tokenId);
894         require(to != owner, "ERC721: approval to current owner");
895 
896         require(
897             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898             "ERC721: approve caller is not owner nor approved for all"
899         );
900 
901         _approve(to, tokenId);
902     }
903 
904     /**
905      * @dev See {IERC721-getApproved}.
906      */
907     function getApproved(uint256 tokenId) public view virtual override returns (address) {
908         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
909 
910         return _tokenApprovals[tokenId];
911     }
912 
913     /**
914      * @dev See {IERC721-setApprovalForAll}.
915      */
916     function setApprovalForAll(address operator, bool approved) public virtual override {
917         require(operator != _msgSender(), "ERC721: approve to caller");
918 
919         _operatorApprovals[_msgSender()][operator] = approved;
920         emit ApprovalForAll(_msgSender(), operator, approved);
921     }
922 
923     /**
924      * @dev See {IERC721-isApprovedForAll}.
925      */
926     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927         return _operatorApprovals[owner][operator];
928     }
929 
930     /**
931      * @dev See {IERC721-transferFrom}.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         //solhint-disable-next-line max-line-length
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940 
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, "");
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965         _safeTransfer(from, to, tokenId, _data);
966     }
967 
968     /**
969      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
970      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
971      *
972      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
973      *
974      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
975      * implement alternative mechanisms to perform token transfer, such as signature-based.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must exist and be owned by `from`.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeTransfer(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) internal virtual {
992         _transfer(from, to, tokenId);
993         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      * and stop existing when they are burned (`_burn`).
1003      */
1004     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005         return _owners[tokenId] != address(0);
1006     }
1007 
1008     /**
1009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1016         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1017         address owner = ERC721.ownerOf(tokenId);
1018         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1019     }
1020 
1021     /**
1022      * @dev Safely mints `tokenId` and transfers it to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(address to, uint256 tokenId) internal virtual {
1032         _safeMint(to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038      */
1039     function _safeMint(
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _mint(to, tokenId);
1045         require(
1046             _checkOnERC721Received(address(0), to, tokenId, _data),
1047             "ERC721: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         address owner = ERC721.ownerOf(tokenId);
1087 
1088         _beforeTokenTransfer(owner, address(0), tokenId);
1089 
1090         // Clear approvals
1091         _approve(address(0), tokenId);
1092 
1093         _balances[owner] -= 1;
1094         delete _owners[tokenId];
1095 
1096         emit Transfer(owner, address(0), tokenId);
1097     }
1098 
1099     /**
1100      * @dev Transfers `tokenId` from `from` to `to`.
1101      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {
1115         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1116         require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(from, to, tokenId);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId);
1122 
1123         _balances[from] -= 1;
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(address to, uint256 tokenId) internal virtual {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1142      * The call is not executed if the target address is not a contract.
1143      *
1144      * @param from address representing the previous owner of the given token ID
1145      * @param to target address that will receive the tokens
1146      * @param tokenId uint256 ID of the token to be transferred
1147      * @param _data bytes optional data to send along with the call
1148      * @return bool whether the call correctly returned the expected magic value
1149      */
1150     function _checkOnERC721Received(
1151         address from,
1152         address to,
1153         uint256 tokenId,
1154         bytes memory _data
1155     ) private returns (bool) {
1156         if (to.isContract()) {
1157             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1158                 return retval == IERC721Receiver.onERC721Received.selector;
1159             } catch (bytes memory reason) {
1160                 if (reason.length == 0) {
1161                     revert("ERC721: transfer to non ERC721Receiver implementer");
1162                 } else {
1163                     assembly {
1164                         revert(add(32, reason), mload(reason))
1165                     }
1166                 }
1167             }
1168         } else {
1169             return true;
1170         }
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1183      * - `from` and `to` are never both zero.
1184      *
1185      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1186      */
1187     function _beforeTokenTransfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) internal virtual {}
1192 }
1193 
1194 /**
1195  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1196  * enumerability of all the token ids in the contract as well as all token ids owned by each
1197  * account.
1198  */
1199 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1200     // Mapping from owner to list of owned token IDs
1201     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1202 
1203     // Mapping from token ID to index of the owner tokens list
1204     mapping(uint256 => uint256) private _ownedTokensIndex;
1205 
1206     // Array with all token ids, used for enumeration
1207     uint256[] private _allTokens;
1208 
1209     // Mapping from token id to position in the allTokens array
1210     mapping(uint256 => uint256) private _allTokensIndex;
1211 
1212     /**
1213      * @dev See {IERC165-supportsInterface}.
1214      */
1215     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1216         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1221      */
1222     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1223         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1224         return _ownedTokens[owner][index];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721Enumerable-totalSupply}.
1229      */
1230     function totalSupply() public view virtual override returns (uint256) {
1231         return _allTokens.length;
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Enumerable-tokenByIndex}.
1236      */
1237     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1238         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1239         return _allTokens[index];
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before any token transfer. This includes minting
1244      * and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1252      * - `from` cannot be the zero address.
1253      * - `to` cannot be the zero address.
1254      *
1255      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1256      */
1257     function _beforeTokenTransfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual override {
1262         super._beforeTokenTransfer(from, to, tokenId);
1263 
1264         if (from == address(0)) {
1265             _addTokenToAllTokensEnumeration(tokenId);
1266         } else if (from != to) {
1267             _removeTokenFromOwnerEnumeration(from, tokenId);
1268         }
1269         if (to == address(0)) {
1270             _removeTokenFromAllTokensEnumeration(tokenId);
1271         } else if (to != from) {
1272             _addTokenToOwnerEnumeration(to, tokenId);
1273         }
1274     }
1275 
1276     /**
1277      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1278      * @param to address representing the new owner of the given token ID
1279      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1280      */
1281     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1282         uint256 length = ERC721.balanceOf(to);
1283         _ownedTokens[to][length] = tokenId;
1284         _ownedTokensIndex[tokenId] = length;
1285     }
1286 
1287     /**
1288      * @dev Private function to add a token to this extension's token tracking data structures.
1289      * @param tokenId uint256 ID of the token to be added to the tokens list
1290      */
1291     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1292         _allTokensIndex[tokenId] = _allTokens.length;
1293         _allTokens.push(tokenId);
1294     }
1295 
1296     /**
1297      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1298      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1299      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1300      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1301      * @param from address representing the previous owner of the given token ID
1302      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1303      */
1304     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1305         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1306         // then delete the last slot (swap and pop).
1307 
1308         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1309         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1310 
1311         // When the token to delete is the last token, the swap operation is unnecessary
1312         if (tokenIndex != lastTokenIndex) {
1313             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1314 
1315             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1316             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1317         }
1318 
1319         // This also deletes the contents at the last position of the array
1320         delete _ownedTokensIndex[tokenId];
1321         delete _ownedTokens[from][lastTokenIndex];
1322     }
1323 
1324     /**
1325      * @dev Private function to remove a token from this extension's token tracking data structures.
1326      * This has O(1) time complexity, but alters the order of the _allTokens array.
1327      * @param tokenId uint256 ID of the token to be removed from the tokens list
1328      */
1329     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1330         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1331         // then delete the last slot (swap and pop).
1332 
1333         uint256 lastTokenIndex = _allTokens.length - 1;
1334         uint256 tokenIndex = _allTokensIndex[tokenId];
1335 
1336         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1337         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1338         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1339         uint256 lastTokenId = _allTokens[lastTokenIndex];
1340 
1341         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1342         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1343 
1344         // This also deletes the contents at the last position of the array
1345         delete _allTokensIndex[tokenId];
1346         _allTokens.pop();
1347     }
1348 }
1349 
1350 
1351 
1352 contract Vibes is ERC721Enumerable, ERC2981ContractWideRoyalties, ReentrancyGuard, Ownable {
1353     using Strings for uint256;
1354 
1355     // 0.07 ETH
1356     uint256 public constant MINT_COST = 70000000000000000;
1357 
1358     bool public mintingActive = false;
1359     bool public useAnimation = false;
1360     bool public useOnChainAnimation = false;
1361     string private baseVibeURI = "ipfs://QmYJBegzL7JNTkrgjUqJTwiSQ3QDcyEX3aj2ekjFmmLMc6/";
1362 
1363     mapping(uint256 => bytes32) private entropyHashes;
1364 
1365     struct ColorInfo {
1366         uint256[] colorInts;
1367         uint256[] colorIntsChosen;
1368         uint256 colorIntCount;
1369         bool ordered;
1370         bool shuffle;
1371         bool restricted;
1372         string palette;
1373         uint256 colorCount;
1374     }
1375 
1376     struct TokenInfo {
1377         string entropyHash;
1378         string element;
1379         string palette;
1380         uint256 colorCount;
1381         string style;
1382         string gravity;
1383         string grain;
1384         string display;
1385         string[14] html;
1386     }
1387 
1388     constructor() ERC721("Vibes", "VIBES") Ownable() {
1389         // set voluntary royalties, according to ERC2981, @ 1 / 77, or 1.3%, 130 basis points
1390         _setRoyalties(owner(), 130);
1391     }
1392 
1393     function getElement(uint256 tokenId) private view returns (string memory) {
1394         return Art.getElementByRoll(roll1000(tokenId, Art.ROLL_ELEMENT));
1395     }
1396 
1397     function getPalette(uint256 tokenId) private view returns (string memory) {
1398         return Art.getPaletteByRoll(roll1000(tokenId, Art.ROLL_PALETTE), getElement(tokenId));
1399     }
1400 
1401     function getColorByIndex(uint256 tokenId, uint256 lookupIndex) public view returns (string memory) {
1402         ColorInfo memory info;
1403         info.colorCount = getColorCount(tokenId);
1404         if (lookupIndex >= info.colorCount || tokenId == 0 || tokenId > super.totalSupply()) {
1405             return 'null';
1406         }
1407 
1408         (info.colorInts, info.colorIntCount, info.ordered, info.shuffle, info.restricted) = ColorData.getPaletteColors(getPalette(tokenId));
1409 
1410         uint256 i;
1411         uint256 temp;
1412         uint256 startIndex;
1413         uint256 currIndex;
1414         uint256 codeCount;
1415 
1416         info.colorIntsChosen = new uint256[](12);
1417 
1418         if (info.ordered) {
1419             temp = roll1000(tokenId, Art.ROLL_ORDERED);
1420             startIndex = temp % info.colorIntCount;
1421             for (i = 0; i < info.colorIntCount; i++) {
1422                 currIndex = startIndex + i;
1423                 if (currIndex >= info.colorIntCount) {
1424                     currIndex -= info.colorIntCount;
1425                 }
1426                 info.colorIntsChosen[i] = info.colorInts[currIndex];
1427             }
1428         } else if (info.shuffle) {
1429             codeCount = info.colorIntCount;
1430 
1431             while (codeCount > 0) {
1432                 i = roll1000(tokenId, string(abi.encodePacked(Art.ROLL_SHUFFLE, toString(codeCount)))) % codeCount;
1433                 codeCount -= 1;
1434 
1435                 temp = info.colorInts[codeCount];
1436                 info.colorInts[codeCount] = info.colorInts[i];
1437                 info.colorInts[i] = temp;
1438             }
1439 
1440             for (i = 0; i < info.colorIntCount; i++) {
1441                 info.colorIntsChosen[i] = info.colorInts[i];
1442             }
1443         } else {
1444             for (i = 0; i < info.colorIntCount; i++) {
1445                 info.colorIntsChosen[i] = info.colorInts[i];
1446             }
1447         }
1448 
1449         if (info.restricted) {
1450             temp = getWobbledColor(info.colorIntsChosen[lookupIndex % info.colorIntCount], tokenId, lookupIndex);
1451         } else if (lookupIndex >= info.colorIntCount) {
1452             temp = getRandomColor(tokenId, lookupIndex);
1453         } else {
1454             temp = getWobbledColor(info.colorIntsChosen[lookupIndex], tokenId, lookupIndex);
1455         }
1456 
1457         return Art.getColorCode(temp);
1458     }
1459 
1460     function getWobbledColor(uint256 color, uint256 tokenId, uint256 index) private view returns (uint256) {
1461         uint256 r = (color >> uint256(16)) & uint256(255);
1462         uint256 g = (color >> uint256(8)) & uint256(255);
1463         uint256 b = color & uint256(255);
1464         uint256 offsetR = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_RED, toString(index)))) % uint256(8);
1465         uint256 offsetG = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_GREEN, toString(index)))) % uint256(8);
1466         uint256 offsetB = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_BLUE, toString(index)))) % uint256(8);
1467         uint256 offsetDirR = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_DIRRED, toString(index)))) % uint256(2);
1468         uint256 offsetDirG = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_DIRGREEN, toString(index)))) % uint256(2);
1469         uint256 offsetDirB = rollMax(tokenId, string(abi.encodePacked(Art.ROLL_DIRBLUE, toString(index)))) % uint256(2);
1470 
1471         if (offsetDirR == uint256(0)) {
1472             if (r > offsetR) {
1473                 r -= offsetR;
1474             } else {
1475                 r = uint256(0);
1476             }
1477         } else {
1478             if (r + offsetR <= uint256(255)) {
1479                 r += offsetR;
1480             } else {
1481                 r = uint256(255);
1482             }
1483         }
1484 
1485         if (offsetDirG == uint256(0)) {
1486             if (g > offsetG) {
1487                 g -= offsetG;
1488             } else {
1489                 g = uint256(0);
1490             }
1491         } else {
1492             if (g + offsetG <= uint256(255)) {
1493                 g += offsetG;
1494             } else {
1495                 g = uint256(255);
1496             }
1497         }
1498 
1499         if (offsetDirB == uint256(0)) {
1500             if (b > offsetB) {
1501                 b -= offsetB;
1502             } else {
1503                 b = uint256(0);
1504             }
1505         } else {
1506             if (b + offsetB <= uint256(255)) {
1507                 b += offsetB;
1508             } else {
1509                 b = uint256(255);
1510             }
1511         }
1512 
1513         return uint256((r << uint256(16)) | (g << uint256(8)) | b);
1514     }
1515 
1516     function getRandomColor(uint256 tokenId, uint256 index) private view returns (uint256) {
1517         return rollMax(tokenId, string(abi.encodePacked(Art.ROLL_RANDOMCOLOR, toString(index)))) % uint256(16777216);
1518     }
1519 
1520     function getStyle(uint256 tokenId) private view returns (string memory) {
1521         return Art.getStyleByRoll(roll1000(tokenId, Art.ROLL_STYLE));
1522     }
1523 
1524     function getColorCount(uint256 tokenId) private view returns (uint256) {
1525         return Art.getColorCount(roll1000(tokenId, Art.ROLL_COLORCOUNT), getStyle(tokenId));
1526     }
1527 
1528     function getGravity(uint256 tokenId) private view returns (string memory) {
1529         string memory gravity;
1530         string memory style = getStyle(tokenId);
1531         uint256 colorCount = getColorCount(tokenId);
1532         uint256 roll = roll1000(tokenId, Art.ROLL_GRAVITY);
1533 
1534         if (colorCount >= uint256(5) && Art.compareStrings(style, Art.STYLE_SMOOTH)) {
1535             gravity = Art.getGravityLimitedByRoll(roll);
1536         } else {
1537             gravity = Art.getGravityByRoll(roll);
1538         }
1539 
1540         return gravity;
1541     }
1542 
1543     function getGrain(uint256 tokenId) private view returns (string memory) {
1544         return Art.getGrainByRoll(roll1000(tokenId, Art.ROLL_GRAIN));
1545     }
1546 
1547     function getDisplay(uint256 tokenId) private view returns (string memory) {
1548         return Art.getDisplayByRoll(roll1000(tokenId, Art.ROLL_DISPLAY));
1549     }
1550 
1551     function getRandomBlockhash(uint256 tokenId) private view returns (bytes32) {
1552         uint256 decrement = (tokenId % uint256(255)) % (block.number - uint256(1));
1553         uint256 blockIndex = block.number - (decrement + uint256(1));
1554         return blockhash(blockIndex);
1555     }
1556 
1557     function getEntropyHash(uint256 tokenId) private view returns (string memory) {
1558         return uint256(entropyHashes[tokenId]).toHexString();
1559     }
1560 
1561     function rollMax(uint256 tokenId, string memory key) private view returns (uint256) {
1562         string memory hashEntropy = getEntropyHash(tokenId);
1563         string memory tokenEntropy = string(abi.encodePacked(key, toString(tokenId)));
1564         return random(hashEntropy) ^ random(tokenEntropy);
1565     }
1566 
1567     function roll1000(uint256 tokenId, string memory key) private view returns (uint256) {
1568         return uint256(1) + rollMax(tokenId, key) % uint256(1000);
1569     }
1570 
1571     function random(string memory input) private pure returns (uint256) {
1572         return uint256(keccak256(abi.encodePacked(input)));
1573     }
1574 
1575     function tokenScript(uint256 tokenId) public view returns (string memory) {
1576         require(tokenId > 0 && tokenId <= super.totalSupply(), 'invalid tokenId');
1577 
1578         TokenInfo memory info;
1579         info.entropyHash = getEntropyHash(tokenId);
1580         info.colorCount = getColorCount(tokenId);
1581         info.style = getStyle(tokenId);
1582         info.gravity = getGravity(tokenId);
1583         info.grain = getGrain(tokenId);
1584         info.display = getDisplay(tokenId);
1585 
1586         info.html[0] = '<!doctype html><html><head><script>';
1587         info.html[1] = string(abi.encodePacked('H="', info.entropyHash, '";'));
1588         info.html[2] = string(abi.encodePacked('Y="', info.style, '";'));
1589         info.html[3] = string(abi.encodePacked('G="', info.gravity, '";'));
1590         info.html[4] = string(abi.encodePacked('A="', info.grain, '";'));
1591         info.html[5] = string(abi.encodePacked('D="', info.display, '";'));
1592 
1593         string memory colorString;
1594         string memory partString;
1595         uint256 i;
1596         for (i = 0; i < 6; i++) {
1597             if (i < info.colorCount) {
1598                 colorString = getColorByIndex(tokenId, i);
1599             } else {
1600                 colorString = '';
1601             }
1602 
1603             if (i == 0) {
1604                 partString = string(abi.encodePacked('P=["', colorString, '",'));
1605             } else if (i < info.colorCount - 1) {
1606                 partString = string(abi.encodePacked('"', colorString, '",'));
1607             } else if (i < info.colorCount) {
1608                 partString = string(abi.encodePacked('"', colorString, '"];'));
1609             } else {
1610                 partString = '';
1611             }
1612 
1613             info.html[6 + i] = partString;
1614         }
1615 
1616         info.html[12] = Art.getScript();
1617         info.html[13] = '</script></head><body></body></html>';
1618 
1619         string memory output = string(abi.encodePacked(info.html[0], info.html[1], info.html[2], info.html[3], info.html[4], info.html[5], info.html[6]));
1620         return string(abi.encodePacked(output, info.html[7], info.html[8], info.html[9], info.html[10], info.html[11], info.html[12], info.html[13]));
1621     }
1622 
1623     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1624         require(tokenId > 0 && tokenId <= super.totalSupply(), 'invalid tokenId');
1625 
1626         TokenInfo memory info;
1627         info.element = getElement(tokenId);
1628         info.palette = getPalette(tokenId);
1629         info.colorCount = getColorCount(tokenId);
1630         info.style = getStyle(tokenId);
1631         info.gravity = getGravity(tokenId);
1632         info.grain = getGrain(tokenId);
1633         info.display = getDisplay(tokenId);
1634 
1635         string memory imagePath = string(abi.encodePacked(baseVibeURI, toString(tokenId), '.jpg'));
1636         string memory json = string(abi.encodePacked('{"name": "vibe #', toString(tokenId), '", "description": "vibes is a generative art collection, randomly created and stored on chain. each token is an interactive html page that allows you to render your vibe at any size. vibes make their color palette available on chain, so feel free to carry your colors with you on your adventures.", "image": "', imagePath));
1637 
1638         if (useOnChainAnimation) {
1639             string memory script = tokenScript(tokenId);
1640             json = string(abi.encodePacked(json, '", "animation_url": "data:text/html;base64,', Base64.encode(bytes(script))));
1641         } else if (useAnimation) {
1642             json = string(abi.encodePacked(json, '", "animation_url": "', string(abi.encodePacked(baseVibeURI, toString(tokenId), '.html'))));
1643         }
1644 
1645         json = string(abi.encodePacked(json, '", "attributes": [{ "trait_type": "element", "value": "', info.element, '" }, { "trait_type": "palette", "value": "', info.palette, '" }, { "trait_type": "colors", "value": "', toString(info.colorCount), '" }, { "trait_type": "style", "value": "', info.style));
1646         json = string(abi.encodePacked(json, '" }, { "trait_type": "gravity", "value": "', info.gravity, '" }, { "trait_type": "grain", "value": "', info.grain, '" }, { "trait_type": "display", "value": "', info.display, '" }]}'));
1647 
1648         return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(json))));
1649     }
1650 
1651     function mintVibes(uint256 mintCount) public payable nonReentrant {
1652         uint256 lastTokenId = super.totalSupply();
1653         require(mintingActive, 'gm friend. minting vibes soon.');
1654         require(mintCount <= uint256(7), 'whoa friend. max 7 vibes a mint.');
1655         require(lastTokenId + mintCount <= uint256(7777), 'gn friend. only so many vibes.');
1656         require(MINT_COST * mintCount <= msg.value, 'hey friend. minting vibes costs more.');
1657         require(!isContract(_msgSender()), 'yo friend. no bot vibes. get a fresh wallet.');
1658 
1659         for (uint256 i = 1; i <= mintCount; i++) {
1660             mintVibe(_msgSender(), lastTokenId + i);
1661         }
1662     }
1663 
1664     function reserveVibes(uint256 reserveCount) public nonReentrant onlyOwner {
1665         uint256 lastTokenId = super.totalSupply();
1666         require(lastTokenId + reserveCount <= uint256(77), 'no worries friend. vibes already reserved.');
1667 
1668         for (uint256 i = 1; i <= reserveCount; i++) {
1669             mintVibe(owner(), lastTokenId + i);
1670         }
1671     }
1672 
1673     function mintVibe(address minter, uint256 tokenId) private {
1674         entropyHashes[tokenId] = getRandomBlockhash(tokenId);
1675         _safeMint(minter, tokenId);
1676     }
1677 
1678     function vibeCheck() public onlyOwner {
1679         mintingActive = !mintingActive;
1680     }
1681 
1682     function toggleAnimation() public onlyOwner {
1683         useAnimation = !useAnimation;
1684     }
1685 
1686     function toggleOnChainAnimation() public onlyOwner {
1687         useOnChainAnimation = !useOnChainAnimation;
1688     }
1689 
1690     function setVibeURI(string memory uri) public onlyOwner {
1691         baseVibeURI = uri;
1692     }
1693 
1694     function withdraw() public onlyOwner {
1695         uint256 balance = address(this).balance;
1696         payable(owner()).transfer(balance);
1697     }
1698 
1699     function supportsInterface(bytes4 interfaceId)
1700         public
1701         view
1702         virtual
1703         override(ERC721Enumerable, ERC2981ContractWideRoyalties)
1704         returns (bool)
1705     {
1706         return super.supportsInterface(interfaceId);
1707     }
1708 
1709     function isContract(address account) internal view returns (bool) {
1710         // This method relies on extcodesize, which returns 0 for contracts in
1711         // construction, since the code is only stored at the end of the
1712         // constructor execution.
1713 
1714         uint256 size;
1715         assembly {
1716             size := extcodesize(account)
1717         }
1718         return size > 0;
1719     }
1720 
1721     function toString(uint256 value) internal pure returns (string memory) {
1722     // Inspired by OraclizeAPI's implementation - MIT license
1723     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1724 
1725         if (value == 0) {
1726             return "0";
1727         }
1728         uint256 temp = value;
1729         uint256 digits;
1730         while (temp != 0) {
1731             digits++;
1732             temp /= 10;
1733         }
1734         bytes memory buffer = new bytes(digits);
1735         while (value != 0) {
1736             digits -= 1;
1737             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1738             value /= 10;
1739         }
1740         return string(buffer);
1741     }
1742 
1743 }
1744 
1745 library ColorData {
1746 
1747     function getPaletteColors(string memory palette) public pure returns (uint256[] memory, uint256, bool, bool, bool) {
1748         uint256[] memory colorInts = new uint256[](12);
1749         uint256 colorIntCount = 0;
1750         bool ordered = false;
1751         bool shuffle = true;
1752         bool restricted = true;
1753 
1754         if (Art.compareStrings(palette, Art.NAT_PAL_JUNGLE)) {
1755             ordered = true;
1756             colorInts[0] = uint256(3299866);
1757             colorInts[1] = uint256(1256965);
1758             colorInts[2] = uint256(2375731);
1759             colorInts[3] = uint256(67585);
1760             colorInts[4] = uint256(16749568);
1761             colorInts[5] = uint256(16776295);
1762             colorInts[6] = uint256(16748230);
1763             colorInts[7] = uint256(16749568);
1764             colorInts[8] = uint256(67585);
1765             colorInts[9] = uint256(2375731);
1766             colorIntCount = uint256(10);
1767         } else if (Art.compareStrings(palette, Art.NAT_PAL_SPRING)) {
1768             colorInts[0] = uint256(11003600);
1769             colorInts[1] = uint256(14413507);
1770             colorInts[2] = uint256(16765879);
1771             colorInts[3] = uint256(16755365);
1772             colorIntCount = uint256(4);
1773         } else if (Art.compareStrings(palette, Art.NAT_PAL_CAMOUFLAGE)) {
1774             colorInts[0] = uint256(10328673);
1775             colorInts[1] = uint256(6245168);
1776             colorInts[2] = uint256(2171169);
1777             colorInts[3] = uint256(4610624);
1778             colorInts[4] = uint256(5269320);
1779             colorInts[5] = uint256(4994846);
1780             colorIntCount = uint256(6);
1781         } else if (Art.compareStrings(palette, Art.NAT_PAL_BLOSSOM)) {
1782             colorInts[0] = uint256(16749568);
1783             colorInts[1] = uint256(16776295);
1784             colorInts[2] = uint256(15348552);
1785             colorInts[3] = uint256(16748230);
1786             colorInts[4] = uint256(11826656);
1787             colorInts[5] = uint256(16769505);
1788             colorIntCount = uint256(6);
1789         } else if (Art.compareStrings(palette, Art.NAT_PAL_LEAF)) {
1790             shuffle = false;
1791             colorInts[0] = uint256(16773276);
1792             colorInts[1] = uint256(7790506);
1793             colorInts[2] = uint256(13888432);
1794             colorInts[3] = uint256(13140270);
1795             colorInts[4] = uint256(12822363);
1796             colorIntCount = uint256(5);
1797         } else if (Art.compareStrings(palette, Art.NAT_PAL_LEMONADE)) {
1798             colorInts[0] = uint256(16285109);
1799             colorInts[1] = uint256(16759385);
1800             colorInts[2] = uint256(16182422);
1801             colorInts[3] = uint256(616217);
1802             colorIntCount = uint256(4);
1803         } else if (Art.compareStrings(palette, Art.NAT_PAL_BIOLUMINESCENCE)) {
1804             colorInts[0] = uint256(2434341);
1805             colorInts[1] = uint256(4194315);
1806             colorInts[2] = uint256(6488209);
1807             colorInts[3] = uint256(7270568);
1808             colorInts[4] = uint256(9117400);
1809             colorInts[5] = uint256(1599944);
1810             colorIntCount = uint256(6);
1811         } else if (Art.compareStrings(palette, Art.NAT_PAL_RAINFOREST)) {
1812             ordered = true;
1813             colorInts[0] = uint256(2205512);
1814             colorInts[1] = uint256(558463);
1815             colorInts[2] = uint256(7195497);
1816             colorInts[3] = uint256(3116642);
1817             colorInts[4] = uint256(7131409);
1818             colorInts[5] = uint256(1673472);
1819             colorIntCount = uint256(6);
1820         } else if (Art.compareStrings(palette, Art.LIG_PAL_PASTEL)) {
1821             colorInts[0] = uint256(16761760);
1822             colorInts[1] = uint256(16756669);
1823             colorInts[2] = uint256(16636817);
1824             colorInts[3] = uint256(13762047);
1825             colorInts[4] = uint256(8714928);
1826             colorInts[5] = uint256(9425908);
1827             colorInts[6] = uint256(16499435);
1828             colorInts[7] = uint256(10587345);
1829             colorIntCount = uint256(8);
1830         } else if (Art.compareStrings(palette, Art.LIG_PAL_HOLY)) {
1831             colorInts[0] = uint256(16776685);
1832             colorInts[1] = uint256(16706239);
1833             colorInts[2] = uint256(16568740);
1834             colorInts[3] = uint256(15646621);
1835             colorInts[4] = uint256(11178648);
1836             colorIntCount = uint256(5);
1837         } else if (Art.compareStrings(palette, Art.LIG_PAL_SYLVAN)) {
1838             colorInts[0] = uint256(16691652);
1839             colorInts[1] = uint256(15987447);
1840             colorInts[2] = uint256(7580394);
1841             colorInts[3] = uint256(12809355);
1842             colorInts[4] = uint256(12821954);
1843             colorInts[5] = uint256(7718129);
1844             colorIntCount = uint256(6);
1845         } else if (Art.compareStrings(palette, Art.LIG_PAL_GLOW)) {
1846             colorInts[0] = uint256(8257501);
1847             colorInts[1] = uint256(12030203);
1848             colorInts[2] = uint256(9338616);
1849             colorInts[3] = uint256(16751583);
1850             colorIntCount = uint256(4);
1851         } else if (Art.compareStrings(palette, Art.LIG_PAL_SUNSET)) {
1852             colorInts[0] = uint256(15887184);
1853             colorInts[1] = uint256(14837651);
1854             colorInts[2] = uint256(16748936);
1855             colorInts[3] = uint256(11817579);
1856             colorInts[4] = uint256(8473468);
1857             colorIntCount = uint256(5);
1858         } else if (Art.compareStrings(palette, Art.LIG_PAL_INFRARED)) {
1859             ordered = true;
1860             colorInts[0] = uint256(16642938);
1861             colorInts[1] = uint256(16755712);
1862             colorInts[2] = uint256(15883521);
1863             colorInts[3] = uint256(13503623);
1864             colorInts[4] = uint256(8257951);
1865             colorInts[5] = uint256(327783);
1866             colorInts[6] = uint256(13503623);
1867             colorInts[7] = uint256(15883521);
1868             colorIntCount = uint256(8);
1869         } else if (Art.compareStrings(palette, Art.LIG_PAL_ULTRAVIOLET)) {
1870             colorInts[0] = uint256(14200063);
1871             colorInts[1] = uint256(5046460);
1872             colorInts[2] = uint256(16775167);
1873             colorInts[3] = uint256(16024318);
1874             colorInts[4] = uint256(11665662);
1875             colorInts[5] = uint256(1507410);
1876             colorIntCount = uint256(6);
1877         } else if (Art.compareStrings(palette, Art.LIG_PAL_YANG)) {
1878             restricted = false;
1879             colorInts[0] = uint256(16777215);
1880             colorIntCount = uint256(1);
1881         } else if (Art.compareStrings(palette, Art.WAT_PAL_ARCHIPELAGO)) {
1882             colorInts[0] = uint256(10079171);
1883             colorInts[1] = uint256(15261129);
1884             colorInts[2] = uint256(43954);
1885             colorInts[3] = uint256(13742713);
1886             colorInts[4] = uint256(15854035);
1887             colorInts[5] = uint256(2982588);
1888             colorIntCount = uint256(6);
1889         } else if (Art.compareStrings(palette, Art.WAT_PAL_FROZEN)) {
1890             colorInts[0] = uint256(13034750);
1891             colorInts[1] = uint256(4102128);
1892             colorInts[2] = uint256(826589);
1893             colorInts[3] = uint256(346764);
1894             colorInts[4] = uint256(6707);
1895             colorInts[5] = uint256(1277652);
1896             colorIntCount = uint256(6);
1897         } else if (Art.compareStrings(palette, Art.WAT_PAL_VAPOR)) {
1898             colorInts[0] = uint256(9361904);
1899             colorInts[1] = uint256(15724747);
1900             colorInts[2] = uint256(2781329);
1901             colorInts[3] = uint256(6194589);
1902             colorIntCount = uint256(4);
1903         } else if (Art.compareStrings(palette, Art.WAT_PAL_DAWN)) {
1904             colorInts[0] = uint256(334699);
1905             colorInts[1] = uint256(610965);
1906             colorInts[2] = uint256(5408708);
1907             colorInts[3] = uint256(16755539);
1908             colorIntCount = uint256(4);
1909         } else if (Art.compareStrings(palette, Art.WAT_PAL_GLACIER)) {
1910             colorInts[0] = uint256(13298921);
1911             colorInts[1] = uint256(1792100);
1912             colorInts[2] = uint256(6342370);
1913             colorInts[3] = uint256(5484740);
1914             colorInts[4] = uint256(2787216);
1915             colorInts[5] = uint256(1327172);
1916             colorIntCount = uint256(6);
1917         } else if (Art.compareStrings(palette, Art.WAT_PAL_SHANTY)) {
1918             colorInts[0] = uint256(600905);
1919             colorInts[1] = uint256(625330);
1920             colorInts[2] = uint256(30334);
1921             colorInts[3] = uint256(1552554);
1922             colorInts[4] = uint256(1263539);
1923             colorInts[5] = uint256(577452);
1924             colorIntCount = uint256(6);
1925         } else if (Art.compareStrings(palette, Art.WAT_PAL_VICE)) {
1926             colorInts[0] = uint256(41952);
1927             colorInts[1] = uint256(46760);
1928             colorInts[2] = uint256(16491446);
1929             colorInts[3] = uint256(16765877);
1930             colorIntCount = uint256(4);
1931         } else if (Art.compareStrings(palette, Art.WAT_PAL_OPALESCENT)) {
1932             ordered = true;
1933             colorInts[0] = uint256(15985337);
1934             colorInts[1] = uint256(15981758);
1935             colorInts[2] = uint256(15713994);
1936             colorInts[3] = uint256(13941977);
1937             colorInts[4] = uint256(8242919);
1938             colorInts[5] = uint256(15985337);
1939             colorInts[6] = uint256(15981758);
1940             colorInts[7] = uint256(15713994);
1941             colorInts[8] = uint256(13941977);
1942             colorInts[9] = uint256(8242919);
1943             colorIntCount = uint256(10);
1944         } else if (Art.compareStrings(palette, Art.EAR_PAL_ARID)) {
1945             restricted = false;
1946             colorInts[0] = uint256(16494931);
1947             colorInts[1] = uint256(14979685);
1948             colorInts[2] = uint256(4989197);
1949             colorInts[3] = uint256(15158540);
1950             colorIntCount = uint256(4);
1951         } else if (Art.compareStrings(palette, Art.EAR_PAL_RIDGE)) {
1952             colorInts[0] = uint256(273743);
1953             colorInts[1] = uint256(2175795);
1954             colorInts[2] = uint256(7837380);
1955             colorInts[3] = uint256(1975345);
1956             colorInts[4] = uint256(8228210);
1957             colorInts[5] = uint256(6571631);
1958             colorIntCount = uint256(6);
1959         } else if (Art.compareStrings(palette, Art.EAR_PAL_COAL)) {
1960             colorInts[0] = uint256(3613475);
1961             colorInts[1] = uint256(1577233);
1962             colorInts[2] = uint256(4407359);
1963             colorInts[3] = uint256(2894892);
1964             colorIntCount = uint256(4);
1965         } else if (Art.compareStrings(palette, Art.EAR_PAL_TOUCH)) {
1966             colorInts[0] = uint256(13149573);
1967             colorInts[1] = uint256(13012609);
1968             colorInts[2] = uint256(11044194);
1969             colorInts[3] = uint256(8145729);
1970             colorInts[4] = uint256(6046249);
1971             colorInts[5] = uint256(5123882);
1972             colorInts[6] = uint256(13934738);
1973             colorInts[7] = uint256(12096624);
1974             colorInts[8] = uint256(12024688);
1975             colorInts[9] = uint256(7426613);
1976             colorInts[10] = uint256(6634804);
1977             colorInts[11] = uint256(4731682);
1978             colorIntCount = uint256(12);
1979         } else if (Art.compareStrings(palette, Art.EAR_PAL_BRONZE)) {
1980             colorInts[0] = uint256(16166768);
1981             colorInts[1] = uint256(10578500);
1982             colorInts[2] = uint256(7555631);
1983             colorInts[3] = uint256(16105363);
1984             colorInts[4] = uint256(11894865);
1985             colorInts[5] = uint256(5323820);
1986             colorIntCount = uint256(6);
1987         } else if (Art.compareStrings(palette, Art.EAR_PAL_SILVER)) {
1988             colorInts[0] = uint256(16053492);
1989             colorInts[1] = uint256(15329769);
1990             colorInts[2] = uint256(10132122);
1991             colorInts[3] = uint256(6776679);
1992             colorInts[4] = uint256(3881787);
1993             colorInts[5] = uint256(1579032);
1994             colorIntCount = uint256(6);
1995         } else if (Art.compareStrings(palette, Art.EAR_PAL_GOLD)) {
1996             colorInts[0] = uint256(16373583);
1997             colorInts[1] = uint256(12152866);
1998             colorInts[2] = uint256(12806164);
1999             colorInts[3] = uint256(4725765);
2000             colorInts[4] = uint256(2557441);
2001             colorIntCount = uint256(5);
2002         } else if (Art.compareStrings(palette, Art.EAR_PAL_PLATINUM)) {
2003             colorInts[0] = uint256(15466475);
2004             colorInts[1] = uint256(14215669);
2005             colorInts[2] = uint256(7962760);
2006             colorInts[3] = uint256(13101564);
2007             colorInts[4] = uint256(7912858);
2008             colorInts[5] = uint256(3703413);
2009             colorIntCount = uint256(6);
2010         } else if (Art.compareStrings(palette, Art.WIN_PAL_BERRY)) {
2011             shuffle = false;
2012             colorInts[0] = uint256(5428970);
2013             colorInts[1] = uint256(13323211);
2014             colorInts[2] = uint256(15385745);
2015             colorInts[3] = uint256(13355851);
2016             colorInts[4] = uint256(15356630);
2017             colorInts[5] = uint256(14903600);
2018             colorIntCount = uint256(6);
2019         } else if (Art.compareStrings(palette, Art.WIN_PAL_BREEZE)) {
2020             colorInts[0] = uint256(9952971);
2021             colorInts[1] = uint256(14020036);
2022             colorInts[2] = uint256(16766134);
2023             colorInts[3] = uint256(16755367);
2024             colorInts[4] = uint256(1091816);
2025             colorIntCount = uint256(5);
2026         } else if (Art.compareStrings(palette, Art.WIN_PAL_JOLT)) {
2027             colorInts[0] = uint256(16240492);
2028             colorInts[1] = uint256(3083849);
2029             colorInts[2] = uint256(15463155);
2030             colorInts[3] = uint256(12687431);
2031             colorIntCount = uint256(4);
2032         } else if (Art.compareStrings(palette, Art.WIN_PAL_THUNDER)) {
2033             colorInts[0] = uint256(924722);
2034             colorInts[1] = uint256(9464002);
2035             colorInts[2] = uint256(470093);
2036             colorInts[3] = uint256(6378394);
2037             colorInts[4] = uint256(16246484);
2038             colorInts[5] = uint256(12114921);
2039             colorIntCount = uint256(6);
2040         } else if (Art.compareStrings(palette, Art.WIN_PAL_WINTER)) {
2041             colorInts[0] = uint256(16051966);
2042             colorInts[1] = uint256(14472694);
2043             colorInts[2] = uint256(10924255);
2044             colorInts[3] = uint256(4474995);
2045             colorIntCount = uint256(4);
2046         } else if (Art.compareStrings(palette, Art.WIN_PAL_HEATHERMOOR)) {
2047             colorInts[0] = uint256(16774653);
2048             colorInts[1] = uint256(10915755);
2049             colorInts[2] = uint256(16750253);
2050             colorInts[3] = uint256(208472);
2051             colorIntCount = uint256(4);
2052         } else if (Art.compareStrings(palette, Art.WIN_PAL_ZEUS)) {
2053             colorInts[0] = uint256(12361355);
2054             colorInts[1] = uint256(10243124);
2055             colorInts[2] = uint256(13747897);
2056             colorInts[3] = uint256(9925744);
2057             colorInts[4] = uint256(8026744);
2058             colorInts[5] = uint256(12945517);
2059             colorIntCount = uint256(6);
2060         } else if (Art.compareStrings(palette, Art.WIN_PAL_MATRIX)) {
2061             shuffle = false;
2062             colorInts[0] = uint256(4609);
2063             colorInts[1] = uint256(803087);
2064             colorInts[2] = uint256(2062109);
2065             colorInts[3] = uint256(11009906);
2066             colorIntCount = uint256(4);
2067         } else if (Art.compareStrings(palette, Art.ARC_PAL_PLASTIC)) {
2068             colorInts[0] = uint256(16772570);
2069             colorInts[1] = uint256(4043519);
2070             colorInts[2] = uint256(16758832);
2071             colorInts[3] = uint256(16720962);
2072             colorIntCount = uint256(4);
2073         } else if (Art.compareStrings(palette, Art.ARC_PAL_COSMIC)) {
2074             ordered = true;
2075             colorInts[0] = uint256(1182264);
2076             colorInts[1] = uint256(10834562);
2077             colorInts[2] = uint256(4269159);
2078             colorInts[3] = uint256(16769495);
2079             colorInts[4] = uint256(3351916);
2080             colorInts[5] = uint256(12612224);
2081             colorIntCount = uint256(6);
2082         } else if (Art.compareStrings(palette, Art.ARC_PAL_BUBBLE)) {
2083             colorInts[0] = uint256(11065577);
2084             colorInts[1] = uint256(11244760);
2085             colorInts[2] = uint256(16628178);
2086             colorInts[3] = uint256(16777172);
2087             colorIntCount = uint256(4);
2088         } else if (Art.compareStrings(palette, Art.ARC_PAL_ESPER)) {
2089             shuffle = false;
2090             colorInts[0] = uint256(15651304);
2091             colorInts[1] = uint256(5867181);
2092             colorInts[2] = uint256(12929115);
2093             colorInts[3] = uint256(11896986);
2094             colorIntCount = uint256(4);
2095         } else if (Art.compareStrings(palette, Art.ARC_PAL_SPIRIT)) {
2096             colorInts[0] = uint256(590090);
2097             colorInts[1] = uint256(4918854);
2098             colorInts[2] = uint256(8196724);
2099             colorInts[3] = uint256(16555462);
2100             colorIntCount = uint256(4);
2101         } else if (Art.compareStrings(palette, Art.ARC_PAL_COLORLESS)) {
2102             colorInts[0] = uint256(1644825);
2103             colorInts[1] = uint256(15132390);
2104             colorIntCount = uint256(2);
2105         } else if (Art.compareStrings(palette, Art.ARC_PAL_ENTROPY)) {
2106             restricted = false;
2107             colorIntCount = uint256(0);
2108         } else if (Art.compareStrings(palette, Art.ARC_PAL_YINYANG)) {
2109             restricted = false;
2110             colorInts[0] = uint256(0);
2111             colorInts[1] = uint256(16777215);
2112             colorIntCount = uint256(2);
2113         } else if (Art.compareStrings(palette, Art.SHA_PAL_MOONRISE)) {
2114             colorInts[0] = uint256(1180799);
2115             colorInts[1] = uint256(16753004);
2116             colorInts[2] = uint256(5767292);
2117             colorInts[3] = uint256(1179979);
2118             colorIntCount = uint256(4);
2119         } else if (Art.compareStrings(palette, Art.SHA_PAL_UMBRAL)) {
2120             colorInts[0] = uint256(4479070);
2121             colorInts[1] = uint256(16377469);
2122             colorInts[2] = uint256(1845042);
2123             colorInts[3] = uint256(11285763);
2124             colorInts[4] = uint256(16711577);
2125             colorIntCount = uint256(5);
2126         } else if (Art.compareStrings(palette, Art.SHA_PAL_DARKNESS)) {
2127             colorInts[0] = uint256(2885188);
2128             colorInts[1] = uint256(1572943);
2129             colorInts[2] = uint256(1179979);
2130             colorInts[3] = uint256(657930);
2131             colorIntCount = uint256(4);
2132         } else if (Art.compareStrings(palette, Art.SHA_PAL_SHARKSKIN)) {
2133             colorInts[0] = uint256(2304306);
2134             colorInts[1] = uint256(3817287);
2135             colorInts[2] = uint256(44469);
2136             colorInts[3] = uint256(15658734);
2137             colorIntCount = uint256(4);
2138         } else if (Art.compareStrings(palette, Art.SHA_PAL_VOID)) {
2139             colorInts[0] = uint256(1572943);
2140             colorInts[1] = uint256(4194415);
2141             colorInts[2] = uint256(6488209);
2142             colorInts[3] = uint256(13051525);
2143             colorInts[4] = uint256(657930);
2144             colorIntCount = uint256(5);
2145         } else if (Art.compareStrings(palette, Art.SHA_PAL_IMMORTAL)) {
2146             colorInts[0] = uint256(1642512);
2147             colorInts[1] = uint256(7084837);
2148             colorInts[2] = uint256(8720180);
2149             colorInts[3] = uint256(16121899);
2150             colorInts[4] = uint256(138580);
2151             colorIntCount = uint256(5);
2152         } else if (Art.compareStrings(palette, Art.SHA_PAL_UNDEAD)) {
2153             shuffle = false;
2154             colorInts[0] = uint256(3546937);
2155             colorInts[1] = uint256(50595);
2156             colorInts[2] = uint256(7511983);
2157             colorInts[3] = uint256(7563923);
2158             colorInts[4] = uint256(10535352);
2159             colorIntCount = uint256(5);
2160         } else if (Art.compareStrings(palette, Art.SHA_PAL_YIN)) {
2161             restricted = false;
2162             colorInts[0] = uint256(0);
2163             colorIntCount = uint256(1);
2164         } else if (Art.compareStrings(palette, Art.FIR_PAL_VOLCANO)) {
2165             colorInts[0] = uint256(3152931);
2166             colorInts[1] = uint256(15027482);
2167             colorInts[2] = uint256(14690821);
2168             colorInts[3] = uint256(16167309);
2169             colorInts[4] = uint256(6320499);
2170             colorInts[5] = uint256(1512470);
2171             colorIntCount = uint256(6);
2172         } else if (Art.compareStrings(palette, Art.FIR_PAL_HEAT)) {
2173             shuffle = false;
2174             colorInts[0] = uint256(590337);
2175             colorInts[1] = uint256(12141574);
2176             colorInts[2] = uint256(15908162);
2177             colorInts[3] = uint256(6886400);
2178             colorIntCount = uint256(4);
2179         } else if (Art.compareStrings(palette, Art.FIR_PAL_FLARE)) {
2180             shuffle = false;
2181             colorInts[0] = uint256(16353609);
2182             colorInts[1] = uint256(11580);
2183             colorInts[2] = uint256(16513713);
2184             colorInts[3] = uint256(12474923);
2185             colorIntCount = uint256(4);
2186         } else if (Art.compareStrings(palette, Art.FIR_PAL_SOLAR)) {
2187             shuffle = false;
2188             colorInts[0] = uint256(984066);
2189             colorInts[1] = uint256(6300419);
2190             colorInts[2] = uint256(16368685);
2191             colorInts[3] = uint256(16570745);
2192             colorIntCount = uint256(4);
2193         } else if (Art.compareStrings(palette, Art.FIR_PAL_SUMMER)) {
2194             colorInts[0] = uint256(16428419);
2195             colorInts[1] = uint256(16738152);
2196             colorInts[2] = uint256(16727143);
2197             colorInts[3] = uint256(11022726);
2198             colorIntCount = uint256(4);
2199         } else if (Art.compareStrings(palette, Art.FIR_PAL_EMBER)) {
2200             shuffle = false;
2201             colorInts[0] = uint256(1180162);
2202             colorInts[1] = uint256(7929858);
2203             colorInts[2] = uint256(7012357);
2204             colorInts[3] = uint256(16744737);
2205             colorIntCount = uint256(4);
2206         } else if (Art.compareStrings(palette, Art.FIR_PAL_COMET)) {
2207             shuffle = false;
2208             colorInts[0] = uint256(197130);
2209             colorInts[1] = uint256(803727);
2210             colorInts[2] = uint256(4441816);
2211             colorInts[3] = uint256(602997);
2212             colorIntCount = uint256(4);
2213         } else {
2214             shuffle = false;
2215             colorInts[0] = uint256(197391);
2216             colorInts[1] = uint256(3604610);
2217             colorInts[2] = uint256(6553778);
2218             colorInts[3] = uint256(14305728);
2219             colorIntCount = uint256(4);
2220         }
2221 
2222         return (colorInts, colorIntCount, ordered, shuffle, restricted);
2223     }
2224 
2225 }
2226 
2227 library Art {
2228 
2229     string public constant ROLL_ELEMENT = 'ELEMENT';
2230     string public constant ROLL_PALETTE = 'PALETTE';
2231     string public constant ROLL_ORDERED = 'ORDERED';
2232     string public constant ROLL_SHUFFLE = 'SHUFFLE';
2233     string public constant ROLL_RED = 'RED';
2234     string public constant ROLL_GREEN = 'GREEN';
2235     string public constant ROLL_BLUE = 'BLUE';
2236     string public constant ROLL_DIRRED = 'DIRRED';
2237     string public constant ROLL_DIRGREEN = 'DIRGREEN';
2238     string public constant ROLL_DIRBLUE = 'DIRBLUE';
2239     string public constant ROLL_RANDOMCOLOR = 'RANDOMCOLOR';
2240     string public constant ROLL_STYLE = 'STYLE';
2241     string public constant ROLL_COLORCOUNT = 'COLORCOUNT';
2242     string public constant ROLL_GRAVITY = 'GRAVITY';
2243     string public constant ROLL_GRAIN = 'GRAIN';
2244     string public constant ROLL_DISPLAY = 'DISPLAY';
2245 
2246     string public constant ELEM_NATURE = 'nature';
2247     string public constant ELEM_LIGHT = 'light';
2248     string public constant ELEM_WATER = 'water';
2249     string public constant ELEM_EARTH = 'earth';
2250     string public constant ELEM_WIND = 'wind';
2251     string public constant ELEM_ARCANE = 'arcane';
2252     string public constant ELEM_SHADOW = 'shadow';
2253     string public constant ELEM_FIRE = 'fire';
2254 
2255     string public constant NAT_PAL_JUNGLE = 'jungle';
2256     string public constant NAT_PAL_SPRING = 'spring';
2257     string public constant NAT_PAL_CAMOUFLAGE = 'camouflage';
2258     string public constant NAT_PAL_BLOSSOM = 'blossom';
2259     string public constant NAT_PAL_LEAF = 'leaf';
2260     string public constant NAT_PAL_LEMONADE = 'lemonade';
2261     string public constant NAT_PAL_BIOLUMINESCENCE = 'bioluminescence';
2262     string public constant NAT_PAL_RAINFOREST = 'rainforest';
2263 
2264     string public constant LIG_PAL_PASTEL = 'pastel';
2265     string public constant LIG_PAL_HOLY = 'holy';
2266     string public constant LIG_PAL_SYLVAN = 'sylvan';
2267     string public constant LIG_PAL_GLOW = 'glow';
2268     string public constant LIG_PAL_SUNSET = 'sunset';
2269     string public constant LIG_PAL_INFRARED = 'infrared';
2270     string public constant LIG_PAL_ULTRAVIOLET = 'ultraviolet';
2271     string public constant LIG_PAL_YANG = 'yang';
2272 
2273     string public constant WAT_PAL_ARCHIPELAGO = 'archipelago';
2274     string public constant WAT_PAL_FROZEN = 'frozen';
2275     string public constant WAT_PAL_VAPOR = 'vapor';
2276     string public constant WAT_PAL_DAWN = 'dawn';
2277     string public constant WAT_PAL_GLACIER = 'glacier';
2278     string public constant WAT_PAL_SHANTY = 'shanty';
2279     string public constant WAT_PAL_VICE = 'vice';
2280     string public constant WAT_PAL_OPALESCENT = 'opalescent';
2281 
2282     string public constant EAR_PAL_ARID = 'arid';
2283     string public constant EAR_PAL_RIDGE = 'ridge';
2284     string public constant EAR_PAL_COAL = 'coal';
2285     string public constant EAR_PAL_TOUCH = 'touch';
2286     string public constant EAR_PAL_BRONZE = 'bronze';
2287     string public constant EAR_PAL_SILVER = 'silver';
2288     string public constant EAR_PAL_GOLD = 'gold';
2289     string public constant EAR_PAL_PLATINUM = 'platinum';
2290 
2291     string public constant WIN_PAL_BERRY = 'berry';
2292     string public constant WIN_PAL_BREEZE = 'breeze';
2293     string public constant WIN_PAL_JOLT = 'jolt';
2294     string public constant WIN_PAL_THUNDER = 'thunder';
2295     string public constant WIN_PAL_WINTER = 'winter';
2296     string public constant WIN_PAL_HEATHERMOOR = 'heathermoor';
2297     string public constant WIN_PAL_ZEUS = 'zeus';
2298     string public constant WIN_PAL_MATRIX = 'matrix';
2299 
2300     string public constant ARC_PAL_PLASTIC = 'plastic';
2301     string public constant ARC_PAL_COSMIC = 'cosmic';
2302     string public constant ARC_PAL_BUBBLE = 'bubble';
2303     string public constant ARC_PAL_ESPER = 'esper';
2304     string public constant ARC_PAL_SPIRIT = 'spirit';
2305     string public constant ARC_PAL_COLORLESS = 'colorless';
2306     string public constant ARC_PAL_ENTROPY = 'entropy';
2307     string public constant ARC_PAL_YINYANG = 'yinyang';
2308 
2309     string public constant SHA_PAL_MOONRISE = 'moonrise';
2310     string public constant SHA_PAL_UMBRAL = 'umbral';
2311     string public constant SHA_PAL_DARKNESS = 'darkness';
2312     string public constant SHA_PAL_SHARKSKIN = 'sharkskin';
2313     string public constant SHA_PAL_VOID = 'void';
2314     string public constant SHA_PAL_IMMORTAL = 'immortal';
2315     string public constant SHA_PAL_UNDEAD = 'undead';
2316     string public constant SHA_PAL_YIN = 'yin';
2317 
2318     string public constant FIR_PAL_VOLCANO = 'volcano';
2319     string public constant FIR_PAL_HEAT = 'heat';
2320     string public constant FIR_PAL_FLARE = 'flare';
2321     string public constant FIR_PAL_SOLAR = 'solar';
2322     string public constant FIR_PAL_SUMMER = 'summer';
2323     string public constant FIR_PAL_EMBER = 'ember';
2324     string public constant FIR_PAL_COMET = 'comet';
2325     string public constant FIR_PAL_CORRUPTED = 'corrupted';
2326 
2327     string public constant STYLE_SMOOTH = 'smooth';
2328     string public constant STYLE_PAJAMAS = 'pajamas';
2329     string public constant STYLE_SILK = 'silk';
2330     string public constant STYLE_RETRO = 'retro';
2331     string public constant STYLE_SKETCH = 'sketch';
2332 
2333     string public constant GRAV_LUNAR = 'lunar';
2334     string public constant GRAV_ATMOSPHERIC = 'atmospheric';
2335     string public constant GRAV_LOW = 'low';
2336     string public constant GRAV_NORMAL = 'normal';
2337     string public constant GRAV_HIGH = 'high';
2338     string public constant GRAV_MASSIVE = 'massive';
2339     string public constant GRAV_STELLAR = 'stellar';
2340     string public constant GRAV_GALACTIC = 'galactic';
2341 
2342     string public constant GRAIN_NULL = 'null';
2343     string public constant GRAIN_FADED = 'faded';
2344     string public constant GRAIN_NONE = 'none';
2345     string public constant GRAIN_SOFT = 'soft';
2346     string public constant GRAIN_MEDIUM = 'medium';
2347     string public constant GRAIN_ROUGH = 'rough';
2348     string public constant GRAIN_RED = 'red';
2349     string public constant GRAIN_GREEN = 'green';
2350     string public constant GRAIN_BLUE = 'blue';
2351 
2352     string public constant DISPLAY_NORMAL = 'normal';
2353     string public constant DISPLAY_MIRRORED = 'mirrored';
2354     string public constant DISPLAY_UPSIDEDOWN = 'upsideDown';
2355     string public constant DISPLAY_MIRROREDUPSIDEDOWN = 'mirroredUpsideDown';
2356 
2357     string public constant SCRIPT = 'UDS=window.UDS!==void 0&&window.UDS,FVCS=window.FVCS===void 0?0:window.FVCS;var b,d,dcE,baC,R,C=P.length,MRCS=9600,DCS=.8,MCS=.0625,PAD=8,L={r:.9,d:.1},BC2=[{x:.5,y:.5},{x:.75,y:0}],BC3=[{x:.65,y:.15},{x:.5,y:.5},{x:.75,y:.75}],BC4=[{x:.5,y:0},{x:0,y:.5},{x:.5,y:1},{x:1,y:.5}],BC5=[{x:.5,y:.5},{x:.5,y:0},{x:0,y:.5},{x:.5,y:1},{x:1,y:.5}],BC6=[{x:.5,y:.5},{x:.5,y:0},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:0,y:0}],BC=[,,BC2,BC3,BC4,BC5,BC6],a="absolute",p="1px solid",c="canvas",q="2d",e="resize",o="px",wRE=window.removeEventListener,mn=Math.min,mx=Math.max,pw=Math.pow,f=Math.floor,pC=BC[C],sM=SD,sSZ=1/3;"pajamas"==Y&&(sM=SS,sSZ=1/99),"silk"==Y&&(sM=SS,sSZ=1/3),"retro"==Y&&(sM=SS,sSZ=3/2),"sketch"==Y&&(sM=SRS);var fX=!("mirrored"!=D&&"mirroredUpsideDown"!=D),fY=!("upsideDown"!=D&&"mirroredUpsideDown"!=D),gv=3;"lunar"==G&&(gv=.5),"atmospheric"==G&&(gv=1),"low"==G&&(gv=2),"high"==G&&(gv=6),"massive"==G&&(gv=9),"stellar"==G&&(gv=12),"galactic"==G&&(gv=24);var gr={r:{o:0,r:0},g:{o:0,r:0},b:{o:0,r:0}};"null"==A&&(gr={r:{o:0,r:-512},g:{o:0,r:-512},b:{o:0,r:-512}}),"faded"==A&&(gr={r:{o:0,r:-128},g:{o:0,r:-128},b:{o:0,r:-128}}),"soft"==A&&(gr={r:{o:-4,r:8},g:{o:-4,r:8},b:{o:-4,r:8}}),"medium"==A&&(gr={r:{o:-8,r:16},g:{o:-8,r:16},b:{o:-8,r:16}}),"rough"==A&&(gr={r:{o:-16,r:32},g:{o:-16,r:32},b:{o:-16,r:32}}),"red"==A&&(gr={r:{o:-16,r:32},g:{o:0,r:0},b:{o:0,r:0}}),"green"==A&&(gr={r:{o:0,r:0},g:{o:-16,r:32},b:{o:0,r:0}}),"blue"==A&&(gr={r:{o:0,r:0},g:{o:0,r:0},b:{o:-16,r:32}});var dC,vC,pCv,pCx,lC,lX,lW,rB,pL,pI,dsL,dsC,wW=0,wH=0,vCS=600,dCS=DCS,dCZ=vCS/dCS,cPts=[],sVl=-1,pIdx=0,lPc=0,rPc=0,dPc=0;function SD(c,a){return c.d-a.d}function SS(){var a=sVl;return sVl+=sSZ,2<=sVl&&(sVl-=3),a}function SRS(){var a=sVl;return sVl+=1/(R()*dCZ),2<=sVl&&(sVl-=3),a}function uLP(){lPc=L.r*rPc+L.d*dPc,lW||(lW=lC.width,lX.fillStyle="#2f2");var a=lPc*lW;lX.fillRect(0,0,a,PAD)}function rnCS(){for(var a=cPts.length,b=2*PAD,c=(lW-(2*a*b-b))/2,d=0;d<a;d++){var e=cPts[d],f=c+2*d*b;pCx.fillStyle="#000",pCx.fillRect(f-1,0,b+2,b+2),pCx.fillStyle="rgb("+e.r+","+e.g+","+e.b+")",pCx.fillRect(f,1,b,b)}}window.onload=function(){ii()};function ii(){sRO(),sS(),cE(),sRn()}function sS(){var a=Uint32Array.from([0,1,s=t=2,3].map(function(a){return parseInt(H.substr(8*a+2,8),16)}));R=function(){return t=a[3],a[3]=a[2],a[2]=a[1],a[1]=s=a[0],t^=t<<11,a[0]^=t^t>>>8^s>>>19,a[0]/4294967296},"tx piter"}function sRO(){d=document,b=d.body,dcE=d.createElement.bind(d),baC=b.appendChild.bind(b),wW=mx(b.clientWidth,window.innerWidth),wH=mx(b.clientHeight,window.innerHeight);var a=wW>wH,c=a?wH:wW;vCS=0<FVCS?mn(MRCS,FVCS):mn(MRCS,c),dCS=UDS?MCS:DCS,dCZ=f(vCS/dCS),dCZ>MRCS&&(dCZ=MRCS),dCS=vCS/dCZ,lPc=0,rPc=0,dPc=0,lW=0,sVl=-1,pIdx=0,cPts.length=0}function sCl(){for(var a=P.slice(),b=0;b<C;b++){var c=gCP(),d=a[b],e=parseInt(d,16);c.r=255&e>>16,c.g=255&e>>8,c.b=255&e,c.weight=pw(gv,5-b),pPt(c),cPts.push(c)}if(2===C)for(var f=cPts[0],g=cPts[1];;){var h=g.y-f.y,j=g.x-f.x,k=h/(j||1);if(-1.2<=k&&-.8>=k)pIdx=0,pPt(f),pPt(g);else break}rnCS()}function cE(){dC=dcE(c),vC=dcE(c),vC.style.position=a,vC.style.border=p,baC(vC),pCv=dcE(c),pCv.style.position=a,baC(pCv),pCx=pCv.getContext(q),lC=dcE(c),lC.style.position=a,lC.style.border=p,baC(lC),lX=lC.getContext(q),rB=dcE("button"),rB.style.position=a,rB.innerHTML="Render",rB.addEventListener("click",oRC),baC(rB),pL=dcE("label"),pL.style.position=a,pL.innerHTML="Size in Pixels (16 - 9600):",baC(pL),pI=dcE("input"),pI.style.position=a,pI.min=16,pI.max=MRCS,pI.value=vCS,pI.type="number",baC(pI),dsL=dcE("label"),dsL.style.position=a,dsL.innerHTML="Downsample (Best Result):",baC(dsL),dsC=dcE("input"),dsC.style.position=a,dsC.type="checkbox",dsC.checked=!0,baC(dsC)}function sRn(){rzVC(),rV(),uLP(),dC.width=dCZ,dC.height=dCZ,rd(dC,function(){.4>=dCS?pIm(dC,function(a){dTVC(a),sRH(a)}):(dTVC(dC),sRH(dC),dPc=1,uLP())})}var rCB;function sRH(a){window.RNCB!==void 0&&window.RNCB(vC),wRE(e,rCB,!0),rCB=function(){sRO(),rzVC(),dTVC(a)},window.addEventListener(e,rCB,!0)}function rV(){var a=f(vCS/12.5),b=f(a/12),c=vCS/60,d=vC.getContext(q);vC.style.letterSpacing=b+o,d.fillStyle="#161616",d.fillRect(0,0,vCS,vCS),d.fillStyle="#E9E9E9",d.font=a+"px sans-serif",d.textBaseline="middle",d.textAlign="center",d.fillText("vibing...",c+vCS/2,vCS/2,vCS)}function rd(a,b){var c=a.getContext(q),d=c.getImageData(0,0,a.width,a.height);dCPG(d,function(){c.putImageData(d,0,0),b()},!1)}function rzVC(){var a=f((wW-vCS)/2),b=f((wH-vCS)/2),c=a+PAD,d=b+vCS+PAD,e=c,g=d+2*PAD;vC.style.left=a+o,vC.style.top=b+o,vC.width=vCS,vC.height=vCS,pCv.style.left=c+o,pCv.style.top=b-3*PAD-2+o,pCv.width=vCS-2*PAD,pCv.height=2*PAD+2,lC.style.left=c+o,lC.style.top=d+o,lC.width=vCS-2*PAD,lC.height=PAD,pL.style.left=e+o,pL.style.top=g+o,pI.style.left=e+180+o,pI.style.top=g+o,dsL.style.left=e+o,dsL.style.top=g+3*PAD+o,dsC.style.left=e+180+o,dsC.style.top=g+3*PAD+o,rB.style.left=e+o,rB.style.top=g+6*PAD+o}function dTVC(a){var b=vC.getContext(q);fX&&(b.translate(vCS,0),b.scale(-1,1)),fY&&(b.translate(0,vCS),b.scale(1,-1)),b.drawImage(a,0,0,vCS,vCS),aG(b)}function aG(a){for(var b=a.getImageData(0,0,vCS,vCS),c=b.data,d=c.length,e=0;e<d;e+=4)c[e+0]+=gr.r.o+R()*gr.r.r,c[e+1]+=gr.g.o+R()*gr.g.r,c[e+2]+=gr.b.o+R()*gr.b.r;a.putImageData(b,0,0)}function pIm(a,b){var c=new Image;c.addEventListener("load",function(){dPc=.6,uLP(),b(rdI(c,vCS,vCS))}),c.src=a.toDataURL()}var _x=0,_y=0;function dCPG(a,b,c){var d=Date.now();for(c||(_x=0,_y=0,sCl());_x<dCZ;){for(_y=0;_y<dCZ;)sQG(a,cPts,_x,_y,dCZ,dCZ),_y++;_x++;var e=Date.now()-d;if(500<=e){rPc=_x/dCZ,uLP();break}}_x===dCZ?(rPc=1,uLP(),b()):setTimeout(function(){dCPG(a,b,!0)},0)}function gCP(){return{x:0,y:0,r:0,g:0,b:0,weight:1,d:0}}function pPt(a){var b=pC[pIdx++];pIdx>=pC.length&&(pIdx=0);var c=-.125+.25*R(),d=-.125+.25*R();a.x=(b.x+c)*dCZ,a.y=(b.y+d)*dCZ}function sQG(a,b,c,d,e,f){srtCC(b,c,d);for(var g=[],h=b.length,j=0;j<h;j+=2)j==h-1?g.push(b[j]):g.push(smsh(b[j],b[j+1]));if(1===g.length){var k=4*(d*e)+4*c,l=g[0],m=a.data;m[k+0]=l.r,m[k+1]=l.g,m[k+2]=l.b,m[k+3]=255}else sQG(a,g,c,d,e,f)}function srtCC(a,b,c){for(var d,e=0;e<a.length;e++)d=a[e],d.d=gD3(b,c,d.x,d.y);a.sort(sM)}function gD3(a,b,c,d){return pw(c-a,3)+pw(d-b,3)}function smsh(a,b){var c=gCP(),d=a.r,e=a.g,f=a.b,g=b.r,h=b.g,i=b.b,j=a.weight,k=b.weight,l=a.d*j,m=b.d*k,n=m/(l+m);return c.x=(a.x+b.x)/2,c.y=(a.y+b.y)/2,c.r=n*(g-d)+d,c.g=n*(h-e)+e,c.b=n*(i-f)+f,c.weight=(j+k)/2,c}function rdI(a,d,e){var f,h,i,j,k,l,m,n,o=0,p=a.naturalWidth,u=a.naturalHeight,v=dcE(c);v.width=p,v.height=u;var w=v.getContext(q),z=dcE(c);z.width=d,z.height=e;var B=z.getContext(q);w.drawImage(a,0,0);for(var C=w.getImageData(0,0,p,u).data,E=B.getImageData(0,0,d,e),F=p/d,I=u/e,J=C,K=E.data;o<e;){for(i=o*I,f=0;f<d;){h=f*F;var L=i+I,M=h+F;for(l=m=n=a=0,k=0|i;k<L;){var N=k+1,O=N>L?L-k:k<i?1-(i-k):1;for(j=0|h;j<M;){var Q=j+1,R=Q>M?M-j:j<h?1-(h-j):1,S=O*R/(F*I),T=4*(k*p+j);l+=J[T]/255*S,m+=J[T+1]/255*S,n+=J[T+2]/255*S,j+=1}k+=1}var T=4*(o*d+f);K[T]=255*l,K[T+1]=255*m,K[T+2]=255*n,K[T+3]=255,f+=1}o+=1,dPc=.6+.4*o/e,uLP()}return B.putImageData(E,0,0),z}function oRC(){var a=mx(16,mn(MRCS,+pI.value||vCS)),b=dsC.checked;FVCS=a,UDS=b,wRE(e,rCB,!0),sRO(),sS(),sRn()}';
2358 
2359     function getElementByRoll(uint256 roll) public pure returns (string memory) {
2360         string memory element;
2361         if (roll <= uint256(125)) {
2362             element = ELEM_NATURE;
2363         } else if (roll <= uint256(250)) {
2364             element = ELEM_LIGHT;
2365         } else if (roll <= uint256(375)) {
2366             element = ELEM_WATER;
2367         } else if (roll <= uint256(500)) {
2368             element = ELEM_EARTH;
2369         } else if (roll <= uint256(625)) {
2370             element = ELEM_WIND;
2371         } else if (roll <= uint256(750)) {
2372             element = ELEM_ARCANE;
2373         } else if (roll <= uint256(875)) {
2374             element = ELEM_SHADOW;
2375         } else {
2376             element = ELEM_FIRE;
2377         }
2378         return element;
2379     }
2380 
2381     function getPaletteByRoll(uint256 roll, string memory element) public pure returns (string memory) {
2382         string memory palette;
2383         if (compareStrings(element, ELEM_NATURE)) {
2384             palette = getNaturePaletteByRoll(roll);
2385         } else if (compareStrings(element, ELEM_LIGHT)) {
2386             palette = getLightPaletteByRoll(roll);
2387         } else if (compareStrings(element, ELEM_WATER)) {
2388             palette = getWaterPaletteByRoll(roll);
2389         } else if (compareStrings(element, ELEM_EARTH)) {
2390             palette = getEarthPaletteByRoll(roll);
2391         } else if (compareStrings(element, ELEM_WIND)) {
2392             palette = getWindPaletteByRoll(roll);
2393         } else if (compareStrings(element, ELEM_ARCANE)) {
2394             palette = getArcanePaletteByRoll(roll);
2395         } else if (compareStrings(element, ELEM_SHADOW)) {
2396             palette = getShadowPaletteByRoll(roll);
2397         } else {
2398             palette = getFirePaletteByRoll(roll);
2399         }
2400         return palette;
2401     }
2402 
2403     function getNaturePaletteByRoll(uint256 roll) public pure returns (string memory) {
2404         string memory palette;
2405         if (roll <= uint256(200)) {
2406             palette = NAT_PAL_JUNGLE;
2407         } else if (roll <= uint256(380)) {
2408             palette = NAT_PAL_SPRING;
2409         } else if (roll <= uint256(540)) {
2410             palette = NAT_PAL_CAMOUFLAGE;
2411         } else if (roll <= uint256(680)) {
2412             palette = NAT_PAL_BLOSSOM;
2413         } else if (roll <= uint256(800)) {
2414             palette = NAT_PAL_LEAF;
2415         } else if (roll <= uint256(880)) {
2416             palette = NAT_PAL_LEMONADE;
2417         } else if (roll <= uint256(960)) {
2418             palette = NAT_PAL_BIOLUMINESCENCE;
2419         } else {
2420             palette = NAT_PAL_RAINFOREST;
2421         }
2422         return palette;
2423     }
2424 
2425     function getLightPaletteByRoll(uint256 roll) public pure returns (string memory) {
2426         string memory palette;
2427         if (roll <= uint256(200)) {
2428             palette = LIG_PAL_PASTEL;
2429         } else if (roll <= uint256(380)) {
2430             palette = LIG_PAL_HOLY;
2431         } else if (roll <= uint256(540)) {
2432             palette = LIG_PAL_SYLVAN;
2433         } else if (roll <= uint256(680)) {
2434             palette = LIG_PAL_GLOW;
2435         } else if (roll <= uint256(800)) {
2436             palette = LIG_PAL_SUNSET;
2437         } else if (roll <= uint256(880)) {
2438             palette = LIG_PAL_INFRARED;
2439         } else if (roll <= uint256(960)) {
2440             palette = LIG_PAL_ULTRAVIOLET;
2441         } else {
2442             palette = LIG_PAL_YANG;
2443         }
2444         return palette;
2445     }
2446 
2447     function getWaterPaletteByRoll(uint256 roll) public pure returns (string memory) {
2448         string memory palette;
2449         if (roll <= uint256(200)) {
2450             palette = WAT_PAL_ARCHIPELAGO;
2451         } else if (roll <= uint256(380)) {
2452             palette = WAT_PAL_FROZEN;
2453         } else if (roll <= uint256(540)) {
2454             palette = WAT_PAL_VAPOR;
2455         } else if (roll <= uint256(680)) {
2456             palette = WAT_PAL_DAWN;
2457         } else if (roll <= uint256(790)) {
2458             palette = WAT_PAL_GLACIER;
2459         } else if (roll <= uint256(880)) {
2460             palette = WAT_PAL_SHANTY;
2461         } else if (roll <= uint256(950)) {
2462             palette = WAT_PAL_VICE;
2463         } else {
2464             palette = WAT_PAL_OPALESCENT;
2465         }
2466         return palette;
2467     }
2468 
2469     function getEarthPaletteByRoll(uint256 roll) public pure returns (string memory) {
2470         string memory palette;
2471         if (roll <= uint256(200)) {
2472             palette = EAR_PAL_ARID;
2473         } else if (roll <= uint256(380)) {
2474             palette = EAR_PAL_RIDGE;
2475         } else if (roll <= uint256(540)) {
2476             palette = EAR_PAL_COAL;
2477         } else if (roll <= uint256(680)) {
2478             palette = EAR_PAL_TOUCH;
2479         } else if (roll <= uint256(790)) {
2480             palette = EAR_PAL_BRONZE;
2481         } else if (roll <= uint256(880)) {
2482             palette = EAR_PAL_SILVER;
2483         } else if (roll <= uint256(950)) {
2484             palette = EAR_PAL_GOLD;
2485         } else {
2486             palette = EAR_PAL_PLATINUM;
2487         }
2488         return palette;
2489     }
2490 
2491     function getWindPaletteByRoll(uint256 roll) public pure returns (string memory) {
2492         string memory palette;
2493         if (roll <= uint256(200)) {
2494             palette = WIN_PAL_BERRY;
2495         } else if (roll <= uint256(380)) {
2496             palette = WIN_PAL_BREEZE;
2497         } else if (roll <= uint256(540)) {
2498             palette = WIN_PAL_JOLT;
2499         } else if (roll <= uint256(680)) {
2500             palette = WIN_PAL_THUNDER;
2501         } else if (roll <= uint256(800)) {
2502             palette = WIN_PAL_WINTER;
2503         } else if (roll <= uint256(880)) {
2504             palette = WIN_PAL_HEATHERMOOR;
2505         } else if (roll <= uint256(960)) {
2506             palette = WIN_PAL_ZEUS;
2507         } else {
2508             palette = WIN_PAL_MATRIX;
2509         }
2510         return palette;
2511     }
2512 
2513     function getArcanePaletteByRoll(uint256 roll) public pure returns (string memory) {
2514         string memory palette;
2515         if (roll <= uint256(200)) {
2516             palette = ARC_PAL_PLASTIC;
2517         } else if (roll <= uint256(380)) {
2518             palette = ARC_PAL_COSMIC;
2519         } else if (roll <= uint256(540)) {
2520             palette = ARC_PAL_BUBBLE;
2521         } else if (roll <= uint256(680)) {
2522             palette = ARC_PAL_ESPER;
2523         } else if (roll <= uint256(800)) {
2524             palette = ARC_PAL_SPIRIT;
2525         } else if (roll <= uint256(880)) {
2526             palette = ARC_PAL_COLORLESS;
2527         } else if (roll <= uint256(960)) {
2528             palette = ARC_PAL_ENTROPY;
2529         } else {
2530             palette = ARC_PAL_YINYANG;
2531         }
2532         return palette;
2533     }
2534 
2535     function getShadowPaletteByRoll(uint256 roll) public pure returns (string memory) {
2536         string memory palette;
2537         if (roll <= uint256(200)) {
2538             palette = SHA_PAL_MOONRISE;
2539         } else if (roll <= uint256(380)) {
2540             palette = SHA_PAL_UMBRAL;
2541         } else if (roll <= uint256(540)) {
2542             palette = SHA_PAL_DARKNESS;
2543         } else if (roll <= uint256(680)) {
2544             palette = SHA_PAL_SHARKSKIN;
2545         } else if (roll <= uint256(800)) {
2546             palette = SHA_PAL_VOID;
2547         } else if (roll <= uint256(880)) {
2548             palette = SHA_PAL_IMMORTAL;
2549         } else if (roll <= uint256(960)) {
2550             palette = SHA_PAL_UNDEAD;
2551         } else {
2552             palette = SHA_PAL_YIN;
2553         }
2554         return palette;
2555     }
2556 
2557     function getFirePaletteByRoll(uint256 roll) public pure returns (string memory) {
2558         string memory palette;
2559         if (roll <= uint256(200)) {
2560             palette = FIR_PAL_VOLCANO;
2561         } else if (roll <= uint256(380)) {
2562             palette = FIR_PAL_HEAT;
2563         } else if (roll <= uint256(540)) {
2564             palette = FIR_PAL_FLARE;
2565         } else if (roll <= uint256(680)) {
2566             palette = FIR_PAL_SOLAR;
2567         } else if (roll <= uint256(790)) {
2568             palette = FIR_PAL_SUMMER;
2569         } else if (roll <= uint256(880)) {
2570             palette = FIR_PAL_EMBER;
2571         } else if (roll <= uint256(950)) {
2572             palette = FIR_PAL_COMET;
2573         } else {
2574             palette = FIR_PAL_CORRUPTED;
2575         }
2576         return palette;
2577     }
2578 
2579     function getColorCount(uint256 roll, string memory style) public pure returns (uint256) {
2580         uint256 colorCount = 2;
2581         uint256[] memory options = new uint256[](5);
2582 
2583         if (compareStrings(style, STYLE_SMOOTH)) {
2584             options[0] = 2;
2585             options[1] = 3;
2586             options[2] = 4;
2587             options[3] = 5;
2588             options[4] = 6;
2589         } else if (compareStrings(style, STYLE_PAJAMAS) || compareStrings(style, STYLE_SILK)) {
2590             options[0] = 5;
2591             options[1] = 6;
2592         } else if (compareStrings(style, STYLE_RETRO)) {
2593             options[0] = 4;
2594             options[1] = 6;
2595         } else {
2596             options[0] = 3;
2597             options[1] = 4;
2598         }
2599 
2600         if (!compareStrings(style, STYLE_SMOOTH)) {
2601             if (roll <= uint256(800)) {
2602                 colorCount = options[0];
2603             } else {
2604                 colorCount = options[1];
2605             }
2606         } else {
2607             if (roll <= uint256(400)) {
2608                 colorCount = options[0];
2609             } else if (roll <= uint256(700)) {
2610                 colorCount = options[1];
2611             } else if (roll <= uint256(880)) {
2612                 colorCount = options[2];
2613             } else if (roll <= uint256(960)) {
2614                 colorCount = options[3];
2615             } else {
2616                 colorCount = options[4];
2617             }
2618         }
2619 
2620         return colorCount;
2621     }
2622 
2623     function getStyleByRoll(uint256 roll) public pure returns (string memory) {
2624         string memory style;
2625         if (roll <= uint256(800)) {
2626             style = STYLE_SMOOTH;
2627         } else if (roll <= uint256(880)) {
2628             style = STYLE_PAJAMAS;
2629         } else if (roll <= uint256(940)) {
2630             style = STYLE_SILK;
2631         } else if (roll <= uint256(980)) {
2632             style = STYLE_RETRO;
2633         } else {
2634             style = STYLE_SKETCH;
2635         }
2636         return style;
2637     }
2638 
2639     function getGravityByRoll(uint256 roll) public pure returns (string memory) {
2640         string memory gravity;
2641         if (roll <= uint256(50)) {
2642             gravity = GRAV_LUNAR;
2643         } else if (roll <= uint256(150)) {
2644             gravity = GRAV_ATMOSPHERIC;
2645         } else if (roll <= uint256(340)) {
2646             gravity = GRAV_LOW;
2647         } else if (roll <= uint256(730)) {
2648             gravity = GRAV_NORMAL;
2649         } else if (roll <= uint256(920)) {
2650             gravity = GRAV_HIGH;
2651         } else if (roll <= uint256(970)) {
2652             gravity = GRAV_MASSIVE;
2653         } else if (roll <= uint256(995)) {
2654             gravity = GRAV_STELLAR;
2655         } else {
2656             gravity = GRAV_GALACTIC;
2657         }
2658         return gravity;
2659     }
2660 
2661     function getGravityLimitedByRoll(uint256 roll) public pure returns (string memory) {
2662         string memory gravity;
2663         if (roll <= uint256(250)) {
2664             gravity = GRAV_LOW;
2665         } else if (roll <= uint256(750)) {
2666             gravity = GRAV_NORMAL;
2667         } else {
2668             gravity = GRAV_HIGH;
2669         }
2670         return gravity;
2671     }
2672 
2673     function getGrainByRoll(uint256 roll) public pure returns (string memory) {
2674         string memory grain;
2675         if (roll <= uint256(1)) {
2676             grain = GRAIN_NULL;
2677         } else if (roll <= uint256(5)) {
2678             grain = GRAIN_FADED;
2679         } else if (roll <= uint256(260)) {
2680             grain = GRAIN_NONE;
2681         } else if (roll <= uint256(580)) {
2682             grain = GRAIN_SOFT;
2683         } else if (roll <= uint256(760)) {
2684             grain = GRAIN_MEDIUM;
2685         } else if (roll <= uint256(820)) {
2686             grain = GRAIN_ROUGH;
2687         } else if (roll <= uint256(880)) {
2688             grain = GRAIN_RED;
2689         } else if (roll <= uint256(940)) {
2690             grain = GRAIN_GREEN;
2691         } else {
2692             grain = GRAIN_BLUE;
2693         }
2694         return grain;
2695     }
2696 
2697     function getDisplayByRoll(uint256 roll) public pure returns (string memory) {
2698         string memory display;
2699         if (roll <= uint256(250)) {
2700             display = DISPLAY_NORMAL;
2701         } else if (roll <= uint256(500)) {
2702             display = DISPLAY_MIRRORED;
2703         } else if (roll <= uint256(750)) {
2704             display = DISPLAY_UPSIDEDOWN;
2705         } else {
2706             display = DISPLAY_MIRROREDUPSIDEDOWN;
2707         }
2708         return display;
2709     }
2710 
2711     function getColorCode(uint256 color) public pure returns (string memory) {
2712         bytes16 hexChars = "0123456789abcdef";
2713         uint256 r1 = (color >> uint256(20)) & uint256(15);
2714         uint256 r2 = (color >> uint256(16)) & uint256(15);
2715         uint256 g1 = (color >> uint256(12)) & uint256(15);
2716         uint256 g2 = (color >> uint256(8)) & uint256(15);
2717         uint256 b1 = (color >> uint256(4)) & uint256(15);
2718         uint256 b2 = color & uint256(15);
2719         bytes memory code = new bytes(6);
2720         code[0] = hexChars[r1];
2721         code[1] = hexChars[r2];
2722         code[2] = hexChars[g1];
2723         code[3] = hexChars[g2];
2724         code[4] = hexChars[b1];
2725         code[5] = hexChars[b2];
2726         return string(code);
2727     }
2728 
2729     function compareStrings(string memory a, string memory b) internal pure returns (bool) {
2730         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
2731     }
2732 
2733     function getScript() public pure returns (string memory) {
2734         return SCRIPT;
2735     }
2736 
2737 }