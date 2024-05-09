1 //SPDX-License-Identifier: UNLICENSED
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
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
100 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Address.sol
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         assembly {
208             size := extcodesize(account)
209         }
210         return size > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
366      * revert reason using the provided one.
367      *
368      * _Available since v4.3._
369      */
370     function verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) internal pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
394 
395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @title ERC721 token receiver interface
401  * @dev Interface for any contract that wants to support safeTransfers
402  * from ERC721 asset contracts.
403  */
404 interface IERC721Receiver {
405     /**
406      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
407      * by `operator` from `from`, this function is called.
408      *
409      * It must return its Solidity selector to confirm the token transfer.
410      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
411      *
412      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
413      */
414     function onERC721Received(
415         address operator,
416         address from,
417         uint256 tokenId,
418         bytes calldata data
419     ) external returns (bytes4);
420 }
421 
422 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Interface of the ERC165 standard, as defined in the
431  * https://eips.ethereum.org/EIPS/eip-165[EIP].
432  *
433  * Implementers can declare support of contract interfaces, which can then be
434  * queried by others ({ERC165Checker}).
435  *
436  * For an implementation, see {ERC165}.
437  */
438 interface IERC165 {
439     /**
440      * @dev Returns true if this contract implements the interface defined by
441      * `interfaceId`. See the corresponding
442      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
443      * to learn more about how these ids are created.
444      *
445      * This function call must use less than 30 000 gas.
446      */
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 }
449 
450 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
451 
452 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Implementation of the {IERC165} interface.
458  *
459  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
460  * for the additional interface id that will be supported. For example:
461  *
462  * ```solidity
463  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
464  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
465  * }
466  * ```
467  *
468  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
469  */
470 abstract contract ERC165 is IERC165 {
471     /**
472      * @dev See {IERC165-supportsInterface}.
473      */
474     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475         return interfaceId == type(IERC165).interfaceId;
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
480 
481 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Required interface of an ERC721 compliant contract.
487  */
488 interface IERC721 is IERC165 {
489     /**
490      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
501      */
502     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
503 
504     /**
505      * @dev Returns the number of tokens in ``owner``'s account.
506      */
507     function balanceOf(address owner) external view returns (uint256 balance);
508 
509     /**
510      * @dev Returns the owner of the `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function ownerOf(uint256 tokenId) external view returns (address owner);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId
536     ) external;
537 
538     /**
539      * @dev Transfers `tokenId` token from `from` to `to`.
540      *
541      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      *
550      * Emits a {Transfer} event.
551      */
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
560      * The approval is cleared when the token is transferred.
561      *
562      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
563      *
564      * Requirements:
565      *
566      * - The caller must own the token or be an approved operator.
567      * - `tokenId` must exist.
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address to, uint256 tokenId) external;
572 
573     /**
574      * @dev Returns the account approved for `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function getApproved(uint256 tokenId) external view returns (address operator);
581 
582     /**
583      * @dev Approve or remove `operator` as an operator for the caller.
584      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
585      *
586      * Requirements:
587      *
588      * - The `operator` cannot be the caller.
589      *
590      * Emits an {ApprovalForAll} event.
591      */
592     function setApprovalForAll(address operator, bool _approved) external;
593 
594     /**
595      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
596      *
597      * See {setApprovalForAll}
598      */
599     function isApprovedForAll(address owner, address operator) external view returns (bool);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId,
618         bytes calldata data
619     ) external;
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
631  * @dev See https://eips.ethereum.org/EIPS/eip-721
632  */
633 interface IERC721Metadata is IERC721 {
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() external view returns (string memory);
638 
639     /**
640      * @dev Returns the token collection symbol.
641      */
642     function symbol() external view returns (string memory);
643 
644     /**
645      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
646      */
647     function tokenURI(uint256 tokenId) external view returns (string memory);
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
651 
652 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension, but not including the Enumerable extension, which is available separately as
659  * {ERC721Enumerable}.
660  */
661 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
662     using Address for address;
663     using Strings for uint256;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to owner address
672     mapping(uint256 => address) private _owners;
673 
674     // Mapping owner address to token count
675     mapping(address => uint256) private _balances;
676 
677     // Mapping from token ID to approved address
678     mapping(uint256 => address) private _tokenApprovals;
679 
680     // Mapping from owner to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     /**
684      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
685      */
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689     }
690 
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
695         return
696             interfaceId == type(IERC721).interfaceId ||
697             interfaceId == type(IERC721Metadata).interfaceId ||
698             super.supportsInterface(interfaceId);
699     }
700 
701     /**
702      * @dev See {IERC721-balanceOf}.
703      */
704     function balanceOf(address owner) public view virtual override returns (uint256) {
705         require(owner != address(0), "ERC721: balance query for the zero address");
706         return _balances[owner];
707     }
708 
709     /**
710      * @dev See {IERC721-ownerOf}.
711      */
712     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
713         address owner = _owners[tokenId];
714         require(owner != address(0), "ERC721: owner query for nonexistent token");
715         return owner;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-name}.
720      */
721     function name() public view virtual override returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-symbol}.
727      */
728     function symbol() public view virtual override returns (string memory) {
729         return _symbol;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-tokenURI}.
734      */
735     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
736         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
737 
738         string memory baseURI = _baseURI();
739         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
740     }
741 
742     /**
743      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
744      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
745      * by default, can be overriden in child contracts.
746      */
747     function _baseURI() internal view virtual returns (string memory) {
748         return "";
749     }
750 
751     /**
752      * @dev See {IERC721-approve}.
753      */
754     function approve(address to, uint256 tokenId) public virtual override {
755         address owner = ERC721.ownerOf(tokenId);
756         require(to != owner, "ERC721: approval to current owner");
757 
758         require(
759             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
760             "ERC721: approve caller is not owner nor approved for all"
761         );
762 
763         _approve(to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-getApproved}.
768      */
769     function getApproved(uint256 tokenId) public view virtual override returns (address) {
770         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
771 
772         return _tokenApprovals[tokenId];
773     }
774 
775     /**
776      * @dev See {IERC721-setApprovalForAll}.
777      */
778     function setApprovalForAll(address operator, bool approved) public virtual override {
779         _setApprovalForAll(_msgSender(), operator, approved);
780     }
781 
782     /**
783      * @dev See {IERC721-isApprovedForAll}.
784      */
785     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
786         return _operatorApprovals[owner][operator];
787     }
788 
789     /**
790      * @dev See {IERC721-transferFrom}.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) public virtual override {
797         //solhint-disable-next-line max-line-length
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799 
800         _transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         safeTransferFrom(from, to, tokenId, "");
812     }
813 
814     /**
815      * @dev See {IERC721-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) public virtual override {
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824         _safeTransfer(from, to, tokenId, _data);
825     }
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
832      *
833      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
834      * implement alternative mechanisms to perform token transfer, such as signature-based.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must exist and be owned by `from`.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeTransfer(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _transfer(from, to, tokenId);
852         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      * and stop existing when they are burned (`_burn`).
862      */
863     function _exists(uint256 tokenId) internal view virtual returns (bool) {
864         return _owners[tokenId] != address(0);
865     }
866 
867     /**
868      * @dev Returns whether `spender` is allowed to manage `tokenId`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
875         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
876         address owner = ERC721.ownerOf(tokenId);
877         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
878     }
879 
880     /**
881      * @dev Safely mints `tokenId` and transfers it to `to`.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeMint(address to, uint256 tokenId) internal virtual {
891         _safeMint(to, tokenId, "");
892     }
893 
894     /**
895      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
896      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
897      */
898     function _safeMint(
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _mint(to, tokenId);
904         require(
905             _checkOnERC721Received(address(0), to, tokenId, _data),
906             "ERC721: transfer to non ERC721Receiver implementer"
907         );
908     }
909 
910     /**
911      * @dev Mints `tokenId` and transfers it to `to`.
912      *
913      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - `to` cannot be the zero address.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _mint(address to, uint256 tokenId) internal virtual {
923         require(to != address(0), "ERC721: mint to the zero address");
924         require(!_exists(tokenId), "ERC721: token already minted");
925 
926         _beforeTokenTransfer(address(0), to, tokenId);
927 
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(address(0), to, tokenId);
932     }
933 
934     /**
935      * @dev Destroys `tokenId`.
936      * The approval is cleared when the token is burned.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _burn(uint256 tokenId) internal virtual {
945         address owner = ERC721.ownerOf(tokenId);
946 
947         _beforeTokenTransfer(owner, address(0), tokenId);
948 
949         // Clear approvals
950         _approve(address(0), tokenId);
951 
952         _balances[owner] -= 1;
953         delete _owners[tokenId];
954 
955         emit Transfer(owner, address(0), tokenId);
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must be owned by `from`.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _transfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {
974         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
975         require(to != address(0), "ERC721: transfer to the zero address");
976 
977         _beforeTokenTransfer(from, to, tokenId);
978 
979         // Clear approvals from the previous owner
980         _approve(address(0), tokenId);
981 
982         _balances[from] -= 1;
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(from, to, tokenId);
987     }
988 
989     /**
990      * @dev Approve `to` to operate on `tokenId`
991      *
992      * Emits a {Approval} event.
993      */
994     function _approve(address to, uint256 tokenId) internal virtual {
995         _tokenApprovals[tokenId] = to;
996         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
997     }
998 
999     /**
1000      * @dev Approve `operator` to operate on all of `owner` tokens
1001      *
1002      * Emits a {ApprovalForAll} event.
1003      */
1004     function _setApprovalForAll(
1005         address owner,
1006         address operator,
1007         bool approved
1008     ) internal virtual {
1009         require(owner != operator, "ERC721: approve to caller");
1010         _operatorApprovals[owner][operator] = approved;
1011         emit ApprovalForAll(owner, operator, approved);
1012     }
1013 
1014     /**
1015      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1016      * The call is not executed if the target address is not a contract.
1017      *
1018      * @param from address representing the previous owner of the given token ID
1019      * @param to target address that will receive the tokens
1020      * @param tokenId uint256 ID of the token to be transferred
1021      * @param _data bytes optional data to send along with the call
1022      * @return bool whether the call correctly returned the expected magic value
1023      */
1024     function _checkOnERC721Received(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) private returns (bool) {
1030         if (to.isContract()) {
1031             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1032                 return retval == IERC721Receiver.onERC721Received.selector;
1033             } catch (bytes memory reason) {
1034                 if (reason.length == 0) {
1035                     revert("ERC721: transfer to non ERC721Receiver implementer");
1036                 } else {
1037                     assembly {
1038                         revert(add(32, reason), mload(reason))
1039                     }
1040                 }
1041             }
1042         } else {
1043             return true;
1044         }
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before any token transfer. This includes minting
1049      * and burning.
1050      *
1051      * Calling conditions:
1052      *
1053      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1054      * transferred to `to`.
1055      * - When `from` is zero, `tokenId` will be minted for `to`.
1056      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1057      * - `from` and `to` are never both zero.
1058      *
1059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1060      */
1061     function _beforeTokenTransfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) internal virtual {}
1066 }
1067 
1068 interface IRender {
1069     function tokenURI(uint256 tokenId) external view returns (string memory);
1070 }
1071 
1072 contract EtherPlant is ERC721, Ownable {
1073 
1074     uint256 public maxToken = 721;
1075     uint256 public totalSupply = 0;
1076     uint256 public salePrice = 0.0721 ether;
1077     bool public paused;
1078     mapping(address => uint256) private minted;
1079 
1080     IRender public render;
1081 
1082     mapping(uint256 => uint256) public tokenSeed;
1083     mapping(uint256 => uint256) public watertime;
1084     mapping(uint256 => uint256) public lastwatertime;
1085     
1086     constructor () ERC721 ("EtherPlant","ETHPLNT")  {}
1087 
1088     function mintGift(address _address) public onlyOwner {
1089         require((totalSupply + 1) <= maxToken, "No more NFTs");
1090 
1091         totalSupply++;
1092         tokenSeed[totalSupply] = uint256(keccak256(abi.encodePacked(block.timestamp, _address, totalSupply)));
1093         _mint(_address, totalSupply);
1094     }
1095 
1096     function mintSeed() public payable onlySender {
1097         require(paused, "Sale paused");
1098         require((totalSupply + 1) <= maxToken, "No more NFTs");
1099         require(msg.value >= salePrice, "Value sent is not correct");
1100         require(minted[msg.sender] == 0, "You have no mint left");
1101 
1102         minted[msg.sender]++;
1103         totalSupply++;
1104         tokenSeed[totalSupply] = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, totalSupply)));
1105         _mint(msg.sender, totalSupply);
1106     }
1107 
1108     function waterPlant (uint256 tokenId) external {
1109         require(watertime[tokenId] == 0 || block.timestamp - lastwatertime[tokenId] > 7 days, "only once a week");
1110         require(watertime[tokenId] == 0 || block.timestamp - lastwatertime[tokenId] < 14 days, "dead! Not growing anmore");
1111         require(msg.sender == ownerOf(tokenId), "only owner can grow the plant");
1112         require(watertime[tokenId] < 10, "this plant fully grown");     
1113 
1114         lastwatertime[tokenId] = block.timestamp;
1115         watertime[tokenId]++;
1116     } 
1117 
1118     function setRender(address _address) external onlyOwner {
1119         render = IRender(_address);
1120     }
1121 
1122     function setSale() public onlyOwner {
1123         paused = !paused;
1124     }
1125 
1126     function getTokenSeed(uint256 tokenId) external view returns (uint256) {
1127         return tokenSeed[tokenId];
1128     }
1129 
1130     function getTime(uint256 tokenId) external view returns (uint256) {
1131         return lastwatertime[tokenId];
1132     }
1133 
1134     function getPhase(uint256 tokenId) external view returns (uint256) {
1135         return watertime[tokenId];
1136     } 
1137     
1138     function sendEthAll() external onlyOwner {
1139         sendEth(0xb65296acc3685e87A9c3262f04Bb60EA31a34d67, address(this).balance);
1140     }
1141 
1142     function sendEth(address to, uint amount) internal {
1143         (bool success,) = to.call{value: amount}("");
1144         require(success, "Failed to send ether");
1145     }
1146 
1147     modifier onlySender() {
1148         require(msg.sender == tx.origin, "only sender");
1149         _;
1150     }
1151 
1152     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1153         require(_exists(tokenId), "Plant not found");
1154         return render.tokenURI(tokenId);
1155     }
1156 }