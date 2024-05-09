1 // SPDX-License-Identifier: MIT
2 
3 //**  LOOBR NFT Contract */
4 //** Author Ishanshahzad: LooBr Marketplace Contract 2022.6 */
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
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
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
107 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Interface of the ERC165 standard, as defined in the
116  * https://eips.ethereum.org/EIPS/eip-165[EIP].
117  *
118  * Implementers can declare support of contract interfaces, which can then be
119  * queried by others ({ERC165Checker}).
120  *
121  * For an implementation, see {ERC165}.
122  */
123 interface IERC165 {
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30 000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 }
134 
135 
136 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Required interface of an ERC721 compliant contract.
145  */
146 interface IERC721 is IERC165 {
147     /**
148      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
154      */
155     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
156 
157     /**
158      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
159      */
160     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
161 
162     /**
163      * @dev Returns the number of tokens in ``owner``'s account.
164      */
165     function balanceOf(address owner) external view returns (uint256 balance);
166 
167     /**
168      * @dev Returns the owner of the `tokenId` token.
169      *
170      * Requirements:
171      *
172      * - `tokenId` must exist.
173      */
174     function ownerOf(uint256 tokenId) external view returns (address owner);
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
178      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` token from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must exist and be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId,
276         bytes calldata data
277     ) external;
278 }
279 
280 
281 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @title ERC721 token receiver interface
290  * @dev Interface for any contract that wants to support safeTransfers
291  * from ERC721 asset contracts.
292  */
293 interface IERC721Receiver {
294     /**
295      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
296      * by `operator` from `from`, this function is called.
297      *
298      * It must return its Solidity selector to confirm the token transfer.
299      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
300      *
301      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
302      */
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 
312 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
321  * @dev See https://eips.ethereum.org/EIPS/eip-721
322  */
323 interface IERC721Metadata is IERC721 {
324     /**
325      * @dev Returns the token collection name.
326      */
327     function name() external view returns (string memory);
328 
329     /**
330      * @dev Returns the token collection symbol.
331      */
332     function symbol() external view returns (string memory);
333 
334     /**
335      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
336      */
337     function tokenURI(uint256 tokenId) external view returns (string memory);
338 }
339 
340 
341 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
342 
343 
344 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
345 
346 pragma solidity ^0.8.1;
347 
348 /**
349  * @dev Collection of functions related to the address type
350  */
351 library Address {
352     /**
353      * @dev Returns true if `account` is a contract.
354      *
355      * [IMPORTANT]
356      * ====
357      * It is unsafe to assume that an address for which this function returns
358      * false is an externally-owned account (EOA) and not a contract.
359      *
360      * Among others, `isContract` will return false for the following
361      * types of addresses:
362      *
363      *  - an externally-owned account
364      *  - a contract in construction
365      *  - an address where a contract will be created
366      *  - an address where a contract lived, but was destroyed
367      * ====
368      *
369      * [IMPORTANT]
370      * ====
371      * You shouldn't rely on `isContract` to protect against flash loan attacks!
372      *
373      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
374      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
375      * constructor.
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // This method relies on extcodesize/address.code.length, which returns 0
380         // for contracts in construction, since the code is only stored at the end
381         // of the constructor execution.
382 
383         return account.code.length > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain `call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but also transferring `value` wei to `target`.
448      *
449      * Requirements:
450      *
451      * - the calling contract must have an ETH balance of at least `value`.
452      * - the called Solidity function must be `payable`.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 
567 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev String operations.
576  */
577 library Strings {
578     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
582      */
583     function toString(uint256 value) internal pure returns (string memory) {
584         // Inspired by OraclizeAPI's implementation - MIT licence
585         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
586 
587         if (value == 0) {
588             return "0";
589         }
590         uint256 temp = value;
591         uint256 digits;
592         while (temp != 0) {
593             digits++;
594             temp /= 10;
595         }
596         bytes memory buffer = new bytes(digits);
597         while (value != 0) {
598             digits -= 1;
599             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
600             value /= 10;
601         }
602         return string(buffer);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
607      */
608     function toHexString(uint256 value) internal pure returns (string memory) {
609         if (value == 0) {
610             return "0x00";
611         }
612         uint256 temp = value;
613         uint256 length = 0;
614         while (temp != 0) {
615             length++;
616             temp >>= 8;
617         }
618         return toHexString(value, length);
619     }
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
623      */
624     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
625         bytes memory buffer = new bytes(2 * length + 2);
626         buffer[0] = "0";
627         buffer[1] = "x";
628         for (uint256 i = 2 * length + 1; i > 1; --i) {
629             buffer[i] = _HEX_SYMBOLS[value & 0xf];
630             value >>= 4;
631         }
632         require(value == 0, "Strings: hex length insufficient");
633         return string(buffer);
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Implementation of the {IERC165} interface.
647  *
648  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
649  * for the additional interface id that will be supported. For example:
650  *
651  * ```solidity
652  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
654  * }
655  * ```
656  *
657  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
658  */
659 abstract contract ERC165 is IERC165 {
660     /**
661      * @dev See {IERC165-supportsInterface}.
662      */
663     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664         return interfaceId == type(IERC165).interfaceId;
665     }
666 }
667 
668 
669 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
670 
671 
672 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 
678 
679 
680 
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension, but not including the Enumerable extension, which is available separately as
685  * {ERC721Enumerable}.
686  */
687 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to owner address
698     mapping(uint256 => address) private _owners;
699 
700     // Mapping owner address to token count
701     mapping(address => uint256) private _balances;
702 
703     // Mapping from token ID to approved address
704     mapping(uint256 => address) private _tokenApprovals;
705 
706     // Mapping from owner to operator approvals
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     /**
710      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view virtual override returns (uint256) {
731         require(owner != address(0), "ERC721: balance query for the zero address");
732         return _balances[owner];
733     }
734 
735     /**
736      * @dev See {IERC721-ownerOf}.
737      */
738     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
739         address owner = _owners[tokenId];
740         require(owner != address(0), "ERC721: owner query for nonexistent token");
741         return owner;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-name}.
746      */
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-symbol}.
753      */
754     function symbol() public view virtual override returns (string memory) {
755         return _symbol;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-tokenURI}.
760      */
761     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
762         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
763 
764         string memory baseURI = _baseURI();
765         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
766     }
767 
768     /**
769      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
770      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
771      * by default, can be overriden in child contracts.
772      */
773     function _baseURI() internal view virtual returns (string memory) {
774         return "";
775     }
776 
777     /**
778      * @dev See {IERC721-approve}.
779      */
780     function approve(address to, uint256 tokenId) public virtual override {
781         address owner = ERC721.ownerOf(tokenId);
782         require(to != owner, "ERC721: approval to current owner");
783 
784         require(
785             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
786             "ERC721: approve caller is not owner nor approved for all"
787         );
788 
789         _approve(to, tokenId);
790     }
791 
792     /**
793      * @dev See {IERC721-getApproved}.
794      */
795     function getApproved(uint256 tokenId) public view virtual override returns (address) {
796         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
797 
798         return _tokenApprovals[tokenId];
799     }
800 
801     /**
802      * @dev See {IERC721-setApprovalForAll}.
803      */
804     function setApprovalForAll(address operator, bool approved) public virtual override {
805         _setApprovalForAll(_msgSender(), operator, approved);
806     }
807 
808     /**
809      * @dev See {IERC721-isApprovedForAll}.
810      */
811     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
812         return _operatorApprovals[owner][operator];
813     }
814 
815     /**
816      * @dev See {IERC721-transferFrom}.
817      */
818     function transferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         //solhint-disable-next-line max-line-length
824         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
825 
826         _transfer(from, to, tokenId);
827     }
828 
829     /**
830      * @dev See {IERC721-safeTransferFrom}.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         safeTransferFrom(from, to, tokenId, "");
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) public virtual override {
849         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
850         _safeTransfer(from, to, tokenId, _data);
851     }
852 
853     /**
854      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
855      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
856      *
857      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
858      *
859      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
860      * implement alternative mechanisms to perform token transfer, such as signature-based.
861      *
862      * Requirements:
863      *
864      * - `from` cannot be the zero address.
865      * - `to` cannot be the zero address.
866      * - `tokenId` token must exist and be owned by `from`.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _safeTransfer(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) internal virtual {
877         _transfer(from, to, tokenId);
878         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
879     }
880 
881     /**
882      * @dev Returns whether `tokenId` exists.
883      *
884      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
885      *
886      * Tokens start existing when they are minted (`_mint`),
887      * and stop existing when they are burned (`_burn`).
888      */
889     function _exists(uint256 tokenId) internal view virtual returns (bool) {
890         return _owners[tokenId] != address(0);
891     }
892 
893     /**
894      * @dev Returns whether `spender` is allowed to manage `tokenId`.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      */
900     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
901         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
902         address owner = ERC721.ownerOf(tokenId);
903         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
904     }
905 
906     /**
907      * @dev Safely mints `tokenId` and transfers it to `to`.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must not exist.
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _safeMint(address to, uint256 tokenId) internal virtual {
917         _safeMint(to, tokenId, "");
918     }
919 
920     /**
921      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
922      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
923      */
924     function _safeMint(
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) internal virtual {
929         _mint(to, tokenId);
930         require(
931             _checkOnERC721Received(address(0), to, tokenId, _data),
932             "ERC721: transfer to non ERC721Receiver implementer"
933         );
934     }
935 
936     /**
937      * @dev Mints `tokenId` and transfers it to `to`.
938      *
939      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - `to` cannot be the zero address.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _mint(address to, uint256 tokenId) internal virtual {
949         require(to != address(0), "ERC721: mint to the zero address");
950         require(!_exists(tokenId), "ERC721: token already minted");
951 
952         _beforeTokenTransfer(address(0), to, tokenId);
953 
954         _balances[to] += 1;
955         _owners[tokenId] = to;
956 
957         emit Transfer(address(0), to, tokenId);
958 
959         _afterTokenTransfer(address(0), to, tokenId);
960     }
961 
962     /**
963      * @dev Destroys `tokenId`.
964      * The approval is cleared when the token is burned.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must exist.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _burn(uint256 tokenId) internal virtual {
973         address owner = ERC721.ownerOf(tokenId);
974 
975         _beforeTokenTransfer(owner, address(0), tokenId);
976 
977         // Clear approvals
978         _approve(address(0), tokenId);
979 
980         _balances[owner] -= 1;
981         delete _owners[tokenId];
982 
983         emit Transfer(owner, address(0), tokenId);
984 
985         _afterTokenTransfer(owner, address(0), tokenId);
986     }
987 
988     /**
989      * @dev Transfers `tokenId` from `from` to `to`.
990      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `tokenId` token must be owned by `from`.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _transfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {
1004         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1005         require(to != address(0), "ERC721: transfer to the zero address");
1006 
1007         _beforeTokenTransfer(from, to, tokenId);
1008 
1009         // Clear approvals from the previous owner
1010         _approve(address(0), tokenId);
1011 
1012         _balances[from] -= 1;
1013         _balances[to] += 1;
1014         _owners[tokenId] = to;
1015 
1016         emit Transfer(from, to, tokenId);
1017 
1018         _afterTokenTransfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Approve `operator` to operate on all of `owner` tokens
1033      *
1034      * Emits a {ApprovalForAll} event.
1035      */
1036     function _setApprovalForAll(
1037         address owner,
1038         address operator,
1039         bool approved
1040     ) internal virtual {
1041         require(owner != operator, "ERC721: approve to caller");
1042         _operatorApprovals[owner][operator] = approved;
1043         emit ApprovalForAll(owner, operator, approved);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver.onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after any transfer of tokens. This includes
1101      * minting and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero.
1106      * - `from` and `to` are never both zero.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _afterTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {}
1115 }
1116 
1117 
1118 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1119 
1120 
1121 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 /**
1126  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1127  * @dev See https://eips.ethereum.org/EIPS/eip-721
1128  */
1129 interface IERC721Enumerable is IERC721 {
1130     /**
1131      * @dev Returns the total amount of tokens stored by the contract.
1132      */
1133     function totalSupply() external view returns (uint256);
1134 
1135     /**
1136      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1137      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1138      */
1139     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1143      * Use along with {totalSupply} to enumerate all tokens.
1144      */
1145     function tokenByIndex(uint256 index) external view returns (uint256);
1146 }
1147 
1148 
1149 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.5.0
1150 
1151 
1152 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 
1157 /**
1158  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1159  * enumerability of all the token ids in the contract as well as all token ids owned by each
1160  * account.
1161  */
1162 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1163     // Mapping from owner to list of owned token IDs
1164     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1165 
1166     // Mapping from token ID to index of the owner tokens list
1167     mapping(uint256 => uint256) private _ownedTokensIndex;
1168 
1169     // Array with all token ids, used for enumeration
1170     uint256[] private _allTokens;
1171 
1172     // Mapping from token id to position in the allTokens array
1173     mapping(uint256 => uint256) private _allTokensIndex;
1174 
1175     /**
1176      * @dev See {IERC165-supportsInterface}.
1177      */
1178     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1179         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1184      */
1185     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1186         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1187         return _ownedTokens[owner][index];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Enumerable-totalSupply}.
1192      */
1193     function totalSupply() public view virtual override returns (uint256) {
1194         return _allTokens.length;
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-tokenByIndex}.
1199      */
1200     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1201         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1202         return _allTokens[index];
1203     }
1204 
1205     /**
1206      * @dev Hook that is called before any token transfer. This includes minting
1207      * and burning.
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1215      * - `from` cannot be the zero address.
1216      * - `to` cannot be the zero address.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual override {
1225         super._beforeTokenTransfer(from, to, tokenId);
1226 
1227         if (from == address(0)) {
1228             _addTokenToAllTokensEnumeration(tokenId);
1229         } else if (from != to) {
1230             _removeTokenFromOwnerEnumeration(from, tokenId);
1231         }
1232         if (to == address(0)) {
1233             _removeTokenFromAllTokensEnumeration(tokenId);
1234         } else if (to != from) {
1235             _addTokenToOwnerEnumeration(to, tokenId);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1241      * @param to address representing the new owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1243      */
1244     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1245         uint256 length = ERC721.balanceOf(to);
1246         _ownedTokens[to][length] = tokenId;
1247         _ownedTokensIndex[tokenId] = length;
1248     }
1249 
1250     /**
1251      * @dev Private function to add a token to this extension's token tracking data structures.
1252      * @param tokenId uint256 ID of the token to be added to the tokens list
1253      */
1254     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1255         _allTokensIndex[tokenId] = _allTokens.length;
1256         _allTokens.push(tokenId);
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1261      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1262      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1263      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1264      * @param from address representing the previous owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1266      */
1267     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1268         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1269         // then delete the last slot (swap and pop).
1270 
1271         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1272         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1273 
1274         // When the token to delete is the last token, the swap operation is unnecessary
1275         if (tokenIndex != lastTokenIndex) {
1276             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1277 
1278             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1279             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1280         }
1281 
1282         // This also deletes the contents at the last position of the array
1283         delete _ownedTokensIndex[tokenId];
1284         delete _ownedTokens[from][lastTokenIndex];
1285     }
1286 
1287     /**
1288      * @dev Private function to remove a token from this extension's token tracking data structures.
1289      * This has O(1) time complexity, but alters the order of the _allTokens array.
1290      * @param tokenId uint256 ID of the token to be removed from the tokens list
1291      */
1292     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1293         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1294         // then delete the last slot (swap and pop).
1295 
1296         uint256 lastTokenIndex = _allTokens.length - 1;
1297         uint256 tokenIndex = _allTokensIndex[tokenId];
1298 
1299         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1300         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1301         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1302         uint256 lastTokenId = _allTokens[lastTokenIndex];
1303 
1304         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1305         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1306 
1307         // This also deletes the contents at the last position of the array
1308         delete _allTokensIndex[tokenId];
1309         _allTokens.pop();
1310     }
1311 }
1312 
1313 
1314 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.5.0
1315 
1316 
1317 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 /**
1322  * @dev ERC721 token with storage based token URI management.
1323  */
1324 abstract contract ERC721URIStorage is ERC721 {
1325     using Strings for uint256;
1326 
1327     // Optional mapping for token URIs
1328     mapping(uint256 => string) private _tokenURIs;
1329 
1330     /**
1331      * @dev See {IERC721Metadata-tokenURI}.
1332      */
1333     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1334         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1335 
1336         string memory _tokenURI = _tokenURIs[tokenId];
1337         string memory base = _baseURI();
1338 
1339         // If there is no base URI, return the token URI.
1340         if (bytes(base).length == 0) {
1341             return _tokenURI;
1342         }
1343         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1344         if (bytes(_tokenURI).length > 0) {
1345             return string(abi.encodePacked(base, _tokenURI));
1346         }
1347 
1348         return super.tokenURI(tokenId);
1349     }
1350 
1351     /**
1352      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      */
1358     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1359         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1360         _tokenURIs[tokenId] = _tokenURI;
1361     }
1362 
1363     /**
1364      * @dev Destroys `tokenId`.
1365      * The approval is cleared when the token is burned.
1366      *
1367      * Requirements:
1368      *
1369      * - `tokenId` must exist.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _burn(uint256 tokenId) internal virtual override {
1374         super._burn(tokenId);
1375 
1376         if (bytes(_tokenURIs[tokenId]).length != 0) {
1377             delete _tokenURIs[tokenId];
1378         }
1379     }
1380 }
1381 
1382 
1383 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
1384 
1385 
1386 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1387 
1388 pragma solidity ^0.8.0;
1389 
1390 /**
1391  * @dev Interface of the ERC20 standard as defined in the EIP.
1392  */
1393 interface IERC20 {
1394     /**
1395      * @dev Returns the amount of tokens in existence.
1396      */
1397     function totalSupply() external view returns (uint256);
1398 
1399     /**
1400      * @dev Returns the amount of tokens owned by `account`.
1401      */
1402     function balanceOf(address account) external view returns (uint256);
1403 
1404     /**
1405      * @dev Moves `amount` tokens from the caller's account to `to`.
1406      *
1407      * Returns a boolean value indicating whether the operation succeeded.
1408      *
1409      * Emits a {Transfer} event.
1410      */
1411     function transfer(address to, uint256 amount) external returns (bool);
1412 
1413     /**
1414      * @dev Returns the remaining number of tokens that `spender` will be
1415      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1416      * zero by default.
1417      *
1418      * This value changes when {approve} or {transferFrom} are called.
1419      */
1420     function allowance(address owner, address spender) external view returns (uint256);
1421 
1422     /**
1423      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1424      *
1425      * Returns a boolean value indicating whether the operation succeeded.
1426      *
1427      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1428      * that someone may use both the old and the new allowance by unfortunate
1429      * transaction ordering. One possible solution to mitigate this race
1430      * condition is to first reduce the spender's allowance to 0 and set the
1431      * desired value afterwards:
1432      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1433      *
1434      * Emits an {Approval} event.
1435      */
1436     function approve(address spender, uint256 amount) external returns (bool);
1437 
1438     /**
1439      * @dev Moves `amount` tokens from `from` to `to` using the
1440      * allowance mechanism. `amount` is then deducted from the caller's
1441      * allowance.
1442      *
1443      * Returns a boolean value indicating whether the operation succeeded.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function transferFrom(
1448         address from,
1449         address to,
1450         uint256 amount
1451     ) external returns (bool);
1452 
1453     /**
1454      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1455      * another (`to`).
1456      *
1457      * Note that `value` may be zero.
1458      */
1459     event Transfer(address indexed from, address indexed to, uint256 value);
1460 
1461     /**
1462      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1463      * a call to {approve}. `value` is the new allowance.
1464      */
1465     event Approval(address indexed owner, address indexed spender, uint256 value);
1466 }
1467 
1468 
1469 // File @openzeppelin/contracts/interfaces/IERC165.sol@v4.5.0
1470 
1471 
1472 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1473 
1474 pragma solidity ^0.8.0;
1475 
1476 
1477 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.5.0
1478 
1479 
1480 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1481 
1482 pragma solidity ^0.8.0;
1483 
1484 /**
1485  * @dev Interface for the NFT Royalty Standard.
1486  *
1487  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1488  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1489  *
1490  * _Available since v4.5._
1491  */
1492 interface IERC2981 is IERC165 {
1493     /**
1494      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1495      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1496      */
1497     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1498         external
1499         view
1500         returns (address receiver, uint256 royaltyAmount);
1501 }
1502 
1503 
1504 // File contracts/interfaces/IMRNFT.sol
1505 
1506 
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 interface IMRNFT {
1511     function mint(address _to, string memory uri) external;
1512 }
1513 
1514 
1515 // File contracts/LoobrNFT.sol
1516 
1517 
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 
1522 
1523 
1524 
1525 
1526 
1527 contract LNFT is IMRNFT, ERC721Enumerable, ERC721URIStorage, IERC2981, Ownable {
1528     using Strings for uint256;
1529     // MAX supply of collection
1530     uint256 public maxSupply;
1531 
1532     // creators
1533     mapping(uint256 => address) public creators;
1534 
1535     struct RoyaltyInfo {
1536         address receiver; // The payment receiver of royalty
1537         uint16 rate; // The rate of the payment
1538     }
1539 
1540     // royalties
1541     mapping(uint256 => RoyaltyInfo) private royalties;
1542 
1543     // MAX royalty percent
1544     uint16 public constant MAX_ROYALTY = 2000;
1545 
1546     event Minted(address indexed minter, address indexed to, string uri, uint256 tokenId);
1547 
1548     event AdminMinted(uint256 qty, address indexed to);
1549 
1550     event SetRoyalty(uint256 tokenId, address receiver, uint256 rate);
1551 
1552     event SetMaxSupply(uint256 maxSupply);
1553     event MultiMinted(
1554         address indexed minter,
1555         address indexed to,
1556         uint256[] tokenIds,
1557         string[] URIs
1558     );
1559     /**
1560      * @dev Mapping of interface ids to whether or not it's supported.
1561      */
1562     mapping(bytes4 => bool) private _supportedInterfaces;
1563 
1564     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1565 
1566     constructor(address _owner) ERC721("LooBrNFT", "LooBrNFT")  {
1567         require(_owner != address(0), "Invalid owner address");
1568         _transferOwnership(_owner);
1569 
1570         _registerInterface(_INTERFACE_ID_ERC2981);
1571 
1572         maxSupply = 10000;
1573     }
1574 
1575     /**
1576      * @dev Registers the contract as an implementer of the interface defined by
1577      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1578      * registering its interface id is not required.
1579      *
1580      * See {IERC165-supportsInterface}.
1581      *
1582      * Requirements:
1583      *
1584      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1585      */
1586     function _registerInterface(bytes4 interfaceId) internal virtual {
1587         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1588         _supportedInterfaces[interfaceId] = true;
1589     }
1590 
1591     /**
1592      * @dev See {IERC165-supportsInterface}.
1593      */
1594     function supportsInterface(bytes4 interfaceId)
1595         public
1596         view
1597         virtual
1598         override(ERC721,ERC721Enumerable, IERC165)
1599         returns (bool)
1600     {
1601         return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
1602     }
1603 
1604     /**************************
1605      ***** MINT FUNCTIONS *****
1606      *************************/
1607     function mint(address _to, string memory uri) override external  {
1608         require(totalSupply() + 1 <= maxSupply, "NFT: out of stock");
1609         require(_to != address(0), "NFT: invalid address");
1610         // Using tokenId in the loop instead of totalSupply() + 1,
1611         // because totalSupply() changed after _safeMint function call.
1612         uint256 tokenId = totalSupply() + 1;
1613         _safeMint(_to, tokenId);
1614         _setTokenURI(tokenId, uri);
1615         if (msg.sender == tx.origin) {
1616             creators[tokenId] = msg.sender;
1617         } else {
1618             creators[tokenId] = address(0);
1619         }
1620 
1621         emit Minted(msg.sender, _to, uri, tokenId);
1622     }
1623 
1624      function multiMint(string[] calldata URIs, address _to) external  {
1625         require(URIs.length > 0, "NFT: minitum 1 nft");
1626         require(_to != address(0), "NFT: invalid address");
1627         require(totalSupply() + URIs.length <= maxSupply, "NFT: max supply reached");
1628         uint256[] memory tokenIds = new uint256[](URIs.length);
1629         for (uint256 i = 0; i < URIs.length; i++) {
1630             uint256 tokenId = totalSupply() + 1;
1631             _safeMint(_to, tokenId);
1632             _setTokenURI(tokenId, URIs[i]);
1633             tokenIds[i] = tokenId;
1634             if (msg.sender == tx.origin) {
1635             creators[tokenId] = msg.sender;
1636             } else {
1637             creators[tokenId] = address(0);
1638             }
1639             emit Minted(msg.sender, _to, URIs[i], tokenId);
1640         }
1641 
1642         emit MultiMinted(msg.sender, _to, tokenIds, URIs);
1643     }
1644 
1645     function tokenURI(uint256 tokenId)
1646         public
1647         view
1648         override(ERC721, ERC721URIStorage)
1649         returns (string memory)
1650     {
1651         return super.tokenURI(tokenId);
1652     }
1653 
1654     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1655         uint256 balance = balanceOf(_owner);
1656         uint256[] memory ids = new uint256[](balance);
1657         for (uint256 i = 0; i < balance; i++) {
1658             ids[i] = tokenOfOwnerByIndex(_owner, i);
1659         }
1660         return ids;
1661     }
1662 
1663     function exists(uint256 _id) external view returns (bool) {
1664         return _exists(_id);
1665     }
1666 
1667 
1668     function clearStuckTokens(IERC20 erc20) external onlyOwner {
1669         uint256 balance = erc20.balanceOf(address(this));
1670         erc20.transfer(msg.sender, balance);
1671     }
1672 
1673     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1674         external
1675         view
1676         override
1677         returns (address receiver, uint256 royaltyAmount)
1678     {
1679         receiver = royalties[_tokenId].receiver;
1680         if (royalties[_tokenId].rate > 0 && royalties[_tokenId].receiver != address(0)) {
1681             royaltyAmount = (_salePrice * royalties[_tokenId].rate) / 10000;
1682         }
1683     }
1684     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1685         internal
1686         override(ERC721, ERC721Enumerable)
1687     {
1688         super._beforeTokenTransfer(from, to, tokenId);
1689     }
1690     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1691         super._burn(tokenId);
1692     }
1693 
1694     function setRoyalty(
1695         uint256 _tokenId,
1696         address _receiver,
1697         uint16 _royalty
1698     ) external {
1699         require(creators[_tokenId] == msg.sender, "NFT: Invalid creator");
1700         require(creators[_tokenId] == ownerOf(_tokenId), "NFT: Cannot set royalty after transfer");
1701         require(_receiver != address(0), "NFT: invalid royalty receiver");
1702         require(_royalty <= MAX_ROYALTY, "NFT: Invalid royalty percentage");
1703 
1704         royalties[_tokenId].receiver = _receiver;
1705         royalties[_tokenId].rate = _royalty;
1706 
1707         emit SetRoyalty(_tokenId, _receiver, _royalty);
1708     }
1709 
1710     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1711         require(_maxSupply > maxSupply, "The max supply should larger than current value");
1712         maxSupply = _maxSupply;
1713 
1714         emit SetMaxSupply(_maxSupply);
1715     }
1716 }