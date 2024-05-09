1 // SPDX-License-Identifier: MIT                                                                                                          
2 //By Elfoly
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Strings.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61     uint8 private constant _ADDRESS_LENGTH = 20;
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 
119     /**
120      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
121      */
122     function toHexString(address addr) internal pure returns (string memory) {
123         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/access/Ownable.sol
155 
156 
157 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Contract module which provides a basic access control mechanism, where
164  * there is an account (an owner) that can be granted exclusive access to
165  * specific functions.
166  *
167  * By default, the owner account will be the one that deploys the contract. This
168  * can later be changed with {transferOwnership}.
169  *
170  * This module is used through inheritance. It will make available the modifier
171  * `onlyOwner`, which can be applied to your functions to restrict their use to
172  * the owner.
173  */
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev Initializes the contract setting the deployer as the initial owner.
181      */
182     constructor() {
183         _transferOwnership(_msgSender());
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         _checkOwner();
191         _;
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if the sender is not the owner.
203      */
204     function _checkOwner() internal view virtual {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _transferOwnership(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _transferOwnership(newOwner);
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Internal function without access restriction.
231      */
232     function _transferOwnership(address newOwner) internal virtual {
233         address oldOwner = _owner;
234         _owner = newOwner;
235         emit OwnershipTransferred(oldOwner, newOwner);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
243 
244 pragma solidity ^0.8.1;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      *
267      * [IMPORTANT]
268      * ====
269      * You shouldn't rely on `isContract` to protect against flash loan attacks!
270      *
271      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
272      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
273      * constructor.
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize/address.code.length, which returns 0
278         // for contracts in construction, since the code is only stored at the end
279         // of the constructor execution.
280 
281         return account.code.length > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain `call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452                 /// @solidity memory-safe-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by `operator` from `from`, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
523 
524 
525 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Interface for the NFT Royalty Standard.
532  *
533  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
534  * support for royalty payments across all NFT marketplaces and ecosystem participants.
535  *
536  * _Available since v4.5._
537  */
538 interface IERC2981 is IERC165 {
539     /**
540      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
541      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
542      */
543     function royaltyInfo(uint256 tokenId, uint256 salePrice)
544         external
545         view
546         returns (address receiver, uint256 royaltyAmount);
547 }
548 
549 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/common/ERC2981.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 /**
590  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
591  *
592  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
593  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
594  *
595  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
596  * fee is specified in basis points by default.
597  *
598  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
599  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
600  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
601  *
602  * _Available since v4.5._
603  */
604 abstract contract ERC2981 is IERC2981, ERC165 {
605     struct RoyaltyInfo {
606         address receiver;
607         uint96 royaltyFraction;
608     }
609 
610     RoyaltyInfo private _defaultRoyaltyInfo;
611     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
617         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
618     }
619 
620     /**
621      * @inheritdoc IERC2981
622      */
623     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
624         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
625 
626         if (royalty.receiver == address(0)) {
627             royalty = _defaultRoyaltyInfo;
628         }
629 
630         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
631 
632         return (royalty.receiver, royaltyAmount);
633     }
634 
635     /**
636      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
637      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
638      * override.
639      */
640     function _feeDenominator() internal pure virtual returns (uint96) {
641         return 10000;
642     }
643 
644     /**
645      * @dev Sets the royalty information that all ids in this contract will default to.
646      *
647      * Requirements:
648      *
649      * - `receiver` cannot be the zero address.
650      * - `feeNumerator` cannot be greater than the fee denominator.
651      */
652     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
653         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
654         require(receiver != address(0), "ERC2981: invalid receiver");
655 
656         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
657     }
658 
659     /**
660      * @dev Removes default royalty information.
661      */
662     function _deleteDefaultRoyalty() internal virtual {
663         delete _defaultRoyaltyInfo;
664     }
665 
666     /**
667      * @dev Sets the royalty information for a specific token id, overriding the global default.
668      *
669      * Requirements:
670      *
671      * - `receiver` cannot be the zero address.
672      * - `feeNumerator` cannot be greater than the fee denominator.
673      */
674     function _setTokenRoyalty(
675         uint256 tokenId,
676         address receiver,
677         uint96 feeNumerator
678     ) internal virtual {
679         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
680         require(receiver != address(0), "ERC2981: Invalid parameters");
681 
682         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
683     }
684 
685     /**
686      * @dev Resets royalty information for the token id back to the global default.
687      */
688     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
689         delete _tokenRoyaltyInfo[tokenId];
690     }
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
694 
695 
696 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Required interface of an ERC721 compliant contract.
703  */
704 interface IERC721 is IERC165 {
705     /**
706      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
707      */
708     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
709 
710     /**
711      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
712      */
713     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
714 
715     /**
716      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
717      */
718     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
719 
720     /**
721      * @dev Returns the number of tokens in ``owner``'s account.
722      */
723     function balanceOf(address owner) external view returns (uint256 balance);
724 
725     /**
726      * @dev Returns the owner of the `tokenId` token.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function ownerOf(uint256 tokenId) external view returns (address owner);
733 
734     /**
735      * @dev Safely transfers `tokenId` token from `from` to `to`.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must exist and be owned by `from`.
742      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
744      *
745      * Emits a {Transfer} event.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes calldata data
752     ) external;
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must exist and be owned by `from`.
763      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) external;
773 
774     /**
775      * @dev Transfers `tokenId` token from `from` to `to`.
776      *
777      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
785      *
786      * Emits a {Transfer} event.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) external;
793 
794     /**
795      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
796      * The approval is cleared when the token is transferred.
797      *
798      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
799      *
800      * Requirements:
801      *
802      * - The caller must own the token or be an approved operator.
803      * - `tokenId` must exist.
804      *
805      * Emits an {Approval} event.
806      */
807     function approve(address to, uint256 tokenId) external;
808 
809     /**
810      * @dev Approve or remove `operator` as an operator for the caller.
811      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
812      *
813      * Requirements:
814      *
815      * - The `operator` cannot be the caller.
816      *
817      * Emits an {ApprovalForAll} event.
818      */
819     function setApprovalForAll(address operator, bool _approved) external;
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId) external view returns (address operator);
829 
830     /**
831      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
832      *
833      * See {setApprovalForAll}
834      */
835     function isApprovedForAll(address owner, address operator) external view returns (bool);
836 }
837 
838 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
839 
840 
841 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
842 
843 pragma solidity ^0.8.0;
844 
845 
846 /**
847  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
848  * @dev See https://eips.ethereum.org/EIPS/eip-721
849  */
850 interface IERC721Metadata is IERC721 {
851     /**
852      * @dev Returns the token collection name.
853      */
854     function name() external view returns (string memory);
855 
856     /**
857      * @dev Returns the token collection symbol.
858      */
859     function symbol() external view returns (string memory);
860 
861     /**
862      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
863      */
864     function tokenURI(uint256 tokenId) external view returns (string memory);
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
868 
869 
870 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 
875 
876 
877 
878 
879 
880 
881 /**
882  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
883  * the Metadata extension, but not including the Enumerable extension, which is available separately as
884  * {ERC721Enumerable}.
885  */
886 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
887     using Address for address;
888     using Strings for uint256;
889 
890     // Token name
891     string private _name;
892 
893     // Token symbol
894     string private _symbol;
895 
896     // Mapping from token ID to owner address
897     mapping(uint256 => address) private _owners;
898 
899     // Mapping owner address to token count
900     mapping(address => uint256) private _balances;
901 
902     // Mapping from token ID to approved address
903     mapping(uint256 => address) private _tokenApprovals;
904 
905     // Mapping from owner to operator approvals
906     mapping(address => mapping(address => bool)) private _operatorApprovals;
907 
908     /**
909      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
910      */
911     constructor(string memory name_, string memory symbol_) {
912         _name = name_;
913         _symbol = symbol_;
914     }
915 
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
920         return
921             interfaceId == type(IERC721).interfaceId ||
922             interfaceId == type(IERC721Metadata).interfaceId ||
923             super.supportsInterface(interfaceId);
924     }
925 
926     /**
927      * @dev See {IERC721-balanceOf}.
928      */
929     function balanceOf(address owner) public view virtual override returns (uint256) {
930         require(owner != address(0), "ERC721: address zero is not a valid owner");
931         return _balances[owner];
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
938         address owner = _owners[tokenId];
939         require(owner != address(0), "ERC721: invalid token ID");
940         return owner;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-name}.
945      */
946     function name() public view virtual override returns (string memory) {
947         return _name;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-symbol}.
952      */
953     function symbol() public view virtual override returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-tokenURI}.
959      */
960     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
961         _requireMinted(tokenId);
962 
963         string memory baseURI = _baseURI();
964         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overridden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return "";
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public virtual override {
980         address owner = ERC721.ownerOf(tokenId);
981         require(to != owner, "ERC721: approval to current owner");
982 
983         require(
984             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
985             "ERC721: approve caller is not token owner nor approved for all"
986         );
987 
988         _approve(to, tokenId);
989     }
990 
991     /**
992      * @dev See {IERC721-getApproved}.
993      */
994     function getApproved(uint256 tokenId) public view virtual override returns (address) {
995         _requireMinted(tokenId);
996 
997         return _tokenApprovals[tokenId];
998     }
999 
1000     /**
1001      * @dev See {IERC721-setApprovalForAll}.
1002      */
1003     function setApprovalForAll(address operator, bool approved) public virtual override {
1004         _setApprovalForAll(_msgSender(), operator, approved);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-isApprovedForAll}.
1009      */
1010     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1011         return _operatorApprovals[owner][operator];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-transferFrom}.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         //solhint-disable-next-line max-line-length
1023         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1024 
1025         _transfer(from, to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         safeTransferFrom(from, to, tokenId, "");
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory data
1047     ) public virtual override {
1048         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1049         _safeTransfer(from, to, tokenId, data);
1050     }
1051 
1052     /**
1053      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1054      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1055      *
1056      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1057      *
1058      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1059      * implement alternative mechanisms to perform token transfer, such as signature-based.
1060      *
1061      * Requirements:
1062      *
1063      * - `from` cannot be the zero address.
1064      * - `to` cannot be the zero address.
1065      * - `tokenId` token must exist and be owned by `from`.
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _safeTransfer(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory data
1075     ) internal virtual {
1076         _transfer(from, to, tokenId);
1077         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1078     }
1079 
1080     /**
1081      * @dev Returns whether `tokenId` exists.
1082      *
1083      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1084      *
1085      * Tokens start existing when they are minted (`_mint`),
1086      * and stop existing when they are burned (`_burn`).
1087      */
1088     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1089         return _owners[tokenId] != address(0);
1090     }
1091 
1092     /**
1093      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1094      *
1095      * Requirements:
1096      *
1097      * - `tokenId` must exist.
1098      */
1099     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1100         address owner = ERC721.ownerOf(tokenId);
1101         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1102     }
1103 
1104     /**
1105      * @dev Safely mints `tokenId` and transfers it to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must not exist.
1110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _safeMint(address to, uint256 tokenId) internal virtual {
1115         _safeMint(to, tokenId, "");
1116     }
1117 
1118     /**
1119      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1120      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1121      */
1122     function _safeMint(
1123         address to,
1124         uint256 tokenId,
1125         bytes memory data
1126     ) internal virtual {
1127         _mint(to, tokenId);
1128         require(
1129             _checkOnERC721Received(address(0), to, tokenId, data),
1130             "ERC721: transfer to non ERC721Receiver implementer"
1131         );
1132     }
1133 
1134     /**
1135      * @dev Mints `tokenId` and transfers it to `to`.
1136      *
1137      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must not exist.
1142      * - `to` cannot be the zero address.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _mint(address to, uint256 tokenId) internal virtual {
1147         require(to != address(0), "ERC721: mint to the zero address");
1148         require(!_exists(tokenId), "ERC721: token already minted");
1149 
1150         _beforeTokenTransfer(address(0), to, tokenId);
1151 
1152         _balances[to] += 1;
1153         _owners[tokenId] = to;
1154 
1155         emit Transfer(address(0), to, tokenId);
1156 
1157         _afterTokenTransfer(address(0), to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Destroys `tokenId`.
1162      * The approval is cleared when the token is burned.
1163      *
1164      * Requirements:
1165      *
1166      * - `tokenId` must exist.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _burn(uint256 tokenId) internal virtual {
1171         address owner = ERC721.ownerOf(tokenId);
1172 
1173         _beforeTokenTransfer(owner, address(0), tokenId);
1174 
1175         // Clear approvals
1176         _approve(address(0), tokenId);
1177 
1178         _balances[owner] -= 1;
1179         delete _owners[tokenId];
1180 
1181         emit Transfer(owner, address(0), tokenId);
1182 
1183         _afterTokenTransfer(owner, address(0), tokenId);
1184     }
1185 
1186     /**
1187      * @dev Transfers `tokenId` from `from` to `to`.
1188      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1189      *
1190      * Requirements:
1191      *
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must be owned by `from`.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _transfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) internal virtual {
1202         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1203         require(to != address(0), "ERC721: transfer to the zero address");
1204 
1205         _beforeTokenTransfer(from, to, tokenId);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId);
1209 
1210         _balances[from] -= 1;
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(from, to, tokenId);
1215 
1216         _afterTokenTransfer(from, to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits an {Approval} event.
1223      */
1224     function _approve(address to, uint256 tokenId) internal virtual {
1225         _tokenApprovals[tokenId] = to;
1226         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1227     }
1228 
1229     /**
1230      * @dev Approve `operator` to operate on all of `owner` tokens
1231      *
1232      * Emits an {ApprovalForAll} event.
1233      */
1234     function _setApprovalForAll(
1235         address owner,
1236         address operator,
1237         bool approved
1238     ) internal virtual {
1239         require(owner != operator, "ERC721: approve to caller");
1240         _operatorApprovals[owner][operator] = approved;
1241         emit ApprovalForAll(owner, operator, approved);
1242     }
1243 
1244     /**
1245      * @dev Reverts if the `tokenId` has not been minted yet.
1246      */
1247     function _requireMinted(uint256 tokenId) internal view virtual {
1248         require(_exists(tokenId), "ERC721: invalid token ID");
1249     }
1250 
1251     /**
1252      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1253      * The call is not executed if the target address is not a contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory data
1266     ) private returns (bool) {
1267         if (to.isContract()) {
1268             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1269                 return retval == IERC721Receiver.onERC721Received.selector;
1270             } catch (bytes memory reason) {
1271                 if (reason.length == 0) {
1272                     revert("ERC721: transfer to non ERC721Receiver implementer");
1273                 } else {
1274                     /// @solidity memory-safe-assembly
1275                     assembly {
1276                         revert(add(32, reason), mload(reason))
1277                     }
1278                 }
1279             }
1280         } else {
1281             return true;
1282         }
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before any token transfer. This includes minting
1287      * and burning.
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1295      * - `from` and `to` are never both zero.
1296      *
1297      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1298      */
1299     function _beforeTokenTransfer(
1300         address from,
1301         address to,
1302         uint256 tokenId
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev Hook that is called after any transfer of tokens. This includes
1307      * minting and burning.
1308      *
1309      * Calling conditions:
1310      *
1311      * - when `from` and `to` are both non-zero.
1312      * - `from` and `to` are never both zero.
1313      *
1314      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1315      */
1316     function _afterTokenTransfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) internal virtual {}
1321 }
1322 
1323 // File: contracts/Justbirdz.sol
1324 
1325 
1326 //By Elfoly
1327 
1328 pragma solidity >=0.7.0 <0.9.0;
1329 
1330 
1331 
1332 
1333 
1334 contract JustBirdz is ERC721, ERC2981, Ownable {
1335   using Strings for uint256;
1336   using Counters for Counters.Counter;
1337 
1338   Counters.Counter private supply;
1339 
1340   string public uriPrefix = "ipfs://bafybeidzanler5cxyaet7hxaizznvnjckk3kyvj5cd3tie7yl3daxwv2su/";
1341   string public uriSuffix = ".json";
1342   string public contractURI;
1343   
1344   uint256 public maxSupply = 1000;
1345   uint256 public maxMintAmountPerTx = 1;
1346   uint256 public maxMintAmountPerWallet = 1;
1347   mapping(address => uint256) public mintedWallets;
1348 
1349   bool public paused = false;
1350 
1351  constructor(uint96 _royaltyFeesInBips, string memory _contractURI) ERC721("JustBirdz", "JB") {
1352    setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
1353    contractURI = _contractURI;
1354   }
1355  
1356 
1357   modifier mintCompliance(uint256 _mintAmount) {
1358     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1359 
1360     _;
1361   }
1362 
1363   function totalSupply() public view returns (uint256) {
1364     return supply.current();
1365   }
1366 
1367   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1368     require(!paused, "The contract is paused!");
1369     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Only one per Tx!");
1370     require(mintedWallets[msg.sender] < 1, "Only one per wallet!");
1371     mintedWallets[msg.sender]++;
1372 
1373 
1374 
1375     _mintLoop(msg.sender, _mintAmount);
1376   }
1377   
1378   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1379     _mintLoop(_receiver, _mintAmount);
1380   }
1381 
1382   function walletOfOwner(address _owner)
1383     public
1384     view
1385     returns (uint256[] memory)
1386   {
1387     uint256 ownerTokenCount = balanceOf(_owner);
1388     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1389     uint256 currentTokenId = 1;
1390     uint256 ownedTokenIndex = 0;
1391 
1392     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1393       address currentTokenOwner = ownerOf(currentTokenId);
1394 
1395       if (currentTokenOwner == _owner) {
1396         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1397 
1398         ownedTokenIndex++;
1399       }
1400 
1401       currentTokenId++;
1402     }
1403 
1404     return ownedTokenIds;
1405   }
1406 
1407   function tokenURI(uint256 _tokenId)
1408     public
1409     view
1410     virtual
1411     override
1412     returns (string memory)
1413   {
1414     require(
1415       _exists(_tokenId),
1416       "ERC721Metadata: URI query for nonexistent token"
1417     );
1418 
1419   
1420 
1421     string memory currentBaseURI = _baseURI();
1422     return bytes(currentBaseURI).length > 0
1423         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1424         : "";
1425   }
1426 
1427 
1428 
1429 
1430   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1431     maxMintAmountPerTx = _maxMintAmountPerTx;
1432   }
1433 
1434   
1435 
1436   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1437     uriPrefix = _uriPrefix;
1438   }
1439 
1440 
1441   function setPaused(bool _state) public onlyOwner {
1442     paused = _state;
1443   }
1444 
1445   function withdraw() public onlyOwner {
1446 
1447 
1448     // This will transfer the remaining contract balance to the owner.
1449     // Do not remove this otherwise you will not be able to withdraw the funds.
1450     // =============================================================================
1451     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1452     require(os);
1453     // =============================================================================
1454   }
1455 
1456   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1457     for (uint256 i = 0; i < _mintAmount; i++) {
1458       supply.increment();
1459       _safeMint(_receiver, supply.current());
1460     }
1461   }
1462 
1463   function _baseURI() internal view virtual override returns (string memory) {
1464     return uriPrefix;
1465   }
1466 
1467   function supportsInterface(bytes4 interfaceId) 
1468   public
1469   view
1470   override(ERC721, ERC2981)
1471   returns (bool)
1472   {
1473     return super.supportsInterface(interfaceId);
1474   }
1475 
1476     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1477       _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1478     }
1479 
1480     function setContractURI(string calldata _contractURI) public onlyOwner {
1481       contractURI = _contractURI;
1482     }
1483 
1484     
1485 
1486 
1487 }