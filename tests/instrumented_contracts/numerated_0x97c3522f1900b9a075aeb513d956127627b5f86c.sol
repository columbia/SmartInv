1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/security/Pausable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which allows children to implement an emergency stop
186  * mechanism that can be triggered by an authorized account.
187  *
188  * This module is used through inheritance. It will make available the
189  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
190  * the functions of your contract. Note that they will not be pausable by
191  * simply including this module, only once the modifiers are put in place.
192  */
193 abstract contract Pausable is Context {
194     /**
195      * @dev Emitted when the pause is triggered by `account`.
196      */
197     event Paused(address account);
198 
199     /**
200      * @dev Emitted when the pause is lifted by `account`.
201      */
202     event Unpaused(address account);
203 
204     bool private _paused;
205 
206     /**
207      * @dev Initializes the contract in unpaused state.
208      */
209     constructor() {
210         _paused = false;
211     }
212 
213     /**
214      * @dev Returns true if the contract is paused, and false otherwise.
215      */
216     function paused() public view virtual returns (bool) {
217         return _paused;
218     }
219 
220     /**
221      * @dev Modifier to make a function callable only when the contract is not paused.
222      *
223      * Requirements:
224      *
225      * - The contract must not be paused.
226      */
227     modifier whenNotPaused() {
228         require(!paused(), "Pausable: paused");
229         _;
230     }
231 
232     /**
233      * @dev Modifier to make a function callable only when the contract is paused.
234      *
235      * Requirements:
236      *
237      * - The contract must be paused.
238      */
239     modifier whenPaused() {
240         require(paused(), "Pausable: not paused");
241         _;
242     }
243 
244     /**
245      * @dev Triggers stopped state.
246      *
247      * Requirements:
248      *
249      * - The contract must not be paused.
250      */
251     function _pause() internal virtual whenNotPaused {
252         _paused = true;
253         emit Paused(_msgSender());
254     }
255 
256     /**
257      * @dev Returns to normal state.
258      *
259      * Requirements:
260      *
261      * - The contract must be paused.
262      */
263     function _unpause() internal virtual whenPaused {
264         _paused = false;
265         emit Unpaused(_msgSender());
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
273 
274 pragma solidity ^0.8.1;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      *
297      * [IMPORTANT]
298      * ====
299      * You shouldn't rely on `isContract` to protect against flash loan attacks!
300      *
301      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
302      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
303      * constructor.
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize/address.code.length, which returns 0
308         // for contracts in construction, since the code is only stored at the end
309         // of the constructor execution.
310 
311         return account.code.length > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC721 token receiver interface
503  * @dev Interface for any contract that wants to support safeTransfers
504  * from ERC721 asset contracts.
505  */
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by `operator` from `from`, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Interface of the ERC165 standard, as defined in the
533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
534  *
535  * Implementers can declare support of contract interfaces, which can then be
536  * queried by others ({ERC165Checker}).
537  *
538  * For an implementation, see {ERC165}.
539  */
540 interface IERC165 {
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * `interfaceId`. See the corresponding
544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30 000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Interface for the NFT Royalty Standard.
562  *
563  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
564  * support for royalty payments across all NFT marketplaces and ecosystem participants.
565  *
566  * _Available since v4.5._
567  */
568 interface IERC2981 is IERC165 {
569     /**
570      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
571      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
572      */
573     function royaltyInfo(uint256 tokenId, uint256 salePrice)
574         external
575         view
576         returns (address receiver, uint256 royaltyAmount);
577 }
578 
579 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
610 // File: @openzeppelin/contracts/token/common/ERC2981.sol
611 
612 
613 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 
619 /**
620  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
621  *
622  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
623  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
624  *
625  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
626  * fee is specified in basis points by default.
627  *
628  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
629  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
630  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
631  *
632  * _Available since v4.5._
633  */
634 abstract contract ERC2981 is IERC2981, ERC165 {
635     struct RoyaltyInfo {
636         address receiver;
637         uint96 royaltyFraction;
638     }
639 
640     RoyaltyInfo private _defaultRoyaltyInfo;
641     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
642 
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
647         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
648     }
649 
650     /**
651      * @inheritdoc IERC2981
652      */
653     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
654         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
655 
656         if (royalty.receiver == address(0)) {
657             royalty = _defaultRoyaltyInfo;
658         }
659 
660         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
661 
662         return (royalty.receiver, royaltyAmount);
663     }
664 
665     /**
666      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
667      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
668      * override.
669      */
670     function _feeDenominator() internal pure virtual returns (uint96) {
671         return 10000;
672     }
673 
674     /**
675      * @dev Sets the royalty information that all ids in this contract will default to.
676      *
677      * Requirements:
678      *
679      * - `receiver` cannot be the zero address.
680      * - `feeNumerator` cannot be greater than the fee denominator.
681      */
682     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
683         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
684         require(receiver != address(0), "ERC2981: invalid receiver");
685 
686         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
687     }
688 
689     /**
690      * @dev Removes default royalty information.
691      */
692     function _deleteDefaultRoyalty() internal virtual {
693         delete _defaultRoyaltyInfo;
694     }
695 
696     /**
697      * @dev Sets the royalty information for a specific token id, overriding the global default.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must be already minted.
702      * - `receiver` cannot be the zero address.
703      * - `feeNumerator` cannot be greater than the fee denominator.
704      */
705     function _setTokenRoyalty(
706         uint256 tokenId,
707         address receiver,
708         uint96 feeNumerator
709     ) internal virtual {
710         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
711         require(receiver != address(0), "ERC2981: Invalid parameters");
712 
713         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
714     }
715 
716     /**
717      * @dev Resets royalty information for the token id back to the global default.
718      */
719     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
720         delete _tokenRoyaltyInfo[tokenId];
721     }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Required interface of an ERC721 compliant contract.
734  */
735 interface IERC721 is IERC165 {
736     /**
737      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
740 
741     /**
742      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
743      */
744     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
748      */
749     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
750 
751     /**
752      * @dev Returns the number of tokens in ``owner``'s account.
753      */
754     function balanceOf(address owner) external view returns (uint256 balance);
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) external view returns (address owner);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns the account approved for `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function getApproved(uint256 tokenId) external view returns (address operator);
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Enumerable is IERC721 {
882     /**
883      * @dev Returns the total amount of tokens stored by the contract.
884      */
885     function totalSupply() external view returns (uint256);
886 
887     /**
888      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
889      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
890      */
891     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
895      * Use along with {totalSupply} to enumerate all tokens.
896      */
897     function tokenByIndex(uint256 index) external view returns (uint256);
898 }
899 
900 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
910  * @dev See https://eips.ethereum.org/EIPS/eip-721
911  */
912 interface IERC721Metadata is IERC721 {
913     /**
914      * @dev Returns the token collection name.
915      */
916     function name() external view returns (string memory);
917 
918     /**
919      * @dev Returns the token collection symbol.
920      */
921     function symbol() external view returns (string memory);
922 
923     /**
924      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
925      */
926     function tokenURI(uint256 tokenId) external view returns (string memory);
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
930 
931 
932 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 
942 
943 /**
944  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
945  * the Metadata extension, but not including the Enumerable extension, which is available separately as
946  * {ERC721Enumerable}.
947  */
948 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
949     using Address for address;
950     using Strings for uint256;
951 
952     // Token name
953     string private _name;
954 
955     // Token symbol
956     string private _symbol;
957 
958     // Mapping from token ID to owner address
959     mapping(uint256 => address) private _owners;
960 
961     // Mapping owner address to token count
962     mapping(address => uint256) private _balances;
963 
964     // Mapping from token ID to approved address
965     mapping(uint256 => address) private _tokenApprovals;
966 
967     // Mapping from owner to operator approvals
968     mapping(address => mapping(address => bool)) private _operatorApprovals;
969 
970     /**
971      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
972      */
973     constructor(string memory name_, string memory symbol_) {
974         _name = name_;
975         _symbol = symbol_;
976     }
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
982         return
983             interfaceId == type(IERC721).interfaceId ||
984             interfaceId == type(IERC721Metadata).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view virtual override returns (uint256) {
992         require(owner != address(0), "ERC721: balance query for the zero address");
993         return _balances[owner];
994     }
995 
996     /**
997      * @dev See {IERC721-ownerOf}.
998      */
999     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1000         address owner = _owners[tokenId];
1001         require(owner != address(0), "ERC721: owner query for nonexistent token");
1002         return owner;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-name}.
1007      */
1008     function name() public view virtual override returns (string memory) {
1009         return _name;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-symbol}.
1014      */
1015     function symbol() public view virtual override returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-tokenURI}.
1021      */
1022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1023         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1024 
1025         string memory baseURI = _baseURI();
1026         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overridden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return "";
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public virtual override {
1042         address owner = ERC721.ownerOf(tokenId);
1043         require(to != owner, "ERC721: approval to current owner");
1044 
1045         require(
1046             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1047             "ERC721: approve caller is not owner nor approved for all"
1048         );
1049 
1050         _approve(to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-getApproved}.
1055      */
1056     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1057         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1058 
1059         return _tokenApprovals[tokenId];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-setApprovalForAll}.
1064      */
1065     function setApprovalForAll(address operator, bool approved) public virtual override {
1066         _setApprovalForAll(_msgSender(), operator, approved);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-isApprovedForAll}.
1071      */
1072     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1073         return _operatorApprovals[owner][operator];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-transferFrom}.
1078      */
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         //solhint-disable-next-line max-line-length
1085         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1086 
1087         _transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public virtual override {
1098         safeTransferFrom(from, to, tokenId, "");
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) public virtual override {
1110         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1111         _safeTransfer(from, to, tokenId, _data);
1112     }
1113 
1114     /**
1115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1117      *
1118      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1119      *
1120      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1121      * implement alternative mechanisms to perform token transfer, such as signature-based.
1122      *
1123      * Requirements:
1124      *
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must exist and be owned by `from`.
1128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeTransfer(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) internal virtual {
1138         _transfer(from, to, tokenId);
1139         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1140     }
1141 
1142     /**
1143      * @dev Returns whether `tokenId` exists.
1144      *
1145      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1146      *
1147      * Tokens start existing when they are minted (`_mint`),
1148      * and stop existing when they are burned (`_burn`).
1149      */
1150     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1151         return _owners[tokenId] != address(0);
1152     }
1153 
1154     /**
1155      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      */
1161     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1162         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1163         address owner = ERC721.ownerOf(tokenId);
1164         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1165     }
1166 
1167     /**
1168      * @dev Safely mints `tokenId` and transfers it to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must not exist.
1173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _safeMint(address to, uint256 tokenId) internal virtual {
1178         _safeMint(to, tokenId, "");
1179     }
1180 
1181     /**
1182      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1183      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1184      */
1185     function _safeMint(
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) internal virtual {
1190         _mint(to, tokenId);
1191         require(
1192             _checkOnERC721Received(address(0), to, tokenId, _data),
1193             "ERC721: transfer to non ERC721Receiver implementer"
1194         );
1195     }
1196 
1197     /**
1198      * @dev Mints `tokenId` and transfers it to `to`.
1199      *
1200      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must not exist.
1205      * - `to` cannot be the zero address.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _mint(address to, uint256 tokenId) internal virtual {
1210         require(to != address(0), "ERC721: mint to the zero address");
1211         require(!_exists(tokenId), "ERC721: token already minted");
1212 
1213         _beforeTokenTransfer(address(0), to, tokenId);
1214 
1215         _balances[to] += 1;
1216         _owners[tokenId] = to;
1217 
1218         emit Transfer(address(0), to, tokenId);
1219 
1220         _afterTokenTransfer(address(0), to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         address owner = ERC721.ownerOf(tokenId);
1235 
1236         _beforeTokenTransfer(owner, address(0), tokenId);
1237 
1238         // Clear approvals
1239         _approve(address(0), tokenId);
1240 
1241         _balances[owner] -= 1;
1242         delete _owners[tokenId];
1243 
1244         emit Transfer(owner, address(0), tokenId);
1245 
1246         _afterTokenTransfer(owner, address(0), tokenId);
1247     }
1248 
1249     /**
1250      * @dev Transfers `tokenId` from `from` to `to`.
1251      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1252      *
1253      * Requirements:
1254      *
1255      * - `to` cannot be the zero address.
1256      * - `tokenId` token must be owned by `from`.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _transfer(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) internal virtual {
1265         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1266         require(to != address(0), "ERC721: transfer to the zero address");
1267 
1268         _beforeTokenTransfer(from, to, tokenId);
1269 
1270         // Clear approvals from the previous owner
1271         _approve(address(0), tokenId);
1272 
1273         _balances[from] -= 1;
1274         _balances[to] += 1;
1275         _owners[tokenId] = to;
1276 
1277         emit Transfer(from, to, tokenId);
1278 
1279         _afterTokenTransfer(from, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Approve `to` to operate on `tokenId`
1284      *
1285      * Emits a {Approval} event.
1286      */
1287     function _approve(address to, uint256 tokenId) internal virtual {
1288         _tokenApprovals[tokenId] = to;
1289         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev Approve `operator` to operate on all of `owner` tokens
1294      *
1295      * Emits a {ApprovalForAll} event.
1296      */
1297     function _setApprovalForAll(
1298         address owner,
1299         address operator,
1300         bool approved
1301     ) internal virtual {
1302         require(owner != operator, "ERC721: approve to caller");
1303         _operatorApprovals[owner][operator] = approved;
1304         emit ApprovalForAll(owner, operator, approved);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1309      * The call is not executed if the target address is not a contract.
1310      *
1311      * @param from address representing the previous owner of the given token ID
1312      * @param to target address that will receive the tokens
1313      * @param tokenId uint256 ID of the token to be transferred
1314      * @param _data bytes optional data to send along with the call
1315      * @return bool whether the call correctly returned the expected magic value
1316      */
1317     function _checkOnERC721Received(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) private returns (bool) {
1323         if (to.isContract()) {
1324             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1325                 return retval == IERC721Receiver.onERC721Received.selector;
1326             } catch (bytes memory reason) {
1327                 if (reason.length == 0) {
1328                     revert("ERC721: transfer to non ERC721Receiver implementer");
1329                 } else {
1330                     assembly {
1331                         revert(add(32, reason), mload(reason))
1332                     }
1333                 }
1334             }
1335         } else {
1336             return true;
1337         }
1338     }
1339 
1340     /**
1341      * @dev Hook that is called before any token transfer. This includes minting
1342      * and burning.
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1350      * - `from` and `to` are never both zero.
1351      *
1352      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1353      */
1354     function _beforeTokenTransfer(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after any transfer of tokens. This includes
1362      * minting and burning.
1363      *
1364      * Calling conditions:
1365      *
1366      * - when `from` and `to` are both non-zero.
1367      * - `from` and `to` are never both zero.
1368      *
1369      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1370      */
1371     function _afterTokenTransfer(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) internal virtual {}
1376 }
1377 
1378 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1379 
1380 
1381 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 
1386 
1387 /**
1388  * @title ERC721 Burnable Token
1389  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1390  */
1391 abstract contract ERC721Burnable is Context, ERC721 {
1392     /**
1393      * @dev Burns `tokenId`. See {ERC721-_burn}.
1394      *
1395      * Requirements:
1396      *
1397      * - The caller must own `tokenId` or be an approved operator.
1398      */
1399     function burn(uint256 tokenId) public virtual {
1400         //solhint-disable-next-line max-line-length
1401         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1402         _burn(tokenId);
1403     }
1404 }
1405 
1406 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1407 
1408 
1409 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 
1414 
1415 /**
1416  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1417  * enumerability of all the token ids in the contract as well as all token ids owned by each
1418  * account.
1419  */
1420 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1421     // Mapping from owner to list of owned token IDs
1422     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1423 
1424     // Mapping from token ID to index of the owner tokens list
1425     mapping(uint256 => uint256) private _ownedTokensIndex;
1426 
1427     // Array with all token ids, used for enumeration
1428     uint256[] private _allTokens;
1429 
1430     // Mapping from token id to position in the allTokens array
1431     mapping(uint256 => uint256) private _allTokensIndex;
1432 
1433     /**
1434      * @dev See {IERC165-supportsInterface}.
1435      */
1436     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1437         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1438     }
1439 
1440     /**
1441      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1442      */
1443     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1444         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1445         return _ownedTokens[owner][index];
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Enumerable-totalSupply}.
1450      */
1451     function totalSupply() public view virtual override returns (uint256) {
1452         return _allTokens.length;
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Enumerable-tokenByIndex}.
1457      */
1458     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1459         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1460         return _allTokens[index];
1461     }
1462 
1463     /**
1464      * @dev Hook that is called before any token transfer. This includes minting
1465      * and burning.
1466      *
1467      * Calling conditions:
1468      *
1469      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1470      * transferred to `to`.
1471      * - When `from` is zero, `tokenId` will be minted for `to`.
1472      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1473      * - `from` cannot be the zero address.
1474      * - `to` cannot be the zero address.
1475      *
1476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1477      */
1478     function _beforeTokenTransfer(
1479         address from,
1480         address to,
1481         uint256 tokenId
1482     ) internal virtual override {
1483         super._beforeTokenTransfer(from, to, tokenId);
1484 
1485         if (from == address(0)) {
1486             _addTokenToAllTokensEnumeration(tokenId);
1487         } else if (from != to) {
1488             _removeTokenFromOwnerEnumeration(from, tokenId);
1489         }
1490         if (to == address(0)) {
1491             _removeTokenFromAllTokensEnumeration(tokenId);
1492         } else if (to != from) {
1493             _addTokenToOwnerEnumeration(to, tokenId);
1494         }
1495     }
1496 
1497     /**
1498      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1499      * @param to address representing the new owner of the given token ID
1500      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1501      */
1502     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1503         uint256 length = ERC721.balanceOf(to);
1504         _ownedTokens[to][length] = tokenId;
1505         _ownedTokensIndex[tokenId] = length;
1506     }
1507 
1508     /**
1509      * @dev Private function to add a token to this extension's token tracking data structures.
1510      * @param tokenId uint256 ID of the token to be added to the tokens list
1511      */
1512     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1513         _allTokensIndex[tokenId] = _allTokens.length;
1514         _allTokens.push(tokenId);
1515     }
1516 
1517     /**
1518      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1519      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1520      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1521      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1522      * @param from address representing the previous owner of the given token ID
1523      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1524      */
1525     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1526         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1527         // then delete the last slot (swap and pop).
1528 
1529         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1530         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1531 
1532         // When the token to delete is the last token, the swap operation is unnecessary
1533         if (tokenIndex != lastTokenIndex) {
1534             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1535 
1536             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1537             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1538         }
1539 
1540         // This also deletes the contents at the last position of the array
1541         delete _ownedTokensIndex[tokenId];
1542         delete _ownedTokens[from][lastTokenIndex];
1543     }
1544 
1545     /**
1546      * @dev Private function to remove a token from this extension's token tracking data structures.
1547      * This has O(1) time complexity, but alters the order of the _allTokens array.
1548      * @param tokenId uint256 ID of the token to be removed from the tokens list
1549      */
1550     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1551         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1552         // then delete the last slot (swap and pop).
1553 
1554         uint256 lastTokenIndex = _allTokens.length - 1;
1555         uint256 tokenIndex = _allTokensIndex[tokenId];
1556 
1557         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1558         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1559         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1560         uint256 lastTokenId = _allTokens[lastTokenIndex];
1561 
1562         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1563         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1564 
1565         // This also deletes the contents at the last position of the array
1566         delete _allTokensIndex[tokenId];
1567         _allTokens.pop();
1568     }
1569 }
1570 
1571 // File: MergeBird.sol
1572 
1573 
1574 pragma solidity ^0.8.4;
1575 
1576 
1577 
1578 
1579 
1580 
1581 
1582 contract MergeBird is
1583     ERC2981,
1584     ERC721,
1585     ERC721Enumerable,
1586     Pausable,
1587     Ownable,
1588     ERC721Burnable
1589 {
1590     constructor() ERC721("MergeBird", "MERGEBIRD") {}
1591 
1592     function _baseURI() internal pure override returns (string memory) {
1593         return "https://meta.game.space/token/";
1594     }
1595 
1596     function pause() public onlyOwner {
1597         _pause();
1598     }
1599 
1600     function unpause() public onlyOwner {
1601         _unpause();
1602     }
1603 
1604     function safeMint(address to, uint256 tokenId) public onlyOwner {
1605         _safeMint(to, tokenId);
1606     }
1607 
1608     function _beforeTokenTransfer(
1609         address from,
1610         address to,
1611         uint256 tokenId
1612     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1613         super._beforeTokenTransfer(from, to, tokenId);
1614     }
1615 
1616     function setDefaultRoyalty(address receiver, uint96 feeNumerator)
1617         public
1618         onlyOwner
1619     {
1620         _setDefaultRoyalty(receiver, feeNumerator);
1621     }
1622 
1623     function setTokenRoyalty(
1624         uint256 tokenId,
1625         address receiver,
1626         uint96 feeNumerator
1627     ) public onlyOwner {
1628         _setTokenRoyalty(tokenId, receiver, feeNumerator);
1629     }
1630 
1631     function supportsInterface(bytes4 interfaceId)
1632         public
1633         view
1634         override(ERC721, ERC721Enumerable, ERC2981)
1635         returns (bool)
1636     {
1637         return
1638             interfaceId == type(ERC2981).interfaceId ||
1639             super.supportsInterface(interfaceId);
1640     }
1641 }