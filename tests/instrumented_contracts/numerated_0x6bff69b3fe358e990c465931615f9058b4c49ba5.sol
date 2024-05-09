1 // SPDX-License-Identifier: MIT
2 // File: contracts/KevFellaz.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-03-02
6 */
7 
8 // File: KevFellaz_flat.sol
9 
10 
11 // File: contracts/KevFellaz.sol
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-03-01
15 */
16 
17 // File: contracts/Sybermon789.sol
18 
19 /**
20  *Submitted for verification at Etherscan.io on 2022-03-01
21 */
22 
23 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 
50 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
51 
52 
53 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
54 
55 
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _transferOwnership(_msgSender());
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions anymore. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby removing any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public virtual onlyOwner {
104         _transferOwnership(address(0));
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _transferOwnership(newOwner);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Internal function without access restriction.
119      */
120     function _transferOwnership(address newOwner) internal virtual {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 
128 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
132 
133 
134 
135 /**
136  * @dev String operations.
137  */
138 library Strings {
139     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
143      */
144     function toString(uint256 value) internal pure returns (string memory) {
145         // Inspired by OraclizeAPI's implementation - MIT licence
146         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
147 
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
168      */
169     function toHexString(uint256 value) internal pure returns (string memory) {
170         if (value == 0) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (temp != 0) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value, length);
180     }
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
184      */
185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
186         bytes memory buffer = new bytes(2 * length + 2);
187         buffer[0] = "0";
188         buffer[1] = "x";
189         for (uint256 i = 2 * length + 1; i > 1; --i) {
190             buffer[i] = _HEX_SYMBOLS[value & 0xf];
191             value >>= 4;
192         }
193         require(value == 0, "Strings: hex length insufficient");
194         return string(buffer);
195     }
196 }
197 
198 
199 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
203 
204 
205 
206 /**
207  * @dev Interface of the ERC165 standard, as defined in the
208  * https://eips.ethereum.org/EIPS/eip-165[EIP].
209  *
210  * Implementers can declare support of contract interfaces, which can then be
211  * queried by others ({ERC165Checker}).
212  *
213  * For an implementation, see {ERC165}.
214  */
215 interface IERC165 {
216     /**
217      * @dev Returns true if this contract implements the interface defined by
218      * `interfaceId`. See the corresponding
219      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
220      * to learn more about how these ids are created.
221      *
222      * This function call must use less than 30 000 gas.
223      */
224     function supportsInterface(bytes4 interfaceId) external view returns (bool);
225 }
226 
227 
228 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
232 
233 
234 
235 /**
236  * @dev Required interface of an ERC721 compliant contract.
237  */
238 interface IERC721 is IERC165 {
239     /**
240      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
241      */
242     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
243 
244     /**
245      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
246      */
247     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
251      */
252     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
253 
254     /**
255      * @dev Returns the number of tokens in ``owner``'s account.
256      */
257     function balanceOf(address owner) external view returns (uint256 balance);
258 
259     /**
260      * @dev Returns the owner of the `tokenId` token.
261      *
262      * Requirements:
263      *
264      * - `tokenId` must exist.
265      */
266     function ownerOf(uint256 tokenId) external view returns (address owner);
267 
268     /**
269      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
270      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     /**
289      * @dev Transfers `tokenId` token from `from` to `to`.
290      *
291      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must be owned by `from`.
298      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(
303         address from,
304         address to,
305         uint256 tokenId
306     ) external;
307 
308     /**
309      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
310      * The approval is cleared when the token is transferred.
311      *
312      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
313      *
314      * Requirements:
315      *
316      * - The caller must own the token or be an approved operator.
317      * - `tokenId` must exist.
318      *
319      * Emits an {Approval} event.
320      */
321     function approve(address to, uint256 tokenId) external;
322 
323     /**
324      * @dev Returns the account approved for `tokenId` token.
325      *
326      * Requirements:
327      *
328      * - `tokenId` must exist.
329      */
330     function getApproved(uint256 tokenId) external view returns (address operator);
331 
332     /**
333      * @dev Approve or remove `operator` as an operator for the caller.
334      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
335      *
336      * Requirements:
337      *
338      * - The `operator` cannot be the caller.
339      *
340      * Emits an {ApprovalForAll} event.
341      */
342     function setApprovalForAll(address operator, bool _approved) external;
343 
344     /**
345      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
346      *
347      * See {setApprovalForAll}
348      */
349     function isApprovedForAll(address owner, address operator) external view returns (bool);
350 
351     /**
352      * @dev Safely transfers `tokenId` token from `from` to `to`.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `tokenId` token must exist and be owned by `from`.
359      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
360      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
361      *
362      * Emits a {Transfer} event.
363      */
364     function safeTransferFrom(
365         address from,
366         address to,
367         uint256 tokenId,
368         bytes calldata data
369     ) external;
370 }
371 
372 
373 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
377 
378 
379 
380 /**
381  * @title ERC721 token receiver interface
382  * @dev Interface for any contract that wants to support safeTransfers
383  * from ERC721 asset contracts.
384  */
385 interface IERC721Receiver {
386     /**
387      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
388      * by `operator` from `from`, this function is called.
389      *
390      * It must return its Solidity selector to confirm the token transfer.
391      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
392      *
393      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
394      */
395     function onERC721Received(
396         address operator,
397         address from,
398         uint256 tokenId,
399         bytes calldata data
400     ) external returns (bytes4);
401 }
402 
403 
404 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
408 
409 
410 
411 /**
412  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
413  * @dev See https://eips.ethereum.org/EIPS/eip-721
414  */
415 interface IERC721Metadata is IERC721 {
416     /**
417      * @dev Returns the token collection name.
418      */
419     function name() external view returns (string memory);
420 
421     /**
422      * @dev Returns the token collection symbol.
423      */
424     function symbol() external view returns (string memory);
425 
426     /**
427      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
428      */
429     function tokenURI(uint256 tokenId) external view returns (string memory);
430 }
431 
432 
433 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
437 
438 
439 
440 /**
441  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
442  * @dev See https://eips.ethereum.org/EIPS/eip-721
443  */
444 interface IERC721Enumerable is IERC721 {
445     /**
446      * @dev Returns the total amount of tokens stored by the contract.
447      */
448     function totalSupply() external view returns (uint256);
449 
450     /**
451      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
452      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
453      */
454     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
455 
456     /**
457      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
458      * Use along with {totalSupply} to enumerate all tokens.
459      */
460     function tokenByIndex(uint256 index) external view returns (uint256);
461 }
462 
463 
464 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
468 
469 
470 
471 /**
472  * @dev Collection of functions related to the address type
473  */
474 library Address {
475     /**
476      * @dev Returns true if `account` is a contract.
477      *
478      * [IMPORTANT]
479      * ====
480      * It is unsafe to assume that an address for which this function returns
481      * false is an externally-owned account (EOA) and not a contract.
482      *
483      * Among others, `isContract` will return false for the following
484      * types of addresses:
485      *
486      *  - an externally-owned account
487      *  - a contract in construction
488      *  - an address where a contract will be created
489      *  - an address where a contract lived, but was destroyed
490      * ====
491      */
492     function isContract(address account) internal view returns (bool) {
493         // This method relies on extcodesize, which returns 0 for contracts in
494         // construction, since the code is only stored at the end of the
495         // constructor execution.
496 
497         uint256 size;
498         assembly {
499             size := extcodesize(account)
500         }
501         return size > 0;
502     }
503 
504     /**
505      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
506      * `recipient`, forwarding all available gas and reverting on errors.
507      *
508      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
509      * of certain opcodes, possibly making contracts go over the 2300 gas limit
510      * imposed by `transfer`, making them unable to receive funds via
511      * `transfer`. {sendValue} removes this limitation.
512      *
513      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
514      *
515      * IMPORTANT: because control is transferred to `recipient`, care must be
516      * taken to not create reentrancy vulnerabilities. Consider using
517      * {ReentrancyGuard} or the
518      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
519      */
520     function sendValue(address payable recipient, uint256 amount) internal {
521         require(address(this).balance >= amount, "Address: insufficient balance");
522 
523         (bool success, ) = recipient.call{value: amount}("");
524         require(success, "Address: unable to send value, recipient may have reverted");
525     }
526 
527     /**
528      * @dev Performs a Solidity function call using a low level `call`. A
529      * plain `call` is an unsafe replacement for a function call: use this
530      * function instead.
531      *
532      * If `target` reverts with a revert reason, it is bubbled up by this
533      * function (like regular Solidity function calls).
534      *
535      * Returns the raw returned data. To convert to the expected return value,
536      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
537      *
538      * Requirements:
539      *
540      * - `target` must be a contract.
541      * - calling `target` with `data` must not revert.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
546         return functionCall(target, data, "Address: low-level call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
551      * `errorMessage` as a fallback revert reason when `target` reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, 0, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but also transferring `value` wei to `target`.
566      *
567      * Requirements:
568      *
569      * - the calling contract must have an ETH balance of at least `value`.
570      * - the called Solidity function must be `payable`.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value
578     ) internal returns (bytes memory) {
579         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
584      * with `errorMessage` as a fallback revert reason when `target` reverts.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(
589         address target,
590         bytes memory data,
591         uint256 value,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         require(address(this).balance >= value, "Address: insufficient balance for call");
595         require(isContract(target), "Address: call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.call{value: value}(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
608         return functionStaticCall(target, data, "Address: low-level static call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal view returns (bytes memory) {
622         require(isContract(target), "Address: static call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.staticcall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
630      * but performing a delegate call.
631      *
632      * _Available since v3.4._
633      */
634     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
635         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal returns (bytes memory) {
649         require(isContract(target), "Address: delegate call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.delegatecall(data);
652         return verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
657      * revert reason using the provided one.
658      *
659      * _Available since v4.3._
660      */
661     function verifyCallResult(
662         bool success,
663         bytes memory returndata,
664         string memory errorMessage
665     ) internal pure returns (bytes memory) {
666         if (success) {
667             return returndata;
668         } else {
669             // Look for revert reason and bubble it up if present
670             if (returndata.length > 0) {
671                 // The easiest way to bubble the revert reason is using memory via assembly
672 
673                 assembly {
674                     let returndata_size := mload(returndata)
675                     revert(add(32, returndata), returndata_size)
676                 }
677             } else {
678                 revert(errorMessage);
679             }
680         }
681     }
682 }
683 
684 
685 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
689 
690 
691 
692 /**
693  * @dev Implementation of the {IERC165} interface.
694  *
695  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
696  * for the additional interface id that will be supported. For example:
697  *
698  * ```solidity
699  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
700  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
701  * }
702  * ```
703  *
704  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
705  */
706 abstract contract ERC165 is IERC165 {
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711         return interfaceId == type(IERC165).interfaceId;
712     }
713 }
714 
715 
716 // File contracts/ERC721A.sol
717 
718 
719 // Creator: Chiru Labs
720 
721 
722 /**
723  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
724  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
725  *
726  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
727  *
728  * Does not support burning tokens to address(0).
729  *
730  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
731  */
732 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
733     using Address for address;
734     using Strings for uint256;
735 
736     struct TokenOwnership {
737         address addr;
738         uint64 startTimestamp;
739     }
740 
741     struct AddressData {
742         uint128 balance;
743         uint128 numberMinted;
744     }
745 
746     uint256 internal currentIndex = 1;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to ownership details
755     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
756     mapping(uint256 => TokenOwnership) internal _ownerships;
757 
758     // Mapping owner address to address data
759     mapping(address => AddressData) private _addressData;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     constructor(string memory name_, string memory symbol_) {
768         _name = name_;
769         _symbol = symbol_;
770     }
771 
772     /**
773      * @dev See {IERC721Enumerable-totalSupply}.
774      */
775     function totalSupply() public view override returns (uint256) {
776         return currentIndex;
777     }
778 
779     /**
780      * @dev See {IERC721Enumerable-tokenByIndex}.
781      */
782     function tokenByIndex(uint256 index) public view override returns (uint256) {
783         require(index < totalSupply(), 'ERC721A: global index out of bounds');
784         return index;
785     }
786 
787     /**
788      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
789      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
790      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
791      */
792     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
793         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
794         uint256 numMintedSoFar = totalSupply();
795         uint256 tokenIdsIdx = 0;
796         address currOwnershipAddr = address(0);
797         for (uint256 i = 0; i < numMintedSoFar; i++) {
798             TokenOwnership memory ownership = _ownerships[i];
799             if (ownership.addr != address(0)) {
800                 currOwnershipAddr = ownership.addr;
801             }
802             if (currOwnershipAddr == owner) {
803                 if (tokenIdsIdx == index) {
804                     return i;
805                 }
806                 tokenIdsIdx++;
807             }
808         }
809         revert('ERC721A: unable to get token of owner by index');
810     }
811 
812     /**
813      * @dev See {IERC165-supportsInterface}.
814      */
815     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
816         return
817             interfaceId == type(IERC721).interfaceId ||
818             interfaceId == type(IERC721Metadata).interfaceId ||
819             interfaceId == type(IERC721Enumerable).interfaceId ||
820             super.supportsInterface(interfaceId);
821     }
822 
823     /**
824      * @dev See {IERC721-balanceOf}.
825      */
826     function balanceOf(address owner) public view override returns (uint256) {
827         require(owner != address(0), 'ERC721A: balance query for the zero address');
828         return uint256(_addressData[owner].balance);
829     }
830 
831     function _numberMinted(address owner) internal view returns (uint256) {
832         require(owner != address(0), 'ERC721A: number minted query for the zero address');
833         return uint256(_addressData[owner].numberMinted);
834     }
835 
836     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
837         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
838 
839         for (uint256 curr = tokenId; ; curr--) {
840             TokenOwnership memory ownership = _ownerships[curr];
841             if (ownership.addr != address(0)) {
842                 return ownership;
843             }
844         }
845 
846         revert('ERC721A: unable to determine the owner of token');
847     }
848 
849     /**
850      * @dev See {IERC721-ownerOf}.
851      */
852     function ownerOf(uint256 tokenId) public view override returns (address) {
853         return ownershipOf(tokenId).addr;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-name}.
858      */
859     function name() public view virtual override returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-symbol}.
865      */
866     function symbol() public view virtual override returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-tokenURI}.
872      */
873     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
874         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
875 
876         string memory baseURI = _baseURI();
877         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
878     }
879 
880     /**
881      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883      * by default, can be overriden in child contracts.
884      */
885     function _baseURI() internal view virtual returns (string memory) {
886         return '';
887     }
888 
889     /**
890      * @dev See {IERC721-approve}.
891      */
892     function approve(address to, uint256 tokenId) public override {
893         address owner = ERC721A.ownerOf(tokenId);
894         require(to != owner, 'ERC721A: approval to current owner');
895 
896         require(
897             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898             'ERC721A: approve caller is not owner nor approved for all'
899         );
900 
901         _approve(to, tokenId, owner);
902     }
903 
904     /**
905      * @dev See {IERC721-getApproved}.
906      */
907     function getApproved(uint256 tokenId) public view override returns (address) {
908         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
909 
910         return _tokenApprovals[tokenId];
911     }
912 
913     /**
914      * @dev See {IERC721-setApprovalForAll}.
915      */
916     function setApprovalForAll(address operator, bool approved) public override {
917         require(operator != _msgSender(), 'ERC721A: approve to caller');
918 
919         _operatorApprovals[_msgSender()][operator] = approved;
920         emit ApprovalForAll(_msgSender(), operator, approved);
921     }
922 
923     /**
924      * @dev See {IERC721-isApprovedForAll}.
925      */
926     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927         return _operatorApprovals[owner][operator];
928     }
929 
930     /**
931      * @dev See {IERC721-transferFrom}.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public override {
938         _transfer(from, to, tokenId);
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public override {
949         safeTransferFrom(from, to, tokenId, '');
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) public override {
961         _transfer(from, to, tokenId);
962         require(
963             _checkOnERC721Received(from, to, tokenId, _data),
964             'ERC721A: transfer to non ERC721Receiver implementer'
965         );
966     }
967 
968     /**
969      * @dev Returns whether `tokenId` exists.
970      *
971      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
972      *
973      * Tokens start existing when they are minted (`_mint`),
974      */
975     function _exists(uint256 tokenId) internal view returns (bool) {
976         return tokenId < currentIndex;
977     }
978 
979     function _safeMint(address to, uint256 quantity) internal {
980         _safeMint(to, quantity, '');
981     }
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` cannot be larger than the max batch size.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeMint(
994         address to,
995         uint256 quantity,
996         bytes memory _data
997     ) internal {
998         uint256 startTokenId = currentIndex;
999         require(to != address(0), 'ERC721A: mint to the zero address');
1000         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1001         require(!_exists(startTokenId), 'ERC721A: token already minted');
1002         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1003 
1004         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1005 
1006         AddressData memory addressData = _addressData[to];
1007         _addressData[to] = AddressData(
1008             addressData.balance + uint128(quantity),
1009             addressData.numberMinted + uint128(quantity)
1010         );
1011         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1012 
1013         uint256 updatedIndex = startTokenId;
1014 
1015         for (uint256 i = 0; i < quantity; i++) {
1016             emit Transfer(address(0), to, updatedIndex);
1017             require(
1018                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1019                 'ERC721A: transfer to non ERC721Receiver implementer'
1020             );
1021             updatedIndex++;
1022         }
1023 
1024         currentIndex = updatedIndex;
1025         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _transfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) private {
1043         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1044 
1045         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1046             getApproved(tokenId) == _msgSender() ||
1047             isApprovedForAll(prevOwnership.addr, _msgSender()));
1048 
1049         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1050 
1051         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1052         require(to != address(0), 'ERC721A: transfer to the zero address');
1053 
1054         _beforeTokenTransfers(from, to, tokenId, 1);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId, prevOwnership.addr);
1058 
1059         // Underflow of the sender's balance is impossible because we check for
1060         // ownership above and the recipient's balance can't realistically overflow.
1061         unchecked {
1062             _addressData[from].balance -= 1;
1063             _addressData[to].balance += 1;
1064         }
1065 
1066         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1067 
1068         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1069         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1070         uint256 nextTokenId = tokenId + 1;
1071         if (_ownerships[nextTokenId].addr == address(0)) {
1072             if (_exists(nextTokenId)) {
1073                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1074             }
1075         }
1076 
1077         emit Transfer(from, to, tokenId);
1078         _afterTokenTransfers(from, to, tokenId, 1);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits a {Approval} event.
1085      */
1086     function _approve(
1087         address to,
1088         uint256 tokenId,
1089         address owner
1090     ) private {
1091         _tokenApprovals[tokenId] = to;
1092         emit Approval(owner, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1097      * The call is not executed if the target address is not a contract.
1098      *
1099      * @param from address representing the previous owner of the given token ID
1100      * @param to target address that will receive the tokens
1101      * @param tokenId uint256 ID of the token to be transferred
1102      * @param _data bytes optional data to send along with the call
1103      * @return bool whether the call correctly returned the expected magic value
1104      */
1105     function _checkOnERC721Received(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) private returns (bool) {
1111         if (to.isContract()) {
1112             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1113                 return retval == IERC721Receiver(to).onERC721Received.selector;
1114             } catch (bytes memory reason) {
1115                 if (reason.length == 0) {
1116                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1117                 } else {
1118                     assembly {
1119                         revert(add(32, reason), mload(reason))
1120                     }
1121                 }
1122             }
1123         } else {
1124             return true;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1130      *
1131      * startTokenId - the first token id to be transferred
1132      * quantity - the amount to be transferred
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      */
1140     function _beforeTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1149      * minting.
1150      *
1151      * startTokenId - the first token id to be transferred
1152      * quantity - the amount to be transferred
1153      *
1154      * Calling conditions:
1155      *
1156      * - when `from` and `to` are both non-zero.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _afterTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 }
1166 
1167 contract KevFellaz is ERC721A, Ownable {
1168 
1169     string public baseURI = "ipfs://QmdxujyZvUe5T2iG7NjK93A2wHcXHik7ynJtU7XuQm9Jpb/";
1170     string public constant baseExtension = ".json";
1171     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1172 
1173     uint256 public constant MAX_PER_TX = 2;
1174     uint256 public constant MAX_PER_WALLET = 4;
1175     uint256 public constant MAX_SUPPLY = 778;
1176     uint256 public constant price = 0.00 ether;
1177 
1178     bool public paused = true;
1179 
1180     mapping(address => uint256) public addressMinted;
1181 
1182     constructor() ERC721A("KevFellaz", "KFELLAZ") {}
1183 
1184     function mint(uint256 _amount) external payable {
1185         address _caller = _msgSender();
1186         require(!paused, "Paused");
1187         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1188         require(_amount > 0, "No 0 mints");
1189         require(tx.origin == _caller, "No contracts");
1190         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1191         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1192         require(_amount * price == msg.value, "Invalid funds provided");
1193          addressMinted[msg.sender] += _amount;
1194         _safeMint(_caller, _amount);
1195     }
1196 
1197     function isApprovedForAll(address owner, address operator)
1198         override
1199         public
1200         view
1201         returns (bool)
1202     {
1203         // Whitelist OpenSea proxy contract for easy trading.
1204         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1205         if (address(proxyRegistry.proxies(owner)) == operator) {
1206             return true;
1207         }
1208 
1209         return super.isApprovedForAll(owner, operator);
1210     }
1211 
1212     function withdraw() external onlyOwner {
1213         uint256 balance = address(this).balance;
1214         (bool success, ) = _msgSender().call{value: balance}("");
1215         require(success, "Failed to send");
1216     }
1217 
1218     function pause(bool _state) external onlyOwner {
1219         paused = _state;
1220     }
1221 
1222     function setBaseURI(string memory baseURI_) external onlyOwner {
1223         baseURI = baseURI_;
1224     }
1225 
1226     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1227         require(_exists(_tokenId), "Token does not exist.");
1228         return bytes(baseURI).length > 0 ? string(
1229             abi.encodePacked(
1230               baseURI,
1231               Strings.toString(_tokenId),
1232               baseExtension
1233             )
1234         ) : "";
1235     }
1236 }
1237 
1238 contract OwnableDelegateProxy { }
1239 contract ProxyRegistry {
1240     mapping(address => OwnableDelegateProxy) public proxies;
1241 }