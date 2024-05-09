1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
111 
112 
113 
114 /**
115  * @dev String operations.
116  */
117 library Strings {
118     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
122      */
123     function toString(uint256 value) internal pure returns (string memory) {
124         // Inspired by OraclizeAPI's implementation - MIT licence
125         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
126 
127         if (value == 0) {
128             return "0";
129         }
130         uint256 temp = value;
131         uint256 digits;
132         while (temp != 0) {
133             digits++;
134             temp /= 10;
135         }
136         bytes memory buffer = new bytes(digits);
137         while (value != 0) {
138             digits -= 1;
139             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
140             value /= 10;
141         }
142         return string(buffer);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
147      */
148     function toHexString(uint256 value) internal pure returns (string memory) {
149         if (value == 0) {
150             return "0x00";
151         }
152         uint256 temp = value;
153         uint256 length = 0;
154         while (temp != 0) {
155             length++;
156             temp >>= 8;
157         }
158         return toHexString(value, length);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
163      */
164     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
165         bytes memory buffer = new bytes(2 * length + 2);
166         buffer[0] = "0";
167         buffer[1] = "x";
168         for (uint256 i = 2 * length + 1; i > 1; --i) {
169             buffer[i] = _HEX_SYMBOLS[value & 0xf];
170             value >>= 4;
171         }
172         require(value == 0, "Strings: hex length insufficient");
173         return string(buffer);
174     }
175 }
176 
177 
178 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
182 
183 
184 
185 /**
186  * @dev Interface of the ERC165 standard, as defined in the
187  * https://eips.ethereum.org/EIPS/eip-165[EIP].
188  *
189  * Implementers can declare support of contract interfaces, which can then be
190  * queried by others ({ERC165Checker}).
191  *
192  * For an implementation, see {ERC165}.
193  */
194 interface IERC165 {
195     /**
196      * @dev Returns true if this contract implements the interface defined by
197      * `interfaceId`. See the corresponding
198      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
199      * to learn more about how these ids are created.
200      *
201      * This function call must use less than 30 000 gas.
202      */
203     function supportsInterface(bytes4 interfaceId) external view returns (bool);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
211 
212 
213 
214 /**
215  * @dev Required interface of an ERC721 compliant contract.
216  */
217 interface IERC721 is IERC165 {
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
230      */
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237 
238     /**
239      * @dev Returns the owner of the `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function ownerOf(uint256 tokenId) external view returns (address owner);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
249      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external;
266 
267     /**
268      * @dev Transfers `tokenId` token from `from` to `to`.
269      *
270      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
292      *
293      * Requirements:
294      *
295      * - The caller must own the token or be an approved operator.
296      * - `tokenId` must exist.
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address to, uint256 tokenId) external;
301 
302     /**
303      * @dev Returns the account approved for `tokenId` token.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must exist.
308      */
309     function getApproved(uint256 tokenId) external view returns (address operator);
310 
311     /**
312      * @dev Approve or remove `operator` as an operator for the caller.
313      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
314      *
315      * Requirements:
316      *
317      * - The `operator` cannot be the caller.
318      *
319      * Emits an {ApprovalForAll} event.
320      */
321     function setApprovalForAll(address operator, bool _approved) external;
322 
323     /**
324      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
325      *
326      * See {setApprovalForAll}
327      */
328     function isApprovedForAll(address owner, address operator) external view returns (bool);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must exist and be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
340      *
341      * Emits a {Transfer} event.
342      */
343     function safeTransferFrom(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes calldata data
348     ) external;
349 }
350 
351 
352 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
356 
357 
358 
359 /**
360  * @title ERC721 token receiver interface
361  * @dev Interface for any contract that wants to support safeTransfers
362  * from ERC721 asset contracts.
363  */
364 interface IERC721Receiver {
365     /**
366      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
367      * by `operator` from `from`, this function is called.
368      *
369      * It must return its Solidity selector to confirm the token transfer.
370      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
371      *
372      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
373      */
374     function onERC721Received(
375         address operator,
376         address from,
377         uint256 tokenId,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 
383 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
387 
388 
389 
390 /**
391  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
392  * @dev See https://eips.ethereum.org/EIPS/eip-721
393  */
394 interface IERC721Metadata is IERC721 {
395     /**
396      * @dev Returns the token collection name.
397      */
398     function name() external view returns (string memory);
399 
400     /**
401      * @dev Returns the token collection symbol.
402      */
403     function symbol() external view returns (string memory);
404 
405     /**
406      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
407      */
408     function tokenURI(uint256 tokenId) external view returns (string memory);
409 }
410 
411 
412 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
416 
417 
418 
419 /**
420  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
421  * @dev See https://eips.ethereum.org/EIPS/eip-721
422  */
423 interface IERC721Enumerable is IERC721 {
424     /**
425      * @dev Returns the total amount of tokens stored by the contract.
426      */
427     function totalSupply() external view returns (uint256);
428 
429     /**
430      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
431      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
432      */
433     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
434 
435     /**
436      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
437      * Use along with {totalSupply} to enumerate all tokens.
438      */
439     function tokenByIndex(uint256 index) external view returns (uint256);
440 }
441 
442 
443 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
447 
448 
449 
450 /**
451  * @dev Collection of functions related to the address type
452  */
453 library Address {
454     /**
455      * @dev Returns true if `account` is a contract.
456      *
457      * [IMPORTANT]
458      * ====
459      * It is unsafe to assume that an address for which this function returns
460      * false is an externally-owned account (EOA) and not a contract.
461      *
462      * Among others, `isContract` will return false for the following
463      * types of addresses:
464      *
465      *  - an externally-owned account
466      *  - a contract in construction
467      *  - an address where a contract will be created
468      *  - an address where a contract lived, but was destroyed
469      * ====
470      */
471     function isContract(address account) internal view returns (bool) {
472         // This method relies on extcodesize, which returns 0 for contracts in
473         // construction, since the code is only stored at the end of the
474         // constructor execution.
475 
476         uint256 size;
477         assembly {
478             size := extcodesize(account)
479         }
480         return size > 0;
481     }
482 
483     /**
484      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
485      * `recipient`, forwarding all available gas and reverting on errors.
486      *
487      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
488      * of certain opcodes, possibly making contracts go over the 2300 gas limit
489      * imposed by `transfer`, making them unable to receive funds via
490      * `transfer`. {sendValue} removes this limitation.
491      *
492      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
493      *
494      * IMPORTANT: because control is transferred to `recipient`, care must be
495      * taken to not create reentrancy vulnerabilities. Consider using
496      * {ReentrancyGuard} or the
497      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
498      */
499     function sendValue(address payable recipient, uint256 amount) internal {
500         require(address(this).balance >= amount, "Address: insufficient balance");
501 
502         (bool success, ) = recipient.call{value: amount}("");
503         require(success, "Address: unable to send value, recipient may have reverted");
504     }
505 
506     /**
507      * @dev Performs a Solidity function call using a low level `call`. A
508      * plain `call` is an unsafe replacement for a function call: use this
509      * function instead.
510      *
511      * If `target` reverts with a revert reason, it is bubbled up by this
512      * function (like regular Solidity function calls).
513      *
514      * Returns the raw returned data. To convert to the expected return value,
515      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
516      *
517      * Requirements:
518      *
519      * - `target` must be a contract.
520      * - calling `target` with `data` must not revert.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionCall(target, data, "Address: low-level call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
530      * `errorMessage` as a fallback revert reason when `target` reverts.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         return functionCallWithValue(target, data, 0, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but also transferring `value` wei to `target`.
545      *
546      * Requirements:
547      *
548      * - the calling contract must have an ETH balance of at least `value`.
549      * - the called Solidity function must be `payable`.
550      *
551      * _Available since v3.1._
552      */
553     function functionCallWithValue(
554         address target,
555         bytes memory data,
556         uint256 value
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
563      * with `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.call{value: value}(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal view returns (bytes memory) {
601         require(isContract(target), "Address: static call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.staticcall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a delegate call.
610      *
611      * _Available since v3.4._
612      */
613     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
614         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal returns (bytes memory) {
628         require(isContract(target), "Address: delegate call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
636      * revert reason using the provided one.
637      *
638      * _Available since v4.3._
639      */
640     function verifyCallResult(
641         bool success,
642         bytes memory returndata,
643         string memory errorMessage
644     ) internal pure returns (bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }
662 
663 
664 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
668 
669 
670 
671 /**
672  * @dev Implementation of the {IERC165} interface.
673  *
674  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
675  * for the additional interface id that will be supported. For example:
676  *
677  * ```solidity
678  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
680  * }
681  * ```
682  *
683  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
684  */
685 abstract contract ERC165 is IERC165 {
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         return interfaceId == type(IERC165).interfaceId;
691     }
692 }
693 
694 
695 // File contracts/ERC721A.sol
696 
697 
698 // Creator: Chiru Labs
699 
700 
701 /**
702  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
703  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
704  *
705  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
706  *
707  * Does not support burning tokens to address(0).
708  *
709  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
710  */
711 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
712     using Address for address;
713     using Strings for uint256;
714 
715     struct TokenOwnership {
716         address addr;
717         uint64 startTimestamp;
718     }
719 
720     struct AddressData {
721         uint128 balance;
722         uint128 numberMinted;
723     }
724 
725     uint256 internal currentIndex = 0;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to ownership details
734     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
735     mapping(uint256 => TokenOwnership) internal _ownerships;
736 
737     // Mapping owner address to address data
738     mapping(address => AddressData) private _addressData;
739 
740     // Mapping from token ID to approved address
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC721Enumerable-totalSupply}.
753      */
754     function totalSupply() public view override returns (uint256) {
755         return currentIndex;
756     }
757 
758     /**
759      * @dev See {IERC721Enumerable-tokenByIndex}.
760      */
761     function tokenByIndex(uint256 index) public view override returns (uint256) {
762         require(index < totalSupply(), 'ERC721A: global index out of bounds');
763         return index;
764     }
765 
766     /**
767      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
768      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
769      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
770      */
771     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
772         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
773         uint256 numMintedSoFar = totalSupply();
774         uint256 tokenIdsIdx = 0;
775         address currOwnershipAddr = address(0);
776         for (uint256 i = 0; i < numMintedSoFar; i++) {
777             TokenOwnership memory ownership = _ownerships[i];
778             if (ownership.addr != address(0)) {
779                 currOwnershipAddr = ownership.addr;
780             }
781             if (currOwnershipAddr == owner) {
782                 if (tokenIdsIdx == index) {
783                     return i;
784                 }
785                 tokenIdsIdx++;
786             }
787         }
788         revert('ERC721A: unable to get token of owner by index');
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             interfaceId == type(IERC721Enumerable).interfaceId ||
799             super.supportsInterface(interfaceId);
800     }
801 
802     /**
803      * @dev See {IERC721-balanceOf}.
804      */
805     function balanceOf(address owner) public view override returns (uint256) {
806         require(owner != address(0), 'ERC721A: balance query for the zero address');
807         return uint256(_addressData[owner].balance);
808     }
809 
810     function _numberMinted(address owner) internal view returns (uint256) {
811         require(owner != address(0), 'ERC721A: number minted query for the zero address');
812         return uint256(_addressData[owner].numberMinted);
813     }
814 
815     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
816         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
817 
818         for (uint256 curr = tokenId; ; curr--) {
819             TokenOwnership memory ownership = _ownerships[curr];
820             if (ownership.addr != address(0)) {
821                 return ownership;
822             }
823         }
824 
825         revert('ERC721A: unable to determine the owner of token');
826     }
827 
828     /**
829      * @dev See {IERC721-ownerOf}.
830      */
831     function ownerOf(uint256 tokenId) public view override returns (address) {
832         return ownershipOf(tokenId).addr;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-name}.
837      */
838     function name() public view virtual override returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-symbol}.
844      */
845     function symbol() public view virtual override returns (string memory) {
846         return _symbol;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-tokenURI}.
851      */
852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
853         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
854 
855         string memory baseURI = _baseURI();
856         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
857     }
858 
859     /**
860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
862      * by default, can be overriden in child contracts.
863      */
864     function _baseURI() internal view virtual returns (string memory) {
865         return '';
866     }
867 
868     /**
869      * @dev See {IERC721-approve}.
870      */
871     function approve(address to, uint256 tokenId) public override {
872         address owner = ERC721A.ownerOf(tokenId);
873         require(to != owner, 'ERC721A: approval to current owner');
874 
875         require(
876             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
877             'ERC721A: approve caller is not owner nor approved for all'
878         );
879 
880         _approve(to, tokenId, owner);
881     }
882 
883     /**
884      * @dev See {IERC721-getApproved}.
885      */
886     function getApproved(uint256 tokenId) public view override returns (address) {
887         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
888 
889         return _tokenApprovals[tokenId];
890     }
891 
892     /**
893      * @dev See {IERC721-setApprovalForAll}.
894      */
895     function setApprovalForAll(address operator, bool approved) public override {
896         require(operator != _msgSender(), 'ERC721A: approve to caller');
897 
898         _operatorApprovals[_msgSender()][operator] = approved;
899         emit ApprovalForAll(_msgSender(), operator, approved);
900     }
901 
902     /**
903      * @dev See {IERC721-isApprovedForAll}.
904      */
905     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
906         return _operatorApprovals[owner][operator];
907     }
908 
909     /**
910      * @dev See {IERC721-transferFrom}.
911      */
912     function transferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public override {
917         _transfer(from, to, tokenId);
918     }
919 
920     /**
921      * @dev See {IERC721-safeTransferFrom}.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public override {
928         safeTransferFrom(from, to, tokenId, '');
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) public override {
940         _transfer(from, to, tokenId);
941         require(
942             _checkOnERC721Received(from, to, tokenId, _data),
943             'ERC721A: transfer to non ERC721Receiver implementer'
944         );
945     }
946 
947     /**
948      * @dev Returns whether `tokenId` exists.
949      *
950      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
951      *
952      * Tokens start existing when they are minted (`_mint`),
953      */
954     function _exists(uint256 tokenId) internal view returns (bool) {
955         return tokenId < currentIndex;
956     }
957 
958     function _safeMint(address to, uint256 quantity) internal {
959         _safeMint(to, quantity, '');
960     }
961 
962     /**
963      * @dev Mints `quantity` tokens and transfers them to `to`.
964      *
965      * Requirements:
966      *
967      * - `to` cannot be the zero address.
968      * - `quantity` cannot be larger than the max batch size.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(
973         address to,
974         uint256 quantity,
975         bytes memory _data
976     ) internal {
977         uint256 startTokenId = currentIndex;
978         require(to != address(0), 'ERC721A: mint to the zero address');
979         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
980         require(!_exists(startTokenId), 'ERC721A: token already minted');
981         require(quantity > 0, 'ERC721A: quantity must be greater 0');
982 
983         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
984 
985         AddressData memory addressData = _addressData[to];
986         _addressData[to] = AddressData(
987             addressData.balance + uint128(quantity),
988             addressData.numberMinted + uint128(quantity)
989         );
990         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
991 
992         uint256 updatedIndex = startTokenId;
993 
994         for (uint256 i = 0; i < quantity; i++) {
995             emit Transfer(address(0), to, updatedIndex);
996             require(
997                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
998                 'ERC721A: transfer to non ERC721Receiver implementer'
999             );
1000             updatedIndex++;
1001         }
1002 
1003         currentIndex = updatedIndex;
1004         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1005     }
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) private {
1022         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1023 
1024         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1025             getApproved(tokenId) == _msgSender() ||
1026             isApprovedForAll(prevOwnership.addr, _msgSender()));
1027 
1028         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1029 
1030         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1031         require(to != address(0), 'ERC721A: transfer to the zero address');
1032 
1033         _beforeTokenTransfers(from, to, tokenId, 1);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId, prevOwnership.addr);
1037 
1038         // Underflow of the sender's balance is impossible because we check for
1039         // ownership above and the recipient's balance can't realistically overflow.
1040         unchecked {
1041             _addressData[from].balance -= 1;
1042             _addressData[to].balance += 1;
1043         }
1044 
1045         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1046 
1047         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1048         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1049         uint256 nextTokenId = tokenId + 1;
1050         if (_ownerships[nextTokenId].addr == address(0)) {
1051             if (_exists(nextTokenId)) {
1052                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1053             }
1054         }
1055 
1056         emit Transfer(from, to, tokenId);
1057         _afterTokenTransfers(from, to, tokenId, 1);
1058     }
1059 
1060     /**
1061      * @dev Approve `to` to operate on `tokenId`
1062      *
1063      * Emits a {Approval} event.
1064      */
1065     function _approve(
1066         address to,
1067         uint256 tokenId,
1068         address owner
1069     ) private {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(owner, to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1076      * The call is not executed if the target address is not a contract.
1077      *
1078      * @param from address representing the previous owner of the given token ID
1079      * @param to target address that will receive the tokens
1080      * @param tokenId uint256 ID of the token to be transferred
1081      * @param _data bytes optional data to send along with the call
1082      * @return bool whether the call correctly returned the expected magic value
1083      */
1084     function _checkOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         if (to.isContract()) {
1091             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1092                 return retval == IERC721Receiver(to).onERC721Received.selector;
1093             } catch (bytes memory reason) {
1094                 if (reason.length == 0) {
1095                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1096                 } else {
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1109      *
1110      * startTokenId - the first token id to be transferred
1111      * quantity - the amount to be transferred
1112      *
1113      * Calling conditions:
1114      *
1115      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1116      * transferred to `to`.
1117      * - When `from` is zero, `tokenId` will be minted for `to`.
1118      */
1119     function _beforeTokenTransfers(
1120         address from,
1121         address to,
1122         uint256 startTokenId,
1123         uint256 quantity
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1128      * minting.
1129      *
1130      * startTokenId - the first token id to be transferred
1131      * quantity - the amount to be transferred
1132      *
1133      * Calling conditions:
1134      *
1135      * - when `from` and `to` are both non-zero.
1136      * - `from` and `to` are never both zero.
1137      */
1138     function _afterTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 }
1145 
1146 
1147 // File contracts/tubbyBearsNFT.sol
1148 
1149 
1150 contract tubbyBearsNFT is ERC721A, Ownable {
1151 
1152     string public baseURI = "";
1153     string public contractURI = "";
1154     string public constant baseExtension = ".json";
1155     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1156 
1157     uint256 public constant MAX_PER_TX_FREE = 10;
1158     uint256 public constant MAX_PER_TX = 10;
1159     uint256 public constant FREE_MAX_SUPPLY = 750;
1160     uint256 public constant MAX_SUPPLY = 4000;
1161     uint256 public constant MAX_PER_WALLET = 30;
1162     uint256 public price = 0.006 ether;
1163 
1164     bool public paused = true;
1165 
1166     constructor() ERC721A("Tubby Bears", "BEARS") {}
1167 
1168     function mint(uint256 _amount) external payable {
1169         address _caller = _msgSender();
1170         uint256 ownerTokenCount = balanceOf(_caller);
1171         require(!paused, "Paused");
1172         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1173         require(_amount > 0, "No 0 mints");
1174         require(tx.origin == _caller, "No contracts");
1175         require(ownerTokenCount < MAX_PER_WALLET, "Exceeds max token count per wallet");
1176 
1177         if(FREE_MAX_SUPPLY >= totalSupply()){
1178             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1179         }else{
1180             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1181             require(_amount * price == msg.value, "Invalid funds provided");
1182         }
1183 
1184         _safeMint(_caller, _amount);
1185     }
1186 
1187     function setCost(uint256 _newCost) public onlyOwner {
1188         price = _newCost;
1189     }
1190 
1191     function isApprovedForAll(address owner, address operator)
1192         override
1193         public
1194         view
1195         returns (bool)
1196     {
1197         // Whitelist OpenSea proxy contract for easy trading.
1198         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1199         if (address(proxyRegistry.proxies(owner)) == operator) {
1200             return true;
1201         }
1202 
1203         return super.isApprovedForAll(owner, operator);
1204     }
1205 
1206     function withdraw() external onlyOwner {
1207         uint256 balance = address(this).balance;
1208         (bool success, ) = _msgSender().call{value: balance}("");
1209         require(success, "Failed to send");
1210     }
1211 
1212     function setupOS() external onlyOwner {
1213         _safeMint(_msgSender(), 1);
1214     }
1215 
1216     function pause(bool _state) external onlyOwner {
1217         paused = _state;
1218     }
1219 
1220     function setBaseURI(string memory baseURI_) external onlyOwner {
1221         baseURI = baseURI_;
1222     }
1223 
1224     function setContractURI(string memory _contractURI) external onlyOwner {
1225         contractURI = _contractURI;
1226     }
1227 
1228     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1229         require(_exists(_tokenId), "Token does not exist.");
1230         return bytes(baseURI).length > 0 ? string(
1231             abi.encodePacked(
1232               baseURI,
1233               Strings.toString(_tokenId),
1234               baseExtension
1235             )
1236         ) : "";
1237     }
1238 }
1239 
1240 contract OwnableDelegateProxy { }
1241 contract ProxyRegistry {
1242     mapping(address => OwnableDelegateProxy) public proxies;
1243 }