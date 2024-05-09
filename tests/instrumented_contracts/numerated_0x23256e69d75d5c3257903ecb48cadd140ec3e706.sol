1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
246 
247 pragma solidity ^0.8.1;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      *
270      * [IMPORTANT]
271      * ====
272      * You shouldn't rely on `isContract` to protect against flash loan attacks!
273      *
274      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
275      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
276      * constructor.
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies on extcodesize/address.code.length, which returns 0
281         // for contracts in construction, since the code is only stored at the end
282         // of the constructor execution.
283 
284         return account.code.length > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Interface of the ERC165 standard, as defined in the
506  * https://eips.ethereum.org/EIPS/eip-165[EIP].
507  *
508  * Implementers can declare support of contract interfaces, which can then be
509  * queried by others ({ERC165Checker}).
510  *
511  * For an implementation, see {ERC165}.
512  */
513 interface IERC165 {
514     /**
515      * @dev Returns true if this contract implements the interface defined by
516      * `interfaceId`. See the corresponding
517      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
518      * to learn more about how these ids are created.
519      *
520      * This function call must use less than 30 000 gas.
521      */
522     function supportsInterface(bytes4 interfaceId) external view returns (bool);
523 }
524 
525 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
526 
527 
528 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Interface for the NFT Royalty Standard.
535  *
536  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
537  * support for royalty payments across all NFT marketplaces and ecosystem participants.
538  *
539  * _Available since v4.5._
540  */
541 interface IERC2981 is IERC165 {
542     /**
543      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
544      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
545      */
546     function royaltyInfo(uint256 tokenId, uint256 salePrice)
547         external
548         view
549         returns (address receiver, uint256 royaltyAmount);
550 }
551 
552 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/common/ERC2981.sol
584 
585 
586 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 
592 /**
593  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
594  *
595  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
596  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
597  *
598  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
599  * fee is specified in basis points by default.
600  *
601  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
602  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
603  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
604  *
605  * _Available since v4.5._
606  */
607 abstract contract ERC2981 is IERC2981, ERC165 {
608     struct RoyaltyInfo {
609         address receiver;
610         uint96 royaltyFraction;
611     }
612 
613     RoyaltyInfo private _defaultRoyaltyInfo;
614     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
615 
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
620         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
621     }
622 
623     /**
624      * @inheritdoc IERC2981
625      */
626     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
627         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
628 
629         if (royalty.receiver == address(0)) {
630             royalty = _defaultRoyaltyInfo;
631         }
632 
633         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
634 
635         return (royalty.receiver, royaltyAmount);
636     }
637 
638     /**
639      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
640      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
641      * override.
642      */
643     function _feeDenominator() internal pure virtual returns (uint96) {
644         return 10000;
645     }
646 
647     /**
648      * @dev Sets the royalty information that all ids in this contract will default to.
649      *
650      * Requirements:
651      *
652      * - `receiver` cannot be the zero address.
653      * - `feeNumerator` cannot be greater than the fee denominator.
654      */
655     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
656         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
657         require(receiver != address(0), "ERC2981: invalid receiver");
658 
659         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
660     }
661 
662     /**
663      * @dev Removes default royalty information.
664      */
665     function _deleteDefaultRoyalty() internal virtual {
666         delete _defaultRoyaltyInfo;
667     }
668 
669     /**
670      * @dev Sets the royalty information for a specific token id, overriding the global default.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must be already minted.
675      * - `receiver` cannot be the zero address.
676      * - `feeNumerator` cannot be greater than the fee denominator.
677      */
678     function _setTokenRoyalty(
679         uint256 tokenId,
680         address receiver,
681         uint96 feeNumerator
682     ) internal virtual {
683         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
684         require(receiver != address(0), "ERC2981: Invalid parameters");
685 
686         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
687     }
688 
689     /**
690      * @dev Resets royalty information for the token id back to the global default.
691      */
692     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
693         delete _tokenRoyaltyInfo[tokenId];
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Required interface of an ERC721 compliant contract.
707  */
708 interface IERC721 is IERC165 {
709     /**
710      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
711      */
712     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
713 
714     /**
715      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
716      */
717     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
718 
719     /**
720      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
721      */
722     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
723 
724     /**
725      * @dev Returns the number of tokens in ``owner``'s account.
726      */
727     function balanceOf(address owner) external view returns (uint256 balance);
728 
729     /**
730      * @dev Returns the owner of the `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function ownerOf(uint256 tokenId) external view returns (address owner);
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes calldata data
756     ) external;
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
760      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) external;
777 
778     /**
779      * @dev Transfers `tokenId` token from `from` to `to`.
780      *
781      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must be owned by `from`.
788      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
789      *
790      * Emits a {Transfer} event.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) external;
797 
798     /**
799      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
800      * The approval is cleared when the token is transferred.
801      *
802      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
803      *
804      * Requirements:
805      *
806      * - The caller must own the token or be an approved operator.
807      * - `tokenId` must exist.
808      *
809      * Emits an {Approval} event.
810      */
811     function approve(address to, uint256 tokenId) external;
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
816      *
817      * Requirements:
818      *
819      * - The `operator` cannot be the caller.
820      *
821      * Emits an {ApprovalForAll} event.
822      */
823     function setApprovalForAll(address operator, bool _approved) external;
824 
825     /**
826      * @dev Returns the account approved for `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function getApproved(uint256 tokenId) external view returns (address operator);
833 
834     /**
835      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
836      *
837      * See {setApprovalForAll}
838      */
839     function isApprovedForAll(address owner, address operator) external view returns (bool);
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
843 
844 
845 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
846 
847 pragma solidity ^0.8.0;
848 
849 
850 /**
851  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
852  * @dev See https://eips.ethereum.org/EIPS/eip-721
853  */
854 interface IERC721Metadata is IERC721 {
855     /**
856      * @dev Returns the token collection name.
857      */
858     function name() external view returns (string memory);
859 
860     /**
861      * @dev Returns the token collection symbol.
862      */
863     function symbol() external view returns (string memory);
864 
865     /**
866      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
867      */
868     function tokenURI(uint256 tokenId) external view returns (string memory);
869 }
870 
871 // File: erc721a/contracts/ERC721A.sol
872 
873 
874 // Creator: Chiru Labs
875 
876 pragma solidity ^0.8.4;
877 
878 
879 
880 
881 
882 
883 
884 
885 error ApprovalCallerNotOwnerNorApproved();
886 error ApprovalQueryForNonexistentToken();
887 error ApproveToCaller();
888 error ApprovalToCurrentOwner();
889 error BalanceQueryForZeroAddress();
890 error MintToZeroAddress();
891 error MintZeroQuantity();
892 error OwnerQueryForNonexistentToken();
893 error TransferCallerNotOwnerNorApproved();
894 error TransferFromIncorrectOwner();
895 error TransferToNonERC721ReceiverImplementer();
896 error TransferToZeroAddress();
897 error URIQueryForNonexistentToken();
898 
899 /**
900  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
901  * the Metadata extension. Built to optimize for lower gas during batch mints.
902  *
903  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
904  *
905  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
906  *
907  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
908  */
909 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
910     using Address for address;
911     using Strings for uint256;
912 
913     // Compiler will pack this into a single 256bit word.
914     struct TokenOwnership {
915         // The address of the owner.
916         address addr;
917         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
918         uint64 startTimestamp;
919         // Whether the token has been burned.
920         bool burned;
921     }
922 
923     // Compiler will pack this into a single 256bit word.
924     struct AddressData {
925         // Realistically, 2**64-1 is more than enough.
926         uint64 balance;
927         // Keeps track of mint count with minimal overhead for tokenomics.
928         uint64 numberMinted;
929         // Keeps track of burn count with minimal overhead for tokenomics.
930         uint64 numberBurned;
931         // For miscellaneous variable(s) pertaining to the address
932         // (e.g. number of whitelist mint slots used).
933         // If there are multiple variables, please pack them into a uint64.
934         uint64 aux;
935     }
936 
937     // The tokenId of the next token to be minted.
938     uint256 internal _currentIndex;
939 
940     // The number of tokens burned.
941     uint256 internal _burnCounter;
942 
943     // Token name
944     string private _name;
945 
946     // Token symbol
947     string private _symbol;
948 
949     // Mapping from token ID to ownership details
950     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
951     mapping(uint256 => TokenOwnership) internal _ownerships;
952 
953     // Mapping owner address to address data
954     mapping(address => AddressData) private _addressData;
955 
956     // Mapping from token ID to approved address
957     mapping(uint256 => address) private _tokenApprovals;
958 
959     // Mapping from owner to operator approvals
960     mapping(address => mapping(address => bool)) private _operatorApprovals;
961 
962     constructor(string memory name_, string memory symbol_) {
963         _name = name_;
964         _symbol = symbol_;
965         _currentIndex = _startTokenId();
966     }
967 
968     /**
969      * To change the starting tokenId, please override this function.
970      */
971     function _startTokenId() internal view virtual returns (uint256) {
972         return 0;
973     }
974 
975     /**
976      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
977      */
978     function totalSupply() public view returns (uint256) {
979         // Counter underflow is impossible as _burnCounter cannot be incremented
980         // more than _currentIndex - _startTokenId() times
981         unchecked {
982             return _currentIndex - _burnCounter - _startTokenId();
983         }
984     }
985 
986     /**
987      * Returns the total amount of tokens minted in the contract.
988      */
989     function _totalMinted() internal view returns (uint256) {
990         // Counter underflow is impossible as _currentIndex does not decrement,
991         // and it is initialized to _startTokenId()
992         unchecked {
993             return _currentIndex - _startTokenId();
994         }
995     }
996 
997     /**
998      * @dev See {IERC165-supportsInterface}.
999      */
1000     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1001         return
1002             interfaceId == type(IERC721).interfaceId ||
1003             interfaceId == type(IERC721Metadata).interfaceId ||
1004             super.supportsInterface(interfaceId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-balanceOf}.
1009      */
1010     function balanceOf(address owner) public view override returns (uint256) {
1011         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1012         return uint256(_addressData[owner].balance);
1013     }
1014 
1015     /**
1016      * Returns the number of tokens minted by `owner`.
1017      */
1018     function _numberMinted(address owner) internal view returns (uint256) {
1019         return uint256(_addressData[owner].numberMinted);
1020     }
1021 
1022     /**
1023      * Returns the number of tokens burned by or on behalf of `owner`.
1024      */
1025     function _numberBurned(address owner) internal view returns (uint256) {
1026         return uint256(_addressData[owner].numberBurned);
1027     }
1028 
1029     /**
1030      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1031      */
1032     function _getAux(address owner) internal view returns (uint64) {
1033         return _addressData[owner].aux;
1034     }
1035 
1036     /**
1037      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1038      * If there are multiple variables, please pack them into a uint64.
1039      */
1040     function _setAux(address owner, uint64 aux) internal {
1041         _addressData[owner].aux = aux;
1042     }
1043 
1044     /**
1045      * Gas spent here starts off proportional to the maximum mint batch size.
1046      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1047      */
1048     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1049         uint256 curr = tokenId;
1050 
1051         unchecked {
1052             if (_startTokenId() <= curr && curr < _currentIndex) {
1053                 TokenOwnership memory ownership = _ownerships[curr];
1054                 if (!ownership.burned) {
1055                     if (ownership.addr != address(0)) {
1056                         return ownership;
1057                     }
1058                     // Invariant:
1059                     // There will always be an ownership that has an address and is not burned
1060                     // before an ownership that does not have an address and is not burned.
1061                     // Hence, curr will not underflow.
1062                     while (true) {
1063                         curr--;
1064                         ownership = _ownerships[curr];
1065                         if (ownership.addr != address(0)) {
1066                             return ownership;
1067                         }
1068                     }
1069                 }
1070             }
1071         }
1072         revert OwnerQueryForNonexistentToken();
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-ownerOf}.
1077      */
1078     function ownerOf(uint256 tokenId) public view override returns (address) {
1079         return _ownershipOf(tokenId).addr;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-name}.
1084      */
1085     function name() public view virtual override returns (string memory) {
1086         return _name;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-symbol}.
1091      */
1092     function symbol() public view virtual override returns (string memory) {
1093         return _symbol;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-tokenURI}.
1098      */
1099     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1100         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1101 
1102         string memory baseURI = _baseURI();
1103         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1104     }
1105 
1106     /**
1107      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1108      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1109      * by default, can be overriden in child contracts.
1110      */
1111     function _baseURI() internal view virtual returns (string memory) {
1112         return '';
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public override {
1119         address owner = ERC721A.ownerOf(tokenId);
1120         if (to == owner) revert ApprovalToCurrentOwner();
1121 
1122         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1123             revert ApprovalCallerNotOwnerNorApproved();
1124         }
1125 
1126         _approve(to, tokenId, owner);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view override returns (address) {
1133         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public virtual override {
1142         if (operator == _msgSender()) revert ApproveToCaller();
1143 
1144         _operatorApprovals[_msgSender()][operator] = approved;
1145         emit ApprovalForAll(_msgSender(), operator, approved);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-isApprovedForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-transferFrom}.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) public virtual override {
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         safeTransferFrom(from, to, tokenId, '');
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         _transfer(from, to, tokenId);
1187         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1188             revert TransferToNonERC721ReceiverImplementer();
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns whether `tokenId` exists.
1194      *
1195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1196      *
1197      * Tokens start existing when they are minted (`_mint`),
1198      */
1199     function _exists(uint256 tokenId) internal view returns (bool) {
1200         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1201     }
1202 
1203     function _safeMint(address to, uint256 quantity) internal {
1204         _safeMint(to, quantity, '');
1205     }
1206 
1207     /**
1208      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1213      * - `quantity` must be greater than 0.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _safeMint(
1218         address to,
1219         uint256 quantity,
1220         bytes memory _data
1221     ) internal {
1222         _mint(to, quantity, _data, true);
1223     }
1224 
1225     /**
1226      * @dev Mints `quantity` tokens and transfers them to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - `to` cannot be the zero address.
1231      * - `quantity` must be greater than 0.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _mint(
1236         address to,
1237         uint256 quantity,
1238         bytes memory _data,
1239         bool safe
1240     ) internal {
1241         uint256 startTokenId = _currentIndex;
1242         if (to == address(0)) revert MintToZeroAddress();
1243         if (quantity == 0) revert MintZeroQuantity();
1244 
1245         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1246 
1247         // Overflows are incredibly unrealistic.
1248         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1249         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1250         unchecked {
1251             _addressData[to].balance += uint64(quantity);
1252             _addressData[to].numberMinted += uint64(quantity);
1253 
1254             _ownerships[startTokenId].addr = to;
1255             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1256 
1257             uint256 updatedIndex = startTokenId;
1258             uint256 end = updatedIndex + quantity;
1259 
1260             if (safe && to.isContract()) {
1261                 do {
1262                     emit Transfer(address(0), to, updatedIndex);
1263                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1264                         revert TransferToNonERC721ReceiverImplementer();
1265                     }
1266                 } while (updatedIndex != end);
1267                 // Reentrancy protection
1268                 if (_currentIndex != startTokenId) revert();
1269             } else {
1270                 do {
1271                     emit Transfer(address(0), to, updatedIndex++);
1272                 } while (updatedIndex != end);
1273             }
1274             _currentIndex = updatedIndex;
1275         }
1276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *
1282      * Requirements:
1283      *
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must be owned by `from`.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _transfer(
1290         address from,
1291         address to,
1292         uint256 tokenId
1293     ) private {
1294         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1295 
1296         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1297 
1298         bool isApprovedOrOwner = (_msgSender() == from ||
1299             isApprovedForAll(from, _msgSender()) ||
1300             getApproved(tokenId) == _msgSender());
1301 
1302         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1303         if (to == address(0)) revert TransferToZeroAddress();
1304 
1305         _beforeTokenTransfers(from, to, tokenId, 1);
1306 
1307         // Clear approvals from the previous owner
1308         _approve(address(0), tokenId, from);
1309 
1310         // Underflow of the sender's balance is impossible because we check for
1311         // ownership above and the recipient's balance can't realistically overflow.
1312         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1313         unchecked {
1314             _addressData[from].balance -= 1;
1315             _addressData[to].balance += 1;
1316 
1317             TokenOwnership storage currSlot = _ownerships[tokenId];
1318             currSlot.addr = to;
1319             currSlot.startTimestamp = uint64(block.timestamp);
1320 
1321             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1322             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1323             uint256 nextTokenId = tokenId + 1;
1324             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1325             if (nextSlot.addr == address(0)) {
1326                 // This will suffice for checking _exists(nextTokenId),
1327                 // as a burned slot cannot contain the zero address.
1328                 if (nextTokenId != _currentIndex) {
1329                     nextSlot.addr = from;
1330                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1331                 }
1332             }
1333         }
1334 
1335         emit Transfer(from, to, tokenId);
1336         _afterTokenTransfers(from, to, tokenId, 1);
1337     }
1338 
1339     /**
1340      * @dev This is equivalent to _burn(tokenId, false)
1341      */
1342     function _burn(uint256 tokenId) internal virtual {
1343         _burn(tokenId, false);
1344     }
1345 
1346     /**
1347      * @dev Destroys `tokenId`.
1348      * The approval is cleared when the token is burned.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1357         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1358 
1359         address from = prevOwnership.addr;
1360 
1361         if (approvalCheck) {
1362             bool isApprovedOrOwner = (_msgSender() == from ||
1363                 isApprovedForAll(from, _msgSender()) ||
1364                 getApproved(tokenId) == _msgSender());
1365 
1366             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1367         }
1368 
1369         _beforeTokenTransfers(from, address(0), tokenId, 1);
1370 
1371         // Clear approvals from the previous owner
1372         _approve(address(0), tokenId, from);
1373 
1374         // Underflow of the sender's balance is impossible because we check for
1375         // ownership above and the recipient's balance can't realistically overflow.
1376         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1377         unchecked {
1378             AddressData storage addressData = _addressData[from];
1379             addressData.balance -= 1;
1380             addressData.numberBurned += 1;
1381 
1382             // Keep track of who burned the token, and the timestamp of burning.
1383             TokenOwnership storage currSlot = _ownerships[tokenId];
1384             currSlot.addr = from;
1385             currSlot.startTimestamp = uint64(block.timestamp);
1386             currSlot.burned = true;
1387 
1388             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1389             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1390             uint256 nextTokenId = tokenId + 1;
1391             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1392             if (nextSlot.addr == address(0)) {
1393                 // This will suffice for checking _exists(nextTokenId),
1394                 // as a burned slot cannot contain the zero address.
1395                 if (nextTokenId != _currentIndex) {
1396                     nextSlot.addr = from;
1397                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1398                 }
1399             }
1400         }
1401 
1402         emit Transfer(from, address(0), tokenId);
1403         _afterTokenTransfers(from, address(0), tokenId, 1);
1404 
1405         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1406         unchecked {
1407             _burnCounter++;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Approve `to` to operate on `tokenId`
1413      *
1414      * Emits a {Approval} event.
1415      */
1416     function _approve(
1417         address to,
1418         uint256 tokenId,
1419         address owner
1420     ) private {
1421         _tokenApprovals[tokenId] = to;
1422         emit Approval(owner, to, tokenId);
1423     }
1424 
1425     /**
1426      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1427      *
1428      * @param from address representing the previous owner of the given token ID
1429      * @param to target address that will receive the tokens
1430      * @param tokenId uint256 ID of the token to be transferred
1431      * @param _data bytes optional data to send along with the call
1432      * @return bool whether the call correctly returned the expected magic value
1433      */
1434     function _checkContractOnERC721Received(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) private returns (bool) {
1440         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1441             return retval == IERC721Receiver(to).onERC721Received.selector;
1442         } catch (bytes memory reason) {
1443             if (reason.length == 0) {
1444                 revert TransferToNonERC721ReceiverImplementer();
1445             } else {
1446                 assembly {
1447                     revert(add(32, reason), mload(reason))
1448                 }
1449             }
1450         }
1451     }
1452 
1453     /**
1454      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1455      * And also called before burning one token.
1456      *
1457      * startTokenId - the first token id to be transferred
1458      * quantity - the amount to be transferred
1459      *
1460      * Calling conditions:
1461      *
1462      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1463      * transferred to `to`.
1464      * - When `from` is zero, `tokenId` will be minted for `to`.
1465      * - When `to` is zero, `tokenId` will be burned by `from`.
1466      * - `from` and `to` are never both zero.
1467      */
1468     function _beforeTokenTransfers(
1469         address from,
1470         address to,
1471         uint256 startTokenId,
1472         uint256 quantity
1473     ) internal virtual {}
1474 
1475     /**
1476      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1477      * minting.
1478      * And also called after one token has been burned.
1479      *
1480      * startTokenId - the first token id to be transferred
1481      * quantity - the amount to be transferred
1482      *
1483      * Calling conditions:
1484      *
1485      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1486      * transferred to `to`.
1487      * - When `from` is zero, `tokenId` has been minted for `to`.
1488      * - When `to` is zero, `tokenId` has been burned by `from`.
1489      * - `from` and `to` are never both zero.
1490      */
1491     function _afterTokenTransfers(
1492         address from,
1493         address to,
1494         uint256 startTokenId,
1495         uint256 quantity
1496     ) internal virtual {}
1497 }
1498 
1499 // File: contracts/NFT.sol
1500 
1501 
1502 pragma solidity ^0.8.4;
1503 
1504 
1505 
1506 
1507 
1508 
1509 contract bullyapes is ERC721A, ERC2981, Ownable, ReentrancyGuard {
1510     using Strings for uint256;
1511     uint256 public constant maxSupply = 5555; //total NFTs available
1512     address public royaltyAddress = 0xca77410c4cFe7162971fD3a6f37a64e72615EeAE; //need to update before deploying
1513     uint96 public royaltyFee = 1000; //10% royalty
1514     string public _baseTokenURI = "ipfs://QmVPyA6TfyqX94m7y4u159ka7vbiShB3UXVCZSydMpKUrc/"; // IPFS link
1515     string public _baseTokenEXT = ".json"; 
1516    
1517     constructor() ERC721A("BULLY' APES", "BULLY") {
1518          _setDefaultRoyalty(royaltyAddress, royaltyFee); 
1519     }
1520     
1521     /**
1522      * @notice Mint tokens - owner only 
1523      */
1524     function mint(uint256 _mintAmount) external payable {
1525         uint256 supply = totalSupply();
1526         require(supply + _mintAmount <= maxSupply , "Exceeds max supply");
1527         _safeMint(msg.sender, _mintAmount);
1528     }
1529      
1530     function _baseURI() internal view virtual override returns (string memory) {
1531         return _baseTokenURI;
1532     }
1533     
1534     /**
1535      * @notice Obtains metadata url for token
1536      */
1537    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1538         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1539             string memory currentBaseURI = _baseURI();
1540             return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),_baseTokenEXT)) : "";
1541         
1542     }
1543     /**
1544      * @notice Updates the metadata url
1545      */
1546     function changeURLParams(string memory _nURL, string memory _nBaseExt) external onlyOwner {
1547         _baseTokenURI = _nURL;
1548         _baseTokenEXT = _nBaseExt;
1549         emit baseTokenURI (_nURL, _nBaseExt);
1550     }
1551 
1552     /**
1553      * @notice Mint tokens via airdrop by owner only
1554      */
1555     function gift(address _to, uint256 _mintAmount) external onlyOwner {
1556         uint256 supply = totalSupply();
1557         require(supply + _mintAmount <= maxSupply, "Exceeds Max Supply");
1558         _safeMint(_to, _mintAmount);
1559     }
1560 
1561     /**
1562      * @notice Change the royalty fee for the collection - denominator out of 10000
1563      */
1564     function setRoyaltyFee(uint96 _feeNumerator) external onlyOwner {
1565         royaltyFee = _feeNumerator;
1566         _setDefaultRoyalty(royaltyAddress, royaltyFee);
1567         emit RoyaltyFees(royaltyAddress, royaltyFee);
1568     }
1569 
1570     /**
1571      * @notice Change the royalty address where royalty payouts are sent
1572      */
1573     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
1574         royaltyAddress = _royaltyAddress;
1575         _setDefaultRoyalty(royaltyAddress, royaltyFee);
1576         emit RoyaltyFees(royaltyAddress, royaltyFee);
1577     }
1578     /**
1579      * @notice Withdraw any funds
1580      */
1581     function withdrawFunds() external onlyOwner nonReentrant {
1582         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1583         require(success, "Transfer failed.");
1584     }
1585 
1586     function supportsInterface(bytes4 interfaceId)
1587         public
1588         view
1589         override(ERC721A, ERC2981)
1590         returns (bool)
1591     {
1592         return super.supportsInterface(interfaceId);
1593     }
1594 
1595     /**
1596      * @notice Event listeners
1597      */
1598     event RoyaltyFees(address, uint96);
1599     event baseTokenURI (string, string);
1600     event Received (address, uint256);
1601     
1602      /**
1603      * @notice Allow external funds
1604      */
1605     receive() external payable {
1606         emit Received(msg.sender,msg.value);
1607         }
1608     
1609 
1610 
1611 }