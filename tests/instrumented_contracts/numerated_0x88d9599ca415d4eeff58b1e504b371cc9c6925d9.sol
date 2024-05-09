1 pragma solidity ^0.8.4;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
6 // Inspired by BaseOpenSea by Simon Fremaux (@dievardump) but without the need
7 // to pass specific addresses depending on deployment network.
8 // https://gist.github.com/dievardump/483eb43bc6ed30b14f01e01842e3339b/
9 /// @notice Library to achieve gas-free listings on OpenSea.
10 library OpenSeaGasFreeListing {
11     /**
12     @notice Returns whether the operator is an OpenSea proxy for the owner, thus
13     allowing it to list without the token owner paying gas.
14     @dev ERC{721,1155}.isApprovedForAll should be overriden to also check if
15     this function returns true.
16      */
17     function isApprovedForAll(address owner, address operator)
18         internal
19         view
20         returns (bool)
21     {
22         ProxyRegistry registry;
23         assembly {
24             switch chainid()
25             case 1 {
26                 // mainnet
27                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
28             }
29             case 4 {
30                 // rinkeby
31                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
32             }
33         }
34 
35         return
36             address(registry) != address(0) &&
37             address(registry.proxies(owner)) == operator;
38     }
39 }
40 
41 contract OwnableDelegateProxy {}
42 
43 contract ProxyRegistry {
44     mapping(address => OwnableDelegateProxy) public proxies;
45 }
46 
47 
48 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
49 /**
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes calldata) {
65         return msg.data;
66     }
67 }
68 
69 
70 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _transferOwnership(_msgSender());
93     }
94 
95     /**
96      * @dev Returns the address of the current owner.
97      */
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 
142 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
143 /**
144  * @dev Contract module which allows children to implement an emergency stop
145  * mechanism that can be triggered by an authorized account.
146  *
147  * This module is used through inheritance. It will make available the
148  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
149  * the functions of your contract. Note that they will not be pausable by
150  * simply including this module, only once the modifiers are put in place.
151  */
152 abstract contract Pausable is Context {
153     /**
154      * @dev Emitted when the pause is triggered by `account`.
155      */
156     event Paused(address account);
157 
158     /**
159      * @dev Emitted when the pause is lifted by `account`.
160      */
161     event Unpaused(address account);
162 
163     bool private _paused;
164 
165     /**
166      * @dev Initializes the contract in unpaused state.
167      */
168     constructor() {
169         _paused = false;
170     }
171 
172     /**
173      * @dev Returns true if the contract is paused, and false otherwise.
174      */
175     function paused() public view virtual returns (bool) {
176         return _paused;
177     }
178 
179     /**
180      * @dev Modifier to make a function callable only when the contract is not paused.
181      *
182      * Requirements:
183      *
184      * - The contract must not be paused.
185      */
186     modifier whenNotPaused() {
187         require(!paused(), "Pausable: paused");
188         _;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is paused.
193      *
194      * Requirements:
195      *
196      * - The contract must be paused.
197      */
198     modifier whenPaused() {
199         require(paused(), "Pausable: not paused");
200         _;
201     }
202 
203     /**
204      * @dev Triggers stopped state.
205      *
206      * Requirements:
207      *
208      * - The contract must not be paused.
209      */
210     function _pause() internal virtual whenNotPaused {
211         _paused = true;
212         emit Paused(_msgSender());
213     }
214 
215     /**
216      * @dev Returns to normal state.
217      *
218      * Requirements:
219      *
220      * - The contract must be paused.
221      */
222     function _unpause() internal virtual whenPaused {
223         _paused = false;
224         emit Unpaused(_msgSender());
225     }
226 }
227 
228 
229 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
230 /// @notice A Pausable contract that can only be toggled by the Owner.
231 contract OwnerPausable is Ownable, Pausable {
232     /// @notice Pauses the contract.
233     function pause() public onlyOwner {
234         Pausable._pause();
235     }
236 
237     /// @notice Unpauses the contract.
238     function unpause() public onlyOwner {
239         Pausable._unpause();
240     }
241 }
242 
243 
244 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
245 /**
246  * @dev Interface of the ERC165 standard, as defined in the
247  * https://eips.ethereum.org/EIPS/eip-165[EIP].
248  *
249  * Implementers can declare support of contract interfaces, which can then be
250  * queried by others ({ERC165Checker}).
251  *
252  * For an implementation, see {ERC165}.
253  */
254 interface IERC165 {
255     /**
256      * @dev Returns true if this contract implements the interface defined by
257      * `interfaceId`. See the corresponding
258      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
259      * to learn more about how these ids are created.
260      *
261      * This function call must use less than 30 000 gas.
262      */
263     function supportsInterface(bytes4 interfaceId) external view returns (bool);
264 }
265 
266 
267 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
268 /**
269  * @dev Required interface of an ERC721 compliant contract.
270  */
271 interface IERC721 is IERC165 {
272     /**
273      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
274      */
275     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
276 
277     /**
278      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
279      */
280     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
281 
282     /**
283      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
284      */
285     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
286 
287     /**
288      * @dev Returns the number of tokens in ``owner``'s account.
289      */
290     function balanceOf(address owner) external view returns (uint256 balance);
291 
292     /**
293      * @dev Returns the owner of the `tokenId` token.
294      *
295      * Requirements:
296      *
297      * - `tokenId` must exist.
298      */
299     function ownerOf(uint256 tokenId) external view returns (address owner);
300 
301     /**
302      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
303      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must exist and be owned by `from`.
310      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
312      *
313      * Emits a {Transfer} event.
314      */
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external;
320 
321     /**
322      * @dev Transfers `tokenId` token from `from` to `to`.
323      *
324      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(
336         address from,
337         address to,
338         uint256 tokenId
339     ) external;
340 
341     /**
342      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
343      * The approval is cleared when the token is transferred.
344      *
345      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
346      *
347      * Requirements:
348      *
349      * - The caller must own the token or be an approved operator.
350      * - `tokenId` must exist.
351      *
352      * Emits an {Approval} event.
353      */
354     function approve(address to, uint256 tokenId) external;
355 
356     /**
357      * @dev Returns the account approved for `tokenId` token.
358      *
359      * Requirements:
360      *
361      * - `tokenId` must exist.
362      */
363     function getApproved(uint256 tokenId) external view returns (address operator);
364 
365     /**
366      * @dev Approve or remove `operator` as an operator for the caller.
367      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
368      *
369      * Requirements:
370      *
371      * - The `operator` cannot be the caller.
372      *
373      * Emits an {ApprovalForAll} event.
374      */
375     function setApprovalForAll(address operator, bool _approved) external;
376 
377     /**
378      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
379      *
380      * See {setApprovalForAll}
381      */
382     function isApprovedForAll(address owner, address operator) external view returns (bool);
383 
384     /**
385      * @dev Safely transfers `tokenId` token from `from` to `to`.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
394      *
395      * Emits a {Transfer} event.
396      */
397     function safeTransferFrom(
398         address from,
399         address to,
400         uint256 tokenId,
401         bytes calldata data
402     ) external;
403 }
404 
405 
406 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 
431 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
432 /**
433  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
434  * @dev See https://eips.ethereum.org/EIPS/eip-721
435  */
436 interface IERC721Metadata is IERC721 {
437     /**
438      * @dev Returns the token collection name.
439      */
440     function name() external view returns (string memory);
441 
442     /**
443      * @dev Returns the token collection symbol.
444      */
445     function symbol() external view returns (string memory);
446 
447     /**
448      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
449      */
450     function tokenURI(uint256 tokenId) external view returns (string memory);
451 }
452 
453 
454 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
455 /**
456  * @dev Collection of functions related to the address type
457  */
458 library Address {
459     /**
460      * @dev Returns true if `account` is a contract.
461      *
462      * [IMPORTANT]
463      * ====
464      * It is unsafe to assume that an address for which this function returns
465      * false is an externally-owned account (EOA) and not a contract.
466      *
467      * Among others, `isContract` will return false for the following
468      * types of addresses:
469      *
470      *  - an externally-owned account
471      *  - a contract in construction
472      *  - an address where a contract will be created
473      *  - an address where a contract lived, but was destroyed
474      * ====
475      */
476     function isContract(address account) internal view returns (bool) {
477         // This method relies on extcodesize, which returns 0 for contracts in
478         // construction, since the code is only stored at the end of the
479         // constructor execution.
480 
481         uint256 size;
482         assembly {
483             size := extcodesize(account)
484         }
485         return size > 0;
486     }
487 
488     /**
489      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
490      * `recipient`, forwarding all available gas and reverting on errors.
491      *
492      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
493      * of certain opcodes, possibly making contracts go over the 2300 gas limit
494      * imposed by `transfer`, making them unable to receive funds via
495      * `transfer`. {sendValue} removes this limitation.
496      *
497      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
498      *
499      * IMPORTANT: because control is transferred to `recipient`, care must be
500      * taken to not create reentrancy vulnerabilities. Consider using
501      * {ReentrancyGuard} or the
502      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
503      */
504     function sendValue(address payable recipient, uint256 amount) internal {
505         require(address(this).balance >= amount, "Address: insufficient balance");
506 
507         (bool success, ) = recipient.call{value: amount}("");
508         require(success, "Address: unable to send value, recipient may have reverted");
509     }
510 
511     /**
512      * @dev Performs a Solidity function call using a low level `call`. A
513      * plain `call` is an unsafe replacement for a function call: use this
514      * function instead.
515      *
516      * If `target` reverts with a revert reason, it is bubbled up by this
517      * function (like regular Solidity function calls).
518      *
519      * Returns the raw returned data. To convert to the expected return value,
520      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
521      *
522      * Requirements:
523      *
524      * - `target` must be a contract.
525      * - calling `target` with `data` must not revert.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
530         return functionCall(target, data, "Address: low-level call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
535      * `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         return functionCallWithValue(target, data, 0, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but also transferring `value` wei to `target`.
550      *
551      * Requirements:
552      *
553      * - the calling contract must have an ETH balance of at least `value`.
554      * - the called Solidity function must be `payable`.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(
559         address target,
560         bytes memory data,
561         uint256 value
562     ) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
568      * with `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(
573         address target,
574         bytes memory data,
575         uint256 value,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         require(address(this).balance >= value, "Address: insufficient balance for call");
579         require(isContract(target), "Address: call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.call{value: value}(data);
582         return verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but performing a static call.
588      *
589      * _Available since v3.3._
590      */
591     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
592         return functionStaticCall(target, data, "Address: low-level static call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(
602         address target,
603         bytes memory data,
604         string memory errorMessage
605     ) internal view returns (bytes memory) {
606         require(isContract(target), "Address: static call to non-contract");
607 
608         (bool success, bytes memory returndata) = target.staticcall(data);
609         return verifyCallResult(success, returndata, errorMessage);
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         require(isContract(target), "Address: delegate call to non-contract");
634 
635         (bool success, bytes memory returndata) = target.delegatecall(data);
636         return verifyCallResult(success, returndata, errorMessage);
637     }
638 
639     /**
640      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
641      * revert reason using the provided one.
642      *
643      * _Available since v4.3._
644      */
645     function verifyCallResult(
646         bool success,
647         bytes memory returndata,
648         string memory errorMessage
649     ) internal pure returns (bytes memory) {
650         if (success) {
651             return returndata;
652         } else {
653             // Look for revert reason and bubble it up if present
654             if (returndata.length > 0) {
655                 // The easiest way to bubble the revert reason is using memory via assembly
656 
657                 assembly {
658                     let returndata_size := mload(returndata)
659                     revert(add(32, returndata), returndata_size)
660                 }
661             } else {
662                 revert(errorMessage);
663             }
664         }
665     }
666 }
667 
668 
669 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
733 
734 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
735 /**
736  * @dev Implementation of the {IERC165} interface.
737  *
738  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
739  * for the additional interface id that will be supported. For example:
740  *
741  * ```solidity
742  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
744  * }
745  * ```
746  *
747  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
748  */
749 abstract contract ERC165 is IERC165 {
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754         return interfaceId == type(IERC165).interfaceId;
755     }
756 }
757 
758 
759 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension, but not including the Enumerable extension, which is available separately as
763  * {ERC721Enumerable}.
764  */
765 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Token name
770     string private _name;
771 
772     // Token symbol
773     string private _symbol;
774 
775     // Mapping from token ID to owner address
776     mapping(uint256 => address) private _owners;
777 
778     // Mapping owner address to token count
779     mapping(address => uint256) private _balances;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     /**
788      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
789      */
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793     }
794 
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
799         return
800             interfaceId == type(IERC721).interfaceId ||
801             interfaceId == type(IERC721Metadata).interfaceId ||
802             super.supportsInterface(interfaceId);
803     }
804 
805     /**
806      * @dev See {IERC721-balanceOf}.
807      */
808     function balanceOf(address owner) public view virtual override returns (uint256) {
809         require(owner != address(0), "ERC721: balance query for the zero address");
810         return _balances[owner];
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
817         address owner = _owners[tokenId];
818         require(owner != address(0), "ERC721: owner query for nonexistent token");
819         return owner;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-name}.
824      */
825     function name() public view virtual override returns (string memory) {
826         return _name;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-symbol}.
831      */
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-tokenURI}.
838      */
839     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
840         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
841 
842         string memory baseURI = _baseURI();
843         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, can be overriden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return "";
853     }
854 
855     /**
856      * @dev See {IERC721-approve}.
857      */
858     function approve(address to, uint256 tokenId) public virtual override {
859         address owner = ERC721.ownerOf(tokenId);
860         require(to != owner, "ERC721: approval to current owner");
861 
862         require(
863             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
864             "ERC721: approve caller is not owner nor approved for all"
865         );
866 
867         _approve(to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-getApproved}.
872      */
873     function getApproved(uint256 tokenId) public view virtual override returns (address) {
874         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
875 
876         return _tokenApprovals[tokenId];
877     }
878 
879     /**
880      * @dev See {IERC721-setApprovalForAll}.
881      */
882     function setApprovalForAll(address operator, bool approved) public virtual override {
883         _setApprovalForAll(_msgSender(), operator, approved);
884     }
885 
886     /**
887      * @dev See {IERC721-isApprovedForAll}.
888      */
889     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
890         return _operatorApprovals[owner][operator];
891     }
892 
893     /**
894      * @dev See {IERC721-transferFrom}.
895      */
896     function transferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         //solhint-disable-next-line max-line-length
902         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
903 
904         _transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, "");
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public virtual override {
927         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
928         _safeTransfer(from, to, tokenId, _data);
929     }
930 
931     /**
932      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
933      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
934      *
935      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
936      *
937      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
938      * implement alternative mechanisms to perform token transfer, such as signature-based.
939      *
940      * Requirements:
941      *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must exist and be owned by `from`.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeTransfer(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) internal virtual {
955         _transfer(from, to, tokenId);
956         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      * and stop existing when they are burned (`_burn`).
966      */
967     function _exists(uint256 tokenId) internal view virtual returns (bool) {
968         return _owners[tokenId] != address(0);
969     }
970 
971     /**
972      * @dev Returns whether `spender` is allowed to manage `tokenId`.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must exist.
977      */
978     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
979         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
980         address owner = ERC721.ownerOf(tokenId);
981         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
982     }
983 
984     /**
985      * @dev Safely mints `tokenId` and transfers it to `to`.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must not exist.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _safeMint(address to, uint256 tokenId) internal virtual {
995         _safeMint(to, tokenId, "");
996     }
997 
998     /**
999      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1000      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1001      */
1002     function _safeMint(
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) internal virtual {
1007         _mint(to, tokenId);
1008         require(
1009             _checkOnERC721Received(address(0), to, tokenId, _data),
1010             "ERC721: transfer to non ERC721Receiver implementer"
1011         );
1012     }
1013 
1014     /**
1015      * @dev Mints `tokenId` and transfers it to `to`.
1016      *
1017      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must not exist.
1022      * - `to` cannot be the zero address.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _mint(address to, uint256 tokenId) internal virtual {
1027         require(to != address(0), "ERC721: mint to the zero address");
1028         require(!_exists(tokenId), "ERC721: token already minted");
1029 
1030         _beforeTokenTransfer(address(0), to, tokenId);
1031 
1032         _balances[to] += 1;
1033         _owners[tokenId] = to;
1034 
1035         emit Transfer(address(0), to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Destroys `tokenId`.
1040      * The approval is cleared when the token is burned.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _burn(uint256 tokenId) internal virtual {
1049         address owner = ERC721.ownerOf(tokenId);
1050 
1051         _beforeTokenTransfer(owner, address(0), tokenId);
1052 
1053         // Clear approvals
1054         _approve(address(0), tokenId);
1055 
1056         _balances[owner] -= 1;
1057         delete _owners[tokenId];
1058 
1059         emit Transfer(owner, address(0), tokenId);
1060     }
1061 
1062     /**
1063      * @dev Transfers `tokenId` from `from` to `to`.
1064      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual {
1078         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1079         require(to != address(0), "ERC721: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(from, to, tokenId);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId);
1085 
1086         _balances[from] -= 1;
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(from, to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `to` to operate on `tokenId`
1095      *
1096      * Emits a {Approval} event.
1097      */
1098     function _approve(address to, uint256 tokenId) internal virtual {
1099         _tokenApprovals[tokenId] = to;
1100         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev Approve `operator` to operate on all of `owner` tokens
1105      *
1106      * Emits a {ApprovalForAll} event.
1107      */
1108     function _setApprovalForAll(
1109         address owner,
1110         address operator,
1111         bool approved
1112     ) internal virtual {
1113         require(owner != operator, "ERC721: approve to caller");
1114         _operatorApprovals[owner][operator] = approved;
1115         emit ApprovalForAll(owner, operator, approved);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver.onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert("ERC721: transfer to non ERC721Receiver implementer");
1140                 } else {
1141                     assembly {
1142                         revert(add(32, reason), mload(reason))
1143                     }
1144                 }
1145             }
1146         } else {
1147             return true;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Hook that is called before any token transfer. This includes minting
1153      * and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1161      * - `from` and `to` are never both zero.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _beforeTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {}
1170 }
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Pausable.sol)
1174 /**
1175  * @dev ERC721 token with pausable token transfers, minting and burning.
1176  *
1177  * Useful for scenarios such as preventing trades until the end of an evaluation
1178  * period, or having an emergency switch for freezing all token transfers in the
1179  * event of a large bug.
1180  */
1181 abstract contract ERC721Pausable is ERC721, Pausable {
1182     /**
1183      * @dev See {ERC721-_beforeTokenTransfer}.
1184      *
1185      * Requirements:
1186      *
1187      * - the contract must not be paused.
1188      */
1189     function _beforeTokenTransfer(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) internal virtual override {
1194         super._beforeTokenTransfer(from, to, tokenId);
1195 
1196         require(!paused(), "ERC721Pausable: token transfer while paused");
1197     }
1198 }
1199 
1200 
1201 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1202 /**
1203 @notice An ERC721 contract with common functionality:
1204  - OpenSea gas-free listings
1205  - OpenZeppelin Pausable
1206  - OpenZeppelin Pausable with functions exposed to Owner only
1207  */
1208 contract ERC721Common is Context, ERC721Pausable, OwnerPausable {
1209     constructor(string memory name, string memory symbol)
1210         ERC721(name, symbol)
1211     {}
1212 
1213     /// @notice Requires that the token exists.
1214     modifier tokenExists(uint256 tokenId) {
1215         require(ERC721._exists(tokenId), "ERC721Common: Token doesn't exist");
1216         _;
1217     }
1218 
1219     /// @notice Requires that msg.sender owns or is approved for the token.
1220     modifier onlyApprovedOrOwner(uint256 tokenId) {
1221         require(
1222             _isApprovedOrOwner(_msgSender(), tokenId),
1223             "ERC721Common: Not approved nor owner"
1224         );
1225         _;
1226     }
1227 
1228     /// @notice Overrides _beforeTokenTransfer as required by inheritance.
1229     function _beforeTokenTransfer(
1230         address from,
1231         address to,
1232         uint256 tokenId
1233     ) internal virtual override(ERC721Pausable) {
1234         super._beforeTokenTransfer(from, to, tokenId);
1235     }
1236 
1237     /// @notice Overrides supportsInterface as required by inheritance.
1238     function supportsInterface(bytes4 interfaceId)
1239         public
1240         view
1241         virtual
1242         override(ERC721)
1243         returns (bool)
1244     {
1245         return super.supportsInterface(interfaceId);
1246     }
1247 
1248     /**
1249     @notice Returns true if either standard isApprovedForAll() returns true or
1250     the operator is the OpenSea proxy for the owner.
1251      */
1252     function isApprovedForAll(address owner, address operator)
1253         public
1254         view
1255         virtual
1256         override
1257         returns (bool)
1258     {
1259         return
1260             super.isApprovedForAll(owner, operator) ||
1261             OpenSeaGasFreeListing.isApprovedForAll(owner, operator);
1262     }
1263 }
1264 
1265 
1266 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1267 /**
1268  * @dev Contract module that helps prevent reentrant calls to a function.
1269  *
1270  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1271  * available, which can be applied to functions to make sure there are no nested
1272  * (reentrant) calls to them.
1273  *
1274  * Note that because there is a single `nonReentrant` guard, functions marked as
1275  * `nonReentrant` may not call one another. This can be worked around by making
1276  * those functions `private`, and then adding `external` `nonReentrant` entry
1277  * points to them.
1278  *
1279  * TIP: If you would like to learn more about reentrancy and alternative ways
1280  * to protect against it, check out our blog post
1281  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1282  */
1283 abstract contract ReentrancyGuard {
1284     // Booleans are more expensive than uint256 or any type that takes up a full
1285     // word because each write operation emits an extra SLOAD to first read the
1286     // slot's contents, replace the bits taken up by the boolean, and then write
1287     // back. This is the compiler's defense against contract upgrades and
1288     // pointer aliasing, and it cannot be disabled.
1289 
1290     // The values being non-zero value makes deployment a bit more expensive,
1291     // but in exchange the refund on every call to nonReentrant will be lower in
1292     // amount. Since refunds are capped to a percentage of the total
1293     // transaction's gas, it is best to keep them low in cases like this one, to
1294     // increase the likelihood of the full refund coming into effect.
1295     uint256 private constant _NOT_ENTERED = 1;
1296     uint256 private constant _ENTERED = 2;
1297 
1298     uint256 private _status;
1299 
1300     constructor() {
1301         _status = _NOT_ENTERED;
1302     }
1303 
1304     /**
1305      * @dev Prevents a contract from calling itself, directly or indirectly.
1306      * Calling a `nonReentrant` function from another `nonReentrant`
1307      * function is not supported. It is possible to prevent this from happening
1308      * by making the `nonReentrant` function external, and making it call a
1309      * `private` function that does the actual work.
1310      */
1311     modifier nonReentrant() {
1312         // On the first call to nonReentrant, _notEntered will be true
1313         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1314 
1315         // Any calls to nonReentrant after this point will fail
1316         _status = _ENTERED;
1317 
1318         _;
1319 
1320         // By storing the original value once again, a refund is triggered (see
1321         // https://eips.ethereum.org/EIPS/eip-2200)
1322         _status = _NOT_ENTERED;
1323     }
1324 }
1325 
1326 
1327 contract McDoodleson is ERC721Common, ReentrancyGuard {
1328     using Strings for uint256;
1329 
1330     bool public saleActive;
1331     uint8 public constant MAX_MINT = 10;
1332     uint16 public _tokenIdTracker;
1333     uint16 public constant MAX_ITEMS = 8_888;
1334     uint256 public PRICE = 0.01 ether;
1335 
1336     address constant w1 = 0xAa8E615be791C34C894F1F36A2B6E0B6fF877c7c;
1337     address constant w2 = 0x370757417c9382E075C55B04D0914e5A97280C41;
1338 
1339     constructor(
1340         string memory name,
1341         string memory symbol
1342     )
1343         ERC721Common(name, symbol)
1344     {}
1345 
1346     function mint(address _to, uint16 _count) public payable 
1347         nonReentrant
1348         whenNotPaused {
1349         require(saleActive == true, "Sale has not yet started");
1350         require(_tokenIdTracker + _count <= MAX_ITEMS, "Max limit");
1351         require(_count <= MAX_MINT, "Exceeds number");
1352         if(_tokenIdTracker > 4_444) require(msg.value >= PRICE * _count, "Value below price");
1353 
1354         for (uint256 i = 0; i < _count; i++) {
1355             uint16 id = _tokenIdTracker;
1356             _tokenIdTracker++;
1357             _safeMint(_to, id);
1358         }
1359     }
1360 
1361     function setSaleStatus(bool _status) external onlyOwner {
1362         saleActive = _status;
1363     }
1364 
1365     function setPrice(uint256 _price) external onlyOwner {
1366         PRICE = _price;
1367     }
1368 
1369     /// @notice Prefix for tokenURI return values.
1370     string public baseTokenURI;
1371 
1372     /// @notice Set the baseTokenURI.
1373     function setBaseTokenURI(string memory baseTokenURI_) external onlyOwner {
1374         baseTokenURI = baseTokenURI_;
1375     }
1376 
1377     /// @notice Returns the token's metadata URI.
1378     function tokenURI(uint256 tokenId)
1379         public
1380         view
1381         override
1382         tokenExists(tokenId)
1383         returns (string memory)
1384     {
1385         return bytes(baseTokenURI).length > 0 ? string(abi.encodePacked(baseTokenURI, tokenId.toString())) : "";
1386     }
1387 
1388     /**
1389     @notice Returns total number of existing tokens.
1390     @dev Using ERC721Enumerable is unnecessarily expensive wrt gas. However
1391     Etherscan uses totalSupply() so we provide it here.
1392      */
1393     function totalSupply() external view returns (uint256) {
1394         return _tokenIdTracker;
1395     }
1396 
1397     function withdrawAll() public payable onlyOwner {
1398         uint256 balance = address(this).balance;
1399         require(balance > 0);
1400         _widthdraw(w1, balance * 80 / 100);
1401         _widthdraw(w2, address(this).balance);
1402     }
1403 
1404     function _widthdraw(address _address, uint256 _amount) private {
1405         (bool success,) = _address.call{value : _amount}("");
1406         require(success, "Transfer failed.");
1407     }
1408 }