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
733 /**
734  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
735  * the Metadata extension, but not including the Enumerable extension, which is available separately as
736  * {ERC721Enumerable}.
737  */
738 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
739     using Address for address;
740     using Strings for uint256;
741 
742     // Token name
743     string private _name;
744 
745     // Token symbol
746     string private _symbol;
747 
748     // Mapping from token ID to owner address
749     mapping(uint256 => address) private _owners;
750 
751     // Mapping owner address to token count
752     mapping(address => uint256) private _balances;
753 
754     // Mapping from token ID to approved address
755     mapping(uint256 => address) private _tokenApprovals;
756 
757     // Mapping from owner to operator approvals
758     mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760     /**
761      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
762      */
763     constructor(string memory name_, string memory symbol_) {
764         _name = name_;
765         _symbol = symbol_;
766     }
767 
768     /**
769      * @dev See {IERC165-supportsInterface}.
770      */
771     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
772         return
773             interfaceId == type(IERC721).interfaceId ||
774             interfaceId == type(IERC721Metadata).interfaceId ||
775             super.supportsInterface(interfaceId);
776     }
777 
778     /**
779      * @dev See {IERC721-balanceOf}.
780      */
781     function balanceOf(address owner) public view virtual override returns (uint256) {
782         require(owner != address(0), "ERC721: balance query for the zero address");
783         return _balances[owner];
784     }
785 
786     /**
787      * @dev See {IERC721-ownerOf}.
788      */
789     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
790         address owner = _owners[tokenId];
791         require(owner != address(0), "ERC721: owner query for nonexistent token");
792         return owner;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-name}.
797      */
798     function name() public view virtual override returns (string memory) {
799         return _name;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-symbol}.
804      */
805     function symbol() public view virtual override returns (string memory) {
806         return _symbol;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-tokenURI}.
811      */
812     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
813         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
814 
815         string memory baseURI = _baseURI();
816         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
817     }
818 
819     /**
820      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
821      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
822      * by default, can be overriden in child contracts.
823      */
824     function _baseURI() internal view virtual returns (string memory) {
825         return "";
826     }
827 
828     /**
829      * @dev See {IERC721-approve}.
830      */
831     function approve(address to, uint256 tokenId) public virtual override {
832         address owner = ERC721.ownerOf(tokenId);
833         require(to != owner, "ERC721: approval to current owner");
834 
835         require(
836             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
837             "ERC721: approve caller is not owner nor approved for all"
838         );
839 
840         _approve(to, tokenId);
841     }
842 
843     /**
844      * @dev See {IERC721-getApproved}.
845      */
846     function getApproved(uint256 tokenId) public view virtual override returns (address) {
847         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
848 
849         return _tokenApprovals[tokenId];
850     }
851 
852     /**
853      * @dev See {IERC721-setApprovalForAll}.
854      */
855     function setApprovalForAll(address operator, bool approved) public virtual override {
856         require(operator != _msgSender(), "ERC721: approve to caller");
857 
858         _operatorApprovals[_msgSender()][operator] = approved;
859         emit ApprovalForAll(_msgSender(), operator, approved);
860     }
861 
862     /**
863      * @dev See {IERC721-isApprovedForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev See {IERC721-transferFrom}.
871      */
872     function transferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         //solhint-disable-next-line max-line-length
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879 
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, "");
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public virtual override {
903         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
904         _safeTransfer(from, to, tokenId, _data);
905     }
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
909      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
910      *
911      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
912      *
913      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
914      * implement alternative mechanisms to perform token transfer, such as signature-based.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeTransfer(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) internal virtual {
931         _transfer(from, to, tokenId);
932         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
933     }
934 
935     /**
936      * @dev Returns whether `tokenId` exists.
937      *
938      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
939      *
940      * Tokens start existing when they are minted (`_mint`),
941      * and stop existing when they are burned (`_burn`).
942      */
943     function _exists(uint256 tokenId) internal view virtual returns (bool) {
944         return _owners[tokenId] != address(0);
945     }
946 
947     /**
948      * @dev Returns whether `spender` is allowed to manage `tokenId`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
955         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
956         address owner = ERC721.ownerOf(tokenId);
957         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
958     }
959 
960     /**
961      * @dev Safely mints `tokenId` and transfers it to `to`.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must not exist.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeMint(address to, uint256 tokenId) internal virtual {
971         _safeMint(to, tokenId, "");
972     }
973 
974     /**
975      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
976      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
977      */
978     function _safeMint(
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) internal virtual {
983         _mint(to, tokenId);
984         require(
985             _checkOnERC721Received(address(0), to, tokenId, _data),
986             "ERC721: transfer to non ERC721Receiver implementer"
987         );
988     }
989 
990     /**
991      * @dev Mints `tokenId` and transfers it to `to`.
992      *
993      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
994      *
995      * Requirements:
996      *
997      * - `tokenId` must not exist.
998      * - `to` cannot be the zero address.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _mint(address to, uint256 tokenId) internal virtual {
1003         require(to != address(0), "ERC721: mint to the zero address");
1004         require(!_exists(tokenId), "ERC721: token already minted");
1005 
1006         _beforeTokenTransfer(address(0), to, tokenId);
1007 
1008         _balances[to] += 1;
1009         _owners[tokenId] = to;
1010 
1011         emit Transfer(address(0), to, tokenId);
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
1036     }
1037 
1038     /**
1039      * @dev Transfers `tokenId` from `from` to `to`.
1040      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1041      *
1042      * Requirements:
1043      *
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must be owned by `from`.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {
1054         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1055         require(to != address(0), "ERC721: transfer to the zero address");
1056 
1057         _beforeTokenTransfer(from, to, tokenId);
1058 
1059         // Clear approvals from the previous owner
1060         _approve(address(0), tokenId);
1061 
1062         _balances[from] -= 1;
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Approve `to` to operate on `tokenId`
1071      *
1072      * Emits a {Approval} event.
1073      */
1074     function _approve(address to, uint256 tokenId) internal virtual {
1075         _tokenApprovals[tokenId] = to;
1076         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1081      * The call is not executed if the target address is not a contract.
1082      *
1083      * @param from address representing the previous owner of the given token ID
1084      * @param to target address that will receive the tokens
1085      * @param tokenId uint256 ID of the token to be transferred
1086      * @param _data bytes optional data to send along with the call
1087      * @return bool whether the call correctly returned the expected magic value
1088      */
1089     function _checkOnERC721Received(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) private returns (bool) {
1095         if (to.isContract()) {
1096             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1097                 return retval == IERC721Receiver.onERC721Received.selector;
1098             } catch (bytes memory reason) {
1099                 if (reason.length == 0) {
1100                     revert("ERC721: transfer to non ERC721Receiver implementer");
1101                 } else {
1102                     assembly {
1103                         revert(add(32, reason), mload(reason))
1104                     }
1105                 }
1106             }
1107         } else {
1108             return true;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Hook that is called before any token transfer. This includes minting
1114      * and burning.
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` will be minted for `to`.
1121      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1122      * - `from` and `to` are never both zero.
1123      *
1124      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1125      */
1126     function _beforeTokenTransfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) internal virtual {}
1131 }
1132 
1133 /**
1134  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1135  * enumerability of all the token ids in the contract as well as all token ids owned by each
1136  * account.
1137  */
1138 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1139     // Mapping from owner to list of owned token IDs
1140     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1141 
1142     // Mapping from token ID to index of the owner tokens list
1143     mapping(uint256 => uint256) private _ownedTokensIndex;
1144 
1145     // Array with all token ids, used for enumeration
1146     uint256[] private _allTokens;
1147 
1148     // Mapping from token id to position in the allTokens array
1149     mapping(uint256 => uint256) private _allTokensIndex;
1150 
1151     /**
1152      * @dev See {IERC165-supportsInterface}.
1153      */
1154     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1155         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1160      */
1161     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1162         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1163         return _ownedTokens[owner][index];
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Enumerable-totalSupply}.
1168      */
1169     function totalSupply() public view virtual override returns (uint256) {
1170         return _allTokens.length;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Enumerable-tokenByIndex}.
1175      */
1176     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1177         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1178         return _allTokens[index];
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before any token transfer. This includes minting
1183      * and burning.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1191      * - `from` cannot be the zero address.
1192      * - `to` cannot be the zero address.
1193      *
1194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1195      */
1196     function _beforeTokenTransfer(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) internal virtual override {
1201         super._beforeTokenTransfer(from, to, tokenId);
1202 
1203         if (from == address(0)) {
1204             _addTokenToAllTokensEnumeration(tokenId);
1205         } else if (from != to) {
1206             _removeTokenFromOwnerEnumeration(from, tokenId);
1207         }
1208         if (to == address(0)) {
1209             _removeTokenFromAllTokensEnumeration(tokenId);
1210         } else if (to != from) {
1211             _addTokenToOwnerEnumeration(to, tokenId);
1212         }
1213     }
1214 
1215     /**
1216      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1217      * @param to address representing the new owner of the given token ID
1218      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1219      */
1220     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1221         uint256 length = ERC721.balanceOf(to);
1222         _ownedTokens[to][length] = tokenId;
1223         _ownedTokensIndex[tokenId] = length;
1224     }
1225 
1226     /**
1227      * @dev Private function to add a token to this extension's token tracking data structures.
1228      * @param tokenId uint256 ID of the token to be added to the tokens list
1229      */
1230     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1231         _allTokensIndex[tokenId] = _allTokens.length;
1232         _allTokens.push(tokenId);
1233     }
1234 
1235     /**
1236      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1237      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1238      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1239      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1240      * @param from address representing the previous owner of the given token ID
1241      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1242      */
1243     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1244         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1245         // then delete the last slot (swap and pop).
1246 
1247         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1248         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1249 
1250         // When the token to delete is the last token, the swap operation is unnecessary
1251         if (tokenIndex != lastTokenIndex) {
1252             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1253 
1254             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1255             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1256         }
1257 
1258         // This also deletes the contents at the last position of the array
1259         delete _ownedTokensIndex[tokenId];
1260         delete _ownedTokens[from][lastTokenIndex];
1261     }
1262 
1263     /**
1264      * @dev Private function to remove a token from this extension's token tracking data structures.
1265      * This has O(1) time complexity, but alters the order of the _allTokens array.
1266      * @param tokenId uint256 ID of the token to be removed from the tokens list
1267      */
1268     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1269         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1270         // then delete the last slot (swap and pop).
1271 
1272         uint256 lastTokenIndex = _allTokens.length - 1;
1273         uint256 tokenIndex = _allTokensIndex[tokenId];
1274 
1275         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1276         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1277         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1278         uint256 lastTokenId = _allTokens[lastTokenIndex];
1279 
1280         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1281         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1282 
1283         // This also deletes the contents at the last position of the array
1284         delete _allTokensIndex[tokenId];
1285         _allTokens.pop();
1286     }
1287 }
1288 
1289 
1290 
1291 contract Degens is ERC721Enumerable, ERC2981ContractWideRoyalties, ReentrancyGuard, Ownable {
1292     using Strings for uint256;
1293 
1294     uint256 public constant MINT_COST = 50000000000000000; // 0.05 ETH
1295     uint256 public constant MAX_SUPPLY = 10000;
1296     uint256 public constant MAX_RESERVE = 150;
1297     uint256 public constant MAX_PER_MINT = 20;
1298     uint256 public constant ROYALTY_BASIS_PTS = 1000; // 10%
1299 
1300     address public contractDev = 0x2533798d5f1386bbA9101387Ff3342FFFC220E27;
1301 
1302     string public PROVENANCE;
1303     string private baseDegenURI;
1304     uint256 public tokenOffset = MAX_SUPPLY;
1305     bool public mintingActive = false;
1306     bool public earlyMintingActive = false;
1307 
1308     mapping(address => uint256) whitelist;
1309 
1310     constructor() ERC721("gmdegens", "GMD") Ownable() {
1311         _setRoyalties(owner(), ROYALTY_BASIS_PTS);
1312 
1313         // snapshot of mint pass and founders pass holders
1314         whitelist[0xff88bD69dc4D42B292B4ACADe8E24A20979C0098] = 2;
1315         whitelist[0xfF3aB8989bf275CE128Ca69481bdabbe93055876] = 2;
1316         whitelist[0xfDF0eaDE0C4ba947999e7885b60099985347eE7A] = 2;
1317         whitelist[0xfa2Ff875d5DED2d6702e3d35678aB9fe674bd68B] = 2;
1318         whitelist[0xF8038FD7DF0862faA5708c174b485F519698d628] = 2;
1319         whitelist[0xF641e2800a94b49B8b428353ea71aAE85865decE] = 2;
1320         whitelist[0xf33f4dF9d5693EC35Be246557E52bA250cF437Dd] = 2;
1321         whitelist[0xeba06532a72bec44A1d33130aaa7C45c31e502F6] = 2;
1322         whitelist[0xeA3AC159b6a623D503e48E3c1726072f20c73089] = 2;
1323         whitelist[0xe8f596d68aEfc6aDdF7E0b4a3A1c5f462F6AF1E0] = 2;
1324         whitelist[0xe8514Ba313Fb227Da83103BbcF57ec0eD710a325] = 2;
1325         whitelist[0xE5e2a3E8fc49De0F2Fd7b87d6D88daA5A305ead9] = 2;
1326         whitelist[0xE53008a668836514B6AC7E4039c788De7850d438] = 2;
1327         whitelist[0xE0cD6DbcbAbc6aA967D1Dc318F7526090d47606C] = 2;
1328         whitelist[0xDAc4f4356E9F92ed39427bb96A47E6981C7B3375] = 2;
1329         whitelist[0xD3b129F1F796f5C26210Eb8f39a938175bDbe215] = 2;
1330         whitelist[0xcEfa22191E49d3D501c57c9a831D01a09f7c1112] = 2;
1331         whitelist[0xc9fbb3a7869aF25aefA08914021520cd05aF0E1D] = 2;
1332         whitelist[0xBDB0Dd845E95d2E24B77D9bEf54d4dF82bAF8335] = 2;
1333         whitelist[0xBD9dDf4b73aa454CC6D47E7C504eb73157BCf35D] = 2;
1334         whitelist[0xbC6e70CB9b89851E6Cff7cE198a774549f4c0F0C] = 2;
1335         whitelist[0xb7D7cE36de85E0E080b1F94Fa7cd8A47378B1b4c] = 2;
1336         whitelist[0xB4e69092a6EB310559e50Bb160ae36f7193b6A99] = 2;
1337         whitelist[0xB1b18bDE5DF9b447727c985e3942Ea937fb0C430] = 2;
1338         whitelist[0xA54E54567c001F3D9f1259665d4E93De8A151A5e] = 2;
1339         whitelist[0xa32f008Cb5Ae34a91abe833A64b13E4E58969B76] = 2;
1340         whitelist[0x9D9Fa64Bd35F06c9F0e9598a7dF93c31d72D14Ce] = 2;
1341         whitelist[0x99e0a9e19775b61b50C690E8F713a588eA3F28bF] = 2;
1342         whitelist[0x9996e496a36B42897b44a5b0Df62A376C3390098] = 2;
1343         whitelist[0x98938eDFfA707492A6E76420d2F42458CC1AC15B] = 2;
1344         whitelist[0x95aF39507c413c12E33ACc34f044d12e5F86f551] = 2;
1345         whitelist[0x946eC68B81f439b490b489F645c4D73bC8f9414c] = 2;
1346         whitelist[0x92a7BD65c8b2a9c9d98be8eAa92de46d1fbdefaF] = 2;
1347         whitelist[0x9260ae742F44b7a2e9472f5C299aa0432B3502FA] = 2;
1348         whitelist[0x90ee9AF63F5d1dC23EfEE15f1598e3852165E195] = 2;
1349         whitelist[0x906a2C11B033d0799107Ae1eFEDA2bd422133D7d] = 2;
1350         whitelist[0x8Fb2A5d8736776291388827E9787F221a1d3633a] = 2;
1351         whitelist[0x8cC140E41f064079F921f53A1c36e765DB4B7e59] = 2;
1352         whitelist[0x889C97c24be9bBD5Fab464ba89D47f621Fbe019c] = 2;
1353         whitelist[0x87b895F37A93E76CF1C27ed68B38d77fEE0f7867] = 2;
1354         whitelist[0x8297A5971a05903D4d33453425D1B800730B10e7] = 2;
1355         whitelist[0x7EFB9007074BBe3047c607531e77D6eF840D8FD5] = 2;
1356         whitelist[0x774363d02e2C8FbBEB5b6B37DAA590317d5C4152] = 2;
1357         whitelist[0x7305ce3A245168dDc87c3009F0B4b719BC4519F5] = 2;
1358         whitelist[0x723D5453Fc08769cb454B5B95DB106Bf396C73B3] = 2;
1359         whitelist[0x6D1fd99F6749C175F72441b04277eC50056A6ABE] = 2;
1360         whitelist[0x691b7e59EA6E8569aBC4C2fE6a8bCAe49D802924] = 2;
1361         whitelist[0x64211c2B214Ee2543AaA224EAdd9715818f085Ed] = 2;
1362         whitelist[0x63E0bD39F6EAd960E2C6317D4540DECaf7ab53bA] = 2;
1363         whitelist[0x6325178265892Ab382bf4f2BcF3745D2c4A987e6] = 2;
1364         whitelist[0x5b046272cB9fDe317aB73a836546E52B1F2d81F3] = 3;
1365         whitelist[0x4f368Dfb630Ba2107e51BABD062657DC7cb6381f] = 2;
1366         whitelist[0x4D92A462e97443a72524664fC2300d07c208b4aF] = 2;
1367         whitelist[0x4D4e5506C75642E2cB4C9b07CCcE305E71e30c15] = 2;
1368         whitelist[0x487d0c7553c8d88500085A805d316eD5b18357f8] = 4;
1369         whitelist[0x486843aD8adb101584FCcE56E88a09e6f25D16d1] = 4;
1370         whitelist[0x41A88a01987174d49bBc72b6Ef46b58727aDc4d0] = 2;
1371         whitelist[0x4115E41D52C6769C4f6D00B9aA6046dF92D41870] = 2;
1372         whitelist[0x402112921222090851acbE280bB68b44bfe3eeB2] = 2;
1373         whitelist[0x3a86FD7949F1bD3b2Bfb8dA3f5e86cFEDC79e0Fb] = 2;
1374         whitelist[0x38D0401941d794D245d41870FcdD9f8Ec61C1352] = 2;
1375         whitelist[0x383b8F1B11812E81D78f945ac344CbF9DD329316] = 2;
1376         whitelist[0x332552959a4d437F2Eecdce021E650ED1F343E63] = 2;
1377         whitelist[0x324Edc2211EF542792588de7A50D9A7E56d95C3a] = 2;
1378         whitelist[0x3020d185B7c6dAE2C2248763Cc0EAB2b48BEb743] = 2;
1379         whitelist[0x2CdbF64c0327a731b53bDD6ce715c3aD6BA099C7] = 2;
1380         whitelist[0x2b8b26ceF820911E18db996396e8053cA1A4459C] = 2;
1381         whitelist[0x25eA8dB35eb9F34cC4e3e1e7261096Fe86b006D2] = 2;
1382         whitelist[0x24D10De50DCFcB21d9620bE3042Ee70aDF69d1D4] = 2;
1383         whitelist[0x229a6A5Da12Ca0d134Fc8AeC58F3359E8eE247b6] = 2;
1384         whitelist[0x1b7B45A9dBE2cc3df954bF52D49D5453a357c196] = 2;
1385         whitelist[0x121b37caDb25A2e7D0c8389aae256144fE0f89A8] = 2;
1386         whitelist[0x1200a40C18804F6B5e01f465D5489E53340d61EC] = 2;
1387         whitelist[0x11aE298E74A77ec562A5Ff262eE0586568eb03c5] = 2;
1388         whitelist[0x0dC83606A23cA9dd1a161CC7B95764b7E7424093] = 2;
1389         whitelist[0x0CB7A06ec845EDCA1AF6DB6b6538C4Ca0942019A] = 2;
1390         whitelist[0x05c232CE5BCC9bFDB838B41A7870Aea5E4fA0fA8] = 2;
1391         whitelist[0x038c275A365b7bF84fbc5C86156619943DF1c123] = 2;
1392         whitelist[0x010edAFA8a3C464413A680a1F6a7115B4eE4c74d] = 2;
1393         whitelist[0xF547Ce1247D3F3959794Ca6Ccad99bf56b7CE52c] = 4;
1394         whitelist[0xe6Fda5F67ebA9dE2cfb0fB2a0734969C951653be] = 4;
1395         whitelist[0xe3E55Fae5B27f1Ec658d3808ecc6137E8F466F1f] = 4;
1396         whitelist[0xcB724B38D476cd8e39bA12B1D06c34b8Be0E0B32] = 4;
1397         whitelist[0x29D5cea7D511810f3Ff754886B898FcE16A6D8fD] = 4;
1398         whitelist[0x17E31bf839acB700e0F584797574A2C1FDe46d0b] = 4;
1399         whitelist[0x10b54d8e8E7EA708E5C71915401261F92E03B376] = 4;
1400         whitelist[0xEF3feA2aB12C822dc3437bE195A1BFFc67f2AD08] = 6;
1401         whitelist[0x230FCac06ae171309ea2E0D826cb021A0F786b81] = 6;
1402         whitelist[0xBD9E322303Fa0EE764d8Efb497Ca4b81589A281a] = 10;
1403         whitelist[0x0c2DFdDdeEF2deBBE58fEC8cf93D2daaCDBe1c1e] = 2;
1404         whitelist[0x48c61D3aB04537448a16F52cF508Bc0dd71316b5] = 2;
1405         whitelist[0x3094cf9A360Fb98ca7a9Dc666751DA9C16E45394] = 3;
1406         whitelist[0xEcDC1c32E4b0bFf00afF1d8f809bDD8b33A58969] = 2;
1407         whitelist[0x46c72258ef3266BD874e391E7A55666A532aeCbA] = 2;
1408         whitelist[0x20f3C88d39c03262eFDDAEE16768e7a334Ff2A3d] = 2;
1409         whitelist[0xB31999Ca48Bd9EFC065eB3E2676badD21dfa17b6] = 5;
1410         whitelist[0x3AaA6A59f89de6419E9392e6F94B57c98573Ae05] = 2;
1411         whitelist[0xA76E80209610480aafd8807a20325e7a9030ed55] = 2;
1412         whitelist[0x7b5585D844A5af06e274C7D66Ce12A2a3d2469f0] = 2;
1413         whitelist[0x6562A7e32a35c479B9044A75D96Ae38a9fe12aB7] = 2;
1414         whitelist[0x7309e1582d611D3ef9DBA6FCe709F177240E0fd9] = 2;
1415         whitelist[0x2d52538486de12CC3Ce00F60DE3CD84fD75597eE] = 2;
1416         whitelist[0x4574F2AEbfa00B9489fad168d2530c1AB0dA94aF] = 2;
1417         whitelist[0xDa56B1ae899Fab58cbB0EEDA7D667aF0DcAe5572] = 2;
1418         whitelist[0xdc96fd721474C3632D6dd5774280a7E1650a3b00] = 2;
1419         whitelist[0xd85Cc97FFC3b8Dc315F983f1bE00D916EF59e2cB] = 2;
1420         whitelist[0x00b6852E20Cd924e536eD94Be2140B3728989cFc] = 2;
1421         whitelist[0xcA1bCc5AfDcc45E87B1B73AdCCa5863f01C46629] = 5;
1422         whitelist[0xe7733E30360B98677DA67F406b23327cA96A4750] = 2;
1423         whitelist[0x3Cd9C90E94850BFfC6C1b7f8fF0Cbd151740Ef5b] = 2;
1424         whitelist[0x59811762A399b4eCED3248406cE5412f5F2b6cb2] = 3;
1425         whitelist[0xB0b8D3345A7276170de955bD8c1c9Bc787d62519] = 2;
1426         whitelist[0x3b8b35D37aBC65CcF7C78Bd677241870417c8451] = 2;
1427         whitelist[0x52D1c62020208dFF40eaAe4f1C41c51D82AB3A4e] = 2;
1428         whitelist[0xB8221D5fb33C317CfBD912b8cE4Bd7C7740fAF88] = 2;
1429         whitelist[0x20A32b6266febb861E0771116FB7B4a7dd6014cE] = 2;
1430         whitelist[0xBD3fD7b44CA24741Db067ace1decEe9B164e31CA] = 2;
1431         whitelist[0xfAcEAA25C46c84F3eE20F979A8bcB6d8deC0Ed78] = 3;
1432         whitelist[0x7ad3d35f3D0970AE97D638C5d461E82401344e67] = 3;
1433         whitelist[0x46e5a4b4721AD087680dC6c2EAE5E4Aa93F8f848] = 2;
1434         whitelist[0x5220CD067677bc7aE6016bd0C8c4eb58B118B77b] = 1;
1435         whitelist[0x52D4E9c6b23cFAfA13938034814AcdAB895B6848] = 1;
1436         whitelist[0xB6B402de2B7fE014500C7e07dFE1eD5c291FFCa8] = 1;
1437         whitelist[0x376a61DC5B30C805089eB027A49F9CA7c21a6c3F] = 1;
1438         whitelist[0x0663C5cD5F11DdDE32630EE929ac00f0C3d4dB9F] = 1;
1439         whitelist[0x70817f848cC79ACB114F606685E8751943fB02C2] = 1;
1440         whitelist[0x95dC53A380D5AbB83438b9308f8219D603543Eed] = 1;
1441         whitelist[0x9Da3f811143ED2208085f460754b32788913a788] = 1;
1442         whitelist[0x36bBA2955490f46396E87f6DB052e1106dEAAcA1] = 1;
1443         whitelist[0xb59C86A4c28bd2663855E02Be15d5a31d1C4eb0b] = 1;
1444         whitelist[0xcF1e264B0B8Fa3cd014Cd7d32A81f5b46Bc06250] = 2;
1445         whitelist[0x29aC2D2A79Dfc7B29277E328235F572C7E626b9C] = 1;
1446         whitelist[0xCCdf62316CA146Ee87AbB2B2c6Fe686A2319466c] = 1;
1447         whitelist[0x1E5139c78050D014f05968Dc5c0755dAe958481B] = 1;
1448         whitelist[0x5eaF958de68f09E7b18D9dc3e424c01ca9136e3e] = 1;
1449         whitelist[0x75321Bc4b5A2aA044C33f1f51e0Ec6e282E91e25] = 1;
1450         whitelist[0x60ef47a7A264818797Ea298d045e7Ef8bA6ac16B] = 1;
1451         whitelist[0xA7cA01E775Dd42ef73f1F87d08e774a9235d516d] = 1;
1452         whitelist[0x8d7c651b9CFfFb23B98c533F11d10ea0BbA8Dd9B] = 2;
1453         whitelist[0x8d4dAbA34C92E581F928fCA40e018382f7A0282a] = 1;
1454         whitelist[0x54ad9d40414eD047067ae04C6faFc199A5bb90bB] = 1;
1455     }
1456 
1457     function mintDegens(uint256 mintCount) public payable nonReentrant {
1458         uint256 lastTokenId = super.totalSupply();
1459         require(mintingActive, 'minting not enabled yet');
1460         require(mintCount <= MAX_PER_MINT, 'max 20 per mint');
1461         require(lastTokenId + mintCount <= MAX_SUPPLY, 'sold out');
1462         require(MINT_COST * mintCount <= msg.value, 'not enough ETH');
1463 
1464         for (uint256 i = 1; i <= mintCount; i++) {
1465             _mintDegen(_msgSender(), lastTokenId + i);
1466         }
1467     }
1468 
1469     function reserveDegens(uint256 reserveCount) public nonReentrant onlyOwner {
1470         uint256 lastTokenId = super.totalSupply();
1471         require(lastTokenId + reserveCount <= MAX_RESERVE, 'max reserves reached.');
1472 
1473         for (uint256 i = 1; i <= reserveCount; i++) {
1474             _mintDegen(owner(), lastTokenId + i);
1475         }
1476     }
1477 
1478     function mintDegensFromWhitelist(uint256 mintCount) public nonReentrant {
1479         uint256 lastTokenId = super.totalSupply();
1480         uint256 freePasses = whitelist[_msgSender()];
1481 
1482         require(earlyMintingActive, 'early minting not enabled yet');
1483         require(lastTokenId + mintCount <= MAX_SUPPLY, 'sold out');
1484         require(mintCount <= freePasses, 'mintCount exceeds passes for this wallet');
1485 
1486         whitelist[_msgSender()] = freePasses - mintCount;
1487 
1488         for (uint256 i = 1; i <= mintCount; i++) {
1489             _mintDegen(_msgSender(), lastTokenId + i);
1490         }
1491     }
1492 
1493     function _mintDegen(address minter, uint256 tokenId) private {
1494         _safeMint(minter, tokenId);
1495     }
1496 
1497     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1498         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1499 
1500         string memory baseURI = _baseURI();
1501         uint256 tokenIdOffset = 1 + (tokenId + tokenOffset) % MAX_SUPPLY;
1502         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenIdOffset.toString())) : "";
1503     }
1504 
1505     function setProvenance(string memory provenance) public onlyOwner {
1506         PROVENANCE = provenance;
1507     }
1508 
1509     function toggleMinting() public onlyOwner {
1510         mintingActive = !mintingActive;
1511     }
1512 
1513     function toggleEarlyMinting() public onlyOwner {
1514         earlyMintingActive = !earlyMintingActive;
1515     }
1516 
1517     function setTokenOffset(uint256 offset) external onlyOwner() {
1518         require(tokenOffset == MAX_SUPPLY, 'tokenOffset can only be set once');
1519         tokenOffset = offset % MAX_SUPPLY;
1520     }
1521 
1522     function setBaseURI(string memory baseURI) external onlyOwner() {
1523         baseDegenURI = baseURI;
1524     }
1525 
1526     function _baseURI() internal view virtual override returns (string memory) {
1527         return baseDegenURI;
1528     }
1529 
1530     function withdraw() public onlyOwner {
1531         uint256 balance = address(this).balance;
1532         uint256 contractFee = balance / 40; // 2.5%
1533 
1534         // send contractFee to contractDev
1535         require(payable(contractDev).send(contractFee), "failed to send contractFee");
1536 
1537         // send everything else to owner
1538         balance = address(this).balance;
1539         require(payable(owner()).send(balance), "failed to withdraw");
1540     }
1541 
1542     function emergencyWithdraw() public onlyOwner {
1543         uint256 balance = address(this).balance;
1544         payable(owner()).transfer(balance);
1545     }
1546 
1547     function supportsInterface(bytes4 interfaceId)
1548         public
1549         view
1550         virtual
1551         override(ERC721Enumerable, ERC2981ContractWideRoyalties)
1552         returns (bool)
1553     {
1554         return super.supportsInterface(interfaceId);
1555     }
1556 
1557 }