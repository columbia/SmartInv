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
1352 /**
1353  * OpenVibes is a set of 2,222 free to mint generative art pieces.
1354  * Combined with the original Vibes drop, the max supply is 9,999.
1355  * This is my gift to the NFT Community. You are legendary. Thank you!
1356  * 
1357  *   - remnynt
1358  *
1359  *   https://vibes.art
1360  */
1361 
1362 contract OpenVibes is ERC721Enumerable, ERC2981ContractWideRoyalties, ReentrancyGuard, Ownable {
1363     ArtLib lib_Art;
1364     ColorDataLib lib_ColorData;
1365 
1366     using Strings for uint256;
1367 
1368     bool public mintingActive = false;
1369     bool public useAnimation = false;
1370     bool public useOnChainAnimation = false;
1371     string private baseVibeURI;
1372 
1373     // the max number of vibes in the original drop, 0.07 ETH each
1374     uint256 private constant MAX_VIBE_SUPPLY = 7777;
1375 
1376     // the max number of vibes in this drop, free mint
1377     uint256 private constant MAX_OPEN_VIBE_SUPPLY = 2222;
1378 
1379     // the blockhash being visualized by each token
1380     mapping(uint256 => bytes32) private entropyHashes;
1381 
1382     // one mint per wallet
1383     mapping(address => bool) private hasWalletMinted;
1384 
1385     struct ColorInfo {
1386         uint256[] colorInts;
1387         uint256[] colorIntsChosen;
1388         uint256 colorIntCount;
1389         bool ordered;
1390         bool shuffle;
1391         bool restricted;
1392         string palette;
1393         uint256 colorCount;
1394     }
1395 
1396     struct TokenInfo {
1397         string entropyHash;
1398         string element;
1399         string palette;
1400         uint256 colorCount;
1401         string style;
1402         string gravity;
1403         string grain;
1404         string display;
1405         string[14] html;
1406     }
1407 
1408     struct WobbleInfo {
1409         uint256 r;
1410         uint256 g;
1411         uint256 b;
1412         uint256 offsetR;
1413         uint256 offsetG;
1414         uint256 offsetB;
1415         uint256 offsetDirR;
1416         uint256 offsetDirG;
1417         uint256 offsetDirB;
1418     }
1419 
1420     constructor() ERC721("OpenVibes", "OVIBES") Ownable() {
1421         // set voluntary royalties, according to ERC2981, @ 12.5%, 1250 basis points
1422         _setRoyalties(owner(), 1250);
1423     }
1424 
1425     function setLibArt(address lib) public onlyOwner {
1426       lib_Art = ArtLib(lib);
1427     }
1428 
1429     function setLibColorData(address lib) public onlyOwner {
1430       lib_ColorData = ColorDataLib(lib);
1431     }
1432 
1433     function getElement(uint256 tokenId) private view returns (string memory) {
1434         return lib_Art.getElementByRoll(roll1000(tokenId, lib_Art.ROLL_ELEMENT()));
1435     }
1436 
1437     function getPalette(uint256 tokenId) private view returns (string memory) {
1438         return lib_Art.getPaletteByRoll(roll1000(tokenId, lib_Art.ROLL_PALETTE()), getElement(tokenId));
1439     }
1440 
1441     function getColorByIndex(uint256 tokenId, uint256 lookupIndex) public view returns (string memory) {
1442         ColorInfo memory info;
1443         info.colorCount = getColorCount(tokenId);
1444 
1445         if (lookupIndex >= info.colorCount
1446             || tokenId <= MAX_VIBE_SUPPLY
1447             || tokenId > MAX_VIBE_SUPPLY + super.totalSupply())
1448         {
1449             return 'null';
1450         }
1451 
1452         (info.colorInts, info.colorIntCount, info.ordered, info.shuffle, info.restricted) = lib_ColorData.getPaletteColors(getPalette(tokenId));
1453 
1454         uint256 i;
1455         uint256 temp;
1456         uint256 startIndex;
1457         uint256 currIndex;
1458         uint256 codeCount;
1459 
1460         info.colorIntsChosen = new uint256[](12);
1461 
1462         if (info.ordered) {
1463             temp = roll1000(tokenId, lib_Art.ROLL_ORDERED());
1464             startIndex = temp % info.colorIntCount;
1465             for (i = 0; i < info.colorIntCount; i++) {
1466                 currIndex = startIndex + i;
1467                 if (currIndex >= info.colorIntCount) {
1468                     currIndex -= info.colorIntCount;
1469                 }
1470                 info.colorIntsChosen[i] = info.colorInts[currIndex];
1471             }
1472         } else if (info.shuffle) {
1473             codeCount = info.colorIntCount;
1474 
1475             while (codeCount > 0) {
1476                 i = roll1000(tokenId, string(abi.encodePacked(lib_Art.ROLL_SHUFFLE, toString(codeCount)))) % codeCount;
1477                 codeCount -= 1;
1478 
1479                 temp = info.colorInts[codeCount];
1480                 info.colorInts[codeCount] = info.colorInts[i];
1481                 info.colorInts[i] = temp;
1482             }
1483 
1484             for (i = 0; i < info.colorIntCount; i++) {
1485                 info.colorIntsChosen[i] = info.colorInts[i];
1486             }
1487         } else {
1488             for (i = 0; i < info.colorIntCount; i++) {
1489                 info.colorIntsChosen[i] = info.colorInts[i];
1490             }
1491         }
1492 
1493         if (info.restricted) {
1494             temp = getWobbledColor(info.colorIntsChosen[lookupIndex % info.colorIntCount], tokenId, lookupIndex);
1495         } else if (lookupIndex >= info.colorIntCount) {
1496             temp = getRandomColor(tokenId, lookupIndex);
1497         } else {
1498             temp = getWobbledColor(info.colorIntsChosen[lookupIndex], tokenId, lookupIndex);
1499         }
1500 
1501         return lib_Art.getColorCode(temp);
1502     }
1503 
1504     function getWobbledColor(uint256 color, uint256 tokenId, uint256 index) private view returns (uint256) {
1505         WobbleInfo memory info;
1506         info.r = (color >> uint256(16)) & uint256(255);
1507         info.g = (color >> uint256(8)) & uint256(255);
1508         info.b = color & uint256(255);
1509         info.offsetR = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_RED, toString(index)))) % uint256(8);
1510         info.offsetG = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_GREEN, toString(index)))) % uint256(8);
1511         info.offsetB = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_BLUE, toString(index)))) % uint256(8);
1512         info.offsetDirR = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_DIRRED, toString(index)))) % uint256(2);
1513         info.offsetDirG = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_DIRGREEN, toString(index)))) % uint256(2);
1514         info.offsetDirB = rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_DIRBLUE, toString(index)))) % uint256(2);
1515 
1516         if (info.offsetDirR == uint256(0)) {
1517             if (info.r > info.offsetR) {
1518                 info.r -= info.offsetR;
1519             } else {
1520                 info.r = uint256(0);
1521             }
1522         } else {
1523             if (info.r + info.offsetR <= uint256(255)) {
1524                 info.r += info.offsetR;
1525             } else {
1526                 info.r = uint256(255);
1527             }
1528         }
1529 
1530         if (info.offsetDirG == uint256(0)) {
1531             if (info.g > info.offsetG) {
1532                 info.g -= info.offsetG;
1533             } else {
1534                 info.g = uint256(0);
1535             }
1536         } else {
1537             if (info.g + info.offsetG <= uint256(255)) {
1538                 info.g += info.offsetG;
1539             } else {
1540                 info.g = uint256(255);
1541             }
1542         }
1543 
1544         if (info.offsetDirB == uint256(0)) {
1545             if (info.b > info.offsetB) {
1546                 info.b -= info.offsetB;
1547             } else {
1548                 info.b = uint256(0);
1549             }
1550         } else {
1551             if (info.b + info.offsetB <= uint256(255)) {
1552                 info.b += info.offsetB;
1553             } else {
1554                 info.b = uint256(255);
1555             }
1556         }
1557 
1558         return uint256((info.r << uint256(16)) | (info.g << uint256(8)) | info.b);
1559     }
1560 
1561     function getRandomColor(uint256 tokenId, uint256 index) private view returns (uint256) {
1562         return rollMax(tokenId, string(abi.encodePacked(lib_Art.ROLL_RANDOMCOLOR, toString(index)))) % uint256(16777216);
1563     }
1564 
1565     function getStyle(uint256 tokenId) private view returns (string memory) {
1566         return lib_Art.getStyleByRoll(roll1000(tokenId, lib_Art.ROLL_STYLE()));
1567     }
1568 
1569     function getColorCount(uint256 tokenId) private view returns (uint256) {
1570         return lib_Art.getColorCount(roll1000(tokenId, lib_Art.ROLL_COLORCOUNT()), getStyle(tokenId));
1571     }
1572 
1573     function getGravity(uint256 tokenId) private view returns (string memory) {
1574         string memory gravity;
1575         string memory style = getStyle(tokenId);
1576         uint256 colorCount = getColorCount(tokenId);
1577         uint256 roll = roll1000(tokenId, lib_Art.ROLL_GRAVITY());
1578 
1579         if (colorCount >= uint256(5) && compareStrings(style, lib_Art.STYLE_SMOOTH())) {
1580             gravity = lib_Art.getGravityLimitedByRoll(roll);
1581         } else {
1582             gravity = lib_Art.getGravityByRoll(roll);
1583         }
1584 
1585         return gravity;
1586     }
1587 
1588     function getGrain(uint256 tokenId) private view returns (string memory) {
1589         return lib_Art.getGrainByRoll(roll1000(tokenId, lib_Art.ROLL_GRAIN()));
1590     }
1591 
1592     function getDisplay(uint256 tokenId) private view returns (string memory) {
1593         return lib_Art.getDisplayByRoll(roll1000(tokenId, lib_Art.ROLL_DISPLAY()));
1594     }
1595 
1596     function getRandomBlockhash(uint256 tokenId) private view returns (bytes32) {
1597         uint256 decrement = (tokenId % 255) % (block.number - 1);
1598         uint256 blockIndex = block.number - (decrement + 1);
1599         return blockhash(blockIndex);
1600     }
1601 
1602     function getEntropyHash(uint256 tokenId) private view returns (string memory) {
1603         return uint256(entropyHashes[tokenId]).toHexString();
1604     }
1605 
1606     function rollMax(uint256 tokenId, string memory key) private view returns (uint256) {
1607         string memory hashEntropy = getEntropyHash(tokenId);
1608         string memory tokenEntropy = string(abi.encodePacked(key, toString(tokenId)));
1609         return random(hashEntropy) ^ random(tokenEntropy);
1610     }
1611 
1612     function roll1000(uint256 tokenId, string memory key) private view returns (uint256) {
1613         return uint256(1) + rollMax(tokenId, key) % uint256(1000);
1614     }
1615 
1616     function random(string memory input) private pure returns (uint256) {
1617         return uint256(keccak256(abi.encodePacked(input)));
1618     }
1619 
1620     function compareStrings(string memory a, string memory b) internal pure returns (bool) {
1621         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
1622     }
1623 
1624     function tokenScript(uint256 tokenId) public view returns (string memory) {
1625         require(tokenId > MAX_VIBE_SUPPLY, 'invalid tokenId');
1626         require(tokenId <= MAX_VIBE_SUPPLY + super.totalSupply(), 'invalid tokenId');
1627 
1628         TokenInfo memory info;
1629         info.entropyHash = getEntropyHash(tokenId);
1630         info.colorCount = getColorCount(tokenId);
1631         info.style = getStyle(tokenId);
1632         info.gravity = getGravity(tokenId);
1633         info.grain = getGrain(tokenId);
1634         info.display = getDisplay(tokenId);
1635 
1636         info.html[0] = '<!doctype html><html><head><script>';
1637         info.html[1] = string(abi.encodePacked('H="', info.entropyHash, '";'));
1638         info.html[2] = string(abi.encodePacked('Y="', info.style, '";'));
1639         info.html[3] = string(abi.encodePacked('G="', info.gravity, '";'));
1640         info.html[4] = string(abi.encodePacked('A="', info.grain, '";'));
1641         info.html[5] = string(abi.encodePacked('D="', info.display, '";'));
1642 
1643         string memory colorString;
1644         string memory partString;
1645         uint256 i;
1646         for (i = 0; i < 6; i++) {
1647             if (i < info.colorCount) {
1648                 colorString = getColorByIndex(tokenId, i);
1649             } else {
1650                 colorString = '';
1651             }
1652 
1653             if (i == 0) {
1654                 partString = string(abi.encodePacked('P=["', colorString, '",'));
1655             } else if (i < info.colorCount - 1) {
1656                 partString = string(abi.encodePacked('"', colorString, '",'));
1657             } else if (i < info.colorCount) {
1658                 partString = string(abi.encodePacked('"', colorString, '"];'));
1659             } else {
1660                 partString = '';
1661             }
1662 
1663             info.html[6 + i] = partString;
1664         }
1665 
1666         info.html[12] = lib_Art.getScript();
1667         info.html[13] = '</script></head><body></body></html>';
1668 
1669         string memory output = string(abi.encodePacked(info.html[0], info.html[1], info.html[2], info.html[3], info.html[4], info.html[5], info.html[6]));
1670         return string(abi.encodePacked(output, info.html[7], info.html[8], info.html[9], info.html[10], info.html[11], info.html[12], info.html[13]));
1671     }
1672 
1673     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1674         require(tokenId > MAX_VIBE_SUPPLY, 'invalid tokenId');
1675         require(tokenId <= MAX_VIBE_SUPPLY + super.totalSupply(), 'invalid tokenId');
1676 
1677         TokenInfo memory info;
1678         info.element = getElement(tokenId);
1679         info.palette = getPalette(tokenId);
1680         info.colorCount = getColorCount(tokenId);
1681         info.style = getStyle(tokenId);
1682         info.gravity = getGravity(tokenId);
1683         info.grain = getGrain(tokenId);
1684         info.display = getDisplay(tokenId);
1685 
1686         string memory imagePath = string(abi.encodePacked(baseVibeURI, toString(tokenId), '.jpg'));
1687         string memory json = string(abi.encodePacked('{"name": "vibe #', toString(tokenId), '", "description": "vibes is a generative art collection, randomly created and stored on chain. each token is an interactive html page that allows you to render your vibe at any size. vibes make their color palette available on chain, so feel free to carry your colors with you on your adventures.", "image": "', imagePath));
1688 
1689         if (useOnChainAnimation) {
1690             string memory script = tokenScript(tokenId);
1691             json = string(abi.encodePacked(json, '", "animation_url": "data:text/html;base64,', Base64.encode(bytes(script))));
1692         } else if (useAnimation) {
1693             json = string(abi.encodePacked(json, '", "animation_url": "', string(abi.encodePacked(baseVibeURI, toString(tokenId), '.html'))));
1694         }
1695 
1696         json = string(abi.encodePacked(json, '", "attributes": [{ "trait_type": "element", "value": "', info.element, '" }, { "trait_type": "palette", "value": "', info.palette, '" }, { "trait_type": "colors", "value": "', toString(info.colorCount), '" }, { "trait_type": "style", "value": "', info.style));
1697         json = string(abi.encodePacked(json, '" }, { "trait_type": "gravity", "value": "', info.gravity, '" }, { "trait_type": "grain", "value": "', info.grain, '" }, { "trait_type": "display", "value": "', info.display, '" }]}'));
1698 
1699         return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(json))));
1700     }
1701 
1702     function mintVibes() public nonReentrant {
1703         uint256 lastTokenId = MAX_VIBE_SUPPLY + super.totalSupply();
1704         uint256 nextTokenId = lastTokenId + 1;
1705         address minter = _msgSender();
1706 
1707         require(mintingActive, 'gm fren. minting open vibes soon.');
1708         require(!hasWalletMinted[minter], 'whoa fren. max 1 open vibe per wallet.');
1709         require(nextTokenId <= MAX_VIBE_SUPPLY + MAX_OPEN_VIBE_SUPPLY, 'gn fren. only so many open vibes.');
1710 
1711         hasWalletMinted[minter] = true;
1712         entropyHashes[nextTokenId] = getRandomBlockhash(nextTokenId);
1713 
1714         _safeMint(minter, nextTokenId);
1715     }
1716 
1717     function vibeCheck() public onlyOwner {
1718         mintingActive = !mintingActive;
1719     }
1720 
1721     function toggleAnimation() public onlyOwner {
1722         useAnimation = !useAnimation;
1723     }
1724 
1725     function toggleOnChainAnimation() public onlyOwner {
1726         useOnChainAnimation = !useOnChainAnimation;
1727     }
1728 
1729     function setVibeURI(string memory uri) public onlyOwner {
1730         baseVibeURI = uri;
1731     }
1732 
1733     function withdraw() public onlyOwner {
1734         uint256 balance = address(this).balance;
1735         payable(owner()).transfer(balance);
1736     }
1737 
1738     function supportsInterface(bytes4 interfaceId)
1739         public
1740         view
1741         virtual
1742         override(ERC721Enumerable, ERC2981ContractWideRoyalties)
1743         returns (bool)
1744     {
1745         return super.supportsInterface(interfaceId);
1746     }
1747 
1748     function toString(uint256 value) internal pure returns (string memory) {
1749     // Inspired by OraclizeAPI's implementation - MIT license
1750     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1751 
1752         if (value == 0) {
1753             return "0";
1754         }
1755         uint256 temp = value;
1756         uint256 digits;
1757         while (temp != 0) {
1758             digits++;
1759             temp /= 10;
1760         }
1761         bytes memory buffer = new bytes(digits);
1762         while (value != 0) {
1763             digits -= 1;
1764             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1765             value /= 10;
1766         }
1767         return string(buffer);
1768     }
1769 
1770 }
1771 
1772 abstract contract ColorDataLib {
1773     function getPaletteColors(string memory palette) virtual public pure returns (uint256[] memory, uint256, bool, bool, bool);
1774 }
1775 
1776 abstract contract ArtLib {
1777     string public ROLL_ELEMENT;
1778     string public ROLL_PALETTE;
1779     string public ROLL_ORDERED;
1780     string public ROLL_SHUFFLE;
1781     string public ROLL_RED;
1782     string public ROLL_GREEN;
1783     string public ROLL_BLUE;
1784     string public ROLL_DIRRED;
1785     string public ROLL_DIRGREEN;
1786     string public ROLL_DIRBLUE;
1787     string public ROLL_RANDOMCOLOR;
1788     string public ROLL_STYLE;
1789     string public ROLL_COLORCOUNT;
1790     string public ROLL_GRAVITY;
1791     string public ROLL_GRAIN;
1792     string public ROLL_DISPLAY;
1793     string public ELEM_NATURE;
1794     string public ELEM_LIGHT;
1795     string public ELEM_WATER;
1796     string public ELEM_EARTH;
1797     string public ELEM_WIND;
1798     string public ELEM_ARCANE;
1799     string public ELEM_SHADOW;
1800     string public ELEM_FIRE;
1801     string public NAT_PAL_JUNGLE;
1802     string public NAT_PAL_SPRING;
1803     string public NAT_PAL_CAMOUFLAGE;
1804     string public NAT_PAL_BLOSSOM;
1805     string public NAT_PAL_LEAF;
1806     string public NAT_PAL_LEMONADE;
1807     string public NAT_PAL_BIOLUMINESCENCE;
1808     string public NAT_PAL_RAINFOREST;
1809     string public LIG_PAL_PASTEL;
1810     string public LIG_PAL_HOLY;
1811     string public LIG_PAL_SYLVAN;
1812     string public LIG_PAL_GLOW;
1813     string public LIG_PAL_SUNSET;
1814     string public LIG_PAL_INFRARED;
1815     string public LIG_PAL_ULTRAVIOLET;
1816     string public LIG_PAL_YANG;
1817     string public WAT_PAL_ARCHIPELAGO;
1818     string public WAT_PAL_FROZEN;
1819     string public WAT_PAL_VAPOR;
1820     string public WAT_PAL_DAWN;
1821     string public WAT_PAL_GLACIER;
1822     string public WAT_PAL_SHANTY;
1823     string public WAT_PAL_VICE;
1824     string public WAT_PAL_OPALESCENT;
1825     string public EAR_PAL_ARID;
1826     string public EAR_PAL_RIDGE;
1827     string public EAR_PAL_COAL;
1828     string public EAR_PAL_TOUCH;
1829     string public EAR_PAL_BRONZE;
1830     string public EAR_PAL_SILVER;
1831     string public EAR_PAL_GOLD;
1832     string public EAR_PAL_PLATINUM;
1833     string public WIN_PAL_BERRY;
1834     string public WIN_PAL_BREEZE;
1835     string public WIN_PAL_JOLT;
1836     string public WIN_PAL_THUNDER;
1837     string public WIN_PAL_WINTER;
1838     string public WIN_PAL_HEATHERMOOR;
1839     string public WIN_PAL_ZEUS;
1840     string public WIN_PAL_MATRIX;
1841     string public ARC_PAL_PLASTIC;
1842     string public ARC_PAL_COSMIC;
1843     string public ARC_PAL_BUBBLE;
1844     string public ARC_PAL_ESPER;
1845     string public ARC_PAL_SPIRIT;
1846     string public ARC_PAL_COLORLESS;
1847     string public ARC_PAL_ENTROPY;
1848     string public ARC_PAL_YINYANG;
1849     string public SHA_PAL_MOONRISE;
1850     string public SHA_PAL_UMBRAL;
1851     string public SHA_PAL_DARKNESS;
1852     string public SHA_PAL_SHARKSKIN;
1853     string public SHA_PAL_VOID;
1854     string public SHA_PAL_IMMORTAL;
1855     string public SHA_PAL_UNDEAD;
1856     string public SHA_PAL_YIN;
1857     string public FIR_PAL_VOLCANO;
1858     string public FIR_PAL_HEAT;
1859     string public FIR_PAL_FLARE;
1860     string public FIR_PAL_SOLAR;
1861     string public FIR_PAL_SUMMER;
1862     string public FIR_PAL_EMBER;
1863     string public FIR_PAL_COMET;
1864     string public FIR_PAL_CORRUPTED;
1865     string public STYLE_SMOOTH;
1866     string public STYLE_PAJAMAS;
1867     string public STYLE_SILK;
1868     string public STYLE_RETRO;
1869     string public STYLE_SKETCH;
1870     string public GRAV_LUNAR;
1871     string public GRAV_ATMOSPHERIC;
1872     string public GRAV_LOW;
1873     string public GRAV_NORMAL;
1874     string public GRAV_HIGH;
1875     string public GRAV_MASSIVE;
1876     string public GRAV_STELLAR;
1877     string public GRAV_GALACTIC;
1878     string public GRAIN_NULL;
1879     string public GRAIN_FADED;
1880     string public GRAIN_NONE;
1881     string public GRAIN_SOFT;
1882     string public GRAIN_MEDIUM;
1883     string public GRAIN_ROUGH;
1884     string public GRAIN_RED;
1885     string public GRAIN_GREEN;
1886     string public GRAIN_BLUE;
1887     string public DISPLAY_NORMAL;
1888     string public DISPLAY_MIRRORED;
1889     string public DISPLAY_UPSIDEDOWN;
1890     string public DISPLAY_MIRROREDUPSIDEDOWN;
1891 
1892     function getElementByRoll(uint256 roll) virtual public pure returns (string memory);
1893     function getPaletteByRoll(uint256 roll, string memory element) virtual public pure returns (string memory);
1894     function getNaturePaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1895     function getLightPaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1896     function getWaterPaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1897     function getEarthPaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1898     function getWindPaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1899     function getArcanePaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1900     function getShadowPaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1901     function getFirePaletteByRoll(uint256 roll) virtual public pure returns (string memory);
1902     function getColorCount(uint256 roll, string memory style) virtual public pure returns (uint256);
1903     function getStyleByRoll(uint256 roll) virtual public pure returns (string memory);
1904     function getGravityByRoll(uint256 roll) virtual public pure returns (string memory);
1905     function getGravityLimitedByRoll(uint256 roll) virtual public pure returns (string memory);
1906     function getGrainByRoll(uint256 roll) virtual public pure returns (string memory);
1907     function getDisplayByRoll(uint256 roll) virtual public pure returns (string memory);
1908     function getColorCode(uint256 color) virtual public pure returns (string memory);
1909     function compareStrings(string memory a, string memory b) virtual internal pure returns (bool);
1910     function getScript() virtual public pure returns (string memory);
1911 }