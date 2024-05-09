1 // SPDX-License-Identifier: MIT
2 // File: contracts/IERC2981Royalties.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /// @title IERC2981Royalties
8 /// @dev Interface for the ERC2981 - Token Royalty standard
9 interface IERC2981Royalties {
10     /// @notice Called with the sale price to determine how much royalty
11     //          is owed and to whom.
12     /// @param _tokenId - the NFT asset queried for royalty information
13     /// @param _value - the sale price of the NFT asset specified by _tokenId
14     /// @return _receiver - address of who should be sent the royalty payment
15     /// @return _royaltyAmount - the royalty payment amount for value sale price
16     function royaltyInfo(uint256 _tokenId, uint256 _value)
17         external
18         view
19         returns (address _receiver, uint256 _royaltyAmount);
20 }
21 
22 // File: @openzeppelin/contracts/utils/Strings.sol
23 
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 }
90 
91 // File: @openzeppelin/contracts/utils/Context.sol
92 
93 
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/access/Ownable.sol
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 
124 /**
125  * @dev Contract module which provides a basic access control mechanism, where
126  * there is an account (an owner) that can be granted exclusive access to
127  * specific functions.
128  *
129  * By default, the owner account will be the one that deploys the contract. This
130  * can later be changed with {transferOwnership}.
131  *
132  * This module is used through inheritance. It will make available the modifier
133  * `onlyOwner`, which can be applied to your functions to restrict their use to
134  * the owner.
135  */
136 abstract contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor() {
145         _setOwner(_msgSender());
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         _setOwner(address(0));
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _setOwner(newOwner);
181     }
182 
183     function _setOwner(address newOwner) private {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Address.sol
191 
192 
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize, which returns 0 for contracts in
219         // construction, since the code is only stored at the end of the
220         // constructor execution.
221 
222         uint256 size;
223         assembly {
224             size := extcodesize(account)
225         }
226         return size > 0;
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      */
245     function sendValue(address payable recipient, uint256 amount) internal {
246         require(address(this).balance >= amount, "Address: insufficient balance");
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionCall(target, data, "Address: low-level call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
276      * `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, 0, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but also transferring `value` wei to `target`.
291      *
292      * Requirements:
293      *
294      * - the calling contract must have an ETH balance of at least `value`.
295      * - the called Solidity function must be `payable`.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(address(this).balance >= value, "Address: insufficient balance for call");
320         require(isContract(target), "Address: call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.call{value: value}(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.staticcall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
382      * revert reason using the provided one.
383      *
384      * _Available since v4.3._
385      */
386     function verifyCallResult(
387         bool success,
388         bytes memory returndata,
389         string memory errorMessage
390     ) internal pure returns (bytes memory) {
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
410 
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
439 
440 
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @dev Interface of the ERC165 standard, as defined in the
446  * https://eips.ethereum.org/EIPS/eip-165[EIP].
447  *
448  * Implementers can declare support of contract interfaces, which can then be
449  * queried by others ({ERC165Checker}).
450  *
451  * For an implementation, see {ERC165}.
452  */
453 interface IERC165 {
454     /**
455      * @dev Returns true if this contract implements the interface defined by
456      * `interfaceId`. See the corresponding
457      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
458      * to learn more about how these ids are created.
459      *
460      * This function call must use less than 30 000 gas.
461      */
462     function supportsInterface(bytes4 interfaceId) external view returns (bool);
463 }
464 
465 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
466 
467 
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: contracts/ERC2981Base.sol
496 
497 
498 pragma solidity ^0.8.0;
499 
500 
501 
502 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
503 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
504     /// @inheritdoc	ERC165
505     function supportsInterface(bytes4 interfaceId)
506         public
507         view
508         virtual
509         override
510         returns (bool)
511     {
512         return
513             interfaceId == type(IERC2981Royalties).interfaceId ||
514             super.supportsInterface(interfaceId);
515     }
516 
517     /// @notice Uses Bitpacking to encode royalties into one bytes32 (saves gas)
518     /// @return the bytes32 representation
519     function encodeRoyalties(address recipient, uint256 amount)
520         public
521         pure
522         returns (bytes32)
523     {
524         require(amount <= 10000, '!WRONG_AMOUNT!');
525         return bytes32((uint256(uint160(recipient)) << 96) + amount);
526     }
527 
528     /// @notice Uses Bitpacking to decode royalties from a bytes32
529     /// @return recipient and amount
530     function decodeRoyalties(bytes32 royalties)
531         public
532         pure
533         returns (address recipient, uint256 amount)
534     {
535         recipient = address(uint160(uint256(royalties) >> 96));
536         amount = uint256(uint96(uint256(royalties)));
537     }
538 }
539 
540 // File: contracts/ERC2981ContractWideRoyalties.sol
541 
542 
543 pragma solidity ^0.8.0;
544 
545 
546 
547 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
548 /// @dev This implementation has the same royalties for each and every tokens
549 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
550     bytes32 private _royalties;
551 
552     /// @dev Sets token royalties
553     /// @param recipient recipient of the royalties
554     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
555     function _setRoyalties(address recipient, uint256 value) internal {
556         require(value <= 10000, 'ERC2981Royalties: Too high');
557         _royalties = encodeRoyalties(recipient, value);
558     }
559 
560     /// @inheritdoc	IERC2981Royalties
561     function royaltyInfo(uint256, uint256 value)
562         external
563         view
564         override
565         returns (address receiver, uint256 royaltyAmount)
566     {
567         uint256 basis;
568         (receiver, basis) = decodeRoyalties(_royalties);
569         royaltyAmount = (value * basis) / 10000;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Required interface of an ERC721 compliant contract.
582  */
583 interface IERC721 is IERC165 {
584     /**
585      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
586      */
587     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
588 
589     /**
590      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
591      */
592     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      * @dev Returns the number of tokens in ``owner``'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
615      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Transfers `tokenId` token from `from` to `to`.
635      *
636      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
655      * The approval is cleared when the token is transferred.
656      *
657      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
658      *
659      * Requirements:
660      *
661      * - The caller must own the token or be an approved operator.
662      * - `tokenId` must exist.
663      *
664      * Emits an {Approval} event.
665      */
666     function approve(address to, uint256 tokenId) external;
667 
668     /**
669      * @dev Returns the account approved for `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function getApproved(uint256 tokenId) external view returns (address operator);
676 
677     /**
678      * @dev Approve or remove `operator` as an operator for the caller.
679      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
680      *
681      * Requirements:
682      *
683      * - The `operator` cannot be the caller.
684      *
685      * Emits an {ApprovalForAll} event.
686      */
687     function setApprovalForAll(address operator, bool _approved) external;
688 
689     /**
690      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
691      *
692      * See {setApprovalForAll}
693      */
694     function isApprovedForAll(address owner, address operator) external view returns (bool);
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must exist and be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes calldata data
714     ) external;
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
718 
719 
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Enumerable is IERC721 {
729     /**
730      * @dev Returns the total amount of tokens stored by the contract.
731      */
732     function totalSupply() external view returns (uint256);
733 
734     /**
735      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
736      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
737      */
738     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
739 
740     /**
741      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
742      * Use along with {totalSupply} to enumerate all tokens.
743      */
744     function tokenByIndex(uint256 index) external view returns (uint256);
745 }
746 
747 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
748 
749 
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
756  * @dev See https://eips.ethereum.org/EIPS/eip-721
757  */
758 interface IERC721Metadata is IERC721 {
759     /**
760      * @dev Returns the token collection name.
761      */
762     function name() external view returns (string memory);
763 
764     /**
765      * @dev Returns the token collection symbol.
766      */
767     function symbol() external view returns (string memory);
768 
769     /**
770      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
771      */
772     function tokenURI(uint256 tokenId) external view returns (string memory);
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
776 
777 
778 
779 pragma solidity ^0.8.0;
780 
781 
782 
783 
784 
785 
786 
787 
788 /**
789  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
790  * the Metadata extension, but not including the Enumerable extension, which is available separately as
791  * {ERC721Enumerable}.
792  */
793 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
794     using Address for address;
795     using Strings for uint256;
796 
797     // Token name
798     string private _name;
799 
800     // Token symbol
801     string private _symbol;
802 
803     // Mapping from token ID to owner address
804     mapping(uint256 => address) private _owners;
805 
806     // Mapping owner address to token count
807     mapping(address => uint256) private _balances;
808 
809     // Mapping from token ID to approved address
810     mapping(uint256 => address) private _tokenApprovals;
811 
812     // Mapping from owner to operator approvals
813     mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815     /**
816      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
817      */
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      */
826     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
827         return
828             interfaceId == type(IERC721).interfaceId ||
829             interfaceId == type(IERC721Metadata).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view virtual override returns (uint256) {
837         require(owner != address(0), "ERC721: balance query for the zero address");
838         return _balances[owner];
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
845         address owner = _owners[tokenId];
846         require(owner != address(0), "ERC721: owner query for nonexistent token");
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return "";
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public virtual override {
887         address owner = ERC721.ownerOf(tokenId);
888         require(to != owner, "ERC721: approval to current owner");
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             "ERC721: approve caller is not owner nor approved for all"
893         );
894 
895         _approve(to, tokenId);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view virtual override returns (address) {
902         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public virtual override {
911         require(operator != _msgSender(), "ERC721: approve to caller");
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         //solhint-disable-next-line max-line-length
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
934 
935         _transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, "");
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
959         _safeTransfer(from, to, tokenId, _data);
960     }
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
964      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
965      *
966      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
967      *
968      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
969      * implement alternative mechanisms to perform token transfer, such as signature-based.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must exist and be owned by `from`.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeTransfer(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) internal virtual {
986         _transfer(from, to, tokenId);
987         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      * and stop existing when they are burned (`_burn`).
997      */
998     function _exists(uint256 tokenId) internal view virtual returns (bool) {
999         return _owners[tokenId] != address(0);
1000     }
1001 
1002     /**
1003      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1010         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1011         address owner = ERC721.ownerOf(tokenId);
1012         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1013     }
1014 
1015     /**
1016      * @dev Safely mints `tokenId` and transfers it to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(address to, uint256 tokenId) internal virtual {
1026         _safeMint(to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1031      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _mint(to, tokenId);
1039         require(
1040             _checkOnERC721Received(address(0), to, tokenId, _data),
1041             "ERC721: transfer to non ERC721Receiver implementer"
1042         );
1043     }
1044 
1045     /**
1046      * @dev Mints `tokenId` and transfers it to `to`.
1047      *
1048      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must not exist.
1053      * - `to` cannot be the zero address.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 tokenId) internal virtual {
1058         require(to != address(0), "ERC721: mint to the zero address");
1059         require(!_exists(tokenId), "ERC721: token already minted");
1060 
1061         _beforeTokenTransfer(address(0), to, tokenId);
1062 
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(address(0), to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId) internal virtual {
1080         address owner = ERC721.ownerOf(tokenId);
1081 
1082         _beforeTokenTransfer(owner, address(0), tokenId);
1083 
1084         // Clear approvals
1085         _approve(address(0), tokenId);
1086 
1087         _balances[owner] -= 1;
1088         delete _owners[tokenId];
1089 
1090         emit Transfer(owner, address(0), tokenId);
1091     }
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must be owned by `from`.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _transfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {
1109         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1110         require(to != address(0), "ERC721: transfer to the zero address");
1111 
1112         _beforeTokenTransfer(from, to, tokenId);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId);
1116 
1117         _balances[from] -= 1;
1118         _balances[to] += 1;
1119         _owners[tokenId] = to;
1120 
1121         emit Transfer(from, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev Approve `to` to operate on `tokenId`
1126      *
1127      * Emits a {Approval} event.
1128      */
1129     function _approve(address to, uint256 tokenId) internal virtual {
1130         _tokenApprovals[tokenId] = to;
1131         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1132     }
1133 
1134     /**
1135      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1136      * The call is not executed if the target address is not a contract.
1137      *
1138      * @param from address representing the previous owner of the given token ID
1139      * @param to target address that will receive the tokens
1140      * @param tokenId uint256 ID of the token to be transferred
1141      * @param _data bytes optional data to send along with the call
1142      * @return bool whether the call correctly returned the expected magic value
1143      */
1144     function _checkOnERC721Received(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) private returns (bool) {
1150         if (to.isContract()) {
1151             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1152                 return retval == IERC721Receiver.onERC721Received.selector;
1153             } catch (bytes memory reason) {
1154                 if (reason.length == 0) {
1155                     revert("ERC721: transfer to non ERC721Receiver implementer");
1156                 } else {
1157                     assembly {
1158                         revert(add(32, reason), mload(reason))
1159                     }
1160                 }
1161             }
1162         } else {
1163             return true;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before any token transfer. This includes minting
1169      * and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1177      * - `from` and `to` are never both zero.
1178      *
1179      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1180      */
1181     function _beforeTokenTransfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) internal virtual {}
1186 }
1187 
1188 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1189 
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 
1196 /**
1197  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1198  * enumerability of all the token ids in the contract as well as all token ids owned by each
1199  * account.
1200  */
1201 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1202     // Mapping from owner to list of owned token IDs
1203     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1204 
1205     // Mapping from token ID to index of the owner tokens list
1206     mapping(uint256 => uint256) private _ownedTokensIndex;
1207 
1208     // Array with all token ids, used for enumeration
1209     uint256[] private _allTokens;
1210 
1211     // Mapping from token id to position in the allTokens array
1212     mapping(uint256 => uint256) private _allTokensIndex;
1213 
1214     /**
1215      * @dev See {IERC165-supportsInterface}.
1216      */
1217     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1218         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1223      */
1224     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1225         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1226         return _ownedTokens[owner][index];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Enumerable-totalSupply}.
1231      */
1232     function totalSupply() public view virtual override returns (uint256) {
1233         return _allTokens.length;
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Enumerable-tokenByIndex}.
1238      */
1239     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1240         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1241         return _allTokens[index];
1242     }
1243 
1244     /**
1245      * @dev Hook that is called before any token transfer. This includes minting
1246      * and burning.
1247      *
1248      * Calling conditions:
1249      *
1250      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1251      * transferred to `to`.
1252      * - When `from` is zero, `tokenId` will be minted for `to`.
1253      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1254      * - `from` cannot be the zero address.
1255      * - `to` cannot be the zero address.
1256      *
1257      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1258      */
1259     function _beforeTokenTransfer(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) internal virtual override {
1264         super._beforeTokenTransfer(from, to, tokenId);
1265 
1266         if (from == address(0)) {
1267             _addTokenToAllTokensEnumeration(tokenId);
1268         } else if (from != to) {
1269             _removeTokenFromOwnerEnumeration(from, tokenId);
1270         }
1271         if (to == address(0)) {
1272             _removeTokenFromAllTokensEnumeration(tokenId);
1273         } else if (to != from) {
1274             _addTokenToOwnerEnumeration(to, tokenId);
1275         }
1276     }
1277 
1278     /**
1279      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1280      * @param to address representing the new owner of the given token ID
1281      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1282      */
1283     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1284         uint256 length = ERC721.balanceOf(to);
1285         _ownedTokens[to][length] = tokenId;
1286         _ownedTokensIndex[tokenId] = length;
1287     }
1288 
1289     /**
1290      * @dev Private function to add a token to this extension's token tracking data structures.
1291      * @param tokenId uint256 ID of the token to be added to the tokens list
1292      */
1293     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1294         _allTokensIndex[tokenId] = _allTokens.length;
1295         _allTokens.push(tokenId);
1296     }
1297 
1298     /**
1299      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1300      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1301      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1302      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1303      * @param from address representing the previous owner of the given token ID
1304      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1305      */
1306     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1307         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1308         // then delete the last slot (swap and pop).
1309 
1310         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1311         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1312 
1313         // When the token to delete is the last token, the swap operation is unnecessary
1314         if (tokenIndex != lastTokenIndex) {
1315             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1316 
1317             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1318             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1319         }
1320 
1321         // This also deletes the contents at the last position of the array
1322         delete _ownedTokensIndex[tokenId];
1323         delete _ownedTokens[from][lastTokenIndex];
1324     }
1325 
1326     /**
1327      * @dev Private function to remove a token from this extension's token tracking data structures.
1328      * This has O(1) time complexity, but alters the order of the _allTokens array.
1329      * @param tokenId uint256 ID of the token to be removed from the tokens list
1330      */
1331     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1332         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1333         // then delete the last slot (swap and pop).
1334 
1335         uint256 lastTokenIndex = _allTokens.length - 1;
1336         uint256 tokenIndex = _allTokensIndex[tokenId];
1337 
1338         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1339         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1340         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1341         uint256 lastTokenId = _allTokens[lastTokenIndex];
1342 
1343         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1344         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1345 
1346         // This also deletes the contents at the last position of the array
1347         delete _allTokensIndex[tokenId];
1348         _allTokens.pop();
1349     }
1350 }
1351 
1352 // File: contracts/MetaSapiens.sol
1353 
1354 
1355 // Amended by MetaSupreme
1356 
1357 /**
1358  *
1359 .#%%%%%%%%%. .#%%%-                              +%%%%%%%%%%%%%%%%%%:
1360  .%@@@@@@@@=:@@@@@                              *@@@@@@@@@@@@@@@@@%.
1361    ..-@@@@@@@@@@@*.=======:.==========- -=====- #@@%.......:++++++.    -=====-    ===:.=======:.===:  ===: .-=========
1362      *@@@@@@@@@@@-+@@@@@@@-+@@@@@@@@@+:%@@@@@@# #@@@@+     -@@@@@@@*.  #@@@@@@%=  %@@#.@@@@@@@% @@@@- *@@% #@@@@@@@@@:
1363      @@@##@@=@@@@ @@@@++++ =+*@@@%++:+@@*+*@@@*  -#@@@@=   -@@@#**@@@* *@@@**#@@@:*@@@ %@@@**** #@@@@-:@@@-+@@@*++++-
1364     +@@@:=@-=@@@*:@@@+.::    :@@@=  %@@@--=@@@+    :*@@@@+.-@@@+--%@@@ +@@@ :=@@@*-@@@-*@@@::::.-@@@@@:#@@%.@@@%:
1365    .@@@# :- @@@@:+@@@@@@%    =@@@.  @@@@@@@@@@-      .#@@@@-@@@@@@@@@@ =@@@.*@@@%=.@@@+-@@@@@@@* @@@@@@*@@@:.#@@@+
1366    *@@@-   :@@@% %@@@@%%=    *@@@  :@@@#++#@@@:        #@@@-@@@#++%@@@.=@@@:-*+:   @@@% @@@@#### *@@@%@@@@@+  =@@@%.
1367   .@@@%    *@@@=:@@@=        @@@#  -@@@-  *@@@.:@@@@@@@@@@%-@@@-  +@@@:-@@@-       #@@@.#@@%.    :@@@=%@@@@@   .*@@@+
1368   *@@@-    @@@@ *@@@##%@+   .@@@=  +@@@.  #@@@ -@@@@@@@@@#:-@@@-  +@@@-:@@@+       *@@@-+@@@@@@@+ @@@* #@@@@=    -@@@@-
1369  .@@@%    =@@@* @@@@@@@@:   -%%#:  =+==   :::.  ....        .           .::.       :+**=:%%@@@@@@ +@@@  #@@@% ==-:.#@@@.
1370  #@@@+    %@@@:-##*+==-:                                                                      ..: .=+*:  *@@@--@@@@@@@@*
1371 :@@@@.    -:.                                                                                              .:: *#@@@@@@@
1372 */
1373 
1374 pragma solidity >=0.7.0 <0.9.0;
1375 
1376 
1377 
1378 
1379 contract MetaSapiens is ERC721Enumerable, Ownable, ERC2981ContractWideRoyalties {
1380   using Strings for uint256;
1381 
1382   string public baseURI;
1383   uint256 public cost = 1 ether;
1384   uint256 public maxSupply = 10101;
1385   uint256 public maxMintAmount = 10;
1386   uint256 public maxAvailableTokenID = 100;
1387   bool public paused = false;
1388   bool public onlyWhitelistedCanMint = false;
1389   bool public onlyOwnerCanMint = true;
1390   address[] public whitelistedAddresses;
1391   
1392   enum MintingAvailability { NoChange, Public, PrivateOnlyWhitelisted, PrivateOnlyOwner, Paused, SoldOut }
1393 
1394   constructor(
1395     string memory _name,
1396     string memory _symbol,
1397     string memory _initBaseURI
1398   ) ERC721(_name, _symbol) {
1399     setBaseURI(_initBaseURI);
1400   }
1401 
1402   // internal
1403   function _baseURI() internal view virtual override returns (string memory) {
1404     return baseURI;
1405   }
1406 
1407   // public
1408   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC2981Base) returns (bool) {
1409         return super.supportsInterface(interfaceId);
1410   }
1411 
1412   function mint(uint256 _mintAmount) public payable {
1413     require(!paused, "the contract is paused");
1414     uint256 supply = totalSupply();
1415     require(_mintAmount > 0, "need to mint at least 1 NFT");
1416     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1417     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1418 
1419     if (msg.sender != owner()) {
1420         require(onlyOwnerCanMint == false, "only owner can mint");
1421         if(onlyWhitelistedCanMint == true) {
1422             require(isWhitelisted(msg.sender), "user is not whitelisted");
1423         }
1424         require(msg.value >= cost * _mintAmount, "insufficient funds");
1425     }
1426     
1427     uint256 lastTokenIDToMint = supply + _mintAmount;
1428     require(lastTokenIDToMint <= maxAvailableTokenID, "token ID is not yet available");
1429 
1430     for (uint256 i = 1; i <= _mintAmount; i++) {
1431       _safeMint(msg.sender, supply + i);
1432     }
1433   }
1434   
1435   function mintingAvailability() public view returns (MintingAvailability) {
1436     uint256 supply = totalSupply();
1437     if (supply >= maxAvailableTokenID || supply >= maxSupply) {
1438       return MintingAvailability.SoldOut;
1439     }
1440     
1441     if (paused) {
1442       return MintingAvailability.Paused;
1443     }
1444     
1445     if (onlyOwnerCanMint) {
1446       return MintingAvailability.PrivateOnlyOwner;
1447     }
1448     
1449     if (onlyWhitelistedCanMint) {
1450       return MintingAvailability.PrivateOnlyWhitelisted;
1451     }
1452     
1453     return MintingAvailability.Public;
1454   }
1455   
1456   function isWhitelisted(address _user) public view returns (bool) {
1457     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1458       if (whitelistedAddresses[i] == _user) {
1459           return true;
1460       }
1461     }
1462     return false;
1463   }
1464 
1465   function walletOfOwner(address _owner)
1466     public
1467     view
1468     returns (uint256[] memory)
1469   {
1470     uint256 ownerTokenCount = balanceOf(_owner);
1471     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1472     for (uint256 i; i < ownerTokenCount; i++) {
1473       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1474     }
1475     return tokenIds;
1476   }
1477   
1478   function setRoyalties(address recipient, uint256 value) public onlyOwner {
1479       _setRoyalties(recipient, value);
1480   }
1481 
1482   function tokenURI(uint256 tokenId)
1483     public
1484     view
1485     virtual
1486     override
1487     returns (string memory)
1488   {
1489     require(
1490       _exists(tokenId),
1491       "ERC721Metadata: URI query for nonexistent token"
1492     );
1493     
1494     string memory currentBaseURI = _baseURI();
1495     return bytes(currentBaseURI).length > 0
1496         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1497         : "";
1498   }
1499 
1500   //only owner
1501   function prepareForDrop(uint256 _nextMaxTokenID, uint256 _ownerMintCount, MintingAvailability _postDropMintState) public onlyOwner {
1502     require(totalSupply() == maxAvailableTokenID, "all tokens from current drop not yet minted");
1503     maxAvailableTokenID = _nextMaxTokenID;
1504     if (_ownerMintCount > 0) {
1505       mint(_ownerMintCount);
1506     }
1507     if (_postDropMintState == MintingAvailability.Public) {
1508       onlyOwnerCanMint = false;
1509       onlyWhitelistedCanMint = false;
1510       paused = false;
1511     } else if (_postDropMintState == MintingAvailability.PrivateOnlyOwner) {
1512       onlyOwnerCanMint = true;
1513       onlyWhitelistedCanMint = false;
1514       paused = false;
1515     } else if (_postDropMintState == MintingAvailability.PrivateOnlyWhitelisted) {
1516       onlyOwnerCanMint = false;
1517       onlyWhitelistedCanMint = true;
1518       paused = false;
1519     } else if (_postDropMintState == MintingAvailability.Paused) {
1520       paused = true;
1521     }
1522   }
1523   
1524   function setCost(uint256 _newCost) public onlyOwner() {
1525     cost = _newCost;
1526   }
1527 
1528   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1529     maxMintAmount = _newmaxMintAmount;
1530   }
1531 
1532   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1533     baseURI = _newBaseURI;
1534   }
1535   
1536   function setMaxAvailableTokenID(uint256 _tokenID) public onlyOwner {
1537     maxAvailableTokenID = _tokenID;
1538   }
1539   
1540   function pause(bool _state) public onlyOwner {
1541     paused = _state;
1542   }
1543   
1544   function setOnlyWhitelistedCanMint(bool _state) public onlyOwner {
1545     onlyWhitelistedCanMint = _state;
1546   }
1547   
1548   function setOnlyOwnerCanMint(bool _state) public onlyOwner {
1549     onlyOwnerCanMint = _state;
1550   }
1551   
1552   function whitelistUsers(address[] calldata _users) public onlyOwner {
1553     delete whitelistedAddresses;
1554     whitelistedAddresses = _users;
1555   }
1556  
1557   function withdraw() public payable onlyOwner {
1558     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1559     require(success);
1560   }
1561 }