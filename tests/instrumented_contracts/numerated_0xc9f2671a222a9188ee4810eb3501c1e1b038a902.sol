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
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/security/Pausable.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 
231 /**
232  * @dev Contract module which allows children to implement an emergency stop
233  * mechanism that can be triggered by an authorized account.
234  *
235  * This module is used through inheritance. It will make available the
236  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
237  * the functions of your contract. Note that they will not be pausable by
238  * simply including this module, only once the modifiers are put in place.
239  */
240 abstract contract Pausable is Context {
241     /**
242      * @dev Emitted when the pause is triggered by `account`.
243      */
244     event Paused(address account);
245 
246     /**
247      * @dev Emitted when the pause is lifted by `account`.
248      */
249     event Unpaused(address account);
250 
251     bool private _paused;
252 
253     /**
254      * @dev Initializes the contract in unpaused state.
255      */
256     constructor() {
257         _paused = false;
258     }
259 
260     /**
261      * @dev Returns true if the contract is paused, and false otherwise.
262      */
263     function paused() public view virtual returns (bool) {
264         return _paused;
265     }
266 
267     /**
268      * @dev Modifier to make a function callable only when the contract is not paused.
269      *
270      * Requirements:
271      *
272      * - The contract must not be paused.
273      */
274     modifier whenNotPaused() {
275         require(!paused(), "Pausable: paused");
276         _;
277     }
278 
279     /**
280      * @dev Modifier to make a function callable only when the contract is paused.
281      *
282      * Requirements:
283      *
284      * - The contract must be paused.
285      */
286     modifier whenPaused() {
287         require(paused(), "Pausable: not paused");
288         _;
289     }
290 
291     /**
292      * @dev Triggers stopped state.
293      *
294      * Requirements:
295      *
296      * - The contract must not be paused.
297      */
298     function _pause() internal virtual whenNotPaused {
299         _paused = true;
300         emit Paused(_msgSender());
301     }
302 
303     /**
304      * @dev Returns to normal state.
305      *
306      * Requirements:
307      *
308      * - The contract must be paused.
309      */
310     function _unpause() internal virtual whenPaused {
311         _paused = false;
312         emit Unpaused(_msgSender());
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Address.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
320 
321 pragma solidity ^0.8.1;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      *
344      * [IMPORTANT]
345      * ====
346      * You shouldn't rely on `isContract` to protect against flash loan attacks!
347      *
348      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
349      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
350      * constructor.
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // This method relies on extcodesize/address.code.length, which returns 0
355         // for contracts in construction, since the code is only stored at the end
356         // of the constructor execution.
357 
358         return account.code.length > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         (bool success, ) = recipient.call{value: amount}("");
381         require(success, "Address: unable to send value, recipient may have reverted");
382     }
383 
384     /**
385      * @dev Performs a Solidity function call using a low level `call`. A
386      * plain `call` is an unsafe replacement for a function call: use this
387      * function instead.
388      *
389      * If `target` reverts with a revert reason, it is bubbled up by this
390      * function (like regular Solidity function calls).
391      *
392      * Returns the raw returned data. To convert to the expected return value,
393      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
394      *
395      * Requirements:
396      *
397      * - `target` must be a contract.
398      * - calling `target` with `data` must not revert.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionCall(target, data, "Address: low-level call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
408      * `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, 0, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but also transferring `value` wei to `target`.
423      *
424      * Requirements:
425      *
426      * - the calling contract must have an ETH balance of at least `value`.
427      * - the called Solidity function must be `payable`.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
441      * with `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         require(isContract(target), "Address: call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.call{value: value}(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
465         return functionStaticCall(target, data, "Address: low-level static call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal view returns (bytes memory) {
479         require(isContract(target), "Address: static call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(isContract(target), "Address: delegate call to non-contract");
507 
508         (bool success, bytes memory returndata) = target.delegatecall(data);
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
514      * revert reason using the provided one.
515      *
516      * _Available since v4.3._
517      */
518     function verifyCallResult(
519         bool success,
520         bytes memory returndata,
521         string memory errorMessage
522     ) internal pure returns (bytes memory) {
523         if (success) {
524             return returndata;
525         } else {
526             // Look for revert reason and bubble it up if present
527             if (returndata.length > 0) {
528                 // The easiest way to bubble the revert reason is using memory via assembly
529 
530                 assembly {
531                     let returndata_size := mload(returndata)
532                     revert(add(32, returndata), returndata_size)
533                 }
534             } else {
535                 revert(errorMessage);
536             }
537         }
538     }
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
542 
543 
544 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @title ERC721 token receiver interface
550  * @dev Interface for any contract that wants to support safeTransfers
551  * from ERC721 asset contracts.
552  */
553 interface IERC721Receiver {
554     /**
555      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
556      * by `operator` from `from`, this function is called.
557      *
558      * It must return its Solidity selector to confirm the token transfer.
559      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
560      *
561      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Interface of the ERC165 standard, as defined in the
580  * https://eips.ethereum.org/EIPS/eip-165[EIP].
581  *
582  * Implementers can declare support of contract interfaces, which can then be
583  * queried by others ({ERC165Checker}).
584  *
585  * For an implementation, see {ERC165}.
586  */
587 interface IERC165 {
588     /**
589      * @dev Returns true if this contract implements the interface defined by
590      * `interfaceId`. See the corresponding
591      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
592      * to learn more about how these ids are created.
593      *
594      * This function call must use less than 30 000 gas.
595      */
596     function supportsInterface(bytes4 interfaceId) external view returns (bool);
597 }
598 
599 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
600 
601 
602 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev Interface for the NFT Royalty Standard.
609  *
610  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
611  * support for royalty payments across all NFT marketplaces and ecosystem participants.
612  *
613  * _Available since v4.5._
614  */
615 interface IERC2981 is IERC165 {
616     /**
617      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
618      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
619      */
620     function royaltyInfo(uint256 tokenId, uint256 salePrice)
621         external
622         view
623         returns (address receiver, uint256 royaltyAmount);
624 }
625 
626 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 
634 /**
635  * @dev Implementation of the {IERC165} interface.
636  *
637  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
638  * for the additional interface id that will be supported. For example:
639  *
640  * ```solidity
641  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
642  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
643  * }
644  * ```
645  *
646  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
647  */
648 abstract contract ERC165 is IERC165 {
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653         return interfaceId == type(IERC165).interfaceId;
654     }
655 }
656 
657 // File: @openzeppelin/contracts/token/common/ERC2981.sol
658 
659 
660 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 
665 
666 /**
667  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
668  *
669  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
670  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
671  *
672  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
673  * fee is specified in basis points by default.
674  *
675  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
676  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
677  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
678  *
679  * _Available since v4.5._
680  */
681 abstract contract ERC2981 is IERC2981, ERC165 {
682     struct RoyaltyInfo {
683         address receiver;
684         uint96 royaltyFraction;
685     }
686 
687     RoyaltyInfo private _defaultRoyaltyInfo;
688     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
689 
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
694         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
695     }
696 
697     /**
698      * @inheritdoc IERC2981
699      */
700     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
701         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
702 
703         if (royalty.receiver == address(0)) {
704             royalty = _defaultRoyaltyInfo;
705         }
706 
707         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
708 
709         return (royalty.receiver, royaltyAmount);
710     }
711 
712     /**
713      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
714      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
715      * override.
716      */
717     function _feeDenominator() internal pure virtual returns (uint96) {
718         return 10000;
719     }
720 
721     /**
722      * @dev Sets the royalty information that all ids in this contract will default to.
723      *
724      * Requirements:
725      *
726      * - `receiver` cannot be the zero address.
727      * - `feeNumerator` cannot be greater than the fee denominator.
728      */
729     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
730         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
731         require(receiver != address(0), "ERC2981: invalid receiver");
732 
733         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
734     }
735 
736     /**
737      * @dev Removes default royalty information.
738      */
739     function _deleteDefaultRoyalty() internal virtual {
740         delete _defaultRoyaltyInfo;
741     }
742 
743     /**
744      * @dev Sets the royalty information for a specific token id, overriding the global default.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must be already minted.
749      * - `receiver` cannot be the zero address.
750      * - `feeNumerator` cannot be greater than the fee denominator.
751      */
752     function _setTokenRoyalty(
753         uint256 tokenId,
754         address receiver,
755         uint96 feeNumerator
756     ) internal virtual {
757         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
758         require(receiver != address(0), "ERC2981: Invalid parameters");
759 
760         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
761     }
762 
763     /**
764      * @dev Resets royalty information for the token id back to the global default.
765      */
766     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
767         delete _tokenRoyaltyInfo[tokenId];
768     }
769 }
770 
771 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
772 
773 
774 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 
779 /**
780  * @dev Required interface of an ERC721 compliant contract.
781  */
782 interface IERC721 is IERC165 {
783     /**
784      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
785      */
786     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
787 
788     /**
789      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
790      */
791     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
792 
793     /**
794      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
795      */
796     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
797 
798     /**
799      * @dev Returns the number of tokens in ``owner``'s account.
800      */
801     function balanceOf(address owner) external view returns (uint256 balance);
802 
803     /**
804      * @dev Returns the owner of the `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function ownerOf(uint256 tokenId) external view returns (address owner);
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId,
829         bytes calldata data
830     ) external;
831 
832     /**
833      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
834      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must exist and be owned by `from`.
841      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
842      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
843      *
844      * Emits a {Transfer} event.
845      */
846     function safeTransferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) external;
851 
852     /**
853      * @dev Transfers `tokenId` token from `from` to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      *
864      * Emits a {Transfer} event.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) external;
871 
872     /**
873      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
874      * The approval is cleared when the token is transferred.
875      *
876      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
877      *
878      * Requirements:
879      *
880      * - The caller must own the token or be an approved operator.
881      * - `tokenId` must exist.
882      *
883      * Emits an {Approval} event.
884      */
885     function approve(address to, uint256 tokenId) external;
886 
887     /**
888      * @dev Approve or remove `operator` as an operator for the caller.
889      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
890      *
891      * Requirements:
892      *
893      * - The `operator` cannot be the caller.
894      *
895      * Emits an {ApprovalForAll} event.
896      */
897     function setApprovalForAll(address operator, bool _approved) external;
898 
899     /**
900      * @dev Returns the account approved for `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function getApproved(uint256 tokenId) external view returns (address operator);
907 
908     /**
909      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
910      *
911      * See {setApprovalForAll}
912      */
913     function isApprovedForAll(address owner, address operator) external view returns (bool);
914 }
915 
916 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
917 
918 
919 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
920 
921 pragma solidity ^0.8.0;
922 
923 
924 /**
925  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
926  * @dev See https://eips.ethereum.org/EIPS/eip-721
927  */
928 interface IERC721Enumerable is IERC721 {
929     /**
930      * @dev Returns the total amount of tokens stored by the contract.
931      */
932     function totalSupply() external view returns (uint256);
933 
934     /**
935      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
936      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
939 
940     /**
941      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
942      * Use along with {totalSupply} to enumerate all tokens.
943      */
944     function tokenByIndex(uint256 index) external view returns (uint256);
945 }
946 
947 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
948 
949 
950 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 
955 /**
956  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
957  * @dev See https://eips.ethereum.org/EIPS/eip-721
958  */
959 interface IERC721Metadata is IERC721 {
960     /**
961      * @dev Returns the token collection name.
962      */
963     function name() external view returns (string memory);
964 
965     /**
966      * @dev Returns the token collection symbol.
967      */
968     function symbol() external view returns (string memory);
969 
970     /**
971      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
972      */
973     function tokenURI(uint256 tokenId) external view returns (string memory);
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
977 
978 
979 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 
984 
985 
986 
987 
988 
989 
990 /**
991  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
992  * the Metadata extension, but not including the Enumerable extension, which is available separately as
993  * {ERC721Enumerable}.
994  */
995 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
996     using Address for address;
997     using Strings for uint256;
998 
999     // Token name
1000     string private _name;
1001 
1002     // Token symbol
1003     string private _symbol;
1004 
1005     // Mapping from token ID to owner address
1006     mapping(uint256 => address) private _owners;
1007 
1008     // Mapping owner address to token count
1009     mapping(address => uint256) private _balances;
1010 
1011     // Mapping from token ID to approved address
1012     mapping(uint256 => address) private _tokenApprovals;
1013 
1014     // Mapping from owner to operator approvals
1015     mapping(address => mapping(address => bool)) private _operatorApprovals;
1016 
1017     /**
1018      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1019      */
1020     constructor(string memory name_, string memory symbol_) {
1021         _name = name_;
1022         _symbol = symbol_;
1023     }
1024 
1025     /**
1026      * @dev See {IERC165-supportsInterface}.
1027      */
1028     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1029         return
1030             interfaceId == type(IERC721).interfaceId ||
1031             interfaceId == type(IERC721Metadata).interfaceId ||
1032             super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-balanceOf}.
1037      */
1038     function balanceOf(address owner) public view virtual override returns (uint256) {
1039         require(owner != address(0), "ERC721: balance query for the zero address");
1040         return _balances[owner];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-ownerOf}.
1045      */
1046     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1047         address owner = _owners[tokenId];
1048         require(owner != address(0), "ERC721: owner query for nonexistent token");
1049         return owner;
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Metadata-name}.
1054      */
1055     function name() public view virtual override returns (string memory) {
1056         return _name;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Metadata-symbol}.
1061      */
1062     function symbol() public view virtual override returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Metadata-tokenURI}.
1068      */
1069     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1070         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1071 
1072         string memory baseURI = _baseURI();
1073         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1074     }
1075 
1076     /**
1077      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1078      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1079      * by default, can be overridden in child contracts.
1080      */
1081     function _baseURI() internal view virtual returns (string memory) {
1082         return "";
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-approve}.
1087      */
1088     function approve(address to, uint256 tokenId) public virtual override {
1089         address owner = ERC721.ownerOf(tokenId);
1090         require(to != owner, "ERC721: approval to current owner");
1091 
1092         require(
1093             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1094             "ERC721: approve caller is not owner nor approved for all"
1095         );
1096 
1097         _approve(to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-getApproved}.
1102      */
1103     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1104         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1105 
1106         return _tokenApprovals[tokenId];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-setApprovalForAll}.
1111      */
1112     function setApprovalForAll(address operator, bool approved) public virtual override {
1113         _setApprovalForAll(_msgSender(), operator, approved);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-isApprovedForAll}.
1118      */
1119     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1120         return _operatorApprovals[owner][operator];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-transferFrom}.
1125      */
1126     function transferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) public virtual override {
1131         //solhint-disable-next-line max-line-length
1132         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1133 
1134         _transfer(from, to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-safeTransferFrom}.
1139      */
1140     function safeTransferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) public virtual override {
1145         safeTransferFrom(from, to, tokenId, "");
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-safeTransferFrom}.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) public virtual override {
1157         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1158         _safeTransfer(from, to, tokenId, _data);
1159     }
1160 
1161     /**
1162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1164      *
1165      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1166      *
1167      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1168      * implement alternative mechanisms to perform token transfer, such as signature-based.
1169      *
1170      * Requirements:
1171      *
1172      * - `from` cannot be the zero address.
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must exist and be owned by `from`.
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _safeTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) internal virtual {
1185         _transfer(from, to, tokenId);
1186         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1187     }
1188 
1189     /**
1190      * @dev Returns whether `tokenId` exists.
1191      *
1192      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1193      *
1194      * Tokens start existing when they are minted (`_mint`),
1195      * and stop existing when they are burned (`_burn`).
1196      */
1197     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1198         return _owners[tokenId] != address(0);
1199     }
1200 
1201     /**
1202      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      */
1208     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1209         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1210         address owner = ERC721.ownerOf(tokenId);
1211         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1212     }
1213 
1214     /**
1215      * @dev Safely mints `tokenId` and transfers it to `to`.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must not exist.
1220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _safeMint(address to, uint256 tokenId) internal virtual {
1225         _safeMint(to, tokenId, "");
1226     }
1227 
1228     /**
1229      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1230      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1231      */
1232     function _safeMint(
1233         address to,
1234         uint256 tokenId,
1235         bytes memory _data
1236     ) internal virtual {
1237         _mint(to, tokenId);
1238         require(
1239             _checkOnERC721Received(address(0), to, tokenId, _data),
1240             "ERC721: transfer to non ERC721Receiver implementer"
1241         );
1242     }
1243 
1244     /**
1245      * @dev Mints `tokenId` and transfers it to `to`.
1246      *
1247      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1248      *
1249      * Requirements:
1250      *
1251      * - `tokenId` must not exist.
1252      * - `to` cannot be the zero address.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _mint(address to, uint256 tokenId) internal virtual {
1257         require(to != address(0), "ERC721: mint to the zero address");
1258         require(!_exists(tokenId), "ERC721: token already minted");
1259 
1260         _beforeTokenTransfer(address(0), to, tokenId);
1261 
1262         _balances[to] += 1;
1263         _owners[tokenId] = to;
1264 
1265         emit Transfer(address(0), to, tokenId);
1266 
1267         _afterTokenTransfer(address(0), to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _burn(uint256 tokenId) internal virtual {
1281         address owner = ERC721.ownerOf(tokenId);
1282 
1283         _beforeTokenTransfer(owner, address(0), tokenId);
1284 
1285         // Clear approvals
1286         _approve(address(0), tokenId);
1287 
1288         _balances[owner] -= 1;
1289         delete _owners[tokenId];
1290 
1291         emit Transfer(owner, address(0), tokenId);
1292 
1293         _afterTokenTransfer(owner, address(0), tokenId);
1294     }
1295 
1296     /**
1297      * @dev Transfers `tokenId` from `from` to `to`.
1298      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `tokenId` token must be owned by `from`.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _transfer(
1308         address from,
1309         address to,
1310         uint256 tokenId
1311     ) internal virtual {
1312         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1313         require(to != address(0), "ERC721: transfer to the zero address");
1314 
1315         _beforeTokenTransfer(from, to, tokenId);
1316 
1317         // Clear approvals from the previous owner
1318         _approve(address(0), tokenId);
1319 
1320         _balances[from] -= 1;
1321         _balances[to] += 1;
1322         _owners[tokenId] = to;
1323 
1324         emit Transfer(from, to, tokenId);
1325 
1326         _afterTokenTransfer(from, to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev Approve `to` to operate on `tokenId`
1331      *
1332      * Emits a {Approval} event.
1333      */
1334     function _approve(address to, uint256 tokenId) internal virtual {
1335         _tokenApprovals[tokenId] = to;
1336         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1337     }
1338 
1339     /**
1340      * @dev Approve `operator` to operate on all of `owner` tokens
1341      *
1342      * Emits a {ApprovalForAll} event.
1343      */
1344     function _setApprovalForAll(
1345         address owner,
1346         address operator,
1347         bool approved
1348     ) internal virtual {
1349         require(owner != operator, "ERC721: approve to caller");
1350         _operatorApprovals[owner][operator] = approved;
1351         emit ApprovalForAll(owner, operator, approved);
1352     }
1353 
1354     /**
1355      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1356      * The call is not executed if the target address is not a contract.
1357      *
1358      * @param from address representing the previous owner of the given token ID
1359      * @param to target address that will receive the tokens
1360      * @param tokenId uint256 ID of the token to be transferred
1361      * @param _data bytes optional data to send along with the call
1362      * @return bool whether the call correctly returned the expected magic value
1363      */
1364     function _checkOnERC721Received(
1365         address from,
1366         address to,
1367         uint256 tokenId,
1368         bytes memory _data
1369     ) private returns (bool) {
1370         if (to.isContract()) {
1371             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1372                 return retval == IERC721Receiver.onERC721Received.selector;
1373             } catch (bytes memory reason) {
1374                 if (reason.length == 0) {
1375                     revert("ERC721: transfer to non ERC721Receiver implementer");
1376                 } else {
1377                     assembly {
1378                         revert(add(32, reason), mload(reason))
1379                     }
1380                 }
1381             }
1382         } else {
1383             return true;
1384         }
1385     }
1386 
1387     /**
1388      * @dev Hook that is called before any token transfer. This includes minting
1389      * and burning.
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` will be minted for `to`.
1396      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1397      * - `from` and `to` are never both zero.
1398      *
1399      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1400      */
1401     function _beforeTokenTransfer(
1402         address from,
1403         address to,
1404         uint256 tokenId
1405     ) internal virtual {}
1406 
1407     /**
1408      * @dev Hook that is called after any transfer of tokens. This includes
1409      * minting and burning.
1410      *
1411      * Calling conditions:
1412      *
1413      * - when `from` and `to` are both non-zero.
1414      * - `from` and `to` are never both zero.
1415      *
1416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1417      */
1418     function _afterTokenTransfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) internal virtual {}
1423 }
1424 
1425 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol
1426 
1427 
1428 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
1429 
1430 pragma solidity ^0.8.0;
1431 
1432 
1433 
1434 
1435 /**
1436  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1437  * information.
1438  *
1439  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1440  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1441  *
1442  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1443  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1444  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1445  *
1446  * _Available since v4.5._
1447  */
1448 abstract contract ERC721Royalty is ERC2981, ERC721 {
1449     /**
1450      * @dev See {IERC165-supportsInterface}.
1451      */
1452     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1453         return super.supportsInterface(interfaceId);
1454     }
1455 
1456     /**
1457      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1458      */
1459     function _burn(uint256 tokenId) internal virtual override {
1460         super._burn(tokenId);
1461         _resetTokenRoyalty(tokenId);
1462     }
1463 }
1464 
1465 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1466 
1467 
1468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 
1473 
1474 /**
1475  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1476  * enumerability of all the token ids in the contract as well as all token ids owned by each
1477  * account.
1478  */
1479 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1480     // Mapping from owner to list of owned token IDs
1481     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1482 
1483     // Mapping from token ID to index of the owner tokens list
1484     mapping(uint256 => uint256) private _ownedTokensIndex;
1485 
1486     // Array with all token ids, used for enumeration
1487     uint256[] private _allTokens;
1488 
1489     // Mapping from token id to position in the allTokens array
1490     mapping(uint256 => uint256) private _allTokensIndex;
1491 
1492     /**
1493      * @dev See {IERC165-supportsInterface}.
1494      */
1495     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1496         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1501      */
1502     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1503         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1504         return _ownedTokens[owner][index];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-totalSupply}.
1509      */
1510     function totalSupply() public view virtual override returns (uint256) {
1511         return _allTokens.length;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Enumerable-tokenByIndex}.
1516      */
1517     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1518         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1519         return _allTokens[index];
1520     }
1521 
1522     /**
1523      * @dev Hook that is called before any token transfer. This includes minting
1524      * and burning.
1525      *
1526      * Calling conditions:
1527      *
1528      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1529      * transferred to `to`.
1530      * - When `from` is zero, `tokenId` will be minted for `to`.
1531      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1532      * - `from` cannot be the zero address.
1533      * - `to` cannot be the zero address.
1534      *
1535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1536      */
1537     function _beforeTokenTransfer(
1538         address from,
1539         address to,
1540         uint256 tokenId
1541     ) internal virtual override {
1542         super._beforeTokenTransfer(from, to, tokenId);
1543 
1544         if (from == address(0)) {
1545             _addTokenToAllTokensEnumeration(tokenId);
1546         } else if (from != to) {
1547             _removeTokenFromOwnerEnumeration(from, tokenId);
1548         }
1549         if (to == address(0)) {
1550             _removeTokenFromAllTokensEnumeration(tokenId);
1551         } else if (to != from) {
1552             _addTokenToOwnerEnumeration(to, tokenId);
1553         }
1554     }
1555 
1556     /**
1557      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1558      * @param to address representing the new owner of the given token ID
1559      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1560      */
1561     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1562         uint256 length = ERC721.balanceOf(to);
1563         _ownedTokens[to][length] = tokenId;
1564         _ownedTokensIndex[tokenId] = length;
1565     }
1566 
1567     /**
1568      * @dev Private function to add a token to this extension's token tracking data structures.
1569      * @param tokenId uint256 ID of the token to be added to the tokens list
1570      */
1571     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1572         _allTokensIndex[tokenId] = _allTokens.length;
1573         _allTokens.push(tokenId);
1574     }
1575 
1576     /**
1577      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1578      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1579      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1580      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1581      * @param from address representing the previous owner of the given token ID
1582      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1583      */
1584     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1585         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1586         // then delete the last slot (swap and pop).
1587 
1588         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1589         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1590 
1591         // When the token to delete is the last token, the swap operation is unnecessary
1592         if (tokenIndex != lastTokenIndex) {
1593             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1594 
1595             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1596             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1597         }
1598 
1599         // This also deletes the contents at the last position of the array
1600         delete _ownedTokensIndex[tokenId];
1601         delete _ownedTokens[from][lastTokenIndex];
1602     }
1603 
1604     /**
1605      * @dev Private function to remove a token from this extension's token tracking data structures.
1606      * This has O(1) time complexity, but alters the order of the _allTokens array.
1607      * @param tokenId uint256 ID of the token to be removed from the tokens list
1608      */
1609     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1610         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1611         // then delete the last slot (swap and pop).
1612 
1613         uint256 lastTokenIndex = _allTokens.length - 1;
1614         uint256 tokenIndex = _allTokensIndex[tokenId];
1615 
1616         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1617         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1618         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1619         uint256 lastTokenId = _allTokens[lastTokenIndex];
1620 
1621         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1622         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1623 
1624         // This also deletes the contents at the last position of the array
1625         delete _allTokensIndex[tokenId];
1626         _allTokens.pop();
1627     }
1628 }
1629 
1630 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1631 
1632 
1633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1634 
1635 pragma solidity ^0.8.0;
1636 
1637 
1638 
1639 /**
1640  * @title ERC721 Burnable Token
1641  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1642  */
1643 abstract contract ERC721Burnable is Context, ERC721 {
1644     /**
1645      * @dev Burns `tokenId`. See {ERC721-_burn}.
1646      *
1647      * Requirements:
1648      *
1649      * - The caller must own `tokenId` or be an approved operator.
1650      */
1651     function burn(uint256 tokenId) public virtual {
1652         //solhint-disable-next-line max-line-length
1653         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1654         _burn(tokenId);
1655     }
1656 }
1657 
1658 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1659 
1660 
1661 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 
1666 /**
1667  * @dev ERC721 token with storage based token URI management.
1668  */
1669 abstract contract ERC721URIStorage is ERC721 {
1670     using Strings for uint256;
1671 
1672     // Optional mapping for token URIs
1673     mapping(uint256 => string) private _tokenURIs;
1674 
1675     /**
1676      * @dev See {IERC721Metadata-tokenURI}.
1677      */
1678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1679         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1680 
1681         string memory _tokenURI = _tokenURIs[tokenId];
1682         string memory base = _baseURI();
1683 
1684         // If there is no base URI, return the token URI.
1685         if (bytes(base).length == 0) {
1686             return _tokenURI;
1687         }
1688         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1689         if (bytes(_tokenURI).length > 0) {
1690             return string(abi.encodePacked(base, _tokenURI));
1691         }
1692 
1693         return super.tokenURI(tokenId);
1694     }
1695 
1696     /**
1697      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must exist.
1702      */
1703     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1704         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1705         _tokenURIs[tokenId] = _tokenURI;
1706     }
1707 
1708     /**
1709      * @dev Destroys `tokenId`.
1710      * The approval is cleared when the token is burned.
1711      *
1712      * Requirements:
1713      *
1714      * - `tokenId` must exist.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function _burn(uint256 tokenId) internal virtual override {
1719         super._burn(tokenId);
1720 
1721         if (bytes(_tokenURIs[tokenId]).length != 0) {
1722             delete _tokenURIs[tokenId];
1723         }
1724     }
1725 }
1726 
1727 // File: contracts/WORLDx.sol
1728 
1729 
1730 pragma solidity ^0.8.4;
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 
1739 
1740 contract WORLDXPassport is ERC721, Pausable, Ownable, ERC721URIStorage, ERC721Burnable, ERC721Enumerable, ERC721Royalty {
1741     using Counters for Counters.Counter;
1742     using Strings for uint256;
1743 
1744     Counters.Counter private _tokenIdCounter;
1745     string baseURI = "ipfs://QmaezJr4gu4eHtGP55auYdwFE3oye3AnM7WR4N62D6CBtK/";
1746     address private _recipient = 0xD4AC2EFF8A0Cc043A0d77C0A85276551829be9E6;
1747     uint256 public constant maxSupply = 200000; // Total token qty supply
1748     uint96 private royaltyPercentage = 700; // Royalty percentage
1749     uint256 public mintPrice = 0; // Price for mint the token (wei)
1750     uint256 public mintedQty = 0; // Current minted token qty
1751     mapping(address => bool) public whitelistAddress;
1752 
1753     constructor() ERC721("WORLDX Passports", "WXP") {
1754         _setDefaultRoyalty(_recipient, royaltyPercentage);
1755         _tokenIdCounter.increment();
1756     }
1757     
1758     function _baseURI() internal view override returns (string memory) {
1759         return baseURI;
1760     }
1761 
1762     //to set after deployed if want to update new metadata
1763     function setbaseURI(string memory uri) external onlyOwner {
1764         baseURI = uri;
1765     }
1766 
1767     function pause() public onlyOwner {
1768         _pause();
1769     }
1770 
1771     function unpause() public onlyOwner {
1772         _unpause();
1773     }
1774 
1775     // The following functions are overrides required by Solidity.
1776     function _burn(uint256 tokenId)
1777         internal
1778         override(ERC721, ERC721URIStorage, ERC721Royalty)
1779     {
1780         super._burn(tokenId);
1781     }
1782 
1783     function setMintPrice(uint256 newMintPrice) public onlyOwner {
1784         mintPrice = newMintPrice;
1785     }
1786 
1787     function mint() public payable {
1788         uint256 tokenQty = 1;
1789         require(
1790             mintedQty + tokenQty <= maxSupply,
1791             "Sale would exceed max supply"
1792         );
1793         require(tokenQty * mintPrice <= msg.value, "Not enough ether sent");
1794         if (msg.sender != owner()) {
1795             require(whitelistAddress[msg.sender] == true, "Not in whitelist");
1796             require(
1797                 balanceOf(msg.sender) == 0,
1798                 "One wallet address can only mint 1 NFT"
1799             );
1800         }
1801 
1802         mintedQty += 1;
1803         safeMint();
1804     }
1805     
1806     function safeMint() internal  {
1807         uint256 tokenId = _tokenIdCounter.current();
1808         _tokenIdCounter.increment();
1809         _safeMint(msg.sender, tokenId);
1810         _setTokenURI(tokenId, string(abi.encodePacked(tokenId.toString(), ".json")));
1811         _removeWhitelistUser(msg.sender);
1812     }
1813 
1814     function whitelistUser(address _user) public onlyOwner {
1815         whitelistAddress[_user] = true;
1816     }
1817 
1818     function whitelistUserByBatch(address[] memory users) public onlyOwner {
1819         for (uint256 i = 0; i < users.length; i++) {
1820             whitelistAddress[users[i]] = true;
1821         }
1822     }
1823 
1824     function removeWhitelistUser(address _user) public onlyOwner {
1825         _removeWhitelistUser(_user);
1826     }
1827 
1828     function _removeWhitelistUser(address _user) internal {
1829         whitelistAddress[_user] = false;
1830     }
1831 
1832     function updateRoyaltyPercentage(uint96 newRoyaltyPercentage) public onlyOwner {
1833         _setDefaultRoyalty(_recipient, newRoyaltyPercentage);
1834     }
1835 
1836     function _beforeTokenTransfer(
1837         address from,
1838         address to,
1839         uint256 tokenId
1840     ) internal virtual override(ERC721, ERC721Enumerable) {
1841         super._beforeTokenTransfer(from, to, tokenId);
1842     }
1843 
1844     function tokenURI(uint256 tokenId)
1845         public
1846         view
1847         override(ERC721, ERC721URIStorage)
1848         returns (string memory)
1849     {
1850         return super.tokenURI(tokenId);
1851     }
1852 
1853     function supportsInterface(bytes4 interfaceId)
1854         public
1855         view
1856         virtual
1857         override(ERC721, ERC721Royalty, ERC721Enumerable)
1858         returns (bool)
1859     {
1860         return super.supportsInterface(interfaceId);
1861     }
1862 }