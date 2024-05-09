1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/security/Pausable.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev Contract module which allows children to implement an emergency stop
232  * mechanism that can be triggered by an authorized account.
233  *
234  * This module is used through inheritance. It will make available the
235  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
236  * the functions of your contract. Note that they will not be pausable by
237  * simply including this module, only once the modifiers are put in place.
238  */
239 abstract contract Pausable is Context {
240     /**
241      * @dev Emitted when the pause is triggered by `account`.
242      */
243     event Paused(address account);
244 
245     /**
246      * @dev Emitted when the pause is lifted by `account`.
247      */
248     event Unpaused(address account);
249 
250     bool private _paused;
251 
252     /**
253      * @dev Initializes the contract in unpaused state.
254      */
255     constructor() {
256         _paused = false;
257     }
258 
259     /**
260      * @dev Returns true if the contract is paused, and false otherwise.
261      */
262     function paused() public view virtual returns (bool) {
263         return _paused;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is not paused.
268      *
269      * Requirements:
270      *
271      * - The contract must not be paused.
272      */
273     modifier whenNotPaused() {
274         require(!paused(), "Pausable: paused");
275         _;
276     }
277 
278     /**
279      * @dev Modifier to make a function callable only when the contract is paused.
280      *
281      * Requirements:
282      *
283      * - The contract must be paused.
284      */
285     modifier whenPaused() {
286         require(paused(), "Pausable: not paused");
287         _;
288     }
289 
290     /**
291      * @dev Triggers stopped state.
292      *
293      * Requirements:
294      *
295      * - The contract must not be paused.
296      */
297     function _pause() internal virtual whenNotPaused {
298         _paused = true;
299         emit Paused(_msgSender());
300     }
301 
302     /**
303      * @dev Returns to normal state.
304      *
305      * Requirements:
306      *
307      * - The contract must be paused.
308      */
309     function _unpause() internal virtual whenPaused {
310         _paused = false;
311         emit Unpaused(_msgSender());
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/Address.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
319 
320 pragma solidity ^0.8.1;
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      *
343      * [IMPORTANT]
344      * ====
345      * You shouldn't rely on `isContract` to protect against flash loan attacks!
346      *
347      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
348      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
349      * constructor.
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize/address.code.length, which returns 0
354         // for contracts in construction, since the code is only stored at the end
355         // of the constructor execution.
356 
357         return account.code.length > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         (bool success, ) = recipient.call{value: amount}("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value
434     ) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(address(this).balance >= value, "Address: insufficient balance for call");
451         require(isContract(target), "Address: call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.call{value: value}(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.staticcall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         require(isContract(target), "Address: delegate call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.delegatecall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
513      * revert reason using the provided one.
514      *
515      * _Available since v4.3._
516      */
517     function verifyCallResult(
518         bool success,
519         bytes memory returndata,
520         string memory errorMessage
521     ) internal pure returns (bytes memory) {
522         if (success) {
523             return returndata;
524         } else {
525             // Look for revert reason and bubble it up if present
526             if (returndata.length > 0) {
527                 // The easiest way to bubble the revert reason is using memory via assembly
528 
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC721 token receiver interface
549  * @dev Interface for any contract that wants to support safeTransfers
550  * from ERC721 asset contracts.
551  */
552 interface IERC721Receiver {
553     /**
554      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
555      * by `operator` from `from`, this function is called.
556      *
557      * It must return its Solidity selector to confirm the token transfer.
558      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
559      *
560      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
561      */
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Interface of the ERC165 standard, as defined in the
579  * https://eips.ethereum.org/EIPS/eip-165[EIP].
580  *
581  * Implementers can declare support of contract interfaces, which can then be
582  * queried by others ({ERC165Checker}).
583  *
584  * For an implementation, see {ERC165}.
585  */
586 interface IERC165 {
587     /**
588      * @dev Returns true if this contract implements the interface defined by
589      * `interfaceId`. See the corresponding
590      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
591      * to learn more about how these ids are created.
592      *
593      * This function call must use less than 30 000 gas.
594      */
595     function supportsInterface(bytes4 interfaceId) external view returns (bool);
596 }
597 
598 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Interface for the NFT Royalty Standard.
608  *
609  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
610  * support for royalty payments across all NFT marketplaces and ecosystem participants.
611  *
612  * _Available since v4.5._
613  */
614 interface IERC2981 is IERC165 {
615     /**
616      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
617      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
618      */
619     function royaltyInfo(uint256 tokenId, uint256 salePrice)
620         external
621         view
622         returns (address receiver, uint256 royaltyAmount);
623 }
624 
625 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @dev Implementation of the {IERC165} interface.
635  *
636  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
637  * for the additional interface id that will be supported. For example:
638  *
639  * ```solidity
640  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
642  * }
643  * ```
644  *
645  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
646  */
647 abstract contract ERC165 is IERC165 {
648     /**
649      * @dev See {IERC165-supportsInterface}.
650      */
651     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
652         return interfaceId == type(IERC165).interfaceId;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/token/common/ERC2981.sol
657 
658 
659 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 
664 
665 /**
666  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
667  *
668  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
669  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
670  *
671  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
672  * fee is specified in basis points by default.
673  *
674  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
675  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
676  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
677  *
678  * _Available since v4.5._
679  */
680 abstract contract ERC2981 is IERC2981, ERC165 {
681     struct RoyaltyInfo {
682         address receiver;
683         uint96 royaltyFraction;
684     }
685 
686     RoyaltyInfo private _defaultRoyaltyInfo;
687     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
693         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
694     }
695 
696     /**
697      * @inheritdoc IERC2981
698      */
699     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
700         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
701 
702         if (royalty.receiver == address(0)) {
703             royalty = _defaultRoyaltyInfo;
704         }
705 
706         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
707 
708         return (royalty.receiver, royaltyAmount);
709     }
710 
711     /**
712      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
713      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
714      * override.
715      */
716     function _feeDenominator() internal pure virtual returns (uint96) {
717         return 10000;
718     }
719 
720     /**
721      * @dev Sets the royalty information that all ids in this contract will default to.
722      *
723      * Requirements:
724      *
725      * - `receiver` cannot be the zero address.
726      * - `feeNumerator` cannot be greater than the fee denominator.
727      */
728     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
729         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
730         require(receiver != address(0), "ERC2981: invalid receiver");
731 
732         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
733     }
734 
735     /**
736      * @dev Removes default royalty information.
737      */
738     function _deleteDefaultRoyalty() internal virtual {
739         delete _defaultRoyaltyInfo;
740     }
741 
742     /**
743      * @dev Sets the royalty information for a specific token id, overriding the global default.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must be already minted.
748      * - `receiver` cannot be the zero address.
749      * - `feeNumerator` cannot be greater than the fee denominator.
750      */
751     function _setTokenRoyalty(
752         uint256 tokenId,
753         address receiver,
754         uint96 feeNumerator
755     ) internal virtual {
756         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
757         require(receiver != address(0), "ERC2981: Invalid parameters");
758 
759         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
760     }
761 
762     /**
763      * @dev Resets royalty information for the token id back to the global default.
764      */
765     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
766         delete _tokenRoyaltyInfo[tokenId];
767     }
768 }
769 
770 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
771 
772 
773 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 
778 /**
779  * @dev Required interface of an ERC721 compliant contract.
780  */
781 interface IERC721 is IERC165 {
782     /**
783      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
784      */
785     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
786 
787     /**
788      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
789      */
790     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
791 
792     /**
793      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
794      */
795     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
796 
797     /**
798      * @dev Returns the number of tokens in ``owner``'s account.
799      */
800     function balanceOf(address owner) external view returns (uint256 balance);
801 
802     /**
803      * @dev Returns the owner of the `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function ownerOf(uint256 tokenId) external view returns (address owner);
810 
811     /**
812      * @dev Safely transfers `tokenId` token from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must exist and be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes calldata data
829     ) external;
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
833      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must exist and be owned by `from`.
840      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) external;
850 
851     /**
852      * @dev Transfers `tokenId` token from `from` to `to`.
853      *
854      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
862      *
863      * Emits a {Transfer} event.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) external;
870 
871     /**
872      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
873      * The approval is cleared when the token is transferred.
874      *
875      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
876      *
877      * Requirements:
878      *
879      * - The caller must own the token or be an approved operator.
880      * - `tokenId` must exist.
881      *
882      * Emits an {Approval} event.
883      */
884     function approve(address to, uint256 tokenId) external;
885 
886     /**
887      * @dev Approve or remove `operator` as an operator for the caller.
888      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
889      *
890      * Requirements:
891      *
892      * - The `operator` cannot be the caller.
893      *
894      * Emits an {ApprovalForAll} event.
895      */
896     function setApprovalForAll(address operator, bool _approved) external;
897 
898     /**
899      * @dev Returns the account approved for `tokenId` token.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      */
905     function getApproved(uint256 tokenId) external view returns (address operator);
906 
907     /**
908      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
909      *
910      * See {setApprovalForAll}
911      */
912     function isApprovedForAll(address owner, address operator) external view returns (bool);
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
925  * @dev See https://eips.ethereum.org/EIPS/eip-721
926  */
927 interface IERC721Metadata is IERC721 {
928     /**
929      * @dev Returns the token collection name.
930      */
931     function name() external view returns (string memory);
932 
933     /**
934      * @dev Returns the token collection symbol.
935      */
936     function symbol() external view returns (string memory);
937 
938     /**
939      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
940      */
941     function tokenURI(uint256 tokenId) external view returns (string memory);
942 }
943 
944 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
945 
946 
947 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 
952 
953 
954 
955 
956 
957 
958 /**
959  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
960  * the Metadata extension, but not including the Enumerable extension, which is available separately as
961  * {ERC721Enumerable}.
962  */
963 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
964     using Address for address;
965     using Strings for uint256;
966 
967     // Token name
968     string private _name;
969 
970     // Token symbol
971     string private _symbol;
972 
973     // Mapping from token ID to owner address
974     mapping(uint256 => address) private _owners;
975 
976     // Mapping owner address to token count
977     mapping(address => uint256) private _balances;
978 
979     // Mapping from token ID to approved address
980     mapping(uint256 => address) private _tokenApprovals;
981 
982     // Mapping from owner to operator approvals
983     mapping(address => mapping(address => bool)) private _operatorApprovals;
984 
985     /**
986      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
987      */
988     constructor(string memory name_, string memory symbol_) {
989         _name = name_;
990         _symbol = symbol_;
991     }
992 
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
997         return
998             interfaceId == type(IERC721).interfaceId ||
999             interfaceId == type(IERC721Metadata).interfaceId ||
1000             super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-balanceOf}.
1005      */
1006     function balanceOf(address owner) public view virtual override returns (uint256) {
1007         require(owner != address(0), "ERC721: balance query for the zero address");
1008         return _balances[owner];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-ownerOf}.
1013      */
1014     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1015         address owner = _owners[tokenId];
1016         require(owner != address(0), "ERC721: owner query for nonexistent token");
1017         return owner;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Metadata-name}.
1022      */
1023     function name() public view virtual override returns (string memory) {
1024         return _name;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Metadata-symbol}.
1029      */
1030     function symbol() public view virtual override returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Metadata-tokenURI}.
1036      */
1037     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1038         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1039 
1040         string memory baseURI = _baseURI();
1041         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1042     }
1043 
1044     /**
1045      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1046      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1047      * by default, can be overridden in child contracts.
1048      */
1049     function _baseURI() internal view virtual returns (string memory) {
1050         return "";
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-approve}.
1055      */
1056     function approve(address to, uint256 tokenId) public virtual override {
1057         address owner = ERC721.ownerOf(tokenId);
1058         require(to != owner, "ERC721: approval to current owner");
1059 
1060         require(
1061             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1062             "ERC721: approve caller is not owner nor approved for all"
1063         );
1064 
1065         _approve(to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-getApproved}.
1070      */
1071     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1072         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1073 
1074         return _tokenApprovals[tokenId];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-setApprovalForAll}.
1079      */
1080     function setApprovalForAll(address operator, bool approved) public virtual override {
1081         _setApprovalForAll(_msgSender(), operator, approved);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-isApprovedForAll}.
1086      */
1087     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1088         return _operatorApprovals[owner][operator];
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-transferFrom}.
1093      */
1094     function transferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) public virtual override {
1099         //solhint-disable-next-line max-line-length
1100         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1101 
1102         _transfer(from, to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-safeTransferFrom}.
1107      */
1108     function safeTransferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) public virtual override {
1113         safeTransferFrom(from, to, tokenId, "");
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) public virtual override {
1125         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1126         _safeTransfer(from, to, tokenId, _data);
1127     }
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1132      *
1133      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1134      *
1135      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1136      * implement alternative mechanisms to perform token transfer, such as signature-based.
1137      *
1138      * Requirements:
1139      *
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must exist and be owned by `from`.
1143      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _safeTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) internal virtual {
1153         _transfer(from, to, tokenId);
1154         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1155     }
1156 
1157     /**
1158      * @dev Returns whether `tokenId` exists.
1159      *
1160      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1161      *
1162      * Tokens start existing when they are minted (`_mint`),
1163      * and stop existing when they are burned (`_burn`).
1164      */
1165     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1166         return _owners[tokenId] != address(0);
1167     }
1168 
1169     /**
1170      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must exist.
1175      */
1176     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1177         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1178         address owner = ERC721.ownerOf(tokenId);
1179         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1180     }
1181 
1182     /**
1183      * @dev Safely mints `tokenId` and transfers it to `to`.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must not exist.
1188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _safeMint(address to, uint256 tokenId) internal virtual {
1193         _safeMint(to, tokenId, "");
1194     }
1195 
1196     /**
1197      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1198      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1199      */
1200     function _safeMint(
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) internal virtual {
1205         _mint(to, tokenId);
1206         require(
1207             _checkOnERC721Received(address(0), to, tokenId, _data),
1208             "ERC721: transfer to non ERC721Receiver implementer"
1209         );
1210     }
1211 
1212     /**
1213      * @dev Mints `tokenId` and transfers it to `to`.
1214      *
1215      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must not exist.
1220      * - `to` cannot be the zero address.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _mint(address to, uint256 tokenId) internal virtual {
1225         require(to != address(0), "ERC721: mint to the zero address");
1226         require(!_exists(tokenId), "ERC721: token already minted");
1227 
1228         _beforeTokenTransfer(address(0), to, tokenId);
1229 
1230         _balances[to] += 1;
1231         _owners[tokenId] = to;
1232 
1233         emit Transfer(address(0), to, tokenId);
1234 
1235         _afterTokenTransfer(address(0), to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev Destroys `tokenId`.
1240      * The approval is cleared when the token is burned.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _burn(uint256 tokenId) internal virtual {
1249         address owner = ERC721.ownerOf(tokenId);
1250 
1251         _beforeTokenTransfer(owner, address(0), tokenId);
1252 
1253         // Clear approvals
1254         _approve(address(0), tokenId);
1255 
1256         _balances[owner] -= 1;
1257         delete _owners[tokenId];
1258 
1259         emit Transfer(owner, address(0), tokenId);
1260 
1261         _afterTokenTransfer(owner, address(0), tokenId);
1262     }
1263 
1264     /**
1265      * @dev Transfers `tokenId` from `from` to `to`.
1266      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1267      *
1268      * Requirements:
1269      *
1270      * - `to` cannot be the zero address.
1271      * - `tokenId` token must be owned by `from`.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _transfer(
1276         address from,
1277         address to,
1278         uint256 tokenId
1279     ) internal virtual {
1280         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1281         require(to != address(0), "ERC721: transfer to the zero address");
1282 
1283         _beforeTokenTransfer(from, to, tokenId);
1284 
1285         // Clear approvals from the previous owner
1286         _approve(address(0), tokenId);
1287 
1288         _balances[from] -= 1;
1289         _balances[to] += 1;
1290         _owners[tokenId] = to;
1291 
1292         emit Transfer(from, to, tokenId);
1293 
1294         _afterTokenTransfer(from, to, tokenId);
1295     }
1296 
1297     /**
1298      * @dev Approve `to` to operate on `tokenId`
1299      *
1300      * Emits a {Approval} event.
1301      */
1302     function _approve(address to, uint256 tokenId) internal virtual {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Approve `operator` to operate on all of `owner` tokens
1309      *
1310      * Emits a {ApprovalForAll} event.
1311      */
1312     function _setApprovalForAll(
1313         address owner,
1314         address operator,
1315         bool approved
1316     ) internal virtual {
1317         require(owner != operator, "ERC721: approve to caller");
1318         _operatorApprovals[owner][operator] = approved;
1319         emit ApprovalForAll(owner, operator, approved);
1320     }
1321 
1322     /**
1323      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1324      * The call is not executed if the target address is not a contract.
1325      *
1326      * @param from address representing the previous owner of the given token ID
1327      * @param to target address that will receive the tokens
1328      * @param tokenId uint256 ID of the token to be transferred
1329      * @param _data bytes optional data to send along with the call
1330      * @return bool whether the call correctly returned the expected magic value
1331      */
1332     function _checkOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) private returns (bool) {
1338         if (to.isContract()) {
1339             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1340                 return retval == IERC721Receiver.onERC721Received.selector;
1341             } catch (bytes memory reason) {
1342                 if (reason.length == 0) {
1343                     revert("ERC721: transfer to non ERC721Receiver implementer");
1344                 } else {
1345                     assembly {
1346                         revert(add(32, reason), mload(reason))
1347                     }
1348                 }
1349             }
1350         } else {
1351             return true;
1352         }
1353     }
1354 
1355     /**
1356      * @dev Hook that is called before any token transfer. This includes minting
1357      * and burning.
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1365      * - `from` and `to` are never both zero.
1366      *
1367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1368      */
1369     function _beforeTokenTransfer(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) internal virtual {}
1374 
1375     /**
1376      * @dev Hook that is called after any transfer of tokens. This includes
1377      * minting and burning.
1378      *
1379      * Calling conditions:
1380      *
1381      * - when `from` and `to` are both non-zero.
1382      * - `from` and `to` are never both zero.
1383      *
1384      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1385      */
1386     function _afterTokenTransfer(
1387         address from,
1388         address to,
1389         uint256 tokenId
1390     ) internal virtual {}
1391 }
1392 
1393 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1394 
1395 
1396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 /**
1403  * @title ERC721 Burnable Token
1404  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1405  */
1406 abstract contract ERC721Burnable is Context, ERC721 {
1407     /**
1408      * @dev Burns `tokenId`. See {ERC721-_burn}.
1409      *
1410      * Requirements:
1411      *
1412      * - The caller must own `tokenId` or be an approved operator.
1413      */
1414     function burn(uint256 tokenId) public virtual {
1415         //solhint-disable-next-line max-line-length
1416         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1417         _burn(tokenId);
1418     }
1419 }
1420 
1421 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol
1422 
1423 
1424 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
1425 
1426 pragma solidity ^0.8.0;
1427 
1428 
1429 
1430 
1431 /**
1432  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1433  * information.
1434  *
1435  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1436  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1437  *
1438  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1439  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1440  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1441  *
1442  * _Available since v4.5._
1443  */
1444 abstract contract ERC721Royalty is ERC2981, ERC721 {
1445     /**
1446      * @dev See {IERC165-supportsInterface}.
1447      */
1448     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1449         return super.supportsInterface(interfaceId);
1450     }
1451 
1452     /**
1453      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1454      */
1455     function _burn(uint256 tokenId) internal virtual override {
1456         super._burn(tokenId);
1457         _resetTokenRoyalty(tokenId);
1458     }
1459 }
1460 
1461 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1462 
1463 
1464 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 
1469 /**
1470  * @dev ERC721 token with storage based token URI management.
1471  */
1472 abstract contract ERC721URIStorage is ERC721 {
1473     using Strings for uint256;
1474 
1475     // Optional mapping for token URIs
1476     mapping(uint256 => string) private _tokenURIs;
1477 
1478     /**
1479      * @dev See {IERC721Metadata-tokenURI}.
1480      */
1481     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1482         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1483 
1484         string memory _tokenURI = _tokenURIs[tokenId];
1485         string memory base = _baseURI();
1486 
1487         // If there is no base URI, return the token URI.
1488         if (bytes(base).length == 0) {
1489             return _tokenURI;
1490         }
1491         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1492         if (bytes(_tokenURI).length > 0) {
1493             return string(abi.encodePacked(base, _tokenURI));
1494         }
1495 
1496         return super.tokenURI(tokenId);
1497     }
1498 
1499     /**
1500      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1501      *
1502      * Requirements:
1503      *
1504      * - `tokenId` must exist.
1505      */
1506     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1507         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1508         _tokenURIs[tokenId] = _tokenURI;
1509     }
1510 
1511     /**
1512      * @dev Destroys `tokenId`.
1513      * The approval is cleared when the token is burned.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _burn(uint256 tokenId) internal virtual override {
1522         super._burn(tokenId);
1523 
1524         if (bytes(_tokenURIs[tokenId]).length != 0) {
1525             delete _tokenURIs[tokenId];
1526         }
1527     }
1528 }
1529 
1530 // File: contracts/WomboDream.sol
1531 
1532 
1533 pragma solidity ^0.8.4;
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 /**
1543  * @title Wombo Dream NFT contract
1544  * @dev This is an ERC721 contract that defines the Wombo Dream collection. It
1545  * allows ownerOnly minting, as well as public minting of verified URIs. 
1546  * Verification is done by the Wombo Dream server.
1547  */
1548 contract WomboDream is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable, ERC721Royalty {
1549     using Counters for Counters.Counter;
1550     Counters.Counter private _tokenIdCounter;
1551 
1552     // Public key used to check the signature, which allows public minting of 
1553     // authorized URIs.
1554     address private _PUBLIC_VERIFICATION_KEY;
1555 
1556     // Maybe we will require a mint fee in the future.
1557     uint256 _mintFee = 0;
1558 
1559     // We use OpenZeppelin's ERC721Royalty, which implements ERC-2981:
1560     // IMPORTANT: ERC-2981 only specifies a way to signal royalty information 
1561     // and does not enforce its payment. See https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale]
1562     // in the EIP. Marketplaces are expected to voluntarily pay royalties 
1563     // together with sales, but note that this standard is not yet widely 
1564     // supported.
1565     uint96 ROYALTY_FEE_PERCENT = 10;
1566 
1567     // To guard against replay attack, and ensure only 1 NFT can be minted for
1568     // a given Dream.
1569     mapping(string => bool) private _taskIDs;
1570 
1571     // This makes it easy to fetch the taskID for a given token.
1572     mapping(uint256 => string) _tokenIdToTaskID;
1573 
1574     constructor(address verificationPublicKey) ERC721("Wombo Dream", "WBO") {
1575         _PUBLIC_VERIFICATION_KEY = verificationPublicKey;
1576         _setDefaultRoyalty(owner(),  ROYALTY_FEE_PERCENT*100 /*royalty numerator is in basis points*/);
1577     }
1578 
1579     //
1580     // Private onlyOwner functions:
1581     //
1582     function updateDefaultRoyalty(address receiver, uint96 feeNumerator)
1583             public onlyOwner {
1584         _setDefaultRoyalty(receiver, feeNumerator);
1585     }
1586 
1587     function pause() public onlyOwner {
1588         _pause();
1589     }
1590 
1591     function unpause() public onlyOwner {
1592         _unpause();
1593     }
1594 
1595     function updateMintFee(uint256 newMintFee) public onlyOwner {
1596         _mintFee = newMintFee;
1597     }
1598 
1599     /** 
1600      * @dev Bulk Minting function, only callable by the contract owner.
1601      * @param uris an array of metadata URIs
1602      * @param targetAddresses an array of addresses that will receive the NFTs
1603      * @param batchSize the number of tokens that we are minting
1604      */
1605     function privateBulkAirdrop(
1606             string[] memory uris,
1607             address[] memory targetAddresses,
1608             string[] memory taskIDs, 
1609             uint batchSize) public onlyOwner {
1610         // Ensure that the input arrays are all the same size
1611         require(uris.length == batchSize, "input arrays must be equal to batch_size");
1612         require(targetAddresses.length == batchSize, "input arrays must be equal to batch_size");
1613         require(taskIDs.length == batchSize, "taskIDs must be equal to batch_size");
1614 
1615         for (uint i = 0; i < batchSize; i++) {
1616             privateMint(uris[i], targetAddresses[i], taskIDs[i]);
1617         }
1618     }
1619 
1620     /** 
1621      * @dev Minting function that is only callable by the contract owner.
1622      * @param uri the metadata URI
1623      * @param targetAddress the address of the receiver of this NFT
1624      */
1625     function privateMint(
1626             string memory uri,
1627             address targetAddress,
1628             string memory taskID) public onlyOwner {
1629         internalMint(uri, targetAddress, taskID);
1630     }
1631 
1632     function withdraw() public onlyOwner {
1633         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1634         require(os);
1635     }
1636 
1637     function internalMint(string memory uri, address to, string memory taskID) internal {
1638         require(!_taskIDs[taskID], "This dream has already been minted");
1639         require(bytes(taskID).length != 0,  "Cannot use empty string for taskID");
1640         _taskIDs[taskID] = true;
1641         _safeMint(to, _tokenIdCounter.current());
1642         _setTokenURI(_tokenIdCounter.current(), uri);
1643         _tokenIdToTaskID[_tokenIdCounter.current()] = taskID;
1644         _tokenIdCounter.increment();
1645     }
1646 
1647     //
1648     // Public functions:
1649     // 
1650 
1651     /**
1652      * @dev Public function to view the taskID for a given token.
1653      * @param tokenId the token ID
1654      */
1655     function tokenTaskID(uint256 tokenId) public view returns (string memory)  {
1656         string memory taskID = _tokenIdToTaskID[tokenId];
1657         require(bytes(taskID).length != 0, "ERC721: taskID query for nonexistent token");
1658         return taskID;
1659     }
1660 
1661 
1662     /** 
1663      * @dev Public mint function. The signature needs to come from the private 
1664      * Wombo server.
1665      * @param uri the metadata URI
1666      * @param signature the signed payload hash, which is signed using the 
1667      * Wombo verification private key. We check to ensure that the signature
1668      * is valid, by reconstructing the payload hash (using uri, sender address, 
1669      * and taskID), and comparing the signature.
1670      * @param taskID the taskID of the dream linked to this NFT. This is used
1671      * to ensure that only a single NFT can be minted for a given Dream.
1672      */
1673     function mint(string memory uri, bytes memory signature, string memory taskID) public payable whenNotPaused {
1674         // Maybe require a mint fee
1675         require(msg.value >= _mintFee, "Not enough eth sent");
1676 
1677         // Recreate the payload hash and validate the signature
1678         bytes32 payloadHash = keccak256(abi.encode(uri, msg.sender, taskID));
1679         require(verify(payloadHash, signature), "signature is invalid");
1680 
1681         internalMint(uri, msg.sender, taskID);
1682     }
1683 
1684     /**
1685      * @dev ECDSA signatures consist of two numbers (integers): r and s. Ethereum also uses an additional v 
1686      * (recovery identifier) variable. The signature can be notated as {r, s, v}. 
1687      * see https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7 for more details.
1688      * @param payloadHash the hash of the payload we are verifying. The payload
1689      * can be the concatenation of various messages.
1690      * @param signature the signature that we are verifying.
1691     */
1692     function verify(
1693         bytes32 payloadHash,
1694         bytes memory signature
1695     ) public view returns (bool)  {
1696         (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);
1697         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash));
1698         return ecrecover(messageHash, v, r, s) == _PUBLIC_VERIFICATION_KEY;
1699     }
1700 
1701     /**
1702      * @dev ECDSA signatures consist of two numbers (integers): r and s. Ethereum also uses an additional v 
1703      * (recovery identifier) variable. The signature can be notated as {r, s, v}. 
1704      * see https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7 for more details.
1705      * @param signature the signature to be split.
1706      */
1707     function splitSignature(
1708         bytes memory signature
1709     ) internal pure
1710         returns (
1711             bytes32 r,
1712             bytes32 s,
1713             uint8 v
1714         )
1715     {
1716         require(signature.length == 65, "invalid signature length");
1717 
1718         assembly {
1719             /*
1720             First 32 bytes stores the length of the signature
1721 
1722             add(sig, 32) = pointer of sig + 32
1723             effectively, skips first 32 bytes of signature
1724 
1725             mload(p) loads next 32 bytes starting at the memory address p into memory
1726             */
1727 
1728             // first 32 bytes, after the length prefix
1729             r := mload(add(signature, 32))
1730             // second 32 bytes
1731             s := mload(add(signature, 64))
1732             // final byte (first byte of the next 32 bytes)
1733             v := byte(0, mload(add(signature, 96)))
1734         }
1735 
1736         // implicitly return (r, s, v)
1737     }
1738 
1739     // The following function overrides are required by Solidity.
1740     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Royalty) returns (bool) {
1741         return super.supportsInterface(interfaceId);
1742     }
1743     
1744     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1745         internal
1746         whenNotPaused
1747         override
1748     {
1749         super._beforeTokenTransfer(from, to, tokenId);
1750     }
1751 
1752     function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty, ERC721URIStorage) {
1753         super._burn(tokenId);
1754     }
1755 
1756     function tokenURI(uint256 tokenId)
1757         public
1758         view
1759         override(ERC721, ERC721URIStorage)
1760         returns (string memory)
1761     {
1762         return super.tokenURI(tokenId);
1763     }
1764 }