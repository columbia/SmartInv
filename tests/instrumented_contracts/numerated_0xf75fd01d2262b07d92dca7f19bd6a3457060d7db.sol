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
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60     uint8 private constant _ADDRESS_LENGTH = 20;
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 
118     /**
119      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
120      */
121     function toHexString(address addr) internal pure returns (string memory) {
122         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/access/Ownable.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         _checkOwner();
190         _;
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if the sender is not the owner.
202      */
203     function _checkOwner() internal view virtual {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _transferOwnership(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _transferOwnership(newOwner);
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Internal function without access restriction.
230      */
231     function _transferOwnership(address newOwner) internal virtual {
232         address oldOwner = _owner;
233         _owner = newOwner;
234         emit OwnershipTransferred(oldOwner, newOwner);
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
242 
243 pragma solidity ^0.8.1;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451                 /// @solidity memory-safe-assembly
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC721 token receiver interface
472  * @dev Interface for any contract that wants to support safeTransfers
473  * from ERC721 asset contracts.
474  */
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
522 
523 
524 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Interface for the NFT Royalty Standard.
531  *
532  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
533  * support for royalty payments across all NFT marketplaces and ecosystem participants.
534  *
535  * _Available since v4.5._
536  */
537 interface IERC2981 is IERC165 {
538     /**
539      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
540      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
541      */
542     function royaltyInfo(uint256 tokenId, uint256 salePrice)
543         external
544         view
545         returns (address receiver, uint256 royaltyAmount);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/common/ERC2981.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 
588 /**
589  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
590  *
591  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
592  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
593  *
594  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
595  * fee is specified in basis points by default.
596  *
597  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
598  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
599  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
600  *
601  * _Available since v4.5._
602  */
603 abstract contract ERC2981 is IERC2981, ERC165 {
604     struct RoyaltyInfo {
605         address receiver;
606         uint96 royaltyFraction;
607     }
608 
609     RoyaltyInfo private _defaultRoyaltyInfo;
610     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
611 
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
616         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
617     }
618 
619     /**
620      * @inheritdoc IERC2981
621      */
622     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
623         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
624 
625         if (royalty.receiver == address(0)) {
626             royalty = _defaultRoyaltyInfo;
627         }
628 
629         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
630 
631         return (royalty.receiver, royaltyAmount);
632     }
633 
634     /**
635      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
636      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
637      * override.
638      */
639     function _feeDenominator() internal pure virtual returns (uint96) {
640         return 10000;
641     }
642 
643     /**
644      * @dev Sets the royalty information that all ids in this contract will default to.
645      *
646      * Requirements:
647      *
648      * - `receiver` cannot be the zero address.
649      * - `feeNumerator` cannot be greater than the fee denominator.
650      */
651     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
652         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
653         require(receiver != address(0), "ERC2981: invalid receiver");
654 
655         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
656     }
657 
658     /**
659      * @dev Removes default royalty information.
660      */
661     function _deleteDefaultRoyalty() internal virtual {
662         delete _defaultRoyaltyInfo;
663     }
664 
665     /**
666      * @dev Sets the royalty information for a specific token id, overriding the global default.
667      *
668      * Requirements:
669      *
670      * - `receiver` cannot be the zero address.
671      * - `feeNumerator` cannot be greater than the fee denominator.
672      */
673     function _setTokenRoyalty(
674         uint256 tokenId,
675         address receiver,
676         uint96 feeNumerator
677     ) internal virtual {
678         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
679         require(receiver != address(0), "ERC2981: Invalid parameters");
680 
681         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
682     }
683 
684     /**
685      * @dev Resets royalty information for the token id back to the global default.
686      */
687     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
688         delete _tokenRoyaltyInfo[tokenId];
689     }
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @dev Required interface of an ERC721 compliant contract.
702  */
703 interface IERC721 is IERC165 {
704     /**
705      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
706      */
707     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
708 
709     /**
710      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
711      */
712     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
713 
714     /**
715      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
716      */
717     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
718 
719     /**
720      * @dev Returns the number of tokens in ``owner``'s account.
721      */
722     function balanceOf(address owner) external view returns (uint256 balance);
723 
724     /**
725      * @dev Returns the owner of the `tokenId` token.
726      *
727      * Requirements:
728      *
729      * - `tokenId` must exist.
730      */
731     function ownerOf(uint256 tokenId) external view returns (address owner);
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external;
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) external;
772 
773     /**
774      * @dev Transfers `tokenId` token from `from` to `to`.
775      *
776      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must be owned by `from`.
783      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
784      *
785      * Emits a {Transfer} event.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) external;
792 
793     /**
794      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
795      * The approval is cleared when the token is transferred.
796      *
797      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
798      *
799      * Requirements:
800      *
801      * - The caller must own the token or be an approved operator.
802      * - `tokenId` must exist.
803      *
804      * Emits an {Approval} event.
805      */
806     function approve(address to, uint256 tokenId) external;
807 
808     /**
809      * @dev Approve or remove `operator` as an operator for the caller.
810      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
811      *
812      * Requirements:
813      *
814      * - The `operator` cannot be the caller.
815      *
816      * Emits an {ApprovalForAll} event.
817      */
818     function setApprovalForAll(address operator, bool _approved) external;
819 
820     /**
821      * @dev Returns the account approved for `tokenId` token.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      */
827     function getApproved(uint256 tokenId) external view returns (address operator);
828 
829     /**
830      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
831      *
832      * See {setApprovalForAll}
833      */
834     function isApprovedForAll(address owner, address operator) external view returns (bool);
835 }
836 
837 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 
845 /**
846  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
847  * @dev See https://eips.ethereum.org/EIPS/eip-721
848  */
849 interface IERC721Metadata is IERC721 {
850     /**
851      * @dev Returns the token collection name.
852      */
853     function name() external view returns (string memory);
854 
855     /**
856      * @dev Returns the token collection symbol.
857      */
858     function symbol() external view returns (string memory);
859 
860     /**
861      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
862      */
863     function tokenURI(uint256 tokenId) external view returns (string memory);
864 }
865 
866 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
867 
868 
869 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 
875 
876 
877 
878 
879 
880 /**
881  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
882  * the Metadata extension, but not including the Enumerable extension, which is available separately as
883  * {ERC721Enumerable}.
884  */
885 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
886     using Address for address;
887     using Strings for uint256;
888 
889     // Token name
890     string private _name;
891 
892     // Token symbol
893     string private _symbol;
894 
895     // Mapping from token ID to owner address
896     mapping(uint256 => address) private _owners;
897 
898     // Mapping owner address to token count
899     mapping(address => uint256) private _balances;
900 
901     // Mapping from token ID to approved address
902     mapping(uint256 => address) private _tokenApprovals;
903 
904     // Mapping from owner to operator approvals
905     mapping(address => mapping(address => bool)) private _operatorApprovals;
906 
907     /**
908      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
909      */
910     constructor(string memory name_, string memory symbol_) {
911         _name = name_;
912         _symbol = symbol_;
913     }
914 
915     /**
916      * @dev See {IERC165-supportsInterface}.
917      */
918     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
919         return
920             interfaceId == type(IERC721).interfaceId ||
921             interfaceId == type(IERC721Metadata).interfaceId ||
922             super.supportsInterface(interfaceId);
923     }
924 
925     /**
926      * @dev See {IERC721-balanceOf}.
927      */
928     function balanceOf(address owner) public view virtual override returns (uint256) {
929         require(owner != address(0), "ERC721: address zero is not a valid owner");
930         return _balances[owner];
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
937         address owner = _owners[tokenId];
938         require(owner != address(0), "ERC721: invalid token ID");
939         return owner;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         _requireMinted(tokenId);
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overridden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return "";
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public virtual override {
979         address owner = ERC721.ownerOf(tokenId);
980         require(to != owner, "ERC721: approval to current owner");
981 
982         require(
983             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984             "ERC721: approve caller is not token owner nor approved for all"
985         );
986 
987         _approve(to, tokenId);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view virtual override returns (address) {
994         _requireMinted(tokenId);
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public virtual override {
1003         _setApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         //solhint-disable-next-line max-line-length
1022         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1023 
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, "");
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory data
1046     ) public virtual override {
1047         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1048         _safeTransfer(from, to, tokenId, data);
1049     }
1050 
1051     /**
1052      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1053      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1054      *
1055      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1056      *
1057      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1058      * implement alternative mechanisms to perform token transfer, such as signature-based.
1059      *
1060      * Requirements:
1061      *
1062      * - `from` cannot be the zero address.
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must exist and be owned by `from`.
1065      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeTransfer(
1070         address from,
1071         address to,
1072         uint256 tokenId,
1073         bytes memory data
1074     ) internal virtual {
1075         _transfer(from, to, tokenId);
1076         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1077     }
1078 
1079     /**
1080      * @dev Returns whether `tokenId` exists.
1081      *
1082      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1083      *
1084      * Tokens start existing when they are minted (`_mint`),
1085      * and stop existing when they are burned (`_burn`).
1086      */
1087     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1088         return _owners[tokenId] != address(0);
1089     }
1090 
1091     /**
1092      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1093      *
1094      * Requirements:
1095      *
1096      * - `tokenId` must exist.
1097      */
1098     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1099         address owner = ERC721.ownerOf(tokenId);
1100         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1101     }
1102 
1103     /**
1104      * @dev Safely mints `tokenId` and transfers it to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must not exist.
1109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _safeMint(address to, uint256 tokenId) internal virtual {
1114         _safeMint(to, tokenId, "");
1115     }
1116 
1117     /**
1118      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1119      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1120      */
1121     function _safeMint(
1122         address to,
1123         uint256 tokenId,
1124         bytes memory data
1125     ) internal virtual {
1126         _mint(to, tokenId);
1127         require(
1128             _checkOnERC721Received(address(0), to, tokenId, data),
1129             "ERC721: transfer to non ERC721Receiver implementer"
1130         );
1131     }
1132 
1133     /**
1134      * @dev Mints `tokenId` and transfers it to `to`.
1135      *
1136      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must not exist.
1141      * - `to` cannot be the zero address.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _mint(address to, uint256 tokenId) internal virtual {
1146         require(to != address(0), "ERC721: mint to the zero address");
1147         require(!_exists(tokenId), "ERC721: token already minted");
1148 
1149         _beforeTokenTransfer(address(0), to, tokenId);
1150 
1151         _balances[to] += 1;
1152         _owners[tokenId] = to;
1153 
1154         emit Transfer(address(0), to, tokenId);
1155 
1156         _afterTokenTransfer(address(0), to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev Destroys `tokenId`.
1161      * The approval is cleared when the token is burned.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _burn(uint256 tokenId) internal virtual {
1170         address owner = ERC721.ownerOf(tokenId);
1171 
1172         _beforeTokenTransfer(owner, address(0), tokenId);
1173 
1174         // Clear approvals
1175         _approve(address(0), tokenId);
1176 
1177         _balances[owner] -= 1;
1178         delete _owners[tokenId];
1179 
1180         emit Transfer(owner, address(0), tokenId);
1181 
1182         _afterTokenTransfer(owner, address(0), tokenId);
1183     }
1184 
1185     /**
1186      * @dev Transfers `tokenId` from `from` to `to`.
1187      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1188      *
1189      * Requirements:
1190      *
1191      * - `to` cannot be the zero address.
1192      * - `tokenId` token must be owned by `from`.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _transfer(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) internal virtual {
1201         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1202         require(to != address(0), "ERC721: transfer to the zero address");
1203 
1204         _beforeTokenTransfer(from, to, tokenId);
1205 
1206         // Clear approvals from the previous owner
1207         _approve(address(0), tokenId);
1208 
1209         _balances[from] -= 1;
1210         _balances[to] += 1;
1211         _owners[tokenId] = to;
1212 
1213         emit Transfer(from, to, tokenId);
1214 
1215         _afterTokenTransfer(from, to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev Approve `to` to operate on `tokenId`
1220      *
1221      * Emits an {Approval} event.
1222      */
1223     function _approve(address to, uint256 tokenId) internal virtual {
1224         _tokenApprovals[tokenId] = to;
1225         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev Approve `operator` to operate on all of `owner` tokens
1230      *
1231      * Emits an {ApprovalForAll} event.
1232      */
1233     function _setApprovalForAll(
1234         address owner,
1235         address operator,
1236         bool approved
1237     ) internal virtual {
1238         require(owner != operator, "ERC721: approve to caller");
1239         _operatorApprovals[owner][operator] = approved;
1240         emit ApprovalForAll(owner, operator, approved);
1241     }
1242 
1243     /**
1244      * @dev Reverts if the `tokenId` has not been minted yet.
1245      */
1246     function _requireMinted(uint256 tokenId) internal view virtual {
1247         require(_exists(tokenId), "ERC721: invalid token ID");
1248     }
1249 
1250     /**
1251      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1252      * The call is not executed if the target address is not a contract.
1253      *
1254      * @param from address representing the previous owner of the given token ID
1255      * @param to target address that will receive the tokens
1256      * @param tokenId uint256 ID of the token to be transferred
1257      * @param data bytes optional data to send along with the call
1258      * @return bool whether the call correctly returned the expected magic value
1259      */
1260     function _checkOnERC721Received(
1261         address from,
1262         address to,
1263         uint256 tokenId,
1264         bytes memory data
1265     ) private returns (bool) {
1266         if (to.isContract()) {
1267             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1268                 return retval == IERC721Receiver.onERC721Received.selector;
1269             } catch (bytes memory reason) {
1270                 if (reason.length == 0) {
1271                     revert("ERC721: transfer to non ERC721Receiver implementer");
1272                 } else {
1273                     /// @solidity memory-safe-assembly
1274                     assembly {
1275                         revert(add(32, reason), mload(reason))
1276                     }
1277                 }
1278             }
1279         } else {
1280             return true;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Hook that is called before any token transfer. This includes minting
1286      * and burning.
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` will be minted for `to`.
1293      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1294      * - `from` and `to` are never both zero.
1295      *
1296      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1297      */
1298     function _beforeTokenTransfer(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) internal virtual {}
1303 
1304     /**
1305      * @dev Hook that is called after any transfer of tokens. This includes
1306      * minting and burning.
1307      *
1308      * Calling conditions:
1309      *
1310      * - when `from` and `to` are both non-zero.
1311      * - `from` and `to` are never both zero.
1312      *
1313      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1314      */
1315     function _afterTokenTransfer(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) internal virtual {}
1320 }
1321 
1322 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1323 
1324 
1325 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1326 
1327 pragma solidity ^0.8.0;
1328 
1329 
1330 /**
1331  * @dev ERC721 token with storage based token URI management.
1332  */
1333 abstract contract ERC721URIStorage is ERC721 {
1334     using Strings for uint256;
1335 
1336     // Optional mapping for token URIs
1337     mapping(uint256 => string) private _tokenURIs;
1338 
1339     /**
1340      * @dev See {IERC721Metadata-tokenURI}.
1341      */
1342     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1343         _requireMinted(tokenId);
1344 
1345         string memory _tokenURI = _tokenURIs[tokenId];
1346         string memory base = _baseURI();
1347 
1348         // If there is no base URI, return the token URI.
1349         if (bytes(base).length == 0) {
1350             return _tokenURI;
1351         }
1352         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1353         if (bytes(_tokenURI).length > 0) {
1354             return string(abi.encodePacked(base, _tokenURI));
1355         }
1356 
1357         return super.tokenURI(tokenId);
1358     }
1359 
1360     /**
1361      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      */
1367     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1368         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1369         _tokenURIs[tokenId] = _tokenURI;
1370     }
1371 
1372     /**
1373      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1374      * token-specific URI was set for the token, and if so, it deletes the token URI from
1375      * the storage mapping.
1376      */
1377     function _burn(uint256 tokenId) internal virtual override {
1378         super._burn(tokenId);
1379 
1380         if (bytes(_tokenURIs[tokenId]).length != 0) {
1381             delete _tokenURIs[tokenId];
1382         }
1383     }
1384 }
1385 
1386 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1387 
1388 
1389 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 
1394 
1395 /**
1396  * @title ERC721 Burnable Token
1397  * @dev ERC721 Token that can be burned (destroyed).
1398  */
1399 abstract contract ERC721Burnable is Context, ERC721 {
1400     /**
1401      * @dev Burns `tokenId`. See {ERC721-_burn}.
1402      *
1403      * Requirements:
1404      *
1405      * - The caller must own `tokenId` or be an approved operator.
1406      */
1407     function burn(uint256 tokenId) public virtual {
1408         //solhint-disable-next-line max-line-length
1409         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1410         _burn(tokenId);
1411     }
1412 }
1413 
1414 // File: contracts/MimicShhans.sol
1415 
1416 
1417 
1418 pragma solidity >=0.7.0 <0.9.0;
1419 
1420 
1421 
1422 
1423 
1424 
1425 
1426 contract MimicShhans is ERC721, Ownable, ERC721Burnable, ERC721URIStorage, ERC2981 {
1427   using Strings for uint256;
1428   using Counters for Counters.Counter;
1429 
1430   Counters.Counter private supply;
1431 
1432   string public uriPrefix = "https://ipfs.filebase.io/ipfs/QmX3v9fNcEFikN6Wc6FvFKqcWD3RxwNhWiX6qzR7Yx6gpK/";
1433   string public uriSuffix = ".json";
1434   string public hiddenMetadataUri;
1435   
1436   uint256 public cost = 0.02 ether;
1437   uint256 public maxSupply = 10020;
1438   uint256 public maxMintAmountPerTx = 2000;
1439   
1440   string public contractURI;
1441   bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1442 
1443   bool public paused = false;
1444   bool public revealed = true;
1445 
1446   constructor(uint96 _royaltyFeesInBips, string memory _contractURI) ERC721("MimicShhans", "MS") {
1447     setHiddenMetadataUri("https://ipfs.filebase.io/ipfs/QmX3v9fNcEFikN6Wc6FvFKqcWD3RxwNhWiX6qzR7Yx6gpK/hidden.json");
1448     setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
1449     contractURI = _contractURI;
1450 
1451   }
1452 
1453   modifier mintCompliance(uint256 _mintAmount) {
1454     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1455     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1456     _;
1457   }
1458 
1459   function totalSupply() public view returns (uint256) {
1460     return supply.current();
1461   }
1462 
1463   function mint(uint256 _mintAmount, uint256 tokenId) public payable onlyOwner mintCompliance(_mintAmount) {
1464     require(!paused, "The contract is paused!");
1465     if (msg.sender != owner()) {
1466       require(msg.value >= cost * _mintAmount);
1467     }
1468 
1469     _mintMS(msg.sender, tokenId);
1470   }
1471   function bulkmint(uint256 _mintAmount, uint256 tokenId) public payable onlyOwner mintCompliance(_mintAmount){
1472     require(!paused, "The contract is paused!");
1473     if (msg.sender != owner()) {
1474       require(msg.value >= cost * _mintAmount);
1475     }
1476     for (uint256 i = tokenId; i < tokenId + _mintAmount; i++) {
1477       _mintMS(msg.sender, i);
1478     } 
1479   }
1480 
1481   function _mintMS(address _receiver, uint256 tokenId) internal onlyOwner{
1482     supply.increment();
1483     _safeMint(_receiver, tokenId);
1484   }
1485 
1486   function walletOfOwner(address _owner)
1487     public
1488     view
1489     returns (uint256[] memory)
1490   {
1491     uint256 ownerTokenCount = balanceOf(_owner);
1492     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1493     uint256 currentTokenId = 1;
1494     uint256 ownedTokenIndex = 0;
1495 
1496     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1497       address currentTokenOwner = ownerOf(currentTokenId);
1498 
1499       if (currentTokenOwner == _owner) {
1500         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1501 
1502         ownedTokenIndex++;
1503       }
1504 
1505       currentTokenId++;
1506     }
1507 
1508     return ownedTokenIds;
1509   }
1510 
1511   function tokenURI(uint256 _tokenId)
1512     public
1513     view
1514     virtual
1515     override(ERC721, ERC721URIStorage)
1516     returns (string memory)
1517   {
1518     require(
1519       _exists(_tokenId),
1520       "ERC721Metadata: URI query for nonexistent token"
1521     );
1522 
1523     if (revealed == false) {
1524       return hiddenMetadataUri;
1525     }
1526 
1527     string memory currentBaseURI = _baseURI();
1528     return bytes(currentBaseURI).length > 0
1529         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1530         : "";
1531   }
1532 
1533   function setRevealed(bool _state) public onlyOwner {
1534     revealed = _state;
1535   }
1536 
1537   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1538     maxMintAmountPerTx = _maxMintAmountPerTx;
1539   }
1540 
1541   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1542     hiddenMetadataUri = _hiddenMetadataUri;
1543   }
1544 
1545   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1546     uriPrefix = _uriPrefix;
1547   }
1548 
1549   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1550     uriSuffix = _uriSuffix;
1551   }
1552 
1553   function setPaused(bool _state) public onlyOwner {
1554     paused = _state;
1555   }
1556 
1557   function withdraw() public onlyOwner {
1558    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1559     require(os, "Transfer failed");
1560   }
1561 
1562   function _baseURI() internal view virtual override returns (string memory) {
1563     return uriPrefix;
1564   }
1565   function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1566         super._burn(tokenId);
1567 }
1568 
1569      
1570     function supportsInterface(bytes4 interfaceId)
1571         public
1572         view
1573         override(ERC721, ERC2981)
1574         returns (bool)
1575     {
1576         return interfaceId == _INTERFACE_ID_ERC2981 ||
1577         ERC721.supportsInterface(interfaceId) ||
1578         super.supportsInterface(interfaceId);
1579     }
1580 
1581     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner
1582     {
1583         _setDefaultRoyalty(_receiver,_royaltyFeesInBips);
1584     }
1585 
1586     function setContractURI(string calldata _contractURI) public onlyOwner{
1587         contractURI =_contractURI;
1588     }
1589 }